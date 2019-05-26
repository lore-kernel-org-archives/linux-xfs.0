Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34933 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfEZG2d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 May 2019 02:28:33 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR ioctls
Date: Sun, 26 May 2019 09:28:25 +0300
Message-Id: <20190526062825.23059-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org

They are the extended version of FS_IOC_FS[SG]ETFLAGS ioctls.
xfs_io -c "chattr <flags>" uses the new ioctls for setting flags.

This used to work in kernel pre v4.19, before stacked file ops
introduced the ovl_ioctl whitelist.

Reported-by: Dave Chinner <david@fromorbit.com>
Fixes: d1d04ef8572b ("ovl: stack file ops")
Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 540a8b845145..340a6ad45914 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -426,7 +426,8 @@ static unsigned int ovl_get_inode_flags(struct inode *inode)
 	return ovl_iflags;
 }
 
-static long ovl_ioctl_set_flags(struct file *file, unsigned long arg)
+static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
+				unsigned long arg)
 {
 	long ret;
 	struct inode *inode = file_inode(file);
@@ -456,7 +457,7 @@ static long ovl_ioctl_set_flags(struct file *file, unsigned long arg)
 	if (ret)
 		goto unlock;
 
-	ret = ovl_real_ioctl(file, FS_IOC_SETFLAGS, arg);
+	ret = ovl_real_ioctl(file, cmd, arg);
 
 	ovl_copyflags(ovl_inode_real(inode), inode);
 unlock:
@@ -474,11 +475,13 @@ static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case FS_IOC_GETFLAGS:
+	case FS_IOC_FSGETXATTR:
 		ret = ovl_real_ioctl(file, cmd, arg);
 		break;
 
 	case FS_IOC_SETFLAGS:
-		ret = ovl_ioctl_set_flags(file, arg);
+	case FS_IOC_FSSETXATTR:
+		ret = ovl_ioctl_set_flags(file, cmd, arg);
 		break;
 
 	default:
-- 
2.17.1
