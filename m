Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42074 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933883AbdHYWSl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 18:18:41 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7PMIeOs014412
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMIeLb024530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:40 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7PMIdXG024083
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:40 GMT
Subject: [PATCH 16/19] xfs: repair refcount btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 Aug 2017 15:18:38 -0700
Message-ID: <150369951845.9957.11603029087222613997.stgit@magnolia>
In-Reply-To: <150369940879.9957.6303798184036268321.stgit@magnolia>
References: <150369940879.9957.6303798184036268321.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Reconstruct the refcount data from the rmap btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/refcount.c |  479 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h   |    1 
 fs/xfs/scrub/scrub.c    |    1 
 3 files changed, 481 insertions(+)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 999820b..d016870 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -29,14 +29,20 @@
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_itable.h"
 #include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
+#include "xfs_error.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/trace.h"
+#include "scrub/repair.h"
 
 /*
  * Set us up to scrub reference count btrees.
@@ -370,3 +376,476 @@ xfs_scrub_refcountbt(
 
 	return error;
 }
+
+/*
+ * Rebuilding the Reference Count Btree
+ *
+ * This algorithm is "borrowed" from xfs_repair.  Imagine the rmap
+ * entries as rectangles representing extents of physical blocks, and
+ * that the rectangles can be laid down to allow them to overlap each
+ * other; then we know that we must emit a refcnt btree entry wherever
+ * the amount of overlap changes, i.e. the emission stimulus is
+ * level-triggered:
+ *
+ *                 -    ---
+ *       --      ----- ----   ---        ------
+ * --   ----     ----------- ----     ---------
+ * -------------------------------- -----------
+ * ^ ^  ^^ ^^    ^ ^^ ^^^  ^^^^  ^ ^^ ^  ^     ^
+ * 2 1  23 21    3 43 234  2123  1 01 2  3     0
+ *
+ * For our purposes, a rmap is a tuple (startblock, len, fileoff, owner).
+ *
+ * Note that in the actual refcnt btree we don't store the refcount < 2
+ * cases because the bnobt tells us which blocks are free; single-use
+ * blocks aren't recorded in the bnobt or the refcntbt.  If the rmapbt
+ * supports storing multiple entries covering a given block we could
+ * theoretically dispense with the refcntbt and simply count rmaps, but
+ * that's inefficient in the (hot) write path, so we'll take the cost of
+ * the extra tree to save time.  Also there's no guarantee that rmap
+ * will be enabled.
+ *
+ * Given an array of rmaps sorted by physical block number, a starting
+ * physical block (sp), a bag to hold rmaps that cover sp, and the next
+ * physical block where the level changes (np), we can reconstruct the
+ * refcount btree as follows:
+ *
+ * While there are still unprocessed rmaps in the array,
+ *  - Set sp to the physical block (pblk) of the next unprocessed rmap.
+ *  - Add to the bag all rmaps in the array where startblock == sp.
+ *  - Set np to the physical block where the bag size will change.  This
+ *    is the minimum of (the pblk of the next unprocessed rmap) and
+ *    (startblock + len of each rmap in the bag).
+ *  - Record the bag size as old_bag_size.
+ *
+ *  - While the bag isn't empty,
+ *     - Remove from the bag all rmaps where startblock + len == np.
+ *     - Add to the bag all rmaps in the array where startblock == np.
+ *     - If the bag size isn't old_bag_size, store the refcount entry
+ *       (sp, np - sp, bag_size) in the refcnt btree.
+ *     - If the bag is empty, break out of the inner loop.
+ *     - Set old_bag_size to the bag size
+ *     - Set sp = np.
+ *     - Set np to the physical block where the bag size will change.
+ *       This is the minimum of (the pblk of the next unprocessed rmap)
+ *       and (startblock + len of each rmap in the bag).
+ *
+ * Like all the other repairers, we make a list of all the refcount
+ * records we need, then reinitialize the refcount btree root and
+ * insert all the records.
+ */
+
+struct xfs_repair_refc_rmap {
+	struct list_head		list;
+	struct xfs_rmap_irec		rmap;
+};
+
+struct xfs_repair_refc_extent {
+	struct list_head		list;
+	struct xfs_refcount_irec	refc;
+};
+
+struct xfs_repair_refc {
+	struct list_head		rmap_bag;  /* rmaps we're tracking */
+	struct list_head		rmap_idle; /* idle rmaps */
+	struct list_head		extlist;   /* refcount extents */
+	struct list_head		btlist;    /* old refcountbt blocks */
+	struct xfs_scrub_context	*sc;
+	xfs_extlen_t			btblocks;  /* # of refcountbt blocks */
+};
+
+/* Grab the next record from the rmapbt. */
+STATIC int
+xfs_repair_refcountbt_next_rmap(
+	struct xfs_btree_cur		*cur,
+	struct xfs_repair_refc		*rr,
+	struct xfs_rmap_irec		*rec,
+	bool				*have_rec)
+{
+	struct xfs_rmap_irec		rmap;
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_repair_refc_extent	*rre;
+	xfs_fsblock_t			fsbno;
+	int				have_gt;
+	int				error = 0;
+
+	*have_rec = false;
+	/*
+	 * Loop through the remaining rmaps.  Remember CoW staging
+	 * extents and the refcountbt blocks from the old tree for later
+	 * disposal.  We can only share written data fork extents, so
+	 * keep looping until we find an rmap for one.
+	 */
+	do {
+		if (xfs_scrub_should_terminate(&error))
+			goto out_error;
+
+		error = xfs_btree_increment(cur, 0, &have_gt);
+		if (error)
+			goto out_error;
+		if (!have_gt)
+			return 0;
+
+		error = xfs_rmap_get_rec(cur, &rmap, &have_gt);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 1, out_error);
+
+		if (rmap.rm_owner == XFS_RMAP_OWN_COW) {
+			/* Pass CoW staging extents right through. */
+			rre = kmem_alloc(sizeof(struct xfs_repair_refc_extent),
+					KM_MAYFAIL | KM_NOFS);
+			if (!rre)
+				goto out_error;
+
+			INIT_LIST_HEAD(&rre->list);
+			rre->refc.rc_startblock = rmap.rm_startblock +
+					XFS_REFC_COW_START;
+			rre->refc.rc_blockcount = rmap.rm_blockcount;
+			rre->refc.rc_refcount = 1;
+			list_add_tail(&rre->list, &rr->extlist);
+		} else if (rmap.rm_owner == XFS_RMAP_OWN_REFC) {
+			/* refcountbt block, dump it when we're done. */
+			rr->btblocks += rmap.rm_blockcount;
+			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
+					cur->bc_private.a.agno,
+					rmap.rm_startblock);
+			error = xfs_repair_collect_btree_extent(rr->sc,
+					&rr->btlist, fsbno, rmap.rm_blockcount);
+			if (error)
+				goto out_error;
+		}
+	} while (XFS_RMAP_NON_INODE_OWNER(rmap.rm_owner) ||
+		 xfs_internal_inum(mp, rmap.rm_owner) ||
+		 (rmap.rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+				   XFS_RMAP_UNWRITTEN)));
+
+	*rec = rmap;
+	*have_rec = true;
+	return 0;
+
+out_error:
+	return error;
+}
+
+/* Recycle an idle rmap or allocate a new one. */
+static struct xfs_repair_refc_rmap *
+xfs_repair_refcountbt_get_rmap(
+	struct xfs_repair_refc		*rr)
+{
+	struct xfs_repair_refc_rmap	*rrm;
+
+	if (list_empty(&rr->rmap_idle)) {
+		rrm = kmem_alloc(sizeof(struct xfs_repair_refc_rmap),
+				KM_MAYFAIL | KM_NOFS);
+		if (!rrm)
+			return NULL;
+		INIT_LIST_HEAD(&rrm->list);
+		return rrm;
+	}
+
+	rrm = list_first_entry(&rr->rmap_idle, struct xfs_repair_refc_rmap,
+			list);
+	list_del_init(&rrm->list);
+	return rrm;
+}
+
+/* Compare two btree extents. */
+static int
+xfs_repair_refcount_extent_cmp(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_repair_refc_extent	*ap;
+	struct xfs_repair_refc_extent	*bp;
+
+	ap = container_of(a, struct xfs_repair_refc_extent, list);
+	bp = container_of(b, struct xfs_repair_refc_extent, list);
+
+	if (ap->refc.rc_startblock > bp->refc.rc_startblock)
+		return 1;
+	else if (ap->refc.rc_startblock < bp->refc.rc_startblock)
+		return -1;
+	return 0;
+}
+
+/* Record a reference count extent. */
+STATIC int
+xfs_repair_refcountbt_new_refc(
+	struct xfs_scrub_context	*sc,
+	struct xfs_repair_refc		*rr,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len,
+	xfs_nlink_t			refcount)
+{
+	struct xfs_repair_refc_extent	*rre;
+	struct xfs_refcount_irec	irec;
+
+	irec.rc_startblock = agbno;
+	irec.rc_blockcount = len;
+	irec.rc_refcount = refcount;
+
+	trace_xfs_repair_refcount_extent_fn(sc->mp, sc->sa.agno,
+			&irec);
+
+	rre = kmem_alloc(sizeof(struct xfs_repair_refc_extent),
+			KM_MAYFAIL | KM_NOFS);
+	if (!rre)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&rre->list);
+	rre->refc = irec;
+	list_add_tail(&rre->list, &rr->extlist);
+
+	return 0;
+}
+
+/* Rebuild the refcount btree. */
+#define RMAP_END(r)	((r).rm_startblock + (r).rm_blockcount)
+int
+xfs_repair_refcountbt(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_repair_refc		rr;
+	struct xfs_rmap_irec		rmap;
+	struct xfs_owner_info		oinfo;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_repair_refc_rmap	*rrm;
+	struct xfs_repair_refc_rmap	*n;
+	struct xfs_repair_refc_extent	*rre;
+	struct xfs_repair_refc_extent	*o;
+	struct xfs_buf			*bp = NULL;
+	struct xfs_agf			*agf;
+	struct xfs_btree_cur		*cur = NULL;
+	struct xfs_perag		*pag;
+	uint64_t			nr_records;
+	xfs_fsblock_t			btfsb;
+	size_t				old_stack_sz;
+	size_t				stack_sz = 0;
+	xfs_agblock_t			sbno;
+	xfs_agblock_t			cbno;
+	xfs_agblock_t			nbno;
+	bool				have;
+	int				have_gt;
+	int				error = 0;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	INIT_LIST_HEAD(&rr.rmap_bag);
+	INIT_LIST_HEAD(&rr.rmap_idle);
+	INIT_LIST_HEAD(&rr.extlist);
+	INIT_LIST_HEAD(&rr.btlist);
+	rr.btblocks = 0;
+	rr.sc = sc;
+
+	nr_records = 0;
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
+
+	/* Start the rmapbt cursor to the left of all records. */
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno);
+	error = xfs_rmap_lookup_le(cur, 0, 0, 0, 0, 0, &have_gt);
+	if (error)
+		goto out;
+	ASSERT(have_gt == 0);
+
+	/* Process reverse mappings into refcount data. */
+	while (xfs_btree_has_more_records(cur)) {
+		/* Push all rmaps with pblk == sbno onto the stack */
+		error = xfs_repair_refcountbt_next_rmap(cur, &rr, &rmap, &have);
+		if (error)
+			goto out;
+		if (!have)
+			break;
+		sbno = cbno = rmap.rm_startblock;
+		while (have && rmap.rm_startblock == sbno) {
+			rrm = xfs_repair_refcountbt_get_rmap(&rr);
+			if (!rrm)
+				goto out;
+			rrm->rmap = rmap;
+			list_add_tail(&rrm->list, &rr.rmap_bag);
+			stack_sz++;
+			error = xfs_repair_refcountbt_next_rmap(cur, &rr, &rmap,
+					&have);
+			if (error)
+				goto out;
+		}
+		error = xfs_btree_decrement(cur, 0, &have_gt);
+		if (error)
+			goto out;
+		XFS_WANT_CORRUPTED_GOTO(mp, have_gt, out);
+
+		/* Set nbno to the bno of the next refcount change */
+		nbno = have ? rmap.rm_startblock : NULLAGBLOCK;
+		list_for_each_entry(rrm, &rr.rmap_bag, list)
+			nbno = min_t(xfs_agblock_t, nbno, RMAP_END(rrm->rmap));
+
+		ASSERT(nbno > sbno);
+		old_stack_sz = stack_sz;
+
+		/* While stack isn't empty... */
+		while (stack_sz) {
+			/* Pop all rmaps that end at nbno */
+			list_for_each_entry_safe(rrm, n, &rr.rmap_bag, list) {
+				if (RMAP_END(rrm->rmap) != nbno)
+					continue;
+				stack_sz--;
+				list_del_init(&rrm->list);
+				list_add(&rrm->list, &rr.rmap_idle);
+			}
+
+			/* Push array items that start at nbno */
+			error = xfs_repair_refcountbt_next_rmap(cur, &rr, &rmap,
+					&have);
+			if (error)
+				goto out;
+			while (have && rmap.rm_startblock == nbno) {
+				rrm = xfs_repair_refcountbt_get_rmap(&rr);
+				if (!rrm)
+					goto out;
+				rrm->rmap = rmap;
+				list_add_tail(&rrm->list, &rr.rmap_bag);
+				stack_sz++;
+				error = xfs_repair_refcountbt_next_rmap(cur,
+						&rr, &rmap, &have);
+				if (error)
+					goto out;
+			}
+			error = xfs_btree_decrement(cur, 0, &have_gt);
+			if (error)
+				goto out;
+			XFS_WANT_CORRUPTED_GOTO(mp, have_gt, out);
+
+			/* Emit refcount if necessary */
+			ASSERT(nbno > cbno);
+			if (stack_sz != old_stack_sz) {
+				if (old_stack_sz > 1) {
+					error = xfs_repair_refcountbt_new_refc(
+							sc, &rr, cbno,
+							nbno - cbno,
+							old_stack_sz);
+					if (error)
+						goto out;
+					nr_records++;
+				}
+				cbno = nbno;
+			}
+
+			/* Stack empty, go find the next rmap */
+			if (stack_sz == 0)
+				break;
+			old_stack_sz = stack_sz;
+			sbno = nbno;
+
+			/* Set nbno to the bno of the next refcount change */
+			nbno = have ? rmap.rm_startblock : NULLAGBLOCK;
+			list_for_each_entry(rrm, &rr.rmap_bag, list)
+				nbno = min_t(xfs_agblock_t, nbno,
+						RMAP_END(rrm->rmap));
+
+			/* Emit reverse mappings, if needed */
+			ASSERT(nbno > sbno);
+		}
+	}
+	ASSERT(list_empty(&rr.rmap_bag));
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	cur = NULL;
+
+	/* Free all the rmap records. */
+	list_for_each_entry_safe(rrm, n, &rr.rmap_idle, list) {
+		list_del(&rrm->list);
+		kmem_free(rrm);
+	}
+	list_for_each_entry_safe(rrm, n, &rr.rmap_bag, list) {
+		list_del(&rrm->list);
+		kmem_free(rrm);
+	}
+
+	/* Do we actually have enough space to do this? */
+	pag = xfs_perag_get(mp, sc->sa.agno);
+	if (!xfs_repair_ag_has_space(pag,
+			xfs_refcountbt_calc_size(mp, nr_records),
+			XFS_AG_RESV_METADATA)) {
+		xfs_perag_put(pag);
+		error = -ENOSPC;
+		goto out;
+	}
+	xfs_perag_put(pag);
+
+	/* Invalidate all the refcountbt blocks in btlist. */
+	error = xfs_repair_invalidate_blocks(sc, &rr.btlist);
+	if (error)
+		goto out;
+
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	/* Initialize a new btree root. */
+	error = xfs_repair_alloc_ag_block(sc, &oinfo, &btfsb,
+			XFS_AG_RESV_METADATA);
+	if (error)
+		goto out;
+	error = xfs_repair_init_btblock(sc, btfsb, &bp, XFS_BTNUM_REFC,
+			&xfs_refcountbt_buf_ops);
+	if (error)
+		goto out;
+	agf->agf_refcount_root = cpu_to_be32(XFS_FSB_TO_AGBNO(mp, btfsb));
+	agf->agf_refcount_level = cpu_to_be32(1);
+	agf->agf_refcount_blocks = cpu_to_be32(1);
+	xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, XFS_AGF_REFCOUNT_BLOCKS |
+			XFS_AGF_REFCOUNT_ROOT | XFS_AGF_REFCOUNT_LEVEL);
+	error = xfs_repair_roll_ag_trans(sc);
+	if (error)
+		goto out;
+
+	/* Insert records into the new btree. */
+	list_sort(NULL, &rr.extlist, xfs_repair_refcount_extent_cmp);
+	list_for_each_entry_safe(rre, o, &rr.extlist, list) {
+		/* Insert into the refcountbt. */
+		cur = xfs_refcountbt_init_cursor(mp, sc->tp, sc->sa.agf_bp,
+				sc->sa.agno, NULL);
+		error = xfs_refcount_lookup_eq(cur, rre->refc.rc_startblock,
+				&have_gt);
+		if (error)
+			goto out;
+		XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 0, out);
+		error = xfs_refcount_insert(cur, &rre->refc, &have_gt);
+		if (error)
+			goto out;
+		XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 1, out);
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		cur = NULL;
+
+		error = xfs_repair_roll_ag_trans(sc);
+		if (error)
+			goto out;
+
+		list_del(&rre->list);
+		kmem_free(rre);
+	}
+
+	/* Free the old refcountbt blocks if they're not in use. */
+	error = xfs_repair_reap_btree_extents(sc, &rr.btlist, &oinfo,
+			XFS_AG_RESV_METADATA);
+	if (error)
+		goto out;
+
+	return error;
+
+out:
+	if (cur)
+		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	xfs_repair_cancel_btree_extents(sc, &rr.btlist);
+	list_for_each_entry_safe(rrm, n, &rr.rmap_idle, list) {
+		list_del(&rrm->list);
+		kmem_free(rrm);
+	}
+	list_for_each_entry_safe(rrm, n, &rr.rmap_bag, list) {
+		list_del(&rrm->list);
+		kmem_free(rrm);
+	}
+	list_for_each_entry_safe(rre, o, &rr.extlist, list) {
+		list_del(&rre->list);
+		kmem_free(rre);
+	}
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 43c7cd2..303afa9 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -80,5 +80,6 @@ int xfs_repair_agi(struct xfs_scrub_context *sc);
 int xfs_repair_allocbt(struct xfs_scrub_context *sc);
 int xfs_repair_iallocbt(struct xfs_scrub_context *sc);
 int xfs_repair_rmapbt(struct xfs_scrub_context *sc);
+int xfs_repair_refcountbt(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_REPAIR_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 87b1dec..2e2ed4a 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -271,6 +271,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 	{ /* refcountbt */
 		.setup	= xfs_scrub_setup_ag_refcountbt,
 		.scrub	= xfs_scrub_refcountbt,
+		.repair	= xfs_repair_refcountbt,
 		.has	= xfs_sb_version_hasreflink,
 	},
 	{ /* inode record */

