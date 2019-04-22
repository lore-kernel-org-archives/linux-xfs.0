Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38820 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfDVPph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Apr 2019 11:45:37 -0400
Subject: [PATCH 07/10] libxfs: refactor buffer item release code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 22 Apr 2019 08:45:34 -0700
Message-ID: <155594793429.115924.9115512760848857551.stgit@magnolia>
In-Reply-To: <155594788997.115924.16224143537288136652.stgit@magnolia>
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the buffer item release code into a helper, which we will use
in subsequent patches to make the buffer log item lifetime match the
kernel equivalents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/trans.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index 9de77c8b..629501f8 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -505,6 +505,16 @@ libxfs_trans_ordered_buf(
 	return ret;
 }
 
+static void
+xfs_buf_item_put(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+
+	bp->b_log_item = NULL;
+	kmem_zone_free(xfs_buf_item_zone, bip);
+}
+
 void
 libxfs_trans_brelse(
 	xfs_trans_t		*tp,
@@ -846,7 +856,6 @@ buf_item_done(
 
 	bp = bip->bli_buf;
 	ASSERT(bp != NULL);
-	bp->b_log_item = NULL;			/* remove log item */
 	bp->b_transp = NULL;			/* remove xact ptr */
 
 	hold = (bip->bli_flags & XFS_BLI_HOLD);
@@ -861,8 +870,7 @@ buf_item_done(
 		bip->bli_flags &= ~XFS_BLI_HOLD;
 	else
 		libxfs_putbuf(bp);
-	/* release the buf item */
-	kmem_zone_free(xfs_buf_item_zone, bip);
+	xfs_buf_item_put(bip);
 }
 
 static void
