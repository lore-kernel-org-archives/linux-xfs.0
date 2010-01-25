Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0P6LwD4037528 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 00:21:58 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB2A31C767A7
	for <xfs@oss.sgi.com>; Sun, 24 Jan 2010 22:23:00 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	r9wBg5HaAT7ANqaN for <xfs@oss.sgi.com>;
	Sun, 24 Jan 2010 22:23:00 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11565360-1927428
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 16:52:59 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NZILi-0002xZ-HL
	for xfs@oss.sgi.com; Mon, 25 Jan 2010 17:22:58 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NZILX-0003oD-Gx
	for xfs@oss.sgi.com; Mon, 25 Jan 2010 17:22:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/7] xfs: xfs_fs_write_inode() can fail to write inodes
	synchronously
Date: Mon, 25 Jan 2010 17:22:44 +1100
Message-Id: <1264400564-19704-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1264400564-19704-1-git-send-email-david@fromorbit.com>
References: <1264400564-19704-1-git-send-email-david@fromorbit.com>
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

When an inode has already be flushed delayed write,
xfs_inode_clean() returns true and hence xfs_fs_write_inode() can
return on a synchronous inode write without having written the
inode. Currently these sycnhronous writes only come from the unmount
path or the nfsd on a synchronous export so should be fairly rare.

Realistically, a synchronous inode write is not necessary here; we
can treat this like fsync where we either force the log if there are
no unlogged changes, or do a sync transaction if there are unlogged
changes. The will result real synchronous semantics as the fsync
will issue barriers, but may slow down the above two configurations
as a result. However, if the inode is not pinned and has no unlogged
changes, then the fsync code is a no-op and hence it may be faster
than the existing code.

For the asynchronous write, move the clean check until after we have
locked up the inode. With the inode locked and the flush lock held,
we know that if the inodis clean there are no pending changes in the
log and there are no current outstanding delayed writes or IO in
progress, so if it reports clean now it really is clean. This matches
the order of locking and checks in xfs_sync_inode_attr().

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   44 ++++++++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 5ed0468..4cfc82a 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1045,14 +1045,18 @@ xfs_fs_write_inode(
 		error = xfs_wait_on_pages(ip, 0, -1);
 		if (error)
 			goto out;
+		/*
+		 * The fsync operation makes inode changes stable and it
+		 * reduces the IOs we have to do here from two (log and inode)
+		 * to just the log. We still need to do a delwri write of the
+		 * inode after this to flush it to the bacing buffer so that
+		 * bulkstat works properly.
+		 */
+		error = xfs_fsync(ip);
+		if (error)
+			goto out;
 	}
 
-	/*
-	 * Bypass inodes which have already been cleaned by
-	 * the inode flush clustering code inside xfs_iflush
-	 */
-	if (xfs_inode_clean(ip))
-		goto out;
 
 	/*
 	 * We make this non-blocking if the inode is contended, return
@@ -1060,20 +1064,24 @@ xfs_fs_write_inode(
 	 * This prevents the flush path from blocking on inodes inside
 	 * another operation right now, they get caught later by xfs_sync.
 	 */
-	if (sync) {
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-		xfs_iflock(ip);
-
-		error = xfs_iflush(ip, SYNC_WAIT);
-	} else {
-		error = EAGAIN;
-		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
-			goto out;
-		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
-			goto out_unlock;
+	error = EAGAIN;
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
+		goto out;
+	if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
+		goto out_unlock;
 
-		error = xfs_iflush(ip, 0);
+	/*
+	 * Now we have the flush lock and the inode is not pinned, we can check
+	 * if the inode is really clean as we know that there are no pending
+	 * transaction completions, it is not waiting on the delayed write
+	 * queue and there is no IO in progress.
+	 */
+	error = 0;
+	if (xfs_inode_clean(ip)) {
+		xfs_ifunlock(ip);
+		goto out_unlock;
 	}
+	error = xfs_iflush(ip, 0);
 
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
