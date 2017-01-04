Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968898AbdADSqP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Jan 2017 13:46:15 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7F8454D68F
        for <linux-xfs@vger.kernel.org>; Wed,  4 Jan 2017 18:46:16 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (dhcp-27-38.brq.redhat.com [10.34.27.38])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v04IkFof021693
        for <linux-xfs@vger.kernel.org>; Wed, 4 Jan 2017 13:46:15 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] [RFC] Propagate error state from buffers to the objects attached
Date: Wed,  4 Jan 2017 19:46:09 +0100
Message-Id: <20170104184609.1102-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

I've been working on a problem regarding buffers that failed to be written back
not being retried as they should, because the items attached to it were flush
locked.

Discussing the problem previously with Dave and Brian, Dave suggested that first
we create an error propagation model, so notify items in case of a failure with
the buffer.

Based on that discussion, I've been playing with a prototype for this, and I
thought about sending it here so I can get some extra input about the model and
if I'm on the right direction (or not :)

The basic idea is to modify xfs_buf_iodone_callbacks() to trigger the iodone
callbacks of the items attached to the buffer, or, in case of failure, trigger a
callback to notify the items about the error, where, we can propagate the buffer
error flags to the items attached to it.

Currently, we only run the callbacks in case of success or a permanent error,
items are not aware of any temporary error, since no callbacks are triggered,
which (in my specific case), can lead to an item to be flush locked forever.

I though that xfs_item_ops structure fits well for an error notification
callback.

xfs_inode_item_push() is a place where we keep spinning in the items deadly
flush locked, so I've added some code there just for my testing here.

Does this notification model makes sense? Anything that I am missing? This is
the first time I'm working into buffer code, so I'm not much sure if what I'm
doing is right or not, so any comments are much appreciated.

I expect to send a 'final version' of this patch together with the fix for the
flush deadlocked items, but I want to make sure that I'm following the right
direction with this error propagation model.

Cheers

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf_item.c   | 27 ++++++++++++++++++++++++++-
 fs/xfs/xfs_inode.h      |  2 ++
 fs/xfs/xfs_inode_item.c | 24 +++++++++++++++++++++++-
 fs/xfs/xfs_trans.h      |  1 +
 4 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 2975cb2..14355ea 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1051,6 +1051,28 @@ xfs_buf_do_callbacks(
 	}
 }
 
+/*
+ * We can't modify the list buffer item list here, it is supposed to be called
+ * on temporary I/O errors only, such buffer list can be used again
+ */
+STATIC void
+xfs_buf_do_callbacks_fail(
+	struct xfs_buf		*bp)
+{
+	struct xfs_log_item	*lip, *next;
+	unsigned int		bflags = bp->b_flags;
+
+	lip = bp->b_fspriv;
+	while (lip != NULL) {
+		next = lip->li_bio_list;
+
+		if(lip->li_ops->iop_error)
+			lip->li_ops->iop_error(lip, bflags);
+
+		lip = next;
+	}
+}
+
 static bool
 xfs_buf_iodone_callback_error(
 	struct xfs_buf		*bp)
@@ -1148,13 +1170,16 @@ void
 xfs_buf_iodone_callbacks(
 	struct xfs_buf		*bp)
 {
+
 	/*
 	 * If there is an error, process it. Some errors require us
 	 * to run callbacks after failure processing is done so we
 	 * detect that and take appropriate action.
 	 */
-	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
+	if (bp->b_error && xfs_buf_iodone_callback_error(bp)) {
+		xfs_buf_do_callbacks_fail(bp);
 		return;
+	}
 
 	/*
 	 * Successful IO or permanent error. Either way, we can clear the
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 10dcf27..f98b0c6 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -232,6 +232,8 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
  */
 #define XFS_IRECOVERY		(1 << 11)
 
+#define XFS_IBFAIL		(1 << 12) /* Failed to flush buffer */
+
 /*
  * Per-lifetime flags need to be reset when re-using a reclaimable inode during
  * inode lookup. This prevents unintended behaviour on the new inode from
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index d90e781..70206c61 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -475,6 +475,17 @@ xfs_inode_item_unpin(
 		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
 }
 
+STATIC void
+xfs_inode_item_error(
+	struct xfs_log_item	*lip,
+	unsigned int		bflags)
+{
+	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
+
+	if (bflags & XBF_WRITE_FAIL)
+		ip->i_flags |= XFS_IBFAIL;
+}
+
 STATIC uint
 xfs_inode_item_push(
 	struct xfs_log_item	*lip,
@@ -512,6 +523,16 @@ xfs_inode_item_push(
 	}
 
 	/*
+	 * EXAMPLE:
+	 *	Have we already tried to submit the buffer attached to this
+	 *	inode, and has it failed?
+	 */
+	if (ip->i_flags & XFS_IBFAIL) {
+		printk("XFS: %s: inode buffer already submitted. ino: %llu\n",
+		       __func__, ip->i_ino);
+	}
+
+	/*
 	 * Someone else is already flushing the inode.  Nothing we can do
 	 * here but wait for the flush to finish and remove the item from
 	 * the AIL.
@@ -622,7 +643,8 @@ static const struct xfs_item_ops xfs_inode_item_ops = {
 	.iop_unlock	= xfs_inode_item_unlock,
 	.iop_committed	= xfs_inode_item_committed,
 	.iop_push	= xfs_inode_item_push,
-	.iop_committing = xfs_inode_item_committing
+	.iop_committing = xfs_inode_item_committing,
+	.iop_error	= xfs_inode_item_error
 };
 
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 61b7fbd..e620e6a 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -80,6 +80,7 @@ struct xfs_item_ops {
 	void (*iop_unlock)(xfs_log_item_t *);
 	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
 	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
+	void (*iop_error)(struct xfs_log_item *, unsigned int bflags);
 };
 
 void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
-- 
2.9.3

