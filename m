Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54AF3C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 342E4610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbhIOXKy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhIOXKy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:10:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 263B0600D4;
        Wed, 15 Sep 2021 23:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747375;
        bh=2sR+XctROO288NlqkeDm2MzJjgIs2eyKJ76g4YZL7Gs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GUJ7XnKRn99wrW4kI80XgIhdUBn6aQ+0275H5g1LtR6J65cV1wGFKX6Qp5/rhMM/W
         cK9vUHi6H1P+3nOmZyXeeQvoLNQQ3REcJfrXBz/QbhQfxS1oTJlRZ1qZyDK2Q6gvA3
         YZbiU29P3TGpMD5tjPy9Meq1h4iQt0mSTHcxWeBp/xsPdFCI1GO++DiaVWIKCYYyor
         CBCmMaJVqNrySGfK3A1wJo6g0PMOMnBeK2g9z8n/fz8fbDo/RgGwr9e+ji4DK8lFTX
         k2ylLSJhwJTmthImNviRTcko1uqfnxw3jFAFS1wt+04BXTtQNXzCDXro+q1aBaNol/
         iGplai0+tAihw==
Subject: [PATCH 33/61] xfs: convert refcount btree cursor to use perags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:09:34 -0700
Message-ID: <163174737482.350433.2950895524621814736.stgit@magnolia>
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

Source kernel commit: a81a06211fb43d80ee746e7a40a32ed812002f8e

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_refcount.c       |   40 ++++++++++++++++++++++------------------
 libxfs/xfs_refcount.h       |    9 ++++++++-
 libxfs/xfs_refcount_btree.c |   22 +++++++++-------------
 libxfs/xfs_refcount_btree.h |    4 ++--
 repair/agbtree.c            |    5 +++--
 repair/agbtree.h            |    2 +-
 repair/phase5.c             |    2 +-
 repair/rmap.c               |    2 +-
 8 files changed, 47 insertions(+), 39 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 0516ae6d..13385394 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -21,6 +21,7 @@
 #include "xfs_bit.h"
 #include "xfs_refcount.h"
 #include "xfs_rmap.h"
+#include "xfs_ag.h"
 
 /* Allowable refcount adjustment amounts. */
 enum xfs_refc_adjust_op {
@@ -1141,30 +1142,30 @@ xfs_refcount_finish_one(
 	struct xfs_btree_cur		*rcur;
 	struct xfs_buf			*agbp = NULL;
 	int				error = 0;
-	xfs_agnumber_t			agno;
 	xfs_agblock_t			bno;
 	xfs_agblock_t			new_agbno;
 	unsigned long			nr_ops = 0;
 	int				shape_changes = 0;
+	struct xfs_perag		*pag;
 
-	agno = XFS_FSB_TO_AGNO(mp, startblock);
-	ASSERT(agno != NULLAGNUMBER);
+	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, startblock));
 	bno = XFS_FSB_TO_AGBNO(mp, startblock);
 
 	trace_xfs_refcount_deferred(mp, XFS_FSB_TO_AGNO(mp, startblock),
 			type, XFS_FSB_TO_AGBNO(mp, startblock),
 			blockcount);
 
-	if (XFS_TEST_ERROR(false, mp,
-			XFS_ERRTAG_REFCOUNT_FINISH_ONE))
-		return -EIO;
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE)) {
+		error = -EIO;
+		goto out_drop;
+	}
 
 	/*
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
 	rcur = *pcur;
-	if (rcur != NULL && rcur->bc_ag.agno != agno) {
+	if (rcur != NULL && rcur->bc_ag.pag != pag) {
 		nr_ops = rcur->bc_ag.refc.nr_ops;
 		shape_changes = rcur->bc_ag.refc.shape_changes;
 		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
@@ -1172,12 +1173,12 @@ xfs_refcount_finish_one(
 		*pcur = NULL;
 	}
 	if (rcur == NULL) {
-		error = xfs_alloc_read_agf(tp->t_mountp, tp, agno,
+		error = xfs_alloc_read_agf(tp->t_mountp, tp, pag->pag_agno,
 				XFS_ALLOC_FLAG_FREEING, &agbp);
 		if (error)
-			return error;
+			goto out_drop;
 
-		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
+		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
 		rcur->bc_ag.refc.nr_ops = nr_ops;
 		rcur->bc_ag.refc.shape_changes = shape_changes;
 	}
@@ -1187,12 +1188,12 @@ xfs_refcount_finish_one(
 	case XFS_REFCOUNT_INCREASE:
 		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
 			new_len, XFS_REFCOUNT_ADJUST_INCREASE, NULL);
-		*new_fsb = XFS_AGB_TO_FSB(mp, agno, new_agbno);
+		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
 		break;
 	case XFS_REFCOUNT_DECREASE:
 		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
 			new_len, XFS_REFCOUNT_ADJUST_DECREASE, NULL);
-		*new_fsb = XFS_AGB_TO_FSB(mp, agno, new_agbno);
+		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
 		break;
 	case XFS_REFCOUNT_ALLOC_COW:
 		*new_fsb = startblock + blockcount;
@@ -1209,8 +1210,10 @@ xfs_refcount_finish_one(
 		error = -EFSCORRUPTED;
 	}
 	if (!error && *new_len > 0)
-		trace_xfs_refcount_finish_one_leftover(mp, agno, type,
+		trace_xfs_refcount_finish_one_leftover(mp, pag->pag_agno, type,
 				bno, blockcount, new_agbno, *new_len);
+out_drop:
+	xfs_perag_put(pag);
 	return error;
 }
 
@@ -1671,7 +1674,7 @@ xfs_refcount_recover_extent(
 int
 xfs_refcount_recover_cow_leftovers(
 	struct xfs_mount		*mp,
-	xfs_agnumber_t			agno)
+	struct xfs_perag		*pag)
 {
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*cur;
@@ -1703,10 +1706,10 @@ xfs_refcount_recover_cow_leftovers(
 	if (error)
 		return error;
 
-	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, &agbp);
 	if (error)
 		goto out_trans;
-	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
+	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
 
 	/* Find all the leftover CoW staging extents. */
 	memset(&low, 0, sizeof(low));
@@ -1728,11 +1731,12 @@ xfs_refcount_recover_cow_leftovers(
 		if (error)
 			goto out_free;
 
-		trace_xfs_refcount_recover_extent(mp, agno, &rr->rr_rrec);
+		trace_xfs_refcount_recover_extent(mp, pag->pag_agno,
+				&rr->rr_rrec);
 
 		/* Free the orphan record */
 		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
-		fsb = XFS_AGB_TO_FSB(mp, agno, agbno);
+		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, agbno);
 		xfs_refcount_free_cow_extent(tp, fsb,
 				rr->rr_rrec.rc_blockcount);
 
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 20979553..9f6e9aae 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -6,6 +6,13 @@
 #ifndef __XFS_REFCOUNT_H__
 #define __XFS_REFCOUNT_H__
 
+struct xfs_trans;
+struct xfs_mount;
+struct xfs_perag;
+struct xfs_btree_cur;
+struct xfs_bmbt_irec;
+struct xfs_refcount_irec;
+
 extern int xfs_refcount_lookup_le(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, int *stat);
 extern int xfs_refcount_lookup_ge(struct xfs_btree_cur *cur,
@@ -50,7 +57,7 @@ void xfs_refcount_alloc_cow_extent(struct xfs_trans *tp, xfs_fsblock_t fsb,
 void xfs_refcount_free_cow_extent(struct xfs_trans *tp, xfs_fsblock_t fsb,
 		xfs_extlen_t len);
 extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
-		xfs_agnumber_t agno);
+		struct xfs_perag *pag);
 
 /*
  * While we're adjusting the refcounts records of an extent, we have
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 0851d357..1794b36d 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -25,7 +25,7 @@ xfs_refcountbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_refcountbt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_ag.agbp, cur->bc_ag.agno, cur->bc_ag.pag);
+			cur->bc_ag.agbp, cur->bc_ag.pag);
 }
 
 STATIC void
@@ -315,13 +315,11 @@ static struct xfs_btree_cur *
 xfs_refcountbt_init_common(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
 	struct xfs_perag	*pag)
 {
 	struct xfs_btree_cur	*cur;
 
-	ASSERT(agno != NULLAGNUMBER);
-	ASSERT(agno < mp->m_sb.sb_agcount);
+	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
 
 	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
 	cur->bc_tp = tp;
@@ -330,13 +328,12 @@ xfs_refcountbt_init_common(
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
-	cur->bc_ag.agno = agno;
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-	if (pag) {
-		/* take a reference for the cursor */
-		atomic_inc(&pag->pag_ref);
-	}
+
+	/* take a reference for the cursor */
+	atomic_inc(&pag->pag_ref);
 	cur->bc_ag.pag = pag;
+	cur->bc_ag.agno = pag->pag_agno;
 
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
@@ -350,13 +347,12 @@ xfs_refcountbt_init_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
-	xfs_agnumber_t		agno,
 	struct xfs_perag	*pag)
 {
 	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_refcountbt_init_common(mp, tp, agno, pag);
+	cur = xfs_refcountbt_init_common(mp, tp, pag);
 	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
 	cur->bc_ag.agbp = agbp;
 	return cur;
@@ -367,11 +363,11 @@ struct xfs_btree_cur *
 xfs_refcountbt_stage_cursor(
 	struct xfs_mount	*mp,
 	struct xbtree_afakeroot	*afake,
-	xfs_agnumber_t		agno)
+	struct xfs_perag	*pag)
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_refcountbt_init_common(mp, NULL, agno, NULL);
+	cur = xfs_refcountbt_init_common(mp, NULL, pag);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }
diff --git a/libxfs/xfs_refcount_btree.h b/libxfs/xfs_refcount_btree.h
index 8b82a39f..bd9ed9e1 100644
--- a/libxfs/xfs_refcount_btree.h
+++ b/libxfs/xfs_refcount_btree.h
@@ -47,9 +47,9 @@ struct xbtree_afakeroot;
 
 extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfs_buf *agbp,
-		xfs_agnumber_t agno, struct xfs_perag *pag);
+		struct xfs_perag *pag);
 struct xfs_btree_cur *xfs_refcountbt_stage_cursor(struct xfs_mount *mp,
-		struct xbtree_afakeroot *afake, xfs_agnumber_t agno);
+		struct xbtree_afakeroot *afake, struct xfs_perag *pag);
 extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
 extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
 
diff --git a/repair/agbtree.c b/repair/agbtree.c
index d1b35b69..b2dbbffd 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -645,10 +645,11 @@ get_refcountbt_record(
 void
 init_refc_cursor(
 	struct repair_ctx	*sc,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	unsigned int		free_space,
 	struct bt_rebuild	*btr)
 {
+	xfs_agnumber_t		agno = pag->pag_agno;
 	int			error;
 
 	if (!xfs_sb_version_hasreflink(&sc->mp->m_sb))
@@ -656,7 +657,7 @@ init_refc_cursor(
 
 	init_rebuild(sc, &XFS_RMAP_OINFO_REFC, free_space, btr);
 	btr->cur = libxfs_refcountbt_stage_cursor(sc->mp, &btr->newbt.afake,
-			agno);
+			pag);
 
 	btr->bload.get_record = get_refcountbt_record;
 	btr->bload.claim_block = rebuild_claim_block;
diff --git a/repair/agbtree.h b/repair/agbtree.h
index 88b07738..a44d5e84 100644
--- a/repair/agbtree.h
+++ b/repair/agbtree.h
@@ -54,7 +54,7 @@ void init_rmapbt_cursor(struct repair_ctx *sc, struct xfs_perag *pag,
 void build_rmap_tree(struct repair_ctx *sc, xfs_agnumber_t agno,
 		struct bt_rebuild *btr);
 
-void init_refc_cursor(struct repair_ctx *sc, xfs_agnumber_t agno,
+void init_refc_cursor(struct repair_ctx *sc, struct xfs_perag *pag,
 		unsigned int free_space, struct bt_rebuild *btr);
 void build_refcount_tree(struct repair_ctx *sc, xfs_agnumber_t agno,
 		struct bt_rebuild *btr);
diff --git a/repair/phase5.c b/repair/phase5.c
index 0cdcf710..04d45e3d 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -479,7 +479,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 
 	init_rmapbt_cursor(&sc, pag, num_freeblocks, &btr_rmap);
 
-	init_refc_cursor(&sc, agno, num_freeblocks, &btr_refc);
+	init_refc_cursor(&sc, pag, num_freeblocks, &btr_refc);
 
 	num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
 	/*
diff --git a/repair/rmap.c b/repair/rmap.c
index 5670c6a0..12fe7442 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1371,7 +1371,7 @@ check_refcounts(
 	pag = libxfs_perag_get(mp, agno);
 	pag->pagf_init = 0;
 
-	bt_cur = libxfs_refcountbt_init_cursor(mp, NULL, agbp, agno, pag);
+	bt_cur = libxfs_refcountbt_init_cursor(mp, NULL, agbp, pag);
 	if (!bt_cur) {
 		error = -ENOMEM;
 		goto err;

