Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2R9kJPk258534 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 04:46:20 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	IZWIZzbatVJm7Vh7 for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 02:46:16 -0700 (PDT)
Date: Tue, 27 Mar 2012 20:45:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2] shutdown hang fix (was Re: [PATCH 2/2] xfs: avoid
	shutdown hang in xlog_wait())
Message-ID: <20120327094547.GZ5091@dastard>
References: <1332467263-12985-1-git-send-email-david@fromorbit.com>
	<1332467263-12985-3-git-send-email-david@fromorbit.com>
	<20120324170302.GB21708@infradead.org>
	<20120324224648.GF5091@dastard>
	<20120325112801.GA7157@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120325112801.GA7157@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Mar 25, 2012 at 07:28:01AM -0400, Christoph Hellwig wrote:
> On Sun, Mar 25, 2012 at 09:46:49AM +1100, Dave Chinner wrote:
> > > Looks good.  I wonder if it might be simple to simply pass a flags
> > > argument to xfs_ail_delete(_bulk) which tells which kind of shutdown
> > > to do.
> > 
> > I thought about doing that, but it seems strange and unusual to tell
> > code how to handle errors internally instead of returning the error
> > and letting the caller handle it...
> > 
> > I don't mind either way, though. If you prefer I pass in the
> > shutdown flag, I can change it all to do that....
> 
> I don't have a strong opinion.  Moving the shutdown to the caller is
> cleaner for sure, but it's a lot of churn when the other version would

Ok, Here's a "pass-in-the-shutdown-method" version of the change.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: pass shutdown method into xfs_trans_ail_delete_bulk

From: Dave Chinner <dchinner@redhat.com>

xfs_trans_ail_delete_bulk() can be called from different contexts so
if the item is not in the AIL we need different shutdown for each
context.  Pass in the shutdown method needed so the correct action
can be taken.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_buf_item.c     |    4 ++--
 fs/xfs/xfs_dquot.c        |    2 +-
 fs/xfs/xfs_dquot_item.c   |    2 +-
 fs/xfs/xfs_extfree_item.c |    3 ++-
 fs/xfs/xfs_iget.c         |    3 ++-
 fs/xfs/xfs_inode.c        |    4 ++--
 fs/xfs/xfs_inode_item.c   |   23 +++++++++++++----------
 fs/xfs/xfs_inode_item.h   |    2 +-
 fs/xfs/xfs_log_recover.c  |    3 ++-
 fs/xfs/xfs_trans_ail.c    |    5 +++--
 fs/xfs/xfs_trans_priv.h   |    8 +++++---
 11 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index eac97ef..8111a65 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -455,7 +455,7 @@ xfs_buf_item_unpin(
 			bp->b_iodone = NULL;
 		} else {
 			spin_lock(&ailp->xa_lock);
-			xfs_trans_ail_delete(ailp, (xfs_log_item_t *)bip);
+			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
 			ASSERT(bp->b_fspriv == NULL);
 		}
@@ -1045,6 +1045,6 @@ xfs_buf_iodone(
 	 * Either way, AIL is useless if we're forcing a shutdown.
 	 */
 	spin_lock(&ailp->xa_lock);
-	xfs_trans_ail_delete(ailp, lip);
+	xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
 	xfs_buf_item_free(BUF_ITEM(lip));
 }
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 1155208..abbdb7a 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -857,7 +857,7 @@ xfs_qm_dqflush_done(
 		/* xfs_trans_ail_delete() drops the AIL lock. */
 		spin_lock(&ailp->xa_lock);
 		if (lip->li_lsn == qip->qli_flush_lsn)
-			xfs_trans_ail_delete(ailp, lip);
+			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
 		else
 			spin_unlock(&ailp->xa_lock);
 	}
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 34baeae..4e3127b 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -454,7 +454,7 @@ xfs_qm_qoffend_logitem_committed(
 	 * xfs_trans_ail_delete() drops the AIL lock.
 	 */
 	spin_lock(&ailp->xa_lock);
-	xfs_trans_ail_delete(ailp, (xfs_log_item_t *)qfs);
+	xfs_trans_ail_delete(ailp, &qfs->qql_item, SHUTDOWN_LOG_IO_ERROR);
 
 	kmem_free(qfs);
 	kmem_free(qfe);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 35c2aff..be61d1d 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -64,7 +64,8 @@ __xfs_efi_release(
 	if (!test_and_clear_bit(XFS_EFI_COMMITTED, &efip->efi_flags)) {
 		spin_lock(&ailp->xa_lock);
 		/* xfs_trans_ail_delete() drops the AIL lock. */
-		xfs_trans_ail_delete(ailp, &efip->efi_item);
+		xfs_trans_ail_delete(ailp, &efip->efi_item,
+				     SHUTDOWN_LOG_IO_ERROR);
 		xfs_efi_item_free(efip);
 	}
 }
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index bcc6c24..b9df823 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -136,7 +136,8 @@ xfs_inode_free(
 		if (lip->li_flags & XFS_LI_IN_AIL) {
 			spin_lock(&ailp->xa_lock);
 			if (lip->li_flags & XFS_LI_IN_AIL)
-				xfs_trans_ail_delete(ailp, lip);
+				xfs_trans_ail_delete(ailp, lip,
+						     SHUTDOWN_CORRUPT_INCORE);
 			else
 				spin_unlock(&ailp->xa_lock);
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
index 05d924e..696f565 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -848,7 +848,8 @@ xfs_iflush_done(
 			ASSERT(i <= need_ail);
 		}
 		/* xfs_trans_ail_delete_bulk() drops the AIL lock. */
-		xfs_trans_ail_delete_bulk(ailp, log_items, i);
+		xfs_trans_ail_delete_bulk(ailp, log_items, i,
+					  SHUTDOWN_CORRUPT_INCORE);
 	}
 
 
@@ -869,16 +870,15 @@ xfs_iflush_done(
 }
 
 /*
- * This is the inode flushing abort routine.  It is called
- * from xfs_iflush when the filesystem is shutting down to clean
- * up the inode state.
- * It is responsible for removing the inode item
- * from the AIL if it has not been re-logged, and unlocking the inode's
- * flush lock.
+ * This is the inode flushing abort routine.  It is called from xfs_iflush when
+ * the filesystem is shutting down to clean up the inode state.  It is
+ * responsible for removing the inode item from the AIL if it has not been
+ * re-logged, and unlocking the inode's flush lock.
  */
 void
 xfs_iflush_abort(
-	xfs_inode_t		*ip)
+	xfs_inode_t		*ip,
+	bool			stale)
 {
 	xfs_inode_log_item_t	*iip = ip->i_itemp;
 
@@ -888,7 +888,10 @@ xfs_iflush_abort(
 			spin_lock(&ailp->xa_lock);
 			if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
 				/* xfs_trans_ail_delete() drops the AIL lock. */
-				xfs_trans_ail_delete(ailp, (xfs_log_item_t *)iip);
+				xfs_trans_ail_delete(ailp, &iip->ili_item,
+						stale ?
+						     SHUTDOWN_LOG_IO_ERROR :
+						     SHUTDOWN_CORRUPT_INCORE);
 			} else
 				spin_unlock(&ailp->xa_lock);
 		}
@@ -915,7 +918,7 @@ xfs_istale_done(
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
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7c75c73..41f0694 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2642,7 +2642,8 @@ xlog_recover_efd_pass2(
 				 * xfs_trans_ail_delete() drops the
 				 * AIL lock.
 				 */
-				xfs_trans_ail_delete(ailp, lip);
+				xfs_trans_ail_delete(ailp, lip,
+						     SHUTDOWN_CORRUPT_INCORE);
 				xfs_efi_item_free(efip);
 				spin_lock(&ailp->xa_lock);
 				break;
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 1dead07..a6016e4 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -700,7 +700,8 @@ void
 xfs_trans_ail_delete_bulk(
 	struct xfs_ail		*ailp,
 	struct xfs_log_item	**log_items,
-	int			nr_items) __releases(ailp->xa_lock)
+	int			nr_items,
+	int			shutdown_type) __releases(ailp->xa_lock)
 {
 	xfs_log_item_t		*mlip;
 	int			mlip_changed = 0;
@@ -718,7 +719,7 @@ xfs_trans_ail_delete_bulk(
 				xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
 		"%s: attempting to delete a log item that is not in the AIL",
 						__func__);
-				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+				xfs_force_shutdown(mp, shutdown_type);
 			}
 			return;
 		}
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 8ab2ced..449c881 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -90,14 +90,16 @@ xfs_trans_ail_update(
 }
 
 void	xfs_trans_ail_delete_bulk(struct xfs_ail *ailp,
-				struct xfs_log_item **log_items, int nr_items)
+				struct xfs_log_item **log_items, int nr_items,
+				int shutdown_type)
 				__releases(ailp->xa_lock);
 static inline void
 xfs_trans_ail_delete(
 	struct xfs_ail	*ailp,
-	xfs_log_item_t	*lip) __releases(ailp->xa_lock)
+	xfs_log_item_t	*lip,
+	int		shutdown_type) __releases(ailp->xa_lock)
 {
-	xfs_trans_ail_delete_bulk(ailp, &lip, 1);
+	xfs_trans_ail_delete_bulk(ailp, &lip, 1, shutdown_type);
 }
 
 void			xfs_ail_push(struct xfs_ail *, xfs_lsn_t);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
