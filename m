Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6981990BA
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637424; cv=none; b=krdd2uixMpE++23jDLtyjuR/5hrZSiapR4fGfmTDQ2jVVJK/ooYCur6L3ubBq5SDjwZ8+WaUt8eB+DFjIsVklaYy4w/jmu2OLS+Pn9XqA7pZg7wIdftpK2vchUfcrRTVDL6v1cplnsNCs0SP13HrbozI+GRUfulc5DWIseVr7wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637424; c=relaxed/simple;
	bh=mW4i29yb2BnpL8CGSPV1NoxbmzQce5kgH58agdHxmFs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HyyzgIJsCCP3Cvmr9mcDFfNeFP7XBle2JrpTKlPIVU4zSCOrOY1qfUyJ5ZfcUUGowqfdH1SfNRsvDuop7eEovWSO+s13ZeX8jTa9XkMI+ag+u9zzy6q0vNKLuy5E6pAcmm+WZ+D55L8XuLfe0y0IFJ1w1n1vqMmm8sv7pWl8A7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MkR6KoEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MkR6KoEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E62C4CECE;
	Thu, 19 Dec 2024 19:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637423;
	bh=mW4i29yb2BnpL8CGSPV1NoxbmzQce5kgH58agdHxmFs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MkR6KoEg5SM3CgEBMI4N8gvOTp7Nd6bOgna6KkuVIF5kWfoMLyw3ch6n1t5J83Uau
	 KWa4eWXdO1iVnJqlGREpDY5sVo6+I7Ejm8X7duC2QOWKjmj+mmdr/YXu8dhVx9Qj0+
	 3ZUjsse64NDWRQD6hS2L/oa+VdWB9GWNImdBOcpvwEobAnDSusr9imspkt9MYf5qRg
	 uFrPzEkLGpeFYnIY1/lMVAh7B9cnRreVH3HLcXKxSYRYKhP6FKYFQJjITh8/vNcSdv
	 +k9XjcPdjWyZOzDxsWZOyqVf8SR7m7dvIwM4aJYVvE0oKwa3Zq1EvxYI4H5PuZYgtx
	 HCP8TONhWlAzg==
Date: Thu, 19 Dec 2024 11:43:42 -0800
Subject: [PATCH 41/43] xfs: check for shared rt extents when rebuilding rt
 file's data fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581679.1572761.14901019904343071334.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're rebuilding the data fork of a realtime file, we need to
cross-reference each mapping with the rt refcount btree to ensure that
the reflink flag is set if there are any shared extents found.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/bmap_repair.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index fd64bdf4e13887..1084213b8e9b88 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -101,14 +101,21 @@ xrep_bmap_discover_shared(
 	xfs_filblks_t		blockcount)
 {
 	struct xfs_scrub	*sc = rb->sc;
+	struct xfs_btree_cur	*cur;
 	xfs_agblock_t		agbno;
 	xfs_agblock_t		fbno;
 	xfs_extlen_t		flen;
 	int			error;
 
-	agbno = XFS_FSB_TO_AGBNO(sc->mp, startblock);
-	error = xfs_refcount_find_shared(sc->sa.refc_cur, agbno, blockcount,
-			&fbno, &flen, false);
+	if (XFS_IS_REALTIME_INODE(sc->ip)) {
+		agbno = xfs_rtb_to_rgbno(sc->mp, startblock);
+		cur = sc->sr.refc_cur;
+	} else {
+		agbno = XFS_FSB_TO_AGBNO(sc->mp, startblock);
+		cur = sc->sa.refc_cur;
+	}
+	error = xfs_refcount_find_shared(cur, agbno, blockcount, &fbno, &flen,
+			false);
 	if (error)
 		return error;
 
@@ -450,7 +457,9 @@ xrep_bmap_scan_rtgroup(
 		return 0;
 
 	error = xrep_rtgroup_init(sc, rtg, &sc->sr,
-			XFS_RTGLOCK_RMAP | XFS_RTGLOCK_BITMAP_SHARED);
+			XFS_RTGLOCK_RMAP |
+			XFS_RTGLOCK_REFCOUNT |
+			XFS_RTGLOCK_BITMAP_SHARED);
 	if (error)
 		return error;
 
@@ -903,10 +912,6 @@ xrep_bmap_init_reflink_scan(
 	if (whichfork != XFS_DATA_FORK)
 		return RLS_IRRELEVANT;
 
-	/* cannot share realtime extents */
-	if (XFS_IS_REALTIME_INODE(sc->ip))
-		return RLS_IRRELEVANT;
-
 	return RLS_UNKNOWN;
 }
 

