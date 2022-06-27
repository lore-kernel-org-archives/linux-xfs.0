Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79527CCA47F
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 00:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiF0ASn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 20:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiF0ASm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 20:18:42 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A24C12BD3
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 17:18:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7DBAE5ECD2E
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 10:18:36 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSZ-00BTVS-79
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 10:18:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSZ-000uBI-5T
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 10:18:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/14] xfs: pass perag to xfs_alloc_put_freelist
Date:   Mon, 27 Jun 2022 10:18:27 +1000
Message-Id: <20220627001832.215779-10-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627001832.215779-1-david@fromorbit.com>
References: <20220627001832.215779-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62b8f75c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=jutQHCjETx02lnyGB_AA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It's available in all callers, so pass it in so that the perag can
be passed further down the stack.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c       |  5 ++---
 fs/xfs/libxfs/xfs_alloc.h       | 14 +++-----------
 fs/xfs/libxfs/xfs_alloc_btree.c |  3 ++-
 fs/xfs/libxfs/xfs_rmap_btree.c  |  2 +-
 fs/xfs/scrub/repair.c           |  4 ++--
 5 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index c0a2c73ec1cf..9ab0bd07d1d8 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2742,7 +2742,7 @@ xfs_alloc_fix_freelist(
 		 * Put each allocated block on the list.
 		 */
 		for (bno = targs.agbno; bno < targs.agbno + targs.len; bno++) {
-			error = xfs_alloc_put_freelist(tp, agbp,
+			error = xfs_alloc_put_freelist(pag, tp, agbp,
 							agflbp, bno, 0);
 			if (error)
 				goto out_agflbp_relse;
@@ -2872,6 +2872,7 @@ xfs_alloc_log_agf(
  */
 int
 xfs_alloc_put_freelist(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
 	struct xfs_buf		*agflbp,
@@ -2880,7 +2881,6 @@ xfs_alloc_put_freelist(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	struct xfs_perag	*pag;
 	__be32			*blockp;
 	int			error;
 	uint32_t		logflags;
@@ -2894,7 +2894,6 @@ xfs_alloc_put_freelist(
 	if (be32_to_cpu(agf->agf_fllast) == xfs_agfl_size(mp))
 		agf->agf_fllast = 0;
 
-	pag = agbp->b_pag;
 	ASSERT(!pag->pagf_agflreset);
 	be32_add_cpu(&agf->agf_flcount, 1);
 	pag->pagf_flcount++;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 6349f0e5f93d..d32a70a28c32 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -97,6 +97,9 @@ unsigned int xfs_alloc_min_freelist(struct xfs_mount *mp,
 		struct xfs_perag *pag);
 int xfs_alloc_get_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
 		struct xfs_buf *agfbp, xfs_agblock_t *bnop, int	 btreeblk);
+int xfs_alloc_put_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
+		struct xfs_buf *agfbp, struct xfs_buf *agflbp,
+		xfs_agblock_t bno, int btreeblk);
 
 /*
  * Compute and fill in value of m_alloc_maxlevels.
@@ -114,17 +117,6 @@ xfs_alloc_log_agf(
 	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
 	uint32_t	fields);/* mask of fields to be logged (XFS_AGF_...) */
 
-/*
- * Put the block on the freelist for the allocation group.
- */
-int				/* error */
-xfs_alloc_put_freelist(
-	struct xfs_trans *tp,	/* transaction pointer */
-	struct xfs_buf	*agbp,	/* buffer for a.g. freelist header */
-	struct xfs_buf	*agflbp,/* buffer for a.g. free block array */
-	xfs_agblock_t	bno,	/* block being freed */
-	int		btreeblk); /* owner was a AGF btree */
-
 /*
  * Allocate an extent (variable-size).
  */
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index a2ead80afb39..549a3cba0234 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -89,7 +89,8 @@ xfs_allocbt_free_block(
 	int			error;
 
 	bno = xfs_daddr_to_agbno(cur->bc_mp, xfs_buf_daddr(bp));
-	error = xfs_alloc_put_freelist(cur->bc_tp, agbp, NULL, bno, 1);
+	error = xfs_alloc_put_freelist(cur->bc_ag.pag, cur->bc_tp, agbp, NULL,
+			bno, 1);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index fbbbeda1b06d..1ae14d0c831c 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -129,7 +129,7 @@ xfs_rmapbt_free_block(
 			bno, 1);
 	be32_add_cpu(&agf->agf_rmap_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
-	error = xfs_alloc_put_freelist(cur->bc_tp, agbp, NULL, bno, 1);
+	error = xfs_alloc_put_freelist(pag, cur->bc_tp, agbp, NULL, bno, 1);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index cd6c92b070f8..c983b76e070f 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -516,8 +516,8 @@ xrep_put_freelist(
 		return error;
 
 	/* Put the block on the AGFL. */
-	error = xfs_alloc_put_freelist(sc->tp, sc->sa.agf_bp, sc->sa.agfl_bp,
-			agbno, 0);
+	error = xfs_alloc_put_freelist(sc->sa.pag, sc->tp, sc->sa.agf_bp,
+			sc->sa.agfl_bp, agbno, 0);
 	if (error)
 		return error;
 	xfs_extent_busy_insert(sc->tp, sc->sa.pag, agbno, 1,
-- 
2.36.1

