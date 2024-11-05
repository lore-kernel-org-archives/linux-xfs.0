Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F03216438
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845717; cv=none; b=CbMrvw/JjZBzQ6jwIWI9smGIa+hGwQZOJ+q9K/k/xFhCxRZ26KZc38whVy7couqP/qVa9nr6iTPFKB/2ZpwK2KzDn5rIVp2z7Eei900dieiTIykPLdLzzJmPB/OzetPtGDqcswdgzSJBsbxQCrVYoLWcsDhaHFnQzkUIOvh0gI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845717; c=relaxed/simple;
	bh=xa1GBYcLAWLbM/wseXGGAbdH4vnw7ZvjxIjZn99oOmc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MEUsTXSS7bOxHCXu/syd3pmLPeFyq2NEA62sqACSs43GxRVPMDI1Pb4R1hogD/U85zwLOs+Zr9Qcvz9AFD2nFvGHOu8oX9mQkPoQbih2XXgikKhE1XbHWHDpSQmdzRGx1VD3n0OZSUHkpZhCmepuRil5uPtNfmYgNMUT7rNR1qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SnvkYdSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SnvkYdSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83BDC4CECF;
	Tue,  5 Nov 2024 22:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845716;
	bh=xa1GBYcLAWLbM/wseXGGAbdH4vnw7ZvjxIjZn99oOmc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SnvkYdSnVdUsSB9kSzfi+otOLZBobvtZz7bVlh2Av06y/xVLPWt+Hj5oVuQHCNSZ2
	 4J72Q6B63QC9IZctDPfvSQb0/6kbi9gbt+NpWzQVf8u/UZHkOJeIHJCAtpiCIjlm0y
	 GVqpfidkQ2hWXIkxkHAkLdQqNeO3ylNNpOTcpn3kEBt4opXleG5CWrB8LXTju8bLiP
	 YWQVq7uYpZhodGVkh/qvjhtjr2vOeYBmjzfCOi3cZHZYTaAT633lO3zFnJ4bkNvzuR
	 FdyPyySxM7mwpMLya5TkWXirDvPZT3C0jfl6T+oTAWLiy3txdoZJ2pbmsmpwvdg78J
	 nvta5TnKySiYg==
Date: Tue, 05 Nov 2024 14:28:36 -0800
Subject: [PATCH 18/21] xfs: factor out a xfs_growfs_check_rtgeom helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084397246.1871025.2886938515086855792.stgit@frogsfrogsfrogs>
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
index e69728c80caf11..d4e55893f8562f 100644
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

