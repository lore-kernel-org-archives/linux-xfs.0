Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DNcTYv117276 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 18:38:29 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	DD1fQFcKX59UXybi for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 16:38:27 -0700 (PDT)
Date: Sat, 14 Apr 2012 09:38:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/18 V2] xfs: pass shutdown method into
	xfs_trans_ail_delete_bulk
Message-ID: <20120413233825.GT6734@dastard>
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-3-git-send-email-david@fromorbit.com>
	<4F88651E.2030908@sgi.com> <20120413230451.GS6734@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120413230451.GS6734@dastard>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Sat, Apr 14, 2012 at 09:04:51AM +1000, Dave Chinner wrote:
> On Fri, Apr 13, 2012 at 12:40:46PM -0500, Mark Tinguely wrote:
> > On 04/13/12 07:10, Dave Chinner wrote:
> > >From: Dave Chinner<dchinner@redhat.com>
> > >
> > >xfs_trans_ail_delete_bulk() can be called from different contexts so
> > >if the item is not in the AIL we need different shutdown for each
> > >context.  Pass in the shutdown method needed so the correct action
> > >can be taken.
> > >
> > >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> > >Reviewed-by: Christoph Hellwig<hch@lst.de>
> > >Reviewed-by: Mark Tinguely<tinguely@sgi.com>
> > 
> > 
> > 
> > These items in my copy of Christoph's xfsbufd series are not
> > resolved in this patch:
> 
> Ah, oh, that's my fault. I re-ordered the series so that all my
> patches were after christoph's, and when reapplying christophs
> patches from my series there were a few merge conflicts I obviously
> didn't resolve correctly.
> 
> I'll fix my tree up and repost this patch.

Updated patch below.

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>

---
 fs/xfs/xfs_buf_item.c     |    4 ++--
 fs/xfs/xfs_dquot.c        |    5 +++--
 fs/xfs/xfs_dquot_item.c   |    2 +-
 fs/xfs/xfs_extfree_item.c |    3 ++-
 fs/xfs/xfs_inode.c        |    4 ++--
 fs/xfs/xfs_inode_item.c   |   23 +++++++++++++----------
 fs/xfs/xfs_inode_item.h   |    2 +-
 fs/xfs/xfs_log_recover.c  |    3 ++-
 fs/xfs/xfs_sync.c         |    2 +-
 fs/xfs/xfs_trans_ail.c    |    5 +++--
 fs/xfs/xfs_trans_priv.h   |    8 +++++---
 11 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index fb20f38..7f0abea 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -454,7 +454,7 @@ xfs_buf_item_unpin(
 			bp->b_iodone = NULL;
 		} else {
 			spin_lock(&ailp->xa_lock);
-			xfs_trans_ail_delete(ailp, (xfs_log_item_t *)bip);
+			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
 			ASSERT(bp->b_fspriv == NULL);
 		}
@@ -1006,6 +1006,6 @@ xfs_buf_iodone(
 	 * Either way, AIL is useless if we're forcing a shutdown.
 	 */
 	spin_lock(&ailp->xa_lock);
-	xfs_trans_ail_delete(ailp, lip);
+	xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
 	xfs_buf_item_free(BUF_ITEM(lip));
 }
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 65b8aa3..7bf3855 100644
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
@@ -909,7 +909,8 @@ xfs_qm_dqflush(
 
 		spin_lock(&mp->m_ail->xa_lock);
 		if (lip->li_flags & XFS_LI_IN_AIL)
-			xfs_trans_ail_delete(mp->m_ail, lip);
+			xfs_trans_ail_delete(mp->m_ail, lip,
+					     SHUTDOWN_CORRUPT_INCORE);
 		else
 			spin_unlock(&mp->m_ail->xa_lock);
 		error = XFS_ERROR(EIO);
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 9c5d58d..aa6a2a6 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -384,7 +384,7 @@ xfs_qm_qoffend_logitem_committed(
 	 * xfs_trans_ail_delete() drops the AIL lock.
 	 */
 	spin_lock(&ailp->xa_lock);
-	xfs_trans_ail_delete(ailp, (xfs_log_item_t *)qfs);
+	xfs_trans_ail_delete(ailp, &qfs->qql_item, SHUTDOWN_LOG_IO_ERROR);
 
 	kmem_free(qfs);
 	kmem_free(qfe);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 1a40dd7..1c57eb9 100644
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
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index acd846d..65d7d99 100644
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
@@ -2482,7 +2482,7 @@ abort_out:
 	/*
 	 * Unlocks the flush lock
 	 */
-	xfs_iflush_abort(ip);
+	xfs_iflush_abort(ip, false);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 8aaebb2..3f96a94 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -777,7 +777,8 @@ xfs_iflush_done(
 			ASSERT(i <= need_ail);
 		}
 		/* xfs_trans_ail_delete_bulk() drops the AIL lock. */
-		xfs_trans_ail_delete_bulk(ailp, log_items, i);
+		xfs_trans_ail_delete_bulk(ailp, log_items, i,
+					  SHUTDOWN_CORRUPT_INCORE);
 	}
 
 
@@ -798,16 +799,15 @@ xfs_iflush_done(
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
 
@@ -817,7 +817,10 @@ xfs_iflush_abort(
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
@@ -844,7 +847,7 @@ xfs_istale_done(
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
index 5e864a9..396e3bf 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2645,7 +2645,8 @@ xlog_recover_efd_pass2(
 				 * xfs_trans_ail_delete() drops the
 				 * AIL lock.
 				 */
-				xfs_trans_ail_delete(ailp, lip);
+				xfs_trans_ail_delete(ailp, lip,
+						     SHUTDOWN_CORRUPT_INCORE);
 				xfs_efi_item_free(efip);
 				spin_lock(&ailp->xa_lock);
 				break;
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 67f3ea6..f7f019f 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -680,7 +680,7 @@ restart:
 		goto reclaim;
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
-		xfs_iflush_abort(ip);
+		xfs_iflush_abort(ip, false);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip)) {
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 99106f1..cd2fde7 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -717,7 +717,8 @@ void
 xfs_trans_ail_delete_bulk(
 	struct xfs_ail		*ailp,
 	struct xfs_log_item	**log_items,
-	int			nr_items) __releases(ailp->xa_lock)
+	int			nr_items,
+	int			shutdown_type) __releases(ailp->xa_lock)
 {
 	xfs_log_item_t		*mlip;
 	int			mlip_changed = 0;
@@ -735,7 +736,7 @@ xfs_trans_ail_delete_bulk(
 				xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
 		"%s: attempting to delete a log item that is not in the AIL",
 						__func__);
-				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+				xfs_force_shutdown(mp, shutdown_type);
 			}
 			return;
 		}
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index dd2742f..da03d1a 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -93,14 +93,16 @@ xfs_trans_ail_update(
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
