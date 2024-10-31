Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A210F19F430
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416372; cv=none; b=onGpz9eh1pf3sDjqOaCUI0+61ZhVrJD/7yc2m/x8q5e6ANdZQgo9xDH+ssOPSt7YiKuC5BLdt3bNbK2CRLJ1C6fkoDXm0mr1KkQmTP+PDWfWXbvImtMuRmIZRFkuICLpp007aJd/R5oGdUw4yOjt4vAMIYskSq151xzumpobE60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416372; c=relaxed/simple;
	bh=aDphQeYyK23f/42cdKznjfHvSdtjC+v4pkbxc5/PtP0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rq06wePhUeiZNEzLCRjXybTo94Db01rayqxBlT9IossAZXZHxeYJS3r1Hlofjx5ksZRITOu1HwKGQDgXy/JrT8dA50oSEo8zfZQmkIzU49rxldDbiFadMHL2FGSeDTvNPraUBH9TzH1uFe8qZiDf0A+iCWsq0pdw8d/2R7Tldew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cdpBONI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cdpBONI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF10C4CEC3;
	Thu, 31 Oct 2024 23:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416372;
	bh=aDphQeYyK23f/42cdKznjfHvSdtjC+v4pkbxc5/PtP0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cdpBONI11XbD+IyNvreOkVHtuqcwCdij/OAqLB5N+4DG8EKgzf8Dg3fwJH7CyXd8I
	 sH6eaSZjJgvJhywR/1cJRdZGsRoGLrINXRwhgToA9EggVwjw+THxf90jS9BAtRQdQV
	 wfpReJ3VNmh6yy1sy8/U0pR/ot94JPrnuVGhaJW1FfZLLOVDk2Z8G7DT/BbRXFzhXo
	 W98ASyBDt4R8qaw9Rgn9Gd5xTqEsKcuCxXaH8AIoBEXHvhTTvpUm3GwVGbF4jKVASy
	 wknbvWcnaIfYHwjo7XdHpz7BqDePyFQpBNIR1CnYr92zUVVbgQ/qRq2ePVUPYwKg1j
	 oZNEtDYkEKQRw==
Date: Thu, 31 Oct 2024 16:12:52 -0700
Subject: [PATCH 16/41] xfs: simplify xfs_rtalloc_query_range
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566163.962545.16668768520023131640.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
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

