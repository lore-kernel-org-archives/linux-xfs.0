Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5B03A7F6C
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 07:47:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3C1D18F8049
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 05:46:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IPZXOpBZGfZSVlM2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Jul 2015 05:46:57 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 5DC82B1F88
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 12:46:56 +0000 (UTC)
Received: from jtulak-t430.brq.redhat.com (jtulak.brq.redhat.com [10.34.1.5])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id t6FCkr9p023337
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 08:46:55 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 2/2] OS X partial support
Date: Wed, 15 Jul 2015 14:46:52 +0200
Message-Id: <1436964412-12093-3-git-send-email-jtulak@redhat.com>
In-Reply-To: <1436964412-12093-1-git-send-email-jtulak@redhat.com>
References: <1436964412-12093-1-git-send-email-jtulak@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This patch introduces changes to support current OS X (10.10 Yosemite).
The previous OS X code base is about 4 years old and both OS X and
XFS changed, so there had to be done some work to make it compilable.

- Because some missing APIs in OS X (like fstab/mtab) and the
  unability to mount XFS, not all tools are compiled.
- fls (find last bit) calls were moved to platform headers,
  as OS X has a native implementation.
- xfs_db currently has only a dummy timer implementation
- Various other edits  - some API translations, some, missing
  defines.

The code compiles using Apple's clang, although it throws some
warnings. Some of them are complaints about deprecated calls, some
are false-positives and there are also some incompatible type
assignments/comparisons, so there is a place for further patches.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 Makefile              |   6 +++
 include/bitops.h      |  47 -----------------------
 include/builddefs.in  |   2 +-
 include/darwin.h      | 104 +++++++++++++++++++++++++++++++++++++++++---------
 include/freebsd.h     |  47 +++++++++++++++++++++++
 include/gnukfreebsd.h |  46 ++++++++++++++++++++++
 include/irix.h        |  46 ++++++++++++++++++++++
 include/linux.h       |  46 ++++++++++++++++++++++
 libdisk/fstype.c      |   1 +
 libhandle/Makefile    |   4 ++
 libxcmd/paths.c       |   2 +-
 libxfs/xfs_bit.h      |   4 +-
 12 files changed, 285 insertions(+), 70 deletions(-)

diff --git a/Makefile b/Makefile
index 6d6803b..2ab928b 100644
--- a/Makefile
+++ b/Makefile
@@ -48,6 +48,12 @@ LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
 TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
 		mdrestore repair rtcp m4 man doc po debian
 
+# Not every tool can work on OS X, so include only those, which has a reason.
+ifeq ($(PKG_PLATFORM),darwin)
+TOOL_SUBDIRS = copy db estimate fsck logprint mkfs quota \
+		mdrestore repair rtcp m4 man doc
+endif
+
 # include is listed last so it is processed last in clean rules.
 SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) include
 
diff --git a/include/bitops.h b/include/bitops.h
index 930f64a..c6593bd 100644
--- a/include/bitops.h
+++ b/include/bitops.h
@@ -2,53 +2,6 @@
 #define __BITOPS_H__
 
 /*
- * fls: find last bit set.
- */
-
-static inline int fls(int x)
-{
-	int r = 32;
-
-	if (!x)
-		return 0;
-	if (!(x & 0xffff0000u)) {
-		x <<= 16;
-		r -= 16;
-	}
-	if (!(x & 0xff000000u)) {
-		x <<= 8;
-		r -= 8;
-	}
-	if (!(x & 0xf0000000u)) {
-		x <<= 4;
-		r -= 4;
-	}
-	if (!(x & 0xc0000000u)) {
-		x <<= 2;
-		r -= 2;
-	}
-	if (!(x & 0x80000000u)) {
-		r -= 1;
-	}
-	return r;
-}
-
-static inline int fls64(__u64 x)
-{
-	__u32 h = x >> 32;
-	if (h)
-		return fls(h) + 32;
-	return fls(x);
-}
-
-static inline unsigned fls_long(unsigned long l)
-{
-        if (sizeof(l) == 4)
-                return fls(l);
-        return fls64(l);
-}
-
-/*
  * ffz: find first zero bit.
  * Result is undefined if no zero bit exists.
  */
diff --git a/include/builddefs.in b/include/builddefs.in
index 7e9f53d..7f939f6 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -119,7 +119,7 @@ ifeq ($(PKG_PLATFORM),gnukfreebsd)
 PCFLAGS = -D_GNU_SOURCE $(GCCFLAGS)
 endif
 ifeq ($(PKG_PLATFORM),darwin)
-PCFLAGS = -traditional-cpp $(GCCFLAGS)
+PCFLAGS = $(GCCFLAGS)
 DEPENDFLAGS = -D__APPLE__
 endif
 ifeq ($(PKG_PLATFORM),irix)
diff --git a/include/darwin.h b/include/darwin.h
index 30f0052..df47d05 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -24,11 +24,15 @@
 #include <sys/stat.h>
 #include <sys/ioctl.h>
 #include <sys/mount.h>
+#include <sys/types.h>
+#include <ftw.h>
+#include <mach/mach_time.h>
+#include <inttypes.h>
 
 #include <machine/endian.h>
-#define __BYTE_ORDER	BYTE_ORDER
-#define __BIG_ENDIAN	BIG_ENDIAN
-#define __LITTLE_ENDIAN	LITTLE_ENDIAN
+#define __BYTE_ORDER   BYTE_ORDER
+#define __BIG_ENDIAN   BIG_ENDIAN
+#define __LITTLE_ENDIAN        LITTLE_ENDIAN
 
 #include <sys/syscall.h>
 # ifndef SYS_fsctl
@@ -68,45 +72,37 @@ static __inline__ void platform_getoptreset(void)
 
 static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
 {
-	return uuid_compare(uu1, uu2, NULL);
+	return uuid_compare((const unsigned char *) uu1, (const unsigned char*) uu2);
 }
 
 static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
 {
-	uint32_t status;
-	char *s;
-	uuid_to_string(uu, &s, &status);
-	if (status == uuid_s_ok)
-		strcpy(buffer, s);
-	else buffer[0] = '\0';
-	free(s);
+	uuid_unparse(*uu, buffer);
 }
 
 static __inline__ int platform_uuid_parse(char *buffer, uuid_t *uu)
 {
-	uint32_t status;
-	uuid_from_string(buffer, uu, &status);
-	return (status == uuid_s_ok);
+	return uuid_parse(buffer, *uu);
 }
 
 static __inline__ int platform_uuid_is_null(uuid_t *uu)
 {
-	return uuid_is_nil(uu, NULL);
+	return uuid_is_null(*uu);
 }
 
 static __inline__ void platform_uuid_generate(uuid_t *uu)
 {
-	uuid_create(uu, NULL);
+	uuid_generate(*uu);
 }
 
 static __inline__ void platform_uuid_clear(uuid_t *uu)
 {
-	uuid_create_nil(uu, NULL);
+	uuid_clear(*uu);
 }
 
 static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
 {
-	memcpy(dst, src, sizeof(uuid_t));
+	uuid_copy(*dst, *src);
 }
 
 #define __int8_t	int8_t
@@ -142,11 +138,13 @@ typedef int64_t		xfs_daddr_t;
 #define O_SYNC          0
 #endif
 
-#define ENOATTR		989     /* Attribute not found */
 #define EFSCORRUPTED	990	/* Filesystem is corrupted */
 #define EFSBADCRC	991	/* Bad CRC detected */
 #define constpp		char * const *
 
+#define XATTR_SIZE_MAX 65536    /* size of an extended attribute value (64k) */
+#define XATTR_LIST_MAX 65536    /* size of extended attribute namelist (64k) */
+
 #define HAVE_FID	1
 
 static __inline__ int
@@ -155,4 +153,72 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 	return 0;
 }
 
+
+/*
+ * Dummy POSIX timer replacement
+ */
+#define CLOCK_REALTIME 1
+typedef uint64_t timer_t;
+typedef double   timer_c;
+typedef clock_id_t clockid_t;
+struct itimerspec
+  {
+    struct timespec it_interval;
+    struct timespec it_value;
+  };
+
+static inline int timer_create (clockid_t __clock_id,
+                         struct sigevent *__restrict __evp,
+                         timer_t *__restrict __timerid)
+{
+	return 0;
+}
+
+static inline int timer_settime (timer_t __timerid, int __flags,
+                          const struct itimerspec *__restrict __value,
+                          struct itimerspec *__restrict __ovalue)
+{
+	return 0;
+}
+
+static inline int timer_delete (timer_t __timerid)
+{
+	return 0;
+}
+
+static inline int timer_gettime (timer_t __timerid, struct itimerspec *__value)
+{
+	return 0;
+}
+
+/*
+ * fls: find last bit set.
+ */
+
+static inline int platform_fls(int x)
+{
+	return fls(x);
+}
+
+static inline int platform_fls64(__u64 x)
+{
+	__u32 h = x >> 32;
+	if (h)
+		return platform_fls(h) + 32;
+	return platform_fls(x);
+}
+
+static inline unsigned platform_fls_long(unsigned long l)
+{
+        if (sizeof(l) == 4)
+                return platform_fls(l);
+        return platform_fls64(l);
+}
+
+static inline int nftw64(const char *path, int (*fn)(const char *, const struct stat *ptr, int flag, struct FTW *), int depth,
+         int flags)
+{
+	return nftw(path, fn, depth, flags);
+}
+
 #endif	/* __XFS_DARWIN_H__ */
diff --git a/include/freebsd.h b/include/freebsd.h
index e59b1e8..59deb30 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -138,4 +138,51 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 	return 0;
 }
 
+/*
+ * fls: find last bit set.
+ */
+
+static inline int platform_fls(int x)
+{
+	int r = 32;
+
+	if (!x)
+		return 0;
+	if (!(x & 0xffff0000u)) {
+		x <<= 16;
+		r -= 16;
+	}
+	if (!(x & 0xff000000u)) {
+		x <<= 8;
+		r -= 8;
+	}
+	if (!(x & 0xf0000000u)) {
+		x <<= 4;
+		r -= 4;
+	}
+	if (!(x & 0xc0000000u)) {
+		x <<= 2;
+		r -= 2;
+	}
+	if (!(x & 0x80000000u)) {
+		r -= 1;
+	}
+	return r;
+}
+
+static inline int platform_fls64(__u64 x)
+{
+	__u32 h = x >> 32;
+	if (h)
+		return platform_fls(h) + 32;
+	return platform_fls(x);
+}
+
+static inline unsigned platform_fls_long(unsigned long l)
+{
+        if (sizeof(l) == 4)
+                return platform_fls(l);
+        return platform_fls64(l);
+}
+
 #endif	/* __XFS_FREEBSD_H__ */
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index f2e1bf5..8d75b6d 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -118,4 +118,50 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 	return 0;
 }
 
+/*
+ * fls: find last bit set.
+ */
+
+static inline int platform_fls(int x)
+{
+	int r = 32;
+
+	if (!x)
+		return 0;
+	if (!(x & 0xffff0000u)) {
+		x <<= 16;
+		r -= 16;
+	}
+	if (!(x & 0xff000000u)) {
+		x <<= 8;
+		r -= 8;
+	}
+	if (!(x & 0xf0000000u)) {
+		x <<= 4;
+		r -= 4;
+	}
+	if (!(x & 0xc0000000u)) {
+		x <<= 2;
+		r -= 2;
+	}
+	if (!(x & 0x80000000u)) {
+		r -= 1;
+	}
+	return r;
+}
+
+static inline int platform_fls64(__u64 x)
+{
+	__u32 h = x >> 32;
+	if (h)
+		return platform_fls(h) + 32;
+	return platform_fls(x);
+}
+
+static inline unsigned platform_fls_long(unsigned long l)
+{
+        if (sizeof(l) == 4)
+                return platform_fls(l);
+        return platform_fls64(l);
+}
 #endif	/* __XFS_KFREEBSD_H__ */
diff --git a/include/irix.h b/include/irix.h
index c7f87d7..6dc4eb2 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -414,4 +414,50 @@ static __inline__ char * strsep(char **s, const char *ct)
 
 #define	XFS_XFLAG_NODEFRAG		0x00002000
 
+/*
+ * fls: find last bit set.
+ */
+
+static inline int platform_fls(int x)
+{
+	int r = 32;
+
+	if (!x)
+		return 0;
+	if (!(x & 0xffff0000u)) {
+		x <<= 16;
+		r -= 16;
+	}
+	if (!(x & 0xff000000u)) {
+		x <<= 8;
+		r -= 8;
+	}
+	if (!(x & 0xf0000000u)) {
+		x <<= 4;
+		r -= 4;
+	}
+	if (!(x & 0xc0000000u)) {
+		x <<= 2;
+		r -= 2;
+	}
+	if (!(x & 0x80000000u)) {
+		r -= 1;
+	}
+	return r;
+}
+
+static inline int platform_fls64(__u64 x)
+{
+	__u32 h = x >> 32;
+	if (h)
+		return platform_fls(h) + 32;
+	return platform_fls(x);
+}
+
+static inline unsigned platform_fls_long(unsigned long l)
+{
+        if (sizeof(l) == 4)
+                return platform_fls(l);
+        return platform_fls64(l);
+}
 #endif	/* __XFS_IRIX_H__ */
diff --git a/include/linux.h b/include/linux.h
index 31c077a..38321ab 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -143,4 +143,50 @@ typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
 
+/*
+ * fls: find last bit set.
+ */
+
+static inline int platform_fls(int x)
+{
+	int r = 32;
+
+	if (!x)
+		return 0;
+	if (!(x & 0xffff0000u)) {
+		x <<= 16;
+		r -= 16;
+	}
+	if (!(x & 0xff000000u)) {
+		x <<= 8;
+		r -= 8;
+	}
+	if (!(x & 0xf0000000u)) {
+		x <<= 4;
+		r -= 4;
+	}
+	if (!(x & 0xc0000000u)) {
+		x <<= 2;
+		r -= 2;
+	}
+	if (!(x & 0x80000000u)) {
+		r -= 1;
+	}
+	return r;
+}
+
+static inline int platform_fls64(__u64 x)
+{
+	__u32 h = x >> 32;
+	if (h)
+		return platform_fls(h) + 32;
+	return platform_fls(x);
+}
+
+static inline unsigned platform_fls_long(unsigned long l)
+{
+        if (sizeof(l) == 4)
+                return platform_fls(l);
+        return platform_fls64(l);
+}
 #endif	/* __XFS_LINUX_H__ */
diff --git a/libdisk/fstype.c b/libdisk/fstype.c
index 548f297..c8bde34 100644
--- a/libdisk/fstype.c
+++ b/libdisk/fstype.c
@@ -22,6 +22,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/stat.h>
+#include <sys/types.h>
 #include "fstype.h"
 
 /*
diff --git a/libhandle/Makefile b/libhandle/Makefile
index 865ca22..0b5e1ad 100644
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -10,7 +10,11 @@ LT_CURRENT = 1
 LT_REVISION = 3
 LT_AGE = 0
 
+ifeq ($(PKG_PLATFORM),darwin)
+LTLDFLAGS += -Wl,libhandle.sym
+else
 LTLDFLAGS += -Wl,--version-script,libhandle.sym
+endif
 
 CFILES = handle.c jdm.c
 LSRCFILES = libhandle.sym
diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index c0b1ddb..b360617 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -364,7 +364,7 @@ fs_table_initialise_mounts(
 			continue;
 		if (!realpath(stats[i].f_mntfromname, rmntfromname))
 			continue;
-		if (!realpath(stats[i].f_mntonname, rmnttomname)))
+		if (!realpath(stats[i].f_mntonname, rmntonname))
 			continue;
 
 		if (path &&
diff --git a/libxfs/xfs_bit.h b/libxfs/xfs_bit.h
index e1649c0..f3e000c 100644
--- a/libxfs/xfs_bit.h
+++ b/libxfs/xfs_bit.h
@@ -41,13 +41,13 @@ static inline __uint64_t xfs_mask64lo(int n)
 /* Get high bit set out of 32-bit argument, -1 if none set */
 static inline int xfs_highbit32(__uint32_t v)
 {
-	return fls(v) - 1;
+	return platform_fls(v) - 1;
 }
 
 /* Get high bit set out of 64-bit argument, -1 if none set */
 static inline int xfs_highbit64(__uint64_t v)
 {
-	return fls64(v) - 1;
+	return platform_fls64(v) - 1;
 }
 
 /* Get low bit set out of 32-bit argument, -1 if none set */
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
