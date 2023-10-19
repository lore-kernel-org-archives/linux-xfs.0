Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD6BCDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbjJSQ3M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbjJSQ3L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:29:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7131A124
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:29:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95F5C433C8;
        Thu, 19 Oct 2023 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732947;
        bh=b9GeSUdCC/JKqL27ZTAbVrOaiPsw2gQz4N0uOUvD55w=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Vla9JJ+alWFXImGxlc4h41lpFN/wabAUysRMRFl2v8qrBDlv+4W4/L/8Is7E4h2Xs
         FIdbpVKGUlcqFQGk1sY5ilOx3AwQqBK4HKLMk69J2cQKGmNHrOTi3F9D9CgXWqXYE3
         /SAAZ7iwA/SOtCBSXI2k3BJCmbhy3F0AjE7xWc8xmBiLER18TB6gqyNyoFSawbcfSJ
         ivtcWrqQrTXysK/x+oVNnOjwGgq6Q0RoNrTshUNm00viSCUhfd0ZNMIZKnZCkuqFnQ
         tf3p1k2PkmVeNr25QvVj+E9IYRPg7tKFUupgO6eI7q0MbTK3ajMAz1gj8JMOF0HO5S
         TxDsCX/hp7NtQ==
Date:   Thu, 19 Oct 2023 09:29:06 -0700
Subject: [PATCH 2/9] xfs: cache last bitmap block in realtime allocator
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, osandov@osandov.com, osandov@fb.com,
        hch@lst.de
Message-ID: <169773211754.225862.17531602086744258277.stgit@frogsfrogsfrogs>
In-Reply-To: <169773211712.225862.9408784830071081083.stgit@frogsfrogsfrogs>
References: <169773211712.225862.9408784830071081083.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Profiling a workload on a highly fragmented realtime device showed a ton
of CPU cycles being spent in xfs_trans_read_buf() called by
xfs_rtbuf_get(). Further tracing showed that much of that was repeated
calls to xfs_rtbuf_get() for the same block of the realtime bitmap.
These come from xfs_rtallocate_extent_block(): as it walks through
ranges of free bits in the bitmap, each call to xfs_rtcheck_range() and
xfs_rtfind_{forw,back}() gets the same bitmap block. If the bitmap block
is very fragmented, then this is _a lot_ of buffer lookups.

The realtime allocator already passes around a cache of the last used
realtime summary block to avoid repeated reads (the parameters rbpp and
rsb). We can do the same for the realtime bitmap.

This replaces rbpp and rsb with a struct xfs_rtbuf_cache, which caches
the most recently used block for both the realtime bitmap and summary.
xfs_rtbuf_get() now handles the caching instead of the callers, which
requires plumbing xfs_rtbuf_cache to more functions but also makes sure
we don't miss anything.

Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |  147 ++++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_rtbitmap.h |   17 +++--
 fs/xfs/scrub/rtsummary.c     |    4 +
 fs/xfs/xfs_rtalloc.c         |  111 +++++++++++++-------------------
 4 files changed, 135 insertions(+), 144 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 07841969ada9..5a2d5eaaba57 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -47,6 +47,23 @@ const struct xfs_buf_ops xfs_rtbuf_ops = {
 	.verify_write = xfs_rtbuf_verify_write,
 };
 
+/* Release cached rt bitmap and summary buffers. */
+void
+xfs_rtbuf_cache_relse(
+	struct xfs_rtalloc_args	*args)
+{
+	if (args->rbmbp) {
+		xfs_trans_brelse(args->tp, args->rbmbp);
+		args->rbmbp = NULL;
+		args->rbmoff = NULLFILEOFF;
+	}
+	if (args->sumbp) {
+		xfs_trans_brelse(args->tp, args->sumbp);
+		args->sumbp = NULL;
+		args->sumoff = NULLFILEOFF;
+	}
+}
+
 /*
  * Get a buffer for the bitmap or summary file block specified.
  * The buffer is returned read and locked.
@@ -59,13 +76,42 @@ xfs_rtbuf_get(
 	struct xfs_buf		**bpp)	/* output: buffer for the block */
 {
 	struct xfs_mount	*mp = args->mp;
+	struct xfs_buf		**cbpp;	/* cached block buffer */
+	xfs_fileoff_t		*coffp;	/* cached block number */
 	struct xfs_buf		*bp;	/* block buffer, result */
 	struct xfs_inode	*ip;	/* bitmap or summary inode */
 	struct xfs_bmbt_irec	map;
+	enum xfs_blft		type;
 	int			nmap = 1;
 	int			error;
 
-	ip = issum ? mp->m_rsumip : mp->m_rbmip;
+	if (issum) {
+		cbpp = &args->sumbp;
+		coffp = &args->sumoff;
+		ip = mp->m_rsumip;
+		type = XFS_BLFT_RTSUMMARY_BUF;
+	} else {
+		cbpp = &args->rbmbp;
+		coffp = &args->rbmoff;
+		ip = mp->m_rbmip;
+		type = XFS_BLFT_RTBITMAP_BUF;
+	}
+
+	/*
+	 * If we have a cached buffer, and the block number matches, use that.
+	 */
+	if (*cbpp && *coffp == block) {
+		*bpp = *cbpp;
+		return 0;
+	}
+	/*
+	 * Otherwise we have to have to get the buffer.  If there was an old
+	 * one, get rid of it first.
+	 */
+	if (*cbpp) {
+		xfs_trans_brelse(args->tp, *cbpp);
+		*cbpp = NULL;
+	}
 
 	error = xfs_bmapi_read(ip, block, 1, &map, &nmap, 0);
 	if (error)
@@ -81,9 +127,9 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	xfs_trans_buf_set_type(args->tp, bp, issum ? XFS_BLFT_RTSUMMARY_BUF
-					     : XFS_BLFT_RTBITMAP_BUF);
-	*bpp = bp;
+	xfs_trans_buf_set_type(args->tp, bp, type);
+	*cbpp = *bpp = bp;
+	*coffp = block;
 	return 0;
 }
 
@@ -153,7 +199,6 @@ xfs_rtfind_back(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i = bit - XFS_RTHIBIT(wdiff);
 			*rtx = start - i + 1;
 			return 0;
@@ -167,7 +212,6 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			error = xfs_rtbuf_get(args, --block, 0, &bp);
 			if (error) {
 				return error;
@@ -194,7 +238,6 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
 			*rtx = start - i + 1;
 			return 0;
@@ -208,7 +251,6 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			error = xfs_rtbuf_get(args, --block, 0, &bp);
 			if (error) {
 				return error;
@@ -236,7 +278,6 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
 			*rtx = start - i + 1;
 			return 0;
@@ -246,7 +287,6 @@ xfs_rtfind_back(
 	/*
 	 * No match, return that we scanned the whole area.
 	 */
-	xfs_trans_brelse(args->tp, bp);
 	*rtx = start - i + 1;
 	return 0;
 }
@@ -316,7 +356,6 @@ xfs_rtfind_forw(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
 			*rtx = start + i - 1;
 			return 0;
@@ -330,7 +369,6 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
@@ -357,7 +395,6 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*rtx = start + i - 1;
 			return 0;
@@ -371,7 +408,6 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
@@ -397,7 +433,6 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*rtx = start + i - 1;
 			return 0;
@@ -407,7 +442,6 @@ xfs_rtfind_forw(
 	/*
 	 * No match, return that we scanned the whole area.
 	 */
-	xfs_trans_brelse(args->tp, bp);
 	*rtx = start + i - 1;
 	return 0;
 }
@@ -442,8 +476,6 @@ xfs_rtmodify_summary_int(
 	int			log,	/* log2 of extent size */
 	xfs_fileoff_t		bbno,	/* bitmap block number */
 	int			delta,	/* change to make to summary info */
-	struct xfs_buf		**rbpp,	/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb,	/* in/out: summary block number */
 	xfs_suminfo_t		*sum)	/* out: summary info for this block */
 {
 	struct xfs_mount	*mp = args->mp;
@@ -461,30 +493,11 @@ xfs_rtmodify_summary_int(
 	 * Compute the block number in the summary file.
 	 */
 	sb = xfs_rtsumoffs_to_block(mp, so);
-	/*
-	 * If we have an old buffer, and the block number matches, use that.
-	 */
-	if (*rbpp && *rsb == sb)
-		bp = *rbpp;
-	/*
-	 * Otherwise we have to get the buffer.
-	 */
-	else {
-		/*
-		 * If there was an old one, get rid of it first.
-		 */
-		if (*rbpp)
-			xfs_trans_brelse(args->tp, *rbpp);
-		error = xfs_rtbuf_get(args, sb, 1, &bp);
-		if (error) {
-			return error;
-		}
-		/*
-		 * Remember this buffer and block for the next call.
-		 */
-		*rbpp = bp;
-		*rsb = sb;
-	}
+
+	error = xfs_rtbuf_get(args, sb, 1, &bp);
+	if (error)
+		return error;
+
 	/*
 	 * Point to the summary information, modify/log it, and/or copy it out.
 	 */
@@ -512,11 +525,9 @@ xfs_rtmodify_summary(
 	struct xfs_rtalloc_args	*args,
 	int			log,	/* log2 of extent size */
 	xfs_fileoff_t		bbno,	/* bitmap block number */
-	int			delta,	/* change to make to summary info */
-	struct xfs_buf		**rbpp,	/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb)	/* in/out: summary block number */
+	int			delta)	/* in/out: summary block number */
 {
-	return xfs_rtmodify_summary_int(args, log, bbno, delta, rbpp, rsb, NULL);
+	return xfs_rtmodify_summary_int(args, log, bbno, delta, NULL);
 }
 
 /* Log rtbitmap block from the word @from to the byte before @next. */
@@ -687,9 +698,7 @@ int
 xfs_rtfree_range(
 	struct xfs_rtalloc_args	*args,
 	xfs_rtxnum_t		start,	/* starting rtext to free */
-	xfs_rtxlen_t		len,	/* length to free */
-	struct xfs_buf		**rbpp,	/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb)	/* in/out: summary block number */
+	xfs_rtxlen_t		len)	/* in/out: summary block number */
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_rtxnum_t		end;	/* end of the freed extent */
@@ -718,7 +727,7 @@ xfs_rtfree_range(
 	 * Find the next allocated block (end of allocated extent).
 	 */
 	error = xfs_rtfind_forw(args, end, mp->m_sb.sb_rextents - 1,
-		&postblock);
+			&postblock);
 	if (error)
 		return error;
 	/*
@@ -727,8 +736,8 @@ xfs_rtfree_range(
 	 */
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(args,
-			XFS_RTBLOCKLOG(start - preblock),
-			xfs_rtx_to_rbmblock(mp, preblock), -1, rbpp, rsb);
+				XFS_RTBLOCKLOG(start - preblock),
+				xfs_rtx_to_rbmblock(mp, preblock), -1);
 		if (error) {
 			return error;
 		}
@@ -739,8 +748,8 @@ xfs_rtfree_range(
 	 */
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(args,
-			XFS_RTBLOCKLOG(postblock - end),
-			xfs_rtx_to_rbmblock(mp, end + 1), -1, rbpp, rsb);
+				XFS_RTBLOCKLOG(postblock - end),
+				xfs_rtx_to_rbmblock(mp, end + 1), -1);
 		if (error) {
 			return error;
 		}
@@ -749,10 +758,9 @@ xfs_rtfree_range(
 	 * Increment the summary information corresponding to the entire
 	 * (new) free extent.
 	 */
-	error = xfs_rtmodify_summary(args,
-		XFS_RTBLOCKLOG(postblock + 1 - preblock),
-		xfs_rtx_to_rbmblock(mp, preblock), 1, rbpp, rsb);
-	return error;
+	return xfs_rtmodify_summary(args,
+			XFS_RTBLOCKLOG(postblock + 1 - preblock),
+			xfs_rtx_to_rbmblock(mp, preblock), 1);
 }
 
 /*
@@ -822,7 +830,6 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
 			*new = start + i;
 			*stat = 0;
@@ -837,7 +844,6 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
@@ -864,7 +870,6 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*new = start + i;
 			*stat = 0;
@@ -879,7 +884,6 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
@@ -905,7 +909,6 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*new = start + i;
 			*stat = 0;
@@ -916,7 +919,6 @@ xfs_rtcheck_range(
 	/*
 	 * Successful, return.
 	 */
-	xfs_trans_brelse(args->tp, bp);
 	*new = start + i;
 	*stat = 1;
 	return 0;
@@ -961,8 +963,6 @@ xfs_rtfree_extent(
 		.tp		= tp,
 	};
 	int			error;
-	xfs_fsblock_t		sb;	/* summary file block number */
-	struct xfs_buf		*sumbp = NULL; /* summary file block buffer */
 
 	ASSERT(mp->m_rbmip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
@@ -974,10 +974,10 @@ xfs_rtfree_extent(
 	/*
 	 * Free the range of realtime blocks.
 	 */
-	error = xfs_rtfree_range(&args, start, len, &sumbp, &sb);
-	if (error) {
-		return error;
-	}
+	error = xfs_rtfree_range(&args, start, len);
+	if (error)
+		goto out;
+
 	/*
 	 * Mark more blocks free in the superblock.
 	 */
@@ -993,7 +993,10 @@ xfs_rtfree_extent(
 		*(uint64_t *)&VFS_I(mp->m_rbmip)->i_atime = 0;
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
 	}
-	return 0;
+	error = 0;
+out:
+	xfs_rtbuf_cache_relse(&args);
+	return error;
 }
 
 /*
@@ -1084,6 +1087,7 @@ xfs_rtalloc_query_range(
 		rtstart = rtend + 1;
 	}
 
+	xfs_rtbuf_cache_relse(&args);
 	return error;
 }
 
@@ -1122,6 +1126,7 @@ xfs_rtalloc_extent_is_free(
 	int				error;
 
 	error = xfs_rtcheck_range(&args, start, len, 1, &end, &matches);
+	xfs_rtbuf_cache_relse(&args);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 52aa301aba7b..253f5b763a6c 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -9,6 +9,12 @@
 struct xfs_rtalloc_args {
 	struct xfs_mount	*mp;
 	struct xfs_trans	*tp;
+
+	struct xfs_buf		*rbmbp;	/* bitmap block buffer */
+	struct xfs_buf		*sumbp;	/* summary block buffer */
+
+	xfs_fileoff_t		rbmoff;	/* bitmap block number */
+	xfs_fileoff_t		sumoff;	/* summary block number */
 };
 
 static inline xfs_rtblock_t
@@ -286,6 +292,8 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 	void				*priv);
 
 #ifdef CONFIG_XFS_RT
+void xfs_rtbuf_cache_relse(struct xfs_rtalloc_args *args);
+
 int xfs_rtbuf_get(struct xfs_rtalloc_args *args, xfs_fileoff_t block,
 		int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
@@ -297,13 +305,11 @@ int xfs_rtfind_forw(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 int xfs_rtmodify_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 		xfs_rtxlen_t len, int val);
 int xfs_rtmodify_summary_int(struct xfs_rtalloc_args *args, int log,
-		xfs_fileoff_t bbno, int delta, struct xfs_buf **rbpp,
-		xfs_fileoff_t *rsb, xfs_suminfo_t *sum);
+		xfs_fileoff_t bbno, int delta, xfs_suminfo_t *sum);
 int xfs_rtmodify_summary(struct xfs_rtalloc_args *args, int log,
-		xfs_fileoff_t bbno, int delta, struct xfs_buf **rbpp,
-		xfs_fileoff_t *rsb);
+		xfs_fileoff_t bbno, int delta);
 int xfs_rtfree_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
-		xfs_rtxlen_t len, struct xfs_buf **rbpp, xfs_fileoff_t *rsb);
+		xfs_rtxlen_t len);
 int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		const struct xfs_rtalloc_rec *low_rec,
 		const struct xfs_rtalloc_rec *high_rec,
@@ -343,6 +349,7 @@ unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 # define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
 # define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
 # define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
+# define xfs_rtbuf_cache_relse(a)			(0)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 static inline xfs_filblks_t
 xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 10e83196301c..ec17385fe4b0 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -228,7 +228,7 @@ xchk_rtsum_compare(
 		/* Read a block's worth of computed rtsummary file. */
 		error = xfsum_copyout(sc, sumoff, sc->buf, mp->m_blockwsize);
 		if (error) {
-			xfs_trans_brelse(sc->tp, bp);
+			xfs_rtbuf_cache_relse(&args);
 			return error;
 		}
 
@@ -237,7 +237,7 @@ xchk_rtsum_compare(
 					mp->m_blockwsize << XFS_WORDLOG) != 0)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
 
-		xfs_trans_brelse(sc->tp, bp);
+		xfs_rtbuf_cache_relse(&args);
 		sumoff += mp->m_blockwsize;
 	}
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 73d3280fbe36..d5b6be45755f 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -32,11 +32,9 @@ xfs_rtget_summary(
 	struct xfs_rtalloc_args	*args,
 	int			log,	/* log2 of extent size */
 	xfs_fileoff_t		bbno,	/* bitmap block number */
-	struct xfs_buf		**rbpp,	/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb,	/* in/out: summary block number */
 	xfs_suminfo_t		*sum)	/* out: summary info for this block */
 {
-	return xfs_rtmodify_summary_int(args, log, bbno, 0, rbpp, rsb, sum);
+	return xfs_rtmodify_summary_int(args, log, bbno, 0, sum);
 }
 
 /*
@@ -49,8 +47,6 @@ xfs_rtany_summary(
 	int			low,	/* low log2 extent size */
 	int			high,	/* high log2 extent size */
 	xfs_fileoff_t		bbno,	/* bitmap block number */
-	struct xfs_buf		**rbpp,	/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb,	/* in/out: summary block number */
 	int			*stat)	/* out: any good extents here? */
 {
 	struct xfs_mount	*mp = args->mp;
@@ -69,7 +65,7 @@ xfs_rtany_summary(
 		/*
 		 * Get one summary datum.
 		 */
-		error = xfs_rtget_summary(args, log, bbno, rbpp, rsb, &sum);
+		error = xfs_rtget_summary(args, log, bbno, &sum);
 		if (error) {
 			return error;
 		}
@@ -103,34 +99,31 @@ xfs_rtcopy_summary(
 	struct xfs_rtalloc_args	*nargs)
 {
 	xfs_fileoff_t		bbno;	/* bitmap block number */
-	struct xfs_buf		*bp;	/* summary buffer */
 	int			error;
 	int			log;	/* summary level number (log length) */
 	xfs_suminfo_t		sum;	/* summary data */
-	xfs_fileoff_t		sumbno;	/* summary block number */
 
-	bp = NULL;
 	for (log = oargs->mp->m_rsumlevels - 1; log >= 0; log--) {
 		for (bbno = oargs->mp->m_sb.sb_rbmblocks - 1;
 		     (xfs_srtblock_t)bbno >= 0;
 		     bbno--) {
-			error = xfs_rtget_summary(oargs, log, bbno, &bp,
-				&sumbno, &sum);
+			error = xfs_rtget_summary(oargs, log, bbno, &sum);
 			if (error)
-				return error;
+				goto out;
 			if (sum == 0)
 				continue;
-			error = xfs_rtmodify_summary(oargs, log, bbno, -sum,
-				&bp, &sumbno);
+			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
 			if (error)
-				return error;
-			error = xfs_rtmodify_summary(nargs, log, bbno, sum,
-				&bp, &sumbno);
+				goto out;
+			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
 			if (error)
-				return error;
+				goto out;
 			ASSERT(sum > 0);
 		}
 	}
+	error = 0;
+out:
+	xfs_rtbuf_cache_relse(oargs);
 	return 0;
 }
 /*
@@ -141,9 +134,7 @@ STATIC int
 xfs_rtallocate_range(
 	struct xfs_rtalloc_args	*args,
 	xfs_rtxnum_t		start,	/* start rtext to allocate */
-	xfs_rtxlen_t		len,	/* length to allocate */
-	struct xfs_buf		**rbpp,	/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb)	/* in/out: summary block number */
+	xfs_rtxlen_t		len)	/* in/out: summary block number */
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_rtxnum_t		end;	/* end of the allocated rtext */
@@ -165,7 +156,7 @@ xfs_rtallocate_range(
 	 * Find the next allocated block (end of free extent).
 	 */
 	error = xfs_rtfind_forw(args, end, mp->m_sb.sb_rextents - 1,
-		&postblock);
+			&postblock);
 	if (error) {
 		return error;
 	}
@@ -174,8 +165,8 @@ xfs_rtallocate_range(
 	 * (old) free extent.
 	 */
 	error = xfs_rtmodify_summary(args,
-		XFS_RTBLOCKLOG(postblock + 1 - preblock),
-		xfs_rtx_to_rbmblock(mp, preblock), -1, rbpp, rsb);
+			XFS_RTBLOCKLOG(postblock + 1 - preblock),
+			xfs_rtx_to_rbmblock(mp, preblock), -1);
 	if (error) {
 		return error;
 	}
@@ -185,8 +176,8 @@ xfs_rtallocate_range(
 	 */
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(args,
-			XFS_RTBLOCKLOG(start - preblock),
-			xfs_rtx_to_rbmblock(mp, preblock), 1, rbpp, rsb);
+				XFS_RTBLOCKLOG(start - preblock),
+				xfs_rtx_to_rbmblock(mp, preblock), 1);
 		if (error) {
 			return error;
 		}
@@ -197,8 +188,8 @@ xfs_rtallocate_range(
 	 */
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(args,
-			XFS_RTBLOCKLOG(postblock - end),
-			xfs_rtx_to_rbmblock(mp, end + 1), 1, rbpp, rsb);
+				XFS_RTBLOCKLOG(postblock - end),
+				xfs_rtx_to_rbmblock(mp, end + 1), 1);
 		if (error) {
 			return error;
 		}
@@ -241,8 +232,6 @@ xfs_rtallocate_extent_block(
 	xfs_rtxlen_t		maxlen,	/* maximum length to allocate */
 	xfs_rtxlen_t		*len,	/* out: actual length allocated */
 	xfs_rtxnum_t		*nextp,	/* out: next rtext to try */
-	struct xfs_buf		**rbpp,	/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb,	/* in/out: summary block number */
 	xfs_rtxlen_t		prod,	/* extent product factor */
 	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
 {
@@ -278,8 +267,7 @@ xfs_rtallocate_extent_block(
 			/*
 			 * i for maxlen is all free, allocate and return that.
 			 */
-			error = xfs_rtallocate_range(args, i, maxlen, rbpp,
-				rsb);
+			error = xfs_rtallocate_range(args, i, maxlen);
 			if (error) {
 				return error;
 			}
@@ -331,7 +319,7 @@ xfs_rtallocate_extent_block(
 		/*
 		 * Allocate besti for bestlen & return that.
 		 */
-		error = xfs_rtallocate_range(args, besti, bestlen, rbpp, rsb);
+		error = xfs_rtallocate_range(args, besti, bestlen);
 		if (error) {
 			return error;
 		}
@@ -360,8 +348,6 @@ xfs_rtallocate_extent_exact(
 	xfs_rtxlen_t		minlen,	/* minimum length to allocate */
 	xfs_rtxlen_t		maxlen,	/* maximum length to allocate */
 	xfs_rtxlen_t		*len,	/* out: actual length allocated */
-	struct xfs_buf		**rbpp,	/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb,	/* in/out: summary block number */
 	xfs_rtxlen_t		prod,	/* extent product factor */
 	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
 {
@@ -383,7 +369,7 @@ xfs_rtallocate_extent_exact(
 		/*
 		 * If it is, allocate it and return success.
 		 */
-		error = xfs_rtallocate_range(args, start, maxlen, rbpp, rsb);
+		error = xfs_rtallocate_range(args, start, maxlen);
 		if (error) {
 			return error;
 		}
@@ -418,7 +404,7 @@ xfs_rtallocate_extent_exact(
 	/*
 	 * Allocate what we can and return it.
 	 */
-	error = xfs_rtallocate_range(args, start, maxlen, rbpp, rsb);
+	error = xfs_rtallocate_range(args, start, maxlen);
 	if (error) {
 		return error;
 	}
@@ -439,8 +425,6 @@ xfs_rtallocate_extent_near(
 	xfs_rtxlen_t		minlen,	/* minimum length to allocate */
 	xfs_rtxlen_t		maxlen,	/* maximum length to allocate */
 	xfs_rtxlen_t		*len,	/* out: actual length allocated */
-	struct xfs_buf		**rbpp,	/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb,	/* in/out: summary block number */
 	xfs_rtxlen_t		prod,	/* extent product factor */
 	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
 {
@@ -475,7 +459,7 @@ xfs_rtallocate_extent_near(
 	 * Try the exact allocation first.
 	 */
 	error = xfs_rtallocate_extent_exact(args, start, minlen, maxlen, len,
-			rbpp, rsb, prod, &r);
+			prod, &r);
 	if (error) {
 		return error;
 	}
@@ -499,7 +483,7 @@ xfs_rtallocate_extent_near(
 		 * starting in this bitmap block.
 		 */
 		error = xfs_rtany_summary(args, log2len, mp->m_rsumlevels - 1,
-			bbno + i, rbpp, rsb, &any);
+				bbno + i, &any);
 		if (error) {
 			return error;
 		}
@@ -517,8 +501,8 @@ xfs_rtallocate_extent_near(
 				 * this block.
 				 */
 				error = xfs_rtallocate_extent_block(args,
-					bbno + i, minlen, maxlen, len, &n, rbpp,
-					rsb, prod, &r);
+						bbno + i, minlen, maxlen, len,
+						&n, prod, &r);
 				if (error) {
 					return error;
 				}
@@ -546,8 +530,9 @@ xfs_rtallocate_extent_near(
 					 * this bitmap block.
 					 */
 					error = xfs_rtany_summary(args,
-						log2len, mp->m_rsumlevels - 1,
-						bbno + j, rbpp, rsb, &any);
+							log2len,
+							mp->m_rsumlevels - 1,
+							bbno + j, &any);
 					if (error) {
 						return error;
 					}
@@ -562,8 +547,9 @@ xfs_rtallocate_extent_near(
 					if (any)
 						continue;
 					error = xfs_rtallocate_extent_block(args,
-						bbno + j, minlen, maxlen,
-						len, &n, rbpp, rsb, prod, &r);
+							bbno + j, minlen,
+							maxlen, len, &n, prod,
+							&r);
 					if (error) {
 						return error;
 					}
@@ -584,8 +570,8 @@ xfs_rtallocate_extent_near(
 				 * that we found.
 				 */
 				error = xfs_rtallocate_extent_block(args,
-					bbno + i, minlen, maxlen, len, &n, rbpp,
-					rsb, prod, &r);
+						bbno + i, minlen, maxlen, len,
+						&n, prod, &r);
 				if (error) {
 					return error;
 				}
@@ -643,8 +629,6 @@ xfs_rtallocate_extent_size(
 	xfs_rtxlen_t		minlen,	/* minimum length to allocate */
 	xfs_rtxlen_t		maxlen,	/* maximum length to allocate */
 	xfs_rtxlen_t		*len,	/* out: actual length allocated */
-	struct xfs_buf		**rbpp,	/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb,	/* in/out: summary block number */
 	xfs_rtxlen_t		prod,	/* extent product factor */
 	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
 {
@@ -675,8 +659,7 @@ xfs_rtallocate_extent_size(
 			/*
 			 * Get the summary for this level/block.
 			 */
-			error = xfs_rtget_summary(args, l, i, rbpp, rsb,
-				&sum);
+			error = xfs_rtget_summary(args, l, i, &sum);
 			if (error) {
 				return error;
 			}
@@ -689,7 +672,7 @@ xfs_rtallocate_extent_size(
 			 * Try allocating the extent.
 			 */
 			error = xfs_rtallocate_extent_block(args, i, maxlen,
-				maxlen, len, &n, rbpp, rsb, prod, &r);
+					maxlen, len, &n, prod, &r);
 			if (error) {
 				return error;
 			}
@@ -734,8 +717,7 @@ xfs_rtallocate_extent_size(
 			/*
 			 * Get the summary information for this level/block.
 			 */
-			error =	xfs_rtget_summary(args, l, i, rbpp, rsb,
-						  &sum);
+			error =	xfs_rtget_summary(args, l, i, &sum);
 			if (error) {
 				return error;
 			}
@@ -752,7 +734,7 @@ xfs_rtallocate_extent_size(
 			error = xfs_rtallocate_extent_block(args, i,
 					XFS_RTMAX(minlen, 1 << l),
 					XFS_RTMIN(maxlen, (1 << (l + 1)) - 1),
-					len, &n, rbpp, rsb, prod, &r);
+					len, &n, prod, &r);
 			if (error) {
 				return error;
 			}
@@ -941,7 +923,6 @@ xfs_growfs_rt(
 	xfs_extlen_t	rbmblocks;	/* current number of rt bitmap blocks */
 	xfs_extlen_t	rsumblocks;	/* current number of rt summary blks */
 	xfs_sb_t	*sbp;		/* old superblock */
-	xfs_fileoff_t	sumbno;		/* summary block number */
 	uint8_t		*rsum_cache;	/* old summary cache */
 
 	sbp = &mp->m_sb;
@@ -1136,9 +1117,9 @@ xfs_growfs_rt(
 		/*
 		 * Free new extent.
 		 */
-		bp = NULL;
 		error = xfs_rtfree_range(&nargs, sbp->sb_rextents,
-			nsbp->sb_rextents - sbp->sb_rextents, &bp, &sumbno);
+				nsbp->sb_rextents - sbp->sb_rextents);
+		xfs_rtbuf_cache_relse(&nargs);
 		if (error) {
 error_cancel:
 			xfs_trans_cancel(tp);
@@ -1211,10 +1192,8 @@ xfs_rtallocate_extent(
 		.mp		= tp->t_mountp,
 		.tp		= tp,
 	};
-	int			error;
+	int			error;	/* error value */
 	xfs_rtxnum_t		r;	/* result allocated rtext */
-	xfs_fileoff_t		sb;	/* summary file block number */
-	struct xfs_buf		*sumbp;	/* summary file block buffer */
 
 	ASSERT(xfs_isilocked(args.mp->m_rbmip, XFS_ILOCK_EXCL));
 	ASSERT(minlen > 0 && minlen <= maxlen);
@@ -1236,15 +1215,15 @@ xfs_rtallocate_extent(
 	}
 
 retry:
-	sumbp = NULL;
 	if (start == 0) {
 		error = xfs_rtallocate_extent_size(&args, minlen,
-				maxlen, len, &sumbp, &sb, prod, &r);
+				maxlen, len, prod, &r);
 	} else {
 		error = xfs_rtallocate_extent_near(&args, start, minlen,
-				maxlen, len, &sumbp, &sb, prod, &r);
+				maxlen, len, prod, &r);
 	}
 
+	xfs_rtbuf_cache_relse(&args);
 	if (error)
 		return error;
 

