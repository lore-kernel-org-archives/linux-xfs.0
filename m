Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:18168 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1946017AbeBORmp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Feb 2018 12:42:45 -0500
Subject: [PATCH v4 3/3] xfs: reject removal of realtime flag when datadev
 doesn't support DAX
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 15 Feb 2018 10:42:44 -0700
Message-ID: <151871656418.27617.17216472781436196968.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151871644696.27617.4390718895806529377.stgit@djiang5-desk3.ch.intel.com>
References: <151871644696.27617.4390718895806529377.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org, dan.j.williams@intel.com

In a situation where the rt_dev is DAX and data_dev is not DAX, if the user
requests to remove the realtime flag via ioctl we can no longer support DAX
for that file. Dynamic changing of S_DAX on the inode is not supported due
to various complications in the existing implementation. Therefore until we
address the dynamic S_DAX change issues, we must disallow realtime flag
being removed.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 fs/xfs/xfs_ioctl.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a6a0efc35c76..a2728f803e26 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1030,6 +1030,21 @@ xfs_ioctl_setattr_xflags(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	uint64_t		di_flags2;
+	struct inode		*inode = VFS_I(ip);
+	struct super_block	*sb = inode->i_sb;
+
+	/*
+	 * In the case that the inode is realtime, and we are trying to remove
+	 * the realtime flag, and the rtdev supports DAX but the datadev does
+	 * not support DAX, we can't allow the realtime flag to be removed
+	 * since we do not support dynamic S_DAX flag removal yet.
+	 */
+	if ((XFS_IS_REALTIME_INODE(ip)) &&
+	    !(fa->fsx_xflags & FS_XFLAG_REALTIME) &&
+	    bdev_dax_supported(sb, mp->m_rtdev_targp->bt_bdev,
+		    sb->s_blocksize) &&
+	    !bdev_dax_supported(sb, mp->m_ddev_targp->bt_bdev, sb->s_blocksize))
+		return -ENOTSUPP;
 
 	/* Can't change realtime flag if any extents are allocated. */
 	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&

