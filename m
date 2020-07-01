Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C52E1C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E2C420748
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fRxF51LL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732344AbgGAQv0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 12:51:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49272 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732559AbgGAQvY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 12:51:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593622283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J6ERAzvMnQufPex/eRMnULXuuof0eCu/aeKjMvuYp3Q=;
        b=fRxF51LLKdm8yQc09i2QN9sgizkU5xK5Iiqh+hBvG6cmJqMvcvVv4RgnAx/EsiSnCY9nP7
        2pNB2KNSBMtvFzDMMh30sfeeQYDHycHR6qlcGb+dLuiB4csZ5yM9zTTX4/yyCH20M5KDzY
        r6n0DPYqFFGLgqWNQSGpA/7xxjR9pm0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-GG_PNNtTOX2TTnAydKktMw-1; Wed, 01 Jul 2020 12:51:20 -0400
X-MC-Unique: GG_PNNtTOX2TTnAydKktMw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACC3A18FF662
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:19 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 695995C3FD
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:19 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/10] xfs: automatically relog the quotaoff start intent
Date:   Wed,  1 Jul 2020 12:51:12 -0400
Message-Id: <20200701165116.47344-7-bfoster@redhat.com>
In-Reply-To: <20200701165116.47344-1-bfoster@redhat.com>
References: <20200701165116.47344-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The quotaoff operation has a rare but longstanding deadlock vector
in terms of how the operation is logged. A quotaoff start intent is
logged (synchronously) at the onset to ensure recovery can handle
the operation if interrupted before in-core changes are made. This
quotaoff intent pins the log tail while the quotaoff sequence scans
and purges dquots from all in-core inodes. While this operation
generally doesn't generate much log traffic on its own, it can be
time consuming. If unrelated, concurrent filesystem activity
consumes remaining log space before quotaoff is able to acquire log
reservation for the quotaoff end intent, the filesystem locks up
indefinitely.

quotaoff cannot allocate the end intent before the scan because the
latter can result in transaction allocation itself in certain
indirect cases (releasing an inode, for example). Further, rolling
the original transaction is difficult because the scanning work
occurs multiple layers down where caller context is lost and not
much information is available to determine how often to roll the
transaction.

To address this problem, enable automatic relogging of the quotaoff
start intent. This automatically relogs the intent whenever AIL
pushing finds the item at the tail of the log. When quotaoff
completes, wait for relogging to complete as the end intent expects
to be able to permanently remove the start intent from the log
subsystem. This ensures that the log tail is kept moving during a
particularly long quotaoff operation and avoids the log reservation
deadlock.

Note that the quotaoff reservation calculation does not need to be
updated for relog as it already (incorrectly) accounts for two
quotaoff intents.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_dquot_item.c  | 26 ++++++++++++++++++++++++--
 fs/xfs/xfs_qm_syscalls.c | 12 +++++++++++-
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 349c92d26570..86dcb6932aab 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -17,6 +17,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 
 static inline struct xfs_dq_logitem *DQUOT_ITEM(struct xfs_log_item *lip)
 {
@@ -275,14 +276,17 @@ xfs_qm_qoff_logitem_format(
 }
 
 /*
- * There isn't much you can do to push a quotaoff item.  It is simply
- * stuck waiting for the log to be flushed to disk.
+ * The quotaoff log item is stuck in the log until quotaoff completes. Either
+ * relog it to keep the tail moving or consider it locked.
  */
 STATIC uint
 xfs_qm_qoff_logitem_push(
 	struct xfs_log_item	*lip,
 	struct list_head	*buffer_list)
 {
+
+	if (xfs_item_needs_relog(lip))
+		return XFS_ITEM_RELOG;
 	return XFS_ITEM_LOCKED;
 }
 
@@ -314,6 +318,23 @@ xfs_qm_qoff_logitem_release(
 	}
 }
 
+STATIC void
+xfs_qm_qoff_logitem_relog(
+	struct xfs_log_item	*lip,
+	struct xfs_trans	*tp)
+{
+	int			res;
+
+	res = xfs_relog_calc_res(lip);
+
+	xfs_trans_add_item(tp, lip);
+	tp->t_ticket->t_curr_res += res;
+	tp->t_ticket->t_unit_res += res;
+	tp->t_log_res += res;
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &lip->li_flags);
+}
+
 static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
@@ -327,6 +348,7 @@ static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
 	.iop_format	= xfs_qm_qoff_logitem_format,
 	.iop_push	= xfs_qm_qoff_logitem_push,
 	.iop_release	= xfs_qm_qoff_logitem_release,
+	.iop_relog	= xfs_qm_qoff_logitem_relog,
 };
 
 /*
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 7effd7a28136..5602ed2b7e8d 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -18,6 +18,7 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_icache.h"
+#include "xfs_trans_priv.h"
 
 STATIC int
 xfs_qm_log_quotaoff(
@@ -29,12 +30,14 @@ xfs_qm_log_quotaoff(
 	int			error;
 	struct xfs_qoff_logitem	*qoffi;
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0,
+				XFS_TRANS_RELOG, &tp);
 	if (error)
 		goto out;
 
 	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
 	xfs_trans_log_quotaoff_item(tp, qoffi);
+	xfs_trans_relog_item(tp, &qoffi->qql_item);
 
 	spin_lock(&mp->m_sb_lock);
 	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
@@ -71,6 +74,13 @@ xfs_qm_log_quotaoff_end(
 	if (error)
 		return error;
 
+	/*
+	 * startqoff must be in the AIL and not the CIL when the end intent
+	 * commits to ensure it is not readded to the AIL out of order. Wait on
+	 * relog activity to drain to isolate startqoff to the AIL.
+	 */
+	xfs_trans_relog_item_cancel(tp, &(*startqoff)->qql_item, true);
+
 	qoffi = xfs_trans_get_qoff_item(tp, *startqoff,
 					flags & XFS_ALL_QUOTA_ACCT);
 	xfs_trans_log_quotaoff_item(tp, qoffi);
-- 
2.21.3

