Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2085ECDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 18:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjJQSxW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 14:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbjJQSxW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 14:53:22 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC0290
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 11:53:20 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 24B9367373; Tue, 17 Oct 2023 20:53:17 +0200 (CEST)
Date:   Tue, 17 Oct 2023 20:53:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 6/8] xfs: use accessor functions for bitmap words
Message-ID: <20231017185316.GA31091@lst.de>
References: <169755742135.3167663.6426011271285866254.stgit@frogsfrogsfrogs> <169755742240.3167663.3888314487214346782.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169755742240.3167663.3888314487214346782.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 17, 2023 at 08:53:21AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create get and set functions for rtbitmap words so that we can redefine
> the ondisk format with a specific endianness.  Note that this requires
> the definition of a distinct type for ondisk rtbitmap words so that the
> compiler can perform proper typechecking as we go back and forth.
> 
> In the upcoming rtgroups feature, we're going to fix the problem that
> rtwords are written in host endian order, which means we'll need the
> distinct rtword/rtword_raw types.

So per the last round I'd much prefer no exposing the xfs_rtword_raw
to the callers.  I've cooked up the patch below to do this, and it
seems to survive the absolute basic testing so far.  One interesting
thing is that as far as I can tell all but one of the
xfs_trans_log_buf calls in the pre-existing code were wrong as they
were missing the usual '- 1' for the last parameter.

For reasons I can't explain the version with this patch also happens
to actually generate smaller binary code as well:

hch@brick:~/work/xfs$ size xfs_rtbitmap.o*
   text	   data	    bss	    dec	    hex	filename
   7763	      0	      0	   7763	   1e53	xfs_rtbitmap.o.new
   7833	      0	      0	   7833	   1e99	xfs_rtbitmap.o.old

---
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index f8daaff947fce8..6ca48fe8a9e1d3 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -90,20 +90,35 @@ xfs_rtbuf_get(
 /* Convert an ondisk bitmap word to its incore representation. */
 inline xfs_rtword_t
 xfs_rtbitmap_getword(
-	struct xfs_mount	*mp,
-	union xfs_rtword_raw	*wordptr)
+	struct xfs_buf		*bp,
+	unsigned int		index)
 {
-	return wordptr->old;
+	union xfs_rtword_raw	*words = bp->b_addr;
+
+	return words[index].old;
 }
 
 /* Set an ondisk bitmap word from an incore representation. */
 inline void
 xfs_rtbitmap_setword(
-	struct xfs_mount	*mp,
-	union xfs_rtword_raw	*wordptr,
+	struct xfs_buf		*bp,
+	unsigned int		index,
 	xfs_rtword_t		incore)
 {
-	wordptr->old = incore;
+	union xfs_rtword_raw	*words = bp->b_addr;
+
+	words[index].old = incore;
+}
+
+static inline void
+xfs_trans_log_rtbitmap(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	int			from,
+	int			to)
+{
+	xfs_trans_log_buf(tp, bp, from * sizeof(union xfs_rtword_raw),
+			  to * sizeof(union xfs_rtword_raw) - 1);
 }
 
 /*
@@ -118,7 +133,6 @@ xfs_rtfind_back(
 	xfs_rtxnum_t	limit,		/* last rtext to look at */
 	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
 {
-	union xfs_rtword_raw *b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -145,14 +159,13 @@ xfs_rtfind_back(
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
-	incore = xfs_rtbitmap_getword(mp, b);
+	incore = xfs_rtbitmap_getword(bp, word);
 	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
@@ -195,12 +208,6 @@ xfs_rtfind_back(
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
@@ -216,7 +223,7 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(mp, b);
+		incore = xfs_rtbitmap_getword(bp, word);
 		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
@@ -242,12 +249,6 @@ xfs_rtfind_back(
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
@@ -264,7 +265,7 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(mp, b);
+		incore = xfs_rtbitmap_getword(bp, word);
 		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
@@ -296,7 +297,6 @@ xfs_rtfind_forw(
 	xfs_rtxnum_t	limit,		/* last rtext to look at */
 	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
 {
-	union xfs_rtword_raw *b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -323,14 +323,13 @@ xfs_rtfind_forw(
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
-	incore = xfs_rtbitmap_getword(mp, b);
+	incore = xfs_rtbitmap_getword(bp, word);
 	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
@@ -372,12 +371,6 @@ xfs_rtfind_forw(
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
@@ -393,7 +386,7 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(mp, b);
+		incore = xfs_rtbitmap_getword(bp, word);
 		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
@@ -419,12 +412,6 @@ xfs_rtfind_forw(
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
@@ -439,7 +426,7 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(mp, b);
+		incore = xfs_rtbitmap_getword(bp, word);
 		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
@@ -566,12 +553,11 @@ xfs_rtmodify_range(
 	xfs_rtxlen_t	len,		/* length of extent to modify */
 	int		val)		/* 1 for free, 0 for allocated */
 {
-	union xfs_rtword_raw *b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	int		error;		/* error value */
-	union xfs_rtword_raw *first;		/* first used word in the buffer */
+	int		first;		/* first used word in the buffer */
 	int		i;		/* current bit number rel. to start */
 	int		lastbit;	/* last useful bit in word */
 	xfs_rtword_t	mask;		/* mask o frelevant bits for value */
@@ -593,8 +579,7 @@ xfs_rtmodify_range(
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
-	word = xfs_rtx_to_rbmword(mp, start);
-	first = b = xfs_rbmblock_wordptr(bp, word);
+	first = word = xfs_rtx_to_rbmword(mp, start);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
 	 * 0 (allocated) => all zeroes; 1 (free) => all ones.
@@ -613,12 +598,12 @@ xfs_rtmodify_range(
 		/*
 		 * Set/clear the active bits.
 		 */
-		incore = xfs_rtbitmap_getword(mp, b);
+		incore = xfs_rtbitmap_getword(bp, word);
 		if (val)
 			incore |= mask;
 		else
 			incore &= ~mask;
-		xfs_rtbitmap_setword(mp, b, incore);
+		xfs_rtbitmap_setword(bp, word, incore);
 		i = lastbit - bit;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -629,21 +614,13 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_buf(tp, bp,
-				(uint)((char *)first - (char *)bp->b_addr),
-				(uint)((char *)b - (char *)bp->b_addr));
+			xfs_trans_log_rtbitmap(tp, bp, first, word);
 			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
 
-			word = 0;
-			first = b = xfs_rbmblock_wordptr(bp, word);
-		} else {
-			/*
-			 * Go on to the next word in the buffer
-			 */
-			b++;
+			first = word = 0;
 		}
 	} else {
 		/*
@@ -659,7 +636,7 @@ xfs_rtmodify_range(
 		/*
 		 * Set the word value correctly.
 		 */
-		xfs_rtbitmap_setword(mp, b, val);
+		xfs_rtbitmap_setword(bp, word, val);
 		i += XFS_NBWORD;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -670,21 +647,13 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_buf(tp, bp,
-				(uint)((char *)first - (char *)bp->b_addr),
-				(uint)((char *)b - (char *)bp->b_addr));
+			xfs_trans_log_rtbitmap(tp, bp, first, word);
 			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
 
-			word = 0;
-			first = b = xfs_rbmblock_wordptr(bp, word);
-		} else {
-			/*
-			 * Go on to the next word in the buffer
-			 */
-			b++;
+			first = word = 0;
 		}
 	}
 	/*
@@ -699,21 +668,19 @@ xfs_rtmodify_range(
 		/*
 		 * Set/clear the active bits.
 		 */
-		incore = xfs_rtbitmap_getword(mp, b);
+		incore = xfs_rtbitmap_getword(bp, word);
 		if (val)
 			incore |= mask;
 		else
 			incore &= ~mask;
-		xfs_rtbitmap_setword(mp, b, incore);
-		b++;
+		xfs_rtbitmap_setword(bp, word, incore);
+		word++;
 	}
 	/*
 	 * Log any remaining changed bytes.
 	 */
-	if (b > first)
-		xfs_trans_log_buf(tp, bp,
-			(uint)((char *)first - (char *)bp->b_addr),
-			(uint)((char *)b - (char *)bp->b_addr - 1));
+	if (word > first)
+		xfs_trans_log_rtbitmap(tp, bp, first, word);
 	return 0;
 }
 
@@ -807,7 +774,6 @@ xfs_rtcheck_range(
 	xfs_rtxnum_t	*new,		/* out: first rtext not matching */
 	int		*stat)		/* out: 1 for matches, 0 for not */
 {
-	union xfs_rtword_raw *b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -835,7 +801,6 @@ xfs_rtcheck_range(
 	 * Compute the starting word's address, and starting bit.
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
-	b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
 	 * 0 (allocated) => all zero's; 1 (free) => all one's.
@@ -857,7 +822,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(mp, b);
+		incore = xfs_rtbitmap_getword(bp, word);
 		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
@@ -884,12 +849,6 @@ xfs_rtcheck_range(
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
@@ -905,7 +864,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(mp, b);
+		incore = xfs_rtbitmap_getword(bp, word);
 		if ((wdiff = incore ^ val)) {
 			/*
 			 * Different, compute first wrong bit and return.
@@ -932,12 +891,6 @@ xfs_rtcheck_range(
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
@@ -952,7 +905,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(mp, b);
+		incore = xfs_rtbitmap_getword(bp, word);
 		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 4e33e84afa7ad6..ec14e6adb8364a 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -158,17 +158,6 @@ xfs_rbmblock_to_rtx(
 	return rbmoff << mp->m_blkbit_log;
 }
 
-/* Return a pointer to a bitmap word within a rt bitmap block. */
-static inline union xfs_rtword_raw *
-xfs_rbmblock_wordptr(
-	struct xfs_buf		*bp,
-	unsigned int		index)
-{
-	union xfs_rtword_raw	*words = bp->b_addr;
-
-	return words + index;
-}
-
 /*
  * Convert a rt extent length and rt bitmap block number to a xfs_suminfo_t
  * offset within the rt summary file.
@@ -285,10 +274,10 @@ xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
 unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
 		xfs_rtbxlen_t rtextents);
-xfs_rtword_t xfs_rtbitmap_getword(struct xfs_mount *mp,
-		union xfs_rtword_raw *wordptr);
-void xfs_rtbitmap_setword(struct xfs_mount *mp,
-		union xfs_rtword_raw *wordptr, xfs_rtword_t incore);
+xfs_rtword_t xfs_rtbitmap_getword(struct xfs_buf *bp, unsigned int index);
+void xfs_rtbitmap_setword(struct xfs_buf *bp, unsigned int index,
+		xfs_rtword_t incore);
+
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)

