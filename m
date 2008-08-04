Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 18:31:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m741Vr1N030687
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 18:31:53 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1F203566B9
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 18:33:06 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id IjxGNwkmMV5Y74BJ for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 18:33:06 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m741X6IF008953
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 03:33:06 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m741X6c4008951
	for xfs@oss.sgi.com; Mon, 4 Aug 2008 03:33:06 +0200
Date: Mon, 4 Aug 2008 03:33:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/26] refactor xfs_btree_readahead
Message-ID: <20080804013306.GG8819@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-readahead-refactor
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

From: Dave Chinner <dgc@sgi.com>

Refactor xfs_btree_readahead to make it more readable:

 (a) remove the inline xfs_btree_readahead wrapper and move all checks out
     of line into the main routine.
 (b) factor out helpers for short/long form btrees
 (c) move check for root in inodes from the callers into xfs_btree_readahead


[hch: split out from a big patch and minor cleanups]


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-08-02 02:11:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-08-02 03:03:28.000000000 +0200
@@ -709,66 +709,84 @@ xfs_btree_reada_bufs(
 	xfs_baread(mp->m_ddev_targp, d, mp->m_bsize * count);
 }
 
+STATIC int
+xfs_btree_readahead_lblock(
+	struct xfs_btree_cur	*cur,
+	int			lr,
+	struct xfs_btree_block	*block)
+{
+	int			rval = 0;
+	xfs_fsblock_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
+	xfs_fsblock_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
+
+	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLDFSBNO) {
+		xfs_btree_reada_bufl(cur->bc_mp, left, 1);
+		rval++;
+	}
+
+	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLDFSBNO) {
+		xfs_btree_reada_bufl(cur->bc_mp, right, 1);
+		rval++;
+	}
+
+	return rval;
+}
+
+STATIC int
+xfs_btree_readahead_sblock(
+	struct xfs_btree_cur	*cur,
+	int			lr,
+	struct xfs_btree_block *block)
+{
+	int			rval = 0;
+	xfs_agblock_t		left = be32_to_cpu(block->bb_u.s.bb_leftsib);
+	xfs_agblock_t		right = be32_to_cpu(block->bb_u.s.bb_rightsib);
+
+
+	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLAGBLOCK) {
+		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
+				     left, 1);
+		rval++;
+	}
+
+	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLAGBLOCK) {
+		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
+				     right, 1);
+		rval++;
+	}
+
+	return rval;
+}
+
 /*
  * Read-ahead btree blocks, at the given level.
  * Bits in lr are set from XFS_BTCUR_{LEFT,RIGHT}RA.
  */
 int
-xfs_btree_readahead_core(
-	xfs_btree_cur_t		*cur,		/* btree cursor */
+xfs_btree_readahead(
+	struct xfs_btree_cur	*cur,		/* btree cursor */
 	int			lev,		/* level in btree */
 	int			lr)		/* left/right bits */
 {
-	xfs_alloc_block_t	*a;
-	xfs_bmbt_block_t	*b;
-	xfs_inobt_block_t	*i;
-	int			rval = 0;
+	struct xfs_btree_block	*block;
+
+	/*
+	 * No readahead needed if we are at the root level and the
+	 * btree root is stored in the inode.
+	 */
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    (lev == cur->bc_nlevels - 1))
+		return 0;
+
+	if ((cur->bc_ra[lev] | lr) == cur->bc_ra[lev])
+		return 0;
 
-	ASSERT(cur->bc_bufs[lev] != NULL);
 	cur->bc_ra[lev] |= lr;
-	switch (cur->bc_btnum) {
-	case XFS_BTNUM_BNO:
-	case XFS_BTNUM_CNT:
-		a = XFS_BUF_TO_ALLOC_BLOCK(cur->bc_bufs[lev]);
-		if ((lr & XFS_BTCUR_LEFTRA) && be32_to_cpu(a->bb_leftsib) != NULLAGBLOCK) {
-			xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
-				be32_to_cpu(a->bb_leftsib), 1);
-			rval++;
-		}
-		if ((lr & XFS_BTCUR_RIGHTRA) && be32_to_cpu(a->bb_rightsib) != NULLAGBLOCK) {
-			xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
-				be32_to_cpu(a->bb_rightsib), 1);
-			rval++;
-		}
-		break;
-	case XFS_BTNUM_BMAP:
-		b = XFS_BUF_TO_BMBT_BLOCK(cur->bc_bufs[lev]);
-		if ((lr & XFS_BTCUR_LEFTRA) && be64_to_cpu(b->bb_leftsib) != NULLDFSBNO) {
-			xfs_btree_reada_bufl(cur->bc_mp, be64_to_cpu(b->bb_leftsib), 1);
-			rval++;
-		}
-		if ((lr & XFS_BTCUR_RIGHTRA) && be64_to_cpu(b->bb_rightsib) != NULLDFSBNO) {
-			xfs_btree_reada_bufl(cur->bc_mp, be64_to_cpu(b->bb_rightsib), 1);
-			rval++;
-		}
-		break;
-	case XFS_BTNUM_INO:
-		i = XFS_BUF_TO_INOBT_BLOCK(cur->bc_bufs[lev]);
-		if ((lr & XFS_BTCUR_LEFTRA) && be32_to_cpu(i->bb_leftsib) != NULLAGBLOCK) {
-			xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
-				be32_to_cpu(i->bb_leftsib), 1);
-			rval++;
-		}
-		if ((lr & XFS_BTCUR_RIGHTRA) && be32_to_cpu(i->bb_rightsib) != NULLAGBLOCK) {
-			xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
-				be32_to_cpu(i->bb_rightsib), 1);
-			rval++;
-		}
-		break;
-	default:
-		ASSERT(0);
-	}
-	return rval;
+	block = XFS_BUF_TO_BLOCK(cur->bc_bufs[lev]);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		return xfs_btree_readahead_lblock(cur, lr, block);
+	return xfs_btree_readahead_sblock(cur, lr, block);
 }
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-08-02 02:11:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-08-02 03:00:21.000000000 +0200
@@ -429,23 +429,10 @@ xfs_btree_reada_bufs(
  * Bits in lr are set from XFS_BTCUR_{LEFT,RIGHT}RA.
  */
 int					/* readahead block count */
-xfs_btree_readahead_core(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			lev,	/* level in btree */
-	int			lr);	/* left/right bits */
-
-static inline int			/* readahead block count */
 xfs_btree_readahead(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	int			lev,	/* level in btree */
-	int			lr)	/* left/right bits */
-{
-	if ((cur->bc_ra[lev] | lr) == cur->bc_ra[lev])
-		return 0;
-
-	return xfs_btree_readahead_core(cur, lev, lr);
-}
-
+	int			lr);	/* left/right bits */
 
 /*
  * Set the buffer for level "lev" in the cursor to bp, releasing
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-08-02 02:11:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-08-02 03:00:18.000000000 +0200
@@ -1721,8 +1721,9 @@ xfs_bmbt_decrement(
 	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
 	XFS_BMBT_TRACE_ARGI(cur, level);
 	ASSERT(level < cur->bc_nlevels);
-	if (level < cur->bc_nlevels - 1)
-		xfs_btree_readahead(cur, level, XFS_BTCUR_LEFTRA);
+
+	xfs_btree_readahead(cur, level, XFS_BTCUR_LEFTRA);
+
 	if (--cur->bc_ptrs[level] > 0) {
 		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
 		*stat = 1;
@@ -1743,8 +1744,7 @@ xfs_bmbt_decrement(
 	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
 		if (--cur->bc_ptrs[lev] > 0)
 			break;
-		if (lev < cur->bc_nlevels - 1)
-			xfs_btree_readahead(cur, lev, XFS_BTCUR_LEFTRA);
+		xfs_btree_readahead(cur, lev, XFS_BTCUR_LEFTRA);
 	}
 	if (lev == cur->bc_nlevels) {
 		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
@@ -1995,8 +1995,8 @@ xfs_bmbt_increment(
 	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
 	XFS_BMBT_TRACE_ARGI(cur, level);
 	ASSERT(level < cur->bc_nlevels);
-	if (level < cur->bc_nlevels - 1)
-		xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
+
+	xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
 	block = xfs_bmbt_get_block(cur, level, &bp);
 #ifdef DEBUG
 	if ((error = xfs_btree_check_lblock(cur, block, level, bp))) {
@@ -2024,8 +2024,7 @@ xfs_bmbt_increment(
 #endif
 		if (++cur->bc_ptrs[lev] <= be16_to_cpu(block->bb_numrecs))
 			break;
-		if (lev < cur->bc_nlevels - 1)
-			xfs_btree_readahead(cur, lev, XFS_BTCUR_RIGHTRA);
+		xfs_btree_readahead(cur, lev, XFS_BTCUR_RIGHTRA);
 	}
 	if (lev == cur->bc_nlevels) {
 		XFS_BMBT_TRACE_CURSOR(cur, EXIT);

-- 
