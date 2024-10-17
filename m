Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9309F21BAEF
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191681; cv=none; b=HIlNPEHojP2u2D6Zq7ulUuk2JouNDLg5yF1x4GhCtgASO84v99LWx0MzVfFEBJua95t5wF5P3mt9fwLxNByKSozdyNFJ+0/S9PmhnBAJ9RfXgupB8clwwRxiYRlx9flksmRZwTok/zVp+DffPp4VF1WBUY2W15TyfRuyRbKFDHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191681; c=relaxed/simple;
	bh=1td6oDYyNE4XnoB4BbbIPnUt9ybeSUSwVvwa4o+otag=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VATUelg1fUvT7JOGAzN9JkUVFGksy4R/y1ke4O2TFpKDf4rIHYxWg2+UneBBf9uplbocT8zdX+BBGb7sx30n1/a1W9b7/Hx+Axzrm51x4hafA983o18LD3i+t6V5/UFdqbRMXQ9eoi08zmQwODct/NPkxcGr2oCd+EYAClsFAO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MP3SafKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MP3SafKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEF2C4CECE;
	Thu, 17 Oct 2024 19:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191681;
	bh=1td6oDYyNE4XnoB4BbbIPnUt9ybeSUSwVvwa4o+otag=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MP3SafKZcsgkV9mHMm7aIyDYG78SoZCWluAlwhF3U2brAAVPbnwJ3GqOP1COwmz3a
	 sshK56tzMWXydlTxhjCIW8xHZhmXovMaKmUF6qReWObSPA5Y9MXHZNkpvL9snPUoXE
	 gELKua9h1Y17Rx7v07ICiYhhu5SOnlAc4G1gv6J3XbPSZmmx8joHvtV4nwtACsPcsd
	 7Iyy8AA4wZmAl7dLXpjoo4e1sImAOr+uRw+mPYGK5bOTH2GlBNer5hp0HQ7qsBJlKk
	 oVG0TNhdJteR5oF5R34bVOtwPXAFpTdET2MSO+FdG7bu6HkF/uOu0QtSinZfnFFCi9
	 zifug3Lvh6ksw==
Date: Thu, 17 Oct 2024 12:01:21 -0700
Subject: [PATCH 09/21] xfs: factor out a xfs_growfs_rt_alloc_blocks helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919070552.3452315.7391021401533104594.stgit@frogsfrogsfrogs>
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

Split out a helper to allocate or grow the rtbitmap and rtsummary files
in preparation of per-RT group bitmap and summary files.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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
 

