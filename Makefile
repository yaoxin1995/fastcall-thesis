######################################################################
# This Makefile is part of a skeleton (diploma) thesis.  If you have
# useful additions or suggestions, please feel free to contact me:
# Martin Unzner <munzner@os.inf.tu-dresden.de>
# or alternatively
# Julian Stecklina <jsteckli@os.inf.tu-dresden.de>
######################################################################

# your main document
DOC_TEX      = diplom.tex

# your sub documents (chapters)
DOC_TEX_ADD ?= preamble/packages.tex \
               preamble/style.tex \
               preamble/color.tex \
               preamble/newcommands.tex \
               $(wildcard content/*.tex)

# your bibtex databases
DOC_BIB     ?= own.bib

# images
DOC_IMG_JPG  = images/squirrel.jpg # you can specify multiple images here
DOC_IMG_PDF  = images/fastcall_architecture.pdf
DOC_IMG_PNG  = images/system_call.png
DOC_IMG_PDF  = images/yaoxin_jing_signed.pdf
DOC_IMG_PNG  = images/IOURING.png
DOC_IMG_PNG  = images/Linux_networking.png
DOC_IMG_PNG  = images/fastcall__design_idea.pdf
DOC_IMG_PNG  = images/Stub_partition.pdf
DOC_IMG_PNG  = images/registeration_process.pdf
DOC_IMG_PNG  = images/fastcall_workflow.pdf
DOC_IMG_PNG  = images/fastcall_table.pdf
DOC_IMG_PNG  = images/Fast_Call entries.pdf
DOC_IMG_PNG  = images/mmap_search_methods.pdf
DOC_IMG_PNG  = images/secret_pages.pdf
DOC_IMG_PNG  = images/secret_pages_2.pdf
DOC_IMG_PNG  = images/secrt_page_3.pdf
DOC_IMG_PNG  = images/secret_page_4.pdf
DOC_IMG_PNG  = images/GDB_METHOD1.pdf
DOC_IMG_PNG  = images/GDB_METHOD2.pdf
DOC_IMG_PNG  = images/MPROTECT.pdf
DOC_IMG_PNG  = images/Seperateuserspace.pdf
DOC_IMG_PNG  = images/sequence_file.pdf

DOC_IMG_PNG  = images/fast_call_design_idea1.pdf
DOC_IMG_PNG  = images/ring_protection.pdf
DOC_IMG_PNG  = images/IO_PERFORMANCE.PNG
DOC_IMG_PNG  = images/rederegistration.PNG

DOC_IMG_PNG  = images/FORK.PNG

# latex stuff
LUALATEX    ?= lualatex --synctex=1
BIBER       ?= biber
DETEX       ?= detex
CHECKBIW    ?= checkbiw/src/checkbiw

######################################################################
# You should not need to adapt stuff below this line ...
######################################################################

DOC_PDF      = $(DOC_TEX:.tex=.pdf)
# Use De-TeXed output for the prose analysis, because you
# may have obsolete text commented out, or PGF commands,
# that you do not want to check for flaws
DOC_TXT      = $(DOC_TEX:.tex=.detex)
DOC_BASE     = $(DOC_TEX:.tex=)

DOC_CLEAN    = $(DOC_PDF)									\
               $(DOC_BASE).{aux,log,toc,bcf,bbl,blg,ltf,brf,out} \
			   $(DOC_BASE).{lof,nav,snm,acn,glo,ist,lot,run.xml} \
			   $(DOC_BASE).{synctex,synctex.gz} \
               $(DOC_TXT) $(DOC_TXT_ADD) \
               *~

VERBOSE = @

.PHONY: default pdf clean check-french-spacing checkbiw

default: pdf

$(DOC_PDF): $(DOC_TEX) $(DOC_TEX_ADD) $(DOC_BIB) $(DOC_IMG_JPG)		\
            $(DOC_IMG_PNG) $(DOC_IMG_PNG) $(DOC_IMG_PDF) Makefile
	$(VERBOSE)$(LUALATEX) $(DOC_TEX) || \
	    ((grep 'TeX capacity exceeded' $(DOC_PDF:.pdf=.log) && \
	   echo -e "\n\033[31mIncrease pool_size to 200000 in" \
	           "/etc/texmf/texmf.cnf!\033[m\n" && false) || false)
	$(VERBOSE)[ -f $(DOC_BASE).bcf ] && \
	  $(BIBER) $(DOC_BASE).bcf
	$(VERBOSE)(export size=1 ; touch $(DOC_PDF);\
	  until [ $$size -eq `ls -o $(DOC_PDF) | awk '{print $$4}'` ]; do\
	    export size=`ls -o $(DOC_PDF) | awk '{print $$4}'` ;\
	    $(LUALATEX) $(DOC_TEX) ;\
	  done)

$(DOC_TXT): $(DOC_TEX) $(DOC_TEX_ADD)
	$(DETEX) $(DOC_TEX) > $(DOC_TXT)

pdf: $(DOC_PDF)

clean:
	rm -f $(DOC_CLEAN)

# Points out abbreviations and reminds you of escaping
# the space after the period
check-french-spacing: $(DOC_TEX) $(DOC_TEX_ADD)
	$(VERBOSE)export GREP_COLOR='1;32'; \
	export GREP_OPTIONS='--color=auto'; \
	grep "[A-Z]\{2,\}\." $(DOC_TEX) $(DOC_TEX_ADD) || \
	grep -e 'e\.g\.' -e 'i\.e\.' -e 'd\.h\.' $(DOC_TEX) $(DOC_TEX_ADD) || \
	true

# check for conformance with "bugs in writing", English only
checkbiw: $(DOC_TXT)
	$(VERBOSE)$(CHECKBIW) -v -c $(DOC_TXT)

