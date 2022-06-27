Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44374CCA485
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 00:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiF0ASp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 20:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiF0ASn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 20:18:43 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8FB92BF2
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 17:18:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BA92C10E75E0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 10:18:36 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSZ-00BTVU-8D
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 10:18:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSZ-000uBN-6o
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 10:18:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/14] xfs: pass perag to xfs_alloc_read_agfl
Date:   Mon, 27 Jun 2022 10:18:28 +1000
Message-Id: <20220627001832.215779-11-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627001832.215779-1-david@fromorbit.com>
References: <20220627001832.215779-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62b8f75d
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=mXlnn1I1KsIwerf7m04A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We have the perag in most places we call xfs_alloc_read_agfl, so
pass the perag instead of a mount/agno pair.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c      | 31 ++++++++++++++++---------------
 fs/xfs/libxfs/xfs_alloc.h      |  4 ++--
 fs/xfs/scrub/agheader_repair.c |  2 +-
 fs/xfs/scrub/common.c          |  2 +-
 4 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 9ab0bd07d1d8..ea9452950647 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -703,20 +703,19 @@ const struct xfs_buf_ops xfs_agfl_buf_ops = {
 /*
  * Read in the allocation group free block array.
  */
-int					/* error */
+int
 xfs_alloc_read_agfl(
-	xfs_mount_t	*mp,		/* mount point structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	struct xfs_buf	**bpp)		/* buffer for the ag free block array */
+	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
+	struct xfs_buf		**bpp)
 {
-	struct xfs_buf	*bp;		/* return value */
-	int		error;
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_buf		*bp;
+	int			error;
 
-	ASSERT(agno != NULLAGNUMBER);
 	error = xfs_trans_read_buf(
 			mp, tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
+			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGFL_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
 	if (error)
 		return error;
@@ -2713,7 +2712,7 @@ xfs_alloc_fix_freelist(
 	targs.alignment = targs.minlen = targs.prod = 1;
 	targs.type = XFS_ALLOCTYPE_THIS_AG;
 	targs.pag = pag;
-	error = xfs_alloc_read_agfl(mp, tp, targs.agno, &agflbp);
+	error = xfs_alloc_read_agfl(pag, tp, &agflbp);
 	if (error)
 		goto out_agbp_relse;
 
@@ -2792,8 +2791,7 @@ xfs_alloc_get_freelist(
 	/*
 	 * Read the array of free blocks.
 	 */
-	error = xfs_alloc_read_agfl(mp, tp, be32_to_cpu(agf->agf_seqno),
-				    &agflbp);
+	error = xfs_alloc_read_agfl(pag, tp, &agflbp);
 	if (error)
 		return error;
 
@@ -2887,9 +2885,12 @@ xfs_alloc_put_freelist(
 	__be32			*agfl_bno;
 	int			startoff;
 
-	if (!agflbp && (error = xfs_alloc_read_agfl(mp, tp,
-			be32_to_cpu(agf->agf_seqno), &agflbp)))
-		return error;
+	if (!agflbp) {
+		error = xfs_alloc_read_agfl(pag, tp, &agflbp);
+		if (error)
+			return error;
+	}
+
 	be32_add_cpu(&agf->agf_fllast, 1);
 	if (be32_to_cpu(agf->agf_fllast) == xfs_agfl_size(mp))
 		agf->agf_fllast = 0;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index d32a70a28c32..2c3f762dfb58 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -172,8 +172,8 @@ int xfs_read_agf(struct xfs_perag *pag, struct xfs_trans *tp, int flags,
 		struct xfs_buf **agfbpp);
 int xfs_alloc_read_agf(struct xfs_perag *pag, struct xfs_trans *tp, int flags,
 		struct xfs_buf **agfbpp);
-int xfs_alloc_read_agfl(struct xfs_mount *mp, struct xfs_trans *tp,
-			xfs_agnumber_t agno, struct xfs_buf **bpp);
+int xfs_alloc_read_agfl(struct xfs_perag *pag, struct xfs_trans *tp,
+		struct xfs_buf **bpp);
 int xfs_free_agfl_block(struct xfs_trans *, xfs_agnumber_t, xfs_agblock_t,
 			struct xfs_buf *, struct xfs_owner_info *);
 int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 230bdfe36e80..10ac1118a595 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -405,7 +405,7 @@ xrep_agf(
 	 * btrees rooted in the AGF.  If the AGFL contents are obviously bad
 	 * then we'll bail out.
 	 */
-	error = xfs_alloc_read_agfl(mp, sc->tp, sc->sa.pag->pag_agno, &agfl_bp);
+	error = xfs_alloc_read_agfl(sc->sa.pag, sc->tp, &agfl_bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index cd7d4ebd240b..9bbbf20f401b 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -424,7 +424,7 @@ xchk_ag_read_headers(
 	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGF))
 		return error;
 
-	error = xfs_alloc_read_agfl(mp, sc->tp, agno, &sa->agfl_bp);
+	error = xfs_alloc_read_agfl(sa->pag, sc->tp, &sa->agfl_bp);
 	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGFL))
 		return error;
 
-- 
2.36.1

