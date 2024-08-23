Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69507179AD
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372408; cv=none; b=noTVebYh1ocjSCntNEJAXldACNS7pVm68fa97PKEPG/VLA30WVVXsoE69NtWWpoySjQMu+hBgiUKTTOrh4DBzRtV8AGEjcVDQpDLBIyDq7fm+dlphjGEE7BeFeJDdCFAT+0QSXorRWoRQkaY4cDYYBZVZyMJvtODfA0T63UmHPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372408; c=relaxed/simple;
	bh=LoFEKU8W417l/YHuSt27t7hwYTBXsHuVhdTGH7eiRJI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EdZfM+8GGFlfyFj63eRbCfsRLCsb77yOoQd562j7isebg2eC9CiR+zVPmegO0D8jRM7bu6uAzXY+gj2GCnJ5PCLEp2z5Zfh+QVma5iR/vgwO07PLnWOKEmYfOJIhJb7fPH0PqATRk98znen6x1f1y6eWGfu2Lh5mc5iDcuoVh0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FT9NhfdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FT9NhfdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3789BC32782;
	Fri, 23 Aug 2024 00:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372408;
	bh=LoFEKU8W417l/YHuSt27t7hwYTBXsHuVhdTGH7eiRJI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FT9NhfdZ1CK12ZaWaMq2DZKbxfNxrdl2Io4lNSgJPCcGdGvpzKViLHh/hLjchoyq2
	 iAwlp3PhyJ40kG8FScA3AFa1S6sV8vCLk/1IjwjKOCuv/ehLs1C/ieRsETP+NkU+7N
	 wJq3RyDnwGyFQNFEGsCoJUGE/iV2K3atcmzPc5235LNlUZhCIY4Ch/3dF+dMqmoppe
	 ydLPDksO+xtz0GqaEA9TUj8gdFsatydIXrBfIjgvMlSDOi2XchW08BlPAlJHEeyNEr
	 9RrpeGpfiVWSCADhVYNuRNnmg64COTRXOv1Mu9c4lAiwYSBXcS5Yl09DRc3xpdrCxu
	 8yVB0kScC88QA==
Date: Thu, 22 Aug 2024 17:20:07 -0700
Subject: [PATCH 21/24] xfs: factor out a xfs_growfs_check_rtgeom helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087611.59588.7898768503459548119.stgit@frogsfrogsfrogs>
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

Split the check that the rtsummary fits into the log into a separate
helper, and use xfs_growfs_rt_alloc_fake_mount to calculate the new RT
geometry.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: avoid division for the 0-rtx growfs check]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 61231b1dc4b79..78a3879ad6193 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1023,6 +1023,31 @@ xfs_growfs_rtg(
 	return error;
 }
 
+static int
+xfs_growfs_check_rtgeom(
+	const struct xfs_mount	*mp,
+	xfs_rfsblock_t		rblocks,
+	xfs_extlen_t		rextsize)
+{
+	struct xfs_mount	*nmp;
+	int			error = 0;
+
+	nmp = xfs_growfs_rt_alloc_fake_mount(mp, rblocks, rextsize);
+	if (!nmp)
+		return -ENOMEM;
+
+	/*
+	 * New summary size can't be more than half the size of the log.  This
+	 * prevents us from getting a log overflow, since we'll log basically
+	 * the whole summary file at once.
+	 */
+	if (nmp->m_rsumblocks > (mp->m_sb.sb_logblocks >> 1))
+		error = -EINVAL;
+
+	kfree(nmp);
+	return error;
+}
+
 /*
  * Grow the realtime area of the filesystem.
  */
@@ -1031,9 +1056,6 @@ xfs_growfs_rt(
 	xfs_mount_t	*mp,		/* mount point for filesystem */
 	xfs_growfs_rt_t	*in)		/* growfs rt input struct */
 {
-	xfs_rtxnum_t		nrextents;
-	xfs_extlen_t		nrbmblocks;
-	xfs_extlen_t		nrsumblocks;
 	struct xfs_buf		*bp;
 	xfs_agblock_t		old_rextsize = mp->m_sb.sb_rextsize;
 	int			error;
@@ -1082,20 +1104,13 @@ xfs_growfs_rt(
 	/*
 	 * Calculate new parameters.  These are the final values to be reached.
 	 */
-	nrextents = div_u64(in->newblocks, in->extsize);
 	error = -EINVAL;
-	if (nrextents == 0)
+	if (in->newblocks < in->extsize)
 		goto out_unlock;
-	nrbmblocks = xfs_rtbitmap_blockcount(mp, nrextents);
-	nrsumblocks = xfs_rtsummary_blockcount(mp,
-			xfs_compute_rextslog(nrextents) + 1, nrbmblocks);
 
-	/*
-	 * New summary size can't be more than half the size of
-	 * the log.  This prevents us from getting a log overflow,
-	 * since we'll log basically the whole summary file at once.
-	 */
-	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1))
+	/* Make sure the new fs size won't cause problems with the log. */
+	error = xfs_growfs_check_rtgeom(mp, in->newblocks, in->extsize);
+	if (error)
 		goto out_unlock;
 
 	error = xfs_growfs_rtg(mp, in->newblocks, in->extsize);

