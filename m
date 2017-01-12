Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750929AbdALOWU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:22:20 -0500
Received: from smtp.corp.redhat.com (int-mx16.intmail.prod.int.phx2.redhat.com [10.5.11.28])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D8A2881240
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jan 2017 14:22:15 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (dhcp-27-38.brq.redhat.com [10.34.27.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C54C6D15C
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jan 2017 14:22:15 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] [WIP] Propagate error state from buffers to the objects attached
Date: Thu, 12 Jan 2017 15:22:09 +0100
Message-Id: <20170112142209.23458-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

this is a new version of my possible fix to the error propagation model plus the
fix to the locked AIL items, both things are merged together since I'm using the
fix to the locked items to test the error propagation model, I'll split them
between different patches and also include dquot fixes when we agree that I'm on
the right path.

This new version adds Brian's suggestion to use a new flag for the xfs_log_item
instead of a callback. and uses the flag into xfs_inode_item_push, to resubmit
the buffer or not.

Also, the logic about when to set the flag has been moved into
xfs_buf_iodone_callback_error, so we only check that after the last buffer
resubmission.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf_item.c   |  6 ++++++
 fs/xfs/xfs_inode_item.c | 33 +++++++++++++++++++++++++++++++--
 fs/xfs/xfs_trans.h      |  4 +++-
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 2975cb2..16896d5 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1123,6 +1123,12 @@ xfs_buf_iodone_callback_error(
 	/* still a transient error, higher layers will retry */
 	xfs_buf_ioerror(bp, 0);
 	xfs_buf_relse(bp);
+
+	/*
+	 * Notify log item that the buffer has been failed so it can be retried
+	 * later if needed
+	 */
+	lip->li_flags |= XFS_LI_FAILED;
 	return true;
 
 	/*
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index d90e781..308aa27 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -517,8 +517,37 @@ xfs_inode_item_push(
 	 * the AIL.
 	 */
 	if (!xfs_iflock_nowait(ip)) {
-		rval = XFS_ITEM_FLUSHING;
-		goto out_unlock;
+		int error;
+		struct xfs_dinode *dip;
+
+		/* Buffer carrying this item has been failed, we must resubmit
+		 * the buffer or the item will be locked forever
+		 */
+		if (lip->li_flags & XFS_LI_FAILED) {
+			printk("#### ITEM BUFFER FAILED PREVIOUSLY, inode: %llu\n",
+			       ip->i_ino);
+			error = xfs_imap_to_bp(ip->i_mount, NULL, &ip->i_imap,
+					       &dip, &bp, XBF_TRYLOCK, 0);
+
+			if (error) {
+				rval = XFS_ITEM_FLUSHING;
+				goto out_unlock;
+			}
+
+			if (!(bp->b_flags & XBF_WRITE_FAIL)) {
+				rval = XFS_ITEM_FLUSHING;
+				xfs_buf_relse(bp);
+				goto out_unlock;
+			}
+
+			if (!xfs_buf_delwri_queue(bp, buffer_list)) {
+				printk("#### QUEUEING AGAIN\n");
+				rval = XFS_ITEM_FLUSHING;
+			}
+
+			xfs_buf_relse(bp);
+			goto out_unlock;
+		}
 	}
 
 	ASSERT(iip->ili_fields != 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 61b7fbd..d62d174 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -66,10 +66,12 @@ typedef struct xfs_log_item {
 
 #define	XFS_LI_IN_AIL	0x1
 #define XFS_LI_ABORTED	0x2
+#define	XFS_LI_FAILED	0x3
 
 #define XFS_LI_FLAGS \
 	{ XFS_LI_IN_AIL,	"IN_AIL" }, \
-	{ XFS_LI_ABORTED,	"ABORTED" }
+	{ XFS_LI_ABORTED,	"ABORTED"}, \
+	{ XFS_LI_FAILED,	"FAILED" }
 
 struct xfs_item_ops {
 	void (*iop_size)(xfs_log_item_t *, int *, int *);
-- 
2.9.3

