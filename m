Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842FDCDB470
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjJKSHE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjJKSHE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:07:04 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E8B94
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:07:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2694C433C8;
        Wed, 11 Oct 2023 18:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047621;
        bh=aiWEuNLqvQUfYvFOoW93XZuBOX5XIqbvgIhBo8tlQZw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=J9QgiU6u6n4TbQulnbrUL+f0+CbPB2y+Q7Y3DvR0Bd2Ba+JOocdn2i/Zt5muo7RWI
         zT1FF7GZJhL6i0UitvUwfJ+cTKkfEPZ5XWgzDh1YEmn32Alx17A5E9uSdiZyKXEIYY
         BoifcDwnPL90j2IcRFBL+H6Ap9ZwfdoWhYfO1Sr36y+c9KamyCW+ucNYjQR2Eyrpbe
         4xKg5q/L8jkMKoMLiZouVOiFUtkgS8MHV6bzX66i2/A4exFrRj8RM2jH1GjpzuMBAc
         Wpu3aIwBYVT2ctSAYoUitKzmFRDzi4OOIpUmuYH59t93ABPAKhVKrqb02RiaZOnN9u
         eI2nx+WFD0Y2g==
Date:   Wed, 11 Oct 2023 11:07:01 -0700
Subject: [PATCH 3/8] xfs: convert open-coded xfs_rtword_t pointer accesses to
 helper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704721677.1773834.5979493182560391662.stgit@frogsfrogsfrogs>
In-Reply-To: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There are a bunch of places where we use open-coded logic to find a
pointer to an xfs_rtword_t within a rt bitmap buffer.  Convert all that
to helper functions for better type safety.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   59 ++++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_rtbitmap.h |   20 ++++++++++++++
 2 files changed, 51 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 1f4886287aad0..231622a5ab681 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -110,7 +110,6 @@ xfs_rtfind_back(
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtxnum_t	firstbit;	/* first useful bit in the word */
 	xfs_rtxnum_t	i;		/* current bit number rel. to start */
@@ -128,12 +127,12 @@ xfs_rtfind_back(
 	if (error) {
 		return error;
 	}
-	bufp = bp->b_addr;
+
 	/*
 	 * Get the first word's index & point to it.
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
-	b = &bufp[word];
+	b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	len = start - limit + 1;
 	/*
@@ -180,9 +179,9 @@ xfs_rtfind_back(
 			if (error) {
 				return error;
 			}
-			bufp = bp->b_addr;
+
 			word = mp->m_blockwsize - 1;
-			b = &bufp[word];
+			b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the previous word in the buffer.
@@ -226,9 +225,9 @@ xfs_rtfind_back(
 			if (error) {
 				return error;
 			}
-			bufp = bp->b_addr;
+
 			word = mp->m_blockwsize - 1;
-			b = &bufp[word];
+			b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the previous word in the buffer.
@@ -285,7 +284,6 @@ xfs_rtfind_forw(
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtxnum_t	i;		/* current bit number rel. to start */
 	xfs_rtxnum_t	lastbit;	/* last useful bit in the word */
@@ -303,12 +301,12 @@ xfs_rtfind_forw(
 	if (error) {
 		return error;
 	}
-	bufp = bp->b_addr;
+
 	/*
 	 * Get the first word's index & point to it.
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
-	b = &bufp[word];
+	b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	len = limit - start + 1;
 	/*
@@ -354,8 +352,9 @@ xfs_rtfind_forw(
 			if (error) {
 				return error;
 			}
-			b = bufp = bp->b_addr;
+
 			word = 0;
+			b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the previous word in the buffer.
@@ -399,8 +398,9 @@ xfs_rtfind_forw(
 			if (error) {
 				return error;
 			}
-			b = bufp = bp->b_addr;
+
 			word = 0;
+			b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the next word in the buffer.
@@ -548,7 +548,6 @@ xfs_rtmodify_range(
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtword_t	*first;		/* first used word in the buffer */
 	int		i;		/* current bit number rel. to start */
@@ -567,12 +566,12 @@ xfs_rtmodify_range(
 	if (error) {
 		return error;
 	}
-	bufp = bp->b_addr;
+
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
-	first = b = &bufp[word];
+	first = b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
 	 * 0 (allocated) => all zeroes; 1 (free) => all ones.
@@ -606,14 +605,15 @@ xfs_rtmodify_range(
 			 * Get the next one.
 			 */
 			xfs_trans_log_buf(tp, bp,
-				(uint)((char *)first - (char *)bufp),
-				(uint)((char *)b - (char *)bufp));
+				(uint)((char *)first - (char *)bp->b_addr),
+				(uint)((char *)b - (char *)bp->b_addr));
 			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
-			first = b = bufp = bp->b_addr;
+
 			word = 0;
+			first = b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the next word in the buffer
@@ -646,14 +646,15 @@ xfs_rtmodify_range(
 			 * Get the next one.
 			 */
 			xfs_trans_log_buf(tp, bp,
-				(uint)((char *)first - (char *)bufp),
-				(uint)((char *)b - (char *)bufp));
+				(uint)((char *)first - (char *)bp->b_addr),
+				(uint)((char *)b - (char *)bp->b_addr));
 			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
-			first = b = bufp = bp->b_addr;
+
 			word = 0;
+			first = b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the next word in the buffer
@@ -683,8 +684,9 @@ xfs_rtmodify_range(
 	 * Log any remaining changed bytes.
 	 */
 	if (b > first)
-		xfs_trans_log_buf(tp, bp, (uint)((char *)first - (char *)bufp),
-			(uint)((char *)b - (char *)bufp - 1));
+		xfs_trans_log_buf(tp, bp,
+			(uint)((char *)first - (char *)bp->b_addr),
+			(uint)((char *)b - (char *)bp->b_addr - 1));
 	return 0;
 }
 
@@ -782,7 +784,6 @@ xfs_rtcheck_range(
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtxnum_t	i;		/* current bit number rel. to start */
 	xfs_rtxnum_t	lastbit;	/* last useful bit in word */
@@ -801,12 +802,12 @@ xfs_rtcheck_range(
 	if (error) {
 		return error;
 	}
-	bufp = bp->b_addr;
+
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
-	b = &bufp[word];
+	b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
 	 * 0 (allocated) => all zero's; 1 (free) => all one's.
@@ -852,8 +853,9 @@ xfs_rtcheck_range(
 			if (error) {
 				return error;
 			}
-			b = bufp = bp->b_addr;
+
 			word = 0;
+			b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the next word in the buffer.
@@ -898,8 +900,9 @@ xfs_rtcheck_range(
 			if (error) {
 				return error;
 			}
-			b = bufp = bp->b_addr;
+
 			word = 0;
+			b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the next word in the buffer.
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 5f4a453e29eb6..af37afec2b010 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -121,6 +121,26 @@ xfs_rbmblock_to_rtx(
 	return rbmoff << mp->m_blkbit_log;
 }
 
+/* Return a pointer to a bitmap word within a rt bitmap block buffer. */
+static inline xfs_rtword_t *
+xfs_rbmbuf_wordptr(
+	void			*buf,
+	unsigned int		rbmword)
+{
+	xfs_rtword_t		*wordp = buf;
+
+	return &wordp[rbmword];
+}
+
+/* Return a pointer to a bitmap word within a rt bitmap block. */
+static inline xfs_rtword_t *
+xfs_rbmblock_wordptr(
+	struct xfs_buf		*bp,
+	unsigned int		rbmword)
+{
+	return xfs_rbmbuf_wordptr(bp->b_addr, rbmword);
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */

