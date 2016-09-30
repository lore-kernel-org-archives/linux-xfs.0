Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43349 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935019AbcI3DMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:12:00 -0400
Subject: [PATCH 58/63] xfs: don't mix reflink and DAX mode for now
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:11:57 -0700
Message-ID: <147520511715.29434.14793907325765131489.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Since we don't have a strategy for handling both DAX and reflink,
for now we'll just prohibit both being set at the same time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    4 ++++
 fs/xfs/xfs_file.c             |    4 ++++
 fs/xfs/xfs_ioctl.c            |    4 ++++
 fs/xfs/xfs_iops.c             |    1 +
 4 files changed, 13 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index f1b9d97..8de9a3a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -407,6 +407,10 @@ xfs_dinode_verify(
 	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
 		return false;
 
+	/* don't let reflink and dax mix */
+	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags2 & XFS_DIFLAG2_DAX))
+		return false;
+
 	return true;
 }
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b8d3a8c..ef01bd3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1052,6 +1052,10 @@ xfs_file_share_range(
 	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
 		return -EINVAL;
 
+	/* Don't share DAX file data for now. */
+	if (IS_DAX(inode_in) || IS_DAX(inode_out))
+		return -EINVAL;
+
 	/* Are we going all the way to the end? */
 	isize = i_size_read(inode_in);
 	if (isize == 0)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index c65d9ea..8b9f31c5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1038,6 +1038,10 @@ xfs_ioctl_setattr_xflags(
 	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
 		return -EINVAL;
 
+	/* Don't allow us to set DAX mode for a reflinked file for now. */
+	if ((fa->fsx_xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))
+		return -EINVAL;
+
 	/*
 	 * Can't modify an immutable/append-only file unless
 	 * we have appropriate permission.
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b24c310..5945b64 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1144,6 +1144,7 @@ xfs_diflags_to_iflags(
 		inode->i_flags |= S_NOATIME;
 	if (S_ISREG(inode->i_mode) &&
 	    ip->i_mount->m_sb.sb_blocksize == PAGE_SIZE &&
+	    !xfs_is_reflink_inode(ip) &&
 	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
 	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
 		inode->i_flags |= S_DAX;

