Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xFft127368 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:15 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	BwgOu60PI82TJi9L for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:13 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCIo-0001Zf-DJ
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCIo-0004XB-9f
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/37] xfs: remove log item from AIL in xfs_qm_dqflush after a
	shutdown
Date: Mon, 23 Apr 2012 15:58:31 +1000
Message-Id: <1335160747-17254-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

If a filesystem has been forced shutdown we are never going to write dquots
to disk, which means the dquot items will stay in the AIL forever.
Currently that is not a problem, but a pending chance requires us to
empty the AIL before shutting down the filesystem, in which case this
behaviour is lethal.  Make sure to remove the log item from the AIL
to allow emptying the AIL on shutdown filesystems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_dquot.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 1155208..e2f6f7c 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -904,10 +904,22 @@ xfs_qm_dqflush(
 	/*
 	 * This may have been unpinned because the filesystem is shutting
 	 * down forcibly. If that's the case we must not write this dquot
-	 * to disk, because the log record didn't make it to disk!
+	 * to disk, because the log record didn't make it to disk.
+	 *
+	 * We also have to remove the log item from the AIL in this case,
+	 * as we wait for an emptry AIL as part of the unmount process.
 	 */
 	if (XFS_FORCED_SHUTDOWN(mp)) {
+		struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
 		dqp->dq_flags &= ~XFS_DQ_DIRTY;
+
+		spin_lock(&mp->m_ail->xa_lock);
+		if (lip->li_flags & XFS_LI_IN_AIL)
+			xfs_trans_ail_delete(mp->m_ail, lip,
+					     SHUTDOWN_CORRUPT_INCORE);
+		else
+			spin_unlock(&mp->m_ail->xa_lock);
+
 		xfs_dqfunlock(dqp);
 		return XFS_ERROR(EIO);
 	}
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
