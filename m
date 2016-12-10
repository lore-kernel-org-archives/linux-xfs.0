Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48924 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751246AbcLJQW3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Dec 2016 11:22:29 -0500
Date: Sat, 10 Dec 2016 17:22:26 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: take indirect blocks into accounting when
        selecting an AG
Message-ID: <20161210162226.GA3204@lst.de>
References: <1481303709-12632-1-git-send-email-hch@lst.de> <20161209173213.GZ16813@birch.djwong.org> <20161209174145.GA15960@lst.de> <20161209214651.GR4326@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161209214651.GR4326@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, eguan@redhat.com

On Sat, Dec 10, 2016 at 08:46:51AM +1100, Dave Chinner wrote:
> I'm pretty sure these cases were added as a mechanism to prevent
> ENOSPC occurrences during delalloc conversion when, in the general
> case, the allocation would have succeeded. i.e. "in most cases the
> BMBT is not going to change shape, so let's just ignore the blocks
> that might be needed for that and hope we don't need them".

... and it it doesn't work we'll shut down the filesystem due to an
error inside a dirty transaction.  Anyway, the history and git-blame
say that this behavior has been there since day one.

> I'd just set it according to maxlen. I don't really care if we can't
> allocate the last few blocks in an AG for certain types of
> allocation - the failure fallbacks should drop back to an allocation
> attempt of maxlen = minlen and we can set minleft accordingly
> for those. If it still fails, then we really have ENOSPC...

I tried a patch doing that yesterday, but we still quickly hit
the failure in xfs/109. I must have messed up something and need
to review the whole are a bit more.  Here is that patch for reference:
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index effb64c..2722c66 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2634,12 +2634,10 @@ xfs_alloc_vextent(
 	xfs_agblock_t	agsize;	/* allocation group size */
 	int		error;
 	int		flags;	/* XFS_ALLOC_FLAG_... locking flags */
-	xfs_extlen_t	minleft;/* minimum left value, temp copy */
 	xfs_mount_t	*mp;	/* mount structure pointer */
 	xfs_agnumber_t	sagno;	/* starting allocation group number */
 	xfs_alloctype_t	type;	/* input allocation type */
 	int		bump_rotor = 0;
-	int		no_min = 0;
 	xfs_agnumber_t	rotorstep = xfs_rotorstep; /* inode32 agf stepper */
 
 	mp = args->mp;
@@ -2668,7 +2666,6 @@ xfs_alloc_vextent(
 		trace_xfs_alloc_vextent_badargs(args);
 		return 0;
 	}
-	minleft = args->minleft;
 
 	switch (type) {
 	case XFS_ALLOCTYPE_THIS_AG:
@@ -2679,9 +2676,7 @@ xfs_alloc_vextent(
 		 */
 		args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 		args->pag = xfs_perag_get(mp, args->agno);
-		args->minleft = 0;
 		error = xfs_alloc_fix_freelist(args, 0);
-		args->minleft = minleft;
 		if (error) {
 			trace_xfs_alloc_vextent_nofix(args);
 			goto error0;
@@ -2746,9 +2741,7 @@ xfs_alloc_vextent(
 		 */
 		for (;;) {
 			args->pag = xfs_perag_get(mp, args->agno);
-			if (no_min) args->minleft = 0;
 			error = xfs_alloc_fix_freelist(args, flags);
-			args->minleft = minleft;
 			if (error) {
 				trace_xfs_alloc_vextent_nofix(args);
 				goto error0;
@@ -2788,20 +2781,17 @@ xfs_alloc_vextent(
 			 * or switch to non-trylock mode.
 			 */
 			if (args->agno == sagno) {
-				if (no_min == 1) {
+				if (flags == 0) {
 					args->agbno = NULLAGBLOCK;
 					trace_xfs_alloc_vextent_allfailed(args);
 					break;
 				}
-				if (flags == 0) {
-					no_min = 1;
-				} else {
-					flags = 0;
-					if (type == XFS_ALLOCTYPE_START_BNO) {
-						args->agbno = XFS_FSB_TO_AGBNO(mp,
-							args->fsbno);
-						args->type = XFS_ALLOCTYPE_NEAR_BNO;
-					}
+
+				flags = 0;
+				if (type == XFS_ALLOCTYPE_START_BNO) {
+					args->agbno = XFS_FSB_TO_AGBNO(mp,
+						args->fsbno);
+					args->type = XFS_ALLOCTYPE_NEAR_BNO;
 				}
 			}
 			xfs_perag_put(args->pag);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6f28814..b6aaa26 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3758,7 +3758,8 @@ xfs_bmap_btalloc(
 		args.alignment = 1;
 		args.minalignslop = 0;
 	}
-	args.minleft = ap->minleft;
+	ASSERT(args.total);
+	args.minleft = xfs_bmap_worst_indlen(ap->ip, args.total);
 	args.wasdel = ap->wasdel;
 	args.resv = XFS_AG_RESV_NONE;
 	args.datatype = ap->datatype;
@@ -3806,7 +3807,8 @@ xfs_bmap_btalloc(
 		args.fsbno = 0;
 		args.type = XFS_ALLOCTYPE_FIRST_AG;
 		args.total = ap->minlen;
-		args.minleft = 0;
+		ASSERT(args.total);
+		args.minleft = xfs_bmap_worst_indlen(ap->ip, args.total);
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 		ap->dfops->dop_low = true;
@@ -4338,8 +4340,6 @@ xfs_bmapi_allocate(
 	if (error)
 		return error;
 
-	if (bma->dfops->dop_low)
-		bma->minleft = 0;
 	if (bma->cur)
 		bma->cur->bc_private.b.firstblock = *bma->firstblock;
 	if (bma->blkno == NULLFSBLOCK)
@@ -4569,15 +4569,6 @@ xfs_bmapi_write(
 
 	XFS_STATS_INC(mp, xs_blk_mapw);
 
-	if (*firstblock == NULLFSBLOCK) {
-		if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE)
-			bma.minleft = be16_to_cpu(ifp->if_broot->bb_level) + 1;
-		else
-			bma.minleft = 1;
-	} else {
-		bma.minleft = 0;
-	}
-
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
 		if (error)
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index cecd094..92e6755 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -49,7 +49,6 @@ struct xfs_bmalloca {
 
 	xfs_extlen_t		total;	/* total blocks needed for xaction */
 	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
-	xfs_extlen_t		minleft; /* amount must be left after alloc */
 	bool			eof;	/* set if allocating past last extent */
 	bool			wasdel;	/* replacing a delayed allocation */
 	bool			aeof;	/* allocated space at eof */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 8007d2b..c33eddb 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -455,18 +455,6 @@ xfs_bmbt_alloc_block(
 		args.fsbno = be64_to_cpu(start->l);
 try_another_ag:
 		args.type = XFS_ALLOCTYPE_START_BNO;
-		/*
-		 * Make sure there is sufficient room left in the AG to
-		 * complete a full tree split for an extent insert.  If
-		 * we are converting the middle part of an extent then
-		 * we may need space for two tree splits.
-		 *
-		 * We are relying on the caller to make the correct block
-		 * reservation for this operation to succeed.  If the
-		 * reservation amount is insufficient then we may fail a
-		 * block allocation here and corrupt the filesystem.
-		 */
-		args.minleft = args.tp->t_blk_res;
 	} else if (cur->bc_private.b.dfops->dop_low) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else {
@@ -499,20 +487,6 @@ try_another_ag:
 		goto try_another_ag;
 	}
 
-	if (args.fsbno == NULLFSBLOCK && args.minleft) {
-		/*
-		 * Could not find an AG with enough free space to satisfy
-		 * a full btree split.  Try again without minleft and if
-		 * successful activate the lowspace algorithm.
-		 */
-		args.fsbno = 0;
-		args.type = XFS_ALLOCTYPE_FIRST_AG;
-		args.minleft = 0;
-		error = xfs_alloc_vextent(&args);
-		if (error)
-			goto error0;
-		cur->bc_private.b.dfops->dop_low = true;
-	}
 	if (args.fsbno == NULLFSBLOCK) {
 		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 		*stat = 0;
