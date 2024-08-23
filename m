Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F346510953
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372815; cv=none; b=bxM5SdZdWIT8rFZldsjly99tk8qY5J3wdhfjZqT/aWsGb3VUHGLy4jzDKoVS30yA4RN8YI/Rec3r84FP3H94a4zoNLmEDtwmd1564jrw4QSfT1r04+twqHU6+0yQ0rtCrAd6fqqacxcKnhMgzL8vjIPHoJbMKZWJI6OQ1LLyZgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372815; c=relaxed/simple;
	bh=3AodzdkziR/nTy8DYtNJjSyJ3Q3clWq83O7HRit6Qyo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TXf32BHyEJIZ6RysDhuM0U5JAv1wzBz9+9W3K+b9HwvjD7WIziOeBI4WgTKoJOMS+vjTOsr6gwan5u0grAtmC5xg8mUARiGDfi7ZiQLDyNfmm1WnnHyO3iCmyeg0HKib4R0JKruoCCXc3AM6ChLelGB85w+1C4woiQ7Hmprb38A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojO6hxO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojO6hxO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD433C32782;
	Fri, 23 Aug 2024 00:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372814;
	bh=3AodzdkziR/nTy8DYtNJjSyJ3Q3clWq83O7HRit6Qyo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ojO6hxO17lMv3zQBqknlH1pDg7xQ+G76y2yeU8CGBHRcWb0KZ07ixP6BW724qvXed
	 lg7/0CcTYTTirjmVbRTf/e/cuszEK/Bb3a0dsrc23Jk+a3JO7U6/8YzLf6HisF84zP
	 KM/aLXL3n/QcAaWgEg2xGXYLz7dkbb4DYadhWZNeGCFowbsCyabkF7VsoYnTCQEVPh
	 sy2xBbhMcvBbzJFI7ut3CQChlMr6hJuxI8SrrtKrWtjvnpLqaf0z7WkYmQbkc66XfG
	 UOWO4uqSc2o0Jy/8fJz4vdu97eoeTStAx4aazWF6SwZwXkH7YlIpNHgB6gR6BmTQjd
	 xBfGwJQuxPCKQ==
Date: Thu, 22 Aug 2024 17:26:54 -0700
Subject: [PATCH 22/26] xfs: don't coalesce file mappings that cross rtgroup
 boundaries in scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088904.60592.6390649383741617327.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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
---
 fs/xfs/scrub/bmap.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 69dac1bd6a83e..173c371e822f5 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -835,9 +835,12 @@ xchk_bmap_iext_mapping(
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
@@ -851,6 +854,17 @@ xchk_are_bmaps_contiguous(
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
 
@@ -888,7 +902,7 @@ xchk_bmap_iext_iter(
 	 * that we just read, if possible.
 	 */
 	while (xfs_iext_peek_next_extent(ifp, &info->icur, &got)) {
-		if (!xchk_are_bmaps_contiguous(irec, &got))
+		if (!xchk_are_bmaps_contiguous(info, irec, &got))
 			break;
 
 		if (!xchk_bmap_iext_mapping(info, &got)) {

