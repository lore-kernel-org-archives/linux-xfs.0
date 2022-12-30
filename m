Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096D5C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236226AbiLaCZJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbiLaCZJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:25:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4746019C12
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:25:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C808061CC4
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C379C433D2;
        Sat, 31 Dec 2022 02:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453507;
        bh=0EiYA4sq2EI7kCdZtbaILwJODvh29kmSTJXmxHqdwBw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JyMmtLD81EzHDwJz80azYXJRuGeN/MNN9L3lAmuBsOkQx6gFyFvDFZvrSEKIYW+RK
         bH4a7L045MyFJK+GE4V4g05cqj8wk3UZFwut8zFErK0250j8xZ34KqDSxKejdBrhii
         OctJAvNcSAbbU4vUy56Wot57G2j+Gogn9uZXhPUZimTTm5nNEQQ0VoBkD8IkxhKAx8
         2kzM/uHrAnPUreDygUHjMpoVhHg+CYwKhLqKg6n3reheE8xFb1fdku3Dic56RL4ln7
         bHNk6hGIp+XI/qrQr1/DjjEk1eIO0JVe3VjzNM36F0NOQXPEUbuiKskMemkSuln7E+
         xyhOlRKXjJLKA==
Subject: [PATCH 3/9] xfs: convert open-coded xfs_rtword_t pointer accesses to
 helper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:32 -0800
Message-ID: <167243877269.727982.17249505634999501680.stgit@magnolia>
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

There are a bunch of places where we use open-coded logic to find a
pointer to an xfs_rtword_t within a rt bitmap buffer.  Convert all that
to helper functions for better type safety.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c            |    4 ++-
 libxfs/xfs_rtbitmap.c |   59 ++++++++++++++++++++++++++-----------------------
 libxfs/xfs_rtbitmap.h |   20 +++++++++++++++++
 repair/phase6.c       |    4 ++-
 4 files changed, 56 insertions(+), 31 deletions(-)


diff --git a/db/check.c b/db/check.c
index 5297ea25459..185be6352b8 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3635,7 +3635,7 @@ process_rtbitmap(
 		push_cur();
 		set_cur(&typtab[TYP_RTBITMAP], XFS_FSB_TO_DADDR(mp, bno), blkbb,
 			DB_RING_IGN, NULL);
-		if ((words = iocur_top->data) == NULL) {
+		if (!iocur_top->bp) {
 			if (!sflag)
 				dbprintf(_("can't read block %lld for rtbitmap "
 					 "inode\n"),
@@ -3644,6 +3644,8 @@ process_rtbitmap(
 			pop_cur();
 			continue;
 		}
+
+		words = xfs_rbmblock_wordptr(iocur_top->bp, 0);
 		for (bit = 0;
 		     bit < bitsperblock && extno < mp->m_sb.sb_rextents;
 		     bit++, extno++) {
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 5301b0448f1..8fec2b769d5 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -108,7 +108,6 @@ xfs_rtfind_back(
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtxnum_t	firstbit;	/* first useful bit in the word */
 	xfs_rtxnum_t	i;		/* current bit number rel. to start */
@@ -126,12 +125,12 @@ xfs_rtfind_back(
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
@@ -178,9 +177,9 @@ xfs_rtfind_back(
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
@@ -224,9 +223,9 @@ xfs_rtfind_back(
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
@@ -283,7 +282,6 @@ xfs_rtfind_forw(
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtxnum_t	i;		/* current bit number rel. to start */
 	xfs_rtxnum_t	lastbit;	/* last useful bit in the word */
@@ -301,12 +299,12 @@ xfs_rtfind_forw(
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
@@ -352,8 +350,9 @@ xfs_rtfind_forw(
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
@@ -397,8 +396,9 @@ xfs_rtfind_forw(
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
@@ -546,7 +546,6 @@ xfs_rtmodify_range(
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtword_t	*first;		/* first used word in the buffer */
 	int		i;		/* current bit number rel. to start */
@@ -565,12 +564,12 @@ xfs_rtmodify_range(
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
@@ -604,14 +603,15 @@ xfs_rtmodify_range(
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
@@ -644,14 +644,15 @@ xfs_rtmodify_range(
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
@@ -681,8 +682,9 @@ xfs_rtmodify_range(
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
 
@@ -780,7 +782,6 @@ xfs_rtcheck_range(
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtxnum_t	i;		/* current bit number rel. to start */
 	xfs_rtxnum_t	lastbit;	/* last useful bit in word */
@@ -799,12 +800,12 @@ xfs_rtcheck_range(
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
@@ -850,8 +851,9 @@ xfs_rtcheck_range(
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
@@ -896,8 +898,9 @@ xfs_rtcheck_range(
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
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 5f4a453e29e..af37afec2b0 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
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
diff --git a/repair/phase6.c b/repair/phase6.c
index 13094730407..aef8a0d6b3f 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -828,11 +828,11 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 			return(1);
 		}
 
-		memmove(bp->b_addr, bmp, mp->m_sb.sb_blocksize);
+		memcpy(xfs_rbmblock_wordptr(bp, 0), bmp, mp->m_sb.sb_blocksize);
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
-		bmp = (xfs_rtword_t *)((intptr_t) bmp + mp->m_sb.sb_blocksize);
+		bmp += mp->m_blockwsize;
 		bno++;
 	}
 

