Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53626 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbfCNVHZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:07:25 -0400
Subject: [PATCH 34/36] libxfs: fix buffer log item lifetime weirdness
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:07:21 -0700
Message-ID: <155259764175.31886.6428125727142055154.stgit@magnolia>
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

In xfsprogs, the lifetime of xfs_buf log items doesn't match the kernel
because we keep them around after comitting or cancelling transactions.
This is confusing, so change the lifetime to be consistent.  Worse yet,
if an inode cluster buffer gets bjoined to a transaction (e.g. someone
called xfs_trans_read_buf) we'll leak it when flushing an inode core
back to that buffer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/trans.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index bd7bbc69..2ceb9838 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -580,6 +580,7 @@ libxfs_trans_brelse(
 	xfs_trans_del_item(&bip->bli_item);
 	if (bip->bli_flags & XFS_BLI_HOLD)
 		bip->bli_flags &= ~XFS_BLI_HOLD;
+	xfs_buf_item_put(bip);
 	bp->b_transp = NULL;
 	libxfs_putbuf(bp);
 }
@@ -939,6 +940,7 @@ buf_item_unlock(
 
 	hold = bip->bli_flags & XFS_BLI_HOLD;
 	bip->bli_flags &= ~XFS_BLI_HOLD;
+	xfs_buf_item_put(bip);
 	if (!hold)
 		libxfs_putbuf(bp);
 }
