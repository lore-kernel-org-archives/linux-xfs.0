Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31615 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751228AbdJZWXt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 18:23:49 -0400
Date: Thu, 26 Oct 2017 15:23:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] misc: enable ubsan if the builder wants it
Message-ID: <20171026222344.GC5483@magnolia>
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
 <150905613758.28563.18393057548617924511.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150905613758.28563.18393057548617924511.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable the undefined behavior sanitizer (ubsan) if the builder requests
it and it's available.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac            |   13 +++++++++++++
 debian/rules            |    4 ++--
 include/builddefs.in    |    6 ++++--
 include/buildmacros     |    2 +-
 m4/Makefile             |    1 +
 m4/package_sanitizer.m4 |   19 +++++++++++++++++++
 6 files changed, 40 insertions(+), 5 deletions(-)
 create mode 100644 m4/package_sanitizer.m4

diff --git a/configure.ac b/configure.ac
index 4161c3b..5838e08 100644
--- a/configure.ac
+++ b/configure.ac
@@ -72,6 +72,12 @@ AC_ARG_ENABLE(librt,
 	enable_librt=yes)
 AC_SUBST(enable_librt)
 
+# Enable UBSAN; set enable_ubsan=probe below to enable autoprobe.
+AC_ARG_ENABLE(ubsan,
+[ --enable-ubsan=[yes/no] Enable Undefined Behavior Sanitizer (UBSAN) [default=no]],,
+	enable_ubsan=no)
+AC_SUBST(enable_ubsan)
+
 #
 # If the user specified a libdir ending in lib64 do not append another
 # 64 to the library names.
@@ -148,6 +154,13 @@ if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
 fi
 
+if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
+        AC_PACKAGE_CHECK_UBSAN
+fi
+if test "$enable_ubsan" = "yes" && test "$have_ubsan" != "yes"; then
+        AC_MSG_ERROR([UBSAN not supported by compiler.])
+fi
+
 AC_CHECK_SIZEOF([long])
 AC_CHECK_SIZEOF([char *])
 AC_TYPE_UMODE_T
diff --git a/debian/rules b/debian/rules
index c673380..9dcaf52 100755
--- a/debian/rules
+++ b/debian/rules
@@ -20,9 +20,9 @@ stdenv = @GZIP=-q; export GZIP;
 
 options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
 	  INSTALL_USER=root INSTALL_GROUP=root \
-	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes" ;
+	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes --disable-ubsan" ;
 diopts  = $(options) \
-	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no" ;
+	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan" ;
 checkdir = test -f debian/rules
 
 build: built
diff --git a/include/builddefs.in b/include/builddefs.in
index ec630bd..6b9d6c2 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -155,6 +155,8 @@ ifeq ($(HAVE_GETFSMAP),yes)
 PCFLAGS+= -DHAVE_GETFSMAP
 endif
 
+SANITIZER_CFLAGS += @ubsan_cflags@
+SANITIZER_LDFLAGS += @ubsan_ldflags@
 
 GCFLAGS = $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
@@ -165,8 +167,8 @@ GCFLAGS += -DENABLE_GETTEXT
 endif
 
 BUILD_CFLAGS += $(GCFLAGS) $(PCFLAGS)
-# First, Global, Platform, Local CFLAGS
-CFLAGS += $(FCFLAGS) $(OPTIMIZER) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)
+# First, Sanitizer, Global, Platform, Local CFLAGS
+CFLAGS += $(FCFLAGS) $(SANITIZER_CFLAGS) $(OPTIMIZER) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)
 
 include $(TOPDIR)/include/buildmacros
 
diff --git a/include/buildmacros b/include/buildmacros
index a7c5d8a..178e2ed 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -9,7 +9,7 @@ BUILDRULES = $(TOPDIR)/include/buildrules
 # $(CXXFILES), or $(HFILES) and is used to construct the manifest list
 # during the "dist" phase (packaging).
 
-LDFLAGS += $(LOADERFLAGS) $(LLDFLAGS)
+LDFLAGS += $(SANITIZER_LDFLAGS) $(LOADERFLAGS) $(LLDFLAGS)
 LTLDFLAGS += $(LOADERFLAGS)
 LDLIBS = $(LLDLIBS) $(PLDLIBS) $(MALLOCLIB)
 
diff --git a/m4/Makefile b/m4/Makefile
index d282f0a..4706121 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -18,6 +18,7 @@ LSRCFILES = \
 	package_globals.m4 \
 	package_libcdev.m4 \
 	package_pthread.m4 \
+	package_sanitizer.m4 \
 	package_types.m4 \
 	package_utilies.m4 \
 	package_uuiddev.m4 \
diff --git a/m4/package_sanitizer.m4 b/m4/package_sanitizer.m4
new file mode 100644
index 0000000..a6673f3
--- /dev/null
+++ b/m4/package_sanitizer.m4
@@ -0,0 +1,19 @@
+AC_DEFUN([AC_PACKAGE_CHECK_UBSAN],
+  [ AC_MSG_CHECKING([if C compiler supports UBSAN])
+    OLD_CFLAGS="$CFLAGS"
+    OLD_LDFLAGS="$LDFLAGS"
+    UBSAN_FLAGS="-fsanitize=undefined"
+    CFLAGS="$CFLAGS $UBSAN_FLAGS"
+    LDFLAGS="$LDFLAGS $UBSAN_FLAGS"
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([])],
+        [AC_MSG_RESULT([yes])]
+        [ubsan_cflags=$UBSAN_FLAGS]
+        [ubsan_ldflags=$UBSAN_FLAGS]
+        [have_ubsan=yes],
+        [AC_MSG_RESULT([no])])
+    CFLAGS="${OLD_CFLAGS}"
+    LDFLAGS="${OLD_LDFLAGS}"
+    AC_SUBST(have_ubsan)
+    AC_SUBST(ubsan_cflags)
+    AC_SUBST(ubsan_ldflags)
+  ])
