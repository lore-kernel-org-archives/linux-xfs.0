Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT0JHga069828 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 18:19:17 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82BDF13F3B2B
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 16:20:57 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	HbaVGsmzbdfBAW5z for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 16:20:57 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	48044422-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 10:50:55 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMrU3-0000Va-S6
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 11:20:43 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMrTo-00049l-Mt
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 11:20:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] xfs: avoid moving stale inodes in the AIL
Date: Mon, 29 Nov 2010 11:20:23 +1100
Message-Id: <1290990024-15898-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1290990024-15898-1-git-send-email-david@fromorbit.com>
References: <1290990024-15898-1-git-send-email-david@fromorbit.com>
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

When an inode has been marked stale because the cluster is being
freed, we don't want to (re-)insert this inode into the AIL. There
is a race condition where the cluster buffer may be unpinned before
the inode is inserted into the AIL during transaction committed
processing. If the buffer is unpinned before the inode item has been
committed and inserted, then it is possible for the buffer to be
released and hence processthe stale inode callbacks before the inode
is inserted into the AIL.

In this case, we then insert a clean, stale inode into the AIL which
will never get removed by an IO completion. It will, however, get
reclaimed and that triggers an assert in xfs_inode_free()
complaining about freeing an inode still in the AIL.

This race can be avoided by not moving stale inodes forward in the AIL
during transaction commit completion processing. This closes the
race condition by ensuring we never insert clean stale inodes into
the AIL. It is safe to do this because a dirty stale inode, by
definition, must already be in the AIL.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode_item.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index c7ac020..7c8d30c 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -657,18 +657,37 @@ xfs_inode_item_unlock(
 }
 
 /*
- * This is called to find out where the oldest active copy of the
- * inode log item in the on disk log resides now that the last log
- * write of it completed at the given lsn.  Since we always re-log
- * all dirty data in an inode, the latest copy in the on disk log
- * is the only one that matters.  Therefore, simply return the
- * given lsn.
+ * This is called to find out where the oldest active copy of the inode log
+ * item in the on disk log resides now that the last log write of it completed
+ * at the given lsn.  Since we always re-log all dirty data in an inode, the
+ * latest copy in the on disk log is the only one that matters.  Therefore,
+ * simply return the given lsn.
+ *
+ * If the inode has been marked stale because the cluster is being freed, we
+ * don't want to (re-)insert this inode into the AIL. There is a race condition
+ * where the cluster buffer may be unpinned before the inode is inserted into
+ * the AIL during transaction committed processing. If the buffer is unpinned
+ * before the inode item has been committed and inserted, then it is possible
+ * for the buffer to be written and IO completions before the inode is inserted
+ * into the AIL. In that case, we'd be inserting a clean, stale inode into the
+ * AIL which will never get removed. It will, however, get reclaimed which
+ * triggers an assert in xfs_inode_free() complaining about freein an inode
+ * still in the AIL.
+ *
+ * To avoid this, return a lower LSN than the one passed in so that the
+ * transaction committed code will not move the inode forward in the AIL but
+ * will still unpin it properly.
  */
 STATIC xfs_lsn_t
 xfs_inode_item_committed(
 	struct xfs_log_item	*lip,
 	xfs_lsn_t		lsn)
 {
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+	struct xfs_inode	*ip = iip->ili_inode;
+
+	if (xfs_iflags_test(ip, XFS_ISTALE))
+		return lsn - 1;
 	return lsn;
 }
 
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
