Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935334AbdEVPc2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 11:32:28 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E1C7CC0B39D0
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2017 15:32:27 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (ovpn-204-168.brq.redhat.com [10.40.204.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53F817D644
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2017 15:32:27 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/3 V2] xfs: Add infrastructure needed for error propagation during buffer IO failure
Date: Mon, 22 May 2017 17:32:19 +0200
Message-Id: <20170522153220.25072-3-cmaiolino@redhat.com>
In-Reply-To: <20170522153220.25072-1-cmaiolino@redhat.com>
References: <20170522153220.25072-1-cmaiolino@redhat.com>
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

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V2:
	- Update commit log to include a better description of why this
	  patch is needed and fix spelling mistakes
	- Move xfs_buf_do_callbacks_fail() call into
	  xfs_buf_iodone_callback_error, so the callbacks can be executed
	  before the buffer is released, and only after it has been
	  retried once

 fs/xfs/xfs_buf_item.c | 27 ++++++++++++++++++++++++++-
 fs/xfs/xfs_trans.h    |  5 ++++-
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 6ac3816..8f128e3 100644
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
@@ -1101,6 +1119,7 @@ xfs_buf_iodone_callback_error(
 
 		xfs_buf_ioerror(bp, 0);
 		xfs_buf_submit(bp);
+
 		return true;
 	}
 
@@ -1120,8 +1139,14 @@ xfs_buf_iodone_callback_error(
 	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
 		goto permanent_error;
 
-	/* still a transient error, higher layers will retry */
+	/*
+	 * still a transient error, run IO completion failure callbacks and
+	 * let the higher layers retry the buffer.
+	 * */
 	xfs_buf_ioerror(bp, 0);
+
+	/* run failure callbacks before releasing buffer */
+	xfs_buf_do_callbacks_fail(bp);
 	xfs_buf_relse(bp);
 	return true;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 7ae04de..7fcf48d 100644
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

