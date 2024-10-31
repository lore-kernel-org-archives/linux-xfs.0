Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471BD1CC8B7
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416828; cv=none; b=k5l0y84xN3Sfxk8QPrZWJxdSCMdW/Dvko85eA4UFhmvYTCubMdirP9I0/Q36U3RE9FSKR9gDVupHcQgH46wHz7soiqhtF1VKqIYO/g5m1jH9lfUC4wMCOvYNFOCcwCZ09mYDYuiaBUU2NbNc0Q4+p8JstyoobtbFbnmCpfxuBzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416828; c=relaxed/simple;
	bh=UWu5lIBkkewIAqf8qTbdU8tp2O/NQsZAjTIN6focLbI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=syOymFDyAgW2eDN89LMvgSjTX1wYWgawjf71pVgiXIgeaZw7SdnwwPEhG29Rg6Szf3qJlMu67w8Y2jLnFyJ8v+F4CM1TrdX9vspDXT/CikAx61u7WODOqip3oJZkfLgFh3oL6rlv6+5gQOdN1qhD7LI9GhOpkvvNz9wUWDsAZfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jKfk54kC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jKfk54kC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4277C4CEC3;
	Thu, 31 Oct 2024 23:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416825;
	bh=UWu5lIBkkewIAqf8qTbdU8tp2O/NQsZAjTIN6focLbI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jKfk54kCOb/av9DkzUPmPHEr8n+vqB3G3CED65Z9NQMphTHVPGBm8Fnugd+7DxMWc
	 79/INx4QG1cxIrCJwwLIdGuEHjYMNTBs9dSFZb0gMG9Ox7JmUdxsfbstnrS2q2+tVz
	 FR8Nft1Ci9upf/Z7oO8gHdhvi6LV6RmztHeoJQMkItcvlG43wQsnxuGQqwuuXsoIb0
	 aXZVJIVK2PafWkQNRbSmRzdhEQCJlDc53pfCbJJwieT5S2bgUHuvOyIkTPIc9EcN4a
	 dDRcGlQRDVoGZIykIVBOV8kqwmygFBO6ezcdAddSHDLbk8I/o2kedEK2DiT7ifrzL/
	 TYSstXR48yWaA==
Date: Thu, 31 Oct 2024 16:20:25 -0700
Subject: [PATCH 4/7] libxfs: validate inumber in xfs_iget
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566967.963918.4965622256532633715.stgit@frogsfrogsfrogs>
In-Reply-To: <173041566899.963918.1566223803606797457.stgit@frogsfrogsfrogs>
References: <173041566899.963918.1566223803606797457.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Actually use the inumber validator to check the argument passed in here,
just like we now do in the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index 2062ecf54486cf..9230ad24a5cb6c 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -143,7 +143,7 @@ libxfs_iget(
 	int			error = 0;
 
 	/* reject inode numbers outside existing AGs */
-	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
+	if (!xfs_verify_ino(mp, ino))
 		return -EINVAL;
 
 	ip = kmem_cache_zalloc(xfs_inode_cache, 0);

