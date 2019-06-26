Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52552 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfFZCdU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 22:33:20 -0400
Subject: [PATCH 3/5] vfs: teach vfs_ioc_fssetxattr_check to check project id
 info
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Jun 2019 19:32:26 -0700
Message-ID: <156151634648.2283456.13503181576369039474.stgit@magnolia>
In-Reply-To: <156151632209.2283456.3592379873620132456.stgit@magnolia>
References: <156151632209.2283456.3592379873620132456.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, darrick.wong@oracle.com, shaggy@kernel.org, ard.biesheuvel@linaro.org, josef@toxicpanda.com, hch@infradead.org, clm@fb.com, adilger.kernel@dilger.ca, jk@ozlabs.org, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, viro@zeniv.linux.org.uk
Cc: cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, Jan Kara <jack@suse.cz>, reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Standardize the project id checks for FSSETXATTR.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ioctl.c    |   27 ---------------------------
 fs/f2fs/file.c     |   27 ---------------------------
 fs/inode.c         |   13 +++++++++++++
 fs/xfs/xfs_ioctl.c |   15 ---------------
 4 files changed, 13 insertions(+), 69 deletions(-)


diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index ebcc173d1e7d..1e88c3af9a8d 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -697,30 +697,6 @@ static long ext4_ioctl_group_add(struct file *file,
 	return err;
 }
 
-static int ext4_ioctl_check_project(struct inode *inode, struct fsxattr *fa)
-{
-	/*
-	 * Project Quota ID state is only allowed to change from within the init
-	 * namespace. Enforce that restriction only if we are trying to change
-	 * the quota ID state. Everything else is allowed in user namespaces.
-	 */
-	if (current_user_ns() == &init_user_ns)
-		return 0;
-
-	if (__kprojid_val(EXT4_I(inode)->i_projid) != fa->fsx_projid)
-		return -EINVAL;
-
-	if (ext4_test_inode_flag(inode, EXT4_INODE_PROJINHERIT)) {
-		if (!(fa->fsx_xflags & FS_XFLAG_PROJINHERIT))
-			return -EINVAL;
-	} else {
-		if (fa->fsx_xflags & FS_XFLAG_PROJINHERIT)
-			return -EINVAL;
-	}
-
-	return 0;
-}
-
 static void ext4_fill_fsxattr(struct inode *inode, struct fsxattr *fa)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
@@ -1133,9 +1109,6 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 		inode_lock(inode);
 		ext4_fill_fsxattr(inode, &old_fa);
-		err = ext4_ioctl_check_project(inode, &fa);
-		if (err)
-			goto out;
 		err = vfs_ioc_fssetxattr_check(inode, &old_fa, &fa);
 		if (err)
 			goto out;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 555b970f7945..d6ed319388d6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2797,30 +2797,6 @@ static int f2fs_ioc_fsgetxattr(struct file *filp, unsigned long arg)
 	return 0;
 }
 
-static int f2fs_ioctl_check_project(struct inode *inode, struct fsxattr *fa)
-{
-	/*
-	 * Project Quota ID state is only allowed to change from within the init
-	 * namespace. Enforce that restriction only if we are trying to change
-	 * the quota ID state. Everything else is allowed in user namespaces.
-	 */
-	if (current_user_ns() == &init_user_ns)
-		return 0;
-
-	if (__kprojid_val(F2FS_I(inode)->i_projid) != fa->fsx_projid)
-		return -EINVAL;
-
-	if (F2FS_I(inode)->i_flags & F2FS_PROJINHERIT_FL) {
-		if (!(fa->fsx_xflags & FS_XFLAG_PROJINHERIT))
-			return -EINVAL;
-	} else {
-		if (fa->fsx_xflags & FS_XFLAG_PROJINHERIT)
-			return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int f2fs_ioc_fssetxattr(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -2848,9 +2824,6 @@ static int f2fs_ioc_fssetxattr(struct file *filp, unsigned long arg)
 		return err;
 
 	inode_lock(inode);
-	err = f2fs_ioctl_check_project(inode, &fa);
-	if (err)
-		goto out;
 
 	f2fs_fill_fsxattr(inode, &old_fa);
 	err = vfs_ioc_fssetxattr_check(inode, &old_fa, &fa);
diff --git a/fs/inode.c b/fs/inode.c
index fdd6c5d3e48d..c4f8fb16f633 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2234,6 +2234,19 @@ int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 	    !capable(CAP_LINUX_IMMUTABLE))
 		return -EPERM;
 
+	/*
+	 * Project Quota ID state is only allowed to change from within the init
+	 * namespace. Enforce that restriction only if we are trying to change
+	 * the quota ID state. Everything else is allowed in user namespaces.
+	 */
+	if (current_user_ns() != &init_user_ns) {
+		if (old_fa->fsx_projid != fa->fsx_projid)
+			return -EINVAL;
+		if ((old_fa->fsx_xflags ^ fa->fsx_xflags) &
+				FS_XFLAG_PROJINHERIT)
+			return -EINVAL;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(vfs_ioc_fssetxattr_check);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 08ec1e458865..d8c02b9905a7 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1299,21 +1299,6 @@ xfs_ioctl_setattr_check_projid(
 	if (fa->fsx_projid > (uint16_t)-1 &&
 	    !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
 		return -EINVAL;
-
-	/*
-	 * Project Quota ID state is only allowed to change from within the init
-	 * namespace. Enforce that restriction only if we are trying to change
-	 * the quota ID state. Everything else is allowed in user namespaces.
-	 */
-	if (current_user_ns() == &init_user_ns)
-		return 0;
-
-	if (xfs_get_projid(ip) != fa->fsx_projid)
-		return -EINVAL;
-	if ((fa->fsx_xflags & FS_XFLAG_PROJINHERIT) !=
-	    (ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT))
-		return -EINVAL;
-
 	return 0;
 }
 
