Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D00216208
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845576; cv=none; b=HTYqOY/lijkn1pVFFEwGsnq7I6iUfRMkrAMviXGQQGHaOZHWtBvc7eW7OBh7181neqdWThGQtqZh58l5JSXPi40/BqT6oBeVFcfJl3kr5EiyvU0w0xEVbbsF1qovthBtK4NToGrxlMog7Ndun38rcqESoO6hCdcmBXsdgBvXM4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845576; c=relaxed/simple;
	bh=1td6oDYyNE4XnoB4BbbIPnUt9ybeSUSwVvwa4o+otag=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jIT9ib/02qlBUmB0lQk0EJqr+vmFK2IrqKCtigGzp8yR/egvcS2NkCJcv/qkaYbGkvSh5LWRJxhsPjpI6QNBeu72B7KgE46u4yG8THwNGg84G4JMYq2e/TimWujLGHdSvwr6sljleh5oJvbU+LvaxgW5dREDBwfWxzCXDux0ab4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oaBaOj0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oaBaOj0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BFBC4CECF;
	Tue,  5 Nov 2024 22:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845576;
	bh=1td6oDYyNE4XnoB4BbbIPnUt9ybeSUSwVvwa4o+otag=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oaBaOj0QL3UsACsodH16r+Eav//UZCJVavxi12q1tfD4tl7CY4lP7nHLWF+i1/2LO
	 LlEnJW4mQ6tKBn1oiowKaUsZNBXwlReOI5morV+vyuPzrTZrYiDqQEiKUGig1tDVtU
	 ++hdIsmy+D0q+1rtoWVBrp2EtE430rCXqv7lv6ng+UQjZnIs3cT4Usjh6EOmNiFhmL
	 w91YWs9vPZBqSBU3w08cVeBkntJobKK+zvbSUhndnDNVg9cWcLQ0ZEI/aSbtwKv3Qf
	 Ijt2b6qOU5EBZ06SSNC2eV1JEUoF8FNKWNn/wpecQDeaDAtecjju/cC3U0X1qEjl4k
	 VU7H/e5x2xGzQ==
Date: Tue, 05 Nov 2024 14:26:15 -0800
Subject: [PATCH 09/21] xfs: factor out a xfs_growfs_rt_alloc_blocks helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084397093.1871025.13676169685527994396.stgit@frogsfrogsfrogs>
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
 

