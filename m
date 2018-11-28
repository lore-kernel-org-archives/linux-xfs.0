Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52266 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbeK1Owo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 09:52:44 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v1 5/7] xfs: Add device retry
Date: Tue, 27 Nov 2018 20:49:49 -0700
Message-Id: <1543376991-5764-6-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com, allison.henderson@oracle.com

Check to see if the _xfs_buf_read fails.  If so loop over the
available mirrors and retry the read

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_buf.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index dd8ba59..f102d01 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -21,6 +21,7 @@
 #include <linux/migrate.h>
 #include <linux/backing-dev.h>
 #include <linux/freezer.h>
+#include <linux/blkdev.h>
 
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -808,6 +809,8 @@ xfs_buf_read_map(
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
+	struct request_queue	*q;
+	unsigned short		i;
 
 	flags |= XBF_READ;
 
@@ -820,7 +823,30 @@ xfs_buf_read_map(
 	if (!(bp->b_flags & XBF_DONE)) {
 		XFS_STATS_INC(target->bt_mount, xb_get_read);
 		bp->b_ops = ops;
-		_xfs_buf_read(bp, flags);
+		q = bdev_get_queue(bp->b_target->bt_bdev);
+
+		/*
+		 * Mirrors are indexed 1 - n, specified through the rw_hint.
+		 * Setting the hint to 0 is unspecified and allows the block
+		 * layer to decide.
+		 */
+		for (i = 0; i <= blk_queue_get_mirrors(q); i++) {
+			bp->b_error = 0;
+			bp->b_rw_hint = i;
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
2.7.4
