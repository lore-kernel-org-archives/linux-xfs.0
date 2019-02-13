Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53348 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387886AbfBMJxs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 04:53:48 -0500
From: Bob Liu <bob.liu@oracle.com>
Subject: [RFC PATCH v2 7/9] xfs: Add device retry
Date: Wed, 13 Feb 2019 17:50:42 +0800
Message-Id: <20190213095044.29628-8-bob.liu@oracle.com>
In-Reply-To: <20190213095044.29628-1-bob.liu@oracle.com>
References: <20190213095044.29628-1-bob.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca

From: Allison Henderson <allison.henderson@oracle.com>

Check to see if the _xfs_buf_read fails.  If so loop over the
available mirrors and retry the read

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_buf.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6098195ecaf4..2c250221cb78 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -21,6 +21,7 @@
 #include <linux/migrate.h>
 #include <linux/backing-dev.h>
 #include <linux/freezer.h>
+#include <linux/blkdev.h>
 
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -824,6 +825,9 @@ xfs_buf_read_map(
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
+	struct request_queue	*q;
+	unsigned long		i;
+	int			retries = 0;
 
 	flags |= XBF_READ;
 
@@ -836,7 +840,27 @@ xfs_buf_read_map(
 	if (!(bp->b_flags & XBF_DONE)) {
 		XFS_STATS_INC(target->bt_mount, xb_get_read);
 		bp->b_ops = ops;
-		_xfs_buf_read(bp, flags);
+		q = bdev_get_queue(bp->b_target->bt_bdev);
+
+		if (bp->b_alt_retry)
+			retries = blk_queue_get_mirrors(q);
+
+		for (i = 0; i <= retries; i++) {
+			bp->b_error = 0;
+			_xfs_buf_read(bp, flags);
+
+			switch (bp->b_error) {
+			case -EIO:
+			case -EFSCORRUPTED:
+			case -EFSBADCRC:
+				/* loop again */
+				continue;
+			default:
+				goto retry_done;
+			}
+
+		}
+retry_done:
 		return bp;
 	}
 
-- 
2.17.1
