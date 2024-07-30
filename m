Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71D94A3F
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300701; cv=none; b=RRjCYbSXQ6avqBB3v5fwLzsywBlGwLoEis0DOnucwV4DfgppiE8K20o9kigWZ+8QQm10BHFYmMwKovQNgcHcVruYvtatT7giuW0rbSHnwTwTUz4jtAf26pK0ZzQndTTrS0QgqRl0LHH1Qcr0g5KuO0SvJNteMtQBXiWOa8HQJBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300701; c=relaxed/simple;
	bh=eX40Xj6Z9lqAwGs+xmLAsbhzstvYaDDUyP9nzHwmA1M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ghShVJjEknGqRXmDW/bNEy6ocMB9LLselZ6N0ZR2zVOuwOqiCssRLkJxdJARJmDE7PH0cVTDcqNtbl/EEkMU+mkrDq1/xh6w06RHgEghoaQq2cBJzg8Gr0aFyBQSpX5IqzVexF4ZmWXKCIPESEDyBlr72GwSqiR0qfIyBztqArU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lTfhxkfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lTfhxkfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AD0C32786;
	Tue, 30 Jul 2024 00:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300701;
	bh=eX40Xj6Z9lqAwGs+xmLAsbhzstvYaDDUyP9nzHwmA1M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lTfhxkfNKy5SJBM8Vam6PR6Me4Z6guuthTBAHEnDvXEXdgo9jjvxs1V2gBGI53pZW
	 tgT1PuY+SHTMD+L8kAgVmPgzdgDECsikciYqlEbyp+vlCJD7ADQa2FWbsKtHPJrnPP
	 py4KnUT8kmPnvpg3fc9aGFRJrdfK6mLrZKKM/9kJ6MndwSsT0hhbooErc0qnF5M7++
	 UIgW0NU9le0n5wzRGBnN+FuESjiwtjXKhOFx2KQdzk154UOXe8s+Sm0HtAJ+JCFD7O
	 sGhpcIsEEtuKkgAOewyTZJ433r+xoFiheGJvtfyfOxSuMg2VBWKcxQHGTdGPZKSHCB
	 dRQlW+RQo6jCw==
Date: Mon, 29 Jul 2024 17:51:41 -0700
Subject: [PATCH 107/115] xfs: simplify iext overflow checking and upgrade
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172229843954.1338752.423549545566881943.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 25576c5420e61dea4c2b52942460f2221b8e46e8

Currently the calls to xfs_iext_count_may_overflow and
xfs_iext_count_upgrade are always paired.  Merge them into a single
function to simplify the callers and the actual check and upgrade
logic itself.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_attr.c       |    5 +---
 libxfs/xfs_bmap.c       |    5 +---
 libxfs/xfs_inode_fork.c |   63 +++++++++++++++++++++--------------------------
 libxfs/xfs_inode_fork.h |    6 +---
 4 files changed, 32 insertions(+), 47 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 99648d78c..9d32aa406 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1049,11 +1049,8 @@ xfs_attr_set(
 		return error;
 
 	if (op != XFS_ATTRUPDATE_REMOVE || xfs_inode_hasattr(dp)) {
-		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
+		error = xfs_iext_count_extend(args->trans, dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(args->trans, dp,
-					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error)
 			goto out_trans_cancel;
 	}
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4a365f1a1..347b44423 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4645,11 +4645,8 @@ xfs_bmapi_convert_one_delalloc(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, whichfork,
+	error = xfs_iext_count_extend(tp, ip, whichfork,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index d9f0a21ac..cd5e2e729 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -763,53 +763,46 @@ xfs_ifork_verify_local_attr(
 	return 0;
 }
 
-int
-xfs_iext_count_may_overflow(
-	struct xfs_inode	*ip,
-	int			whichfork,
-	int			nr_to_add)
-{
-	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
-	uint64_t		max_exts;
-	uint64_t		nr_exts;
-
-	if (whichfork == XFS_COW_FORK)
-		return 0;
-
-	max_exts = xfs_iext_max_nextents(xfs_inode_has_large_extent_counts(ip),
-				whichfork);
-
-	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
-		max_exts = 10;
-
-	nr_exts = ifp->if_nextents + nr_to_add;
-	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
-		return -EFBIG;
-
-	return 0;
-}
-
 /*
- * Upgrade this inode's extent counter fields to be able to handle a potential
- * increase in the extent count by nr_to_add.  Normally this is the same
- * quantity that caused xfs_iext_count_may_overflow() to return -EFBIG.
+ * Check if the inode fork supports adding nr_to_add more extents.
+ *
+ * If it doesn't but we can upgrade it to large extent counters, do the upgrade.
+ * If we can't upgrade or are already using big counters but still can't fit the
+ * additional extents, return -EFBIG.
  */
 int
-xfs_iext_count_upgrade(
+xfs_iext_count_extend(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
+	int			whichfork,
 	uint			nr_to_add)
 {
+	struct xfs_mount	*mp = ip->i_mount;
+	bool			has_large =
+		xfs_inode_has_large_extent_counts(ip);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+	uint64_t		nr_exts;
+
 	ASSERT(nr_to_add <= XFS_MAX_EXTCNT_UPGRADE_NR);
 
-	if (!xfs_has_large_extent_counts(ip->i_mount) ||
-	    xfs_inode_has_large_extent_counts(ip) ||
-	    XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
+	if (whichfork == XFS_COW_FORK)
+		return 0;
+
+	/* no point in upgrading if if_nextents overflows */
+	nr_exts = ifp->if_nextents + nr_to_add;
+	if (nr_exts < ifp->if_nextents)
 		return -EFBIG;
 
-	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS) &&
+	    nr_exts > 10)
+		return -EFBIG;
 
+	if (nr_exts > xfs_iext_max_nextents(has_large, whichfork)) {
+		if (has_large || !xfs_has_large_extent_counts(mp))
+			return -EFBIG;
+		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	}
 	return 0;
 }
 
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index bd53eb951..2373d12fd 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -256,10 +256,8 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
 int xfs_ifork_verify_local_data(struct xfs_inode *ip);
 int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
-int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
-		int nr_to_add);
-int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
-		uint nr_to_add);
+int xfs_iext_count_extend(struct xfs_trans *tp, struct xfs_inode *ip,
+		int whichfork, uint nr_to_add);
 bool xfs_ifork_is_realtime(struct xfs_inode *ip, int whichfork);
 
 /* returns true if the fork has extents but they are not read in yet. */

