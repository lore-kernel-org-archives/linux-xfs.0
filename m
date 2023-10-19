Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4430BCDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbjJSQ1v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbjJSQ1u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:27:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E431E9B
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:27:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE60C433C7;
        Thu, 19 Oct 2023 16:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732868;
        bh=08TJHzLuUOzzl9OgRG2l3Z8gyNBfMpzQ9+1ff4aht3k=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=bSWMtMt+YPyEkZOJqA/9OgqyOTxOSMiYUVv/z5mNCPuwfquCAhyVg5oQIzcOG5EOO
         32NfVLJptgjzvSzwqvZhNehncw11JOdlAzXl3BRd/lq+diwZvksU93o+1/fg8egk+b
         oaKT7sDKAR4tE190r+FtU4e0fDol4ckFHKGue8pLG5tt6bAdrbyzJsMhbB85algbA/
         n/D/aSDmvUlPcv6pClo5/1SqFkfBy/okQnvrx5j/1Kw+i4MfTnQ021uNmzJoDDz4fj
         ZaS59uuwH31JQ+J4ZMm/CJ3uvNI7jsKXE4x+PPTG5RimCHnMIQMJ+mgr1m6v6bJ6l7
         uIageMutmXBcQ==
Date:   Thu, 19 Oct 2023 09:27:48 -0700
Subject: [PATCH 1/4] xfs: create a helper to handle logging parts of rt
 bitmap/summary blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, osandov@fb.com, hch@lst.de
Message-ID: <169773211358.225711.13859802342332594222.stgit@frogsfrogsfrogs>
In-Reply-To: <169773211338.225711.17480890063747608115.stgit@frogsfrogsfrogs>
References: <169773211338.225711.17480890063747608115.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

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
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   55 +++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index aefa2b0747a5..4f096348d4b2 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -432,6 +432,21 @@ xfs_rtfind_forw(
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
@@ -497,8 +512,6 @@ xfs_rtmodify_summary_int(
 	infoword = xfs_rtsumoffs_to_infoword(mp, so);
 	sp = xfs_rsumblock_infoptr(bp, infoword);
 	if (delta) {
-		uint first = (uint)((char *)sp - (char *)bp->b_addr);
-
 		*sp += delta;
 		if (mp->m_rsum_cache) {
 			if (*sp == 0 && log == mp->m_rsum_cache[bbno])
@@ -506,7 +519,7 @@ xfs_rtmodify_summary_int(
 			if (*sp != 0 && log < mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno] = log;
 		}
-		xfs_trans_log_buf(tp, bp, first, first + sizeof(*sp) - 1);
+		xfs_trans_log_rtsummary(tp, bp, infoword);
 	}
 	if (sum)
 		*sum = *sp;
@@ -527,6 +540,22 @@ xfs_rtmodify_summary(
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
@@ -548,6 +577,7 @@ xfs_rtmodify_range(
 	int		i;		/* current bit number rel. to start */
 	int		lastbit;	/* last useful bit in word */
 	xfs_rtword_t	mask;		/* mask o frelevant bits for value */
+	unsigned int	firstword;	/* first word used in the buffer */
 	unsigned int	word;		/* word number in the buffer */
 
 	/*
@@ -565,7 +595,7 @@ xfs_rtmodify_range(
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
-	word = xfs_rtx_to_rbmword(mp, start);
+	firstword = word = xfs_rtx_to_rbmword(mp, start);
 	first = b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
@@ -599,15 +629,13 @@ xfs_rtmodify_range(
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
@@ -640,15 +668,13 @@ xfs_rtmodify_range(
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
@@ -673,15 +699,14 @@ xfs_rtmodify_range(
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
 

