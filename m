Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0EF12AAD0
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998980; cv=none; b=fEtbS94F/rMQSCMsIySC+I6u7TPfvffYYZxvWM2GPDKQN2z5DevbUwac7+7rVOMPCMinrC0FOJpGP7gfK/l0Q4nRRUMcxSr+EK5Q2ZJbKoLdfpwk9LbsmycD6dHVPzdGYSJtVpVyvwsD8eXCFcQUoGjCbLaRByI3P+NU9Av1Bj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998980; c=relaxed/simple;
	bh=YCStQVUxbpgtDq8CZQGtxRipKvur8mhevHIiJ1VAZhA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yjmn9JfwOZh2Ry7dEVYi31JBynh0HyvMTb9ZyCRLpsjtAFwGpEe+pW/6RbDwMFiwtFolZtihtBt6b0Xwft8QBOhzRBDzrLklG30vt7MS0RF9AWyhCM/CPpKRIPoCVcnnUtlaUE9yY6AG59521aQLaNQjqakL3nMob8rSTJtr31E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qO10uXEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qO10uXEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CFEC433F1
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998980;
	bh=YCStQVUxbpgtDq8CZQGtxRipKvur8mhevHIiJ1VAZhA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qO10uXEHDheZTteXzWLJNO6qfgFYufrHoFFG4KXvJxx96VpnTFe8WlXWzg3bjXqvm
	 89TK4hnFG/rnxnvUOts9Npjp2rrajETPR8UsGDe2j6xb8ICQJhrTKH7UJO87CyRyR9
	 /LQG8Ci3mtogAlCCMgPIiLM1shNzaWFtIrtvMWB6IrE+1H2O60612/IW+VCA/0fQ9T
	 gAAPv6NiUNsK++85cBDtKHfMQwGdKi5Dg6p6EswONpysdRyRkKg0xPdJfDFmDNkc8n
	 t0xnPFJzQu+c3IS5VFWDCRnurxoyW69cW31MXb2t9cnCgARE1QUvkMpSMDZ9zk1Xw8
	 dDmQ2NNHCjOHQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 24/35] xfs: use accessor functions for bitmap words
Date: Thu, 15 Feb 2024 13:08:36 +0100
Message-ID: <20240215120907.1542854-25-cem@kernel.org>
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

Source kernel commit: 97e993830a1cdd86ad7d207308b9f55a00660edd

Create get and set functions for rtbitmap words so that we can redefine
the ondisk format with a specific endianness.  Note that this requires
the definition of a distinct type for ondisk rtbitmap words so that the
compiler can perform proper typechecking as we go back and forth.

In the upcoming rtgroups feature, we're going to fix the problem that
rtwords are written in host endian order, which means we'll need the
distinct rtword/rtword_raw types.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_format.h   |   8 ++++
 libxfs/xfs_rtbitmap.c | 109 +++++++++++++-----------------------------
 libxfs/xfs_rtbitmap.h |  27 ++++++++++-
 3 files changed, 67 insertions(+), 77 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d48e3a395..2af891d5d 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -690,6 +690,14 @@ struct xfs_agfl {
 	    ASSERT(xfs_daddr_to_agno(mp, d) == \
 		   xfs_daddr_to_agno(mp, (d) + (len) - 1)))
 
+/*
+ * Realtime bitmap information is accessed by the word, which is currently
+ * stored in host-endian format.
+ */
+union xfs_rtword_raw {
+	__u32		old;
+};
+
 /*
  * XFS Timestamps
  * ==============
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 562b40a1a..f7be9ea5f 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -97,7 +97,6 @@ xfs_rtfind_back(
 	xfs_rtxnum_t	limit,		/* last rtext to look at */
 	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -108,6 +107,7 @@ xfs_rtfind_back(
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	want;		/* mask for "good" values */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	xfs_rtword_t	incore;
 	unsigned int	word;		/* word number in the buffer */
 
 	/*
@@ -123,14 +123,14 @@ xfs_rtfind_back(
 	 * Get the first word's index & point to it.
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
-	b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	len = start - limit + 1;
 	/*
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	want = (*b & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
+	incore = xfs_rtbitmap_getword(bp, word);
+	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
 	 * partial word.
@@ -147,7 +147,7 @@ xfs_rtfind_back(
 		 * Calculate the difference between the value there
 		 * and what we're looking for.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different.  Mark where we are and return.
 			 */
@@ -172,12 +172,6 @@ xfs_rtfind_back(
 			}
 
 			word = mp->m_blockwsize - 1;
-			b = xfs_rbmblock_wordptr(bp, word);
-		} else {
-			/*
-			 * Go on to the previous word in the buffer.
-			 */
-			b--;
 		}
 	} else {
 		/*
@@ -193,7 +187,8 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = *b ^ want)) {
+		incore = xfs_rtbitmap_getword(bp, word);
+		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -218,12 +213,6 @@ xfs_rtfind_back(
 			}
 
 			word = mp->m_blockwsize - 1;
-			b = xfs_rbmblock_wordptr(bp, word);
-		} else {
-			/*
-			 * Go on to the previous word in the buffer.
-			 */
-			b--;
 		}
 	}
 	/*
@@ -240,7 +229,8 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		incore = xfs_rtbitmap_getword(bp, word);
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -271,7 +261,6 @@ xfs_rtfind_forw(
 	xfs_rtxnum_t	limit,		/* last rtext to look at */
 	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -282,6 +271,7 @@ xfs_rtfind_forw(
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	want;		/* mask for "good" values */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	xfs_rtword_t	incore;
 	unsigned int	word;		/* word number in the buffer */
 
 	/*
@@ -297,14 +287,14 @@ xfs_rtfind_forw(
 	 * Get the first word's index & point to it.
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
-	b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	len = limit - start + 1;
 	/*
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	want = (*b & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
+	incore = xfs_rtbitmap_getword(bp, word);
+	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
 	 * partial word.
@@ -320,7 +310,7 @@ xfs_rtfind_forw(
 		 * Calculate the difference between the value there
 		 * and what we're looking for.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different.  Mark where we are and return.
 			 */
@@ -345,12 +335,6 @@ xfs_rtfind_forw(
 			}
 
 			word = 0;
-			b = xfs_rbmblock_wordptr(bp, word);
-		} else {
-			/*
-			 * Go on to the previous word in the buffer.
-			 */
-			b++;
 		}
 	} else {
 		/*
@@ -366,7 +350,8 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = *b ^ want)) {
+		incore = xfs_rtbitmap_getword(bp, word);
+		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -391,12 +376,6 @@ xfs_rtfind_forw(
 			}
 
 			word = 0;
-			b = xfs_rbmblock_wordptr(bp, word);
-		} else {
-			/*
-			 * Go on to the next word in the buffer.
-			 */
-			b++;
 		}
 	}
 	/*
@@ -411,7 +390,8 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		incore = xfs_rtbitmap_getword(bp, word);
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -566,15 +546,14 @@ xfs_rtmodify_range(
 	xfs_rtxlen_t	len,		/* length of extent to modify */
 	int		val)		/* 1 for free, 0 for allocated */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	int		error;		/* error value */
-	xfs_rtword_t	*first;		/* first used word in the buffer */
 	int		i;		/* current bit number rel. to start */
 	int		lastbit;	/* last useful bit in word */
 	xfs_rtword_t	mask;		/* mask o frelevant bits for value */
+	xfs_rtword_t	incore;
 	unsigned int	firstword;	/* first word used in the buffer */
 	unsigned int	word;		/* word number in the buffer */
 
@@ -594,7 +573,6 @@ xfs_rtmodify_range(
 	 * Compute the starting word's address, and starting bit.
 	 */
 	firstword = word = xfs_rtx_to_rbmword(mp, start);
-	first = b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
 	 * 0 (allocated) => all zeroes; 1 (free) => all ones.
@@ -613,10 +591,12 @@ xfs_rtmodify_range(
 		/*
 		 * Set/clear the active bits.
 		 */
+		incore = xfs_rtbitmap_getword(bp, word);
 		if (val)
-			*b |= mask;
+			incore |= mask;
 		else
-			*b &= ~mask;
+			incore &= ~mask;
+		xfs_rtbitmap_setword(bp, word, incore);
 		i = lastbit - bit;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -634,12 +614,6 @@ xfs_rtmodify_range(
 			}
 
 			firstword = word = 0;
-			first = b = xfs_rbmblock_wordptr(bp, word);
-		} else {
-			/*
-			 * Go on to the next word in the buffer
-			 */
-			b++;
 		}
 	} else {
 		/*
@@ -655,7 +629,7 @@ xfs_rtmodify_range(
 		/*
 		 * Set the word value correctly.
 		 */
-		*b = val;
+		xfs_rtbitmap_setword(bp, word, val);
 		i += XFS_NBWORD;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -673,12 +647,6 @@ xfs_rtmodify_range(
 			}
 
 			firstword = word = 0;
-			first = b = xfs_rbmblock_wordptr(bp, word);
-		} else {
-			/*
-			 * Go on to the next word in the buffer
-			 */
-			b++;
 		}
 	}
 	/*
@@ -693,17 +661,18 @@ xfs_rtmodify_range(
 		/*
 		 * Set/clear the active bits.
 		 */
+		incore = xfs_rtbitmap_getword(bp, word);
 		if (val)
-			*b |= mask;
+			incore |= mask;
 		else
-			*b &= ~mask;
+			incore &= ~mask;
+		xfs_rtbitmap_setword(bp, word, incore);
 		word++;
-		b++;
 	}
 	/*
 	 * Log any remaining changed bytes.
 	 */
-	if (b > first)
+	if (word > firstword)
 		xfs_trans_log_rtbitmap(tp, bp, firstword, word);
 	return 0;
 }
@@ -798,7 +767,6 @@ xfs_rtcheck_range(
 	xfs_rtxnum_t	*new,		/* out: first rtext not matching */
 	int		*stat)		/* out: 1 for matches, 0 for not */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -807,6 +775,7 @@ xfs_rtcheck_range(
 	xfs_rtxnum_t	lastbit;	/* last useful bit in word */
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	xfs_rtword_t	incore;
 	unsigned int	word;		/* word number in the buffer */
 
 	/*
@@ -825,7 +794,6 @@ xfs_rtcheck_range(
 	 * Compute the starting word's address, and starting bit.
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
-	b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
 	 * 0 (allocated) => all zero's; 1 (free) => all one's.
@@ -847,7 +815,8 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ val) & mask)) {
+		incore = xfs_rtbitmap_getword(bp, word);
+		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
@@ -873,12 +842,6 @@ xfs_rtcheck_range(
 			}
 
 			word = 0;
-			b = xfs_rbmblock_wordptr(bp, word);
-		} else {
-			/*
-			 * Go on to the next word in the buffer.
-			 */
-			b++;
 		}
 	} else {
 		/*
@@ -894,7 +857,8 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = *b ^ val)) {
+		incore = xfs_rtbitmap_getword(bp, word);
+		if ((wdiff = incore ^ val)) {
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
@@ -920,12 +884,6 @@ xfs_rtcheck_range(
 			}
 
 			word = 0;
-			b = xfs_rbmblock_wordptr(bp, word);
-		} else {
-			/*
-			 * Go on to the next word in the buffer.
-			 */
-			b++;
 		}
 	}
 	/*
@@ -940,7 +898,8 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ val) & mask)) {
+		incore = xfs_rtbitmap_getword(bp, word);
+		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 618c96468..02ee57f87 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -162,16 +162,39 @@ xfs_rbmblock_to_rtx(
 }
 
 /* Return a pointer to a bitmap word within a rt bitmap block. */
-static inline xfs_rtword_t *
+static inline union xfs_rtword_raw *
 xfs_rbmblock_wordptr(
 	struct xfs_buf		*bp,
 	unsigned int		index)
 {
-	xfs_rtword_t		*words = bp->b_addr;
+	union xfs_rtword_raw	*words = bp->b_addr;
 
 	return words + index;
 }
 
+/* Convert an ondisk bitmap word to its incore representation. */
+static inline xfs_rtword_t
+xfs_rtbitmap_getword(
+	struct xfs_buf		*bp,
+	unsigned int		index)
+{
+	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(bp, index);
+
+	return word->old;
+}
+
+/* Set an ondisk bitmap word from an incore representation. */
+static inline void
+xfs_rtbitmap_setword(
+	struct xfs_buf		*bp,
+	unsigned int		index,
+	xfs_rtword_t		value)
+{
+	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(bp, index);
+
+	word->old = value;
+}
+
 /*
  * Convert a rt extent length and rt bitmap block number to a xfs_suminfo_t
  * offset within the rt summary file.
-- 
2.43.0

