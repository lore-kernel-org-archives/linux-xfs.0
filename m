Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A9A3CCA47B
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347609AbiFKB1T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348741AbiFKB1P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:15 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76A183A481D
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B948F10E720B
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-005APD-On
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-00ELMV-Nd
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 24/50] xfs: use xfs_alloc_vextent_this_ag() in _iterate_ags()
Date:   Sat, 11 Jun 2022 11:26:33 +1000
Message-Id: <20220611012659.3418072-25-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a3ef68
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=x_O8MFN3wK5gYPUfcAwA:9
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
index 2978b4afe2e4..9c40d93c63d4 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3224,6 +3224,28 @@ xfs_alloc_vextent_set_fsbno(
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
@@ -3240,24 +3262,13 @@ xfs_alloc_vextent_this_ag(
 
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
@@ -3295,24 +3306,12 @@ xfs_alloc_vextent_iterate_ags(
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
2.35.1

