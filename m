Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90EABA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BdqXtFHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDF5C433C8;
	Sun, 31 Dec 2023 21:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056664;
	bh=l538ZIPZ7n7320HhviSNjoUxYCi2v+BtTRhlbhArKXE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BdqXtFHRG/ZczOdx7dZQE+QVHsCImpUIgbFoqTRmrmdUqVqIb8Xhnxu7Tez4zsIDC
	 +teL8ImkxaE5sgCHA8ix0lMxMf0SKeTBPLVE6YL//EyStVjEmihfpuDs8Ho/g4lbPf
	 IB2h6j3Xc7KDRp/A4C3RRPayAVXZ1Z1s5ii5wL/ceTxjoM15CSGdz23zaPzT4rp3GU
	 bfHnbiMPJhvWS+LDT+f1ZMqGziiCKN8Q6XplpbuxK6FQn+i9CEfyzpwPwUVeg3IgVt
	 EeYgqHUAexXcC73DnpDiuoXHvtepeiiiGvBumAo47Yci7os6OZxjZSHnK06yOO3Ngk
	 QKrXQJBw4aadQ==
Date: Sun, 31 Dec 2023 13:04:24 -0800
Subject: [PATCH 14/21] xfs: create libxfs helper to link a new inode into a
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844278.1759932.4871928648333680613.stgit@frogsfrogsfrogs>
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

Create a new libxfs function to link a newly created inode into a
directory.  The upcoming metadata directory feature will need this to
create a metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |   47 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |   12 ++++++++++
 fs/xfs/xfs_inode.c       |   53 +++++++++++++++-------------------------------
 fs/xfs/xfs_symlink.c     |   43 ++++++++++++++++---------------------
 4 files changed, 95 insertions(+), 60 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 525b23a3800b6..16dfe869ef2de 100644
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
@@ -782,3 +785,47 @@ xfs_dir2_compname(
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
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_EXCL));
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
+	return xfs_parent_add(tp, du->ppargs, dp, name, ip);
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index ca1949ed4f5e8..71a8d8e8a8e7b 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -293,4 +293,16 @@ static inline unsigned char xfs_ascii_ci_xfrm(unsigned char c)
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
index 0e37bbc5b6784..401bd2a455196 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -754,14 +754,16 @@ xfs_create(
 	const struct xfs_icreate_args *args,
 	struct xfs_inode	**ipp)
 {
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
@@ -791,7 +793,7 @@ xfs_create(
 		tres = &M_RES(mp)->tr_create;
 	}
 
-	error = xfs_parent_start(mp, &ppargs);
+	error = xfs_parent_start(mp, &du.ppargs);
 	if (error)
 		goto out_release_dquots;
 
@@ -822,7 +824,7 @@ xfs_create(
 	 */
 	error = xfs_dialloc(&tp, dp->i_ino, args->mode, &ino);
 	if (!error)
-		error = xfs_icreate(tp, ino, args, &ip);
+		error = xfs_icreate(tp, ino, args, &du.ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -835,28 +837,7 @@ xfs_create(
 	 */
 	xfs_trans_ijoin(tp, dp, 0);
 
-	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					resblks - XFS_IALLOC_SPACE_RES(mp));
-	if (error) {
-		ASSERT(error != -ENOSPC);
-		goto out_trans_cancel;
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
-	error = xfs_parent_add(tp, ppargs, dp, name, ip);
+	error = xfs_dir_create_child(tp, resblks, &du);
 	if (error)
 		goto out_trans_cancel;
 
@@ -864,7 +845,7 @@ xfs_create(
 	 * Create ip with a reference from dp, and add '.' and '..' references
 	 * if it's a directory.
 	 */
-	xfs_dir_update_hook(dp, ip, 1, name);
+	xfs_dir_update_hook(dp, du.ip, 1, name);
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -879,7 +860,7 @@ xfs_create(
 	 * These ids of the inode couldn't have changed since the new
 	 * inode has been locked ever since it was created.
 	 */
-	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
+	xfs_qm_vop_create_dqattach(tp, du.ip, udqp, gdqp, pdqp);
 
 	error = xfs_trans_commit(tp);
 	if (error)
@@ -889,10 +870,10 @@ xfs_create(
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
@@ -903,13 +884,13 @@ xfs_create(
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
index a4872a6903e69..a923160a7dae0 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -93,9 +93,12 @@ xfs_symlink(
 	struct xfs_icreate_args	args = {
 		.nlink		= 1,
 	};
+	struct xfs_dir_update	du = {
+		.dp		= dp,
+		.name		= link_name,
+	};
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans	*tp = NULL;
-	struct xfs_inode	*ip = NULL;
 	int			error = 0;
 	int			pathlen;
 	bool                    unlock_dp_on_error = false;
@@ -105,7 +108,6 @@ xfs_symlink(
 	struct xfs_dquot	*pdqp;
 	uint			resblks;
 	xfs_ino_t		ino;
-	struct xfs_parent_args	*ppargs;
 
 	*ipp = NULL;
 
@@ -144,7 +146,7 @@ xfs_symlink(
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
 	resblks = xfs_symlink_space_res(mp, link_name->len, fs_blocks);
 
-	error = xfs_parent_start(mp, &ppargs);
+	error = xfs_parent_start(mp, &du.ppargs);
 	if (error)
 		goto out_release_dquots;
 
@@ -169,7 +171,7 @@ xfs_symlink(
 	 */
 	error = xfs_dialloc(&tp, dp->i_ino, S_IFLNK, &ino);
 	if (!error)
-		error = xfs_icreate(tp, ino, &args, &ip);
+		error = xfs_icreate(tp, ino, &args, &du.ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -185,31 +187,24 @@ xfs_symlink(
 	/*
 	 * Also attach the dquot(s) to it, if applicable.
 	 */
-	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
+	xfs_qm_vop_create_dqattach(tp, du.ip, udqp, gdqp, pdqp);
 
 	resblks -= XFS_IALLOC_SPACE_RES(mp);
-	error = xfs_symlink_write_target(tp, ip, target_path, pathlen,
+	error = xfs_symlink_write_target(tp, du.ip, target_path, pathlen,
 			fs_blocks, resblks);
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
-	error = xfs_parent_add(tp, ppargs, dp, link_name, ip);
-	if (error)
-		goto out_trans_cancel;
-
-	xfs_dir_update_hook(dp, ip, 1, link_name);
+	xfs_dir_update_hook(dp, du.ip, 1, link_name);
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -227,10 +222,10 @@ xfs_symlink(
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
@@ -241,13 +236,13 @@ xfs_symlink(
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

