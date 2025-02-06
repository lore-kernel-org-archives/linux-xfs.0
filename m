Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83894197A8E
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882012; cv=none; b=Qdb53BOJ3bpdCmkNd6HXqZXOC0b3VBgyeBqMS2QrTWnIZVpfknK864lZQUQYj1AdNHnyLdkT8OxW+2eXHyKYDQ/8onc9a3XsOV7fbZXCLPBftc6WziwMQVCC5WMYosMHVmfrboj7maQ6lf/YH49pSfgkYzSl+s4FGH73fF41K9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882012; c=relaxed/simple;
	bh=HPBb1XHhAMpTrckqUM4bEYMl9hQxqK8htbdYQmronXs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kcRW3sQBbZn7/9iS0UfK1vkevhvQuwN4BQD50nJMYwLLusc+aEaKlG66a3vluLjfgqJZCiIF+TcxmpMXhDdzhT0eJOn6sUB1RXxNALsNtyV9+PViOjokbH9Wd0qAU1Fy0eNRomjIC3/pFAaezvRrEgmPuYCDE02QAt833vHWkBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K2OmT9lX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K2OmT9lX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6DDC4CEDD;
	Thu,  6 Feb 2025 22:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882012;
	bh=HPBb1XHhAMpTrckqUM4bEYMl9hQxqK8htbdYQmronXs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K2OmT9lXAyZmizSBmKY570jfrxIqW61SGYjvyeiVPRPzJrm+idNvUEIMI1Pqggtki
	 rWvzSa7E+pCtjPa7rCrZlQvAwIVclnUJKvKYVza4Sd+fvBLmviPY4EYSjBcFvNifxw
	 xgonXx1ProTyp4PBc35QNzBpFtH8kApp5KKUAmgXIsycSfCbG6z56b7AyW6HIlp5vS
	 /KG318LdwZ4NH1UVKYy9qvZvxkDkPZ/RH3mElf5n64rijvFR01UuxvIA3809uN6g6Z
	 xz144zSkYPk+0pgYiGB4Clu/p0Wgo5n9Xca7BvwYnHVqPY6iVtSxJokWmqIELOISS1
	 ans7Vbxd7QGzA==
Date: Thu, 06 Feb 2025 14:46:51 -0800
Subject: [PATCH 45/56] xfs: recover CoW leftovers in the realtime volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087481.2739176.5640519933337769407.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 51e232674975ff138d0e892272fdde9bc444c572

Scan the realtime refcount tree at mount time to get rid of leftover
CoW staging extents.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_refcount.c |   47 +++++++++++++++++++++++++++++++++--------------
 libxfs/xfs_refcount.h |    3 +--
 2 files changed, 34 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 738c3cd4ea5131..1000bab245284f 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -2052,12 +2052,13 @@ xfs_refcount_recover_extent(
 /* Find and remove leftover CoW reservations. */
 int
 xfs_refcount_recover_cow_leftovers(
-	struct xfs_mount		*mp,
-	struct xfs_perag		*pag)
+	struct xfs_group		*xg)
 {
+	struct xfs_mount		*mp = xg->xg_mount;
+	bool				isrt = xg->xg_type == XG_TYPE_RTG;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*cur;
-	struct xfs_buf			*agbp;
+	struct xfs_buf			*agbp = NULL;
 	struct xfs_refcount_recovery	*rr, *n;
 	struct list_head		debris;
 	union xfs_btree_irec		low = {
@@ -2070,10 +2071,19 @@ xfs_refcount_recover_cow_leftovers(
 	xfs_fsblock_t			fsb;
 	int				error;
 
-	/* reflink filesystems mustn't have AGs larger than 2^31-1 blocks */
+	/* reflink filesystems must not have groups larger than 2^31-1 blocks */
+	BUILD_BUG_ON(XFS_MAX_RGBLOCKS >= XFS_REFC_COWFLAG);
 	BUILD_BUG_ON(XFS_MAX_CRC_AG_BLOCKS >= XFS_REFC_COWFLAG);
-	if (mp->m_sb.sb_agblocks > XFS_MAX_CRC_AG_BLOCKS)
-		return -EOPNOTSUPP;
+
+	if (isrt) {
+		if (!xfs_has_rtgroups(mp))
+			return 0;
+		if (xfs_group_max_blocks(xg) >= XFS_MAX_RGBLOCKS)
+			return -EOPNOTSUPP;
+	} else {
+		if (xfs_group_max_blocks(xg) > XFS_MAX_CRC_AG_BLOCKS)
+			return -EOPNOTSUPP;
+	}
 
 	INIT_LIST_HEAD(&debris);
 
@@ -2091,16 +2101,24 @@ xfs_refcount_recover_cow_leftovers(
 	if (error)
 		return error;
 
-	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
-	if (error)
-		goto out_trans;
-	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
+	if (isrt) {
+		xfs_rtgroup_lock(to_rtg(xg), XFS_RTGLOCK_REFCOUNT);
+		cur = xfs_rtrefcountbt_init_cursor(tp, to_rtg(xg));
+	} else {
+		error = xfs_alloc_read_agf(to_perag(xg), tp, 0, &agbp);
+		if (error)
+			goto out_trans;
+		cur = xfs_refcountbt_init_cursor(mp, tp, agbp, to_perag(xg));
+	}
 
 	/* Find all the leftover CoW staging extents. */
 	error = xfs_btree_query_range(cur, &low, &high,
 			xfs_refcount_recover_extent, &debris);
 	xfs_btree_del_cursor(cur, error);
-	xfs_trans_brelse(tp, agbp);
+	if (agbp)
+		xfs_trans_brelse(tp, agbp);
+	else
+		xfs_rtgroup_unlock(to_rtg(xg), XFS_RTGLOCK_REFCOUNT);
 	xfs_trans_cancel(tp);
 	if (error)
 		goto out_free;
@@ -2113,14 +2131,15 @@ xfs_refcount_recover_cow_leftovers(
 			goto out_free;
 
 		/* Free the orphan record */
-		fsb = xfs_agbno_to_fsb(pag, rr->rr_rrec.rc_startblock);
-		xfs_refcount_free_cow_extent(tp, false, fsb,
+		fsb = xfs_gbno_to_fsb(xg, rr->rr_rrec.rc_startblock);
+		xfs_refcount_free_cow_extent(tp, isrt, fsb,
 				rr->rr_rrec.rc_blockcount);
 
 		/* Free the block. */
 		error = xfs_free_extent_later(tp, fsb,
 				rr->rr_rrec.rc_blockcount, NULL,
-				XFS_AG_RESV_NONE, 0);
+				XFS_AG_RESV_NONE,
+				isrt ? XFS_FREE_EXTENT_REALTIME : 0);
 		if (error)
 			goto out_trans;
 
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index be11df25abcc5b..f2e299a716a4ee 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -94,8 +94,7 @@ void xfs_refcount_alloc_cow_extent(struct xfs_trans *tp, bool isrt,
 		xfs_fsblock_t fsb, xfs_extlen_t len);
 void xfs_refcount_free_cow_extent(struct xfs_trans *tp, bool isrt,
 		xfs_fsblock_t fsb, xfs_extlen_t len);
-extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
-		struct xfs_perag *pag);
+int xfs_refcount_recover_cow_leftovers(struct xfs_group *xg);
 
 /*
  * While we're adjusting the refcounts records of an extent, we have

