Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FF4rK2019618 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 10:05:10 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 792051C43C9E
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 08:04:31 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail05.adl2.internode.on.net
	[203.16.214.69]) by cuda.sgi.com with ESMTP id EFQhc6olmB01QGlF
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 08:04:31 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	43731177-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 22:16:53 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1Lionj-0006nA-Br
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 22:46:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] [XFS] Split inode data writeback from inode sync.
Date: Sun, 15 Mar 2009 22:46:38 +1100
Message-Id: <1237117603-26071-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1237117603-26071-1-git-send-email-david@fromorbit.com>
References: <1237117603-26071-1-git-send-email-david@fromorbit.com>
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

In many cases we only want to sync inode data. Start
spliting the inode sync into data sync and inode sync
by factoring out the inode data flush.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   54 +++++++++++++++++++++++++++----------------
 1 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index f7ba766..fd024e2 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -47,6 +47,37 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
+static int
+xfs_sync_inode_data(
+	struct xfs_inode	*ip,
+	int			flags)
+{
+	struct inode	*inode = VFS_I(ip);
+	int		error = 0;
+
+	if (VN_DIRTY(inode)) {
+		int	locked = 0;
+		if (flags & SYNC_TRYLOCK) {
+			if (xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
+				locked = 1;
+		} else {
+			xfs_ilock(ip, XFS_IOLOCK_SHARED);
+			locked = 1;
+		}
+		if (locked) {
+			error = xfs_flush_pages(ip, 0, -1,
+					(flags & SYNC_WAIT) ? 0 : XFS_B_ASYNC,
+					FI_NONE);
+			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+		}
+	}
+
+	if (flags & SYNC_IOWAIT)
+		xfs_ioend_wait(ip);
+
+	return error;
+}
+
 /*
  * Sync all the inodes in the given AG according to the
  * direction given by the flags.
@@ -122,27 +153,10 @@ xfs_sync_inodes_ag(
 		 * If we have to flush data or wait for I/O completion
 		 * we need to hold the iolock.
 		 */
-		if (flags & SYNC_DELWRI) {
-			if (VN_DIRTY(inode)) {
-				if (flags & SYNC_TRYLOCK) {
-					if (xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
-						lock_flags |= XFS_IOLOCK_SHARED;
-				} else {
-					xfs_ilock(ip, XFS_IOLOCK_SHARED);
-					lock_flags |= XFS_IOLOCK_SHARED;
-				}
-				if (lock_flags & XFS_IOLOCK_SHARED) {
-					error = xfs_flush_pages(ip, 0, -1,
-							(flags & SYNC_WAIT) ? 0
-								: XFS_B_ASYNC,
-							FI_NONE);
-				}
-			}
-			if (VN_CACHED(inode) && (flags & SYNC_IOWAIT))
-				xfs_ioend_wait(ip);
-		}
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
+		if (flags & SYNC_DELWRI)
+			error = xfs_sync_inode_data(ip, flags);
 
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
 		if ((flags & SYNC_ATTR) && !xfs_inode_clean(ip)) {
 			if (flags & SYNC_WAIT) {
 				xfs_iflock(ip);
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
