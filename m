Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06N8V1h120045 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 17:08:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1C411C35D04
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2010 15:09:22 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	sWZ8JqoCf04na1dO for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2010 15:09:22 -0800 (PST)
Received: from discord (unverified [121.44.238.220])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11070984-1927428
	for <xfs@oss.sgi.com>; Thu, 07 Jan 2010 09:39:20 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NSf0B-0000jT-Bk
	for xfs@oss.sgi.com; Thu, 07 Jan 2010 10:09:19 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NSewT-00073u-0o
	for xfs@oss.sgi.com; Thu, 07 Jan 2010 10:05:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: reclaim all inodes by background tree walks
Date: Thu,  7 Jan 2010 10:05:25 +1100
Message-Id: <1262819125-27083-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1262819125-27083-1-git-send-email-david@fromorbit.com>
References: <1262819125-27083-1-git-send-email-david@fromorbit.com>
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

We cannot do direct inode reclaim without taking the flush lock to
ensure that we do not reclaim an inode under IO. We check the inode
is clean before doing direct reclaim, but this is not good enough
because the inode flush code marks the inode clean once it has
copied the in-core dirty state to the backing buffer.

It is the flush lock that determines whether the inode is still
under IO, even though it is marked clean, and the inode is still
required at IO completion so we can't reclaim it even though it is
clean in core. Hence the requirement that we need to take the
flush lock even on clean inodes because this guarantees that the
inode writeback IO has completed and it is safe to reclaim the
inode.

With delayed write inode flushing, we coul dend up waiting a long
time on the flush lock even for a clean inode. The background
reclaim already handles this efficiently, so avoid all the problems
by killing the direct reclaim path altogether.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   14 ++++++--------
 fs/xfs/linux-2.6/xfs_sync.c  |   11 ++++++++++-
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index f3dd67d..23768f4 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -953,16 +953,14 @@ xfs_fs_destroy_inode(
 	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
 
 	/*
-	 * If we have nothing to flush with this inode then complete the
-	 * teardown now, otherwise delay the flush operation.
+	 * we always use background reclaim here because even if the
+	 * inode is clean, it still may be under IO and hence we have
+	 * to take the flush lock. The background reclaim path handles
+	 * this more efficiently than we can here, so simply let background
+	 * reclaim tear down all inodes.
 	 */
-	if (!xfs_inode_clean(ip)) {
-		xfs_inode_set_reclaim_tag(ip);
-		return;
-	}
-
 out_reclaim:
-	xfs_ireclaim(ip);
+	xfs_inode_set_reclaim_tag(ip);
 }
 
 /*
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 6d1cd6e..a1d7876 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -700,6 +700,8 @@ xfs_reclaim_inode(
 	/*
 	 * In the case of a forced shutdown we rely on xfs_iflush() to
 	 * wait for the inode to be unpinned before returning an error.
+	 * Because we hold the flush lock, we know that the inode cannot
+	 * be under IO, so if it reports clean it can be reclaimed.
 	 */
 	if (!is_bad_inode(VFS_I(ip)) && !xfs_inode_clean(ip)) {
 		/*
@@ -726,9 +728,16 @@ xfs_reclaim_inode(
 	return 0;
 
 unlock_and_requeue:
+	/*
+	 * We could return EAGAIN here to make reclaim rescan the inode tree in
+	 * a short while. However, this just burns CPU time scanning the tree
+	 * waiting for IO to complete and xfssyncd never goes back to the idle
+	 * state. Instead, return 0 to let the next scheduled background reclaim
+	 * attempt to reclaim the inode again.
+	 */
 	xfs_iflags_clear(ip, XFS_IRECLAIM);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return EAGAIN;
+	return 0;
 }
 
 void
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
