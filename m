Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208FCC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbiLaCZ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiLaCZ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:25:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E836158
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:25:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CED761CCB
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5951C433D2;
        Sat, 31 Dec 2022 02:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453554;
        bh=foWJ39KzLLAjh6i57uwk5oNPrNtTvy8kpCCvrDJF0p8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=leoENgDT54ZycWL3wzS72uVx3bHJUZqckUSEme+IEJ/D89SRfBTCIcbE/nLyiKCK6
         AFM98GXInUd7evbv73yATGaYEWcWcia8KSDWezC0oXyjoUGeqCe6mkmCAHB5PC9yYl
         jNOEziuVAW6sxsFdWQMgoZ3GcYb/cH7u49ffOhD7g4V9Ux0wVn2JwtS2y6hWAM+27r
         tXstWoNPET9boU0cQg83spgeAvopiiqsgo9K/LNJ7Eb9xCr3goYksZ1WU6/a6X2ZC7
         hGaQ6c3bphTaYnON8UgsJQwrnIphfD5LTkCo/8JCF4GFOMomN7L6sqXb9JX9LfrC+/
         i9w4pIrnzhHVg==
Subject: [PATCH 6/9] xfs: use accessor functions for bitmap words
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:33 -0800
Message-ID: <167243877309.727982.6782851356706519669.stgit@magnolia>
In-Reply-To: <167243877226.727982.8292582053571487702.stgit@magnolia>
References: <167243877226.727982.8292582053571487702.stgit@magnolia>
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
 db/check.c               |   16 +++++++++
 libxfs/libxfs_api_defs.h |    2 +
 libxfs/xfs_format.h      |    8 +++++
 libxfs/xfs_rtbitmap.c    |   78 ++++++++++++++++++++++++++++++++++------------
 libxfs/xfs_rtbitmap.h    |   10 ++++--
 repair/globals.c         |    2 +
 repair/globals.h         |    2 +
 repair/phase6.c          |    2 +
 repair/rt.c              |   13 ++++----
 repair/rt.h              |    6 +---
 10 files changed, 101 insertions(+), 38 deletions(-)


diff --git a/db/check.c b/db/check.c
index 4e1d3c6d366..a10eb74ae81 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3619,10 +3619,20 @@ process_rtbitmap(
 	xfs_rtword_t	*words;
 
 	bitsperblock = mp->m_sb.sb_blocksize * NBBY;
+	words = malloc(mp->m_blockwsize << XFS_WORDLOG);
+	if (!words) {
+		dbprintf(_("could not allocate rtwords buffer\n"));
+		error++;
+		return;
+	}
 	bit = extno = prevbit = start_bmbno = start_bit = 0;
 	bmbno = NULLFILEOFF;
 	while ((bmbno = blkmap_next_off(blkmap, bmbno, &t)) !=
 	       NULLFILEOFF) {
+		xfs_rtword_t	*incore = words;
+		union xfs_rtword_ondisk *ondisk;
+		unsigned int	i;
+
 		bno = blkmap_get(blkmap, bmbno);
 		if (bno == NULLFSBLOCK) {
 			if (!sflag)
@@ -3645,7 +3655,10 @@ process_rtbitmap(
 			continue;
 		}
 
-		words = xfs_rbmblock_wordptr(iocur_top->bp, 0);
+		ondisk = xfs_rbmblock_wordptr(iocur_top->bp, 0);
+		for (i = 0; i < mp->m_blockwsize; i++, incore++, ondisk++)
+			*incore = libxfs_rtbitmap_getword(mp, ondisk);
+
 		for (bit = 0;
 		     bit < bitsperblock && extno < mp->m_sb.sb_rextents;
 		     bit++, extno++) {
@@ -3679,6 +3692,7 @@ process_rtbitmap(
 		offs = xfs_rtsumoffs(mp, log, start_bmbno);
 		sumcompute[offs]++;
 	}
+	free(words);
 }
 
 static void
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 818406b0415..23b4365cc6e 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -227,6 +227,8 @@
 #define xfs_rmap_query_all		libxfs_rmap_query_all
 #define xfs_rmap_query_range		libxfs_rmap_query_range
 
+#define xfs_rtbitmap_getword		libxfs_rtbitmap_getword
+#define xfs_rtbitmap_setword		libxfs_rtbitmap_setword
 #define xfs_rtbitmap_wordcount		libxfs_rtbitmap_wordcount
 
 #define xfs_rtfree_extent		libxfs_rtfree_extent
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d95497c064f..14da972f550 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -717,6 +717,14 @@ struct xfs_agfl {
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
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 116afec2a75..9cfefccb36c 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -92,6 +92,25 @@ xfs_rtbuf_get(
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
@@ -104,7 +123,7 @@ xfs_rtfind_back(
 	xfs_rtxnum_t	limit,		/* last rtext to look at */
 	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
+	union xfs_rtword_ondisk *b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -115,6 +134,7 @@ xfs_rtfind_back(
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	want;		/* mask for "good" values */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	xfs_rtword_t	incore;
 	int		word;		/* word number in the buffer */
 
 	/*
@@ -137,7 +157,8 @@ xfs_rtfind_back(
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	want = (*b & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
+	incore = xfs_rtbitmap_getword(mp, b);
+	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
 	 * partial word.
@@ -154,7 +175,7 @@ xfs_rtfind_back(
 		 * Calculate the difference between the value there
 		 * and what we're looking for.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different.  Mark where we are and return.
 			 */
@@ -200,7 +221,8 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = *b ^ want)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -247,7 +269,8 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -278,7 +301,7 @@ xfs_rtfind_forw(
 	xfs_rtxnum_t	limit,		/* last rtext to look at */
 	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
+	union xfs_rtword_ondisk *b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -289,6 +312,7 @@ xfs_rtfind_forw(
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	want;		/* mask for "good" values */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	xfs_rtword_t	incore;
 	int		word;		/* word number in the buffer */
 
 	/*
@@ -311,7 +335,8 @@ xfs_rtfind_forw(
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	want = (*b & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
+	incore = xfs_rtbitmap_getword(mp, b);
+	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
 	 * partial word.
@@ -327,7 +352,7 @@ xfs_rtfind_forw(
 		 * Calculate the difference between the value there
 		 * and what we're looking for.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different.  Mark where we are and return.
 			 */
@@ -373,7 +398,8 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = *b ^ want)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -418,7 +444,8 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ want) & mask)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
 			 */
@@ -544,15 +571,16 @@ xfs_rtmodify_range(
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
@@ -590,10 +618,12 @@ xfs_rtmodify_range(
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
@@ -634,7 +664,7 @@ xfs_rtmodify_range(
 		/*
 		 * Set the word value correctly.
 		 */
-		*b = val;
+		xfs_rtbitmap_setword(mp, b, val);
 		i += XFS_NBWORD;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -674,10 +704,12 @@ xfs_rtmodify_range(
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
@@ -780,7 +812,7 @@ xfs_rtcheck_range(
 	xfs_rtxnum_t	*new,		/* out: first rtext not matching */
 	int		*stat)		/* out: 1 for matches, 0 for not */
 {
-	xfs_rtword_t	*b;		/* current word in buffer */
+	union xfs_rtword_ondisk *b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
@@ -789,6 +821,7 @@ xfs_rtcheck_range(
 	xfs_rtxnum_t	lastbit;	/* last useful bit in word */
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	xfs_rtword_t	incore;
 	int		word;		/* word number in the buffer */
 
 	/*
@@ -829,7 +862,8 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ val) & mask)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
@@ -876,7 +910,8 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = *b ^ val)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = incore ^ val)) {
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
@@ -922,7 +957,8 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		if ((wdiff = (*b ^ val) & mask)) {
+		incore = xfs_rtbitmap_getword(mp, b);
+		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 308ce814a90..0a3c6299af8 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
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
diff --git a/repair/globals.c b/repair/globals.c
index 3200342e9f1..694a4c39cbd 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -93,7 +93,7 @@ int64_t		fs_max_file_offset;
 
 /* realtime info */
 
-xfs_rtword_t	*btmcompute;
+union xfs_rtword_ondisk	*btmcompute;
 xfs_suminfo_t	*sumcompute;
 
 /* inode tree records have full or partial backptr fields ? */
diff --git a/repair/globals.h b/repair/globals.h
index e51f4e7ece4..51d94ce8224 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -134,7 +134,7 @@ extern int64_t		fs_max_file_offset;
 
 /* realtime info */
 
-extern xfs_rtword_t	*btmcompute;
+extern union xfs_rtword_ondisk		*btmcompute;
 extern xfs_suminfo_t	*sumcompute;
 
 /* inode tree records have full or partial backptr fields ? */
diff --git a/repair/phase6.c b/repair/phase6.c
index aef8a0d6b3f..27c47032fcb 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -782,7 +782,7 @@ fill_rbmino(xfs_mount_t *mp)
 	struct xfs_buf	*bp;
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
-	xfs_rtword_t	*bmp;
+	union xfs_rtword_ondisk	*bmp;
 	int		nmap;
 	int		error;
 	xfs_fileoff_t	bno;
diff --git a/repair/rt.c b/repair/rt.c
index 244b59f04ce..c6df8819cc7 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -29,7 +29,7 @@ rtinit(xfs_mount_t *mp)
 	 * handled by incore_init()
 	 */
 	wordcnt = libxfs_rtbitmap_wordcount(mp, mp->m_sb.sb_rextents);
-	btmcompute = calloc(wordcnt, sizeof(xfs_rtword_t));
+	btmcompute = calloc(wordcnt, sizeof(union xfs_rtword_ondisk));
 	if (!btmcompute)
 		do_error(
 	_("couldn't allocate memory for incore realtime bitmap.\n"));
@@ -44,9 +44,10 @@ rtinit(xfs_mount_t *mp)
  * incore realtime extent map.
  */
 int
-generate_rtinfo(xfs_mount_t	*mp,
-		xfs_rtword_t	*words,
-		xfs_suminfo_t	*sumcompute)
+generate_rtinfo(
+	struct xfs_mount	*mp,
+	union xfs_rtword_ondisk	*words,
+	xfs_suminfo_t		*sumcompute)
 {
 	xfs_rtxnum_t	extno;
 	xfs_rtxnum_t	start_ext;
@@ -75,7 +76,7 @@ generate_rtinfo(xfs_mount_t	*mp,
 	 */
 	while (extno < mp->m_sb.sb_rextents)  {
 		freebit = 1;
-		*words = 0;
+		libxfs_rtbitmap_setword(mp, words, 0);
 		bits = 0;
 		for (i = 0; i < sizeof(xfs_rtword_t) * NBBY &&
 				extno < mp->m_sb.sb_rextents; i++, extno++)  {
@@ -98,7 +99,7 @@ generate_rtinfo(xfs_mount_t	*mp,
 
 			freebit <<= 1;
 		}
-		*words = bits;
+		libxfs_rtbitmap_setword(mp, words, bits);
 		words++;
 
 		if (extno % bitsperblock == 0)
diff --git a/repair/rt.h b/repair/rt.h
index be24e91c95e..4f944487d63 100644
--- a/repair/rt.h
+++ b/repair/rt.h
@@ -11,10 +11,8 @@ struct blkmap;
 void
 rtinit(xfs_mount_t		*mp);
 
-int
-generate_rtinfo(xfs_mount_t	*mp,
-		xfs_rtword_t	*words,
-		xfs_suminfo_t	*sumcompute);
+int generate_rtinfo(struct xfs_mount *mp, union xfs_rtword_ondisk *words,
+		xfs_suminfo_t *sumcompute);
 
 void check_rtbitmap(struct xfs_mount *mp);
 void check_rtsummary(struct xfs_mount *mp);

