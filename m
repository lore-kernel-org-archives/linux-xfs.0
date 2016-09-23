Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36743 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752772AbcIWIis (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 04:38:48 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 1/3] vfs: allow vfs_clone_file_range() across mount points
Date: Fri, 23 Sep 2016 11:38:10 +0300
Message-Id: <1474619892-5113-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1474619892-5113-1-git-send-email-amir73il@gmail.com>
References: <1474619892-5113-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org

FICLONE/FICLONERANGE ioctls return -EXDEV if src and dest
files are not on the same mount point.
Practically, clone only requires that src and dest files
are on the same file system.

Move the check for same mount point to ioctl handler and keep
only the check for same super block in the vfs helper.

A following patch is going to use the vfs_clone_file_range()
helper in overlayfs to copy up between lower and upper
mount points on the same file system.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/ioctl.c      | 2 ++
 fs/read_write.c | 8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index c415668..34d2994 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -223,6 +223,8 @@ static long ioctl_file_clone(struct file *dst_file, unsigned long srcfd,
 
 	if (!src_file.file)
 		return -EBADF;
+	if (src_file.file->f_path.mnt != dst_file->f_path.mnt)
+		return -EXDEV;
 	ret = vfs_clone_file_range(src_file.file, off, dst_file, destoff, olen);
 	fdput(src_file);
 	return ret;
diff --git a/fs/read_write.c b/fs/read_write.c
index 66215a7..9dc6e52 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1628,8 +1628,12 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 	struct inode *inode_out = file_inode(file_out);
 	int ret;
 
-	if (inode_in->i_sb != inode_out->i_sb ||
-	    file_in->f_path.mnt != file_out->f_path.mnt)
+	/*
+	 * FICLONE/FICLONERANGE ioctls enforce that src and dest files
+	 * are on the same mount point. Practically, they only need
+	 * to be on the same file system.
+	 */
+	if (inode_in->i_sb != inode_out->i_sb)
 		return -EXDEV;
 
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
-- 
2.7.4

