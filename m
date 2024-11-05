Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900431FBCB5
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846138; cv=none; b=mCOz8dtEaoPh7a8RYWfKhNGBgSAqciP8PGjcWlciLtMgHwqOAGOyK1aypFceTNzhMCc2J9h5SYWV9xahw4Nnf7PCyu8AdY8DcXTGR4WidOJK95hhIQmyCFeKqwxiFLTl2JGJzRCGxxnVlVm1ACx7LZ2DtBMJJ93Y2GYMZt2i9t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846138; c=relaxed/simple;
	bh=sBGTL4capdNvkgP0r6UhUrGeeT4atfbQYmpU6MoLZnI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZBD+Wlotxj/0i8mxfHW2nhdP6+4G/udwZSvwHA0Ld9715ncPd7HvdalfQb9uYh/hFz4E1b61P23FlT8gtE0RvfIuu6p9GMsJBv7yzjHDlsmaY9MZRZwxQnLRWpXIBoeNE7Dr6XrRMjAVxxEspCygNwYOVfEANJGMkHKnNrmZmXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ksL0Yoil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ksL0Yoil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59316C4CECF;
	Tue,  5 Nov 2024 22:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846138;
	bh=sBGTL4capdNvkgP0r6UhUrGeeT4atfbQYmpU6MoLZnI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ksL0YoilFdLMuvdVtVZ25Tg9puvaFfnITxj+fqyjR2knNSUpXAYtTRO/GAfnvavt3
	 uUA3HlYq0m1PcCUrS3/MohYk9QPSKgh17Q8ru4CA5VICUd6touvvB7zvHiROVoInO3
	 LY+TR75r0sqcNuxa3VJRnX7I5mGQWj1XnioLHdBzUJ0mEvQ5n05doYqvAU3OCeRBO6
	 EZnhrUZkm/00zDzj7vWHvOPp7HfDcoi/cVNZm+QzqGmjI1v43up0AOYVbc0QSitRMG
	 PzTlLp9+5J3C0aWwnqbNfrvGzZ5XrcV5vTy7J4M8lmfsxHatdT03tkYr3LzhIysU64
	 02KH7XF+O7azw==
Date: Tue, 05 Nov 2024 14:35:37 -0800
Subject: [PATCH 22/34] xfs: don't coalesce file mappings that cross rtgroup
 boundaries in scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398561.1871887.4133474986394058893.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The bmbt scrubber will combine file mappings if they are mergeable to
reduce the number of cross-referencing checks.  However, we shouldn't
combine mappings that cross rt group boundaries because that will cause
verifiers to trip incorrectly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/bmap.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 008630b2b75263..7e00312225ed10 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -834,9 +834,12 @@ xchk_bmap_iext_mapping(
 /* Are these two mappings contiguous with each other? */
 static inline bool
 xchk_are_bmaps_contiguous(
+	const struct xchk_bmap_info	*info,
 	const struct xfs_bmbt_irec	*b1,
 	const struct xfs_bmbt_irec	*b2)
 {
+	struct xfs_mount		*mp = info->sc->mp;
+
 	/* Don't try to combine unallocated mappings. */
 	if (!xfs_bmap_is_real_extent(b1))
 		return false;
@@ -850,6 +853,17 @@ xchk_are_bmaps_contiguous(
 		return false;
 	if (b1->br_state != b2->br_state)
 		return false;
+
+	/*
+	 * Don't combine bmaps that would cross rtgroup boundaries.  This is a
+	 * valid state, but if combined they will fail rtb extent checks.
+	 */
+	if (info->is_rt && xfs_has_rtgroups(mp)) {
+		if (xfs_rtb_to_rgno(mp, b1->br_startblock) !=
+		    xfs_rtb_to_rgno(mp, b2->br_startblock))
+			return false;
+	}
+
 	return true;
 }
 
@@ -887,7 +901,7 @@ xchk_bmap_iext_iter(
 	 * that we just read, if possible.
 	 */
 	while (xfs_iext_peek_next_extent(ifp, &info->icur, &got)) {
-		if (!xchk_are_bmaps_contiguous(irec, &got))
+		if (!xchk_are_bmaps_contiguous(info, irec, &got))
 			break;
 
 		if (!xchk_bmap_iext_mapping(info, &got)) {

