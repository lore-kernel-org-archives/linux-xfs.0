Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DEF6CDB474
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 02:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjJRCK2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 22:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjJRCK2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 22:10:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419EAFC
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 19:10:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9071C433C8;
        Wed, 18 Oct 2023 02:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697595025;
        bh=knsMA1HkNiSKgVKvMqVT/enR9IPcFhr55dt78NPcUFk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lkPDGXoCEvZbyHMWwATYeAx8Zvwo7D2PoT0Bs2yDv6+RdJf0n395G88IrQb60LMUI
         xineKNoC1g4C0uVYoPtbqKGScYlOE9aHmY+85sw/6SbJvyLjDdE3eD7kHU62DX59o+
         Qrhvd5/NLyEab2aInMWgP4NM/DryvFwWZ7vacvE7JU7sEUEK6799xiqx2bWfnlAYZr
         DAB+rkWGx3nSzfbhaKesdwZ5clTjOJiZ9ILuFXWnE4RVsHCi8r8dKxcjEfAqSCyNhM
         /mktSGVHtl/XQ5dZoxYsLlmb/SKZts5FU5FfSdqrxx7JCGtfeMauVVtrxWTHqKAVHo
         UpR5/+kI0k9Ng==
Subject: [PATCH 1/4] xfs: create a helper to handle logging parts of rt bitmap
 blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com, hch@lst.de,
        linux-xfs@vger.kernel.org
Date:   Tue, 17 Oct 2023 19:10:25 -0700
Message-ID: <169759502538.3396240.16032555048636051800.stgit@frogsfrogsfrogs>
In-Reply-To: <169759501951.3396240.14113780813650896727.stgit@frogsfrogsfrogs>
References: <169759501951.3396240.14113780813650896727.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create an explicit helper function to log parts of rt bitmap blocks.
While we're at it, fix an off-by-one error in two of the the rtbitmap
logging calls that led to unnecessarily large log items but was
otherwise benign.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   49 +++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index aefa2b0747a5..d05bd0218885 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -432,6 +432,18 @@ xfs_rtfind_forw(
 	return 0;
 }
 
+/* Log rtsummary counter at @infoword. */
+static inline void
+xfs_trans_log_rtsummary(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	unsigned int		infoword)
+{
+	xfs_trans_log_buf(tp, bp,
+			infoword * sizeof(xfs_suminfo_t),
+			(infoword + 1) * sizeof(xfs_suminfo_t) - 1);
+}
+
 /*
  * Read and/or modify the summary information for a given extent size,
  * bitmap block combination.
@@ -497,8 +509,6 @@ xfs_rtmodify_summary_int(
 	infoword = xfs_rtsumoffs_to_infoword(mp, so);
 	sp = xfs_rsumblock_infoptr(bp, infoword);
 	if (delta) {
-		uint first = (uint)((char *)sp - (char *)bp->b_addr);
-
 		*sp += delta;
 		if (mp->m_rsum_cache) {
 			if (*sp == 0 && log == mp->m_rsum_cache[bbno])
@@ -506,7 +516,7 @@ xfs_rtmodify_summary_int(
 			if (*sp != 0 && log < mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno] = log;
 		}
-		xfs_trans_log_buf(tp, bp, first, first + sizeof(*sp) - 1);
+		xfs_trans_log_rtsummary(tp, bp, infoword);
 	}
 	if (sum)
 		*sum = *sp;
@@ -527,6 +537,19 @@ xfs_rtmodify_summary(
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
+	xfs_trans_log_buf(tp, bp,
+			from * sizeof(xfs_rtword_t),
+			next * sizeof(xfs_rtword_t) - 1);
+}
+
 /*
  * Set the given range of bitmap bits to the given value.
  * Do whatever I/O and logging is required.
@@ -548,6 +571,7 @@ xfs_rtmodify_range(
 	int		i;		/* current bit number rel. to start */
 	int		lastbit;	/* last useful bit in word */
 	xfs_rtword_t	mask;		/* mask o frelevant bits for value */
+	unsigned int	firstword;	/* first word used in the buffer */
 	unsigned int	word;		/* word number in the buffer */
 
 	/*
@@ -565,7 +589,7 @@ xfs_rtmodify_range(
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
-	word = xfs_rtx_to_rbmword(mp, start);
+	firstword = word = xfs_rtx_to_rbmword(mp, start);
 	first = b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
@@ -599,15 +623,13 @@ xfs_rtmodify_range(
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
@@ -640,15 +662,13 @@ xfs_rtmodify_range(
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
@@ -673,15 +693,14 @@ xfs_rtmodify_range(
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
 

