Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22417C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbiL3Xnu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235801AbiL3Xnq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:43:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD141DF34
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:43:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEE9AB81DCA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC34C433D2;
        Fri, 30 Dec 2022 23:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443820;
        bh=EzVlmjsuUWoalbhbiEkvBJqlMBSEj6k2rWIfBZBdLCg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ey8tHrGntpTEWLM3WXe4cWPujrS+YYeRtCwG0xukE/lMydDnHT6OAevV6bAWr4BzS
         whTxwYiReUx3GzQ6c4ff/erRdqNTjSjLVKd9JoON1kjClRUw/ZMM5xCLXnRB/ZeohB
         gluGWlUM23YNxta9ut44cumSbV33bEK2dG/UQxQ6ReXpFZsmbZ63lAUNiuGgGKb3Fh
         zI1GlbKZar8QRZxuhedG4QErkf8QL1q2ss+Nh0+PS2hYgWbQL36e/Asb7vtadTgHbf
         Cy87EPeDmoGo9oENcCUTQklkP617YI4dMS86rTuqJwtLYE2qPVyVYlJ/dFSV/+OBME
         nENrmclJUfihA==
Subject: [PATCH 3/4] xfs: create a shadow rmap btree during rmap repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:30 -0800
Message-ID: <167243841047.696748.1109958954696816235.stgit@magnolia>
In-Reply-To: <167243840997.696748.11741067698987523110.stgit@magnolia>
References: <167243840997.696748.11741067698987523110.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create an in-memory btree of rmap records instead of an array.  This
enables us to do live record collection instead of freezing the fs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c       |   25 ++--
 fs/xfs/libxfs/xfs_rmap_btree.c |  123 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h |    9 +
 fs/xfs/scrub/repair.c          |   23 ++++
 fs/xfs/scrub/repair.h          |    2 
 fs/xfs/scrub/rmap_repair.c     |  250 +++++++++++++++++++++++++++++-----------
 6 files changed, 353 insertions(+), 79 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 16233bb5be7e..f7587f985aca 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -274,6 +274,8 @@ xfs_rmap_check_irec(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*irec)
 {
+	if (cur->bc_flags & XFS_BTREE_IN_MEMORY)
+		return xfs_rmap_check_perag_irec(cur->bc_mem.pag, irec);
 	return xfs_rmap_check_perag_irec(cur->bc_ag.pag, irec);
 }
 
@@ -285,9 +287,13 @@ xfs_rmap_complain_bad_rec(
 {
 	struct xfs_mount		*mp = cur->bc_mp;
 
-	xfs_warn(mp,
-		"Reverse Mapping BTree record corruption in AG %d detected at %pS!",
-		cur->bc_ag.pag->pag_agno, fa);
+	if (cur->bc_flags & XFS_BTREE_IN_MEMORY)
+		xfs_warn(mp,
+ "In-Memory Reverse Mapping BTree record corruption detected at %pS!", fa);
+	else
+		xfs_warn(mp,
+ "Reverse Mapping BTree record corruption in AG %d detected at %pS!",
+			cur->bc_ag.pag->pag_agno, fa);
 	xfs_warn(mp,
 		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
@@ -2412,15 +2418,12 @@ xfs_rmap_map_raw(
 {
 	struct xfs_owner_info	oinfo;
 
-	oinfo.oi_owner = rmap->rm_owner;
-	oinfo.oi_offset = rmap->rm_offset;
-	oinfo.oi_flags = 0;
-	if (rmap->rm_flags & XFS_RMAP_ATTR_FORK)
-		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
-	if (rmap->rm_flags & XFS_RMAP_BMBT_BLOCK)
-		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
+	xfs_owner_info_pack(&oinfo, rmap->rm_owner, rmap->rm_offset,
+			rmap->rm_flags);
 
-	if (rmap->rm_flags || XFS_RMAP_NON_INODE_OWNER(rmap->rm_owner))
+	if ((rmap->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			       XFS_RMAP_UNWRITTEN)) ||
+	    XFS_RMAP_NON_INODE_OWNER(rmap->rm_owner))
 		return xfs_rmap_map(cur, rmap->rm_startblock,
 				rmap->rm_blockcount,
 				rmap->rm_flags & XFS_RMAP_UNWRITTEN,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 103e4c97badc..49e6ecb9fb62 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -21,6 +21,9 @@
 #include "xfs_extent_busy.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
+#include "scrub/xfile.h"
+#include "scrub/xfbtree.h"
+#include "xfs_btree_mem.h"
 
 static struct kmem_cache	*xfs_rmapbt_cur_cache;
 
@@ -555,6 +558,126 @@ xfs_rmapbt_stage_cursor(
 	return cur;
 }
 
+#ifdef CONFIG_XFS_IN_MEMORY_BTREE
+/*
+ * Validate an in-memory rmap btree block.  Callers are allowed to generate an
+ * in-memory btree even if the ondisk feature is not enabled.
+ */
+static xfs_failaddr_t
+xfs_rmapbt_mem_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_failaddr_t		fa;
+	unsigned int		level;
+
+	if (!xfs_verify_magic(bp, block->bb_magic))
+		return __this_address;
+
+	fa = xfs_btree_sblock_v5hdr_verify(bp);
+	if (fa)
+		return fa;
+
+	level = be16_to_cpu(block->bb_level);
+	if (xfs_has_rmapbt(mp)) {
+		if (level >= mp->m_rmap_maxlevels)
+			return __this_address;
+	} else {
+		if (level >= xfs_rmapbt_maxlevels_ondisk())
+			return __this_address;
+	}
+
+	return xfbtree_sblock_verify(bp,
+			xfs_rmapbt_maxrecs(xfo_to_b(1), level == 0));
+}
+
+static void
+xfs_rmapbt_mem_rw_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa = xfs_rmapbt_mem_verify(bp);
+
+	if (fa)
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+}
+
+/* skip crc checks on in-memory btrees to save time */
+static const struct xfs_buf_ops xfs_rmapbt_mem_buf_ops = {
+	.name			= "xfs_rmapbt_mem",
+	.magic			= { 0, cpu_to_be32(XFS_RMAP_CRC_MAGIC) },
+	.verify_read		= xfs_rmapbt_mem_rw_verify,
+	.verify_write		= xfs_rmapbt_mem_rw_verify,
+	.verify_struct		= xfs_rmapbt_mem_verify,
+};
+
+static const struct xfs_btree_ops xfs_rmapbt_mem_ops = {
+	.rec_len		= sizeof(struct xfs_rmap_rec),
+	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+
+	.dup_cursor		= xfbtree_dup_cursor,
+	.set_root		= xfbtree_set_root,
+	.alloc_block		= xfbtree_alloc_block,
+	.free_block		= xfbtree_free_block,
+	.get_minrecs		= xfbtree_get_minrecs,
+	.get_maxrecs		= xfbtree_get_maxrecs,
+	.init_key_from_rec	= xfs_rmapbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_rmapbt_init_high_key_from_rec,
+	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
+	.key_diff		= xfs_rmapbt_key_diff,
+	.buf_ops		= &xfs_rmapbt_mem_buf_ops,
+	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
+	.keys_inorder		= xfs_rmapbt_keys_inorder,
+	.recs_inorder		= xfs_rmapbt_recs_inorder,
+	.keys_contiguous	= xfs_rmapbt_keys_contiguous,
+};
+
+/* Create a cursor for an in-memory btree. */
+struct xfs_btree_cur *
+xfs_rmapbt_mem_cursor(
+	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*head_bp,
+	struct xfbtree		*xfbtree)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	/* Overlapping btree; 2 keys per pointer. */
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP,
+			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
+	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING |
+			XFS_BTREE_IN_MEMORY;
+	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
+	cur->bc_ops = &xfs_rmapbt_mem_ops;
+	cur->bc_mem.xfbtree = xfbtree;
+	cur->bc_mem.head_bp = head_bp;
+	cur->bc_nlevels = xfs_btree_mem_head_nlevels(head_bp);
+
+	cur->bc_mem.pag = xfs_perag_bump(pag);
+	return cur;
+}
+
+/* Create an in-memory rmap btree. */
+int
+xfs_rmapbt_mem_create(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_buftarg	*target,
+	struct xfbtree		**xfbtreep)
+{
+	struct xfbtree_config	cfg = {
+		.btree_ops	= &xfs_rmapbt_mem_ops,
+		.target		= target,
+		.btnum		= XFS_BTNUM_RMAP,
+		.owner		= agno,
+	};
+
+	return xfbtree_create(mp, &cfg, xfbtreep);
+}
+#endif /* CONFIG_XFS_IN_MEMORY_BTREE */
+
 /*
  * Install a new reverse mapping btree root.  Caller is responsible for
  * invalidating and freeing the old btree blocks.
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 3244715dd111..a27a236111dd 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -64,4 +64,13 @@ unsigned int xfs_rmapbt_maxlevels_ondisk(void);
 int __init xfs_rmapbt_init_cur_cache(void);
 void xfs_rmapbt_destroy_cur_cache(void);
 
+#ifdef CONFIG_XFS_IN_MEMORY_BTREE
+struct xfbtree;
+struct xfs_btree_cur *xfs_rmapbt_mem_cursor(struct xfs_perag *pag,
+		struct xfs_trans *tp, struct xfs_buf *head_bp,
+		struct xfbtree *xfbtree);
+int xfs_rmapbt_mem_create(struct xfs_mount *mp, xfs_agnumber_t agno,
+		struct xfs_buftarg *target, struct xfbtree **xfbtreep);
+#endif /* CONFIG_XFS_IN_MEMORY_BTREE */
+
 #endif /* __XFS_RMAP_BTREE_H__ */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 7c242fddac8a..a685161db7bb 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -36,6 +36,7 @@
 #include "scrub/trace.h"
 #include "scrub/repair.h"
 #include "scrub/bitmap.h"
+#include "scrub/xfile.h"
 
 /*
  * Attempt to repair some metadata, if the metadata is corrupt and userspace
@@ -1130,3 +1131,25 @@ xrep_metadata_inode_forks(
 
 	return 0;
 }
+
+/*
+ * Set up an xfile and a buffer cache so that we can use the xfbtree.  Buffer
+ * target initialization registers a shrinker, so we cannot be in transaction
+ * context.  Park our resources in the scrub context and let the teardown
+ * function take care of them at the right time.
+ */
+int
+xrep_setup_buftarg(
+	struct xfs_scrub	*sc,
+	const char		*descr)
+{
+	int			error;
+
+	ASSERT(sc->tp == NULL);
+
+	error = xfile_create(sc->mp, descr, 0, &sc->xfile);
+	if (error)
+		return error;
+
+	return xfs_alloc_memory_buftarg(sc->mp, sc->xfile, &sc->xfile_buftarg);
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 22e8e1ed2de2..87e4827a6fb2 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -71,6 +71,8 @@ int xrep_ino_dqattach(struct xfs_scrub *sc);
 # define xrep_ino_dqattach(sc)			(0)
 #endif /* CONFIG_XFS_QUOTA */
 
+int xrep_setup_buftarg(struct xfs_scrub *sc, const char *descr);
+
 int xrep_ino_ensure_extent_count(struct xfs_scrub *sc, int whichfork,
 		xfs_extnum_t nextents);
 int xrep_reset_perag_resv(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 952dae473d4d..ae6015b171d9 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -12,6 +12,7 @@
 #include "xfs_defer.h"
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
+#include "xfs_btree_mem.h"
 #include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
@@ -41,6 +42,7 @@
 #include "scrub/iscan.h"
 #include "scrub/newbt.h"
 #include "scrub/reap.h"
+#include "scrub/xfbtree.h"
 
 /*
  * Reverse Mapping Btree Repair
@@ -125,37 +127,28 @@ int
 xrep_setup_ag_rmapbt(
 	struct xfs_scrub	*sc)
 {
-	/* For now this is a placeholder until we land other pieces. */
-	return 0;
+	return xrep_setup_buftarg(sc, "rmapbt repair");
 }
 
-/*
- * Packed rmap record.  The ATTR/BMBT/UNWRITTEN flags are hidden in the upper
- * bits of offset, just like the on-disk record.
- */
-struct xrep_rmap_extent {
-	xfs_agblock_t	startblock;
-	xfs_extlen_t	blockcount;
-	uint64_t	owner;
-	uint64_t	offset;
-} __packed;
-
 /* Context for collecting rmaps */
 struct xrep_rmap {
 	/* new rmapbt information */
 	struct xrep_newbt	new_btree;
 
 	/* rmap records generated from primary metadata */
-	struct xfarray		*rmap_records;
+	struct xfbtree		*rmap_btree;
 
 	struct xfs_scrub	*sc;
 
-	/* get_records()'s position in the rmap record array. */
-	xfarray_idx_t		array_cur;
+	/* in-memory btree cursor for the xfs_btree_bload iteration */
+	struct xfs_btree_cur	*mcur;
 
 	/* inode scan cursor */
 	struct xchk_iscan	iscan;
 
+	/* Number of non-freespace records found. */
+	unsigned long long	nr_records;
+
 	/* bnobt/cntbt contribution to btreeblks */
 	xfs_agblock_t		freesp_btblocks;
 
@@ -196,11 +189,6 @@ xrep_rmap_stash(
 	uint64_t		offset,
 	unsigned int		flags)
 {
-	struct xrep_rmap_extent	rre = {
-		.startblock	= startblock,
-		.blockcount	= blockcount,
-		.owner		= owner,
-	};
 	struct xfs_rmap_irec	rmap = {
 		.rm_startblock	= startblock,
 		.rm_blockcount	= blockcount,
@@ -209,6 +197,8 @@ xrep_rmap_stash(
 		.rm_flags	= flags,
 	};
 	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_btree_cur	*mcur;
+	struct xfs_buf		*mhead_bp;
 	int			error = 0;
 
 	if (xchk_should_terminate(sc, &error))
@@ -216,8 +206,22 @@ xrep_rmap_stash(
 
 	trace_xrep_rmap_found(sc->mp, sc->sa.pag->pag_agno, &rmap);
 
-	rre.offset = xfs_rmap_irec_offset_pack(&rmap);
-	return xfarray_append(rr->rmap_records, &rre);
+	error = xfbtree_head_read_buf(rr->rmap_btree, sc->tp, &mhead_bp);
+	if (error)
+		return error;
+
+	mcur = xfs_rmapbt_mem_cursor(sc->sa.pag, sc->tp, mhead_bp,
+			rr->rmap_btree);
+	error = xfs_rmap_map_raw(mcur, &rmap);
+	xfs_btree_del_cursor(mcur, error);
+	if (error)
+		goto out_cancel;
+
+	return xfbtree_trans_commit(rr->rmap_btree, sc->tp);
+
+out_cancel:
+	xfbtree_trans_cancel(rr->rmap_btree, sc->tp);
+	return error;
 }
 
 struct xrep_rmap_stash_run {
@@ -758,6 +762,24 @@ xrep_rmap_find_log_rmaps(
 			sc->mp->m_sb.sb_logblocks, XFS_RMAP_OWN_LOG, 0, 0);
 }
 
+/* Check and count all the records that we gathered. */
+STATIC int
+xrep_rmap_check_record(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_rmap		*rr = priv;
+	int				error;
+
+	error = xrep_rmap_check_mapping(rr->sc, rec);
+	if (error)
+		return error;
+
+	rr->nr_records++;
+	return 0;
+}
+
 /*
  * Generate all the reverse-mappings for this AG, a list of the old rmapbt
  * blocks, and the new btreeblks count.  Figure out if we have enough free
@@ -771,6 +793,8 @@ xrep_rmap_find_rmaps(
 	struct xfs_scrub	*sc = rr->sc;
 	struct xchk_ag		*sa = &sc->sa;
 	struct xfs_inode	*ip;
+	struct xfs_buf		*mhead_bp;
+	struct xfs_btree_cur	*mcur;
 	int			error;
 
 	/* Find all the per-AG metadata. */
@@ -837,7 +861,35 @@ xrep_rmap_find_rmaps(
 	error = xchk_setup_fs(sc);
 	if (error)
 		return error;
-	return xchk_perag_lock(sc);
+	error = xchk_perag_lock(sc);
+	if (error)
+		return error;
+
+	/*
+	 * Now that we have everything locked again, we need to count the
+	 * number of rmap records stashed in the btree.  This should reflect
+	 * all actively-owned space in the filesystem.  At the same time, check
+	 * all our records before we start building a new btree, which requires
+	 * a bnobt cursor.
+	 */
+	error = xfbtree_head_read_buf(rr->rmap_btree, NULL, &mhead_bp);
+	if (error)
+		return error;
+
+	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, mhead_bp,
+			rr->rmap_btree);
+	sc->sa.bno_cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.pag, XFS_BTNUM_BNO);
+
+	rr->nr_records = 0;
+	error = xfs_rmap_query_all(mcur, xrep_rmap_check_record, rr);
+
+	xfs_btree_del_cursor(sc->sa.bno_cur, error);
+	sc->sa.bno_cur = NULL;
+	xfs_btree_del_cursor(mcur, error);
+	xfs_buf_relse(mhead_bp);
+
+	return error;
 }
 
 /* Section (II): Reserving space for new rmapbt and setting free space bitmap */
@@ -870,7 +922,6 @@ STATIC int
 xrep_rmap_try_reserve(
 	struct xrep_rmap	*rr,
 	struct xfs_btree_cur	*rmap_cur,
-	uint64_t		nr_records,
 	struct xagb_bitmap	*freesp_blocks,
 	uint64_t		*blocks_reserved,
 	bool			*done)
@@ -954,7 +1005,7 @@ xrep_rmap_try_reserve(
 
 	/* Compute how many blocks we'll need for all the rmaps. */
 	error = xfs_btree_bload_compute_geometry(rmap_cur,
-			&rr->new_btree.bload, nr_records + freesp_records);
+			&rr->new_btree.bload, rr->nr_records + freesp_records);
 	if (error)
 		return error;
 
@@ -973,16 +1024,13 @@ xrep_rmap_reserve_space(
 	struct xfs_btree_cur	*rmap_cur)
 {
 	struct xagb_bitmap	freesp_blocks;	/* AGBIT */
-	uint64_t		nr_records;	/* NR */
 	uint64_t		blocks_reserved = 0;
 	bool			done = false;
 	int			error;
 
-	nr_records = xfarray_length(rr->rmap_records);
-
 	/* Compute how many blocks we'll need for the rmaps collected so far. */
 	error = xfs_btree_bload_compute_geometry(rmap_cur,
-			&rr->new_btree.bload, nr_records);
+			&rr->new_btree.bload, rr->nr_records);
 	if (error)
 		return error;
 
@@ -999,8 +1047,8 @@ xrep_rmap_reserve_space(
 	 * Finish when we don't need more blocks.
 	 */
 	do {
-		error = xrep_rmap_try_reserve(rr, rmap_cur, nr_records,
-				&freesp_blocks, &blocks_reserved, &done);
+		error = xrep_rmap_try_reserve(rr, rmap_cur, &freesp_blocks,
+				&blocks_reserved, &done);
 		if (error)
 			goto out_bitmap;
 	} while (!done);
@@ -1062,28 +1110,25 @@ xrep_rmap_get_records(
 	unsigned int		nr_wanted,
 	void			*priv)
 {
-	struct xrep_rmap_extent	rec;
-	struct xfs_rmap_irec	*irec = &cur->bc_rec.r;
 	struct xrep_rmap	*rr = priv;
 	union xfs_btree_rec	*block_rec;
 	unsigned int		loaded;
 	int			error;
 
 	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
-		error = xfarray_load_next(rr->rmap_records, &rr->array_cur,
-				&rec);
+		int		stat = 0;
+
+		error = xfs_btree_increment(rr->mcur, 0, &stat);
 		if (error)
 			return error;
-
-		irec->rm_startblock = rec.startblock;
-		irec->rm_blockcount = rec.blockcount;
-		irec->rm_owner = rec.owner;
-		if (xfs_rmap_irec_offset_unpack(rec.offset, irec) != NULL)
+		if (!stat)
 			return -EFSCORRUPTED;
 
-		error = xrep_rmap_check_mapping(rr->sc, irec);
+		error = xfs_rmap_get_rec(rr->mcur, &cur->bc_rec.r, &stat);
 		if (error)
 			return error;
+		if (!stat)
+			return -EFSCORRUPTED;
 
 		block_rec = xfs_btree_rec_addr(cur, idx, block);
 		cur->bc_ops->init_rec_from_cur(cur, block_rec);
@@ -1147,6 +1192,29 @@ xrep_rmap_alloc_vextent(
 	return xfs_alloc_vextent(args);
 }
 
+
+/* Count the records in this btree. */
+STATIC int
+xrep_rmap_count_records(
+	struct xfs_btree_cur	*cur,
+	unsigned long long	*nr)
+{
+	int			running = 1;
+	int			error;
+
+	*nr = 0;
+
+	error = xfs_btree_goto_left_edge(cur);
+	if (error)
+		return error;
+
+	while (running && !(error = xfs_btree_increment(cur, 0, &running))) {
+		if (running)
+			(*nr)++;
+	}
+
+	return error;
+}
 /*
  * Use the collected rmap information to stage a new rmap btree.  If this is
  * successful we'll return with the new btree root information logged to the
@@ -1161,6 +1229,7 @@ xrep_rmap_build_new_tree(
 	struct xfs_perag	*pag = sc->sa.pag;
 	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
 	struct xfs_btree_cur	*rmap_cur;
+	struct xfs_buf		*mhead_bp;
 	xfs_fsblock_t		fsbno;
 	int			error;
 
@@ -1195,6 +1264,21 @@ xrep_rmap_build_new_tree(
 	if (error)
 		goto err_cur;
 
+	/*
+	 * Count the rmapbt records again, because the space reservation
+	 * for the rmapbt itself probably added more records to the btree.
+	 */
+	error = xfbtree_head_read_buf(rr->rmap_btree, NULL, &mhead_bp);
+	if (error)
+		goto err_cur;
+
+	rr->mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, mhead_bp,
+			rr->rmap_btree);
+
+	error = xrep_rmap_count_records(rr->mcur, &rr->nr_records);
+	if (error)
+		goto err_mcur;
+
 	/*
 	 * Due to btree slack factors, it's possible for a new btree to be one
 	 * level taller than the old btree.  Update the incore btree height so
@@ -1204,13 +1288,16 @@ xrep_rmap_build_new_tree(
 	pag->pagf_alt_levels[XFS_BTNUM_RMAPi] =
 					rr->new_btree.bload.btree_height;
 
+	/*
+	 * Move the cursor to the left edge of the tree so that the first
+	 * increment in ->get_records positions us at the first record.
+	 */
+	error = xfs_btree_goto_left_edge(rr->mcur);
+	if (error)
+		goto err_level;
+
 	/* Add all observed rmap records. */
-	rr->array_cur = XFARRAY_CURSOR_INIT;
-	sc->sa.bno_cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
-			sc->sa.pag, XFS_BTNUM_BNO);
 	error = xfs_btree_bload(rmap_cur, &rr->new_btree.bload, rr);
-	xfs_btree_del_cursor(sc->sa.bno_cur, error);
-	sc->sa.bno_cur = NULL;
 	if (error)
 		goto err_level;
 
@@ -1220,6 +1307,15 @@ xrep_rmap_build_new_tree(
 	 */
 	xfs_rmapbt_commit_staged_btree(rmap_cur, sc->tp, sc->sa.agf_bp);
 	xfs_btree_del_cursor(rmap_cur, 0);
+	xfs_btree_del_cursor(rr->mcur, 0);
+	rr->mcur = NULL;
+	xfs_buf_relse(mhead_bp);
+
+	/*
+	 * Now that we've written the new btree to disk, we don't need to keep
+	 * updating the in-memory btree.  Abort the scan to stop live updates.
+	 */
+	xchk_iscan_abort(&rr->iscan);
 
 	/*
 	 * The newly committed rmap recordset includes mappings for the blocks
@@ -1243,6 +1339,9 @@ xrep_rmap_build_new_tree(
 
 err_level:
 	pag->pagf_alt_levels[XFS_BTNUM_RMAPi] = 0;
+err_mcur:
+	xfs_btree_del_cursor(rr->mcur, error);
+	xfs_buf_relse(mhead_bp);
 err_cur:
 	xfs_btree_del_cursor(rmap_cur, error);
 err_newbt:
@@ -1270,6 +1369,28 @@ xrep_rmap_find_freesp(
 			rec->ar_blockcount);
 }
 
+/* Record the free space we find, as part of cleaning out the btree. */
+STATIC int
+xrep_rmap_find_gaps(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_rmap_find_gaps	*rfg = priv;
+	int				error;
+
+	if (rec->rm_startblock > rfg->next_agbno) {
+		error = xagb_bitmap_set(&rfg->rmap_gaps, rfg->next_agbno,
+				rec->rm_startblock - rfg->next_agbno);
+		if (error)
+			return error;
+	}
+
+	rfg->next_agbno = max_t(xfs_agblock_t, rfg->next_agbno,
+				rec->rm_startblock + rec->rm_blockcount);
+	return 0;
+}
+
 /*
  * Reap the old rmapbt blocks.  Now that the rmapbt is fully rebuilt, we make
  * a list of gaps in the rmap records and a list of the extents mentioned in
@@ -1286,30 +1407,23 @@ xrep_rmap_remove_old_tree(
 	struct xfs_scrub	*sc = rr->sc;
 	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
 	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_btree_cur	*mcur;
+	struct xfs_buf		*mhead_bp;
 	xfs_agblock_t		agend;
-	xfarray_idx_t		array_cur;
 	int			error;
 
 	xagb_bitmap_init(&rfg.rmap_gaps);
 
 	/* Compute free space from the new rmapbt. */
-	foreach_xfarray_idx(rr->rmap_records, array_cur) {
-		struct xrep_rmap_extent	rec;
+	error = xfbtree_head_read_buf(rr->rmap_btree, NULL, &mhead_bp);
+	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, mhead_bp,
+			rr->rmap_btree);
 
-		error = xfarray_load(rr->rmap_records, array_cur, &rec);
-		if (error)
-			goto out_bitmap;
-
-		/* Record the free space we find. */
-		if (rec.startblock > rfg.next_agbno) {
-			error = xagb_bitmap_set(&rfg.rmap_gaps, rfg.next_agbno,
-					rec.startblock - rfg.next_agbno);
-			if (error)
-				goto out_bitmap;
-		}
-		rfg.next_agbno = max_t(xfs_agblock_t, rfg.next_agbno,
-					rec.startblock + rec.blockcount);
-	}
+	error = xfs_rmap_query_all(mcur, xrep_rmap_find_gaps, &rfg);
+	xfs_btree_del_cursor(mcur, error);
+	xfs_buf_relse(mhead_bp);
+	if (error)
+		goto out_bitmap;
 
 	/* Insert a record for space between the last rmap and EOAG. */
 	agend = be32_to_cpu(agf->agf_length);
@@ -1371,9 +1485,9 @@ xrep_rmapbt(
 		return -ENOMEM;
 	rr->sc = sc;
 
-	/* Set up some storage */
-	error = xfarray_create(sc->mp, "rmap records", 0,
-			sizeof(struct xrep_rmap_extent), &rr->rmap_records);
+	/* Set up in-memory rmap btree */
+	error = xfs_rmapbt_mem_create(sc->mp, sc->sa.pag->pag_agno,
+			sc->xfile_buftarg, &rr->rmap_btree);
 	if (error)
 		goto out_rr;
 
@@ -1398,7 +1512,7 @@ xrep_rmapbt(
 
 out_records:
 	xchk_iscan_finish(&rr->iscan);
-	xfarray_destroy(rr->rmap_records);
+	xfbtree_destroy(rr->rmap_btree);
 out_rr:
 	kfree(rr);
 	return error;

