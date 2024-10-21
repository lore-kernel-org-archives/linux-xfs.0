Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97D11E1027
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548045; cv=none; b=h1VQeWXnBXdzv6MVzPTL4fsBPzN5JceKt8bLoe1qJADUJVcRZwb0N7+6VIVh+MmHR2Ffroem72omsEtR11fYOH8slh370LVo1rC3B0FwHMdytb2MCIzY90sekhrgWbKr9hwjkVVuaiSY2QkCx/YxMIm0EXfpJ9h+ex4hD79WC6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548045; c=relaxed/simple;
	bh=x/VHeZr1db/0cnjY3yrszpmQfhlEnFBp3ghbmgpQIAw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vx7VWdrGgbuDgphkMZOFXFau1fZwD+sA7cXH+5FffFepdQGdpKy29LYK/FtkgbCR60PNg8FPH5mwmHg7nLTZxtCkeVh4ER1l62N1sFSb7ycGUnc8AhI3lI/tktqyIuhfVAlFNBBq9P4EUx8vRadOeRPUxIobaTYTe8SyoVve+ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cngetNL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cngetNL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926E4C4CEC3;
	Mon, 21 Oct 2024 22:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548045;
	bh=x/VHeZr1db/0cnjY3yrszpmQfhlEnFBp3ghbmgpQIAw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cngetNL/NVYFknKHXbeE+J7ODml7kc36utmJjiASSJBBsWZarUoORdb7qieTLhjIX
	 MM1Ad3y1TqWHzMROXTrUch6wHjf3diaMM2X/dqleJQhyKwJTTqigNZubD9CMgUNHUQ
	 WdXzlOki4vXKzizvbGE/dy4k2v/ZIcDZq20/KgSavEGmy3qKLW0r/B9xD9AaYBm1qQ
	 k3PTkzxj7AS+Vjetif5Zr+2PNhZLA28E73yIrJXmfAcKoz8OwZ0U6Zx/oX1eX88vDF
	 BtK0iUnsAljrDYI8rTY7pHKktkEyc9+6HZgrldHeeK18Ag5ziZDPQgOR6onHLlPkjt
	 Rgc0JSr+ZaiJQ==
Date: Mon, 21 Oct 2024 15:00:45 -0700
Subject: [PATCH 07/37] xfs: remove xfs_validate_rtextents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783578.34558.6394842867679427215.stgit@frogsfrogsfrogs>
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

Source kernel commit: 021d9c107e29a598e51fb66a54b22e5416125408

Replace xfs_validate_rtextents with an open coded check for 0
rtextents.  The name for the function implies it does a lot more
than a zero check, which is more obvious when open coded.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_sb.c    |    2 +-
 libxfs/xfs_types.h |   12 ------------
 2 files changed, 1 insertion(+), 13 deletions(-)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index bedb36a0620dff..a50c9c06c3f19c 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -511,7 +511,7 @@ xfs_validate_sb_common(
 		rbmblocks = howmany_64(sbp->sb_rextents,
 				       NBBY * sbp->sb_blocksize);
 
-		if (!xfs_validate_rtextents(rexts) ||
+		if (sbp->sb_rextents == 0 ||
 		    sbp->sb_rextents != rexts ||
 		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
 		    sbp->sb_rbmblocks != rbmblocks) {
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 76eb9e328835f8..a8cd44d03ef648 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -235,16 +235,4 @@ bool xfs_verify_fileoff(struct xfs_mount *mp, xfs_fileoff_t off);
 bool xfs_verify_fileext(struct xfs_mount *mp, xfs_fileoff_t off,
 		xfs_fileoff_t len);
 
-/* Do we support an rt volume having this number of rtextents? */
-static inline bool
-xfs_validate_rtextents(
-	xfs_rtbxlen_t		rtextents)
-{
-	/* No runt rt volumes */
-	if (rtextents == 0)
-		return false;
-
-	return true;
-}
-
 #endif	/* __XFS_TYPES_H__ */

