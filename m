Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15343C43219
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349763AbhLCAEo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:04:44 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:35729 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349676AbhLCAEn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:43 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 14900869D54
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:17 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00G1L9-6N
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00BkiH-52
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 26/36] xfs: use xfs_alloc_vextent_this_ag() where appropriate
Date:   Fri,  3 Dec 2021 11:01:01 +1100
Message-Id: <20211203000111.2800982-27-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61a95e4d
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=LTYJ9dsPWdyigA4p4SUA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Change obvious callers of single AG allocation to use
xfs_alloc_vextent_this_ag(). Drive the per-ag grabbing out to the
callers, too, so that callers with active references don't need
to do new lookups just for an allocation in a context that already
has a perag reference.

The only remaining caller that does single AG allocation through
xfs_alloc_vextent() is xfs_bmap_btalloc() with
XFS_ALLOCTYPE_NEAR_BNO. That is going to need more untangling before
it can be converted cleanly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c             |  3 +-
 fs/xfs/libxfs/xfs_alloc.c          | 15 ++++---
 fs/xfs/libxfs/xfs_alloc.h          |  6 +++
 fs/xfs/libxfs/xfs_bmap.c           | 71 ++++++++++++++++++------------
 fs/xfs/libxfs/xfs_bmap_btree.c     | 48 +++++++++++---------
 fs/xfs/libxfs/xfs_ialloc.c         |  9 ++--
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  3 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  3 +-
 fs/xfs/scrub/repair.c              |  3 +-
 9 files changed, 98 insertions(+), 63 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index c866274cb8ce..f210f438db84 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -896,6 +896,7 @@ xfs_ag_shrink_space(
 	struct xfs_alloc_arg	args = {
 		.tp	= *tpp,
 		.mp	= mp,
+		.pag	= pag,
 		.type	= XFS_ALLOCTYPE_THIS_BNO,
 		.minlen = delta,
 		.maxlen = delta,
@@ -947,7 +948,7 @@ xfs_ag_shrink_space(
 		return error;
 
 	/* internal log shouldn't also show up in the free space btrees */
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_this_ag(&args);
 	if (!error && args.agbno == NULLAGBLOCK)
 		error = -ENOSPC;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7082f77c38e9..78a9cd543a2d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2709,7 +2709,6 @@ xfs_alloc_fix_freelist(
 	targs.agbp = agbp;
 	targs.agno = args->agno;
 	targs.alignment = targs.minlen = targs.prod = 1;
-	targs.type = XFS_ALLOCTYPE_THIS_AG;
 	targs.pag = pag;
 	error = xfs_alloc_read_agfl(pag, tp, &agflbp);
 	if (error)
@@ -3233,7 +3232,7 @@ xfs_alloc_vextent_set_fsbno(
 /*
  * Allocate within a single AG only.
  */
-static int
+int
 xfs_alloc_vextent_this_ag(
 	struct xfs_alloc_arg	*args)
 {
@@ -3248,9 +3247,7 @@ xfs_alloc_vextent_this_ag(
 	}
 
 	args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
-	args->pag = xfs_perag_get(mp, args->agno);
 	error = xfs_alloc_ag_vextent(args);
-	xfs_perag_put(args->pag);
 	if (error)
 		return error;
 
@@ -3429,11 +3426,15 @@ int
 xfs_alloc_vextent(
 	struct xfs_alloc_arg	*args)
 {
+	int			error;
+
 	switch (args->type) {
-	case XFS_ALLOCTYPE_THIS_AG:
 	case XFS_ALLOCTYPE_NEAR_BNO:
-	case XFS_ALLOCTYPE_THIS_BNO:
-		return xfs_alloc_vextent_this_ag(args);
+		args->pag = xfs_perag_get(args->mp,
+				XFS_FSB_TO_AGNO(args->mp, args->fsbno));
+		error = xfs_alloc_vextent_this_ag(args);
+		xfs_perag_put(args->pag);
+		return error;
 	case XFS_ALLOCTYPE_START_BNO:
 		return xfs_alloc_vextent_start_ag(args);
 	case XFS_ALLOCTYPE_FIRST_AG:
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index aa4c8f866cd1..7baf65a23e6e 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -125,6 +125,12 @@ int				/* error */
 xfs_alloc_vextent(
 	xfs_alloc_arg_t	*args);	/* allocation argument structure */
 
+/*
+ * Allocate an extent in the specific AG defined by args->fsbno. If there is no
+ * space in that AG, then the allocation will fail.
+ */
+int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
+
 /*
  * Free an extent.
  */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e9e039d8ba62..304a0e8cedc8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -646,21 +646,25 @@ xfs_bmap_extents_to_btree(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = mp;
+	args.minlen = args.maxlen = args.prod = 1;
+	args.wasdel = wasdel;
+	*logflagsp = 0;
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
 	if (tp->t_firstblock == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
+		error = xfs_alloc_vextent(&args);
 	} else if (tp->t_flags & XFS_TRANS_LOWMODE) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = tp->t_firstblock;
+		error = xfs_alloc_vextent(&args);
 	} else {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.fsbno = tp->t_firstblock;
+		args.pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, args.fsbno));
+		error = xfs_alloc_vextent_this_ag(&args);
+		xfs_perag_put(args.pag);
 	}
-	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = wasdel;
-	*logflagsp = 0;
-	error = xfs_alloc_vextent(&args);
 	if (error)
 		goto out_root_realloc;
 
@@ -801,6 +805,8 @@ xfs_bmap_local_to_extents(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = ip->i_mount;
+	args.total = total;
+	args.minlen = args.maxlen = args.prod = 1;
 	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
 	/*
 	 * Allocate a block.  We know we need only one, since the
@@ -809,13 +815,15 @@ xfs_bmap_local_to_extents(
 	if (tp->t_firstblock == NULLFSBLOCK) {
 		args.fsbno = XFS_INO_TO_FSB(args.mp, ip->i_ino);
 		args.type = XFS_ALLOCTYPE_START_BNO;
+		error = xfs_alloc_vextent(&args);
 	} else {
 		args.fsbno = tp->t_firstblock;
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
+		args.pag = xfs_perag_get(args.mp,
+				XFS_FSB_TO_AGNO(args.mp, args.fsbno));
+		error = xfs_alloc_vextent_this_ag(&args);
+		xfs_perag_put(args.pag);
 	}
-	args.total = total;
-	args.minlen = args.maxlen = args.prod = 1;
-	error = xfs_alloc_vextent(&args);
 	if (error)
 		goto done;
 
@@ -3554,7 +3562,6 @@ xfs_bmap_btalloc(
 	xfs_extlen_t		nextminlen = 0;
 	int			nullfb; /* true if ap->firstblock isn't set */
 	int			isaligned;
-	int			tryagain;
 	int			error;
 	int			stripe_align;
 
@@ -3592,7 +3599,7 @@ xfs_bmap_btalloc(
 	/*
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
-	tryagain = isaligned = 0;
+	isaligned = 0;
 	args.fsbno = ap->blkno;
 	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 
@@ -3623,6 +3630,10 @@ xfs_bmap_btalloc(
 		args.total = ap->total;
 		args.minlen = ap->minlen;
 	}
+	args.minleft = ap->minleft;
+	args.wasdel = ap->wasdel;
+	args.resv = XFS_AG_RESV_NONE;
+	args.datatype = ap->datatype;
 
 	/*
 	 * If we are not low on available data blocks, and the underlying
@@ -3651,9 +3662,9 @@ xfs_bmap_btalloc(
 			 * allocation with alignment turned on.
 			 */
 			atype = args.type;
-			tryagain = 1;
 			args.type = XFS_ALLOCTYPE_THIS_BNO;
 			args.alignment = 1;
+
 			/*
 			 * Compute the minlen+alignment for the
 			 * next case.  Set slop so that the value
@@ -3670,34 +3681,37 @@ xfs_bmap_btalloc(
 					args.minlen - 1;
 			else
 				args.minalignslop = 0;
+
+			args.pag = xfs_perag_get(mp,
+					XFS_FSB_TO_AGNO(mp, args.fsbno));
+			error = xfs_alloc_vextent_this_ag(&args);
+			xfs_perag_put(args.pag);
+			if (error)
+				return error;
+
+			if (args.fsbno != NULLFSBLOCK)
+				goto out_success;
+			/*
+			 * Exact allocation failed. Now try with alignment
+			 * turned on.
+			 */
+			args.pag = NULL;
+			args.type = atype;
+			args.fsbno = ap->blkno;
+			args.alignment = stripe_align;
+			args.minlen = nextminlen;
+			args.minalignslop = 0;
+			isaligned = 1;
 		}
 	} else {
 		args.alignment = 1;
 		args.minalignslop = 0;
 	}
-	args.minleft = ap->minleft;
-	args.wasdel = ap->wasdel;
-	args.resv = XFS_AG_RESV_NONE;
-	args.datatype = ap->datatype;
 
 	error = xfs_alloc_vextent(&args);
 	if (error)
 		return error;
 
-	if (tryagain && args.fsbno == NULLFSBLOCK) {
-		/*
-		 * Exact allocation failed. Now try with alignment
-		 * turned on.
-		 */
-		args.type = atype;
-		args.fsbno = ap->blkno;
-		args.alignment = stripe_align;
-		args.minlen = nextminlen;
-		args.minalignslop = 0;
-		isaligned = 1;
-		if ((error = xfs_alloc_vextent(&args)))
-			return error;
-	}
 	if (isaligned && args.fsbno == NULLFSBLOCK) {
 		/*
 		 * allocation failed, so turn off alignment and
@@ -3727,6 +3741,7 @@ xfs_bmap_btalloc(
 	}
 
 	if (args.fsbno != NULLFSBLOCK) {
+out_success:
 		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
 			orig_length);
 	} else {
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 453309fc85f2..d7b1016355de 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -21,6 +21,7 @@
 #include "xfs_quota.h"
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
+#include "xfs_ag.h"
 
 static struct kmem_cache	*xfs_bmbt_cur_cache;
 
@@ -209,6 +210,10 @@ xfs_bmbt_alloc_block(
 	args.fsbno = cur->bc_tp->t_firstblock;
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_ino.ip->i_ino,
 			cur->bc_ino.whichfork);
+	args.minlen = args.maxlen = args.prod = 1;
+	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL;
+	if (!args.wasdel && args.tp->t_blk_res == 0)
+		return -ENOSPC;
 
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
@@ -225,35 +230,36 @@ xfs_bmbt_alloc_block(
 		 * block allocation here and corrupt the filesystem.
 		 */
 		args.minleft = args.tp->t_blk_res;
+		error = xfs_alloc_vextent(&args);
+		if (error)
+			goto error0;
+
+		if (args.fsbno == NULLFSBLOCK) {
+			/*
+			 * Could not find an AG with enough free space to
+			 * satisfy a full btree split.  Try again and if
+			 * successful activate the lowspace algorithm.
+			 */
+			args.fsbno = 0;
+			args.type = XFS_ALLOCTYPE_FIRST_AG;
+			error = xfs_alloc_vextent(&args);
+			if (error)
+				goto error0;
+			cur->bc_tp->t_flags |= XFS_TRANS_LOWMODE;
+		}
 	} else if (cur->bc_tp->t_flags & XFS_TRANS_LOWMODE) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
+		error = xfs_alloc_vextent(&args);
 	} else {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
+		args.pag = xfs_perag_get(args.mp,
+				XFS_FSB_TO_AGNO(args.mp, args.fsbno));
+		error = xfs_alloc_vextent_this_ag(&args);
+		xfs_perag_put(args.pag);
 	}
-
-	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL;
-	if (!args.wasdel && args.tp->t_blk_res == 0) {
-		error = -ENOSPC;
-		goto error0;
-	}
-	error = xfs_alloc_vextent(&args);
 	if (error)
 		goto error0;
 
-	if (args.fsbno == NULLFSBLOCK && args.minleft) {
-		/*
-		 * Could not find an AG with enough free space to satisfy
-		 * a full btree split.  Try again and if
-		 * successful activate the lowspace algorithm.
-		 */
-		args.fsbno = 0;
-		args.type = XFS_ALLOCTYPE_FIRST_AG;
-		error = xfs_alloc_vextent(&args);
-		if (error)
-			goto error0;
-		cur->bc_tp->t_flags |= XFS_TRANS_LOWMODE;
-	}
 	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
 		*stat = 0;
 		return 0;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index a155b3cc1e14..27f5951ae087 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -630,6 +630,7 @@ xfs_ialloc_ag_alloc(
 	args.mp = tp->t_mountp;
 	args.fsbno = NULLFSBLOCK;
 	args.oinfo = XFS_RMAP_OINFO_INODES;
+	args.pag = pag;
 
 #ifdef DEBUG
 	/* randomly do sparse inode allocations */
@@ -683,7 +684,8 @@ xfs_ialloc_ag_alloc(
 
 		/* Allow space for the inode btree to split. */
 		args.minleft = igeo->inobt_maxlevels;
-		if ((error = xfs_alloc_vextent(&args)))
+		error = xfs_alloc_vextent_this_ag(&args);
+		if (error)
 			return error;
 
 		/*
@@ -731,7 +733,8 @@ xfs_ialloc_ag_alloc(
 		 * Allow space for the inode btree to split.
 		 */
 		args.minleft = igeo->inobt_maxlevels;
-		if ((error = xfs_alloc_vextent(&args)))
+		error = xfs_alloc_vextent_this_ag(&args);
+		if (error)
 			return error;
 	}
 
@@ -780,7 +783,7 @@ xfs_ialloc_ag_alloc(
 					    args.mp->m_sb.sb_inoalignmt) -
 				 igeo->ialloc_blks;
 
-		error = xfs_alloc_vextent(&args);
+		error = xfs_alloc_vextent_this_ag(&args);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 3675a0d29310..fa6cd2502970 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -103,6 +103,7 @@ __xfs_inobt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
+	args.pag = cur->bc_ag.pag;
 	args.oinfo = XFS_RMAP_OINFO_INOBT;
 	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_ag.pag->pag_agno, sbno);
 	args.minlen = 1;
@@ -111,7 +112,7 @@ __xfs_inobt_alloc_block(
 	args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	args.resv = resv;
 
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_this_ag(&args);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 938e804d420f..bf4049b42f7d 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -66,6 +66,7 @@ xfs_refcountbt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
+	args.pag = cur->bc_ag.pag;
 	args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			xfs_refc_block(args.mp));
@@ -73,7 +74,7 @@ xfs_refcountbt_alloc_block(
 	args.minlen = args.maxlen = args.prod = 1;
 	args.resv = XFS_AG_RESV_METADATA;
 
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_this_ag(&args);
 	if (error)
 		goto out_error;
 	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index d2331d515758..0fd7ec7461a5 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -313,6 +313,7 @@ xrep_alloc_ag_block(
 
 	args.tp = sc->tp;
 	args.mp = sc->mp;
+	args.pag = sc->sa.pag;
 	args.oinfo = *oinfo;
 	args.fsbno = XFS_AGB_TO_FSB(args.mp, sc->sa.pag->pag_agno, 0);
 	args.minlen = 1;
@@ -321,7 +322,7 @@ xrep_alloc_ag_block(
 	args.type = XFS_ALLOCTYPE_THIS_AG;
 	args.resv = resv;
 
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_this_ag(&args);
 	if (error)
 		return error;
 	if (args.fsbno == NULLFSBLOCK)
-- 
2.33.0

