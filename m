Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D705BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="noAZVeVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CBAC433C8;
	Sun, 31 Dec 2023 20:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054505;
	bh=oh6+niEGADWMZ6pdzPAHZJCQJDjmSrUFalSgipmUFOA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=noAZVeVQNMygo8oXxm/lnfX1DyjzUT6oNOw2GHDMq/db4zvXBzytOZm4MYOlrku4P
	 UjYXR+7ogPNcXwUMphujghlpaoQLGs6XydbnZu0QeVg5zprytCjp6BU7eEgzsp0J7B
	 Y+v3gDLN/UaxkxIW8M7oKF1z3O1qeEK43DVnze84HJZuO6IeYH8mD3mZGB+FNW1FpR
	 bp1gLDSsspPv1FAyR01yiJ4WzNRYBBLfAXj5Pyz2m2zFIwPw5SUPODogFYXBVFZjpS
	 OgUyJ6EJLMKjV6fXCPUayGdnSXoR5XFG/yeKA8ucvPu2wd4sVxvbGZ57+PdT9vzN+q
	 eUxAMTm0INx4Q==
Date: Sun, 31 Dec 2023 12:28:24 -0800
Subject: [PATCH 16/25] xfs: consolidate all of the xfs_swap_extent_forks code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833398.1750288.14345157787842896292.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we've moved the old swapext code to use the new log-assisted
extent swap code for rmap filesystems, let's start porting the old
implementation to the new ioctl interface so that later we can port the
old interface to the new interface.

Consolidate the reflink flag swap code and the the bmbt owner change
scan code in xfs_swap_extent_forks, since both interfaces are going to
need that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |  220 ++++++++++++++++++++++++------------------------
 1 file changed, 108 insertions(+), 112 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8ca681d78bbcb..0056bee7ca1d6 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1354,19 +1354,61 @@ xfs_swap_extent_flush(
 	return 0;
 }
 
+/*
+ * Fix up the owners of the bmbt blocks to refer to the current inode. The
+ * change owner scan attempts to order all modified buffers in the current
+ * transaction. In the event of ordered buffer failure, the offending buffer is
+ * physically logged as a fallback and the scan returns -EAGAIN. We must roll
+ * the transaction in this case to replenish the fallback log reservation and
+ * restart the scan. This process repeats until the scan completes.
+ */
+static int
+xfs_swap_change_owner(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	struct xfs_inode	*tmpip)
+{
+	int			error;
+	struct xfs_trans	*tp = *tpp;
+
+	do {
+		error = xfs_bmbt_change_owner(tp, ip, XFS_DATA_FORK, ip->i_ino,
+					      NULL);
+		/* success or fatal error */
+		if (error != -EAGAIN)
+			break;
+
+		error = xfs_trans_roll(tpp);
+		if (error)
+			break;
+		tp = *tpp;
+
+		/*
+		 * Redirty both inodes so they can relog and keep the log tail
+		 * moving forward.
+		 */
+		xfs_trans_ijoin(tp, ip, 0);
+		xfs_trans_ijoin(tp, tmpip, 0);
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		xfs_trans_log_inode(tp, tmpip, XFS_ILOG_CORE);
+	} while (true);
+
+	return error;
+}
+
 /* Swap the extents of two files by swapping data forks. */
 STATIC int
 xfs_swap_extent_forks(
-	struct xfs_trans	*tp,
+	struct xfs_trans	**tpp,
 	struct xfs_inode	*ip,
-	struct xfs_inode	*tip,
-	int			*src_log_flags,
-	int			*target_log_flags)
+	struct xfs_inode	*tip)
 {
 	xfs_filblks_t		aforkblks = 0;
 	xfs_filblks_t		taforkblks = 0;
 	xfs_extnum_t		junk;
 	uint64_t		tmp;
+	int			src_log_flags = XFS_ILOG_CORE;
+	int			target_log_flags = XFS_ILOG_CORE;
 	int			error;
 
 	/*
@@ -1374,14 +1416,14 @@ xfs_swap_extent_forks(
 	 */
 	if (xfs_inode_has_attr_fork(ip) && ip->i_af.if_nextents > 0 &&
 	    ip->i_af.if_format != XFS_DINODE_FMT_LOCAL) {
-		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK, &junk,
+		error = xfs_bmap_count_blocks(*tpp, ip, XFS_ATTR_FORK, &junk,
 				&aforkblks);
 		if (error)
 			return error;
 	}
 	if (xfs_inode_has_attr_fork(tip) && tip->i_af.if_nextents > 0 &&
 	    tip->i_af.if_format != XFS_DINODE_FMT_LOCAL) {
-		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK, &junk,
+		error = xfs_bmap_count_blocks(*tpp, tip, XFS_ATTR_FORK, &junk,
 				&taforkblks);
 		if (error)
 			return error;
@@ -1396,9 +1438,9 @@ xfs_swap_extent_forks(
 	 */
 	if (xfs_has_v3inodes(ip->i_mount)) {
 		if (ip->i_df.if_format == XFS_DINODE_FMT_BTREE)
-			(*target_log_flags) |= XFS_ILOG_DOWNER;
+			target_log_flags |= XFS_ILOG_DOWNER;
 		if (tip->i_df.if_format == XFS_DINODE_FMT_BTREE)
-			(*src_log_flags) |= XFS_ILOG_DOWNER;
+			src_log_flags |= XFS_ILOG_DOWNER;
 	}
 
 	/*
@@ -1428,71 +1470,80 @@ xfs_swap_extent_forks(
 
 	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_EXTENTS:
-		(*src_log_flags) |= XFS_ILOG_DEXT;
+		src_log_flags |= XFS_ILOG_DEXT;
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		ASSERT(!xfs_has_v3inodes(ip->i_mount) ||
-		       (*src_log_flags & XFS_ILOG_DOWNER));
-		(*src_log_flags) |= XFS_ILOG_DBROOT;
+		       (src_log_flags & XFS_ILOG_DOWNER));
+		src_log_flags |= XFS_ILOG_DBROOT;
 		break;
 	}
 
 	switch (tip->i_df.if_format) {
 	case XFS_DINODE_FMT_EXTENTS:
-		(*target_log_flags) |= XFS_ILOG_DEXT;
+		target_log_flags |= XFS_ILOG_DEXT;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		(*target_log_flags) |= XFS_ILOG_DBROOT;
+		target_log_flags |= XFS_ILOG_DBROOT;
 		ASSERT(!xfs_has_v3inodes(ip->i_mount) ||
-		       (*target_log_flags & XFS_ILOG_DOWNER));
+		       (target_log_flags & XFS_ILOG_DOWNER));
 		break;
 	}
 
+	/* Do we have to swap reflink flags? */
+	if ((ip->i_diflags2 & XFS_DIFLAG2_REFLINK) ^
+	    (tip->i_diflags2 & XFS_DIFLAG2_REFLINK)) {
+		uint64_t	f;
+
+		f = ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
+		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+		ip->i_diflags2 |= tip->i_diflags2 & XFS_DIFLAG2_REFLINK;
+		tip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+		tip->i_diflags2 |= f & XFS_DIFLAG2_REFLINK;
+	}
+
+	/* Swap the cow forks. */
+	if (xfs_has_reflink(ip->i_mount)) {
+		ASSERT(!ip->i_cowfp ||
+		       ip->i_cowfp->if_format == XFS_DINODE_FMT_EXTENTS);
+		ASSERT(!tip->i_cowfp ||
+		       tip->i_cowfp->if_format == XFS_DINODE_FMT_EXTENTS);
+
+		swap(ip->i_cowfp, tip->i_cowfp);
+
+		if (ip->i_cowfp && ip->i_cowfp->if_bytes)
+			xfs_inode_set_cowblocks_tag(ip);
+		else
+			xfs_inode_clear_cowblocks_tag(ip);
+		if (tip->i_cowfp && tip->i_cowfp->if_bytes)
+			xfs_inode_set_cowblocks_tag(tip);
+		else
+			xfs_inode_clear_cowblocks_tag(tip);
+	}
+
+	xfs_trans_log_inode(*tpp, ip,  src_log_flags);
+	xfs_trans_log_inode(*tpp, tip, target_log_flags);
+
+	/*
+	 * The extent forks have been swapped, but crc=1,rmapbt=0 filesystems
+	 * have inode number owner values in the bmbt blocks that still refer to
+	 * the old inode. Scan each bmbt to fix up the owner values with the
+	 * inode number of the current inode.
+	 */
+	if (src_log_flags & XFS_ILOG_DOWNER) {
+		error = xfs_swap_change_owner(tpp, ip, tip);
+		if (error)
+			return error;
+	}
+	if (target_log_flags & XFS_ILOG_DOWNER) {
+		error = xfs_swap_change_owner(tpp, tip, ip);
+		if (error)
+			return error;
+	}
+
 	return 0;
 }
 
-/*
- * Fix up the owners of the bmbt blocks to refer to the current inode. The
- * change owner scan attempts to order all modified buffers in the current
- * transaction. In the event of ordered buffer failure, the offending buffer is
- * physically logged as a fallback and the scan returns -EAGAIN. We must roll
- * the transaction in this case to replenish the fallback log reservation and
- * restart the scan. This process repeats until the scan completes.
- */
-static int
-xfs_swap_change_owner(
-	struct xfs_trans	**tpp,
-	struct xfs_inode	*ip,
-	struct xfs_inode	*tmpip)
-{
-	int			error;
-	struct xfs_trans	*tp = *tpp;
-
-	do {
-		error = xfs_bmbt_change_owner(tp, ip, XFS_DATA_FORK, ip->i_ino,
-					      NULL);
-		/* success or fatal error */
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_trans_roll(tpp);
-		if (error)
-			break;
-		tp = *tpp;
-
-		/*
-		 * Redirty both inodes so they can relog and keep the log tail
-		 * moving forward.
-		 */
-		xfs_trans_ijoin(tp, ip, 0);
-		xfs_trans_ijoin(tp, tmpip, 0);
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		xfs_trans_log_inode(tp, tmpip, XFS_ILOG_CORE);
-	} while (true);
-
-	return error;
-}
-
 int
 xfs_swap_extents(
 	struct xfs_inode	*ip,	/* target inode */
@@ -1502,9 +1553,7 @@ xfs_swap_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	struct xfs_bstat	*sbp = &sxp->sx_stat;
-	int			src_log_flags, target_log_flags;
 	int			error = 0;
-	uint64_t		f;
 	int			resblks = 0;
 	unsigned int		flags = 0;
 	struct timespec64	ctime, mtime;
@@ -1637,9 +1686,6 @@ xfs_swap_extents(
 	 * recovery is going to see the fork as owned by the swapped inode,
 	 * not the pre-swapped inodes.
 	 */
-	src_log_flags = XFS_ILOG_CORE;
-	target_log_flags = XFS_ILOG_CORE;
-
 	if (xfs_has_rmapbt(mp)) {
 		struct xfs_swapext_req	req = {
 			.ip1		= tip,
@@ -1652,62 +1698,12 @@ xfs_swap_extents(
 		xfs_swapext(tp, &req);
 		error = xfs_defer_finish(&tp);
 	} else
-		error = xfs_swap_extent_forks(tp, ip, tip, &src_log_flags,
-				&target_log_flags);
+		error = xfs_swap_extent_forks(&tp, ip, tip);
 	if (error) {
 		trace_xfs_swap_extent_error(ip, error, _THIS_IP_);
 		goto out_trans_cancel;
 	}
 
-	/* Do we have to swap reflink flags? */
-	if ((ip->i_diflags2 & XFS_DIFLAG2_REFLINK) ^
-	    (tip->i_diflags2 & XFS_DIFLAG2_REFLINK)) {
-		f = ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
-		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
-		ip->i_diflags2 |= tip->i_diflags2 & XFS_DIFLAG2_REFLINK;
-		tip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
-		tip->i_diflags2 |= f & XFS_DIFLAG2_REFLINK;
-	}
-
-	/* Swap the cow forks. */
-	if (xfs_has_reflink(mp)) {
-		ASSERT(!ip->i_cowfp ||
-		       ip->i_cowfp->if_format == XFS_DINODE_FMT_EXTENTS);
-		ASSERT(!tip->i_cowfp ||
-		       tip->i_cowfp->if_format == XFS_DINODE_FMT_EXTENTS);
-
-		swap(ip->i_cowfp, tip->i_cowfp);
-
-		if (ip->i_cowfp && ip->i_cowfp->if_bytes)
-			xfs_inode_set_cowblocks_tag(ip);
-		else
-			xfs_inode_clear_cowblocks_tag(ip);
-		if (tip->i_cowfp && tip->i_cowfp->if_bytes)
-			xfs_inode_set_cowblocks_tag(tip);
-		else
-			xfs_inode_clear_cowblocks_tag(tip);
-	}
-
-	xfs_trans_log_inode(tp, ip,  src_log_flags);
-	xfs_trans_log_inode(tp, tip, target_log_flags);
-
-	/*
-	 * The extent forks have been swapped, but crc=1,rmapbt=0 filesystems
-	 * have inode number owner values in the bmbt blocks that still refer to
-	 * the old inode. Scan each bmbt to fix up the owner values with the
-	 * inode number of the current inode.
-	 */
-	if (src_log_flags & XFS_ILOG_DOWNER) {
-		error = xfs_swap_change_owner(&tp, ip, tip);
-		if (error)
-			goto out_trans_cancel;
-	}
-	if (target_log_flags & XFS_ILOG_DOWNER) {
-		error = xfs_swap_change_owner(&tp, tip, ip);
-		if (error)
-			goto out_trans_cancel;
-	}
-
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * transaction goes to disk before returning to the user.

