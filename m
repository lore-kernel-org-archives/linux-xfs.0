Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5E5CCA480
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345228AbiFKB1k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349009AbiFKB1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:21 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89FE83A4813
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 79D7810E7214
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-005APM-Ry
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-00ELMk-Qx
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 27/50] xfs: factor xfs_bmap_btalloc()
Date:   Sat, 11 Jun 2022 11:26:36 +1000
Message-Id: <20220611012659.3418072-28-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=_SQKL7Lu6c1vmibDrAoA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There are several different contexts xfs_bmap_btalloc() handles,
and large chunks of the code execute individual contexts. For
example, "nullfb" and "low mode" are mutually exclusive, but the
code that handles them is deeply intertwined. Try to untangle this
mess a bit.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 475 +++++++++++++++++++++++----------------
 1 file changed, 277 insertions(+), 198 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 68e862a9d584..edb8f71674b2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3239,41 +3239,6 @@ xfs_bmap_select_minlen(
 	}
 }
 
-STATIC int
-xfs_bmap_btalloc_nullfb(
-	struct xfs_bmalloca	*ap,
-	struct xfs_alloc_arg	*args,
-	xfs_extlen_t		*blen)
-{
-	struct xfs_mount	*mp = ap->ip->i_mount;
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno, startag;
-	int			notinit = 0;
-	int			error = 0;
-
-	args->type = XFS_ALLOCTYPE_START_BNO;
-	args->total = ap->total;
-
-	startag = XFS_FSB_TO_AGNO(mp, args->fsbno);
-	if (startag == NULLAGNUMBER)
-		startag = 0;
-
-	*blen = 0;
-	for_each_perag_wrap(mp, startag, agno, pag) {
-		error = xfs_bmap_longest_free_extent(pag, args->tp, blen,
-						     &notinit);
-		if (error)
-			break;
-		if (*blen >= args->maxlen)
-			break;
-	}
-	if (pag)
-		xfs_perag_rele(pag);
-
-	xfs_bmap_select_minlen(ap, args, blen, notinit);
-	return 0;
-}
-
 STATIC int
 xfs_bmap_btalloc_filestreams(
 	struct xfs_bmalloca	*ap,
@@ -3544,202 +3509,316 @@ xfs_bmap_exact_minlen_extent_alloc(
 #define xfs_bmap_exact_minlen_extent_alloc(bma) (-EFSCORRUPTED)
 
 #endif
-
-STATIC int
-xfs_bmap_btalloc(
-	struct xfs_bmalloca	*ap)
+/*
+ * If we are not low on available data blocks and we are allocating at
+ * EOF, optimise allocation for contiguous file extension and/or stripe
+ * alignment of the new extent.
+ *
+ * NOTE: ap->aeof is only set if the allocation length is >= the
+ * stripe unit and the allocation offset is at the end of file.
+ */
+static int
+xfs_btalloc_at_eof(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_extlen_t		blen,
+	int			stripe_align)
 {
-	struct xfs_mount	*mp = ap->ip->i_mount;
-	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
-	xfs_alloctype_t		atype = 0;
-	xfs_agnumber_t		fb_agno;	/* ag number of ap->firstblock */
-	xfs_agnumber_t		ag;
-	xfs_fileoff_t		orig_offset;
-	xfs_extlen_t		orig_length;
-	xfs_extlen_t		blen;
-	xfs_extlen_t		nextminlen = 0;
-	int			nullfb; /* true if ap->firstblock isn't set */
-	int			isaligned;
+	struct xfs_mount	*mp = args->mp;
+	xfs_alloctype_t		atype;
 	int			error;
-	int			stripe_align;
-
-	ASSERT(ap->length);
-	orig_offset = ap->offset;
-	orig_length = ap->length;
-
-	stripe_align = xfs_bmap_compute_alignments(ap, &args);
-
-	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
-	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
-							ap->tp->t_firstblock);
-	if (nullfb) {
-		if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-		    xfs_inode_is_filestream(ap->ip)) {
-			ag = xfs_filestream_lookup_ag(ap->ip);
-			ag = (ag != NULLAGNUMBER) ? ag : 0;
-			ap->blkno = XFS_AGB_TO_FSB(mp, ag, 0);
-		} else {
-			ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
-		}
-	} else
-		ap->blkno = ap->tp->t_firstblock;
-
-	xfs_bmap_adjacent(ap);
 
 	/*
-	 * If allowed, use ap->blkno; otherwise must use firstblock since
-	 * it's in the right allocation group.
+	 * If there are already extents in the file, try an exact EOF block
+	 * allocation to extend the file as a contiguous extent. If that fails,
+	 * or it's the first allocation in a file, just try for a stripe aligned
+	 * allocation.
 	 */
-	if (nullfb || XFS_FSB_TO_AGNO(mp, ap->blkno) == fb_agno)
-		;
-	else
-		ap->blkno = ap->tp->t_firstblock;
-	/*
-	 * Normal allocation, done through xfs_alloc_vextent.
-	 */
-	isaligned = 0;
-	args.fsbno = ap->blkno;
-	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
+	if (ap->offset) {
+		xfs_extlen_t	nextminlen = 0;
+
+		atype = args->type;
+		args->type = XFS_ALLOCTYPE_THIS_BNO;
+		args->alignment = 1;
 
-	/* Trim the allocation back to the maximum an AG can fit. */
-	args.maxlen = min(ap->length, mp->m_ag_max_usable);
-	blen = 0;
-	if (nullfb) {
 		/*
-		 * Search for an allocation group with a single extent large
-		 * enough for the request.  If one isn't found, then adjust
-		 * the minimum allocation size to the largest space found.
+		 * Compute the minlen+alignment for the next case.  Set slop so
+		 * that the value of minlen+alignment+slop doesn't go up between
+		 * the calls.
 		 */
-		if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-		    xfs_inode_is_filestream(ap->ip))
-			error = xfs_bmap_btalloc_filestreams(ap, &args, &blen);
+		if (blen > stripe_align && blen <= args->maxlen)
+			nextminlen = blen - stripe_align;
 		else
-			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
+			nextminlen = args->minlen;
+		if (nextminlen + stripe_align > args->minlen + 1)
+			args->minalignslop = nextminlen + stripe_align -
+					args->minlen - 1;
+		else
+			args->minalignslop = 0;
+
+		args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, args->fsbno));
+		error = xfs_alloc_vextent_this_ag(args);
+		xfs_perag_put(args->pag);
 		if (error)
 			return error;
-	} else if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
-		if (xfs_inode_is_filestream(ap->ip))
-			args.type = XFS_ALLOCTYPE_FIRST_AG;
-		else
-			args.type = XFS_ALLOCTYPE_START_BNO;
-		args.total = args.minlen = ap->minlen;
+
+		if (args->fsbno != NULLFSBLOCK)
+			return 0;
+		/*
+		 * Exact allocation failed. Reset to try an aligned allocation
+		 * according to the original allocation specification.
+		 */
+		args->pag = NULL;
+		args->type = atype;
+		args->fsbno = ap->blkno;
+		args->alignment = stripe_align;
+		args->minlen = nextminlen;
+		args->minalignslop = 0;
 	} else {
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.total = ap->total;
-		args.minlen = ap->minlen;
+		args->alignment = stripe_align;
+		atype = args->type;
+		/*
+		 * Adjust minlen to try and preserve alignment if we
+		 * can't guarantee an aligned maxlen extent.
+		 */
+		if (blen > args->alignment &&
+		    blen <= args->maxlen + args->alignment)
+			args->minlen = blen - args->alignment;
+		args->minalignslop = 0;
 	}
-	args.minleft = ap->minleft;
-	args.wasdel = ap->wasdel;
-	args.resv = XFS_AG_RESV_NONE;
-	args.datatype = ap->datatype;
+
+	error = xfs_alloc_vextent(args);
+	if (error)
+		return error;
+
+	if (args->fsbno != NULLFSBLOCK)
+		return 0;
 
 	/*
-	 * If we are not low on available data blocks, and the underlying
-	 * logical volume manager is a stripe, and the file offset is zero then
-	 * try to allocate data blocks on stripe unit boundary. NOTE: ap->aeof
-	 * is only set if the allocation length is >= the stripe unit and the
-	 * allocation offset is at the end of file.
+	 * Allocation failed, so turn return the allocation args to their
+	 * original non-aligned state so the caller can proceed on allocation
+	 * failure as if this function was never called.
 	 */
-	if (!(ap->tp->t_flags & XFS_TRANS_LOWMODE) && ap->aeof) {
-		if (!ap->offset) {
-			args.alignment = stripe_align;
-			atype = args.type;
-			isaligned = 1;
-			/*
-			 * Adjust minlen to try and preserve alignment if we
-			 * can't guarantee an aligned maxlen extent.
-			 */
-			if (blen > args.alignment &&
-			    blen <= args.maxlen + args.alignment)
-				args.minlen = blen - args.alignment;
-			args.minalignslop = 0;
-		} else {
-			/*
-			 * First try an exact bno allocation.
-			 * If it fails then do a near or start bno
-			 * allocation with alignment turned on.
-			 */
-			atype = args.type;
-			args.type = XFS_ALLOCTYPE_THIS_BNO;
-			args.alignment = 1;
+	args->type = atype;
+	args->fsbno = ap->blkno;
+	args->alignment = 1;
+	return 0;
+}
 
-			/*
-			 * Compute the minlen+alignment for the
-			 * next case.  Set slop so that the value
-			 * of minlen+alignment+slop doesn't go up
-			 * between the calls.
-			 */
-			if (blen > stripe_align && blen <= args.maxlen)
-				nextminlen = blen - stripe_align;
-			else
-				nextminlen = args.minlen;
-			if (nextminlen + stripe_align > args.minlen + 1)
-				args.minalignslop =
-					nextminlen + stripe_align -
-					args.minlen - 1;
-			else
-				args.minalignslop = 0;
+static int
+xfs_btalloc_nullfb_bestlen(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_extlen_t		*blen)
+{
+	struct xfs_mount	*mp = args->mp;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno, startag;
+	int			notinit = 0;
+	int			error = 0;
 
-			args.pag = xfs_perag_get(mp,
-					XFS_FSB_TO_AGNO(mp, args.fsbno));
-			error = xfs_alloc_vextent_this_ag(&args);
-			xfs_perag_put(args.pag);
-			if (error)
-				return error;
+	args->type = XFS_ALLOCTYPE_START_BNO;
+	args->total = ap->total;
 
-			if (args.fsbno != NULLFSBLOCK)
-				goto out_success;
-			/*
-			 * Exact allocation failed. Now try with alignment
-			 * turned on.
-			 */
-			args.pag = NULL;
-			args.type = atype;
-			args.fsbno = ap->blkno;
-			args.alignment = stripe_align;
-			args.minlen = nextminlen;
-			args.minalignslop = 0;
-			isaligned = 1;
-		}
+	startag = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	if (startag == NULLAGNUMBER)
+		startag = 0;
+
+	*blen = 0;
+	for_each_perag_wrap(mp, startag, agno, pag) {
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen,
+						     &notinit);
+		if (error)
+			break;
+		if (*blen >= args->maxlen)
+			break;
+	}
+	if (pag)
+		xfs_perag_rele(pag);
+
+	xfs_bmap_select_minlen(ap, args, blen, notinit);
+	return 0;
+}
+
+static int
+xfs_btalloc_nullfb(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	int			stripe_align)
+{
+	struct xfs_mount	*mp = args->mp;
+	xfs_extlen_t		blen = 0;
+	int			error;
+
+	/*
+	 * Determine the initial block number we will target for allocation.
+	 */
+	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
+	    xfs_inode_is_filestream(ap->ip)) {
+		xfs_agnumber_t	agno = xfs_filestream_lookup_ag(ap->ip);
+		if (agno == NULLAGNUMBER)
+			agno = 0;
+		ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
 	} else {
-		args.alignment = 1;
-		args.minalignslop = 0;
+		ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
 	}
+	xfs_bmap_adjacent(ap);
+	args->fsbno = ap->blkno;
 
-	error = xfs_alloc_vextent(&args);
+	/*
+	 * Search for an allocation group with a single extent large enough for
+	 * the request.  If one isn't found, then adjust the minimum allocation
+	 * size to the largest space found.
+	 */
+	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
+	    xfs_inode_is_filestream(ap->ip))
+		error = xfs_bmap_btalloc_filestreams(ap, args, &blen);
+	else
+		error = xfs_btalloc_nullfb_bestlen(ap, args, &blen);
 	if (error)
 		return error;
 
-	if (isaligned && args.fsbno == NULLFSBLOCK) {
-		/*
-		 * allocation failed, so turn off alignment and
-		 * try again.
-		 */
-		args.type = atype;
-		args.fsbno = ap->blkno;
-		args.alignment = 0;
-		if ((error = xfs_alloc_vextent(&args)))
+	if (ap->aeof) {
+		error = xfs_btalloc_at_eof(ap, args, blen, stripe_align);
+		if (error)
 			return error;
+		if (args->fsbno != NULLFSBLOCK)
+			return 0;
 	}
-	if (args.fsbno == NULLFSBLOCK && nullfb &&
-	    args.minlen > ap->minlen) {
-		args.minlen = ap->minlen;
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		args.fsbno = ap->blkno;
-		if ((error = xfs_alloc_vextent(&args)))
+
+	error = xfs_alloc_vextent(args);
+	if (error)
+		return error;
+	if (args->fsbno != NULLFSBLOCK)
+		return 0;
+
+	/*
+	 * Try a locality first full filesystem minimum length allocation whilst
+	 * still maintaining necessary total block reservation requirements.
+	 */
+	if (args->minlen > ap->minlen) {
+		args->minlen = ap->minlen;
+		args->type = XFS_ALLOCTYPE_START_BNO;
+		args->fsbno = ap->blkno;
+		error = xfs_alloc_vextent(args);
+		if (error)
 			return error;
 	}
-	if (args.fsbno == NULLFSBLOCK && nullfb) {
-		args.fsbno = 0;
-		args.type = XFS_ALLOCTYPE_FIRST_AG;
-		args.total = ap->minlen;
-		if ((error = xfs_alloc_vextent(&args)))
+	if (args->fsbno != NULLFSBLOCK)
+		return 0;
+
+	/*
+	 * We are now critically low on space, so this is a last resort
+	 * allocation attempt: no reserve, no locality, blocking, minimum
+	 * length, full filesystem free space scan. We also indicate to future
+	 * allocations in this transaction that we are critically low on space
+	 * so they don't waste time on allocation modes that are unlikely to
+	 * succeed.
+	 */
+	args->fsbno = 0;
+	args->type = XFS_ALLOCTYPE_FIRST_AG;
+	args->total = ap->minlen;
+	error = xfs_alloc_vextent(args);
+	if (error)
+		return error;
+	ap->tp->t_flags |= XFS_TRANS_LOWMODE;
+	return 0;
+}
+
+/*
+ * We are near ENOSPC, so try an exhaustive minimum length allocation. If this
+ * fails, we really are at ENOSPC.
+ */
+static int
+xfs_btalloc_low_mode(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args)
+{
+	ap->blkno = ap->tp->t_firstblock;
+	xfs_bmap_adjacent(ap);
+	args->fsbno = ap->blkno;
+	args->total = args->minlen = ap->minlen;
+	if (xfs_inode_is_filestream(ap->ip))
+		args->type = XFS_ALLOCTYPE_FIRST_AG;
+	else
+		args->type = XFS_ALLOCTYPE_START_BNO;
+
+	return xfs_alloc_vextent(args);
+}
+
+/*
+ * Attempt to allocate near the current target. We attempt optimal EOF
+ * allocation, but then if that fails we simply try somewhere near in the same
+ * AG. If we can't get a block in the same AG, then we fail the allocation.
+ */
+static int
+xfs_btalloc_near(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	int			stripe_align)
+{
+	xfs_extlen_t		blen = 0;
+	int			error;
+
+	ap->blkno = ap->tp->t_firstblock;
+	xfs_bmap_adjacent(ap);
+	args->fsbno = ap->blkno;
+	args->type = XFS_ALLOCTYPE_NEAR_BNO;
+	args->total = ap->total;
+	args->minlen = ap->minlen;
+
+	if (ap->aeof) {
+		error = xfs_btalloc_at_eof(ap, args, blen, stripe_align);
+		if (error)
 			return error;
-		ap->tp->t_flags |= XFS_TRANS_LOWMODE;
+		if (args->fsbno != NULLFSBLOCK)
+			return 0;
 	}
+	return xfs_alloc_vextent(args);
+}
+
+STATIC int
+xfs_bmap_btalloc(
+	struct xfs_bmalloca	*ap)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_alloc_arg	args = {
+		.tp		= ap->tp,
+		.mp		= mp,
+		.fsbno		= NULLFSBLOCK,
+		.oinfo		= XFS_RMAP_OINFO_SKIP_UPDATE,
+		.minleft	= ap->minleft,
+		.wasdel		= ap->wasdel,
+		.resv		= XFS_AG_RESV_NONE,
+		.datatype	= ap->datatype,
+		.alignment	= 1,
+		.minalignslop	= 0,
+	};
+	xfs_fileoff_t		orig_offset;
+	xfs_extlen_t		orig_length;
+	int			error;
+	int			stripe_align;
+
+	ASSERT(ap->length);
+	orig_offset = ap->offset;
+	orig_length = ap->length;
+
+	stripe_align = xfs_bmap_compute_alignments(ap, &args);
+
+	/* Trim the allocation back to the maximum an AG can fit. */
+	args.maxlen = min(ap->length, mp->m_ag_max_usable);
+
+	if (ap->tp->t_firstblock == NULLFSBLOCK) {
+		error = xfs_btalloc_nullfb(ap, &args, stripe_align);
+	} else if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
+		error = xfs_btalloc_low_mode(ap, &args);
+	} else {
+		error = xfs_btalloc_near(ap, &args, stripe_align);
+	}
+	if (error)
+		return error;
 
 	if (args.fsbno != NULLFSBLOCK) {
-out_success:
 		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
 			orig_length);
 	} else {
-- 
2.35.1

