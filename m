Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B923834107F
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291324; cv=none; b=TdwxSnVIv5NhOlLmtF18boLpKJR4jLBJ2TgbS3R6sdYZFvRXjSH8wrD4Wstztn6R6Ax9ZXeyYcJvGrGXvCP1YRqJfw6h7Rk8FKGtkqqVq/1TYkuZYAf7sy1wBjPuBuC161NIAZFyF7HxAriQlYCBPz9Zgr13i/8OY/ov4c401jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291324; c=relaxed/simple;
	bh=xSojRe6n2AxnKaM9+zpdDd56Ok/HazBM29z29Alih9E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gYyigy2MwbnhguZAD1YMU8mQfBXkwLaWj0OWeDE5aupNQ5QOFFenw1HWjdJM/Xc3V9PI2equj0BUcwHVPgICeSHD0cGlBQVT8GAA8P4RadUZ6uYJIMcPjTgnfTbxS1BrJAGxE8dj+Ojoo+XpYF1QcLdfvD9WE7pYpGT3PhVYBkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IvjgVSti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IvjgVSti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA15C2BC9E;
	Mon, 23 Mar 2026 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291324;
	bh=xSojRe6n2AxnKaM9+zpdDd56Ok/HazBM29z29Alih9E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IvjgVStiiUYqz8Rqqn2i9T6/Aqry25qKkwz/gK92zajblZ4m4ngSXPggEuPpMziXl
	 Tg51P/Mx8yYxubGGFjkOi6q04PylqfF0uZUs415ZA7X6/wCRan24sX5IGGoesoshgZ
	 MX5PtSVKmr/Si6oBL96dU5uWUoXG2+zXFHpBjMkxGgDxz/DvVXrfQS0gz+4W/gtNPv
	 6kn7ZmRio9v/gXRcl21t65L6SLWXBvRaxf4Dq5NBbpUIKsmhQLU+swLFJblXbJUrfs
	 WCtuiUawJA2qBRcsJfcgLGjF2cRkj7gdC9M2Pjix5seQBppgTLQHWqU53n1BdSut5e
	 P53D9hy6pel4g==
Date: Mon, 23 Mar 2026 11:42:03 -0700
Subject: [PATCH 03/40] libfrog: hoist some utilities from libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429120793.2266274.13916698523913941363.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This started with a desire to move the duplicate cmn_err declarations in
libxfs into libfrog/util.h ahead of the patch that renames libxfs_priv.h
to xfs_platform.h.

Then this patch expanded in scope when I realized that there were
several other utility functions that weren't specific to xfs; those go
in libfrog.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h        |    7 --
 include/platform_defs.h |    8 ++
 include/xfs_fs_compat.h |    8 --
 libfrog/util.h          |   21 ++++++
 libxfs/libxfs_priv.h    |   17 -----
 libfrog/Makefile        |    4 +
 libfrog/util.c          |  166 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/Makefile         |    2 -
 libxfs/util.c           |  160 ---------------------------------------------
 9 files changed, 201 insertions(+), 192 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 1e0d1a48fbb698..68d1f351f70093 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -26,6 +26,7 @@
 #include "libfrog/radix-tree.h"
 #include "libfrog/bitmask.h"
 #include "libfrog/div64.h"
+#include "libfrog/util.h"
 #include "atomic.h"
 #include "spinlock.h"
 
@@ -187,12 +188,6 @@ int	libxfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
 int	libxfs_file_write(struct xfs_inode *ip, void *buf, off_t pos,
 		size_t len);
 
-/* XXX: this is messy and needs fixing */
-#ifndef __LIBXFS_INTERNAL_XFS_H__
-extern void cmn_err(int, char *, ...);
-enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
-#endif
-
 #include "xfs_ialloc.h"
 
 #include "xfs_attr_leaf.h"
diff --git a/include/platform_defs.h b/include/platform_defs.h
index 09129e0f22dcba..b2d80597a83aa4 100644
--- a/include/platform_defs.h
+++ b/include/platform_defs.h
@@ -74,6 +74,14 @@ typedef unsigned short umode_t;
 
 extern int	platform_nproc(void);
 
+/* 64-bit seconds counter that works independently of the C library time_t. */
+typedef long long int time64_t;
+
+struct timespec64 {
+	time64_t	tv_sec;			/* seconds */
+	long		tv_nsec;		/* nanoseconds */
+};
+
 #define NSEC_PER_SEC	(1000000000ULL)
 #define NSEC_PER_USEC	(1000ULL)
 
diff --git a/include/xfs_fs_compat.h b/include/xfs_fs_compat.h
index 0077f00cb94904..ccf00424b1b85a 100644
--- a/include/xfs_fs_compat.h
+++ b/include/xfs_fs_compat.h
@@ -85,14 +85,6 @@ struct xfs_extent_data {
 #define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)
 #define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_extent_data)
 
-/* 64-bit seconds counter that works independently of the C library time_t. */
-typedef long long int time64_t;
-
-struct timespec64 {
-	time64_t	tv_sec;			/* seconds */
-	long		tv_nsec;		/* nanoseconds */
-};
-
 #define U32_MAX		((uint32_t)~0U)
 #define S32_MAX		((int32_t)(U32_MAX >> 1))
 #define S32_MIN		((int32_t)(-S32_MAX - 1))
diff --git a/libfrog/util.h b/libfrog/util.h
index d1c4dd40fc926c..48df6a691a8f6d 100644
--- a/libfrog/util.h
+++ b/libfrog/util.h
@@ -7,6 +7,8 @@
 #define __LIBFROG_UTIL_H__
 
 #include <sys/types.h>
+#include <stdint.h>
+#include <stdbool.h>
 
 unsigned int	log2_roundup(unsigned int i);
 unsigned int	log2_rounddown(unsigned long long i);
@@ -18,4 +20,23 @@ unsigned int	log2_rounddown(unsigned long long i);
 
 void *memchr_inv(const void *start, int c, size_t bytes);
 
+struct timespec64;
+
+bool current_fixed_time(struct timespec64 *tv);
+bool get_deterministic_seed(uint32_t *result);
+
+#ifdef HAVE_GETRANDOM_NONBLOCK
+uint32_t get_random_u32(void);
+#else
+#define get_random_u32()	(0)
+#endif
+
+extern void cmn_err(int, char *, ...);
+enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
+
+typedef unsigned char u8;
+unsigned int hweight8(unsigned int w);
+unsigned int hweight32(unsigned int w);
+unsigned int hweight64(uint64_t w);
+
 #endif /* __LIBFROG_UTIL_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index f72f07fabdf21e..32b86b1df677c2 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -65,9 +65,6 @@
 #include "libfrog/crc32c.h"
 
 #include <sys/xattr.h>
-#ifdef HAVE_GETRANDOM_NONBLOCK
-#include <sys/random.h>
-#endif
 
 /* Zones used in libxfs allocations that aren't in shared header files */
 extern struct kmem_cache *xfs_buf_item_cache;
@@ -133,9 +130,6 @@ extern char    *progname;
 #define XFS_IGET_CREATE			0x1
 #define XFS_IGET_UNTRUSTED		0x2
 
-extern void cmn_err(int, char *, ...);
-enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
-
 #define xfs_info(mp,fmt,args...)	cmn_err(CE_CONT, _(fmt), ## args)
 #define xfs_info_ratelimited(mp,fmt,args...) cmn_err(CE_CONT, _(fmt), ## args)
 #define xfs_notice(mp,fmt,args...)	cmn_err(CE_NOTE, _(fmt), ## args)
@@ -214,12 +208,6 @@ static inline bool WARN_ON(bool expr) {
 #define percpu_counter_read_positive(x)	((*x) > 0 ? (*x) : 0)
 #define percpu_counter_sum_positive(x)	((*x) > 0 ? (*x) : 0)
 
-#ifdef HAVE_GETRANDOM_NONBLOCK
-uint32_t get_random_u32(void);
-#else
-#define get_random_u32()	(0)
-#endif
-
 #define PAGE_SIZE		getpagesize()
 extern unsigned int PAGE_SHIFT;
 
@@ -567,11 +555,6 @@ void xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *lip, int type,
 #define XFS_STATS_INC_OFF(mp, off)
 #define XFS_STATS_ADD_OFF(mp, off, val)
 
-typedef unsigned char u8;
-unsigned int hweight8(unsigned int w);
-unsigned int hweight32(unsigned int w);
-unsigned int hweight64(__u64 w);
-
 #define xfs_buf_cache_init(bch)		(0)
 #define xfs_buf_cache_destroy(bch)	((void)0)
 
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 9f405ffe347566..927bd8d0957fab 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -82,6 +82,10 @@ else
 HAVE_GETTEXT = False
 endif
 
+ifeq ($(HAVE_GETRANDOM_NONBLOCK),yes)
+LCFLAGS += -DHAVE_GETRANDOM_NONBLOCK
+endif
+
 default: ltdepend $(LTLIBRARY) $(GETTEXT_PY)
 
 crc32table.h: gen_crc32table.c crc32defs.h
diff --git a/libfrog/util.c b/libfrog/util.c
index 4e130c884c17a2..d49cf72426f6c8 100644
--- a/libfrog/util.c
+++ b/libfrog/util.c
@@ -6,6 +6,12 @@
 #include "platform_defs.h"
 #include "util.h"
 
+#ifdef HAVE_GETRANDOM_NONBLOCK
+#include <sys/random.h>
+#endif
+
+extern char *progname;
+
 /*
  * libfrog is a collection of miscellaneous userspace utilities.
  * It's a library of Funny Random Oddball Gunk <cough>.
@@ -48,3 +54,163 @@ log2_rounddown(unsigned long long i)
 	}
 	return rval;
 }
+
+/*
+ * current_fixed_time() tries to detect if SOURCE_DATE_EPOCH is in our
+ * environment, and set input timespec's timestamp to that value.
+ *
+ * Returns true on success, fail otherwise.
+ */
+bool
+current_fixed_time(
+	struct timespec64	*tv)
+{
+	/*
+	 * To avoid many getenv() we'll use an initialization static flag, so
+	 * we only read once.
+	 */
+	static bool		enabled = false;
+	static bool		read_env = false;
+	static time64_t		epoch;
+	char			*endp;
+	char			*source_date_epoch;
+
+	if (!read_env) {
+		read_env = true;
+		source_date_epoch = getenv("SOURCE_DATE_EPOCH");
+		if (source_date_epoch && source_date_epoch[0] != '\0') {
+			errno = 0;
+			epoch = strtoll(source_date_epoch, &endp, 10);
+			if (errno != 0 || *endp != '\0') {
+				fprintf(stderr,
+			"%s: SOURCE_DATE_EPOCH '%s' invalid timestamp, ignoring.\n",
+				progname, source_date_epoch);
+
+				return false;
+			}
+
+			enabled = true;
+		}
+	}
+
+	/*
+	 * This will happen only if we successfully read a valid
+	 * SOURCE_DATE_EPOCH and properly initiated the epoch value.
+	 */
+	if (read_env && enabled) {
+		tv->tv_sec = epoch;
+		tv->tv_nsec = 0;
+		return true;
+	}
+
+	/*
+	 * We initialized but had no valid SOURCE_DATE_EPOCH so we fall back
+	 * to regular behaviour.
+	 */
+	return false;
+}
+
+void
+cmn_err(int level, char *fmt, ...)
+{
+	va_list	ap;
+
+	va_start(ap, fmt);
+	vfprintf(stderr, fmt, ap);
+	fputs("\n", stderr);
+	va_end(ap);
+}
+
+unsigned int
+hweight8(unsigned int w)
+{
+	unsigned int res = w - ((w >> 1) & 0x55);
+	res = (res & 0x33) + ((res >> 2) & 0x33);
+	return (res + (res >> 4)) & 0x0F;
+}
+
+unsigned int
+hweight32(unsigned int w)
+{
+	unsigned int res = w - ((w >> 1) & 0x55555555);
+	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
+	res = (res + (res >> 4)) & 0x0F0F0F0F;
+	res = res + (res >> 8);
+	return (res + (res >> 16)) & 0x000000FF;
+}
+
+unsigned int
+hweight64(uint64_t w)
+{
+	return hweight32((unsigned int)w) +
+	       hweight32((unsigned int)(w >> 32));
+}
+
+/*
+ * get_deterministic_seed() tries to detect if DETERMINISTIC_SEED=1 is in our
+ * environment, and set our result to 0x53454544 (SEED) instead of
+ * extracting from getrandom().
+ *
+ * Returns true on success, fail otherwise.
+ */
+bool
+get_deterministic_seed(
+	uint32_t	*result)
+{
+	/*
+	 * To avoid many getenv() we'll use an initialization static flag, so
+	 * we only read once.
+	 */
+	static bool	enabled = false;
+	static bool	read_env = false;
+	static uint32_t	deterministic_seed = 0x53454544; /* SEED */
+	char		*seed_env;
+
+	if (!read_env) {
+		read_env = true;
+		seed_env = getenv("DETERMINISTIC_SEED");
+		if (seed_env && strcmp(seed_env, "1") == 0)
+			enabled = true;
+	}
+
+	/*
+	 * This will happen only if we successfully read DETERMINISTIC_SEED=1.
+	 */
+	if (read_env && enabled) {
+		*result = deterministic_seed;
+
+		return true;
+	}
+
+	/*
+	 * We initialized but had no DETERMINISTIC_SEED=1 in env so we fall
+	 * back to regular behaviour.
+	 */
+	return false;
+}
+
+#ifdef HAVE_GETRANDOM_NONBLOCK
+uint32_t
+get_random_u32(void)
+{
+	uint32_t	ret;
+	ssize_t		sz;
+
+	/*
+	 * Check for DETERMINISTIC_SEED in environment, it means we're
+	 * creating a reproducible filesystem.
+	 * If it fails, fall back to returning getrandom() like we used to do.
+	 */
+	if (get_deterministic_seed(&ret))
+		return ret;
+	/*
+	 * Try to extract a u32 of randomness from /dev/urandom.  If that
+	 * fails, fall back to returning zero like we used to do.
+	 */
+	sz = getrandom(&ret, sizeof(ret), GRND_NONBLOCK);
+	if (sz != sizeof(ret))
+		return 0;
+
+	return ret;
+}
+#endif
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 61c43529b532b6..c5e2161c33096a 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -169,7 +169,7 @@ endif
 
 FCFLAGS = -I.
 
-LTLIBS = $(LIBPTHREAD) $(LIBRT)
+LTLIBS = $(LIBPTHREAD) $(LIBRT) $(LIBFROG)
 
 # don't try linking xfs_repair with a debug libxfs.
 DEBUG = -DNDEBUG
diff --git a/libxfs/util.c b/libxfs/util.c
index 2b1c32efc4709a..14b746ec705092 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -137,61 +137,6 @@ xfs_log_calc_unit_res(
 	return unit_bytes;
 }
 
-/*
- * current_fixed_time() tries to detect if SOURCE_DATE_EPOCH is in our
- * environment, and set input timespec's timestamp to that value.
- *
- * Returns true on success, fail otherwise.
- */
-static bool
-current_fixed_time(
-	struct			timespec64 *tv)
-{
-	/*
-	 * To avoid many getenv() we'll use an initialization static flag, so
-	 * we only read once.
-	 */
-	static bool		enabled = false;
-	static bool		read_env = false;
-	static time64_t		epoch;
-	char			*endp;
-	char			*source_date_epoch;
-
-	if (!read_env) {
-		read_env = true;
-		source_date_epoch = getenv("SOURCE_DATE_EPOCH");
-		if (source_date_epoch && source_date_epoch[0] != '\0') {
-			errno = 0;
-			epoch = strtoll(source_date_epoch, &endp, 10);
-			if (errno != 0 || *endp != '\0') {
-				fprintf(stderr,
-			"%s: SOURCE_DATE_EPOCH '%s' invalid timestamp, ignoring.\n",
-				progname, source_date_epoch);
-
-				return false;
-			}
-
-			enabled = true;
-		}
-	}
-
-	/*
-	 * This will happen only if we successfully read a valid
-	 * SOURCE_DATE_EPOCH and properly initiated the epoch value.
-	 */
-	if (read_env && enabled) {
-		tv->tv_sec = epoch;
-		tv->tv_nsec = 0;
-		return true;
-	}
-
-	/*
-	 * We initialized but had no valid SOURCE_DATE_EPOCH so we fall back
-	 * to regular behaviour.
-	 */
-	return false;
-}
-
 struct timespec64
 current_time(struct inode *inode)
 {
@@ -364,17 +309,6 @@ libxfs_alloc_file_space(
 	return error;
 }
 
-void
-cmn_err(int level, char *fmt, ...)
-{
-	va_list	ap;
-
-	va_start(ap, fmt);
-	vfprintf(stderr, fmt, ap);
-	fputs("\n", stderr);
-	va_end(ap);
-}
-
 /*
  * Warnings specifically for verifier errors.  Differentiate CRC vs. invalid
  * values, and omit the stack trace unless the error level is tuned high.
@@ -513,31 +447,6 @@ libxfs_zero_extent(
 	return libxfs_device_zero(xfs_find_bdev_for_inode(ip), sector, size);
 }
 
-unsigned int
-hweight8(unsigned int w)
-{
-	unsigned int res = w - ((w >> 1) & 0x55);
-	res = (res & 0x33) + ((res >> 2) & 0x33);
-	return (res + (res >> 4)) & 0x0F;
-}
-
-unsigned int
-hweight32(unsigned int w)
-{
-	unsigned int res = w - ((w >> 1) & 0x55555555);
-	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
-	res = (res + (res >> 4)) & 0x0F0F0F0F;
-	res = res + (res >> 8);
-	return (res + (res >> 16)) & 0x000000FF;
-}
-
-unsigned int
-hweight64(__u64 w)
-{
-	return hweight32((unsigned int)w) +
-	       hweight32((unsigned int)(w >> 32));
-}
-
 /* xfs_health.c */
 
 /* Mark a per-fs metadata healed. */
@@ -579,75 +488,6 @@ void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_da_mark_sick(struct xfs_da_args *args) { }
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask) { }
 
-/*
- * get_deterministic_seed() tries to detect if DETERMINISTIC_SEED=1 is in our
- * environment, and set our result to 0x53454544 (SEED) instead of
- * extracting from getrandom().
- *
- * Returns true on success, fail otherwise.
- */
-static bool
-get_deterministic_seed(
-	uint32_t	*result)
-{
-	/*
-	 * To avoid many getenv() we'll use an initialization static flag, so
-	 * we only read once.
-	 */
-	static bool	enabled = false;
-	static bool	read_env = false;
-	static uint32_t	deterministic_seed = 0x53454544; /* SEED */
-	char		*seed_env;
-
-	if (!read_env) {
-		read_env = true;
-		seed_env = getenv("DETERMINISTIC_SEED");
-		if (seed_env && strcmp(seed_env, "1") == 0)
-			enabled = true;
-	}
-
-	/*
-	 * This will happen only if we successfully read DETERMINISTIC_SEED=1.
-	 */
-	if (read_env && enabled) {
-		*result = deterministic_seed;
-
-		return true;
-	}
-
-	/*
-	 * We initialized but had no DETERMINISTIC_SEED=1 in env so we fall
-	 * back to regular behaviour.
-	 */
-	return false;
-}
-
-#ifdef HAVE_GETRANDOM_NONBLOCK
-uint32_t
-get_random_u32(void)
-{
-	uint32_t	ret;
-	ssize_t		sz;
-
-	/*
-	 * Check for DETERMINISTIC_SEED in environment, it means we're
-	 * creating a reproducible filesystem.
-	 * If it fails, fall back to returning getrandom() like we used to do.
-	 */
-	if (get_deterministic_seed(&ret))
-		return ret;
-	/*
-	 * Try to extract a u32 of randomness from /dev/urandom.  If that
-	 * fails, fall back to returning zero like we used to do.
-	 */
-	sz = getrandom(&ret, sizeof(ret), GRND_NONBLOCK);
-	if (sz != sizeof(ret))
-		return 0;
-
-	return ret;
-}
-#endif
-
 /*
  * Write a buffer to a file on the data device.  There must not be sparse holes
  * or unwritten extents, and the blocks underneath the file range will be

