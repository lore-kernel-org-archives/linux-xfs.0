Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36369 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751764AbdGUEkY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:24 -0400
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 14/15] build: remove IRIX-specific build logic
Date: Thu, 20 Jul 2017 21:38:52 -0700
Message-Id: <20170721043853.364-15-ebiggers3@gmail.com>
In-Reply-To: <20170721043853.364-1-ebiggers3@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

As xfstests is no longer supported on IRIX, remove the ability to build
xfstests for IRIX.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 configure.ac          |  59 ++++++++++----------------
 include/builddefs.in  |   3 --
 ltp/Makefile          |   4 --
 m4/package_globals.m4 |   2 +-
 m4/package_libcdev.m4 |   2 +-
 m4/package_utilies.m4 |  14 +++----
 m4/package_xfslibs.m4 |  13 ------
 make_irix             | 114 --------------------------------------------------
 src/Makefile          |   4 --
 9 files changed, 32 insertions(+), 183 deletions(-)
 delete mode 100755 make_irix

diff --git a/configure.ac b/configure.ac
index 843ff6b6..57092f1c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -42,45 +42,32 @@ AC_CHECK_HEADERS([xfs/xfs_log_format.h],,,[
 
 AC_PACKAGE_NEED_UUIDCOMPARE
 
-case $pkg_platform
-in
-	irix)
-		AC_PACKAGE_NEED_SYS_ACL_H
-		AC_PACKAGE_NEED_ATTRIBUTES_H
-		AC_PACKAGE_WANT_NDBM
-		AC_PACKAGE_NEED_IRIX_LIBHANDLE
-		have_attr_list=true
-		AC_SUBST(have_attr_list)
-		;;
-	*)
-		AC_MULTILIB($enable_lib64)
-		AC_PACKAGE_NEED_XFS_XFS_H
-		AC_PACKAGE_WANT_LIBXFS_H
-		AC_PACKAGE_WANT_XLOG_ASSIGN_LSN
-		AC_PACKAGE_NEED_XFS_XQM_H
-		AC_PACKAGE_NEED_XFSCTL_MACRO
-		AC_PACKAGE_NEED_XFS_HANDLE_H
+AC_MULTILIB($enable_lib64)
+AC_PACKAGE_NEED_XFS_XFS_H
+AC_PACKAGE_WANT_LIBXFS_H
+AC_PACKAGE_WANT_XLOG_ASSIGN_LSN
+AC_PACKAGE_NEED_XFS_XQM_H
+AC_PACKAGE_NEED_XFSCTL_MACRO
+AC_PACKAGE_NEED_XFS_HANDLE_H
 
-		AC_PACKAGE_NEED_ATTRLIST_LIBHANDLE
-		AC_PACKAGE_NEED_ATTR_XATTR_H
-		AC_PACKAGE_NEED_ATTRIBUTES_H
-		AC_PACKAGE_WANT_ATTRLIST_LIBATTR
-		AC_PACKAGE_NEED_GETXATTR_LIBATTR
+AC_PACKAGE_NEED_ATTRLIST_LIBHANDLE
+AC_PACKAGE_NEED_ATTR_XATTR_H
+AC_PACKAGE_NEED_ATTRIBUTES_H
+AC_PACKAGE_WANT_ATTRLIST_LIBATTR
+AC_PACKAGE_NEED_GETXATTR_LIBATTR
 
-		AC_PACKAGE_NEED_SYS_ACL_H
-		AC_PACKAGE_NEED_ACL_LIBACL_H
-		AC_PACKAGE_NEED_ACLINIT_LIBACL
+AC_PACKAGE_NEED_SYS_ACL_H
+AC_PACKAGE_NEED_ACL_LIBACL_H
+AC_PACKAGE_NEED_ACLINIT_LIBACL
 
-		AC_PACKAGE_WANT_GDBM
-		AC_PACKAGE_WANT_AIO
-		AC_PACKAGE_WANT_DMAPI
-		AC_PACKAGE_WANT_LINUX_FIEMAP_H
-		AC_PACKAGE_WANT_FALLOCATE
-		AC_PACKAGE_WANT_OPEN_BY_HANDLE_AT
-		AC_PACKAGE_WANT_LINUX_PRCTL_H
-		AC_PACKAGE_WANT_LINUX_FS_H
-		;;
-esac
+AC_PACKAGE_WANT_GDBM
+AC_PACKAGE_WANT_AIO
+AC_PACKAGE_WANT_DMAPI
+AC_PACKAGE_WANT_LINUX_FIEMAP_H
+AC_PACKAGE_WANT_FALLOCATE
+AC_PACKAGE_WANT_OPEN_BY_HANDLE_AT
+AC_PACKAGE_WANT_LINUX_PRCTL_H
+AC_PACKAGE_WANT_LINUX_FS_H
 
 AC_CHECK_FUNCS([renameat2])
 
diff --git a/include/builddefs.in b/include/builddefs.in
index 38fb9c60..cb52b99a 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -76,9 +76,6 @@ endif
 ifeq ($(PKG_PLATFORM),darwin)
 PCFLAGS = -traditional-cpp $(GCCFLAGS)
 endif
-ifeq ($(PKG_PLATFORM),irix)
-PCFLAGS = -nostdinc -I$(ROOT)/usr/include -I$(TOPDIR)/../irix/include
-endif
 ifeq ($(PKG_PLATFORM),freebsd)
 endif
 
diff --git a/ltp/Makefile b/ltp/Makefile
index 5bea4927..eed83f48 100644
--- a/ltp/Makefile
+++ b/ltp/Makefile
@@ -17,10 +17,6 @@ ifeq ($(HAVE_ATTR_LIST), true)
 LCFLAGS += -DHAVE_ATTR_LIST
 LLDLIBS += $(LIBATTR)
 endif
-ifeq ($(PKG_PLATFORM),irix)
-LCFLAGS += -DHAVE_ATTR_LIST
-LLDLIBS += $(LIBATTR)
-endif
 
 ifeq ($(HAVE_AIO), true)
 TARGETS += aio-stress
diff --git a/m4/package_globals.m4 b/m4/package_globals.m4
index 72fbbb78..ce7a8c51 100644
--- a/m4/package_globals.m4
+++ b/m4/package_globals.m4
@@ -39,7 +39,7 @@ AC_DEFUN([AC_PACKAGE_GLOBALS],
     test -z "$DISTRIBUTION" || pkg_distribution="$DISTRIBUTION"
     AC_SUBST(pkg_distribution)
 
-    pkg_platform=`uname -s | tr 'A-Z' 'a-z' | sed -e 's/irix64/irix/'`
+    pkg_platform=`uname -s | tr 'A-Z' 'a-z'`
     test -z "$PLATFORM" || pkg_platform="$PLATFORM"
     AC_SUBST(pkg_platform)
   ])
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 5156ced6..fb123f33 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -67,7 +67,7 @@ AC_DEFUN([AC_HAVE_SENDFILE],
   ])
 
 #
-# Check if we have a getmntent libc call (IRIX, Linux)
+# Check if we have a getmntent libc call (Linux)
 #
 AC_DEFUN([AC_HAVE_GETMNTENT],
   [ AC_MSG_CHECKING([for getmntent ])
diff --git a/m4/package_utilies.m4 b/m4/package_utilies.m4
index 726406c8..108ef455 100644
--- a/m4/package_utilies.m4
+++ b/m4/package_utilies.m4
@@ -41,7 +41,7 @@ AC_DEFUN([AC_PACKAGE_UTILITIES],
     AC_PACKAGE_NEED_UTILITY($1, "$cc", cc, [C compiler])
 
     if test -z "$MAKE"; then
-        AC_PATH_PROG(MAKE, gmake,, /usr/bin:/usr/local/bin:/usr/freeware/bin)
+        AC_PATH_PROG(MAKE, gmake,, /usr/bin:/usr/local/bin)
     fi
     if test -z "$MAKE"; then
         AC_PATH_PROG(MAKE, make,, /usr/bin)
@@ -54,19 +54,19 @@ AC_DEFUN([AC_PACKAGE_UTILITIES],
 	AC_PATH_PROG(LIBTOOL, glibtool,, /usr/bin)
     fi
     if test -z "$LIBTOOL"; then
-	AC_PATH_PROG(LIBTOOL, libtool,, /usr/bin:/usr/local/bin:/usr/freeware/bin)
+	AC_PATH_PROG(LIBTOOL, libtool,, /usr/bin:/usr/local/bin)
     fi
     libtool=$LIBTOOL
     AC_SUBST(libtool)
     AC_PACKAGE_NEED_UTILITY($1, "$libtool", libtool, [GNU libtool])
 
     if test -z "$TAR"; then
-        AC_PATH_PROG(TAR, tar,, /usr/freeware/bin:/bin:/usr/local/bin:/usr/bin)
+        AC_PATH_PROG(TAR, tar,, /bin:/usr/local/bin:/usr/bin)
     fi
     tar=$TAR
     AC_SUBST(tar)
     if test -z "$ZIP"; then
-        AC_PATH_PROG(ZIP, gzip,, /bin:/usr/bin:/usr/local/bin:/usr/freeware/bin)
+        AC_PATH_PROG(ZIP, gzip,, /bin:/usr/bin:/usr/local/bin)
     fi
 
     zip=$ZIP
@@ -108,14 +108,14 @@ AC_DEFUN([AC_PACKAGE_UTILITIES],
 
     if test "$enable_gettext" = yes; then
         if test -z "$MSGFMT"; then
-                AC_PATH_PROG(MSGFMT, msgfmt,, /usr/bin:/usr/local/bin:/usr/freeware/bin)
+                AC_PATH_PROG(MSGFMT, msgfmt,, /usr/bin:/usr/local/bin)
         fi
         msgfmt=$MSGFMT
         AC_SUBST(msgfmt)
         AC_PACKAGE_NEED_UTILITY($1, "$msgfmt", msgfmt, gettext)
 
         if test -z "$MSGMERGE"; then
-                AC_PATH_PROG(MSGMERGE, msgmerge,, /usr/bin:/usr/local/bin:/usr/freeware/bin)
+                AC_PATH_PROG(MSGMERGE, msgmerge,, /usr/bin:/usr/local/bin)
         fi
         msgmerge=$MSGMERGE
         AC_SUBST(msgmerge)
@@ -123,7 +123,7 @@ AC_DEFUN([AC_PACKAGE_UTILITIES],
     fi
 
     if test -z "$RPM"; then
-        AC_PATH_PROG(RPM, rpm,, /bin:/usr/bin:/usr/freeware/bin)
+        AC_PATH_PROG(RPM, rpm,, /bin:/usr/bin)
     fi
     rpm=$RPM
     AC_SUBST(rpm)
diff --git a/m4/package_xfslibs.m4 b/m4/package_xfslibs.m4
index 5588e9ed..9be56e11 100644
--- a/m4/package_xfslibs.m4
+++ b/m4/package_xfslibs.m4
@@ -92,19 +92,6 @@ AC_DEFUN([AC_PACKAGE_NEED_ATTRLIST_LIBHANDLE],
     AC_SUBST(libhdl)
   ])
 
-AC_DEFUN([AC_PACKAGE_NEED_IRIX_LIBHANDLE],
-  [ 
-    AC_MSG_CHECKING([libhandle.a for IRIX])
-    libhdl="`pwd`/../irix/libhandle/libhandle.a"
-    if ! test -f $libhdl; then
-	echo 'no'
-        echo 'FATAL ERROR: could not find IRIX XFS handle library.'
-        exit 1
-    fi
-    echo 'yes'
-    AC_SUBST(libhdl)
-  ])
-
 AC_DEFUN([AC_PACKAGE_NEED_XFSCTL_MACRO],
   [ AC_MSG_CHECKING([xfsctl from xfs/xfs.h])
     AC_TRY_LINK([
diff --git a/make_irix b/make_irix
deleted file mode 100755
index d1782785..00000000
diff --git a/src/Makefile b/src/Makefile
index cb608ad4..b8aff49e 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -49,10 +49,6 @@ ifeq ($(PKG_PLATFORM),linux)
 TARGETS += $(LINUX_TARGETS)
 endif
 
-ifeq ($(PKG_PLATFORM),irix)
-LLDLIBS += -lgen
-endif
-
 ifeq ($(HAVE_DB), true)
 TARGETS += dbtest
 LLDLIBS += $(LIBGDBM)
-- 
2.13.3

