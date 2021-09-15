Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10779C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E359C610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhIOXLA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhIOXLA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:11:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E3B8600D4;
        Wed, 15 Sep 2021 23:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747380;
        bh=qSGStvqlZH9ft4ERTjn80ZfXSWXcvqejv+A9aIL2IG4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mmYWFWimKTC7ddec5to5vFwcHy+Zt9S77UaGLE3xY5GEuUxvyho4gWjZNeNL5zp2o
         Rx0cVYyIU4tfT2jJePuXdjBLrdhmgUA+EPh+OGOrDWg0hzVJ9UHmgn9uxDT90ggoqb
         JzX1a0ywQrnoFe9WV9Bv6z5hS1u5iHurwfQcyy+0JXZIwzdOpptn/lkzFQNkc9ovsA
         A4zokBQL7Wk+3GTSaGGKPMh9NCVh+/GGitLSqMqAffACmc/0KJdeLrW8xNAJSFpMhk
         uwAps6Ay5EpfY4SZNAPjYql03fokND2r0KPEWzIbat+4FLCcUvEH++A9hzLqsuKQxO
         JmDSV7ZbBfuBA==
Subject: [PATCH 34/61] xfs: convert allocbt cursors to use perags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:09:40 -0700
Message-ID: <163174738033.350433.2947743640716954348.stgit@magnolia>
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

Source kernel commit: 289d38d22cd88960cb648dc480c50de5102519bb

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc.c       |   25 ++++++++++---------------
 libxfs/xfs_alloc_btree.c |   26 ++++++++++----------------
 libxfs/xfs_alloc_btree.h |    8 ++++----
 repair/agbtree.c         |    7 ++++---
 repair/agbtree.h         |    2 +-
 repair/phase5.c          |    2 +-
 6 files changed, 30 insertions(+), 40 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 199c7fae..d41d11c7 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -772,8 +772,7 @@ xfs_alloc_cur_setup(
 	 */
 	if (!acur->cnt)
 		acur->cnt = xfs_allocbt_init_cursor(args->mp, args->tp,
-						args->agbp, args->agno,
-						args->pag, XFS_BTNUM_CNT);
+					args->agbp, args->pag, XFS_BTNUM_CNT);
 	error = xfs_alloc_lookup_ge(acur->cnt, 0, args->maxlen, &i);
 	if (error)
 		return error;
@@ -783,12 +782,10 @@ xfs_alloc_cur_setup(
 	 */
 	if (!acur->bnolt)
 		acur->bnolt = xfs_allocbt_init_cursor(args->mp, args->tp,
-						args->agbp, args->agno,
-						args->pag, XFS_BTNUM_BNO);
+					args->agbp, args->pag, XFS_BTNUM_BNO);
 	if (!acur->bnogt)
 		acur->bnogt = xfs_allocbt_init_cursor(args->mp, args->tp,
-						args->agbp, args->agno,
-						args->pag, XFS_BTNUM_BNO);
+					args->agbp, args->pag, XFS_BTNUM_BNO);
 	return i == 1 ? 0 : -ENOSPC;
 }
 
@@ -1216,7 +1213,7 @@ xfs_alloc_ag_vextent_exact(
 	 * Allocate/initialize a cursor for the by-number freespace btree.
 	 */
 	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-					  args->agno, args->pag, XFS_BTNUM_BNO);
+					  args->pag, XFS_BTNUM_BNO);
 
 	/*
 	 * Lookup bno and minlen in the btree (minlen is irrelevant, really).
@@ -1276,7 +1273,7 @@ xfs_alloc_ag_vextent_exact(
 	 * Allocate/initialize a cursor for the by-size btree.
 	 */
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-					args->agno, args->pag, XFS_BTNUM_CNT);
+					args->pag, XFS_BTNUM_CNT);
 	ASSERT(args->agbno + args->len <= be32_to_cpu(agf->agf_length));
 	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen, args->agbno,
 				      args->len, XFSA_FIXUP_BNO_OK);
@@ -1673,7 +1670,7 @@ xfs_alloc_ag_vextent_size(
 	 * Allocate and initialize a cursor for the by-size btree.
 	 */
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-					args->agno, args->pag, XFS_BTNUM_CNT);
+					args->pag, XFS_BTNUM_CNT);
 	bno_cur = NULL;
 	busy = false;
 
@@ -1836,7 +1833,7 @@ xfs_alloc_ag_vextent_size(
 	 * Allocate and initialize a cursor for the by-block tree.
 	 */
 	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-					args->agno, args->pag, XFS_BTNUM_BNO);
+					args->pag, XFS_BTNUM_BNO);
 	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen,
 			rbno, rlen, XFSA_FIXUP_CNT_OK)))
 		goto error0;
@@ -1909,8 +1906,7 @@ xfs_free_ag_extent(
 	/*
 	 * Allocate and initialize a cursor for the by-block btree.
 	 */
-	bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno,
-					NULL, XFS_BTNUM_BNO);
+	bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_BNO);
 	/*
 	 * Look for a neighboring block on the left (lower block numbers)
 	 * that is contiguous with this space.
@@ -1980,8 +1976,7 @@ xfs_free_ag_extent(
 	/*
 	 * Now allocate and initialize a cursor for the by-size tree.
 	 */
-	cnt_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno,
-					NULL, XFS_BTNUM_CNT);
+	cnt_cur = xfs_allocbt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_CNT);
 	/*
 	 * Have both left and right contiguous neighbors.
 	 * Merge all three into a single free block.
@@ -2492,7 +2487,7 @@ xfs_exact_minlen_extent_available(
 	int			error = 0;
 
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
-					args->agno, args->pag, XFS_BTNUM_CNT);
+					args->pag, XFS_BTNUM_CNT);
 	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
 	if (error)
 		goto out;
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index d2f2a82e..abc06574 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -24,8 +24,7 @@ xfs_allocbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_allocbt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_ag.agbp, cur->bc_ag.agno,
-			cur->bc_ag.pag, cur->bc_btnum);
+			cur->bc_ag.agbp, cur->bc_ag.pag, cur->bc_btnum);
 }
 
 STATIC void
@@ -37,13 +36,12 @@ xfs_allocbt_set_root(
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
@@ -222,7 +220,7 @@ xfs_allocbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_roots[cur->bc_btnum];
 }
@@ -470,7 +468,6 @@ STATIC struct xfs_btree_cur *
 xfs_allocbt_init_common(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
 	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)
 {
@@ -484,6 +481,7 @@ xfs_allocbt_init_common(
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+	cur->bc_ag.abt.active = false;
 
 	if (btnum == XFS_BTNUM_CNT) {
 		cur->bc_ops = &xfs_cntbt_ops;
@@ -494,13 +492,10 @@ xfs_allocbt_init_common(
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
 	}
 
-	cur->bc_ag.agno = agno;
-	cur->bc_ag.abt.active = false;
-	if (pag) {
-		/* take a reference for the cursor */
-		atomic_inc(&pag->pag_ref);
-	}
+	/* take a reference for the cursor */
+	atomic_inc(&pag->pag_ref);
 	cur->bc_ag.pag = pag;
+	cur->bc_ag.agno = pag->pag_agno;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
@@ -516,14 +511,13 @@ xfs_allocbt_init_cursor(
 	struct xfs_mount	*mp,		/* file system mount point */
 	struct xfs_trans	*tp,		/* transaction pointer */
 	struct xfs_buf		*agbp,		/* buffer for agf structure */
-	xfs_agnumber_t		agno,		/* allocation group number */
 	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)		/* btree identifier */
 {
 	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_allocbt_init_common(mp, tp, agno, pag, btnum);
+	cur = xfs_allocbt_init_common(mp, tp, pag, btnum);
 	if (btnum == XFS_BTNUM_CNT)
 		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
 	else
@@ -539,12 +533,12 @@ struct xfs_btree_cur *
 xfs_allocbt_stage_cursor(
 	struct xfs_mount	*mp,
 	struct xbtree_afakeroot	*afake,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_allocbt_init_common(mp, NULL, agno, NULL, btnum);
+	cur = xfs_allocbt_init_common(mp, NULL, pag, btnum);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }
diff --git a/libxfs/xfs_alloc_btree.h b/libxfs/xfs_alloc_btree.h
index a10cedba..9eb4c667 100644
--- a/libxfs/xfs_alloc_btree.h
+++ b/libxfs/xfs_alloc_btree.h
@@ -47,11 +47,11 @@ struct xbtree_afakeroot;
 		 (maxrecs) * sizeof(xfs_alloc_key_t) + \
 		 ((index) - 1) * sizeof(xfs_alloc_ptr_t)))
 
-extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
-		struct xfs_trans *, struct xfs_buf *,
-		xfs_agnumber_t, struct xfs_perag *pag, xfs_btnum_t);
+extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, struct xfs_buf *bp,
+		struct xfs_perag *pag, xfs_btnum_t btnum);
 struct xfs_btree_cur *xfs_allocbt_stage_cursor(struct xfs_mount *mp,
-		struct xbtree_afakeroot *afake, xfs_agnumber_t agno,
+		struct xbtree_afakeroot *afake, struct xfs_perag *pag,
 		xfs_btnum_t btnum);
 extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
 extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
diff --git a/repair/agbtree.c b/repair/agbtree.c
index b2dbbffd..6c1ae375 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -226,13 +226,14 @@ get_bnobt_record(
 void
 init_freespace_cursors(
 	struct repair_ctx	*sc,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	unsigned int		free_space,
 	unsigned int		*nr_extents,
 	int			*extra_blocks,
 	struct bt_rebuild	*btr_bno,
 	struct bt_rebuild	*btr_cnt)
 {
+	xfs_agnumber_t		agno = pag->pag_agno;
 	unsigned int		agfl_goal;
 	int			error;
 
@@ -242,9 +243,9 @@ init_freespace_cursors(
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_cnt);
 
 	btr_bno->cur = libxfs_allocbt_stage_cursor(sc->mp,
-			&btr_bno->newbt.afake, agno, XFS_BTNUM_BNO);
+			&btr_bno->newbt.afake, pag, XFS_BTNUM_BNO);
 	btr_cnt->cur = libxfs_allocbt_stage_cursor(sc->mp,
-			&btr_cnt->newbt.afake, agno, XFS_BTNUM_CNT);
+			&btr_cnt->newbt.afake, pag, XFS_BTNUM_CNT);
 
 	btr_bno->bload.get_record = get_bnobt_record;
 	btr_bno->bload.claim_block = rebuild_claim_block;
diff --git a/repair/agbtree.h b/repair/agbtree.h
index a44d5e84..593ac44c 100644
--- a/repair/agbtree.h
+++ b/repair/agbtree.h
@@ -35,7 +35,7 @@ struct bt_rebuild {
 
 void finish_rebuild(struct xfs_mount *mp, struct bt_rebuild *btr,
 		struct bitmap *lost_blocks);
-void init_freespace_cursors(struct repair_ctx *sc, xfs_agnumber_t agno,
+void init_freespace_cursors(struct repair_ctx *sc, struct xfs_perag *pag,
 		unsigned int free_space, unsigned int *nr_extents,
 		int *extra_blocks, struct bt_rebuild *btr_bno,
 		struct bt_rebuild *btr_cnt);
diff --git a/repair/phase5.c b/repair/phase5.c
index 04d45e3d..26094238 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -507,7 +507,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	/*
 	 * track blocks that we might really lose
 	 */
-	init_freespace_cursors(&sc, agno, num_freeblocks, &num_extents,
+	init_freespace_cursors(&sc, pag, num_freeblocks, &num_extents,
 			&extra_blocks, &btr_bno, &btr_cnt);
 
 	/*

