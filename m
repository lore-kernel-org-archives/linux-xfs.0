Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751528AbdFHOA1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jun 2017 10:00:27 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5A4CA7D4E3
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2017 14:00:22 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (ovpn-204-167.brq.redhat.com [10.40.204.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B00C997DC8
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2017 14:00:21 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/2 V3] xfs: Properly retry failed inode items in case of error during buffer writeback
Date: Thu,  8 Jun 2017 16:00:14 +0200
Message-Id: <20170608140014.25132-3-cmaiolino@redhat.com>
In-Reply-To: <20170608140014.25132-1-cmaiolino@redhat.com>
References: <20170608140014.25132-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

When a buffer has been failed during writeback, the inode items into it
are kept flush locked, and are never resubmitted due the flush lock, so,
if any buffer fails to be written, the items in AIL are never written to
disk and never unlocked.

This causes unmount operation to hang due these items flush locked in AIL,
but this also causes the items in AIL to never be written back, even when
the IO device comes back to normal.

I've been testing this patch with a DM-thin device, creating a
filesystem larger than the real device.

When writing enough data to fill the DM-thin device, XFS receives ENOSPC
errors from the device, and keep spinning on xfsaild (when 'retry
forever' configuration is set).

At this point, the filesystem can not be unmounted because of the flush locked
items in AIL, but worse, the items in AIL are never retried at all
(once xfs_inode_item_push() will skip the items that are flush locked),
even if the underlying DM-thin device is expanded to the proper size.

This patch fixes both cases, retrying any item that has been failed
previously, using the infra-structure provided by the previous patch.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V2:
	- Fix XFS_LI_FAILED flag removal
	- Use atomic operations to set and clear XFS_LI_FAILED flag
	- Remove check for XBF_WRITE_FAIL in xfs_inode_item_push
	- Add more comments to the code
	- Add a helper function to resubmit the failed buffers, so this
	  can be also used in dquot system without duplicating code

V3:
	- drop xfs_imap_to_bp call using a pointer in the log item to
	  hold the buffer address, fixing a possible infinite loop if
	  xfs_map_to_bp returns -EIO
	- use xa_lock instead of atomic operations to handle log item
	  flags
	- Add a hold to the buffer for each log item failed
	- move buffer resubmission up in xfs_inode_item_push()

 fs/xfs/xfs_buf_item.c   | 39 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf_item.h   |  2 ++
 fs/xfs/xfs_inode_item.c | 44 +++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_trans.h      |  1 +
 fs/xfs/xfs_trans_ail.c  |  4 ++--
 5 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 523b7a4..9b7bd23 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1222,3 +1222,42 @@ xfs_buf_iodone(
 	xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
 	xfs_buf_item_free(BUF_ITEM(lip));
 }
+
+/*
+ * Requeue a failed buffer for writeback
+ *
+ * Return true if the buffer has been re-queued properly, false otherwise
+ */
+bool
+xfs_buf_resubmit_failed_buffers(
+	struct xfs_inode	*ip,
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
+{
+	struct xfs_log_item	*next;
+	struct xfs_buf		*bp;
+	bool			ret;
+
+	bp = lip->li_buf;
+
+	/* Clear XFS_LI_FAILED flag from all items before resubmit
+	 *
+	 * XFS_LI_FAILED set/clear is protected by xa_lock, caller  this
+	 * function already have it acquired
+	 */
+	for (; lip; lip = next) {
+		next = lip->li_bio_list;
+		lip->li_flags &= ~XFS_LI_FAILED;
+		xfs_buf_rele(bp);
+	}
+
+	/* Add this buffer back to the delayed write list */
+	xfs_buf_lock(bp);
+	if (!xfs_buf_delwri_queue(bp, buffer_list))
+		ret = false;
+	else
+		ret = true;
+
+	xfs_buf_unlock(bp);
+	return ret;
+}
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index f7eba99..32aceae 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -70,6 +70,8 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
 			      xfs_log_item_t *);
 void	xfs_buf_iodone_callbacks(struct xfs_buf *);
 void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
+bool	xfs_buf_resubmit_failed_buffers(struct xfs_inode *, struct xfs_log_item *,
+					struct list_head *);
 
 extern kmem_zone_t	*xfs_buf_item_zone;
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 08cb7d1..2f5a49e 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -27,6 +27,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_trans_priv.h"
+#include "xfs_buf_item.h"
 #include "xfs_log.h"
 
 
@@ -475,6 +476,26 @@ xfs_inode_item_unpin(
 		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
 }
 
+STATIC void
+xfs_inode_item_error(
+	struct xfs_log_item	*lip,
+	struct xfs_buf		*bp,
+	unsigned int		bflags)
+{
+
+	/*
+	 * The buffer writeback containing this inode has been failed
+	 * mark it as failed and unlock the flush lock, so it can be retried
+	 * again.
+	 * Use xa_lock to avoid races with other log item state changes.
+	 */
+	spin_lock(&lip->li_ailp->xa_lock);
+	xfs_buf_hold(bp);
+	lip->li_flags |= XFS_LI_FAILED;
+	lip->li_buf = bp;
+	spin_unlock(&lip->li_ailp->xa_lock);
+}
+
 STATIC uint
 xfs_inode_item_push(
 	struct xfs_log_item	*lip,
@@ -504,6 +525,18 @@ xfs_inode_item_push(
 	}
 
 	/*
+	 * The buffer containing this item failed to be written back
+	 * previously. Resubmit the buffer for IO.
+	 */
+	if (lip->li_flags & XFS_LI_FAILED) {
+		if (!xfs_buf_resubmit_failed_buffers(ip, lip,
+						     buffer_list))
+			rval = XFS_ITEM_FLUSHING;
+
+		goto out_unlock;
+	}
+
+	/*
 	 * Stale inode items should force out the iclog.
 	 */
 	if (ip->i_flags & XFS_ISTALE) {
@@ -622,7 +655,8 @@ static const struct xfs_item_ops xfs_inode_item_ops = {
 	.iop_unlock	= xfs_inode_item_unlock,
 	.iop_committed	= xfs_inode_item_committed,
 	.iop_push	= xfs_inode_item_push,
-	.iop_committing = xfs_inode_item_committing
+	.iop_committing = xfs_inode_item_committing,
+	.iop_error	= xfs_inode_item_error
 };
 
 
@@ -710,7 +744,8 @@ xfs_iflush_done(
 		 * the AIL lock.
 		 */
 		iip = INODE_ITEM(blip);
-		if (iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn)
+		if ((iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn) ||
+		    lip->li_flags & XFS_LI_FAILED)
 			need_ail++;
 
 		blip = next;
@@ -718,7 +753,8 @@ xfs_iflush_done(
 
 	/* make sure we capture the state of the initial inode. */
 	iip = INODE_ITEM(lip);
-	if (iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn)
+	if ((iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn) ||
+	    lip->li_flags & XFS_LI_FAILED)
 		need_ail++;
 
 	/*
@@ -739,6 +775,8 @@ xfs_iflush_done(
 			if (INODE_ITEM(blip)->ili_logged &&
 			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn)
 				mlip_changed |= xfs_ail_delete_one(ailp, blip);
+			else if (blip->li_flags & XFS_LI_FAILED)
+				blip->li_flags &= ~XFS_LI_FAILED;
 		}
 
 		if (mlip_changed) {
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 3486517..86c3464 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -49,6 +49,7 @@ typedef struct xfs_log_item {
 	struct xfs_ail			*li_ailp;	/* ptr to AIL */
 	uint				li_type;	/* item type */
 	uint				li_flags;	/* misc flags */
+	struct xfs_buf			*li_buf;	/* real buffer pointer */
 	struct xfs_log_item		*li_bio_list;	/* buffer item list */
 	void				(*li_cb)(struct xfs_buf *,
 						 struct xfs_log_item *);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 9056c0f..36e08dd 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -687,13 +687,13 @@ xfs_trans_ail_update_bulk(
 bool
 xfs_ail_delete_one(
 	struct xfs_ail		*ailp,
-	struct xfs_log_item 	*lip)
+	struct xfs_log_item	*lip)
 {
 	struct xfs_log_item	*mlip = xfs_ail_min(ailp);
 
 	trace_xfs_ail_delete(lip, mlip->li_lsn, lip->li_lsn);
 	xfs_ail_delete(ailp, lip);
-	lip->li_flags &= ~XFS_LI_IN_AIL;
+	lip->li_flags &= ~(XFS_LI_IN_AIL | XFS_LI_FAILED);
 	lip->li_lsn = 0;
 
 	return mlip == lip;
-- 
2.9.3

