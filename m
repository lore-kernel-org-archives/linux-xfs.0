Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B495157872
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998985; cv=none; b=fqK+ulyDW0Ccw1A2g3NYI1xIc/et7RKJ1erh6WvU+oPanC3CYh4kG33rdnZlrMJcqe+UfHQHHDRHUFx6QIfrUplqxy0epG6bdNsWx0HulEspGG5CTxzQM1LYG/CJUaliizfBhU9+N8kH1miRBxFBbUB+98FWri9QOQ28LfLr6lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998985; c=relaxed/simple;
	bh=7uPNxdBG4LP7W6/xenwEhoVdXYeT8A9UIR7GmzN6WWg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmHsqkTwrBR+SFpoRpRgsF7RDRvPvxS1yRQvUk+Jid1KiAsU7BSGFIfn3pwNNNXpi3kQYKxKQFgjA/sTyqEEoQubat5bsE4qyNDGJVN8s1U8zD1fEKCIUbIhlUMj3pNfxTB4BsQByQdGkM3flJxnHDnQRutExxjnr/nt6L8uyWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p8gHePrK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p8gHePrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4CFC433F1
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998985;
	bh=7uPNxdBG4LP7W6/xenwEhoVdXYeT8A9UIR7GmzN6WWg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=p8gHePrKBVW8KXlQyuHgVQ5VJR7ajml0y5hLmqDFWBLd1wusg0D/OzdrmteOh+wTd
	 /MWAHgqccjWK8AGwZ82R6JhLNKqlIzlQVU9gkYk7dciI9zgCjDK+/EfGfCEMoZfXzS
	 JzbRIonQOBb4lIxQRWLjNmjzG6MNxtMaQv8Au1kmydtpwlGCTVfHYTaK4HXkhDYHb1
	 Iltb46VZF4j9agJ9Q1YB8KZM+iee4ifBmurCwuvYtA6yg3mLKGcNzjeMtT4+e9Pom1
	 HxN5QSDzynKy1Cs8FK9qpOB3v6HJDfWyvbXtotln/YE4MFg5G8tY++LS32lJG0UrXA
	 50hhsd0PXIv0w==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 28/35] xfs: cache last bitmap block in realtime allocator
Date: Thu, 15 Feb 2024 13:08:40 +0100
Message-ID: <20240215120907.1542854-29-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Omar Sandoval <osandov@fb.com>

Source kernel commit: e94b53ff699c2674a9ec083342a5254866210ade

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
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.c | 147 ++++++++++++++++++++++--------------------
 libxfs/xfs_rtbitmap.h |  17 +++--
 2 files changed, 88 insertions(+), 76 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 53e2c1c89..e9c70ff88 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -45,6 +45,23 @@ const struct xfs_buf_ops xfs_rtbuf_ops = {
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
@@ -57,13 +74,42 @@ xfs_rtbuf_get(
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
@@ -79,9 +125,9 @@ xfs_rtbuf_get(
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
 
@@ -151,7 +197,6 @@ xfs_rtfind_back(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i = bit - XFS_RTHIBIT(wdiff);
 			*rtx = start - i + 1;
 			return 0;
@@ -165,7 +210,6 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			error = xfs_rtbuf_get(args, --block, 0, &bp);
 			if (error) {
 				return error;
@@ -192,7 +236,6 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
 			*rtx = start - i + 1;
 			return 0;
@@ -206,7 +249,6 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			error = xfs_rtbuf_get(args, --block, 0, &bp);
 			if (error) {
 				return error;
@@ -234,7 +276,6 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
 			*rtx = start - i + 1;
 			return 0;
@@ -244,7 +285,6 @@ xfs_rtfind_back(
 	/*
 	 * No match, return that we scanned the whole area.
 	 */
-	xfs_trans_brelse(args->tp, bp);
 	*rtx = start - i + 1;
 	return 0;
 }
@@ -314,7 +354,6 @@ xfs_rtfind_forw(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
 			*rtx = start + i - 1;
 			return 0;
@@ -328,7 +367,6 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
@@ -355,7 +393,6 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*rtx = start + i - 1;
 			return 0;
@@ -369,7 +406,6 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
@@ -395,7 +431,6 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*rtx = start + i - 1;
 			return 0;
@@ -405,7 +440,6 @@ xfs_rtfind_forw(
 	/*
 	 * No match, return that we scanned the whole area.
 	 */
-	xfs_trans_brelse(args->tp, bp);
 	*rtx = start + i - 1;
 	return 0;
 }
@@ -440,8 +474,6 @@ xfs_rtmodify_summary_int(
 	int			log,	/* log2 of extent size */
 	xfs_fileoff_t		bbno,	/* bitmap block number */
 	int			delta,	/* change to make to summary info */
-	struct xfs_buf		**rbpp,	/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb,	/* in/out: summary block number */
 	xfs_suminfo_t		*sum)	/* out: summary info for this block */
 {
 	struct xfs_mount	*mp = args->mp;
@@ -459,30 +491,11 @@ xfs_rtmodify_summary_int(
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
@@ -510,11 +523,9 @@ xfs_rtmodify_summary(
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
@@ -685,9 +696,7 @@ int
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
@@ -716,7 +725,7 @@ xfs_rtfree_range(
 	 * Find the next allocated block (end of allocated extent).
 	 */
 	error = xfs_rtfind_forw(args, end, mp->m_sb.sb_rextents - 1,
-		&postblock);
+			&postblock);
 	if (error)
 		return error;
 	/*
@@ -725,8 +734,8 @@ xfs_rtfree_range(
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
@@ -737,8 +746,8 @@ xfs_rtfree_range(
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
@@ -747,10 +756,9 @@ xfs_rtfree_range(
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
@@ -820,7 +828,6 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
 			*new = start + i;
 			*stat = 0;
@@ -835,7 +842,6 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
@@ -862,7 +868,6 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*new = start + i;
 			*stat = 0;
@@ -877,7 +882,6 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
@@ -903,7 +907,6 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(args->tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*new = start + i;
 			*stat = 0;
@@ -914,7 +917,6 @@ xfs_rtcheck_range(
 	/*
 	 * Successful, return.
 	 */
-	xfs_trans_brelse(args->tp, bp);
 	*new = start + i;
 	*stat = 1;
 	return 0;
@@ -959,8 +961,6 @@ xfs_rtfree_extent(
 		.tp		= tp,
 	};
 	int			error;
-	xfs_fsblock_t		sb;	/* summary file block number */
-	struct xfs_buf		*sumbp = NULL;	/* summary file block buffer */
 	struct timespec64	atime;
 
 	ASSERT(mp->m_rbmip->i_itemp != NULL);
@@ -973,10 +973,10 @@ xfs_rtfree_extent(
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
@@ -995,7 +995,10 @@ xfs_rtfree_extent(
 		inode_set_atime_to_ts(VFS_I(mp->m_rbmip), atime);
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
 	}
-	return 0;
+	error = 0;
+out:
+	xfs_rtbuf_cache_relse(&args);
+	return error;
 }
 
 /*
@@ -1086,6 +1089,7 @@ xfs_rtalloc_query_range(
 		rtstart = rtend + 1;
 	}
 
+	xfs_rtbuf_cache_relse(&args);
 	return error;
 }
 
@@ -1124,6 +1128,7 @@ xfs_rtalloc_extent_is_free(
 	int				error;
 
 	error = xfs_rtcheck_range(&args, start, len, 1, &end, &matches);
+	xfs_rtbuf_cache_relse(&args);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 025a7efc2..ac8cd1412 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -12,6 +12,12 @@
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
@@ -289,6 +295,8 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 	void				*priv);
 
 #ifdef CONFIG_XFS_RT
+void xfs_rtbuf_cache_relse(struct xfs_rtalloc_args *args);
+
 int xfs_rtbuf_get(struct xfs_rtalloc_args *args, xfs_fileoff_t block,
 		int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
@@ -300,13 +308,11 @@ int xfs_rtfind_forw(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
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
@@ -346,6 +352,7 @@ unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 # define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
 # define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
 # define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
+# define xfs_rtbuf_cache_relse(a)			(0)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 static inline xfs_filblks_t
 xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
-- 
2.43.0

