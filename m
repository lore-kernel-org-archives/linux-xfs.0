Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE5EC77B61
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 22:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344237AbjD0Wpb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 18:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344308AbjD0Wpa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 18:45:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840AB3C28
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 15:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05E8963FE4
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 22:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61778C433D2;
        Thu, 27 Apr 2023 22:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682635522;
        bh=Q5W1rF60XpnNXeFoZYkq4BV4AhhVk01b7fskXEVSqoc=;
        h=Date:From:To:Cc:Subject:From;
        b=R6hA0eiMJguLQ+5HxVHIHHje3qFSMIYu4jqHVYSJddwIpI0jLLTf6je+W+Va8/tgh
         n/eFHhbUTpxKjiIhYfZ+V0Tyra5a/zL3Qbx5bXYTf/6K8H694PeIkfCFXkToiuEUE5
         JqJqM9AXMjBQSdhIT4E6HhPauvCdHGYqQ1QVre/K6+8wHscV+zdKC6kj0VvMMk6Tr0
         o71IwXuOqDiiBbHvfYivHX4jqmf2OugSJYqcUypgn+4YUC8P9IIHvBP7JC9KMiXBhQ
         yIYd24yjSS0xkd35VJGoeElp9rWoIoB6DgQfKNFKeXcyl/UaKNzNMxn1Y/iqZyFGjA
         6aRbogVdowZtw==
Date:   Thu, 27 Apr 2023 15:45:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_repair: estimate per-AG btree slack better
Message-ID: <20230427224521.GD59213@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The slack calculation for per-AG btrees is a bit inaccurate because it
only disables slack space in the new btrees when the amount of free
space in the AG (not counting the btrees) is less than 3/32ths of the
AG.  In other words, it assumes that the btrees will fit in less than 9
percent of the space.

However, there's one scenario where this goes wrong -- if the rmapbt
consumes a significant portion of the AG space.  Say a filesystem is
hosting a VM image farm that starts with perfectly shared images.  As
time goes by, random writes to those images will slowly cause the rmapbt
to increase in size as blocks within those images get COWed.

Suppose that the rmapbt now consumes 20% of the space in the AG, that
the AG is nearly full, and that the blocks in the old rmapbt are mostly
full.  At the start of phase5_func, mk_incore_fstree will return that
num_freeblocks is ~20% of the AG size.  Hence the slack calculation will
conclude that there's plenty of space in the AG and new btrees will be
built with 25% slack in the blocks.  If the size of these new expanded
btrees is larger than the free space in the AG, repair will fail to
allocate btree blocks and fail, causing severe filesystem damage.

To combat this, estimate the worst case size of the AG btrees given the
number of records we intend to put in them, subtract that worst case
figure from num_freeblocks, and feed that to bulkload_estimate_ag_slack.
This results in tighter packing of new btree blocks when space is dear,
and hopefully fewer problems.  This /can/ be reproduced with generic/333
if you hack it to keep COWing blocks until the filesystem is totally
out of space, even if reflink has long since refused to share more
blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    4 ++
 repair/agbtree.c         |   90 ++++++++++++++++++++++++++++++++++++++++------
 repair/agbtree.h         |    3 ++
 repair/phase5.c          |   18 +++++++--
 repair/rmap.c            |   44 ++++++++++++++++++++++
 repair/rmap.h            |    3 ++
 6 files changed, 146 insertions(+), 16 deletions(-)

diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index f8efcce7..d973e300 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -25,6 +25,7 @@
 #define xfs_ag_resv_free		libxfs_ag_resv_free
 
 #define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
+#define xfs_allocbt_calc_size		libxfs_allocbt_calc_size
 #define xfs_allocbt_maxlevels_ondisk	libxfs_allocbt_maxlevels_ondisk
 #define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
 #define xfs_allocbt_stage_cursor	libxfs_allocbt_stage_cursor
@@ -115,6 +116,7 @@
 #define xfs_highbit32			libxfs_highbit32
 #define xfs_highbit64			libxfs_highbit64
 #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
+#define xfs_iallocbt_calc_size		libxfs_iallocbt_calc_size
 #define xfs_iallocbt_maxlevels_ondisk	libxfs_iallocbt_maxlevels_ondisk
 #define xfs_ialloc_read_agi		libxfs_ialloc_read_agi
 #define xfs_idata_realloc		libxfs_idata_realloc
@@ -146,6 +148,7 @@
 #define xfs_read_agf			libxfs_read_agf
 #define xfs_refc_block			libxfs_refc_block
 #define xfs_refcountbt_calc_reserves	libxfs_refcountbt_calc_reserves
+#define xfs_refcountbt_calc_size	libxfs_refcountbt_calc_size
 #define xfs_refcountbt_init_cursor	libxfs_refcountbt_init_cursor
 #define xfs_refcountbt_maxlevels_ondisk	libxfs_refcountbt_maxlevels_ondisk
 #define xfs_refcountbt_maxrecs		libxfs_refcountbt_maxrecs
@@ -155,6 +158,7 @@
 
 #define xfs_rmap_alloc			libxfs_rmap_alloc
 #define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
+#define xfs_rmapbt_calc_size		libxfs_rmapbt_calc_size
 #define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
 #define xfs_rmapbt_maxlevels_ondisk	libxfs_rmapbt_maxlevels_ondisk
 #define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
diff --git a/repair/agbtree.c b/repair/agbtree.c
index ef001803..d5e441a3 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -17,13 +17,13 @@ static void
 init_rebuild(
 	struct repair_ctx		*sc,
 	const struct xfs_owner_info	*oinfo,
-	xfs_agblock_t			free_space,
+	xfs_agblock_t			est_agfreeblocks,
 	struct bt_rebuild		*btr)
 {
 	memset(btr, 0, sizeof(struct bt_rebuild));
 
 	bulkload_init_ag(&btr->newbt, sc, oinfo);
-	bulkload_estimate_ag_slack(sc, &btr->bload, free_space);
+	bulkload_estimate_ag_slack(sc, &btr->bload, est_agfreeblocks);
 }
 
 /*
@@ -227,7 +227,7 @@ void
 init_freespace_cursors(
 	struct repair_ctx	*sc,
 	struct xfs_perag	*pag,
-	unsigned int		free_space,
+	unsigned int		est_agfreeblocks,
 	unsigned int		*nr_extents,
 	int			*extra_blocks,
 	struct bt_rebuild	*btr_bno,
@@ -239,8 +239,8 @@ init_freespace_cursors(
 
 	agfl_goal = libxfs_alloc_min_freelist(sc->mp, NULL);
 
-	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_bno);
-	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_cnt);
+	init_rebuild(sc, &XFS_RMAP_OINFO_AG, est_agfreeblocks, btr_bno);
+	init_rebuild(sc, &XFS_RMAP_OINFO_AG, est_agfreeblocks, btr_cnt);
 
 	btr_bno->cur = libxfs_allocbt_stage_cursor(sc->mp,
 			&btr_bno->newbt.afake, pag, XFS_BTNUM_BNO);
@@ -439,7 +439,7 @@ void
 init_ino_cursors(
 	struct repair_ctx	*sc,
 	struct xfs_perag	*pag,
-	unsigned int		free_space,
+	unsigned int		est_agfreeblocks,
 	uint64_t		*num_inos,
 	uint64_t		*num_free_inos,
 	struct bt_rebuild	*btr_ino,
@@ -453,7 +453,7 @@ init_ino_cursors(
 	int			error;
 
 	finobt = xfs_has_finobt(sc->mp);
-	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, free_space, btr_ino);
+	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, est_agfreeblocks, btr_ino);
 
 	/* Compute inode statistics. */
 	*num_free_inos = 0;
@@ -506,7 +506,7 @@ _("Unable to compute inode btree geometry, error %d.\n"), error);
 	if (!finobt)
 		return;
 
-	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, free_space, btr_fino);
+	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, est_agfreeblocks, btr_fino);
 	btr_fino->cur = libxfs_inobt_stage_cursor(pag, &btr_fino->newbt.afake,
 			XFS_BTNUM_FINO);
 
@@ -577,7 +577,7 @@ void
 init_rmapbt_cursor(
 	struct repair_ctx	*sc,
 	struct xfs_perag	*pag,
-	unsigned int		free_space,
+	unsigned int		est_agfreeblocks,
 	struct bt_rebuild	*btr)
 {
 	xfs_agnumber_t		agno = pag->pag_agno;
@@ -586,7 +586,7 @@ init_rmapbt_cursor(
 	if (!xfs_has_rmapbt(sc->mp))
 		return;
 
-	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr);
+	init_rebuild(sc, &XFS_RMAP_OINFO_AG, est_agfreeblocks, btr);
 	btr->cur = libxfs_rmapbt_stage_cursor(sc->mp, &btr->newbt.afake, pag);
 
 	btr->bload.get_record = get_rmapbt_record;
@@ -648,7 +648,7 @@ void
 init_refc_cursor(
 	struct repair_ctx	*sc,
 	struct xfs_perag	*pag,
-	unsigned int		free_space,
+	unsigned int		est_agfreeblocks,
 	struct bt_rebuild	*btr)
 {
 	xfs_agnumber_t		agno = pag->pag_agno;
@@ -657,7 +657,7 @@ init_refc_cursor(
 	if (!xfs_has_reflink(sc->mp))
 		return;
 
-	init_rebuild(sc, &XFS_RMAP_OINFO_REFC, free_space, btr);
+	init_rebuild(sc, &XFS_RMAP_OINFO_REFC, est_agfreeblocks, btr);
 	btr->cur = libxfs_refcountbt_stage_cursor(sc->mp, &btr->newbt.afake,
 			pag);
 
@@ -698,3 +698,69 @@ _("Error %d while creating refcount btree for AG %u.\n"), error, agno);
 	libxfs_btree_del_cursor(btr->cur, 0);
 	free_slab_cursor(&btr->slab_cursor);
 }
+
+static xfs_extlen_t
+estimate_allocbt_blocks(
+	struct xfs_perag	*pag,
+	unsigned int		nr_extents)
+{
+	return libxfs_allocbt_calc_size(pag->pag_mount, nr_extents) * 2;
+}
+
+static xfs_extlen_t
+estimate_inobt_blocks(
+	struct xfs_perag	*pag)
+{
+	struct ino_tree_node	*ino_rec;
+	xfs_agnumber_t		agno = pag->pag_agno;
+	unsigned int		ino_recs = 0;
+	unsigned int		fino_recs = 0;
+	xfs_extlen_t		ret;
+
+	for (ino_rec = findfirst_inode_rec(agno);
+	     ino_rec != NULL;
+	     ino_rec = next_ino_rec(ino_rec))  {
+		unsigned int	rec_nfinos = 0;
+		int		i;
+
+		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
+			ASSERT(is_inode_confirmed(ino_rec, i));
+			/*
+			 * sparse inodes are not factored into superblock (free)
+			 * inode counts
+			 */
+			if (is_inode_sparse(ino_rec, i))
+				continue;
+			if (is_inode_free(ino_rec, i))
+				rec_nfinos++;
+		}
+
+		ino_recs++;
+
+		/* finobt only considers records with free inodes */
+		if (rec_nfinos)
+			fino_recs++;
+	}
+
+	ret = libxfs_iallocbt_calc_size(pag->pag_mount, ino_recs);
+	if (xfs_has_finobt(pag->pag_mount))
+		ret += libxfs_iallocbt_calc_size(pag->pag_mount, fino_recs);
+	return ret;
+
+}
+
+/* Estimate the size of the per-AG btrees. */
+xfs_extlen_t
+estimate_agbtree_blocks(
+	struct xfs_perag	*pag,
+	unsigned int		free_extents)
+{
+	unsigned int		ret = 0;
+
+	ret += estimate_allocbt_blocks(pag, free_extents);
+	ret += estimate_inobt_blocks(pag);
+	ret += estimate_rmapbt_blocks(pag);
+	ret += estimate_refcountbt_blocks(pag);
+
+	return ret;
+}
diff --git a/repair/agbtree.h b/repair/agbtree.h
index 84f7083d..714d8e68 100644
--- a/repair/agbtree.h
+++ b/repair/agbtree.h
@@ -59,4 +59,7 @@ void init_refc_cursor(struct repair_ctx *sc, struct xfs_perag *pag,
 void build_refcount_tree(struct repair_ctx *sc, xfs_agnumber_t agno,
 		struct bt_rebuild *btr);
 
+xfs_extlen_t estimate_agbtree_blocks(struct xfs_perag *pag,
+		unsigned int free_extents);
+
 #endif /* __XFS_REPAIR_AG_BTREE_H__ */
diff --git a/repair/phase5.c b/repair/phase5.c
index b04912d8..0d14c354 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -447,6 +447,8 @@ phase5_func(
 	int			extra_blocks = 0;
 	uint			num_freeblocks;
 	xfs_agblock_t		num_extents;
+	unsigned int		est_agfreeblocks = 0;
+	unsigned int		total_btblocks;
 
 	if (verbose)
 		do_log(_("        - agno = %d\n"), agno);
@@ -474,12 +476,20 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 			agno);
 	}
 
-	init_ino_cursors(&sc, pag, num_freeblocks, &sb_icount_ag[agno],
+	/*
+	 * Estimate the number of free blocks in this AG after rebuilding
+	 * all btrees.
+	 */
+	total_btblocks = estimate_agbtree_blocks(pag, num_extents);
+	if (num_freeblocks > total_btblocks)
+		est_agfreeblocks = num_freeblocks - total_btblocks;
+
+	init_ino_cursors(&sc, pag, est_agfreeblocks, &sb_icount_ag[agno],
 			&sb_ifree_ag[agno], &btr_ino, &btr_fino);
 
-	init_rmapbt_cursor(&sc, pag, num_freeblocks, &btr_rmap);
+	init_rmapbt_cursor(&sc, pag, est_agfreeblocks, &btr_rmap);
 
-	init_refc_cursor(&sc, pag, num_freeblocks, &btr_refc);
+	init_refc_cursor(&sc, pag, est_agfreeblocks, &btr_refc);
 
 	num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
 	/*
@@ -507,7 +517,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	/*
 	 * track blocks that we might really lose
 	 */
-	init_freespace_cursors(&sc, pag, num_freeblocks, &num_extents,
+	init_freespace_cursors(&sc, pag, est_agfreeblocks, &num_extents,
 			&extra_blocks, &btr_bno, &btr_cnt);
 
 	/*
diff --git a/repair/rmap.c b/repair/rmap.c
index 9013daa2..6bb77e08 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1531,3 +1531,47 @@ rmap_store_agflcount(
 
 	ag_rmaps[agno].ar_flcount = count;
 }
+
+/* Estimate the size of the ondisk rmapbt from the incore data. */
+xfs_extlen_t
+estimate_rmapbt_blocks(
+	struct xfs_perag	*pag)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_ag_rmap	*x;
+	unsigned long long	nr_recs = 0;
+
+	if (!rmap_needs_work(mp) || !xfs_has_rmapbt(mp))
+		return 0;
+
+	/*
+	 * Overestimate the amount of space needed by pretending that every
+	 * record in the incore slab will become rmapbt records.
+	 */
+	x = &ag_rmaps[pag->pag_agno];
+	if (x->ar_rmaps)
+		nr_recs += slab_count(x->ar_rmaps);
+	if (x->ar_raw_rmaps)
+		nr_recs += slab_count(x->ar_raw_rmaps);
+
+	return libxfs_rmapbt_calc_size(mp, nr_recs);
+}
+
+/* Estimate the size of the ondisk refcountbt from the incore data. */
+xfs_extlen_t
+estimate_refcountbt_blocks(
+	struct xfs_perag	*pag)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_ag_rmap	*x;
+
+	if (!rmap_needs_work(mp) || !xfs_has_reflink(mp))
+		return 0;
+
+	x = &ag_rmaps[pag->pag_agno];
+	if (!x->ar_refcount_items)
+		return 0;
+
+	return libxfs_refcountbt_calc_size(mp,
+			slab_count(x->ar_refcount_items));
+}
diff --git a/repair/rmap.h b/repair/rmap.h
index 8d176cb3..6004e9f6 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -48,4 +48,7 @@ extern int fix_inode_reflink_flags(struct xfs_mount *, xfs_agnumber_t);
 extern void fix_freelist(struct xfs_mount *, xfs_agnumber_t, bool);
 extern void rmap_store_agflcount(struct xfs_mount *, xfs_agnumber_t, int);
 
+xfs_extlen_t estimate_rmapbt_blocks(struct xfs_perag *pag);
+xfs_extlen_t estimate_refcountbt_blocks(struct xfs_perag *pag);
+
 #endif /* RMAP_H_ */
