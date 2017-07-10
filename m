Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754152AbdGJN2C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jul 2017 09:28:02 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8DB0978EB7
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2017 13:28:01 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7132717D9A
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2017 13:28:01 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 4/6] xfs: add log item pinning error injection tag
Date: Mon, 10 Jul 2017 09:27:58 -0400
Message-Id: <20170710132800.19506-5-bfoster@redhat.com>
In-Reply-To: <20170710132800.19506-1-bfoster@redhat.com>
References: <20170710132800.19506-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Add an error injection tag to force log items in the AIL to the
pinned state. This option can be used by test infrastructure to
induce head behind tail conditions. Specifically, this is intended
to be used by xfstests to reproduce log recovery problems after
failed/corrupted log writes overwrite the last good tail LSN in the
log.

When enabled, AIL push attempts see log items in the AIL in the
pinned state. This stalls metadata writeback and thus prevents the
current tail of the log from moving forward. When disabled,
subsequent AIL pushes observe the log items in their appropriate
state and filesystem operation continues as normal.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_error.c     |  3 +++
 fs/xfs/xfs_error.h     |  4 +++-
 fs/xfs/xfs_trans_ail.c | 17 ++++++++++++++++-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 2f4feb9..bd786a9 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -57,6 +57,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_AG_RESV_CRITICAL,
 	XFS_RANDOM_DROP_WRITES,
 	XFS_RANDOM_LOG_BAD_CRC,
+	XFS_RANDOM_LOG_ITEM_PIN,
 };
 
 struct xfs_errortag_attr {
@@ -161,6 +162,7 @@ XFS_ERRORTAG_ATTR_RW(bmap_finish_one,	XFS_ERRTAG_BMAP_FINISH_ONE);
 XFS_ERRORTAG_ATTR_RW(ag_resv_critical,	XFS_ERRTAG_AG_RESV_CRITICAL);
 XFS_ERRORTAG_ATTR_RW(drop_writes,	XFS_ERRTAG_DROP_WRITES);
 XFS_ERRORTAG_ATTR_RW(log_bad_crc,	XFS_ERRTAG_LOG_BAD_CRC);
+XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -193,6 +195,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_critical),
 	XFS_ERRORTAG_ATTR_LIST(drop_writes),
 	XFS_ERRORTAG_ATTR_LIST(log_bad_crc),
+	XFS_ERRORTAG_ATTR_LIST(log_item_pin),
 	NULL,
 };
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 7577be5..7c4bef3 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -106,7 +106,8 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
  */
 #define XFS_ERRTAG_DROP_WRITES				28
 #define XFS_ERRTAG_LOG_BAD_CRC				29
-#define XFS_ERRTAG_MAX					30
+#define XFS_ERRTAG_LOG_ITEM_PIN				30
+#define XFS_ERRTAG_MAX					31
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -141,6 +142,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_RANDOM_AG_RESV_CRITICAL			4
 #define XFS_RANDOM_DROP_WRITES				1
 #define XFS_RANDOM_LOG_BAD_CRC				1
+#define XFS_RANDOM_LOG_ITEM_PIN				1
 
 #ifdef DEBUG
 extern int xfs_errortag_init(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 9056c0f..563b315 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -325,6 +325,21 @@ xfs_ail_delete(
 	xfs_trans_ail_cursor_clear(ailp, lip);
 }
 
+static inline uint
+xfsaild_push_item(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip)
+{
+	/*
+	 * If log item pinning is enabled, skip the push and track the item as
+	 * pinned. This can help induce head-behind-tail conditions.
+	 */
+	if (XFS_TEST_ERROR(false, ailp->xa_mount, XFS_ERRTAG_LOG_ITEM_PIN))
+		return XFS_ITEM_PINNED;
+
+	return lip->li_ops->iop_push(lip, &ailp->xa_buf_list);
+}
+
 static long
 xfsaild_push(
 	struct xfs_ail		*ailp)
@@ -382,7 +397,7 @@ xfsaild_push(
 		 * rely on the AIL cursor implementation to be able to deal with
 		 * the dropped lock.
 		 */
-		lock_result = lip->li_ops->iop_push(lip, &ailp->xa_buf_list);
+		lock_result = xfsaild_push_item(ailp, lip);
 		switch (lock_result) {
 		case XFS_ITEM_SUCCESS:
 			XFS_STATS_INC(mp, xs_push_ail_success);
-- 
2.9.4

