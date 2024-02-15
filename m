Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDAA57872
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998984; cv=none; b=aa1Vvxb2izZiEdHZQwLPf+GU/VYcWVgldW4YXbPFauDZi1ryO1nDGhlZ8L5WoiBRGs6R134ADrJX4JQhONzctC/ZcAkYVF9zQ03nVpsjuS1TANhAGZ5J551+LPf6+mhDBFjMn/h0YPQ8w6sXdFlqSJVPPRoB0oRBy0dkD60hfcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998984; c=relaxed/simple;
	bh=9sCnNI/dZsC4YE6cV6Yi9BO+eIhqpTIl1WjtGQaFBQg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5+PYhahE1I2Wr+w+Jyu2W5tyKBok8pfbV3xgZ1Vw1HvY4umFnWx6Ke9K+jNNPp/UmE8SgfLj6+G7sJYVUF4+xvdU0IRJsShBChP/p2UczhTnisMt+T+sdZfW83PuNx6scubAIrLj4V068OJNkweS2JENSXcD89MRtfM1JORNNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uO1OHjJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uO1OHjJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38137C433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998984;
	bh=9sCnNI/dZsC4YE6cV6Yi9BO+eIhqpTIl1WjtGQaFBQg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=uO1OHjJphKE9HV72vZi+xNNqTyN+jbj4EJP7+u3SnVp2WMT0dp9Tb8naKSKM753Bc
	 ezAlT/LDKN2iQtm7hW7Ix+LtXs3/nVS36F8wN0SF9jAAvxYKLfYLjaxczshx+GEOtt
	 QWFJ4XHoLszth7y/nfjlYlg5s2SLj9zWws3T4zsuAwt9v8sTEmtiHUZNjaEKcKZQY7
	 Ag0zPXqZMIV/Z805jGuEe8Pu+nnJMIJyOydotpcv1q0Nfbr4Ku0z9nbP6DVkOcb6iJ
	 ayxzgn4vIFCOOEBPLWuVZuJpx2vP4AaKKD4MFKkx7B6QajTmRG5BX6+xnaI5YMnujU
	 jOACouPAqgNXw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 27/35] xfs: consolidate realtime allocation arguments
Date: Thu, 15 Feb 2024 13:08:39 +0100
Message-ID: <20240215120907.1542854-28-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 41f33d82cfd310e344fc9183f02cc9e0d2d27663

Consolidate the arguments passed around the rt allocator into a
struct xfs_rtalloc_arg similar to how the btree allocator arguments
are consolidated in a struct xfs_alloc_arg....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.c | 368 +++++++++++++++++++++---------------------
 libxfs/xfs_rtbitmap.h |  46 +++---
 2 files changed, 211 insertions(+), 203 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 869d26e79..53e2c1c89 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -51,17 +51,17 @@ const struct xfs_buf_ops xfs_rtbuf_ops = {
  */
 int
 xfs_rtbuf_get(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_fileoff_t	block,		/* block number in bitmap or summary */
-	int		issum,		/* is summary not bitmap */
-	struct xfs_buf	**bpp)		/* output: buffer for the block */
+	struct xfs_rtalloc_args	*args,
+	xfs_fileoff_t		block,	/* block number in bitmap or summary */
+	int			issum,	/* is summary not bitmap */
+	struct xfs_buf		**bpp)	/* output: buffer for the block */
 {
-	struct xfs_buf	*bp;		/* block buffer, result */
-	xfs_inode_t	*ip;		/* bitmap or summary inode */
-	xfs_bmbt_irec_t	map;
-	int		nmap = 1;
-	int		error;		/* error value */
+	struct xfs_mount	*mp = args->mp;
+	struct xfs_buf		*bp;	/* block buffer, result */
+	struct xfs_inode	*ip;	/* bitmap or summary inode */
+	struct xfs_bmbt_irec	map;
+	int			nmap = 1;
+	int			error;
 
 	ip = issum ? mp->m_rsumip : mp->m_rbmip;
 
@@ -73,13 +73,13 @@ xfs_rtbuf_get(
 		return -EFSCORRUPTED;
 
 	ASSERT(map.br_startblock != NULLFSBLOCK);
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+	error = xfs_trans_read_buf(mp, args->tp, mp->m_ddev_targp,
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
 				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
 	if (error)
 		return error;
 
-	xfs_trans_buf_set_type(tp, bp, issum ? XFS_BLFT_RTSUMMARY_BUF
+	xfs_trans_buf_set_type(args->tp, bp, issum ? XFS_BLFT_RTSUMMARY_BUF
 					     : XFS_BLFT_RTBITMAP_BUF);
 	*bpp = bp;
 	return 0;
@@ -91,30 +91,30 @@ xfs_rtbuf_get(
  */
 int
 xfs_rtfind_back(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* starting rtext to look at */
-	xfs_rtxnum_t	limit,		/* last rtext to look at */
-	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxnum_t		start,	/* starting rtext to look at */
+	xfs_rtxnum_t		limit,	/* last rtext to look at */
+	xfs_rtxnum_t		*rtx)	/* out: start rtext found */
 {
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
-	unsigned int	word;		/* word number in the buffer */
+	struct xfs_mount	*mp = args->mp;
+	int			bit;	/* bit number in the word */
+	xfs_fileoff_t		block;	/* bitmap block number */
+	struct xfs_buf		*bp;	/* buf for the block */
+	int			error;	/* error value */
+	xfs_rtxnum_t		firstbit; /* first useful bit in the word */
+	xfs_rtxnum_t		i;	/* current bit number rel. to start */
+	xfs_rtxnum_t		len;	/* length of inspected area */
+	xfs_rtword_t		mask;	/* mask of relevant bits for value */
+	xfs_rtword_t		want;	/* mask for "good" values */
+	xfs_rtword_t		wdiff;	/* difference from wanted value */
+	xfs_rtword_t		incore;
+	unsigned int		word;	/* word number in the buffer */
 
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */
 	block = xfs_rtx_to_rbmblock(mp, start);
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(args, block, 0, &bp);
 	if (error) {
 		return error;
 	}
@@ -151,7 +151,7 @@ xfs_rtfind_back(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->tp, bp);
 			i = bit - XFS_RTHIBIT(wdiff);
 			*rtx = start - i + 1;
 			return 0;
@@ -165,8 +165,8 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, --block, 0, &bp);
+			xfs_trans_brelse(args->tp, bp);
+			error = xfs_rtbuf_get(args, --block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -192,7 +192,7 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->tp, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
 			*rtx = start - i + 1;
 			return 0;
@@ -206,8 +206,8 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, --block, 0, &bp);
+			xfs_trans_brelse(args->tp, bp);
+			error = xfs_rtbuf_get(args, --block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -234,7 +234,7 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->tp, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
 			*rtx = start - i + 1;
 			return 0;
@@ -244,7 +244,7 @@ xfs_rtfind_back(
 	/*
 	 * No match, return that we scanned the whole area.
 	 */
-	xfs_trans_brelse(tp, bp);
+	xfs_trans_brelse(args->tp, bp);
 	*rtx = start - i + 1;
 	return 0;
 }
@@ -255,30 +255,30 @@ xfs_rtfind_back(
  */
 int
 xfs_rtfind_forw(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* starting rtext to look at */
-	xfs_rtxnum_t	limit,		/* last rtext to look at */
-	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxnum_t		start,	/* starting rtext to look at */
+	xfs_rtxnum_t		limit,	/* last rtext to look at */
+	xfs_rtxnum_t		*rtx)	/* out: start rtext found */
 {
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
-	unsigned int	word;		/* word number in the buffer */
+	struct xfs_mount	*mp = args->mp;
+	int			bit;	/* bit number in the word */
+	xfs_fileoff_t		block;	/* bitmap block number */
+	struct xfs_buf		*bp;	/* buf for the block */
+	int			error;
+	xfs_rtxnum_t		i;	/* current bit number rel. to start */
+	xfs_rtxnum_t		lastbit;/* last useful bit in the word */
+	xfs_rtxnum_t		len;	/* length of inspected area */
+	xfs_rtword_t		mask;	/* mask of relevant bits for value */
+	xfs_rtword_t		want;	/* mask for "good" values */
+	xfs_rtword_t		wdiff;	/* difference from wanted value */
+	xfs_rtword_t		incore;
+	unsigned int		word;	/* word number in the buffer */
 
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */
 	block = xfs_rtx_to_rbmblock(mp, start);
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(args, block, 0, &bp);
 	if (error) {
 		return error;
 	}
@@ -314,7 +314,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->tp, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
 			*rtx = start + i - 1;
 			return 0;
@@ -328,8 +328,8 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			xfs_trans_brelse(args->tp, bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -355,7 +355,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*rtx = start + i - 1;
 			return 0;
@@ -369,8 +369,8 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			xfs_trans_brelse(args->tp, bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -395,7 +395,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*rtx = start + i - 1;
 			return 0;
@@ -405,7 +405,7 @@ xfs_rtfind_forw(
 	/*
 	 * No match, return that we scanned the whole area.
 	 */
-	xfs_trans_brelse(tp, bp);
+	xfs_trans_brelse(args->tp, bp);
 	*rtx = start + i - 1;
 	return 0;
 }
@@ -436,20 +436,20 @@ xfs_trans_log_rtsummary(
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
+	int			log,	/* log2 of extent size */
+	xfs_fileoff_t		bbno,	/* bitmap block number */
+	int			delta,	/* change to make to summary info */
+	struct xfs_buf		**rbpp,	/* in/out: summary block buffer */
+	xfs_fileoff_t		*rsb,	/* in/out: summary block number */
+	xfs_suminfo_t		*sum)	/* out: summary info for this block */
 {
-	struct xfs_buf	*bp;		/* buffer for the summary block */
-	int		error;		/* error value */
-	xfs_fileoff_t	sb;		/* summary fsblock */
-	xfs_rtsumoff_t	so;		/* index into the summary file */
-	unsigned int	infoword;
+	struct xfs_mount	*mp = args->mp;
+	struct xfs_buf		*bp;	/* buffer for the summary block */
+	int			error;
+	xfs_fileoff_t		sb;	/* summary fsblock */
+	xfs_rtsumoff_t		so;	/* index into the summary file */
+	unsigned int		infoword;
 
 	/*
 	 * Compute entry number in the summary file.
@@ -472,8 +472,8 @@ xfs_rtmodify_summary_int(
 		 * If there was an old one, get rid of it first.
 		 */
 		if (*rbpp)
-			xfs_trans_brelse(tp, *rbpp);
-		error = xfs_rtbuf_get(mp, tp, sb, 1, &bp);
+			xfs_trans_brelse(args->tp, *rbpp);
+		error = xfs_rtbuf_get(args, sb, 1, &bp);
 		if (error) {
 			return error;
 		}
@@ -496,7 +496,7 @@ xfs_rtmodify_summary_int(
 			if (val != 0 && log < mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno] = log;
 		}
-		xfs_trans_log_rtsummary(tp, bp, infoword);
+		xfs_trans_log_rtsummary(args->tp, bp, infoword);
 		if (sum)
 			*sum = val;
 	} else if (sum) {
@@ -507,16 +507,14 @@ xfs_rtmodify_summary_int(
 
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
+	int			log,	/* log2 of extent size */
+	xfs_fileoff_t		bbno,	/* bitmap block number */
+	int			delta,	/* change to make to summary info */
+	struct xfs_buf		**rbpp,	/* in/out: summary block buffer */
+	xfs_fileoff_t		*rsb)	/* in/out: summary block number */
 {
-	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
-					delta, rbpp, rsb, NULL);
+	return xfs_rtmodify_summary_int(args, log, bbno, delta, rbpp, rsb, NULL);
 }
 
 /* Log rtbitmap block from the word @from to the byte before @next. */
@@ -541,22 +539,22 @@ xfs_trans_log_rtbitmap(
  */
 int
 xfs_rtmodify_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* starting rtext to modify */
-	xfs_rtxlen_t	len,		/* length of extent to modify */
-	int		val)		/* 1 for free, 0 for allocated */
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxnum_t		start,	/* starting rtext to modify */
+	xfs_rtxlen_t		len,	/* length of extent to modify */
+	int			val)	/* 1 for free, 0 for allocated */
 {
-	int		bit;		/* bit number in the word */
-	xfs_fileoff_t	block;		/* bitmap block number */
-	struct xfs_buf	*bp;		/* buf for the block */
-	int		error;		/* error value */
-	int		i;		/* current bit number rel. to start */
-	int		lastbit;	/* last useful bit in word */
-	xfs_rtword_t	mask;		/* mask o frelevant bits for value */
-	xfs_rtword_t	incore;
-	unsigned int	firstword;	/* first word used in the buffer */
-	unsigned int	word;		/* word number in the buffer */
+	struct xfs_mount	*mp = args->mp;
+	int			bit;	/* bit number in the word */
+	xfs_fileoff_t		block;	/* bitmap block number */
+	struct xfs_buf		*bp;	/* buf for the block */
+	int			error;
+	int			i;	/* current bit number rel. to start */
+	int			lastbit; /* last useful bit in word */
+	xfs_rtword_t		mask;	 /* mask of relevant bits for value */
+	xfs_rtword_t		incore;
+	unsigned int		firstword; /* first word used in the buffer */
+	unsigned int		word;	/* word number in the buffer */
 
 	/*
 	 * Compute starting bitmap block number.
@@ -565,7 +563,7 @@ xfs_rtmodify_range(
 	/*
 	 * Read the bitmap block, and point to its data.
 	 */
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(args, block, 0, &bp);
 	if (error) {
 		return error;
 	}
@@ -608,8 +606,9 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_rtbitmap(tp, bp, firstword, word);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			xfs_trans_log_rtbitmap(args->tp, bp, firstword,
+					word);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -641,11 +640,11 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_rtbitmap(tp, bp, firstword, word);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
-			if (error) {
+			xfs_trans_log_rtbitmap(args->tp, bp, firstword,
+					word);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
+			if (error)
 				return error;
-			}
 
 			firstword = word = 0;
 		}
@@ -674,7 +673,7 @@ xfs_rtmodify_range(
 	 * Log any remaining changed bytes.
 	 */
 	if (word > firstword)
-		xfs_trans_log_rtbitmap(tp, bp, firstword, word);
+		xfs_trans_log_rtbitmap(args->tp, bp, firstword, word);
 	return 0;
 }
 
@@ -684,23 +683,23 @@ xfs_rtmodify_range(
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
+	xfs_rtxnum_t		start,	/* starting rtext to free */
+	xfs_rtxlen_t		len,	/* length to free */
+	struct xfs_buf		**rbpp,	/* in/out: summary block buffer */
+	xfs_fileoff_t		*rsb)	/* in/out: summary block number */
 {
-	xfs_rtxnum_t	end;		/* end of the freed extent */
-	int		error;		/* error value */
-	xfs_rtxnum_t	postblock;	/* first rtext freed > end */
-	xfs_rtxnum_t	preblock;	/* first rtext freed < start */
+	struct xfs_mount	*mp = args->mp;
+	xfs_rtxnum_t		end;	/* end of the freed extent */
+	int			error;	/* error value */
+	xfs_rtxnum_t		postblock; /* first rtext freed > end */
+	xfs_rtxnum_t		preblock;  /* first rtext freed < start */
 
 	end = start + len - 1;
 	/*
 	 * Modify the bitmap to mark this extent freed.
 	 */
-	error = xfs_rtmodify_range(mp, tp, start, len, 1);
+	error = xfs_rtmodify_range(args, start, len, 1);
 	if (error) {
 		return error;
 	}
@@ -709,14 +708,14 @@ xfs_rtfree_range(
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
@@ -725,7 +724,7 @@ xfs_rtfree_range(
 	 * old extent, add summary data for them to be allocated.
 	 */
 	if (preblock < start) {
-		error = xfs_rtmodify_summary(mp, tp,
+		error = xfs_rtmodify_summary(args,
 			XFS_RTBLOCKLOG(start - preblock),
 			xfs_rtx_to_rbmblock(mp, preblock), -1, rbpp, rsb);
 		if (error) {
@@ -737,7 +736,7 @@ xfs_rtfree_range(
 	 * old extent, add summary data for them to be allocated.
 	 */
 	if (postblock > end) {
-		error = xfs_rtmodify_summary(mp, tp,
+		error = xfs_rtmodify_summary(args,
 			XFS_RTBLOCKLOG(postblock - end),
 			xfs_rtx_to_rbmblock(mp, end + 1), -1, rbpp, rsb);
 		if (error) {
@@ -748,7 +747,7 @@ xfs_rtfree_range(
 	 * Increment the summary information corresponding to the entire
 	 * (new) free extent.
 	 */
-	error = xfs_rtmodify_summary(mp, tp,
+	error = xfs_rtmodify_summary(args,
 		XFS_RTBLOCKLOG(postblock + 1 - preblock),
 		xfs_rtx_to_rbmblock(mp, preblock), 1, rbpp, rsb);
 	return error;
@@ -760,24 +759,24 @@ xfs_rtfree_range(
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
+	xfs_rtxnum_t		start,	/* starting rtext number of extent */
+	xfs_rtxlen_t		len,	/* length of extent */
+	int			val,	/* 1 for free, 0 for allocated */
+	xfs_rtxnum_t		*new,	/* out: first rtext not matching */
+	int			*stat)	/* out: 1 for matches, 0 for not */
 {
-	int		bit;		/* bit number in the word */
-	xfs_fileoff_t	block;		/* bitmap block number */
-	struct xfs_buf	*bp;		/* buf for the block */
-	int		error;		/* error value */
-	xfs_rtxnum_t	i;		/* current bit number rel. to start */
-	xfs_rtxnum_t	lastbit;	/* last useful bit in word */
-	xfs_rtword_t	mask;		/* mask of relevant bits for value */
-	xfs_rtword_t	wdiff;		/* difference from wanted value */
-	xfs_rtword_t	incore;
-	unsigned int	word;		/* word number in the buffer */
+	struct xfs_mount	*mp = args->mp;
+	int			bit;	/* bit number in the word */
+	xfs_fileoff_t		block;	/* bitmap block number */
+	struct xfs_buf		*bp;	/* buf for the block */
+	int			error;
+	xfs_rtxnum_t		i;	/* current bit number rel. to start */
+	xfs_rtxnum_t		lastbit; /* last useful bit in word */
+	xfs_rtword_t		mask;	/* mask of relevant bits for value */
+	xfs_rtword_t		wdiff;	/* difference from wanted value */
+	xfs_rtword_t		incore;
+	unsigned int		word;	/* word number in the buffer */
 
 	/*
 	 * Compute starting bitmap block number
@@ -786,7 +785,7 @@ xfs_rtcheck_range(
 	/*
 	 * Read the bitmap block.
 	 */
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(args, block, 0, &bp);
 	if (error) {
 		return error;
 	}
@@ -821,7 +820,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->tp, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
 			*new = start + i;
 			*stat = 0;
@@ -836,8 +835,8 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			xfs_trans_brelse(args->tp, bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -863,7 +862,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*new = start + i;
 			*stat = 0;
@@ -878,8 +877,8 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			xfs_trans_brelse(args->tp, bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -904,7 +903,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*new = start + i;
 			*stat = 0;
@@ -915,7 +914,7 @@ xfs_rtcheck_range(
 	/*
 	 * Successful, return.
 	 */
-	xfs_trans_brelse(tp, bp);
+	xfs_trans_brelse(args->tp, bp);
 	*new = start + i;
 	*stat = 1;
 	return 0;
@@ -925,55 +924,56 @@ xfs_rtcheck_range(
 /*
  * Check that the given extent (block range) is allocated already.
  */
-STATIC int				/* error */
+STATIC int
 xfs_rtcheck_alloc_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* starting rtext number of extent */
-	xfs_rtxlen_t	len)		/* length of extent */
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxnum_t		start,	/* starting rtext number of extent */
+	xfs_rtxlen_t		len)	/* length of extent */
 {
-	xfs_rtxnum_t	new;		/* dummy for xfs_rtcheck_range */
-	int		stat;
-	int		error;
+	xfs_rtxnum_t		new;	/* dummy for xfs_rtcheck_range */
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
  * realtime extents, as is the block number.
  */
-int					/* error */
+int
 xfs_rtfree_extent(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtxnum_t	start,		/* starting rtext number to free */
-	xfs_rtxlen_t	len)		/* length of extent freed */
+	xfs_trans_t		*tp,	/* transaction pointer */
+	xfs_rtxnum_t		start,	/* starting rtext number to free */
+	xfs_rtxlen_t		len)	/* length of extent freed */
 {
-	int		error;		/* error value */
-	xfs_mount_t	*mp;		/* file system mount structure */
-	xfs_fsblock_t	sb;		/* summary file block number */
-	struct xfs_buf	*sumbp = NULL;	/* summary file block buffer */
-	struct timespec64 atime;
-
-	mp = tp->t_mountp;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_rtalloc_args	args = {
+		.mp		= mp,
+		.tp		= tp,
+	};
+	int			error;
+	xfs_fsblock_t		sb;	/* summary file block number */
+	struct xfs_buf		*sumbp = NULL;	/* summary file block buffer */
+	struct timespec64	atime;
 
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
@@ -1041,6 +1041,10 @@ xfs_rtalloc_query_range(
 	xfs_rtalloc_query_range_fn	fn,
 	void				*priv)
 {
+	struct xfs_rtalloc_args		args = {
+		.mp			= mp,
+		.tp			= tp,
+	};
 	struct xfs_rtalloc_rec		rec;
 	xfs_rtxnum_t			rtstart;
 	xfs_rtxnum_t			rtend;
@@ -1060,13 +1064,13 @@ xfs_rtalloc_query_range(
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
 
@@ -1111,11 +1115,15 @@ xfs_rtalloc_extent_is_free(
 	xfs_rtxlen_t			len,
 	bool				*is_free)
 {
+	struct xfs_rtalloc_args		args = {
+		.mp			= mp,
+		.tp			= tp,
+	};
 	xfs_rtxnum_t			end;
 	int				matches;
 	int				error;
 
-	error = xfs_rtcheck_range(mp, tp, start, len, 1, &end, &matches);
+	error = xfs_rtcheck_range(&args, start, len, 1, &end, &matches);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index e4268faa6..025a7efc2 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -9,6 +9,11 @@
 /* For userspace XFS_RT is always defined */
 #define CONFIG_XFS_RT
 
+struct xfs_rtalloc_args {
+	struct xfs_mount	*mp;
+	struct xfs_trans	*tp;
+};
+
 static inline xfs_rtblock_t
 xfs_rtx_to_rtb(
 	struct xfs_mount	*mp,
@@ -284,29 +289,24 @@ typedef int (*xfs_rtalloc_query_range_fn)(
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
-- 
2.43.0

