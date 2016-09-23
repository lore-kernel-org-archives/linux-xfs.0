Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33244 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754016AbcIWIiv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 04:38:51 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 2/3] vfs: call vfs_clone_file_range() under mnt_want_write()
Date: Fri, 23 Sep 2016 11:38:11 +0300
Message-Id: <1474619892-5113-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1474619892-5113-1-git-send-email-amir73il@gmail.com>
References: <1474619892-5113-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org

Move mnt_want_write() out of the vfs helper and up into
the ioctl handler.
Taking mnt_want_write() outside the vfs helper is the standard
in most namei.c syscalls.
This change will allow overlayfs code to use the helper for
copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/ioctl.c      | 9 +++++++++
 fs/read_write.c | 5 -----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 34d2994..9299832 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -15,6 +15,7 @@
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
 #include <linux/falloc.h>
+#include <linux/mount.h>
 #include "internal.h"
 
 #include <asm/ioctls.h>
@@ -225,7 +226,15 @@ static long ioctl_file_clone(struct file *dst_file, unsigned long srcfd,
 		return -EBADF;
 	if (src_file.file->f_path.mnt != dst_file->f_path.mnt)
 		return -EXDEV;
+
+	ret = mnt_want_write_file(dst_file);
+	if (ret)
+		goto out_fput;
+
 	ret = vfs_clone_file_range(src_file.file, off, dst_file, destoff, olen);
+
+	mnt_drop_write_file(dst_file);
+out_fput:
 	fdput(src_file);
 	return ret;
 }
diff --git a/fs/read_write.c b/fs/read_write.c
index 9dc6e52..90bc18b 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1660,10 +1660,6 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 	if (pos_in + len > i_size_read(inode_in))
 		return -EINVAL;
 
-	ret = mnt_want_write_file(file_out);
-	if (ret)
-		return ret;
-
 	ret = file_in->f_op->clone_file_range(file_in, pos_in,
 			file_out, pos_out, len);
 	if (!ret) {
@@ -1671,7 +1667,6 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 		fsnotify_modify(file_out);
 	}
 
-	mnt_drop_write_file(file_out);
 	return ret;
 }
 EXPORT_SYMBOL(vfs_clone_file_range);
-- 
2.7.4

