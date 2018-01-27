Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52938 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751889AbeA0BLE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 20:11:04 -0500
Subject: [PATCH 3/7] xfs: only grab shared inode locks for source file
 during reflink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 26 Jan 2018 17:10:28 -0800
Message-ID: <151701542824.3070.12415207450562775643.stgit@magnolia>
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

Reflink and dedupe operations remap blocks from a source file into a
destination file.  The destination file needs exclusive locks on all
levels because we're updating its block map, but the source file isn't
undergoing any block map changes so we can use a shared lock.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   25 +++++++++++++++----------
 include/linux/fs.h   |    5 +++++
 2 files changed, 20 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index bcc58c2..85a119e 100644
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
 	if (src < dest) {
-		inode_lock(src);
+		inode_lock_shared(src);
 		inode_lock_nested(dest, I_MUTEX_NONDIR2);
 	} else {
 		/* src >= dest */
@@ -1271,7 +1274,7 @@ xfs_iolock_two_inodes_and_break_layout(
 	if (error == -EWOULDBLOCK) {
 		inode_unlock(dest);
 		if (src < dest)
-			inode_unlock(src);
+			inode_unlock_shared(src);
 		error = break_layout(dest, true);
 		if (error)
 			return error;
@@ -1280,11 +1283,11 @@ xfs_iolock_two_inodes_and_break_layout(
 	if (error) {
 		inode_unlock(dest);
 		if (src < dest)
-			inode_unlock(src);
+			inode_unlock_shared(src);
 		return error;
 	}
 	if (src > dest)
-		inode_lock_nested(src, I_MUTEX_NONDIR2);
+		inode_lock_shared_nested(src, I_MUTEX_NONDIR2);
 	return 0;
 }
 
@@ -1324,7 +1327,7 @@ xfs_reflink_remap_range(
 	if (same_inode)
 		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
 	else
-		xfs_lock_two_inodes(src, XFS_MMAPLOCK_EXCL, dest,
+		xfs_lock_two_inodes(src, XFS_MMAPLOCK_SHARED, dest,
 				XFS_MMAPLOCK_EXCL);
 
 	/* Check file eligibility and prepare for block sharing. */
@@ -1393,10 +1396,12 @@ xfs_reflink_remap_range(
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7f8d96d..5cbeab8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -748,6 +748,11 @@ static inline void inode_lock_nested(struct inode *inode, unsigned subclass)
 	down_write_nested(&inode->i_rwsem, subclass);
 }
 
+static inline void inode_lock_shared_nested(struct inode *inode, unsigned subclass)
+{
+	down_read_nested(&inode->i_rwsem, subclass);
+}
+
 void lock_two_nondirectories(struct inode *, struct inode*);
 void unlock_two_nondirectories(struct inode *, struct inode*);
 

