Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AFAEC4167B
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349676AbhLCAEo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:04:44 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:35759 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243809AbhLCAEn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:43 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 5F0C1869C1B
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:17 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00G1LR-D4
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00Bkim-Bs
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 32/36] xfs: introduce xfs_alloc_vextent_prepare()
Date:   Fri,  3 Dec 2021 11:01:07 +1100
Message-Id: <20211203000111.2800982-33-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61a95e4d
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=wHXgHO0elxk0tAdDANkA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that we have wrapper functions for each type of allocation we
can ask for, we can start unravelling xfs_alloc_ag_vextent(). That
is essentially just a prepare stage, the allocation multiplexer
and a post-allocation accounting step is the allocation proceeded.

The current xfs_alloc_vextent*() wrappers all have a prepare stage,
the allocation operation and a post-allocation accounting step.

We can consolidate this by moving the AG alloc prep code into the
wrapper functions, the accounting code in the wrapper accounting
functions, and cut out the multiplexer layer entirely.

This patch consolidates the AG preparation stage.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 122 +++++++++++++++++++++++++++-----------
 1 file changed, 86 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 1fb72fff5d26..d2595dada0e2 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1130,31 +1130,8 @@ static int
 xfs_alloc_ag_vextent(
 	struct xfs_alloc_arg	*args)
 {
-	struct xfs_mount	*mp = args->mp;
 	int			error = 0;
 
-	ASSERT(args->minlen > 0);
-	ASSERT(args->maxlen > 0);
-	ASSERT(args->minlen <= args->maxlen);
-	ASSERT(args->mod < args->prod);
-	ASSERT(args->alignment > 0);
-	ASSERT(args->resv != XFS_AG_RESV_AGFL);
-
-
-	error = xfs_alloc_fix_freelist(args, 0);
-	if (error) {
-		trace_xfs_alloc_vextent_nofix(args);
-		return error;
-	}
-	if (!args->agbp) {
-		/* cannot allocate in this AG at all */
-		trace_xfs_alloc_vextent_noagbp(args);
-		args->agbno = NULLAGBLOCK;
-		return 0;
-	}
-	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
-	args->wasfromfl = 0;
-
 	/*
 	 * Branch to correct routine based on the type.
 	 */
@@ -3186,11 +3163,18 @@ xfs_alloc_vextent_check_args(
 		args->maxlen = agsize;
 	if (args->alignment == 0)
 		args->alignment = 1;
+
+	ASSERT(args->minlen > 0);
+	ASSERT(args->maxlen > 0);
+	ASSERT(args->alignment > 0);
+	ASSERT(args->resv != XFS_AG_RESV_AGFL);
+
 	ASSERT(XFS_FSB_TO_AGNO(mp, target) < mp->m_sb.sb_agcount);
 	ASSERT(XFS_FSB_TO_AGBNO(mp, target) < agsize);
 	ASSERT(args->minlen <= args->maxlen);
 	ASSERT(args->minlen <= agsize);
 	ASSERT(args->mod < args->prod);
+
 	if (XFS_FSB_TO_AGNO(mp, target) >= mp->m_sb.sb_agcount ||
 	    XFS_FSB_TO_AGBNO(mp, target) >= agsize ||
 	    args->minlen > args->maxlen || args->minlen > agsize ||
@@ -3202,6 +3186,40 @@ xfs_alloc_vextent_check_args(
 	return 0;
 }
 
+/*
+ * Prepare an AG for allocation. If the AG is not prepared to accept the
+ * allocation, return failure.
+ *
+ * XXX(dgc): The complexity of "need_pag" will go away as all caller paths are
+ * modified to hold their own perag references.
+ */
+static int
+xfs_alloc_vextent_prepare_ag(
+	struct xfs_alloc_arg	*args)
+{
+	bool			need_pag = !args->pag;
+	int			error;
+
+	if (need_pag)
+		args->pag = xfs_perag_get(args->mp, args->agno);
+
+	error = xfs_alloc_fix_freelist(args, 0);
+	if (error) {
+		trace_xfs_alloc_vextent_nofix(args);
+		if (need_pag)
+			xfs_perag_put(args->pag);
+		return error;
+	}
+	if (!args->agbp) {
+		/* cannot allocate in this AG at all */
+		trace_xfs_alloc_vextent_noagbp(args);
+		args->agbno = NULLAGBLOCK;
+		return 0;
+	}
+	args->wasfromfl = 0;
+	return 0;
+}
+
 /*
  * Post-process allocation results to set the allocated block number correctly
  * for the caller.
@@ -3231,7 +3249,8 @@ xfs_alloc_vextent_set_fsbno(
 }
 
 /*
- * Allocate within a single AG only.
+ * Allocate within a single AG only. Caller is expected to hold a
+ * perag reference in args->pag.
  */
 int
 xfs_alloc_vextent_this_ag(
@@ -3253,10 +3272,16 @@ xfs_alloc_vextent_this_ag(
 	args->agbno = 0;
 	args->fsbno = target;
 	args->type = XFS_ALLOCTYPE_THIS_AG;
-	error = xfs_alloc_ag_vextent(args);
+	error = xfs_alloc_vextent_prepare_ag(args);
 	if (error)
 		return error;
 
+	if (args->agbp) {
+		error = xfs_alloc_ag_vextent(args);
+		if (error)
+			return error;
+	}
+
 	xfs_alloc_vextent_set_fsbno(args);
 	return 0;
 }
@@ -3294,16 +3319,27 @@ xfs_alloc_vextent_iterate_ags(
 	 */
 	args->agno = start_agno;
 	for (;;) {
-		args->pag = xfs_perag_get(mp, args->agno);
-		error = xfs_alloc_ag_vextent(args);
-		if (error || args->agbp)
+		args->pag = xfs_perag_get(args->mp, args->agno);
+		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+		error = xfs_alloc_vextent_prepare_ag(args);
+		if (error)
 			break;
 
+		if (args->agbp) {
+			/*
+			 * Allocation is supposed to succeed now, so break out
+			 * of the loop regardless of whether we succeed or not.
+			 */
+			error = xfs_alloc_ag_vextent(args);
+			break;
+		}
+
 		trace_xfs_alloc_vextent_loopfailed(args);
 
 		if (args->agno == start_agno &&
 		    args->otype == XFS_ALLOCTYPE_NEAR_BNO)
 			args->type = XFS_ALLOCTYPE_THIS_AG;
+
 		/*
 		* For the first allocation, we can try any AG to get
 		* space.  However, if we already have allocated a
@@ -3329,14 +3365,14 @@ xfs_alloc_vextent_iterate_ags(
 			}
 
 			flags = 0;
-			if (args->otype == XFS_ALLOCTYPE_NEAR_BNO) {
-				args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+			if (args->otype == XFS_ALLOCTYPE_NEAR_BNO)
 				args->type = XFS_ALLOCTYPE_NEAR_BNO;
-			}
 		}
 		xfs_perag_put(args->pag);
+		args->pag = NULL;
 	}
 	xfs_perag_put(args->pag);
+	args->pag = NULL;
 	return error;
 }
 
@@ -3429,7 +3465,8 @@ xfs_alloc_vextent_first_ag(
 }
 
 /*
- * Allocate within a single AG only.
+ * Allocate at the exact block target or fail. Caller is expected to hold a
+ * perag reference in args->pag.
  */
 int
 xfs_alloc_vextent_exact_bno(
@@ -3450,10 +3487,17 @@ xfs_alloc_vextent_exact_bno(
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
 	args->fsbno = target;
 	args->type = XFS_ALLOCTYPE_THIS_BNO;
-	error = xfs_alloc_ag_vextent(args);
+
+	error = xfs_alloc_vextent_prepare_ag(args);
 	if (error)
 		return error;
 
+	if (args->agbp) {
+		error = xfs_alloc_ag_vextent(args);
+		if (error)
+			return error;
+	}
+
 	xfs_alloc_vextent_set_fsbno(args);
 	return 0;
 }
@@ -3461,6 +3505,8 @@ xfs_alloc_vextent_exact_bno(
 /*
  * Allocate an extent as close to the target as possible. If there are not
  * viable candidates in the AG, then fail the allocation.
+ *
+ * Caller may or may not have a per-ag reference in args->pag.
  */
 int
 xfs_alloc_vextent_near_bno(
@@ -3481,9 +3527,13 @@ xfs_alloc_vextent_near_bno(
 	args->agno = XFS_FSB_TO_AGNO(mp, target);
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
 	args->type = XFS_ALLOCTYPE_NEAR_BNO;
-	if (need_pag)
-		args->pag = xfs_perag_get(args->mp, args->agno);
-	error = xfs_alloc_ag_vextent(args);
+
+	error = xfs_alloc_vextent_prepare_ag(args);
+	if (error)
+		return error;
+
+	if (args->agbp)
+		error = xfs_alloc_ag_vextent(args);
 	if (need_pag)
 		xfs_perag_put(args->pag);
 	if (error)
-- 
2.33.0

