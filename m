Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o022gP78051762 for <xfs@oss.sgi.com>; Fri, 1 Jan 2010 20:42:25 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73C311DAB36D
	for <xfs@oss.sgi.com>; Fri,  1 Jan 2010 18:43:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	dGksxI35Ac4rdvPS for <xfs@oss.sgi.com>;
	Fri, 01 Jan 2010 18:43:13 -0800 (PST)
Received: from discord (unverified [121.44.238.220])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10818608-1927428
	for <xfs@oss.sgi.com>; Sat, 02 Jan 2010 13:13:12 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NQtxO-0007wo-Tg
	for xfs@oss.sgi.com; Sat, 02 Jan 2010 13:43:10 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NQtu0-00051S-43
	for xfs@oss.sgi.com; Sat, 02 Jan 2010 13:39:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] XFS: Don't flush stale inodes
Date: Sat,  2 Jan 2010 13:39:40 +1100
Message-Id: <1262399980-19277-1-git-send-email-david@fromorbit.com>
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

Because inodes remain in cache much longer than inode buffers do
under memory pressure, we can get the situation where we have stale,
dirty inodes being reclaimed but the backing storage has been freed.
Hence we should never, ever flush XFS_ISTALE inodes to disk as
there is no guarantee that the backing buffer is in cache and
still marked stale when the flush occurs.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_inode.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c2618db..e5c9953 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2846,10 +2846,14 @@ xfs_iflush(
 	mp = ip->i_mount;
 
 	/*
-	 * If the inode isn't dirty, then just release the inode
-	 * flush lock and do nothing.
+	 * If the inode isn't dirty, then just release the inode flush lock and
+	 * do nothing. Treat stale inodes the same; we cannot rely on the
+	 * backing buffer remaining stale in cache for the remaining life of
+	 * the stale inode and so xfs_itobp() below may give us a buffer that
+	 * no longer contains inodes below. Doing this stale check here also
+	 * avoids forcing the log on pinned, stale inodes.
 	 */
-	if (xfs_inode_clean(ip)) {
+	if (xfs_inode_clean(ip) || xfs_iflags_test(ip, XFS_ISTALE)) {
 		xfs_ifunlock(ip);
 		return 0;
 	}
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
