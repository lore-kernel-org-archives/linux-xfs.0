Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47746 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfHEAfO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:35:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750OxWC024269
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:10 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u51ptmba2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:35:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750Mxg8195483
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u51kktsg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:35:09 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x750Z9x7012590
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:09 GMT
Subject: [PATCH 04/18] xfs: repair free space btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 04 Aug 2019 17:35:07 -0700
Message-ID: <156496530772.804304.4506267733153244819.stgit@magnolia>
In-Reply-To: <156496528310.804304.8105015456378794397.stgit@magnolia>
References: <156496528310.804304.8105015456378794397.stgit@magnolia>
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
 fs/xfs/Makefile             |    1 
 fs/xfs/libxfs/xfs_ag_resv.c |    2 
 fs/xfs/scrub/alloc_repair.c |  595 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c       |    8 +
 fs/xfs/scrub/repair.h       |    8 +
 fs/xfs/scrub/scrub.c        |    6 
 fs/xfs/scrub/trace.h        |    2 
 fs/xfs/xfs_extent_busy.c    |   13 +
 fs/xfs/xfs_extent_busy.h    |    2 
 fs/xfs/xfs_mount.h          |    7 +
 10 files changed, 640 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/alloc_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0ace13e94d98..f1a1a2a47805 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -160,6 +160,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
+				   alloc_repair.o \
 				   array.o \
 				   bitmap.o \
 				   repair.o \
diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 87a9747f1d36..3f79958ce08e 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -381,6 +381,8 @@ xfs_ag_resv_free_extent(
 		/* fall through */
 	case XFS_AG_RESV_NONE:
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (int64_t)len);
+		/* fall through */
+	case XFS_AG_RESV_IGNORE:
 		return;
 	}
 
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
new file mode 100644
index 000000000000..7c98a2f76ee7
--- /dev/null
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -0,0 +1,595 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
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
+#include "xfs_health.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/array.h"
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
+	xfs_agblock_t		bno;
+	xfs_extlen_t		len;
+} __packed;
+
+struct xrep_abt {
+	/* Blocks owned by the rmapbt or the agfl. */
+	struct xfs_bitmap	nobtlist;
+
+	/* All OWN_AG blocks. */
+	struct xfs_bitmap	*btlist;
+
+	/* Free space extents. */
+	struct xfbma		*free_records;
+
+	struct xfs_scrub	*sc;
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
+	struct xrep_abt_extent	rae;
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
+		rae.bno = ra->next_bno;
+		rae.len = rec->rm_startblock - ra->next_bno;
+		error = xfbma_append(ra->free_records, &rae);
+		if (error)
+			return error;
+		ra->nr_blocks += rae.len;
+	}
+
+	/*
+	 * rmap records can overlap on reflink filesystems, so project next_bno
+	 * as far out into the AG space as we currently know about.
+	 */
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
+	const void			*a,
+	const void			*b)
+{
+	const struct xrep_abt_extent	*ap = a;
+	const struct xrep_abt_extent	*bp = b;
+
+	if (ap->bno > bp->bno)
+		return 1;
+	else if (ap->bno < bp->bno)
+		return -1;
+	return 0;
+}
+
+/*
+ * Add a free space record back into the bnobt/cntbt.  It is assumed that the
+ * space is already accounted for in fdblocks, so we use a special per-AG
+ * reservation code to skip the fdblocks update.
+ */
+STATIC int
+xrep_abt_free_extent(
+	const void			*item,
+	void				*priv)
+{
+	struct xfs_scrub		*sc = priv;
+	const struct xrep_abt_extent	*rae = item;
+	xfs_fsblock_t			fsbno;
+	int				error;
+
+	fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, rae->bno);
+
+	error = xfs_free_extent(sc->tp, fsbno, rae->len,
+			&XFS_RMAP_OINFO_SKIP_UPDATE, XFS_AG_RESV_IGNORE);
+	if (error)
+		return error;
+	return xrep_roll_ag_trans(sc);
+}
+
+/* Find the longest free extent in the list. */
+static int
+xrep_abt_get_longest(
+	struct xfbma		*free_records,
+	struct xrep_abt_extent	*longest)
+{
+	struct xrep_abt_extent	rae;
+	uint64_t		victim = -1ULL;
+	uint64_t		i;
+
+	longest->len = 0;
+	foreach_xfbma_item(free_records, i, rae) {
+		if (rae.len > longest->len) {
+			memcpy(longest, &rae, sizeof(*longest));
+			victim = i;
+		}
+	}
+
+	if (longest->len == 0)
+		return 0;
+	return xfbma_nullify(free_records, victim);
+}
+
+/*
+ * Allocate a block from the (cached) first extent in the AG.  In theory
+ * this should never fail, since we already checked that there was enough
+ * space to handle the new btrees.
+ */
+STATIC xfs_agblock_t
+xrep_abt_alloc_block(
+	struct xfs_scrub	*sc,
+	struct xfbma		*free_records)
+{
+	struct xrep_abt_extent	ext = { 0 };
+	uint64_t		i;
+	xfs_agblock_t		agbno;
+	int			error;
+
+	/* Pull the first free space extent off the list, and... */
+	foreach_xfbma_item(free_records, i, ext) {
+		break;
+	}
+	if (ext.len == 0)
+		return NULLAGBLOCK;
+
+	/* ...take its first block. */
+	agbno = ext.bno;
+	ext.bno++;
+	ext.len--;
+	if (ext.len)
+		error = xfbma_set(free_records, i, &ext);
+	else
+		error = xfbma_nullify(free_records, i);
+	if (error)
+		return NULLAGBLOCK;
+	return agbno;
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
+	struct xfbma		*free_records,
+	struct xfs_bitmap	*old_allocbt_blocks)
+{
+	struct xrep_abt		ra = {
+		.sc		= sc,
+		.free_records	= free_records,
+		.btlist		= old_allocbt_blocks,
+	};
+	struct xrep_abt_extent	rae;
+	struct xfs_btree_cur	*cur;
+	struct xfs_mount	*mp = sc->mp;
+	xfs_agblock_t		agend;
+	xfs_agblock_t		nr_blocks;
+	int			error;
+
+	xfs_bitmap_init(&ra.nobtlist);
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
+		rae.bno = ra.next_bno;
+		rae.len = agend - ra.next_bno;
+		error = xfbma_append(free_records, &rae);
+		if (error)
+			goto err;
+		ra.nr_blocks += rae.len;
+	}
+
+	/* Collect all the AGFL blocks. */
+	error = xfs_agfl_walk(mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
+			sc->sa.agfl_bp, xrep_abt_walk_agfl, &ra);
+	if (error)
+		goto err;
+
+	/*
+	 * Do we have enough space to rebuild both freespace btrees?  We won't
+	 * touch the AG if we've exceeded the per-AG reservation or if we don't
+	 * have enough free space to store the free space information.
+	 */
+	nr_blocks = 2 * xfs_allocbt_calc_size(mp, xfbma_length(free_records));
+	if (!xrep_ag_has_space(sc->sa.pag, 0, XFS_AG_RESV_NONE) ||
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
+	struct xfbma		*free_records)
+{
+	struct xfs_buf		*bp;
+	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	const struct xfs_buf_ops *ops;
+	xfs_agblock_t		agbno;
+	int			error;
+
+	/* Allocate new root block. */
+	agbno = xrep_abt_alloc_block(sc, free_records);
+	if (agbno == NULLAGBLOCK)
+		return -ENOSPC;
+
+	switch (btnum) {
+	case XFS_BTNUM_BNOi:
+		ops = &xfs_bnobt_buf_ops;
+		break;
+	case XFS_BTNUM_CNTi:
+		ops = &xfs_cntbt_buf_ops;
+		break;
+	default:
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	/* Initialize new tree root. */
+	error = xrep_init_btblock(sc, XFS_AGB_TO_FSB(mp, sc->sa.agno, agbno),
+			&bp, btnum, ops);
+	if (error)
+		return error;
+
+	/* Implant into AGF. */
+	agf->agf_roots[btnum] = cpu_to_be32(agbno);
+	agf->agf_levels[btnum] = cpu_to_be32(1);
+
+	/* Add rmap records for the btree roots */
+	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno, agbno, 1,
+			&XFS_RMAP_OINFO_AG);
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
+	struct xfbma		*free_records,
+	int			*log_flags)
+{
+	int			error;
+
+	error = xrep_abt_reset_btree(sc, XFS_BTNUM_BNOi, free_records);
+	if (error)
+		return error;
+	error = xrep_abt_reset_btree(sc, XFS_BTNUM_CNTi, free_records);
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
+	struct xfbma		*free_records,
+	struct xfs_bitmap	*old_allocbt_blocks)
+{
+	struct xrep_abt_extent	rae;
+	int			error;
+
+	/*
+	 * Insert the longest free extent in case it's necessary to
+	 * refresh the AGFL with multiple blocks.  If there is no longest
+	 * extent, we had exactly the free space we needed; we're done.
+	 */
+	error = xrep_abt_get_longest(free_records, &rae);
+	if (!error && rae.len > 0) {
+		error = xrep_abt_free_extent(&rae, sc);
+		if (error)
+			return error;
+	}
+
+	/* Free all the OWN_AG blocks that are not in the rmapbt/agfl. */
+	error = xrep_reap_extents(sc, old_allocbt_blocks, &XFS_RMAP_OINFO_AG,
+			XFS_AG_RESV_IGNORE);
+	if (error)
+		return error;
+
+	/* Insert records into the new btrees. */
+	return xfbma_iter_del(free_records, xrep_abt_free_extent, sc);
+}
+
+/* Repair the freespace btrees for some AG. */
+int
+xrep_allocbt(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_bitmap	old_allocbt_blocks;
+	struct xfbma		*free_records;
+	struct xfs_mount	*mp = sc->mp;
+	int			log_flags = 0;
+	int			error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	/* We rebuild both data structures. */
+	sc->sick_mask = XFS_SICK_AG_BNOBT | XFS_SICK_AG_CNTBT;
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
+	/* Set up some storage */
+	free_records = xfbma_init(sizeof(struct xrep_abt_extent));
+	if (IS_ERR(free_records))
+		return PTR_ERR(free_records);
+
+	/* Collect the free space data and find the old btree blocks. */
+	xfs_bitmap_init(&old_allocbt_blocks);
+	error = xrep_abt_find_freespace(sc, free_records, &old_allocbt_blocks);
+	if (error)
+		goto out;
+
+	/* Make sure we got some free space. */
+	if (xfbma_length(free_records) == 0) {
+		error = -ENOSPC;
+		goto out;
+	}
+
+	/*
+	 * Sort the free extents by block number to avoid bnobt splits when we
+	 * rebuild the free space btrees.
+	 */
+	error = xfbma_sort(free_records, xrep_abt_extent_cmp);
+	if (error)
+		goto out;
+
+	/*
+	 * Blow out the old free space btrees.  This is the point at which
+	 * we are no longer able to bail out gracefully.
+	 */
+	error = xrep_abt_reset_counters(sc, &log_flags);
+	if (error)
+		goto out;
+	error = xrep_abt_reset_btrees(sc, free_records, &log_flags);
+	if (error)
+		goto out;
+	error = xrep_abt_commit_new(sc, &old_allocbt_blocks, log_flags);
+	if (error)
+		goto out;
+
+	/* Now rebuild the freespace information. */
+	error = xrep_abt_rebuild_trees(sc, free_records, &old_allocbt_blocks);
+out:
+	xfbma_destroy(free_records);
+	xfs_bitmap_destroy(&old_allocbt_blocks);
+	return error;
+}
+
+/* Make sure both btrees are ok after we've rebuilt them. */
+int
+xrep_revalidate_allocbt(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	error = xchk_bnobt(sc);
+	if (error)
+		return error;
+
+	return xchk_cntbt(sc);
+}
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 18876056e5e0..4a49a9099477 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -634,8 +634,14 @@ xchk_setup_ag_btree(
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
index 60c61d7052a8..5a6a1cd437d7 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -52,6 +52,10 @@ int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
 void xrep_force_quotacheck(struct xfs_scrub *sc, uint dqtype);
 int xrep_ino_dqattach(struct xfs_scrub *sc);
 
+/* Metadata revalidators */
+
+int xrep_revalidate_allocbt(struct xfs_scrub *sc);
+
 /* Metadata repairers */
 
 int xrep_probe(struct xfs_scrub *sc);
@@ -59,6 +63,7 @@ int xrep_superblock(struct xfs_scrub *sc);
 int xrep_agf(struct xfs_scrub *sc);
 int xrep_agfl(struct xfs_scrub *sc);
 int xrep_agi(struct xfs_scrub *sc);
+int xrep_allocbt(struct xfs_scrub *sc);
 
 #else
 
@@ -79,11 +84,14 @@ xrep_calc_ag_resblks(
 	return 0;
 }
 
+#define xrep_revalidate_allocbt		(NULL)
+
 #define xrep_probe			xrep_notsupported
 #define xrep_superblock			xrep_notsupported
 #define xrep_agf			xrep_notsupported
 #define xrep_agfl			xrep_notsupported
 #define xrep_agi			xrep_notsupported
+#define xrep_allocbt			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 0f0b64d7164b..b42ac8ecdb49 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -217,13 +217,15 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_allocbt,
 		.scrub	= xchk_bnobt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_allocbt,
+		.repair_eval = xrep_revalidate_allocbt,
 	},
 	[XFS_SCRUB_TYPE_CNTBT] = {	/* cntbt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_allocbt,
 		.scrub	= xchk_cntbt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_allocbt,
+		.repair_eval = xrep_revalidate_allocbt,
 	},
 	[XFS_SCRUB_TYPE_INOBT] = {	/* inobt */
 		.type	= ST_PERAG,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 3362bae28b46..d43b6003a088 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -722,7 +722,7 @@ DEFINE_EVENT(xrep_rmap_class, name, \
 		 xfs_agblock_t agbno, xfs_extlen_t len, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
-DEFINE_REPAIR_RMAP_EVENT(xrep_alloc_extent_fn);
+DEFINE_REPAIR_RMAP_EVENT(xrep_abt_walk_rmap);
 DEFINE_REPAIR_RMAP_EVENT(xrep_ialloc_extent_fn);
 DEFINE_REPAIR_RMAP_EVENT(xrep_rmap_extent_fn);
 DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_extent_fn);
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 0ed68379e551..cc83b0687b9b 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -657,3 +657,16 @@ xfs_extent_busy_ag_cmp(
 		diff = b1->bno - b2->bno;
 	return diff;
 }
+
+/* Are there any busy extents in this AG? */
+bool
+xfs_extent_busy_list_empty(
+	struct xfs_perag	*pag)
+{
+	bool			res;
+
+	spin_lock(&pag->pagb_lock);
+	res = RB_EMPTY_ROOT(&pag->pagb_tree);
+	spin_unlock(&pag->pagb_lock);
+	return res;
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
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 4adb6837439a..f40283df29cc 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -332,6 +332,13 @@ enum xfs_ag_resv_type {
 	XFS_AG_RESV_AGFL,
 	XFS_AG_RESV_METADATA,
 	XFS_AG_RESV_RMAPBT,
+
+	/*
+	 * Don't increase fdblocks when freeing extent.  This is a pony for
+	 * the bnobt repair functions to re-free the free space without
+	 * altering fdblocks.  If you think you need this you're wrong.
+	 */
+	XFS_AG_RESV_IGNORE,
 };
 
 struct xfs_ag_resv {
