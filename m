Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55100 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbeCUDk0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 23:40:26 -0400
Subject: [PATCH 06/14] xfs_scrub: transition from libunistring to libicu for
 Unicode processing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Mar 2018 20:40:17 -0700
Message-ID: <152160361707.8288.15514688320499713393.stgit@magnolia>
In-Reply-To: <152160358015.8288.2700156777231657519.stgit@magnolia>
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move off of libunistring and onto libicu for Unicode name scanning.
This will make it easy to warn about unicode code points that do not
belong in identifiers (directional overrides, zero width elements) and
warn about names that could render similarly enough to cause confusion.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac            |   13 ++++++++--
 debian/control          |    2 +
 include/builddefs.in    |    6 +++-
 m4/Makefile             |    2 +
 m4/package_icu.m4       |    6 ++++
 m4/package_unistring.m4 |   19 --------------
 scrub/Makefile          |    8 +++---
 scrub/unicrash.c        |   64 ++++++++++++++++++++++++++++++++++++-----------
 scrub/unicrash.h        |    4 +--
 9 files changed, 78 insertions(+), 46 deletions(-)
 create mode 100644 m4/package_icu.m4
 delete mode 100644 m4/package_unistring.m4


diff --git a/configure.ac b/configure.ac
index 686bf78..1885c45 100644
--- a/configure.ac
+++ b/configure.ac
@@ -95,6 +95,11 @@ AC_ARG_ENABLE(lto,
 	enable_lto=probe)
 AC_SUBST(enable_lto)
 
+# Enable libicu for xfs_scrubbing of malicious unicode sequences in names
+AC_ARG_ENABLE(libicu,
+[ --enable-libicu=[yes/no]   Enable Unicode name scanning (libicu) [default=probe]],,
+	enable_libicu=probe)
+
 #
 # If the user specified a libdir ending in lib64 do not append another
 # 64 to the library names.
@@ -173,8 +178,12 @@ AC_HAVE_DEVMAPPER
 AC_HAVE_MALLINFO
 AC_PACKAGE_WANT_ATTRIBUTES_H
 AC_HAVE_LIBATTR
-AC_PACKAGE_WANT_UNINORM_H
-AC_HAVE_U8NORMALIZE
+if test "$enable_libicu" = "yes" || test "$enable_libicu" = "probe"; then
+	AC_HAVE_LIBICU
+fi
+if test "$enable_libicu" = "yes" && test "$have_libicu" != "yes"; then
+        AC_MSG_ERROR([libicu not found.])
+fi
 AC_HAVE_OPENAT
 AC_HAVE_FSTATAT
 AC_HAVE_SG_IO
diff --git a/debian/control b/debian/control
index 2937c99..f4f807b 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
-Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libunistring-dev, dh-python, pkg-config
+Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, dh-python, pkg-config
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 
diff --git a/include/builddefs.in b/include/builddefs.in
index 7a2a626..8aac06c 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -36,7 +36,6 @@ LIBEDITLINE = @libeditline@
 LIBREADLINE = @libreadline@
 LIBBLKID = @libblkid@
 LIBDEVMAPPER = @libdevmapper@
-LIBUNISTRING = @libunistring@
 LIBXFS = $(TOPDIR)/libxfs/libxfs.la
 LIBFROG = $(TOPDIR)/libfrog/libfrog.la
 LIBXCMD = $(TOPDIR)/libxcmd/libxcmd.la
@@ -122,7 +121,7 @@ HAVE_MAP_SYNC = @have_map_sync@
 HAVE_DEVMAPPER = @have_devmapper@
 HAVE_MALLINFO = @have_mallinfo@
 HAVE_LIBATTR = @have_libattr@
-HAVE_U8NORMALIZE = @have_u8normalize@
+HAVE_LIBICU = @have_libicu@
 HAVE_OPENAT = @have_openat@
 HAVE_FSTATAT = @have_fstatat@
 HAVE_SG_IO = @have_sg_io@
@@ -173,6 +172,9 @@ ifeq ($(HAVE_GETFSMAP),yes)
 PCFLAGS+= -DHAVE_GETFSMAP
 endif
 
+LIBICU_LIBS = @libicu_LIBS@
+LIBICU_CFLAGS = @libicu_CFLAGS@
+
 SANITIZER_CFLAGS += @addrsan_cflags@ @threadsan_cflags@ @ubsan_cflags@
 SANITIZER_LDFLAGS += @addrsan_ldflags@ @threadsan_ldflags@ @ubsan_ldflags@
 
diff --git a/m4/Makefile b/m4/Makefile
index a6d11e9..cf0ce60 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -23,7 +23,7 @@ LSRCFILES = \
 	package_sanitizer.m4 \
 	package_services.m4 \
 	package_types.m4 \
-	package_unistring.m4 \
+	package_icu.m4 \
 	package_utilies.m4 \
 	package_uuiddev.m4 \
 	multilib.m4 \
diff --git a/m4/package_icu.m4 b/m4/package_icu.m4
new file mode 100644
index 0000000..3ccbe0c
--- /dev/null
+++ b/m4/package_icu.m4
@@ -0,0 +1,6 @@
+AC_DEFUN([AC_HAVE_LIBICU],
+  [ PKG_CHECK_MODULES([libicu], [icu-i18n], [have_libicu=yes], [have_libicu=no])
+    AC_SUBST(have_libicu)
+    AC_SUBST(libicu_CFLAGS)
+    AC_SUBST(libicu_LIBS)
+  ])
diff --git a/m4/package_unistring.m4 b/m4/package_unistring.m4
deleted file mode 100644
index 9cbfcb0..0000000
--- a/m4/package_unistring.m4
+++ /dev/null
@@ -1,19 +0,0 @@
-AC_DEFUN([AC_PACKAGE_WANT_UNINORM_H],
-  [ AC_CHECK_HEADERS(uninorm.h)
-    if test $ac_cv_header_uninorm_h = no; then
-	AC_CHECK_HEADERS(uninorm.h,, [
-	echo
-	echo 'WARNING: could not find a valid uninorm.h header.'])
-    fi
-  ])
-
-AC_DEFUN([AC_HAVE_U8NORMALIZE],
-  [ AC_CHECK_LIB(unistring, u8_normalize,[
-	libunistring=-lunistring
-	have_u8normalize=yes
-    ],[
-	echo
-	echo 'WARNING: xfs_scrub will not be built with Unicode libraries.'])
-    AC_SUBST(libunistring)
-    AC_SUBST(have_u8normalize)
-  ])
diff --git a/scrub/Makefile b/scrub/Makefile
index 0632794..bcc05a0 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -68,8 +68,8 @@ spacemap.c \
 vfs.c \
 xfs_scrub.c
 
-LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUNISTRING) $(LIBRT)
-LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG) $(LIBUNISTRING) $(LIBRT)
+LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBICU_LIBS) $(LIBRT)
+LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static
 
 ifeq ($(HAVE_MALLINFO),yes)
@@ -84,9 +84,9 @@ ifeq ($(HAVE_LIBATTR),yes)
 LCFLAGS += -DHAVE_LIBATTR
 endif
 
-ifeq ($(HAVE_U8NORMALIZE),yes)
+ifeq ($(HAVE_LIBICU),yes)
 CFILES += unicrash.c
-LCFLAGS += -DHAVE_U8NORMALIZE
+LCFLAGS += -DHAVE_LIBICU $(LIBICU_CFLAGS)
 endif
 
 ifeq ($(HAVE_SG_IO),yes)
diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 51da32c..06ccadf 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -23,8 +23,9 @@
 #include <dirent.h>
 #include <sys/types.h>
 #include <sys/statvfs.h>
-#include <unistr.h>
-#include <uninorm.h>
+#include <strings.h>
+#include <unicode/ustring.h>
+#include <unicode/unorm2.h>
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
@@ -63,7 +64,7 @@ struct name_entry {
 	struct name_entry	*next;
 
 	/* NFKC normalized name */
-	uint8_t			*normstr;
+	UChar			*normstr;
 	size_t			normstrlen;
 
 	xfs_ino_t		ino;
@@ -77,6 +78,7 @@ struct name_entry {
 
 struct unicrash {
 	struct scrub_ctx	*ctx;
+	const UNormalizer2	*normalizer;
 	bool			compare_ino;
 	size_t			nr_buckets;
 	struct name_entry	*buckets[0];
@@ -135,23 +137,48 @@ name_entry_compute_checknames(
 	struct unicrash		*uc,
 	struct name_entry	*entry)
 {
-	uint8_t			*normstr;
-	size_t			normstrlen;
-
-	normstrlen = (entry->namelen * 2) + 1;
-	normstr = calloc(normstrlen, sizeof(uint8_t));
-	if (!normstr)
+	UChar			*normstr;
+	UChar			*unistr;
+	int32_t			normstrlen;
+	int32_t			unistrlen;
+	UErrorCode		uerr = U_ZERO_ERROR;
+
+	/* Convert bytestr to unistr for normalization */
+	u_strFromUTF8(NULL, 0, &unistrlen, entry->name, entry->namelen, &uerr);
+	if (uerr != U_BUFFER_OVERFLOW_ERROR)
 		return false;
-
-	if (!u8_normalize(UNINORM_NFKC, (const uint8_t *)entry->name,
-			entry->namelen, normstr, &normstrlen));
+	uerr = U_ZERO_ERROR;
+	unistr = calloc(unistrlen + 1, sizeof(UChar));
+	if (!unistr)
+		return false;
+	u_strFromUTF8(unistr, unistrlen, NULL, entry->name, entry->namelen,
+			&uerr);
+	if (U_FAILURE(uerr))
+		goto out_unistr;
+
+	/* Normalize the string. */
+	normstrlen = unorm2_normalize(uc->normalizer, unistr, unistrlen, NULL,
+			0, &uerr);
+	if (uerr != U_BUFFER_OVERFLOW_ERROR)
+		goto out_unistr;
+	uerr = U_ZERO_ERROR;
+	normstr = calloc(normstrlen + 1, sizeof(UChar));
+	if (!normstr)
+		goto out_unistr;
+	unorm2_normalize(uc->normalizer, unistr, unistrlen, normstr, normstrlen,
+			&uerr);
+	if (U_FAILURE(uerr))
 		goto out_normstr;
 
 	entry->normstr = normstr;
 	entry->normstrlen = normstrlen;
+	free(unistr);
 	return true;
+
 out_normstr:
 	free(normstr);
+out_unistr:
+	free(unistr);
 	return false;
 }
 
@@ -214,8 +241,8 @@ name_entry_hash(
 	size_t			namelen;
 	xfs_dahash_t		hash;
 
-	name = entry->normstr;
-	namelen = entry->normstrlen;
+	name = (uint8_t *)entry->normstr;
+	namelen = entry->normstrlen * sizeof(UChar);
 
 	/*
 	 * Do four characters at a time as long as we can.
@@ -249,6 +276,7 @@ unicrash_init(
 	size_t			nr_buckets)
 {
 	struct unicrash		*p;
+	UErrorCode		uerr = U_ZERO_ERROR;
 
 	if (!is_utf8_locale()) {
 		*ucp = NULL;
@@ -266,9 +294,15 @@ unicrash_init(
 	p->ctx = ctx;
 	p->nr_buckets = nr_buckets;
 	p->compare_ino = compare_ino;
+	p->normalizer = unorm2_getNFKCInstance(&uerr);
+	if (U_FAILURE(uerr))
+		goto out_free;
 	*ucp = p;
 
 	return true;
+out_free:
+	free(p);
+	return false;
 }
 
 /* Initialize the collision detector for a directory. */
@@ -378,7 +412,7 @@ unicrash_add(
 	while (entry != NULL) {
 		/* Same normalization? */
 		if (new_entry->normstrlen == entry->normstrlen &&
-		    !u8_strcmp(new_entry->normstr, entry->normstr) &&
+		    !u_strcmp(new_entry->normstr, entry->normstr) &&
 		    (uc->compare_ino ? entry->ino != new_entry->ino : true)) {
 			*badflags |= UNICRASH_NOT_UNIQUE;
 			*existing_entry = entry;
diff --git a/scrub/unicrash.h b/scrub/unicrash.h
index 3337319..67e70ae 100644
--- a/scrub/unicrash.h
+++ b/scrub/unicrash.h
@@ -23,7 +23,7 @@
 struct unicrash;
 
 /* Unicode name collision detection. */
-#ifdef HAVE_U8NORMALIZE
+#ifdef HAVE_LIBICU
 
 struct dirent;
 
@@ -42,6 +42,6 @@ bool unicrash_check_xattr_name(struct unicrash *uc, const char *descr,
 # define unicrash_free(u)			do {(u) = (u);} while (0)
 # define unicrash_check_dir_name(u, d, n)	(true)
 # define unicrash_check_xattr_name(u, d, n)	(true)
-#endif /* HAVE_U8NORMALIZE */
+#endif /* HAVE_LIBICU */
 
 #endif /* XFS_SCRUB_UNICRASH_H_ */

