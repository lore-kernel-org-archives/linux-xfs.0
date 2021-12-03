Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85DCBC4321E
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377737AbhLCAEu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:04:50 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:37649 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377744AbhLCAEu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:50 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 58B88869E5E
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:24 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00G1LU-EI
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00Bkir-D2
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 33/36] xfs: move allocation accounting to xfs_alloc_vextent_set_fsbno()
Date:   Fri,  3 Dec 2021 11:01:08 +1100
Message-Id: <20211203000111.2800982-34-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61a95e54
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=wN4_hNFfbszvjEHaC1QA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Move it from xfs_alloc_ag_vextent() so we can get rid of that layer.
Rename xfs_alloc_vextent_set_fsbno() to xfs_alloc_vextent_finish()
to indicate that it's function is finishing off the allocation that
we've run now that it contains much more functionality.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 127 +++++++++++++++++++-------------------
 1 file changed, 62 insertions(+), 65 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d2595dada0e2..a1f391a44fe5 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1149,36 +1149,6 @@ xfs_alloc_ag_vextent(
 		ASSERT(0);
 		/* NOTREACHED */
 	}
-
-	if (error || args->agbno == NULLAGBLOCK)
-		return error;
-
-	ASSERT(args->len >= args->minlen);
-	ASSERT(args->len <= args->maxlen);
-	ASSERT(args->agbno % args->alignment == 0);
-
-	/* if not file data, insert new block into the reverse map btree */
-	if (!xfs_rmap_should_skip_owner_update(&args->oinfo)) {
-		error = xfs_rmap_alloc(args->tp, args->agbp, args->pag,
-				       args->agbno, args->len, &args->oinfo);
-		if (error)
-			return error;
-	}
-
-	if (!args->wasfromfl) {
-		error = xfs_alloc_update_counters(args->tp, args->agbp,
-						  -((long)(args->len)));
-		if (error)
-			return error;
-
-		ASSERT(!xfs_extent_busy_search(args->mp, args->pag,
-					      args->agbno, args->len));
-	}
-
-	xfs_ag_resv_alloc_extent(args->pag, args->resv, args);
-
-	XFS_STATS_INC(args->mp, xs_allocx);
-	XFS_STATS_ADD(args->mp, xs_allocb, args->len);
 	return error;
 }
 
@@ -3221,31 +3191,56 @@ xfs_alloc_vextent_prepare_ag(
 }
 
 /*
- * Post-process allocation results to set the allocated block number correctly
- * for the caller.
+ * Post-process allocation results to account for the allocation if it succeed
+ * and set the allocated block number correctly for the caller.
  *
- * XXX: xfs_alloc_vextent() should really be returning ENOSPC for ENOSPC, not
+ * XXX: we should really be returning ENOSPC for ENOSPC, not
  * hiding it behind a "successful" NULLFSBLOCK allocation.
  */
-static void
-xfs_alloc_vextent_set_fsbno(
+static int
+xfs_alloc_vextent_finish(
 	struct xfs_alloc_arg	*args)
 {
-	struct xfs_mount	*mp = args->mp;
+	int			error = 0;
 
 	/* Allocation failed with ENOSPC if NULLAGBLOCK was returned. */
 	if (args->agbno == NULLAGBLOCK) {
 		args->fsbno = NULLFSBLOCK;
-		return;
+		return 0;
 	}
 
-	args->fsbno = XFS_AGB_TO_FSB(mp, args->agno, args->agbno);
-#ifdef DEBUG
+	args->fsbno = XFS_AGB_TO_FSB(args->mp, args->agno, args->agbno);
+
 	ASSERT(args->len >= args->minlen);
 	ASSERT(args->len <= args->maxlen);
 	ASSERT(args->agbno % args->alignment == 0);
-	XFS_AG_CHECK_DADDR(mp, XFS_FSB_TO_DADDR(mp, args->fsbno), args->len);
-#endif
+	XFS_AG_CHECK_DADDR(args->mp, XFS_FSB_TO_DADDR(args->mp, args->fsbno),
+			args->len);
+
+	/* if not file data, insert new block into the reverse map btree */
+	if (!xfs_rmap_should_skip_owner_update(&args->oinfo)) {
+		error = xfs_rmap_alloc(args->tp, args->agbp, args->pag,
+				       args->agbno, args->len, &args->oinfo);
+		if (error)
+			return error;
+	}
+
+	if (!args->wasfromfl) {
+		error = xfs_alloc_update_counters(args->tp, args->agbp,
+						  -((long)(args->len)));
+		if (error)
+			return error;
+
+		ASSERT(!xfs_extent_busy_search(args->mp, args->pag,
+					      args->agbno, args->len));
+	}
+
+	xfs_ag_resv_alloc_extent(args->pag, args->resv, args);
+
+	XFS_STATS_INC(args->mp, xs_allocx);
+	XFS_STATS_ADD(args->mp, xs_allocb, args->len);
+
+	return 0;
 }
 
 /*
@@ -3282,8 +3277,7 @@ xfs_alloc_vextent_this_ag(
 			return error;
 	}
 
-	xfs_alloc_vextent_set_fsbno(args);
-	return 0;
+	return xfs_alloc_vextent_finish(args);
 }
 
 /*
@@ -3371,8 +3365,10 @@ xfs_alloc_vextent_iterate_ags(
 		xfs_perag_put(args->pag);
 		args->pag = NULL;
 	}
-	xfs_perag_put(args->pag);
-	args->pag = NULL;
+	/*
+	 * On success, perag is left referenced in args for the caller to clean
+	 * up after they've finished the allocation.
+	 */
 	return error;
 }
 
@@ -3418,8 +3414,12 @@ xfs_alloc_vextent_start_ag(
 
 	error = xfs_alloc_vextent_iterate_ags(args, start_agno,
 			XFS_ALLOC_FLAG_TRYLOCK);
-	if (error)
-		return error;
+	if (!error)
+		error = xfs_alloc_vextent_finish(args);
+	if (args->pag) {
+		xfs_perag_put(args->pag);
+		args->pag = NULL;
+	}
 
 	if (bump_rotor) {
 		if (args->agno == start_agno)
@@ -3430,8 +3430,7 @@ xfs_alloc_vextent_start_ag(
 				(mp->m_sb.sb_agcount * rotorstep);
 	}
 
-	xfs_alloc_vextent_set_fsbno(args);
-	return 0;
+	return error;
 }
 
 /*
@@ -3458,10 +3457,13 @@ xfs_alloc_vextent_first_ag(
 	args->fsbno = target;
 	error =  xfs_alloc_vextent_iterate_ags(args,
 			XFS_FSB_TO_AGNO(mp, args->fsbno), 0);
-	if (error)
-		return error;
-	xfs_alloc_vextent_set_fsbno(args);
-	return 0;
+	if (!error)
+		error = xfs_alloc_vextent_finish(args);
+	if (args->pag) {
+		xfs_perag_put(args->pag);
+		args->pag = NULL;
+	}
+	return error;
 }
 
 /*
@@ -3492,14 +3494,11 @@ xfs_alloc_vextent_exact_bno(
 	if (error)
 		return error;
 
-	if (args->agbp) {
+	if (args->agbp)
 		error = xfs_alloc_ag_vextent(args);
-		if (error)
-			return error;
-	}
-
-	xfs_alloc_vextent_set_fsbno(args);
-	return 0;
+	if (!error)
+		error = xfs_alloc_vextent_finish(args);
+	return error;
 }
 
 /*
@@ -3534,13 +3533,11 @@ xfs_alloc_vextent_near_bno(
 
 	if (args->agbp)
 		error = xfs_alloc_ag_vextent(args);
+	if (!error)
+		error = xfs_alloc_vextent_finish(args);
 	if (need_pag)
 		xfs_perag_put(args->pag);
-	if (error)
-		return error;
-
-	xfs_alloc_vextent_set_fsbno(args);
-	return 0;
+	return error;
 }
 
 /* Ensure that the freelist is at full capacity. */
-- 
2.33.0

