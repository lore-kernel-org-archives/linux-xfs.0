Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3567171A5
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372393; cv=none; b=aikq3vfZaqzFbXnf9lr7J6kbKsTy54Yekn2RnCtLx0s+Ujm36tddNMJ2Hz2v8HGmYAYAR63fIXehX+5/mklzuf18+tiw6nJZx53/AUfl0sSrYVkY46bq45C+TyNbKzoSH8TuOJd1SyTTiywz0VfhtnZyyZn2eUURSsUlqudWhjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372393; c=relaxed/simple;
	bh=Oz1JfcgfD0qamXeNbpkwNpkRxlMbXxil0MX88dWWpCQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SPU6ZaqsPXEI62jbsfZVNzgRdziFizTa9/WRDhsYOJsVVLbXum3fw+8fGNBxBcTuCvUvGFhQJGh0fMShirZQxrlNu+b9iEXkNwNexWaplbQiIHuTFTu1aD0B3qQwTS0PB9O4imUxDUpyzwMFH+wdZQlkB5CZDH5m+7EAaqPnpcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RLow2123; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RLow2123"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED7DC32782;
	Fri, 23 Aug 2024 00:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372392;
	bh=Oz1JfcgfD0qamXeNbpkwNpkRxlMbXxil0MX88dWWpCQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RLow2123Wv+FQSyqJBA+3pK3JVp+SYPUWcUJ2RqqAZFtGplvGuc3HYIN5oqDDQi8k
	 yhNukAzB3FnJs1sIvZ8XhZCRF3u3bDAhVHwFF4VtMOTkcDlxvB7NbBAW+HmT8J5iEK
	 /uX29bHdV+DORpvQyFimckOBpnrRv26+/74k1Hh23xuXpypUE89FXgPv7e5XVBV2Ae
	 paY4ZHll44BYfRP7C0aEzIFyNoEOIXZW+m2puaGFrEdX4I0mmYee8yXx2/GvIiHB0y
	 ndUeRLSMFURYI0LzUMmJ7690tqyWVR4GMRPYxaaahla4oHvDHI/evx9cUlOmZAlvU0
	 mVRzeRFKOfXwA==
Date: Thu, 22 Aug 2024 17:19:52 -0700
Subject: [PATCH 20/24] xfs: use xfs_growfs_rt_alloc_fake_mount in
 xfs_growfs_rt_alloc_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087593.59588.3393693654050943333.stgit@frogsfrogsfrogs>
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

Use xfs_growfs_rt_alloc_fake_mount instead of manually recalculating
the RT bitmap geometry.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 71e650b6c4253..61231b1dc4b79 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -935,10 +935,10 @@ xfs_growfs_rt_alloc_blocks(
 	struct xfs_mount	*mp = rtg->rtg_mount;
 	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
 	struct xfs_inode	*rsumip = rtg->rtg_inodes[XFS_RTGI_SUMMARY];
-	xfs_rtxnum_t		nrextents = div_u64(nrblocks, rextsize);
 	xfs_extlen_t		orbmblocks;
 	xfs_extlen_t		orsumblocks;
 	xfs_extlen_t		nrsumblocks;
+	struct xfs_mount	*nmp;
 	int			error;
 
 	/*
@@ -948,9 +948,13 @@ xfs_growfs_rt_alloc_blocks(
 	orbmblocks = XFS_B_TO_FSB(mp, rbmip->i_disk_size);
 	orsumblocks = XFS_B_TO_FSB(mp, rsumip->i_disk_size);
 
-	*nrbmblocks = xfs_rtbitmap_blockcount(mp, nrextents);
-	nrsumblocks = xfs_rtsummary_blockcount(mp,
-		xfs_compute_rextslog(nrextents) + 1, *nrbmblocks);
+	nmp = xfs_growfs_rt_alloc_fake_mount(mp, nrblocks, rextsize);
+	if (!nmp)
+		return -ENOMEM;
+
+	*nrbmblocks = nmp->m_sb.sb_rbmblocks;
+	nrsumblocks = nmp->m_rsumblocks;
+	kfree(nmp);
 
 	error = xfs_rtfile_initialize_blocks(rtg, XFS_RTGI_BITMAP, orbmblocks,
 			*nrbmblocks, NULL);

