Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:26658 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750989AbeCGJK2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Mar 2018 04:10:28 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1etV5b-0000q5-75
        for linux-xfs@vger.kernel.org; Wed, 07 Mar 2018 20:10:23 +1100
Received: from dave by discord.disaster.area with local (Exim 4.90_1)
        (envelope-from <david@fromorbit.com>)
        id 1etV5b-0001eR-5q
        for linux-xfs@vger.kernel.org; Wed, 07 Mar 2018 20:10:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: fix double ijoin in xfs_inactive_symlink_rmt()
Date: Wed,  7 Mar 2018 20:10:19 +1100
Message-Id: <20180307091020.6186-2-david@fromorbit.com>
In-Reply-To: <20180307091020.6186-1-david@fromorbit.com>
References: <20180307091020.6186-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_inactive_symlink_rmt() does something nasty - it joins an inode
into a transaction it is already joined to. This means the inode can
have multiple log item descriptors attached to the transaction for
it. This breaks teh 1:1 mapping that is supposed to exist
between the log item and log item descriptor.

This results in the log item being processed twice during
transaction commit and CIL formatting, and there are lots of other
potential issues tha arise from double processing of log items in
the transaction commit state machine.

In this case, the inode is already held by the rolling transaction
returned from xfs_defer_finish(), so there's no need to join it
again.

Also add a log item flag to say the item has been joined to a
transaction and assert that it's not set when adding a log item to a
transaction. Clear it when the log item is disconnected from the log
item descriptor. This will tell us if there are other log items that
transactions are referencing multiple times.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_symlink.c | 9 ++-------
 fs/xfs/xfs_trans.c   | 7 +++++--
 fs/xfs/xfs_trans.h   | 4 +++-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 2e9e793a8f9d..b0502027070e 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -488,16 +488,11 @@ xfs_inactive_symlink_rmt(
 	error = xfs_defer_finish(&tp, &dfops);
 	if (error)
 		goto error_bmap_cancel;
-	/*
-	 * The first xact was committed, so add the inode to the new one.
-	 * Mark it dirty so it will be logged and moved forward in the log as
-	 * part of every commit.
-	 */
-	xfs_trans_ijoin(tp, ip, 0);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
 	/*
 	 * Commit the transaction containing extent freeing and EFDs.
 	 */
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = xfs_trans_commit(tp);
 	if (error) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 86f92df32c42..2aeeb2ad276a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -737,12 +737,14 @@ xfs_trans_add_item(
 
 	ASSERT(lip->li_mountp == tp->t_mountp);
 	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
+	ASSERT(!(lip->li_flags & XFS_LI_TRANS));
 
 	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP | KM_NOFS);
 
 	lidp->lid_item = lip;
 	lidp->lid_flags = 0;
 	list_add_tail(&lidp->lid_trans, &tp->t_items);
+	lip->li_flags |= XFS_LI_TRANS;
 
 	lip->li_desc = lidp;
 }
@@ -762,6 +764,7 @@ void
 xfs_trans_del_item(
 	struct xfs_log_item	*lip)
 {
+	lip->li_flags &= ~XFS_LI_TRANS;
 	xfs_trans_free_item_desc(lip->li_desc);
 	lip->li_desc = NULL;
 }
@@ -781,15 +784,15 @@ xfs_trans_free_items(
 	list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
 		struct xfs_log_item	*lip = lidp->lid_item;
 
-		lip->li_desc = NULL;
+		xfs_trans_del_item(lip);
 
 		if (commit_lsn != NULLCOMMITLSN)
 			lip->li_ops->iop_committing(lip, commit_lsn);
 		if (abort)
 			lip->li_flags |= XFS_LI_ABORTED;
+
 		lip->li_ops->iop_unlock(lip);
 
-		xfs_trans_free_item_desc(lidp);
 	}
 }
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9d542dfe0052..c514486ba2a0 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -67,11 +67,13 @@ typedef struct xfs_log_item {
 #define	XFS_LI_IN_AIL	0x1
 #define	XFS_LI_ABORTED	0x2
 #define	XFS_LI_FAILED	0x4
+#define	XFS_LI_TRANS	0x8	/* attached to an active transaction */
 
 #define XFS_LI_FLAGS \
 	{ XFS_LI_IN_AIL,	"IN_AIL" }, \
 	{ XFS_LI_ABORTED,	"ABORTED" }, \
-	{ XFS_LI_FAILED,	"FAILED" }
+	{ XFS_LI_FAILED,	"FAILED" }, \
+	{ XFS_LI_TRANS,		"TRANS" }
 
 struct xfs_item_ops {
 	void (*iop_size)(xfs_log_item_t *, int *, int *);
-- 
2.16.1

