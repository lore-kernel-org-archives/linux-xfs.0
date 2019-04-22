Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40972 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfDVPrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Apr 2019 11:47:42 -0400
Subject: [PATCH 08/10] libxfs: don't touch buffer log item pointer when
 flushing inode log item
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 22 Apr 2019 08:45:40 -0700
Message-ID: <155594794076.115924.11541140246431884889.stgit@magnolia>
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

When we're flushing an inode log item, it is not necessary to mess with
the inode cluster buffer's log item because the iflush code paths pass
the inode log item directly.  The unconditional reset causes us to leak
buffer log items.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/trans.c |    2 --
 libxfs/util.c  |    1 -
 2 files changed, 3 deletions(-)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index 629501f8..d562cdc0 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -826,10 +826,8 @@ inode_item_done(
 	 * of whether the flush succeed or not. If we fail the flush, make sure
 	 * we still release the buffer reference we currently hold.
 	 */
-	bp->b_log_item = iip;
 	error = libxfs_iflush_int(ip, bp);
 	ip->i_transp = NULL;	/* disassociate from transaction */
-	bp->b_log_item = NULL;	/* remove log item */
 	bp->b_transp = NULL;	/* remove xact ptr */
 
 	if (error) {
diff --git a/libxfs/util.c b/libxfs/util.c
index ea75fa20..9fe9a367 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -394,7 +394,6 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 	xfs_dinode_t		*dip;
 	xfs_mount_t		*mp;
 
-	ASSERT(bp-b_log_item != NULL);
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 		ip->i_d.di_nextents > ip->i_df.if_ext_max);
 	ASSERT(ip->i_d.di_version > 1);
