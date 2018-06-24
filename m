Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58412 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752239AbeFXTYL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jun 2018 15:24:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5OJOAtL077366
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:10 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2jt8a7gere-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:09 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJO9NR029611
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:09 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJO8Q6031490
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:09 GMT
Subject: [PATCH 06/21] xfs: repair free space btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 24 Jun 2018 12:24:07 -0700
Message-ID: <152986824747.3155.3861118263934672652.stgit@magnolia>
In-Reply-To: <152986820984.3155.16417868536016544528.stgit@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
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
 fs/xfs/scrub/alloc.c        |    1 
 fs/xfs/scrub/alloc_repair.c |  561 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c       |    8 +
 fs/xfs/scrub/repair.h       |    2 
 fs/xfs/scrub/scrub.c        |    4 
 fs/xfs/xfs_extent_busy.c    |   14 +
 fs/xfs/xfs_extent_busy.h    |    4 
 8 files changed, 591 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/alloc_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a36cccbec169..841e0824eeb6 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -164,6 +164,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
+				   alloc_repair.o \
 				   repair.o \
 				   )
 endif
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 50e4f7fa06f0..e2514c84cb7a 100644
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
index 000000000000..c25a2b0d71f1
--- /dev/null
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -0,0 +1,561 @@
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
+ */
+
+struct xfs_repair_alloc_extent {
+	struct list_head		list;
+	xfs_agblock_t			bno;
+	xfs_extlen_t			len;
+};
+
+struct xfs_repair_alloc {
+	struct xfs_repair_extent_list	nobtlist; /* rmapbt/agfl blocks */
+	struct xfs_repair_extent_list	*btlist;  /* OWN_AG blocks */
+	struct list_head		*extlist; /* free extents */
+	struct xfs_scrub_context	*sc;
+	uint64_t			nr_records; /* length of extlist */
+	xfs_agblock_t			next_bno; /* next bno we want to see */
+	xfs_agblock_t			nr_blocks; /* free blocks in extlist */
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
+	xfs_fsblock_t			fsb;
+	int				error;
+
+	/* Record all the OWN_AG blocks... */
+	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
+		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+				rec->rm_startblock);
+		error = xfs_repair_collect_btree_extent(ra->sc,
+				ra->btlist, fsb, rec->rm_blockcount);
+		if (error)
+			return error;
+	}
+
+	/* ...and all the rmapbt blocks... */
+	error = xfs_repair_collect_btree_cur_blocks(ra->sc, cur,
+			xfs_repair_collect_btree_cur_blocks_in_extent_list,
+			&ra->nobtlist);
+	if (error)
+		return error;
+
+	/* ...and all the free space. */
+	if (rec->rm_startblock > ra->next_bno) {
+		trace_xfs_repair_alloc_extent_fn(cur->bc_mp,
+				cur->bc_private.a.agno,
+				ra->next_bno, rec->rm_startblock - ra->next_bno,
+				XFS_RMAP_OWN_NULL, 0, 0);
+
+		rae = kmem_alloc(sizeof(struct xfs_repair_alloc_extent),
+				KM_MAYFAIL);
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
+xfs_repair_collect_agfl_block(
+	struct xfs_mount		*mp,
+	xfs_agblock_t			bno,
+	void				*priv)
+{
+	struct xfs_repair_alloc		*ra = priv;
+	xfs_fsblock_t			fsb;
+
+	fsb = XFS_AGB_TO_FSB(mp, ra->sc->sa.agno, bno);
+	return xfs_repair_collect_btree_extent(ra->sc, &ra->nobtlist, fsb, 1);
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
+/* Find the longest free extent in the list. */
+static struct xfs_repair_alloc_extent *
+xfs_repair_allocbt_get_longest(
+	struct list_head		*free_extents)
+{
+	struct xfs_repair_alloc_extent	*rae;
+	struct xfs_repair_alloc_extent	*res = NULL;
+
+	list_for_each_entry(rae, free_extents, list) {
+		if (!res || rae->len > res->len)
+			res = rae;
+	}
+	return res;
+}
+
+/* Find the shortest free extent in the list. */
+static struct xfs_repair_alloc_extent *
+xfs_repair_allocbt_get_shortest(
+	struct list_head		*free_extents)
+{
+	struct xfs_repair_alloc_extent	*rae;
+	struct xfs_repair_alloc_extent	*res = NULL;
+
+	list_for_each_entry(rae, free_extents, list) {
+		if (!res || rae->len < res->len)
+			res = rae;
+		if (res->len == 1)
+			break;
+	}
+	return res;
+}
+
+/*
+ * Allocate a block from the (cached) shortest extent in the AG.  In theory
+ * this should never fail, since we already checked that there was enough
+ * space to handle the new btrees.
+ */
+STATIC xfs_fsblock_t
+xfs_repair_allocbt_alloc_block(
+	struct xfs_scrub_context	*sc,
+	struct list_head		*free_extents,
+	struct xfs_repair_alloc_extent	**cached_result)
+{
+	struct xfs_repair_alloc_extent	*ext = *cached_result;
+	xfs_fsblock_t			fsb;
+
+	/* No cached result, see if we can find another. */
+	if (!ext) {
+		ext = xfs_repair_allocbt_get_shortest(free_extents);
+		ASSERT(ext);
+		if (!ext)
+			return NULLFSBLOCK;
+	}
+
+	/* Subtract one block. */
+	fsb = XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, ext->bno);
+	ext->bno++;
+	ext->len--;
+	if (ext->len == 0) {
+		list_del(&ext->list);
+		kmem_free(ext);
+		ext = NULL;
+	}
+
+	*cached_result = ext;
+	return fsb;
+}
+
+/* Free every record in the extent list. */
+STATIC void
+xfs_repair_allocbt_cancel_freelist(
+	struct list_head		*extlist)
+{
+	struct xfs_repair_alloc_extent	*rae;
+	struct xfs_repair_alloc_extent	*n;
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
+xfs_repair_allocbt_find_freespace(
+	struct xfs_scrub_context	*sc,
+	struct list_head		*free_extents,
+	struct xfs_repair_extent_list	*old_allocbt_blocks)
+{
+	struct xfs_repair_alloc		ra;
+	struct xfs_repair_alloc_extent	*rae;
+	struct xfs_btree_cur		*cur;
+	struct xfs_mount		*mp = sc->mp;
+	xfs_agblock_t			agend;
+	xfs_agblock_t			nr_blocks;
+	int				error;
+
+	ra.extlist = free_extents;
+	ra.btlist = old_allocbt_blocks;
+	xfs_repair_init_extent_list(&ra.nobtlist);
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
+	error = xfs_rmap_query_all(cur, xfs_repair_alloc_extent_fn, &ra);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	cur = NULL;
+
+	/* Insert a record for space between the last rmap and EOAG. */
+	agend = be32_to_cpu(XFS_BUF_TO_AGF(sc->sa.agf_bp)->agf_length);
+	if (ra.next_bno < agend) {
+		rae = kmem_alloc(sizeof(struct xfs_repair_alloc_extent),
+				KM_MAYFAIL);
+		if (!rae) {
+			error = -ENOMEM;
+			goto err;
+		}
+		INIT_LIST_HEAD(&rae->list);
+		rae->bno = ra.next_bno;
+		rae->len = agend - ra.next_bno;
+		list_add_tail(&rae->list, free_extents);
+		ra.nr_records++;
+	}
+
+	/* Collect all the AGFL blocks. */
+	error = xfs_agfl_walk(mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
+			sc->sa.agfl_bp, xfs_repair_collect_agfl_block, &ra);
+	if (error)
+		goto err;
+
+	/* Do we actually have enough space to do this? */
+	nr_blocks = 2 * xfs_allocbt_calc_size(mp, ra.nr_records);
+	if (!xfs_repair_ag_has_space(sc->sa.pag, nr_blocks, XFS_AG_RESV_NONE) ||
+	    ra.nr_blocks < nr_blocks) {
+		error = -ENOSPC;
+		goto err;
+	}
+
+	/* Compute the old bnobt/cntbt blocks. */
+	error = xfs_repair_subtract_extents(sc, old_allocbt_blocks,
+			&ra.nobtlist);
+	if (error)
+		goto err;
+	xfs_repair_cancel_btree_extents(sc, &ra.nobtlist);
+	return 0;
+
+err:
+	xfs_repair_cancel_btree_extents(sc, &ra.nobtlist);
+	if (cur)
+		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/*
+ * Reset the global free block counter and the per-AG counters to make it look
+ * like this AG has no free space.
+ */
+STATIC int
+xfs_repair_allocbt_reset_counters(
+	struct xfs_scrub_context	*sc,
+	int				*log_flags)
+{
+	struct xfs_perag		*pag = sc->sa.pag;
+	struct xfs_agf			*agf;
+	xfs_extlen_t			oldf;
+	xfs_agblock_t			rmap_blocks;
+	int				error;
+
+	/*
+	 * Since we're abandoning the old bnobt/cntbt, we have to
+	 * decrease fdblocks by the # of blocks in those trees.
+	 * btreeblks counts the non-root blocks of the free space
+	 * and rmap btrees.  Do this before resetting the AGF counters.
+	 */
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	rmap_blocks = be32_to_cpu(agf->agf_rmap_blocks) - 1;
+	oldf = pag->pagf_btreeblks + 2;
+	oldf -= rmap_blocks;
+	error = xfs_mod_fdblocks(sc->mp, -(int64_t)oldf, false);
+	if (error)
+		return error;
+
+	/* Reset the per-AG info, both incore and ondisk. */
+	pag->pagf_btreeblks = rmap_blocks;
+	pag->pagf_freeblks = 0;
+	pag->pagf_longest = 0;
+
+	agf->agf_btreeblks = cpu_to_be32(pag->pagf_btreeblks);
+	agf->agf_freeblks = 0;
+	agf->agf_longest = 0;
+	*log_flags |= XFS_AGF_BTREEBLKS | XFS_AGF_LONGEST | XFS_AGF_FREEBLKS;
+
+	return 0;
+}
+
+/* Initialize new bnobt/cntbt roots and implant them into the AGF. */
+STATIC int
+xfs_repair_allocbt_reset_btrees(
+	struct xfs_scrub_context	*sc,
+	struct list_head		*free_extents,
+	int				*log_flags)
+{
+	struct xfs_owner_info		oinfo;
+	struct xfs_repair_alloc_extent	*cached = NULL;
+	struct xfs_buf			*bp;
+	struct xfs_perag		*pag = sc->sa.pag;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_agf			*agf;
+	xfs_fsblock_t			bnofsb;
+	xfs_fsblock_t			cntfsb;
+	int				error;
+
+	/* Allocate new bnobt root. */
+	bnofsb = xfs_repair_allocbt_alloc_block(sc, free_extents, &cached);
+	if (bnofsb == NULLFSBLOCK)
+		return -ENOSPC;
+
+	/* Allocate new cntbt root. */
+	cntfsb = xfs_repair_allocbt_alloc_block(sc, free_extents, &cached);
+	if (cntfsb == NULLFSBLOCK)
+		return -ENOSPC;
+
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	/* Initialize new bnobt root. */
+	error = xfs_repair_init_btblock(sc, bnofsb, &bp, XFS_BTNUM_BNO,
+			&xfs_allocbt_buf_ops);
+	if (error)
+		return error;
+	agf->agf_roots[XFS_BTNUM_BNOi] =
+			cpu_to_be32(XFS_FSB_TO_AGBNO(mp, bnofsb));
+	agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
+
+	/* Initialize new cntbt root. */
+	error = xfs_repair_init_btblock(sc, cntfsb, &bp, XFS_BTNUM_CNT,
+			&xfs_allocbt_buf_ops);
+	if (error)
+		return error;
+	agf->agf_roots[XFS_BTNUM_CNTi] =
+			cpu_to_be32(XFS_FSB_TO_AGBNO(mp, cntfsb));
+	agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
+
+	/* Add rmap records for the btree roots */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
+	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno,
+			XFS_FSB_TO_AGBNO(mp, bnofsb), 1, &oinfo);
+	if (error)
+		return error;
+	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno,
+			XFS_FSB_TO_AGBNO(mp, cntfsb), 1, &oinfo);
+	if (error)
+		return error;
+
+	/* Reset the incore state. */
+	pag->pagf_levels[XFS_BTNUM_BNOi] = 1;
+	pag->pagf_levels[XFS_BTNUM_CNTi] = 1;
+
+	*log_flags |=  XFS_AGF_ROOTS | XFS_AGF_LEVELS;
+	return 0;
+}
+
+/* Build new free space btrees and dispose of the old one. */
+STATIC int
+xfs_repair_allocbt_rebuild_trees(
+	struct xfs_scrub_context	*sc,
+	struct list_head		*free_extents,
+	struct xfs_repair_extent_list	*old_allocbt_blocks)
+{
+	struct xfs_owner_info		oinfo;
+	struct xfs_repair_alloc_extent	*rae;
+	struct xfs_repair_alloc_extent	*n;
+	struct xfs_repair_alloc_extent	*longest;
+	int				error;
+
+	xfs_rmap_skip_owner_update(&oinfo);
+
+	/*
+	 * Insert the longest free extent in case it's necessary to
+	 * refresh the AGFL with multiple blocks.  If there is no longest
+	 * extent, we had exactly the free space we needed; we're done.
+	 */
+	longest = xfs_repair_allocbt_get_longest(free_extents);
+	if (!longest)
+		goto done;
+	error = xfs_repair_allocbt_free_extent(sc,
+			XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, longest->bno),
+			longest->len, &oinfo);
+	list_del(&longest->list);
+	kmem_free(longest);
+	if (error)
+		return error;
+
+	/* Insert records into the new btrees. */
+	list_sort(NULL, free_extents, xfs_repair_allocbt_extent_cmp);
+	list_for_each_entry_safe(rae, n, free_extents, list) {
+		error = xfs_repair_allocbt_free_extent(sc,
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
+	return xfs_repair_reap_btree_extents(sc, old_allocbt_blocks, &oinfo,
+			XFS_AG_RESV_NONE);
+}
+
+/* Repair the freespace btrees for some AG. */
+int
+xfs_repair_allocbt(
+	struct xfs_scrub_context	*sc)
+{
+	struct list_head		free_extents;
+	struct xfs_repair_extent_list	old_allocbt_blocks;
+	struct xfs_mount		*mp = sc->mp;
+	int				log_flags = 0;
+	int				error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	xfs_scrub_perag_get(sc->mp, &sc->sa);
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
+	xfs_repair_init_extent_list(&old_allocbt_blocks);
+	error = xfs_repair_allocbt_find_freespace(sc, &free_extents,
+			&old_allocbt_blocks);
+	if (error)
+		goto out;
+
+	/*
+	 * Blow out the old free space btrees.  This is the point at which
+	 * we are no longer able to bail out gracefully.
+	 */
+	error = xfs_repair_allocbt_reset_counters(sc, &log_flags);
+	if (error)
+		goto out;
+	error = xfs_repair_allocbt_reset_btrees(sc, &free_extents, &log_flags);
+	if (error)
+		goto out;
+	xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, log_flags);
+
+	/* Invalidate the old freespace btree blocks and commit. */
+	error = xfs_repair_invalidate_blocks(sc, &old_allocbt_blocks);
+	if (error)
+		goto out;
+	error = xfs_repair_roll_ag_trans(sc);
+	if (error)
+		goto out;
+
+	/* Now rebuild the freespace information. */
+	error = xfs_repair_allocbt_rebuild_trees(sc, &free_extents,
+			&old_allocbt_blocks);
+out:
+	xfs_repair_allocbt_cancel_freelist(&free_extents);
+	xfs_repair_cancel_btree_extents(sc, &old_allocbt_blocks);
+	return error;
+}
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 70e70c69f83f..c1132a40a366 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -623,8 +623,14 @@ xfs_scrub_setup_ag_btree(
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
 		error = xfs_scrub_checkpoint_log(mp);
 		if (error)
 			return error;
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index d541c1586d0a..e5f67fc68e9a 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -103,6 +103,7 @@ int xfs_repair_superblock(struct xfs_scrub_context *sc);
 int xfs_repair_agf(struct xfs_scrub_context *sc);
 int xfs_repair_agfl(struct xfs_scrub_context *sc);
 int xfs_repair_agi(struct xfs_scrub_context *sc);
+int xfs_repair_allocbt(struct xfs_scrub_context *sc);
 
 #else
 
@@ -129,6 +130,7 @@ xfs_repair_calc_ag_resblks(
 #define xfs_repair_agf			xfs_repair_notsupported
 #define xfs_repair_agfl			xfs_repair_notsupported
 #define xfs_repair_agi			xfs_repair_notsupported
+#define xfs_repair_allocbt		xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 0f036aab2551..7a55b20b7e4e 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -226,13 +226,13 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_ag_allocbt,
 		.scrub	= xfs_scrub_bnobt,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_allocbt,
 	},
 	[XFS_SCRUB_TYPE_CNTBT] = {	/* cntbt */
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_ag_allocbt,
 		.scrub	= xfs_scrub_cntbt,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_allocbt,
 	},
 	[XFS_SCRUB_TYPE_INOBT] = {	/* inobt */
 		.type	= ST_PERAG,
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
index 990ab3891971..df1ea61df16e 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -65,4 +65,8 @@ static inline void xfs_extent_busy_sort(struct list_head *list)
 	list_sort(NULL, list, xfs_extent_busy_ag_cmp);
 }
 
+bool
+xfs_extent_busy_list_empty(
+	struct xfs_perag	*pag);
+
 #endif /* __XFS_EXTENT_BUSY_H__ */

