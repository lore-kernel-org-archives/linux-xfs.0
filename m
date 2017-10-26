Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51315 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbdJZWPy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 18:15:54 -0400
Subject: [PATCH 09/10] misc: enable thread
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 26 Oct 2017 15:15:49 -0700
Message-ID: <150905614967.28563.13207982162984486911.stgit@magnolia>
In-Reply-To: <150905608689.28563.9670731739870415773.stgit@magnolia>
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>


---
 configure.ac            |   17 +++++++++++++++++
 debian/rules            |    4 ++--
 include/builddefs.in    |    4 ++--
 m4/package_sanitizer.m4 |   20 ++++++++++++++++++++
 4 files changed, 41 insertions(+), 4 deletions(-)


diff --git a/configure.ac b/configure.ac
index b101e05..947392c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -84,6 +84,12 @@ AC_ARG_ENABLE(addrsan,
 	enable_addrsan=no)
 AC_SUBST(enable_addrsan)
 
+# Enable THREADSAN; set enable_threadsan=yesdefault to enable autoprobe.
+AC_ARG_ENABLE(threadsan,
+[ --enable-threadsan=[yes/no] Enable Thread Sanitizer (THREADSAN) [default=no]],,
+	enable_threadsan=no)
+AC_SUBST(enable_threadsan)
+
 #
 # If the user specified a libdir ending in lib64 do not append another
 # 64 to the library names.
@@ -174,6 +180,17 @@ if test "$enable_addrsan" = "yes" && test "$have_addrsan" != "yes"; then
         AC_MSG_ERROR([ADDRSAN not supported by compiler.])
 fi
 
+if test "$enable_threadsan" = "yes" || test "$enable_threadsan" = "yesdefault"; then
+        AC_PACKAGE_CHECK_THREADSAN
+fi
+if test "$enable_threadsan" = "yes" && test "$have_threadsan" != "yes"; then
+        AC_MSG_ERROR([THREADSAN not supported by compiler.])
+fi
+
+if test "$have_threadsan" = "yes" && test "$have_addrsan" = "yes"; then
+        AC_MSG_WARN([ADDRSAN and THREADSAN are not known to work together.])
+fi
+
 AC_CHECK_SIZEOF([long])
 AC_CHECK_SIZEOF([char *])
 AC_TYPE_UMODE_T
diff --git a/debian/rules b/debian/rules
index 6b6f45b..f186d79 100755
--- a/debian/rules
+++ b/debian/rules
@@ -20,9 +20,9 @@ stdenv = @GZIP=-q; export GZIP;
 
 options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
 	  INSTALL_USER=root INSTALL_GROUP=root \
-	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan" ;
+	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan" ;
 diopts  = $(options) \
-	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan --disable-addrsan" ;
+	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan" ;
 checkdir = test -f debian/rules
 
 build: built
diff --git a/include/builddefs.in b/include/builddefs.in
index 7c78d4b..2df12a7 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -155,8 +155,8 @@ ifeq ($(HAVE_GETFSMAP),yes)
 PCFLAGS+= -DHAVE_GETFSMAP
 endif
 
-SANITIZER_CFLAGS += @addrsan_cflags@ @ubsan_cflags@
-SANITIZER_LDFLAGS += @addrsan_ldflags@ @ubsan_ldflags@
+SANITIZER_CFLAGS += @addrsan_cflags@ @threadsan_cflags@ @ubsan_cflags@
+SANITIZER_LDFLAGS += @addrsan_ldflags@ @threadsan_ldflags@ @ubsan_ldflags@
 
 GCFLAGS = $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
diff --git a/m4/package_sanitizer.m4 b/m4/package_sanitizer.m4
index 06031ad..41b7299 100644
--- a/m4/package_sanitizer.m4
+++ b/m4/package_sanitizer.m4
@@ -37,3 +37,23 @@ AC_DEFUN([AC_PACKAGE_CHECK_ADDRSAN],
     AC_SUBST(addrsan_cflags)
     AC_SUBST(addrsan_ldflags)
   ])
+
+AC_DEFUN([AC_PACKAGE_CHECK_THREADSAN],
+  [ AC_MSG_CHECKING([if C compiler supports THREADSAN])
+    OLD_CFLAGS="$CFLAGS"
+    OLD_LDFLAGS="$LDFLAGS"
+    THREADSAN_FLAGS="-fsanitize=thread"
+    CFLAGS="$CFLAGS $THREADSAN_FLAGS"
+    LDFLAGS="$LDFLAGS $ADRSAN_FLAGS"
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
+        [AC_MSG_RESULT([yes])]
+        [threadsan_cflags=$THREADSAN_FLAGS]
+        [threadsan_ldflags=$THREADSAN_FLAGS]
+        [have_threadsan=yes],
+        [AC_MSG_RESULT([no])])
+    CFLAGS="${OLD_CFLAGS}"
+    LDFLAGS="${OLD_LDFLAGS}"
+    AC_SUBST(have_threadsan)
+    AC_SUBST(threadsan_cflags)
+    AC_SUBST(threadsan_ldflags)
+  ])

