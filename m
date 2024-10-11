Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445424A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608282; cv=none; b=fvRCohykKXuk/N9k6RGR6ujaKZtfg3HXcUPP+ihU3mUX4C57l2ZYTzElTEgQzsLoQQNG2Hu3rCoF3fiiWK0SI1S2gtDW+b474GUdEtDLaqcH1t77WPXRAtBnNVGj6uJ3MQYM7dNEAS2LFcRNzIukwyRu06VelmR6YpcF5/U91Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608282; c=relaxed/simple;
	bh=msDJynXC58oxKW3VXx9Y5zPJy1V9cJ4nb7/gy6yiUkY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXLQoDDpoO21Y23ucRgfsXIQZdorQKxR3+382fUXFl840P3XWmz+gmvdVYAxy+lx1nAXRBn0FVm1doG52ZO7ciqG7vdKR616U7KOEL4uSat5eOTHXRib0q6Rh0aoLSrf6Xzzo6+00XjquDBO2yRVOsBfo0+jpuysFEu85q0mRc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NbZqMDtx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NbZqMDtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267EAC4CEC5;
	Fri, 11 Oct 2024 00:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608282;
	bh=msDJynXC58oxKW3VXx9Y5zPJy1V9cJ4nb7/gy6yiUkY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NbZqMDtxa9MFhuYKvNYwqlmSnsi1ct+m95h317sUbNvjoILpCRX07g2GOLRUyb+TU
	 MVN4KRBXD3J9pSlUDn0i8i54lBNuKM1u/OIZDzzV3FEQsS6C9kR52AMHRNYabw3+Nz
	 I9US8eVYsG4rIeW0ujnMCaGc0zZxEPIu8eed90dq2gfar7rh1gGbRiMlpHJ0TFybrt
	 PGKiDSRMwNw4LbsVmtee25B1/7ZEmdf+eLjX+MHq/zlkRngPyxxecsgd+XZS0CfTaz
	 jOtCqBWvmd2coNyNaUYkTsyE4ZMcDErUdHgeEeck1zYpExGKs11CL7t6WC4o9cVCCF
	 IuT57W/xEOzBA==
Date: Thu, 10 Oct 2024 17:58:01 -0700
Subject: [PATCH 09/21] xfs: factor out a xfs_growfs_rt_alloc_blocks helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860643102.4177836.18109353388682341977.stgit@frogsfrogsfrogs>
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

Split out a helper to allocate or grow the rtbitmap and rtsummary files
in preparation of per-RT group bitmap and summary files.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |   56 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 96225313686414..9a451f88bf4647 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -875,6 +875,43 @@ xfs_last_rt_bmblock(
 	return bmbno;
 }
 
+/*
+ * Allocate space to the bitmap and summary files, as necessary.
+ */
+static int
+xfs_growfs_rt_alloc_blocks(
+	struct xfs_mount	*mp,
+	xfs_rfsblock_t		nrblocks,
+	xfs_agblock_t		rextsize,
+	xfs_extlen_t		*nrbmblocks)
+{
+	struct xfs_inode	*rbmip = mp->m_rbmip;
+	struct xfs_inode	*rsumip = mp->m_rsumip;
+	xfs_rtxnum_t		nrextents = div_u64(nrblocks, rextsize);
+	xfs_extlen_t		orbmblocks;
+	xfs_extlen_t		orsumblocks;
+	xfs_extlen_t		nrsumblocks;
+	int			error;
+
+	/*
+	 * Get the old block counts for bitmap and summary inodes.
+	 * These can't change since other growfs callers are locked out.
+	 */
+	orbmblocks = XFS_B_TO_FSB(mp, rbmip->i_disk_size);
+	orsumblocks = XFS_B_TO_FSB(mp, rsumip->i_disk_size);
+
+	*nrbmblocks = xfs_rtbitmap_blockcount(mp, nrextents);
+	nrsumblocks = xfs_rtsummary_blockcount(mp,
+		xfs_compute_rextslog(nrextents) + 1, *nrbmblocks);
+
+	error = xfs_rtfile_initialize_blocks(rbmip, orbmblocks,
+			*nrbmblocks, NULL);
+	if (error)
+		return error;
+	return xfs_rtfile_initialize_blocks(rsumip, orsumblocks,
+			nrsumblocks, NULL);
+}
+
 /*
  * Grow the realtime area of the filesystem.
  */
@@ -889,8 +926,6 @@ xfs_growfs_rt(
 	xfs_extlen_t	nrbmblocks;	/* new number of rt bitmap blocks */
 	xfs_rtxnum_t	nrextents;	/* new number of realtime extents */
 	xfs_extlen_t	nrsumblocks;	/* new number of summary blocks */
-	xfs_extlen_t	rbmblocks;	/* current number of rt bitmap blocks */
-	xfs_extlen_t	rsumblocks;	/* current number of rt summary blks */
 	uint8_t		*rsum_cache;	/* old summary cache */
 	xfs_agblock_t	old_rextsize = mp->m_sb.sb_rextsize;
 
@@ -963,21 +998,8 @@ xfs_growfs_rt(
 		goto out_unlock;
 	}
 
-	/*
-	 * Get the old block counts for bitmap and summary inodes.
-	 * These can't change since other growfs callers are locked out.
-	 */
-	rbmblocks = XFS_B_TO_FSB(mp, mp->m_rbmip->i_disk_size);
-	rsumblocks = XFS_B_TO_FSB(mp, mp->m_rsumip->i_disk_size);
-	/*
-	 * Allocate space to the bitmap and summary files, as necessary.
-	 */
-	error = xfs_rtfile_initialize_blocks(mp->m_rbmip, rbmblocks,
-			nrbmblocks, NULL);
-	if (error)
-		goto out_unlock;
-	error = xfs_rtfile_initialize_blocks(mp->m_rsumip, rsumblocks,
-			nrsumblocks, NULL);
+	error = xfs_growfs_rt_alloc_blocks(mp, in->newblocks, in->extsize,
+			&nrbmblocks);
 	if (error)
 		goto out_unlock;
 

