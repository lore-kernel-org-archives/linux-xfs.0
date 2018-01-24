Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46358 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751897AbeAXCSF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jan 2018 21:18:05 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0O27GAH066399
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:05 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2fpgyjg1ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:05 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0O2I5tP030001
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:05 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0O2I4Ra012150
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:05 GMT
Subject: [PATCH 01/11] xfs: reflink should break pnfs leases before sharing
 blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Jan 2018 18:18:03 -0800
Message-ID: <151676028366.12349.7219306586282315379.stgit@magnolia>
In-Reply-To: <151676027743.12349.3845769501491774512.stgit@magnolia>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Before we share blocks between files, we need to break the pnfs leases
on the layout before we start slicing and dicing the block map.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 47aea2e..f89a725 100644
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
+	bool			src_first = src < dest;
+	bool			src_last = src > dest;
+	int			error;
+
+retry:
+	if (src_first) {
+		inode_lock(src);
+		inode_lock_nested(dest, I_MUTEX_NONDIR2);
+	} else {
+		inode_lock(dest);
+	}
+
+	error = break_layout(dest, false);
+	if (error == -EWOULDBLOCK) {
+		inode_unlock(dest);
+		if (src_first)
+			inode_unlock(src);
+		error = break_layout(dest, true);
+		if (error)
+			return error;
+		goto retry;
+	} else if (error) {
+		inode_unlock(dest);
+		if (src_first)
+			inode_unlock(src);
+		return error;
+	}
+	if (src_last)
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

