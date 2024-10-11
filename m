Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758715256
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608407; cv=none; b=jh22W4vr31Z+aT3RH6lOAE6gqcE5Bvr7N+7TIt4hbIg8vZrt5k8gZoDBThz6/8gv5ZfNILhOOCnsxultlU2LkDUf0NMawmPI23PoECAq9YD5hjD9Lfg/wdURT1V0r0Dy7xCOMPnJFLz3dVe0chncTScjwtJAvwNfo9p5isZ6RV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608407; c=relaxed/simple;
	bh=RU9dvPEJVMH4OFXNfijjUaLWhq//YOslkbZ1KiL0M70=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ihAt3Tp/T84rsQiDoIsMNw52nIBrTjMQCTfWTuDXeVxvj+uZxFkMEQ1RVAY0pZzW6xi4hEv1MQUlO1S0/K2qAYHuiQQn3Sne09gxTSDsyx32elpdpLPSAlYDjKADS4cJ01D8CI5k9Ewf2Xrh62eslGSR2OsUk6iYQpcpovdzw+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hK4AsscF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hK4AsscF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A75C4CEC5;
	Fri, 11 Oct 2024 01:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608407;
	bh=RU9dvPEJVMH4OFXNfijjUaLWhq//YOslkbZ1KiL0M70=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hK4AsscFwCefDalfeLiP1QRRQX4qeHjy8Qv1T8GgvK3w6Z5LSClPWkNKRqchYZwU/
	 n7JihX3qXACvL4dOTeEjz3o2tPW+qc6mTKs9HKclqX2lyaSZb1PtbiXTIWWSiKp3Xw
	 AjXzsNieNKNxGmWPzekPAfmt4bLfNHFZv04SWTB5+MOPJrRVnQBv/WFY1b+YksZ64T
	 e2OmdvDbjsM/ZO0xzOizXd6fwR98bEFe2XUZGjxBO2r9ClMyyzFGCIFkhiCUZRu4rr
	 EkwETsVY0Aw+d+y5DoYCX1YS7F4gZ3gBTA+cIFSHsS+2zwqi412nK45KCOyNvMjUxa
	 ZghDigwBEBJ3A==
Date: Thu, 10 Oct 2024 18:00:06 -0700
Subject: [PATCH 17/21] xfs: use xfs_growfs_rt_alloc_fake_mount in
 xfs_growfs_rt_alloc_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860643241.4177836.2123493604915682598.stgit@frogsfrogsfrogs>
In-Reply-To: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
References: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
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

