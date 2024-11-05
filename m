Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13B11EC01B
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845701; cv=none; b=ojb0dFWNY2AEAMRTKQSNBZBIf4nHcT3I8H1I4Ohjxe6Wd6dCnyuk6D2xcEBMDM0T1kfX3eEYA1AjlAnnn1rK1j5o8dsgN8s3IYVvo04uQDxOrAWKjpzXxgmhBfHEwN7js1MfnTH3/oKCCpSnqD7LzUk0zuvmNLRygpFXjaZkTeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845701; c=relaxed/simple;
	bh=9dyABwGcL07ZPEwsC+mhphBd2qm3+FXrib8qsi9P2uw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GwBFN6cipSv68p76nYeBTp+Rr6WGzk/HXQzqzZ89meIy8BBfNLxeiwHMGvCHGxHKmqKgEnXhWqEnChH50qkUnBd6fq87E5zOfvpEC03unxZu835JuiMDrjOYcczVGOjBL5U7bVRdtTo9Zvln6Fiehm+4/2eQSHTrxpXhoXDe86c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CQMNJNnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CQMNJNnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2657EC4CECF;
	Tue,  5 Nov 2024 22:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845701;
	bh=9dyABwGcL07ZPEwsC+mhphBd2qm3+FXrib8qsi9P2uw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CQMNJNnt0TS0HHssVH4FpVuYoMS8Vge5XLl5wE1QEgkn/jymh18wqytpgj20I1/61
	 1Jkzuw8rQG6BL5WI/Q0Y6sWHlFp3YSEU2YNJvo6t+WOeEKw4bX6BUjDStaYt+WY124
	 4Srq0UuhDUbccmpW8M1gEfyc46Qb7ddYW77gW5dq9onkua6/Hs1W8r0JEnkBcjAhTH
	 Xww/nG6MY/AXJUpkEwnHGPN1tYK1mTccghLNxIv+kbNuA+y0b7iPGteNY5h3OwmitK
	 WBwAPX8RFX27RCfF6/xZjPRYiV1P0cWmzulaJ3LfhX7aik9MB/SJXlMwKECSuQQT25
	 j15G7iccvu/Qw==
Date: Tue, 05 Nov 2024 14:28:20 -0800
Subject: [PATCH 17/21] xfs: use xfs_growfs_rt_alloc_fake_mount in
 xfs_growfs_rt_alloc_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084397229.1871025.8520748931295123577.stgit@frogsfrogsfrogs>
In-Reply-To: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
References: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
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
index e557eee5210419..e69728c80caf11 100644
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

