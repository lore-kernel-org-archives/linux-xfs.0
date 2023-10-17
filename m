Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A058ECDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344183AbjJQPyO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344137AbjJQPyN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:54:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010C09E
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:54:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCDFC433C7;
        Tue, 17 Oct 2023 15:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697558048;
        bh=lw54SMPaCmPecKvzZ6CYLQZLG9av8H/mdY5PFbF6XTY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=G2QqrNA0QPd3xTNkmo4MnejGM0dfRFRwGwGxomc0sxLpZbd0f+jCXNmxaSs/3zuQW
         tmiNAalyrlGVHZFoukw2CbKpkL+l4g+QpyxeZzW2GT8+4kxCBpH+j/YSnwsBFPzJak
         yLY4yMia4n7BSodyf9L0CzRMfo4ERueHUxMe56i9Zn+A7JiDSdbbYN+PnPldIATlM/
         2r9Qu0SkWon29c0aQyihCm0t+Hcy//ULRerP2x/UmvmfHGdBqVVUFUsUp0rO5lNIjK
         BOy+YOyP/yUFbYtYprVTRUGxMrYObpe2SWYcg7mwDGfVQfcfvSKB2QKh3BgxGItYM8
         CdUDw1puRMPdA==
Date:   Tue, 17 Oct 2023 08:54:08 -0700
Subject: [PATCH 1/7] xfs: consolidate realtime allocation arguments
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, osandov@fb.com,
        osandov@osandov.com, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755742594.3167911.2655847193439153279.stgit@frogsfrogsfrogs>
In-Reply-To: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs>
References: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Consolidate the arguments passed around the rt allocator into a
struct xfs_rtalloc_arg similar to how the btree allocator arguments
are consolidated in a struct xfs_alloc_arg....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |  371 +++++++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_rtbitmap.h |   46 +++--
 fs/xfs/scrub/rtsummary.c     |    6 +
 fs/xfs/xfs_rtalloc.c         |  317 ++++++++++++++++++------------------
 4 files changed, 380 insertions(+), 360 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 63a83e728724..5a7994e031f3 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -53,17 +53,17 @@ const struct xfs_buf_ops xfs_rtbuf_ops = {
  */
 int
 xfs_rtbuf_get(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_fileoff_t	block,		/* block number in bitmap or summary */
-	int		issum,		/* is summary not bitmap */
-	struct xfs_buf	**bpp)		/* output: buffer for the block */
+	struct xfs_rtalloc_args	*args,
+	xfs_fileoff_t		block,		/* block number in bitmap or summary */
+	int			issum,		/* is summary not bitmap */
+	struct xfs_buf		**bpp)		/* output: buffer for the block */
 {
-	struct xfs_buf	*bp;		/* block buffer, result */
-	xfs_inode_t	*ip;		/* bitmap or summary inode */
-	xfs_bmbt_irec_t	map;
-	int		nmap = 1;
-	int		error;		/* error value */
+	struct xfs_mount	*mp = args->mount;
+	struct xfs_buf		*bp;		/* block buffer, result */
+	struct xfs_inode	*ip;		/* bitmap or summary inode */
+	struct xfs_bmbt_irec	map;
+	int			nmap = 1;
+	int			error;		/* error value */
 
 	ip = issum ? mp->m_rsumip : mp->m_rbmip;
 
@@ -75,13 +75,13 @@ xfs_rtbuf_get(
 		return -EFSCORRUPTED;
 
 	ASSERT(map.br_startblock != NULLFSBLOCK);
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+	error = xfs_trans_read_buf(mp, args->trans, mp->m_ddev_targp,
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
 				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
 	if (error)
 		return error;
 
-	xfs_trans_buf_set_type(tp, bp, issum ? XFS_BLFT_RTSUMMARY_BUF
+	xfs_trans_buf_set_type(args->trans, bp, issum ? XFS_BLFT_RTSUMMARY_BUF
 					     : XFS_BLFT_RTBITMAP_BUF);
 	*bpp = bp;
 	return 0;
@@ -112,31 +112,31 @@ xfs_rtbitmap_setword(
  */
 int
 xfs_rtfind_back(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* starting rtext to look at */
-	xfs_rtxnum_t	limit,		/* last rtext to look at */
-	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxnum_t		start,		/* starting rtext to look at */
+	xfs_rtxnum_t		limit,		/* last rtext to look at */
+	xfs_rtxnum_t		*rtx)		/* out: start rtext found */
 {
-	union xfs_rtword_raw *b;		/* current word in buffer */
-	int		bit;		/* bit number in the word */
-	xfs_fileoff_t	block;		/* bitmap block number */
-	struct xfs_buf	*bp;		/* buf for the block */
-	int		error;		/* error value */
-	xfs_rtxnum_t	firstbit;	/* first useful bit in the word */
-	xfs_rtxnum_t	i;		/* current bit number rel. to start */
-	xfs_rtxnum_t	len;		/* length of inspected area */
-	xfs_rtword_t	mask;		/* mask of relevant bits for value */
-	xfs_rtword_t	want;		/* mask for "good" values */
-	xfs_rtword_t	wdiff;		/* difference from wanted value */
-	xfs_rtword_t	incore;
-	int		word;		/* word number in the buffer */
+	struct xfs_mount	*mp = args->mount;
+	union xfs_rtword_raw	*b;		/* current word in buffer */
+	int			bit;		/* bit number in the word */
+	xfs_fileoff_t		block;		/* bitmap block number */
+	struct xfs_buf		*bp;		/* buf for the block */
+	int			error;		/* error value */
+	xfs_rtxnum_t		firstbit;	/* first useful bit in the word */
+	xfs_rtxnum_t		i;		/* current bit number rel. to start */
+	xfs_rtxnum_t		len;		/* length of inspected area */
+	xfs_rtword_t		mask;		/* mask of relevant bits for value */
+	xfs_rtword_t		want;		/* mask for "good" values */
+	xfs_rtword_t		wdiff;		/* difference from wanted value */
+	xfs_rtword_t		incore;
+	int			word;		/* word number in the buffer */
 
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */
 	block = xfs_rtx_to_rbmblock(mp, start);
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(args, block, 0, &bp);
 	if (error) {
 		return error;
 	}
@@ -174,7 +174,7 @@ xfs_rtfind_back(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i = bit - XFS_RTHIBIT(wdiff);
 			*rtx = start - i + 1;
 			return 0;
@@ -188,8 +188,8 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, --block, 0, &bp);
+			xfs_trans_brelse(args->trans, bp);
+			error = xfs_rtbuf_get(args, --block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -221,7 +221,7 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
 			*rtx = start - i + 1;
 			return 0;
@@ -235,8 +235,8 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, --block, 0, &bp);
+			xfs_trans_brelse(args->trans, bp);
+			error = xfs_rtbuf_get(args, --block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -269,7 +269,7 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
 			*rtx = start - i + 1;
 			return 0;
@@ -279,7 +279,7 @@ xfs_rtfind_back(
 	/*
 	 * No match, return that we scanned the whole area.
 	 */
-	xfs_trans_brelse(tp, bp);
+	xfs_trans_brelse(args->trans, bp);
 	*rtx = start - i + 1;
 	return 0;
 }
@@ -290,31 +290,31 @@ xfs_rtfind_back(
  */
 int
 xfs_rtfind_forw(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* starting rtext to look at */
-	xfs_rtxnum_t	limit,		/* last rtext to look at */
-	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxnum_t		start,		/* starting rtext to look at */
+	xfs_rtxnum_t		limit,		/* last rtext to look at */
+	xfs_rtxnum_t		*rtx)		/* out: start rtext found */
 {
-	union xfs_rtword_raw *b;		/* current word in buffer */
-	int		bit;		/* bit number in the word */
-	xfs_fileoff_t	block;		/* bitmap block number */
-	struct xfs_buf	*bp;		/* buf for the block */
-	int		error;		/* error value */
-	xfs_rtxnum_t	i;		/* current bit number rel. to start */
-	xfs_rtxnum_t	lastbit;	/* last useful bit in the word */
-	xfs_rtxnum_t	len;		/* length of inspected area */
-	xfs_rtword_t	mask;		/* mask of relevant bits for value */
-	xfs_rtword_t	want;		/* mask for "good" values */
-	xfs_rtword_t	wdiff;		/* difference from wanted value */
-	xfs_rtword_t	incore;
-	int		word;		/* word number in the buffer */
+	struct xfs_mount	*mp = args->mount;
+	union xfs_rtword_raw	*b;		/* current word in buffer */
+	int			bit;		/* bit number in the word */
+	xfs_fileoff_t		block;		/* bitmap block number */
+	struct xfs_buf		*bp;		/* buf for the block */
+	int			error;		/* error value */
+	xfs_rtxnum_t		i;		/* current bit number rel. to start */
+	xfs_rtxnum_t		lastbit;	/* last useful bit in the word */
+	xfs_rtxnum_t		len;		/* length of inspected area */
+	xfs_rtword_t		mask;		/* mask of relevant bits for value */
+	xfs_rtword_t		want;		/* mask for "good" values */
+	xfs_rtword_t		wdiff;		/* difference from wanted value */
+	xfs_rtword_t		incore;
+	int			word;		/* word number in the buffer */
 
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */
 	block = xfs_rtx_to_rbmblock(mp, start);
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(args, block, 0, &bp);
 	if (error) {
 		return error;
 	}
@@ -351,7 +351,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
 			*rtx = start + i - 1;
 			return 0;
@@ -365,8 +365,8 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			xfs_trans_brelse(args->trans, bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -398,7 +398,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*rtx = start + i - 1;
 			return 0;
@@ -412,8 +412,8 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			xfs_trans_brelse(args->trans, bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -444,7 +444,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*rtx = start + i - 1;
 			return 0;
@@ -454,7 +454,7 @@ xfs_rtfind_forw(
 	/*
 	 * No match, return that we scanned the whole area.
 	 */
-	xfs_trans_brelse(tp, bp);
+	xfs_trans_brelse(args->trans, bp);
 	*rtx = start + i - 1;
 	return 0;
 }
@@ -487,21 +487,21 @@ xfs_suminfo_add(
  */
 int
 xfs_rtmodify_summary_int(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	int		log,		/* log2 of extent size */
-	xfs_fileoff_t	bbno,		/* bitmap block number */
-	int		delta,		/* change to make to summary info */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
-	xfs_suminfo_t	*sum)		/* out: summary info for this block */
+	struct xfs_rtalloc_args	*args,
+	int			log,		/* log2 of extent size */
+	xfs_fileoff_t		bbno,		/* bitmap block number */
+	int			delta,		/* change to make to summary info */
+	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
+	xfs_fileoff_t		*rsb,		/* in/out: summary block number */
+	xfs_suminfo_t		*sum)		/* out: summary info for this block */
 {
-	struct xfs_buf	*bp;		/* buffer for the summary block */
-	int		error;		/* error value */
-	xfs_fileoff_t	sb;		/* summary fsblock */
-	xfs_rtsumoff_t	so;		/* index into the summary file */
-	union xfs_suminfo_raw *sp;		/* pointer to returned data */
-	unsigned int	infoword;
+	struct xfs_mount	*mp = args->mount;
+	struct xfs_buf		*bp;		/* buffer for the summary block */
+	int			error;		/* error value */
+	xfs_fileoff_t		sb;		/* summary fsblock */
+	xfs_rtsumoff_t		so;		/* index into the summary file */
+	union xfs_suminfo_raw	*sp;		/* pointer to returned data */
+	unsigned int		infoword;
 
 	/*
 	 * Compute entry number in the summary file.
@@ -524,8 +524,8 @@ xfs_rtmodify_summary_int(
 		 * If there was an old one, get rid of it first.
 		 */
 		if (*rbpp)
-			xfs_trans_brelse(tp, *rbpp);
-		error = xfs_rtbuf_get(mp, tp, sb, 1, &bp);
+			xfs_trans_brelse(args->trans, *rbpp);
+		error = xfs_rtbuf_get(args, sb, 1, &bp);
 		if (error) {
 			return error;
 		}
@@ -552,7 +552,7 @@ xfs_rtmodify_summary_int(
 			if (val != 0 && log < mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno] = log;
 		}
-		xfs_trans_log_buf(tp, bp, first, first + sizeof(*sp) - 1);
+		xfs_trans_log_buf(args->trans, bp, first, first + sizeof(*sp) - 1);
 	}
 	if (sum)
 		*sum = xfs_suminfo_get(mp, sp);
@@ -561,16 +561,14 @@ xfs_rtmodify_summary_int(
 
 int
 xfs_rtmodify_summary(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	int		log,		/* log2 of extent size */
-	xfs_fileoff_t	bbno,		/* bitmap block number */
-	int		delta,		/* change to make to summary info */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t	*rsb)		/* in/out: summary block number */
+	struct xfs_rtalloc_args	*args,
+	int			log,		/* log2 of extent size */
+	xfs_fileoff_t		bbno,		/* bitmap block number */
+	int			delta,		/* change to make to summary info */
+	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
+	xfs_fileoff_t		*rsb)		/* in/out: summary block number */
 {
-	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
-					delta, rbpp, rsb, NULL);
+	return xfs_rtmodify_summary_int(args, log, bbno, delta, rbpp, rsb, NULL);
 }
 
 /*
@@ -579,23 +577,23 @@ xfs_rtmodify_summary(
  */
 int
 xfs_rtmodify_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* starting rtext to modify */
-	xfs_rtxlen_t	len,		/* length of extent to modify */
-	int		val)		/* 1 for free, 0 for allocated */
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxnum_t		start,		/* starting rtext to modify */
+	xfs_rtxlen_t		len,		/* length of extent to modify */
+	int			val)		/* 1 for free, 0 for allocated */
 {
-	union xfs_rtword_raw *b;		/* current word in buffer */
-	int		bit;		/* bit number in the word */
-	xfs_fileoff_t	block;		/* bitmap block number */
-	struct xfs_buf	*bp;		/* buf for the block */
-	int		error;		/* error value */
-	union xfs_rtword_raw *first;		/* first used word in the buffer */
-	int		i;		/* current bit number rel. to start */
-	int		lastbit;	/* last useful bit in word */
-	xfs_rtword_t	mask;		/* mask o frelevant bits for value */
-	xfs_rtword_t	incore;
-	int		word;		/* word number in the buffer */
+	struct xfs_mount	*mp = args->mount;
+	union xfs_rtword_raw	*b;		/* current word in buffer */
+	int			bit;		/* bit number in the word */
+	xfs_fileoff_t		block;		/* bitmap block number */
+	struct xfs_buf		*bp;		/* buf for the block */
+	int			error;		/* error value */
+	union xfs_rtword_raw	*first;		/* first used word in the buffer */
+	int			i;		/* current bit number rel. to start */
+	int			lastbit;	/* last useful bit in word */
+	xfs_rtword_t		mask;		/* mask o frelevant bits for value */
+	xfs_rtword_t		incore;
+	int			word;		/* word number in the buffer */
 
 	/*
 	 * Compute starting bitmap block number.
@@ -604,7 +602,7 @@ xfs_rtmodify_range(
 	/*
 	 * Read the bitmap block, and point to its data.
 	 */
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(args, block, 0, &bp);
 	if (error) {
 		return error;
 	}
@@ -648,10 +646,10 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_buf(tp, bp,
+			xfs_trans_log_buf(args->trans, bp,
 				(uint)((char *)first - (char *)bp->b_addr),
 				(uint)((char *)b - (char *)bp->b_addr));
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -689,10 +687,10 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_buf(tp, bp,
+			xfs_trans_log_buf(args->trans, bp,
 				(uint)((char *)first - (char *)bp->b_addr),
 				(uint)((char *)b - (char *)bp->b_addr));
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -730,9 +728,9 @@ xfs_rtmodify_range(
 	 * Log any remaining changed bytes.
 	 */
 	if (b > first)
-		xfs_trans_log_buf(tp, bp,
-			(uint)((char *)first - (char *)bp->b_addr),
-			(uint)((char *)b - (char *)bp->b_addr - 1));
+		xfs_trans_log_buf(args->trans, bp,
+				(uint)((char *)first - (char *)bp->b_addr),
+				(uint)((char *)b - (char *)bp->b_addr - 1));
 	return 0;
 }
 
@@ -742,23 +740,23 @@ xfs_rtmodify_range(
  */
 int
 xfs_rtfree_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* starting rtext to free */
-	xfs_rtxlen_t	len,		/* length to free */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t	*rsb)		/* in/out: summary block number */
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxnum_t		start,		/* starting rtext to free */
+	xfs_rtxlen_t		len,		/* length to free */
+	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
+	xfs_fileoff_t		*rsb)		/* in/out: summary block number */
 {
-	xfs_rtxnum_t	end;		/* end of the freed extent */
-	int		error;		/* error value */
-	xfs_rtxnum_t	postblock;	/* first rtext freed > end */
-	xfs_rtxnum_t	preblock;	/* first rtext freed < start */
+	struct xfs_mount	*mp = args->mount;
+	xfs_rtxnum_t		end;		/* end of the freed extent */
+	int			error;		/* error value */
+	xfs_rtxnum_t		postblock;	/* first rtext freed > end */
+	xfs_rtxnum_t		preblock;	/* first rtext freed < start */
 
 	end = start + len - 1;
 	/*
 	 * Modify the bitmap to mark this extent freed.
 	 */
-	error = xfs_rtmodify_range(mp, tp, start, len, 1);
+	error = xfs_rtmodify_range(args, start, len, 1);
 	if (error) {
 		return error;
 	}
@@ -767,14 +765,14 @@ xfs_rtfree_range(
 	 * We need to find the beginning and end of the extent so we can
 	 * properly update the summary.
 	 */
-	error = xfs_rtfind_back(mp, tp, start, 0, &preblock);
+	error = xfs_rtfind_back(args, start, 0, &preblock);
 	if (error) {
 		return error;
 	}
 	/*
 	 * Find the next allocated block (end of allocated extent).
 	 */
-	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1,
+	error = xfs_rtfind_forw(args, end, mp->m_sb.sb_rextents - 1,
 		&postblock);
 	if (error)
 		return error;
@@ -783,7 +781,7 @@ xfs_rtfree_range(
 	 * old extent, add summary data for them to be allocated.
 	 */
 	if (preblock < start) {
-		error = xfs_rtmodify_summary(mp, tp,
+		error = xfs_rtmodify_summary(args,
 			XFS_RTBLOCKLOG(start - preblock),
 			xfs_rtx_to_rbmblock(mp, preblock), -1, rbpp, rsb);
 		if (error) {
@@ -795,7 +793,7 @@ xfs_rtfree_range(
 	 * old extent, add summary data for them to be allocated.
 	 */
 	if (postblock > end) {
-		error = xfs_rtmodify_summary(mp, tp,
+		error = xfs_rtmodify_summary(args,
 			XFS_RTBLOCKLOG(postblock - end),
 			xfs_rtx_to_rbmblock(mp, end + 1), -1, rbpp, rsb);
 		if (error) {
@@ -806,7 +804,7 @@ xfs_rtfree_range(
 	 * Increment the summary information corresponding to the entire
 	 * (new) free extent.
 	 */
-	error = xfs_rtmodify_summary(mp, tp,
+	error = xfs_rtmodify_summary(args,
 		XFS_RTBLOCKLOG(postblock + 1 - preblock),
 		xfs_rtx_to_rbmblock(mp, preblock), 1, rbpp, rsb);
 	return error;
@@ -818,25 +816,25 @@ xfs_rtfree_range(
  */
 int
 xfs_rtcheck_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* starting rtext number of extent */
-	xfs_rtxlen_t	len,		/* length of extent */
-	int		val,		/* 1 for free, 0 for allocated */
-	xfs_rtxnum_t	*new,		/* out: first rtext not matching */
-	int		*stat)		/* out: 1 for matches, 0 for not */
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxnum_t		start,		/* starting rtext number of extent */
+	xfs_rtxlen_t		len,		/* length of extent */
+	int			val,		/* 1 for free, 0 for allocated */
+	xfs_rtxnum_t		*new,		/* out: first rtext not matching */
+	int			*stat)		/* out: 1 for matches, 0 for not */
 {
-	union xfs_rtword_raw *b;		/* current word in buffer */
-	int		bit;		/* bit number in the word */
-	xfs_fileoff_t	block;		/* bitmap block number */
-	struct xfs_buf	*bp;		/* buf for the block */
-	int		error;		/* error value */
-	xfs_rtxnum_t	i;		/* current bit number rel. to start */
-	xfs_rtxnum_t	lastbit;	/* last useful bit in word */
-	xfs_rtword_t	mask;		/* mask of relevant bits for value */
-	xfs_rtword_t	wdiff;		/* difference from wanted value */
-	xfs_rtword_t	incore;
-	int		word;		/* word number in the buffer */
+	struct xfs_mount	*mp = args->mount;
+	union xfs_rtword_raw	*b;		/* current word in buffer */
+	int			bit;		/* bit number in the word */
+	xfs_fileoff_t		block;		/* bitmap block number */
+	struct xfs_buf		*bp;		/* buf for the block */
+	int			error;		/* error value */
+	xfs_rtxnum_t		i;		/* current bit number rel. to start */
+	xfs_rtxnum_t		lastbit;	/* last useful bit in word */
+	xfs_rtword_t		mask;		/* mask of relevant bits for value */
+	xfs_rtword_t		wdiff;		/* difference from wanted value */
+	xfs_rtword_t		incore;
+	int			word;		/* word number in the buffer */
 
 	/*
 	 * Compute starting bitmap block number
@@ -845,7 +843,7 @@ xfs_rtcheck_range(
 	/*
 	 * Read the bitmap block.
 	 */
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(args, block, 0, &bp);
 	if (error) {
 		return error;
 	}
@@ -881,7 +879,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
 			*new = start + i;
 			*stat = 0;
@@ -896,8 +894,8 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			xfs_trans_brelse(args->trans, bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -929,7 +927,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*new = start + i;
 			*stat = 0;
@@ -944,8 +942,8 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			xfs_trans_brelse(args->trans, bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -976,7 +974,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*new = start + i;
 			*stat = 0;
@@ -987,7 +985,7 @@ xfs_rtcheck_range(
 	/*
 	 * Successful, return.
 	 */
-	xfs_trans_brelse(tp, bp);
+	xfs_trans_brelse(args->trans, bp);
 	*new = start + i;
 	*stat = 1;
 	return 0;
@@ -999,23 +997,22 @@ xfs_rtcheck_range(
  */
 STATIC int				/* error */
 xfs_rtcheck_alloc_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* starting rtext number of extent */
-	xfs_rtxlen_t	len)		/* length of extent */
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxnum_t		start,		/* starting rtext number of extent */
+	xfs_rtxlen_t		len)		/* length of extent */
 {
-	xfs_rtxnum_t	new;		/* dummy for xfs_rtcheck_range */
-	int		stat;
-	int		error;
+	xfs_rtxnum_t		new;		/* dummy for xfs_rtcheck_range */
+	int			stat;
+	int			error;
 
-	error = xfs_rtcheck_range(mp, tp, start, len, 0, &new, &stat);
+	error = xfs_rtcheck_range(args, start, len, 0, &new, &stat);
 	if (error)
 		return error;
 	ASSERT(stat);
 	return 0;
 }
 #else
-#define xfs_rtcheck_alloc_range(m,t,b,l)	(0)
+#define xfs_rtcheck_alloc_range(a,b,l)	(0)
 #endif
 /*
  * Free an extent in the realtime subvolume.  Length is expressed in
@@ -1023,28 +1020,30 @@ xfs_rtcheck_alloc_range(
  */
 int					/* error */
 xfs_rtfree_extent(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* starting rtext number to free */
-	xfs_rtxlen_t	len)		/* length of extent freed */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	xfs_rtxnum_t		start,		/* starting rtext number to free */
+	xfs_rtxlen_t		len)		/* length of extent freed */
 {
-	int		error;		/* error value */
-	xfs_mount_t	*mp;		/* file system mount structure */
-	xfs_fsblock_t	sb;		/* summary file block number */
-	struct xfs_buf	*sumbp = NULL;	/* summary file block buffer */
-
-	mp = tp->t_mountp;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_rtalloc_args	args = {
+		.mount		= mp,
+		.trans		= tp,
+	};
+	int			error;		/* error value */
+	xfs_fsblock_t		sb;		/* summary file block number */
+	struct xfs_buf		*sumbp = NULL;	/* summary file block buffer */
 
 	ASSERT(mp->m_rbmip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
-	error = xfs_rtcheck_alloc_range(mp, tp, start, len);
+	error = xfs_rtcheck_alloc_range(&args, start, len);
 	if (error)
 		return error;
 
 	/*
 	 * Free the range of realtime blocks.
 	 */
-	error = xfs_rtfree_range(mp, tp, start, len, &sumbp, &sb);
+	error = xfs_rtfree_range(&args, start, len, &sumbp, &sb);
 	if (error) {
 		return error;
 	}
@@ -1109,6 +1108,10 @@ xfs_rtalloc_query_range(
 	xfs_rtalloc_query_range_fn	fn,
 	void				*priv)
 {
+	struct xfs_rtalloc_args		args = {
+		.mount	= mp,
+		.trans	= tp,
+	};
 	struct xfs_rtalloc_rec		rec;
 	xfs_rtxnum_t			rtstart;
 	xfs_rtxnum_t			rtend;
@@ -1128,13 +1131,13 @@ xfs_rtalloc_query_range(
 	rtstart = low_rec->ar_startext;
 	while (rtstart <= high_key) {
 		/* Is the first block free? */
-		error = xfs_rtcheck_range(mp, tp, rtstart, 1, 1, &rtend,
+		error = xfs_rtcheck_range(&args, rtstart, 1, 1, &rtend,
 				&is_free);
 		if (error)
 			break;
 
 		/* How long does the extent go for? */
-		error = xfs_rtfind_forw(mp, tp, rtstart, high_key, &rtend);
+		error = xfs_rtfind_forw(&args, rtstart, high_key, &rtend);
 		if (error)
 			break;
 
@@ -1179,11 +1182,15 @@ xfs_rtalloc_extent_is_free(
 	xfs_rtxlen_t			len,
 	bool				*is_free)
 {
+	struct xfs_rtalloc_args		args = {
+		.mount			= mp,
+		.trans			= tp,
+	};
 	xfs_rtxnum_t			end;
 	int				matches;
 	int				error;
 
-	error = xfs_rtcheck_range(mp, tp, start, len, 1, &end, &matches);
+	error = xfs_rtcheck_range(&args, start, len, 1, &end, &matches);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 6a0d8b8af36d..39da0adf0f45 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -234,29 +234,29 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 	void				*priv);
 
 #ifdef CONFIG_XFS_RT
-int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
-		  xfs_fileoff_t block, int issum, struct xfs_buf **bpp);
-int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		      xfs_rtxnum_t start, xfs_rtxlen_t len, int val,
-		      xfs_rtxnum_t *new, int *stat);
-int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
-		    xfs_rtxnum_t start, xfs_rtxnum_t limit,
-		    xfs_rtxnum_t *rtblock);
-int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
-		    xfs_rtxnum_t start, xfs_rtxnum_t limit,
-		    xfs_rtxnum_t *rtblock);
-int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		       xfs_rtxnum_t start, xfs_rtxlen_t len, int val);
-int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
-			     int log, xfs_fileoff_t bbno, int delta,
-			     struct xfs_buf **rbpp, xfs_fileoff_t *rsb,
-			     xfs_suminfo_t *sum);
-int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
-			 xfs_fileoff_t bbno, int delta, struct xfs_buf **rbpp,
-			 xfs_fileoff_t *rsb);
-int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		     xfs_rtxnum_t start, xfs_rtxlen_t len,
-		     struct xfs_buf **rbpp, xfs_fileoff_t *rsb);
+struct xfs_rtalloc_args {
+	struct xfs_mount	*mount;
+	struct xfs_trans	*trans;
+};
+
+int xfs_rtbuf_get(struct xfs_rtalloc_args *args, xfs_fileoff_t block,
+		int issum, struct xfs_buf **bpp);
+int xfs_rtcheck_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
+		xfs_rtxlen_t len, int val, xfs_rtxnum_t *new, int *stat);
+int xfs_rtfind_back(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
+		xfs_rtxnum_t limit, xfs_rtxnum_t *rtblock);
+int xfs_rtfind_forw(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
+		xfs_rtxnum_t limit, xfs_rtxnum_t *rtblock);
+int xfs_rtmodify_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
+		xfs_rtxlen_t len, int val);
+int xfs_rtmodify_summary_int(struct xfs_rtalloc_args *args, int log,
+		xfs_fileoff_t bbno, int delta, struct xfs_buf **rbpp,
+		xfs_fileoff_t *rsb, xfs_suminfo_t *sum);
+int xfs_rtmodify_summary(struct xfs_rtalloc_args *args, int log,
+		xfs_fileoff_t bbno, int delta, struct xfs_buf **rbpp,
+		xfs_fileoff_t *rsb);
+int xfs_rtfree_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
+		xfs_rtxlen_t len, struct xfs_buf **rbpp, xfs_fileoff_t *rsb);
 int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		const struct xfs_rtalloc_rec *low_rec,
 		const struct xfs_rtalloc_rec *high_rec,
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index c6fdb65f20e2..3f6f6efe7375 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -178,6 +178,10 @@ STATIC int
 xchk_rtsum_compare(
 	struct xfs_scrub	*sc)
 {
+	struct xfs_rtalloc_args args = {
+		.mount = sc->mp,
+		.trans = sc->tp,
+	};
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_buf		*bp;
 	struct xfs_bmbt_irec	map;
@@ -206,7 +210,7 @@ xchk_rtsum_compare(
 		}
 
 		/* Read a block's worth of ondisk rtsummary file. */
-		error = xfs_rtbuf_get(mp, sc->tp, off, 1, &bp);
+		error = xfs_rtbuf_get(&args, off, 1, &bp);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, off, &error))
 			return error;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 3be6bda2fd92..922d2fdcf953 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -29,15 +29,14 @@
  */
 static int
 xfs_rtget_summary(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	int		log,		/* log2 of extent size */
-	xfs_fileoff_t	bbno,		/* bitmap block number */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
-	xfs_suminfo_t	*sum)		/* out: summary info for this block */
+	struct xfs_rtalloc_args	*args,
+	int			log,		/* log2 of extent size */
+	xfs_fileoff_t		bbno,		/* bitmap block number */
+	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
+	xfs_fileoff_t		*rsb,		/* in/out: summary block number */
+	xfs_suminfo_t		*sum)		/* out: summary info for this block */
 {
-	return xfs_rtmodify_summary_int(mp, tp, log, bbno, 0, rbpp, rsb, sum);
+	return xfs_rtmodify_summary_int(args, log, bbno, 0, rbpp, rsb, sum);
 }
 
 /*
@@ -46,18 +45,18 @@ xfs_rtget_summary(
  */
 STATIC int				/* error */
 xfs_rtany_summary(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	int		low,		/* low log2 extent size */
-	int		high,		/* high log2 extent size */
-	xfs_fileoff_t	bbno,		/* bitmap block number */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
-	int		*stat)		/* out: any good extents here? */
+	struct xfs_rtalloc_args	*args,
+	int			low,		/* low log2 extent size */
+	int			high,		/* high log2 extent size */
+	xfs_fileoff_t		bbno,		/* bitmap block number */
+	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
+	xfs_fileoff_t		*rsb,		/* in/out: summary block number */
+	int			*stat)		/* out: any good extents here? */
 {
-	int		error;		/* error value */
-	int		log;		/* loop counter, log2 of ext. size */
-	xfs_suminfo_t	sum;		/* summary data */
+	struct xfs_mount	*mp = args->mount;
+	int			error;		/* error value */
+	int			log;		/* loop counter, log2 of ext. size */
+	xfs_suminfo_t		sum;		/* summary data */
 
 	/* There are no extents at levels < m_rsum_cache[bbno]. */
 	if (mp->m_rsum_cache && low < mp->m_rsum_cache[bbno])
@@ -70,7 +69,7 @@ xfs_rtany_summary(
 		/*
 		 * Get one summary datum.
 		 */
-		error = xfs_rtget_summary(mp, tp, log, bbno, rbpp, rsb, &sum);
+		error = xfs_rtget_summary(args, log, bbno, rbpp, rsb, &sum);
 		if (error) {
 			return error;
 		}
@@ -100,33 +99,32 @@ xfs_rtany_summary(
  */
 STATIC int				/* error */
 xfs_rtcopy_summary(
-	xfs_mount_t	*omp,		/* old file system mount point */
-	xfs_mount_t	*nmp,		/* new file system mount point */
-	xfs_trans_t	*tp)		/* transaction pointer */
+	struct xfs_rtalloc_args	*oargs,
+	struct xfs_rtalloc_args	*nargs)
 {
-	xfs_fileoff_t	bbno;		/* bitmap block number */
-	struct xfs_buf	*bp;		/* summary buffer */
-	int		error;		/* error return value */
-	int		log;		/* summary level number (log length) */
-	xfs_suminfo_t	sum;		/* summary data */
-	xfs_fileoff_t	sumbno;		/* summary block number */
+	xfs_fileoff_t		bbno;		/* bitmap block number */
+	struct xfs_buf		*bp;		/* summary buffer */
+	int			error;		/* error return value */
+	int			log;		/* summary level number (log length) */
+	xfs_suminfo_t		sum;		/* summary data */
+	xfs_fileoff_t		sumbno;		/* summary block number */
 
 	bp = NULL;
-	for (log = omp->m_rsumlevels - 1; log >= 0; log--) {
-		for (bbno = omp->m_sb.sb_rbmblocks - 1;
+	for (log = oargs->mount->m_rsumlevels - 1; log >= 0; log--) {
+		for (bbno = oargs->mount->m_sb.sb_rbmblocks - 1;
 		     (xfs_srtblock_t)bbno >= 0;
 		     bbno--) {
-			error = xfs_rtget_summary(omp, tp, log, bbno, &bp,
+			error = xfs_rtget_summary(oargs, log, bbno, &bp,
 				&sumbno, &sum);
 			if (error)
 				return error;
 			if (sum == 0)
 				continue;
-			error = xfs_rtmodify_summary(omp, tp, log, bbno, -sum,
+			error = xfs_rtmodify_summary(oargs, log, bbno, -sum,
 				&bp, &sumbno);
 			if (error)
 				return error;
-			error = xfs_rtmodify_summary(nmp, tp, log, bbno, sum,
+			error = xfs_rtmodify_summary(nargs, log, bbno, sum,
 				&bp, &sumbno);
 			if (error)
 				return error;
@@ -141,17 +139,17 @@ xfs_rtcopy_summary(
  */
 STATIC int				/* error */
 xfs_rtallocate_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* start rtext to allocate */
-	xfs_rtxlen_t	len,		/* length to allocate */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t	*rsb)		/* in/out: summary block number */
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxnum_t		start,		/* start rtext to allocate */
+	xfs_rtxlen_t		len,		/* length to allocate */
+	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
+	xfs_fileoff_t		*rsb)		/* in/out: summary block number */
 {
-	xfs_rtxnum_t	end;		/* end of the allocated rtext */
-	int		error;		/* error value */
-	xfs_rtxnum_t	postblock = 0;	/* first rtext allocated > end */
-	xfs_rtxnum_t	preblock = 0;	/* first rtext allocated < start */
+	struct xfs_mount	*mp = args->mount;
+	xfs_rtxnum_t		end;		/* end of the allocated rtext */
+	int			error;		/* error value */
+	xfs_rtxnum_t		postblock = 0;	/* first rtext allocated > end */
+	xfs_rtxnum_t		preblock = 0;	/* first rtext allocated < start */
 
 	end = start + len - 1;
 	/*
@@ -159,14 +157,14 @@ xfs_rtallocate_range(
 	 * We need to find the beginning and end of the extent so we can
 	 * properly update the summary.
 	 */
-	error = xfs_rtfind_back(mp, tp, start, 0, &preblock);
+	error = xfs_rtfind_back(args, start, 0, &preblock);
 	if (error) {
 		return error;
 	}
 	/*
 	 * Find the next allocated block (end of free extent).
 	 */
-	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1,
+	error = xfs_rtfind_forw(args, end, mp->m_sb.sb_rextents - 1,
 		&postblock);
 	if (error) {
 		return error;
@@ -175,7 +173,7 @@ xfs_rtallocate_range(
 	 * Decrement the summary information corresponding to the entire
 	 * (old) free extent.
 	 */
-	error = xfs_rtmodify_summary(mp, tp,
+	error = xfs_rtmodify_summary(args,
 		XFS_RTBLOCKLOG(postblock + 1 - preblock),
 		xfs_rtx_to_rbmblock(mp, preblock), -1, rbpp, rsb);
 	if (error) {
@@ -186,7 +184,7 @@ xfs_rtallocate_range(
 	 * old extent, add summary data for them to be free.
 	 */
 	if (preblock < start) {
-		error = xfs_rtmodify_summary(mp, tp,
+		error = xfs_rtmodify_summary(args,
 			XFS_RTBLOCKLOG(start - preblock),
 			xfs_rtx_to_rbmblock(mp, preblock), 1, rbpp, rsb);
 		if (error) {
@@ -198,7 +196,7 @@ xfs_rtallocate_range(
 	 * old extent, add summary data for them to be free.
 	 */
 	if (postblock > end) {
-		error = xfs_rtmodify_summary(mp, tp,
+		error = xfs_rtmodify_summary(args,
 			XFS_RTBLOCKLOG(postblock - end),
 			xfs_rtx_to_rbmblock(mp, end + 1), 1, rbpp, rsb);
 		if (error) {
@@ -208,7 +206,7 @@ xfs_rtallocate_range(
 	/*
 	 * Modify the bitmap to mark this extent allocated.
 	 */
-	error = xfs_rtmodify_range(mp, tp, start, len, 0);
+	error = xfs_rtmodify_range(args, start, len, 0);
 	return error;
 }
 
@@ -237,25 +235,25 @@ xfs_rtallocate_clamp_len(
  */
 STATIC int				/* error */
 xfs_rtallocate_extent_block(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_fileoff_t	bbno,		/* bitmap block number */
-	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
-	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
-	xfs_rtxlen_t	*len,		/* out: actual length allocated */
-	xfs_rtxnum_t	*nextp,		/* out: next rtext to try */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
-	xfs_rtxlen_t	prod,		/* extent product factor */
-	xfs_rtxnum_t	*rtx)		/* out: start rtext allocated */
+	struct xfs_rtalloc_args	*args,
+	xfs_fileoff_t		bbno,		/* bitmap block number */
+	xfs_rtxlen_t		minlen,		/* minimum length to allocate */
+	xfs_rtxlen_t		maxlen,		/* maximum length to allocate */
+	xfs_rtxlen_t		*len,		/* out: actual length allocated */
+	xfs_rtxnum_t		*nextp,		/* out: next rtext to try */
+	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
+	xfs_fileoff_t		*rsb,		/* in/out: summary block number */
+	xfs_rtxlen_t		prod,		/* extent product factor */
+	xfs_rtxnum_t		*rtx)		/* out: start rtext allocated */
 {
-	xfs_rtxnum_t	besti;		/* best rtext found so far */
-	xfs_rtxnum_t	bestlen;	/* best length found so far */
-	xfs_rtxnum_t	end;		/* last rtext in chunk */
-	int		error;		/* error value */
-	xfs_rtxnum_t	i;		/* current rtext trying */
-	xfs_rtxnum_t	next;		/* next rtext to try */
-	int		stat;		/* status from internal calls */
+	struct xfs_mount	*mp = args->mount;
+	xfs_rtxnum_t		besti;		/* best rtext found so far */
+	xfs_rtxnum_t		bestlen;	/* best length found so far */
+	xfs_rtxnum_t		end;		/* last rtext in chunk */
+	int			error;		/* error value */
+	xfs_rtxnum_t		i;		/* current rtext trying */
+	xfs_rtxnum_t		next;		/* next rtext to try */
+	int			stat;		/* status from internal calls */
 
 	/*
 	 * Loop over all the extents starting in this bitmap block,
@@ -272,7 +270,7 @@ xfs_rtallocate_extent_block(
 		 * See if there's a free extent of maxlen starting at i.
 		 * If it's not so then next will contain the first non-free.
 		 */
-		error = xfs_rtcheck_range(mp, tp, i, maxlen, 1, &next, &stat);
+		error = xfs_rtcheck_range(args, i, maxlen, 1, &next, &stat);
 		if (error) {
 			return error;
 		}
@@ -280,7 +278,7 @@ xfs_rtallocate_extent_block(
 			/*
 			 * i for maxlen is all free, allocate and return that.
 			 */
-			error = xfs_rtallocate_range(mp, tp, i, maxlen, rbpp,
+			error = xfs_rtallocate_range(args, i, maxlen, rbpp,
 				rsb);
 			if (error) {
 				return error;
@@ -308,7 +306,7 @@ xfs_rtallocate_extent_block(
 		 * If not done yet, find the start of the next free space.
 		 */
 		if (next < end) {
-			error = xfs_rtfind_forw(mp, tp, next, end, &i);
+			error = xfs_rtfind_forw(args, next, end, &i);
 			if (error) {
 				return error;
 			}
@@ -333,7 +331,7 @@ xfs_rtallocate_extent_block(
 		/*
 		 * Allocate besti for bestlen & return that.
 		 */
-		error = xfs_rtallocate_range(mp, tp, besti, bestlen, rbpp, rsb);
+		error = xfs_rtallocate_range(args, besti, bestlen, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -357,28 +355,27 @@ xfs_rtallocate_extent_block(
  */
 STATIC int				/* error */
 xfs_rtallocate_extent_exact(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* starting rtext number to allocate */
-	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
-	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
-	xfs_rtxlen_t	*len,		/* out: actual length allocated */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
-	xfs_rtxlen_t	prod,		/* extent product factor */
-	xfs_rtxnum_t	*rtx)		/* out: start rtext allocated */
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxnum_t		start,		/* starting rtext number to allocate */
+	xfs_rtxlen_t		minlen,		/* minimum length to allocate */
+	xfs_rtxlen_t		maxlen,		/* maximum length to allocate */
+	xfs_rtxlen_t		*len,		/* out: actual length allocated */
+	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
+	xfs_fileoff_t		*rsb,		/* in/out: summary block number */
+	xfs_rtxlen_t		prod,		/* extent product factor */
+	xfs_rtxnum_t		*rtx)		/* out: start rtext allocated */
 {
-	int		error;		/* error value */
-	xfs_rtxlen_t	i;		/* extent length trimmed due to prod */
-	int		isfree;		/* extent is free */
-	xfs_rtxnum_t	next;		/* next rtext to try (dummy) */
+	int			error;		/* error value */
+	xfs_rtxlen_t		i;		/* extent length trimmed due to prod */
+	int			isfree;		/* extent is free */
+	xfs_rtxnum_t		next;		/* next rtext to try (dummy) */
 
 	ASSERT(minlen % prod == 0);
 	ASSERT(maxlen % prod == 0);
 	/*
 	 * Check if the range in question (for maxlen) is free.
 	 */
-	error = xfs_rtcheck_range(mp, tp, start, maxlen, 1, &next, &isfree);
+	error = xfs_rtcheck_range(args, start, maxlen, 1, &next, &isfree);
 	if (error) {
 		return error;
 	}
@@ -386,7 +383,7 @@ xfs_rtallocate_extent_exact(
 		/*
 		 * If it is, allocate it and return success.
 		 */
-		error = xfs_rtallocate_range(mp, tp, start, maxlen, rbpp, rsb);
+		error = xfs_rtallocate_range(args, start, maxlen, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -421,7 +418,7 @@ xfs_rtallocate_extent_exact(
 	/*
 	 * Allocate what we can and return it.
 	 */
-	error = xfs_rtallocate_range(mp, tp, start, maxlen, rbpp, rsb);
+	error = xfs_rtallocate_range(args, start, maxlen, rbpp, rsb);
 	if (error) {
 		return error;
 	}
@@ -437,25 +434,25 @@ xfs_rtallocate_extent_exact(
  */
 STATIC int				/* error */
 xfs_rtallocate_extent_near(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* starting rtext number to allocate */
-	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
-	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
-	xfs_rtxlen_t	*len,		/* out: actual length allocated */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
-	xfs_rtxlen_t	prod,		/* extent product factor */
-	xfs_rtxnum_t	*rtx)		/* out: start rtext allocated */
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxnum_t		start,		/* starting rtext number to allocate */
+	xfs_rtxlen_t		minlen,		/* minimum length to allocate */
+	xfs_rtxlen_t		maxlen,		/* maximum length to allocate */
+	xfs_rtxlen_t		*len,		/* out: actual length allocated */
+	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
+	xfs_fileoff_t		*rsb,		/* in/out: summary block number */
+	xfs_rtxlen_t		prod,		/* extent product factor */
+	xfs_rtxnum_t		*rtx)		/* out: start rtext allocated */
 {
-	int		any;		/* any useful extents from summary */
-	xfs_fileoff_t	bbno;		/* bitmap block number */
-	int		error;		/* error value */
-	int		i;		/* bitmap block offset (loop control) */
-	int		j;		/* secondary loop control */
-	int		log2len;	/* log2 of minlen */
-	xfs_rtxnum_t	n;		/* next rtext to try */
-	xfs_rtxnum_t	r;		/* result rtext */
+	struct xfs_mount	*mp = args->mount;
+	int			any;		/* any useful extents from summary */
+	xfs_fileoff_t		bbno;		/* bitmap block number */
+	int			error;		/* error value */
+	int			i;		/* bitmap block offset (loop control) */
+	int			j;		/* secondary loop control */
+	int			log2len;	/* log2 of minlen */
+	xfs_rtxnum_t		n;		/* next rtext to try */
+	xfs_rtxnum_t		r;		/* result rtext */
 
 	ASSERT(minlen % prod == 0);
 	ASSERT(maxlen % prod == 0);
@@ -477,8 +474,8 @@ xfs_rtallocate_extent_near(
 	/*
 	 * Try the exact allocation first.
 	 */
-	error = xfs_rtallocate_extent_exact(mp, tp, start, minlen, maxlen, len,
-		rbpp, rsb, prod, &r);
+	error = xfs_rtallocate_extent_exact(args, start, minlen, maxlen, len,
+			rbpp, rsb, prod, &r);
 	if (error) {
 		return error;
 	}
@@ -501,7 +498,7 @@ xfs_rtallocate_extent_near(
 		 * Get summary information of extents of all useful levels
 		 * starting in this bitmap block.
 		 */
-		error = xfs_rtany_summary(mp, tp, log2len, mp->m_rsumlevels - 1,
+		error = xfs_rtany_summary(args, log2len, mp->m_rsumlevels - 1,
 			bbno + i, rbpp, rsb, &any);
 		if (error) {
 			return error;
@@ -519,7 +516,7 @@ xfs_rtallocate_extent_near(
 				 * Try to allocate an extent starting in
 				 * this block.
 				 */
-				error = xfs_rtallocate_extent_block(mp, tp,
+				error = xfs_rtallocate_extent_block(args,
 					bbno + i, minlen, maxlen, len, &n, rbpp,
 					rsb, prod, &r);
 				if (error) {
@@ -548,7 +545,7 @@ xfs_rtallocate_extent_near(
 					 * Grab the summary information for
 					 * this bitmap block.
 					 */
-					error = xfs_rtany_summary(mp, tp,
+					error = xfs_rtany_summary(args,
 						log2len, mp->m_rsumlevels - 1,
 						bbno + j, rbpp, rsb, &any);
 					if (error) {
@@ -564,8 +561,8 @@ xfs_rtallocate_extent_near(
 					 */
 					if (any)
 						continue;
-					error = xfs_rtallocate_extent_block(mp,
-						tp, bbno + j, minlen, maxlen,
+					error = xfs_rtallocate_extent_block(args,
+						bbno + j, minlen, maxlen,
 						len, &n, rbpp, rsb, prod, &r);
 					if (error) {
 						return error;
@@ -586,7 +583,7 @@ xfs_rtallocate_extent_near(
 				 * Try to allocate from the summary block
 				 * that we found.
 				 */
-				error = xfs_rtallocate_extent_block(mp, tp,
+				error = xfs_rtallocate_extent_block(args,
 					bbno + i, minlen, maxlen, len, &n, rbpp,
 					rsb, prod, &r);
 				if (error) {
@@ -642,22 +639,22 @@ xfs_rtallocate_extent_near(
  */
 STATIC int				/* error */
 xfs_rtallocate_extent_size(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
-	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
-	xfs_rtxlen_t	*len,		/* out: actual length allocated */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
-	xfs_rtxlen_t	prod,		/* extent product factor */
-	xfs_rtxnum_t	*rtx)		/* out: start rtext allocated */
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxlen_t		minlen,		/* minimum length to allocate */
+	xfs_rtxlen_t		maxlen,		/* maximum length to allocate */
+	xfs_rtxlen_t		*len,		/* out: actual length allocated */
+	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
+	xfs_fileoff_t		*rsb,		/* in/out: summary block number */
+	xfs_rtxlen_t		prod,		/* extent product factor */
+	xfs_rtxnum_t		*rtx)		/* out: start rtext allocated */
 {
-	int		error;		/* error value */
-	xfs_fileoff_t	i;		/* bitmap block number */
-	int		l;		/* level number (loop control) */
-	xfs_rtxnum_t	n;		/* next rtext to be tried */
-	xfs_rtxnum_t	r;		/* result rtext number */
-	xfs_suminfo_t	sum;		/* summary information for extents */
+	struct xfs_mount	*mp = args->mount;
+	int			error;		/* error value */
+	xfs_fileoff_t		i;		/* bitmap block number */
+	int			l;		/* level number (loop control) */
+	xfs_rtxnum_t		n;		/* next rtext to be tried */
+	xfs_rtxnum_t		r;		/* result rtext number */
+	xfs_suminfo_t		sum;		/* summary information for extents */
 
 	ASSERT(minlen % prod == 0);
 	ASSERT(maxlen % prod == 0);
@@ -678,7 +675,7 @@ xfs_rtallocate_extent_size(
 			/*
 			 * Get the summary for this level/block.
 			 */
-			error = xfs_rtget_summary(mp, tp, l, i, rbpp, rsb,
+			error = xfs_rtget_summary(args, l, i, rbpp, rsb,
 				&sum);
 			if (error) {
 				return error;
@@ -691,7 +688,7 @@ xfs_rtallocate_extent_size(
 			/*
 			 * Try allocating the extent.
 			 */
-			error = xfs_rtallocate_extent_block(mp, tp, i, maxlen,
+			error = xfs_rtallocate_extent_block(args, i, maxlen,
 				maxlen, len, &n, rbpp, rsb, prod, &r);
 			if (error) {
 				return error;
@@ -737,7 +734,7 @@ xfs_rtallocate_extent_size(
 			/*
 			 * Get the summary information for this level/block.
 			 */
-			error =	xfs_rtget_summary(mp, tp, l, i, rbpp, rsb,
+			error =	xfs_rtget_summary(args, l, i, rbpp, rsb,
 						  &sum);
 			if (error) {
 				return error;
@@ -752,7 +749,7 @@ xfs_rtallocate_extent_size(
 			 * minlen/maxlen are in the possible range for
 			 * this summary level.
 			 */
-			error = xfs_rtallocate_extent_block(mp, tp, i,
+			error = xfs_rtallocate_extent_block(args, i,
 					XFS_RTMAX(minlen, 1 << l),
 					XFS_RTMIN(maxlen, (1 << (l + 1)) - 1),
 					len, &n, rbpp, rsb, prod, &r);
@@ -1044,6 +1041,12 @@ xfs_growfs_rt(
 		     ((sbp->sb_rextents & ((1 << mp->m_blkbit_log) - 1)) != 0);
 	     bmbno < nrbmblocks;
 	     bmbno++) {
+		struct xfs_rtalloc_args	args = {
+			.mount	= mp,
+		};
+		struct xfs_rtalloc_args	nargs = {
+			.mount	= nmp,
+		};
 		struct xfs_trans	*tp;
 		xfs_rfsblock_t		nrblocks_step;
 
@@ -1072,6 +1075,9 @@ xfs_growfs_rt(
 				&tp);
 		if (error)
 			break;
+		args.trans = tp;
+		nargs.trans = tp;
+
 		/*
 		 * Lock out other callers by grabbing the bitmap inode lock.
 		 */
@@ -1105,7 +1111,7 @@ xfs_growfs_rt(
 		 */
 		if (sbp->sb_rbmblocks != nsbp->sb_rbmblocks ||
 		    mp->m_rsumlevels != nmp->m_rsumlevels) {
-			error = xfs_rtcopy_summary(mp, nmp, tp);
+			error = xfs_rtcopy_summary(&args, &nargs);
 			if (error)
 				goto error_cancel;
 		}
@@ -1131,7 +1137,7 @@ xfs_growfs_rt(
 		 * Free new extent.
 		 */
 		bp = NULL;
-		error = xfs_rtfree_range(nmp, tp, sbp->sb_rextents,
+		error = xfs_rtfree_range(&nargs, sbp->sb_rextents,
 			nsbp->sb_rextents - sbp->sb_rextents, &bp, &sumbno);
 		if (error) {
 error_cancel:
@@ -1192,22 +1198,25 @@ xfs_growfs_rt(
  */
 int					/* error */
 xfs_rtallocate_extent(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* starting rtext number to allocate */
-	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
-	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
-	xfs_rtxlen_t	*len,		/* out: actual length allocated */
-	int		wasdel,		/* was a delayed allocation extent */
-	xfs_rtxlen_t	prod,		/* extent product factor */
-	xfs_rtxnum_t	*rtblock)	/* out: start rtext allocated */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	xfs_rtxnum_t		start,		/* starting rtext number to allocate */
+	xfs_rtxlen_t		minlen,		/* minimum length to allocate */
+	xfs_rtxlen_t		maxlen,		/* maximum length to allocate */
+	xfs_rtxlen_t		*len,		/* out: actual length allocated */
+	int			wasdel,		/* was a delayed allocation extent */
+	xfs_rtxlen_t		prod,		/* extent product factor */
+	xfs_rtxnum_t		*rtblock)	/* out: start rtext allocated */
 {
-	xfs_mount_t	*mp = tp->t_mountp;
-	int		error;		/* error value */
-	xfs_rtxnum_t	r;		/* result allocated rtext */
-	xfs_fileoff_t	sb;		/* summary file block number */
-	struct xfs_buf	*sumbp;		/* summary file block buffer */
+	struct xfs_rtalloc_args	args = {
+		.mount		= tp->t_mountp,
+		.trans		= tp,
+	};
+	int			error;		/* error value */
+	xfs_rtxnum_t		r;		/* result allocated rtext */
+	xfs_fileoff_t		sb;		/* summary file block number */
+	struct xfs_buf		*sumbp;		/* summary file block buffer */
 
-	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(args.mount->m_rbmip, XFS_ILOCK_EXCL));
 	ASSERT(minlen > 0 && minlen <= maxlen);
 
 	/*
@@ -1229,11 +1238,11 @@ xfs_rtallocate_extent(
 retry:
 	sumbp = NULL;
 	if (start == 0) {
-		error = xfs_rtallocate_extent_size(mp, tp, minlen, maxlen, len,
-				&sumbp,	&sb, prod, &r);
+		error = xfs_rtallocate_extent_size(&args, minlen,
+				maxlen, len, &sumbp, &sb, prod, &r);
 	} else {
-		error = xfs_rtallocate_extent_near(mp, tp, start, minlen, maxlen,
-				len, &sumbp, &sb, prod, &r);
+		error = xfs_rtallocate_extent_near(&args, start, minlen,
+				maxlen, len, &sumbp, &sb, prod, &r);
 	}
 
 	if (error)

