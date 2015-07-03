Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3099D7F81
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 05:14:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A52BFAC008
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 03:14:42 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id J4cMCmSkxsg0E7K9 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 03:14:40 -0700 (PDT)
Received: from [88.128.80.19] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZAxzT-0002SE-NN
	for xfs@oss.sgi.com; Fri, 03 Jul 2015 10:14:40 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/13] xfsprogs: remove unused macros from xfs_arch.h
Date: Fri,  3 Jul 2015 12:12:10 +0200
Message-Id: <1435918341-10128-3-git-send-email-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_arch.h | 60 ------------------------------------------------------
 1 file changed, 60 deletions(-)

diff --git a/include/xfs_arch.h b/include/xfs_arch.h
index 07026c0..903b02a 100644
--- a/include/xfs_arch.h
+++ b/include/xfs_arch.h
@@ -71,64 +71,4 @@ static inline void be64_add_cpu(__be64 *a, __s64 b)
 	*a = cpu_to_be64(be64_to_cpu(*a) + b);
 }
 
-/*
- * get and set integers from potentially unaligned locations
- */
-
-#define INT_GET_UNALIGNED_16_BE(pointer) \
-   ((__u16)((((__u8*)(pointer))[0] << 8) | (((__u8*)(pointer))[1])))
-#define INT_SET_UNALIGNED_16_BE(pointer,value) \
-    { \
-	((__u8*)(pointer))[0] = (((value) >> 8) & 0xff); \
-	((__u8*)(pointer))[1] = (((value)     ) & 0xff); \
-    }
-
-/*
- * In directories inode numbers are stored as unaligned arrays of unsigned
- * 8bit integers on disk.
- *
- * For v1 directories or v2 directories that contain inode numbers that
- * do not fit into 32bit the array has eight members, but the first member
- * is always zero:
- *
- *  |unused|48-55|40-47|32-39|24-31|16-23| 8-15| 0- 7|
- *
- * For v2 directories that only contain entries with inode numbers that fit
- * into 32bits a four-member array is used:
- *
- *  |24-31|16-23| 8-15| 0- 7|
- */ 
-
-#define XFS_GET_DIR_INO4(di) \
-	(((__u32)(di).i[0] << 24) | ((di).i[1] << 16) | ((di).i[2] << 8) | ((di).i[3]))
-
-#define XFS_PUT_DIR_INO4(from, di) \
-do { \
-	(di).i[0] = (((from) & 0xff000000ULL) >> 24); \
-	(di).i[1] = (((from) & 0x00ff0000ULL) >> 16); \
-	(di).i[2] = (((from) & 0x0000ff00ULL) >> 8); \
-	(di).i[3] = ((from) & 0x000000ffULL); \
-} while (0)
-
-#define XFS_DI_HI(di) \
-	(((__u32)(di).i[1] << 16) | ((di).i[2] << 8) | ((di).i[3]))
-#define XFS_DI_LO(di) \
-	(((__u32)(di).i[4] << 24) | ((di).i[5] << 16) | ((di).i[6] << 8) | ((di).i[7]))
-
-#define XFS_GET_DIR_INO8(di)        \
-	(((xfs_ino_t)XFS_DI_LO(di) & 0xffffffffULL) | \
-	 ((xfs_ino_t)XFS_DI_HI(di) << 32))
-
-#define XFS_PUT_DIR_INO8(from, di) \
-do { \
-	(di).i[0] = 0; \
-	(di).i[1] = (((from) & 0x00ff000000000000ULL) >> 48); \
-	(di).i[2] = (((from) & 0x0000ff0000000000ULL) >> 40); \
-	(di).i[3] = (((from) & 0x000000ff00000000ULL) >> 32); \
-	(di).i[4] = (((from) & 0x00000000ff000000ULL) >> 24); \
-	(di).i[5] = (((from) & 0x0000000000ff0000ULL) >> 16); \
-	(di).i[6] = (((from) & 0x000000000000ff00ULL) >> 8); \
-	(di).i[7] = ((from) & 0x00000000000000ffULL); \
-} while (0)
-	
 #endif	/* __XFS_ARCH_H__ */
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
