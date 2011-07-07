Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67B6k6q159982 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 06:06:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F30852E56
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 04:06:45 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	wzaFEuVZq7hzmREF for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 04:06:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QemPs-00040Z-SX
	for xfs@oss.sgi.com; Thu, 07 Jul 2011 11:06:44 +0000
Message-Id: <20110707110644.847340796@bombadil.infradead.org>
Date: Thu, 07 Jul 2011 07:05:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 22/28] xfs: use generic get_unaligned_beXX helpers
References: <20110707110535.205001532@bombadil.infradead.org>
Content-Disposition: inline;
	filename=xfs-dir2-use-generic-unaligned-byteswap-macros
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Switch the shortform directory code over to use the generic
get_unaligned_beXX helpers instead of reinventing them.  As a result
kill off xfs_arch.h and move the setting of XFS_NATIVE_HOST into
xfs_linux.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2011-06-30 20:22:44.849587371 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_linux.h	2011-06-30 20:40:52.116240531 +0200
@@ -33,7 +33,6 @@
 #endif
 
 #include <xfs_types.h>
-#include <xfs_arch.h>
 
 #include <kmem.h>
 #include <mrlock.h>
@@ -88,6 +87,12 @@
 #include <xfs_buf.h>
 #include <xfs_message.h>
 
+#ifdef __BIG_ENDIAN
+#define XFS_NATIVE_HOST 1
+#else
+#undef XFS_NATIVE_HOST
+#endif
+
 /*
  * Feature macros (disable/enable)
  */
Index: xfs/fs/xfs/xfs_arch.h
===================================================================
--- xfs.orig/fs/xfs/xfs_arch.h	2011-06-30 20:21:42.116254819 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,136 +0,0 @@
-/*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_ARCH_H__
-#define __XFS_ARCH_H__
-
-#ifndef XFS_BIG_INUMS
-# error XFS_BIG_INUMS must be defined true or false
-#endif
-
-#ifdef __KERNEL__
-
-#include <asm/byteorder.h>
-
-#ifdef __BIG_ENDIAN
-#define	XFS_NATIVE_HOST	1
-#else
-#undef XFS_NATIVE_HOST
-#endif
-
-#else /* __KERNEL__ */
-
-#if __BYTE_ORDER == __BIG_ENDIAN
-#define	XFS_NATIVE_HOST	1
-#else
-#undef XFS_NATIVE_HOST
-#endif
-
-#ifdef XFS_NATIVE_HOST
-#define cpu_to_be16(val)	((__force __be16)(__u16)(val))
-#define cpu_to_be32(val)	((__force __be32)(__u32)(val))
-#define cpu_to_be64(val)	((__force __be64)(__u64)(val))
-#define be16_to_cpu(val)	((__force __u16)(__be16)(val))
-#define be32_to_cpu(val)	((__force __u32)(__be32)(val))
-#define be64_to_cpu(val)	((__force __u64)(__be64)(val))
-#else
-#define cpu_to_be16(val)	((__force __be16)__swab16((__u16)(val)))
-#define cpu_to_be32(val)	((__force __be32)__swab32((__u32)(val)))
-#define cpu_to_be64(val)	((__force __be64)__swab64((__u64)(val)))
-#define be16_to_cpu(val)	(__swab16((__force __u16)(__be16)(val)))
-#define be32_to_cpu(val)	(__swab32((__force __u32)(__be32)(val)))
-#define be64_to_cpu(val)	(__swab64((__force __u64)(__be64)(val)))
-#endif
-
-static inline void be16_add_cpu(__be16 *a, __s16 b)
-{
-	*a = cpu_to_be16(be16_to_cpu(*a) + b);
-}
-
-static inline void be32_add_cpu(__be32 *a, __s32 b)
-{
-	*a = cpu_to_be32(be32_to_cpu(*a) + b);
-}
-
-static inline void be64_add_cpu(__be64 *a, __s64 b)
-{
-	*a = cpu_to_be64(be64_to_cpu(*a) + b);
-}
-
-#endif	/* __KERNEL__ */
-
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
-#endif	/* __XFS_ARCH_H__ */
Index: xfs/fs/xfs/xfs_dir2_sf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.c	2011-06-30 20:24:26.516252776 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.c	2011-06-30 20:46:45.366236141 +0200
@@ -59,11 +59,12 @@ static void xfs_dir2_sf_toino4(xfs_da_ar
 static void xfs_dir2_sf_toino8(xfs_da_args_t *args);
 #endif /* XFS_BIG_INUMS */
 
-
 /*
  * Inode numbers in short-form directories can come in two versions,
  * either 4 bytes or 8 bytes wide.  These helpers deal with the
  * two forms transparently by looking at the headers i8count field.
+ *
+ * For 64-bit inode number the most significant byte must be zero.
  */
 static xfs_ino_t
 xfs_dir2_sf_get_ino(
@@ -71,9 +72,9 @@ xfs_dir2_sf_get_ino(
 	xfs_dir2_inou_t		*from)
 {
 	if (hdr->i8count)
-		return XFS_GET_DIR_INO8(from->i8);
+		return get_unaligned_be64(&from->i8.i) & 0x00ffffffffffffffULL;
 	else
-		return XFS_GET_DIR_INO4(from->i4);
+		return get_unaligned_be32(&from->i4.i);
 }
 
 static void
@@ -82,10 +83,12 @@ xfs_dir2_sf_put_ino(
 	xfs_dir2_inou_t		*to,
 	xfs_ino_t		ino)
 {
+	ASSERT((ino & 0xff00000000000000ULL) == 0);
+
 	if (hdr->i8count)
-		XFS_PUT_DIR_INO8(ino, to->i8);
+		put_unaligned_be64(ino, &to->i8.i);
 	else
-		XFS_PUT_DIR_INO4(ino, to->i4);
+		put_unaligned_be32(ino, &to->i4.i);
 }
 
 xfs_ino_t
Index: xfs/fs/xfs/xfs_dir2_sf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.h	2011-06-30 20:24:08.732919663 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.h	2011-06-30 20:38:37.019575543 +0200
@@ -95,13 +95,13 @@ static inline int xfs_dir2_sf_hdr_size(i
 static inline xfs_dir2_data_aoff_t
 xfs_dir2_sf_get_offset(xfs_dir2_sf_entry_t *sfep)
 {
-	return INT_GET_UNALIGNED_16_BE(&(sfep)->offset.i);
+	return get_unaligned_be16(&sfep->offset.i);
 }
 
 static inline void
 xfs_dir2_sf_put_offset(xfs_dir2_sf_entry_t *sfep, xfs_dir2_data_aoff_t off)
 {
-	INT_SET_UNALIGNED_16_BE(&(sfep)->offset.i, off);
+	put_unaligned_be16(off, &sfep->offset.i);
 }
 
 static inline int

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
