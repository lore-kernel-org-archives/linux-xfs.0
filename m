Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6R5iW52167606 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 00:44:32 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 608FC12BB468
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 22:54:54 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	bR44VrEQfPC2Ux3i for <xfs@oss.sgi.com>;
	Mon, 26 Jul 2010 22:54:54 -0700 (PDT)
Received: from dastard (unverified [121.44.18.238])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	32959310-1927428
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 15:17:34 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Odd0o-0004HY-1h
	for xfs@oss.sgi.com; Tue, 27 Jul 2010 15:47:34 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Odd0l-0002og-5H
	for xfs@oss.sgi.com; Tue, 27 Jul 2010 15:47:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: don't hold the XFS_ILOCK while flushing pages in swapext
Date: Tue, 27 Jul 2010 15:47:31 +1000
Message-Id: <1280209651-10800-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Otherwise it'll deadlock during allocation/block mapping.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dfrag.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index 3b9582c..f04a79a 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -229,29 +229,34 @@ xfs_swap_extents(
 	 * below.
 	 */
 	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
+
+	/*
+	 * can't hold the ILOCK while flushing pages, so flush now we won't get
+	 * new pages cached as we hold the XFS_IOLOCK_EXCL.
+	 */
+	if (VN_CACHED(VFS_I(tip)) != 0) {
+		error = xfs_flushinval_pages(tip, 0, -1,
+				FI_REMAPF_LOCKED);
+		if (error)
+			goto out_unlock;
+	}
+
 	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
 
-	/* Verify that both files have the same format */
-	if ((ip->i_d.di_mode & S_IFMT) != (tip->i_d.di_mode & S_IFMT)) {
+	/* Verify we have no cached pages for ftmp */
+	if (VN_CACHED(VFS_I(tip)) != 0) {
 		error = XFS_ERROR(EINVAL);
 		goto out_unlock;
 	}
 
-	/* Verify both files are either real-time or non-realtime */
-	if (XFS_IS_REALTIME_INODE(ip) != XFS_IS_REALTIME_INODE(tip)) {
+	/* Verify that both files have the same format */
+	if ((ip->i_d.di_mode & S_IFMT) != (tip->i_d.di_mode & S_IFMT)) {
 		error = XFS_ERROR(EINVAL);
 		goto out_unlock;
 	}
 
-	if (VN_CACHED(VFS_I(tip)) != 0) {
-		error = xfs_flushinval_pages(tip, 0, -1,
-				FI_REMAPF_LOCKED);
-		if (error)
-			goto out_unlock;
-	}
-
-	/* Verify O_DIRECT for ftmp */
-	if (VN_CACHED(VFS_I(tip)) != 0) {
+	/* Verify both files are either real-time or non-realtime */
+	if (XFS_IS_REALTIME_INODE(ip) != XFS_IS_REALTIME_INODE(tip)) {
 		error = XFS_ERROR(EINVAL);
 		goto out_unlock;
 	}
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
