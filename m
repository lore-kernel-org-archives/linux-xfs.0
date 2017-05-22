Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935334AbdEVPc3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 11:32:29 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF72C80C1D
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2017 15:32:28 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (ovpn-204-168.brq.redhat.com [10.40.204.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40F3E7A406
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2017 15:32:28 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 3/3 V2] xfs: Properly retry failed inode items in case of error during buffer writeback
Date: Mon, 22 May 2017 17:32:20 +0200
Message-Id: <20170522153220.25072-4-cmaiolino@redhat.com>
In-Reply-To: <20170522153220.25072-1-cmaiolino@redhat.com>
References: <20170522153220.25072-1-cmaiolino@redhat.com>
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

 fs/xfs/xfs_buf_item.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf_item.h   |  2 ++
 fs/xfs/xfs_inode_item.c | 36 +++++++++++++++++++++++++++++++++++-
 3 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 8f128e3..4b68b27 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -29,6 +29,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_inode.h"
 
 
 kmem_zone_t	*xfs_buf_item_zone;
@@ -1226,3 +1227,44 @@ xfs_buf_iodone(
 	xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
 	xfs_buf_item_free(BUF_ITEM(lip));
 }
+
+/* Requeue a failed buffer for writeback
+ *
+ * Return true if the buffer has been re-queued properly, false otherwise
+ *
+ */
+bool
+xfs_buf_resubmit_failed_buffers(
+	struct xfs_inode	*ip,
+	struct xfs_log_item	*lip,
+	struct xfs_buf		*bp,
+	struct list_head	*buffer_list)
+{
+	struct xfs_dinode	*dip;
+	struct xfs_log_item	*next;
+	int			error;
+	bool			ret;
+
+	error = xfs_imap_to_bp(ip->i_mount, NULL, &ip->i_imap,
+			       &dip, &bp, XBF_TRYLOCK, 0);
+
+		if (error)
+			return false;
+
+		/* Clear XFS_LI_FAILED flag from all items before resubmit */
+		while (lip != NULL) {
+			next = lip->li_bio_list;
+
+			clear_bit(XFS_LI_FAILED, &lip->li_flags);
+			lip = next;
+		}
+
+		/* Add this buffer back to the delayed write list */
+		if (!xfs_buf_delwri_queue(bp, buffer_list))
+			ret = false;
+		else
+			ret = true;
+
+		xfs_buf_relse(bp);
+		return ret;
+}
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index f7eba99..7340c64 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -70,6 +70,8 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
 			      xfs_log_item_t *);
 void	xfs_buf_iodone_callbacks(struct xfs_buf *);
 void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
+bool	xfs_buf_resubmit_failed_buffers(struct xfs_inode *, struct xfs_log_item *,
+					struct xfs_buf *, struct list_head *);
 
 extern kmem_zone_t	*xfs_buf_item_zone;
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index eeeadbb..97db299 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -27,6 +27,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_trans_priv.h"
+#include "xfs_buf_item.h"
 #include "xfs_log.h"
 
 
@@ -475,6 +476,24 @@ xfs_inode_item_unpin(
 		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
 }
 
+STATIC void
+xfs_inode_item_error(
+	struct xfs_log_item	*lip,
+	unsigned int		bflags)
+{
+
+	/*
+	 * The buffer writeback containing this inode has been failed
+	 * mark it as failed and unlock the flush lock, so it can be retried
+	 * again.
+	 * It requires an atomic operation, once the parent object is not locked
+	 * in this context, and we need to avoid races with other log item state
+	 * changes.
+	 */
+	if (bflags & XBF_WRITE_FAIL)
+		set_bit(XFS_LI_FAILED, &lip->li_flags);
+}
+
 STATIC uint
 xfs_inode_item_push(
 	struct xfs_log_item	*lip,
@@ -517,8 +536,22 @@ xfs_inode_item_push(
 	 * the AIL.
 	 */
 	if (!xfs_iflock_nowait(ip)) {
+
+		/*
+		 * The buffer containing this item failed to be written back
+		 * previously. Resubmit the buffer for IO.
+		 */
+		if (lip->li_flags & XFS_LI_FAILED) {
+			if (!xfs_buf_resubmit_failed_buffers(ip, lip, bp,
+							     buffer_list))
+				rval = XFS_ITEM_FLUSHING;
+
+			goto out_unlock;
+		}
+
 		rval = XFS_ITEM_FLUSHING;
 		goto out_unlock;
+
 	}
 
 	ASSERT(iip->ili_fields != 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
@@ -622,7 +655,8 @@ static const struct xfs_item_ops xfs_inode_item_ops = {
 	.iop_unlock	= xfs_inode_item_unlock,
 	.iop_committed	= xfs_inode_item_committed,
 	.iop_push	= xfs_inode_item_push,
-	.iop_committing = xfs_inode_item_committing
+	.iop_committing = xfs_inode_item_committing,
+	.iop_error	= xfs_inode_item_error
 };
 
 
-- 
2.9.3

