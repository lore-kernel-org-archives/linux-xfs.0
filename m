Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BBmf31137521 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 05:48:42 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F63C1588B1
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 03:49:34 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	1XATouC7JlFibX1R for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2010 03:49:34 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11367060-1927428
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 22:19:33 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NUIm3-0003eX-IW
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:49:31 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NUIi1-0005VH-AO
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:45:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix stale inode flush avoidance
Date: Mon, 11 Jan 2010 22:45:21 +1100
Message-Id: <1263210321-21068-1-git-send-email-david@fromorbit.com>
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

When reclaiming stale inodes, we need to guarantee that inodes are
unpinned before returning with a "clean" status. If we don't we can
reclaim inodes that are pinned, leading to use after free in the
transaction subsystem as transactions complete.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_inode.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 391d36b..ef77fd8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2842,13 +2842,9 @@ xfs_iflush(
 
 	/*
 	 * If the inode isn't dirty, then just release the inode flush lock and
-	 * do nothing. Treat stale inodes the same; we cannot rely on the
-	 * backing buffer remaining stale in cache for the remaining life of
-	 * the stale inode and so xfs_itobp() below may give us a buffer that
-	 * no longer contains inodes below. Doing this stale check here also
-	 * avoids forcing the log on pinned, stale inodes.
+	 * do nothing.
 	 */
-	if (xfs_inode_clean(ip) || xfs_iflags_test(ip, XFS_ISTALE)) {
+	if (xfs_inode_clean(ip)) {
 		xfs_ifunlock(ip);
 		return 0;
 	}
@@ -2872,6 +2868,19 @@ xfs_iflush(
 	xfs_iunpin_wait(ip);
 
 	/*
+	 * For stale inodes we cannot rely on the backing buffer remaining
+	 * stale in cache for the remaining life of the stale inode and so
+	 * xfs_itobp() below may give us a buffer that no longer contains
+	 * inodes below. We have to check this after ensuring the inode is
+	 * unpinned so that it is safe to reclaim the stale inode after the
+	 * flush call.
+	 */
+	if (xfs_iflags_test(ip, XFS_ISTALE)) {
+		xfs_ifunlock(ip);
+		return 0;
+	}
+
+	/*
 	 * This may have been unpinned because the filesystem is shutting
 	 * down forcibly. If that's the case we must not write this inode
 	 * to disk, because the log record didn't make it to disk!
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
