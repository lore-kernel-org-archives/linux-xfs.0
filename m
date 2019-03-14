Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53112 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbfCNVHM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:07:12 -0400
Subject: [PATCH 32/36] libxfs: refactor buffer item release code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:07:09 -0700
Message-ID: <155259762965.31886.1477262840183695209.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
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
index 7bdd1544..295e687e 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -540,6 +540,16 @@ libxfs_trans_ordered_buf(
 	return ret;
 }
 
+void
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
@@ -881,7 +891,6 @@ buf_item_done(
 
 	bp = bip->bli_buf;
 	ASSERT(bp != NULL);
-	bp->b_log_item = NULL;			/* remove log item */
 	bp->b_transp = NULL;			/* remove xact ptr */
 
 	hold = (bip->bli_flags & XFS_BLI_HOLD);
@@ -896,8 +905,7 @@ buf_item_done(
 		bip->bli_flags &= ~XFS_BLI_HOLD;
 	else
 		libxfs_putbuf(bp);
-	/* release the buf item */
-	kmem_zone_free(xfs_buf_item_zone, bip);
+	xfs_buf_item_put(bip);
 }
 
 static void
