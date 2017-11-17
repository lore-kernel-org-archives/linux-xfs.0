Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47268 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751858AbdKQVCD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:02:03 -0500
Subject: [PATCH 18/27] xfs_scrub: warn about normalized Unicode name
 collisions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:01:57 -0800
Message-ID: <151095251751.4825.12970492279566773085.stgit@magnolia>
In-Reply-To: <151095240950.4825.6375172010231614655.stgit@magnolia>
References: <151095240950.4825.6375172010231614655.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Iterate all directory and xattr names to look for name collisions
amongst Unicode normalized names.  This is generally a sign of buggy
programs or malicious duplicate files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac            |    2 
 debian/control          |    2 
 include/builddefs.in    |    2 
 m4/Makefile             |    1 
 m4/package_unistring.m4 |   19 ++
 scrub/Makefile          |   12 +
 scrub/common.c          |   20 ++
 scrub/common.h          |    3 
 scrub/phase5.c          |   37 ++++
 scrub/unicrash.c        |  399 +++++++++++++++++++++++++++++++++++++++++++++++
 scrub/unicrash.h        |   49 ++++++
 scrub/xfs_scrub.c       |    2 
 12 files changed, 538 insertions(+), 10 deletions(-)
 create mode 100644 m4/package_unistring.m4
 create mode 100644 scrub/unicrash.c
 create mode 100644 scrub/unicrash.h


diff --git a/configure.ac b/configure.ac
index 58dc9e8..b96d7a7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -165,6 +165,8 @@ AC_HAVE_GETFSMAP
 AC_HAVE_MALLINFO
 AC_PACKAGE_WANT_ATTRIBUTES_H
 AC_HAVE_LIBATTR
+AC_PACKAGE_WANT_UNINORM_H
+AC_HAVE_U8NORMALIZE
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/debian/control b/debian/control
index 1ef0b97..25b8594 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
-Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17), linux-libc-dev, libattr1-dev
+Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17), linux-libc-dev, libattr1-dev, libunistring-dev
 Standards-Version: 3.9.1
 Homepage: http://xfs.org/
 
diff --git a/include/builddefs.in b/include/builddefs.in
index 7964599..e63e232 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -35,6 +35,7 @@ LIBTERMCAP = @libtermcap@
 LIBEDITLINE = @libeditline@
 LIBREADLINE = @libreadline@
 LIBBLKID = @libblkid@
+LIBUNISTRING = @libunistring@
 LIBXFS = $(TOPDIR)/libxfs/libxfs.la
 LIBFROG = $(TOPDIR)/libfrog/libfrog.la
 LIBXCMD = $(TOPDIR)/libxcmd/libxcmd.la
@@ -117,6 +118,7 @@ NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
 HAVE_GETFSMAP = @have_getfsmap@
 HAVE_MALLINFO = @have_mallinfo@
 HAVE_LIBATTR = @have_libattr@
+HAVE_U8NORMALIZE = @have_u8normalize@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/m4/Makefile b/m4/Makefile
index 100c8f5..f3a24bc 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -21,6 +21,7 @@ LSRCFILES = \
 	package_pthread.m4 \
 	package_sanitizer.m4 \
 	package_types.m4 \
+	package_unistring.m4 \
 	package_utilies.m4 \
 	package_uuiddev.m4 \
 	multilib.m4 \
diff --git a/m4/package_unistring.m4 b/m4/package_unistring.m4
new file mode 100644
index 0000000..9cbfcb0
--- /dev/null
+++ b/m4/package_unistring.m4
@@ -0,0 +1,19 @@
+AC_DEFUN([AC_PACKAGE_WANT_UNINORM_H],
+  [ AC_CHECK_HEADERS(uninorm.h)
+    if test $ac_cv_header_uninorm_h = no; then
+	AC_CHECK_HEADERS(uninorm.h,, [
+	echo
+	echo 'WARNING: could not find a valid uninorm.h header.'])
+    fi
+  ])
+
+AC_DEFUN([AC_HAVE_U8NORMALIZE],
+  [ AC_CHECK_LIB(unistring, u8_normalize,[
+	libunistring=-lunistring
+	have_u8normalize=yes
+    ],[
+	echo
+	echo 'WARNING: xfs_scrub will not be built with Unicode libraries.'])
+    AC_SUBST(libunistring)
+    AC_SUBST(have_u8normalize)
+  ])
diff --git a/scrub/Makefile b/scrub/Makefile
index d7c24a1..5642dea 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -24,6 +24,7 @@ fscounters.h \
 inodes.h \
 scrub.h \
 spacemap.h \
+unicrash.h \
 xfs_scrub.h
 
 CFILES = \
@@ -41,8 +42,8 @@ scrub.c \
 spacemap.c \
 xfs_scrub.c
 
-LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
-LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
+LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUNISTRING)
+LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG) $(LIBUNISTRING)
 LLDFLAGS = -static
 
 ifeq ($(HAVE_MALLINFO),yes)
@@ -57,9 +58,14 @@ ifeq ($(HAVE_LIBATTR),yes)
 LCFLAGS += -DHAVE_LIBATTR
 endif
 
+ifeq ($(HAVE_U8NORMALIZE),yes)
+CFILES += unicrash.c
+LCFLAGS += -DHAVE_U8NORMALIZE
+endif
+
 default: depend $(LTCOMMAND)
 
-phase5.o: $(TOPDIR)/include/builddefs
+phase5.o unicrash.o xfs.o: $(TOPDIR)/include/builddefs
 
 include $(BUILDRULES)
 
diff --git a/scrub/common.c b/scrub/common.c
index ceb80bc..5072493 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -75,6 +75,26 @@ __str_errno(
 	pthread_mutex_unlock(&ctx->lock);
 }
 
+/* Print a warning string and whatever error is stored in errno. */
+void
+__str_errno_warn(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	const char		*file,
+	int			line)
+{
+	char			buf[DESCR_BUFSZ];
+
+	pthread_mutex_lock(&ctx->lock);
+	fprintf(stderr, _("Warning: %s: %s."), descr,
+			strerror_r(errno, buf, DESCR_BUFSZ));
+	if (debug)
+		fprintf(stderr, _(" (%s line %d)"), file, line);
+	fprintf(stderr, "\n");
+	ctx->warnings_found++;
+	pthread_mutex_unlock(&ctx->lock);
+}
+
 /* Print an error string and some error text. */
 void
 __str_error(
diff --git a/scrub/common.h b/scrub/common.h
index 3bb2524..0c451cc 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -41,11 +41,14 @@ void __record_repair(struct scrub_ctx *ctx, const char *descr, const char *file,
 		int line, const char *format, ...);
 void __record_preen(struct scrub_ctx *ctx, const char *descr, const char *file,
 		int line, const char *format, ...);
+void __str_errno_warn(struct scrub_ctx *, const char *descr, const char *file,
+		      int line);
 
 #define str_errno(ctx, str)		__str_errno(ctx, str, __FILE__, __LINE__)
 #define str_error(ctx, str, ...)	__str_error(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
 #define str_warn(ctx, str, ...)		__str_warn(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
 #define str_info(ctx, str, ...)		__str_info(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define str_errno_warn(ctx, str)	__str_errno_warn(ctx, str, __FILE__, __LINE__)
 #define dbg_printf(fmt, ...)		{if (debug > 1) {printf(fmt, __VA_ARGS__);}}
 
 /* Is this debug tweak enabled? */
diff --git a/scrub/phase5.c b/scrub/phase5.c
index a248c59..ed89266 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -35,6 +35,7 @@
 #include "common.h"
 #include "inodes.h"
 #include "scrub.h"
+#include "unicrash.h"
 
 /* Phase 5: Check directory connectivity. */
 
@@ -92,8 +93,10 @@ static bool
 xfs_scrub_scan_dirents(
 	struct scrub_ctx	*ctx,
 	const char		*descr,
-	int			*fd)
+	int			*fd,
+	struct xfs_bstat	*bstat)
 {
+	struct unicrash		*uc = NULL;
 	DIR			*dir;
 	struct dirent		*dentry;
 	bool			moveon = true;
@@ -105,15 +108,24 @@ xfs_scrub_scan_dirents(
 	}
 	*fd = -1; /* closedir will close *fd for us */
 
+	moveon = unicrash_dir_init(&uc, ctx, bstat);
+	if (!moveon)
+		goto out_unicrash;
+
 	dentry = readdir(dir);
 	while (dentry) {
 		moveon = xfs_scrub_check_name(ctx, descr, _("directory"),
 				dentry->d_name);
 		if (!moveon)
 			break;
+		moveon = unicrash_check_dir_name(uc, descr, dentry);
+		if (!moveon)
+			break;
 		dentry = readdir(dir);
 	}
+	unicrash_free(uc);
 
+out_unicrash:
 	closedir(dir);
 out:
 	return moveon;
@@ -142,6 +154,7 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 	struct scrub_ctx		*ctx,
 	const char			*descr,
 	struct xfs_handle		*handle,
+	struct xfs_bstat		*bstat,
 	const struct xfs_attr_ns	*attr_ns)
 {
 	struct attrlist_cursor		cur;
@@ -149,10 +162,15 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 	char				keybuf[NAME_MAX + 1];
 	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
 	struct attrlist_ent		*ent;
+	struct unicrash			*uc;
 	bool				moveon = true;
 	int				i;
 	int				error;
 
+	moveon = unicrash_xattr_init(&uc, ctx, bstat);
+	if (!moveon)
+		return false;
+
 	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
 	memset(&cur, 0, sizeof(cur));
 	memset(keybuf, 0, NAME_MAX + 1);
@@ -168,6 +186,9 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 					_("extended attribute"), keybuf);
 			if (!moveon)
 				goto out;
+			moveon = unicrash_check_xattr_name(uc, descr, keybuf);
+			if (!moveon)
+				goto out;
 		}
 
 		if (!attrlist->al_more)
@@ -178,6 +199,7 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 	if (error && errno != ESTALE)
 		str_errno(ctx, descr);
 out:
+	unicrash_free(uc);
 	return moveon;
 }
 
@@ -189,14 +211,15 @@ static bool
 xfs_scrub_scan_fhandle_xattrs(
 	struct scrub_ctx		*ctx,
 	const char			*descr,
-	struct xfs_handle		*handle)
+	struct xfs_handle		*handle,
+	struct xfs_bstat		*bstat)
 {
 	const struct xfs_attr_ns	*ns;
 	bool				moveon = true;
 
 	for (ns = attr_ns; ns->name; ns++) {
 		moveon = xfs_scrub_scan_fhandle_namespace_xattrs(ctx, descr,
-				handle, ns);
+				handle, bstat, ns);
 		if (!moveon)
 			break;
 	}
@@ -217,6 +240,8 @@ xfs_scrub_scan_fhandle_xattrs(
  * Verify the connectivity of the directory tree.
  * We know that the kernel's open-by-handle function will try to reconnect
  * parents of an opened directory, so we'll accept that as sufficient.
+ *
+ * Check for potential Unicode collisions in names.
  */
 static int
 xfs_scrub_connections(
@@ -226,7 +251,7 @@ xfs_scrub_connections(
 	void			*arg)
 {
 	char			descr[DESCR_BUFSZ];
-	bool			moveon = true;
+	bool			moveon;
 	xfs_agnumber_t		agno;
 	xfs_agino_t		agino;
 	int			fd = -1;
@@ -239,7 +264,7 @@ xfs_scrub_connections(
 	background_sleep();
 
         /* Warn about naming problems in xattrs. */
-        moveon = xfs_scrub_scan_fhandle_xattrs(ctx, descr, handle);
+        moveon = xfs_scrub_scan_fhandle_xattrs(ctx, descr, handle, bstat);
         if (!moveon)
                 goto out;
 
@@ -256,7 +281,7 @@ xfs_scrub_connections(
 
         /* Warn about naming problems in the directory entries. */
         if (fd >= 0 && S_ISDIR(bstat->bs_mode)) {
-                moveon = xfs_scrub_scan_dirents(ctx, descr, &fd);
+                moveon = xfs_scrub_scan_dirents(ctx, descr, &fd, bstat);
                 if (!moveon)
                         goto out;
         }
diff --git a/scrub/unicrash.c b/scrub/unicrash.c
new file mode 100644
index 0000000..35d3b56
--- /dev/null
+++ b/scrub/unicrash.c
@@ -0,0 +1,399 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include <stdio.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <stdlib.h>
+#include <dirent.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/statvfs.h>
+#include <unistr.h>
+#include <uninorm.h>
+#include "xfs.h"
+#include "path.h"
+#include "xfs_scrub.h"
+#include "common.h"
+
+/*
+ * Detect collisions of Unicode-normalized names.
+ *
+ * Record all the name->ino mappings in a directory/xattr, with a twist!
+ * The twist is that we perform unicode normalization on every name we
+ * see, so that we can warn about a directory containing more than one
+ * directory entries that normalize to the same Unicode string.  These
+ * entries are at best a sign of Unicode mishandling, or some sort of
+ * weird name substitution attack if the entries do not point to the
+ * same inode.  Warn if we see multiple dirents that do not all point to
+ * the same inode.
+ *
+ * For extended attributes we perform the same collision checks on the
+ * attribute, though any collision is enough to trigger a warning.
+ *
+ * We flag these collisions as warnings and not errors because XFS
+ * treats names as a sequence of arbitrary nonzero bytes.  While a
+ * Unicode collision is not technically a filesystem corruption, we
+ * ought to say something if there's a possibility for misleading a
+ * user.
+ *
+ * To normalize, we use Unicode NFKC.  We use the composing
+ * normalization mode (e.g. "E WITH ACUTE" instead of "E" then "ACUTE")
+ * because that's what W3C (and in general Linux) uses.  This enables us
+ * to detect multiple object names that normalize to the same name and
+ * could be confusing to users.  Furthermore, we use the compatibility
+ * mode to detect names with compatible but different code points to
+ * strengthen those checks.
+ */
+
+struct name_entry {
+	struct name_entry	*next;
+	xfs_ino_t		ino;
+	size_t			uninamelen;
+	uint8_t			uniname[0];
+};
+#define NAME_ENTRY_SZ(nl)	(sizeof(struct name_entry) + 1 + \
+				 (nl * sizeof(uint8_t)))
+
+struct unicrash {
+	struct scrub_ctx	*ctx;
+	bool			compare_ino;
+	size_t			nr_buckets;
+	struct name_entry	*buckets[0];
+};
+#define UNICRASH_SZ(nr)		(sizeof(struct unicrash) + \
+				 (nr * sizeof(struct name_entry *)))
+
+/*
+ * We only care about validating utf8 collisions if the underlying
+ * system configuration says we're using utf8.  If the language
+ * specifier string used to output messages has ".UTF-8" somewhere in
+ * its name, then we conclude utf8 is in use.  Otherwise, no checking is
+ * performed.
+ *
+ * Most modern Linux systems default to utf8, so the only time this
+ * check will return false is if the administrator configured things
+ * this way or if things are so messed up there is no locale data at
+ * all.
+ */
+#define UTF8_STR		".UTF-8"
+#define UTF8_STRLEN		(sizeof(UTF8_STR) - 1)
+static bool
+is_utf8_locale(void)
+{
+	const char		*msg_locale;
+	static int		answer = -1;
+
+	if (answer != -1)
+		return answer;
+
+	msg_locale = setlocale(LC_MESSAGES, NULL);
+	if (msg_locale == NULL)
+		return false;
+
+	if (strstr(msg_locale, UTF8_STR) != NULL)
+		answer = 1;
+	else
+		answer = 0;
+	return answer;
+}
+
+/* Set up unicrash global state. */
+void
+unicrash_setup(void)
+{
+	is_utf8_locale();
+}
+
+/* Initialize the collision detector. */
+static bool
+unicrash_init(
+	struct unicrash		**ucp,
+	struct scrub_ctx	*ctx,
+	bool			compare_ino,
+	size_t			nr_buckets)
+{
+	struct unicrash		*p;
+
+	if (!is_utf8_locale()) {
+		*ucp = NULL;
+		return true;
+	}
+
+	if (nr_buckets > 65536)
+		nr_buckets = 65536;
+	else if (nr_buckets < 16)
+		nr_buckets = 16;
+
+	p = calloc(1, UNICRASH_SZ(nr_buckets));
+	if (!p)
+		return false;
+	p->ctx = ctx;
+	p->nr_buckets = nr_buckets;
+	p->compare_ino = compare_ino;
+	*ucp = p;
+
+	return true;
+}
+
+/* Initialize the collision detector for a directory. */
+bool
+unicrash_dir_init(
+	struct unicrash		**ucp,
+	struct scrub_ctx	*ctx,
+	struct xfs_bstat	*bstat)
+{
+	/*
+	 * Assume 64 bytes per dentry, clamp buckets between 16 and 64k.
+	 * Same general idea as dir_hash_init in xfs_repair.
+	 */
+	return unicrash_init(ucp, ctx, true, bstat->bs_size / 64);
+}
+
+/* Initialize the collision detector for an extended attribute. */
+bool
+unicrash_xattr_init(
+	struct unicrash		**ucp,
+	struct scrub_ctx	*ctx,
+	struct xfs_bstat	*bstat)
+{
+	/* Assume 16 attributes per extent for lack of a better idea. */
+	return unicrash_init(ucp, ctx, false, 16 * (1 + bstat->bs_aextents));
+}
+
+/* Free the crash detector. */
+void
+unicrash_free(
+	struct unicrash		*uc)
+{
+	struct name_entry	*ne;
+	struct name_entry	*x;
+	size_t			i;
+
+	if (!uc)
+		return;
+
+	for (i = 0; i < uc->nr_buckets; i++) {
+		for (ne = uc->buckets[i]; ne != NULL; ne = x) {
+			x = ne->next;
+			free(ne);
+		}
+	}
+	free(uc);
+}
+
+/* Steal the dirhash function from libxfs, avoid linking with libxfs. */
+
+#define rol32(x, y)		(((x) << (y)) | ((x) >> (32 - (y))))
+
+/*
+ * Implement a simple hash on a character string.
+ * Rotate the hash value by 7 bits, then XOR each character in.
+ * This is implemented with some source-level loop unrolling.
+ */
+static xfs_dahash_t
+unicrash_hashname(
+	const uint8_t		*name,
+	size_t			namelen)
+{
+	xfs_dahash_t		hash;
+
+	/*
+	 * Do four characters at a time as long as we can.
+	 */
+	for (hash = 0; namelen >= 4; namelen -= 4, name += 4)
+		hash = (name[0] << 21) ^ (name[1] << 14) ^ (name[2] << 7) ^
+		       (name[3] << 0) ^ rol32(hash, 7 * 4);
+
+	/*
+	 * Now do the rest of the characters.
+	 */
+	switch (namelen) {
+	case 3:
+		return (name[0] << 14) ^ (name[1] << 7) ^ (name[2] << 0) ^
+		       rol32(hash, 7 * 3);
+	case 2:
+		return (name[0] << 7) ^ (name[1] << 0) ^ rol32(hash, 7 * 2);
+	case 1:
+		return (name[0] << 0) ^ rol32(hash, 7 * 1);
+	default: /* case 0: */
+		return hash;
+	}
+}
+
+/*
+ * Normalize a name according to Unicode NFKC normalization rules.
+ * Returns true if the name was already normalized.
+ */
+static bool
+unicrash_normalize(
+	const char		*in,
+	uint8_t			*out,
+	size_t			outlen)
+{
+	size_t			inlen = strlen(in);
+
+	assert(inlen <= outlen);
+	if (!u8_normalize(UNINORM_NFKC, (const uint8_t *)in, inlen,
+			out, &outlen)) {
+		/* Didn't normalize, just return the same buffer. */
+		memcpy(out, in, inlen + 1);
+		return true;
+	}
+	out[outlen] = 0;
+	return outlen == inlen ? memcmp(in, out, inlen) == 0 : false;
+}
+
+/* Complain about Unicode problems. */
+static void
+unicrash_complain(
+	struct unicrash		*uc,
+	const char		*descr,
+	const char		*what,
+	bool			normal,
+	bool			unique,
+	const char		*name,
+	uint8_t			*uniname)
+{
+	char			*bad1 = NULL;
+	char			*bad2 = NULL;
+
+	bad1 = string_escape(name);
+	bad2 = string_escape((char *)uniname);
+
+	if (!normal && should_warn_about_name(uc->ctx))
+		str_info(uc->ctx, descr,
+_("Unicode name \"%s\" in %s should be normalized as \"%s\"."),
+				bad1, what, bad2);
+	if (!unique)
+		str_warn(uc->ctx, descr,
+_("Duplicate normalized Unicode name \"%s\" found in %s."),
+				bad1, what);
+
+	free(bad1);
+	free(bad2);
+}
+
+/*
+ * Try to add a name -> ino entry to the collision detector.  The name
+ * must be normalized according to Unicode NFKC normalization rules to
+ * detect byte-unique names that map to the same sequence of Unicode
+ * code points.
+ *
+ * This function returns true either if there was no previous mapping or
+ * there was a mapping that matched exactly.  It returns false if
+ * there is already a record with that name pointing to a different
+ * inode.
+ */
+static bool
+unicrash_add(
+	struct unicrash		*uc,
+	uint8_t			*uniname,
+	xfs_ino_t		ino,
+	bool			*unique)
+{
+	struct name_entry	*ne;
+	struct name_entry	*x;
+	struct name_entry	**nep;
+	size_t			uninamelen = u8_strlen(uniname);
+	size_t			bucket;
+	xfs_dahash_t		hash;
+
+	/* Do we already know about that name? */
+	hash = unicrash_hashname(uniname, uninamelen);
+	bucket = hash % uc->nr_buckets;
+	for (nep = &uc->buckets[bucket], ne = *nep; ne != NULL; ne = x) {
+		if (u8_strcmp(uniname, ne->uniname) == 0) {
+			*unique = uc->compare_ino ? ne->ino == ino : false;
+			return true;
+		}
+		nep = &ne->next;
+		x = ne->next;
+	}
+
+	/* Remember that name. */
+	x = malloc(NAME_ENTRY_SZ(uninamelen));
+	if (!x)
+		return false;
+	x->next = NULL;
+	x->ino = ino;
+	x->uninamelen = uninamelen;
+	memcpy(x->uniname, uniname, uninamelen + 1);
+	*nep = x;
+	*unique = true;
+
+	return true;
+}
+
+/* Check a name for unicode normalization problems or collisions. */
+static bool
+__unicrash_check_name(
+	struct unicrash		*uc,
+	const char		*descr,
+	const char		*namedescr,
+	const char		*name,
+	xfs_ino_t		ino)
+{
+	uint8_t			uniname[(NAME_MAX * 2) + 1];
+	bool			moveon;
+	bool			normal;
+	bool			unique;
+
+	memset(uniname, 0, (NAME_MAX * 2) + 1);
+	normal = unicrash_normalize(name, uniname, NAME_MAX * 2);
+	moveon = unicrash_add(uc, uniname, ino, &unique);
+	if (!moveon)
+		return false;
+
+	if (normal && unique)
+		return true;
+
+	unicrash_complain(uc, descr, namedescr, normal, unique, name,
+			uniname);
+	return true;
+}
+
+/* Check a directory entry for unicode normalization problems or collisions. */
+bool
+unicrash_check_dir_name(
+	struct unicrash		*uc,
+	const char		*descr,
+	struct dirent		*dentry)
+{
+	if (!uc)
+		return true;
+	return __unicrash_check_name(uc, descr, _("directory"),
+			dentry->d_name, dentry->d_ino);
+}
+
+/*
+ * Check an extended attribute name for unicode normalization problems
+ * or collisions.
+ */
+bool
+unicrash_check_xattr_name(
+	struct unicrash		*uc,
+	const char		*descr,
+	const char		*attrname)
+{
+	if (!uc)
+		return true;
+	return __unicrash_check_name(uc, descr, _("extended attribute"),
+			attrname, 0);
+}
diff --git a/scrub/unicrash.h b/scrub/unicrash.h
new file mode 100644
index 0000000..266fdd0
--- /dev/null
+++ b/scrub/unicrash.h
@@ -0,0 +1,49 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef XFS_SCRUB_UNICRASH_H_
+#define XFS_SCRUB_UNICRASH_H_
+
+struct unicrash;
+
+/* Unicode name collision detection. */
+#ifdef HAVE_U8NORMALIZE
+
+struct dirent;
+
+void unicrash_setup(void);
+bool unicrash_dir_init(struct unicrash **ucp, struct scrub_ctx *ctx,
+		struct xfs_bstat *bstat);
+bool unicrash_xattr_init(struct unicrash **ucp, struct scrub_ctx *ctx,
+		struct xfs_bstat *bstat);
+void unicrash_free(struct unicrash *uc);
+bool unicrash_check_dir_name(struct unicrash *uc, const char *descr,
+		struct dirent *dirent);
+bool unicrash_check_xattr_name(struct unicrash *uc, const char *descr,
+		const char *attrname);
+#else
+# define unicrash_setup()
+# define unicrash_dir_init(u, c, b)		(true)
+# define unicrash_xattr_init(u, c, b)		(true)
+# define unicrash_free(u)			do {(u) = (u);} while (0)
+# define unicrash_check_dir_name(u, d, n)	(true)
+# define unicrash_check_xattr_name(u, d, n)	(true)
+#endif /* HAVE_U8NORMALIZE */
+
+#endif /* XFS_SCRUB_UNICRASH_H_ */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 642f541..f224784 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -31,6 +31,7 @@
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
+#include "unicrash.h"
 
 /*
  * XFS Online Metadata Scrub (and Repair)
@@ -529,6 +530,7 @@ _("Only one of the options -n or -y may be specified.\n"));
 	if (optind != argc - 1)
 		usage();
 
+	unicrash_setup();
 	ctx.mntpoint = strdup(argv[optind]);
 
 	/* Find the mount record for the passed-in argument. */

