Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2N1m0d8071392 for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 20:48:00 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	H3OFKIqvufl3brsR for <xfs@oss.sgi.com>;
	Thu, 22 Mar 2012 18:47:58 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SAtbe-0005K4-F5
	for xfs@oss.sgi.com; Fri, 23 Mar 2012 12:47:54 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SAtbW-0003OW-E3
	for xfs@oss.sgi.com; Fri, 23 Mar 2012 12:47:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: avoid shutdown hang in xlog_wait()
Date: Fri, 23 Mar 2012 12:47:43 +1100
Message-Id: <1332467263-12985-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1332467263-12985-1-git-send-email-david@fromorbit.com>
References: <1332467263-12985-1-git-send-email-david@fromorbit.com>
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

When a shutdown is triggered from failing to find an item in the AIL
during delete, we can be called from either metadata IO completion
context or from log IO completion context. In the case of log IO
completion context, we must indicate that this is a log error so
that the forced shutdown does not attempt to flush the log.

To flush the log whilst in log IO completion will cause a deadlock
as the shutdown won't proceed until log IO completes, and log Io
cannot complete because it has blocked waiting for itself to
complete....

We delete items in the AIL from log IO completion when we are
unpinning in-memory only items, or items that do not require
writeback to remove from the AIL (e.g. EFI/EFD items). Hence there
are several locations that need this treatment.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c     |    2 +-
 fs/xfs/xfs_dquot_item.c   |    2 +-
 fs/xfs/xfs_extfree_item.c |    2 +-
 fs/xfs/xfs_inode.c        |    4 ++--
 fs/xfs/xfs_inode_item.c   |    6 ++++--
 fs/xfs/xfs_inode_item.h   |    2 +-
 6 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3e5f654..07fac37 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -460,7 +460,7 @@ xfs_buf_item_unpin(
 			error = xfs_trans_ail_delete(ailp, lip);
 			if (error == EFSCORRUPTED)
 				xfs_force_shutdown(ailp->xa_mount,
-						   SHUTDOWN_CORRUPT_INCORE);
+						   SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
 			ASSERT(bp->b_fspriv == NULL);
 		}
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 69a098c..452fb24 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -457,7 +457,7 @@ xfs_qm_qoffend_logitem_committed(
 	spin_lock(&ailp->xa_lock);
 	error = xfs_trans_ail_delete(ailp, (struct xfs_log_item *)qfs);
 	if (error == EFSCORRUPTED)
-		xfs_force_shutdown(ailp->xa_mount, SHUTDOWN_CORRUPT_INCORE);
+		xfs_force_shutdown(ailp->xa_mount, SHUTDOWN_LOG_IO_ERROR);
 
 	kmem_free(qfs);
 	kmem_free(qfe);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 4ccf2b6..40d1b0e 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -69,7 +69,7 @@ __xfs_efi_release(
 		error = xfs_trans_ail_delete(ailp, &efip->efi_item);
 		if (error == EFSCORRUPTED)
 			xfs_force_shutdown(ailp->xa_mount,
-						SHUTDOWN_CORRUPT_INCORE);
+						SHUTDOWN_LOG_IO_ERROR);
 		xfs_efi_item_free(efip);
 	}
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bc46c0a..4fb2e99 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2377,7 +2377,7 @@ cluster_corrupt_out:
 	/*
 	 * Unlocks the flush lock
 	 */
-	xfs_iflush_abort(iq);
+	xfs_iflush_abort(iq, false);
 	kmem_free(ilist);
 	xfs_perag_put(pag);
 	return XFS_ERROR(EFSCORRUPTED);
@@ -2503,7 +2503,7 @@ cluster_corrupt_out:
 	/*
 	 * Unlocks the flush lock
 	 */
-	xfs_iflush_abort(ip);
+	xfs_iflush_abort(ip, false);
 	return XFS_ERROR(EFSCORRUPTED);
 }
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index b0a813f..bd7fd73 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -883,7 +883,8 @@ xfs_iflush_done(
  */
 void
 xfs_iflush_abort(
-	xfs_inode_t		*ip)
+	struct xfs_inode	*ip,
+	bool			stale)
 {
 	xfs_inode_log_item_t	*iip = ip->i_itemp;
 
@@ -898,6 +899,7 @@ xfs_iflush_abort(
 							(xfs_log_item_t *)iip);
 				if (error == EFSCORRUPTED)
 					xfs_force_shutdown(ailp->xa_mount,
+						stale ? SHUTDOWN_LOG_IO_ERROR :
 							SHUTDOWN_CORRUPT_INCORE);
 			} else
 				spin_unlock(&ailp->xa_lock);
@@ -925,7 +927,7 @@ xfs_istale_done(
 	struct xfs_buf		*bp,
 	struct xfs_log_item	*lip)
 {
-	xfs_iflush_abort(INODE_ITEM(lip)->ili_inode);
+	xfs_iflush_abort(INODE_ITEM(lip)->ili_inode, true);
 }
 
 /*
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 41d61c3..376d4d0 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -165,7 +165,7 @@ extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
 extern void xfs_inode_item_destroy(struct xfs_inode *);
 extern void xfs_iflush_done(struct xfs_buf *, struct xfs_log_item *);
 extern void xfs_istale_done(struct xfs_buf *, struct xfs_log_item *);
-extern void xfs_iflush_abort(struct xfs_inode *);
+extern void xfs_iflush_abort(struct xfs_inode *, bool);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 					 xfs_inode_log_format_t *);
 
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
