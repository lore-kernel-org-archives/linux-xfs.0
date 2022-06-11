Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE8BCCA47B
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348049AbiFKB1Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347121AbiFKB1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:17 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D1BF3FB125
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E240F5EC7F2
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-005APS-Tl
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-00ELMt-Si
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 29/50] xfs: use xfs_alloc_vextent_start_bno() where appropriate
Date:   Sat, 11 Jun 2022 11:26:38 +1000
Message-Id: <20220611012659.3418072-30-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=2bNGl3VnspcAYmXYyhAA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Change obvious callers of single AG allocation to use
xfs_alloc_vextent_start_bno(). Callers no long need to specify
XFS_ALLOCTYPE_START_BNO, and so the type can be driven inward and
removed.

While doing this, also pass the allocation target fsb as a parameter
rather than encoding it in args->fsbno.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c      | 34 ++++++++++-----------
 fs/xfs/libxfs/xfs_alloc.h      | 13 ++++++--
 fs/xfs/libxfs/xfs_bmap.c       | 54 ++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_bmap_btree.c |  8 ++---
 4 files changed, 59 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6a13be14600c..65d1d48beef6 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3192,7 +3192,6 @@ xfs_alloc_vextent_check_args(
 	struct xfs_mount	*mp = args->mp;
 	xfs_agblock_t		agsize;
 
-	args->otype = args->type;
 	args->agbno = NULLAGBLOCK;
 
 	/*
@@ -3278,12 +3277,11 @@ xfs_alloc_vextent_this_ag(
 /*
  * Iterate all AGs trying to allocate an extent starting from @start_ag.
  *
- * If the
- * incoming allocation type is XFS_ALLOCTYPE_NEAR_BNO, it means the allocation
- * attempts in @start_agno have locality information. If we fail to allocate in
- * that AG, then we revert to anywhere-in-AG for all the other AGs we attempt to
- * allocation in as there is no locality optimisation possible for those
- * allocations.
+ * If the incoming allocation type is XFS_ALLOCTYPE_NEAR_BNO, it means the
+ * allocation attempts in @start_agno have locality information. If we fail to
+ * allocate in that AG, then we revert to anywhere-in-AG for all the other AGs
+ * we attempt to allocation in as there is no locality optimisation possible for
+ * those allocations.
  *
  * When we wrap the AG iteration at the end of the filesystem, we have to be
  * careful not to wrap into AGs below ones we already have locked in the
@@ -3317,7 +3315,7 @@ xfs_alloc_vextent_iterate_ags(
 		trace_xfs_alloc_vextent_loopfailed(args);
 
 		if (args->agno == start_agno &&
-		    args->otype == XFS_ALLOCTYPE_START_BNO)
+		    args->otype == XFS_ALLOCTYPE_NEAR_BNO)
 			args->type = XFS_ALLOCTYPE_THIS_AG;
 		/*
 		* For the first allocation, we can try any AG to get
@@ -3344,7 +3342,7 @@ xfs_alloc_vextent_iterate_ags(
 			}
 
 			flags = 0;
-			if (args->otype == XFS_ALLOCTYPE_START_BNO) {
+			if (args->otype == XFS_ALLOCTYPE_NEAR_BNO) {
 				args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
 				args->type = XFS_ALLOCTYPE_NEAR_BNO;
 			}
@@ -3363,9 +3361,10 @@ xfs_alloc_vextent_iterate_ags(
  * otherwise will wrap back to the start AG and run a second blocking pass to
  * the end of the filesystem.
  */
-static int
+int
 xfs_alloc_vextent_start_ag(
-	struct xfs_alloc_arg	*args)
+	struct xfs_alloc_arg	*args,
+	xfs_rfsblock_t		target)
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		start_agno;
@@ -3373,7 +3372,7 @@ xfs_alloc_vextent_start_ag(
 	bool			bump_rotor = false;
 	int			error;
 
-	error = xfs_alloc_vextent_check_args(args, args->fsbno);
+	error = xfs_alloc_vextent_check_args(args, target);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
@@ -3382,14 +3381,17 @@ xfs_alloc_vextent_start_ag(
 
 	if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
 	    xfs_is_inode32(mp)) {
-		args->fsbno = XFS_AGB_TO_FSB(mp,
+		target = XFS_AGB_TO_FSB(mp,
 				((mp->m_agfrotor / rotorstep) %
 				mp->m_sb.sb_agcount), 0);
 		bump_rotor = 1;
 	}
-	start_agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
-	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+
+	start_agno = XFS_FSB_TO_AGNO(mp, target);
+	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
+	args->otype = XFS_ALLOCTYPE_NEAR_BNO;
 	args->type = XFS_ALLOCTYPE_NEAR_BNO;
+	args->fsbno = target;
 
 	error = xfs_alloc_vextent_iterate_ags(args, start_agno,
 			XFS_ALLOC_FLAG_TRYLOCK);
@@ -3457,8 +3459,6 @@ xfs_alloc_vextent(
 		error = xfs_alloc_vextent_this_ag(args);
 		xfs_perag_put(args->pag);
 		return error;
-	case XFS_ALLOCTYPE_START_BNO:
-		return xfs_alloc_vextent_start_ag(args);
 	default:
 		ASSERT(0);
 		/* NOTREACHED */
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 73697dd3ca55..5487dff3d68a 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -20,7 +20,6 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
  * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
  */
 #define XFS_ALLOCTYPE_THIS_AG	0x08	/* anywhere in this a.g. */
-#define XFS_ALLOCTYPE_START_BNO	0x10	/* near this block else anywhere */
 #define XFS_ALLOCTYPE_NEAR_BNO	0x20	/* in this a.g. and near this block */
 #define XFS_ALLOCTYPE_THIS_BNO	0x40	/* at exactly this block */
 
@@ -29,7 +28,6 @@ typedef unsigned int xfs_alloctype_t;
 
 #define XFS_ALLOC_TYPES \
 	{ XFS_ALLOCTYPE_THIS_AG,	"THIS_AG" }, \
-	{ XFS_ALLOCTYPE_START_BNO,	"START_BNO" }, \
 	{ XFS_ALLOCTYPE_NEAR_BNO,	"NEAR_BNO" }, \
 	{ XFS_ALLOCTYPE_THIS_BNO,	"THIS_BNO" }
 
@@ -128,6 +126,17 @@ xfs_alloc_vextent(
  */
 int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
 
+/*
+ * Best effort full filesystem allocation scan.
+ *
+ * Locality aware allocation will be attempted in the initial AG, but on failure
+ * non-localised attempts will be made. The AGs are constrained by previous
+ * allocations in the current transaction. Two passes will be made - the first
+ * non-blocking, the second blocking.
+ */
+int xfs_alloc_vextent_start_ag(struct xfs_alloc_arg *args,
+		xfs_rfsblock_t target);
+
 /*
  * Iterate from the AG indicated from args->fsbno through to the end of the
  * filesystem attempting blocking allocation. This is for use in last
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7009f48de520..dfb92dbe16b2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -649,13 +649,10 @@ xfs_bmap_extents_to_btree(
 	*logflagsp = 0;
 	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
 	if (tp->t_firstblock == NULLFSBLOCK) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
-		error = xfs_alloc_vextent(&args);
+		error = xfs_alloc_vextent_start_ag(&args,
+				XFS_INO_TO_FSB(mp, ip->i_ino));
 	} else if (tp->t_flags & XFS_TRANS_LOWMODE) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		args.fsbno = tp->t_firstblock;
-		error = xfs_alloc_vextent(&args);
+		error = xfs_alloc_vextent_start_ag(&args, tp->t_firstblock);
 	} else {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.fsbno = tp->t_firstblock;
@@ -811,9 +808,8 @@ xfs_bmap_local_to_extents(
 	 * file currently fits in an inode.
 	 */
 	if (tp->t_firstblock == NULLFSBLOCK) {
-		args.fsbno = XFS_INO_TO_FSB(args.mp, ip->i_ino);
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		error = xfs_alloc_vextent(&args);
+		error = xfs_alloc_vextent_start_ag(&args,
+				XFS_INO_TO_FSB(args.mp, ip->i_ino));
 	} else {
 		args.fsbno = tp->t_firstblock;
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
@@ -3520,7 +3516,8 @@ xfs_btalloc_at_eof(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
 	xfs_extlen_t		blen,
-	int			stripe_align)
+	int			stripe_align,
+	bool			ag_only)
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_alloctype_t		atype;
@@ -3585,7 +3582,10 @@ xfs_btalloc_at_eof(
 		args->minalignslop = 0;
 	}
 
-	error = xfs_alloc_vextent(args);
+	if (ag_only)
+		error = xfs_alloc_vextent(args);
+	else
+		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	if (error)
 		return error;
 
@@ -3615,7 +3615,6 @@ xfs_btalloc_nullfb_bestlen(
 	int			notinit = 0;
 	int			error = 0;
 
-	args->type = XFS_ALLOCTYPE_START_BNO;
 	args->total = ap->total;
 
 	startag = XFS_FSB_TO_AGNO(mp, args->fsbno);
@@ -3646,13 +3645,17 @@ xfs_btalloc_nullfb(
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_extlen_t		blen = 0;
+	bool			is_filestream = false;
 	int			error;
 
+	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
+	    xfs_inode_is_filestream(ap->ip))
+		is_filestream = true;
+
 	/*
 	 * Determine the initial block number we will target for allocation.
 	 */
-	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-	    xfs_inode_is_filestream(ap->ip)) {
+	if (is_filestream) {
 		xfs_agnumber_t	agno = xfs_filestream_lookup_ag(ap->ip);
 		if (agno == NULLAGNUMBER)
 			agno = 0;
@@ -3668,8 +3671,7 @@ xfs_btalloc_nullfb(
 	 * the request.  If one isn't found, then adjust the minimum allocation
 	 * size to the largest space found.
 	 */
-	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-	    xfs_inode_is_filestream(ap->ip))
+	if (is_filestream)
 		error = xfs_bmap_btalloc_filestreams(ap, args, &blen);
 	else
 		error = xfs_btalloc_nullfb_bestlen(ap, args, &blen);
@@ -3677,14 +3679,18 @@ xfs_btalloc_nullfb(
 		return error;
 
 	if (ap->aeof) {
-		error = xfs_btalloc_at_eof(ap, args, blen, stripe_align);
+		error = xfs_btalloc_at_eof(ap, args, blen, stripe_align,
+				is_filestream);
 		if (error)
 			return error;
 		if (args->fsbno != NULLFSBLOCK)
 			return 0;
 	}
 
-	error = xfs_alloc_vextent(args);
+	if (is_filestream)
+		error = xfs_alloc_vextent(args);
+	else
+		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	if (error)
 		return error;
 	if (args->fsbno != NULLFSBLOCK)
@@ -3696,9 +3702,7 @@ xfs_btalloc_nullfb(
 	 */
 	if (args->minlen > ap->minlen) {
 		args->minlen = ap->minlen;
-		args->type = XFS_ALLOCTYPE_START_BNO;
-		args->fsbno = ap->blkno;
-		error = xfs_alloc_vextent(args);
+		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 		if (error)
 			return error;
 	}
@@ -3735,10 +3739,7 @@ xfs_btalloc_low_mode(
 	args->total = args->minlen = ap->minlen;
 	if (xfs_inode_is_filestream(ap->ip))
 		return xfs_alloc_vextent_first_ag(args, ap->blkno);
-
-	args->fsbno = ap->blkno;
-	args->type = XFS_ALLOCTYPE_START_BNO;
-	return xfs_alloc_vextent(args);
+	return xfs_alloc_vextent_start_ag(args, ap->blkno);
 }
 
 /*
@@ -3763,7 +3764,8 @@ xfs_btalloc_near(
 	args->minlen = ap->minlen;
 
 	if (ap->aeof) {
-		error = xfs_btalloc_at_eof(ap, args, blen, stripe_align);
+		error = xfs_btalloc_at_eof(ap, args, blen, stripe_align,
+				true);
 		if (error)
 			return error;
 		if (args->fsbno != NULLFSBLOCK)
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index ab3877bf4aaf..cf4b19549334 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -216,8 +216,6 @@ xfs_bmbt_alloc_block(
 		return -ENOSPC;
 
 	if (args.fsbno == NULLFSBLOCK) {
-		args.fsbno = be64_to_cpu(start->l);
-		args.type = XFS_ALLOCTYPE_START_BNO;
 		/*
 		 * Make sure there is sufficient room left in the AG to
 		 * complete a full tree split for an extent insert.  If
@@ -230,7 +228,7 @@ xfs_bmbt_alloc_block(
 		 * block allocation here and corrupt the filesystem.
 		 */
 		args.minleft = args.tp->t_blk_res;
-		error = xfs_alloc_vextent(&args);
+		error = xfs_alloc_vextent_start_ag(&args, be64_to_cpu(start->l));
 		if (error)
 			goto error0;
 
@@ -246,8 +244,8 @@ xfs_bmbt_alloc_block(
 			cur->bc_tp->t_flags |= XFS_TRANS_LOWMODE;
 		}
 	} else if (cur->bc_tp->t_flags & XFS_TRANS_LOWMODE) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		error = xfs_alloc_vextent(&args);
+		error = xfs_alloc_vextent_start_ag(&args,
+				cur->bc_tp->t_firstblock);
 	} else {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.pag = xfs_perag_get(args.mp,
-- 
2.35.1

