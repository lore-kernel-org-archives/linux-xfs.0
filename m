Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D8C8CCA47B
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349130AbiFKB1V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347331AbiFKB1Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:16 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1C573A4820
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 044ED5EC7F5
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005APb-1C
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELN9-0H
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 32/50] xfs: introduce xfs_alloc_vextent_prepare()
Date:   Sat, 11 Jun 2022 11:26:41 +1000
Message-Id: <20220611012659.3418072-33-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=wHXgHO0elxk0tAdDANkA:9
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
index 2f6de1ee2b36..10d65e6dad4e 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1148,31 +1148,8 @@ static int
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
@@ -3204,11 +3181,18 @@ xfs_alloc_vextent_check_args(
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
@@ -3220,6 +3204,40 @@ xfs_alloc_vextent_check_args(
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
@@ -3249,7 +3267,8 @@ xfs_alloc_vextent_set_fsbno(
 }
 
 /*
- * Allocate within a single AG only.
+ * Allocate within a single AG only. Caller is expected to hold a
+ * perag reference in args->pag.
  */
 int
 xfs_alloc_vextent_this_ag(
@@ -3271,10 +3290,16 @@ xfs_alloc_vextent_this_ag(
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
@@ -3312,16 +3337,27 @@ xfs_alloc_vextent_iterate_ags(
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
@@ -3347,14 +3383,14 @@ xfs_alloc_vextent_iterate_ags(
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
 
@@ -3447,7 +3483,8 @@ xfs_alloc_vextent_first_ag(
 }
 
 /*
- * Allocate within a single AG only.
+ * Allocate at the exact block target or fail. Caller is expected to hold a
+ * perag reference in args->pag.
  */
 int
 xfs_alloc_vextent_exact_bno(
@@ -3468,10 +3505,17 @@ xfs_alloc_vextent_exact_bno(
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
@@ -3479,6 +3523,8 @@ xfs_alloc_vextent_exact_bno(
 /*
  * Allocate an extent as close to the target as possible. If there are not
  * viable candidates in the AG, then fail the allocation.
+ *
+ * Caller may or may not have a per-ag reference in args->pag.
  */
 int
 xfs_alloc_vextent_near_bno(
@@ -3499,9 +3545,13 @@ xfs_alloc_vextent_near_bno(
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
2.35.1

