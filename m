Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE1C39856
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924555; cv=none; b=XpTALFn6t632YmR0j1KLrvVM3OlQffb6Xez9oysWRJVmoRxBFRU4BDxGGZZSJD3sYJj5FJsB/CZuQQ0+J45Lgh3tT4GjQJSYi2xDi7hpnIsU9FFWjx/CLs1PZLSX/blciyD8g7zRGHyMFXVbSpbe5/WoYybE9IDR+nUt8FH7kqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924555; c=relaxed/simple;
	bh=7dVGl+lud3IarO0FE4qbQ+TPuRH+7ceU2ZghOPl5wUo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EfMMmx9dFgZOawpwf+ZV03FPXJyrJBPW+XmYiXLWrAAsBDNcTp83sIsMkJ4wl1pB3ruYXJvqIOBMu5jChs+m/oz22/7/7S+yoZFqQCwT6QB14fmm+DCrscWwVIcUSmc07C2jxZ3q1Nfe1quiwbq4LYB7Gf2dyrS/UfyM6M2jshI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qJlJfkMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qJlJfkMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06749C2BD10;
	Thu, 20 Jun 2024 23:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924555;
	bh=7dVGl+lud3IarO0FE4qbQ+TPuRH+7ceU2ZghOPl5wUo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qJlJfkMGNXyzuWAyo1U10ecCaioup8aff/Bm4GrNz6o/tgguW87Sgw1QIV538O/t1
	 NEjwPjNWcw3w8WRpbuODrycTHPuUpRz9sZUKdRV9A9iwcb1ocU9+MeQogmP1M9Do22
	 cFDNpAH1Br8+AV2yavZC/XAE+J1o8rsVeqIMukcutoCxRpHzNEntzt6vjHZGuYK5iG
	 SLCBmELivchurT6J4ltW8ibiyVENp3Nm8e23L6ev/3CI4+8IxDF5NhrCGHM9uCBWse
	 toiJCfZIimH4DDl9v34ePvlEyVrYJ03eMZMn+8FoExjWR9UaWhYXM95LgMK3EPPWlb
	 4EVtH/8tl0pFw==
Date: Thu, 20 Jun 2024 16:02:34 -0700
Subject: [PATCH 16/24] xfs: create libxfs helper to link a new inode into a
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418173.3183075.477214909437232970.stgit@frogsfrogsfrogs>
In-Reply-To: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
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

Create a new libxfs function to link a newly created inode into a
directory.  The upcoming metadata directory feature will need this to
create a metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |   53 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |   12 ++++++++++
 fs/xfs/xfs_inode.c       |   57 +++++++++++++++-------------------------------
 fs/xfs/xfs_symlink.c     |   45 +++++++++++++++---------------------
 4 files changed, 102 insertions(+), 65 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 457f9a38f8504..bbed03441f5cc 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -19,6 +19,9 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_health.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_parent.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -756,3 +759,53 @@ xfs_dir2_compname(
 		return xfs_ascii_ci_compname(args, name, len);
 	return xfs_da_compname(args, name, len);
 }
+
+/*
+ * Given a directory @dp, a newly allocated inode @ip, and a @name, link @ip
+ * into @dp under the given @name.  If @ip is a directory, it will be
+ * initialized.  Both inodes must have the ILOCK held and the transaction must
+ * have sufficient blocks reserved.
+ */
+int
+xfs_dir_create_child(
+	struct xfs_trans	*tp,
+	unsigned int		resblks,
+	struct xfs_dir_update	*du)
+{
+	struct xfs_inode	*dp = du->dp;
+	const struct xfs_name	*name = du->name;
+	struct xfs_inode	*ip = du->ip;
+	int			error;
+
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
+	xfs_assert_ilocked(dp, XFS_ILOCK_EXCL);
+
+	error = xfs_dir_createname(tp, dp, name, ip->i_ino, resblks);
+	if (error) {
+		ASSERT(error != -ENOSPC);
+		return error;
+	}
+
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
+		error = xfs_dir_init(tp, ip, dp);
+		if (error)
+			return error;
+
+		xfs_bumplink(tp, dp);
+	}
+
+	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now.
+	 */
+	if (du->ppargs) {
+		error = xfs_parent_addname(tp, du->ppargs, dp, name, ip);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 6dbe6e9ecb491..a1ba6fd0a725f 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -309,4 +309,16 @@ static inline unsigned char xfs_ascii_ci_xfrm(unsigned char c)
 	return c;
 }
 
+struct xfs_parent_args;
+
+struct xfs_dir_update {
+	struct xfs_inode	*dp;
+	const struct xfs_name	*name;
+	struct xfs_inode	*ip;
+	struct xfs_parent_args	*ppargs;
+};
+
+int xfs_dir_create_child(struct xfs_trans *tp, unsigned int resblks,
+		struct xfs_dir_update *du);
+
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index dd8e189175d53..37f2ac96b7fbe 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -714,14 +714,16 @@ xfs_create(
 	struct xfs_inode	**ipp)
 {
 	struct xfs_inode	*dp = args->pip;
+	struct xfs_dir_update	du = {
+		.dp		= dp,
+		.name		= name,
+	};
 	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	struct xfs_dquot	*udqp;
 	struct xfs_dquot	*gdqp;
 	struct xfs_dquot	*pdqp;
 	struct xfs_trans_res	*tres;
-	struct xfs_parent_args	*ppargs;
 	xfs_ino_t		ino;
 	bool			unlock_dp_on_error = false;
 	bool			is_dir = S_ISDIR(args->mode);
@@ -748,7 +750,7 @@ xfs_create(
 		tres = &M_RES(mp)->tr_create;
 	}
 
-	error = xfs_parent_start(mp, &ppargs);
+	error = xfs_parent_start(mp, &du.ppargs);
 	if (error)
 		goto out_release_dquots;
 
@@ -779,7 +781,7 @@ xfs_create(
 	 */
 	error = xfs_dialloc(&tp, dp->i_ino, args->mode, &ino);
 	if (!error)
-		error = xfs_icreate(tp, ino, args, &ip);
+		error = xfs_icreate(tp, ino, args, &du.ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -792,38 +794,15 @@ xfs_create(
 	 */
 	xfs_trans_ijoin(tp, dp, 0);
 
-	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					resblks - XFS_IALLOC_SPACE_RES(mp));
-	if (error) {
-		ASSERT(error != -ENOSPC);
+	error = xfs_dir_create_child(tp, resblks, &du);
+	if (error)
 		goto out_trans_cancel;
-	}
-	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
-
-	if (is_dir) {
-		error = xfs_dir_init(tp, ip, dp);
-		if (error)
-			goto out_trans_cancel;
-
-		xfs_bumplink(tp, dp);
-	}
-
-	/*
-	 * If we have parent pointers, we need to add the attribute containing
-	 * the parent information now.
-	 */
-	if (ppargs) {
-		error = xfs_parent_addname(tp, ppargs, dp, name, ip);
-		if (error)
-			goto out_trans_cancel;
-	}
 
 	/*
 	 * Create ip with a reference from dp, and add '.' and '..' references
 	 * if it's a directory.
 	 */
-	xfs_dir_update_hook(dp, ip, 1, name);
+	xfs_dir_update_hook(dp, du.ip, 1, name);
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -838,7 +817,7 @@ xfs_create(
 	 * These ids of the inode couldn't have changed since the new
 	 * inode has been locked ever since it was created.
 	 */
-	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
+	xfs_qm_vop_create_dqattach(tp, du.ip, udqp, gdqp, pdqp);
 
 	error = xfs_trans_commit(tp);
 	if (error)
@@ -848,10 +827,10 @@ xfs_create(
 	xfs_qm_dqrele(gdqp);
 	xfs_qm_dqrele(pdqp);
 
-	*ipp = ip;
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	*ipp = du.ip;
+	xfs_iunlock(du.ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	xfs_parent_finish(mp, ppargs);
+	xfs_parent_finish(mp, du.ppargs);
 	return 0;
 
  out_trans_cancel:
@@ -862,13 +841,13 @@ xfs_create(
 	 * setup of the inode and release the inode.  This prevents recursive
 	 * transactions and deadlocks from xfs_inactive.
 	 */
-	if (ip) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_finish_inode_setup(ip);
-		xfs_irele(ip);
+	if (du.ip) {
+		xfs_iunlock(du.ip, XFS_ILOCK_EXCL);
+		xfs_finish_inode_setup(du.ip);
+		xfs_irele(du.ip);
 	}
  out_parent:
-	xfs_parent_finish(mp, ppargs);
+	xfs_parent_finish(mp, du.ppargs);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index e471369f6b634..c0f5c2e1f215b 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -95,8 +95,11 @@ xfs_symlink(
 		.pip		= dp,
 		.mode		= S_IFLNK | (mode & ~S_IFMT),
 	};
+	struct xfs_dir_update	du = {
+		.dp		= dp,
+		.name		= link_name,
+	};
 	struct xfs_trans	*tp = NULL;
-	struct xfs_inode	*ip = NULL;
 	int			error = 0;
 	int			pathlen;
 	bool                    unlock_dp_on_error = false;
@@ -106,7 +109,6 @@ xfs_symlink(
 	struct xfs_dquot	*pdqp;
 	uint			resblks;
 	xfs_ino_t		ino;
-	struct xfs_parent_args	*ppargs;
 
 	*ipp = NULL;
 
@@ -140,7 +142,7 @@ xfs_symlink(
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
 	resblks = xfs_symlink_space_res(mp, link_name->len, fs_blocks);
 
-	error = xfs_parent_start(mp, &ppargs);
+	error = xfs_parent_start(mp, &du.ppargs);
 	if (error)
 		goto out_release_dquots;
 
@@ -165,7 +167,7 @@ xfs_symlink(
 	 */
 	error = xfs_dialloc(&tp, dp->i_ino, S_IFLNK, &ino);
 	if (!error)
-		error = xfs_icreate(tp, ino, &args, &ip);
+		error = xfs_icreate(tp, ino, &args, &du.ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -181,33 +183,24 @@ xfs_symlink(
 	/*
 	 * Also attach the dquot(s) to it, if applicable.
 	 */
-	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
+	xfs_qm_vop_create_dqattach(tp, du.ip, udqp, gdqp, pdqp);
 
 	resblks -= XFS_IALLOC_SPACE_RES(mp);
-	error = xfs_symlink_write_target(tp, ip, ip->i_ino, target_path,
+	error = xfs_symlink_write_target(tp, du.ip, du.ip->i_ino, target_path,
 			pathlen, fs_blocks, resblks);
 	if (error)
 		goto out_trans_cancel;
 	resblks -= fs_blocks;
-	i_size_write(VFS_I(ip), ip->i_disk_size);
+	i_size_write(VFS_I(du.ip), du.ip->i_disk_size);
 
 	/*
 	 * Create the directory entry for the symlink.
 	 */
-	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino, resblks);
+	error = xfs_dir_create_child(tp, resblks, &du);
 	if (error)
 		goto out_trans_cancel;
-	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
-	/* Add parent pointer for the new symlink. */
-	if (ppargs) {
-		error = xfs_parent_addname(tp, ppargs, dp, link_name, ip);
-		if (error)
-			goto out_trans_cancel;
-	}
-
-	xfs_dir_update_hook(dp, ip, 1, link_name);
+	xfs_dir_update_hook(dp, du.ip, 1, link_name);
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -225,10 +218,10 @@ xfs_symlink(
 	xfs_qm_dqrele(gdqp);
 	xfs_qm_dqrele(pdqp);
 
-	*ipp = ip;
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	*ipp = du.ip;
+	xfs_iunlock(du.ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	xfs_parent_finish(mp, ppargs);
+	xfs_parent_finish(mp, du.ppargs);
 	return 0;
 
 out_trans_cancel:
@@ -239,13 +232,13 @@ xfs_symlink(
 	 * setup of the inode and release the inode.  This prevents recursive
 	 * transactions and deadlocks from xfs_inactive.
 	 */
-	if (ip) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_finish_inode_setup(ip);
-		xfs_irele(ip);
+	if (du.ip) {
+		xfs_iunlock(du.ip, XFS_ILOCK_EXCL);
+		xfs_finish_inode_setup(du.ip);
+		xfs_irele(du.ip);
 	}
 out_parent:
-	xfs_parent_finish(mp, ppargs);
+	xfs_parent_finish(mp, du.ppargs);
 out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);

