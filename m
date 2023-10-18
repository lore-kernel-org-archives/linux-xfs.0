Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C997BCDB474
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 02:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjJRCKe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 22:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjJRCKe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 22:10:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA9EF7
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 19:10:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91745C433C7;
        Wed, 18 Oct 2023 02:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697595031;
        bh=MQCLCqjZFrwz4gtoFrI7aAcYWMUtVgpMv2ywbiWd0Jk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ey3LAnMfG2dh43HINYretrFZVYlkmNMZfk331Bn2uSxDUlRovYbs4HXt1Mkptv4lp
         G0bNYE2csNzg6SF9ij3qvV4B8Wc//tEeXQeFHy6kBtwSrmG7cMR3lx4d9TMNgFNy3C
         AGDcRItNLGwEDqk3dcDQI3DWcL4xRXYQ0CSPL3SZXz3rehK4lkA+L4YYe4+/7SZBcx
         VACGADWR4Pn3BGv0wHcynwa4mIoqDwMR+/AXZ6HQKbZi+/bBU2+qCMwCBCBJ8CQMYg
         hWk8uV3sQbo7dsT8c0wRzpY4PSo5yQKZEDRAMs3W3W5dEnCLhwBrKFy292ICFQysV2
         bCwma8nbBZjhg==
Subject: [PATCH 2/4] xfs: use accessor functions for bitmap words
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     osandov@fb.com, hch@lst.de, linux-xfs@vger.kernel.org
Date:   Tue, 17 Oct 2023 19:10:31 -0700
Message-ID: <169759503104.3396240.5905890094753315092.stgit@frogsfrogsfrogs>
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

Create get and set functions for rtbitmap words so that we can redefine
the ondisk format with a specific endianness.  Note that this requires
the definition of a distinct type for ondisk rtbitmap words so that the
compiler can perform proper typechecking as we go back and forth.

In the upcoming rtgroups feature, we're going to fix the problem that
rtwords are written in host endian order, which means we'll need the
distinct rtword/rtword_raw types.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h   |    8 +++
 fs/xfs/libxfs/xfs_rtbitmap.c |  109 +++++++++++++-----------------------------
 fs/xfs/libxfs/xfs_rtbitmap.h |   27 ++++++++++
 fs/xfs/xfs_ondisk.h          |    3 +
 4 files changed, 70 insertions(+), 77 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d48e3a395bd9..2af891d5d171 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index d05bd0218885..0e83eca507dd 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -99,7 +99,6 @@ xfs_rtfind_back(
 	xfs_rtxnum_t	limit,		/* last rtext to look at */
 	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -110,6 +109,7 @@ xfs_rtfind_back(
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	want;		/* mask for "good" values */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	xfs_rtword_t	incore;
 	unsigned int	word;		/* word number in the buffer */
 
 	/*
@@ -125,14 +125,14 @@ xfs_rtfind_back(
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
@@ -149,7 +149,7 @@ xfs_rtfind_back(
 		 * Calculate the difference between the value there
 		 * and what we're looking for.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different.  Mark where we are and return.
 			 */
@@ -174,12 +174,6 @@ xfs_rtfind_back(
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
@@ -195,7 +189,8 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = *b ^ want)) {
+		incore = xfs_rtbitmap_getword(bp, word);
+		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -220,12 +215,6 @@ xfs_rtfind_back(
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
@@ -242,7 +231,8 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		incore = xfs_rtbitmap_getword(bp, word);
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -273,7 +263,6 @@ xfs_rtfind_forw(
 	xfs_rtxnum_t	limit,		/* last rtext to look at */
 	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -284,6 +273,7 @@ xfs_rtfind_forw(
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	want;		/* mask for "good" values */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	xfs_rtword_t	incore;
 	unsigned int	word;		/* word number in the buffer */
 
 	/*
@@ -299,14 +289,14 @@ xfs_rtfind_forw(
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
@@ -322,7 +312,7 @@ xfs_rtfind_forw(
 		 * Calculate the difference between the value there
 		 * and what we're looking for.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different.  Mark where we are and return.
 			 */
@@ -347,12 +337,6 @@ xfs_rtfind_forw(
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
@@ -368,7 +352,8 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = *b ^ want)) {
+		incore = xfs_rtbitmap_getword(bp, word);
+		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -393,12 +378,6 @@ xfs_rtfind_forw(
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
@@ -413,7 +392,8 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		incore = xfs_rtbitmap_getword(bp, word);
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -562,15 +542,14 @@ xfs_rtmodify_range(
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
 
@@ -590,7 +569,6 @@ xfs_rtmodify_range(
 	 * Compute the starting word's address, and starting bit.
 	 */
 	firstword = word = xfs_rtx_to_rbmword(mp, start);
-	first = b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
 	 * 0 (allocated) => all zeroes; 1 (free) => all ones.
@@ -609,10 +587,12 @@ xfs_rtmodify_range(
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
@@ -630,12 +610,6 @@ xfs_rtmodify_range(
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
@@ -651,7 +625,7 @@ xfs_rtmodify_range(
 		/*
 		 * Set the word value correctly.
 		 */
-		*b = val;
+		xfs_rtbitmap_setword(bp, word, val);
 		i += XFS_NBWORD;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -669,12 +643,6 @@ xfs_rtmodify_range(
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
@@ -689,17 +657,18 @@ xfs_rtmodify_range(
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
@@ -794,7 +763,6 @@ xfs_rtcheck_range(
 	xfs_rtxnum_t	*new,		/* out: first rtext not matching */
 	int		*stat)		/* out: 1 for matches, 0 for not */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -803,6 +771,7 @@ xfs_rtcheck_range(
 	xfs_rtxnum_t	lastbit;	/* last useful bit in word */
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	xfs_rtword_t	incore;
 	unsigned int	word;		/* word number in the buffer */
 
 	/*
@@ -821,7 +790,6 @@ xfs_rtcheck_range(
 	 * Compute the starting word's address, and starting bit.
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
-	b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
 	 * 0 (allocated) => all zero's; 1 (free) => all one's.
@@ -843,7 +811,8 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ val) & mask)) {
+		incore = xfs_rtbitmap_getword(bp, word);
+		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
@@ -869,12 +838,6 @@ xfs_rtcheck_range(
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
@@ -890,7 +853,8 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = *b ^ val)) {
+		incore = xfs_rtbitmap_getword(bp, word);
+		if ((wdiff = incore ^ val)) {
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
@@ -916,12 +880,6 @@ xfs_rtcheck_range(
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
@@ -936,7 +894,8 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ val) & mask)) {
+		incore = xfs_rtbitmap_getword(bp, word);
+		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 01eabb9b5516..ede24de74620 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -159,16 +159,39 @@ xfs_rbmblock_to_rtx(
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
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index c4cc99b70dd3..14d455f768d3 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -72,6 +72,9 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_map_t,		4);
 	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_local_t,	4);
 
+	/* realtime structures */
+	XFS_CHECK_STRUCT_SIZE(union xfs_rtword_raw,		4);
+
 	/*
 	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to
 	 * 4 bytes anyway so it's not obviously a problem.  Hence for the moment

