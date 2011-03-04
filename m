Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24JYoJD184523 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 13:34:50 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103041937.p24Jbfh5004820@stout.americas.sgi.com>
Date: Fri, 04 Mar 2011 13:37:41 -0600
Subject: [PATCH 2/2] xfstests: some refinements on "make depend"
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Make it so "make depend" is a generic target, like "make clean".

Each Makefile has a "depend" target that indicates whether making
dependencies means creating ".dep" or creating ".ltdep" (or, I
suppose, both, though none do that right now).  Both files get
created even if there are no CFILES to scan (to ensure the target
up-to-date).  The "default" target now depends on "depend" (there is
no "ltdepend" any more).

Remove the "depend" and "ltdepend" definitions from the "buildrules"
file; only the actual generated files (".dep" and ".ltdep") remain
as generic targets.  The "depend' target is still defined as phony.
 
Do a shell trick when expanding the value of CFILES, to avoid a
problem that occurs if it is created by "make" by concatentating two
empty strings.  The problem was that in that case CFILES will
contain a space, and that wasn't getting treated as empty as
desired.

Make the rule for tool/lib dependencies more generic, to reflect the
general desire that "lib" subdirectories need to be built before
things in the "tool" subdirectories.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 Makefile                     |    4 +++-
 include/buildrules           |   31 +++++++++++++++++++++----------
 lib/Makefile                 |    4 +++-
 ltp/Makefile                 |    2 ++
 src/Makefile                 |    2 ++
 src/aio-dio-regress/Makefile |    2 ++
 6 files changed, 33 insertions(+), 12 deletions(-)

Index: b/Makefile
===================================================================
--- a/Makefile
+++ b/Makefile
@@ -52,7 +52,7 @@ endif
 endif
 
 # tool/lib dependencies
-src ltp: lib
+$(TOOL_SUBDIRS): $(LIB_SUBDIRS)
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
@@ -77,6 +77,8 @@ endif
 aclocal.m4::
 	aclocal --acdir=`pwd`/m4 --output=$@
 
+depend: include/builddefs $(addsuffix -depend,$(SUBDIRS))
+
 install: default $(addsuffix -install,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)
 	$(INSTALL) -m 755 check $(PKG_LIB_DIR)
Index: b/include/buildrules
===================================================================
--- a/include/buildrules
+++ b/include/buildrules
@@ -6,13 +6,20 @@ _BUILDRULES_INCLUDED_ = 1
 
 include $(TOPDIR)/include/builddefs
 
+depend: $(addsuffix -depend,$(SUBDIRS))
+
+%-depend:
+	$(Q)$(MAKE) $(MAKEOPTS) -q -C $* depend || \
+	    $(MAKE) $(MAKEOPTS) -C $* depend
+
 clean clobber : $(addsuffix -clean,$(SUBDIRS))
 	$(Q)rm -f $(DIRT)
 	$(Q)rm -fr .libs .ltdep .dep
 
 %-clean:
 	@echo "Cleaning $*"
-	$(Q)$(MAKE) $(MAKEOPTS) -q -C $* clean || $(MAKE) $(MAKEOPTS) -C $* clean
+	$(Q)$(MAKE) $(MAKEOPTS) -q -C $* clean || \
+	    $(MAKE) $(MAKEOPTS) -C $* clean
 
 # Never blow away subdirs
 ifdef SUBDIRS
@@ -71,21 +78,25 @@ endif # _BUILDRULES_INCLUDED_
 $(_FORCE):
 
 # dependency build is automatic, relies on gcc -MM to generate.
-.PHONY : depend ltdepend
+.PHONY : depend
 
 MAKEDEP := $(MAKEDEPEND) $(CFLAGS)
 
-ltdepend: .ltdep
-
 .ltdep: $(CFILES) $(HFILES)
 	@echo "    [LTDEP]"
-	$(Q)[ -n "$(CFILES)" ] && \
-	    $(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep
-
-depend: .dep
+	$(Q)if [ -n "$$( echo $(CFILES))" ]; then \
+	    $(MAKEDEP) $(CFILES) | \
+	    $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep; \
+	else \
+	    cp /dev/null .ltdep; \
+	fi
 
 .dep: $(CFILES) $(HFILES)
 	@echo "    [DEP]"
-	$(Q)[ -n "$(CFILES)" ] && \
-	    $(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1,' > .dep
+	$(Q)if [ -n "$$( echo $(CFILES))" ]; then \
+	    $(MAKEDEP) $(CFILES) | \
+	    $(SED) -e 's,^\([^:]*\)\.o,\1,' > .dep; \
+	else \
+	    cp /dev/null .dep; \
+	fi
 
Index: b/lib/Makefile
===================================================================
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -19,10 +19,12 @@ CFILES = dataascii.c databin.c datapid.c
 	str_to_bytes.c tlibio.c write_log.c \
 	random.c
 
-default: ltdepend $(LTLIBRARY)
+default: depend $(LTLIBRARY)
 
 include $(BUILDRULES)
 
+depend: .ltdep
+
 install install-dev: default
 
 -include .ltdep
Index: b/ltp/Makefile
===================================================================
--- a/ltp/Makefile
+++ b/ltp/Makefile
@@ -29,6 +29,8 @@ endif
 
 default: depend $(TARGETS)
 
+depend: .dep
+
 include $(BUILDRULES)
 
 $(TARGETS): $(LIBTEST)
Index: b/src/Makefile
===================================================================
--- a/src/Makefile
+++ b/src/Makefile
@@ -61,6 +61,8 @@ LDIRT = $(TARGETS)
 
 default: depend $(TARGETS) $(SUBDIRS)
 
+depend: .dep
+
 include $(BUILDRULES)
 
 $(TARGETS): $(LIBTEST)
Index: b/src/aio-dio-regress/Makefile
===================================================================
--- a/src/aio-dio-regress/Makefile
+++ b/src/aio-dio-regress/Makefile
@@ -10,6 +10,8 @@ LLDLIBS = -laio -lpthread
 
 default: depend $(TARGETS)
 
+depend: .dep
+
 include $(BUILDRULES)
 
 $(TARGETS):

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
