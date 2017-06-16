Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750873AbdFPQof (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 12:44:35 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1A281C04B950
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2017 16:44:35 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDC7B91281
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2017 16:44:34 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: debug mode sysfs flag to force [un]pin the log tail
Date: Fri, 16 Jun 2017 12:44:33 -0400
Message-Id: <1497631473-14278-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Create a debug mode only sysfs option to force pin the tail of the
log. This option can be used by test infrastructure to induce head
behind tail conditions. Specifically, this is intended to be used by
xfstests to reproduce log recovery problems after failed/corrupted
log writes overwrite the last good tail LSN in the log.

When enabled, AIL push attempts see every log item on the AIL in the
pinned state. This stalls metadata writeback and thus prevents the
current tail of the log from moving forward. When disabled,
subsequent AIL pushes observe the log items in their appropriate
state and filesystem operation continues as normal.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

This patch is a supporting patch for an xfstests test I'm about to post
that pins the tail of the log in order to reproduce the log recovery
problem that appears to be the root of the problem in this[1] thread.
That is the primary motivation for the patch and so should probably be
reviewed with that context. IOW, if there's a better way to reproduce
the problem in the test without the need for kernel support, I'm happy
to drop this. Thoughts, reviews, flames appreciated.

Brian

[1] http://www.spinics.net/lists/linux-xfs/msg07499.html

 fs/xfs/xfs_log_priv.h  |  2 ++
 fs/xfs/xfs_sysfs.c     | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans_ail.c | 20 +++++++++++++++++++-
 3 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index c2604a5..bfbfde12 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -413,6 +413,8 @@ struct xlog {
 	void			*l_iclog_bak[XLOG_MAX_ICLOGS];
 	/* log record crc error injection factor */
 	uint32_t		l_badcrc_factor;
+	/* force pin the log tail */
+	bool			l_pin_tail;
 #endif
 	/* log recovery lsn tracking (for buffer submission */
 	xfs_lsn_t		l_recovery_lsn;
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index ec6e0e2..b86148a 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -378,6 +378,51 @@ log_badcrc_factor_show(
 }
 
 XFS_SYSFS_ATTR_RW(log_badcrc_factor);
+
+/*
+ * DEBUG mode flag to force pin the tail of the log. Used from test
+ * infrastructure to manufacture head-behind-tail conditions. DO NOT USE
+ * DIRECTLY. This will lock up the fs!
+ *
+ * When this option is enabled, all log items present in the AIL are emulated as
+ * being in the pinned state until the option is disabled. Once disabled, log
+ * items return to their natural state and fs operation continues as normal.
+ */
+STATIC ssize_t
+log_pin_tail_store(
+	struct kobject		*kobject,
+	const char		*buf,
+	size_t			count)
+{
+	struct xlog		*log = to_xlog(kobject);
+	int			ret;
+	int			val;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val == 1)
+		log->l_pin_tail = true;
+	else if (val == 0)
+		log->l_pin_tail = false;
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+STATIC ssize_t
+log_pin_tail_show(
+	struct kobject		*kobject,
+	char			*buf)
+{
+	struct xlog		*log = to_xlog(kobject);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", log->l_pin_tail ? 1 : 0);
+}
+XFS_SYSFS_ATTR_RW(log_pin_tail);
+
 #endif	/* DEBUG */
 
 static struct attribute *xfs_log_attrs[] = {
@@ -387,6 +432,7 @@ static struct attribute *xfs_log_attrs[] = {
 	ATTR_LIST(write_grant_head),
 #ifdef DEBUG
 	ATTR_LIST(log_badcrc_factor),
+	ATTR_LIST(log_pin_tail),
 #endif
 	NULL,
 };
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 9056c0f..c901e61 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -27,6 +27,7 @@
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 
 #ifdef DEBUG
 /*
@@ -325,6 +326,23 @@ xfs_ail_delete(
 	xfs_trans_ail_cursor_clear(ailp, lip);
 }
 
+static inline uint
+xfsaild_push_item(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip)
+{
+#ifdef DEBUG
+	/*
+	 * If tail pinning is enabled, skip the push and track all items as
+	 * pinned to force pin the log tail. This helps induce head-behind-tail
+	 * conditions.
+	 */
+	if (ailp->xa_mount->m_log->l_pin_tail)
+		return XFS_ITEM_PINNED;
+#endif
+	return lip->li_ops->iop_push(lip, &ailp->xa_buf_list);
+}
+
 static long
 xfsaild_push(
 	struct xfs_ail		*ailp)
@@ -382,7 +400,7 @@ xfsaild_push(
 		 * rely on the AIL cursor implementation to be able to deal with
 		 * the dropped lock.
 		 */
-		lock_result = lip->li_ops->iop_push(lip, &ailp->xa_buf_list);
+		lock_result = xfsaild_push_item(ailp, lip);
 		switch (lock_result) {
 		case XFS_ITEM_SUCCESS:
 			XFS_STATS_INC(mp, xs_push_ail_success);
-- 
2.7.5

