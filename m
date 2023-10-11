Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0724CDB470
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjJKSHv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjJKSHu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:07:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BC79D
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:07:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA9BC433C8;
        Wed, 11 Oct 2023 18:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047668;
        bh=qLTdLXQPpVDUI7gHgXCEkqPq9Uf6jMkrQmLwSq7cpfk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Kx257vGwgq6ubwE7N5eND+hoJlWiJmdzjhR3y47trVccibYWnnsGNzEwJia/yYh2X
         olsyrgS2cJ2knv7tuNOid8iij/fgzYbknWZiarxwiJHbphWhr2fTM3uAkIFvsPiKvt
         RAAyMbpyQ5pGuQd/ZZnK9Tpg3AdNcxn6e2tIXzV4rTBuzVuMbwXvFfI3kezKnKl6Ut
         QuGWQO7zWuna94D0WrdwGQEUmcszwvP8p5xyOJ4mWB8PBhqobQpvZDAtkE05qlhFv3
         AIUeBc1OVqMLPZjwnC4UAZ535tTibXqwfUcF7vAVu7d3MD23iypoOY5+YCYlT0Q7+S
         kHO+t8aW+Y8Qg==
Date:   Wed, 11 Oct 2023 11:07:48 -0700
Subject: [PATCH 6/8] xfs: use accessor functions for bitmap words
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704721721.1773834.17403646854103787383.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_rtbitmap.h |   10 ++++-
 fs/xfs/xfs_ondisk.h          |    3 ++
 4 files changed, 75 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1254834ab5c9e..8e880ec217396 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -728,6 +728,14 @@ struct xfs_agfl {
 	    ASSERT(xfs_daddr_to_agno(mp, d) == \
 		   xfs_daddr_to_agno(mp, (d) + (len) - 1)))
 
+/*
+ * Realtime bitmap information is accessed by the word, which is currently
+ * stored in host-endian format.
+ */
+union xfs_rtword_ondisk {
+	__u32		raw;
+};
+
 /*
  * XFS Timestamps
  * ==============
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 2a453f0215ee0..b2b1a1aec3422 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -94,6 +94,25 @@ xfs_rtbuf_get(
 	return 0;
 }
 
+/* Convert an ondisk bitmap word to its incore representation. */
+inline xfs_rtword_t
+xfs_rtbitmap_getword(
+	struct xfs_mount	*mp,
+	union xfs_rtword_ondisk	*wordptr)
+{
+	return wordptr->raw;
+}
+
+/* Set an ondisk bitmap word from an incore representation. */
+inline void
+xfs_rtbitmap_setword(
+	struct xfs_mount	*mp,
+	union xfs_rtword_ondisk	*wordptr,
+	xfs_rtword_t		incore)
+{
+	wordptr->raw = incore;
+}
+
 /*
  * Searching backward from start to limit, find the first block whose
  * allocated/free state is different from start's.
@@ -106,7 +125,7 @@ xfs_rtfind_back(
 	xfs_rtxnum_t	limit,		/* last rtext to look at */
 	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
+	union xfs_rtword_ondisk *b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -117,6 +136,7 @@ xfs_rtfind_back(
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	want;		/* mask for "good" values */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	xfs_rtword_t	incore;
 	int		word;		/* word number in the buffer */
 
 	/*
@@ -139,7 +159,8 @@ xfs_rtfind_back(
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	want = (*b & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
+	incore = xfs_rtbitmap_getword(mp, b);
+	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
 	 * partial word.
@@ -156,7 +177,7 @@ xfs_rtfind_back(
 		 * Calculate the difference between the value there
 		 * and what we're looking for.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different.  Mark where we are and return.
 			 */
@@ -202,7 +223,8 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = *b ^ want)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -249,7 +271,8 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -280,7 +303,7 @@ xfs_rtfind_forw(
 	xfs_rtxnum_t	limit,		/* last rtext to look at */
 	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
+	union xfs_rtword_ondisk *b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -291,6 +314,7 @@ xfs_rtfind_forw(
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	want;		/* mask for "good" values */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	xfs_rtword_t	incore;
 	int		word;		/* word number in the buffer */
 
 	/*
@@ -313,7 +337,8 @@ xfs_rtfind_forw(
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	want = (*b & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
+	incore = xfs_rtbitmap_getword(mp, b);
+	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
 	 * partial word.
@@ -329,7 +354,7 @@ xfs_rtfind_forw(
 		 * Calculate the difference between the value there
 		 * and what we're looking for.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different.  Mark where we are and return.
 			 */
@@ -375,7 +400,8 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = *b ^ want)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -420,7 +446,8 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -546,15 +573,16 @@ xfs_rtmodify_range(
 	xfs_rtxlen_t	len,		/* length of extent to modify */
 	int		val)		/* 1 for free, 0 for allocated */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
+	union xfs_rtword_ondisk *b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	int		error;		/* error value */
-	xfs_rtword_t	*first;		/* first used word in the buffer */
+	union xfs_rtword_ondisk *first;		/* first used word in the buffer */
 	int		i;		/* current bit number rel. to start */
 	int		lastbit;	/* last useful bit in word */
 	xfs_rtword_t	mask;		/* mask o frelevant bits for value */
+	xfs_rtword_t	incore;
 	int		word;		/* word number in the buffer */
 
 	/*
@@ -592,10 +620,12 @@ xfs_rtmodify_range(
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
@@ -636,7 +666,7 @@ xfs_rtmodify_range(
 		/*
 		 * Set the word value correctly.
 		 */
-		*b = val;
+		xfs_rtbitmap_setword(mp, b, val);
 		i += XFS_NBWORD;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -676,10 +706,12 @@ xfs_rtmodify_range(
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
@@ -782,7 +814,7 @@ xfs_rtcheck_range(
 	xfs_rtxnum_t	*new,		/* out: first rtext not matching */
 	int		*stat)		/* out: 1 for matches, 0 for not */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
+	union xfs_rtword_ondisk *b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -791,6 +823,7 @@ xfs_rtcheck_range(
 	xfs_rtxnum_t	lastbit;	/* last useful bit in word */
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	xfs_rtword_t	incore;
 	int		word;		/* word number in the buffer */
 
 	/*
@@ -831,7 +864,8 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ val) & mask)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
@@ -878,7 +912,8 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = *b ^ val)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = incore ^ val)) {
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
@@ -924,7 +959,8 @@ xfs_rtcheck_range(
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
index 308ce814a908a..0a3c6299af8e2 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -122,18 +122,18 @@ xfs_rbmblock_to_rtx(
 }
 
 /* Return a pointer to a bitmap word within a rt bitmap block buffer. */
-static inline xfs_rtword_t *
+static inline union xfs_rtword_ondisk *
 xfs_rbmbuf_wordptr(
 	void			*buf,
 	unsigned int		rbmword)
 {
-	xfs_rtword_t		*wordp = buf;
+	union xfs_rtword_ondisk	*wordp = buf;
 
 	return &wordp[rbmword];
 }
 
 /* Return a pointer to a bitmap word within a rt bitmap block. */
-static inline xfs_rtword_t *
+static inline union xfs_rtword_ondisk *
 xfs_rbmblock_wordptr(
 	struct xfs_buf		*bp,
 	unsigned int		rbmword)
@@ -266,6 +266,10 @@ xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
 unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
 		xfs_rtbxlen_t rtextents);
+xfs_rtword_t xfs_rtbitmap_getword(struct xfs_mount *mp,
+		union xfs_rtword_ondisk *wordptr);
+void xfs_rtbitmap_setword(struct xfs_mount *mp,
+		union xfs_rtword_ondisk *wordptr, xfs_rtword_t incore);
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 2bbad8bfc6293..efdba05f90aed 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -72,6 +72,9 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_map_t,		4);
 	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_local_t,	4);
 
+	/* realtime structures */
+	XFS_CHECK_STRUCT_SIZE(union xfs_rtword_ondisk,		4);
+
 	/*
 	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to
 	 * 4 bytes anyway so it's not obviously a problem.  Hence for the moment

