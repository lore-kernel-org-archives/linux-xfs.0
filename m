Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3759BA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OVpE05yM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909C1C433C8;
	Sun, 31 Dec 2023 20:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054536;
	bh=uT1DFpHDrRcjXEUCGa964QNWB4yQsXfhV0m9+UqLPDE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OVpE05yMWEKW+NgTf/+2uvrtwxtWL1SNC9q0tKKo4087VLtrQ+5QiJYtv5Gl10oqV
	 jkCce47d6GsE0bCQEcQvbd2YO/X6bJG8vaaiTkJy8DoI747ZK0oViD6E7+i8LsWT42
	 uOuAP3ShFKwggjIzQGakVquTOgtgpMF9aDrZ8yfU5QVQL7LVd7lD1igDRNiiHP4jkk
	 NA5VcMvobUA/oDYmYf7Y2hhUnXlcB1LiBe2miXJtPTgG9Khk9wrHdI0Bx/p7jo9flK
	 8CKDzf1FHAMzfdFG+V/MpZkpctrv4Q9wKqOe5ZI92/lxONdoK4dFGF71Cb+MmQce+K
	 nC5xFBDvWZR9A==
Date: Sun, 31 Dec 2023 12:28:56 -0800
Subject: [PATCH 18/25] xfs: allow xfs_swap_range to use older extent swap
 algorithms
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833430.1750288.9653515546607359144.stgit@frogsfrogsfrogs>
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

If userspace permits non-atomic swap operations, use the older code
paths to implement the same functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |    4 +-
 fs/xfs/xfs_bmap_util.h |    4 ++
 fs/xfs/xfs_xchgrange.c |  123 ++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 118 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c6d8d061c998b..405d02e71ab65 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1255,7 +1255,7 @@ xfs_insert_file_space(
  * reject and log the attempt. basically we are putting the responsibility on
  * userspace to get this right.
  */
-static int
+int
 xfs_swap_extents_check_format(
 	struct xfs_inode	*ip,	/* target inode */
 	struct xfs_inode	*tip)	/* tmp inode */
@@ -1397,7 +1397,7 @@ xfs_swap_change_owner(
 }
 
 /* Swap the extents of two files by swapping data forks. */
-STATIC int
+int
 xfs_swap_extent_forks(
 	struct xfs_trans	**tpp,
 	struct xfs_swapext_req	*req)
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 6888078f5c31e..39c71da08403c 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -69,6 +69,10 @@ int	xfs_free_eofblocks(struct xfs_inode *ip);
 int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
 			 struct xfs_swapext *sx);
 
+struct xfs_swapext_req;
+int xfs_swap_extent_forks(struct xfs_trans **tpp, struct xfs_swapext_req *req);
+int xfs_swap_extents_check_format(struct xfs_inode *ip, struct xfs_inode *tip);
+
 xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
 
 xfs_extnum_t xfs_bmap_count_leaves(struct xfs_ifork *ifp, xfs_filblks_t *count);
diff --git a/fs/xfs/xfs_xchgrange.c b/fs/xfs/xfs_xchgrange.c
index 835e83c90f7f5..328217551c1e8 100644
--- a/fs/xfs/xfs_xchgrange.c
+++ b/fs/xfs/xfs_xchgrange.c
@@ -712,6 +712,65 @@ xfs_xchg_range_rele_log_assist(
 		xlog_drop_incompat_feat(mp->m_log, XLOG_INCOMPAT_FEAT_SWAPEXT);
 }
 
+/*
+ * Can we use xfs_swapext() to perform the exchange?
+ *
+ * The swapext state tracking mechanism uses deferred bmap log intent (BUI)
+ * items to swap extents between file forks, and it /can/ track the overall
+ * operation status over a file range using swapext log intent (SXI) items.
+ */
+static inline bool
+xfs_xchg_use_swapext(
+	struct xfs_mount	*mp,
+	unsigned int		xchg_flags)
+{
+	/*
+	 * If the caller got permission from the log to use SXI items, we will
+	 * use xfs_swapext with both log items.
+	 */
+	if (xchg_flags & XFS_XCHG_RANGE_LOGGED)
+		return true;
+
+	/*
+	 * If the caller didn't get permission to use SXI items, then userspace
+	 * must have allowed non-atomic swap mode.  Use the state tracking in
+	 * xfs_swapext to log BUI log items if the fs supports rmap or reflink.
+	 */
+	return xfs_swapext_supports_nonatomic(mp);
+}
+
+/*
+ * Can we use the old data fork swapping to perform the exchange?
+ *
+ * Userspace must be asking for a full swap of two files with the same file
+ * size and cannot require atomic mode.
+ */
+static inline bool
+xfs_xchg_use_forkswap(
+	const struct xfs_exch_range	*fxr,
+	struct xfs_inode		*ip1,
+	struct xfs_inode		*ip2)
+{
+	if (!(fxr->flags & XFS_EXCH_RANGE_NONATOMIC))
+		return false;
+	if (!(fxr->flags & XFS_EXCH_RANGE_FULL_FILES))
+		return false;
+	if (fxr->flags & XFS_EXCH_RANGE_TO_EOF)
+		return false;
+	if (fxr->file1_offset != 0 || fxr->file2_offset != 0)
+		return false;
+	if (fxr->length != ip1->i_disk_size)
+		return false;
+	if (fxr->length != ip2->i_disk_size)
+		return false;
+	return true;
+}
+
+enum xchg_strategy {
+	SWAPEXT		= 1,	/* xfs_swapext() */
+	FORKSWAP	= 2,	/* exchange forks */
+};
+
 /* Exchange the contents of two files. */
 int
 xfs_xchg_range(
@@ -731,20 +790,13 @@ xfs_xchg_range(
 	};
 	struct xfs_trans		*tp;
 	unsigned int			qretry;
+	unsigned int			flags = 0;
 	bool				retried = false;
+	enum xchg_strategy		strategy;
 	int				error;
 
 	trace_xfs_xchg_range(ip1, fxr, ip2, xchg_flags);
 
-	/*
-	 * This function only supports using log intent items (SXI items if
-	 * atomic exchange is required, or BUI items if not) to exchange file
-	 * data.  The legacy whole-fork swap will be ported in a later patch.
-	 */
-	if (!(xchg_flags & XFS_XCHG_RANGE_LOGGED) &&
-	    !xfs_swapext_supports_nonatomic(mp))
-		return -EOPNOTSUPP;
-
 	if (fxr->flags & XFS_EXCH_RANGE_TO_EOF)
 		req.req_flags |= XFS_SWAP_REQ_SET_SIZES;
 	if (fxr->flags & XFS_EXCH_RANGE_FILE1_WRITTEN)
@@ -756,10 +808,25 @@ xfs_xchg_range(
 	if (error)
 		return error;
 
+	/*
+	 * We haven't decided which exchange strategy we want to use yet, but
+	 * here we must choose if we want freed blocks during the swap to be
+	 * added to the transaction block reservation (RES_FDBLKS) or freed
+	 * into the global fdblocks.  The legacy fork swap mechanism doesn't
+	 * free any blocks, so it doesn't require it.  It is also the only
+	 * option that works for older filesystems.
+	 *
+	 * The bmap log intent items that were added with rmap and reflink can
+	 * change the bmbt shape, so the intent-based swap strategies require
+	 * us to set RES_FDBLKS.
+	 */
+	if (xfs_has_lazysbcount(mp))
+		flags |= XFS_TRANS_RES_FDBLKS;
+
 retry:
 	/* Allocate the transaction, lock the inodes, and join them. */
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, req.resblks, 0,
-			XFS_TRANS_RES_FDBLKS, &tp);
+			flags, &tp);
 	if (error)
 		return error;
 
@@ -802,6 +869,30 @@ xfs_xchg_range(
 	if (error)
 		goto out_trans_cancel;
 
+	if (xfs_xchg_use_swapext(mp, xchg_flags)) {
+		/* Exchange the file contents with our fancy state tracking. */
+		strategy = SWAPEXT;
+	} else if (xfs_xchg_use_forkswap(fxr, ip1, ip2)) {
+		/*
+		 * Exchange the file contents by using the old bmap fork
+		 * exchange code, if we're a defrag tool doing a full file
+		 * swap.
+		 */
+		strategy = FORKSWAP;
+
+		error = xfs_swap_extents_check_format(ip2, ip1);
+		if (error) {
+			xfs_notice(mp,
+		"%s: inode 0x%llx format is incompatible for exchanging.",
+					__func__, ip2->i_ino);
+			goto out_trans_cancel;
+		}
+	} else {
+		/* We cannot exchange the file contents. */
+		error = -EOPNOTSUPP;
+		goto out_trans_cancel;
+	}
+
 	/* If we got this far on a dry run, all parameters are ok. */
 	if (fxr->flags & XFS_EXCH_RANGE_DRY_RUN)
 		goto out_trans_cancel;
@@ -814,7 +905,17 @@ xfs_xchg_range(
 		xfs_trans_ichgtime(tp, ip2,
 				XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
-	xfs_swapext(tp, &req);
+	switch (strategy) {
+	case SWAPEXT:
+		xfs_swapext(tp, &req);
+		error = 0;
+		break;
+	case FORKSWAP:
+		error = xfs_swap_extent_forks(&tp, &req);
+		break;
+	}
+	if (error)
+		goto out_trans_cancel;
 
 	/*
 	 * Force the log to persist metadata updates if the caller or the

