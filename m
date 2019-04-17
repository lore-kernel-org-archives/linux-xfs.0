Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36476 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfDQTFS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 15:05:18 -0400
Subject: [PATCH 7/8] btrfs: don't allow any modifications to an immutable
 file
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 17 Apr 2019 12:05:13 -0700
Message-ID: <155552791345.20411.13373076079148473736.stgit@magnolia>
In-Reply-To: <155552786671.20411.6442426840435740050.stgit@magnolia>
References: <155552786671.20411.6442426840435740050.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't allow any modifications to a file that's marked immutable, which
means that we have to flush all the writable pages to make the readonly
and we have to check the setattr/setflags parameters more closely.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/btrfs/ioctl.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)


diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cd4e693406a0..632600e4be0a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -180,6 +180,44 @@ static int check_fsflags(unsigned int flags)
 	return 0;
 }
 
+/* Do all the prep work to check immutable status and all that. */
+static int btrfs_ioctl_check_immutable(struct inode *inode,
+				       unsigned int fsflags,
+				       const unsigned int immutable_fsflag)
+{
+	struct btrfs_inode *binode = BTRFS_I(inode);
+	int ret;
+
+	/*
+	 * Wait for all pending directio and then flush all the dirty pages
+	 * for this file.  The flush marks all the pages readonly, so any
+	 * subsequent attempt to write to the file (particularly mmap pages)
+	 * will come through the filesystem and fail.
+	 */
+	if (S_ISREG(inode->i_mode) && !IS_IMMUTABLE(inode) &&
+	    (fsflags & immutable_fsflag)) {
+		inode_dio_wait(inode);
+		ret = filemap_write_and_wait(inode->i_mapping);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * If immutable is set and we are not clearing it, we're not allowed to
+	 * change anything else in the inode.  Don't error out if we're only
+	 * trying to set immutable on an immutable file.
+	 */
+	if (!(binode->flags & BTRFS_INODE_IMMUTABLE) ||
+	    !(fsflags & immutable_fsflag))
+		return 0;
+
+	if ((binode->flags & ~BTRFS_INODE_IMMUTABLE) !=
+	    (fsflags & ~immutable_fsflag))
+		return -EPERM;
+
+	return 0;
+}
+
 static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 {
 	struct inode *inode = file_inode(file);
@@ -225,6 +263,10 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		}
 	}
 
+	ret = btrfs_ioctl_check_immutable(inode, fsflags, FS_IMMUTABLE_FL);
+	if (ret)
+		goto out_unlock;
+
 	if (fsflags & FS_SYNC_FL)
 		binode->flags |= BTRFS_INODE_SYNC;
 	else
@@ -433,6 +475,11 @@ static int btrfs_ioctl_fssetxattr(struct file *file, void __user *arg)
 		goto out_unlock;
 	}
 
+	ret = btrfs_ioctl_check_immutable(inode, fa.fsx_xflags,
+					  FS_XFLAG_IMMUTABLE);
+	if (ret)
+		goto out_unlock;
+
 	if (fa.fsx_xflags & FS_XFLAG_SYNC)
 		binode->flags |= BTRFS_INODE_SYNC;
 	else
