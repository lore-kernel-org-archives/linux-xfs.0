Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2BMetIS194285 for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 16:40:55 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B13881D2DEA8
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 14:42:27 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	Pns773JKlns6nTyg for <xfs@oss.sgi.com>;
	Thu, 11 Mar 2010 14:42:27 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/19] xfs: Don't flush stale inodes
Date: Fri, 12 Mar 2010 09:42:06 +1100
Message-Id: <1268347337-7160-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1268347337-7160-1-git-send-email-david@fromorbit.com>
References: <1268347337-7160-1-git-send-email-david@fromorbit.com>
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
To: stable@kernel.org
Cc: xfs@oss.sgi.com

>From 44e08c45cc14e6190a424be8d450070c8e508fad
Date: Sat, 2 Jan 2010 02:39:40 +0000
Because inodes remain in cache much longer than inode buffers do
under memory pressure, we can get the situation where we have
stale, dirty inodes being reclaimed but the backing storage has
been freed.  Hence we should never, ever flush XFS_ISTALE inodes
to disk as there is no guarantee that the backing buffer is in
cache and still marked stale when the flush occurs.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_inode.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b92a4fa..13d7d21 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2877,10 +2877,14 @@ xfs_iflush(
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
