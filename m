Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBAA57872
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998986; cv=none; b=Ph4K17sVX0kFCL9l6VgPd6dGkzWMVzgKIUt+GcgWInEB/xH94ym8k/6rDuLmmdR+YqwDRJb6hSVMLAXXFuHZMMEpyjzukzVAVMHuDUVFrrVbRVlnkAfW37KVKyv8epCSV2+Mqx9f+mq0gr3x4gyNiinXKBMHKxKQQtqxnkr+gkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998986; c=relaxed/simple;
	bh=gxUSt//5D8i/CKRHGXmQHxicDiI6MN5QPutSc2eCIqM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzDtBDPwqTZrc1qtYf9rqsAtrbOssZ3NJqvyVEazB3zJE/mYnIapwF4nmvpB9PRtVXjHOsKwy66Deew+2a2ZTuRfv/e/PK6EJqYv3TumNh/3gJN1Tbs+1IRtQqHjfHULW7vIc86ZMe0PSfrR9ICAr17/2yCGzMX429lyWRMJIGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z1EZ4JYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z1EZ4JYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF72DC43399
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998986;
	bh=gxUSt//5D8i/CKRHGXmQHxicDiI6MN5QPutSc2eCIqM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Z1EZ4JYuswUF5BTD74ZYfBJHvKFinr5QtCaIterB+tZpll66grIrWL9dahrHMcTAk
	 UI4053yd8EbpyuMJTy/w+kmEL/ojrEf5aRniTCONwltTtmWkkccoe1v09OQSNFVFYP
	 GCRoHdf9dauYnrmc/wMYRXYDkQMCRq7uSYe7EmxZs6Q5HbXQPCzxBf97yksadGdibk
	 FQm70sjnv+fHJ6oDTL4W3X/L0zZXuspwdXA9M1OUBQPDOWx0uMdq0M/LwIzFLf6Q2T
	 +tRQrZEL+xPqJWWh2X2kSxM4DWn+LJsAOaf048f3/2dVxNywp8Y32okXPuEv5XOCnR
	 T913cIBdzV9HA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 29/35] xfs: simplify xfs_rtbuf_get calling conventions
Date: Thu, 15 Feb 2024 13:08:41 +0100
Message-ID: <20240215120907.1542854-30-cem@kernel.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 5b1d0ae9753f0654ab56c1e06155b3abf2919d71

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
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.c | 115 ++++++++++++++++++------------------------
 libxfs/xfs_rtbitmap.h |  22 +++++++-
 2 files changed, 69 insertions(+), 68 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index e9c70ff88..bc3ce7bce 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -70,8 +70,7 @@ int
 xfs_rtbuf_get(
 	struct xfs_rtalloc_args	*args,
 	xfs_fileoff_t		block,	/* block number in bitmap or summary */
-	int			issum,	/* is summary not bitmap */
-	struct xfs_buf		**bpp)	/* output: buffer for the block */
+	int			issum)	/* is summary not bitmap */
 {
 	struct xfs_mount	*mp = args->mp;
 	struct xfs_buf		**cbpp;	/* cached block buffer */
@@ -98,10 +97,9 @@ xfs_rtbuf_get(
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
@@ -126,7 +124,7 @@ xfs_rtbuf_get(
 		return error;
 
 	xfs_trans_buf_set_type(args->tp, bp, type);
-	*cbpp = *bpp = bp;
+	*cbpp = bp;
 	*coffp = block;
 	return 0;
 }
@@ -145,7 +143,6 @@ xfs_rtfind_back(
 	struct xfs_mount	*mp = args->mp;
 	int			bit;	/* bit number in the word */
 	xfs_fileoff_t		block;	/* bitmap block number */
-	struct xfs_buf		*bp;	/* buf for the block */
 	int			error;	/* error value */
 	xfs_rtxnum_t		firstbit; /* first useful bit in the word */
 	xfs_rtxnum_t		i;	/* current bit number rel. to start */
@@ -160,10 +157,9 @@ xfs_rtfind_back(
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
@@ -175,7 +171,7 @@ xfs_rtfind_back(
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	incore = xfs_rtbitmap_getword(bp, word);
+	incore = xfs_rtbitmap_getword(args->rbmbp, word);
 	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
@@ -210,10 +206,9 @@ xfs_rtfind_back(
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
@@ -231,7 +226,7 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
@@ -249,10 +244,9 @@ xfs_rtfind_back(
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
@@ -271,7 +265,7 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
@@ -303,7 +297,6 @@ xfs_rtfind_forw(
 	struct xfs_mount	*mp = args->mp;
 	int			bit;	/* bit number in the word */
 	xfs_fileoff_t		block;	/* bitmap block number */
-	struct xfs_buf		*bp;	/* buf for the block */
 	int			error;
 	xfs_rtxnum_t		i;	/* current bit number rel. to start */
 	xfs_rtxnum_t		lastbit;/* last useful bit in the word */
@@ -318,10 +311,9 @@ xfs_rtfind_forw(
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
@@ -333,7 +325,7 @@ xfs_rtfind_forw(
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	incore = xfs_rtbitmap_getword(bp, word);
+	incore = xfs_rtbitmap_getword(args->rbmbp, word);
 	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
@@ -367,10 +359,9 @@ xfs_rtfind_forw(
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
@@ -388,7 +379,7 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
@@ -406,10 +397,9 @@ xfs_rtfind_forw(
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
@@ -426,7 +416,7 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
@@ -477,7 +467,6 @@ xfs_rtmodify_summary_int(
 	xfs_suminfo_t		*sum)	/* out: summary info for this block */
 {
 	struct xfs_mount	*mp = args->mp;
-	struct xfs_buf		*bp;	/* buffer for the summary block */
 	int			error;
 	xfs_fileoff_t		sb;	/* summary fsblock */
 	xfs_rtsumoff_t		so;	/* index into the summary file */
@@ -492,7 +481,7 @@ xfs_rtmodify_summary_int(
 	 */
 	sb = xfs_rtsumoffs_to_block(mp, so);
 
-	error = xfs_rtbuf_get(args, sb, 1, &bp);
+	error = xfs_rtsummary_read_buf(args, sb);
 	if (error)
 		return error;
 
@@ -501,7 +490,8 @@ xfs_rtmodify_summary_int(
 	 */
 	infoword = xfs_rtsumoffs_to_infoword(mp, so);
 	if (delta) {
-		xfs_suminfo_t	val = xfs_suminfo_add(bp, infoword, delta);
+		xfs_suminfo_t	val = xfs_suminfo_add(args->sumbp, infoword,
+						      delta);
 
 		if (mp->m_rsum_cache) {
 			if (val == 0 && log == mp->m_rsum_cache[bbno])
@@ -509,11 +499,11 @@ xfs_rtmodify_summary_int(
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
@@ -558,7 +548,6 @@ xfs_rtmodify_range(
 	struct xfs_mount	*mp = args->mp;
 	int			bit;	/* bit number in the word */
 	xfs_fileoff_t		block;	/* bitmap block number */
-	struct xfs_buf		*bp;	/* buf for the block */
 	int			error;
 	int			i;	/* current bit number rel. to start */
 	int			lastbit; /* last useful bit in word */
@@ -574,10 +563,9 @@ xfs_rtmodify_range(
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
@@ -601,12 +589,12 @@ xfs_rtmodify_range(
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
@@ -617,12 +605,11 @@ xfs_rtmodify_range(
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
@@ -640,7 +627,7 @@ xfs_rtmodify_range(
 		/*
 		 * Set the word value correctly.
 		 */
-		xfs_rtbitmap_setword(bp, word, val);
+		xfs_rtbitmap_setword(args->rbmbp, word, val);
 		i += XFS_NBWORD;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -651,9 +638,9 @@ xfs_rtmodify_range(
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
 
@@ -672,19 +659,19 @@ xfs_rtmodify_range(
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
 
@@ -777,7 +764,6 @@ xfs_rtcheck_range(
 	struct xfs_mount	*mp = args->mp;
 	int			bit;	/* bit number in the word */
 	xfs_fileoff_t		block;	/* bitmap block number */
-	struct xfs_buf		*bp;	/* buf for the block */
 	int			error;
 	xfs_rtxnum_t		i;	/* current bit number rel. to start */
 	xfs_rtxnum_t		lastbit; /* last useful bit in word */
@@ -793,10 +779,9 @@ xfs_rtcheck_range(
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
@@ -823,7 +808,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
@@ -842,10 +827,9 @@ xfs_rtcheck_range(
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
@@ -863,7 +847,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if ((wdiff = incore ^ val)) {
 			/*
 			 * Different, compute first wrong bit and return.
@@ -882,10 +866,9 @@ xfs_rtcheck_range(
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
@@ -902,7 +885,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(bp, word);
+		incore = xfs_rtbitmap_getword(args->rbmbp, word);
 		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index ac8cd1412..b5505da7a 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -298,7 +298,24 @@ typedef int (*xfs_rtalloc_query_range_fn)(
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
@@ -351,7 +368,8 @@ unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
 # define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
 # define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
-# define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
+# define xfs_rtbitmap_read_buf(a,b)			(-ENOSYS)
+# define xfs_rtsummary_read_buf(a,b)			(-ENOSYS)
 # define xfs_rtbuf_cache_relse(a)			(0)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 static inline xfs_filblks_t
-- 
2.43.0

