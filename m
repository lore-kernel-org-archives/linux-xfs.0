Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14790171A5
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372377; cv=none; b=NyY52kOP+zJXU4CDi4CzFhITHDPf4kQ0MPxaUVXtzEUv+umyXBMIVRAcCQWzN+MGpf3qQJFJMTA8/HSs3ADj4MLC/GVOd0oMCVNHfaHFJA01PrG40w5Dh57xynAcegn3V4CARYtTOtT3/QkaQK90CiQi7bFiYTCQW1NfKClETfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372377; c=relaxed/simple;
	bh=YAmBgkVlvNct18O0EZGpoKDvL9YusFpvfoPxlEAU9ko=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kI+zbbY/QdeN+Is8Oj7GPLBpAl8r/3ryxdOekRUnJwMZ7pE1gDExHXzizC0O/8GDbfdvLFHkVkxRkfjSP6k0e3SbXUzdJtU32NOF//O3Klh7miBMS4pzktBw+qDkeJQxurBz5+4caOxWB30MseM1v5IDOzAhHFJFG9MxyEkZMDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aVcjqRhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aVcjqRhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54D2C32782;
	Fri, 23 Aug 2024 00:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372377;
	bh=YAmBgkVlvNct18O0EZGpoKDvL9YusFpvfoPxlEAU9ko=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aVcjqRhhxPUOlcXEDPkDQTbMxpAlZKPqwhTsPgMUK6zs9Q1cetdFG8D8qidpTH+QE
	 JPgqyDUQVL3fC2zQZstfVX4Cxju/JZmWshds9I4sfrRkKdEgAnB6nj8qOlm1HTYTzM
	 EcGHXHhWqAMy+lzVZLf5XJ099oBz5BOYtGHEnqQABHZ/yynpDnKa4/H4c4zHbmcnfn
	 9zVLlfHFXgoqLTGMdI2dlY+Qc1IJ8bCSexiUXuMJHWwa3xIEmRC3W1rF2SkQqfQTKJ
	 hKn6RHZFgJGB/2vterYEUycCJLDu5AMDbw2722ADlTffkZ9XWTUZsBiCj+LclOpz9y
	 fNuVebmENOc6A==
Date: Thu, 22 Aug 2024 17:19:36 -0700
Subject: [PATCH 19/24] xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087576.59588.17128388413774079852.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
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

Split the code to set up a fake mount point to calculate new RT
geometry out of xfs_growfs_rt_bmblock so that it can be reused.

Note that this changes the rmblocks calculation method to be based
on the passed in rblocks and extsize and not the explicitly passed
one, but both methods will always lead to the same result.  The new
version just does a little bit more math while being more general.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   52 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 2a694ad8ead2c..71e650b6c4253 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -734,6 +734,36 @@ xfs_rtginode_ensure(
 	return xfs_rtginode_create(rtg, type, true);
 }
 
+static struct xfs_mount *
+xfs_growfs_rt_alloc_fake_mount(
+	const struct xfs_mount	*mp,
+	xfs_rfsblock_t		rblocks,
+	xfs_agblock_t		rextsize)
+{
+	struct xfs_mount	*nmp;
+
+	nmp = kmemdup(mp, sizeof(*mp), GFP_KERNEL);
+	if (!nmp)
+		return NULL;
+	nmp->m_sb.sb_rextsize = rextsize;
+	xfs_mount_sb_set_rextsize(nmp, &nmp->m_sb);
+	nmp->m_sb.sb_rblocks = rblocks;
+	nmp->m_sb.sb_rextents = xfs_rtb_to_rtx(nmp, nmp->m_sb.sb_rblocks);
+	nmp->m_sb.sb_rbmblocks = xfs_rtbitmap_blockcount(nmp,
+			nmp->m_sb.sb_rextents);
+	nmp->m_sb.sb_rextslog = xfs_compute_rextslog(nmp->m_sb.sb_rextents);
+	nmp->m_rsumlevels = nmp->m_sb.sb_rextslog + 1;
+	nmp->m_rsumblocks = xfs_rtsummary_blockcount(nmp, nmp->m_rsumlevels,
+			nmp->m_sb.sb_rbmblocks);
+
+	if (rblocks > 0)
+		nmp->m_features |= XFS_FEAT_REALTIME;
+
+	/* recompute growfsrt reservation from new rsumsize */
+	xfs_trans_resv_calc(nmp, &nmp->m_resv);
+	return nmp;
+}
+
 static int
 xfs_growfs_rt_bmblock(
 	struct xfs_rtgroup	*rtg,
@@ -756,25 +786,15 @@ xfs_growfs_rt_bmblock(
 	xfs_rtbxlen_t		freed_rtx;
 	int			error;
 
-
-	nrblocks_step = (bmbno + 1) * NBBY * mp->m_sb.sb_blocksize * rextsize;
-
-	nmp = nargs.mp = kmemdup(mp, sizeof(*mp), GFP_KERNEL);
-	if (!nmp)
-		return -ENOMEM;
-
 	/*
 	 * Calculate new sb and mount fields for this round.
 	 */
-	nmp->m_sb.sb_rextsize = rextsize;
-	xfs_mount_sb_set_rextsize(nmp, &nmp->m_sb);
-	nmp->m_sb.sb_rbmblocks = bmbno + 1;
-	nmp->m_sb.sb_rblocks = min(nrblocks, nrblocks_step);
-	nmp->m_sb.sb_rextents = xfs_rtb_to_rtx(nmp, nmp->m_sb.sb_rblocks);
-	nmp->m_sb.sb_rextslog = xfs_compute_rextslog(nmp->m_sb.sb_rextents);
-	nmp->m_rsumlevels = nmp->m_sb.sb_rextslog + 1;
-	nmp->m_rsumblocks = xfs_rtsummary_blockcount(mp, nmp->m_rsumlevels,
-			nmp->m_sb.sb_rbmblocks);
+	nrblocks_step = (bmbno + 1) * NBBY * mp->m_sb.sb_blocksize * rextsize;
+	nmp = nargs.mp = xfs_growfs_rt_alloc_fake_mount(mp,
+			min(nrblocks, nrblocks_step), rextsize);
+	if (!nmp)
+		return -ENOMEM;
+
 	rtg->rtg_extents = xfs_rtgroup_extents(nmp, rtg->rtg_rgno);
 
 	/*

