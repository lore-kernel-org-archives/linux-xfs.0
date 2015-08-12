Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 17FB77F50
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 08:00:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 030E68F804C
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 06:00:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8OKcPOCsCEYvyRIa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 06:00:56 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 44B183812B0
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 13:00:55 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-184.bos.redhat.com [10.18.41.184])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7CD0sNx017527
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 09:00:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 12/13] xfs: add helper to conditionally remove items from
	the AIL
Date: Wed, 12 Aug 2015 09:00:53 -0400
Message-Id: <1439384453-34048-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1439233309-19959-13-git-send-email-bfoster@redhat.com>
References: <1439233309-19959-13-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Several areas of code duplicate a pattern where we take the AIL lock,
check whether an item is in the AIL and remove it if so. Create a new
helper for this pattern and use it where appropriate.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v4:
- Drop the xfs_ail parameter and use the AIL reference from the log item.

 fs/xfs/xfs_buf_item.c     |  6 +-----
 fs/xfs/xfs_dquot.c        |  8 ++------
 fs/xfs/xfs_extfree_item.c | 14 +-------------
 fs/xfs/xfs_inode_item.c   | 11 ++---------
 fs/xfs/xfs_trans_priv.h   | 15 +++++++++++++++
 5 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 092d652..919057e 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -647,11 +647,7 @@ xfs_buf_item_unlock(
 			xfs_buf_item_relse(bp);
 		else if (aborted) {
 			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
-			if (lip->li_flags & XFS_LI_IN_AIL) {
-				spin_lock(&lip->li_ailp->xa_lock);
-				xfs_trans_ail_delete(lip->li_ailp, lip,
-						     SHUTDOWN_LOG_IO_ERROR);
-			}
+			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
 		}
 	}
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 4143dc7..6964d7c 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -954,12 +954,8 @@ xfs_qm_dqflush(
 		struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
 		dqp->dq_flags &= ~XFS_DQ_DIRTY;
 
-		spin_lock(&mp->m_ail->xa_lock);
-		if (lip->li_flags & XFS_LI_IN_AIL)
-			xfs_trans_ail_delete(mp->m_ail, lip,
-					     SHUTDOWN_CORRUPT_INCORE);
-		else
-			spin_unlock(&mp->m_ail->xa_lock);
+		xfs_trans_ail_remove(lip, SHUTDOWN_CORRUPT_INCORE);
+
 		error = -EIO;
 		goto out_unlock;
 	}
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index ce1d4fb..4aa0153 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -286,20 +286,8 @@ void
 xfs_efi_release(
 	struct xfs_efi_log_item	*efip)
 {
-	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
-
 	if (atomic_dec_and_test(&efip->efi_refcount)) {
-		spin_lock(&ailp->xa_lock);
-		/*
-		 * We don't know whether the EFI made it to the AIL. Remove it
-		 * if so. Note that xfs_trans_ail_delete() drops the AIL lock.
-		 */
-		if (efip->efi_item.li_flags & XFS_LI_IN_AIL)
-			xfs_trans_ail_delete(ailp, &efip->efi_item,
-					     SHUTDOWN_LOG_IO_ERROR);
-		else
-			spin_unlock(&ailp->xa_lock);
-
+		xfs_trans_ail_remove(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_efi_item_free(efip);
 	}
 }
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index bf13a5a..62bd80f 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -703,17 +703,10 @@ xfs_iflush_abort(
 	xfs_inode_log_item_t	*iip = ip->i_itemp;
 
 	if (iip) {
-		struct xfs_ail	*ailp = iip->ili_item.li_ailp;
 		if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
-			spin_lock(&ailp->xa_lock);
-			if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
-				/* xfs_trans_ail_delete() drops the AIL lock. */
-				xfs_trans_ail_delete(ailp, &iip->ili_item,
-						stale ?
-						     SHUTDOWN_LOG_IO_ERROR :
+			xfs_trans_ail_remove(&iip->ili_item,
+					     stale ? SHUTDOWN_LOG_IO_ERROR :
 						     SHUTDOWN_CORRUPT_INCORE);
-			} else
-				spin_unlock(&ailp->xa_lock);
 		}
 		iip->ili_logged = 0;
 		/*
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 1b73629..49931b7 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -119,6 +119,21 @@ xfs_trans_ail_delete(
 	xfs_trans_ail_delete_bulk(ailp, &lip, 1, shutdown_type);
 }
 
+static inline void
+xfs_trans_ail_remove(
+	struct xfs_log_item	*lip,
+	int			shutdown_type)
+{
+	struct xfs_ail		*ailp = lip->li_ailp;
+
+	spin_lock(&ailp->xa_lock);
+	/* xfs_trans_ail_delete() drops the AIL lock */
+	if (lip->li_flags & XFS_LI_IN_AIL)
+		xfs_trans_ail_delete(ailp, lip, shutdown_type);
+	else
+		spin_unlock(&ailp->xa_lock);
+}
+
 void			xfs_ail_push(struct xfs_ail *, xfs_lsn_t);
 void			xfs_ail_push_all(struct xfs_ail *);
 void			xfs_ail_push_all_sync(struct xfs_ail *);
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
