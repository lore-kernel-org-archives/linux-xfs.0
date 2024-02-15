Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D2B12C52D
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998979; cv=none; b=K+pu1xdnmBx5ijkCoA+w3iuZ+4Mpwtg3JC4YVBWV0vrdVV7GEZbOnLoildtoZI2d/fzw8f8lV+UA6kmW2eItxnCMdxehpTYqjN1DFRtL/whux6CqMAR8y9HD4sNlFWLPhRdtoSKT9ywg8el4IfDiM+x7di7q/yFkW8TO2sYqYRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998979; c=relaxed/simple;
	bh=Hapw8RLZtMCGqImN4gU5aJXU2WmntO4RaNRvfJlDBDA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmO103IWbknukH2N9QVFt+bhexAQRrVmwi/l61Q9UFVvRjCBaN5qsRZqwt+rIO31xjZD8jqDpkS44x6WZoV0pspnFwf7v0E9T3sZL0jIZ4dA1mUFXJz7YsyORrHH5oSY4EQcfK8p5cARAZBxMY+giaNIvKKrq8ofhFfBGR2/3R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mbn364Cy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mbn364Cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC3EC433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998979;
	bh=Hapw8RLZtMCGqImN4gU5aJXU2WmntO4RaNRvfJlDBDA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Mbn364CyDvl3uAfr5pkwH9gfaxpfHBLtYM3O0VWXdmdXINSKpuXYlDkg2LsKDZ77N
	 0Cpw5UvFK/6UTi1i02Jz6TYfKxy7jkCa0lf7Bep2GdEuMd1wKLnvGWGLS9XFaVqfqS
	 K7K7yw5P6xEvnFY8f6tiRtBBR1bw9wL83dOwdKx10QSRwDbihBM7J371B4hvTFjsi0
	 n/CNEljCZ8tcsTBBn2/+IUez8A9nhLUIm14fWXkiP8gx/wo2pSrc/PDBWYHPdhshGQ
	 vBKfYo0DtD3qXuaqRZNNrt14EWsVxvpQey74LvGNSUvcxKkRnVnQZAXWQbM5i+g59s
	 S//Bg6AOu9K5A==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 23/35] xfs: create a helper to handle logging parts of rt bitmap/summary blocks
Date: Thu, 15 Feb 2024 13:08:35 +0100
Message-ID: <20240215120907.1542854-24-cem@kernel.org>
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

Source kernel commit: 312d61021b8947446aa9ec80b78b9230e8cb3691

Create an explicit helper function to log parts of rt bitmap and summary
blocks.  While we're at it, fix an off-by-one error in two of the
rtbitmap logging calls that led to unnecessarily large log items but was
otherwise benign.

Note that the upcoming rtgroups patchset will add block headers to the
rtbitmap and rtsummary files.  The helpers in this and the next few
patches take a less than direct route through xfs_rbmblock_wordptr and
xfs_rsumblock_infoptr to avoid helper churn in that patchset.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.c | 55 +++++++++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 15 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 92473d4a5..562b40a1a 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -430,6 +430,21 @@ xfs_rtfind_forw(
 	return 0;
 }
 
+/* Log rtsummary counter at @infoword. */
+static inline void
+xfs_trans_log_rtsummary(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	unsigned int		infoword)
+{
+	size_t			first, last;
+
+	first = (void *)xfs_rsumblock_infoptr(bp, infoword) - bp->b_addr;
+	last = first + sizeof(xfs_suminfo_t) - 1;
+
+	xfs_trans_log_buf(tp, bp, first, last);
+}
+
 /*
  * Read and/or modify the summary information for a given extent size,
  * bitmap block combination.
@@ -495,8 +510,6 @@ xfs_rtmodify_summary_int(
 	infoword = xfs_rtsumoffs_to_infoword(mp, so);
 	sp = xfs_rsumblock_infoptr(bp, infoword);
 	if (delta) {
-		uint first = (uint)((char *)sp - (char *)bp->b_addr);
-
 		*sp += delta;
 		if (mp->m_rsum_cache) {
 			if (*sp == 0 && log == mp->m_rsum_cache[bbno])
@@ -504,7 +517,7 @@ xfs_rtmodify_summary_int(
 			if (*sp != 0 && log < mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno] = log;
 		}
-		xfs_trans_log_buf(tp, bp, first, first + sizeof(*sp) - 1);
+		xfs_trans_log_rtsummary(tp, bp, infoword);
 	}
 	if (sum)
 		*sum = *sp;
@@ -525,6 +538,22 @@ xfs_rtmodify_summary(
 					delta, rbpp, rsb, NULL);
 }
 
+/* Log rtbitmap block from the word @from to the byte before @next. */
+static inline void
+xfs_trans_log_rtbitmap(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	unsigned int		from,
+	unsigned int		next)
+{
+	size_t			first, last;
+
+	first = (void *)xfs_rbmblock_wordptr(bp, from) - bp->b_addr;
+	last = ((void *)xfs_rbmblock_wordptr(bp, next) - 1) - bp->b_addr;
+
+	xfs_trans_log_buf(tp, bp, first, last);
+}
+
 /*
  * Set the given range of bitmap bits to the given value.
  * Do whatever I/O and logging is required.
@@ -546,6 +575,7 @@ xfs_rtmodify_range(
 	int		i;		/* current bit number rel. to start */
 	int		lastbit;	/* last useful bit in word */
 	xfs_rtword_t	mask;		/* mask o frelevant bits for value */
+	unsigned int	firstword;	/* first word used in the buffer */
 	unsigned int	word;		/* word number in the buffer */
 
 	/*
@@ -563,7 +593,7 @@ xfs_rtmodify_range(
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
-	word = xfs_rtx_to_rbmword(mp, start);
+	firstword = word = xfs_rtx_to_rbmword(mp, start);
 	first = b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
@@ -597,15 +627,13 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_buf(tp, bp,
-				(uint)((char *)first - (char *)bp->b_addr),
-				(uint)((char *)b - (char *)bp->b_addr));
+			xfs_trans_log_rtbitmap(tp, bp, firstword, word);
 			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
 
-			word = 0;
+			firstword = word = 0;
 			first = b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
@@ -638,15 +666,13 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_buf(tp, bp,
-				(uint)((char *)first - (char *)bp->b_addr),
-				(uint)((char *)b - (char *)bp->b_addr));
+			xfs_trans_log_rtbitmap(tp, bp, firstword, word);
 			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
 
-			word = 0;
+			firstword = word = 0;
 			first = b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
@@ -671,15 +697,14 @@ xfs_rtmodify_range(
 			*b |= mask;
 		else
 			*b &= ~mask;
+		word++;
 		b++;
 	}
 	/*
 	 * Log any remaining changed bytes.
 	 */
 	if (b > first)
-		xfs_trans_log_buf(tp, bp,
-			(uint)((char *)first - (char *)bp->b_addr),
-			(uint)((char *)b - (char *)bp->b_addr - 1));
+		xfs_trans_log_rtbitmap(tp, bp, firstword, word);
 	return 0;
 }
 
-- 
2.43.0

