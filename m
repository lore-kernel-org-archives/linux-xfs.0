Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2274CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbjJSQ30 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbjJSQ3Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:29:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB449B
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:29:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A4CC433C8;
        Thu, 19 Oct 2023 16:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732962;
        bh=LoeRHgC3cBGSixFfP3JwzyXnkf+zjNdErTvKUD5X/xQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=PgGc7fe2pPTVXEf8hoKS8Gc6LjsowIIAOegBAQv+l1OQKy/7htkyPEctxrbx9IXMv
         /plwcwyUr3jpnY2aFklxJGlRlGtoqnrG/DkDFVKn8vVZSd0G9Cmb23dFB6c9GleQd1
         ypmDZtVBMFb2tfiWQ+2sxBW8y/Xk9cuvXnWUDNB1zZHmBLJEjAZr/VgPiCdUSh2EG8
         o1g8Q2Q17F0HfrtxEB/F3BeHkWBN/IjUYn/YADmkUCCUoCd9QkFwVwdjX3tmgFyuRT
         QFNdHZcNK7ht8FW4j+pErPuFv29Ikqxqn00KZpokFjui2hLk/tRHeFYyuKLFfSPb47
         KAP5SG8kn3reQ==
Date:   Thu, 19 Oct 2023 09:29:22 -0700
Subject: [PATCH 3/9] xfs: simplify xfs_rtbuf_get calling conventions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@osandov.com, osandov@fb.com, hch@lst.de
Message-ID: <169773211770.225862.7103372176762288412.stgit@frogsfrogsfrogs>
In-Reply-To: <169773211712.225862.9408784830071081083.stgit@frogsfrogsfrogs>
References: <169773211712.225862.9408784830071081083.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that xfs_rtalloc_args holds references to the last-read bitmap and
summary blocks, we don't need to pass the buffer pointer out of
xfs_rtbuf_get.

Callers no longer have to xfs_trans_brelse on their own, though they are
required to call xfs_rtbuf_cache_relse before the xfs_rtalloc_args goes
out of scope.

While we're at it, create some trivial helpers so that we don't have to
remember if "0" means "bitmap" and "1" means "summary".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |  115 ++++++++++++++++++------------------------
 fs/xfs/libxfs/xfs_rtbitmap.h |   22 +++++++-
 fs/xfs/scrub/rtsummary.c     |    5 +-
 3 files changed, 71 insertions(+), 71 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 5a2d5eaaba57..9867a6f8f56e 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -72,8 +72,7 @@ int
 xfs_rtbuf_get(
 	struct xfs_rtalloc_args	*args,
 	xfs_fileoff_t		block,	/* block number in bitmap or summary */
-	int			issum,	/* is summary not bitmap */
-	struct xfs_buf		**bpp)	/* output: buffer for the block */
+	int			issum)	/* is summary not bitmap */
 {
 	struct xfs_mount	*mp = args->mp;
 	struct xfs_buf		**cbpp;	/* cached block buffer */
@@ -100,10 +99,9 @@ xfs_rtbuf_get(
 	/*
 	 * If we have a cached buffer, and the block number matches, use that.
 	 */
-	if (*cbpp && *coffp == block) {
-		*bpp = *cbpp;
+	if (*cbpp && *coffp == block)
 		return 0;
-	}
+
 	/*
 	 * Otherwise we have to have to get the buffer.  If there was an old
 	 * one, get rid of it first.
@@ -128,7 +126,7 @@ xfs_rtbuf_get(
 		return error;
 
 	xfs_trans_buf_set_type(args->tp, bp, type);
-	*cbpp = *bpp = bp;
+	*cbpp = bp;
 	*coffp = block;
 	return 0;
 }
@@ -147,7 +145,6 @@ xfs_rtfind_back(
 	struct xfs_mount	*mp = args->mp;
 	int			bit;	/* bit number in the word */
 	xfs_fileoff_t		block;	/* bitmap block number */
-	struct xfs_buf		*bp;	/* buf for the block */
 	int			error;	/* error value */
 	xfs_rtxnum_t		firstbit; /* first useful bit in the word */
 	xfs_rtxnum_t		i;	/* current bit number rel. to start */
@@ -162,10 +159,9 @@ xfs_rtfind_back(
 	 * Compute and read in starting bitmap block for starting block.
 	 */
 	block = xfs_rtx_to_rbmblock(mp, start);
-	error = xfs_rtbuf_get(args, block, 0, &bp);
-	if (error) {
+	error = xfs_rtbitmap_read_buf(args, block);
+	if (error)
 		return error;
-	}
 
 	/*
 	 * Get the first word's index & point to it.
@@ -177,7 +173,7 @@ xfs_rtfind_back(
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	incore = xfs_rtbitmap_getword(bp, word);
+	incore = xfs_rtbitmap_getword(args->rbmbp, word);
 	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
@@ -212,10 +208,9 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			error = xfs_rtbuf_get(args, --block, 0, &bp);
-			if (error) {
+			error = xfs_rtbitmap_read_buf(args, --block);
+			if (error)
 				return error;
-			}
 
 			word = mp->m_blockwsize - 1;
 		}
@@ -233,7 +228,7 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
@@ -251,10 +246,9 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			error = xfs_rtbuf_get(args, --block, 0, &bp);
-			if (error) {
+			error = xfs_rtbitmap_read_buf(args, --block);
+			if (error)
 				return error;
-			}
 
 			word = mp->m_blockwsize - 1;
 		}
@@ -273,7 +267,7 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
@@ -305,7 +299,6 @@ xfs_rtfind_forw(
 	struct xfs_mount	*mp = args->mp;
 	int			bit;	/* bit number in the word */
 	xfs_fileoff_t		block;	/* bitmap block number */
-	struct xfs_buf		*bp;	/* buf for the block */
 	int			error;
 	xfs_rtxnum_t		i;	/* current bit number rel. to start */
 	xfs_rtxnum_t		lastbit;/* last useful bit in the word */
@@ -320,10 +313,9 @@ xfs_rtfind_forw(
 	 * Compute and read in starting bitmap block for starting block.
 	 */
 	block = xfs_rtx_to_rbmblock(mp, start);
-	error = xfs_rtbuf_get(args, block, 0, &bp);
-	if (error) {
+	error = xfs_rtbitmap_read_buf(args, block);
+	if (error)
 		return error;
-	}
 
 	/*
 	 * Get the first word's index & point to it.
@@ -335,7 +327,7 @@ xfs_rtfind_forw(
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	incore = xfs_rtbitmap_getword(bp, word);
+	incore = xfs_rtbitmap_getword(args->rbmbp, word);
 	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
@@ -369,10 +361,9 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			error = xfs_rtbuf_get(args, ++block, 0, &bp);
-			if (error) {
+			error = xfs_rtbitmap_read_buf(args, ++block);
+			if (error)
 				return error;
-			}
 
 			word = 0;
 		}
@@ -390,7 +381,7 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
@@ -408,10 +399,9 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			error = xfs_rtbuf_get(args, ++block, 0, &bp);
-			if (error) {
+			error = xfs_rtbitmap_read_buf(args, ++block);
+			if (error)
 				return error;
-			}
 
 			word = 0;
 		}
@@ -428,7 +418,7 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
@@ -479,7 +469,6 @@ xfs_rtmodify_summary_int(
 	xfs_suminfo_t		*sum)	/* out: summary info for this block */
 {
 	struct xfs_mount	*mp = args->mp;
-	struct xfs_buf		*bp;	/* buffer for the summary block */
 	int			error;
 	xfs_fileoff_t		sb;	/* summary fsblock */
 	xfs_rtsumoff_t		so;	/* index into the summary file */
@@ -494,7 +483,7 @@ xfs_rtmodify_summary_int(
 	 */
 	sb = xfs_rtsumoffs_to_block(mp, so);
 
-	error = xfs_rtbuf_get(args, sb, 1, &bp);
+	error = xfs_rtsummary_read_buf(args, sb);
 	if (error)
 		return error;
 
@@ -503,7 +492,8 @@ xfs_rtmodify_summary_int(
 	 */
 	infoword = xfs_rtsumoffs_to_infoword(mp, so);
 	if (delta) {
-		xfs_suminfo_t	val = xfs_suminfo_add(bp, infoword, delta);
+		xfs_suminfo_t	val = xfs_suminfo_add(args->sumbp, infoword,
+						      delta);
 
 		if (mp->m_rsum_cache) {
 			if (val == 0 && log == mp->m_rsum_cache[bbno])
@@ -511,11 +501,11 @@ xfs_rtmodify_summary_int(
 			if (val != 0 && log < mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno] = log;
 		}
-		xfs_trans_log_rtsummary(args->tp, bp, infoword);
+		xfs_trans_log_rtsummary(args->tp, args->sumbp, infoword);
 		if (sum)
 			*sum = val;
 	} else if (sum) {
-		*sum = xfs_suminfo_get(bp, infoword);
+		*sum = xfs_suminfo_get(args->sumbp, infoword);
 	}
 	return 0;
 }
@@ -560,7 +550,6 @@ xfs_rtmodify_range(
 	struct xfs_mount	*mp = args->mp;
 	int			bit;	/* bit number in the word */
 	xfs_fileoff_t		block;	/* bitmap block number */
-	struct xfs_buf		*bp;	/* buf for the block */
 	int			error;
 	int			i;	/* current bit number rel. to start */
 	int			lastbit; /* last useful bit in word */
@@ -576,10 +565,9 @@ xfs_rtmodify_range(
 	/*
 	 * Read the bitmap block, and point to its data.
 	 */
-	error = xfs_rtbuf_get(args, block, 0, &bp);
-	if (error) {
+	error = xfs_rtbitmap_read_buf(args, block);
+	if (error)
 		return error;
-	}
 
 	/*
 	 * Compute the starting word's address, and starting bit.
@@ -603,12 +591,12 @@ xfs_rtmodify_range(
 		/*
 		 * Set/clear the active bits.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if (val)
 			incore |= mask;
 		else
 			incore &= ~mask;
-		xfs_rtbitmap_setword(bp, word, incore);
+		xfs_rtbitmap_setword(args->rbmbp, word, incore);
 		i = lastbit - bit;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -619,12 +607,11 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_rtbitmap(args->tp, bp, firstword,
+			xfs_trans_log_rtbitmap(args->tp, args->rbmbp, firstword,
 					word);
-			error = xfs_rtbuf_get(args, ++block, 0, &bp);
-			if (error) {
+			error = xfs_rtbitmap_read_buf(args, ++block);
+			if (error)
 				return error;
-			}
 
 			firstword = word = 0;
 		}
@@ -642,7 +629,7 @@ xfs_rtmodify_range(
 		/*
 		 * Set the word value correctly.
 		 */
-		xfs_rtbitmap_setword(bp, word, val);
+		xfs_rtbitmap_setword(args->rbmbp, word, val);
 		i += XFS_NBWORD;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -653,9 +640,9 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_rtbitmap(args->tp, bp, firstword,
+			xfs_trans_log_rtbitmap(args->tp, args->rbmbp, firstword,
 					word);
-			error = xfs_rtbuf_get(args, ++block, 0, &bp);
+			error = xfs_rtbitmap_read_buf(args, ++block);
 			if (error)
 				return error;
 
@@ -674,19 +661,19 @@ xfs_rtmodify_range(
 		/*
 		 * Set/clear the active bits.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if (val)
 			incore |= mask;
 		else
 			incore &= ~mask;
-		xfs_rtbitmap_setword(bp, word, incore);
+		xfs_rtbitmap_setword(args->rbmbp, word, incore);
 		word++;
 	}
 	/*
 	 * Log any remaining changed bytes.
 	 */
 	if (word > firstword)
-		xfs_trans_log_rtbitmap(args->tp, bp, firstword, word);
+		xfs_trans_log_rtbitmap(args->tp, args->rbmbp, firstword, word);
 	return 0;
 }
 
@@ -779,7 +766,6 @@ xfs_rtcheck_range(
 	struct xfs_mount	*mp = args->mp;
 	int			bit;	/* bit number in the word */
 	xfs_fileoff_t		block;	/* bitmap block number */
-	struct xfs_buf		*bp;	/* buf for the block */
 	int			error;
 	xfs_rtxnum_t		i;	/* current bit number rel. to start */
 	xfs_rtxnum_t		lastbit; /* last useful bit in word */
@@ -795,10 +781,9 @@ xfs_rtcheck_range(
 	/*
 	 * Read the bitmap block.
 	 */
-	error = xfs_rtbuf_get(args, block, 0, &bp);
-	if (error) {
+	error = xfs_rtbitmap_read_buf(args, block);
+	if (error)
 		return error;
-	}
 
 	/*
 	 * Compute the starting word's address, and starting bit.
@@ -825,7 +810,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
@@ -844,10 +829,9 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			error = xfs_rtbuf_get(args, ++block, 0, &bp);
-			if (error) {
+			error = xfs_rtbitmap_read_buf(args, ++block);
+			if (error)
 				return error;
-			}
 
 			word = 0;
 		}
@@ -865,7 +849,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if ((wdiff = incore ^ val)) {
 			/*
 			 * Different, compute first wrong bit and return.
@@ -884,10 +868,9 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			error = xfs_rtbuf_get(args, ++block, 0, &bp);
-			if (error) {
+			error = xfs_rtbitmap_read_buf(args, ++block);
+			if (error)
 				return error;
-			}
 
 			word = 0;
 		}
@@ -904,7 +887,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 253f5b763a6c..3bda0c175812 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -295,7 +295,24 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 void xfs_rtbuf_cache_relse(struct xfs_rtalloc_args *args);
 
 int xfs_rtbuf_get(struct xfs_rtalloc_args *args, xfs_fileoff_t block,
-		int issum, struct xfs_buf **bpp);
+		int issum);
+
+static inline int
+xfs_rtbitmap_read_buf(
+	struct xfs_rtalloc_args		*args,
+	xfs_fileoff_t			block)
+{
+	return xfs_rtbuf_get(args, block, 0);
+}
+
+static inline int
+xfs_rtsummary_read_buf(
+	struct xfs_rtalloc_args		*args,
+	xfs_fileoff_t			block)
+{
+	return xfs_rtbuf_get(args, block, 1);
+}
+
 int xfs_rtcheck_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 		xfs_rtxlen_t len, int val, xfs_rtxnum_t *new, int *stat);
 int xfs_rtfind_back(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
@@ -348,7 +365,8 @@ unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
 # define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
 # define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
-# define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
+# define xfs_rtbitmap_read_buf(a,b)			(-ENOSYS)
+# define xfs_rtsummary_read_buf(a,b)			(-ENOSYS)
 # define xfs_rtbuf_cache_relse(a)			(0)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 static inline xfs_filblks_t
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index ec17385fe4b0..cc5ae050dfb2 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -193,7 +193,6 @@ xchk_rtsum_compare(
 		.tp		= sc->tp,
 	};
 	struct xfs_mount	*mp = sc->mp;
-	struct xfs_buf		*bp;
 	struct xfs_bmbt_irec	map;
 	xfs_fileoff_t		off;
 	xchk_rtsumoff_t		sumoff = 0;
@@ -221,7 +220,7 @@ xchk_rtsum_compare(
 		}
 
 		/* Read a block's worth of ondisk rtsummary file. */
-		error = xfs_rtbuf_get(&args, off, 1, &bp);
+		error = xfs_rtsummary_read_buf(&args, off);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, off, &error))
 			return error;
 
@@ -232,7 +231,7 @@ xchk_rtsum_compare(
 			return error;
 		}
 
-		ondisk_info = xfs_rsumblock_infoptr(bp, 0);
+		ondisk_info = xfs_rsumblock_infoptr(args.sumbp, 0);
 		if (memcmp(ondisk_info, sc->buf,
 					mp->m_blockwsize << XFS_WORDLOG) != 0)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, off);

