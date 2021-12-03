Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B0BC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377754AbhLCAFE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:05:04 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:60302 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349987AbhLCAFE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:05:04 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id DA6786064A7
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:23 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00G1KH-Gx
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:14 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00Bkgq-Fk
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/36] xfs: pass perag to xfs_alloc_get_freelist
Date:   Fri,  3 Dec 2021 11:00:43 +1100
Message-Id: <20211203000111.2800982-9-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61a95e54
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=Hm9j3Q2J-9EBiYWz0l0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It's available in all callers, so pass it in so that the perag can
be passed further down the stack.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c       |  8 ++++----
 fs/xfs/libxfs/xfs_alloc.h       | 13 ++-----------
 fs/xfs/libxfs/xfs_alloc_btree.c |  6 +++---
 fs/xfs/libxfs/xfs_rmap_btree.c  |  2 +-
 fs/xfs/scrub/repair.c           |  6 +++---
 5 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d1a76b7f33b7..081fdce5621a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1057,7 +1057,8 @@ xfs_alloc_ag_vextent_small(
 	    be32_to_cpu(agf->agf_flcount) <= args->minleft)
 		goto out;
 
-	error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
+	error = xfs_alloc_get_freelist(args->pag, args->tp, args->agbp,
+			&fbno, 0);
 	if (error)
 		goto error;
 	if (fbno == NULLAGBLOCK)
@@ -2679,7 +2680,7 @@ xfs_alloc_fix_freelist(
 	else
 		targs.oinfo = XFS_RMAP_OINFO_AG;
 	while (!(flags & XFS_ALLOC_FLAG_NOSHRINK) && pag->pagf_flcount > need) {
-		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
+		error = xfs_alloc_get_freelist(pag, tp, agbp, &bno, 0);
 		if (error)
 			goto out_agbp_relse;
 
@@ -2749,6 +2750,7 @@ xfs_alloc_fix_freelist(
  */
 int
 xfs_alloc_get_freelist(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
 	xfs_agblock_t		*bnop,
@@ -2761,7 +2763,6 @@ xfs_alloc_get_freelist(
 	int			error;
 	int			logflags;
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_perag	*pag;
 
 	/*
 	 * Freelist is empty, give up.
@@ -2789,7 +2790,6 @@ xfs_alloc_get_freelist(
 	if (be32_to_cpu(agf->agf_flfirst) == xfs_agfl_size(mp))
 		agf->agf_flfirst = 0;
 
-	pag = agbp->b_pag;
 	ASSERT(!pag->pagf_agflreset);
 	be32_add_cpu(&agf->agf_flcount, -1);
 	pag->pagf_flcount--;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 5efd52b3dd59..2b3fb141b68c 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -96,6 +96,8 @@ xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_perag *pag,
 		xfs_extlen_t need, xfs_extlen_t reserved);
 unsigned int xfs_alloc_min_freelist(struct xfs_mount *mp,
 		struct xfs_perag *pag);
+int xfs_alloc_get_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
+		struct xfs_buf *agfbp, xfs_agblock_t *bnop, int	 btreeblk);
 
 /*
  * Compute and fill in value of m_alloc_maxlevels.
@@ -104,17 +106,6 @@ void
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
index 06b41321f425..382449567090 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -299,13 +299,13 @@ xrep_alloc_ag_block(
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
2.33.0

