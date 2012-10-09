Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q993o8PU212962 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 22:50:08 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	LPdHYtHL1KEW0GJ0 for <xfs@oss.sgi.com>;
	Mon, 08 Oct 2012 20:51:36 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TLQqq-0002PJ-HR
	for xfs@oss.sgi.com; Tue, 09 Oct 2012 14:51:24 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TLQqg-0008PL-FH
	for xfs@oss.sgi.com; Tue, 09 Oct 2012 14:51:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/19] xfs: verify btree blocks as they are read from disk
Date: Tue,  9 Oct 2012 14:51:00 +1100
Message-Id: <1349754670-32009-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1349754670-32009-1-git-send-email-david@fromorbit.com>
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Add an btree block verify callback function and pass it into the
buffer read functions. Because each different btree block type
requires different verification, add a function to the ops structure
that is called from the generic code.

Also, propagate the verification callback functions through the
readahead functions, and into the external bmap and bulkstat inode
readahead code that uses the generic btree buffer read functions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc_btree.c  |   49 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap.c         |   60 ++++++++++++++++++++++++-----------------
 fs/xfs/xfs_bmap_btree.c   |   47 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_btree.h   |    1 +
 fs/xfs/xfs_btree.c        |   66 +++++++++++++++++++++++----------------------
 fs/xfs/xfs_btree.h        |   10 ++++---
 fs/xfs/xfs_ialloc_btree.c |   40 +++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c        |    2 +-
 fs/xfs/xfs_inode.h        |    1 +
 fs/xfs/xfs_itable.c       |    3 ++-
 10 files changed, 218 insertions(+), 61 deletions(-)

diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index f1647ca..4dbe323 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -270,6 +270,54 @@ xfs_allocbt_key_diff(
 	return (__int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
 }
 
+void
+xfs_allocbt_read_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_perag	*pag = bp->b_pag;
+	unsigned int		level;
+	int			sblock_ok; /* block passes checks */
+
+	/* magic number and level verification */
+	level = be16_to_cpu(block->bb_level);
+	switch (block->bb_magic) {
+	case cpu_to_be32(XFS_ABTB_MAGIC):
+		sblock_ok = level < pag->pagf_levels[XFS_BTNUM_BNOi];
+		break;
+	case cpu_to_be32(XFS_ABTC_MAGIC):
+		sblock_ok = level < pag->pagf_levels[XFS_BTNUM_CNTi];
+		break;
+	default:
+		sblock_ok = 0;
+		break;
+	}
+
+	/* numrecs verification */
+	sblock_ok = sblock_ok &&
+		be16_to_cpu(block->bb_numrecs) <= mp->m_alloc_mxr[level != 0];
+
+	/* sibling pointer verification */
+	sblock_ok = sblock_ok &&
+		(block->bb_u.s.bb_leftsib == cpu_to_be32(NULLAGBLOCK) ||
+		 be32_to_cpu(block->bb_u.s.bb_leftsib) < mp->m_sb.sb_agblocks) &&
+		block->bb_u.s.bb_leftsib &&
+		(block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK) ||
+		 be32_to_cpu(block->bb_u.s.bb_rightsib) < mp->m_sb.sb_agblocks) &&
+		block->bb_u.s.bb_rightsib;
+
+	if (!sblock_ok) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		XFS_CORRUPTION_ERROR("xfs_allocbt_read_verify",
+					XFS_ERRLEVEL_LOW, mp, block);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
 #ifdef DEBUG
 STATIC int
 xfs_allocbt_keys_inorder(
@@ -325,6 +373,7 @@ static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.key_diff		= xfs_allocbt_key_diff,
+	.read_verify		= xfs_allocbt_read_verify,
 #ifdef DEBUG
 	.keys_inorder		= xfs_allocbt_keys_inorder,
 	.recs_inorder		= xfs_allocbt_recs_inorder,
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 83d0cf3..8e944bb 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -2662,8 +2662,9 @@ xfs_bmap_btree_to_extents(
 	if ((error = xfs_btree_check_lptr(cur, cbno, 1)))
 		return error;
 #endif
-	if ((error = xfs_btree_read_bufl(mp, tp, cbno, 0, &cbp,
-			XFS_BMAP_BTREE_REF)))
+	error = xfs_btree_read_bufl(mp, tp, cbno, 0, &cbp, XFS_BMAP_BTREE_REF,
+				xfs_bmbt_read_verify);
+	if (error)
 		return error;
 	cblock = XFS_BUF_TO_BLOCK(cbp);
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
@@ -4078,8 +4079,9 @@ xfs_bmap_read_extents(
 	 * pointer (leftmost) at each level.
 	 */
 	while (level-- > 0) {
-		if ((error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
-				XFS_BMAP_BTREE_REF)))
+		error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
+				XFS_BMAP_BTREE_REF, xfs_bmbt_read_verify);
+		if (error)
 			return error;
 		block = XFS_BUF_TO_BLOCK(bp);
 		XFS_WANT_CORRUPTED_GOTO(
@@ -4124,7 +4126,8 @@ xfs_bmap_read_extents(
 		 */
 		nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
 		if (nextbno != NULLFSBLOCK)
-			xfs_btree_reada_bufl(mp, nextbno, 1);
+			xfs_btree_reada_bufl(mp, nextbno, 1,
+					     xfs_bmbt_read_verify);
 		/*
 		 * Copy records into the extent records.
 		 */
@@ -4156,8 +4159,9 @@ xfs_bmap_read_extents(
 		 */
 		if (bno == NULLFSBLOCK)
 			break;
-		if ((error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
-				XFS_BMAP_BTREE_REF)))
+		error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
+				XFS_BMAP_BTREE_REF, xfs_bmbt_read_verify);
+		if (error)
 			return error;
 		block = XFS_BUF_TO_BLOCK(bp);
 	}
@@ -5868,15 +5872,16 @@ xfs_bmap_check_leaf_extents(
 	 */
 	while (level-- > 0) {
 		/* See if buf is in cur first */
+		bp_release = 0;
 		bp = xfs_bmap_get_bp(cur, XFS_FSB_TO_DADDR(mp, bno));
-		if (bp) {
-			bp_release = 0;
-		} else {
+		if (!bp) {
 			bp_release = 1;
+			error = xfs_btree_read_bufl(mp, NULL, bno, 0, &bp,
+						XFS_BMAP_BTREE_REF,
+						xfs_bmbt_read_verify);
+			if (error)
+				goto error_norelse;
 		}
-		if (!bp && (error = xfs_btree_read_bufl(mp, NULL, bno, 0, &bp,
-				XFS_BMAP_BTREE_REF)))
-			goto error_norelse;
 		block = XFS_BUF_TO_BLOCK(bp);
 		XFS_WANT_CORRUPTED_GOTO(
 			xfs_bmap_sanity_check(mp, bp, level),
@@ -5953,15 +5958,16 @@ xfs_bmap_check_leaf_extents(
 		if (bno == NULLFSBLOCK)
 			break;
 
+		bp_release = 0;
 		bp = xfs_bmap_get_bp(cur, XFS_FSB_TO_DADDR(mp, bno));
-		if (bp) {
-			bp_release = 0;
-		} else {
+		if (!bp) {
 			bp_release = 1;
+			error = xfs_btree_read_bufl(mp, NULL, bno, 0, &bp,
+						XFS_BMAP_BTREE_REF,
+						xfs_bmbt_read_verify);
+			if (error)
+				goto error_norelse;
 		}
-		if (!bp && (error = xfs_btree_read_bufl(mp, NULL, bno, 0, &bp,
-				XFS_BMAP_BTREE_REF)))
-			goto error_norelse;
 		block = XFS_BUF_TO_BLOCK(bp);
 	}
 	if (bp_release) {
@@ -6052,7 +6058,9 @@ xfs_bmap_count_tree(
 	struct xfs_btree_block	*block, *nextblock;
 	int			numrecs;
 
-	if ((error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp, XFS_BMAP_BTREE_REF)))
+	error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp, XFS_BMAP_BTREE_REF,
+						xfs_bmbt_read_verify);
+	if (error)
 		return error;
 	*count += 1;
 	block = XFS_BUF_TO_BLOCK(bp);
@@ -6061,8 +6069,10 @@ xfs_bmap_count_tree(
 		/* Not at node above leaves, count this level of nodes */
 		nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
 		while (nextbno != NULLFSBLOCK) {
-			if ((error = xfs_btree_read_bufl(mp, tp, nextbno,
-				0, &nbp, XFS_BMAP_BTREE_REF)))
+			error = xfs_btree_read_bufl(mp, tp, nextbno, 0, &nbp,
+						XFS_BMAP_BTREE_REF,
+						xfs_bmbt_read_verify);
+			if (error)
 				return error;
 			*count += 1;
 			nextblock = XFS_BUF_TO_BLOCK(nbp);
@@ -6091,8 +6101,10 @@ xfs_bmap_count_tree(
 			if (nextbno == NULLFSBLOCK)
 				break;
 			bno = nextbno;
-			if ((error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
-				XFS_BMAP_BTREE_REF)))
+			error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
+						XFS_BMAP_BTREE_REF,
+						xfs_bmbt_read_verify);
+			if (error)
 				return error;
 			*count += 1;
 			block = XFS_BUF_TO_BLOCK(bp);
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index 862084a..bddca9b 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -36,6 +36,7 @@
 #include "xfs_bmap.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
+#include "xfs_trace.h"
 
 /*
  * Determine the extent state.
@@ -707,6 +708,51 @@ xfs_bmbt_key_diff(
 				      cur->bc_rec.b.br_startoff;
 }
 
+void
+xfs_bmbt_read_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	unsigned int		level;
+	int			lblock_ok; /* block passes checks */
+
+	/* magic number and level verification.
+	 *
+	 * We don't know waht fork we belong to, so just verify that the level
+	 * is less than the maximum of the two. Later checks will be more
+	 * precise.
+	 */
+	level = be16_to_cpu(block->bb_level);
+	lblock_ok = block->bb_magic == cpu_to_be32(XFS_BMAP_MAGIC) &&
+		    level < max(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]);
+
+	/* numrecs verification */
+	lblock_ok = lblock_ok &&
+		be16_to_cpu(block->bb_numrecs) <= mp->m_bmap_dmxr[level != 0];
+
+	/* sibling pointer verification */
+	lblock_ok = lblock_ok &&
+		block->bb_u.l.bb_leftsib &&
+		(block->bb_u.l.bb_leftsib == cpu_to_be64(NULLDFSBNO) ||
+		 XFS_FSB_SANITY_CHECK(mp,
+			be64_to_cpu(block->bb_u.l.bb_leftsib))) &&
+		block->bb_u.l.bb_rightsib &&
+		(block->bb_u.l.bb_rightsib == cpu_to_be64(NULLDFSBNO) ||
+		 XFS_FSB_SANITY_CHECK(mp,
+			be64_to_cpu(block->bb_u.l.bb_rightsib)));
+
+	if (!lblock_ok) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		XFS_CORRUPTION_ERROR("xfs_bmbt_read_verify",
+					XFS_ERRLEVEL_LOW, mp, block);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
 #ifdef DEBUG
 STATIC int
 xfs_bmbt_keys_inorder(
@@ -746,6 +792,7 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
+	.read_verify		= xfs_bmbt_read_verify,
 #ifdef DEBUG
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
diff --git a/fs/xfs/xfs_bmap_btree.h b/fs/xfs/xfs_bmap_btree.h
index 0e66c4e..1d00fbe 100644
--- a/fs/xfs/xfs_bmap_btree.h
+++ b/fs/xfs/xfs_bmap_btree.h
@@ -232,6 +232,7 @@ extern void xfs_bmbt_to_bmdr(struct xfs_mount *, struct xfs_btree_block *, int,
 extern int xfs_bmbt_get_maxrecs(struct xfs_btree_cur *, int level);
 extern int xfs_bmdr_maxrecs(struct xfs_mount *, int blocklen, int leaf);
 extern int xfs_bmbt_maxrecs(struct xfs_mount *, int blocklen, int leaf);
+extern void xfs_bmbt_read_verify(struct xfs_buf *bp);
 
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 1937c9b..b680949 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -270,7 +270,8 @@ xfs_btree_dup_cursor(
 		if (bp) {
 			error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 						   XFS_BUF_ADDR(bp), mp->m_bsize,
-						   0, &bp, NULL);
+						   0, &bp,
+						   cur->bc_ops->read_verify);
 			if (error) {
 				xfs_btree_del_cursor(new, error);
 				*ncur = NULL;
@@ -612,23 +613,24 @@ xfs_btree_offsets(
  * Get a buffer for the block, return it read in.
  * Long-form addressing.
  */
-int					/* error */
+int
 xfs_btree_read_bufl(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_fsblock_t	fsbno,		/* file system block number */
-	uint		lock,		/* lock flags for read_buf */
-	xfs_buf_t	**bpp,		/* buffer for fsbno */
-	int		refval)		/* ref count value for buffer */
-{
-	xfs_buf_t	*bp;		/* return value */
+	struct xfs_mount	*mp,		/* file system mount point */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	xfs_fsblock_t		fsbno,		/* file system block number */
+	uint			lock,		/* lock flags for read_buf */
+	struct xfs_buf		**bpp,		/* buffer for fsbno */
+	int			refval,		/* ref count value for buffer */
+	xfs_buf_iodone_t	verify)
+{
+	struct xfs_buf		*bp;		/* return value */
 	xfs_daddr_t		d;		/* real disk block address */
-	int		error;
+	int			error;
 
 	ASSERT(fsbno != NULLFSBLOCK);
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, d,
-				   mp->m_bsize, lock, &bp, NULL);
+				   mp->m_bsize, lock, &bp, verify);
 	if (error)
 		return error;
 	ASSERT(!xfs_buf_geterror(bp));
@@ -645,15 +647,16 @@ xfs_btree_read_bufl(
 /* ARGSUSED */
 void
 xfs_btree_reada_bufl(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_fsblock_t	fsbno,		/* file system block number */
-	xfs_extlen_t	count)		/* count of filesystem blocks */
+	struct xfs_mount	*mp,		/* file system mount point */
+	xfs_fsblock_t		fsbno,		/* file system block number */
+	xfs_extlen_t		count,		/* count of filesystem blocks */
+	xfs_buf_iodone_t	verify)
 {
 	xfs_daddr_t		d;
 
 	ASSERT(fsbno != NULLFSBLOCK);
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
-	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count, NULL);
+	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count, verify);
 }
 
 /*
@@ -663,17 +666,18 @@ xfs_btree_reada_bufl(
 /* ARGSUSED */
 void
 xfs_btree_reada_bufs(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	xfs_agblock_t	agbno,		/* allocation group block number */
-	xfs_extlen_t	count)		/* count of filesystem blocks */
+	struct xfs_mount	*mp,		/* file system mount point */
+	xfs_agnumber_t		agno,		/* allocation group number */
+	xfs_agblock_t		agbno,		/* allocation group block number */
+	xfs_extlen_t		count,		/* count of filesystem blocks */
+	xfs_buf_iodone_t	verify)
 {
 	xfs_daddr_t		d;
 
 	ASSERT(agno != NULLAGNUMBER);
 	ASSERT(agbno != NULLAGBLOCK);
 	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
-	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count, NULL);
+	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count, verify);
 }
 
 STATIC int
@@ -687,12 +691,14 @@ xfs_btree_readahead_lblock(
 	xfs_dfsbno_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLDFSBNO) {
-		xfs_btree_reada_bufl(cur->bc_mp, left, 1);
+		xfs_btree_reada_bufl(cur->bc_mp, left, 1,
+				     cur->bc_ops->read_verify);
 		rval++;
 	}
 
 	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLDFSBNO) {
-		xfs_btree_reada_bufl(cur->bc_mp, right, 1);
+		xfs_btree_reada_bufl(cur->bc_mp, right, 1,
+				     cur->bc_ops->read_verify);
 		rval++;
 	}
 
@@ -712,13 +718,13 @@ xfs_btree_readahead_sblock(
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLAGBLOCK) {
 		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
-				     left, 1);
+				     left, 1, cur->bc_ops->read_verify);
 		rval++;
 	}
 
 	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLAGBLOCK) {
 		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
-				     right, 1);
+				     right, 1, cur->bc_ops->read_verify);
 		rval++;
 	}
 
@@ -1001,19 +1007,15 @@ xfs_btree_read_buf_block(
 
 	d = xfs_btree_ptr_to_daddr(cur, ptr);
 	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
-				   mp->m_bsize, flags, bpp, NULL);
+				   mp->m_bsize, flags, bpp,
+				   cur->bc_ops->read_verify);
 	if (error)
 		return error;
 
 	ASSERT(!xfs_buf_geterror(*bpp));
-
 	xfs_btree_set_refs(cur, *bpp);
 	*block = XFS_BUF_TO_BLOCK(*bpp);
-
-	error = xfs_btree_check_block(cur, *block, level, *bpp);
-	if (error)
-		xfs_trans_brelse(cur->bc_tp, *bpp);
-	return error;
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_btree.h b/fs/xfs/xfs_btree.h
index 5b240de..7c3cb8d 100644
--- a/fs/xfs/xfs_btree.h
+++ b/fs/xfs/xfs_btree.h
@@ -188,6 +188,7 @@ struct xfs_btree_ops {
 	__int64_t (*key_diff)(struct xfs_btree_cur *cur,
 			      union xfs_btree_key *key);
 
+	void	(*read_verify)(struct xfs_buf *bp);
 #ifdef DEBUG
 	/* check that k1 is lower than k2 */
 	int	(*keys_inorder)(struct xfs_btree_cur *cur,
@@ -355,7 +356,8 @@ xfs_btree_read_bufl(
 	xfs_fsblock_t		fsbno,	/* file system block number */
 	uint			lock,	/* lock flags for read_buf */
 	struct xfs_buf		**bpp,	/* buffer for fsbno */
-	int			refval);/* ref count value for buffer */
+	int			refval,	/* ref count value for buffer */
+	xfs_buf_iodone_t	verify);
 
 /*
  * Read-ahead the block, don't wait for it, don't return a buffer.
@@ -365,7 +367,8 @@ void					/* error */
 xfs_btree_reada_bufl(
 	struct xfs_mount	*mp,	/* file system mount point */
 	xfs_fsblock_t		fsbno,	/* file system block number */
-	xfs_extlen_t		count);	/* count of filesystem blocks */
+	xfs_extlen_t		count,	/* count of filesystem blocks */
+	xfs_buf_iodone_t	verify);
 
 /*
  * Read-ahead the block, don't wait for it, don't return a buffer.
@@ -376,7 +379,8 @@ xfs_btree_reada_bufs(
 	struct xfs_mount	*mp,	/* file system mount point */
 	xfs_agnumber_t		agno,	/* allocation group number */
 	xfs_agblock_t		agbno,	/* allocation group block number */
-	xfs_extlen_t		count);	/* count of filesystem blocks */
+	xfs_extlen_t		count,	/* count of filesystem blocks */
+	xfs_buf_iodone_t	verify);
 
 
 /*
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index 2b8b7a3..11306c6 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -33,6 +33,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
+#include "xfs_trace.h"
 
 
 STATIC int
@@ -181,6 +182,44 @@ xfs_inobt_key_diff(
 			  cur->bc_rec.i.ir_startino;
 }
 
+void
+xfs_inobt_read_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	unsigned int		level;
+	int			sblock_ok; /* block passes checks */
+
+	/* magic number and level verification */
+	level = be16_to_cpu(block->bb_level);
+	sblock_ok = block->bb_magic == cpu_to_be32(XFS_IBT_MAGIC) &&
+		    level < mp->m_in_maxlevels;
+
+	/* numrecs verification */
+	sblock_ok = sblock_ok &&
+		be16_to_cpu(block->bb_numrecs) <= mp->m_inobt_mxr[level != 0];
+
+	/* sibling pointer verification */
+	sblock_ok = sblock_ok &&
+		(block->bb_u.s.bb_leftsib == cpu_to_be32(NULLAGBLOCK) ||
+		 be32_to_cpu(block->bb_u.s.bb_leftsib) < mp->m_sb.sb_agblocks) &&
+		block->bb_u.s.bb_leftsib &&
+		(block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK) ||
+		 be32_to_cpu(block->bb_u.s.bb_rightsib) < mp->m_sb.sb_agblocks) &&
+		block->bb_u.s.bb_rightsib;
+
+	if (!sblock_ok) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		XFS_CORRUPTION_ERROR("xfs_inobt_read_verify",
+					XFS_ERRLEVEL_LOW, mp, block);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
 #ifdef DEBUG
 STATIC int
 xfs_inobt_keys_inorder(
@@ -218,6 +257,7 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
+	.read_verify		= xfs_inobt_read_verify,
 #ifdef DEBUG
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5baf6cb..0905e72 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -382,7 +382,7 @@ xfs_inobp_check(
 }
 #endif
 
-static void
+void
 xfs_inode_buf_verify(
 	struct xfs_buf	*bp)
 {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1fc2065..3c1d831 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -554,6 +554,7 @@ int		xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
 			       struct xfs_buf **, uint, uint);
 int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_inode *, uint);
+void		xfs_inode_buf_verify(struct xfs_buf *);
 void		xfs_dinode_to_disk(struct xfs_dinode *,
 				   struct xfs_icdinode *);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 3998fd2..0f18d41 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -396,7 +396,8 @@ xfs_bulkstat(
 					if (xfs_inobt_maskn(chunkidx, nicluster)
 							& ~r.ir_free)
 						xfs_btree_reada_bufs(mp, agno,
-							agbno, nbcluster);
+							agbno, nbcluster,
+							xfs_inode_buf_verify);
 				}
 				irbp->ir_startino = r.ir_startino;
 				irbp->ir_freecount = r.ir_freecount;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
