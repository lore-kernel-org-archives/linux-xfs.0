Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23FAC77B73
	for <linux-xfs@archiver.kernel.org>; Wed, 24 May 2023 12:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjEXMM6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 May 2023 08:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjEXMM5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2023 08:12:57 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043F395
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 05:12:56 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QR94k5gVQzsSVN;
        Wed, 24 May 2023 20:10:46 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 24 May
 2023 20:12:53 +0800
Date:   Wed, 24 May 2023 20:11:21 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>
CC:     <david@fromorbit.com>, <linux-xfs@vger.kernel.org>,
        <houtao1@huawei.com>, <yi.zhang@huawei.com>, <guoxuenan@huawei.com>
Subject: [PATCH] xfs: xfs_trans_cancel() path must check for log shutdown
Message-ID: <20230524121121.GA4130562@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following error occurred when do IO fault injection test:

XFS: Assertion failed: xlog_is_shutdown(lip->li_log), file: fs/xfs/xfs_inode_item.c, line: 748

In commit 3c4cb76bce43 (xfs: xfs_trans_commit() path must check for log
shutdown) fix a problem that dirty transaction was canceled before log
shutdown, because of the log is still running, it result dirty and
unlogged inode item that isn't in the AIL in memory that can be flushed
to disk via writeback clustering.

xfs_trans_cancel() has the same problem, if a shut down races with
xfs_trans_cancel() and we have shut down the filesystem but not the log,
we will still cancel the transaction before log shutdown. So
xfs_trans_cancel() needs to check log state for shutdown, not mount.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_trans.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8afc0c080861..033991854d4f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1059,11 +1059,9 @@ xfs_trans_commit(
  *
  * This is a high level function (equivalent to xfs_trans_commit()) and so can
  * be called after the transaction has effectively been aborted due to the mount
- * being shut down. However, if the mount has not been shut down and the
+ * being shut down. However, if the log has not been shut down and the
  * transaction is dirty we will shut the mount down and, in doing so, that
- * guarantees that the log is shut down, too. Hence we don't need to be as
- * careful with shutdown state and dirty items here as we need to be in
- * xfs_trans_commit().
+ * guarantees that the log is shut down.
  */
 void
 xfs_trans_cancel(
@@ -1089,11 +1087,12 @@ xfs_trans_cancel(
 
 	/*
 	 * See if the caller is relying on us to shut down the filesystem. We
-	 * only want an error report if there isn't already a shutdown in
-	 * progress, so we only need to check against the mount shutdown state
-	 * here.
+	 * only want an error report if there isn't already a log shutdown. We
+	 * must check against log shutdown here because we cannot abort log and
+	 * leave them dirty, inconsistent and unpinned in memory while the log
+	 * is active, as we needed in xfs_trans_commit().
 	 */
-	if (dirty && !xfs_is_shutdown(mp)) {
+	if (dirty && !xlog_is_shutdown(log)) {
 		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, mp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	}
-- 
2.31.1

