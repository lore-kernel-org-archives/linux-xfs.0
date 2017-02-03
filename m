Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:25202 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751958AbdBCJHv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Feb 2017 04:07:51 -0500
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH] xfs: reset b_first_retry_time when clear the retry status of xfs_buf_t
Date: Fri, 3 Feb 2017 17:08:25 +0800
Message-ID: <1486112905-38025-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, cmaiolino@redhat.com, sandeen@redhat.com

After successful IO or permanent error, b_first_retry_time also
needs to be cleared, else the invalid first retry time will be
used by the next retry check.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/xfs_buf_item.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 2975cb2..0306168 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1162,6 +1162,7 @@ xfs_buf_iodone_callbacks(
 	 */
 	bp->b_last_error = 0;
 	bp->b_retries = 0;
+	bp->b_first_retry_time = 0;
 
 	xfs_buf_do_callbacks(bp);
 	bp->b_fspriv = NULL;
-- 
2.5.0

