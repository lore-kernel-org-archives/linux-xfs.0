Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A2937FE2
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 05:15:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AB7EEAC00B
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 03:15:13 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id lRE8FivEAwLpTu18 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 03:15:11 -0700 (PDT)
Received: from [88.128.80.19] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZAxzy-0003hC-G1
	for xfs@oss.sgi.com; Fri, 03 Jul 2015 10:15:10 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/13] xfsprogs: move __u*/__s* typedefs to per-port headers
Date: Fri,  3 Jul 2015 12:12:17 +0200
Message-Id: <1435918341-10128-10-git-send-email-hch@lst.de>
In-Reply-To: <1435918341-10128-1-git-send-email-hch@lst.de>
References: <1435918341-10128-1-git-send-email-hch@lst.de>
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

Currently we have to install the autoconf-generated platform_defs.h
to get the defintions for these.  But they are clearly a feature
of Linux vs non-Linux platforms so move them to the per-port headers
instead.

Note: in the long run it might be a good idea to just the standard
uint*_t/int*_t types instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac               |  1 -
 include/darwin.h           |  9 +++++++++
 include/freebsd.h          |  9 +++++++++
 include/gnukfreebsd.h      |  9 +++++++++
 include/irix.h             |  9 +++++++++
 include/linux.h            |  1 +
 include/platform_defs.h.in | 14 --------------
 m4/package_types.m4        | 13 -------------
 8 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/configure.ac b/configure.ac
index fe991cc..d6d1adc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -116,7 +116,6 @@ AC_HAVE_READDIR
 
 AC_CHECK_SIZEOF([long])
 AC_CHECK_SIZEOF([char *])
-AC_TYPE_U32
 AC_TYPE_UMODE_T
 AC_MANUAL_FORMAT
 
diff --git a/include/darwin.h b/include/darwin.h
index 30f0052..abdf4e3 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -109,6 +109,15 @@ static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
 	memcpy(dst, src, sizeof(uuid_t));
 }
 
+typedef unsigned char		__u8;
+typedef signed char		__s8;
+typedef unsigned short		__u16;
+typedef signed short		__s16;
+typedef unsigned int		__u32;
+typedef signed int		__s32;
+typedef unsigned long long int	__u64;
+typedef signed long long int	__s64;
+
 #define __int8_t	int8_t
 #define __int16_t	int16_t
 #define __int32_t	int32_t
diff --git a/include/freebsd.h b/include/freebsd.h
index e59b1e8..902b940 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -53,6 +53,15 @@ typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
 
+typedef unsigned char		__u8;
+typedef signed char		__s8;
+typedef unsigned short		__u16;
+typedef signed short		__s16;
+typedef unsigned int		__u32;
+typedef signed int		__s32;
+typedef unsigned long long int	__u64;
+typedef signed long long int	__s64;
+
 #define	O_LARGEFILE	0
 
 #define HAVE_FID	1
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index b83c144..95c4c13 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -42,6 +42,15 @@ typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
 
+typedef unsigned char		__u8;
+typedef signed char		__s8;
+typedef unsigned short		__u16;
+typedef signed short		__s16;
+typedef unsigned int		__u32;
+typedef signed int		__s32;
+typedef unsigned long long int	__u64;
+typedef signed long long int	__s64;
+
 #define HAVE_FID	1
 
 static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
diff --git a/include/irix.h b/include/irix.h
index 31050c4..28564c8 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -47,6 +47,15 @@ typedef __int64_t	xfs_ino_t;
 typedef __int32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
 
+typedef unsigned char		__u8;
+typedef signed char		__s8;
+typedef unsigned short		__u16;
+typedef signed short		__s16;
+typedef unsigned int		__u32;
+typedef signed int		__s32;
+typedef unsigned long long int	__u64;
+typedef signed long long int	__s64;
+
 #define xfs_flock64	flock64
 #define xfs_flock64_t	struct flock64
 
diff --git a/include/linux.h b/include/linux.h
index 31c077a..cb6298f 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -28,6 +28,7 @@
 #include <getopt.h>
 #include <endian.h>
 #include <stdbool.h>
+#include <asm/types.h>
 
 static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
 {
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 81741c4..db6cb2e 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -36,20 +36,6 @@
 #include <limits.h>
 #include <stdbool.h>
 
-#undef HAVE___U32
-#ifdef HAVE___U32
-#include <asm/types.h>
-#else
-typedef unsigned char		__u8;
-typedef signed char		__s8;
-typedef unsigned short		__u16;
-typedef signed short		__s16;
-typedef unsigned int		__u32;
-typedef signed int		__s32;
-typedef unsigned long long int	__u64;
-typedef signed long long int	__s64;
-#endif
-
 typedef struct filldir		filldir_t;
 
 #if defined(__linux__)
diff --git a/m4/package_types.m4 b/m4/package_types.m4
index c3645bc..4aa09a5 100644
--- a/m4/package_types.m4
+++ b/m4/package_types.m4
@@ -1,16 +1,3 @@
-# 
-# Check if we have a type for __u32
-# 
-AC_DEFUN([AC_TYPE_U32],
-  [ AC_MSG_CHECKING([for __u32 ])
-    AC_TRY_COMPILE([
-#include <asm/types.h>
-#include <stdlib.h>
-#include <stddef.h>
-    ], [
-         __u32  u32;
-    ], AC_DEFINE(HAVE___U32) AC_MSG_RESULT(yes) , AC_MSG_RESULT(no))
-  ])
 #
 # Check if we have umode_t
 #
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
