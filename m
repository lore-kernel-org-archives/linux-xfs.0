Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B742837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995475; cv=none; b=lqyoXGXgTy7+nEH3r4S1AeUgVLzsIrTq+hIj5bAL9nenH18k2hE7M8F1FtDCkOy9Cp07qqnI83wCSGDzyHtBdAwmwpaUIAm49A0xuFTs333TebUFG6NN0X4QI8zX/YecFaVa2kPLrFOO2CPTcTgdogxwVkVykEQeAJfAfmYjk7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995475; c=relaxed/simple;
	bh=krTqPSDbEL4Uf4dmqOY5JcZGYJBUioGdHSoLVkGzkCk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rYPJI0QhVTBczP3ub2kjGNRd767tcNQQNs3LmvfM9jgR8bl6W59l8rLe5WxFO1SZRRm/v9cD4kydE4dG7vrQ85H52KhtduPtdmmzm+L5uqiNsHWuHv8kUZaNifNjixhf4PFvoiKAGsRx4hiNPVaz3OTVWBiZPFEmkYNnMTVI2ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C40uAoW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C40uAoW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BACC4CED3;
	Mon, 23 Dec 2024 23:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995474;
	bh=krTqPSDbEL4Uf4dmqOY5JcZGYJBUioGdHSoLVkGzkCk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C40uAoW+Xl3yKa+rV12sWLGyltpAsprWyft3PtMspMzcYNXR4AHyHx06tcxKEiXhH
	 leZJIxlRQoLb7tLAVpVJm7rcpwaCzmx7eaRAkIzLHd7XCp/ZA6B9yt1tATcniHwyCp
	 MC58swUi4bUiR7VNnSZvWyUo86cEV7vlnZzWgawzYN6LXoeE7RsLHi8SrkzsBg302O
	 XhqCwBD9b+mmhgTW4BdQp8PqIM8X3VdpBhJpXb3CVXMW17fla/mOqM9JacstII+zH4
	 lGnGYsNucXYQFLUqWRWNoKPsB07UefCuk6DzGGIwZQBQAh0mJk1oMWUAa2cSj6tf7j
	 l5hppJCJ2jsow==
Date: Mon, 23 Dec 2024 15:11:14 -0800
Subject: [PATCH 19/43] xfs: enable CoW for realtime data
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420264.2381378.15207407249279111578.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update our write paths to support copy on write on the rt volume.  This
works in more or less the same way as it does on the data device, with
the major exception that we never do delalloc on the rt volume.

Because we consider unwritten CoW fork staging extents to be incore
quota reservation, we update xfs_quota_reserve_blkres to support this
case.  Though xfs doesn't allow rt and quota together, the change is
trivial and we shouldn't leave a logic bomb here.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 29574b015fddc0..24f545687b8730 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -439,20 +439,26 @@ xfs_reflink_fill_cow_hole(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	xfs_filblks_t		resaligned;
-	xfs_extlen_t		resblks;
+	unsigned int		dblocks = 0, rblocks = 0;
 	int			nimaps;
 	int			error;
 	bool			found;
 
 	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
 		imap->br_blockcount, xfs_get_cowextsz_hint(ip));
-	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+		rblocks = resaligned;
+	} else {
+		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
+		rblocks = 0;
+	}
 
 	xfs_iunlock(ip, *lockmode);
 	*lockmode = 0;
 
-	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
-			false, &tp);
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
+			rblocks, false, &tp);
 	if (error)
 		return error;
 
@@ -1212,7 +1218,7 @@ xfs_reflink_remap_extent(
 	struct xfs_trans	*tp;
 	xfs_off_t		newlen;
 	int64_t			qdelta = 0;
-	unsigned int		resblks;
+	unsigned int		dblocks, rblocks, resblks;
 	bool			quota_reserved = true;
 	bool			smap_real;
 	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
@@ -1243,8 +1249,15 @@ xfs_reflink_remap_extent(
 	 * we're remapping.
 	 */
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		dblocks = resblks;
+		rblocks = dmap->br_blockcount;
+	} else {
+		dblocks = resblks + dmap->br_blockcount;
+		rblocks = 0;
+	}
 	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
-			resblks + dmap->br_blockcount, 0, false, &tp);
+			dblocks, rblocks, false, &tp);
 	if (error == -EDQUOT || error == -ENOSPC) {
 		quota_reserved = false;
 		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
@@ -1324,8 +1337,15 @@ xfs_reflink_remap_extent(
 	 * done.
 	 */
 	if (!quota_reserved && !smap_real && dmap_written) {
-		error = xfs_trans_reserve_quota_nblks(tp, ip,
-				dmap->br_blockcount, 0, false);
+		if (XFS_IS_REALTIME_INODE(ip)) {
+			dblocks = 0;
+			rblocks = dmap->br_blockcount;
+		} else {
+			dblocks = dmap->br_blockcount;
+			rblocks = 0;
+		}
+		error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks,
+				false);
 		if (error)
 			goto out_cancel;
 	}

