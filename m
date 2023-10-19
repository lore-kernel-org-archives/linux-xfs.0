Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF3BCDB483
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 00:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjJSABQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 20:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjJSABP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 20:01:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D7AFA
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 17:01:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCE8C433C7;
        Thu, 19 Oct 2023 00:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697673673;
        bh=48HvR6kjejywLx1Wmn0Q+hNJlBuq2EvO18KtNBBOpUM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pp6KvU6mWxPbmx4HU6sk2f9qRvWr/7XlNZ1WCfMTgB8wJzatfuZfSZ9EsLbmqMSM4
         YifoXs1YFyRwB9sK6nQMC1cefbC8R9wJvqTrrMnfuqmqtrkflZUfEZC1RhyjOMevc4
         4+r2jLd5YyhLSnXjBe2Gy5vEs1jJrcH+eJTIgSWp0HmiPlBijA1S7IEXNV80y21giV
         m9dgTFBvkAyso7hdT6a0mFoqGt87FEyjqS8De2G8cdin+R/sLqxc7eiOTCjwNQEHXh
         4HPvsxeg314MiXIUltTLNIWC6qLvzOnGrYvjtj8yWFbHB7UaPIBLs3aU9wNJxDqhDK
         zPbLzalLEFLaA==
Subject: [PATCH 4/9] xfs: simplify rt bitmap/summary block accessor functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, osandov@osandov.com,
        hch@lst.de
Date:   Wed, 18 Oct 2023 17:01:12 -0700
Message-ID: <169767367256.4127997.17671935176137544426.stgit@frogsfrogsfrogs>
In-Reply-To: <169767364977.4127997.1556211251650244714.stgit@frogsfrogsfrogs>
References: <169767364977.4127997.1556211251650244714.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Simplify the calling convention of these functions since the
xfs_rtalloc_args structure contains the parameters we need.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   61 ++++++++++++++++++++----------------------
 fs/xfs/libxfs/xfs_rtbitmap.h |   46 ++++++++++++++++----------------
 fs/xfs/scrub/rtsummary.c     |    2 +
 3 files changed, 53 insertions(+), 56 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 9867a6f8f56e..9f806af4f720 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -173,7 +173,7 @@ xfs_rtfind_back(
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	incore = xfs_rtbitmap_getword(args->rbmbp, word);
+	incore = xfs_rtbitmap_getword(args, word);
 	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
@@ -228,7 +228,7 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
@@ -267,7 +267,7 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
@@ -327,7 +327,7 @@ xfs_rtfind_forw(
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	incore = xfs_rtbitmap_getword(args->rbmbp, word);
+	incore = xfs_rtbitmap_getword(args, word);
 	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
@@ -381,7 +381,7 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
@@ -418,7 +418,7 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
@@ -439,16 +439,16 @@ xfs_rtfind_forw(
 /* Log rtsummary counter at @infoword. */
 static inline void
 xfs_trans_log_rtsummary(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		infoword)
 {
+	struct xfs_buf		*bp = args->sumbp;
 	size_t			first, last;
 
-	first = (void *)xfs_rsumblock_infoptr(bp, infoword) - bp->b_addr;
+	first = (void *)xfs_rsumblock_infoptr(args, infoword) - bp->b_addr;
 	last = first + sizeof(xfs_suminfo_t) - 1;
 
-	xfs_trans_log_buf(tp, bp, first, last);
+	xfs_trans_log_buf(args->tp, bp, first, last);
 }
 
 /*
@@ -492,8 +492,7 @@ xfs_rtmodify_summary_int(
 	 */
 	infoword = xfs_rtsumoffs_to_infoword(mp, so);
 	if (delta) {
-		xfs_suminfo_t	val = xfs_suminfo_add(args->sumbp, infoword,
-						      delta);
+		xfs_suminfo_t	val = xfs_suminfo_add(args, infoword, delta);
 
 		if (mp->m_rsum_cache) {
 			if (val == 0 && log == mp->m_rsum_cache[bbno])
@@ -501,11 +500,11 @@ xfs_rtmodify_summary_int(
 			if (val != 0 && log < mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno] = log;
 		}
-		xfs_trans_log_rtsummary(args->tp, args->sumbp, infoword);
+		xfs_trans_log_rtsummary(args, infoword);
 		if (sum)
 			*sum = val;
 	} else if (sum) {
-		*sum = xfs_suminfo_get(args->sumbp, infoword);
+		*sum = xfs_suminfo_get(args, infoword);
 	}
 	return 0;
 }
@@ -523,17 +522,17 @@ xfs_rtmodify_summary(
 /* Log rtbitmap block from the word @from to the byte before @next. */
 static inline void
 xfs_trans_log_rtbitmap(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		from,
 	unsigned int		next)
 {
+	struct xfs_buf		*bp = args->rbmbp;
 	size_t			first, last;
 
-	first = (void *)xfs_rbmblock_wordptr(bp, from) - bp->b_addr;
-	last = ((void *)xfs_rbmblock_wordptr(bp, next) - 1) - bp->b_addr;
+	first = (void *)xfs_rbmblock_wordptr(args, from) - bp->b_addr;
+	last = ((void *)xfs_rbmblock_wordptr(args, next) - 1) - bp->b_addr;
 
-	xfs_trans_log_buf(tp, bp, first, last);
+	xfs_trans_log_buf(args->tp, bp, first, last);
 }
 
 /*
@@ -591,12 +590,12 @@ xfs_rtmodify_range(
 		/*
 		 * Set/clear the active bits.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if (val)
 			incore |= mask;
 		else
 			incore &= ~mask;
-		xfs_rtbitmap_setword(args->rbmbp, word, incore);
+		xfs_rtbitmap_setword(args, word, incore);
 		i = lastbit - bit;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -607,8 +606,7 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_rtbitmap(args->tp, args->rbmbp, firstword,
-					word);
+			xfs_trans_log_rtbitmap(args, firstword, word);
 			error = xfs_rtbitmap_read_buf(args, ++block);
 			if (error)
 				return error;
@@ -629,7 +627,7 @@ xfs_rtmodify_range(
 		/*
 		 * Set the word value correctly.
 		 */
-		xfs_rtbitmap_setword(args->rbmbp, word, val);
+		xfs_rtbitmap_setword(args, word, val);
 		i += XFS_NBWORD;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -640,8 +638,7 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_rtbitmap(args->tp, args->rbmbp, firstword,
-					word);
+			xfs_trans_log_rtbitmap(args, firstword, word);
 			error = xfs_rtbitmap_read_buf(args, ++block);
 			if (error)
 				return error;
@@ -661,19 +658,19 @@ xfs_rtmodify_range(
 		/*
 		 * Set/clear the active bits.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if (val)
 			incore |= mask;
 		else
 			incore &= ~mask;
-		xfs_rtbitmap_setword(args->rbmbp, word, incore);
+		xfs_rtbitmap_setword(args, word, incore);
 		word++;
 	}
 	/*
 	 * Log any remaining changed bytes.
 	 */
 	if (word > firstword)
-		xfs_trans_log_rtbitmap(args->tp, args->rbmbp, firstword, word);
+		xfs_trans_log_rtbitmap(args, firstword, word);
 	return 0;
 }
 
@@ -810,7 +807,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
@@ -849,7 +846,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if ((wdiff = incore ^ val)) {
 			/*
 			 * Different, compute first wrong bit and return.
@@ -887,7 +884,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 9516bc333828..c0637057d69c 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -6,6 +6,17 @@
 #ifndef __XFS_RTBITMAP_H__
 #define	__XFS_RTBITMAP_H__
 
+struct xfs_rtalloc_args {
+	struct xfs_mount	*mp;
+	struct xfs_trans	*tp;
+
+	struct xfs_buf		*rbmbp;	/* bitmap block buffer */
+	struct xfs_buf		*sumbp;	/* summary block buffer */
+
+	xfs_fileoff_t		rbmoff;	/* bitmap block number */
+	xfs_fileoff_t		sumoff;	/* summary block number */
+};
+
 static inline xfs_rtblock_t
 xfs_rtx_to_rtb(
 	struct xfs_mount	*mp,
@@ -161,10 +172,10 @@ xfs_rbmblock_to_rtx(
 /* Return a pointer to a bitmap word within a rt bitmap block. */
 static inline union xfs_rtword_raw *
 xfs_rbmblock_wordptr(
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		index)
 {
-	union xfs_rtword_raw	*words = bp->b_addr;
+	union xfs_rtword_raw	*words = args->rbmbp->b_addr;
 
 	return words + index;
 }
@@ -172,10 +183,10 @@ xfs_rbmblock_wordptr(
 /* Convert an ondisk bitmap word to its incore representation. */
 static inline xfs_rtword_t
 xfs_rtbitmap_getword(
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		index)
 {
-	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(bp, index);
+	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(args, index);
 
 	return word->old;
 }
@@ -183,11 +194,11 @@ xfs_rtbitmap_getword(
 /* Set an ondisk bitmap word from an incore representation. */
 static inline void
 xfs_rtbitmap_setword(
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		index,
 	xfs_rtword_t		value)
 {
-	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(bp, index);
+	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(args, index);
 
 	word->old = value;
 }
@@ -234,10 +245,10 @@ xfs_rtsumoffs_to_infoword(
 /* Return a pointer to a summary info word within a rt summary block. */
 static inline union xfs_suminfo_raw *
 xfs_rsumblock_infoptr(
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		index)
 {
-	union xfs_suminfo_raw	*info = bp->b_addr;
+	union xfs_suminfo_raw	*info = args->sumbp->b_addr;
 
 	return info + index;
 }
@@ -245,10 +256,10 @@ xfs_rsumblock_infoptr(
 /* Get the current value of a summary counter. */
 static inline xfs_suminfo_t
 xfs_suminfo_get(
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		index)
 {
-	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(bp, index);
+	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(args, index);
 
 	return info->old;
 }
@@ -256,11 +267,11 @@ xfs_suminfo_get(
 /* Add to the current value of a summary counter and return the new value. */
 static inline xfs_suminfo_t
 xfs_suminfo_add(
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		index,
 	int			delta)
 {
-	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(bp, index);
+	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(args, index);
 
 	info->old += delta;
 	return info->old;
@@ -281,17 +292,6 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 	void				*priv);
 
 #ifdef CONFIG_XFS_RT
-struct xfs_rtalloc_args {
-	struct xfs_mount	*mp;
-	struct xfs_trans	*tp;
-
-	struct xfs_buf		*rbmbp;	/* bitmap block buffer */
-	struct xfs_buf		*sumbp;	/* summary block buffer */
-
-	xfs_fileoff_t		rbmoff;	/* bitmap block number */
-	xfs_fileoff_t		sumoff;	/* summary block number */
-};
-
 void xfs_rtbuf_cache_relse(struct xfs_rtalloc_args *args);
 
 int xfs_rtbuf_get(struct xfs_rtalloc_args *args, xfs_fileoff_t block,
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index cc5ae050dfb2..8b15c47408d0 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -231,7 +231,7 @@ xchk_rtsum_compare(
 			return error;
 		}
 
-		ondisk_info = xfs_rsumblock_infoptr(args.sumbp, 0);
+		ondisk_info = xfs_rsumblock_infoptr(&args, 0);
 		if (memcmp(ondisk_info, sc->buf,
 					mp->m_blockwsize << XFS_WORDLOG) != 0)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, off);

