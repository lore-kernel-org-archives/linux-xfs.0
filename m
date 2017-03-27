Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50387 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752213AbdC0IuW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 04:50:22 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/27] xfs: reset b_first_retry_time when clear the retry status of xfs_buf_t
Date: Mon, 27 Mar 2017 10:49:08 +0200
Message-Id: <20170327084922.11691-14-hch@lst.de>
In-Reply-To: <20170327084922.11691-1-hch@lst.de>
References: <20170327084922.11691-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org, Hou Tao <houtao1@huawei.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Hou Tao <houtao1@huawei.com>

commit 4dd2eb633598cb6a5a0be2fd9a2be0819f5eeb5f upstream.

After successful IO or permanent error, b_first_retry_time also
needs to be cleared, else the invalid first retry time will be
used by the next retry check.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 2975cb2319f4..0306168af332 100644
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
2.11.0

