Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0ANtLXi064765 for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 17:55:21 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FC74157A13
	for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 15:56:15 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	CxotBOOVSD6v95Dp for <xfs@oss.sgi.com>;
	Sun, 10 Jan 2010 15:56:15 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11344157-1927428
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 10:26:14 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NU7da-0002qV-Kg
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 10:56:02 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NU7ZY-0007Yt-LV
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 10:51:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: reclaim all inodes by background tree walks
Date: Mon, 11 Jan 2010 10:51:47 +1100
Message-Id: <1263167508-9346-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1263167508-9346-1-git-send-email-david@fromorbit.com>
References: <1263167508-9346-1-git-send-email-david@fromorbit.com>
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
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 09783cc..384bd96 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -954,16 +954,14 @@ xfs_fs_destroy_inode(
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
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
