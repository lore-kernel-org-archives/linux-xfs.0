Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 13:07:32 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NK7QhV015503
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:07:28 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1E7C1B3ED41
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:08:35 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 4vk7ZvOpByd9Y4WD for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:08:35 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6NK8QNg007445
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 22:08:26 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6NK8Q6S007443
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 22:08:26 +0200
Date: Wed, 23 Jul 2008 22:08:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/15] use the same btree_cur union member for alloc and inobt trees
Message-ID: <20080723200826.GC7401@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-cur-unification
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The alloc and inobt btree use the same agbp/agno pair in the btree_cur
union.  Make them use the same bc_private.a union member so that code
for these two short form btree implementations can be shared.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-16 03:02:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-16 03:24:19.000000000 +0200
@@ -158,8 +158,8 @@ typedef struct xfs_btree_cur
 	__uint8_t	bc_blocklog;	/* log2(blocksize) of btree blocks */
 	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
 	union {
-		struct {			/* needed for BNO, CNT */
-			struct xfs_buf	*agbp;	/* agf buffer pointer */
+		struct {			/* needed for BNO, CNT, INO */
+			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
 			xfs_agnumber_t	agno;	/* ag number */
 		} a;
 		struct {			/* needed for BMAP */
@@ -172,10 +172,6 @@ typedef struct xfs_btree_cur
 			char		flags;		/* flags */
 #define	XFS_BTCUR_BPRV_WASDEL	1			/* was delayed */
 		} b;
-		struct {			/* needed for INO */
-			struct xfs_buf	*agbp;	/* agi buffer pointer */
-			xfs_agnumber_t	agno;	/* ag number */
-		} i;
 	}		bc_private;	/* per-btree type data */
 } xfs_btree_cur_t;
 
Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-16 03:24:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-16 03:24:19.000000000 +0200
@@ -570,6 +570,13 @@ xfs_btree_init_cursor(
 		cur->bc_private.a.agbp = agbp;
 		cur->bc_private.a.agno = agno;
 		break;
+	case XFS_BTNUM_INO:
+		/*
+		 * Inode allocation btree fields.
+		 */
+		cur->bc_private.a.agbp = agbp;
+		cur->bc_private.a.agno = agno;
+		break;
 	case XFS_BTNUM_BMAP:
 		/*
 		 * Bmap btree fields.
@@ -582,13 +589,6 @@ xfs_btree_init_cursor(
 		cur->bc_private.b.flags = 0;
 		cur->bc_private.b.whichfork = whichfork;
 		break;
-	case XFS_BTNUM_INO:
-		/*
-		 * Inode allocation btree fields.
-		 */
-		cur->bc_private.i.agbp = agbp;
-		cur->bc_private.i.agno = agno;
-		break;
 	default:
 		ASSERT(0);
 	}
@@ -863,12 +863,12 @@ xfs_btree_readahead_core(
 	case XFS_BTNUM_INO:
 		i = XFS_BUF_TO_INOBT_BLOCK(cur->bc_bufs[lev]);
 		if ((lr & XFS_BTCUR_LEFTRA) && be32_to_cpu(i->bb_leftsib) != NULLAGBLOCK) {
-			xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.i.agno,
+			xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
 				be32_to_cpu(i->bb_leftsib), 1);
 			rval++;
 		}
 		if ((lr & XFS_BTCUR_RIGHTRA) && be32_to_cpu(i->bb_rightsib) != NULLAGBLOCK) {
-			xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.i.agno,
+			xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
 				be32_to_cpu(i->bb_rightsib), 1);
 			rval++;
 		}
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-07-16 03:02:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-07-16 03:24:19.000000000 +0200
@@ -181,7 +181,7 @@ xfs_inobt_delrec(
 		 * then we can get rid of this level.
 		 */
 		if (numrecs == 1 && level > 0) {
-			agbp = cur->bc_private.i.agbp;
+			agbp = cur->bc_private.a.agbp;
 			agi = XFS_BUF_TO_AGI(agbp);
 			/*
 			 * pp is still set to the first pointer in the block.
@@ -194,7 +194,7 @@ xfs_inobt_delrec(
 			 * Free the block.
 			 */
 			if ((error = xfs_free_extent(cur->bc_tp,
-				XFS_AGB_TO_FSB(mp, cur->bc_private.i.agno, bno), 1)))
+				XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno, bno), 1)))
 				return error;
 			xfs_trans_binval(cur->bc_tp, bp);
 			xfs_ialloc_log_agi(cur->bc_tp, agbp,
@@ -379,7 +379,7 @@ xfs_inobt_delrec(
 		rrecs = be16_to_cpu(right->bb_numrecs);
 		rbp = bp;
 		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.i.agno, lbno, 0, &lbp,
+				cur->bc_private.a.agno, lbno, 0, &lbp,
 				XFS_INO_BTREE_REF)))
 			return error;
 		left = XFS_BUF_TO_INOBT_BLOCK(lbp);
@@ -401,7 +401,7 @@ xfs_inobt_delrec(
 		lrecs = be16_to_cpu(left->bb_numrecs);
 		lbp = bp;
 		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.i.agno, rbno, 0, &rbp,
+				cur->bc_private.a.agno, rbno, 0, &rbp,
 				XFS_INO_BTREE_REF)))
 			return error;
 		right = XFS_BUF_TO_INOBT_BLOCK(rbp);
@@ -484,7 +484,7 @@ xfs_inobt_delrec(
 		xfs_buf_t		*rrbp;
 
 		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.i.agno, be32_to_cpu(left->bb_rightsib), 0,
+				cur->bc_private.a.agno, be32_to_cpu(left->bb_rightsib), 0,
 				&rrbp, XFS_INO_BTREE_REF)))
 			return error;
 		rrblock = XFS_BUF_TO_INOBT_BLOCK(rrbp);
@@ -497,7 +497,7 @@ xfs_inobt_delrec(
 	 * Free the deleting block.
 	 */
 	if ((error = xfs_free_extent(cur->bc_tp, XFS_AGB_TO_FSB(mp,
-				     cur->bc_private.i.agno, rbno), 1)))
+				     cur->bc_private.a.agno, rbno), 1)))
 		return error;
 	xfs_trans_binval(cur->bc_tp, rbp);
 	/*
@@ -854,7 +854,7 @@ xfs_inobt_lookup(
 	{
 		xfs_agi_t	*agi;	/* a.g. inode header */
 
-		agi = XFS_BUF_TO_AGI(cur->bc_private.i.agbp);
+		agi = XFS_BUF_TO_AGI(cur->bc_private.a.agbp);
 		agno = be32_to_cpu(agi->agi_seqno);
 		agbno = be32_to_cpu(agi->agi_root);
 	}
@@ -1089,7 +1089,7 @@ xfs_inobt_lshift(
 	 * Set up the left neighbor as "left".
 	 */
 	if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.i.agno, be32_to_cpu(right->bb_leftsib),
+			cur->bc_private.a.agno, be32_to_cpu(right->bb_leftsib),
 			0, &lbp, XFS_INO_BTREE_REF)))
 		return error;
 	left = XFS_BUF_TO_INOBT_BLOCK(lbp);
@@ -1207,10 +1207,10 @@ xfs_inobt_newroot(
 	/*
 	 * Get a block & a buffer.
 	 */
-	agi = XFS_BUF_TO_AGI(cur->bc_private.i.agbp);
+	agi = XFS_BUF_TO_AGI(cur->bc_private.a.agbp);
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.i.agno,
+	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno,
 		be32_to_cpu(agi->agi_root));
 	args.mod = args.minleft = args.alignment = args.total = args.wasdel =
 		args.isfl = args.userdata = args.minalignslop = 0;
@@ -1233,7 +1233,7 @@ xfs_inobt_newroot(
 	 */
 	agi->agi_root = cpu_to_be32(args.agbno);
 	be32_add(&agi->agi_level, 1);
-	xfs_ialloc_log_agi(args.tp, cur->bc_private.i.agbp,
+	xfs_ialloc_log_agi(args.tp, cur->bc_private.a.agbp,
 		XFS_AGI_ROOT | XFS_AGI_LEVEL);
 	/*
 	 * At the previous root level there are now two blocks: the old
@@ -1376,7 +1376,7 @@ xfs_inobt_rshift(
 	 * Set up the right neighbor as "right".
 	 */
 	if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.i.agno, be32_to_cpu(left->bb_rightsib),
+			cur->bc_private.a.agno, be32_to_cpu(left->bb_rightsib),
 			0, &rbp, XFS_INO_BTREE_REF)))
 		return error;
 	right = XFS_BUF_TO_INOBT_BLOCK(rbp);
@@ -1492,7 +1492,7 @@ xfs_inobt_split(
 	 * Allocate the new block.
 	 * If we can't do it, we're toast.  Give up.
 	 */
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.i.agno, lbno);
+	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, lbno);
 	args.mod = args.minleft = args.alignment = args.total = args.wasdel =
 		args.isfl = args.userdata = args.minalignslop = 0;
 	args.minlen = args.maxlen = args.prod = 1;
@@ -1725,7 +1725,7 @@ xfs_inobt_decrement(
 
 		agbno = be32_to_cpu(*XFS_INOBT_PTR_ADDR(block, cur->bc_ptrs[lev], cur));
 		if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-				cur->bc_private.i.agno, agbno, 0, &bp,
+				cur->bc_private.a.agno, agbno, 0, &bp,
 				XFS_INO_BTREE_REF)))
 			return error;
 		lev--;
@@ -1897,7 +1897,7 @@ xfs_inobt_increment(
 
 		agbno = be32_to_cpu(*XFS_INOBT_PTR_ADDR(block, cur->bc_ptrs[lev], cur));
 		if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-				cur->bc_private.i.agno, agbno, 0, &bp,
+				cur->bc_private.a.agno, agbno, 0, &bp,
 				XFS_INO_BTREE_REF)))
 			return error;
 		lev--;
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-07-16 03:29:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-07-16 03:30:17.000000000 +0200
@@ -4579,10 +4579,6 @@ xfsidbg_xbtcur(xfs_btree_cur_t *c)
 			xfs_fmtfsblock(c->bc_private.b.firstblock, c->bc_mp),
 			c->bc_private.b.flist,
 			c->bc_private.b.allocated);
-	} else if (c->bc_btnum == XFS_BTNUM_INO) {
-		kdb_printf("private agbp 0x%p agno 0x%x\n",
-			c->bc_private.i.agbp,
-			c->bc_private.i.agno);
 	} else {
 		kdb_printf("private agbp 0x%p agno 0x%x\n",
 			c->bc_private.a.agbp,

-- 
