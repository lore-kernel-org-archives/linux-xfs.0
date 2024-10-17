Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B54C1E0DC3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192064; cv=none; b=dpq3rGCq3Lwbw/H1H18pGxeIo641DjH7ESIXYlKxP5upEvil1uP/ltDGyOy7wQ7uuY/CIRUcHKMEUFdWlee4uye+iU0pfMMBZ4c34chtjJxEWy3H7Dzoo8LalX8eA9X2G+G0UVofP4WB1PxxcB8iTvr4I61rlw87ardaKNpLziU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192064; c=relaxed/simple;
	bh=sBGTL4capdNvkgP0r6UhUrGeeT4atfbQYmpU6MoLZnI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uz+lD53nTG/twPc5wgTZih4FuNkbhnnARegKzPTRq/dYqPtVP10am5SD1DwmvdVIpdHG5VvudyDSJutyP71xUzgbBvIqMo0fGVVmmwYSAEnAQRm6YSFIfy8b2UL0oqGBVMFtfP6c9ct1RQifLDurNi1nq6QvO0I8QOi24NnfPNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWH/1CX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWH/1CX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0884AC4CECE;
	Thu, 17 Oct 2024 19:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192064;
	bh=sBGTL4capdNvkgP0r6UhUrGeeT4atfbQYmpU6MoLZnI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nWH/1CX+qqlUQd3jZnY3bSbJKxwezXhj8KqdcVBFrYT4WebrQDEYXXP6BWK6adaqL
	 82jXLDtFYFULK0HeErUoRO7XeUPW1iU3Ct3Uaoyqkkw70Lub57zflW7Bun9Z0M9ZF3
	 FQqM/9NLgbCE6MCcxw1AZsLRcVlcw+UKK2SyjPxFSk/8QkPh43yaQzVcCsc2j9y6ae
	 GYAfq5uhiB5mOJU/D2aSTWeyOzzsOTQb0xiWjAoPwew/kST8Cwq1dxvScbTj+WGAGg
	 JYU3YlkUIB/1PS3xyNthZCIRuvxhXyu5vVYXpRnlyBAlaKPC3eSA+DJgTH4Z43wJ6J
	 lZPTGfM7Etvyw==
Date: Thu, 17 Oct 2024 12:07:43 -0700
Subject: [PATCH 22/34] xfs: don't coalesce file mappings that cross rtgroup
 boundaries in scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919072048.3453179.5756327403798892475.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
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

