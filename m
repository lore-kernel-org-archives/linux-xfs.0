Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0L9nTOp065054 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 03:49:30 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47B1A12F42CD
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 01:50:29 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	9ugSJlBVd9G46jJa for <xfs@oss.sgi.com>;
	Thu, 21 Jan 2010 01:50:29 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11416768-1927428
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 20:20:28 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NXtgI-0006pp-GN
	for xfs@oss.sgi.com; Thu, 21 Jan 2010 20:50:26 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NXtgG-0000ai-R8
	for xfs@oss.sgi.com; Thu, 21 Jan 2010 20:50:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsdump: Automatic build dependency calculations
Date: Thu, 21 Jan 2010 20:50:24 +1100
Message-Id: <1264067424-2242-1-git-send-email-david@fromorbit.com>
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

Currently the xfsdump builds do not have any automatic dependency
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
 dump/Makefile         |    6 +++++-
 include/buildrules    |   36 +++++++++---------------------------
 inventory/Makefile    |    2 ++
 invutil/Makefile      |    6 +++++-
 librmt/Makefile       |    4 +++-
 m4/package_utilies.m4 |   25 ++++++++++++++++++++++---
 restore/Makefile      |    6 +++++-
 7 files changed, 51 insertions(+), 34 deletions(-)

diff --git a/dump/Makefile b/dump/Makefile
index a0c74dc..e0e6f34 100644
--- a/dump/Makefile
+++ b/dump/Makefile
@@ -94,7 +94,7 @@ LTDEPENDENCIES = $(LIBRMT)
 
 LCFLAGS = -DDUMP -DRMT -DBASED -DDOSOCKS -DINVCONVFIX -DSIZEEST -DPIPEINVFIX
 
-default: $(LTCOMMAND)
+default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
@@ -105,6 +105,8 @@ install: default
 	$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) $(PKG_SBIN_DIR)/$(LTCOMMAND)
 install-dev:
 
+depend: $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
+
 $(COMMINCL) $(COMMON):
 	@echo "    [LN]     $@"
 	$(Q)$(RM) $@; $(LN_S) ../common/$@ $@
@@ -112,3 +114,5 @@ $(COMMINCL) $(COMMON):
 $(INVINCL) $(INVCOMMON):
 	@echo "    [LN]     $@"
 	$(Q)$(RM) $@; $(LN_S) ../inventory/$@ $@
+
+-include .dep
diff --git a/include/buildrules b/include/buildrules
index a9eb092..625e85c 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -89,33 +89,15 @@ endif # _BUILDRULES_INCLUDED_
 
 $(_FORCE):
 
-.PHONY : depend
+# dependency build is automatic, relies on gcc -MM to generate.
+.PHONY : depend ltdepend
 
-DEPENDSCRIPT := $(MAKEDEPEND) $(DEPENDFLAGS) -f - -- $(CFLAGS) -- $(CFILES) | \
-	$(SED) \
-	    -e 's,`pwd`,$(TOPDIR),g' \
-	    -e 's,  */[^ ]*,,g' \
-	    -e '/^[^ ]*: *$$/d' \
-	    -e '/^ *$$/d'
+MAKEDEP := $(MAKEDEPEND) $(CFLAGS)
 
-ifdef LTLIBRARY
-DEPENDSCRIPT := $(DEPENDSCRIPT) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,'
-endif
-
-depend : $(CFILES) $(HFILES) $(addsuffix -depend,$(SUBDIRS))
-	$(DEPENDSCRIPT) > .dep
-	test -s .dep || rm -f .dep
+ltdepend: $(CFILES) $(HFILES)
+	@echo "    [DEP]"
+	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .dep
 
-%-depend:
-	$(MAKE) -C $* depend
-
-# Include dep, but only if it exists
-ifeq ($(shell test -f .dep && echo .dep), .dep)
-include .dep
-else
-ifdef LTLIBRARY
-$(LTOBJECTS): $(HFILES) $(LHFILES)
-else
-$(OBJECTS): $(HFILES) $(LHFILES)
-endif
-endif
+depend: $(CFILES) $(HFILES)
+	@echo "    [DEP]"
+	$(Q)$(MAKEDEP) $(CFILES) > .dep
diff --git a/inventory/Makefile b/inventory/Makefile
index 6624fba..4bc1e09 100644
--- a/inventory/Makefile
+++ b/inventory/Makefile
@@ -12,3 +12,5 @@ LSRCFILES = inv_api.c inv_core.c inv_fstab.c inv_idx.c inv_mgr.c \
 default install install-dev:
 
 include $(BUILDRULES)
+
+-include .dep
diff --git a/invutil/Makefile b/invutil/Makefile
index 9e361f1..c5c61d1 100644
--- a/invutil/Makefile
+++ b/invutil/Makefile
@@ -61,7 +61,7 @@ else
 LSRCFILES += $(CURSESCOMMON) $(CURSESINCL)
 endif
 
-default: $(LTCOMMAND)
+default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
@@ -70,6 +70,8 @@ install: default
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
 
+depend: $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
+
 $(COMMINCL) $(COMMON):
 	@echo "    [LN]     $@"
 	$(Q)$(RM) $@; $(LN_S) ../common/$@ $@
@@ -77,3 +79,5 @@ $(COMMINCL) $(COMMON):
 $(INVINCL) $(INVCOMMON):
 	@echo "    [LN]     $@"
 	$(Q)$(RM) $@; $(LN_S) ../inventory/$@ $@
+
+-include .dep
diff --git a/librmt/Makefile b/librmt/Makefile
index 2831375..2493d21 100644
--- a/librmt/Makefile
+++ b/librmt/Makefile
@@ -15,8 +15,10 @@ CFILES = \
     rmtaccess.c  rmtcreat.c    rmtioctl.c  rmtopen.c    rmtwrite.c \
     rmtmsg.c
 
-default: $(LTLIBRARY)
+default: ltdepend $(LTLIBRARY)
 
 include $(BUILDRULES)
 
 install install-dev: default
+
+-include .dep
diff --git a/m4/package_utilies.m4 b/m4/package_utilies.m4
index f42bd6b..0c379c9 100644
--- a/m4/package_utilies.m4
+++ b/m4/package_utilies.m4
@@ -11,6 +11,24 @@ AC_DEFUN([AC_PACKAGE_NEED_UTILITY],
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
 #  CC MAKE LIBTOOL TAR ZIP MAKEDEPEND AWK SED ECHO SORT
@@ -44,10 +62,11 @@ AC_DEFUN([AC_PACKAGE_UTILITIES],
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
diff --git a/restore/Makefile b/restore/Makefile
index a587632..d70f88d 100644
--- a/restore/Makefile
+++ b/restore/Makefile
@@ -106,7 +106,7 @@ LCFLAGS = -DRESTORE -DRMT -DBASED -DDOSOCKS -DINVCONVFIX -DPIPEINVFIX \
 	-DEOMFIX -DSESSCPLT -DWHITEPARSE -DNODECHK -DDIRENTHDR_CHECKSUM \
 	-DF_FSSETDM
 
-default: $(LTCOMMAND)
+default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
@@ -117,6 +117,8 @@ install: default
 	$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) $(PKG_SBIN_DIR)/$(LTCOMMAND)
 install-dev:
 
+depend: $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
+
 $(COMMINCL) $(COMMON):
 	@echo "    [LN]     $@"
 	$(Q)$(RM) $@; $(LN_S) ../common/$@ $@
@@ -124,3 +126,5 @@ $(COMMINCL) $(COMMON):
 $(INVINCL) $(INVCOMMON):
 	@echo "    [LN]     $@"
 	$(Q)$(RM) $@; $(LN_S) ../inventory/$@ $@
+
+-include .dep
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
