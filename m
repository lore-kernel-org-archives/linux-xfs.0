Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31965 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933012AbdEKN5l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 09:57:41 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6D3ECC001084
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 13:57:41 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (ovpn-204-141.brq.redhat.com [10.40.204.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6E838A8D8
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 13:57:40 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/2] xfs: Add infrastructure needed for error propagation during buffer IO failure
Date: Thu, 11 May 2017 15:57:32 +0200
Message-Id: <20170511135733.21765-2-cmaiolino@redhat.com>
In-Reply-To: <20170511135733.21765-1-cmaiolino@redhat.com>
References: <20170511135733.21765-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

To be able to resubmit an log item for IO, we need a way to mark an item
as failed, if, for any reason the buffer which the item belonged to
failed during writeback.

Add a new log item callback to be used after an IO completion failure
and make the needed clean ups.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 27 ++++++++++++++++++++++++++-
 fs/xfs/xfs_trans.h    |  5 ++++-
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 0306168..026aed4 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1051,6 +1051,24 @@ xfs_buf_do_callbacks(
 	}
 }
 
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
+		if (lip->li_ops->iop_error)
+			lip->li_ops->iop_error(lip, bflags);
+
+		lip = next;
+	}
+}
+
 static bool
 xfs_buf_iodone_callback_error(
 	struct xfs_buf		*bp)
@@ -1153,8 +1171,15 @@ xfs_buf_iodone_callbacks(
 	 * to run callbacks after failure processing is done so we
 	 * detect that and take appropriate action.
 	 */
-	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
+	if (bp->b_error && xfs_buf_iodone_callback_error(bp)) {
+
+		/*
+		 * We've got an error during buffer writeback, we need to notify
+		 * the items in the buffer
+		 */
+		xfs_buf_do_callbacks_fail(bp);
 		return;
+	}
 
 	/*
 	 * Successful IO or permanent error. Either way, we can clear the
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a07acbf..c57181a 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -65,10 +65,12 @@ typedef struct xfs_log_item {
 
 #define	XFS_LI_IN_AIL	0x1
 #define XFS_LI_ABORTED	0x2
+#define XFS_LI_FAILED	0x3
 
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
+	void (*iop_error)(xfs_log_item_t *, unsigned int bflags);
 };
 
 void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
-- 
2.9.3

