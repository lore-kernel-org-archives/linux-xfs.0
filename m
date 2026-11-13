Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571319;
	b=Wn9AtgWxGkcuTTj1lLgYHXLTPktff9pwSUB8OMhf0rSOiEoTMzdMJlDFJ4d3r10+1S0S
	 KtmrXCp9d+T6I8ljhKvSX18PB2QKX7LRyBZIlxly1oW+5aJb/Mx0XD/oERnLNT8IKXiPj
	 5wWjY16+rBLCGIvbvI9kMA7p2NYkbNKWhAxNEai7jd8pifNriIN4tmSWGaTJ6rAm5Qf3W
	 UHw749MzOi8F5kYkuTggS1mj8e15PUaQk+IgK/lUpNLCM0sY2SJvqHV8zylReCO2CkSQ5
	 H7QBqv6AUMc3WWB8Iu2DdIxVOGYtWTw5Q15z1xcyJ1gaTkW1283m9NaU/4WERRk6Z8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571319;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=9m7rGhniXkCVOpjWxIRaB48HqI4fh7CALv+MiR87LK4=;
	b=ARy6+HUzfZ2OFhDceACh0sbkpoGaHqHanbgCPUuVrIfJsI0nY+lOOYhzNv3b0zMGpSto
	 8G7kW8I03Nqv7lObwy+8JrM50nAIWCTdTN2UQ3ny0PPwUETBSWZ4RfbjykjvKCgvsCbKn
	 T0u6j/mX/XOkW+Sv/mf0sLXjrBlPrUBy0rJrQwu8WLH0GobGvLbltD/CQqAZf6a5DTPKt
	 1+mdZNXhsyN5Ts7H1Wud7soVI25Yd9H9Jz6XVlVU8MQcvN85Bov3aGrY04LarASCqw3jr
	 8TW221O9AhwknpeX3ACWofP8/V1r8Sh5FQFHaP5dKmjVzEEtqyN4tZ8dLZxpz+fGp4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ug6W5wvR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AF1606EAE2;
	Fri, 13 Nov 2026 12:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ug6W5wvR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3391F000C6;
	Fri, 13 Nov 2026 12:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571319;
	bh=9m7rGhniXkCVOpjWxIRaB48HqI4fh7CALv+MiR87LK4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ug6W5wvRvHb+tMs8apk9dsP12PBW6wealEd4cLaVlE1fx5qaxqtwRWv5cqHHWuhDr
	 YVnjvHdTrptkecCq3R2oMJGTGmOxrWz0qZVCTiaiKN9DE6t5gewtPzzQDis7LktDry
	 duUPpwOfDeDuTQAZjHOZqqPb9oRFf2t/ve6OvwN72J5QKsuISTXm+hYy0QJnLfv9hz
	 JW/bfx/JL2fdDy2aLhuKpSKmB3fOaWJc5+SPTFntR7HN/9z1Ya12r9bvJl3y9R8Iue
	 n0kqSrkyoT1yn6fqhBQ6xKvPhajY2OIuJ7Kyw95+zVc2BNwJtFDivWhPfIIj6DPK8z
	 40BhzVceFBNcQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:21 +0100
Subject: [PATCH v3 25/33] btrfs: check BTRFS_FS_STATE_RO instead of
 SB_RDONLY at runtime
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-25-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=14087; i=brauner@kernel.org;
 h=from:subject:message-id; bh=N9txMHHpqH0c/abOscx2MPg9hwaXL1389imewXw8xz4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+71dY/PcFR/n+Jr/5noSq9qt0zsxl8s2YY35pWM6P
 SxWKikNHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABP5rM7wTz/IP7h+sWdTcIRk
 yGcTRk3GGC/GRb/mrTNe1SgxKWuNCyPD89N8yYem+L5b6ZHpd2m519f4KXVeM1e9bz9dt7GWd5c
 qAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add btrfs_fs_rdonly() which tests BTRFS_FS_STATE_RO and use it instead
of sb_rdonly() wherever btrfs checks for a read-only filesystem at
runtime: the error handler, read repair, async discard, close_ctree(),
btrfs_inc_block_group_ro(), check_inode_item(), device replace and add,
cancelling a balance, the sysfs label and force_chunk_alloc stores, the
qgroup PERTRANS conversions and the subvolume orphan cleanup. And check
it next to every btrfs_root_readonly() check that guards a modification,
e.g. in btrfs_permission(), btrfs_setattr(), btrfs_update_time(), the
xattr and ACL handlers, btrfs_fileattr_set() and
btrfs_remap_file_range_prep().

BTRFS_FS_STATE_RO has always been set and cleared together with
SB_RDONLY. The remaining sb_rdonly() users are mount and remount paths
plus btrfs_is_full_ro() which only matters for rescue mounts.

This prepares for not setting SB_RDONLY from the error handler. Until
then the only difference is that ftruncate() and FICLONE through files
that were opened for writing before a forced remount to read-only, e.g.
by sysrq u, fail with EROFS now instead of modifying the filesystem.

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
 fs/btrfs/sysfs.c        |  4 ++--
 fs/btrfs/tree-checker.c |  2 +-
 fs/btrfs/volumes.c      |  4 ++--
 fs/btrfs/xattr.c        |  8 ++++++--
 16 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 10a0d733bfd17..8bf11da118f7c 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -107,8 +107,9 @@ int btrfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	int ret;
 	struct inode *inode = d_inode(dentry);
 	umode_t old_mode = inode->i_mode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 
-	if (btrfs_root_readonly(BTRFS_I(inode)->root))
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 		return -EROFS;
 
 	if (type == ACL_TYPE_ACCESS && acl) {
diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 2c6234f6182f8..987f29b1ac462 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -924,7 +924,7 @@ int btrfs_repair_bbio_failure(struct btrfs_bio *bbio, const struct bvec_iter *or
 	 * The fs either mounted RO or hit critical errors, no need
 	 * to continue repairing.
 	 */
-	if (unlikely(sb_rdonly(fs_info->sb)))
+	if (unlikely(btrfs_fs_rdonly(fs_info)))
 		return 0;
 
 	if (btrfs_repair_one_zone(fs_info, logical))
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 9a98e291769ca..04c0c0b0c489f 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3138,7 +3138,7 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 	 * In that case we should not start a new transaction on read-only fs.
 	 * Thus here we skip all chunk allocations.
 	 */
-	if (sb_rdonly(fs_info->sb)) {
+	if (btrfs_fs_rdonly(fs_info)) {
 		mutex_lock(&fs_info->ro_block_group_mutex);
 		ret = inc_block_group_ro(cache, false);
 		mutex_unlock(&fs_info->ro_block_group_mutex);
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index cdfe093e5c5c4..943ce620a046c 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -1115,7 +1115,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 	int result;
 	int ret;
 
-	if (sb_rdonly(fs_info->sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return -EROFS;
 
 	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
diff --git a/fs/btrfs/discard.c b/fs/btrfs/discard.c
index 1c304bf473e55..e5c029813228c 100644
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
index c45cda4290d5a..3dcacf7e4d1d4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -177,7 +177,7 @@ static int btrfs_repair_eb_io_failure(const struct extent_buffer *eb,
 	struct btrfs_bio *bbio;
 	int ret;
 
-	if (sb_rdonly(fs_info->sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return -EROFS;
 
 	/*
@@ -4483,7 +4483,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	/* Cancel or finish ongoing discard work */
 	btrfs_discard_cleanup(fs_info);
 
-	if (!sb_rdonly(fs_info->sb)) {
+	if (!btrfs_fs_rdonly(fs_info)) {
 		/*
 		 * The cleaner kthread is stopped, so do one final pass over
 		 * unused block groups.
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 2dd167c32d612..024c3ec7d0583 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -1194,6 +1194,16 @@ static inline int btrfs_need_cleaner_sleep(const struct btrfs_fs_info *fs_info)
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
index abaa334714566..415c5145fcbe3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5433,7 +5433,7 @@ static int btrfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
-	if (btrfs_root_readonly(root))
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 		return -EROFS;
 
 	ret = setattr_prepare(idmap, dentry, attr);
@@ -6058,7 +6058,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 			return ERR_CAST(inode);
 
 		down_read(&fs_info->cleanup_work_sem);
-		if (!sb_rdonly(inode->vfs_inode.i_sb))
+		if (!btrfs_fs_rdonly(fs_info))
 			ret = btrfs_orphan_cleanup(sub_root);
 		up_read(&fs_info->cleanup_work_sem);
 		if (ret) {
@@ -6421,7 +6421,7 @@ static int btrfs_update_time(struct inode *inode, enum fs_update_time type,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int dirty;
 
-	if (btrfs_root_readonly(root))
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 		return -EROFS;
 	if (flags & IOCB_NOWAIT)
 		return -EAGAIN;
@@ -9316,7 +9316,7 @@ static int btrfs_permission(const struct mnt_idmap *idmap,
 
 	if (mask & MAY_WRITE &&
 	    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))) {
-		if (btrfs_root_readonly(root))
+		if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 			return -EROFS;
 		if (BTRFS_I(inode)->flags & BTRFS_INODE_READONLY)
 			return -EACCES;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f3e2afe221be3..2063075906c8f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -291,7 +291,7 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
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
index 0704be7be8719..cedca40508315 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -132,10 +132,10 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
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
@@ -168,7 +168,7 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
 	if (!(sb->s_flags & SB_BORN))
 		return;
 
-	if (sb_rdonly(sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return;
 
 	btrfs_discard_stop(fs_info);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a0651fbfe7782..dc96c6aca1a94 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4658,7 +4658,7 @@ static void qgroup_convert_meta(struct btrfs_fs_info *fs_info, u64 ref_root,
 
 		qgroup_rsv_release(fs_info, qgroup, num_bytes,
 				BTRFS_QGROUP_RSV_META_PREALLOC);
-		if (!sb_rdonly(fs_info->sb))
+		if (!btrfs_fs_rdonly(fs_info))
 			qgroup_rsv_add(fs_info, qgroup, num_bytes,
 				       BTRFS_QGROUP_RSV_META_PERTRANS);
 
@@ -4688,7 +4688,7 @@ void btrfs_qgroup_convert_reserved_meta(struct btrfs_root *root, int num_bytes)
 				      BTRFS_QGROUP_RSV_META_PREALLOC);
 	trace_btrfs_qgroup_meta_convert(root, num_bytes);
 	qgroup_convert_meta(fs_info, btrfs_root_id(root), num_bytes);
-	if (!sb_rdonly(fs_info->sb))
+	if (!btrfs_fs_rdonly(fs_info))
 		add_root_meta_rsv(root, num_bytes, BTRFS_QGROUP_RSV_META_PERTRANS);
 }
 
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index b5d2c094941df..de9bc8ba50287 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -857,7 +857,8 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	if (!(remap_flags & REMAP_FILE_DEDUP)) {
 		struct btrfs_root *root_out = inode_out->root;
 
-		if (btrfs_root_readonly(root_out))
+		if (btrfs_root_readonly(root_out) ||
+		    btrfs_fs_rdonly(root_out->fs_info))
 			return -EROFS;
 
 		ASSERT(inode_in->vfs_inode.i_sb == inode_out->vfs_inode.i_sb);
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 3ac1fa608d3b5..c7522aafde1b0 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -751,7 +751,7 @@ static ssize_t btrfs_force_chunk_alloc_store(struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (sb_rdonly(fs_info->sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return -EROFS;
 
 	ret = kstrtobool(buf, &val);
@@ -980,7 +980,7 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	if (!fs_info)
 		return -EPERM;
 
-	if (sb_rdonly(fs_info->sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return -EROFS;
 
 	/*
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 9cd79d97b9b5e..6cce0e6c759e5 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1325,7 +1325,7 @@ static int check_inode_item(struct extent_buffer *leaf,
 			       "unknown incompat flags detected: 0x%x", flags);
 		return -EUCLEAN;
 	}
-	if (unlikely(!sb_rdonly(fs_info->sb) &&
+	if (unlikely(!btrfs_fs_rdonly(fs_info) &&
 		     (ro_flags & ~BTRFS_INODE_RO_FLAG_MASK))) {
 		inode_item_err(leaf, slot,
 			"unknown ro-compat flags detected on writeable mount: 0x%x",
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d3e6a9b429dd9..47879cc2160df 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2964,7 +2964,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	bool seeding_dev = false;
 	bool locked = false;
 
-	if (sb_rdonly(sb) && !fs_devices->seeding)
+	if (btrfs_fs_rdonly(fs_info) && !fs_devices->seeding)
 		return -EROFS;
 
 	/* Forbid freezing until the device is a committed member (or unwound). */
@@ -5297,7 +5297,7 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
 	 * mount time if the mount is read-write. Otherwise it's still paused
 	 * and we must not allow cancelling as it deletes the item.
 	 */
-	if (sb_rdonly(fs_info->sb)) {
+	if (btrfs_fs_rdonly(fs_info)) {
 		mutex_unlock(&fs_info->balance_mutex);
 		return -EROFS;
 	}
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index cbee10b6b49aa..c38ddee786362 100644
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

