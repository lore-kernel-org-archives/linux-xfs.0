Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44622 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161161AbeCATOH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Mar 2018 14:14:07 -0500
Subject: [PATCH 09/16] misc: enable link time optimization, if requested
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Mar 2018 11:14:00 -0800
Message-ID: <151993164084.22223.15974003091174128021.stgit@magnolia>
In-Reply-To: <151993157539.22223.6269629008244777191.stgit@magnolia>
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable link time optimization (LTO) if the builder requests it.  The
extra link optimization results in smaller binaries.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac          |   12 ++++++++++++
 debian/rules          |    4 ++--
 include/builddefs.in  |    9 +++++++++
 m4/package_libcdev.m4 |   26 ++++++++++++++++++++++++++
 4 files changed, 49 insertions(+), 2 deletions(-)


diff --git a/configure.ac b/configure.ac
index 3a0ab18..9cfc661 100644
--- a/configure.ac
+++ b/configure.ac
@@ -90,6 +90,11 @@ AC_ARG_ENABLE(threadsan,
 	enable_threadsan=no)
 AC_SUBST(enable_threadsan)
 
+AC_ARG_ENABLE(lto,
+[ --enable-lto=[yes/no]      Enable link time optimization (LTO) [default=probe]],,
+	enable_lto=probe)
+AC_SUBST(enable_lto)
+
 #
 # If the user specified a libdir ending in lib64 do not append another
 # 64 to the library names.
@@ -206,6 +211,13 @@ if test "$have_threadsan" = "yes" && test "$have_addrsan" = "yes"; then
         AC_MSG_WARN([ADDRSAN and THREADSAN are not known to work together.])
 fi
 
+if test "$enable_lto" = "yes" || test "$enable_lto" = "probe"; then
+        AC_PACKAGE_CHECK_LTO
+fi
+if test "$enable_lto" = "yes" && test "$have_lto" != "yes"; then
+        AC_MSG_ERROR([LTO not supported by compiler.])
+fi
+
 AC_CHECK_SIZEOF([long])
 AC_CHECK_SIZEOF([char *])
 AC_TYPE_UMODE_T
diff --git a/debian/rules b/debian/rules
index 4cba165..cb4fa22 100755
--- a/debian/rules
+++ b/debian/rules
@@ -20,9 +20,9 @@ stdenv = @GZIP=-q; export GZIP;
 
 options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
 	  INSTALL_USER=root INSTALL_GROUP=root \
-	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan" ;
+	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
 diopts  = $(options) \
-	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan" ;
+	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
 checkdir = test -f debian/rules
 
 build: build-arch build-indep
diff --git a/include/builddefs.in b/include/builddefs.in
index df76b2c..b0bf9f1 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -176,6 +176,15 @@ endif
 SANITIZER_CFLAGS += @addrsan_cflags@ @threadsan_cflags@ @ubsan_cflags@
 SANITIZER_LDFLAGS += @addrsan_ldflags@ @threadsan_ldflags@ @ubsan_ldflags@
 
+# Use special ar/ranlib wrappers if we have lto
+HAVE_LTO = @have_lto@
+ifeq ($(HAVE_LTO),yes)
+OPTIMIZER += @lto_cflags@
+LOADERFLAGS += @lto_ldflags@
+AR = @gcc_ar@
+RANLIB = @gcc_ranlib@
+endif
+
 GCFLAGS = $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
 	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -I$(TOPDIR)/libxfs
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 9258c27..52ddac2 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -420,3 +420,29 @@ AC_DEFUN([AC_HAVE_HDIO_GETGEO],
        AC_MSG_RESULT(no))
     AC_SUBST(have_hdio_getgeo)
   ])
+
+AC_DEFUN([AC_PACKAGE_CHECK_LTO],
+  [ AC_MSG_CHECKING([if C compiler supports LTO])
+    OLD_CFLAGS="$CFLAGS"
+    OLD_LDFLAGS="$LDFLAGS"
+    LTO_FLAGS="-flto -ffat-lto-objects"
+    CFLAGS="$CFLAGS $LTO_FLAGS"
+    LDFLAGS="$LDFLAGS $LTO_FLAGS"
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
+        [AC_MSG_RESULT([yes])]
+        [lto_cflags=$LTO_FLAGS]
+        [lto_ldflags=$LTO_FLAGS]
+        [AC_PATH_PROG(gcc_ar, gcc-ar,,)]
+        [AC_PATH_PROG(gcc_ranlib, gcc-ranlib,,)],
+        [AC_MSG_RESULT([no])])
+    if test -x "$gcc_ar" && test -x "$gcc_ranlib"; then
+        have_lto=yes
+    fi
+    CFLAGS="${OLD_CFLAGS}"
+    LDFLAGS="${OLD_LDFLAGS}"
+    AC_SUBST(gcc_ar)
+    AC_SUBST(gcc_ranlib)
+    AC_SUBST(have_lto)
+    AC_SUBST(lto_cflags)
+    AC_SUBST(lto_ldflags)
+  ])

