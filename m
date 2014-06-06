Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F2CB7F51
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 03:23:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 86F278F8037
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 01:23:05 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	OkA9EER7uvVDchTI for <xfs@oss.sgi.com>;
	Fri, 06 Jun 2014 01:23:03 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WspQN-000328-AY
	for xfs@oss.sgi.com; Fri, 06 Jun 2014 18:22:55 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1WspQN-0006qs-9m
	for xfs@oss.sgi.com; Fri, 06 Jun 2014 18:22:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: fix swapext ilock deadlock
Date: Fri,  6 Jun 2014 18:22:52 +1000
Message-Id: <1402042973-26276-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1402042973-26276-1-git-send-email-david@fromorbit.com>
References: <1402042973-26276-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

xfs_swap_extents() holds the ilock over a call to
filemap_write_and_wait(), which can then try to write data and take
the ilock. That causes a self-deadlock.

Fix the deadlock and clean up the code by separating the locking
appropriately. Add a lockflags variable to track what locks we are
holding as we gain and drop them and cleanup the error handling to
always use "out_unlock" with the lockflags variable.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 703b3ec..948eba1 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1686,6 +1686,7 @@ xfs_swap_extents(
 	int		aforkblks = 0;
 	int		taforkblks = 0;
 	__uint64_t	tmp;
+	int		lock_flags;
 
 	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
 	if (!tempifp) {
@@ -1694,13 +1695,13 @@ xfs_swap_extents(
 	}
 
 	/*
-	 * we have to do two separate lock calls here to keep lockdep
-	 * happy. If we try to get all the locks in one call, lock will
-	 * report false positives when we drop the ILOCK and regain them
-	 * below.
+	 * Lock up the inodes against other IO and truncate to begin with.
+	 * Then we can ensure the inodes are flushed and have no page cache
+	 * safely. Once we have done this we can take the ilocks and do the rest
+	 * of the checks.
 	 */
+	lock_flags = XFS_IOLOCK_EXCL;
 	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
-	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
 
 	/* Verify that both files have the same format */
 	if ((ip->i_d.di_mode & S_IFMT) != (tip->i_d.di_mode & S_IFMT)) {
@@ -1719,6 +1720,9 @@ xfs_swap_extents(
 		goto out_unlock;
 	truncate_pagecache_range(VFS_I(tip), 0, -1);
 
+	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
+	lock_flags |= XFS_ILOCK_EXCL;
+
 	/* Verify O_DIRECT for ftmp */
 	if (VN_CACHED(VFS_I(tip)) != 0) {
 		error = XFS_ERROR(EINVAL);
@@ -1773,6 +1777,7 @@ xfs_swap_extents(
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(tip, XFS_ILOCK_EXCL);
+	lock_flags &= ~XFS_ILOCK_EXCL;
 
 	/*
 	 * There is a race condition here since we gave up the
@@ -1785,13 +1790,11 @@ xfs_swap_extents(
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SWAPEXT);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
-	if (error) {
-		xfs_iunlock(ip,  XFS_IOLOCK_EXCL);
-		xfs_iunlock(tip, XFS_IOLOCK_EXCL);
-		xfs_trans_cancel(tp, 0);
-		goto out;
-	}
+	if (error)
+		goto out_trans_cancel;
+
 	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
+	lock_flags |= XFS_ILOCK_EXCL;
 
 	/*
 	 * Count the number of extended attribute blocks
@@ -1810,8 +1813,8 @@ xfs_swap_extents(
 			goto out_trans_cancel;
 	}
 
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_trans_ijoin(tp, tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, lock_flags);
+	xfs_trans_ijoin(tp, tip, lock_flags);
 
 	/*
 	 * Before we've swapped the forks, lets set the owners of the forks
@@ -1940,8 +1943,8 @@ out:
 	return error;
 
 out_unlock:
-	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, lock_flags);
+	xfs_iunlock(tip, lock_flags);
 	goto out;
 
 out_trans_cancel:
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
