Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34660 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751324AbeA0BKc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 20:10:32 -0500
Subject: [PATCH 1/7] xfs: reflink should break pnfs leases before sharing
 blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 26 Jan 2018 17:10:15 -0800
Message-ID: <151701541571.3070.9498021803548418301.stgit@magnolia>
In-Reply-To: <151701540938.3070.15043243007590700677.stgit@magnolia>
References: <151701540938.3070.15043243007590700677.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, bfoster@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Before we share blocks between files, we need to break the pnfs leases
on the layout before we start slicing and dicing the block map.  The
structure of this function sets us up for the lock contention reduction
in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_reflink.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index bcc2ad4..bac464f 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1245,6 +1245,50 @@ xfs_reflink_remap_blocks(
 }
 
 /*
+ * Grab the exclusive iolock for a data copy from src to dest, making
+ * sure to abide vfs locking order (lowest pointer value goes first) and
+ * breaking the pnfs layout leases on dest before proceeding.  The loop
+ * is needed because we cannot call the blocking break_layout() with the
+ * src iolock held, and therefore have to back out both locks.
+ */
+static int
+xfs_iolock_two_inodes_and_break_layout(
+	struct inode		*src,
+	struct inode		*dest)
+{
+	int			error;
+
+retry:
+	if (src < dest) {
+		inode_lock(src);
+		inode_lock_nested(dest, I_MUTEX_NONDIR2);
+	} else {
+		/* src >= dest */
+		inode_lock(dest);
+	}
+
+	error = break_layout(dest, false);
+	if (error == -EWOULDBLOCK) {
+		inode_unlock(dest);
+		if (src < dest)
+			inode_unlock(src);
+		error = break_layout(dest, true);
+		if (error)
+			return error;
+		goto retry;
+	}
+	if (error) {
+		inode_unlock(dest);
+		if (src < dest)
+			inode_unlock(src);
+		return error;
+	}
+	if (src > dest)
+		inode_lock_nested(src, I_MUTEX_NONDIR2);
+	return 0;
+}
+
+/*
  * Link a range of blocks from one file to another.
  */
 int
@@ -1274,7 +1318,9 @@ xfs_reflink_remap_range(
 		return -EIO;
 
 	/* Lock both files against IO */
-	lock_two_nondirectories(inode_in, inode_out);
+	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
+	if (ret)
+		return ret;
 	if (same_inode)
 		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
 	else

