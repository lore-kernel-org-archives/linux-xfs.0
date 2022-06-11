Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F363CCA47E
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348495AbiFKB1g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348466AbiFKB1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:21 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A54793A4826
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E750F10E720F
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-005APK-R1
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-00ELMe-Pu
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 26/50] xfs: use xfs_alloc_vextent_this_ag() where appropriate
Date:   Sat, 11 Jun 2022 11:26:35 +1000
Message-Id: <20220611012659.3418072-27-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=LTYJ9dsPWdyigA4p4SUA:9
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
index 89b053c668e9..7a7932854283 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -895,6 +895,7 @@ xfs_ag_shrink_space(
 	struct xfs_alloc_arg	args = {
 		.tp	= *tpp,
 		.mp	= mp,
+		.pag	= pag,
 		.type	= XFS_ALLOCTYPE_THIS_BNO,
 		.minlen = delta,
 		.maxlen = delta,
@@ -946,7 +947,7 @@ xfs_ag_shrink_space(
 		return error;
 
 	/* internal log shouldn't also show up in the free space btrees */
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_this_ag(&args);
 	if (!error && args.agbno == NULLAGBLOCK)
 		error = -ENOSPC;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d7687aaba2d0..63a8c6c0b927 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2727,7 +2727,6 @@ xfs_alloc_fix_freelist(
 	targs.agbp = agbp;
 	targs.agno = args->agno;
 	targs.alignment = targs.minlen = targs.prod = 1;
-	targs.type = XFS_ALLOCTYPE_THIS_AG;
 	targs.pag = pag;
 	error = xfs_alloc_read_agfl(pag, tp, &agflbp);
 	if (error)
@@ -3251,7 +3250,7 @@ xfs_alloc_vextent_set_fsbno(
 /*
  * Allocate within a single AG only.
  */
-static int
+int
 xfs_alloc_vextent_this_ag(
 	struct xfs_alloc_arg	*args)
 {
@@ -3266,9 +3265,7 @@ xfs_alloc_vextent_this_ag(
 	}
 
 	args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
-	args->pag = xfs_perag_get(mp, args->agno);
 	error = xfs_alloc_ag_vextent(args);
-	xfs_perag_put(args->pag);
 	if (error)
 		return error;
 
@@ -3447,11 +3444,15 @@ int
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
index 2c3f762dfb58..0a9ad6cd18e2 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -124,6 +124,12 @@ int				/* error */
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
index 9524f606b183..68e862a9d584 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -644,21 +644,25 @@ xfs_bmap_extents_to_btree(
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
 
@@ -799,6 +803,8 @@ xfs_bmap_local_to_extents(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = ip->i_mount;
+	args.total = total;
+	args.minlen = args.maxlen = args.prod = 1;
 	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
 	/*
 	 * Allocate a block.  We know we need only one, since the
@@ -807,13 +813,15 @@ xfs_bmap_local_to_extents(
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
 
@@ -3552,7 +3560,6 @@ xfs_bmap_btalloc(
 	xfs_extlen_t		nextminlen = 0;
 	int			nullfb; /* true if ap->firstblock isn't set */
 	int			isaligned;
-	int			tryagain;
 	int			error;
 	int			stripe_align;
 
@@ -3590,7 +3597,7 @@ xfs_bmap_btalloc(
 	/*
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
-	tryagain = isaligned = 0;
+	isaligned = 0;
 	args.fsbno = ap->blkno;
 	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 
@@ -3621,6 +3628,10 @@ xfs_bmap_btalloc(
 		args.total = ap->total;
 		args.minlen = ap->minlen;
 	}
+	args.minleft = ap->minleft;
+	args.wasdel = ap->wasdel;
+	args.resv = XFS_AG_RESV_NONE;
+	args.datatype = ap->datatype;
 
 	/*
 	 * If we are not low on available data blocks, and the underlying
@@ -3649,9 +3660,9 @@ xfs_bmap_btalloc(
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
@@ -3668,34 +3679,37 @@ xfs_bmap_btalloc(
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
@@ -3725,6 +3739,7 @@ xfs_bmap_btalloc(
 	}
 
 	if (args.fsbno != NULLFSBLOCK) {
+out_success:
 		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
 			orig_length);
 	} else {
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 2b77d45c215f..cf52a2c23bb9 100644
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
index d4b1d82910ad..2084bee7a31b 100644
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
index bb651fac9c64..2e5d5ab4a2ec 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -314,6 +314,7 @@ xrep_alloc_ag_block(
 
 	args.tp = sc->tp;
 	args.mp = sc->mp;
+	args.pag = sc->sa.pag;
 	args.oinfo = *oinfo;
 	args.fsbno = XFS_AGB_TO_FSB(args.mp, sc->sa.pag->pag_agno, 0);
 	args.minlen = 1;
@@ -322,7 +323,7 @@ xrep_alloc_ag_block(
 	args.type = XFS_ALLOCTYPE_THIS_AG;
 	args.resv = resv;
 
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_this_ag(&args);
 	if (error)
 		return error;
 	if (args.fsbno == NULLFSBLOCK)
-- 
2.35.1

