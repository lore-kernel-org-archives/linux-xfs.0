Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53832 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbfCNVHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:07:19 -0400
Subject: [PATCH 33/36] libxfs: don't touch buffer log item pointer when
 flushing inode log item
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:07:15 -0700
Message-ID: <155259763568.31886.8011442389519021944.stgit@magnolia>
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

When we're flushing an inode log item, it is not necessary to mess with
the inode cluster buffer's log item because the iflush code paths pass
the inode log item directly.  The unconditional reset causes us to leak
buffer log items.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/trans.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index 295e687e..bd7bbc69 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -861,10 +861,8 @@ inode_item_done(
 	 * of whether the flush succeed or not. If we fail the flush, make sure
 	 * we still release the buffer reference we currently hold.
 	 */
-	bp->b_log_item = iip;
 	error = libxfs_iflush_int(ip, bp);
 	ip->i_transp = NULL;	/* disassociate from transaction */
-	bp->b_log_item = NULL;	/* remove log item */
 	bp->b_transp = NULL;	/* remove xact ptr */
 
 	if (error) {
