Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753743AbdGTNPQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 09:15:16 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC6103D94F
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 13:15:15 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (ovpn-204-190.brq.redhat.com [10.40.204.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 229847C1DC
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 13:15:13 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/2 V6] xfs: Add infrastructure needed for error propagation during buffer IO failure
Date: Thu, 20 Jul 2017 15:15:07 +0200
Message-Id: <20170720131508.13582-2-cmaiolino@redhat.com>
In-Reply-To: <20170720131508.13582-1-cmaiolino@redhat.com>
References: <20170720131508.13582-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

With the current code, XFS never re-submit a failed buffer for IO,
because the failed item in the buffer is kept in the flush locked state
forever.

To be able to resubmit an log item for IO, we need a way to mark an item
as failed, if, for any reason the buffer which the item belonged to
failed during writeback.

Add a new log item callback to be used after an IO completion failure
and make the needed clean ups.

Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V2:
	- Update commit log to include a better description of why this
	  patch is needed and fix spelling mistakes
	- Move xfs_buf_do_callbacks_fail() call into
	  xfs_buf_iodone_callback_error, so the callbacks can be executed
	  before the buffer is released, and only after it has been
	  retried once

V3:
	- fix some loops according to hch suggestion
	- whitespace cleanup

V4:
	- Invoke failure callbacks before reset the I/O error
	- Remove bflags field from iop_error callback
	- move spin_lock/unlock xa_lock up in the stack, handling all
	  log items in the same buffer into a single lock

V5:
	- Reorganize variable declarations
	  in fxs_buf_do_callbacks_fail

V6:
	- Add a comment to xfs_buf_do_callbacks_fail

 fs/xfs/xfs_buf_item.c | 32 +++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans.h    |  7 +++++--
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index f6a8422..7573a1f 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -29,6 +29,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_inode.h"
 
 
 kmem_zone_t	*xfs_buf_item_zone;
@@ -1054,6 +1055,31 @@ xfs_buf_do_callbacks(
 	}
 }
 
+/*
+ * Invoke the error state callback for each log item affected by the failed I/O.
+ *
+ * If a metadata buffer write fails with a non-permanent error, the buffer is
+ * eventually resubmitted and so the completion callbacks are not run. The error
+ * state may need to be propagated to the log items attached to the buffer,
+ * however, so the next AIL push of the item knows hot to handle it correctly.
+ */
+STATIC void
+xfs_buf_do_callbacks_fail(
+	struct xfs_buf		*bp)
+{
+	struct xfs_log_item	*next;
+	struct xfs_log_item	*lip = bp->b_fspriv;
+	struct xfs_ail		*ailp = lip->li_ailp;
+
+	spin_lock(&ailp->xa_lock);
+	for (; lip; lip = next) {
+		next = lip->li_bio_list;
+		if (lip->li_ops->iop_error)
+			lip->li_ops->iop_error(lip, bp);
+	}
+	spin_unlock(&ailp->xa_lock);
+}
+
 static bool
 xfs_buf_iodone_callback_error(
 	struct xfs_buf		*bp)
@@ -1123,7 +1149,11 @@ xfs_buf_iodone_callback_error(
 	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
 		goto permanent_error;
 
-	/* still a transient error, higher layers will retry */
+	/*
+	 * Still a transient error, run IO completion failure callbacks and let
+	 * the higher layers retry the buffer.
+	 */
+	xfs_buf_do_callbacks_fail(bp);
 	xfs_buf_ioerror(bp, 0);
 	xfs_buf_relse(bp);
 	return true;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 6bdad6f..442d679 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -64,11 +64,13 @@ typedef struct xfs_log_item {
 } xfs_log_item_t;
 
 #define	XFS_LI_IN_AIL	0x1
-#define XFS_LI_ABORTED	0x2
+#define	XFS_LI_ABORTED	0x2
+#define	XFS_LI_FAILED	0x4
 
 #define XFS_LI_FLAGS \
 	{ XFS_LI_IN_AIL,	"IN_AIL" }, \
-	{ XFS_LI_ABORTED,	"ABORTED" }
+	{ XFS_LI_ABORTED,	"ABORTED" }, \
+	{ XFS_LI_FAILED,	"FAILED" }
 
 struct xfs_item_ops {
 	void (*iop_size)(xfs_log_item_t *, int *, int *);
@@ -79,6 +81,7 @@ struct xfs_item_ops {
 	void (*iop_unlock)(xfs_log_item_t *);
 	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
 	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
+	void (*iop_error)(xfs_log_item_t *, xfs_buf_t *);
 };
 
 void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
-- 
2.9.4

