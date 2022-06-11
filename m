Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8864ECCA47B
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238121AbiFKB1f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348881AbiFKB1U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:20 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E73C83A483D
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 2D7925EC7F9
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005APe-22
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELNE-15
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 33/50] xfs: move allocation accounting to xfs_alloc_vextent_set_fsbno()
Date:   Sat, 11 Jun 2022 11:26:42 +1000
Message-Id: <20220611012659.3418072-34-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=wN4_hNFfbszvjEHaC1QA:9
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
index 10d65e6dad4e..1590e9142f7e 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1167,36 +1167,6 @@ xfs_alloc_ag_vextent(
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
 
@@ -3239,31 +3209,56 @@ xfs_alloc_vextent_prepare_ag(
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
@@ -3300,8 +3295,7 @@ xfs_alloc_vextent_this_ag(
 			return error;
 	}
 
-	xfs_alloc_vextent_set_fsbno(args);
-	return 0;
+	return xfs_alloc_vextent_finish(args);
 }
 
 /*
@@ -3389,8 +3383,10 @@ xfs_alloc_vextent_iterate_ags(
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
 
@@ -3436,8 +3432,12 @@ xfs_alloc_vextent_start_ag(
 
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
@@ -3448,8 +3448,7 @@ xfs_alloc_vextent_start_ag(
 				(mp->m_sb.sb_agcount * rotorstep);
 	}
 
-	xfs_alloc_vextent_set_fsbno(args);
-	return 0;
+	return error;
 }
 
 /*
@@ -3476,10 +3475,13 @@ xfs_alloc_vextent_first_ag(
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
@@ -3510,14 +3512,11 @@ xfs_alloc_vextent_exact_bno(
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
@@ -3552,13 +3551,11 @@ xfs_alloc_vextent_near_bno(
 
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
2.35.1

