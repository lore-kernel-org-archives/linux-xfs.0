Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2EAC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 14:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiGKO3R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 10:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGKO3R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 10:29:17 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57753357E7
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 07:29:16 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LhR4S6lxCzVfb4;
        Mon, 11 Jul 2022 22:25:28 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500005.china.huawei.com
 (7.192.104.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 11 Jul
 2022 22:29:09 +0800
From:   Zhang Yi <yi.zhang@huawei.com>
To:     <linux-xfs@vger.kernel.org>
CC:     <djwong@kernel.org>, <yi.zhang@huawei.com>, <yukuai3@huawei.com>
Subject: [PATCH] xfs: flush inode gc workqueue before clearing agi bucket
Date:   Mon, 11 Jul 2022 22:41:34 +0800
Message-ID: <20220711144134.3103197-1-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In the procedure of recover AGI unlinked lists, if something bad
happenes on one of the unlinked inode in the bucket list, we would call
xlog_recover_clear_agi_bucket() to clear the whole unlinked bucket list,
not the unlinked inodes after the bad one. If we have already added some
inodes to the gc workqueue before the bad inode in the list, we could
get below error when freeing those inodes, and finaly fail to complete
the log recover procedure.

 XFS (ram0): Internal error xfs_iunlink_remove at line 2456 of file
 fs/xfs/xfs_inode.c.  Caller xfs_ifree+0xb0/0x360 [xfs]

The problem is xlog_recover_clear_agi_bucket() clear the bucket list, so
the gc worker fail to check the agino in xfs_verify_agino(). Fix this by
flush workqueue before clearing the bucket.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/xfs/xfs_log_recover.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5f7e4e6e33ce..2f655ef4364e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2714,6 +2714,7 @@ xlog_recover_process_one_iunlink(
 	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
 	 * clear the inode pointer in the bucket.
 	 */
+	xfs_inodegc_flush(mp);
 	xlog_recover_clear_agi_bucket(mp, agno, bucket);
 	return NULLAGINO;
 }
-- 
2.31.1

