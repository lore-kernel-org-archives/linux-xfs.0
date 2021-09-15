Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025C0C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0D95610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhIOXKt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:10:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhIOXKt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:10:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C786600D4;
        Wed, 15 Sep 2021 23:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747369;
        bh=m2yP6y9ZbpFFCPtTr/Zs4xNi+OmvAzsdXy1rokVS3yI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rSiDDk6hDwDGOr505hshcZCichyFc0eS5/234dBaSz++zz9VE8tHDsOaZCVI8tPFj
         anTxFT1sPIAD3cJ2t2il82EhIvZf45rSydNPR7wP5muj2CTMbKV2cI8zM61kKyhKA/
         ih5kHOTyu/hiJhyrGHVrwhyPyk/T1ZPghJn/pG711NL3AzWmU/YuSAkD6IK1o8gf/q
         QdRG/9XDdhNRj8bVNma7Hbt+LnTBZj9EWfrIXBfTYaZ3Y850Fb64N3WqbAjmtaswFK
         oaBr/cJOpgHRZGjooIZ8OvrxdZsRLcKa4ya9Cw0eopBrqO6BxoNvExZIoRc9T2Fjzi
         Xj63D5TsikpMw==
Subject: [PATCH 32/61] xfs: convert rmap btree cursor to using a perag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:09:29 -0700
Message-ID: <163174736937.350433.4596074225370842445.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: fa9c3c197329fdab0efc48a8944d2c4a21c6a74f

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/fsmap.c              |    3 +--
 libxfs/xfs_ag.c         |    2 +-
 libxfs/xfs_alloc.c      |    7 ++++---
 libxfs/xfs_rmap.c       |   10 +++++-----
 libxfs/xfs_rmap.h       |    6 ++++--
 libxfs/xfs_rmap_btree.c |   37 ++++++++++++++++---------------------
 libxfs/xfs_rmap_btree.h |    4 ++--
 repair/agbtree.c        |    5 +++--
 repair/agbtree.h        |    2 +-
 repair/phase5.c         |   10 ++++++----
 repair/rmap.c           |    7 +++++--
 11 files changed, 48 insertions(+), 45 deletions(-)


diff --git a/db/fsmap.c b/db/fsmap.c
index 5973f0d6..65e9f1ba 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -74,8 +74,7 @@ fsmap(
 			return;
 		}
 
-		bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp,
-				pag->pag_agno, pag);
+		bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, pag);
 		if (!bt_cur) {
 			libxfs_buf_relse(agbp);
 			libxfs_perag_put(pag);
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 1027bc7b..1db6a65b 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -913,7 +913,7 @@ xfs_ag_extend_space(
 	 * XFS_RMAP_OINFO_SKIP_UPDATE is used here to tell the rmap btree that
 	 * this doesn't actually exist in the rmap btree.
 	 */
-	error = xfs_rmap_free(tp, bp, id->agno,
+	error = xfs_rmap_free(tp, bp, bp->b_pag,
 				be32_to_cpu(agf->agf_length) - len,
 				len, &XFS_RMAP_OINFO_SKIP_UPDATE);
 	if (error)
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index dfe0a9ce..199c7fae 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1088,7 +1088,7 @@ xfs_alloc_ag_vextent_small(
 	 * If we're feeding an AGFL block to something that doesn't live in the
 	 * free space, we need to clear out the OWN_AG rmap.
 	 */
-	error = xfs_rmap_free(args->tp, args->agbp, args->agno, fbno, 1,
+	error = xfs_rmap_free(args->tp, args->agbp, args->pag, fbno, 1,
 			      &XFS_RMAP_OINFO_AG);
 	if (error)
 		goto error;
@@ -1165,7 +1165,7 @@ xfs_alloc_ag_vextent(
 
 	/* if not file data, insert new block into the reverse map btree */
 	if (!xfs_rmap_should_skip_owner_update(&args->oinfo)) {
-		error = xfs_rmap_alloc(args->tp, args->agbp, args->agno,
+		error = xfs_rmap_alloc(args->tp, args->agbp, args->pag,
 				       args->agbno, args->len, &args->oinfo);
 		if (error)
 			return error;
@@ -1895,12 +1895,13 @@ xfs_free_ag_extent(
 	int				haveright; /* have a right neighbor */
 	int				i;
 	int				error;
+	struct xfs_perag		*pag = agbp->b_pag;
 
 	bno_cur = cnt_cur = NULL;
 	mp = tp->t_mountp;
 
 	if (!xfs_rmap_should_skip_owner_update(oinfo)) {
-		error = xfs_rmap_free(tp, agbp, agno, bno, len, oinfo);
+		error = xfs_rmap_free(tp, agbp, pag, bno, len, oinfo);
 		if (error)
 			goto error0;
 	}
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index e61de3b2..f0621ca5 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -695,7 +695,7 @@ int
 xfs_rmap_free(
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
-	xfs_agnumber_t			agno,
+	struct xfs_perag		*pag,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
 	const struct xfs_owner_info	*oinfo)
@@ -707,7 +707,7 @@ xfs_rmap_free(
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
-	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno, NULL);
+	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
 
 	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
 
@@ -949,7 +949,7 @@ int
 xfs_rmap_alloc(
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
-	xfs_agnumber_t			agno,
+	struct xfs_perag		*pag,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
 	const struct xfs_owner_info	*oinfo)
@@ -961,7 +961,7 @@ xfs_rmap_alloc(
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
-	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno, NULL);
+	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
 	error = xfs_rmap_map(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -2407,7 +2407,7 @@ xfs_rmap_finish_one(
 			goto out_drop;
 		}
 
-		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag->pag_agno, pag);
+		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
 	}
 	*pcur = rcur;
 
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index abe63340..f2423cf7 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_RMAP_H__
 #define __XFS_RMAP_H__
 
+struct xfs_perag;
+
 static inline void
 xfs_rmap_ino_bmbt_owner(
 	struct xfs_owner_info	*oi,
@@ -113,10 +115,10 @@ xfs_owner_info_pack(
 }
 
 int xfs_rmap_alloc(struct xfs_trans *tp, struct xfs_buf *agbp,
-		   xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
+		   struct xfs_perag *pag, xfs_agblock_t bno, xfs_extlen_t len,
 		   const struct xfs_owner_info *oinfo);
 int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
-		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
+		  struct xfs_perag *pag, xfs_agblock_t bno, xfs_extlen_t len,
 		  const struct xfs_owner_info *oinfo);
 
 int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t bno,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index bed2f381..7f71d355 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -50,7 +50,7 @@ xfs_rmapbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_rmapbt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_ag.agbp, cur->bc_ag.agno, cur->bc_ag.pag);
+				cur->bc_ag.agbp, cur->bc_ag.pag);
 }
 
 STATIC void
@@ -62,13 +62,12 @@ xfs_rmapbt_set_root(
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
 	int			btnum = cur->bc_btnum;
-	struct xfs_perag	*pag = agbp->b_pag;
 
 	ASSERT(ptr->s != 0);
 
 	agf->agf_roots[btnum] = ptr->s;
 	be32_add_cpu(&agf->agf_levels[btnum], inc);
-	pag->pagf_levels[btnum] += inc;
+	cur->bc_ag.pag->pagf_levels[btnum] += inc;
 
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 }
@@ -82,6 +81,7 @@ xfs_rmapbt_alloc_block(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
+	struct xfs_perag	*pag = cur->bc_ag.pag;
 	int			error;
 	xfs_agblock_t		bno;
 
@@ -91,20 +91,19 @@ xfs_rmapbt_alloc_block(
 	if (error)
 		return error;
 
-	trace_xfs_rmapbt_alloc_block(cur->bc_mp, cur->bc_ag.agno,
-			bno, 1);
+	trace_xfs_rmapbt_alloc_block(cur->bc_mp, pag->pag_agno, bno, 1);
 	if (bno == NULLAGBLOCK) {
 		*stat = 0;
 		return 0;
 	}
 
-	xfs_extent_busy_reuse(cur->bc_mp, agbp->b_pag, bno, 1, false);
+	xfs_extent_busy_reuse(cur->bc_mp, pag, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 	be32_add_cpu(&agf->agf_rmap_blocks, 1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
 
-	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, cur->bc_ag.agno);
+	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, pag->pag_agno);
 
 	*stat = 1;
 	return 0;
@@ -117,12 +116,12 @@ xfs_rmapbt_free_block(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	struct xfs_perag	*pag;
+	struct xfs_perag	*pag = cur->bc_ag.pag;
 	xfs_agblock_t		bno;
 	int			error;
 
 	bno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(bp));
-	trace_xfs_rmapbt_free_block(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_rmapbt_free_block(cur->bc_mp, pag->pag_agno,
 			bno, 1);
 	be32_add_cpu(&agf->agf_rmap_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
@@ -130,7 +129,6 @@ xfs_rmapbt_free_block(
 	if (error)
 		return error;
 
-	pag = cur->bc_ag.agbp->b_pag;
 	xfs_extent_busy_insert(cur->bc_tp, pag, bno, 1,
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 
@@ -212,7 +210,7 @@ xfs_rmapbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_roots[cur->bc_btnum];
 }
@@ -447,7 +445,6 @@ static struct xfs_btree_cur *
 xfs_rmapbt_init_common(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
 	struct xfs_perag	*pag)
 {
 	struct xfs_btree_cur	*cur;
@@ -460,13 +457,12 @@ xfs_rmapbt_init_common(
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
-	cur->bc_ag.agno = agno;
 	cur->bc_ops = &xfs_rmapbt_ops;
-	if (pag) {
-		/* take a reference for the cursor */
-		atomic_inc(&pag->pag_ref);
-	}
+
+	/* take a reference for the cursor */
+	atomic_inc(&pag->pag_ref);
 	cur->bc_ag.pag = pag;
+	cur->bc_ag.agno = pag->pag_agno;
 
 	return cur;
 }
@@ -477,13 +473,12 @@ xfs_rmapbt_init_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
-	xfs_agnumber_t		agno,
 	struct xfs_perag	*pag)
 {
 	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_rmapbt_init_common(mp, tp, agno, pag);
+	cur = xfs_rmapbt_init_common(mp, tp, pag);
 	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
 	cur->bc_ag.agbp = agbp;
 	return cur;
@@ -494,11 +489,11 @@ struct xfs_btree_cur *
 xfs_rmapbt_stage_cursor(
 	struct xfs_mount	*mp,
 	struct xbtree_afakeroot	*afake,
-	xfs_agnumber_t		agno)
+	struct xfs_perag	*pag)
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_rmapbt_init_common(mp, NULL, agno, NULL);
+	cur = xfs_rmapbt_init_common(mp, NULL, pag);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index b036470a..f2eee657 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -43,9 +43,9 @@ struct xbtree_afakeroot;
 
 struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
 				struct xfs_trans *tp, struct xfs_buf *bp,
-				xfs_agnumber_t agno, struct xfs_perag *pag);
+				struct xfs_perag *pag);
 struct xfs_btree_cur *xfs_rmapbt_stage_cursor(struct xfs_mount *mp,
-		struct xbtree_afakeroot *afake, xfs_agnumber_t agno);
+		struct xbtree_afakeroot *afake, struct xfs_perag *pag);
 void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 int xfs_rmapbt_maxrecs(int blocklen, int leaf);
diff --git a/repair/agbtree.c b/repair/agbtree.c
index cc066f2e..d1b35b69 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -574,17 +574,18 @@ get_rmapbt_record(
 void
 init_rmapbt_cursor(
 	struct repair_ctx	*sc,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	unsigned int		free_space,
 	struct bt_rebuild	*btr)
 {
+	xfs_agnumber_t		agno = pag->pag_agno;
 	int			error;
 
 	if (!xfs_sb_version_hasrmapbt(&sc->mp->m_sb))
 		return;
 
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr);
-	btr->cur = libxfs_rmapbt_stage_cursor(sc->mp, &btr->newbt.afake, agno);
+	btr->cur = libxfs_rmapbt_stage_cursor(sc->mp, &btr->newbt.afake, pag);
 
 	btr->bload.get_record = get_rmapbt_record;
 	btr->bload.claim_block = rebuild_claim_block;
diff --git a/repair/agbtree.h b/repair/agbtree.h
index d8095d20..88b07738 100644
--- a/repair/agbtree.h
+++ b/repair/agbtree.h
@@ -49,7 +49,7 @@ void init_ino_cursors(struct repair_ctx *sc, xfs_agnumber_t agno,
 void build_inode_btrees(struct repair_ctx *sc, xfs_agnumber_t agno,
 		struct bt_rebuild *btr_ino, struct bt_rebuild *btr_fino);
 
-void init_rmapbt_cursor(struct repair_ctx *sc, xfs_agnumber_t agno,
+void init_rmapbt_cursor(struct repair_ctx *sc, struct xfs_perag *pag,
 		unsigned int free_space, struct bt_rebuild *btr);
 void build_rmap_tree(struct repair_ctx *sc, xfs_agnumber_t agno,
 		struct bt_rebuild *btr);
diff --git a/repair/phase5.c b/repair/phase5.c
index fcdf757c..0cdcf710 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -433,7 +433,7 @@ keep_fsinos(xfs_mount_t *mp)
 static void
 phase5_func(
 	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	struct bitmap		*lost_blocks)
 {
 	struct repair_ctx	sc = { .mp = mp, };
@@ -443,6 +443,7 @@ phase5_func(
 	struct bt_rebuild	btr_fino;
 	struct bt_rebuild	btr_rmap;
 	struct bt_rebuild	btr_refc;
+	xfs_agnumber_t		agno = pag->pag_agno;
 	int			extra_blocks = 0;
 	uint			num_freeblocks;
 	xfs_agblock_t		num_extents;
@@ -476,7 +477,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	init_ino_cursors(&sc, agno, num_freeblocks, &sb_icount_ag[agno],
 			&sb_ifree_ag[agno], &btr_ino, &btr_fino);
 
-	init_rmapbt_cursor(&sc, agno, num_freeblocks, &btr_rmap);
+	init_rmapbt_cursor(&sc, pag, num_freeblocks, &btr_rmap);
 
 	init_refc_cursor(&sc, agno, num_freeblocks, &btr_refc);
 
@@ -605,6 +606,7 @@ void
 phase5(xfs_mount_t *mp)
 {
 	struct bitmap		*lost_blocks = NULL;
+	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 	int			error;
 
@@ -651,8 +653,8 @@ phase5(xfs_mount_t *mp)
 	if (error)
 		do_error(_("cannot alloc lost block bitmap\n"));
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
-		phase5_func(mp, agno, lost_blocks);
+	for_each_perag(mp, agno, pag)
+		phase5_func(mp, pag, lost_blocks);
 
 	print_final_rpt();
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 2ffa27c8..5670c6a0 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -545,6 +545,7 @@ rmap_store_ag_btree_rec(
 	rm_rec = pop_slab_cursor(rm_cur);
 	while (rm_rec) {
 		struct xfs_owner_info	oinfo = {};
+		struct xfs_perag	*pag;
 
 		error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
 		if (error)
@@ -556,8 +557,10 @@ rmap_store_ag_btree_rec(
 
 		ASSERT(XFS_RMAP_NON_INODE_OWNER(rm_rec->rm_owner));
 		oinfo.oi_owner = rm_rec->rm_owner;
-		error = -libxfs_rmap_alloc(tp, agbp, agno, rm_rec->rm_startblock,
+		pag = libxfs_perag_get(mp, agno);
+		error = -libxfs_rmap_alloc(tp, agbp, pag, rm_rec->rm_startblock,
 				rm_rec->rm_blockcount, &oinfo);
+		libxfs_perag_put(pag);
 		if (error)
 			goto err_trans;
 
@@ -1006,7 +1009,7 @@ rmaps_verify_btree(
 	pag = libxfs_perag_get(mp, agno);
 	pag->pagf_init = 0;
 
-	bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, agno, pag);
+	bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, pag);
 	if (!bt_cur) {
 		error = -ENOMEM;
 		goto err;

