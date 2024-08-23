Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A14C800
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371783; cv=none; b=aocjNaAk4gHW1PUXmnH+mGviAJMwwnztiuzmIP71dpZs1L99irrFMCpje8lP54XSs6pUkCVFn2FXCV9VVnZ+6iXOsMmvTvR3AXxWefdGdf43tAcOSJ9O1jSAkzhHAPoHBZHOPE/VsMvN9K8p5SlJVwmitGaWhYpnZ0WEqAsVkbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371783; c=relaxed/simple;
	bh=GZqnQmoUmCB+iuKBdKWgvaKjgd7BjOjQVqOLsztmxe0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wg50bcR2Z1jW7xsOGSP1tPAEPx2f4l55DpBa/4IdK36QD48e/S8O+qBdRnxNZxpxDyYOdyIAclMUsMY/yr2F4XP+sf1lRbR9o4ckzQV2JNPPpWUM+xBgfX59RzXQB8SIByrCJ4F4BqfidfV7NgaRRDlmc6RtOIDiiYg9+KZBkOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPGuNbd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPGuNbd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47753C32782;
	Fri, 23 Aug 2024 00:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371783;
	bh=GZqnQmoUmCB+iuKBdKWgvaKjgd7BjOjQVqOLsztmxe0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mPGuNbd80m02a18hfFim0iTYBFPVbgOy2tPAWWC/QPis6lpPir2T03XPUwJz+eDyU
	 oHUy5CUgbfM42N61p0VXCHjPEqGVIBqq5GB7nzfFTtAwBIX79KBG3CaoYDUzdGldTN
	 ftK6hNulurTcRhA/d0cpw5YbrGZnuHDInASYOpo2D9gVZLWmRV/dh+wTTrP6Ucin/V
	 5iZprNLcT5p+/d8B9u1iCc2nvJyPtFJAxbID33gqOC/kEZyls76GN8wWvz7HMmRpFq
	 ltq2F905aCBgysvLXRra1Gd6x9wwie0n3Nsj3iLFcs1SBzlEweZVeudA8SNdM5bSAr
	 WOyVYlrMuUJ+w==
Date: Thu, 22 Aug 2024 17:09:42 -0700
Subject: [PATCH 03/12] xfs: make the RT rsum_cache mandatory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086070.58604.6724403084646621017.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
References: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
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

Currently the RT mount code simply ignores an allocation failure for the
rsum_cache.  The code mostly works fine with it, but not having it leads
to nasty corner cases in the growfs code that we don't really handle
well.  Switch to failing the mount if we can't allocate the memory, the
file system would not exactly be useful in such a constrained environment
to start with.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 2acb75336b7b9..f5a39cfd9bcb8 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -769,21 +769,20 @@ xfs_growfs_rt_alloc(
 	return error;
 }
 
-static void
+static int
 xfs_alloc_rsum_cache(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_extlen_t	rbmblocks)	/* number of rt bitmap blocks */
+	struct xfs_mount	*mp,
+	xfs_extlen_t		rbmblocks)
 {
 	/*
 	 * The rsum cache is initialized to the maximum value, which is
 	 * trivially an upper bound on the maximum level with any free extents.
-	 * We can continue without the cache if it couldn't be allocated.
 	 */
 	mp->m_rsum_cache = kvmalloc(rbmblocks, GFP_KERNEL);
-	if (mp->m_rsum_cache)
-		memset(mp->m_rsum_cache, -1, rbmblocks);
-	else
-		xfs_warn(mp, "could not allocate realtime summary cache");
+	if (!mp->m_rsum_cache)
+		return -ENOMEM;
+	memset(mp->m_rsum_cache, -1, rbmblocks);
+	return 0;
 }
 
 /*
@@ -941,8 +940,11 @@ xfs_growfs_rt(
 		goto out_unlock;
 
 	rsum_cache = mp->m_rsum_cache;
-	if (nrbmblocks != sbp->sb_rbmblocks)
-		xfs_alloc_rsum_cache(mp, nrbmblocks);
+	if (nrbmblocks != sbp->sb_rbmblocks) {
+		error = xfs_alloc_rsum_cache(mp, nrbmblocks);
+		if (error)
+			goto out_unlock;
+	}
 
 	/*
 	 * Allocate a new (fake) mount/sb.
@@ -1271,7 +1273,9 @@ xfs_rtmount_inodes(
 	if (error)
 		goto out_rele_summary;
 
-	xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
+	error = xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
+	if (error)
+		goto out_rele_summary;
 	xfs_trans_cancel(tp);
 	return 0;
 

