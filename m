Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E553C4321E
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377726AbhLCAEr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:04:47 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:55994 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377732AbhLCAEq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:46 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 10681606B28
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:18 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00G1LO-Bv
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00Bkih-As
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 31/36] xfs: introduce xfs_alloc_vextent_exact_bno()
Date:   Fri,  3 Dec 2021 11:01:06 +1100
Message-Id: <20211203000111.2800982-32-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61a95e4e
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=oGMmTz3EdBZv14weP10A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Two of the callers to xfs_alloc_vextent_this_ag() actually want
exact block number allocation, not anywhere-in-ag allocation. Split
this out from _this_ag() as a first class citizen so no external
extent allocation code needs to care about args->type anymore.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c     |  6 ++----
 fs/xfs/libxfs/xfs_alloc.c  | 41 +++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_alloc.h  | 13 +++++++++---
 fs/xfs/libxfs/xfs_bmap.c   |  6 ++----
 fs/xfs/libxfs/xfs_ialloc.c |  6 +++---
 fs/xfs/scrub/repair.c      |  4 +---
 6 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index f210f438db84..757cc72c8553 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -897,7 +897,6 @@ xfs_ag_shrink_space(
 		.tp	= *tpp,
 		.mp	= mp,
 		.pag	= pag,
-		.type	= XFS_ALLOCTYPE_THIS_BNO,
 		.minlen = delta,
 		.maxlen = delta,
 		.oinfo	= XFS_RMAP_OINFO_SKIP_UPDATE,
@@ -929,8 +928,6 @@ xfs_ag_shrink_space(
 	if (delta >= aglen)
 		return -EINVAL;
 
-	args.fsbno = XFS_AGB_TO_FSB(mp, pag->pag_agno, aglen - delta);
-
 	/*
 	 * Make sure that the last inode cluster cannot overlap with the new
 	 * end of the AG, even if it's sparse.
@@ -948,7 +945,8 @@ xfs_ag_shrink_space(
 		return error;
 
 	/* internal log shouldn't also show up in the free space btrees */
-	error = xfs_alloc_vextent_this_ag(&args);
+	error = xfs_alloc_vextent_exact_bno(&args,
+			XFS_AGB_TO_FSB(mp, pag->pag_agno, aglen - delta));
 	if (!error && args.agbno == NULLAGBLOCK)
 		error = -ENOSPC;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 266753fe7893..1fb72fff5d26 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3235,19 +3235,24 @@ xfs_alloc_vextent_set_fsbno(
  */
 int
 xfs_alloc_vextent_this_ag(
-	struct xfs_alloc_arg	*args)
+	struct xfs_alloc_arg	*args,
+	xfs_agnumber_t		agno)
 {
 	struct xfs_mount	*mp = args->mp;
 	int			error;
+	xfs_rfsblock_t		target = XFS_AGB_TO_FSB(mp, agno, 0);
 
-	error = xfs_alloc_vextent_check_args(args, args->fsbno);
+	error = xfs_alloc_vextent_check_args(args, target);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
 		return error;
 	}
 
-	args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	args->agno = agno;
+	args->agbno = 0;
+	args->fsbno = target;
+	args->type = XFS_ALLOCTYPE_THIS_AG;
 	error = xfs_alloc_ag_vextent(args);
 	if (error)
 		return error;
@@ -3423,6 +3428,36 @@ xfs_alloc_vextent_first_ag(
 	return 0;
 }
 
+/*
+ * Allocate within a single AG only.
+ */
+int
+xfs_alloc_vextent_exact_bno(
+	struct xfs_alloc_arg	*args,
+	xfs_rfsblock_t		target)
+{
+	struct xfs_mount	*mp = args->mp;
+	int			error;
+
+	error = xfs_alloc_vextent_check_args(args, target);
+	if (error) {
+		if (error == -ENOSPC)
+			return 0;
+		return error;
+	}
+
+	args->agno = XFS_FSB_TO_AGNO(mp, target);
+	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
+	args->fsbno = target;
+	args->type = XFS_ALLOCTYPE_THIS_BNO;
+	error = xfs_alloc_ag_vextent(args);
+	if (error)
+		return error;
+
+	xfs_alloc_vextent_set_fsbno(args);
+	return 0;
+}
+
 /*
  * Allocate an extent as close to the target as possible. If there are not
  * viable candidates in the AG, then fail the allocation.
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 4cd0e9abdc1c..d61c3803c5dc 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -115,10 +115,10 @@ xfs_alloc_log_agf(
 	int		fields);/* mask of fields to be logged (XFS_AGF_...) */
 
 /*
- * Allocate an extent in the specific AG defined by args->fsbno. If there is no
- * space in that AG, then the allocation will fail.
+ * Allocate an extent anywhere in the specific AG given. If there is no
+ * space matching the requirements in that AG, then the allocation will fail.
  */
-int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
+int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args, xfs_agnumber_t agno);
 
 /*
  * Allocate an extent as close to the target as possible. If there are not
@@ -127,6 +127,13 @@ int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
 int xfs_alloc_vextent_near_bno(struct xfs_alloc_arg *args,
 		xfs_rfsblock_t target);
 
+/*
+ * Allocate an extent exactly at the target given. If this is not possible
+ * then the allocation fails.
+ */
+int xfs_alloc_vextent_exact_bno(struct xfs_alloc_arg *args,
+		xfs_rfsblock_t target);
+
 /*
  * Best effort full filesystem allocation scan.
  *
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 47414bd9be80..4227007a4f9d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3525,7 +3525,6 @@ xfs_btalloc_at_eof(
 		xfs_extlen_t	nextminlen = 0;
 
 		atype = args->type;
-		args->type = XFS_ALLOCTYPE_THIS_BNO;
 		args->alignment = 1;
 
 		/*
@@ -3543,8 +3542,8 @@ xfs_btalloc_at_eof(
 		else
 			args->minalignslop = 0;
 
-		args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, args->fsbno));
-		error = xfs_alloc_vextent_this_ag(args);
+		args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
+		error = xfs_alloc_vextent_exact_bno(args, ap->blkno);
 		xfs_perag_put(args->pag);
 		if (error)
 			return error;
@@ -3557,7 +3556,6 @@ xfs_btalloc_at_eof(
 		 */
 		args->pag = NULL;
 		args->type = atype;
-		args->fsbno = ap->blkno;
 		args->alignment = stripe_align;
 		args->minlen = nextminlen;
 		args->minalignslop = 0;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 64577be85c8b..a519c2d3696e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -662,8 +662,6 @@ xfs_ialloc_ag_alloc(
 		goto sparse_alloc;
 	if (likely(newino != NULLAGINO &&
 		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
-		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
-		args.type = XFS_ALLOCTYPE_THIS_BNO;
 		args.prod = 1;
 
 		/*
@@ -684,7 +682,9 @@ xfs_ialloc_ag_alloc(
 
 		/* Allow space for the inode btree to split. */
 		args.minleft = igeo->inobt_maxlevels;
-		error = xfs_alloc_vextent_this_ag(&args);
+		error = xfs_alloc_vextent_exact_bno(&args,
+				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
+						args.agbno));
 		if (error)
 			return error;
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 0fd7ec7461a5..08d856bf75f8 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -315,14 +315,12 @@ xrep_alloc_ag_block(
 	args.mp = sc->mp;
 	args.pag = sc->sa.pag;
 	args.oinfo = *oinfo;
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, sc->sa.pag->pag_agno, 0);
 	args.minlen = 1;
 	args.maxlen = 1;
 	args.prod = 1;
-	args.type = XFS_ALLOCTYPE_THIS_AG;
 	args.resv = resv;
 
-	error = xfs_alloc_vextent_this_ag(&args);
+	error = xfs_alloc_vextent_this_ag(&args, sc->sa.pag->pag_agno);
 	if (error)
 		return error;
 	if (args.fsbno == NULLFSBLOCK)
-- 
2.33.0

