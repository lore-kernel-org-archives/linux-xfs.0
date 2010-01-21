Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0L6289A056239 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 00:02:09 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 503EFF2F531
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 22:03:07 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	D8Suvw4R3CI4Bb7Z for <xfs@oss.sgi.com>;
	Wed, 20 Jan 2010 22:03:07 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11416006-1927428
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 16:33:06 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NXq8B-0006cP-VM
	for xfs@oss.sgi.com; Thu, 21 Jan 2010 17:03:00 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NXq8A-0001aS-Dg
	for xfs@oss.sgi.com; Thu, 21 Jan 2010 17:02:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfstests: Automatic build dependency calculations
Date: Thu, 21 Jan 2010 17:02:53 +1100
Message-Id: <1264053773-6054-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1264053773-6054-1-git-send-email-david@fromorbit.com>
References: <1264053773-6054-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Currently the xfstest builds do not have any automatic dependency
calculations. It relies on a separate make depend run to build or
update dependency information. It also relies on an external
makedepend binary. If that binary does not exist, the dependencies
do not get calculated.

To remove the dependency on makedepend, gcc can be used instead as
it has a command to generate dependency information. This patch
changes the dependency rule building to use gcc.

In case anyone uses an old (several years) gcc compiler or a
compiler that doesn't support gcc compatible dependency generation,
a new configure check is added to turn off dependency checking so
builds can still be done.

To use the dependencies automatically, we need to use a special
include makefile directive to include the build dependencies into
the current makefile.  Essentially once the dependencies are
calculated, they can be included into the makefile and make will
recalculate the build dependencies automatically based on that
information.

Hence we get a build that automatically calculates and keeps
dependencies up to date without dependence on any external tools.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 .gitignore                   |    3 +++
 include/builddefs.in         |    4 ----
 include/buildrules           |   36 ++++++++++--------------------------
 lib/Makefile                 |    4 +++-
 ltp/Makefile                 |    3 ++-
 m4/package_utilies.m4        |   27 +++++++++++++++++++++++----
 src/Makefile                 |   19 ++++++++++---------
 src/aio-dio-regress/Makefile |    4 +++-
 8 files changed, 54 insertions(+), 46 deletions(-)

diff --git a/.gitignore b/.gitignore
index d7cbab1..563c30a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,9 +1,12 @@
 *.lo
 *.o
 *.la
+.dep
 
 autom4te.cache
 configure
+config.log
+config.status
 include/builddefs
 include/config.h
 include/config.h.in
diff --git a/include/builddefs.in b/include/builddefs.in
index 7827ed5..23a4991 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -65,18 +65,14 @@ GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 
 ifeq ($(PKG_PLATFORM),linux)
 PCFLAGS = -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 $(GCCFLAGS)
-DEPENDFLAGS = -D__linux__
 endif
 ifeq ($(PKG_PLATFORM),darwin)
 PCFLAGS = -traditional-cpp $(GCCFLAGS)
-DEPENDFLAGS = -D__APPLE__
 endif
 ifeq ($(PKG_PLATFORM),irix)
 PCFLAGS = -nostdinc -I$(ROOT)/usr/include -I$(TOPDIR)/../irix/include
-DEPENDFLAGS = -D__sgi__
 endif
 ifeq ($(PKG_PLATFORM),freebsd)
-DEPENDFLAGS = -D__FreeBSD__
 endif
 
 GCFLAGS = $(OPTIMIZER) $(DEBUG) $(CPPFLAGS) \
diff --git a/include/buildrules b/include/buildrules
index 5428391..5388210 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 
 clean clobber : $(addsuffix -clean,$(SUBDIRS))
 	$(Q)rm -f $(DIRT)
-	$(Q)rm -fr .libs
+	$(Q)rm -fr .libs .dep
 
 %-clean:
 	@echo "Cleaning $*"
@@ -70,32 +70,16 @@ endif # _BUILDRULES_INCLUDED_
 
 $(_FORCE):
 
-.PHONY : depend
+# dependency build is automatic, relies on gcc -MM to generate.
+.PHONY : depend ltdepend
 
-DEPENDSCRIPT := $(MAKEDEPEND) $(DEPENDFLAGS) -f - -- $(CFLAGS) -- $(CFILES) | \
-	$(SED) -e 's,`pwd`,$(TOPDIR),g' \
-	    -e 's,  */[^ ]*,,g' \
-	    -e '/^[^ ]*: *$$/d' \
-	    -e '/^ *$$/d'
+MAKEDEP := $(MAKEDEPEND) $(CFLAGS)
 
-ifdef LTLIBRARY
-DEPENDSCRIPT := $(DEPENDSCRIPT) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,'
-endif
+ltdepend: $(CFILES) $(HFILES)
+	@echo "    [DEP]"
+	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .dep
 
-depend : $(CFILES) $(HFILES) $(addsuffix -depend,$(SUBDIRS))
-	$(DEPENDSCRIPT) > .dep
-	test -s .dep || rm -f .dep
+depend: $(CFILES) $(HFILES)
+	@echo "    [DEP]"
+	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1,' > .dep
 
-%-depend:
-	$(MAKE) -C $* depend
-
-# Include dep, but only if it exists
-ifeq ($(shell test -f .dep && echo .dep), .dep)
-include .dep
-else
-ifdef LTLIBRARY
-$(LTOBJECTS): $(HFILES)
-else
-$(OBJECTS): $(HFILES)
-endif
-endif
diff --git a/lib/Makefile b/lib/Makefile
index 435c38c..43fb0a0 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -19,8 +19,10 @@ CFILES = dataascii.c databin.c datapid.c file_lock.c forker.c \
 	str_to_bytes.c tlibio.c write_log.c \
 	random.c
 
-default: $(LTLIBRARY)
+default: ltdepend $(LTLIBRARY)
 
 include $(BUILDRULES)
 
 install install-dev: default
+
+-include .dep
diff --git a/ltp/Makefile b/ltp/Makefile
index fee10f5..d74a9df 100644
--- a/ltp/Makefile
+++ b/ltp/Makefile
@@ -27,7 +27,7 @@ LCFLAGS += -DAIO
 LLDLIBS += -laio -lpthread
 endif
 
-default: $(TARGETS)
+default: depend $(TARGETS)
 
 include $(BUILDRULES)
 
@@ -39,3 +39,4 @@ install: default
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/ltp
 	$(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/ltp
 
+-include .dep
diff --git a/m4/package_utilies.m4 b/m4/package_utilies.m4
index c034a7c..726406c 100644
--- a/m4/package_utilies.m4
+++ b/m4/package_utilies.m4
@@ -11,9 +11,27 @@ AC_DEFUN([AC_PACKAGE_NEED_UTILITY],
   ])
 
 #
+#check compiler can generate dependencies
+#
+AC_DEFUN([AC_PACKAGE_GCC_DEPS],
+  [AC_CACHE_CHECK(whether gcc -MM is supported,
+                  ac_cv_gcc_nodeps,
+                  [cat > conftest.c <<EOF
+		   #include <stdio.h>
+		   int main() { exit(0); }
+EOF
+                  ac_cv_gcc_nodeps=no
+                  if ${CC} -MM conftest.c >/dev/null 2>&1; then
+                     ac_cv_gcc_nodeps=yes
+                  fi
+                  rm -f conftest.c a.out
+                  ])
+  ])
+
+#
 # Generic macro, sets up all of the global build variables.
 # The following environment variables may be set to override defaults:
-#  CC MAKE LIBTOOL TAR ZIP MAKEDEPEND AWK SED ECHO SORT
+#  CC MAKE LIBTOOL TAR ZIP eMAKEDEPEND AWK SED ECHO SORT
 #  MSGFMT MSGMERGE RPM
 #
 AC_DEFUN([AC_PACKAGE_UTILITIES],
@@ -54,10 +72,11 @@ AC_DEFUN([AC_PACKAGE_UTILITIES],
     zip=$ZIP
     AC_SUBST(zip)
 
-    if test -z "$MAKEDEPEND"; then
-        AC_PATH_PROG(MAKEDEPEND, makedepend, /bin/true)
+    AC_PACKAGE_GCC_DEPS()
+    makedepend="$cc -MM"
+    if test $ac_cv_gcc_nodeps = no; then
+	makedepend=/bin/true
     fi
-    makedepend=$MAKEDEPEND
     AC_SUBST(makedepend)
 
     if test -z "$AWK"; then
diff --git a/src/Makefile b/src/Makefile
index e2a42ce..398b9dc 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -13,11 +13,12 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	multi_open_unlink dmiperf unwritten_sync genhashnames
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize \
-	preallo_rw_pattern_reader preallo_rw_pattern_writer ftrunc trunc \
-	fs_perms testx looptest locktest unwritten_mmap \
+	ftrunc trunc fs_perms testx looptest locktest unwritten_mmap \
 	bulkstat_unlink_test bulkstat_unlink_test_modified t_dir_offset \
 	t_futimens
 
+SUBDIRS =
+
 LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
 
 ifeq ($(HAVE_XLOG_ASSIGN_LSN), true)
@@ -27,6 +28,7 @@ endif
 IRIX_TARGETS = open_unlink
 
 ifeq ($(PKG_PLATFORM),linux)
+PREALLO_TARGETS = preallo_rw_pattern_reader
 TARGETS += $(LINUX_TARGETS)
 TARGETS += t_immutable
 endif
@@ -45,13 +47,10 @@ ifeq ($(HAVE_AIO), true)
 SUBDIRS += aio-dio-regress
 endif
 
-CFILES = $(TARGETS:=.c)
-LDIRT = $(TARGETS)
-
+CFILES := $(TARGETS:=.c)
+LDIRT := $(TARGETS) $(PREALLO_TARGETS)
 
-default: $(TARGETS) $(SUBDIRS)
-
-PREALLO_TARGETS = preallo_rw_pattern_reader preallo_rw_pattern_writer
+default: depend $(TARGETS) $(PREALLO_TARGETS) $(SUBDIRS)
 
 include $(BUILDRULES)
 
@@ -63,7 +62,7 @@ preallo_rw_pattern_writer:
 	@echo "    [CC]    $@"
 	$(Q)$(LTLINK) iopat.c -DWRITE -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
 
-$(filter-out $(PREALLO_TARGETS), $(TARGETS)): $(LIBTEST)
+$(TARGETS): $(LIBTEST)
 	@echo "    [CC]    $@"
 	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
 
@@ -77,3 +76,5 @@ install: default $(addsuffix -install,$(SUBDIRS))
 
 %-install:
 	$(MAKE) -C $* install
+
+-include .dep
diff --git a/src/aio-dio-regress/Makefile b/src/aio-dio-regress/Makefile
index f0e4d15..3f9d1c2 100644
--- a/src/aio-dio-regress/Makefile
+++ b/src/aio-dio-regress/Makefile
@@ -8,7 +8,7 @@ LDIRT = $(TARGETS)
 
 LLDLIBS = -laio -lpthread
 
-default: $(TARGETS)
+default: depend $(TARGETS)
 
 include $(BUILDRULES)
 
@@ -19,3 +19,5 @@ $(TARGETS):
 install:
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/src/aio-dio-regress
 	$(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/src/aio-dio-regress
+
+-include .dep
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
