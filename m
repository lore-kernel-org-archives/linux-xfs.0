Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433ACC4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349734AbhLCAEm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:04:42 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:35729 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349676AbhLCAEm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:42 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id E2BE9869D4E
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:16 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00G1L2-44
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00Bki8-3A
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 24/36] xfs: use xfs_alloc_vextent_this_ag() in _iterate_ags()
Date:   Fri,  3 Dec 2021 11:00:59 +1100
Message-Id: <20211203000111.2800982-25-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61a95e4d
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=x_O8MFN3wK5gYPUfcAwA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because the core of the per-ag iteration is calling "this ag"
allocation on one AG at a time. This brings the number of callers of
xfs_alloc_ag_vextent() down to 1.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 57 +++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 0e259786d522..9ff6772ee019 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3206,6 +3206,28 @@ xfs_alloc_vextent_set_fsbno(
 /*
  * Allocate within a single AG only.
  */
+static int
+__xfs_alloc_vextent_this_ag(
+	struct xfs_alloc_arg	*args)
+{
+	struct xfs_mount	*mp = args->mp;
+	int			error;
+
+	error = xfs_alloc_fix_freelist(args, 0);
+	if (error) {
+		trace_xfs_alloc_vextent_nofix(args);
+		return error;
+	}
+	if (!args->agbp) {
+		/* cannot allocate in this AG at all */
+		trace_xfs_alloc_vextent_noagbp(args);
+		args->agbno = NULLAGBLOCK;
+		return 0;
+	}
+	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+	return xfs_alloc_ag_vextent(args);
+}
+
 static int
 xfs_alloc_vextent_this_ag(
 	struct xfs_alloc_arg	*args)
@@ -3222,24 +3244,13 @@ xfs_alloc_vextent_this_ag(
 
 	args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 	args->pag = xfs_perag_get(mp, args->agno);
-	error = xfs_alloc_fix_freelist(args, 0);
-	if (error) {
-		trace_xfs_alloc_vextent_nofix(args);
-		goto out_error;
-	}
-	if (!args->agbp) {
-		trace_xfs_alloc_vextent_noagbp(args);
-		goto out_error;
-	}
-	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
-	error = xfs_alloc_ag_vextent(args);
+	error = __xfs_alloc_vextent_this_ag(args);
+	xfs_perag_put(args->pag);
 	if (error)
-		goto out_error;
+		return error;
 
 	xfs_alloc_vextent_set_fsbno(args);
-out_error:
-	xfs_perag_put(args->pag);
-	return error;
+	return 0;
 }
 
 /*
@@ -3277,24 +3288,12 @@ xfs_alloc_vextent_iterate_ags(
 	args->agno = start_agno;
 	for (;;) {
 		args->pag = xfs_perag_get(mp, args->agno);
-		error = xfs_alloc_fix_freelist(args, flags);
-		if (error) {
-			trace_xfs_alloc_vextent_nofix(args);
-			break;
-		}
-		/*
-		 * If we get a buffer back then the allocation will fly.
-		 */
-		if (args->agbp) {
-			error = xfs_alloc_ag_vextent(args);
+		error = __xfs_alloc_vextent_this_ag(args);
+		if (error || args->agbp)
 			break;
-		}
 
 		trace_xfs_alloc_vextent_loopfailed(args);
 
-		/*
-		 * Didn't work, figure out the next iteration.
-		 */
 		if (args->agno == start_agno &&
 		    args->otype == XFS_ALLOCTYPE_START_BNO)
 			args->type = XFS_ALLOCTYPE_THIS_AG;
-- 
2.33.0

