Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 18:02:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8F1249N027029
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 18:02:04 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3716E126FEA3
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 18:03:33 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id cnRCzvYjNB8OQM65 for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 18:03:33 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8F13WIF013225
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 03:03:32 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8F13WRn013223
	for xfs@oss.sgi.com; Mon, 15 Sep 2008 03:03:32 +0200
Date: Mon, 15 Sep 2008 03:03:32 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] add support for large btree blocks with CRCs and additional RAS information
Message-ID: <20080915010332.GE13062@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-large-btree-blocks
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Add support for larger btree blocks that contains a CRC32C checksum, a
filesystem uuid and block number for detecting filesystem consistency
and out of place writes.  The use of these blocks is triggered by the
crc superblock patches just added.

Note that we currently do not log the crc of the block, but re-created
it during log recovery.  With the pending patch to also checksum the log
this should be safe against filesystem corruption but doesn't really
follow the end to end argument.  Also poking into the buffer to find
out whether this is a btree buffer during log recovery is not a very
clean way to implement this.  I'll look into how well adding crcs
to the buffer log items for every btree is going to work and hope
I can switch to that variant for the next version.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-09-15 02:42:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-09-15 02:51:15.000000000 +0200
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
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-09-15 02:42:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-09-15 02:51:15.000000000 +0200
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
@@ -440,10 +448,18 @@ xfs_bmbt_to_bmdr(
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
@@ -885,6 +901,8 @@ xfs_bmbt_init_cursor(
 
 	cur->bc_ops = &xfs_bmbt_ops;
 	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
 	cur->bc_private.b.ip = ip;
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2008-09-15 02:42:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-09-15 02:51:15.000000000 +0200
@@ -18,7 +18,8 @@
 #ifndef __XFS_BMAP_BTREE_H__
 #define __XFS_BMAP_BTREE_H__
 
-#define XFS_BMAP_MAGIC	0x424d4150	/* 'BMAP' */
+#define XFS_BMAP_MAGIC		0x424d4150	/* 'BMAP' */
+#define XFS_BMAP_CRC_MAGIC	0x424d4158
 
 struct xfs_btree_cur;
 struct xfs_btree_block;
@@ -148,10 +149,11 @@ typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_
 
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
@@ -198,12 +200,12 @@ typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_
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
Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-09-15 02:42:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-09-15 02:51:15.000000000 +0200
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
@@ -270,18 +329,28 @@ xfs_btree_dup_cursor(
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
@@ -322,9 +391,17 @@ xfs_btree_dup_cursor(
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
@@ -418,6 +495,30 @@ xfs_btree_ptr_addr(
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
@@ -472,6 +573,9 @@ xfs_btree_get_bufl(
 	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, lock);
 	ASSERT(bp);
 	ASSERT(!XFS_BUF_GETERROR(bp));
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		xfs_buf_set_io_callback(bp, xfs_btree_lblock_calc_crc);
 	return bp;
 }
 
@@ -496,6 +600,9 @@ xfs_btree_get_bufs(
 	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, lock);
 	ASSERT(bp);
 	ASSERT(!XFS_BUF_GETERROR(bp));
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		xfs_buf_set_io_callback(bp, xfs_btree_sblock_calc_crc);
 	return bp;
 }
 
@@ -638,6 +745,8 @@ xfs_btree_read_bufl(
 	ASSERT(!bp || !XFS_BUF_GETERROR(bp));
 	if (bp != NULL) {
 		XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, refval);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			xfs_buf_set_io_callback(bp, xfs_btree_lblock_calc_crc);
 	}
 	*bpp = bp;
 	return 0;
@@ -678,6 +787,8 @@ xfs_btree_read_bufs(
 			XFS_BUF_SET_VTYPE_REF(bp, B_FS_INOMAP, refval);
 			break;
 		}
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			xfs_buf_set_io_callback(bp, xfs_btree_sblock_calc_crc);
 	}
 	*bpp = bp;
 	return 0;
@@ -907,20 +1018,34 @@ xfs_btree_set_sibling(
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
-	new->bb_level = cpu_to_be16(level);
-	new->bb_numrecs = cpu_to_be16(numrecs);
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+
+	block->bb_magic = cpu_to_be32(xfs_btree_magic(cur));
+	block->bb_level = cpu_to_be16(level);
+	block->bb_numrecs = cpu_to_be16(numrecs);
 
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		new->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
-		new->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
+		block->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
+		block->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
+		if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+			block->bb_u.l.bb_blkno = cpu_to_be64(XFS_BUF_ADDR(bp));
+			uuid_copy(&block->bb_u.l.bb_uuid,
+				  &cur->bc_mp->m_sb.sb_uuid);
+			block->bb_u.l.bb_pad = 0;
+		}
 	} else {
-		new->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
-		new->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+		block->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
+		block->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+		if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+			block->bb_u.s.bb_blkno = cpu_to_be64(XFS_BUF_ADDR(bp));
+			uuid_copy(&block->bb_u.s.bb_uuid,
+				  &cur->bc_mp->m_sb.sb_uuid);
+			block->bb_u.s.bb_pad = 0;
+		}
 	}
 }
 
@@ -1011,19 +1136,28 @@ xfs_btree_get_buf_block(
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
 
@@ -1041,6 +1175,7 @@ xfs_btree_read_buf_block(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_buf		*bp;
 	xfs_daddr_t		d;
 	int			error;
 
@@ -1049,20 +1184,31 @@ xfs_btree_read_buf_block(
 
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
@@ -1248,31 +1394,56 @@ xfs_btree_log_block(
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
@@ -2235,7 +2406,7 @@ xfs_btree_split(
 		goto error0;
 
 	/* Fill in the btree header for the new right block. */
-	xfs_btree_init_block(cur, xfs_btree_get_level(left), 0, right);
+	xfs_btree_init_block(cur, rbp, xfs_btree_get_level(left), 0);
 
 	/*
 	 * Split the entries between the old and the new block evenly.
@@ -2544,7 +2715,7 @@ xfs_btree_new_root(
 		nptr = 2;
 	}
 	/* Fill in the new block's btree header and log it. */
-	xfs_btree_init_block(cur, cur->bc_nlevels, 2, new);
+	xfs_btree_init_block(cur, nbp, cur->bc_nlevels, 2);
 	xfs_btree_log_block(cur, nbp, XFS_BB_ALL_BITS);
 	ASSERT(!xfs_btree_ptr_is_null(cur, &lptr) &&
 			!xfs_btree_ptr_is_null(cur, &rptr));
Index: linux-2.6-xfs/fs/xfs/xfs_dinode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dinode.h	2008-09-15 02:42:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dinode.h	2008-09-15 02:50:30.000000000 +0200
@@ -164,8 +164,8 @@ typedef enum xfs_dinode_fmt
  * Inode size for given fs.
  */
 #define	XFS_LITINO(mp)	((mp)->m_litino)
-#define	XFS_BROOT_SIZE_ADJ	\
-	(XFS_BTREE_LBLOCK_LEN - sizeof(xfs_bmdr_block_t))
+#define	XFS_BROOT_SIZE_ADJ(ip)	\
+	(XFS_BMBT_BLOCK_LEN((ip)->i_mount) - sizeof(xfs_bmdr_block_t))
 
 /*
  * Inode data & attribute fork sizes, per inode.
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-09-15 02:42:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-09-15 02:50:30.000000000 +0200
@@ -613,6 +613,7 @@ xfs_iformat_btree(
 	xfs_dinode_t		*dip,
 	int			whichfork)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	xfs_bmdr_block_t	*dfp;
 	xfs_ifork_t		*ifp;
 	/* REFERENCED */
@@ -621,7 +622,7 @@ xfs_iformat_btree(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	dfp = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
-	size = XFS_BMAP_BROOT_SPACE(dfp);
+	size = XFS_BMAP_BROOT_SPACE(mp, dfp);
 	nrecs = be16_to_cpu(dfp->bb_numrecs);
 
 	/*
@@ -633,13 +634,12 @@ xfs_iformat_btree(
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
 
@@ -2372,7 +2372,7 @@ xfs_iroot_realloc(
 		 * allocate it now and get out.
 		 */
 		if (ifp->if_broot_bytes == 0) {
-			new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(rec_diff);
+			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
 			ifp->if_broot = kmem_alloc(new_size, KM_SLEEP);
 			ifp->if_broot_bytes = (int)new_size;
 			return;
@@ -2386,9 +2386,9 @@ xfs_iroot_realloc(
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
@@ -2396,7 +2396,7 @@ xfs_iroot_realloc(
 						     (int)new_size);
 		ifp->if_broot_bytes = (int)new_size;
 		ASSERT(ifp->if_broot_bytes <=
-			XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ);
+			XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ(ip));
 		memmove(np, op, cur_max * (uint)sizeof(xfs_dfsbno_t));
 		return;
 	}
@@ -2411,7 +2411,7 @@ xfs_iroot_realloc(
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
 	if (new_max > 0)
-		new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(new_max);
+		new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
 	else
 		new_size = 0;
 	if (new_size > 0) {
@@ -2419,7 +2419,8 @@ xfs_iroot_realloc(
 		/*
 		 * First copy over the btree block header.
 		 */
-		memcpy(new_broot, ifp->if_broot, XFS_BTREE_LBLOCK_LEN);
+		memcpy(new_broot, ifp->if_broot,
+			XFS_BMBT_BLOCK_LEN(ip->i_mount));
 	} else {
 		new_broot = NULL;
 		ifp->if_flags &= ~XFS_IFBROOT;
@@ -2449,7 +2450,7 @@ xfs_iroot_realloc(
 	ifp->if_broot = new_broot;
 	ifp->if_broot_bytes = (int)new_size;
 	ASSERT(ifp->if_broot_bytes <=
-		XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ);
+		XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ(ip));
 	return;
 }
 
@@ -2916,7 +2917,7 @@ xfs_iflush_fork(
 			ASSERT(ifp->if_broot != NULL);
 			ASSERT(ifp->if_broot_bytes <=
 			       (XFS_IFORK_SIZE(ip, whichfork) +
-				XFS_BROOT_SIZE_ADJ));
+				XFS_BROOT_SIZE_ADJ(ip)));
 			xfs_bmbt_to_bmdr(mp, ifp->if_broot, ifp->if_broot_bytes,
 				(xfs_bmdr_block_t *)cp,
 				XFS_DFORK_SIZE(dip, mp, whichfork));
Index: linux-2.6-xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr_leaf.c	2008-09-15 02:11:58.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr_leaf.c	2008-09-15 02:50:30.000000000 +0200
@@ -172,7 +172,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 			else 
 				return dp->i_d.di_forkoff;
 		} else
-			dsize = XFS_BMAP_BROOT_SPACE(dp->i_df.if_broot);
+			dsize = XFS_BMAP_BROOT_SPACE(mp, dp->i_df.if_broot);
 		break;
 	}
 	
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-09-15 02:42:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-09-15 02:51:15.000000000 +0200
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
 	*logflagsp = XFS_ILOG_CORE | XFS_ILOG_FBROOT(whichfork);
@@ -3662,7 +3678,13 @@ xfs_bmap_local_to_extents(
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
@@ -4532,11 +4554,21 @@ xfs_bmap_sanity_check(
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
 
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-09-15 02:42:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-09-15 02:50:30.000000000 +0200
@@ -474,6 +474,8 @@ xfs_allocbt_init_cursor(
 	cur->bc_ops = &xfs_allocbt_ops;
 	if (btnum == XFS_BTNUM_CNT)
 		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_private.a.agbp = agbp;
 	cur->bc_private.a.agno = agno;
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-09-15 02:42:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-09-15 02:50:30.000000000 +0200
@@ -359,6 +359,8 @@ xfs_inobt_init_cursor(
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 
 	cur->bc_ops = &xfs_inobt_ops;
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_private.a.agbp = agbp;
 	cur->bc_private.a.agno = agno;
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-09-15 02:42:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-09-15 02:50:30.000000000 +0200
@@ -567,6 +567,12 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 STATIC void
 xfs_mount_common(xfs_mount_t *mp, xfs_sb_t *sbp)
 {
+
+	if (xfs_sb_version_hascrc(sbp))
+		printk("XFS: using CRCs\n");
+	else
+		printk("XFS: not using CRCs\n");
+
 	mp->m_agfrotor = mp->m_agirotor = 0;
 	spin_lock_init(&mp->m_agirotor_lock);
 	mp->m_maxagi = mp->m_sb.sb_agcount;
Index: linux-2.6-xfs/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_fsops.c	2008-09-15 02:42:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_fsops.c	2008-09-15 02:51:15.000000000 +0200
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
Index: linux-2.6-xfs/fs/xfs/xfs_cksum.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-xfs/fs/xfs/xfs_cksum.h	2008-09-15 02:50:30.000000000 +0200
@@ -0,0 +1,59 @@
+#ifndef _XFS_CKSUM_H
+#define _XFS_CKSUM_H 1
+
+#define XFS_CRC_SEED	(~(__uint32_t)0)
+
+/*
+ * Calculate the intermediate checksum for a buffer that has the CRC field
+ * inside it.  The offset of the 32bit crc fields is passed as the
+ * cksum_offset parameter.
+ */
+static inline __uint32_t
+xfs_start_cksum(char *buffer, size_t length, unsigned long cksum_offset)
+{
+	__uint32_t zero = 0;
+	__uint32_t crc;
+
+	/* Calculate CRC up to the checksum. */
+	crc = crc32c(XFS_CRC_SEED, buffer, cksum_offset);
+
+	/* Skip checksum field */
+	crc = crc32c(crc, &zero, sizeof(__u32));
+
+	/* Calculate the rest of the CRC. */
+	return crc32c(crc, &buffer[cksum_offset + sizeof(__be32)],
+		      length - (cksum_offset + sizeof(__be32)));
+}
+
+/*
+ * Convert the intermediate checmsum to the final ondisk format.
+ */
+static inline __be32
+xfs_end_cksum(__uint32_t crc)
+{
+	return cpu_to_be32(~crc);
+}
+
+/*
+ * Helper to generate the checksum for a buffer.
+ */
+static inline void
+xfs_update_cksum(char *buffer, size_t length, unsigned long cksum_offset)
+{
+	__uint32_t crc = xfs_start_cksum(buffer, length, cksum_offset);
+
+	*(__be32 *)(buffer + cksum_offset) = xfs_end_cksum(crc);
+}
+
+/*
+ * Helper to verify the checksum for a buffer.
+ */
+static inline int
+xfs_verify_cksum(char *buffer, size_t length, unsigned long cksum_offset)
+{
+	__uint32_t crc = xfs_start_cksum(buffer, length, cksum_offset);
+
+	return *(__be32 *)(buffer + cksum_offset) == xfs_end_cksum(crc);
+}
+
+#endif /* _XFS_CKSUM_H */
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.h	2008-09-15 02:42:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h	2008-09-15 02:51:15.000000000 +0200
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
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.h	2008-09-15 02:42:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h	2008-09-15 02:51:15.000000000 +0200
@@ -29,7 +29,8 @@ struct xfs_mount;
 /*
  * There is a btree for the inode map per allocation group.
  */
-#define	XFS_IBT_MAGIC	0x49414254	/* 'IABT' */
+#define	XFS_IBT_MAGIC		0x49414254	/* 'IABT' */
+#define	XFS_IBT_CRC_MAGIC	0x4941425c
 
 typedef	__uint64_t	xfs_inofree_t;
 #define	XFS_INODES_PER_CHUNK	(NBBY * sizeof(xfs_inofree_t))
@@ -91,10 +92,11 @@ typedef __be32 xfs_inobt_ptr_t;
 
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
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-09-15 02:42:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-09-15 02:51:15.000000000 +0200
@@ -31,6 +31,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
+#include "xfs_btree.h"
 #include "xfs_dir2_sf.h"
 #include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
@@ -1888,6 +1889,7 @@ xlog_recover_do_reg_buffer(
 	int			nbits;
 	unsigned int		*data_map = NULL;
 	unsigned int		map_size = 0;
+	struct xfs_btree_block *block;
 	int                     error;
 
 	switch (buf_f->blf_type) {
@@ -1931,6 +1933,20 @@ xlog_recover_do_reg_buffer(
 		bit += nbits;
 	}
 
+	block = XFS_BUF_TO_BLOCK(bp);
+	switch (be32_to_cpu(block->bb_magic)) {
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
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-09-15 02:51:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-09-15 02:51:15.000000000 +0200
@@ -3060,6 +3060,26 @@ xfsidbg_print_btree_lblock(struct xfs_bt
 }
 
 static void
+xfsidbg_print_btree_sblock_crc(struct xfs_btree_block *block)
+{
+	xfsidbg_print_btree_sblock(block);
+	kdb_printf("blkno 0x%llx uuid %s crc %d\n",
+			(unsigned long long)be64_to_cpu(block->bb_u.s.bb_blkno),
+			xfs_fmtuuid(&block->bb_u.s.bb_uuid),
+			be32_to_cpu(block->bb_u.s.bb_crc));
+}
+
+static void
+xfsidbg_print_btree_lblock_crc(struct xfs_btree_block *block)
+{
+	xfsidbg_print_btree_lblock(block);
+	kdb_printf("blkno 0x%llx uuid %s crc %d\n",
+			(unsigned long long)be64_to_cpu(block->bb_u.l.bb_blkno),
+			xfs_fmtuuid(&block->bb_u.l.bb_uuid),
+			be32_to_cpu(block->bb_u.l.bb_crc));
+}
+
+static void
 xfsidbg_print_alloc_rec(int i, union xfs_btree_rec *rec)
 {
 	kdb_printf("rec %d startblock 0x%x blockcount %d\n", i,
@@ -3087,6 +3107,16 @@ static struct xfsidbg_btree xfsidbg_allo
 	.print_key	= xfsidbg_print_alloc_key,
 };
 
+static struct xfsidbg_btree xfsidbg_allocbtcrc = {
+	.block_len	= XFS_BTREE_SBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD,
+	.key_len	= sizeof(xfs_alloc_key_t),
+	.rec_len	= sizeof(xfs_alloc_rec_t),
+	.ptr_len	= sizeof(__be32),
+	.print_block	= xfsidbg_print_btree_sblock_crc,
+	.print_rec	= xfsidbg_print_alloc_rec,
+	.print_key	= xfsidbg_print_alloc_key,
+};
+
 static void
 xfsidbg_print_bmbt_rec(int i, union xfs_btree_rec *rec)
 {
@@ -3119,6 +3149,16 @@ static struct xfsidbg_btree xfsidbg_bmbt
 	.print_key	= xfsidbg_print_bmbt_key,
 };
 
+static struct xfsidbg_btree xfsidbg_bmbtcrc = {
+	.block_len	= XFS_BTREE_LBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD,
+	.key_len	= sizeof(xfs_bmbt_key_t),
+	.rec_len	= sizeof(xfs_bmbt_rec_t),
+	.ptr_len	= sizeof(__be64),
+	.print_block	= xfsidbg_print_btree_lblock_crc,
+	.print_rec	= xfsidbg_print_bmbt_rec,
+	.print_key	= xfsidbg_print_bmbt_key,
+};
+
 static void
 xfsidbg_print_inobt_rec(int i, union xfs_btree_rec *rec)
 {
@@ -3147,6 +3187,16 @@ static struct xfsidbg_btree xfsidbg_inob
 	.print_key	= xfsidbg_print_inobt_key,
 };
 
+static struct xfsidbg_btree xfsidbg_inobtbtcrc = {
+	.block_len	= XFS_BTREE_SBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD,
+	.key_len	= sizeof(xfs_inobt_key_t),
+	.rec_len	= sizeof(xfs_inobt_rec_t),
+	.ptr_len	= sizeof(__be32),
+	.print_block	= xfsidbg_print_btree_sblock_crc,
+	.print_rec	= xfsidbg_print_inobt_rec,
+	.print_key	= xfsidbg_print_inobt_key,
+};
+
 /*
  * Print an xfs in-inode bmap btree root.
  */
@@ -4830,6 +4880,38 @@ xfsidbg_xbuf_real(xfs_buf_t *bp, int sum
 			kdb_printf("buf 0x%p inobt 0x%p\n", bp, bt);
 			xfs_btblock(bt, XFS_BUF_COUNT(bp), &xfsidbg_inobtbt);
 		}
+	} else if (be32_to_cpu((bt = d)->bb_magic) == XFS_ABTB_CRC_MAGIC) {
+		if (summary) {
+			kdb_printf("Alloc BNO Btree blk, level %d (at 0x%p)\n",
+				       be16_to_cpu(bt->bb_level), bt);
+		} else {
+			kdb_printf("buf 0x%p abtbno 0x%p\n", bp, bt);
+			xfs_btblock(bt, XFS_BUF_COUNT(bp), &xfsidbg_allocbtcrc);
+		}
+	} else if (be32_to_cpu((bt = d)->bb_magic) == XFS_ABTC_CRC_MAGIC) {
+		if (summary) {
+			kdb_printf("Alloc COUNT Btree blk, level %d (at 0x%p)\n",
+				       be16_to_cpu(bt->bb_level), bt);
+		} else {
+			kdb_printf("buf 0x%p abtcnt 0x%p\n", bp, bt);
+			xfs_btblock(bt, XFS_BUF_COUNT(bp), &xfsidbg_allocbtcrc);
+		}
+	} else if (be32_to_cpu((bt = d)->bb_magic) == XFS_BMAP_CRC_MAGIC) {
+		if (summary) {
+			kdb_printf("Bmap Btree blk, level %d (at 0x%p)\n",
+				      be16_to_cpu(bt->bb_level), bt);
+		} else {
+			kdb_printf("buf 0x%p bmapbt 0x%p\n", bp, bt);
+			xfs_btblock(bt, XFS_BUF_COUNT(bp), &xfsidbg_bmbtcrc);
+		}
+	} else if (be32_to_cpu((bt = d)->bb_magic) == XFS_IBT_CRC_MAGIC) {
+		if (summary) {
+			kdb_printf("Inode Btree blk, level %d (at 0x%p)\n",
+				       be16_to_cpu(bt->bb_level), bt);
+		} else {
+			kdb_printf("buf 0x%p inobt 0x%p\n", bp, bt);
+			xfs_btblock(bt, XFS_BUF_COUNT(bp), &xfsidbg_inobtbtcrc);
+		}
 	} else if (be16_to_cpu((aleaf = d)->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC) {
 		if (summary) {
 			kdb_printf("Attr Leaf, 1st hash 0x%x (at 0x%p)\n",

-- 
