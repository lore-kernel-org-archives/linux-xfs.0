Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20284 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964876AbcI1C7y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:59:54 -0400
Subject: [PATCH 58/63] xfs: don't mix reflink and DAX mode for now
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:59:51 -0700
Message-ID: <147503159106.30303.15446494618167648273.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

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
index 912f1d8..349f328 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1050,6 +1050,10 @@ xfs_file_share_range(
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
index dc3f5ba5..6d6b219 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1153,6 +1153,7 @@ xfs_diflags_to_iflags(
 		inode->i_flags |= S_NOATIME;
 	if (S_ISREG(inode->i_mode) &&
 	    ip->i_mount->m_sb.sb_blocksize == PAGE_SIZE &&
+	    !xfs_is_reflink_inode(ip) &&
 	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
 	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
 		inode->i_flags |= S_DAX;

