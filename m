Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40276 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbeAUFeG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Jan 2018 00:34:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0L5Wu5R192200
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jan 2018 05:34:06 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2fmkhm029q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jan 2018 05:34:06 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0L5Y4Hr001562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jan 2018 05:34:05 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0L5Y4lh003986
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jan 2018 05:34:04 GMT
Subject: [PATCH 2/6] xfs: only grab shared inode locks for source file
 during reflink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 20 Jan 2018 21:34:03 -0800
Message-ID: <151651284391.28390.6456958202076195269.stgit@magnolia>
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

Reflink and dedupe operations remap blocks from a source file into a
destination file.  The destination file needs exclusive locks on all
levels because we're updating its block map, but the source file isn't
undergoing any block map changes so we can use a shared lock.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   50 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index ce523dd..5d1ff5a 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1202,13 +1202,16 @@ xfs_reflink_remap_blocks(
 
 	/* drange = (destoff, destoff + len); srange = (srcoff, srcoff + len) */
 	while (len) {
+		uint		lock_mode;
+
 		trace_xfs_reflink_remap_blocks_loop(src, srcoff, len,
 				dest, destoff);
+
 		/* Read extent from the source file */
 		nimaps = 1;
-		xfs_ilock(src, XFS_ILOCK_EXCL);
+		lock_mode = xfs_ilock_data_map_shared(src);
 		error = xfs_bmapi_read(src, srcoff, len, &imap, &nimaps, 0);
-		xfs_iunlock(src, XFS_ILOCK_EXCL);
+		xfs_iunlock(src, lock_mode);
 		if (error)
 			goto err;
 		ASSERT(nimaps == 1);
@@ -1260,7 +1263,7 @@ xfs_iolock_two_inodes_and_break_layout(
 
 retry:
 	if (src_first) {
-		inode_lock(src);
+		inode_lock_shared(src);
 		inode_lock_nested(dest, I_MUTEX_NONDIR2);
 	} else {
 		inode_lock(dest);
@@ -1270,7 +1273,7 @@ xfs_iolock_two_inodes_and_break_layout(
 	if (error == -EWOULDBLOCK) {
 		inode_unlock(dest);
 		if (src_first)
-			inode_unlock(src);
+			inode_unlock_shared(src);
 		error = break_layout(dest, true);
 		if (error)
 			return error;
@@ -1278,14 +1281,36 @@ xfs_iolock_two_inodes_and_break_layout(
 	} else if (error) {
 		inode_unlock(dest);
 		if (src_first)
-			inode_unlock(src);
+			inode_unlock_shared(src);
 		return error;
 	}
 	if (src_last)
-		inode_lock_nested(src, I_MUTEX_NONDIR2);
+		down_read_nested(&src->i_rwsem, I_MUTEX_NONDIR2);
 	return 0;
 }
 
+static void
+xfs_reflink_mmaplock_two(
+	struct xfs_inode	*src,
+	struct xfs_inode	*dest)
+{
+	int			i = 0;
+
+	if (src->i_ino == dest->i_ino) {
+		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
+		return;
+	}
+
+	if (src->i_ino < dest->i_ino) {
+		xfs_ilock(src, XFS_MMAPLOCK_SHARED);
+		i++;
+	}
+	xfs_ilock(dest, XFS_MMAPLOCK_EXCL + (i << XFS_MMAPLOCK_SHIFT));
+	i++;
+	if (src->i_ino > dest->i_ino)
+		xfs_ilock(src, XFS_MMAPLOCK_SHARED + (i << XFS_MMAPLOCK_SHIFT));
+}
+
 /*
  * Link a range of blocks from one file to another.
  */
@@ -1319,10 +1344,7 @@ xfs_reflink_remap_range(
 	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
 	if (ret)
 		return ret;
-	if (same_inode)
-		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
-	else
-		xfs_lock_two_inodes(src, dest, XFS_MMAPLOCK_EXCL);
+	xfs_reflink_mmaplock_two(src, dest);
 
 	/* Check file eligibility and prepare for block sharing. */
 	ret = -EINVAL;
@@ -1385,10 +1407,12 @@ xfs_reflink_remap_range(
 			is_dedupe);
 
 out_unlock:
-	xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
+	xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
+	if (!same_inode)
+		xfs_iunlock(src, XFS_MMAPLOCK_SHARED);
+	inode_unlock(inode_out);
 	if (!same_inode)
-		xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
-	unlock_two_nondirectories(inode_in, inode_out);
+		inode_unlock_shared(inode_in);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
 	return ret;

