Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5DDC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377666AbhLCAE7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:04:59 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:58448 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377751AbhLCAE5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:57 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 709126068B8
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:16 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00G1KM-Iv
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:14 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00Bkh0-Hy
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/36] xfs: pass perag to xfs_alloc_read_agfl
Date:   Fri,  3 Dec 2021 11:00:45 +1100
Message-Id: <20211203000111.2800982-11-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61a95e4c
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=SAILczb-qZbT2BScxn0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We have the perag in most places we call xfs_alloc_read_agfl, so
pass the perag instead of a mount/agno pair.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c      | 31 ++++++++++++++++---------------
 fs/xfs/libxfs/xfs_alloc.h      |  4 ++--
 fs/xfs/scrub/agheader_repair.c |  2 +-
 fs/xfs/scrub/common.c          |  2 +-
 4 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index da14c16df92a..b81d62a4ed5b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -685,20 +685,19 @@ const struct xfs_buf_ops xfs_agfl_buf_ops = {
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
@@ -2695,7 +2694,7 @@ xfs_alloc_fix_freelist(
 	targs.alignment = targs.minlen = targs.prod = 1;
 	targs.type = XFS_ALLOCTYPE_THIS_AG;
 	targs.pag = pag;
-	error = xfs_alloc_read_agfl(mp, tp, targs.agno, &agflbp);
+	error = xfs_alloc_read_agfl(pag, tp, &agflbp);
 	if (error)
 		goto out_agbp_relse;
 
@@ -2774,8 +2773,7 @@ xfs_alloc_get_freelist(
 	/*
 	 * Read the array of free blocks.
 	 */
-	error = xfs_alloc_read_agfl(mp, tp, be32_to_cpu(agf->agf_seqno),
-				    &agflbp);
+	error = xfs_alloc_read_agfl(pag, tp, &agflbp);
 	if (error)
 		return error;
 
@@ -2869,9 +2867,12 @@ xfs_alloc_put_freelist(
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
index e13b730c78f7..aa4c8f866cd1 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -173,8 +173,8 @@ int xfs_read_agf(struct xfs_perag *pag, struct xfs_trans *tp, int flags,
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
index 24cc8c0a9d80..66c33f9d8541 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -393,7 +393,7 @@ xrep_agf(
 	 * btrees rooted in the AGF.  If the AGFL contents are obviously bad
 	 * then we'll bail out.
 	 */
-	error = xfs_alloc_read_agfl(mp, sc->tp, sc->sa.pag->pag_agno, &agfl_bp);
+	error = xfs_alloc_read_agfl(sc->sa.pag, sc->tp, &agfl_bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 73f3d729d7f5..03e07c873964 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -422,7 +422,7 @@ xchk_ag_read_headers(
 	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGF))
 		return error;
 
-	error = xfs_alloc_read_agfl(mp, sc->tp, agno, &sa->agfl_bp);
+	error = xfs_alloc_read_agfl(sa->pag, sc->tp, &sa->agfl_bp);
 	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGFL))
 		return error;
 
-- 
2.33.0

