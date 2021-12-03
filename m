Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B62B2C43219
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349853AbhLCAFA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:05:00 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:58518 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377752AbhLCAE5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:57 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id D509F606CCF
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:23 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00G1KF-Fe
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:14 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00Bkgl-E2
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/36] xfs: pass perag to xfs_read_agf
Date:   Fri,  3 Dec 2021 11:00:42 +1100
Message-Id: <20211203000111.2800982-8-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61a95e53
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=kP1XSlkOuOZPmVMylvYA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We have the perag in most places we call xfs_read_agf, so pass the
perag instead of a mount/agno pair.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 26 ++++++++++++--------------
 fs/xfs/libxfs/xfs_alloc.h |  4 ++--
 fs/xfs/xfs_log_recover.c  |  2 +-
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a8f032e49fcd..d1a76b7f33b7 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3033,27 +3033,25 @@ const struct xfs_buf_ops xfs_agf_buf_ops = {
 /*
  * Read in the allocation group header (free/alloc section).
  */
-int					/* error */
+int
 xfs_read_agf(
-	struct xfs_mount	*mp,	/* mount point structure */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_agnumber_t		agno,	/* allocation group number */
-	int			flags,	/* XFS_BUF_ */
-	struct xfs_buf		**bpp)	/* buffer for the ag freelist header */
+	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
+	int			flags,
+	struct xfs_buf		**agfbpp)
 {
-	int		error;
+	struct xfs_mount	*mp = pag->pag_mount;
+	int			error;
 
-	trace_xfs_read_agf(mp, agno);
+	trace_xfs_read_agf(pag->pag_mount, pag->pag_agno);
 
-	ASSERT(agno != NULLAGNUMBER);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
+			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGF_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1), flags, agfbpp, &xfs_agf_buf_ops);
 	if (error)
 		return error;
 
-	ASSERT(!(*bpp)->b_error);
-	xfs_buf_set_ref(*bpp, XFS_AGF_REF);
+	xfs_buf_set_ref(*agfbpp, XFS_AGF_REF);
 	return 0;
 }
 
@@ -3079,7 +3077,7 @@ xfs_alloc_read_agf(
 	/* We don't support trylock when freeing. */
 	ASSERT((flags & (XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK)) !=
 			(XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK));
-	error = xfs_read_agf(pag->pag_mount, tp, pag->pag_agno,
+	error = xfs_read_agf(pag, tp,
 			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
 			&agfbp);
 	if (error)
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index bdf7c1a75057..5efd52b3dd59 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -186,8 +186,8 @@ xfs_alloc_get_rec(
 	xfs_extlen_t		*len,	/* output: length of extent */
 	int			*stat);	/* output: success/failure */
 
-int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
-			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
+int xfs_read_agf(struct xfs_perag *pag, struct xfs_trans *tp, int flags,
+		struct xfs_buf **agfbpp);
 int xfs_alloc_read_agf(struct xfs_perag *pag, struct xfs_trans *tp, int flags,
 		struct xfs_buf **agfbpp);
 int xfs_alloc_read_agfl(struct xfs_mount *mp, struct xfs_trans *tp,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 08ea47ad3d9d..74f399ceddd9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3534,7 +3534,7 @@ xlog_recover_check_summary(
 	itotal = 0LL;
 	ifree = 0LL;
 	for_each_perag(mp, agno, pag) {
-		error = xfs_read_agf(mp, NULL, pag->pag_agno, 0, &agfbp);
+		error = xfs_read_agf(pag, NULL, 0, &agfbp);
 		if (error) {
 			xfs_alert(mp, "%s agf read failed agno %d error %d",
 						__func__, pag->pag_agno, error);
-- 
2.33.0

