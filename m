Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40212 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbeAUFeA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Jan 2018 00:34:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0L5VpXo191818
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jan 2018 05:34:00 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2fmkhm029m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jan 2018 05:34:00 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0L5Xxef000529
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jan 2018 05:33:59 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0L5XwOD005059
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jan 2018 05:33:58 GMT
Subject: [PATCH 1/6] xfs: reflink should break pnfs leases before sharing
 blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 20 Jan 2018 21:33:55 -0800
Message-ID: <151651283574.28390.7095577838603162643.stgit@magnolia>
In-Reply-To: <151651282961.28390.17944517354130397779.stgit@magnolia>
References: <151651282961.28390.17944517354130397779.stgit@magnolia>
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
 fs/xfs/xfs_reflink.c |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 47aea2e..ce523dd 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1245,6 +1245,48 @@ xfs_reflink_remap_blocks(
 }
 
 /*
+ * Grab the exclusive iolock for a data copy from src to dest, making
+ * sure to abide vfs locking order (lowest pointer value goes first) and
+ * breaking the pnfs layout leases on dest before proceeding.
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
@@ -1274,7 +1316,9 @@ xfs_reflink_remap_range(
 		return -EIO;
 
 	/* Lock both files against IO */
-	lock_two_nondirectories(inode_in, inode_out);
+	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
+	if (ret)
+		return ret;
 	if (same_inode)
 		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
 	else

