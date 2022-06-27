Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB2CCCA47C
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 00:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiF0ASl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 20:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiF0ASk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 20:18:40 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB4992BF1
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 17:18:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7CC5510E77AB
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 10:18:36 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSZ-00BTVQ-5o
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 10:18:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSZ-000uBC-44
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 10:18:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/14] xfs: pass perag to xfs_alloc_get_freelist
Date:   Mon, 27 Jun 2022 10:18:26 +1000
Message-Id: <20220627001832.215779-9-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627001832.215779-1-david@fromorbit.com>
References: <20220627001832.215779-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62b8f75c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=Hm9j3Q2J-9EBiYWz0l0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It's available in all callers, so pass it in so that the perag can
be passed further down the stack.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c       |  8 ++++----
 fs/xfs/libxfs/xfs_alloc.h       | 13 ++-----------
 fs/xfs/libxfs/xfs_alloc_btree.c |  6 +++---
 fs/xfs/libxfs/xfs_rmap_btree.c  |  2 +-
 fs/xfs/scrub/repair.c           |  6 +++---
 5 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 478dd81e4590..c0a2c73ec1cf 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1075,7 +1075,8 @@ xfs_alloc_ag_vextent_small(
 	    be32_to_cpu(agf->agf_flcount) <= args->minleft)
 		goto out;
 
-	error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
+	error = xfs_alloc_get_freelist(args->pag, args->tp, args->agbp,
+			&fbno, 0);
 	if (error)
 		goto error;
 	if (fbno == NULLAGBLOCK)
@@ -2697,7 +2698,7 @@ xfs_alloc_fix_freelist(
 	else
 		targs.oinfo = XFS_RMAP_OINFO_AG;
 	while (!(flags & XFS_ALLOC_FLAG_NOSHRINK) && pag->pagf_flcount > need) {
-		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
+		error = xfs_alloc_get_freelist(pag, tp, agbp, &bno, 0);
 		if (error)
 			goto out_agbp_relse;
 
@@ -2767,6 +2768,7 @@ xfs_alloc_fix_freelist(
  */
 int
 xfs_alloc_get_freelist(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
 	xfs_agblock_t		*bnop,
@@ -2779,7 +2781,6 @@ xfs_alloc_get_freelist(
 	int			error;
 	uint32_t		logflags;
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_perag	*pag;
 
 	/*
 	 * Freelist is empty, give up.
@@ -2807,7 +2808,6 @@ xfs_alloc_get_freelist(
 	if (be32_to_cpu(agf->agf_flfirst) == xfs_agfl_size(mp))
 		agf->agf_flfirst = 0;
 
-	pag = agbp->b_pag;
 	ASSERT(!pag->pagf_agflreset);
 	be32_add_cpu(&agf->agf_flcount, -1);
 	pag->pagf_flcount--;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 06e69fe9c957..6349f0e5f93d 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -95,6 +95,8 @@ xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_perag *pag,
 		xfs_extlen_t need, xfs_extlen_t reserved);
 unsigned int xfs_alloc_min_freelist(struct xfs_mount *mp,
 		struct xfs_perag *pag);
+int xfs_alloc_get_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
+		struct xfs_buf *agfbp, xfs_agblock_t *bnop, int	 btreeblk);
 
 /*
  * Compute and fill in value of m_alloc_maxlevels.
@@ -103,17 +105,6 @@ void
 xfs_alloc_compute_maxlevels(
 	struct xfs_mount	*mp);	/* file system mount structure */
 
-/*
- * Get a block from the freelist.
- * Returns with the buffer for the block gotten.
- */
-int				/* error */
-xfs_alloc_get_freelist(
-	struct xfs_trans *tp,	/* transaction pointer */
-	struct xfs_buf	*agbp,	/* buffer containing the agf structure */
-	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
-	int		btreeblk); /* destination is a AGF btree */
-
 /*
  * Log the given fields from the agf structure.
  */
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 8c9f73cc0bee..a2ead80afb39 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -60,8 +60,8 @@ xfs_allocbt_alloc_block(
 	xfs_agblock_t		bno;
 
 	/* Allocate the new block from the freelist. If we can't, give up.  */
-	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_ag.agbp,
-				       &bno, 1);
+	error = xfs_alloc_get_freelist(cur->bc_ag.pag, cur->bc_tp,
+			cur->bc_ag.agbp, &bno, 1);
 	if (error)
 		return error;
 
@@ -71,7 +71,7 @@ xfs_allocbt_alloc_block(
 	}
 
 	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
-	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agbp->b_pag, bno, 1, false);
+	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.pag, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index d6d45992fe7b..fbbbeda1b06d 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -90,7 +90,7 @@ xfs_rmapbt_alloc_block(
 	xfs_agblock_t		bno;
 
 	/* Allocate the new block from the freelist. If we can't, give up.  */
-	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_ag.agbp,
+	error = xfs_alloc_get_freelist(pag, cur->bc_tp, cur->bc_ag.agbp,
 				       &bno, 1);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 1c66f7ee6282..cd6c92b070f8 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -300,13 +300,13 @@ xrep_alloc_ag_block(
 	switch (resv) {
 	case XFS_AG_RESV_AGFL:
 	case XFS_AG_RESV_RMAPBT:
-		error = xfs_alloc_get_freelist(sc->tp, sc->sa.agf_bp, &bno, 1);
+		error = xfs_alloc_get_freelist(sc->sa.pag, sc->tp,
+				sc->sa.agf_bp, &bno, 1);
 		if (error)
 			return error;
 		if (bno == NULLAGBLOCK)
 			return -ENOSPC;
-		xfs_extent_busy_reuse(sc->mp, sc->sa.pag, bno,
-				1, false);
+		xfs_extent_busy_reuse(sc->mp, sc->sa.pag, bno, 1, false);
 		*fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno, bno);
 		if (resv == XFS_AG_RESV_RMAPBT)
 			xfs_ag_resv_rmapbt_alloc(sc->mp, sc->sa.pag->pag_agno);
-- 
2.36.1

