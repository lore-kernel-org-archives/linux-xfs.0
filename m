Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34478 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753569AbdKXMD7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Nov 2017 07:03:59 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E3E4A1438
        for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2017 12:03:59 +0000 (UTC)
Received: from odin.localdomain.com (unknown [10.40.205.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C26CA61784
        for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2017 12:03:58 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs: Properly retry failed dquot items in case of error during buffer writeback
Date: Fri, 24 Nov 2017 13:03:53 +0100
Message-Id: <20171124120353.30997-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Once the inode item writeback errors is already fixed, it's time to fix the same
problem in dquot code.

Although there were no reports of users hitting this bug in dquot code (at least
none I've seen), the bug is there and I was already planning to fix it when the
correct approach to fix the inodes part was decided.

This patch aims to fix the same problem in dquot code, regarding failed buffers
being unable to be resubmitted once they are flush locked.

Tested with the recently test-case sent to fstests list by Hou Tao.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

>From RFC:
	- ASSERT the correct dquot flush lock in xfs_dquot_item_error()

	As in the inode item error path, we ASSERT the inode flush lock is
	properly locked when settin XFS_LI_FAILED to the log item. I'm not 100%
	sure I've handled the dquot flush lock properly. Once dquot uses a
	completion queue as a flush lock, I used completion_done() helper to
	check if it's properly locked, but I'm not 100% sure if it is the right
	approach, once it uses a spin_lock/unlock irqsave/restore, and I don't
	know if in this code path it is ok to run such spin locks.
	What you guys think?

with flush lock
	- add an extra couple of parenthesis in xfs_qm_dqflush_done() as
	  suggested by Darrick.


 fs/xfs/xfs_dquot.c      | 11 ++++++++---
 fs/xfs/xfs_dquot_item.c | 38 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index d57c2db64e59..a77b5c8e4f6b 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -970,14 +970,19 @@ xfs_qm_dqflush_done(
 	 * holding the lock before removing the dquot from the AIL.
 	 */
 	if ((lip->li_flags & XFS_LI_IN_AIL) &&
-	    lip->li_lsn == qip->qli_flush_lsn) {
+	   ((lip->li_lsn == qip->qli_flush_lsn) ||
+	    lip->li_flags & XFS_LI_FAILED)) {
 
 		/* xfs_trans_ail_delete() drops the AIL lock. */
 		spin_lock(&ailp->xa_lock);
-		if (lip->li_lsn == qip->qli_flush_lsn)
+		if (lip->li_lsn == qip->qli_flush_lsn) {
 			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
-		else
+		} else if (lip->li_flags & XFS_LI_FAILED) {
+			xfs_clear_li_failed(lip);
 			spin_unlock(&ailp->xa_lock);
+		} else {
+			spin_unlock(&ailp->xa_lock);
+		}
 	}
 
 	/*
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 2c7a1629e064..3d73a0124988 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -137,6 +137,24 @@ xfs_qm_dqunpin_wait(
 	wait_event(dqp->q_pinwait, (atomic_read(&dqp->q_pincount) == 0));
 }
 
+/*
+ * Callback used to mark a buffer with XFS_LI_FAILED when items in the buffer
+ * have been failed during writeback
+ *
+ * this informs the AIL that the dquot is already flush locked on the next push,
+ * and acquires a hold on the buffer to ensure that it isn't reclaimed before
+ * dirty data makes it to disk.
+ */
+STATIC void
+xfs_dquot_item_error(
+	struct xfs_log_item	*lip,
+	struct xfs_buf		*bp)
+{
+	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
+	ASSERT(!completion_done(&dqp->q_flush));
+	xfs_set_li_failed(lip, bp);
+}
+
 STATIC uint
 xfs_qm_dquot_logitem_push(
 	struct xfs_log_item	*lip,
@@ -144,13 +162,28 @@ xfs_qm_dquot_logitem_push(
 					      __acquires(&lip->li_ailp->xa_lock)
 {
 	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
-	struct xfs_buf		*bp = NULL;
+	struct xfs_buf		*bp = lip->li_buf;
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
 	if (atomic_read(&dqp->q_pincount) > 0)
 		return XFS_ITEM_PINNED;
 
+	/*
+	 * The buffer containing this item failed to be written back
+	 * previously. Resubmit the buffer for IO
+	 */
+	if (lip->li_flags & XFS_LI_FAILED) {
+		if (!xfs_buf_trylock(bp))
+			return XFS_ITEM_LOCKED;
+
+		if (!xfs_buf_resubmit_failed_buffers(bp, lip, buffer_list))
+			rval = XFS_ITEM_FLUSHING;
+
+		xfs_buf_unlock(bp);
+		return rval;
+	}
+
 	if (!xfs_dqlock_nowait(dqp))
 		return XFS_ITEM_LOCKED;
 
@@ -242,7 +275,8 @@ static const struct xfs_item_ops xfs_dquot_item_ops = {
 	.iop_unlock	= xfs_qm_dquot_logitem_unlock,
 	.iop_committed	= xfs_qm_dquot_logitem_committed,
 	.iop_push	= xfs_qm_dquot_logitem_push,
-	.iop_committing = xfs_qm_dquot_logitem_committing
+	.iop_committing = xfs_qm_dquot_logitem_committing,
+	.iop_error	= xfs_dquot_item_error
 };
 
 /*
-- 
2.14.3

