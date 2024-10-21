Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C7F19581F
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548187; cv=none; b=OqDYW0KsnM6phLkbfAN0DtSy0AndPv67YjzfK0Dys9p0BNxwsZcEa7BKDkErszCfQvmWsG6v+G3XIHK1ReuAVmIgxS2HpV0SQKxjLqKKbQVI3TnCUdv++kX18/9u2DyVvNFsp3q8cZV4FUK2gariub79LoXr516blW0PmXN2rHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548187; c=relaxed/simple;
	bh=aDphQeYyK23f/42cdKznjfHvSdtjC+v4pkbxc5/PtP0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DfHRcdWMaO0DcYVM9FNtt+GLt5EOZoUtIl05CmkofM8jYIyRJCQg4z0AuvoeyOsjZlqbPPekIRN4lDUF0MO54Jd09NaMI38phSsNZt1qehCYg4qza/76BRdrcETXCJ4ABYNqkVVCj+hS0ozmNh3Tw3HV5HxCmFMMeJ1LxfJVgOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDivApYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDivApYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F705C4CEC3;
	Mon, 21 Oct 2024 22:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548186;
	bh=aDphQeYyK23f/42cdKznjfHvSdtjC+v4pkbxc5/PtP0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EDivApYxLuaYt1k08LnsMfTxAwLAudjW4a6XVpK3qpN7qerbolAwG/HYDd7+htmz8
	 N18EU6Y3GgTbX0l1MpKMdbUjg1HUhj+EkcBBs70vpQ+DuwTZXg5WPpfFzdbzms7yPH
	 /wNr5o8fYD+KagNuasdc9b8NXHAW4byuaIwrIhdVqKFjuFG+nHeG77Ukcd9p+CBXex
	 93j/1w/9pgSXquUHnLDB63QAxeTia2fPWdQ/CS11P19FXKmxwRMEWD9MJvGGhI73sV
	 e+ALquwyKKbX1+FD5Yu7yeGIM/DNYmPE1l3+n1Tn8SQTtkwt9VYvWuw9DsCM+3VNtf
	 f6k+hmVTEQwNA==
Date: Mon, 21 Oct 2024 15:03:06 -0700
Subject: [PATCH 16/37] xfs: simplify xfs_rtalloc_query_range
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783713.34558.17245720172191250363.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: df8b181f1551581e96076a653cdca43468093c0f

There isn't much of a good reason to pass the xfs_rtalloc_rec structures
that describe extents to xfs_rtalloc_query_range as we really just want
a lower and upper bound xfs_rtxnum_t.  Pass the rtxnum directly and
simply the interface.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtbitmap.c |   42 +++++++++++++++++-------------------------
 libxfs/xfs_rtbitmap.h |    3 +--
 2 files changed, 18 insertions(+), 27 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 74029d4431e1ca..3f534a4724a26b 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1045,8 +1045,8 @@ int
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
@@ -1054,45 +1054,42 @@ xfs_rtalloc_query_range(
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
@@ -1107,13 +1104,8 @@ xfs_rtalloc_query_all(
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
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 69ddacd4b01e6f..0dbc9bb40668a2 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
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

