Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0181319F430
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416232; cv=none; b=BkzMk1sF+Q/uc0QJ0EDbjmY2k9BNzNQ7vCJrO9StAf63KTGUbRtIrpuPzFwLIDDn5/RADeNF4wuI/PApYb3IAGBmqor9oLCC05NZZwBWPmrOIO4EkQwWu/r2mwUBFEqx8RdXOPMNS+StXUAGVa6UN47hid93IsJgK3qi150xELg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416232; c=relaxed/simple;
	bh=x/VHeZr1db/0cnjY3yrszpmQfhlEnFBp3ghbmgpQIAw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oXJBoude38NedrHjpv4iwxSa+VOqvwVKIXRBozHQdeifjt1t8QuXuQpl0esXzu/PGpramFwdn+z4rW6Fk1vkjHfkJ7UlnG795pMKs8r1D7wC8lxbPR1x2D5fxvkZbMxZWd9qqDRyUWxrB1sAh4/sazONwkJdnfVyUviiDMSQNfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bDIDq7ia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bDIDq7ia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C981CC4CEC3;
	Thu, 31 Oct 2024 23:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416231;
	bh=x/VHeZr1db/0cnjY3yrszpmQfhlEnFBp3ghbmgpQIAw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bDIDq7iaAKYeYHl1gKxx3bz2bp+QycpOozm1PTdtaHbbIxeXmgV8bCL1TBnKSE6aj
	 FPLXFWq8q4oXnJyd0/PS4EoUrlTMGD08qEOGzmAuA9pD8lJM2hq3MVTlQfZ4t8vE7T
	 0NXhKu8tsbet7pzYiDb65jQofJ8RZsspk5fr5yjTVIeOFN/xmIH5ThjUcP8Mmt6yxm
	 C4cyYwlRHIO/VRv6IyCV41ApeDwsx3DD4JxP8oYfhwGo1VD0dJl8xGSHnR7QB+kUJB
	 5QLPmp+XxJYxiWngNWXj6sBpLGSIlz/p9rja0vyPRxNbtd11Byn8tdZyP2l03vAtNH
	 FlmFevEMm6vpg==
Date: Thu, 31 Oct 2024 16:10:31 -0700
Subject: [PATCH 07/41] xfs: remove xfs_validate_rtextents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566027.962545.11315128066429511227.stgit@frogsfrogsfrogs>
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

