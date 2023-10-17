Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726BFCDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbjJQPx0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbjJQPxZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:53:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBB7FF
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:53:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE4AC433C7;
        Tue, 17 Oct 2023 15:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697558001;
        bh=/M8ONbQIkDxzw7ksEloLqsd0qePspNTXbWhmvzxLl5E=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qcvGrOZdk2H4rAkfH0du3L+kV6Oadxt2x6GPlUq/rJdidEVKwvSHwHGFj5vpBTDIT
         XZ67730f9yTktzisaCa3n/eOjTmwnSMIozchta4Ud4GQq2IptgmV+iCMvIlhZf3A0L
         8VucscC0a7WwDP8dFO8dK+efJ7Lf+tod3BLkevog+HDMM0/PIEJt/nCtrxDmuqDSVJ
         S9SNkZ7xqKjx9XvCFC2jos0K/H2yazdwJWPxlwknScxfkvoCta0e+oKR+RRr+30PKe
         gtsmtCQ2gUWGBa2xr45ctbYFKSCLWW2H4COG5jRyN2uydxRjR7bVKRPfuL5iaqIBV7
         wVIVkTkIlV/IQ==
Date:   Tue, 17 Oct 2023 08:53:21 -0700
Subject: [PATCH 6/8] xfs: use accessor functions for bitmap words
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755742240.3167663.3888314487214346782.stgit@frogsfrogsfrogs>
In-Reply-To: <169755742135.3167663.6426011271285866254.stgit@frogsfrogsfrogs>
References: <169755742135.3167663.6426011271285866254.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_format.h   |    8 ++++
 fs/xfs/libxfs/xfs_rtbitmap.c |   78 +++++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_rtbitmap.h |    8 +++-
 fs/xfs/xfs_ondisk.h          |    3 ++
 4 files changed, 74 insertions(+), 23 deletions(-)


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
index ff3d10d67bde..f8daaff947fc 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -87,6 +87,25 @@ xfs_rtbuf_get(
 	return 0;
 }
 
+/* Convert an ondisk bitmap word to its incore representation. */
+inline xfs_rtword_t
+xfs_rtbitmap_getword(
+	struct xfs_mount	*mp,
+	union xfs_rtword_raw	*wordptr)
+{
+	return wordptr->old;
+}
+
+/* Set an ondisk bitmap word from an incore representation. */
+inline void
+xfs_rtbitmap_setword(
+	struct xfs_mount	*mp,
+	union xfs_rtword_raw	*wordptr,
+	xfs_rtword_t		incore)
+{
+	wordptr->old = incore;
+}
+
 /*
  * Searching backward from start to limit, find the first block whose
  * allocated/free state is different from start's.
@@ -99,7 +118,7 @@ xfs_rtfind_back(
 	xfs_rtxnum_t	limit,		/* last rtext to look at */
 	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
+	union xfs_rtword_raw *b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -110,6 +129,7 @@ xfs_rtfind_back(
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	want;		/* mask for "good" values */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	xfs_rtword_t	incore;
 	int		word;		/* word number in the buffer */
 
 	/*
@@ -132,7 +152,8 @@ xfs_rtfind_back(
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	want = (*b & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
+	incore = xfs_rtbitmap_getword(mp, b);
+	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
 	 * partial word.
@@ -149,7 +170,7 @@ xfs_rtfind_back(
 		 * Calculate the difference between the value there
 		 * and what we're looking for.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different.  Mark where we are and return.
 			 */
@@ -195,7 +216,8 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = *b ^ want)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -242,7 +264,8 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -273,7 +296,7 @@ xfs_rtfind_forw(
 	xfs_rtxnum_t	limit,		/* last rtext to look at */
 	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
+	union xfs_rtword_raw *b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -284,6 +307,7 @@ xfs_rtfind_forw(
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	want;		/* mask for "good" values */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	xfs_rtword_t	incore;
 	int		word;		/* word number in the buffer */
 
 	/*
@@ -306,7 +330,8 @@ xfs_rtfind_forw(
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	want = (*b & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
+	incore = xfs_rtbitmap_getword(mp, b);
+	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
 	 * partial word.
@@ -322,7 +347,7 @@ xfs_rtfind_forw(
 		 * Calculate the difference between the value there
 		 * and what we're looking for.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different.  Mark where we are and return.
 			 */
@@ -368,7 +393,8 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = *b ^ want)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -413,7 +439,8 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -539,15 +566,16 @@ xfs_rtmodify_range(
 	xfs_rtxlen_t	len,		/* length of extent to modify */
 	int		val)		/* 1 for free, 0 for allocated */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
+	union xfs_rtword_raw *b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	int		error;		/* error value */
-	xfs_rtword_t	*first;		/* first used word in the buffer */
+	union xfs_rtword_raw *first;		/* first used word in the buffer */
 	int		i;		/* current bit number rel. to start */
 	int		lastbit;	/* last useful bit in word */
 	xfs_rtword_t	mask;		/* mask o frelevant bits for value */
+	xfs_rtword_t	incore;
 	int		word;		/* word number in the buffer */
 
 	/*
@@ -585,10 +613,12 @@ xfs_rtmodify_range(
 		/*
 		 * Set/clear the active bits.
 		 */
+		incore = xfs_rtbitmap_getword(mp, b);
 		if (val)
-			*b |= mask;
+			incore |= mask;
 		else
-			*b &= ~mask;
+			incore &= ~mask;
+		xfs_rtbitmap_setword(mp, b, incore);
 		i = lastbit - bit;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -629,7 +659,7 @@ xfs_rtmodify_range(
 		/*
 		 * Set the word value correctly.
 		 */
-		*b = val;
+		xfs_rtbitmap_setword(mp, b, val);
 		i += XFS_NBWORD;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -669,10 +699,12 @@ xfs_rtmodify_range(
 		/*
 		 * Set/clear the active bits.
 		 */
+		incore = xfs_rtbitmap_getword(mp, b);
 		if (val)
-			*b |= mask;
+			incore |= mask;
 		else
-			*b &= ~mask;
+			incore &= ~mask;
+		xfs_rtbitmap_setword(mp, b, incore);
 		b++;
 	}
 	/*
@@ -775,7 +807,7 @@ xfs_rtcheck_range(
 	xfs_rtxnum_t	*new,		/* out: first rtext not matching */
 	int		*stat)		/* out: 1 for matches, 0 for not */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
+	union xfs_rtword_raw *b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -784,6 +816,7 @@ xfs_rtcheck_range(
 	xfs_rtxnum_t	lastbit;	/* last useful bit in word */
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	xfs_rtword_t	incore;
 	int		word;		/* word number in the buffer */
 
 	/*
@@ -824,7 +857,8 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ val) & mask)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
@@ -871,7 +905,8 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = *b ^ val)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = incore ^ val)) {
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
@@ -917,7 +952,8 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ val) & mask)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 01eabb9b5516..4e33e84afa7a 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -159,12 +159,12 @@ xfs_rbmblock_to_rtx(
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
@@ -285,6 +285,10 @@ xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
 unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
 		xfs_rtbxlen_t rtextents);
+xfs_rtword_t xfs_rtbitmap_getword(struct xfs_mount *mp,
+		union xfs_rtword_raw *wordptr);
+void xfs_rtbitmap_setword(struct xfs_mount *mp,
+		union xfs_rtword_raw *wordptr, xfs_rtword_t incore);
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
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

