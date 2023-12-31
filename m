Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F15EC8CB
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RVd8Oirj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E40C433C8;
	Sun, 31 Dec 2023 21:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056743;
	bh=kdwv/G/DHsqH/KVRI80Ds0f1wTeE+glvaBDy40u8bdI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RVd8Oirj73r0lg+/8DFAT59EyKgYtIJ2UyYq+QD2fyZMhmMFNnF/cH4Jt+WxDI3pA
	 PnQUDTyVwFU49kZxyXm9wV69rVevDH5jscyOq+w637E6lYGrtQsb37pRPHyKn/4Nuz
	 GmZly5+ke9kQeyO5b55q6q4BzLVmE3io/0fu3Xtso8Uc7aopCHs+d2j3ZYWrAFHvFG
	 b+ZCNlHIVqpw83e+0RQyCjO3ldkMVx85rifS/sSRNwHBfbVaGX7wIMnDGy1hxqjp66
	 jzpAgIKoRZazgRakKTb5KCzb7khOavX5AHDNNKkCeB4+mpvPO8ZS5M3anq/wEXlyeo
	 lud2JCDOCfQbg==
Date: Sun, 31 Dec 2023 13:05:42 -0800
Subject: [PATCH 19/21] xfs: create libxfs helper to rename two directory
 entries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844359.1759932.10234262918061286927.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
References: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
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

Create a new libxfs function to rename two directory entries.  The
upcoming metadata directory feature will need this to replace a metadata
inode directory entry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |  217 +++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    3 
 fs/xfs/xfs_inode.c       |  288 ++++++++++------------------------------------
 3 files changed, 282 insertions(+), 226 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index f6b448d5fb0e4..0ec653d1d5b8d 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -23,6 +23,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_parent.h"
 #include "xfs_ag.h"
+#include "xfs_ialloc.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -1080,3 +1081,219 @@ xfs_dir_exchange_children(
 	return xfs_parent_replace(tp, du2->ppargs, dp2, name2, dp1, name1,
 			ip2);
 }
+
+/*
+ * Given an entry (@src_name, @src_ip) in directory @src_dp, make the entry
+ * @target_name in directory @target_dp point to @src_ip and remove the
+ * original entry, cleaning up everything left behind.
+ *
+ * Cleanup involves dropping a link count on @target_ip, and either removing
+ * the (@src_name, @src_ip) entry from @src_dp or simply replacing the entry
+ * with (@src_name, @wip) if a whiteout inode @wip is supplied.
+ *
+ * All inodes must have the ILOCK held.  We assume that if @src_ip is a
+ * directory then its '..' doesn't already point to @target_dp, and that @wip
+ * is a freshly allocated whiteout.
+ */
+int
+xfs_dir_rename_children(
+	struct xfs_trans	*tp,
+	struct xfs_dir_update	*du_src,
+	struct xfs_dir_update	*du_tgt,
+	unsigned int		spaceres,
+	struct xfs_dir_update	*du_wip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*src_dp = du_src->dp;
+	const struct xfs_name	*src_name = du_src->name;
+	struct xfs_inode	*src_ip = du_src->ip;
+	struct xfs_inode	*target_dp = du_tgt->dp;
+	const struct xfs_name	*target_name = du_tgt->name;
+	struct xfs_inode	*target_ip = du_tgt->ip;
+	bool			new_parent = (src_dp != target_dp);
+	bool			src_is_directory;
+	int			error;
+
+	src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
+
+	/*
+	 * Check for expected errors before we dirty the transaction
+	 * so we can return an error without a transaction abort.
+	 */
+	if (target_ip == NULL) {
+		/*
+		 * If there's no space reservation, check the entry will
+		 * fit before actually inserting it.
+		 */
+		if (!spaceres) {
+			error = xfs_dir_canenter(tp, target_dp, target_name);
+			if (error)
+				return error;
+		}
+	} else {
+		/*
+		 * If target exists and it's a directory, check that whether
+		 * it can be destroyed.
+		 */
+		if (S_ISDIR(VFS_I(target_ip)->i_mode) &&
+		    (!xfs_dir_isempty(target_ip) ||
+		     (VFS_I(target_ip)->i_nlink > 2)))
+			return -EEXIST;
+	}
+
+	/*
+	 * Directory entry creation below may acquire the AGF. Remove
+	 * the whiteout from the unlinked list first to preserve correct
+	 * AGI/AGF locking order. This dirties the transaction so failures
+	 * after this point will abort and log recovery will clean up the
+	 * mess.
+	 *
+	 * For whiteouts, we need to bump the link count on the whiteout
+	 * inode. After this point, we have a real link, clear the tmpfile
+	 * state flag from the inode so it doesn't accidentally get misused
+	 * in future.
+	 */
+	if (du_wip->ip) {
+		struct xfs_perag	*pag;
+
+		ASSERT(VFS_I(du_wip->ip)->i_nlink == 0);
+
+		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, du_wip->ip->i_ino));
+		error = xfs_iunlink_remove(tp, pag, du_wip->ip);
+		xfs_perag_put(pag);
+		if (error)
+			return error;
+
+		xfs_bumplink(tp, du_wip->ip);
+	}
+
+	/*
+	 * Set up the target.
+	 */
+	if (target_ip == NULL) {
+		/*
+		 * If target does not exist and the rename crosses
+		 * directories, adjust the target directory link count
+		 * to account for the ".." reference from the new entry.
+		 */
+		error = xfs_dir_createname(tp, target_dp, target_name,
+					   src_ip->i_ino, spaceres);
+		if (error)
+			return error;
+
+		xfs_trans_ichgtime(tp, target_dp,
+					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+		if (new_parent && src_is_directory) {
+			xfs_bumplink(tp, target_dp);
+		}
+	} else { /* target_ip != NULL */
+		/*
+		 * Link the source inode under the target name.
+		 * If the source inode is a directory and we are moving
+		 * it across directories, its ".." entry will be
+		 * inconsistent until we replace that down below.
+		 *
+		 * In case there is already an entry with the same
+		 * name at the destination directory, remove it first.
+		 */
+		error = xfs_dir_replace(tp, target_dp, target_name,
+					src_ip->i_ino, spaceres);
+		if (error)
+			return error;
+
+		xfs_trans_ichgtime(tp, target_dp,
+					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+		/*
+		 * Decrement the link count on the target since the target
+		 * dir no longer points to it.
+		 */
+		error = xfs_droplink(tp, target_ip);
+		if (error)
+			return error;
+
+		if (src_is_directory) {
+			/*
+			 * Drop the link from the old "." entry.
+			 */
+			error = xfs_droplink(tp, target_ip);
+			if (error)
+				return error;
+		}
+	} /* target_ip != NULL */
+
+	/*
+	 * Remove the source.
+	 */
+	if (new_parent && src_is_directory) {
+		/*
+		 * Rewrite the ".." entry to point to the new
+		 * directory.
+		 */
+		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
+					target_dp->i_ino, spaceres);
+		ASSERT(error != -EEXIST);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * We always want to hit the ctime on the source inode.
+	 *
+	 * This isn't strictly required by the standards since the source
+	 * inode isn't really being changed, but old unix file systems did
+	 * it and some incremental backup programs won't work without it.
+	 */
+	xfs_trans_ichgtime(tp, src_ip, XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
+
+	/*
+	 * Adjust the link count on src_dp.  This is necessary when
+	 * renaming a directory, either within one parent when
+	 * the target existed, or across two parent directories.
+	 */
+	if (src_is_directory && (new_parent || target_ip != NULL)) {
+
+		/*
+		 * Decrement link count on src_directory since the
+		 * entry that's moved no longer points to it.
+		 */
+		error = xfs_droplink(tp, src_dp);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * For whiteouts, we only need to update the source dirent with the
+	 * inode number of the whiteout inode rather than removing it
+	 * altogether.
+	 */
+	if (du_wip->ip)
+		error = xfs_dir_replace(tp, src_dp, src_name, du_wip->ip->i_ino,
+					spaceres);
+	else
+		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
+					   spaceres);
+	if (error)
+		return error;
+
+	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
+	if (new_parent)
+		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
+
+	/* Schedule parent pointer updates. */
+	error = xfs_parent_add(tp, du_wip->ppargs, src_dp, src_name,
+			du_wip->ip);
+	if (error)
+		return error;
+
+	error = xfs_parent_replace(tp, du_src->ppargs, src_dp, src_name,
+			target_dp, target_name, src_ip);
+	if (error)
+		return error;
+
+	return xfs_parent_remove(tp, du_tgt->ppargs, target_dp, target_name,
+			target_ip);
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index dbca60ec93462..5e8b18f3f0036 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -311,5 +311,8 @@ int xfs_dir_remove_child(struct xfs_trans *tp, unsigned int resblks,
 
 int xfs_dir_exchange_children(struct xfs_trans *tp, struct xfs_dir_update *du1,
 		struct xfs_dir_update *du2, unsigned int spaceres);
+int xfs_dir_rename_children(struct xfs_trans *tp, struct xfs_dir_update *du_src,
+		struct xfs_dir_update *du_tgt, unsigned int spaceres,
+		struct xfs_dir_update *du_wip);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1eb92c05d8b78..1a87ccf4e0474 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2358,29 +2358,37 @@ xfs_rename_alloc_whiteout(
  */
 int
 xfs_rename(
-	struct mnt_idmap	*idmap,
-	struct xfs_inode	*src_dp,
-	struct xfs_name		*src_name,
-	struct xfs_inode	*src_ip,
-	struct xfs_inode	*target_dp,
-	struct xfs_name		*target_name,
-	struct xfs_inode	*target_ip,
-	unsigned int		flags)
+	struct mnt_idmap		*idmap,
+	struct xfs_inode		*src_dp,
+	struct xfs_name			*src_name,
+	struct xfs_inode		*src_ip,
+	struct xfs_inode		*target_dp,
+	struct xfs_name			*target_name,
+	struct xfs_inode		*target_ip,
+	unsigned int			flags)
 {
-	struct xfs_mount	*mp = src_dp->i_mount;
-	struct xfs_trans	*tp;
-	struct xfs_inode	*wip = NULL;		/* whiteout inode */
-	struct xfs_inode	*inodes[__XFS_SORT_INODES];
-	struct xfs_parent_args	*src_ppargs = NULL;
-	struct xfs_parent_args	*tgt_ppargs = NULL;
-	struct xfs_parent_args	*wip_ppargs = NULL;
-	int			i;
-	int			num_inodes = __XFS_SORT_INODES;
-	bool			new_parent = (src_dp != target_dp);
-	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
-	int			spaceres;
-	bool			retried = false;
-	int			error, nospace_error = 0;
+	struct xfs_dir_update		du_src = {
+		.dp			= src_dp,
+		.name			= src_name,
+		.ip			= src_ip,
+	};
+	struct xfs_dir_update		du_tgt = {
+		.dp			= target_dp,
+		.name			= target_name,
+		.ip			= target_ip,
+	};
+	struct xfs_dir_update		du_wip = { };
+	struct xfs_mount		*mp = src_dp->i_mount;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*inodes[__XFS_SORT_INODES];
+	int				i;
+	int				num_inodes = __XFS_SORT_INODES;
+	bool				new_parent = (src_dp != target_dp);
+	bool				src_is_directory =
+						S_ISDIR(VFS_I(src_ip)->i_mode);
+	int				spaceres;
+	bool				retried = false;
+	int				error, nospace_error = 0;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -2393,8 +2401,8 @@ xfs_rename(
 	 * appropriately.
 	 */
 	if (flags & RENAME_WHITEOUT) {
-		error = xfs_rename_alloc_whiteout(idmap, src_name,
-						  target_dp, &wip);
+		error = xfs_rename_alloc_whiteout(idmap, src_name, target_dp,
+				&du_wip.ip);
 		if (error)
 			return error;
 
@@ -2402,21 +2410,21 @@ xfs_rename(
 		src_name->type = XFS_DIR3_FT_CHRDEV;
 	}
 
-	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
-				inodes, &num_inodes);
+	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, du_wip.ip,
+			inodes, &num_inodes);
 
-	error = xfs_parent_start(mp, &src_ppargs);
+	error = xfs_parent_start(mp, &du_src.ppargs);
 	if (error)
 		goto out_release_wip;
 
-	if (wip) {
-		error = xfs_parent_start(mp, &wip_ppargs);
+	if (du_wip.ip) {
+		error = xfs_parent_start(mp, &du_wip.ppargs);
 		if (error)
 			goto out_src_ppargs;
 	}
 
 	if (target_ip) {
-		error = xfs_parent_start(mp, &tgt_ppargs);
+		error = xfs_parent_start(mp, &du_tgt.ppargs);
 		if (error)
 			goto out_wip_ppargs;
 	}
@@ -2424,7 +2432,7 @@ xfs_rename(
 retry:
 	nospace_error = 0;
 	spaceres = xfs_rename_space_res(mp, src_name->len, target_ip != NULL,
-			target_name->len, wip != NULL);
+			target_name->len, du_wip.ip != NULL);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
 	if (error == -ENOSPC) {
 		nospace_error = error;
@@ -2439,7 +2447,7 @@ xfs_rename(
 	 * We don't allow reservationless renaming when parent pointers are
 	 * enabled because we can't back out if the xattrs must grow.
 	 */
-	if (src_ppargs && nospace_error) {
+	if (du_src.ppargs && nospace_error) {
 		error = nospace_error;
 		xfs_trans_cancel(tp);
 		goto out_tgt_ppargs;
@@ -2471,8 +2479,8 @@ xfs_rename(
 	xfs_trans_ijoin(tp, src_ip, 0);
 	if (target_ip)
 		xfs_trans_ijoin(tp, target_ip, 0);
-	if (wip)
-		xfs_trans_ijoin(tp, wip, 0);
+	if (du_wip.ip)
+		xfs_trans_ijoin(tp, du_wip.ip, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
@@ -2488,8 +2496,8 @@ xfs_rename(
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE) {
 		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
-				src_ppargs, target_dp, target_name, target_ip,
-				tgt_ppargs, spaceres);
+				du_src.ppargs, target_dp, target_name,
+				target_ip, du_tgt.ppargs, spaceres);
 		nospace_error = 0;
 		goto out_unlock;
 	}
@@ -2524,38 +2532,11 @@ xfs_rename(
 	 * We don't allow quotaless renaming when parent pointers are enabled
 	 * because we can't back out if the xattrs must grow.
 	 */
-	if (src_ppargs && nospace_error) {
+	if (du_src.ppargs && nospace_error) {
 		error = nospace_error;
 		goto out_trans_cancel;
 	}
 
-	/*
-	 * Check for expected errors before we dirty the transaction
-	 * so we can return an error without a transaction abort.
-	 */
-	if (target_ip == NULL) {
-		/*
-		 * If there's no space reservation, check the entry will
-		 * fit before actually inserting it.
-		 */
-		if (!spaceres) {
-			error = xfs_dir_canenter(tp, target_dp, target_name);
-			if (error)
-				goto out_trans_cancel;
-		}
-	} else {
-		/*
-		 * If target exists and it's a directory, check that whether
-		 * it can be destroyed.
-		 */
-		if (S_ISDIR(VFS_I(target_ip)->i_mode) &&
-		    (!xfs_dir_isempty(target_ip) ||
-		     (VFS_I(target_ip)->i_nlink > 2))) {
-			error = -EEXIST;
-			goto out_trans_cancel;
-		}
-	}
-
 	/*
 	 * Lock the AGI buffers we need to handle bumping the nlink of the
 	 * whiteout inode off the unlinked list and to handle dropping the
@@ -2567,7 +2548,7 @@ xfs_rename(
 	 * target_ip is either null or an empty directory.
 	 */
 	for (i = 0; i < num_inodes && inodes[i] != NULL; i++) {
-		if (inodes[i] == wip ||
+		if (inodes[i] == du_wip.ip ||
 		    (inodes[i] == target_ip &&
 		     (VFS_I(target_ip)->i_nlink == 1 || src_is_directory))) {
 			struct xfs_perag	*pag;
@@ -2582,165 +2563,20 @@ xfs_rename(
 		}
 	}
 
-	/*
-	 * Directory entry creation below may acquire the AGF. Remove
-	 * the whiteout from the unlinked list first to preserve correct
-	 * AGI/AGF locking order. This dirties the transaction so failures
-	 * after this point will abort and log recovery will clean up the
-	 * mess.
-	 *
-	 * For whiteouts, we need to bump the link count on the whiteout
-	 * inode. After this point, we have a real link, clear the tmpfile
-	 * state flag from the inode so it doesn't accidentally get misused
-	 * in future.
-	 */
-	if (wip) {
-		struct xfs_perag	*pag;
-
-		ASSERT(VFS_I(wip)->i_nlink == 0);
-
-		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, wip->i_ino));
-		error = xfs_iunlink_remove(tp, pag, wip);
-		xfs_perag_put(pag);
-		if (error)
-			goto out_trans_cancel;
-
-		xfs_bumplink(tp, wip);
-		VFS_I(wip)->i_state &= ~I_LINKABLE;
-	}
-
-	/*
-	 * Set up the target.
-	 */
-	if (target_ip == NULL) {
-		/*
-		 * If target does not exist and the rename crosses
-		 * directories, adjust the target directory link count
-		 * to account for the ".." reference from the new entry.
-		 */
-		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres);
-		if (error)
-			goto out_trans_cancel;
-
-		xfs_trans_ichgtime(tp, target_dp,
-					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
-		if (new_parent && src_is_directory) {
-			xfs_bumplink(tp, target_dp);
-		}
-	} else { /* target_ip != NULL */
-		/*
-		 * Link the source inode under the target name.
-		 * If the source inode is a directory and we are moving
-		 * it across directories, its ".." entry will be
-		 * inconsistent until we replace that down below.
-		 *
-		 * In case there is already an entry with the same
-		 * name at the destination directory, remove it first.
-		 */
-		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
-		if (error)
-			goto out_trans_cancel;
-
-		xfs_trans_ichgtime(tp, target_dp,
-					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
-		/*
-		 * Decrement the link count on the target since the target
-		 * dir no longer points to it.
-		 */
-		error = xfs_droplink(tp, target_ip);
-		if (error)
-			goto out_trans_cancel;
-
-		if (src_is_directory) {
-			/*
-			 * Drop the link from the old "." entry.
-			 */
-			error = xfs_droplink(tp, target_ip);
-			if (error)
-				goto out_trans_cancel;
-		}
-	} /* target_ip != NULL */
-
-	/*
-	 * Remove the source.
-	 */
-	if (new_parent && src_is_directory) {
-		/*
-		 * Rewrite the ".." entry to point to the new
-		 * directory.
-		 */
-		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
-		ASSERT(error != -EEXIST);
-		if (error)
-			goto out_trans_cancel;
-	}
-
-	/*
-	 * We always want to hit the ctime on the source inode.
-	 *
-	 * This isn't strictly required by the standards since the source
-	 * inode isn't really being changed, but old unix file systems did
-	 * it and some incremental backup programs won't work without it.
-	 */
-	xfs_trans_ichgtime(tp, src_ip, XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
-
-	/*
-	 * Adjust the link count on src_dp.  This is necessary when
-	 * renaming a directory, either within one parent when
-	 * the target existed, or across two parent directories.
-	 */
-	if (src_is_directory && (new_parent || target_ip != NULL)) {
+	error = xfs_dir_rename_children(tp, &du_src, &du_tgt, spaceres,
+			&du_wip);
+	if (error)
+		goto out_trans_cancel;
 
+	if (du_wip.ip) {
 		/*
-		 * Decrement link count on src_directory since the
-		 * entry that's moved no longer points to it.
+		 * Now we have a real link, clear the "I'm a tmpfile" state
+		 * flag from the inode so it doesn't accidentally get misused in
+		 * future.
 		 */
-		error = xfs_droplink(tp, src_dp);
-		if (error)
-			goto out_trans_cancel;
+		VFS_I(du_wip.ip)->i_state &= ~I_LINKABLE;
 	}
 
-	/*
-	 * For whiteouts, we only need to update the source dirent with the
-	 * inode number of the whiteout inode rather than removing it
-	 * altogether.
-	 */
-	if (wip)
-		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres);
-	else
-		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres);
-
-	if (error)
-		goto out_trans_cancel;
-
-	/* Schedule parent pointer updates. */
-	error = xfs_parent_add(tp, wip_ppargs, src_dp, src_name, wip);
-	if (error)
-		goto out_trans_cancel;
-
-	error = xfs_parent_replace(tp, src_ppargs, src_dp, src_name, target_dp,
-			target_name, src_ip);
-	if (error)
-		goto out_trans_cancel;
-
-	error = xfs_parent_remove(tp, tgt_ppargs, target_dp, target_name,
-			target_ip);
-	if (error)
-		goto out_trans_cancel;
-
-	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
-	if (new_parent)
-		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
-
 	/*
 	 * Inform our hook clients that we've finished a rename operation as
 	 * follows: removed the source and target files from their directories;
@@ -2753,8 +2589,8 @@ xfs_rename(
 		xfs_dir_update_hook(target_dp, target_ip, -1, target_name);
 	xfs_dir_update_hook(src_dp, src_ip, -1, src_name);
 	xfs_dir_update_hook(target_dp, src_ip, 1, target_name);
-	if (wip)
-		xfs_dir_update_hook(src_dp, wip, 1, src_name);
+	if (du_wip.ip)
+		xfs_dir_update_hook(src_dp, du_wip.ip, 1, src_name);
 
 	error = xfs_finish_rename(tp);
 	nospace_error = 0;
@@ -2765,14 +2601,14 @@ xfs_rename(
 out_unlock:
 	xfs_iunlock_rename(inodes, num_inodes);
 out_tgt_ppargs:
-	xfs_parent_finish(mp, tgt_ppargs);
+	xfs_parent_finish(mp, du_tgt.ppargs);
 out_wip_ppargs:
-	xfs_parent_finish(mp, wip_ppargs);
+	xfs_parent_finish(mp, du_wip.ppargs);
 out_src_ppargs:
-	xfs_parent_finish(mp, src_ppargs);
+	xfs_parent_finish(mp, du_src.ppargs);
 out_release_wip:
-	if (wip)
-		xfs_irele(wip);
+	if (du_wip.ip)
+		xfs_irele(du_wip.ip);
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
 	return error;

