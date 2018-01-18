Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41138 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753377AbeARHmi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jan 2018 02:42:38 -0500
Subject: [PATCH 1/2] xfs: reflink should break pnfs leases before sharing
 blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 17 Jan 2018 23:42:33 -0800
Message-ID: <151626135332.25794.4917048406130796904.stgit@magnolia>
In-Reply-To: <151626134674.25794.7913544634631149739.stgit@magnolia>
References: <151626134674.25794.7913544634631149739.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@lst.de, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Before we share blocks between files, we need to break the pnfs leases
on the layout before we start slicing and dicing the block map.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index da5c490..a701336 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1249,6 +1249,34 @@ xfs_reflink_remap_blocks(
 }
 
 /*
+ * Grab the exclusive iolock for a data copy from in to out, making sure to
+ * break the pnfs layout leases on out before proceeding.
+ */
+static int
+xfs_iolock_two_inodes_and_break_layout(
+	struct inode		*inode_in,
+	struct inode		*inode_out)
+{
+	uint			iolock = XFS_IOLOCK_EXCL;
+	int			error;
+
+	if (inode_in < inode_out) {
+		inode_lock(inode_in);
+		inode_lock_nested(inode_out, I_MUTEX_NONDIR2);
+	} else {
+		inode_lock(inode_out);
+	}
+	error = xfs_break_layouts(inode_out, &iolock);
+	if (error) {
+		inode_unlock(inode_in);
+		return error;
+	}
+	if (inode_in > inode_out)
+		inode_lock_nested(inode_in, I_MUTEX_NONDIR2);
+	return 0;
+}
+
+/*
  * Link a range of blocks from one file to another.
  */
 int
@@ -1278,7 +1306,9 @@ xfs_reflink_remap_range(
 		return -EIO;
 
 	/* Lock both files against IO */
-	lock_two_nondirectories(inode_in, inode_out);
+	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
+	if (ret)
+		return ret;
 	if (same_inode)
 		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
 	else

