Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F38C4167D
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377751AbhLCAFD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:05:03 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:60014 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377754AbhLCAFC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:05:02 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 408DA606877
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:25 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00G1LF-8j
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00BkiS-7f
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 28/36] xfs: use xfs_alloc_vextent_first_ag() where appropriate
Date:   Fri,  3 Dec 2021 11:01:03 +1100
Message-Id: <20211203000111.2800982-29-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61a95e55
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=ZYJNKcoVrom5moMyh1QA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Change obvious callers of single AG allocation to use
xfs_alloc_vextent_first_ag(). This gets rid of
XFS_ALLOCTYPE_FIRST_AG as the type used within
xfs_alloc_vextent_first_ag() during iteration is _THIS_AG. Hence we
can remove the setting of args->type from all the callers of
_first_ag() and remove the alloctype.

While doing this, pass the allocation target fsb as a parameter
rather than encoding it in args->fsbno. This starts the process
of making args->fsbno an output only variable rather than
input/output.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c      | 26 ++++++++++++++------------
 fs/xfs/libxfs/xfs_alloc.h      | 10 ++++++++--
 fs/xfs/libxfs/xfs_bmap.c       | 15 +++++----------
 fs/xfs/libxfs/xfs_bmap_btree.c |  4 +---
 4 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 78a9cd543a2d..946899a5e3cb 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3168,7 +3168,8 @@ xfs_alloc_read_agf(
  */
 static int
 xfs_alloc_vextent_check_args(
-	struct xfs_alloc_arg	*args)
+	struct xfs_alloc_arg	*args,
+	xfs_rfsblock_t		target)
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_agblock_t		agsize;
@@ -3186,13 +3187,13 @@ xfs_alloc_vextent_check_args(
 		args->maxlen = agsize;
 	if (args->alignment == 0)
 		args->alignment = 1;
-	ASSERT(XFS_FSB_TO_AGNO(mp, args->fsbno) < mp->m_sb.sb_agcount);
-	ASSERT(XFS_FSB_TO_AGBNO(mp, args->fsbno) < agsize);
+	ASSERT(XFS_FSB_TO_AGNO(mp, target) < mp->m_sb.sb_agcount);
+	ASSERT(XFS_FSB_TO_AGBNO(mp, target) < agsize);
 	ASSERT(args->minlen <= args->maxlen);
 	ASSERT(args->minlen <= agsize);
 	ASSERT(args->mod < args->prod);
-	if (XFS_FSB_TO_AGNO(mp, args->fsbno) >= mp->m_sb.sb_agcount ||
-	    XFS_FSB_TO_AGBNO(mp, args->fsbno) >= agsize ||
+	if (XFS_FSB_TO_AGNO(mp, target) >= mp->m_sb.sb_agcount ||
+	    XFS_FSB_TO_AGBNO(mp, target) >= agsize ||
 	    args->minlen > args->maxlen || args->minlen > agsize ||
 	    args->mod >= args->prod) {
 		args->fsbno = NULLFSBLOCK;
@@ -3201,6 +3202,7 @@ xfs_alloc_vextent_check_args(
 	}
 	return 0;
 }
+
 /*
  * Post-process allocation results to set the allocated block number correctly
  * for the caller.
@@ -3239,7 +3241,7 @@ xfs_alloc_vextent_this_ag(
 	struct xfs_mount	*mp = args->mp;
 	int			error;
 
-	error = xfs_alloc_vextent_check_args(args);
+	error = xfs_alloc_vextent_check_args(args, args->fsbno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
@@ -3353,7 +3355,7 @@ xfs_alloc_vextent_start_ag(
 	bool			bump_rotor = false;
 	int			error;
 
-	error = xfs_alloc_vextent_check_args(args);
+	error = xfs_alloc_vextent_check_args(args, args->fsbno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
@@ -3394,14 +3396,15 @@ xfs_alloc_vextent_start_ag(
  * filesystem attempting blocking allocation. This does not wrap or try a second
  * pass, so will not recurse into AGs lower than indicated by fsbno.
  */
-static int
+int
 xfs_alloc_vextent_first_ag(
-	struct xfs_alloc_arg	*args)
+	struct xfs_alloc_arg	*args,
+	xfs_rfsblock_t		target)
 {
 	struct xfs_mount	*mp = args->mp;
 	int			error;
 
-	error = xfs_alloc_vextent_check_args(args);
+	error = xfs_alloc_vextent_check_args(args, target);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
@@ -3409,6 +3412,7 @@ xfs_alloc_vextent_first_ag(
 	}
 
 	args->type = XFS_ALLOCTYPE_THIS_AG;
+	args->fsbno = target;
 	error =  xfs_alloc_vextent_iterate_ags(args,
 			XFS_FSB_TO_AGNO(mp, args->fsbno), 0);
 	if (error)
@@ -3437,8 +3441,6 @@ xfs_alloc_vextent(
 		return error;
 	case XFS_ALLOCTYPE_START_BNO:
 		return xfs_alloc_vextent_start_ag(args);
-	case XFS_ALLOCTYPE_FIRST_AG:
-		return xfs_alloc_vextent_first_ag(args);
 	default:
 		ASSERT(0);
 		/* NOTREACHED */
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 7baf65a23e6e..1b47c48c6060 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -19,7 +19,6 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
 /*
  * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
  */
-#define XFS_ALLOCTYPE_FIRST_AG	0x02	/* ... start at ag 0 */
 #define XFS_ALLOCTYPE_THIS_AG	0x08	/* anywhere in this a.g. */
 #define XFS_ALLOCTYPE_START_BNO	0x10	/* near this block else anywhere */
 #define XFS_ALLOCTYPE_NEAR_BNO	0x20	/* in this a.g. and near this block */
@@ -29,7 +28,6 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
 typedef unsigned int xfs_alloctype_t;
 
 #define XFS_ALLOC_TYPES \
-	{ XFS_ALLOCTYPE_FIRST_AG,	"FIRST_AG" }, \
 	{ XFS_ALLOCTYPE_THIS_AG,	"THIS_AG" }, \
 	{ XFS_ALLOCTYPE_START_BNO,	"START_BNO" }, \
 	{ XFS_ALLOCTYPE_NEAR_BNO,	"NEAR_BNO" }, \
@@ -131,6 +129,14 @@ xfs_alloc_vextent(
  */
 int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
 
+/*
+ * Iterate from the AG indicated from args->fsbno through to the end of the
+ * filesystem attempting blocking allocation. This is for use in last
+ * resort allocation attempts when everything else has failed.
+ */
+int xfs_alloc_vextent_first_ag(struct xfs_alloc_arg *args,
+		xfs_rfsblock_t target);
+
 /*
  * Free an extent.
  */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5bf3f0856d2a..52e00ce478e1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3478,9 +3478,7 @@ xfs_bmap_exact_minlen_extent_alloc(
 		ap->blkno = ap->tp->t_firstblock;
 	}
 
-	args.fsbno = ap->blkno;
 	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
-	args.type = XFS_ALLOCTYPE_FIRST_AG;
 	args.minlen = args.maxlen = ap->minlen;
 	args.total = ap->total;
 
@@ -3492,7 +3490,7 @@ xfs_bmap_exact_minlen_extent_alloc(
 	args.resv = XFS_AG_RESV_NONE;
 	args.datatype = ap->datatype;
 
-	error = xfs_alloc_vextent(&args);
+	error = xfs_alloc_vextent_first_ag(&args, ap->blkno);
 	if (error)
 		return error;
 
@@ -3717,10 +3715,8 @@ xfs_btalloc_nullfb(
 	 * so they don't waste time on allocation modes that are unlikely to
 	 * succeed.
 	 */
-	args->fsbno = 0;
-	args->type = XFS_ALLOCTYPE_FIRST_AG;
 	args->total = ap->minlen;
-	error = xfs_alloc_vextent(args);
+	error = xfs_alloc_vextent_first_ag(args, 0);
 	if (error)
 		return error;
 	ap->tp->t_flags |= XFS_TRANS_LOWMODE;
@@ -3738,13 +3734,12 @@ xfs_btalloc_low_mode(
 {
 	ap->blkno = ap->tp->t_firstblock;
 	xfs_bmap_adjacent(ap);
-	args->fsbno = ap->blkno;
 	args->total = args->minlen = ap->minlen;
 	if (xfs_inode_is_filestream(ap->ip))
-		args->type = XFS_ALLOCTYPE_FIRST_AG;
-	else
-		args->type = XFS_ALLOCTYPE_START_BNO;
+		return xfs_alloc_vextent_first_ag(args, ap->blkno);
 
+	args->fsbno = ap->blkno;
+	args->type = XFS_ALLOCTYPE_START_BNO;
 	return xfs_alloc_vextent(args);
 }
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index d7b1016355de..16899345a535 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -240,9 +240,7 @@ xfs_bmbt_alloc_block(
 			 * satisfy a full btree split.  Try again and if
 			 * successful activate the lowspace algorithm.
 			 */
-			args.fsbno = 0;
-			args.type = XFS_ALLOCTYPE_FIRST_AG;
-			error = xfs_alloc_vextent(&args);
+			error = xfs_alloc_vextent_first_ag(&args, 0);
 			if (error)
 				goto error0;
 			cur->bc_tp->t_flags |= XFS_TRANS_LOWMODE;
-- 
2.33.0

