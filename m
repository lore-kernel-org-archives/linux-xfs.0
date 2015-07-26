Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1E5D67F91
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 11:16:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AE54FAC005
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 09:16:55 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id h0pFTlHHFirYORzc (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 09:16:54 -0700 (PDT)
Received: from p5de57ec4.dip0.t-ipconnect.de ([93.229.126.196] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat
	Linux)) id 1ZJObd-0000RV-Io
	for xfs@oss.sgi.com; Sun, 26 Jul 2015 16:16:54 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/10] xfsprogs: move __be*/__le* types and __arch_pack to
	xfs_arch.h
Date: Sun, 26 Jul 2015 18:13:27 +0200
Message-Id: <1437927209-31354-9-git-send-email-hch@lst.de>
In-Reply-To: <1437927209-31354-1-git-send-email-hch@lst.de>
References: <1437927209-31354-1-git-send-email-hch@lst.de>
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

These are defines and typedefs only needed for the XFS on disk format,
so there is no need to have the available for every user of xfs.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/platform_defs.h.in | 23 -----------------------
 include/xfs_arch.h         | 23 +++++++++++++++++++++++
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 529c0a6..81741c4 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -50,22 +50,6 @@ typedef unsigned long long int	__u64;
 typedef signed long long int	__s64;
 #endif
 
-#ifdef __CHECKER__
-#define __bitwise		__attribute__((bitwise))
-#define __force			__attribute__((force))
-#else
-#define __bitwise
-#define __force
-#endif
-
-typedef __u16	__bitwise	__le16;
-typedef __u32	__bitwise	__le32;
-typedef __u64	__bitwise	__le64;
-
-typedef __u16	__bitwise	__be16;
-typedef __u32	__bitwise	__be32;
-typedef __u64	__bitwise	__be64;
-
 typedef struct filldir		filldir_t;
 
 #if defined(__linux__)
@@ -130,13 +114,6 @@ typedef unsigned short umode_t;
 					| (minor&IRIX_DEV_MAXMIN)))
 #define IRIX_DEV_TO_KDEVT(dev)	makedev(IRIX_DEV_MAJOR(dev),IRIX_DEV_MINOR(dev))
 
-/* ARM old ABI has some weird alignment/padding */
-#if defined(__arm__) && !defined(__ARM_EABI__)
-#define __arch_pack __attribute__((packed))
-#else
-#define __arch_pack
-#endif
-
 #ifndef min
 #define min(a,b)	(((a)<(b))?(a):(b))
 #define max(a,b)	(((a)>(b))?(a):(b))
diff --git a/include/xfs_arch.h b/include/xfs_arch.h
index 310a17e..87650f1 100644
--- a/include/xfs_arch.h
+++ b/include/xfs_arch.h
@@ -24,6 +24,22 @@
 #undef XFS_NATIVE_HOST
 #endif
 
+#ifdef __CHECKER__
+#define __bitwise		__attribute__((bitwise))
+#define __force			__attribute__((force))
+#else
+#define __bitwise
+#define __force
+#endif
+
+typedef __u16	__bitwise	__le16;
+typedef __u32	__bitwise	__le32;
+typedef __u64	__bitwise	__le64;
+
+typedef __u16	__bitwise	__be16;
+typedef __u32	__bitwise	__be32;
+typedef __u64	__bitwise	__be64;
+
 /*
  * Casts are necessary for constants, because we never know how for sure
  * how U/UL/ULL map to __u16, __u32, __u64. At least not in a portable way.
@@ -262,4 +278,11 @@ static inline void put_unaligned_be64(__uint64_t val, void *p)
 	put_unaligned_be32(val, p + 4);
 }
 
+/* ARM old ABI has some weird alignment/padding */
+#if defined(__arm__) && !defined(__ARM_EABI__)
+#define __arch_pack __attribute__((packed))
+#else
+#define __arch_pack
+#endif
+
 #endif	/* __XFS_ARCH_H__ */
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
