Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5A746E01E;
	Mon, 12 Oct 2026 10:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800561; cv=none; b=ucbHUmd01AJrWyHDES6R022qE4cS4Am3pI+Em6IC3kX4/MukROJ7xu3kpCSn6RQ99UjyeAPy9YG73c9UH5Hbj4kCEDBLnv55P6ecb9B8XQNCUrXTZQIYLSwlCPTuzisOrHa0nsOwJWKtzj7VWgo1YE+bzwt42Nyyw3OuRYgO0RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800561; c=relaxed/simple;
	bh=XqknGlXrMmg5okgYHJNEIP2nT6u7Q0JlJRzk0JZ1JxA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VwPXDDM+rFsB/CGFH5IX2pYWTxWl9O5MbdBZTWGqkZmTw+HhL7NdUMfG91yYes3mRbhJE7fX88X4w81ukxTKKcUl8mv/eA3NqEimtEbPLDQhgb71y8Xa7dLtexF6Cf61Hd9E9cJSG8XVJk196MvziF5nCNJCb+uvC9I3ojUmTpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MZoTJPC+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZoTJPC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD861F008A1;
	Mon, 12 Oct 2026 10:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800548;
	bh=dvPQj0EguC1LSQS2p7TW/9goW1YpTLs+pQz3r8NylHM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MZoTJPC+H9+GZJpqwsLvdkkzFEzLfkp6hmKGxLFOkCnEQ19AyVR54ErU6Lbd51C4K
	 jy+uKDJ7K+PYb1ecURv/N4M3weOYRa2koo5pTyGm6i6jIgPbQmmdJ3WnSSvP+KCMNm
	 9CQBCUkGnPZj5a7rpfvFbHgIFBqzrm2BsBXr5Zgv32tjwdFWJDBfvQM3cblMtloe+H
	 nGZ1LTDfHSCVfPNqG+J2sA/1hlZSAmX1+eqAcVqfHLgTgQ+Cym7K1+YwAuu678TDha
	 Nmo+ZyJg+2b84tmSplSxrzerHzKoTlIONOaUennuFrwWtSvN2aQHfThr7Uy5j4nouU
	 oFs0MVcCLOB/w==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:21:03 +0200
Subject: [PATCH RFC 18/28] btrfs: check BTRFS_FS_STATE_RO instead of
 SB_RDONLY at runtime
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-18-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
To: Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
 ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
 gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
 linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=14977; i=brauner@kernel.org;
 h=from:subject:message-id; bh=XqknGlXrMmg5okgYHJNEIP2nT6u7Q0JlJRzk0JZ1JxA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TI5e81Vu9/b0u0Os30suhG9Z/552S/L2w+kF9y7/
 3HPDeH7CzpKWRjEuBhkxRRZHNpNwuWW81RsNsrUgJnDygQyhIGLUwAmct+QkaGH9wPz2kV/Tq44
 83llQ94GQck/DGkHi7MfVfo6i4R87JZh+B88wzBv0uybulzSFukSd6Mu5KwQ/WQ+cekJCwWGx+/
 lNHgA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add btrfs_fs_rdonly() which tests BTRFS_FS_STATE_RO and use it instead
of sb_rdonly() wherever btrfs checks for a read-only filesystem at
runtime:

- the read-only checks in __btrfs_handle_fs_error()
- read repair in btrfs_repair_io_failure() and
  btrfs_repair_eb_io_failure()
- async discard in btrfs_run_discard_work()
- the final unused block group pass and commit in close_ctree()
- btrfs_inc_block_group_ro() and the ro-compat flag check in
  check_inode_item()
- starting and cancelling a device replace, adding a device and
  cancelling a balance
- the sysfs feature, label and force_chunk_alloc stores
- the qgroup PERTRANS conversions in qgroup_convert_meta() and
  btrfs_qgroup_convert_reserved_meta()
- the subvolume orphan cleanup in btrfs_lookup_dentry()

And check it next to every btrfs_root_readonly() check that guards a
modification, e.g. in btrfs_permission(), btrfs_setattr(),
btrfs_update_time(), the xattr and ACL handlers, btrfs_fileattr_set()
and the clone checks in btrfs_remap_file_range_prep().

BTRFS_FS_STATE_RO has always been set and cleared together with
SB_RDONLY, at mount time, on remount and after errors. And where
SB_RDONLY is set the VFS refuses new modifications before any of the new
checks is reached. The remaining sb_rdonly() users are mount and remount
paths, plus btrfs_is_full_ro() which only matters for rescue mounts that
are read-only from the start.

This is in preparation of not setting SB_RDONLY from the error handler
anymore. No functional changes for a healthy filesystem. After an error
file descriptors that were opened before it now fail in btrfs_setattr()
and btrfs_remap_file_range_prep() with the same -EROFS instead of
further down.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/acl.c          |  3 ++-
 fs/btrfs/bio.c          |  2 +-
 fs/btrfs/block-group.c  |  2 +-
 fs/btrfs/dev-replace.c  |  2 +-
 fs/btrfs/discard.c      |  2 +-
 fs/btrfs/disk-io.c      |  4 ++--
 fs/btrfs/fs.h           | 10 ++++++++++
 fs/btrfs/inode.c        |  8 ++++----
 fs/btrfs/ioctl.c        |  8 ++++----
 fs/btrfs/messages.c     |  8 ++++----
 fs/btrfs/qgroup.c       |  4 ++--
 fs/btrfs/reflink.c      |  3 ++-
 fs/btrfs/sysfs.c        |  6 +++---
 fs/btrfs/tree-checker.c |  2 +-
 fs/btrfs/volumes.c      |  4 ++--
 fs/btrfs/xattr.c        |  8 ++++++--
 16 files changed, 46 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 662cdd1cbdef..ab8de171bebf 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -107,8 +107,9 @@ int btrfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	int ret;
 	struct inode *inode = d_inode(dentry);
 	umode_t old_mode = inode->i_mode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 
-	if (btrfs_root_readonly(BTRFS_I(inode)->root))
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 		return -EROFS;
 
 	if (type == ACL_TYPE_ACCESS && acl) {
diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index cc0bd03048ba..f0c69ac377c3 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -957,7 +957,7 @@ int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 fileoff,
 	 * The fs either mounted RO or hit critical errors, no need
 	 * to continue repairing.
 	 */
-	if (unlikely(sb_rdonly(fs_info->sb)))
+	if (unlikely(btrfs_fs_rdonly(fs_info)))
 		return 0;
 
 	if (btrfs_repair_one_zone(fs_info, logical))
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index ee182369254c..895f0c3a2195 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3153,7 +3153,7 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 	 * In that case we should not start a new transaction on read-only fs.
 	 * Thus here we skip all chunk allocations.
 	 */
-	if (sb_rdonly(fs_info->sb)) {
+	if (btrfs_fs_rdonly(fs_info)) {
 		mutex_lock(&fs_info->ro_block_group_mutex);
 		ret = inc_block_group_ro(cache, false);
 		mutex_unlock(&fs_info->ro_block_group_mutex);
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 0284be0e4e82..4ba8d24453a6 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -1111,7 +1111,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 	int result;
 	int ret;
 
-	if (sb_rdonly(fs_info->sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return -EROFS;
 
 	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
diff --git a/fs/btrfs/discard.c b/fs/btrfs/discard.c
index 1c304bf473e5..e5c029813228 100644
--- a/fs/btrfs/discard.c
+++ b/fs/btrfs/discard.c
@@ -86,7 +86,7 @@ static bool btrfs_run_discard_work(const struct btrfs_discard_ctl *discard_ctl)
 						     struct btrfs_fs_info,
 						     discard_ctl);
 
-	return (!(fs_info->sb->s_flags & SB_RDONLY) &&
+	return (!btrfs_fs_rdonly(fs_info) &&
 		test_bit(BTRFS_FS_DISCARD_RUNNING, &fs_info->flags));
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dc7ad92876c0..3fdc1eed86bf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -180,7 +180,7 @@ static int btrfs_repair_eb_io_failure(const struct extent_buffer *eb,
 	const u32 nr_steps = eb->len / step;
 	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
 
-	if (sb_rdonly(fs_info->sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return -EROFS;
 
 	for (int i = 0; i < num_extent_pages(eb); i++) {
@@ -4511,7 +4511,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	/* Cancel or finish ongoing discard work */
 	btrfs_discard_cleanup(fs_info);
 
-	if (!sb_rdonly(fs_info->sb)) {
+	if (!btrfs_fs_rdonly(fs_info)) {
 		/*
 		 * The cleaner kthread is stopped, so do one final pass over
 		 * unused block groups.
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 10e15a319b93..92ba79cbbc6e 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -1195,6 +1195,16 @@ static inline int btrfs_need_cleaner_sleep(const struct btrfs_fs_info *fs_info)
 		btrfs_fs_closing(fs_info);
 }
 
+/*
+ * Check whether the filesystem is read-only. BTRFS_FS_STATE_RO is set and
+ * cleared together with SB_RDONLY on mount, on remount and when an error forces
+ * the filesystem read-only. Use this instead of sb_rdonly() at runtime.
+ */
+static inline bool btrfs_fs_rdonly(const struct btrfs_fs_info *fs_info)
+{
+	return test_bit(BTRFS_FS_STATE_RO, &fs_info->fs_state);
+}
+
 static inline void btrfs_wake_unfinished_drop(struct btrfs_fs_info *fs_info)
 {
 	clear_and_wake_up_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index faf6ed7deb18..261e0a2d6e30 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5505,7 +5505,7 @@ static int btrfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
-	if (btrfs_root_readonly(root))
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 		return -EROFS;
 
 	ret = setattr_prepare(idmap, dentry, attr);
@@ -6130,7 +6130,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 			return ERR_CAST(inode);
 
 		down_read(&fs_info->cleanup_work_sem);
-		if (!sb_rdonly(inode->vfs_inode.i_sb))
+		if (!btrfs_fs_rdonly(fs_info))
 			ret = btrfs_orphan_cleanup(sub_root);
 		up_read(&fs_info->cleanup_work_sem);
 		if (ret) {
@@ -6493,7 +6493,7 @@ static int btrfs_update_time(struct inode *inode, enum fs_update_time type,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int dirty;
 
-	if (btrfs_root_readonly(root))
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 		return -EROFS;
 	if (flags & IOCB_NOWAIT)
 		return -EAGAIN;
@@ -9402,7 +9402,7 @@ static int btrfs_permission(struct mnt_idmap *idmap,
 
 	if (mask & MAY_WRITE &&
 	    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))) {
-		if (btrfs_root_readonly(root))
+		if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 			return -EROFS;
 		if (BTRFS_I(inode)->flags & BTRFS_INODE_READONLY)
 			return -EACCES;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 576cd76ca0bf..44593825c0f4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -291,7 +291,7 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 	u32 inode_flags;
 	bool prop_set = false;
 
-	if (btrfs_root_readonly(root))
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(fs_info))
 		return -EROFS;
 
 	if (fileattr_has_fsx(fa))
@@ -2453,7 +2453,7 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 	if (ret)
 		return ret;
 
-	if (btrfs_root_readonly(root)) {
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info)) {
 		ret = -EROFS;
 		goto out;
 	}
@@ -3191,7 +3191,7 @@ static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
 
 	switch (p->cmd) {
 	case BTRFS_IOCTL_DEV_REPLACE_CMD_START:
-		if (sb_rdonly(fs_info->sb))
+		if (btrfs_fs_rdonly(fs_info))
 			return -EROFS;
 		if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_DEV_REPLACE)) {
 			ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
@@ -3927,7 +3927,7 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 		goto out;
 	}
 
-	if (btrfs_root_readonly(root)) {
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(fs_info)) {
 		ret = -EROFS;
 		goto out;
 	}
diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index 198d1747c80a..9aee0e0d7e85 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -130,10 +130,10 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
 #endif
 
 	/*
-	 * Special case: if the error is EROFS, and we're already under
-	 * SB_RDONLY, then it is safe here.
+	 * Special case: if the error is EROFS, and we're already read-only,
+	 * then it is safe here.
 	 */
-	if (error == -EROFS && sb_rdonly(sb))
+	if (error == -EROFS && btrfs_fs_rdonly(fs_info))
 		return;
 
 #ifdef CONFIG_PRINTK
@@ -166,7 +166,7 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
 	if (!(sb->s_flags & SB_BORN))
 		return;
 
-	if (sb_rdonly(sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return;
 
 	btrfs_discard_stop(fs_info);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f68b696b4bf7..ee6c4e936d08 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4618,7 +4618,7 @@ static void qgroup_convert_meta(struct btrfs_fs_info *fs_info, u64 ref_root,
 
 		qgroup_rsv_release(fs_info, qgroup, num_bytes,
 				BTRFS_QGROUP_RSV_META_PREALLOC);
-		if (!sb_rdonly(fs_info->sb))
+		if (!btrfs_fs_rdonly(fs_info))
 			qgroup_rsv_add(fs_info, qgroup, num_bytes,
 				       BTRFS_QGROUP_RSV_META_PERTRANS);
 
@@ -4648,7 +4648,7 @@ void btrfs_qgroup_convert_reserved_meta(struct btrfs_root *root, int num_bytes)
 				      BTRFS_QGROUP_RSV_META_PREALLOC);
 	trace_btrfs_qgroup_meta_convert(root, num_bytes);
 	qgroup_convert_meta(fs_info, btrfs_root_id(root), num_bytes);
-	if (!sb_rdonly(fs_info->sb))
+	if (!btrfs_fs_rdonly(fs_info))
 		add_root_meta_rsv(root, num_bytes, BTRFS_QGROUP_RSV_META_PERTRANS);
 }
 
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index d2a4101912bd..96cc207cdb4e 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -846,7 +846,8 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	if (!(remap_flags & REMAP_FILE_DEDUP)) {
 		struct btrfs_root *root_out = inode_out->root;
 
-		if (btrfs_root_readonly(root_out))
+		if (btrfs_root_readonly(root_out) ||
+		    btrfs_fs_rdonly(root_out->fs_info))
 			return -EROFS;
 
 		ASSERT(inode_in->vfs_inode.i_sb == inode_out->vfs_inode.i_sb);
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 39cb01ee441a..fdda9334a018 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -202,7 +202,7 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	if (!fs_info)
 		return -EPERM;
 
-	if (sb_rdonly(fs_info->sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return -EROFS;
 
 	ret = kstrtoul(skip_spaces(buf), 0, &val);
@@ -864,7 +864,7 @@ static ssize_t btrfs_force_chunk_alloc_store(struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (sb_rdonly(fs_info->sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return -EROFS;
 
 	ret = kstrtobool(buf, &val);
@@ -1093,7 +1093,7 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	if (!fs_info)
 		return -EPERM;
 
-	if (sb_rdonly(fs_info->sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return -EROFS;
 
 	/*
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 4b1e47173c63..46625f2e1e95 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1284,7 +1284,7 @@ static int check_inode_item(struct extent_buffer *leaf,
 			       "unknown incompat flags detected: 0x%x", flags);
 		return -EUCLEAN;
 	}
-	if (unlikely(!sb_rdonly(fs_info->sb) &&
+	if (unlikely(!btrfs_fs_rdonly(fs_info) &&
 		     (ro_flags & ~BTRFS_INODE_RO_FLAG_MASK))) {
 		inode_item_err(leaf, slot,
 			"unknown ro-compat flags detected on writeable mount: 0x%x",
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 85ea9c5d4536..e4067871995e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2933,7 +2933,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	bool seeding_dev = false;
 	bool locked = false;
 
-	if (sb_rdonly(sb) && !fs_devices->seeding)
+	if (btrfs_fs_rdonly(fs_info) && !fs_devices->seeding)
 		return -EROFS;
 
 	/* Forbid freezing until the device is a committed member (or unwound). */
@@ -5264,7 +5264,7 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
 	 * mount time if the mount is read-write. Otherwise it's still paused
 	 * and we must not allow cancelling as it deletes the item.
 	 */
-	if (sb_rdonly(fs_info->sb)) {
+	if (btrfs_fs_rdonly(fs_info)) {
 		mutex_unlock(&fs_info->balance_mutex);
 		return -EROFS;
 	}
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index cb001a211f55..cd9df07646ac 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -365,7 +365,9 @@ static int btrfs_xattr_handler_set(const struct xattr_handler *handler,
 				   const char *name, const void *buffer,
 				   size_t size, int flags)
 {
-	if (btrfs_root_readonly(BTRFS_I(inode)->root))
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 		return -EROFS;
 
 	name = xattr_full_name(handler, name);
@@ -409,7 +411,9 @@ static int btrfs_xattr_handler_set_security(const struct xattr_handler *handler,
 					    const void *buffer,
 					    size_t size, int flags)
 {
-	if (btrfs_root_readonly(BTRFS_I(inode)->root))
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 		return -EROFS;
 
 	name = xattr_full_name(handler, name);

-- 
2.53.0

