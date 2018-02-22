Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39228 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbeBVCQd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Feb 2018 21:16:33 -0500
Date: Wed, 21 Feb 2018 18:16:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] misc: enable retpolines across all xfsprogs utilities
Message-ID: <20180222021625.GA9827@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Detect and enable retpolines for all code, to mitigate Spectre v2
(branch target injection) on x86.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac          |    1 +
 include/builddefs.in  |    7 +++++++
 m4/package_libcdev.m4 |   22 ++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/configure.ac b/configure.ac
index d068ba0..2104219 100644
--- a/configure.ac
+++ b/configure.ac
@@ -206,6 +206,7 @@ if test "$have_threadsan" = "yes" && test "$have_addrsan" = "yes"; then
         AC_MSG_WARN([ADDRSAN and THREADSAN are not known to work together.])
 fi
 
+AC_PACKAGE_CHECK_RETPOLINE
 AC_CHECK_SIZEOF([long])
 AC_CHECK_SIZEOF([char *])
 AC_TYPE_UMODE_T
diff --git a/include/builddefs.in b/include/builddefs.in
index df76b2c..fe05dc3 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -176,6 +176,13 @@ endif
 SANITIZER_CFLAGS += @addrsan_cflags@ @threadsan_cflags@ @ubsan_cflags@
 SANITIZER_LDFLAGS += @addrsan_ldflags@ @threadsan_ldflags@ @ubsan_ldflags@
 
+# Enable retpolines if available
+HAVE_RETPOLINE = @have_retpoline@
+ifeq ($(HAVE_RETPOLINE),yes)
+OPTIMIZER += @retpoline_cflags@
+LOADERFLAGS += @retpoline_ldflags@
+endif
+
 GCFLAGS = $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
 	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -I$(TOPDIR)/libxfs
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 9258c27..5a7baa1 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -420,3 +420,25 @@ AC_DEFUN([AC_HAVE_HDIO_GETGEO],
        AC_MSG_RESULT(no))
     AC_SUBST(have_hdio_getgeo)
   ])
+
+AC_DEFUN([AC_PACKAGE_CHECK_RETPOLINE],
+  [ AC_MSG_CHECKING([if C compiler supports retpoline])
+    OLD_CFLAGS="$CFLAGS"
+    OLD_LDFLAGS="$LDFLAGS"
+    RETPOLINE_FLAGS="-mindirect-branch=thunk"
+    CFLAGS="$CFLAGS $RETPOLINE_FLAGS"
+    LDFLAGS="$LDFLAGS $RETPOLINE_FLAGS"
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
+        [AC_MSG_RESULT([yes])]
+        [retpoline_cflags=$RETPOLINE_FLAGS]
+        [retpoline_ldflags=$RETPOLINE_FLAGS],
+        [AC_MSG_RESULT([no])])
+    if test -n "$retpoline_cflags"; then
+        have_retpoline=yes
+    fi
+    CFLAGS="${OLD_CFLAGS}"
+    LDFLAGS="${OLD_LDFLAGS}"
+    AC_SUBST(have_retpoline)
+    AC_SUBST(retpoline_cflags)
+    AC_SUBST(retpoline_ldflags)
+  ])
