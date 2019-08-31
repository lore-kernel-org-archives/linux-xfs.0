Return-Path: <SRS0=0uIH=W3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA82AC3A59F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Aug 2019 09:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C54E423426
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Aug 2019 09:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfHaJRa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 31 Aug 2019 05:17:30 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6157 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfHaJR3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 31 Aug 2019 05:17:29 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7FFAFC8D1225965FF1B8;
        Sat, 31 Aug 2019 17:17:09 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Sat, 31 Aug 2019
 17:17:01 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <darrick.wong@oracle.com>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <zhengbin13@huawei.com>,
        <yi.zhang@huawei.com>
Subject: [PATCH v2] xfs: revise function comment for xfs_trans_ail_delete
Date:   Sat, 31 Aug 2019 17:23:43 +0800
Message-ID: <1567243423-59571-1-git-send-email-yukuai3@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since xfs_trans_ail_delete_bulk no longer exists, revising the comment
for new function xfs_trans_ail_delete.

Fix following warning:
make W=1 fs/xfs/xfs_trans_ail.o
fs/xfs/xfs_trans_ail.c:793: warning: Function parameter or member 
'ailp' not described in 'xfs_trans_ail_delete'
fs/xfs/xfs_trans_ail.c:793: warning: Function parameter or member
'lip' not described in 'xfs_trans_ail_delete'
fs/xfs/xfs_trans_ail.c:793: warning: Function parameter or member
'shutdown_type' not described in 'xfs_trans_ail_delete'

Fixes:27af1bbf5244("xfs: remove xfs_trans_ail_delete_bulk")
Signed-off-by: yu kuai <yukuai3@huawei.com>
---
 fs/xfs/xfs_trans_ail.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 6ccfd75..6c43b66e 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -765,25 +765,20 @@ xfs_ail_delete_one(
 }
 
-/**
- * Remove a log items from the AIL
+/*
+ * xfs_trans_ail_delet - remove a log item from the AIL
  *
- * @xfs_trans_ail_delete_bulk takes an array of log items that all need to
- * removed from the AIL. The caller is already holding the AIL lock, and done
- * all the checks necessary to ensure the items passed in via @log_items are
- * ready for deletion. This includes checking that the items are in the AIL.
+ * @xfs_trans_ail_delete takes a log item that needs to be removed from the
+ * AIL. The caller is already holding the AIL lock, and done all the checks
+ * necessary to ensure the item passed in via @lip are ready for deletion.
+ * This includes checking that the items are in the AIL.
  *
- * For each log item to be removed, unlink it  from the AIL, clear the IN_AIL
- * flag from the item and reset the item's lsn to 0. If we remove the first
- * item in the AIL, update the log tail to match the new minimum LSN in the
- * AIL.
+ * For the log item to be removed, call xfs_ail_delete_one to unlink it
+ * from the AIL, clear the IN_AIL flag from the item and reset the item's
+ * lsn to 0. If we remove the first item in the AIL, update the log tail
+ * to match the new minimum LSN in the AIL.
  *
- * This function will not drop the AIL lock until all items are removed from
- * the AIL to minimise the amount of lock traffic on the AIL. This does not
- * greatly increase the AIL hold time, but does significantly reduce the amount
- * of traffic on the lock, especially during IO completion.
- *
- * This function must be called with the AIL lock held.  The lock is dropped
- * before returning.
+ * This function must be called with the AIL lock held. The lock will be
+ * dropped before returning.
  */
 void
 xfs_trans_ail_delete(
-- 
2.7.4

