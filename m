Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17E5C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377696AbhLCAEn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:04:43 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:35727 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349763AbhLCAEn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:43 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 37BF4869CC3
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:17 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00G1LL-Av
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00Bkic-9o
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 30/36] xfs: introduce xfs_alloc_vextent_near_bno()
Date:   Fri,  3 Dec 2021 11:01:05 +1100
Message-Id: <20211203000111.2800982-31-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61a95e4d
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=cxPQ6x55hLG55csZt-YA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The remaining callers of xfs_alloc_vextent() are all doing NEAR_BNO
allocations. We can replace that function with a new
xfs_alloc_vextent_near_bno() function that does this explicitly.

We also multiplex NEAR_BNO allocations through
xfs_alloc_vextent_this_ag via args->type. Replace all of these with
direct calls to xfs_alloc_vextent_near_bno(), too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c          | 41 ++++++++++++++++++------------
 fs/xfs/libxfs/xfs_alloc.h          | 14 +++++-----
 fs/xfs/libxfs/xfs_bmap.c           | 23 ++++-------------
 fs/xfs/libxfs/xfs_bmap_btree.c     |  7 ++---
 fs/xfs/libxfs/xfs_ialloc.c         | 27 ++++++++------------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  5 ++--
 fs/xfs/libxfs/xfs_refcount_btree.c |  7 +++--
 7 files changed, 54 insertions(+), 70 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 9c22d101d3ca..266753fe7893 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3424,29 +3424,38 @@ xfs_alloc_vextent_first_ag(
 }
 
 /*
- * Allocate an extent (variable-size).
- * Depending on the allocation type, we either look in a single allocation
- * group or loop over the allocation groups to find the result.
+ * Allocate an extent as close to the target as possible. If there are not
+ * viable candidates in the AG, then fail the allocation.
  */
 int
-xfs_alloc_vextent(
-	struct xfs_alloc_arg	*args)
+xfs_alloc_vextent_near_bno(
+	struct xfs_alloc_arg	*args,
+	xfs_rfsblock_t		target)
 {
+	struct xfs_mount	*mp = args->mp;
+	bool			need_pag = !args->pag;
 	int			error;
 
-	switch (args->type) {
-	case XFS_ALLOCTYPE_NEAR_BNO:
-		args->pag = xfs_perag_get(args->mp,
-				XFS_FSB_TO_AGNO(args->mp, args->fsbno));
-		error = xfs_alloc_vextent_this_ag(args);
-		xfs_perag_put(args->pag);
+	error = xfs_alloc_vextent_check_args(args, target);
+	if (error) {
+		if (error == -ENOSPC)
+			return 0;
 		return error;
-	default:
-		ASSERT(0);
-		/* NOTREACHED */
 	}
-	/* Should never get here */
-	return -EFSCORRUPTED;
+
+	args->agno = XFS_FSB_TO_AGNO(mp, target);
+	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
+	args->type = XFS_ALLOCTYPE_NEAR_BNO;
+	if (need_pag)
+		args->pag = xfs_perag_get(args->mp, args->agno);
+	error = xfs_alloc_ag_vextent(args);
+	if (need_pag)
+		xfs_perag_put(args->pag);
+	if (error)
+		return error;
+
+	xfs_alloc_vextent_set_fsbno(args);
+	return 0;
 }
 
 /* Ensure that the freelist is at full capacity. */
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index a02ea72aa0c4..4cd0e9abdc1c 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -114,19 +114,19 @@ xfs_alloc_log_agf(
 	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
 	int		fields);/* mask of fields to be logged (XFS_AGF_...) */
 
-/*
- * Allocate an extent (variable-size).
- */
-int				/* error */
-xfs_alloc_vextent(
-	xfs_alloc_arg_t	*args);	/* allocation argument structure */
-
 /*
  * Allocate an extent in the specific AG defined by args->fsbno. If there is no
  * space in that AG, then the allocation will fail.
  */
 int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
 
+/*
+ * Allocate an extent as close to the target as possible. If there are not
+ * viable candidates in the AG, then fail the allocation.
+ */
+int xfs_alloc_vextent_near_bno(struct xfs_alloc_arg *args,
+		xfs_rfsblock_t target);
+
 /*
  * Best effort full filesystem allocation scan.
  *
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 23a29b33e77c..47414bd9be80 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -656,11 +656,7 @@ xfs_bmap_extents_to_btree(
 	} else if (tp->t_flags & XFS_TRANS_LOWMODE) {
 		error = xfs_alloc_vextent_start_ag(&args, tp->t_firstblock);
 	} else {
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.fsbno = tp->t_firstblock;
-		args.pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, args.fsbno));
-		error = xfs_alloc_vextent_this_ag(&args);
-		xfs_perag_put(args.pag);
+		error = xfs_alloc_vextent_near_bno(&args, tp->t_firstblock);
 	}
 	if (error)
 		goto out_root_realloc;
@@ -813,12 +809,7 @@ xfs_bmap_local_to_extents(
 		error = xfs_alloc_vextent_start_ag(&args,
 				XFS_INO_TO_FSB(args.mp, ip->i_ino));
 	} else {
-		args.fsbno = tp->t_firstblock;
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.pag = xfs_perag_get(args.mp,
-				XFS_FSB_TO_AGNO(args.mp, args.fsbno));
-		error = xfs_alloc_vextent_this_ag(&args);
-		xfs_perag_put(args.pag);
+		error = xfs_alloc_vextent_near_bno(&args, tp->t_firstblock);
 	}
 	if (error)
 		goto done;
@@ -3249,7 +3240,6 @@ xfs_bmap_btalloc_filestreams(
 	int			notinit = 0;
 	int			error;
 
-	args->type = XFS_ALLOCTYPE_NEAR_BNO;
 	args->total = ap->total;
 
 	start_agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
@@ -3585,7 +3575,7 @@ xfs_btalloc_at_eof(
 	}
 
 	if (ag_only)
-		error = xfs_alloc_vextent(args);
+		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
 	else
 		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	if (error)
@@ -3666,7 +3656,6 @@ xfs_btalloc_nullfb(
 		ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
 	}
 	xfs_bmap_adjacent(ap);
-	args->fsbno = ap->blkno;
 
 	/*
 	 * Search for an allocation group with a single extent large enough for
@@ -3690,7 +3679,7 @@ xfs_btalloc_nullfb(
 	}
 
 	if (is_filestream)
-		error = xfs_alloc_vextent(args);
+		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
 	else
 		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	if (error)
@@ -3760,8 +3749,6 @@ xfs_btalloc_near(
 
 	ap->blkno = ap->tp->t_firstblock;
 	xfs_bmap_adjacent(ap);
-	args->fsbno = ap->blkno;
-	args->type = XFS_ALLOCTYPE_NEAR_BNO;
 	args->total = ap->total;
 	args->minlen = ap->minlen;
 
@@ -3773,7 +3760,7 @@ xfs_btalloc_near(
 		if (args->fsbno != NULLFSBLOCK)
 			return 0;
 	}
-	return xfs_alloc_vextent(args);
+	return xfs_alloc_vextent_near_bno(args, ap->blkno);
 }
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index b2166dc16459..ea548cca085f 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -247,11 +247,8 @@ xfs_bmbt_alloc_block(
 		error = xfs_alloc_vextent_start_ag(&args,
 				cur->bc_tp->t_firstblock);
 	} else {
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.pag = xfs_perag_get(args.mp,
-				XFS_FSB_TO_AGNO(args.mp, args.fsbno));
-		error = xfs_alloc_vextent_this_ag(&args);
-		xfs_perag_put(args.pag);
+		error = xfs_alloc_vextent_near_bno(&args,
+				cur->bc_tp->t_firstblock);
 	}
 	if (error)
 		goto error0;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 27f5951ae087..64577be85c8b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -717,23 +717,17 @@ xfs_ialloc_ag_alloc(
 			isaligned = 1;
 		} else
 			args.alignment = igeo->cluster_align;
-		/*
-		 * Need to figure out where to allocate the inode blocks.
-		 * Ideally they should be spaced out through the a.g.
-		 * For now, just allocate blocks up front.
-		 */
-		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
 		/*
 		 * Allocate a fixed-size extent of inodes.
 		 */
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.prod = 1;
 		/*
 		 * Allow space for the inode btree to split.
 		 */
 		args.minleft = igeo->inobt_maxlevels;
-		error = xfs_alloc_vextent_this_ag(&args);
+		error = xfs_alloc_vextent_near_bno(&args,
+				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
+						be32_to_cpu(agi->agi_root)));
 		if (error)
 			return error;
 	}
@@ -743,11 +737,11 @@ xfs_ialloc_ag_alloc(
 	 * alignment.
 	 */
 	if (isaligned && args.fsbno == NULLFSBLOCK) {
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
 		args.alignment = igeo->cluster_align;
-		if ((error = xfs_alloc_vextent(&args)))
+		error = xfs_alloc_vextent_near_bno(&args,
+				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
+						be32_to_cpu(agi->agi_root)));
+		if (error)
 			return error;
 	}
 
@@ -759,9 +753,6 @@ xfs_ialloc_ag_alloc(
 	    igeo->ialloc_min_blks < igeo->ialloc_blks &&
 	    args.fsbno == NULLFSBLOCK) {
 sparse_alloc:
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
 		args.alignment = args.mp->m_sb.sb_spino_align;
 		args.prod = 1;
 
@@ -783,7 +774,9 @@ xfs_ialloc_ag_alloc(
 					    args.mp->m_sb.sb_inoalignmt) -
 				 igeo->ialloc_blks;
 
-		error = xfs_alloc_vextent_this_ag(&args);
+		error = xfs_alloc_vextent_near_bno(&args,
+				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
+						be32_to_cpu(agi->agi_root)));
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index fa6cd2502970..9b28211d5a4c 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -105,14 +105,13 @@ __xfs_inobt_alloc_block(
 	args.mp = cur->bc_mp;
 	args.pag = cur->bc_ag.pag;
 	args.oinfo = XFS_RMAP_OINFO_INOBT;
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_ag.pag->pag_agno, sbno);
 	args.minlen = 1;
 	args.maxlen = 1;
 	args.prod = 1;
-	args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	args.resv = resv;
 
-	error = xfs_alloc_vextent_this_ag(&args);
+	error = xfs_alloc_vextent_near_bno(&args,
+			XFS_AGB_TO_FSB(args.mp, args.pag->pag_agno, sbno));
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index bf4049b42f7d..7da175ac5cf6 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -67,14 +67,13 @@ xfs_refcountbt_alloc_block(
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
 	args.pag = cur->bc_ag.pag;
-	args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			xfs_refc_block(args.mp));
 	args.oinfo = XFS_RMAP_OINFO_REFC;
 	args.minlen = args.maxlen = args.prod = 1;
 	args.resv = XFS_AG_RESV_METADATA;
 
-	error = xfs_alloc_vextent_this_ag(&args);
+	error = xfs_alloc_vextent_near_bno(&args,
+			XFS_AGB_TO_FSB(args.mp, args.pag->pag_agno,
+					xfs_refc_block(args.mp)));
 	if (error)
 		goto out_error;
 	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-- 
2.33.0

