Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25690 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAJr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:09:47 -0400
Subject: [PATCH 19/22] xfs_scrub: warn about normalized Unicode name
 collisions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:09:40 -0700
Message-ID: <150180538013.18784.1118748235380084818.stgit@magnolia>
In-Reply-To: <150180525692.18784.13730590233404009267.stgit@magnolia>
References: <150180525692.18784.13730590233404009267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Iterate all directory and xattr names to look for name collisions
amongst Unicode normalized names.  This is generally a sign of buggy
programs or malicious duplicate files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac            |    4 
 debian/control          |    2 
 include/builddefs.in    |    3 
 m4/Makefile             |    1 
 m4/package_libcdev.m4   |   13 +
 m4/package_unistring.m4 |   19 ++
 scrub/Makefile          |   18 +-
 scrub/common.c          |   20 ++
 scrub/common.h          |    3 
 scrub/phase5.c          |   15 +
 scrub/unicrash.c        |  484 +++++++++++++++++++++++++++++++++++++++++++++++
 scrub/unicrash.h        |   38 ++++
 12 files changed, 616 insertions(+), 4 deletions(-)
 create mode 100644 m4/package_unistring.m4
 create mode 100644 scrub/unicrash.c
 create mode 100644 scrub/unicrash.h


diff --git a/configure.ac b/configure.ac
index 8b65cf5..91fba71 100644
--- a/configure.ac
+++ b/configure.ac
@@ -124,6 +124,9 @@ AC_PACKAGE_NEED_UUIDCOMPARE
 AC_PACKAGE_NEED_PTHREAD_H
 AC_PACKAGE_NEED_PTHREADMUTEXINIT
 
+AC_PACKAGE_WANT_UNINORM_H
+AC_PACKAGE_WANT_U8_NORMALIZE
+
 AC_HAVE_FADVISE
 AC_HAVE_MADVISE
 AC_HAVE_MINCORE
@@ -148,6 +151,7 @@ AC_HAVE_OPENAT
 AC_HAVE_FSTATAT
 AC_HAVE_SG_IO
 AC_HAVE_HDIO_GETGEO
+AC_HAVE_ATTR_ROOT
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/debian/control b/debian/control
index ad81662..c255ae6 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
-Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17), linux-libc-dev
+Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17), linux-libc-dev, libunistring-dev
 Standards-Version: 3.9.1
 Homepage: http://xfs.org/
 
diff --git a/include/builddefs.in b/include/builddefs.in
index c90c76f..2cde2dc 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -35,6 +35,8 @@ LIBTERMCAP = @libtermcap@
 LIBEDITLINE = @libeditline@
 LIBREADLINE = @libreadline@
 LIBBLKID = @libblkid@
+LIBUNISTRING = @libunistring@
+HAVE_LIBUNISTRING = @have_libunistring@
 LIBXFS = $(TOPDIR)/libxfs/libxfs.la
 LIBXCMD = $(TOPDIR)/libxcmd/libxcmd.la
 LIBXLOG = $(TOPDIR)/libxlog/libxlog.la
@@ -118,6 +120,7 @@ HAVE_OPENAT = @have_openat@
 HAVE_FSTATAT = @have_fstatat@
 HAVE_SG_IO = @have_sg_io@
 HAVE_HDIO_GETGEO = @have_hdio_getgeo@
+HAVE_ATTR_ROOT = @have_attr_root@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/m4/Makefile b/m4/Makefile
index d282f0a..8348325 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -19,6 +19,7 @@ LSRCFILES = \
 	package_libcdev.m4 \
 	package_pthread.m4 \
 	package_types.m4 \
+	package_unistring.m4 \
 	package_utilies.m4 \
 	package_uuiddev.m4 \
 	multilib.m4 \
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 8608d10..5d821f0 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -373,3 +373,16 @@ AC_DEFUN([AC_HAVE_HDIO_GETGEO],
        AC_MSG_RESULT(no))
     AC_SUBST(have_hdio_getgeo)
   ])
+
+#
+# Check if we have a ATTR_ROOT flag
+#
+AC_DEFUN([AC_HAVE_ATTR_ROOT],
+  [ AC_CHECK_DECL([ATTR_ROOT],
+       have_attr_root=yes,
+       [],
+       [#include <sys/types.h>
+        #include <attr/attributes.h>]
+       )
+    AC_SUBST(have_attr_root)
+  ])
diff --git a/m4/package_unistring.m4 b/m4/package_unistring.m4
new file mode 100644
index 0000000..9aaadfc
--- /dev/null
+++ b/m4/package_unistring.m4
@@ -0,0 +1,19 @@
+AC_DEFUN([AC_PACKAGE_WANT_UNINORM_H],
+  [ AC_CHECK_HEADERS(uninorm.h)
+    if test $ac_cv_header_uninorm_h = no; then
+	AC_CHECK_HEADERS(uninorm.h,, [
+	echo
+	echo 'WARNING: could not find a valid uninorm header.'])
+    fi
+  ])
+
+AC_DEFUN([AC_PACKAGE_WANT_U8_NORMALIZE],
+  [ AC_CHECK_LIB(unistring, u8_normalize,[
+	libunistring=-lunistring
+	have_libunistring=yes
+    ],[
+	echo
+	echo 'WARNING: xfs_scrub will not be built with Unicode libraries.'])
+    AC_SUBST(libunistring)
+    AC_SUBST(have_libunistring)
+  ])
diff --git a/scrub/Makefile b/scrub/Makefile
index a17dfa3..0fbcf6b 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -27,7 +27,8 @@ read_verify.h \
 repair.h \
 scrub.h \
 vfs.h \
-xfs.h
+xfs.h \
+unicrash.h
 
 CFILES = \
 ../libxfs/list_sort.c \
@@ -51,8 +52,8 @@ scrub.c \
 vfs.c \
 xfs.c
 
-LLDLIBS += $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD)
-LTDEPENDENCIES += $(LIBXCMD) $(LIBHANDLE)
+LLDLIBS += $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD) $(LIBUNISTRING)
+LTDEPENDENCIES += $(LIBXCMD) $(LIBHANDLE) $(LIBUNISTRING)
 LLDFLAGS = -static
 
 ifeq ($(HAVE_MALLINFO),yes)
@@ -71,8 +72,19 @@ ifeq ($(HAVE_HDIO_GETGEO),yes)
 LCFLAGS += -DHAVE_HDIO_GETGEO
 endif
 
+ifeq ($(HAVE_LIBUNISTRING),yes)
+CFILES += unicrash.c
+LCFLAGS += -DHAVE_LIBUNISTRING
+endif
+
+ifeq ($(HAVE_ATTR_ROOT),yes)
+LCFLAGS += -DHAVE_ATTR_ROOT
+endif
+
 default: depend $(LTCOMMAND)
 
+unicrash.o xfs.o: $(TOPDIR)/include/builddefs
+
 include $(BUILDRULES)
 
 install: default $(INSTALL_SCRUB)
diff --git a/scrub/common.c b/scrub/common.c
index 7ca0e78..02a8453 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -85,6 +85,26 @@ __str_errno(
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
index 2e4ff05..6251c6d 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -41,6 +41,8 @@ void __record_repair(struct scrub_ctx *ctx, const char *descr, const char *file,
 		int line, const char *format, ...);
 void __record_preen(struct scrub_ctx *ctx, const char *descr, const char *file,
 		int line, const char *format, ...);
+void __str_errno_warn(struct scrub_ctx *, const char *descr, const char *file,
+		      int line);
 
 #define str_errno(ctx, str)		__str_errno(ctx, str, __FILE__, __LINE__)
 #define str_error(ctx, str, ...)	__str_error(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
@@ -48,6 +50,7 @@ void __record_preen(struct scrub_ctx *ctx, const char *descr, const char *file,
 #define str_info(ctx, str, ...)		__str_info(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
 #define record_repair(ctx, str, ...)	__record_repair(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
 #define record_preen(ctx, str, ...)	__record_preen(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define str_errno_warn(ctx, str)	__str_errno_warn(ctx, str, __FILE__, __LINE__)
 #define dbg_printf(fmt, ...)		{if (debug > 1) {printf(fmt, __VA_ARGS__);}}
 
 /* Is this debug tweak enabled? */
diff --git a/scrub/phase5.c b/scrub/phase5.c
index e5a5835..9010a08 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -31,6 +31,7 @@
 #include "ioctl.h"
 #include "xfs_fs.h"
 #include "xfs.h"
+#include "unicrash.h"
 
 /* Phase 5: Check directory connectivity. */
 
@@ -38,6 +39,8 @@
  * Verify the connectivity of the directory tree.
  * We know that the kernel's open-by-handle function will try to reconnect
  * parents of an opened directory, so we'll accept that as sufficient.
+ *
+ * Check for potential Unicode collisions in names.
  */
 static int
 xfs_scrub_connections(
@@ -59,6 +62,11 @@ xfs_scrub_connections(
 			agno, agino);
 	background_sleep();
 
+	/* Warn about Unicode normalization problems in xattrs. */
+	moveon = unicrash_scan_fh_xattrs(ctx, descr, handle, bstat);
+	if (!moveon)
+		goto out;
+
 	/* Open the dir, let the kernel try to reconnect it to the root. */
 	if (S_ISDIR(bstat->bs_mode)) {
 		fd = xfs_open_handle(handle);
@@ -70,6 +78,13 @@ xfs_scrub_connections(
 		}
 	}
 
+	/* Warn about Unicode normalization problems in dirents. */
+	if (fd >= 0 && S_ISDIR(bstat->bs_mode)) {
+		moveon = unicrash_scan_dir(ctx, descr, fd, bstat->bs_size);
+		if (!moveon)
+			goto out;
+	}
+
 out:
 	if (fd >= 0)
 		close(fd);
diff --git a/scrub/unicrash.c b/scrub/unicrash.c
new file mode 100644
index 0000000..dfa8a0c
--- /dev/null
+++ b/scrub/unicrash.c
@@ -0,0 +1,484 @@
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
+#include "libxfs.h"
+#include <dirent.h>
+#include <sys/statvfs.h>
+#include <sys/types.h>
+#ifdef HAVE_ATTR_ROOT
+# include <attr/attributes.h>
+#endif
+#include <unistr.h>
+#include <uninorm.h>
+#include "disk.h"
+#include "../repair/threads.h"
+#include "handle.h"
+#include "path.h"
+#include "read_verify.h"
+#include "bitmap.h"
+#include "vfs.h"
+#include "scrub.h"
+#include "common.h"
+#include "unicrash.h"
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
+	size_t			namelen;
+	uint8_t			name[0];
+};
+#define NAME_ENTRY_SZ(nl)	(sizeof(struct name_entry) + 1 + \
+				 (nl * sizeof(uint8_t)))
+
+struct unicrash {
+	bool			compare_ino;
+	size_t			nr_buckets;
+	struct name_entry	*buckets[0];
+};
+#define UNICRASH_SZ(nr)		(sizeof(struct unicrash) + \
+				 (nr * sizeof(struct name_entry)))
+
+/* Initialize the crash detector. */
+static struct unicrash *
+unicrash_init(
+	bool			compare_ino,
+	size_t			nr_buckets)
+{
+	struct unicrash		*p;
+
+	assert(nr_buckets > 0);
+	p = calloc(1, UNICRASH_SZ(nr_buckets));
+	if (!p)
+		return NULL;
+	p->nr_buckets = nr_buckets;
+	p->compare_ino = compare_ino;
+	return p;
+}
+
+/* Free the crash detector. */
+static void
+unicrash_free(
+	struct unicrash		*uc)
+{
+	struct name_entry	*ne;
+	struct name_entry	*x;
+	size_t			i;
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
+xfs_dahash_t
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
+/*
+ * Return the input string with non-printing bytes escaped.
+ * Caller must free the buffer.
+ */
+static char *
+unicrash_escape(
+	const char		*in)
+{
+	char			*str;
+	const char		*p;
+	char			*q;
+	int			x;
+
+	str = malloc(strlen(in) * 4);
+	for (p = in, q = str; *p != '\0'; p++) {
+		if (isprint(*p)) {
+			*q = *p;
+			q++;
+		} else {
+			x = sprintf(q, "\\x%02x", *p);
+			q += x;
+		}
+	}
+	*q = '\0';
+	return str;
+}
+
+/* Complain about Unicode problems. */
+#define TOO_MANY_NORM_WARNINGS	10000
+static void
+unicrash_complain(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	const char		*what,
+	bool			normal,
+	bool			unique,
+	const char		*name,
+	uint8_t			*uniname)
+{
+	static pthread_mutex_t	normlock = PTHREAD_MUTEX_INITIALIZER;
+	static unsigned int	normwarnings;
+	char			*bad1 = NULL;
+	char			*bad2 = NULL;
+
+	if (normal && unique)
+		return;
+
+	bad1 = unicrash_escape(name);
+	bad2 = unicrash_escape((char *)uniname);
+
+	if (!normal && (debug || verbose)) {
+		pthread_mutex_lock(&normlock);
+		if (normwarnings == TOO_MANY_NORM_WARNINGS) {
+			str_info(ctx, ctx->mntpoint,
+_("Filesystem has more than %u normalization warnings, shutting up."),
+					normwarnings);
+			normwarnings++;
+		} else if (normwarnings < TOO_MANY_NORM_WARNINGS) {
+			str_info(ctx, descr,
+_("Unicode name \"%s\" in %s should be normalized as \"%s\"."),
+					bad1, what, bad2);
+			normwarnings++;
+		}
+		pthread_mutex_unlock(&normlock);
+	}
+	if (!unique)
+		str_warn(ctx, descr,
+_("Duplicate normalized Unicode name \"%s\" found in %s."),
+				bad1, what);
+
+	free(bad1);
+	free(bad2);
+}
+#undef TOO_MANY_NORM_WARNINGS
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
+	uint8_t			*name,
+	xfs_ino_t		ino)
+{
+	struct name_entry	*ne;
+	struct name_entry	*x;
+	struct name_entry	**nep;
+	size_t			namelen = u8_strlen(name);
+	size_t			bucket;
+	xfs_dahash_t		hash;
+
+	/* Do we already know about that name? */
+	hash = unicrash_hashname(name, namelen);
+	bucket = hash % uc->nr_buckets;
+	for (nep = &uc->buckets[bucket], ne = *nep; ne != NULL; ne = x) {
+		if (u8_strcmp(name, ne->name) == 0)
+			return uc->compare_ino ? ne->ino == ino : false;
+		nep = &ne->next;
+		x = ne->next;
+	}
+
+	/* Remember that name. */
+	x = malloc(NAME_ENTRY_SZ(namelen));
+	x->next = NULL;
+	x->ino = ino;
+	x->namelen = namelen;
+	memcpy(x->name, name, namelen + 1);
+	*nep = x;
+	return true;
+}
+
+/*
+ * Iterate a directory looking for collisions between the Unicode
+ * normalized names.
+ */
+bool
+unicrash_scan_dir(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd,
+	off_t			dirsize)
+{
+	uint8_t			buf[NAME_MAX * 2];
+	DIR			*dir;
+	struct dirent		*dentry;
+	struct unicrash		*uc;
+	size_t			buckets;
+	bool			normal;
+	bool			unique;
+	int			new_fd;
+
+	new_fd = dup(fd);
+	if (new_fd < 0) {
+		str_errno_warn(ctx, descr);
+		goto out;
+	}
+
+	dir = fdopendir(new_fd);
+	if (!dir) {
+		str_errno_warn(ctx, descr);
+		goto out_close;
+	}
+	new_fd = -1;
+
+	/*
+	 * Assume 64 bytes per dentry, clamp buckets between 16 and 64k.
+	 * Same general idea as dir_hash_init in xfs_repair.
+	 */
+	buckets = dirsize / 64;
+	if (buckets > 65536)
+		buckets = 65536;
+	else if (buckets < 16)
+		buckets = 16;
+
+	uc = unicrash_init(true, buckets);
+	if (!uc) {
+		str_errno_warn(ctx, descr);
+		goto out_closedir;
+	}
+
+	while ((dentry = readdir(dir))) {
+		normal = unicrash_normalize(dentry->d_name, buf, NAME_MAX * 2);
+		unique = unicrash_add(uc, buf, dentry->d_ino);
+
+		unicrash_complain(ctx, descr, _("directory"),
+				normal, unique, dentry->d_name, buf);
+	}
+
+	unicrash_free(uc);
+out_closedir:
+	closedir(dir);
+out_close:
+	if (new_fd >= 0)
+		close(new_fd);
+out:
+	return true;
+}
+
+/* Routines to scan all of an inode's xattrs for Unicode problems. */
+
+#ifdef HAVE_ATTR_ROOT
+enum xfs_xattr_ns {
+	RXT_USER	= 0,
+	RXT_ROOT,
+	RXT_TRUST,
+	RXT_SECURE,
+	RXT_MAX,
+};
+
+static const int ns_to_flag[] = {
+	[RXT_USER]	= 0,
+	[RXT_ROOT]	= ATTR_ROOT,
+	[RXT_TRUST]	= ATTR_TRUST,
+	[RXT_SECURE]	= ATTR_SECURE,
+};
+
+static const char * const ns_to_str[] = {
+	[RXT_USER]	= "user",
+	[RXT_ROOT]	= "system",
+	[RXT_TRUST]	= "trust",
+	[RXT_SECURE]	= "secure",
+};
+
+/*
+ * Check all the xattr names in a particular namespace of a file handle
+ * for Unicode normalization problems or collisions.
+ */
+static bool
+unicrash_scan_fh_ns_xattrs(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	struct xfs_handle	*handle,
+	struct xfs_bstat	*bstat,
+	enum xfs_xattr_ns	ns)
+{
+	struct attrlist_cursor	cur;
+	char			attrbuf[XFS_XATTR_LIST_MAX];
+	char			buf[NAME_MAX];
+	uint8_t			nbuf[NAME_MAX * 2];
+	struct attrlist		*attrlist = (struct attrlist *)attrbuf;
+	struct attrlist_ent	*ent;
+	struct unicrash		*uc;
+	bool			normal;
+	bool			unique;
+	int			i;
+	int			error;
+
+	/* Assume 16 buckets per attr extent will do. */
+	uc = unicrash_init(false, 16 * (1 + bstat->bs_aextents));
+	if (!uc) {
+		str_errno_warn(ctx, descr);
+		goto out;
+	}
+
+	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
+	memset(&cur, 0, sizeof(cur));
+	while ((error = attr_list_by_handle(handle, sizeof(*handle),
+			attrbuf, XFS_XATTR_LIST_MAX, ns_to_flag[ns],
+			&cur)) == 0) {
+
+		/* Examine the xattrs. */
+		for (i = 0; i < attrlist->al_count; i++) {
+			ent = ATTR_ENTRY(attrlist, i);
+			normal = unicrash_normalize(ent->a_name, nbuf,
+					NAME_MAX * 2);
+			unique = unicrash_add(uc, nbuf, 0);
+
+			snprintf(buf, NAME_MAX, "%s.%s", ns_to_str[ns],
+					ent->a_name);
+			unicrash_complain(ctx, descr, _("extended attribute"),
+					normal, unique, buf, nbuf);
+		}
+
+		if (!attrlist->al_more)
+			break;
+	}
+	/*
+	 * ATTR_TRUST doesn't currently work on Linux, and ignore
+	 * the file if the handle is now stale.
+	 */
+	if (error && ((ns == RXT_TRUST && errno == EINVAL) ||
+		      (errno == ESTALE)))
+		error = 0;
+	if (error)
+		str_errno_warn(ctx, descr);
+	unicrash_free(uc);
+out:
+	return true;
+}
+
+/*
+ * Check all the xattr names under a file handle for Unicode normalization
+ * problems or collisions.
+ */
+bool
+unicrash_scan_fh_xattrs(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	struct xfs_handle	*handle,
+	struct xfs_bstat	*bstat)
+{
+	enum xfs_xattr_ns	i;
+	bool			moveon = true;
+
+	for (i = 0; i < RXT_MAX; i++) {
+		moveon = unicrash_scan_fh_ns_xattrs(ctx, descr, handle,
+				bstat, i);
+		if (!moveon)
+			break;
+	}
+	return moveon;
+}
+#endif /* HAVE_ATTR_ROOT */
diff --git a/scrub/unicrash.h b/scrub/unicrash.h
new file mode 100644
index 0000000..9caae39
--- /dev/null
+++ b/scrub/unicrash.h
@@ -0,0 +1,38 @@
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
+/* Unicode name collision detection. */
+#ifdef HAVE_LIBUNISTRING
+bool unicrash_scan_dir(struct scrub_ctx *ctx, const char *descr, int fd,
+		off_t size);
+#else
+# define unicrash_scan_dir(c, d, f, s)		(true)
+#endif
+
+#if defined(HAVE_LIBUNISTRING) && defined(HAVE_ATTR_ROOT)
+bool unicrash_scan_fh_xattrs(struct scrub_ctx *ctx, const char *descr,
+		struct xfs_handle *handle, struct xfs_bstat *bstat);
+#else
+# define unicrash_scan_fh_xattrs(c, d, h, b)	(true)
+#endif
+
+#endif /* XFS_SCRUB_UNICRASH_H_ */

