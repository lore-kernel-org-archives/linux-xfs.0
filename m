Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:34138 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755058AbeBAUdG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Feb 2018 15:33:06 -0500
Subject: [PATCH 2 2/2] xfs: fix rt_dev usage for DAX
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 01 Feb 2018 13:33:05 -0700
Message-ID: <151751718516.69886.135497175511444689.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151751717968.69886.6978962571680635420.stgit@djiang5-desk3.ch.intel.com>
References: <151751717968.69886.6978962571680635420.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org, dan.j.williams@intel.com, linux-nvdimm@lists.01.org

When using realtime device (rtdev) with xfs where the data device is not
DAX capable, two issues arise. One is when data device is not DAX but the
realtime device is DAX capable, we currently disable DAX.
After passing this check, we are also not marking the inode as DAX capable.
This change will allow DAX enabled if the data device or the realtime
device is DAX capable. S_DAX will be marked for the inode if the file is
residing on a DAX capable device. This will prevent the case of rtdev is not
DAX and data device is DAX to create realtime files.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reported-by: Darrick Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iops.c  |    3 ++-
 fs/xfs/xfs_super.c |    9 ++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 56475fcd76f2..ab352c325301 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1204,7 +1204,8 @@ xfs_diflags_to_iflags(
 	    ip->i_mount->m_sb.sb_blocksize == PAGE_SIZE &&
 	    !xfs_is_reflink_inode(ip) &&
 	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
-	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
+	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX) &&
+	    blk_queue_dax(bdev_get_queue(inode->i_sb->s_bdev)))
 		inode->i_flags |= S_DAX;
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e8a687232614..5ac478924dce 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1649,11 +1649,18 @@ xfs_fs_fill_super(
 		sb->s_flags |= SB_I_VERSION;
 
 	if (mp->m_flags & XFS_MOUNT_DAX) {
+		bool rtdev_is_dax = false;
+
 		xfs_warn(mp,
 		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 
+		if (mp->m_rtdev_targp->bt_daxdev)
+			if (bdev_dax_supported(mp->m_rtdev_targp->bt_bdev,
+					      sb->s_blocksize) == 0)
+				rtdev_is_dax = true;
+
 		error = bdev_dax_supported(sb->s_bdev, sb->s_blocksize);
-		if (error) {
+		if (error && !rtdev_is_dax) {
 			xfs_alert(mp,
 			"DAX unsupported by block device. Turning off DAX.");
 			mp->m_flags &= ~XFS_MOUNT_DAX;

