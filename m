Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7BF21D640
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191767; cv=none; b=T+trXwJ+zaZXw9o38p1QujMsK/dU07TS3U1pDcUNfB3LMsuJWEZzJ/7H/KIcDLgpsNo65NSgZDeDeHoGzL5leGNDhRQAQLzIN4/BBQoozmO+wRW/DhJTSjzVi/sg7HIJ+8AJ1jix2yLVjBaNxtF/k4HbmEJAeL1XTs6GjNU4Jww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191767; c=relaxed/simple;
	bh=RU9dvPEJVMH4OFXNfijjUaLWhq//YOslkbZ1KiL0M70=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fmYU5v4K+HXFBlU6IgB8oNL2SPozbafZi+DKcZJPBQ0wR6iKTFJbjPpIv74uYMdkWP0NLT8G53etKPP2yjNar9JKvveOH1jzSqbLQgHq5f7gTfsz5vfF+LIgJC0cXRjcUhdxqBd2c0XQp/LgqVDoqCpCV1kscDl3HWaJOMxuTUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l0QvikPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l0QvikPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D948C4CEC3;
	Thu, 17 Oct 2024 19:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191767;
	bh=RU9dvPEJVMH4OFXNfijjUaLWhq//YOslkbZ1KiL0M70=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l0QvikPZiZ/nX0g6pCgKpTif255bznU1HNY/3kkFFJs8/TPkVpyaxu0tbXNqDpDRc
	 AieJ+5gk+m/yhB2Fg3J6BfUqrAWMFkoPz5l8emPQv0UsUJR/BL6eizDNImPu8wfFLh
	 wnx0/IJC8mtfpzS2uke8gctacIP3tncznbkQ0m5kM5lrzTb+WIHlKU7wm2/EFPCh0N
	 vxthxjnG02lkeixLn8vzNkF46enJQZwcHhvhQoAOHtzUYzFYk7qVGz05CU+ZoXM03j
	 7zRM2oSY+xCkgfJAJDZ1vhlmFLuvhm3u4ZUEynHzXRy5rvIelgmwIEF3luLu20Dnkx
	 O+lSsF4YtuxbA==
Date: Thu, 17 Oct 2024 12:02:46 -0700
Subject: [PATCH 17/21] xfs: use xfs_growfs_rt_alloc_fake_mount in
 xfs_growfs_rt_alloc_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919070691.3452315.16116404400674640047.stgit@frogsfrogsfrogs>
In-Reply-To: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
References: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
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
index 53503b675f9519..16d633da1614c3 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -935,10 +935,10 @@ xfs_growfs_rt_alloc_blocks(
 	struct xfs_mount	*mp = rtg_mount(rtg);
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

