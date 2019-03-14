Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53336 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbfCNVHM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:07:12 -0400
Subject: [PATCH 31/36] libxfs: refactor the open-coded libxfs_trans_bjoin
 calls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:07:03 -0700
Message-ID: <155259762358.31886.5732556054840025852.stgit@magnolia>
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

Refactor open-coded bjoin code to use libxfs_trans_bjoin.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/trans.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index 10a35dd4..7bdd1544 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -663,13 +663,9 @@ libxfs_trans_get_buf_map(
 	fprintf(stderr, "trans_get_buf buffer %p, transaction %p\n", bp, tp);
 #endif
 
-	xfs_buf_item_init(bp, tp->t_mountp);
+	libxfs_trans_bjoin(tp, bp);
 	bip = bp->b_log_item;
 	bip->bli_recur = 0;
-	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
-
-	/* initialize b_transp so we can find it incore */
-	bp->b_transp = tp;
 	return bp;
 }
 
@@ -701,13 +697,9 @@ libxfs_trans_getsb(
 	fprintf(stderr, "trans_get_sb buffer %p, transaction %p\n", bp, tp);
 #endif
 
-	xfs_buf_item_init(bp, mp);
+	libxfs_trans_bjoin(tp, bp);
 	bip = bp->b_log_item;
 	bip->bli_recur = 0;
-	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
-
-	/* initialize b_transp so we can find it incore */
-	bp->b_transp = tp;
 	return bp;
 }
 
@@ -758,13 +750,9 @@ libxfs_trans_read_buf_map(
 	fprintf(stderr, "trans_read_buf buffer %p, transaction %p\n", bp, tp);
 #endif
 
-	xfs_buf_item_init(bp, tp->t_mountp);
+	xfs_trans_bjoin(tp, bp);
 	bip = bp->b_log_item;
 	bip->bli_recur = 0;
-	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
-
-	/* initialise b_transp so we can find it incore */
-	bp->b_transp = tp;
 done:
 	*bpp = bp;
 	return 0;
