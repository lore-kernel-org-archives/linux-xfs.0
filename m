Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42020 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933883AbdHYWSW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 18:18:22 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7PMIL6i014101
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMIKcX004732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:20 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMIK2H015730
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:20 GMT
Subject: [PATCH 13/19] xfs: repair free space btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 Aug 2017 15:18:18 -0700
Message-ID: <150369949850.9957.1807089183639709059.stgit@magnolia>
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

Rebuild the free space btrees from the gaps in the rmap btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/alloc.c  |  411 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c |   16 ++
 fs/xfs/scrub/repair.h |    1 
 fs/xfs/scrub/scrub.c  |    2 
 4 files changed, 430 insertions(+)


diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 812843c..4daf78f 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -29,15 +29,19 @@
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_inode.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
+#include "xfs_alloc_btree.h"
 #include "xfs_ialloc.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/trace.h"
+#include "scrub/repair.h"
 
 /*
  * Set us up to scrub free space btrees.
@@ -182,3 +186,410 @@ xfs_scrub_cntbt(
 {
 	return xfs_scrub_allocbt(sc, XFS_BTNUM_CNT);
 }
+
+/* Free space btree repair. */
+
+struct xfs_repair_alloc_extent {
+	struct list_head		list;
+	xfs_agblock_t			bno;
+	xfs_extlen_t			len;
+};
+
+struct xfs_repair_alloc {
+	struct list_head		extlist;
+	struct list_head		btlist;	  /* OWN_AG blocks */
+	struct list_head		nobtlist; /* rmapbt/agfl blocks */
+	struct xfs_scrub_context	*sc;
+	xfs_agblock_t			next_bno;
+	uint64_t			nr_records;
+};
+
+/* Record extents that aren't in use from gaps in the rmap records. */
+STATIC int
+xfs_repair_alloc_extent_fn(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_repair_alloc		*ra = priv;
+	struct xfs_repair_alloc_extent	*rae;
+	struct xfs_buf			*bp;
+	xfs_fsblock_t			fsb;
+	int				i;
+	int				error;
+
+	/* Record all the OWN_AG blocks... */
+	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
+		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+				rec->rm_startblock);
+		error = xfs_repair_collect_btree_extent(ra->sc,
+				&ra->btlist, fsb, rec->rm_blockcount);
+		if (error)
+			return error;
+	}
+
+	/* ...and all the rmapbt blocks... */
+	for (i = 0; i < cur->bc_nlevels && cur->bc_ptrs[i] == 1; i++) {
+		xfs_btree_get_block(cur, i, &bp);
+		if (!bp)
+			continue;
+		fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
+		error = xfs_repair_collect_btree_extent(ra->sc,
+				&ra->nobtlist, fsb, 1);
+		if (error)
+			return error;
+	}
+
+	/* ...and all the free space. */
+	if (rec->rm_startblock > ra->next_bno) {
+		trace_xfs_repair_alloc_extent_fn(sc->mp, cur->bc_private.a.agno,
+				rec->rm_startblock, rec->rm_blockcount,
+				rec->rm_owner, rec->rm_offset, rec->rm_flags);
+
+		rae = kmem_alloc(sizeof(struct xfs_repair_alloc_extent),
+				KM_MAYFAIL | KM_NOFS);
+		if (!rae)
+			return -ENOMEM;
+		INIT_LIST_HEAD(&rae->list);
+		rae->bno = ra->next_bno;
+		rae->len = rec->rm_startblock - ra->next_bno;
+		list_add_tail(&rae->list, &ra->extlist);
+		ra->nr_records++;
+	}
+	ra->next_bno = max_t(xfs_agblock_t, ra->next_bno,
+			rec->rm_startblock + rec->rm_blockcount);
+	return 0;
+}
+
+/* Find the longest free extent in the list. */
+static struct xfs_repair_alloc_extent *
+xfs_repair_allocbt_get_longest(
+	struct xfs_repair_alloc		*ra)
+{
+	struct xfs_repair_alloc_extent	*rae;
+	struct xfs_repair_alloc_extent	*longest = NULL;
+
+	list_for_each_entry(rae, &ra->extlist, list)
+		if (!longest || rae->len > longest->len)
+			longest = rae;
+	return longest;
+}
+
+/* Collect an AGFL block for the not-to-release list. */
+static int
+xfs_repair_collect_agfl_block(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno,
+	void				*data)
+{
+	struct xfs_repair_alloc		*ra = data;
+	xfs_fsblock_t			fsb;
+
+	fsb = XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, bno);
+	return xfs_repair_collect_btree_extent(sc, &ra->nobtlist, fsb, 1);
+}
+
+/* Compare two btree extents. */
+static int
+xfs_repair_allocbt_extent_cmp(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_repair_alloc_extent	*ap;
+	struct xfs_repair_alloc_extent	*bp;
+
+	ap = container_of(a, struct xfs_repair_alloc_extent, list);
+	bp = container_of(b, struct xfs_repair_alloc_extent, list);
+
+	if (ap->bno > bp->bno)
+		return 1;
+	else if (ap->bno < bp->bno)
+		return -1;
+	return 0;
+}
+
+/* Put an extent onto the free list. */
+STATIC int
+xfs_repair_allocbt_free_extent(
+	struct xfs_scrub_context	*sc,
+	xfs_fsblock_t			fsbno,
+	xfs_extlen_t			len,
+	struct xfs_owner_info		*oinfo)
+{
+	int				error;
+
+	error = xfs_free_extent(sc->tp, fsbno, len, oinfo, 0);
+	if (error)
+		return error;
+	error = xfs_repair_roll_ag_trans(sc);
+	if (error)
+		return error;
+	return xfs_mod_fdblocks(sc->mp, -(int64_t)len, false);
+}
+
+/* Allocate a block from the (cached) longest extent in the AG. */
+STATIC xfs_fsblock_t
+xfs_repair_allocbt_alloc_from_longest(
+	struct xfs_repair_alloc		*ra,
+	struct xfs_repair_alloc_extent	**longest)
+{
+	xfs_fsblock_t			fsb;
+
+	if (*longest && (*longest)->len == 0) {
+		list_del(&(*longest)->list);
+		kmem_free(*longest);
+		*longest = NULL;
+	}
+
+	if (*longest == NULL) {
+		*longest = xfs_repair_allocbt_get_longest(ra);
+		if (*longest == NULL)
+			return NULLFSBLOCK;
+	}
+
+	fsb = XFS_AGB_TO_FSB(ra->sc->mp, ra->sc->sa.agno, (*longest)->bno);
+	(*longest)->bno++;
+	(*longest)->len--;
+	return fsb;
+}
+
+/* Insert a free space record into the allocbt. */
+static int
+xfs_repair_allocbt_insert_free_space(
+	struct xfs_scrub_context	*sc,
+	struct xfs_owner_info		*oinfo,
+	struct xfs_repair_alloc_extent	*rae)
+{
+	int				error;
+
+	error = xfs_repair_allocbt_free_extent(sc,
+			XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, rae->bno),
+			rae->len, oinfo);
+	if (error)
+		return error;
+	list_del(&rae->list);
+	kmem_free(rae);
+	return 0;
+}
+
+/* Repair the freespace btrees for some AG. */
+int
+xfs_repair_allocbt(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_repair_alloc		ra;
+	struct xfs_owner_info		oinfo;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_btree_cur		*cur = NULL;
+	struct xfs_repair_alloc_extent	*longest = NULL;
+	struct xfs_repair_alloc_extent	*rae;
+	struct xfs_repair_alloc_extent	*n;
+	struct xfs_perag		*pag;
+	struct xfs_agf			*agf;
+	struct xfs_buf			*bp;
+	xfs_fsblock_t			bnofsb;
+	xfs_fsblock_t			cntfsb;
+	xfs_extlen_t			oldf;
+	xfs_extlen_t			nr_blocks;
+	xfs_agblock_t			agend;
+	int				error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	/*
+	 * Make sure the busy extent list is clear because we can't put
+	 * extents on there twice.
+	 */
+	pag = xfs_perag_get(sc->mp, sc->sa.agno);
+	spin_lock(&pag->pagb_lock);
+	if (pag->pagb_tree.rb_node) {
+		spin_unlock(&pag->pagb_lock);
+		xfs_perag_put(pag);
+		return -EDEADLOCK;
+	}
+	spin_unlock(&pag->pagb_lock);
+	xfs_perag_put(pag);
+
+	/*
+	 * Collect all reverse mappings for free extents, and the rmapbt
+	 * blocks.  We can discover the rmapbt blocks completely from a
+	 * query_all handler because there are always rmapbt entries.
+	 * (One cannot use on query_all to visit all of a btree's blocks
+	 * unless that btree is guaranteed to have at least one entry.)
+	 */
+	INIT_LIST_HEAD(&ra.extlist);
+	INIT_LIST_HEAD(&ra.btlist);
+	INIT_LIST_HEAD(&ra.nobtlist);
+	ra.next_bno = 0;
+	ra.nr_records = 0;
+	ra.sc = sc;
+
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno);
+	error = xfs_rmap_query_all(cur, xfs_repair_alloc_extent_fn, &ra);
+	if (error)
+		goto out;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	cur = NULL;
+
+	/* Insert a record for space between the last rmap and EOAG. */
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	agend = be32_to_cpu(agf->agf_length);
+	if (ra.next_bno < agend) {
+		rae = kmem_alloc(sizeof(struct xfs_repair_alloc_extent),
+				KM_MAYFAIL | KM_NOFS);
+		if (!rae) {
+			error = -ENOMEM;
+			goto out;
+		}
+		INIT_LIST_HEAD(&rae->list);
+		rae->bno = ra.next_bno;
+		rae->len = agend - ra.next_bno;
+		list_add_tail(&rae->list, &ra.extlist);
+		ra.nr_records++;
+	}
+
+	/* Collect all the AGFL blocks. */
+	error = xfs_scrub_walk_agfl(sc, xfs_repair_collect_agfl_block, &ra);
+	if (error)
+		goto out;
+
+	/* Do we actually have enough space to do this? */
+	pag = xfs_perag_get(mp, sc->sa.agno);
+	nr_blocks = 2 * xfs_allocbt_calc_size(mp, ra.nr_records);
+	if (!xfs_repair_ag_has_space(pag, nr_blocks, XFS_AG_RESV_NONE)) {
+		xfs_perag_put(pag);
+		error = -ENOSPC;
+		goto out;
+	}
+	xfs_perag_put(pag);
+
+	/* Invalidate all the bnobt/cntbt blocks in btlist. */
+	error = xfs_repair_subtract_extents(sc, &ra.btlist, &ra.nobtlist);
+	if (error)
+		goto out;
+	xfs_repair_cancel_btree_extents(sc, &ra.nobtlist);
+	error = xfs_repair_invalidate_blocks(sc, &ra.btlist);
+	if (error)
+		goto out;
+
+	/* Allocate new bnobt root. */
+	bnofsb = xfs_repair_allocbt_alloc_from_longest(&ra, &longest);
+	if (bnofsb == NULLFSBLOCK) {
+		error = -ENOSPC;
+		goto out;
+	}
+
+	/* Allocate new cntbt root. */
+	cntfsb = xfs_repair_allocbt_alloc_from_longest(&ra, &longest);
+	if (cntfsb == NULLFSBLOCK) {
+		error = -ENOSPC;
+		goto out;
+	}
+
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	/* Initialize new bnobt root. */
+	error = xfs_repair_init_btblock(sc, bnofsb, &bp, XFS_BTNUM_BNO,
+			&xfs_allocbt_buf_ops);
+	if (error)
+		goto out;
+	agf->agf_roots[XFS_BTNUM_BNOi] =
+			cpu_to_be32(XFS_FSB_TO_AGBNO(mp, bnofsb));
+	agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
+
+	/* Initialize new cntbt root. */
+	error = xfs_repair_init_btblock(sc, cntfsb, &bp, XFS_BTNUM_CNT,
+			&xfs_allocbt_buf_ops);
+	if (error)
+		goto out;
+	agf->agf_roots[XFS_BTNUM_CNTi] =
+			cpu_to_be32(XFS_FSB_TO_AGBNO(mp, cntfsb));
+	agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
+
+	/*
+	 * Since we're abandoning the old bnobt/cntbt, we have to
+	 * decrease fdblocks by the # of blocks in those trees.
+	 * btreeblks counts the non-root blocks of the free space
+	 * and rmap btrees.  Do this before resetting the AGF counters.
+	 */
+	pag = xfs_perag_get(mp, sc->sa.agno);
+	oldf = pag->pagf_btreeblks + 2;
+	oldf -= (be32_to_cpu(agf->agf_rmap_blocks) - 1);
+	error = xfs_mod_fdblocks(mp, -(int64_t)oldf, false);
+	if (error) {
+		xfs_perag_put(pag);
+		goto out;
+	}
+
+	/* Reset the perag info. */
+	pag->pagf_btreeblks = be32_to_cpu(agf->agf_rmap_blocks) - 1;
+	pag->pagf_freeblks = 0;
+	pag->pagf_longest = 0;
+	pag->pagf_levels[XFS_BTNUM_BNOi] =
+			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
+	pag->pagf_levels[XFS_BTNUM_CNTi] =
+			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
+
+	/* Now reset the AGF counters. */
+	agf->agf_btreeblks = cpu_to_be32(pag->pagf_btreeblks);
+	agf->agf_freeblks = cpu_to_be32(pag->pagf_freeblks);
+	agf->agf_longest = cpu_to_be32(pag->pagf_longest);
+	xfs_perag_put(pag);
+	xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp,
+			XFS_AGF_ROOTS | XFS_AGF_LEVELS | XFS_AGF_BTREEBLKS |
+			XFS_AGF_LONGEST | XFS_AGF_FREEBLKS);
+	error = xfs_repair_roll_ag_trans(sc);
+	if (error)
+		goto out;
+
+	/*
+	 * Insert the longest free extent in case it's necessary to
+	 * refresh the AGFL with multiple blocks.
+	 */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_UNKNOWN);
+	if (longest && longest->len == 0) {
+		error = xfs_repair_allocbt_insert_free_space(sc, &oinfo,
+				longest);
+		if (error)
+			goto out;
+	}
+
+	/* Insert records into the new btrees. */
+	list_sort(NULL, &ra.extlist, xfs_repair_allocbt_extent_cmp);
+	list_for_each_entry_safe(rae, n, &ra.extlist, list) {
+		error = xfs_repair_allocbt_insert_free_space(sc, &oinfo, rae);
+		if (error)
+			goto out;
+	}
+
+	/* Add rmap records for the btree roots */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
+	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno,
+			XFS_FSB_TO_AGBNO(mp, bnofsb), 1, &oinfo);
+	if (error)
+		goto out;
+	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno,
+			XFS_FSB_TO_AGBNO(mp, cntfsb), 1, &oinfo);
+	if (error)
+		goto out;
+
+	/* Free all the OWN_AG blocks that are not in the rmapbt/agfl. */
+	error = xfs_repair_reap_btree_extents(sc, &ra.btlist, &oinfo,
+			XFS_AG_RESV_NONE);
+	if (error)
+		goto out;
+
+	return 0;
+out:
+	xfs_repair_cancel_btree_extents(sc, &ra.btlist);
+	xfs_repair_cancel_btree_extents(sc, &ra.nobtlist);
+	if (cur)
+		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	list_for_each_entry_safe(rae, n, &ra.extlist, list) {
+		list_del(&rae->list);
+		kmem_free(rae);
+	}
+	return error;
+}
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 515bee6..8c00acb 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -42,6 +42,8 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_log.h"
+#include "xfs_trans_priv.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -711,8 +713,22 @@ xfs_scrub_setup_ag_btree(
 	struct xfs_inode		*ip,
 	bool				force_log)
 {
+	struct xfs_mount		*mp = sc->mp;
 	int				error;
 
+	/*
+	 * Push everything out of the log onto disk prior to checking.
+	 * Force everything in memory out to disk if we're repairing.
+	 * This ensures we won't get tripped up by btree blocks sitting
+	 * in memory waiting to have LSNs stamped in.
+	 */
+	if (force_log || (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)) {
+		error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
+		if (error)
+			return error;
+		xfs_ail_push_all_sync(mp->m_ail);
+	}
+
 	error = xfs_scrub_setup_ag_header(sc, ip);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index e80f2e3..5756d27 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -74,5 +74,6 @@ int xfs_repair_superblock(struct xfs_scrub_context *sc);
 int xfs_repair_agf(struct xfs_scrub_context *sc);
 int xfs_repair_agfl(struct xfs_scrub_context *sc);
 int xfs_repair_agi(struct xfs_scrub_context *sc);
+int xfs_repair_allocbt(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_REPAIR_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 03da10a..b15c320 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -236,10 +236,12 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 	{ /* bnobt */
 		.setup	= xfs_scrub_setup_ag_allocbt,
 		.scrub	= xfs_scrub_bnobt,
+		.repair	= xfs_repair_allocbt,
 	},
 	{ /* cntbt */
 		.setup	= xfs_scrub_setup_ag_allocbt,
 		.scrub	= xfs_scrub_cntbt,
+		.repair	= xfs_repair_allocbt,
 	},
 	{ /* inobt */
 		.setup	= xfs_scrub_setup_ag_iallocbt,

