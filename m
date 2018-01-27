Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34772 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751522AbeA0BKh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 20:10:37 -0500
Subject: [PATCH 2/7] xfs: allow xfs_lock_two_inodes to take different
 EXCL/SHARED modes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 26 Jan 2018 17:10:22 -0800
Message-ID: <151701542193.3070.5082993119459865573.stgit@magnolia>
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

Refactor xfs_lock_two_inodes to take separate locking modes for each
inode.  Specifically, this enables us to take a SHARED lock on one inode
and an EXCL lock on the other.  The lock class (MMAPLOCK/ILOCK) must be
the same for each inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |    4 ++--
 fs/xfs/xfs_inode.c     |   49 +++++++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_inode.h     |    3 ++-
 fs/xfs/xfs_reflink.c   |    5 +++--
 4 files changed, 39 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 6d37ab4..c83f549 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1872,7 +1872,7 @@ xfs_swap_extents(
 	 */
 	lock_two_nondirectories(VFS_I(ip), VFS_I(tip));
 	lock_flags = XFS_MMAPLOCK_EXCL;
-	xfs_lock_two_inodes(ip, tip, XFS_MMAPLOCK_EXCL);
+	xfs_lock_two_inodes(ip, XFS_MMAPLOCK_EXCL, tip, XFS_MMAPLOCK_EXCL);
 
 	/* Verify that both files have the same format */
 	if ((VFS_I(ip)->i_mode & S_IFMT) != (VFS_I(tip)->i_mode & S_IFMT)) {
@@ -1919,7 +1919,7 @@ xfs_swap_extents(
 	 * Lock and join the inodes to the tansaction so that transaction commit
 	 * or cancel will unlock the inodes from this point onwards.
 	 */
-	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
+	xfs_lock_two_inodes(ip, XFS_ILOCK_EXCL, tip, XFS_ILOCK_EXCL);
 	lock_flags |= XFS_ILOCK_EXCL;
 	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_ijoin(tp, tip, 0);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5366fb6..e7f6d52 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -546,23 +546,36 @@ xfs_lock_inodes(
 
 /*
  * xfs_lock_two_inodes() can only be used to lock one type of lock at a time -
- * the iolock, the mmaplock or the ilock, but not more than one at a time. If we
- * lock more than one at a time, lockdep will report false positives saying we
- * have violated locking orders.
+ * the mmaplock or the ilock, but not more than one type at a time. If we lock
+ * more than one at a time, lockdep will report false positives saying we have
+ * violated locking orders.  The iolock must be double-locked separately since
+ * we use i_rwsem for that.  We now support taking one lock EXCL and the other
+ * SHARED.
  */
 void
 xfs_lock_two_inodes(
-	xfs_inode_t		*ip0,
-	xfs_inode_t		*ip1,
-	uint			lock_mode)
+	struct xfs_inode	*ip0,
+	uint			ip0_mode,
+	struct xfs_inode	*ip1,
+	uint			ip1_mode)
 {
-	xfs_inode_t		*temp;
+	struct xfs_inode	*temp;
+	uint			mode_temp;
 	int			attempts = 0;
 	xfs_log_item_t		*lp;
 
-	ASSERT(!(lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)));
-	if (lock_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL))
-		ASSERT(!(lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
+	ASSERT(hweight32(ip0_mode) == 1);
+	ASSERT(hweight32(ip1_mode) == 1);
+	ASSERT(!(ip0_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)));
+	ASSERT(!(ip1_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)));
+	ASSERT(!(ip0_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)) ||
+	       !(ip0_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
+	ASSERT(!(ip1_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)) ||
+	       !(ip1_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
+	ASSERT(!(ip1_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)) ||
+	       !(ip0_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
+	ASSERT(!(ip0_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)) ||
+	       !(ip1_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
 
 	ASSERT(ip0->i_ino != ip1->i_ino);
 
@@ -570,10 +583,13 @@ xfs_lock_two_inodes(
 		temp = ip0;
 		ip0 = ip1;
 		ip1 = temp;
+		mode_temp = ip0_mode;
+		ip0_mode = ip1_mode;
+		ip1_mode = mode_temp;
 	}
 
  again:
-	xfs_ilock(ip0, xfs_lock_inumorder(lock_mode, 0));
+	xfs_ilock(ip0, xfs_lock_inumorder(ip0_mode, 0));
 
 	/*
 	 * If the first lock we have locked is in the AIL, we must TRY to get
@@ -582,18 +598,17 @@ xfs_lock_two_inodes(
 	 */
 	lp = (xfs_log_item_t *)ip0->i_itemp;
 	if (lp && (lp->li_flags & XFS_LI_IN_AIL)) {
-		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(lock_mode, 1))) {
-			xfs_iunlock(ip0, lock_mode);
+		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(ip1_mode, 1))) {
+			xfs_iunlock(ip0, ip0_mode);
 			if ((++attempts % 5) == 0)
 				delay(1); /* Don't just spin the CPU */
 			goto again;
 		}
 	} else {
-		xfs_ilock(ip1, xfs_lock_inumorder(lock_mode, 1));
+		xfs_ilock(ip1, xfs_lock_inumorder(ip1_mode, 1));
 	}
 }
 
-
 void
 __xfs_iflock(
 	struct xfs_inode	*ip)
@@ -1421,7 +1436,7 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	xfs_lock_two_inodes(sip, tdp, XFS_ILOCK_EXCL);
+	xfs_lock_two_inodes(sip, XFS_ILOCK_EXCL, tdp, XFS_ILOCK_EXCL);
 
 	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
@@ -2585,7 +2600,7 @@ xfs_remove(
 		goto std_return;
 	}
 
-	xfs_lock_two_inodes(dp, ip, XFS_ILOCK_EXCL);
+	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
 
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 386b0bb..3e8dc99 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -423,7 +423,8 @@ void		xfs_iunpin_wait(xfs_inode_t *);
 #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
 
 int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
-void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
+void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
+				struct xfs_inode *ip1, uint ip1_mode);
 
 xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
 xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index bac464f..bcc58c2 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -944,7 +944,7 @@ xfs_reflink_set_inode_flag(
 	if (src->i_ino == dest->i_ino)
 		xfs_ilock(src, XFS_ILOCK_EXCL);
 	else
-		xfs_lock_two_inodes(src, dest, XFS_ILOCK_EXCL);
+		xfs_lock_two_inodes(src, XFS_ILOCK_EXCL, dest, XFS_ILOCK_EXCL);
 
 	if (!xfs_is_reflink_inode(src)) {
 		trace_xfs_reflink_set_inode_flag(src);
@@ -1324,7 +1324,8 @@ xfs_reflink_remap_range(
 	if (same_inode)
 		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
 	else
-		xfs_lock_two_inodes(src, dest, XFS_MMAPLOCK_EXCL);
+		xfs_lock_two_inodes(src, XFS_MMAPLOCK_EXCL, dest,
+				XFS_MMAPLOCK_EXCL);
 
 	/* Check file eligibility and prepare for block sharing. */
 	ret = -EINVAL;

