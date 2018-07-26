Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44980 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbeGZBfI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 21:35:08 -0400
Subject: [PATCH 07/16] xfs: repair free space btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 25 Jul 2018 17:20:18 -0700
Message-ID: <153256441877.29021.16391351691957669894.stgit@magnolia>
In-Reply-To: <153256436688.29021.4638459579042241728.stgit@magnolia>
References: <153256436688.29021.4638459579042241728.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Rebuild the free space btrees from the gaps in the rmap btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile             |    1 
 fs/xfs/scrub/alloc.c        |    1 
 fs/xfs/scrub/alloc_repair.c |  581 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c       |    8 +
 fs/xfs/scrub/repair.h       |    2 
 fs/xfs/scrub/scrub.c        |    4 
 fs/xfs/scrub/trace.h        |    2 
 fs/xfs/xfs_extent_busy.c    |   14 +
 fs/xfs/xfs_extent_busy.h    |    2 
 9 files changed, 610 insertions(+), 5 deletions(-)
 create mode 100644 fs/xfs/scrub/alloc_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 57ec46951ede..44ddd112acd2 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -164,6 +164,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
+				   alloc_repair.o \
 				   bitmap.o \
 				   repair.o \
 				   )
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 036b5c7021eb..c9b34ba312ab 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -15,7 +15,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
-#include "xfs_alloc.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
 #include "scrub/xfs_scrub.h"
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
new file mode 100644
index 000000000000..b228c2906de2
--- /dev/null
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -0,0 +1,581 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_alloc.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_refcount.h"
+#include "xfs_extent_busy.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+
+/*
+ * Free Space Btree Repair
+ * =======================
+ *
+ * The reverse mappings are supposed to record all space usage for the entire
+ * AG.  Therefore, we can recalculate the free extents in an AG by looking for
+ * gaps in the physical extents recorded in the rmapbt.  On a reflink
+ * filesystem this is a little more tricky in that we have to be aware that
+ * the rmap records are allowed to overlap.
+ *
+ * We derive which blocks belonged to the old bnobt/cntbt by recording all the
+ * OWN_AG extents and subtracting out the blocks owned by all other OWN_AG
+ * metadata: the rmapbt blocks visited while iterating the reverse mappings
+ * and the AGFL blocks.
+ *
+ * Once we have both of those pieces, we can reconstruct the bnobt and cntbt
+ * by blowing out the free block state and freeing all the extents that we
+ * found.  This adds the requirement that we can't have any busy extents in
+ * the AG because the busy code cannot handle duplicate records.
+ *
+ * Note that we can only rebuild both free space btrees at the same time
+ * because the regular extent freeing infrastructure loads both btrees at the
+ * same time.
+ *
+ * We use the prefix 'xrep_abt' here because we regenerate both free space
+ * allocation btrees at the same time.
+ */
+
+struct xrep_abt_extent {
+	struct list_head	list;
+	xfs_agblock_t		bno;
+	xfs_extlen_t		len;
+};
+
+struct xrep_abt {
+	/* Blocks owned by the rmapbt or the agfl. */
+	struct xfs_bitmap	nobtlist;
+
+	/* All OWN_AG blocks. */
+	struct xfs_bitmap	*btlist;
+
+	/* Free space extents. */
+	struct list_head	*extlist;
+
+	struct xfs_scrub	*sc;
+
+	/* Length of extlist. */
+	uint64_t		nr_records;
+
+	/*
+	 * Next block we anticipate seeing in the rmap records.  If the next
+	 * rmap record is greater than next_bno, we have found unused space.
+	 */
+	xfs_agblock_t		next_bno;
+
+	/* Number of free blocks in this AG. */
+	xfs_agblock_t		nr_blocks;
+};
+
+/* Record extents that aren't in use from gaps in the rmap records. */
+STATIC int
+xrep_abt_walk_rmap(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rec,
+	void			*priv)
+{
+	struct xrep_abt		*ra = priv;
+	struct xrep_abt_extent	*rae;
+	xfs_fsblock_t		fsb;
+	int			error;
+
+	/* Record all the OWN_AG blocks... */
+	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
+		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+				rec->rm_startblock);
+		error = xfs_bitmap_set(ra->btlist, fsb, rec->rm_blockcount);
+		if (error)
+			return error;
+	}
+
+	/* ...and all the rmapbt blocks... */
+	error = xfs_bitmap_set_btcur_path(&ra->nobtlist, cur);
+	if (error)
+		return error;
+
+	/* ...and all the free space. */
+	if (rec->rm_startblock > ra->next_bno) {
+		trace_xrep_abt_walk_rmap(cur->bc_mp, cur->bc_private.a.agno,
+				ra->next_bno, rec->rm_startblock - ra->next_bno,
+				XFS_RMAP_OWN_NULL, 0, 0);
+
+		rae = kmem_alloc(sizeof(struct xrep_abt_extent), KM_MAYFAIL);
+		if (!rae)
+			return -ENOMEM;
+		INIT_LIST_HEAD(&rae->list);
+		rae->bno = ra->next_bno;
+		rae->len = rec->rm_startblock - ra->next_bno;
+		list_add_tail(&rae->list, ra->extlist);
+		ra->nr_records++;
+		ra->nr_blocks += rae->len;
+	}
+	ra->next_bno = max_t(xfs_agblock_t, ra->next_bno,
+			rec->rm_startblock + rec->rm_blockcount);
+	return 0;
+}
+
+/* Collect an AGFL block for the not-to-release list. */
+static int
+xrep_abt_walk_agfl(
+	struct xfs_mount	*mp,
+	xfs_agblock_t		bno,
+	void			*priv)
+{
+	struct xrep_abt		*ra = priv;
+	xfs_fsblock_t		fsb;
+
+	fsb = XFS_AGB_TO_FSB(mp, ra->sc->sa.agno, bno);
+	return xfs_bitmap_set(&ra->nobtlist, fsb, 1);
+}
+
+/* Compare two free space extents. */
+static int
+xrep_abt_extent_cmp(
+	void			*priv,
+	struct list_head	*a,
+	struct list_head	*b)
+{
+	struct xrep_abt_extent	*ap;
+	struct xrep_abt_extent	*bp;
+
+	ap = container_of(a, struct xrep_abt_extent, list);
+	bp = container_of(b, struct xrep_abt_extent, list);
+
+	if (ap->bno > bp->bno)
+		return 1;
+	else if (ap->bno < bp->bno)
+		return -1;
+	return 0;
+}
+
+/* Free an extent, which creates a record in the bnobt/cntbt. */
+STATIC int
+xrep_abt_free_extent(
+	struct xfs_scrub	*sc,
+	xfs_fsblock_t		fsbno,
+	xfs_extlen_t		len,
+	struct xfs_owner_info	*oinfo)
+{
+	int			error;
+
+	error = xfs_free_extent(sc->tp, fsbno, len, oinfo, 0);
+	if (error)
+		return error;
+	error = xrep_roll_ag_trans(sc);
+	if (error)
+		return error;
+	return xfs_mod_fdblocks(sc->mp, -(int64_t)len, false);
+}
+
+/* Find the longest free extent in the list. */
+static struct xrep_abt_extent *
+xrep_abt_get_longest(
+	struct list_head	*free_extents)
+{
+	struct xrep_abt_extent	*rae;
+	struct xrep_abt_extent	*res = NULL;
+
+	list_for_each_entry(rae, free_extents, list) {
+		if (!res || rae->len > res->len)
+			res = rae;
+	}
+	return res;
+}
+
+/*
+ * Allocate a block from the (cached) first extent in the AG.  In theory
+ * this should never fail, since we already checked that there was enough
+ * space to handle the new btrees.
+ */
+STATIC xfs_fsblock_t
+xrep_abt_alloc_block(
+	struct xfs_scrub	*sc,
+	struct list_head	*free_extents)
+{
+	struct xrep_abt_extent	*ext;
+
+	/* Pull the first free space extent off the list, and... */
+	ext = list_first_entry(free_extents, struct xrep_abt_extent, list);
+
+	/* ...take its first block. */
+	ext->bno++;
+	ext->len--;
+	if (ext->len == 0) {
+		list_del(&ext->list);
+		kmem_free(ext);
+	}
+
+	return XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, ext->bno - 1);
+}
+
+/* Free every record in the extent list. */
+STATIC void
+xrep_abt_cancel_freelist(
+	struct list_head	*extlist)
+{
+	struct xrep_abt_extent	*rae;
+	struct xrep_abt_extent	*n;
+
+	list_for_each_entry_safe(rae, n, extlist, list) {
+		list_del(&rae->list);
+		kmem_free(rae);
+	}
+}
+
+/*
+ * Iterate all reverse mappings to find (1) the free extents, (2) the OWN_AG
+ * extents, (3) the rmapbt blocks, and (4) the AGFL blocks.  The free space is
+ * (1) + (2) - (3) - (4).  Figure out if we have enough free space to
+ * reconstruct the free space btrees.  Caller must clean up the input lists
+ * if something goes wrong.
+ */
+STATIC int
+xrep_abt_find_freespace(
+	struct xfs_scrub	*sc,
+	struct list_head	*free_extents,
+	struct xfs_bitmap	*old_allocbt_blocks)
+{
+	struct xrep_abt		ra;
+	struct xrep_abt_extent	*rae;
+	struct xfs_btree_cur	*cur;
+	struct xfs_mount	*mp = sc->mp;
+	xfs_agblock_t		agend;
+	xfs_agblock_t		nr_blocks;
+	int			error;
+
+	ra.extlist = free_extents;
+	ra.btlist = old_allocbt_blocks;
+	xfs_bitmap_init(&ra.nobtlist);
+	ra.next_bno = 0;
+	ra.nr_records = 0;
+	ra.nr_blocks = 0;
+	ra.sc = sc;
+
+	/*
+	 * Iterate all the reverse mappings to find gaps in the physical
+	 * mappings, all the OWN_AG blocks, and all the rmapbt extents.
+	 */
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno);
+	error = xfs_rmap_query_all(cur, xrep_abt_walk_rmap, &ra);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, error);
+	cur = NULL;
+
+	/* Insert a record for space between the last rmap and EOAG. */
+	agend = be32_to_cpu(XFS_BUF_TO_AGF(sc->sa.agf_bp)->agf_length);
+	if (ra.next_bno < agend) {
+		rae = kmem_alloc(sizeof(struct xrep_abt_extent), KM_MAYFAIL);
+		if (!rae) {
+			error = -ENOMEM;
+			goto err;
+		}
+		INIT_LIST_HEAD(&rae->list);
+		rae->bno = ra.next_bno;
+		rae->len = agend - ra.next_bno;
+		list_add_tail(&rae->list, free_extents);
+		ra.nr_records++;
+		ra.nr_blocks += rae->len;
+	}
+
+	/* Collect all the AGFL blocks. */
+	error = xfs_agfl_walk(mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
+			sc->sa.agfl_bp, xrep_abt_walk_agfl, &ra);
+	if (error)
+		goto err;
+
+	/* Do we have enough space to rebuild both freespace btrees? */
+	nr_blocks = 2 * xfs_allocbt_calc_size(mp, ra.nr_records);
+	if (!xrep_ag_has_space(sc->sa.pag, nr_blocks, XFS_AG_RESV_NONE) ||
+	    ra.nr_blocks < nr_blocks) {
+		error = -ENOSPC;
+		goto err;
+	}
+
+	/* Compute the old bnobt/cntbt blocks. */
+	error = xfs_bitmap_disunion(old_allocbt_blocks, &ra.nobtlist);
+err:
+	xfs_bitmap_destroy(&ra.nobtlist);
+	if (cur)
+		xfs_btree_del_cursor(cur, error);
+	return error;
+}
+
+/*
+ * Reset the global free block counter and the per-AG counters to make it look
+ * like this AG has no free space.
+ */
+STATIC int
+xrep_abt_reset_counters(
+	struct xfs_scrub	*sc,
+	int			*log_flags)
+{
+	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_agf		*agf;
+	xfs_agblock_t		new_btblks;
+	xfs_agblock_t		to_free;
+	int			error;
+
+	/*
+	 * Since we're abandoning the old bnobt/cntbt, we have to decrease
+	 * fdblocks by the # of blocks in those trees.  btreeblks counts the
+	 * non-root blocks of the free space and rmap btrees.  Do this before
+	 * resetting the AGF counters.
+	 */
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+
+	/* rmap_blocks accounts root block, btreeblks doesn't */
+	new_btblks = be32_to_cpu(agf->agf_rmap_blocks) - 1;
+
+	/* btreeblks doesn't account bno/cnt root blocks */
+	to_free = pag->pagf_btreeblks + 2;
+
+	/* and don't account for the blocks we aren't freeing */
+	to_free -= new_btblks;
+
+	error = xfs_mod_fdblocks(sc->mp, -(int64_t)to_free, false);
+	if (error)
+		return error;
+
+	/*
+	 * Reset the per-AG info, both incore and ondisk.  Mark the incore
+	 * state stale in case we fail out of here.
+	 */
+	ASSERT(pag->pagf_init);
+	pag->pagf_init = 0;
+	pag->pagf_btreeblks = new_btblks;
+	pag->pagf_freeblks = 0;
+	pag->pagf_longest = 0;
+
+	agf->agf_btreeblks = cpu_to_be32(new_btblks);
+	agf->agf_freeblks = 0;
+	agf->agf_longest = 0;
+	*log_flags |= XFS_AGF_BTREEBLKS | XFS_AGF_LONGEST | XFS_AGF_FREEBLKS;
+
+	return 0;
+}
+
+/* Initialize a new free space btree root and implant into AGF. */
+STATIC int
+xrep_abt_reset_btree(
+	struct xfs_scrub	*sc,
+	xfs_btnum_t		btnum,
+	struct list_head	*free_extents)
+{
+	struct xfs_owner_info	oinfo;
+	struct xfs_buf		*bp;
+	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	xfs_fsblock_t		fsbno;
+	int			error;
+
+	/* Allocate new root block. */
+	fsbno = xrep_abt_alloc_block(sc, free_extents);
+	if (fsbno == NULLFSBLOCK)
+		return -ENOSPC;
+
+	/* Initialize new tree root. */
+	error = xrep_init_btblock(sc, fsbno, &bp, btnum, &xfs_allocbt_buf_ops);
+	if (error)
+		return error;
+
+	/* Implant into AGF. */
+	agf->agf_roots[btnum] = cpu_to_be32(XFS_FSB_TO_AGBNO(mp, fsbno));
+	agf->agf_levels[btnum] = cpu_to_be32(1);
+
+	/* Add rmap records for the btree roots */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
+	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno,
+			XFS_FSB_TO_AGBNO(mp, fsbno), 1, &oinfo);
+	if (error)
+		return error;
+
+	/* Reset the incore state. */
+	pag->pagf_levels[btnum] = 1;
+
+	return 0;
+}
+
+/* Initialize new bnobt/cntbt roots and implant them into the AGF. */
+STATIC int
+xrep_abt_reset_btrees(
+	struct xfs_scrub	*sc,
+	struct list_head	*free_extents,
+	int			*log_flags)
+{
+	int			error;
+
+	error = xrep_abt_reset_btree(sc, XFS_BTNUM_BNOi, free_extents);
+	if (error)
+		return error;
+	error = xrep_abt_reset_btree(sc, XFS_BTNUM_CNTi, free_extents);
+	if (error)
+		return error;
+
+	*log_flags |= XFS_AGF_ROOTS | XFS_AGF_LEVELS;
+	return 0;
+}
+
+/*
+ * Make our new freespace btree roots permanent so that we can start freeing
+ * unused space back into the AG.
+ */
+STATIC int
+xrep_abt_commit_new(
+	struct xfs_scrub	*sc,
+	struct xfs_bitmap	*old_allocbt_blocks,
+	int			log_flags)
+{
+	int			error;
+
+	xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, log_flags);
+
+	/* Invalidate the old freespace btree blocks and commit. */
+	error = xrep_invalidate_blocks(sc, old_allocbt_blocks);
+	if (error)
+		return error;
+	error = xrep_roll_ag_trans(sc);
+	if (error)
+		return error;
+
+	/* Now that we've succeeded, mark the incore state valid again. */
+	sc->sa.pag->pagf_init = 1;
+	return 0;
+}
+
+/* Build new free space btrees and dispose of the old one. */
+STATIC int
+xrep_abt_rebuild_trees(
+	struct xfs_scrub	*sc,
+	struct list_head	*free_extents,
+	struct xfs_bitmap	*old_allocbt_blocks)
+{
+	struct xfs_owner_info	oinfo;
+	struct xrep_abt_extent	*rae;
+	struct xrep_abt_extent	*n;
+	struct xrep_abt_extent	*longest;
+	int			error;
+
+	xfs_rmap_skip_owner_update(&oinfo);
+
+	/*
+	 * Insert the longest free extent in case it's necessary to
+	 * refresh the AGFL with multiple blocks.  If there is no longest
+	 * extent, we had exactly the free space we needed; we're done.
+	 */
+	longest = xrep_abt_get_longest(free_extents);
+	if (!longest)
+		goto done;
+	error = xrep_abt_free_extent(sc,
+			XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, longest->bno),
+			longest->len, &oinfo);
+	list_del(&longest->list);
+	kmem_free(longest);
+	if (error)
+		return error;
+
+	/* Insert records into the new btrees. */
+	list_for_each_entry_safe(rae, n, free_extents, list) {
+		error = xrep_abt_free_extent(sc,
+				XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, rae->bno),
+				rae->len, &oinfo);
+		if (error)
+			return error;
+		list_del(&rae->list);
+		kmem_free(rae);
+	}
+
+done:
+	/* Free all the OWN_AG blocks that are not in the rmapbt/agfl. */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
+	return xrep_reap_extents(sc, old_allocbt_blocks, &oinfo,
+			XFS_AG_RESV_NONE);
+}
+
+/* Repair the freespace btrees for some AG. */
+int
+xrep_allocbt(
+	struct xfs_scrub	*sc)
+{
+	struct list_head	free_extents;
+	struct xfs_bitmap	old_allocbt_blocks;
+	struct xfs_mount	*mp = sc->mp;
+	int			log_flags = 0;
+	int			error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	xchk_perag_get(sc->mp, &sc->sa);
+
+	/*
+	 * Make sure the busy extent list is clear because we can't put
+	 * extents on there twice.
+	 */
+	if (!xfs_extent_busy_list_empty(sc->sa.pag))
+		return -EDEADLOCK;
+
+	/* Collect the free space data and find the old btree blocks. */
+	INIT_LIST_HEAD(&free_extents);
+	xfs_bitmap_init(&old_allocbt_blocks);
+	error = xrep_abt_find_freespace(sc, &free_extents, &old_allocbt_blocks);
+	if (error)
+		goto out;
+
+	/* Make sure we got some free space. */
+	if (list_empty(&free_extents)) {
+		error = -ENOSPC;
+		goto out;
+	}
+
+	/*
+	 * Sort the free extents by block number to avoid bnobt splits when we
+	 * rebuild the free space btrees.
+	 */
+	list_sort(NULL, &free_extents, xrep_abt_extent_cmp);
+
+	/*
+	 * Blow out the old free space btrees.  This is the point at which
+	 * we are no longer able to bail out gracefully.
+	 */
+	error = xrep_abt_reset_counters(sc, &log_flags);
+	if (error)
+		goto out;
+	error = xrep_abt_reset_btrees(sc, &free_extents, &log_flags);
+	if (error)
+		goto out;
+	error = xrep_abt_commit_new(sc, &old_allocbt_blocks, log_flags);
+	if (error)
+		goto out;
+
+	/* Now rebuild the freespace information. */
+	error = xrep_abt_rebuild_trees(sc, &free_extents, &old_allocbt_blocks);
+out:
+	xrep_abt_cancel_freelist(&free_extents);
+	xfs_bitmap_destroy(&old_allocbt_blocks);
+	return error;
+}
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 6512d8fb67e1..5b910aecc59a 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -623,8 +623,14 @@ xchk_setup_ag_btree(
 	 * expensive operation should be performed infrequently and only
 	 * as a last resort.  Any caller that sets force_log should
 	 * document why they need to do so.
+	 *
+	 * Force everything in memory out to disk if we're repairing.
+	 * This ensures we won't get tripped up by btree blocks sitting
+	 * in memory waiting to have LSNs stamped in.  The AGF/AGI repair
+	 * routines use any available rmap data to try to find a btree
+	 * root that also passes the read verifiers.
 	 */
-	if (force_log) {
+	if (force_log || (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)) {
 		error = xchk_checkpoint_log(mp);
 		if (error)
 			return error;
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 9de321eee4ab..bc1a5f1cbcdc 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -61,6 +61,7 @@ int xrep_superblock(struct xfs_scrub *sc);
 int xrep_agf(struct xfs_scrub *sc);
 int xrep_agfl(struct xfs_scrub *sc);
 int xrep_agi(struct xfs_scrub *sc);
+int xrep_allocbt(struct xfs_scrub *sc);
 
 #else
 
@@ -87,6 +88,7 @@ xrep_calc_ag_resblks(
 #define xrep_agf			xrep_notsupported
 #define xrep_agfl			xrep_notsupported
 #define xrep_agi			xrep_notsupported
+#define xrep_allocbt			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 4bfae1e61d30..2133a3199372 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -232,13 +232,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_allocbt,
 		.scrub	= xchk_bnobt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_allocbt,
 	},
 	[XFS_SCRUB_TYPE_CNTBT] = {	/* cntbt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_allocbt,
 		.scrub	= xchk_cntbt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_allocbt,
 	},
 	[XFS_SCRUB_TYPE_INOBT] = {	/* inobt */
 		.type	= ST_PERAG,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 4e20f0e48232..26bd5dc68efe 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -551,7 +551,7 @@ DEFINE_EVENT(xrep_rmap_class, name, \
 		 xfs_agblock_t agbno, xfs_extlen_t len, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
-DEFINE_REPAIR_RMAP_EVENT(xrep_alloc_extent_fn);
+DEFINE_REPAIR_RMAP_EVENT(xrep_abt_walk_rmap);
 DEFINE_REPAIR_RMAP_EVENT(xrep_ialloc_extent_fn);
 DEFINE_REPAIR_RMAP_EVENT(xrep_rmap_extent_fn);
 DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_extent_fn);
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 0ed68379e551..82f99633a597 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -657,3 +657,17 @@ xfs_extent_busy_ag_cmp(
 		diff = b1->bno - b2->bno;
 	return diff;
 }
+
+/* Are there any busy extents in this AG? */
+bool
+xfs_extent_busy_list_empty(
+	struct xfs_perag	*pag)
+{
+	spin_lock(&pag->pagb_lock);
+	if (pag->pagb_tree.rb_node) {
+		spin_unlock(&pag->pagb_lock);
+		return false;
+	}
+	spin_unlock(&pag->pagb_lock);
+	return true;
+}
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 990ab3891971..2f8c73c712c6 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -65,4 +65,6 @@ static inline void xfs_extent_busy_sort(struct list_head *list)
 	list_sort(NULL, list, xfs_extent_busy_ag_cmp);
 }
 
+bool xfs_extent_busy_list_empty(struct xfs_perag *pag);
+
 #endif /* __XFS_EXTENT_BUSY_H__ */

