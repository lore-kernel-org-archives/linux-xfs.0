Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FF4sV9019619 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 10:05:15 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2EB4219A47E
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 08:04:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail02.adl2.internode.on.net
	[203.16.214.66]) by cuda.sgi.com with ESMTP id OnUDtZFTiBiZYosr
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 08:04:32 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	354575713-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 22:16:54 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1Lionj-0006nF-Fy
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 22:46:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] [XFS] Use xfs_inode_flush() in xfs_sync_inodes_ag()
Date: Sun, 15 Mar 2009 22:46:39 +1100
Message-Id: <1237117603-26071-3-git-send-email-david@fromorbit.com>
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

xfs_sync_inodes_ag() effectively open-codes xfs_inode_flush()
to do blocking vs non-blocking inode flushing. It doesn't have
all the optimisations that xfs_inode_flush() has but does
the same thing. Call xfs_inode_flush() instead.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   63 +++++++++++++++++++++++++++++++-----------
 1 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index fd024e2..b3d4f7a 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -43,6 +43,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_inode_item.h"
 #include "xfs_rw.h"
+#include "linux-2.6/xfs_vnode.h"
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -78,6 +79,47 @@ xfs_sync_inode_data(
 	return error;
 }
 
+static int
+xfs_sync_inode_flush(
+	struct xfs_inode	*ip,
+	int			flags)
+{
+	int		error = 0;
+
+	/*
+	 * Bypass inodes which have already been cleaned by
+	 * the inode flush clustering code inside xfs_iflush
+	 */
+	if (xfs_inode_clean(ip))
+		return 0;
+
+	/*
+	 * We make this non-blocking if the inode is contended,
+	 * return EAGAIN to indicate to the caller that they
+	 * did not succeed. This prevents the flush path from
+	 * blocking on inodes inside another operation right
+	 * now, they get caught later by xfs_sync.
+	 */
+	if (flags & SYNC_WAIT) {
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
+		xfs_iflock(ip);
+
+		error = xfs_iflush(ip, XFS_IFLUSH_SYNC);
+	} else {
+		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
+			goto out;
+		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
+			goto out_unlock;
+
+		error = xfs_iflush(ip, XFS_IFLUSH_ASYNC_NOBLOCK);
+	}
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+out:
+	return error;
+}
+
 /*
  * Sync all the inodes in the given AG according to the
  * direction given by the flags.
@@ -97,7 +139,6 @@ xfs_sync_inodes_ag(
 	do {
 		struct inode	*inode;
 		xfs_inode_t	*ip = NULL;
-		int		lock_flags = XFS_ILOCK_SHARED;
 
 		/*
 		 * use a gang lookup to find the next inode in the tree
@@ -156,22 +197,10 @@ xfs_sync_inodes_ag(
 		if (flags & SYNC_DELWRI)
 			error = xfs_sync_inode_data(ip, flags);
 
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-		if ((flags & SYNC_ATTR) && !xfs_inode_clean(ip)) {
-			if (flags & SYNC_WAIT) {
-				xfs_iflock(ip);
-				if (!xfs_inode_clean(ip))
-					error = xfs_iflush(ip, XFS_IFLUSH_SYNC);
-				else
-					xfs_ifunlock(ip);
-			} else if (xfs_iflock_nowait(ip)) {
-				if (!xfs_inode_clean(ip))
-					error = xfs_iflush(ip, XFS_IFLUSH_DELWRI);
-				else
-					xfs_ifunlock(ip);
-			}
-		}
-		xfs_iput(ip, lock_flags);
+		if (flags & SYNC_ATTR)
+			error = xfs_sync_inode_flush(ip, flags);
+
+		IRELE(ip);
 
 		if (error)
 			last_error = error;
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
