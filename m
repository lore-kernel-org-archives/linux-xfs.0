Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51016 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756628AbeDBT5x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Apr 2018 15:57:53 -0400
Subject: [PATCH 10/21] xfs: add helper routines for the repair code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 02 Apr 2018 12:57:18 -0700
Message-ID: <152269903810.16346.11410639151264264247.stgit@magnolia>
In-Reply-To: <152269897182.16346.1710955088267364781.stgit@magnolia>
References: <152269897182.16346.1710955088267364781.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Add some helper functions for repair functions that will help us to
allocate and initialize new metadata blocks for btrees that we're
rebuilding.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bmap.c   |    3 
 fs/xfs/scrub/common.c |    8 
 fs/xfs/scrub/common.h |    9 +
 fs/xfs/scrub/inode.c  |    4 
 fs/xfs/scrub/repair.c |  816 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |   78 +++++
 fs/xfs/scrub/scrub.c  |    2 
 fs/xfs/scrub/scrub.h  |    1 
 8 files changed, 915 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 639d14b..cecc447 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -74,8 +74,7 @@ xfs_scrub_setup_inode_bmap(
 			goto out;
 	}
 
-	/* Got the inode, lock it and we're ready to go. */
-	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
+	error = xfs_scrub_trans_alloc(sc->sm, mp, 0, &sc->tp);
 	if (error)
 		goto out;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index ddb0ff6..056d46e 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -49,6 +49,7 @@
 #include "scrub/common.h"
 #include "scrub/trace.h"
 #include "scrub/btree.h"
+#include "scrub/repair.h"
 
 /* Common code for the metadata scrubbers. */
 
@@ -574,7 +575,10 @@ xfs_scrub_setup_fs(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	return xfs_scrub_trans_alloc(sc->sm, sc->mp, &sc->tp);
+	uint				resblks;
+
+	resblks = xfs_repair_calc_ag_resblks(sc);
+	return xfs_scrub_trans_alloc(sc->sm, sc->mp, resblks, &sc->tp);
 }
 
 /* Set us up with AG headers and btree cursors. */
@@ -705,7 +709,7 @@ xfs_scrub_setup_inode_contents(
 	/* Got the inode, lock it and we're ready to go. */
 	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
-	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
+	error = xfs_scrub_trans_alloc(sc->sm, mp, resblks, &sc->tp);
 	if (error)
 		goto out;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 140e90c..e6875f8 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -41,13 +41,22 @@ xfs_scrub_should_terminate(
 /*
  * Grab an empty transaction so that we can re-grab locked buffers if
  * one of our btrees turns out to be cyclic.
+ *
+ * If we're going to repair something, we need to ask for the largest
+ * possible log reservation so that we can handle the worst case
+ * scenario for rebuilding a metadata item.
  */
 static inline int
 xfs_scrub_trans_alloc(
 	struct xfs_scrub_metadata	*sm,
 	struct xfs_mount		*mp,
+	uint				blocks,
 	struct xfs_trans		**tpp)
 {
+	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+		return xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+				blocks, 0, 0, tpp);
+
 	return xfs_trans_alloc_empty(mp, tpp);
 }
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index df14930..28a0d92 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -68,7 +68,7 @@ xfs_scrub_setup_inode(
 		break;
 	case -EFSCORRUPTED:
 	case -EFSBADCRC:
-		return xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
+		return xfs_scrub_trans_alloc(sc->sm, mp, 0, &sc->tp);
 	default:
 		return error;
 	}
@@ -76,7 +76,7 @@ xfs_scrub_setup_inode(
 	/* Got the inode, lock it and we're ready to go. */
 	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
-	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
+	error = xfs_scrub_trans_alloc(sc->sm, mp, 0, &sc->tp);
 	if (error)
 		goto out;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 69ffb94..11c2257 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -63,3 +63,819 @@ xfs_repair_probe(
 
 	return 0;
 }
+
+/*
+ * Roll a transaction, keeping the AG headers locked and reinitializing
+ * the btree cursors.
+ */
+int
+xfs_repair_roll_ag_trans(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_trans		*tp;
+	int				error;
+
+	/* Keep the AG header buffers locked so we can keep going. */
+	xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
+	xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
+	xfs_trans_bhold(sc->tp, sc->sa.agfl_bp);
+
+	/* Roll the transaction. */
+	tp = sc->tp;
+	error = xfs_trans_roll(&sc->tp);
+	if (error)
+		return error;
+
+	/* Join the buffer to the new transaction or release the hold. */
+	if (sc->tp != tp) {
+		xfs_trans_bjoin(sc->tp, sc->sa.agi_bp);
+		xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
+		xfs_trans_bjoin(sc->tp, sc->sa.agfl_bp);
+	} else {
+		xfs_trans_bhold_release(sc->tp, sc->sa.agi_bp);
+		xfs_trans_bhold_release(sc->tp, sc->sa.agf_bp);
+		xfs_trans_bhold_release(sc->tp, sc->sa.agfl_bp);
+	}
+
+	return error;
+}
+
+/*
+ * Does the given AG have enough space to rebuild a btree?  Neither AG
+ * reservation can be critical, and we must have enough space (factoring
+ * in AG reservations) to construct a whole btree.
+ */
+bool
+xfs_repair_ag_has_space(
+	struct xfs_perag		*pag,
+	xfs_extlen_t			nr_blocks,
+	enum xfs_ag_resv_type		type)
+{
+	return  !xfs_ag_resv_critical(pag, XFS_AG_RESV_AGFL) &&
+		!xfs_ag_resv_critical(pag, XFS_AG_RESV_METADATA) &&
+		pag->pagf_freeblks > xfs_ag_resv_needed(pag, type) + nr_blocks;
+}
+
+/* Allocate a block in an AG. */
+int
+xfs_repair_alloc_ag_block(
+	struct xfs_scrub_context	*sc,
+	struct xfs_owner_info		*oinfo,
+	xfs_fsblock_t			*fsbno,
+	enum xfs_ag_resv_type		resv)
+{
+	struct xfs_alloc_arg		args = {0};
+	xfs_agblock_t			bno;
+	int				error;
+
+	if (resv == XFS_AG_RESV_AGFL) {
+		error = xfs_alloc_get_freelist(sc->tp, sc->sa.agf_bp, &bno, 1);
+		if (error)
+			return error;
+		if (bno == NULLAGBLOCK)
+			return -ENOSPC;
+		xfs_extent_busy_reuse(sc->mp, sc->sa.agno, bno,
+				1, false);
+		*fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, bno);
+		return 0;
+	}
+
+	args.tp = sc->tp;
+	args.mp = sc->mp;
+	args.oinfo = *oinfo;
+	args.fsbno = XFS_AGB_TO_FSB(args.mp, sc->sa.agno, 0);
+	args.minlen = 1;
+	args.maxlen = 1;
+	args.prod = 1;
+	args.type = XFS_ALLOCTYPE_NEAR_BNO;
+	args.resv = resv;
+
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		return error;
+	if (args.fsbno == NULLFSBLOCK)
+		return -ENOSPC;
+	ASSERT(args.len == 1);
+	*fsbno = args.fsbno;
+
+	return 0;
+}
+
+/* Initialize an AG block to a zeroed out btree header. */
+int
+xfs_repair_init_btblock(
+	struct xfs_scrub_context	*sc,
+	xfs_fsblock_t			fsb,
+	struct xfs_buf			**bpp,
+	xfs_btnum_t			btnum,
+	const struct xfs_buf_ops	*ops)
+{
+	struct xfs_trans		*tp = sc->tp;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_buf			*bp;
+
+	trace_xfs_repair_init_btblock(mp, XFS_FSB_TO_AGNO(mp, fsb),
+			XFS_FSB_TO_AGBNO(mp, fsb), btnum);
+
+	ASSERT(XFS_FSB_TO_AGNO(mp, fsb) == sc->sa.agno);
+	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, XFS_FSB_TO_DADDR(mp, fsb),
+			XFS_FSB_TO_BB(mp, 1), 0);
+	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
+	xfs_btree_init_block(mp, bp, btnum, 0, 0, sc->sa.agno,
+			XFS_BTREE_CRC_BLOCKS);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
+	xfs_trans_log_buf(tp, bp, 0, bp->b_length);
+	bp->b_ops = ops;
+	*bpp = bp;
+
+	return 0;
+}
+
+/* Ensure the freelist is full. */
+int
+xfs_repair_fix_freelist(
+	struct xfs_scrub_context	*sc,
+	bool				can_shrink)
+{
+	struct xfs_alloc_arg		args = {0};
+	int				error;
+
+	args.mp = sc->mp;
+	args.tp = sc->tp;
+	args.agno = sc->sa.agno;
+	args.alignment = 1;
+	args.pag = xfs_perag_get(args.mp, sc->sa.agno);
+	args.resv = XFS_AG_RESV_AGFL;
+
+	error = xfs_alloc_fix_freelist(&args,
+			can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK);
+	xfs_perag_put(args.pag);
+
+	return error;
+}
+
+/* Put a block back on the AGFL. */
+int
+xfs_repair_put_freelist(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			agbno)
+{
+	struct xfs_owner_info		oinfo;
+	int				error;
+
+	/*
+	 * Since we're "freeing" a lost block onto the AGFL, we have to
+	 * create an rmap for the block prior to merging it or else other
+	 * parts will break.
+	 */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
+	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno, agbno, 1,
+			&oinfo);
+	if (error)
+		return error;
+
+	/* Put the block on the AGFL. */
+	error = xfs_alloc_put_freelist(sc->tp, sc->sa.agf_bp, sc->sa.agfl_bp,
+			agbno, 0);
+	if (error)
+		return error;
+	xfs_extent_busy_insert(sc->tp, sc->sa.agno, agbno, 1,
+			XFS_EXTENT_BUSY_SKIP_DISCARD);
+
+	/* Make sure the AGFL doesn't overfill. */
+	return xfs_repair_fix_freelist(sc, true);
+}
+
+/*
+ * For a given metadata extent and owner, delete the associated rmap.
+ * If the block has no other owners, free it.
+ */
+STATIC int
+xfs_repair_free_or_unmap_extent(
+	struct xfs_scrub_context	*sc,
+	xfs_fsblock_t			fsbno,
+	xfs_extlen_t			len,
+	struct xfs_owner_info		*oinfo,
+	enum xfs_ag_resv_type		resv)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_btree_cur		*rmap_cur;
+	struct xfs_buf			*agf_bp = NULL;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	bool				has_other_rmap;
+	int				error = 0;
+
+	ASSERT(xfs_sb_version_hasrmapbt(&mp->m_sb));
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+
+	trace_xfs_repair_free_or_unmap_extent(mp, agno, agbno, len);
+
+	for (; len > 0 && !error; len--, agbno++, fsbno++) {
+		ASSERT(sc->ip != NULL || agno == sc->sa.agno);
+
+		/* Can we find any other rmappings? */
+		if (sc->ip) {
+			error = xfs_alloc_read_agf(mp, sc->tp, agno, 0,
+					&agf_bp);
+			if (error)
+				break;
+			if (!agf_bp) {
+				error = -ENOMEM;
+				break;
+			}
+		}
+		rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp,
+				agf_bp ? agf_bp : sc->sa.agf_bp, agno);
+		error = xfs_rmap_has_other_keys(rmap_cur, agbno, 1, oinfo,
+				&has_other_rmap);
+		if (error)
+			goto out_cur;
+		xfs_btree_del_cursor(rmap_cur, XFS_BTREE_NOERROR);
+		if (agf_bp)
+			xfs_trans_brelse(sc->tp, agf_bp);
+
+		/*
+		 * If there are other rmappings, this block is cross
+		 * linked and must not be freed.  Remove the reverse
+		 * mapping and move on.  Otherwise, we were the only
+		 * owner of the block, so free the extent, which will
+		 * also remove the rmap.
+		 */
+		if (has_other_rmap)
+			error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1,
+					oinfo);
+		else if (resv == XFS_AG_RESV_AGFL)
+			error = xfs_repair_put_freelist(sc, agbno);
+		else
+			error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
+		if (error)
+			break;
+
+		if (sc->ip)
+			error = xfs_trans_roll_inode(&sc->tp, sc->ip);
+		else
+			error = xfs_repair_roll_ag_trans(sc);
+	}
+
+	return error;
+out_cur:
+	xfs_btree_del_cursor(rmap_cur, XFS_BTREE_ERROR);
+	if (agf_bp)
+		xfs_trans_brelse(sc->tp, agf_bp);
+	return error;
+}
+
+/* Collect a dead btree extent for later disposal. */
+int
+xfs_repair_collect_btree_extent(
+	struct xfs_scrub_context	*sc,
+	struct xfs_repair_extent_list	*exlist,
+	xfs_fsblock_t			fsbno,
+	xfs_extlen_t			len)
+{
+	struct xfs_repair_extent	*rae;
+
+	trace_xfs_repair_collect_btree_extent(sc->mp,
+			XFS_FSB_TO_AGNO(sc->mp, fsbno),
+			XFS_FSB_TO_AGBNO(sc->mp, fsbno), len);
+
+	rae = kmem_alloc(sizeof(struct xfs_repair_extent),
+			KM_MAYFAIL | KM_NOFS);
+	if (!rae)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&rae->list);
+	rae->fsbno = fsbno;
+	rae->len = len;
+	list_add_tail(&rae->list, &exlist->list);
+
+	return 0;
+}
+
+/* Invalidate buffers for blocks we're dumping. */
+int
+xfs_repair_invalidate_blocks(
+	struct xfs_scrub_context	*sc,
+	struct xfs_repair_extent_list	*exlist)
+{
+	struct xfs_repair_extent	*rae;
+	struct xfs_repair_extent	*n;
+	struct xfs_buf			*bp;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	xfs_agblock_t			i;
+
+	for_each_xfs_repair_extent_safe(rae, n, exlist) {
+		agno = XFS_FSB_TO_AGNO(sc->mp, rae->fsbno);
+		agbno = XFS_FSB_TO_AGBNO(sc->mp, rae->fsbno);
+		for (i = 0; i < rae->len; i++) {
+			bp = xfs_btree_get_bufs(sc->mp, sc->tp, agno,
+					agbno + i, 0);
+			xfs_trans_binval(sc->tp, bp);
+		}
+	}
+
+	return 0;
+}
+
+/* Dispose of dead btree extents.  If oinfo is NULL, just delete the list. */
+int
+xfs_repair_reap_btree_extents(
+	struct xfs_scrub_context	*sc,
+	struct xfs_repair_extent_list	*exlist,
+	struct xfs_owner_info		*oinfo,
+	enum xfs_ag_resv_type		type)
+{
+	struct xfs_repair_extent	*rae;
+	struct xfs_repair_extent	*n;
+	int				error = 0;
+
+	for_each_xfs_repair_extent_safe(rae, n, exlist) {
+		if (oinfo) {
+			error = xfs_repair_free_or_unmap_extent(sc, rae->fsbno,
+					rae->len, oinfo, type);
+			if (error)
+				oinfo = NULL;
+		}
+		list_del(&rae->list);
+		kmem_free(rae);
+	}
+
+	return error;
+}
+
+/* Errors happened, just delete the dead btree extent list. */
+void
+xfs_repair_cancel_btree_extents(
+	struct xfs_scrub_context	*sc,
+	struct xfs_repair_extent_list	*exlist)
+{
+	xfs_repair_reap_btree_extents(sc, exlist, NULL, XFS_AG_RESV_NONE);
+}
+
+/* Compare two btree extents. */
+static int
+xfs_repair_btree_extent_cmp(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_repair_extent	*ap;
+	struct xfs_repair_extent	*bp;
+
+	ap = container_of(a, struct xfs_repair_extent, list);
+	bp = container_of(b, struct xfs_repair_extent, list);
+
+	if (ap->fsbno > bp->fsbno)
+		return 1;
+	else if (ap->fsbno < bp->fsbno)
+		return -1;
+	return 0;
+}
+
+/* Remove all the blocks in sublist from exlist. */
+#define LEFT_CONTIG	(1 << 0)
+#define RIGHT_CONTIG	(1 << 1)
+int
+xfs_repair_subtract_extents(
+	struct xfs_scrub_context	*sc,
+	struct xfs_repair_extent_list	*exlist,
+	struct xfs_repair_extent_list	*sublist)
+{
+	struct list_head		*lp;
+	struct xfs_repair_extent	*ex;
+	struct xfs_repair_extent	*newex;
+	struct xfs_repair_extent	*subex;
+	xfs_fsblock_t			sub_fsb;
+	xfs_extlen_t			sub_len;
+	int				state;
+	int				error = 0;
+
+	if (list_empty(&exlist->list) || list_empty(&sublist->list))
+		return 0;
+	ASSERT(!list_empty(&sublist->list));
+
+	list_sort(NULL, &exlist->list, xfs_repair_btree_extent_cmp);
+	list_sort(NULL, &sublist->list, xfs_repair_btree_extent_cmp);
+
+	subex = list_first_entry(&sublist->list, struct xfs_repair_extent,
+			list);
+	lp = exlist->list.next;
+	while (lp != &exlist->list) {
+		ex = list_entry(lp, struct xfs_repair_extent, list);
+
+		/*
+		 * Advance subex and/or ex until we find a pair that
+		 * intersect or we run out of extents.
+		 */
+		while (subex->fsbno + subex->len <= ex->fsbno) {
+			if (list_is_last(&subex->list, &sublist->list))
+				goto out;
+			subex = list_next_entry(subex, list);
+		}
+		if (subex->fsbno >= ex->fsbno + ex->len) {
+			lp = lp->next;
+			continue;
+		}
+
+		/* trim subex to fit the extent we have */
+		sub_fsb = subex->fsbno;
+		sub_len = subex->len;
+		if (subex->fsbno < ex->fsbno) {
+			sub_len -= ex->fsbno - subex->fsbno;
+			sub_fsb = ex->fsbno;
+		}
+		if (sub_len > ex->len)
+			sub_len = ex->len;
+
+		state = 0;
+		if (sub_fsb == ex->fsbno)
+			state |= LEFT_CONTIG;
+		if (sub_fsb + sub_len == ex->fsbno + ex->len)
+			state |= RIGHT_CONTIG;
+		switch (state) {
+		case LEFT_CONTIG:
+			/* Coincides with only the left. */
+			ex->fsbno += sub_len;
+			ex->len -= sub_len;
+			break;
+		case RIGHT_CONTIG:
+			/* Coincides with only the right. */
+			ex->len -= sub_len;
+			lp = lp->next;
+			break;
+		case LEFT_CONTIG | RIGHT_CONTIG:
+			/* Total overlap, just delete ex. */
+			lp = lp->next;
+			list_del(&ex->list);
+			kmem_free(ex);
+			break;
+		case 0:
+			/*
+			 * Deleting from the middle: add the new right extent
+			 * and then shrink the left extent.
+			 */
+			newex = kmem_alloc(
+					sizeof(struct xfs_repair_extent),
+					KM_MAYFAIL | KM_NOFS);
+			if (!newex) {
+				error = -ENOMEM;
+				goto out;
+			}
+			INIT_LIST_HEAD(&newex->list);
+			newex->fsbno = sub_fsb + sub_len;
+			newex->len = ex->len - (sub_fsb - ex->fsbno) - sub_len;
+			list_add(&newex->list, &ex->list);
+			ex->len = sub_fsb - ex->fsbno;
+			lp = lp->next;
+			break;
+		default:
+			ASSERT(0);
+			break;
+		}
+	}
+
+out:
+	return error;
+}
+#undef LEFT_CONTIG
+#undef RIGHT_CONTIG
+
+struct xfs_repair_find_ag_btree_roots_info {
+	struct xfs_buf			*agfl_bp;
+	struct xfs_repair_find_ag_btree	*btree_info;
+};
+
+/* Is this an OWN_AG block in the AGFL? */
+STATIC bool
+xfs_repair_is_block_in_agfl(
+	struct xfs_mount		*mp,
+	uint64_t			rmap_owner,
+	xfs_agblock_t			agbno,
+	struct xfs_buf			*agf_bp,
+	struct xfs_buf			*agfl_bp)
+{
+	struct xfs_agf			*agf;
+	__be32				*agfl_bno;
+	unsigned int			flfirst;
+	unsigned int			fllast;
+	int				i;
+
+	if (rmap_owner != XFS_RMAP_OWN_AG)
+		return false;
+
+	agf = XFS_BUF_TO_AGF(agf_bp);
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
+	flfirst = be32_to_cpu(agf->agf_flfirst);
+	fllast = be32_to_cpu(agf->agf_fllast);
+
+	/* Skip an empty AGFL. */
+	if (agf->agf_flcount == cpu_to_be32(0))
+		return false;
+
+	/* first to last is a consecutive list. */
+	if (fllast >= flfirst) {
+		for (i = flfirst; i <= fllast; i++) {
+			if (be32_to_cpu(agfl_bno[i]) == agbno)
+				return true;
+		}
+
+		return false;
+	}
+
+	/* first to the end */
+	for (i = flfirst; i < xfs_agfl_size(mp); i++) {
+		if (be32_to_cpu(agfl_bno[i]) == agbno)
+			return true;
+	}
+
+	/* the start to last. */
+	for (i = 0; i <= fllast; i++) {
+		if (be32_to_cpu(agfl_bno[i]) == agbno)
+			return true;
+	}
+
+	return false;
+}
+
+/* Find btree roots from the AGF. */
+STATIC int
+xfs_repair_find_ag_btree_roots_helper(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_repair_find_ag_btree_roots_info	*ri = priv;
+	struct xfs_repair_find_ag_btree	*fab;
+	struct xfs_buf			*bp;
+	struct xfs_btree_block		*btblock;
+	xfs_daddr_t			daddr;
+	xfs_agblock_t			agbno;
+	int				error = 0;
+
+	if (!XFS_RMAP_NON_INODE_OWNER(rec->rm_owner))
+		return 0;
+
+	for (agbno = 0; agbno < rec->rm_blockcount; agbno++) {
+		daddr = XFS_AGB_TO_DADDR(mp, cur->bc_private.a.agno,
+				rec->rm_startblock + agbno);
+		for (fab = ri->btree_info; fab->buf_ops; fab++) {
+			if (rec->rm_owner != fab->rmap_owner)
+				continue;
+
+			/*
+			 * Blocks in the AGFL have stale contents that
+			 * might just happen to have a matching magic
+			 * and uuid.  We don't want to pull these blocks
+			 * in as part of a tree root, so we have to
+			 * filter out the AGFL stuff here.  If the AGFL
+			 * looks insane we'll just refuse to repair.
+			 */
+			if (xfs_repair_is_block_in_agfl(mp, rec->rm_owner,
+					rec->rm_startblock + agbno,
+					cur->bc_private.a.agbp, ri->agfl_bp))
+				continue;
+
+			error = xfs_trans_read_buf(mp, cur->bc_tp,
+					mp->m_ddev_targp, daddr, mp->m_bsize,
+					0, &bp, NULL);
+			if (error)
+				return error;
+
+			/* Does this look like a block we want? */
+			btblock = XFS_BUF_TO_BLOCK(bp);
+			if (be32_to_cpu(btblock->bb_magic) != fab->magic)
+				goto next_fab;
+			if (xfs_sb_version_hascrc(&mp->m_sb) &&
+			    !uuid_equal(&btblock->bb_u.s.bb_uuid,
+					&mp->m_sb.sb_meta_uuid))
+				goto next_fab;
+			if (fab->root != NULLAGBLOCK &&
+			    xfs_btree_get_level(btblock) <= fab->level)
+				goto next_fab;
+
+			/* Make sure we pass the verifiers. */
+			bp->b_ops = fab->buf_ops;
+			bp->b_ops->verify_read(bp);
+			if (bp->b_error)
+				goto next_fab;
+			fab->root = rec->rm_startblock + agbno;
+			fab->level = xfs_btree_get_level(btblock);
+
+			trace_xfs_repair_find_ag_btree_roots_helper(mp,
+					cur->bc_private.a.agno,
+					rec->rm_startblock + agbno,
+					be32_to_cpu(btblock->bb_magic),
+					fab->level);
+next_fab:
+			xfs_trans_brelse(cur->bc_tp, bp);
+			if (be32_to_cpu(btblock->bb_magic) == fab->magic)
+				break;
+		}
+	}
+
+	return error;
+}
+
+/* Find the roots of the given btrees from the rmap info. */
+int
+xfs_repair_find_ag_btree_roots(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*agf_bp,
+	struct xfs_repair_find_ag_btree	*btree_info,
+	struct xfs_buf			*agfl_bp)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_repair_find_ag_btree_roots_info	ri;
+	struct xfs_repair_find_ag_btree	*fab;
+	struct xfs_btree_cur		*cur;
+	int				error;
+
+	ri.btree_info = btree_info;
+	ri.agfl_bp = agfl_bp;
+	for (fab = btree_info; fab->buf_ops; fab++) {
+		ASSERT(agfl_bp || fab->rmap_owner != XFS_RMAP_OWN_AG);
+		fab->root = NULLAGBLOCK;
+		fab->level = 0;
+	}
+
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
+	error = xfs_rmap_query_all(cur, xfs_repair_find_ag_btree_roots_helper,
+			&ri);
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+
+	for (fab = btree_info; !error && fab->buf_ops; fab++)
+		if (fab->root != NULLAGBLOCK)
+			fab->level++;
+
+	return error;
+}
+
+/* Reset the superblock counters from the AGF/AGI. */
+int
+xfs_repair_reset_counters(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans	*tp;
+	struct xfs_buf		*agi_bp;
+	struct xfs_buf		*agf_bp;
+	struct xfs_agi		*agi;
+	struct xfs_agf		*agf;
+	xfs_agnumber_t		agno;
+	xfs_ino_t		icount = 0;
+	xfs_ino_t		ifree = 0;
+	xfs_filblks_t		fdblocks = 0;
+	int64_t			delta_icount;
+	int64_t			delta_ifree;
+	int64_t			delta_fdblocks;
+	int			error;
+
+	trace_xfs_repair_reset_counters(mp);
+
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		/* Count all the inodes... */
+		error = xfs_ialloc_read_agi(mp, tp, agno, &agi_bp);
+		if (error)
+			goto out;
+		agi = XFS_BUF_TO_AGI(agi_bp);
+		icount += be32_to_cpu(agi->agi_count);
+		ifree += be32_to_cpu(agi->agi_freecount);
+
+		/* Add up the free/freelist/bnobt/cntbt blocks... */
+		error = xfs_alloc_read_agf(mp, tp, agno, 0, &agf_bp);
+		if (error)
+			goto out;
+		if (!agf_bp) {
+			error = -ENOMEM;
+			goto out;
+		}
+		agf = XFS_BUF_TO_AGF(agf_bp);
+		fdblocks += be32_to_cpu(agf->agf_freeblks);
+		fdblocks += be32_to_cpu(agf->agf_flcount);
+		fdblocks += be32_to_cpu(agf->agf_btreeblks);
+	}
+
+	/*
+	 * Reinitialize the counters.  The on-disk and in-core counters
+	 * differ by the number of inodes/blocks reserved by the admin,
+	 * the per-AG reservation, and any transactions in progress, so
+	 * we have to account for that.
+	 */
+	spin_lock(&mp->m_sb_lock);
+	delta_icount = (int64_t)mp->m_sb.sb_icount - icount;
+	delta_ifree = (int64_t)mp->m_sb.sb_ifree - ifree;
+	delta_fdblocks = (int64_t)mp->m_sb.sb_fdblocks - fdblocks;
+	mp->m_sb.sb_icount = icount;
+	mp->m_sb.sb_ifree = ifree;
+	mp->m_sb.sb_fdblocks = fdblocks;
+	spin_unlock(&mp->m_sb_lock);
+
+	if (delta_icount) {
+		error = xfs_mod_icount(mp, delta_icount);
+		if (error)
+			goto out;
+	}
+	if (delta_ifree) {
+		error = xfs_mod_ifree(mp, delta_ifree);
+		if (error)
+			goto out;
+	}
+	if (delta_fdblocks) {
+		error = xfs_mod_fdblocks(mp, delta_fdblocks, false);
+		if (error)
+			goto out;
+	}
+
+out:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+/* Figure out how many blocks to reserve for an AG repair. */
+xfs_extlen_t
+xfs_repair_calc_ag_resblks(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_scrub_metadata	*sm = sc->sm;
+	struct xfs_agi			*agi;
+	struct xfs_agf			*agf;
+	struct xfs_buf			*bp;
+	xfs_agino_t			icount;
+	xfs_extlen_t			aglen;
+	xfs_extlen_t			usedlen;
+	xfs_extlen_t			freelen;
+	xfs_extlen_t			bnobt_sz;
+	xfs_extlen_t			inobt_sz;
+	xfs_extlen_t			rmapbt_sz;
+	xfs_extlen_t			refcbt_sz;
+	int				error;
+
+	if (!(sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
+		return 0;
+
+	/*
+	 * Try to get the actual counters from disk; if not, make
+	 * some worst case assumptions.
+	 */
+	error = xfs_read_agi(mp, NULL, sm->sm_agno, &bp);
+	if (!error) {
+		agi = XFS_BUF_TO_AGI(bp);
+		icount = be32_to_cpu(agi->agi_count);
+		xfs_trans_brelse(NULL, bp);
+	} else {
+		icount = mp->m_sb.sb_agblocks / mp->m_sb.sb_inopblock;
+	}
+
+	error = xfs_alloc_read_agf(mp, NULL, sm->sm_agno, 0, &bp);
+	if (!error && bp) {
+		agf = XFS_BUF_TO_AGF(bp);
+		aglen = be32_to_cpu(agf->agf_length);
+		freelen = be32_to_cpu(agf->agf_freeblks);
+		usedlen = aglen - freelen;
+		xfs_trans_brelse(NULL, bp);
+	} else {
+		aglen = mp->m_sb.sb_agblocks;
+		freelen = aglen;
+		usedlen = aglen;
+	}
+
+	trace_xfs_repair_calc_ag_resblks(mp, sm->sm_agno, icount, aglen,
+			freelen, usedlen);
+
+	/*
+	 * Figure out how many blocks we'd need worst case to rebuild
+	 * each type of btree.  Note that we can only rebuild the
+	 * bnobt/cntbt or inobt/finobt as pairs.
+	 */
+	bnobt_sz = 2 * xfs_allocbt_calc_size(mp, freelen);
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+		inobt_sz = xfs_iallocbt_calc_size(mp, icount /
+				XFS_INODES_PER_HOLEMASK_BIT);
+	else
+		inobt_sz = xfs_iallocbt_calc_size(mp, icount /
+				XFS_INODES_PER_CHUNK);
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		inobt_sz *= 2;
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		rmapbt_sz = xfs_rmapbt_calc_size(mp, aglen);
+		refcbt_sz = xfs_refcountbt_calc_size(mp, usedlen);
+	} else {
+		rmapbt_sz = xfs_rmapbt_calc_size(mp, usedlen);
+		refcbt_sz = 0;
+	}
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		rmapbt_sz = 0;
+
+	trace_xfs_repair_calc_ag_resblks_btsize(mp, sm->sm_agno, bnobt_sz,
+			inobt_sz, rmapbt_sz, refcbt_sz);
+
+	return max(max(bnobt_sz, inobt_sz), max(rmapbt_sz, refcbt_sz));
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 660ab3a..6872359 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -24,10 +24,88 @@
 
 int xfs_repair_probe(struct xfs_scrub_context *sc);
 
+/* Repair helpers */
+
+struct xfs_repair_find_ag_btree {
+	uint64_t			rmap_owner;
+	const struct xfs_buf_ops	*buf_ops;
+	uint32_t			magic;
+	xfs_agblock_t			root;
+	unsigned int			level;
+};
+
+struct xfs_repair_extent {
+	struct list_head		list;
+	xfs_fsblock_t			fsbno;
+	xfs_extlen_t			len;
+};
+
+struct xfs_repair_extent_list {
+	struct list_head		list;
+};
+
+static inline void
+xfs_repair_init_extent_list(
+	struct xfs_repair_extent_list	*exlist)
+{
+	INIT_LIST_HEAD(&exlist->list);
+}
+
+#define for_each_xfs_repair_extent_safe(rbe, n, exlist) \
+	list_for_each_entry_safe((rbe), (n), &(exlist)->list, list)
+
+int xfs_repair_roll_ag_trans(struct xfs_scrub_context *sc);
+bool xfs_repair_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
+		enum xfs_ag_resv_type type);
+int xfs_repair_alloc_ag_block(struct xfs_scrub_context *sc,
+		struct xfs_owner_info *oinfo, xfs_fsblock_t *fsbno,
+		enum xfs_ag_resv_type resv);
+int xfs_repair_init_btblock(struct xfs_scrub_context *sc, xfs_fsblock_t fsb,
+		struct xfs_buf **bpp, xfs_btnum_t btnum,
+		const struct xfs_buf_ops *ops);
+int xfs_repair_fix_freelist(struct xfs_scrub_context *sc, bool can_shrink);
+int xfs_repair_put_freelist(struct xfs_scrub_context *sc, xfs_agblock_t agbno);
+int xfs_repair_collect_btree_extent(struct xfs_scrub_context *sc,
+		struct xfs_repair_extent_list *btlist, xfs_fsblock_t fsbno,
+		xfs_extlen_t len);
+int xfs_repair_invalidate_blocks(struct xfs_scrub_context *sc,
+		struct xfs_repair_extent_list *btlist);
+int xfs_repair_reap_btree_extents(struct xfs_scrub_context *sc,
+		struct xfs_repair_extent_list *btlist,
+		struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
+void xfs_repair_cancel_btree_extents(struct xfs_scrub_context *sc,
+		struct xfs_repair_extent_list *btlist);
+int xfs_repair_subtract_extents(struct xfs_scrub_context *sc,
+		struct xfs_repair_extent_list *exlist,
+		struct xfs_repair_extent_list *sublist);
+int xfs_repair_find_ag_btree_roots(struct xfs_scrub_context *sc,
+		struct xfs_buf *agf_bp,
+		struct xfs_repair_find_ag_btree *btree_info,
+		struct xfs_buf *agfl_bp);
+int xfs_repair_reset_counters(struct xfs_mount *mp);
+xfs_extlen_t xfs_repair_calc_ag_resblks(struct xfs_scrub_context *sc);
+int xfs_repair_setup_btree_extent_collection(struct xfs_scrub_context *sc);
+
+/* Metadata repairers */
+
 #else
 
 #define xfs_repair_probe		(NULL)
 
+static inline int xfs_repair_reset_counters(struct xfs_mount *mp)
+{
+	ASSERT(0);
+	return -EIO;
+}
+
+static inline xfs_extlen_t
+xfs_repair_calc_ag_resblks(
+	struct xfs_scrub_context	*sc)
+{
+	ASSERT(!(sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR));
+	return 0;
+}
+
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
 #endif	/* __XFS_SCRUB_REPAIR_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 888ab2a..9a8fa78 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -196,6 +196,8 @@ xfs_scrub_teardown(
 		kmem_free(sc->buf);
 		sc->buf = NULL;
 	}
+	if (sc->reset_counters && !error)
+		error = xfs_repair_reset_counters(sc->mp);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 9ab8ef8..340d6227 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -76,6 +76,7 @@ struct xfs_scrub_context {
 	void				*buf;
 	uint				ilock_flags;
 	bool				try_harder;
+	bool				reset_counters;
 
 	/* State tracking for single-AG operations. */
 	struct xfs_scrub_ag		sa;

