Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5374A02
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372080; cv=none; b=a9xu94sy/PTtR6NY64kVzTfqv9MU1N+laxYA//oqH9nZIZvi5yCYZowllOMzYnS18Wb3XfJBnifkPmPqhRHXJr1NLD7Y28ZE1kXtdG0leZKcv+87IfH5ztxNgWene5GO/VrugwrJnuMyKOB94jC1/9bh+0X+32FhPwYX/MRBy60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372080; c=relaxed/simple;
	bh=OnwU5reumCw9sk2dnYJQK3hTGXFqXFWBTHFwttFX4Tw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lab2szPNXNNluuTmvaoihxD3LV2drZu+E+eKS2KE0XxwFDWAY5gbO53xc4RhMlvYNdZUkFrNPM24SF8oTx4ljLik+GEyhcR6R2qQKEjZ7uM/yFDbT5OK3yMTYiE8g02nCbtrPg1sGxvc2OKyeUZjKY1mhDbE461RzS3m6758Gws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DweApmSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DweApmSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE443C4AF0B;
	Fri, 23 Aug 2024 00:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372079;
	bh=OnwU5reumCw9sk2dnYJQK3hTGXFqXFWBTHFwttFX4Tw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DweApmSKz4zfevsoD8qZDPd8kMhYcr5y6/uJxZsU6bgN4PIBL+pd2TTtwnlZMlN+P
	 7kU5umIX/w3i8TZKrhBF870A0CuZMh5qFCDzgBtizeYZjirpa3TOpqnHeWUMSEbnVP
	 SDfa1FJE1ikETw2IlhmWao5vjnaCOdoYqKP1rBZKj7dQ839/fDsmvVn+J/WAXl+3HH
	 CMZKP/mPNZH1XK5XiGM56q+xSW3fB0ep9idGOoP/vYcUt5v+dusF7FXX7xhcRCi1SB
	 YbMHtZaQ8P0OFZLh+hoamSBpH+Vq/FnP2ZXLu43uH8CwcAKYkGtGa6bsi36CN8+nD0
	 vINMKdiG5WA2g==
Date: Thu, 22 Aug 2024 17:14:39 -0700
Subject: [PATCH 10/10] xfs: simplify xfs_rtalloc_query_range
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086789.59070.5109124547219329958.stgit@frogsfrogsfrogs>
In-Reply-To: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
References: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

There isn't much of a good reason to pass the xfs_rtalloc_rec structures
that describe extents to xfs_rtalloc_query_range as we really just want
a lower and upper bound xfs_rtxnum_t.  Pass the rtxnum directly and
simply the interface.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   42 +++++++++++++++++-------------------------
 fs/xfs/libxfs/xfs_rtbitmap.h |    3 +--
 fs/xfs/xfs_discard.c         |   15 +++++++--------
 fs/xfs/xfs_fsmap.c           |   11 +++++------
 4 files changed, 30 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 431ef62939caa..c58eb75ef0fa0 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1047,8 +1047,8 @@ int
 xfs_rtalloc_query_range(
 	struct xfs_mount		*mp,
 	struct xfs_trans		*tp,
-	const struct xfs_rtalloc_rec	*low_rec,
-	const struct xfs_rtalloc_rec	*high_rec,
+	xfs_rtxnum_t			start,
+	xfs_rtxnum_t			end,
 	xfs_rtalloc_query_range_fn	fn,
 	void				*priv)
 {
@@ -1056,45 +1056,42 @@ xfs_rtalloc_query_range(
 		.mp			= mp,
 		.tp			= tp,
 	};
-	struct xfs_rtalloc_rec		rec;
-	xfs_rtxnum_t			rtstart;
-	xfs_rtxnum_t			rtend;
-	xfs_rtxnum_t			high_key;
-	int				is_free;
 	int				error = 0;
 
-	if (low_rec->ar_startext > high_rec->ar_startext)
+	if (start > end)
 		return -EINVAL;
-	if (low_rec->ar_startext >= mp->m_sb.sb_rextents ||
-	    low_rec->ar_startext == high_rec->ar_startext)
+	if (start == end || start >= mp->m_sb.sb_rextents)
 		return 0;
 
-	high_key = min(high_rec->ar_startext, mp->m_sb.sb_rextents - 1);
+	end = min(end, mp->m_sb.sb_rextents - 1);
 
 	/* Iterate the bitmap, looking for discrepancies. */
-	rtstart = low_rec->ar_startext;
-	while (rtstart <= high_key) {
+	while (start <= end) {
+		struct xfs_rtalloc_rec	rec;
+		int			is_free;
+		xfs_rtxnum_t		rtend;
+
 		/* Is the first block free? */
-		error = xfs_rtcheck_range(&args, rtstart, 1, 1, &rtend,
+		error = xfs_rtcheck_range(&args, start, 1, 1, &rtend,
 				&is_free);
 		if (error)
 			break;
 
 		/* How long does the extent go for? */
-		error = xfs_rtfind_forw(&args, rtstart, high_key, &rtend);
+		error = xfs_rtfind_forw(&args, start, end, &rtend);
 		if (error)
 			break;
 
 		if (is_free) {
-			rec.ar_startext = rtstart;
-			rec.ar_extcount = rtend - rtstart + 1;
+			rec.ar_startext = start;
+			rec.ar_extcount = rtend - start + 1;
 
 			error = fn(mp, tp, &rec, priv);
 			if (error)
 				break;
 		}
 
-		rtstart = rtend + 1;
+		start = rtend + 1;
 	}
 
 	xfs_rtbuf_cache_relse(&args);
@@ -1109,13 +1106,8 @@ xfs_rtalloc_query_all(
 	xfs_rtalloc_query_range_fn	fn,
 	void				*priv)
 {
-	struct xfs_rtalloc_rec		keys[2];
-
-	keys[0].ar_startext = 0;
-	keys[1].ar_startext = mp->m_sb.sb_rextents - 1;
-	keys[0].ar_extcount = keys[1].ar_extcount = 0;
-
-	return xfs_rtalloc_query_range(mp, tp, &keys[0], &keys[1], fn, priv);
+	return xfs_rtalloc_query_range(mp, tp, 0, mp->m_sb.sb_rextents - 1, fn,
+			priv);
 }
 
 /* Is the given extent all free? */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 69ddacd4b01e6..0dbc9bb40668a 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -292,8 +292,7 @@ int xfs_rtmodify_summary(struct xfs_rtalloc_args *args, int log,
 int xfs_rtfree_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 		xfs_rtxlen_t len);
 int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		const struct xfs_rtalloc_rec *low_rec,
-		const struct xfs_rtalloc_rec *high_rec,
+		xfs_rtxnum_t start, xfs_rtxnum_t end,
 		xfs_rtalloc_query_range_fn fn, void *priv);
 int xfs_rtalloc_query_all(struct xfs_mount *mp, struct xfs_trans *tp,
 			  xfs_rtalloc_query_range_fn fn,
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 25f5dffeab2ae..bf1e3f330018d 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -554,11 +554,10 @@ xfs_trim_rtdev_extents(
 	xfs_daddr_t		end,
 	xfs_daddr_t		minlen)
 {
-	struct xfs_rtalloc_rec	low = { };
-	struct xfs_rtalloc_rec	high = { };
 	struct xfs_trim_rtdev	tr = {
 		.minlen_fsb	= XFS_BB_TO_FSB(mp, minlen),
 	};
+	xfs_rtxnum_t		low, high;
 	struct xfs_trans	*tp;
 	xfs_daddr_t		rtdev_daddr;
 	int			error;
@@ -584,17 +583,17 @@ xfs_trim_rtdev_extents(
 			XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks) - 1);
 
 	/* Convert the rt blocks to rt extents */
-	low.ar_startext = xfs_rtb_to_rtxup(mp, XFS_BB_TO_FSB(mp, start));
-	high.ar_startext = xfs_rtb_to_rtx(mp, XFS_BB_TO_FSBT(mp, end));
+	low = xfs_rtb_to_rtxup(mp, XFS_BB_TO_FSB(mp, start));
+	high = xfs_rtb_to_rtx(mp, XFS_BB_TO_FSBT(mp, end));
 
 	/*
 	 * Walk the free ranges between low and high.  The query_range function
 	 * trims the extents returned.
 	 */
 	do {
-		tr.stop_rtx = low.ar_startext + (mp->m_sb.sb_blocksize * NBBY);
+		tr.stop_rtx = low + (mp->m_sb.sb_blocksize * NBBY);
 		xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
-		error = xfs_rtalloc_query_range(mp, tp, &low, &high,
+		error = xfs_rtalloc_query_range(mp, tp, low, high,
 				xfs_trim_gather_rtextent, &tr);
 
 		if (error == -ECANCELED)
@@ -615,8 +614,8 @@ xfs_trim_rtdev_extents(
 		if (error)
 			break;
 
-		low.ar_startext = tr.restart_rtx;
-	} while (!xfs_trim_should_stop() && low.ar_startext <= high.ar_startext);
+		low = tr.restart_rtx;
+	} while (!xfs_trim_should_stop() && low <= high);
 
 	xfs_trans_cancel(tp);
 	return error;
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 71f32354944e4..e154466268757 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -520,11 +520,11 @@ xfs_getfsmap_rtdev_rtbitmap(
 	struct xfs_getfsmap_info	*info)
 {
 
-	struct xfs_rtalloc_rec		alow = { 0 };
 	struct xfs_rtalloc_rec		ahigh = { 0 };
 	struct xfs_mount		*mp = tp->t_mountp;
 	xfs_rtblock_t			start_rtb;
 	xfs_rtblock_t			end_rtb;
+	xfs_rtxnum_t			high;
 	uint64_t			eofs;
 	int				error;
 
@@ -553,10 +553,9 @@ xfs_getfsmap_rtdev_rtbitmap(
 	 * Set up query parameters to return free rtextents covering the range
 	 * we want.
 	 */
-	alow.ar_startext = xfs_rtb_to_rtx(mp, start_rtb);
-	ahigh.ar_startext = xfs_rtb_to_rtxup(mp, end_rtb);
-	error = xfs_rtalloc_query_range(mp, tp, &alow, &ahigh,
-			xfs_getfsmap_rtdev_rtbitmap_helper, info);
+	high = xfs_rtb_to_rtxup(mp, end_rtb);
+	error = xfs_rtalloc_query_range(mp, tp, xfs_rtb_to_rtx(mp, start_rtb),
+			high, xfs_getfsmap_rtdev_rtbitmap_helper, info);
 	if (error)
 		goto err;
 
@@ -565,7 +564,7 @@ xfs_getfsmap_rtdev_rtbitmap(
 	 * rmap starting at the block after the end of the query range.
 	 */
 	info->last = true;
-	ahigh.ar_startext = min(mp->m_sb.sb_rextents, ahigh.ar_startext);
+	ahigh.ar_startext = min(mp->m_sb.sb_rextents, high);
 
 	error = xfs_getfsmap_rtdev_rtbitmap_helper(mp, tp, &ahigh, info);
 	if (error)

