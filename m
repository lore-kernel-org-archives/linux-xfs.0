Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AKUGqx073468 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 14:30:17 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B6D7310651D
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:29:40 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oCIDr5EOAVemmQ1G for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:29:40 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LWzEi-0005mH-6o
	for xfs@oss.sgi.com; Tue, 10 Feb 2009 20:29:40 +0000
Message-Id: <20090210202939.970362000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 15:22:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/13] xfs: add support for large btree blocks
References: <20090210202241.546501000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-large-btree-blocks
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

Add support for larger btree blocks that contains a CRC32C checksum, a
filesystem uuid and block number for detecting filesystem consistency
and out of place writes.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_btree.h
===================================================================
--- xfs.orig/fs/xfs/xfs_btree.h	2009-02-09 19:05:49.005068530 +0100
+++ xfs/fs/xfs/xfs_btree.h	2009-02-09 19:15:42.836068971 +0100
@@ -47,6 +47,10 @@ extern kmem_zone_t	*xfs_btree_cur_zone;
  *
  * To get the size of the actual short or long form headers please use
  * the size macros below.  Never use sizeof(xfs_btree_block).
+ *
+ * The blkno, crc and uuid fields are only available in filesystems with
+ * the crc feature bit, and all accesses to them must be conditional on
+ * that flag.
  */
 struct xfs_btree_block {
 	__be32		bb_magic;	/* magic number for block type */
@@ -56,16 +60,32 @@ struct xfs_btree_block {
 		struct {
 			__be32		bb_leftsib;
 			__be32		bb_rightsib;
+
+			__be64		bb_blkno;
+			uuid_t		bb_uuid;
+			__be32		bb_crc;
+			__be32		bb_pad; /* padding for alignment */
 		} s;			/* short form pointers */
 		struct	{
 			__be64		bb_leftsib;
 			__be64		bb_rightsib;
+
+			__be64		bb_blkno;
+			uuid_t		bb_uuid;
+			__be32		bb_crc;
+			__be32		bb_pad; /* padding for alignment */
 		} l;			/* long form pointers */
 	} bb_u;				/* rest */
 };
 
 #define XFS_BTREE_SBLOCK_LEN	16	/* size of a short form block */
 #define XFS_BTREE_LBLOCK_LEN	24	/* size of a long form block */
+#define XFS_BTREE_CRCBLOCK_ADD	32	/* size of blkno + crc + uuid */
+
+#define XFS_BTREE_SBLOCK_CRC_OFF \
+	offsetof(struct xfs_btree_block, bb_u.s.bb_crc)
+#define XFS_BTREE_LBLOCK_CRC_OFF \
+	offsetof(struct xfs_btree_block, bb_u.l.bb_crc)
 
 
 /*
@@ -101,13 +121,11 @@ union xfs_btree_rec {
 #define	XFS_BB_NUMRECS		0x04
 #define	XFS_BB_LEFTSIB		0x08
 #define	XFS_BB_RIGHTSIB		0x10
+#define XFS_BB_BLKNO		0x20
 #define	XFS_BB_NUM_BITS		5
 #define	XFS_BB_ALL_BITS		((1 << XFS_BB_NUM_BITS) - 1)
-
-/*
- * Magic numbers for btree blocks.
- */
-extern const __uint32_t	xfs_magics[];
+#define	XFS_BB_NUM_BITS_CRC	8
+#define	XFS_BB_ALL_BITS_CRC	((1 << XFS_BB_NUM_BITS_CRC) - 1)
 
 /*
  * Generic stats interface
@@ -275,6 +293,7 @@ typedef struct xfs_btree_cur
 #define XFS_BTREE_LONG_PTRS		(1<<0)	/* pointers are 64bits long */
 #define XFS_BTREE_ROOT_IN_INODE		(1<<1)	/* root may be variable size */
 #define XFS_BTREE_LASTREC_UPDATE	(1<<2)	/* track last rec externally */
+#define XFS_BTREE_CRC_BLOCKS		(1<<3)	/* uses extended btree blocks */
 
 
 #define	XFS_BTREE_NOERROR	0
@@ -438,6 +457,12 @@ int xfs_btree_delete(struct xfs_btree_cu
 int xfs_btree_get_rec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
 
 /*
+ * CRC calculation is also needed for growfs.
+ */
+void xfs_btree_lblock_calc_crc(struct xfs_buf *);
+void xfs_btree_sblock_calc_crc(struct xfs_buf *);
+
+/*
  * Internal btree helpers also used by xfs_bmap.c.
  */
 void xfs_btree_log_block(struct xfs_btree_cur *, struct xfs_buf *, int);
Index: xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_btree.c	2009-02-09 19:05:49.009069179 +0100
+++ xfs/fs/xfs/xfs_bmap_btree.c	2009-02-09 19:15:42.838069994 +0100
@@ -77,12 +77,20 @@ xfs_bmdr_to_bmbt(
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
-	rblock->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		rblock->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
+	else
+		rblock->bb_magic = cpu_to_be32(XFS_BMAP_CRC_MAGIC);
 	rblock->bb_level = dblock->bb_level;
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
 	rblock->bb_numrecs = dblock->bb_numrecs;
 	rblock->bb_u.l.bb_leftsib = cpu_to_be64(NULLDFSBNO);
 	rblock->bb_u.l.bb_rightsib = cpu_to_be64(NULLDFSBNO);
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		rblock->bb_u.l.bb_blkno = cpu_to_be64(XFS_BUF_DADDR_NULL);
+		uuid_copy(&rblock->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid);
+		rblock->bb_u.l.bb_pad = 0;
+	}
 	dmxr = xfs_bmdr_maxrecs(mp, dblocklen, 0);
 	fkp = XFS_BMDR_KEY_ADDR(dblock, 1);
 	tkp = XFS_BMBT_KEY_ADDR(mp, rblock, 1);
@@ -441,10 +449,18 @@ xfs_bmbt_to_bmdr(
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
-	ASSERT(be32_to_cpu(rblock->bb_magic) == XFS_BMAP_MAGIC);
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		ASSERT(be32_to_cpu(rblock->bb_magic) == XFS_BMAP_CRC_MAGIC);
+	else
+		ASSERT(be32_to_cpu(rblock->bb_magic) == XFS_BMAP_MAGIC);
 	ASSERT(be64_to_cpu(rblock->bb_u.l.bb_leftsib) == NULLDFSBNO);
 	ASSERT(be64_to_cpu(rblock->bb_u.l.bb_rightsib) == NULLDFSBNO);
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		ASSERT(uuid_equal(&rblock->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid));
+		ASSERT(rblock->bb_u.l.bb_blkno ==
+		       cpu_to_be64(XFS_BUF_DADDR_NULL));
+	}
 	dblock->bb_level = rblock->bb_level;
 	dblock->bb_numrecs = rblock->bb_numrecs;
 	dmxr = xfs_bmdr_maxrecs(mp, dblocklen, 0);
@@ -886,6 +902,8 @@ xfs_bmbt_init_cursor(
 
 	cur->bc_ops = &xfs_bmbt_ops;
 	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
 	cur->bc_private.b.ip = ip;
Index: xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_btree.h	2009-02-09 19:05:49.013068710 +0100
+++ xfs/fs/xfs/xfs_bmap_btree.h	2009-02-09 19:15:42.838069994 +0100
@@ -18,7 +18,8 @@
 #ifndef __XFS_BMAP_BTREE_H__
 #define __XFS_BMAP_BTREE_H__
 
-#define XFS_BMAP_MAGIC	0x424d4150	/* 'BMAP' */
+#define XFS_BMAP_MAGIC		0x424d4150	/* 'BMAP' */
+#define XFS_BMAP_CRC_MAGIC	0x424d4158
 
 struct xfs_btree_cur;
 struct xfs_btree_block;
@@ -144,10 +145,11 @@ typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_
 
 /*
  * Btree block header size depends on a superblock flag.
- *
- * (not quite yet, but soon)
  */
-#define XFS_BMBT_BLOCK_LEN(mp)	XFS_BTREE_LBLOCK_LEN
+#define XFS_BMBT_BLOCK_LEN(mp) \
+	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+	 XFS_BTREE_LBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD : \
+	 XFS_BTREE_LBLOCK_LEN)
 
 #define XFS_BMBT_REC_ADDR(mp, block, index) \
 	((xfs_bmbt_rec_t *) \
@@ -194,12 +196,12 @@ typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_
 #define XFS_BMAP_BROOT_PTR_ADDR(mp, bb, i, sz) \
 	XFS_BMBT_PTR_ADDR(mp, bb, i, xfs_bmbt_maxrecs(mp, sz, 0))
 
-#define XFS_BMAP_BROOT_SPACE_CALC(nrecs) \
-	(int)(XFS_BTREE_LBLOCK_LEN + \
+#define XFS_BMAP_BROOT_SPACE_CALC(mp, nrecs) \
+	(int)(XFS_BMBT_BLOCK_LEN(mp) + \
 	       ((nrecs) * (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t))))
 
-#define XFS_BMAP_BROOT_SPACE(bb) \
-	(XFS_BMAP_BROOT_SPACE_CALC(be16_to_cpu((bb)->bb_numrecs)))
+#define XFS_BMAP_BROOT_SPACE(mp, bb) \
+	(XFS_BMAP_BROOT_SPACE_CALC(mp, be16_to_cpu((bb)->bb_numrecs)))
 #define XFS_BMDR_SPACE_CALC(nrecs) \
 	(int)(sizeof(xfs_bmdr_block_t) + \
 	       ((nrecs) * (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t))))
Index: xfs/fs/xfs/xfs_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_btree.c	2009-02-09 19:05:49.018069067 +0100
+++ xfs/fs/xfs/xfs_btree.c	2009-02-09 19:15:42.842069176 +0100
@@ -39,6 +39,7 @@
 #include "xfs_btree_trace.h"
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
+#include "xfs_cksum.h"
 
 /*
  * Cursor allocation zone.
@@ -48,9 +49,13 @@ kmem_zone_t	*xfs_btree_cur_zone;
 /*
  * Btree magic numbers.
  */
-const __uint32_t xfs_magics[XFS_BTNUM_MAX] = {
-	XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, XFS_BMAP_MAGIC, XFS_IBT_MAGIC
+static const __uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
+	{ XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, XFS_BMAP_MAGIC, XFS_IBT_MAGIC },
+	{ XFS_ABTB_CRC_MAGIC, XFS_ABTC_CRC_MAGIC,
+	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC }
 };
+#define xfs_btree_magic(cur) \
+	xfs_magics[!!((cur)->bc_flags & XFS_BTREE_CRC_BLOCKS)][cur->bc_btnum]
 
 
 STATIC int				/* error (0 or EFSCORRUPTED) */
@@ -64,8 +69,34 @@ xfs_btree_check_lblock(
 	struct xfs_mount	*mp;	/* file system mount point */
 
 	mp = cur->bc_mp;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		/*
+		 * Validate the CRC of the btree block only if the block is
+		 * clean (i.e. it just came from disk) and we have CRCs enabled.
+		 *
+		 * If we are called for an in inode root block don't check the
+		 * crc because we only calculate it for real btree blocks on
+		 * disk.
+		 */
+		if (bp && !(XFS_BUF_ISWRITE(bp) || XFS_BUF_ISDELAYWRITE(bp)) &&
+		    !xfs_verify_cksum(XFS_BUF_PTR(bp), XFS_BUF_SIZE(bp),
+		    		      XFS_BTREE_LBLOCK_CRC_OFF)) {
+			XFS_CORRUPTION_ERROR("xfs_btree_check_lblock crc",
+				XFS_ERRLEVEL_LOW, mp, mp);
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+
+		lblock_ok =
+			uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid) &&
+			block->bb_u.l.bb_blkno == cpu_to_be64(
+				bp ? XFS_BUF_ADDR(bp) : XFS_BUF_DADDR_NULL);
+		if (!lblock_ok)
+			goto test_error;
+	}
+
 	lblock_ok =
-		be32_to_cpu(block->bb_magic) == xfs_magics[cur->bc_btnum] &&
+		be32_to_cpu(block->bb_magic) == xfs_btree_magic(cur) &&
 		be16_to_cpu(block->bb_level) == level &&
 		be16_to_cpu(block->bb_numrecs) <=
 			cur->bc_ops->get_maxrecs(cur, level) &&
@@ -77,6 +108,8 @@ xfs_btree_check_lblock(
 		(be64_to_cpu(block->bb_u.l.bb_rightsib) == NULLDFSBNO ||
 		 XFS_FSB_SANITY_CHECK(mp,
 		 	be64_to_cpu(block->bb_u.l.bb_rightsib)));
+
+ test_error:
 	if (unlikely(XFS_TEST_ERROR(!lblock_ok, mp,
 			XFS_ERRTAG_BTREE_CHECK_LBLOCK,
 			XFS_RANDOM_BTREE_CHECK_LBLOCK))) {
@@ -96,16 +129,40 @@ xfs_btree_check_sblock(
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp)	/* buffer containing block */
 {
+	struct xfs_mount	*mp;	/* file system mount point */
 	struct xfs_buf		*agbp;	/* buffer for ag. freespace struct */
 	struct xfs_agf		*agf;	/* ag. freespace structure */
 	xfs_agblock_t		agflen;	/* native ag. freespace length */
 	int			sblock_ok; /* block passes checks */
 
+	mp = cur->bc_mp;
 	agbp = cur->bc_private.a.agbp;
 	agf = XFS_BUF_TO_AGF(agbp);
 	agflen = be32_to_cpu(agf->agf_length);
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		/*
+		 * Validate the CRC of the btree block only if the block is
+		 * clean (i.e. it just came from disk) and we have CRCs enabled.
+		 */
+		if (!(XFS_BUF_ISWRITE(bp) || XFS_BUF_ISDELAYWRITE(bp)) &&
+		    !xfs_verify_cksum(XFS_BUF_PTR(bp), XFS_BUF_SIZE(bp),
+			    	      XFS_BTREE_SBLOCK_CRC_OFF)) {
+			XFS_CORRUPTION_ERROR("xfs_btree_check_sblock crc",
+				XFS_ERRLEVEL_LOW, mp, mp);
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+
+		sblock_ok =
+			uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid) &&
+			block->bb_u.s.bb_blkno == cpu_to_be64(
+				bp ? XFS_BUF_ADDR(bp) : XFS_BUF_DADDR_NULL);
+		if (!sblock_ok)
+			goto test_error;
+	}
+
 	sblock_ok =
-		be32_to_cpu(block->bb_magic) == xfs_magics[cur->bc_btnum] &&
+		be32_to_cpu(block->bb_magic) == xfs_btree_magic(cur) &&
 		be16_to_cpu(block->bb_level) == level &&
 		be16_to_cpu(block->bb_numrecs) <=
 			cur->bc_ops->get_maxrecs(cur, level) &&
@@ -115,13 +172,15 @@ xfs_btree_check_sblock(
 		(be32_to_cpu(block->bb_u.s.bb_rightsib) == NULLAGBLOCK ||
 		 be32_to_cpu(block->bb_u.s.bb_rightsib) < agflen) &&
 		block->bb_u.s.bb_rightsib;
-	if (unlikely(XFS_TEST_ERROR(!sblock_ok, cur->bc_mp,
+
+ test_error:
+	if (unlikely(XFS_TEST_ERROR(!sblock_ok, mp,
 			XFS_ERRTAG_BTREE_CHECK_SBLOCK,
 			XFS_RANDOM_BTREE_CHECK_SBLOCK))) {
 		if (bp)
 			xfs_buftrace("SBTREE ERROR", bp);
 		XFS_ERROR_REPORT("xfs_btree_check_sblock", XFS_ERRLEVEL_LOW,
-				 cur->bc_mp);
+				 mp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 	return 0;
@@ -272,18 +331,28 @@ xfs_btree_dup_cursor(
 	for (i = 0; i < new->bc_nlevels; i++) {
 		new->bc_ptrs[i] = cur->bc_ptrs[i];
 		new->bc_ra[i] = cur->bc_ra[i];
-		if ((bp = cur->bc_bufs[i])) {
-			if ((error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-				XFS_BUF_ADDR(bp), mp->m_bsize, 0, &bp))) {
+		bp = cur->bc_bufs[i];
+		if (bp) {
+			error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+				XFS_BUF_ADDR(bp), mp->m_bsize, 0, &bp);
+			if (error) {
 				xfs_btree_del_cursor(new, error);
 				*ncur = NULL;
 				return error;
 			}
-			new->bc_bufs[i] = bp;
+
 			ASSERT(bp);
 			ASSERT(!XFS_BUF_GETERROR(bp));
-		} else
-			new->bc_bufs[i] = NULL;
+
+			if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+				xfs_buf_set_io_callback(bp,
+					(cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
+						xfs_btree_lblock_calc_crc :
+						xfs_btree_sblock_calc_crc);
+			}
+
+		}
+		new->bc_bufs[i] = bp;
 	}
 	*ncur = new;
 	return 0;
@@ -324,9 +393,17 @@ xfs_btree_dup_cursor(
  */
 static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
 {
-	return (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
-		XFS_BTREE_LBLOCK_LEN :
-		XFS_BTREE_SBLOCK_LEN;
+	size_t len;
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		len = XFS_BTREE_LBLOCK_LEN;
+	else
+		len = XFS_BTREE_SBLOCK_LEN;
+
+	if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS)
+		len += XFS_BTREE_CRCBLOCK_ADD;
+
+	return len;
 }
 
 /*
@@ -420,6 +497,30 @@ xfs_btree_ptr_addr(
 }
 
 /*
+ * Calculate CRC on the whole btree block and stuff it into the
+ * long-form btree header.
+ */
+void
+xfs_btree_lblock_calc_crc(
+	struct xfs_buf		*bp)
+{
+	xfs_update_cksum(XFS_BUF_PTR(bp), XFS_BUF_SIZE(bp),
+			 XFS_BTREE_LBLOCK_CRC_OFF);
+}
+
+/*
+ * Calculate CRC on the whole btree block and stuff it into the
+ * short-form btree header.
+ */
+void
+xfs_btree_sblock_calc_crc(
+	struct xfs_buf		*bp)
+{
+	xfs_update_cksum(XFS_BUF_PTR(bp), XFS_BUF_SIZE(bp),
+			 XFS_BTREE_SBLOCK_CRC_OFF);
+}
+
+/*
  * Get a the root block which is stored in the inode.
  *
  * For now this btree implementation assumes the btree root is always
@@ -474,6 +575,9 @@ xfs_btree_get_bufl(
 	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, lock);
 	ASSERT(bp);
 	ASSERT(!XFS_BUF_GETERROR(bp));
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		xfs_buf_set_io_callback(bp, xfs_btree_lblock_calc_crc);
 	return bp;
 }
 
@@ -498,6 +602,9 @@ xfs_btree_get_bufs(
 	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, lock);
 	ASSERT(bp);
 	ASSERT(!XFS_BUF_GETERROR(bp));
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		xfs_buf_set_io_callback(bp, xfs_btree_sblock_calc_crc);
 	return bp;
 }
 
@@ -640,6 +747,8 @@ xfs_btree_read_bufl(
 	ASSERT(!bp || !XFS_BUF_GETERROR(bp));
 	if (bp != NULL) {
 		XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, refval);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			xfs_buf_set_io_callback(bp, xfs_btree_lblock_calc_crc);
 	}
 	*bpp = bp;
 	return 0;
@@ -680,6 +789,8 @@ xfs_btree_read_bufs(
 			XFS_BUF_SET_VTYPE_REF(bp, B_FS_INOMAP, refval);
 			break;
 		}
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			xfs_buf_set_io_callback(bp, xfs_btree_sblock_calc_crc);
 	}
 	*bpp = bp;
 	return 0;
@@ -909,20 +1020,34 @@ xfs_btree_set_sibling(
 STATIC void
 xfs_btree_init_block(
 	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
 	int			level,
-	int			numrecs,
-	struct xfs_btree_block	*new)	/* new block */
+	int			numrecs)
 {
-	new->bb_magic = cpu_to_be32(xfs_magics[cur->bc_btnum]);
+	struct xfs_btree_block	*new = XFS_BUF_TO_BLOCK(bp);
+
+	new->bb_magic = cpu_to_be32(xfs_btree_magic(cur));
 	new->bb_level = cpu_to_be16(level);
 	new->bb_numrecs = cpu_to_be16(numrecs);
 
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
 		new->bb_u.l.bb_leftsib = cpu_to_be64(NULLDFSBNO);
 		new->bb_u.l.bb_rightsib = cpu_to_be64(NULLDFSBNO);
+		if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+			new->bb_u.l.bb_blkno = cpu_to_be64(XFS_BUF_ADDR(bp));
+			uuid_copy(&new->bb_u.l.bb_uuid,
+				  &cur->bc_mp->m_sb.sb_uuid);
+			new->bb_u.l.bb_pad = 0;
+		}
 	} else {
 		new->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
 		new->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+		if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+			new->bb_u.s.bb_blkno = cpu_to_be64(XFS_BUF_ADDR(bp));
+			uuid_copy(&new->bb_u.s.bb_uuid,
+				  &cur->bc_mp->m_sb.sb_uuid);
+			new->bb_u.s.bb_pad = 0;
+		}
 	}
 }
 
@@ -1013,19 +1138,28 @@ xfs_btree_get_buf_block(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_buf		*bp;
 	xfs_daddr_t		d;
 
 	/* need to sort out how callers deal with failures first */
 	ASSERT(!(flags & XFS_BUF_TRYLOCK));
 
 	d = xfs_btree_ptr_to_daddr(cur, ptr);
-	*bpp = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d,
-				 mp->m_bsize, flags);
+	bp = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d,
+			       mp->m_bsize, flags);
 
-	ASSERT(*bpp);
-	ASSERT(!XFS_BUF_GETERROR(*bpp));
+	ASSERT(bp);
+	ASSERT(!XFS_BUF_GETERROR(bp));
+
+	if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+		if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+			xfs_buf_set_io_callback(bp, xfs_btree_lblock_calc_crc);
+		else
+			xfs_buf_set_io_callback(bp, xfs_btree_sblock_calc_crc);
+	}
 
-	*block = XFS_BUF_TO_BLOCK(*bpp);
+	*block = XFS_BUF_TO_BLOCK(bp);
+	*bpp = bp;
 	return 0;
 }
 
@@ -1043,6 +1177,7 @@ xfs_btree_read_buf_block(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_buf		*bp;
 	xfs_daddr_t		d;
 	int			error;
 
@@ -1051,20 +1186,31 @@ xfs_btree_read_buf_block(
 
 	d = xfs_btree_ptr_to_daddr(cur, ptr);
 	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
-				   mp->m_bsize, flags, bpp);
+				   mp->m_bsize, flags, &bp);
 	if (error)
 		return error;
 
-	ASSERT(*bpp != NULL);
-	ASSERT(!XFS_BUF_GETERROR(*bpp));
+	ASSERT(bp != NULL);
+	ASSERT(!XFS_BUF_GETERROR(bp));
 
-	xfs_btree_set_refs(cur, *bpp);
-	*block = XFS_BUF_TO_BLOCK(*bpp);
+	xfs_btree_set_refs(cur, bp);
+	*block = XFS_BUF_TO_BLOCK(bp);
 
-	error = xfs_btree_check_block(cur, *block, level, *bpp);
-	if (error)
-		xfs_trans_brelse(cur->bc_tp, *bpp);
-	return error;
+	if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+		if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+			xfs_buf_set_io_callback(bp, xfs_btree_lblock_calc_crc);
+		else
+			xfs_buf_set_io_callback(bp, xfs_btree_sblock_calc_crc);
+	}
+
+	error = xfs_btree_check_block(cur, *block, level, bp);
+	if (error) {
+		xfs_trans_brelse(cur->bc_tp, bp);
+		return error;
+	}
+
+	*bpp = bp;
+	return 0;
 }
 
 /*
@@ -1250,31 +1396,56 @@ xfs_btree_log_block(
 {
 	int			first;	/* first byte offset logged */
 	int			last;	/* last byte offset logged */
-	static const short	soffsets[] = {	/* table of offsets (short) */
+	static const short	soffsets[] = {	/* short + crc */
 		offsetof(struct xfs_btree_block, bb_magic),
 		offsetof(struct xfs_btree_block, bb_level),
 		offsetof(struct xfs_btree_block, bb_numrecs),
 		offsetof(struct xfs_btree_block, bb_u.s.bb_leftsib),
 		offsetof(struct xfs_btree_block, bb_u.s.bb_rightsib),
-		XFS_BTREE_SBLOCK_LEN
+		offsetof(struct xfs_btree_block, bb_u.s.bb_blkno),
+		offsetof(struct xfs_btree_block, bb_u.s.bb_crc),
+		offsetof(struct xfs_btree_block, bb_u.s.bb_uuid),
+		offsetof(struct xfs_btree_block, bb_u.s.bb_pad),
+		XFS_BTREE_SBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD
 	};
-	static const short	loffsets[] = {	/* table of offsets (long) */
+	static const short	loffsets[] = {	/* long + crc */
 		offsetof(struct xfs_btree_block, bb_magic),
 		offsetof(struct xfs_btree_block, bb_level),
 		offsetof(struct xfs_btree_block, bb_numrecs),
 		offsetof(struct xfs_btree_block, bb_u.l.bb_leftsib),
 		offsetof(struct xfs_btree_block, bb_u.l.bb_rightsib),
-		XFS_BTREE_LBLOCK_LEN
+		offsetof(struct xfs_btree_block, bb_u.l.bb_blkno),
+		offsetof(struct xfs_btree_block, bb_u.l.bb_crc),
+		offsetof(struct xfs_btree_block, bb_u.l.bb_uuid),
+		offsetof(struct xfs_btree_block, bb_u.l.bb_pad),
+		XFS_BTREE_LBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD
 	};
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
 	XFS_BTREE_TRACE_ARGBI(cur, bp, fields);
 
 	if (bp) {
+		int nbits;
+
+		if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+			/*
+			 * We don't log the CRC when updating a btree
+			 * block but instead recreate it during log
+			 * recovery.  As the log buffers have checksums
+			 * of their this is safe and avoids logging a crc
+			 * update in a lot of places.
+			 */
+			if (fields == XFS_BB_ALL_BITS)
+				fields = XFS_BB_ALL_BITS_CRC;
+			nbits = XFS_BB_NUM_BITS_CRC;
+		} else {
+			nbits = XFS_BB_NUM_BITS;
+		}
+
 		xfs_btree_offsets(fields,
 				  (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
-					loffsets : soffsets,
-				  XFS_BB_NUM_BITS, &first, &last);
+				  	loffsets : soffsets,
+				  nbits, &first, &last);
 		xfs_trans_log_buf(cur->bc_tp, bp, first, last);
 	} else {
 		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
@@ -2237,7 +2408,7 @@ xfs_btree_split(
 		goto error0;
 
 	/* Fill in the btree header for the new right block. */
-	xfs_btree_init_block(cur, xfs_btree_get_level(left), 0, right);
+	xfs_btree_init_block(cur, rbp, xfs_btree_get_level(left), 0);
 
 	/*
 	 * Split the entries between the old and the new block evenly.
@@ -2546,7 +2717,7 @@ xfs_btree_new_root(
 		nptr = 2;
 	}
 	/* Fill in the new block's btree header and log it. */
-	xfs_btree_init_block(cur, cur->bc_nlevels, 2, new);
+	xfs_btree_init_block(cur, nbp, cur->bc_nlevels, 2);
 	xfs_btree_log_block(cur, nbp, XFS_BB_ALL_BITS);
 	ASSERT(!xfs_btree_ptr_is_null(cur, &lptr) &&
 			!xfs_btree_ptr_is_null(cur, &rptr));
Index: xfs/fs/xfs/xfs_dinode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dinode.h	2009-02-09 19:15:37.179944489 +0100
+++ xfs/fs/xfs/xfs_dinode.h	2009-02-09 19:15:42.843068745 +0100
@@ -106,8 +106,8 @@ typedef enum xfs_dinode_fmt {
 #define XFS_LITINO(version, mp) \
 	((int)(((mp)->m_sb.sb_inodesize) - sizeof(struct xfs_dinode)))
 
-#define	XFS_BROOT_SIZE_ADJ	\
-	(XFS_BTREE_LBLOCK_LEN - sizeof(xfs_bmdr_block_t))
+#define XFS_BROOT_SIZE_ADJ(ip) \
+	(XFS_BMBT_BLOCK_LEN((ip)->i_mount) - sizeof(xfs_bmdr_block_t))
 
 /*
  * Inode data & attribute fork sizes, per inode.
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2009-02-09 19:05:49.026068758 +0100
+++ xfs/fs/xfs/xfs_inode.c	2009-02-09 19:15:42.848068962 +0100
@@ -596,6 +596,7 @@ xfs_iformat_btree(
 	xfs_dinode_t		*dip,
 	int			whichfork)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	xfs_bmdr_block_t	*dfp;
 	xfs_ifork_t		*ifp;
 	/* REFERENCED */
@@ -604,7 +605,7 @@ xfs_iformat_btree(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	dfp = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
-	size = XFS_BMAP_BROOT_SPACE(dfp);
+	size = XFS_BMAP_BROOT_SPACE(mp, dfp);
 	nrecs = be16_to_cpu(dfp->bb_numrecs);
 
 	/*
@@ -616,13 +617,12 @@ xfs_iformat_btree(
 	 */
 	if (unlikely(XFS_IFORK_NEXTENTS(ip, whichfork) <= ifp->if_ext_max
 	    || XFS_BMDR_SPACE_CALC(nrecs) >
-			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork)
+			XFS_DFORK_SIZE(dip, mp, whichfork)
 	    || XFS_IFORK_NEXTENTS(ip, whichfork) > ip->i_d.di_nblocks)) {
-		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
+		xfs_fs_repair_cmn_err(CE_WARN, mp,
 			"corrupt inode %Lu (btree).",
 			(unsigned long long) ip->i_ino);
-		XFS_ERROR_REPORT("xfs_iformat_btree", XFS_ERRLEVEL_LOW,
-				 ip->i_mount);
+		XFS_ERROR_REPORT("xfs_iformat_btree", XFS_ERRLEVEL_LOW, mp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
@@ -2247,7 +2247,7 @@ xfs_iroot_realloc(
 		 * allocate it now and get out.
 		 */
 		if (ifp->if_broot_bytes == 0) {
-			new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(rec_diff);
+			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
 			ifp->if_broot = kmem_alloc(new_size, KM_SLEEP);
 			ifp->if_broot_bytes = (int)new_size;
 			return;
@@ -2261,9 +2261,9 @@ xfs_iroot_realloc(
 		 */
 		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
 		new_max = cur_max + rec_diff;
-		new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(new_max);
+		new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
 		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
-				(size_t)XFS_BMAP_BROOT_SPACE_CALC(cur_max), /* old size */
+				(size_t)XFS_BMAP_BROOT_SPACE_CALC(mp, cur_max), /* old size */
 				KM_SLEEP);
 		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
@@ -2271,7 +2271,7 @@ xfs_iroot_realloc(
 						     (int)new_size);
 		ifp->if_broot_bytes = (int)new_size;
 		ASSERT(ifp->if_broot_bytes <=
-			XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ);
+			XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ(ip));
 		memmove(np, op, cur_max * (uint)sizeof(xfs_dfsbno_t));
 		return;
 	}
@@ -2286,7 +2286,7 @@ xfs_iroot_realloc(
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
 	if (new_max > 0)
-		new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(new_max);
+		new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
 	else
 		new_size = 0;
 	if (new_size > 0) {
@@ -2294,7 +2294,8 @@ xfs_iroot_realloc(
 		/*
 		 * First copy over the btree block header.
 		 */
-		memcpy(new_broot, ifp->if_broot, XFS_BTREE_LBLOCK_LEN);
+		memcpy(new_broot, ifp->if_broot,
+			XFS_BMBT_BLOCK_LEN(ip->i_mount));
 	} else {
 		new_broot = NULL;
 		ifp->if_flags &= ~XFS_IFBROOT;
@@ -2324,7 +2325,7 @@ xfs_iroot_realloc(
 	ifp->if_broot = new_broot;
 	ifp->if_broot_bytes = (int)new_size;
 	ASSERT(ifp->if_broot_bytes <=
-		XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ);
+		XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ(ip));
 	return;
 }
 
@@ -2665,7 +2666,7 @@ xfs_iflush_fork(
 			ASSERT(ifp->if_broot != NULL);
 			ASSERT(ifp->if_broot_bytes <=
 			       (XFS_IFORK_SIZE(ip, whichfork) +
-				XFS_BROOT_SIZE_ADJ));
+				XFS_BROOT_SIZE_ADJ(ip)));
 			xfs_bmbt_to_bmdr(mp, ifp->if_broot, ifp->if_broot_bytes,
 				(xfs_bmdr_block_t *)cp,
 				XFS_DFORK_SIZE(dip, mp, whichfork));
Index: xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.c	2009-02-09 19:15:37.185944554 +0100
+++ xfs/fs/xfs/xfs_attr_leaf.c	2009-02-09 19:15:42.850068937 +0100
@@ -174,7 +174,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 			else 
 				return dp->i_d.di_forkoff;
 		} else
-			dsize = XFS_BMAP_BROOT_SPACE(dp->i_df.if_broot);
+			dsize = XFS_BMAP_BROOT_SPACE(mp, dp->i_df.if_broot);
 		break;
 	}
 	
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2009-02-09 19:15:37.192068867 +0100
+++ xfs/fs/xfs/xfs_bmap.c	2009-02-09 19:15:42.854098570 +0100
@@ -3465,6 +3465,7 @@ xfs_bmap_extents_to_btree(
 	xfs_extnum_t		nextents;	/* number of file extents */
 	xfs_bmbt_ptr_t		*pp;		/* root block address pointer */
 
+	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS);
 	ASSERT(ifp->if_ext_max ==
@@ -3479,16 +3480,23 @@ xfs_bmap_extents_to_btree(
 	 * Fill in the root.
 	 */
 	block = ifp->if_broot;
-	block->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		block->bb_magic = cpu_to_be32(XFS_BMAP_CRC_MAGIC);
+	else
+		block->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
 	block->bb_level = cpu_to_be16(1);
 	block->bb_numrecs = cpu_to_be16(1);
 	block->bb_u.l.bb_leftsib = cpu_to_be64(NULLDFSBNO);
 	block->bb_u.l.bb_rightsib = cpu_to_be64(NULLDFSBNO);
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		block->bb_u.l.bb_blkno = cpu_to_be64(XFS_BUF_DADDR_NULL);
+		uuid_copy(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid);
+		block->bb_u.l.bb_pad = 0;
+	}
 
 	/*
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
-	mp = ip->i_mount;
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 	cur->bc_private.b.firstblock = *firstblock;
 	cur->bc_private.b.flist = flist;
@@ -3537,10 +3545,18 @@ xfs_bmap_extents_to_btree(
 	 * Fill in the child block.
 	 */
 	ablock = XFS_BUF_TO_BLOCK(abp);
-	ablock->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		ablock->bb_magic = cpu_to_be32(XFS_BMAP_CRC_MAGIC);
+	else
+		ablock->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
 	ablock->bb_level = 0;
 	ablock->bb_u.l.bb_leftsib = cpu_to_be64(NULLDFSBNO);
 	ablock->bb_u.l.bb_rightsib = cpu_to_be64(NULLDFSBNO);
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		ablock->bb_u.l.bb_blkno = cpu_to_be64(XFS_BUF_ADDR(abp));
+		uuid_copy(&ablock->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid);
+		ablock->bb_u.l.bb_pad = 0;
+	}
 	arp = XFS_BMBT_REC_ADDR(mp, ablock, 1);
 	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 	for (cnt = i = 0; i < nextents; i++) {
@@ -3568,8 +3584,8 @@ xfs_bmap_extents_to_btree(
 	 * Do all this logging at the end so that
 	 * the root is at the right level.
 	 */
-	xfs_btree_log_block(cur, abp, XFS_BB_ALL_BITS);
 	xfs_btree_log_recs(cur, abp, 1, be16_to_cpu(ablock->bb_numrecs));
+	xfs_btree_log_block(cur, abp, XFS_BB_ALL_BITS);
 	ASSERT(*curp == NULL);
 	*curp = cur;
 	*logflagsp = XFS_ILOG_CORE | xfs_ilog_fbroot(whichfork);
@@ -3686,7 +3702,13 @@ xfs_bmap_local_to_extents(
 		ASSERT(args.fsbno != NULLFSBLOCK);
 		ASSERT(args.len == 1);
 		*firstblock = args.fsbno;
-		bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno, 0);
+
+		bp = xfs_trans_get_buf(args.tp, args.mp->m_ddev_targp,
+				       XFS_FSB_TO_DADDR(args.mp, args.fsbno),
+				       args.mp->m_bsize, 0);
+		ASSERT(bp);
+		ASSERT(!XFS_BUF_GETERROR(bp));
+
 		memcpy((char *)XFS_BUF_PTR(bp), ifp->if_u1.if_data,
 			ifp->if_bytes);
 		xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
@@ -4562,11 +4584,21 @@ xfs_bmap_sanity_check(
 {
 	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
 
-	if (be32_to_cpu(block->bb_magic) != XFS_BMAP_MAGIC ||
-	    be16_to_cpu(block->bb_level) != level ||
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (be32_to_cpu(block->bb_magic) != XFS_BMAP_CRC_MAGIC ||
+		    !uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid) ||
+		    block->bb_u.l.bb_blkno != cpu_to_be64(XFS_BUF_ADDR(bp)))
+			return 0;
+	} else {
+		if (be32_to_cpu(block->bb_magic) != XFS_BMAP_MAGIC)
+			return 0;
+	}
+
+	if (be16_to_cpu(block->bb_level) != level ||
 	    be16_to_cpu(block->bb_numrecs) == 0 ||
 	    be16_to_cpu(block->bb_numrecs) > mp->m_bmap_dmxr[level != 0])
 		return 0;
+
 	return 1;
 }
 
Index: xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc_btree.c	2009-02-09 19:05:49.038069167 +0100
+++ xfs/fs/xfs/xfs_alloc_btree.c	2009-02-09 19:15:42.855068736 +0100
@@ -474,6 +474,8 @@ xfs_allocbt_init_cursor(
 	cur->bc_ops = &xfs_allocbt_ops;
 	if (btnum == XFS_BTNUM_CNT)
 		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_private.a.agbp = agbp;
 	cur->bc_private.a.agno = agno;
Index: xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc_btree.c	2009-02-09 19:05:49.043068895 +0100
+++ xfs/fs/xfs/xfs_ialloc_btree.c	2009-02-09 19:15:42.857069060 +0100
@@ -359,6 +359,8 @@ xfs_inobt_init_cursor(
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 
 	cur->bc_ops = &xfs_inobt_ops;
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_private.a.agbp = agbp;
 	cur->bc_private.a.agno = agno;
Index: xfs/fs/xfs/xfs_fsops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fsops.c	2009-02-09 19:05:49.047068705 +0100
+++ xfs/fs/xfs/xfs_fsops.c	2009-02-09 19:15:42.860069581 +0100
@@ -253,11 +253,19 @@ xfs_growfs_data_private(
 			BTOBB(mp->m_sb.sb_blocksize), 0);
 		block = XFS_BUF_TO_BLOCK(bp);
 		memset(block, 0, mp->m_sb.sb_blocksize);
-		block->bb_magic = cpu_to_be32(XFS_ABTB_MAGIC);
 		block->bb_level = 0;
 		block->bb_numrecs = cpu_to_be16(1);
 		block->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
 		block->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			block->bb_magic = cpu_to_be32(XFS_ABTB_CRC_MAGIC);
+			block->bb_u.s.bb_blkno = cpu_to_be64(XFS_BUF_ADDR(bp));
+			uuid_copy(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid);
+			block->bb_u.s.bb_pad = 0;
+			xfs_buf_set_io_callback(bp, xfs_btree_sblock_calc_crc);
+		} else {
+			block->bb_magic = cpu_to_be32(XFS_ABTB_MAGIC);
+		}
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
 		arec->ar_blockcount = cpu_to_be32(
@@ -274,11 +282,19 @@ xfs_growfs_data_private(
 			BTOBB(mp->m_sb.sb_blocksize), 0);
 		block = XFS_BUF_TO_BLOCK(bp);
 		memset(block, 0, mp->m_sb.sb_blocksize);
-		block->bb_magic = cpu_to_be32(XFS_ABTC_MAGIC);
 		block->bb_level = 0;
 		block->bb_numrecs = cpu_to_be16(1);
 		block->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
 		block->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			block->bb_magic = cpu_to_be32(XFS_ABTC_CRC_MAGIC);
+			block->bb_u.s.bb_blkno = cpu_to_be64(XFS_BUF_ADDR(bp));
+			uuid_copy(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid);
+			block->bb_u.s.bb_pad = 0;
+			xfs_buf_set_io_callback(bp, xfs_btree_sblock_calc_crc);
+		} else {
+			block->bb_magic = cpu_to_be32(XFS_ABTC_MAGIC);
+		}
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
 		arec->ar_blockcount = cpu_to_be32(
@@ -296,11 +312,19 @@ xfs_growfs_data_private(
 			BTOBB(mp->m_sb.sb_blocksize), 0);
 		block = XFS_BUF_TO_BLOCK(bp);
 		memset(block, 0, mp->m_sb.sb_blocksize);
-		block->bb_magic = cpu_to_be32(XFS_IBT_MAGIC);
 		block->bb_level = 0;
 		block->bb_numrecs = 0;
 		block->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
 		block->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			block->bb_magic = cpu_to_be32(XFS_IBT_CRC_MAGIC);
+			block->bb_u.s.bb_blkno = cpu_to_be64(XFS_BUF_ADDR(bp));
+			uuid_copy(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid);
+			block->bb_u.s.bb_pad = 0;
+			xfs_buf_set_io_callback(bp, xfs_btree_sblock_calc_crc);
+		} else {
+			block->bb_magic = cpu_to_be32(XFS_IBT_MAGIC);
+		}
 		error = xfs_bwrite(mp, bp);
 		if (error) {
 			goto error0;
Index: xfs/fs/xfs/xfs_alloc_btree.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc_btree.h	2009-02-09 19:05:49.051069843 +0100
+++ xfs/fs/xfs/xfs_alloc_btree.h	2009-02-09 19:15:42.862069766 +0100
@@ -31,8 +31,10 @@ struct xfs_mount;
  * by blockcount and blockno.  All blocks look the same to make the code
  * simpler; if we have time later, we'll make the optimizations.
  */
-#define	XFS_ABTB_MAGIC	0x41425442	/* 'ABTB' for bno tree */
-#define	XFS_ABTC_MAGIC	0x41425443	/* 'ABTC' for cnt tree */
+#define	XFS_ABTB_MAGIC		0x41425442	/* 'ABTB' for bno tree */
+#define	XFS_ABTB_CRC_MAGIC	0x4142544a
+#define	XFS_ABTC_MAGIC		0x41425443	/* 'ABTC' for cnt tree */
+#define	XFS_ABTC_CRC_MAGIC	0x4142544b
 
 /*
  * Data record/key structure
@@ -73,10 +75,11 @@ typedef __be32 xfs_alloc_ptr_t;
 
 /*
  * Btree block header size depends on a superblock flag.
- *
- * (not quite yet, but soon)
  */
-#define XFS_ALLOC_BLOCK_LEN(mp)	XFS_BTREE_SBLOCK_LEN
+#define XFS_ALLOC_BLOCK_LEN(mp) \
+	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+	 XFS_BTREE_SBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD : \
+	 XFS_BTREE_SBLOCK_LEN)
 
 /*
  * Record, key, and pointer address macros for btree blocks.
Index: xfs/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc_btree.h	2009-02-09 19:05:49.055069304 +0100
+++ xfs/fs/xfs/xfs_ialloc_btree.h	2009-02-09 19:15:42.866069437 +0100
@@ -29,7 +29,8 @@ struct xfs_mount;
 /*
  * There is a btree for the inode map per allocation group.
  */
-#define	XFS_IBT_MAGIC	0x49414254	/* 'IABT' */
+#define	XFS_IBT_MAGIC		0x49414254	/* 'IABT' */
+#define	XFS_IBT_CRC_MAGIC	0x4941425c
 
 typedef	__uint64_t	xfs_inofree_t;
 #define	XFS_INODES_PER_CHUNK		(NBBY * sizeof(xfs_inofree_t))
@@ -76,10 +77,11 @@ typedef __be32 xfs_inobt_ptr_t;
 
 /*
  * Btree block header size depends on a superblock flag.
- *
- * (not quite yet, but soon)
  */
-#define XFS_INOBT_BLOCK_LEN(mp)	XFS_BTREE_SBLOCK_LEN
+#define XFS_INOBT_BLOCK_LEN(mp) \
+	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+	 XFS_BTREE_SBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD : \
+	 XFS_BTREE_SBLOCK_LEN)
 
 /*
  * Record, key, and pointer address macros for btree blocks.
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2009-02-09 19:15:38.648943978 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2009-02-09 19:15:42.873069001 +0100
@@ -31,6 +31,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
+#include "xfs_btree.h"
 #include "xfs_dir2_sf.h"
 #include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
@@ -1980,6 +1981,19 @@ xlog_recover_do_reg_buffer(
 		bit += nbits;
 	}
 
+	switch (be32_to_cpu(*(__be32 *)XFS_BUF_PTR(bp))) {
+	case XFS_ABTB_CRC_MAGIC:
+	case XFS_ABTC_CRC_MAGIC:
+	case XFS_IBT_CRC_MAGIC:
+		xfs_btree_sblock_calc_crc(bp);
+		break;
+	case XFS_BMAP_CRC_MAGIC:
+		xfs_btree_lblock_calc_crc(bp);
+		break;
+	default:
+		break;
+	}
+
 	/* Shouldn't be any more regions */
 	ASSERT(i == item->ri_total);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
