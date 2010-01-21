Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0L7gNC2059913 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 01:42:24 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CEBFBCB4FC
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 23:43:22 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	HgWhl2rjGs5RknMn for <xfs@oss.sgi.com>;
	Wed, 20 Jan 2010 23:43:22 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11575089-1927428
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 18:13:21 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NXrhH-0006k5-QD
	for xfs@oss.sgi.com; Thu, 21 Jan 2010 18:43:19 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NXrhG-0006X7-66
	for xfs@oss.sgi.com; Thu, 21 Jan 2010 18:43:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsprogs: Automatic build dependency calculations
Date: Thu, 21 Jan 2010 18:43:18 +1100
Message-Id: <1264059798-25085-1-git-send-email-david@fromorbit.com>
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

Currently the xfsprogs builds do not have any automatic dependency
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
 copy/Makefile         |    4 +++-
 db/Makefile           |    4 +++-
 estimate/Makefile     |    4 +++-
 fsr/Makefile          |    4 +++-
 growfs/Makefile       |    4 +++-
 include/buildrules    |   36 +++++++++++-------------------------
 io/Makefile           |    4 +++-
 libdisk/Makefile      |    4 +++-
 libhandle/Makefile    |    4 +++-
 libxcmd/Makefile      |    4 +++-
 libxfs/Makefile       |    4 +++-
 libxlog/Makefile      |    4 +++-
 logprint/Makefile     |    4 +++-
 m4/package_utilies.m4 |   24 +++++++++++++++++++++---
 mdrestore/Makefile    |    4 +++-
 mkfs/Makefile         |    4 +++-
 quota/Makefile        |    4 +++-
 repair/Makefile       |    4 +++-
 rtcp/Makefile         |    4 +++-
 19 files changed, 83 insertions(+), 45 deletions(-)

diff --git a/copy/Makefile b/copy/Makefile
index 3bdc72b..54f6dfb 100644
--- a/copy/Makefile
+++ b/copy/Makefile
@@ -13,7 +13,7 @@ LLDLIBS = $(LIBXFS) $(LIBUUID) $(LIBPTHREAD) $(LIBRT)
 LTDEPENDENCIES = $(LIBXFS)
 LLDFLAGS = -static
 
-default: $(LTCOMMAND)
+default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
@@ -21,3 +21,5 @@ install: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
+
+-include .dep
diff --git a/db/Makefile b/db/Makefile
index 69a85d7..5c7d054 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -30,7 +30,7 @@ LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 CFLAGS += -DENABLE_EDITLINE
 endif
 
-default: $(LTCOMMAND)
+default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
@@ -42,3 +42,5 @@ install: default
 	$(INSTALL) -m 755 xfs_ncheck.sh $(PKG_SBIN_DIR)/xfs_ncheck
 	$(INSTALL) -m 755 xfs_metadump.sh $(PKG_SBIN_DIR)/xfs_metadump
 install-dev:
+
+-include .dep
diff --git a/estimate/Makefile b/estimate/Makefile
index c972403..18971e4 100644
--- a/estimate/Makefile
+++ b/estimate/Makefile
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_estimate
 CFILES = xfs_estimate.c
 
-default: $(LTCOMMAND)
+default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
@@ -16,3 +16,5 @@ install: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
+
+-include .dep
diff --git a/fsr/Makefile b/fsr/Makefile
index b7b0ab8..a9d1bf6 100644
--- a/fsr/Makefile
+++ b/fsr/Makefile
@@ -9,7 +9,7 @@ LTCOMMAND = xfs_fsr
 CFILES = xfs_fsr.c
 LLDLIBS = $(LIBHANDLE)
 
-default: $(LTCOMMAND)
+default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
@@ -17,3 +17,5 @@ install: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
+
+-include .dep
diff --git a/growfs/Makefile b/growfs/Makefile
index 2bab89f..88cbf4f 100644
--- a/growfs/Makefile
+++ b/growfs/Makefile
@@ -22,7 +22,7 @@ LTDEPENDENCIES = $(LIBXFS) $(LIBXCMD)
 LLDFLAGS = -static
 LSRCFILES = xfs_info.sh
 
-default: $(LTCOMMAND)
+default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
@@ -31,3 +31,5 @@ install: default
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 	$(INSTALL) -m 755 xfs_info.sh $(PKG_SBIN_DIR)/xfs_info
 install-dev:
+
+-include .dep
diff --git a/include/buildrules b/include/buildrules
index fdc60e6..d1a3a6f 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -89,33 +89,19 @@ endif # _BUILDRULES_INCLUDED_
 
 $(_FORCE):
 
-.PHONY : depend install-qa
+# dependency build is automatic, relies on gcc -MM to generate.
+.PHONY : depend ltdepend install-qa
 
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
+ltdepend: $(CFILES) $(HFILES)
+	@echo "    [DEP]"
+	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .dep
 
-depend : $(CFILES) $(HFILES) $(addsuffix -depend,$(SUBDIRS))
-	$(DEPENDSCRIPT) > .dep
-	test -s .dep || rm -f .dep
+depend: $(CFILES) $(HFILES)
+	@echo "    [DEP]"
+	$(Q)$(MAKEDEP) $(CFILES) > .dep
 
-%-depend:
-	$(MAKE) -C $* depend
 
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
+#	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1,' > .dep
+
diff --git a/io/Makefile b/io/Makefile
index 59c2860..fc98166 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -63,7 +63,7 @@ ifeq ($(HAVE_FALLOCATE),yes)
 LCFLAGS += -DHAVE_FALLOCATE
 endif
 
-default: $(LTCOMMAND)
+default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
@@ -74,3 +74,5 @@ install: default
 	$(LTINSTALL) -m 755 xfs_freeze.sh $(PKG_SBIN_DIR)/xfs_freeze
 	$(LTINSTALL) -m 755 xfs_mkfile.sh $(PKG_SBIN_DIR)/xfs_mkfile
 install-dev:
+
+-include .dep
diff --git a/libdisk/Makefile b/libdisk/Makefile
index 4c0dacb..32416a5 100644
--- a/libdisk/Makefile
+++ b/libdisk/Makefile
@@ -20,7 +20,7 @@ else
 LSRCFILES = $(LINUX_DRIVERS)
 endif
 
-default: $(LTLIBRARY)
+default: ltdepend $(LTLIBRARY)
 
 include $(BUILDRULES)
 
@@ -29,3 +29,5 @@ install: default
 install-dev: default
 
 install-qa: install-dev
+
+-include .dep
diff --git a/libhandle/Makefile b/libhandle/Makefile
index 4ce0878..9422c34 100644
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -15,7 +15,7 @@ LTLDFLAGS += -Wl,--version-script,libhandle.sym
 CFILES = handle.c jdm.c
 LSRCFILES = libhandle.sym
 
-default:  $(LTLIBRARY)
+default: ltdepend $(LTLIBRARY)
 
 include $(BUILDRULES)
 
@@ -26,3 +26,5 @@ install-dev: default
 	$(INSTALL_LTLIB_DEV)
 
 install-qa: install-dev
+
+-include .dep
diff --git a/libxcmd/Makefile b/libxcmd/Makefile
index 53922b7..60b6f9e 100644
--- a/libxcmd/Makefile
+++ b/libxcmd/Makefile
@@ -28,8 +28,10 @@ ifeq ($(ENABLE_EDITLINE),yes)
 LCFLAGS += -DENABLE_EDITLINE
 endif
 
-default: $(LTLIBRARY)
+default: ltdepend $(LTLIBRARY)
 
 include $(BUILDRULES)
 
 install install-dev install-qa: default
+
+-include .dep
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 1914927..8f80cdc 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -36,7 +36,7 @@ FCFLAGS = -I.
 # don't try linking xfs_repair with a debug libxfs.
 DEBUG = -DNDEBUG
 
-default:  $(LTLIBRARY)
+default: ltdepend $(LTLIBRARY)
 
 include $(BUILDRULES)
 
@@ -45,3 +45,5 @@ install: default
 install-dev: default
 
 install-qa: default
+
+-include .dep
diff --git a/libxlog/Makefile b/libxlog/Makefile
index 988d01c..7358fb1 100644
--- a/libxlog/Makefile
+++ b/libxlog/Makefile
@@ -15,8 +15,10 @@ CFILES = xfs_log_recover.c util.c
 # don't want to link xfs_repair with a debug libxlog.
 DEBUG = -DNDEBUG
 
-default:  $(LTLIBRARY)
+default: ltdepend $(LTLIBRARY)
 
 include $(BUILDRULES)
 
 install install-dev install-qa: default
+
+-include .dep
diff --git a/logprint/Makefile b/logprint/Makefile
index 1c7d997..2d656a4 100644
--- a/logprint/Makefile
+++ b/logprint/Makefile
@@ -16,7 +16,7 @@ LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
 LLDFLAGS = -static
 
-default: $(LTCOMMAND)
+default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
@@ -24,3 +24,5 @@ install: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
+
+-include .dep
diff --git a/m4/package_utilies.m4 b/m4/package_utilies.m4
index f42bd6b..475ce0b 100644
--- a/m4/package_utilies.m4
+++ b/m4/package_utilies.m4
@@ -11,6 +11,23 @@ AC_DEFUN([AC_PACKAGE_NEED_UTILITY],
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
+#
 # Generic macro, sets up all of the global build variables.
 # The following environment variables may be set to override defaults:
 #  CC MAKE LIBTOOL TAR ZIP MAKEDEPEND AWK SED ECHO SORT
@@ -44,10 +61,11 @@ AC_DEFUN([AC_PACKAGE_UTILITIES],
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
diff --git a/mdrestore/Makefile b/mdrestore/Makefile
index 6dc6cd4..fd35d80 100644
--- a/mdrestore/Makefile
+++ b/mdrestore/Makefile
@@ -12,7 +12,7 @@ LLDLIBS = $(LIBXFS) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS)
 LLDFLAGS = -static
 
-default: $(LTCOMMAND)
+default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
@@ -20,3 +20,5 @@ install:
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
+
+-include .dep
diff --git a/mkfs/Makefile b/mkfs/Makefile
index a749262..8b61c2f 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -27,7 +27,7 @@ endif
 LSRCFILES = $(FSTYP).c
 LDIRT = $(FSTYP)
 
-default: $(LTCOMMAND)
+default: depend $(LTCOMMAND)
 
 ifneq ($(ENABLE_BLKID),yes)
 default: $(FSTYP)
@@ -43,3 +43,5 @@ install: default
 	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
 install-dev:
+
+-include .dep
diff --git a/quota/Makefile b/quota/Makefile
index 7aedd56..9c6411e 100644
--- a/quota/Makefile
+++ b/quota/Makefile
@@ -28,7 +28,7 @@ LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 CFLAGS += -DENABLE_EDITLINE
 endif
 
-default: $(LTCOMMAND)
+default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
@@ -36,3 +36,5 @@ install: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
+
+-include .dep
diff --git a/repair/Makefile b/repair/Makefile
index fa96df5..b0e03f8 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -24,7 +24,7 @@ LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
 LLDFLAGS = -static
 
-default: $(LTCOMMAND)
+default: depend $(LTCOMMAND)
 
 globals.o: globals.h
 
@@ -48,3 +48,5 @@ install: default
 	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
 install-dev:
+
+-include .dep
diff --git a/rtcp/Makefile b/rtcp/Makefile
index 5f1a803..9a5b66f 100644
--- a/rtcp/Makefile
+++ b/rtcp/Makefile
@@ -9,7 +9,7 @@ LTCOMMAND = xfs_rtcp
 CFILES = xfs_rtcp.c
 LLDFLAGS = -static
 
-default: $(LTCOMMAND)
+default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
@@ -17,3 +17,5 @@ install: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:
+
+-include .dep
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
