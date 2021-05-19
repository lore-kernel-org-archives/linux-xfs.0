Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3484C43461
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 01:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4BF0613AA
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 01:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbhESBW3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 May 2021 21:22:29 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:60339 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232201AbhESBW1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 May 2021 21:22:27 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 2B0A310654D
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 11:21:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljAtT-002bOQ-M5
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:21:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljAtT-001tKK-EE
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:21:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/23] xfs: convert rmap btree cursor to using a perag
Date:   Wed, 19 May 2021 11:20:51 +1000
Message-Id: <20210519012102.450926-13-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519012102.450926-1-david@fromorbit.com>
References: <20210519012102.450926-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=ClUxWLAoj8rven8FJdkA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c         |  2 +-
 fs/xfs/libxfs/xfs_alloc.c      |  7 ++++---
 fs/xfs/libxfs/xfs_rmap.c       | 10 ++++-----
 fs/xfs/libxfs/xfs_rmap.h       |  6 ++++--
 fs/xfs/libxfs/xfs_rmap_btree.c | 37 +++++++++++++++-------------------
 fs/xfs/libxfs/xfs_rmap_btree.h |  4 ++--
 fs/xfs/scrub/agheader_repair.c |  6 ++----
 fs/xfs/scrub/bmap.c            |  2 +-
 fs/xfs/scrub/common.c          |  2 +-
 fs/xfs/scrub/repair.c          | 10 ++++-----
 fs/xfs/xfs_fsmap.c             |  2 +-
 11 files changed, 42 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 97fb160e01de..0e0819f6fb89 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -916,7 +916,7 @@ xfs_ag_extend_space(
 	 * XFS_RMAP_OINFO_SKIP_UPDATE is used here to tell the rmap btree that
 	 * this doesn't actually exist in the rmap btree.
 	 */
-	error = xfs_rmap_free(tp, bp, id->agno,
+	error = xfs_rmap_free(tp, bp, bp->b_pag,
 				be32_to_cpu(agf->agf_length) - len,
 				len, &XFS_RMAP_OINFO_SKIP_UPDATE);
 	if (error)
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7ec4af6bf494..10747cc4d8f6 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1092,7 +1092,7 @@ xfs_alloc_ag_vextent_small(
 	 * If we're feeding an AGFL block to something that doesn't live in the
 	 * free space, we need to clear out the OWN_AG rmap.
 	 */
-	error = xfs_rmap_free(args->tp, args->agbp, args->agno, fbno, 1,
+	error = xfs_rmap_free(args->tp, args->agbp, args->pag, fbno, 1,
 			      &XFS_RMAP_OINFO_AG);
 	if (error)
 		goto error;
@@ -1169,7 +1169,7 @@ xfs_alloc_ag_vextent(
 
 	/* if not file data, insert new block into the reverse map btree */
 	if (!xfs_rmap_should_skip_owner_update(&args->oinfo)) {
-		error = xfs_rmap_alloc(args->tp, args->agbp, args->agno,
+		error = xfs_rmap_alloc(args->tp, args->agbp, args->pag,
 				       args->agbno, args->len, &args->oinfo);
 		if (error)
 			return error;
@@ -1899,12 +1899,13 @@ xfs_free_ag_extent(
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
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 0d7a6997120c..b23f949ee15c 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -696,7 +696,7 @@ int
 xfs_rmap_free(
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
-	xfs_agnumber_t			agno,
+	struct xfs_perag		*pag,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
 	const struct xfs_owner_info	*oinfo)
@@ -708,7 +708,7 @@ xfs_rmap_free(
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
-	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno, NULL);
+	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
 
 	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
 
@@ -950,7 +950,7 @@ int
 xfs_rmap_alloc(
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
-	xfs_agnumber_t			agno,
+	struct xfs_perag		*pag,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
 	const struct xfs_owner_info	*oinfo)
@@ -962,7 +962,7 @@ xfs_rmap_alloc(
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
-	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno, NULL);
+	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
 	error = xfs_rmap_map(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -2408,7 +2408,7 @@ xfs_rmap_finish_one(
 			goto out_drop;
 		}
 
-		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag->pag_agno, pag);
+		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
 	}
 	*pcur = rcur;
 
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index abe633403fd1..f2423cf7f1e2 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
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
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 7bef8feeded1..cafe181bc92d 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -52,7 +52,7 @@ xfs_rmapbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_rmapbt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_ag.agbp, cur->bc_ag.agno, cur->bc_ag.pag);
+				cur->bc_ag.agbp, cur->bc_ag.pag);
 }
 
 STATIC void
@@ -64,13 +64,12 @@ xfs_rmapbt_set_root(
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
@@ -84,6 +83,7 @@ xfs_rmapbt_alloc_block(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
+	struct xfs_perag	*pag = cur->bc_ag.pag;
 	int			error;
 	xfs_agblock_t		bno;
 
@@ -93,20 +93,19 @@ xfs_rmapbt_alloc_block(
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
@@ -119,12 +118,12 @@ xfs_rmapbt_free_block(
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
@@ -132,7 +131,6 @@ xfs_rmapbt_free_block(
 	if (error)
 		return error;
 
-	pag = cur->bc_ag.agbp->b_pag;
 	xfs_extent_busy_insert(cur->bc_tp, pag, bno, 1,
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 
@@ -214,7 +212,7 @@ xfs_rmapbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_roots[cur->bc_btnum];
 }
@@ -449,7 +447,6 @@ static struct xfs_btree_cur *
 xfs_rmapbt_init_common(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
 	struct xfs_perag	*pag)
 {
 	struct xfs_btree_cur	*cur;
@@ -462,13 +459,12 @@ xfs_rmapbt_init_common(
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
@@ -479,13 +475,12 @@ xfs_rmapbt_init_cursor(
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
@@ -496,11 +491,11 @@ struct xfs_btree_cur *
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
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index c94f418cc06b..88d8d18788a2 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
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
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 5dd91bf04c18..981c689e3d95 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -269,8 +269,7 @@ xrep_agf_calc_from_btrees(
 	btreeblks += blocks - 1;
 
 	/* Update the AGF counters from the rmapbt. */
-	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
-			sc->sa.pag);
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
 	error = xfs_btree_count_blocks(cur, &blocks);
 	if (error)
 		goto err;
@@ -491,8 +490,7 @@ xrep_agfl_collect_blocks(
 	xbitmap_init(&ra.agmetablocks);
 
 	/* Find all space used by the free space btrees & rmapbt. */
-	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
-			sc->sa.pag);
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
 	error = xfs_rmap_query_all(cur, xrep_agfl_walk_rmap, &ra);
 	if (error)
 		goto err;
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 28fd4b961bb4..dbe7b65f8da1 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -556,7 +556,7 @@ xchk_bmap_check_ag_rmaps(
 	if (error)
 		return error;
 
-	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf, agno, NULL);
+	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf, sc->sa.pag);
 
 	sbcri.sc = sc;
 	sbcri.whichfork = whichfork;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 50768559fb60..48381c1adeed 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -493,7 +493,7 @@ xchk_ag_btcur_init(
 	if (sa->agf_bp && xfs_sb_version_hasrmapbt(&mp->m_sb) &&
 	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_RMAP)) {
 		sa->rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, sa->agf_bp,
-				agno, sa->pag);
+				sa->pag);
 	}
 
 	/* Set up a refcountbt cursor for cross-referencing. */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 862dc56fd8cd..5cf1c3707b6a 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -509,7 +509,7 @@ xrep_put_freelist(
 	 * create an rmap for the block prior to merging it or else other
 	 * parts will break.
 	 */
-	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno, agbno, 1,
+	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno, 1,
 			&XFS_RMAP_OINFO_AG);
 	if (error)
 		return error;
@@ -555,7 +555,7 @@ xrep_reap_block(
 	} else {
 		agf_bp = sc->sa.agf_bp;
 	}
-	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, agno, sc->sa.pag);
+	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, sc->sa.pag);
 
 	/* Can we find any other rmappings? */
 	error = xfs_rmap_has_other_keys(cur, agbno, 1, oinfo, &has_other_rmap);
@@ -577,7 +577,8 @@ xrep_reap_block(
 	 * to run xfs_repair.
 	 */
 	if (has_other_rmap)
-		error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1, oinfo);
+		error = xfs_rmap_free(sc->tp, agf_bp, sc->sa.pag, agbno,
+					1, oinfo);
 	else if (resv == XFS_AG_RESV_AGFL)
 		error = xrep_put_freelist(sc, agbno);
 	else
@@ -892,8 +893,7 @@ xrep_find_ag_btree_roots(
 		fab->height = 0;
 	}
 
-	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
-			sc->sa.pag);
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
 	error = xfs_rmap_query_all(cur, xrep_findroot_rmap, &ri);
 	xfs_btree_del_cursor(cur, error);
 
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index b654a2bf9a9f..7bfe9ea35de0 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -708,7 +708,7 @@ xfs_getfsmap_datadev_rmapbt_query(
 
 	/* Allocate cursor for this AG and query_range it. */
 	*curpp = xfs_rmapbt_init_cursor(tp->t_mountp, tp, info->agf_bp,
-			info->pag->pag_agno, info->pag);
+			info->pag);
 	return xfs_rmap_query_range(*curpp, &info->low, &info->high,
 			xfs_getfsmap_datadev_helper, info);
 }
-- 
2.31.1

