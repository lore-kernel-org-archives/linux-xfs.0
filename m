Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18310 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751228AbdJZWYL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 18:24:11 -0400
Date: Thu, 26 Oct 2017 15:24:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 08/10] misc: enable gcc/clang address sanitizer
Message-ID: <20171026222407.GD5483@magnolia>
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
 <150905614361.28563.9247533518481627005.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150905614361.28563.9247533518481627005.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable AddressSanitizer to look for memory usage errors if the builder
asks for it and it's available.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac            |   13 +++++++++++++
 debian/rules            |    4 ++--
 include/builddefs.in    |    4 ++--
 m4/package_sanitizer.m4 |   20 ++++++++++++++++++++
 4 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index 5838e08..764b22b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -78,6 +78,12 @@ AC_ARG_ENABLE(ubsan,
 	enable_ubsan=no)
 AC_SUBST(enable_ubsan)
 
+# Enable ADDRSAN; set enable_addrsan=probe below to enable autoprobe.
+AC_ARG_ENABLE(addrsan,
+[ --enable-addrsan=[yes/no] Enable Address Sanitizer (ADDRSAN) [default=no]],,
+	enable_addrsan=no)
+AC_SUBST(enable_addrsan)
+
 #
 # If the user specified a libdir ending in lib64 do not append another
 # 64 to the library names.
@@ -161,6 +167,13 @@ if test "$enable_ubsan" = "yes" && test "$have_ubsan" != "yes"; then
         AC_MSG_ERROR([UBSAN not supported by compiler.])
 fi
 
+if test "$enable_addrsan" = "yes" || test "$enable_addrsan" = "probe"; then
+        AC_PACKAGE_CHECK_ADDRSAN
+fi
+if test "$enable_addrsan" = "yes" && test "$have_addrsan" != "yes"; then
+        AC_MSG_ERROR([ADDRSAN not supported by compiler.])
+fi
+
 AC_CHECK_SIZEOF([long])
 AC_CHECK_SIZEOF([char *])
 AC_TYPE_UMODE_T
diff --git a/debian/rules b/debian/rules
index 9dcaf52..6b6f45b 100755
--- a/debian/rules
+++ b/debian/rules
@@ -20,9 +20,9 @@ stdenv = @GZIP=-q; export GZIP;
 
 options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
 	  INSTALL_USER=root INSTALL_GROUP=root \
-	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes --disable-ubsan" ;
+	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan" ;
 diopts  = $(options) \
-	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan" ;
+	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan --disable-addrsan" ;
 checkdir = test -f debian/rules
 
 build: built
diff --git a/include/builddefs.in b/include/builddefs.in
index 6b9d6c2..7c78d4b 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -155,8 +155,8 @@ ifeq ($(HAVE_GETFSMAP),yes)
 PCFLAGS+= -DHAVE_GETFSMAP
 endif
 
-SANITIZER_CFLAGS += @ubsan_cflags@
-SANITIZER_LDFLAGS += @ubsan_ldflags@
+SANITIZER_CFLAGS += @addrsan_cflags@ @ubsan_cflags@
+SANITIZER_LDFLAGS += @addrsan_ldflags@ @ubsan_ldflags@
 
 GCFLAGS = $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
diff --git a/m4/package_sanitizer.m4 b/m4/package_sanitizer.m4
index a6673f3..06031ad 100644
--- a/m4/package_sanitizer.m4
+++ b/m4/package_sanitizer.m4
@@ -17,3 +17,23 @@ AC_DEFUN([AC_PACKAGE_CHECK_UBSAN],
     AC_SUBST(ubsan_cflags)
     AC_SUBST(ubsan_ldflags)
   ])
+
+AC_DEFUN([AC_PACKAGE_CHECK_ADDRSAN],
+  [ AC_MSG_CHECKING([if C compiler supports ADDRSAN])
+    OLD_CFLAGS="$CFLAGS"
+    OLD_LDFLAGS="$LDFLAGS"
+    ADDRSAN_FLAGS="-fsanitize=address"
+    CFLAGS="$CFLAGS $ADDRSAN_FLAGS"
+    LDFLAGS="$LDFLAGS $ADDRSAN_FLAGS"
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
+        [AC_MSG_RESULT([yes])]
+        [addrsan_cflags=$ADDRSAN_FLAGS]
+        [addrsan_ldflags=$ADDRSAN_FLAGS]
+        [have_addrsan=yes],
+        [AC_MSG_RESULT([no])])
+    CFLAGS="${OLD_CFLAGS}"
+    LDFLAGS="${OLD_LDFLAGS}"
+    AC_SUBST(have_addrsan)
+    AC_SUBST(addrsan_cflags)
+    AC_SUBST(addrsan_ldflags)
+  ])
