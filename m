Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6C4CCA47B
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347415AbiFKB13 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239210AbiFKB1T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:19 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C994E3FB131
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 20AED5EC7F7
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005APh-30
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELNI-1x
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 34/50] xfs: fold xfs_alloc_ag_vextent() into callers
Date:   Sat, 11 Jun 2022 11:26:43 +1000
Message-Id: <20220611012659.3418072-35-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=Hfmiz4SQFC9lsfJXRUIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We don't need the multiplexing xfs_alloc_ag_vextent() provided
anymore - we can just call the exact/near/size variants directly.
This allows us to remove args->type completely and stop using
args->fsbno as an input to the allocator algorithms.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 97 ++++++++-------------------------------
 fs/xfs/libxfs/xfs_alloc.h | 17 -------
 fs/xfs/libxfs/xfs_bmap.c  | 10 +---
 fs/xfs/xfs_trace.h        |  8 +---
 4 files changed, 23 insertions(+), 109 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 1590e9142f7e..a3ce5f28f84b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -36,10 +36,6 @@ struct workqueue_struct *xfs_alloc_wq;
 #define	XFSA_FIXUP_BNO_OK	1
 #define	XFSA_FIXUP_CNT_OK	2
 
-STATIC int xfs_alloc_ag_vextent_exact(xfs_alloc_arg_t *);
-STATIC int xfs_alloc_ag_vextent_near(xfs_alloc_arg_t *);
-STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
-
 /*
  * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of slots in
  * the beginning of the block for a proper header with the location information
@@ -776,8 +772,6 @@ xfs_alloc_cur_setup(
 	int			error;
 	int			i;
 
-	ASSERT(args->alignment == 1 || args->type != XFS_ALLOCTYPE_THIS_BNO);
-
 	acur->cur_len = args->maxlen;
 	acur->rec_bno = 0;
 	acur->rec_len = 0;
@@ -891,7 +885,6 @@ xfs_alloc_cur_check(
 	 * We have an aligned record that satisfies minlen and beats or matches
 	 * the candidate extent size. Compare locality for near allocation mode.
 	 */
-	ASSERT(args->type == XFS_ALLOCTYPE_NEAR_BNO);
 	diff = xfs_alloc_compute_diff(args->agbno, args->len,
 				      args->alignment, args->datatype,
 				      bnoa, lena, &bnew);
@@ -1136,40 +1129,6 @@ xfs_alloc_ag_vextent_small(
 	return error;
 }
 
-/*
- * Allocate a variable extent in the allocation group agno.
- * Type and bno are used to determine where in the allocation group the
- * extent will start.
- * Extent's length (returned in *len) will be between minlen and maxlen,
- * and of the form k * prod + mod unless there's nothing that large.
- * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
- */
-static int
-xfs_alloc_ag_vextent(
-	struct xfs_alloc_arg	*args)
-{
-	int			error = 0;
-
-	/*
-	 * Branch to correct routine based on the type.
-	 */
-	switch (args->type) {
-	case XFS_ALLOCTYPE_THIS_AG:
-		error = xfs_alloc_ag_vextent_size(args);
-		break;
-	case XFS_ALLOCTYPE_NEAR_BNO:
-		error = xfs_alloc_ag_vextent_near(args);
-		break;
-	case XFS_ALLOCTYPE_THIS_BNO:
-		error = xfs_alloc_ag_vextent_exact(args);
-		break;
-	default:
-		ASSERT(0);
-		/* NOTREACHED */
-	}
-	return error;
-}
-
 /*
  * Allocate a variable extent at exactly agno/bno.
  * Extent's length (returned in *len) will be between minlen and maxlen,
@@ -1355,7 +1314,6 @@ xfs_alloc_ag_vextent_locality(
 	bool			fbinc;
 
 	ASSERT(acur->len == 0);
-	ASSERT(args->type == XFS_ALLOCTYPE_NEAR_BNO);
 
 	*stat = 0;
 
@@ -3140,6 +3098,7 @@ xfs_alloc_vextent_check_args(
 	xfs_agblock_t		agsize;
 
 	args->agbno = NULLAGBLOCK;
+	args->fsbno = NULLFSBLOCK;
 
 	/*
 	 * Just fix this up, for the case where the last a.g. is shorter
@@ -3262,8 +3221,11 @@ xfs_alloc_vextent_finish(
 }
 
 /*
- * Allocate within a single AG only. Caller is expected to hold a
- * perag reference in args->pag.
+ * Allocate within a single AG only. This uses a best-fit length algorithm so if
+ * you need an exact sized allocation without locality constraints, this is the
+ * fastest way to do it.
+ *
+ * Caller is expected to hold a perag reference in args->pag.
  */
 int
 xfs_alloc_vextent_this_ag(
@@ -3272,9 +3234,8 @@ xfs_alloc_vextent_this_ag(
 {
 	struct xfs_mount	*mp = args->mp;
 	int			error;
-	xfs_rfsblock_t		target = XFS_AGB_TO_FSB(mp, agno, 0);
 
-	error = xfs_alloc_vextent_check_args(args, target);
+	error = xfs_alloc_vextent_check_args(args, XFS_AGB_TO_FSB(mp, agno, 0));
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
@@ -3283,14 +3244,12 @@ xfs_alloc_vextent_this_ag(
 
 	args->agno = agno;
 	args->agbno = 0;
-	args->fsbno = target;
-	args->type = XFS_ALLOCTYPE_THIS_AG;
 	error = xfs_alloc_vextent_prepare_ag(args);
 	if (error)
 		return error;
 
 	if (args->agbp) {
-		error = xfs_alloc_ag_vextent(args);
+		error = xfs_alloc_ag_vextent_size(args);
 		if (error)
 			return error;
 	}
@@ -3320,6 +3279,7 @@ static int
 xfs_alloc_vextent_iterate_ags(
 	struct xfs_alloc_arg	*args,
 	xfs_agnumber_t		start_agno,
+	xfs_agblock_t		target_agbno,
 	uint32_t		flags)
 {
 	struct xfs_mount	*mp = args->mp;
@@ -3331,8 +3291,8 @@ xfs_alloc_vextent_iterate_ags(
 	 */
 	args->agno = start_agno;
 	for (;;) {
+		args->agbno = target_agbno;
 		args->pag = xfs_perag_get(args->mp, args->agno);
-		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
 		error = xfs_alloc_vextent_prepare_ag(args);
 		if (error)
 			break;
@@ -3342,16 +3302,15 @@ xfs_alloc_vextent_iterate_ags(
 			 * Allocation is supposed to succeed now, so break out
 			 * of the loop regardless of whether we succeed or not.
 			 */
-			error = xfs_alloc_ag_vextent(args);
+			if (args->agno == start_agno && target_agbno)
+				error = xfs_alloc_ag_vextent_near(args);
+			else
+				error = xfs_alloc_ag_vextent_size(args);
 			break;
 		}
 
 		trace_xfs_alloc_vextent_loopfailed(args);
 
-		if (args->agno == start_agno &&
-		    args->otype == XFS_ALLOCTYPE_NEAR_BNO)
-			args->type = XFS_ALLOCTYPE_THIS_AG;
-
 		/*
 		* For the first allocation, we can try any AG to get
 		* space.  However, if we already have allocated a
@@ -3375,10 +3334,7 @@ xfs_alloc_vextent_iterate_ags(
 				trace_xfs_alloc_vextent_allfailed(args);
 				break;
 			}
-
 			flags = 0;
-			if (args->otype == XFS_ALLOCTYPE_NEAR_BNO)
-				args->type = XFS_ALLOCTYPE_NEAR_BNO;
 		}
 		xfs_perag_put(args->pag);
 		args->pag = NULL;
@@ -3404,8 +3360,8 @@ xfs_alloc_vextent_start_ag(
 	xfs_rfsblock_t		target)
 {
 	struct xfs_mount	*mp = args->mp;
-	xfs_agnumber_t		start_agno;
 	xfs_agnumber_t		rotorstep = xfs_rotorstep;
+	xfs_agnumber_t		start_agno = XFS_FSB_TO_AGNO(mp, target);
 	bool			bump_rotor = false;
 	int			error;
 
@@ -3424,14 +3380,8 @@ xfs_alloc_vextent_start_ag(
 		bump_rotor = 1;
 	}
 
-	start_agno = XFS_FSB_TO_AGNO(mp, target);
-	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
-	args->otype = XFS_ALLOCTYPE_NEAR_BNO;
-	args->type = XFS_ALLOCTYPE_NEAR_BNO;
-	args->fsbno = target;
-
 	error = xfs_alloc_vextent_iterate_ags(args, start_agno,
-			XFS_ALLOC_FLAG_TRYLOCK);
+			XFS_FSB_TO_AGBNO(mp, target), XFS_ALLOC_FLAG_TRYLOCK);
 	if (!error)
 		error = xfs_alloc_vextent_finish(args);
 	if (args->pag) {
@@ -3471,10 +3421,8 @@ xfs_alloc_vextent_first_ag(
 		return error;
 	}
 
-	args->type = XFS_ALLOCTYPE_THIS_AG;
-	args->fsbno = target;
-	error =  xfs_alloc_vextent_iterate_ags(args,
-			XFS_FSB_TO_AGNO(mp, args->fsbno), 0);
+	error = xfs_alloc_vextent_iterate_ags(args,
+			XFS_FSB_TO_AGNO(mp, target), 0, 0);
 	if (!error)
 		error = xfs_alloc_vextent_finish(args);
 	if (args->pag) {
@@ -3505,15 +3453,12 @@ xfs_alloc_vextent_exact_bno(
 
 	args->agno = XFS_FSB_TO_AGNO(mp, target);
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
-	args->fsbno = target;
-	args->type = XFS_ALLOCTYPE_THIS_BNO;
-
 	error = xfs_alloc_vextent_prepare_ag(args);
 	if (error)
 		return error;
 
 	if (args->agbp)
-		error = xfs_alloc_ag_vextent(args);
+		error = xfs_alloc_ag_vextent_exact(args);
 	if (!error)
 		error = xfs_alloc_vextent_finish(args);
 	return error;
@@ -3543,14 +3488,12 @@ xfs_alloc_vextent_near_bno(
 
 	args->agno = XFS_FSB_TO_AGNO(mp, target);
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
-	args->type = XFS_ALLOCTYPE_NEAR_BNO;
-
 	error = xfs_alloc_vextent_prepare_ag(args);
 	if (error)
 		return error;
 
 	if (args->agbp)
-		error = xfs_alloc_ag_vextent(args);
+		error = xfs_alloc_ag_vextent_near(args);
 	if (!error)
 		error = xfs_alloc_vextent_finish(args);
 	if (need_pag)
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 106b4deb1110..689419409e09 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -16,21 +16,6 @@ extern struct workqueue_struct *xfs_alloc_wq;
 
 unsigned int xfs_agfl_size(struct xfs_mount *mp);
 
-/*
- * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
- */
-#define XFS_ALLOCTYPE_THIS_AG	0x08	/* anywhere in this a.g. */
-#define XFS_ALLOCTYPE_NEAR_BNO	0x20	/* in this a.g. and near this block */
-#define XFS_ALLOCTYPE_THIS_BNO	0x40	/* at exactly this block */
-
-/* this should become an enum again when the tracing code is fixed */
-typedef unsigned int xfs_alloctype_t;
-
-#define XFS_ALLOC_TYPES \
-	{ XFS_ALLOCTYPE_THIS_AG,	"THIS_AG" }, \
-	{ XFS_ALLOCTYPE_NEAR_BNO,	"NEAR_BNO" }, \
-	{ XFS_ALLOCTYPE_THIS_BNO,	"THIS_BNO" }
-
 /*
  * Flags for xfs_alloc_fix_freelist.
  */
@@ -64,8 +49,6 @@ typedef struct xfs_alloc_arg {
 	xfs_agblock_t	min_agbno;	/* set an agbno range for NEAR allocs */
 	xfs_agblock_t	max_agbno;	/* ... */
 	xfs_extlen_t	len;		/* output: actual size of extent */
-	xfs_alloctype_t	type;		/* allocation type XFS_ALLOCTYPE_... */
-	xfs_alloctype_t	otype;		/* original allocation type */
 	int		datatype;	/* mask defining data type treatment */
 	char		wasdel;		/* set if allocation was prev delayed */
 	char		wasfromfl;	/* set if allocation is from freelist */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 48a608e3c458..a6d3157ae896 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3510,7 +3510,6 @@ xfs_btalloc_at_eof(
 	bool			ag_only)
 {
 	struct xfs_mount	*mp = args->mp;
-	xfs_alloctype_t		atype;
 	int			error;
 
 	/*
@@ -3522,14 +3521,12 @@ xfs_btalloc_at_eof(
 	if (ap->offset) {
 		xfs_extlen_t	nextminlen = 0;
 
-		atype = args->type;
-		args->alignment = 1;
-
 		/*
 		 * Compute the minlen+alignment for the next case.  Set slop so
 		 * that the value of minlen+alignment+slop doesn't go up between
 		 * the calls.
 		 */
+		args->alignment = 1;
 		if (blen > stripe_align && blen <= args->maxlen)
 			nextminlen = blen - stripe_align;
 		else
@@ -3553,17 +3550,15 @@ xfs_btalloc_at_eof(
 		 * according to the original allocation specification.
 		 */
 		args->pag = NULL;
-		args->type = atype;
 		args->alignment = stripe_align;
 		args->minlen = nextminlen;
 		args->minalignslop = 0;
 	} else {
-		args->alignment = stripe_align;
-		atype = args->type;
 		/*
 		 * Adjust minlen to try and preserve alignment if we
 		 * can't guarantee an aligned maxlen extent.
 		 */
+		args->alignment = stripe_align;
 		if (blen > args->alignment &&
 		    blen <= args->maxlen + args->alignment)
 			args->minlen = blen - args->alignment;
@@ -3585,7 +3580,6 @@ xfs_btalloc_at_eof(
 	 * original non-aligned state so the caller can proceed on allocation
 	 * failure as if this function was never called.
 	 */
-	args->type = atype;
 	args->fsbno = ap->blkno;
 	args->alignment = 1;
 	return 0;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index cacef4eecac0..686d6078e936 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1795,8 +1795,6 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__field(xfs_extlen_t, alignment)
 		__field(xfs_extlen_t, minalignslop)
 		__field(xfs_extlen_t, len)
-		__field(short, type)
-		__field(short, otype)
 		__field(char, wasdel)
 		__field(char, wasfromfl)
 		__field(int, resv)
@@ -1816,8 +1814,6 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__entry->alignment = args->alignment;
 		__entry->minalignslop = args->minalignslop;
 		__entry->len = args->len;
-		__entry->type = args->type;
-		__entry->otype = args->otype;
 		__entry->wasdel = args->wasdel;
 		__entry->wasfromfl = args->wasfromfl;
 		__entry->resv = args->resv;
@@ -1826,7 +1822,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 	),
 	TP_printk("dev %d:%d agno 0x%x agbno 0x%x minlen %u maxlen %u mod %u "
 		  "prod %u minleft %u total %u alignment %u minalignslop %u "
-		  "len %u type %s otype %s wasdel %d wasfromfl %d resv %d "
+		  "len %u wasdel %d wasfromfl %d resv %d "
 		  "datatype 0x%x firstblock 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
@@ -1840,8 +1836,6 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		  __entry->alignment,
 		  __entry->minalignslop,
 		  __entry->len,
-		  __print_symbolic(__entry->type, XFS_ALLOC_TYPES),
-		  __print_symbolic(__entry->otype, XFS_ALLOC_TYPES),
 		  __entry->wasdel,
 		  __entry->wasfromfl,
 		  __entry->resv,
-- 
2.35.1

