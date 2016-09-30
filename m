Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49069 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752998AbcI3DJu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:09:50 -0400
Subject: [PATCH 38/63] xfs: cancel CoW reservations and clear inode reflink
 flag when freeing blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:09:46 -0700
Message-ID: <147520498644.29434.5014643991183828847.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When we're freeing blocks (truncate, punch, etc.), clear all CoW
reservations in the range being freed.  If the file block count
drops to zero, also clear the inode reflink flag.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0c25a76..8c971fd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -49,6 +49,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_reflink.h"
 
 kmem_zone_t *xfs_inode_zone;
 
@@ -1586,6 +1587,18 @@ xfs_itruncate_extents(
 			goto out;
 	}
 
+	/* Remove all pending CoW reservations. */
+	error = xfs_reflink_cancel_cow_blocks(ip, &tp, first_unmap_block,
+			last_block);
+	if (error)
+		goto out;
+
+	/*
+	 * Clear the reflink flag if we truncated everything.
+	 */
+	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip))
+		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+
 	/*
 	 * Always re-log the inode so that our permanent transaction can keep
 	 * on rolling it forward in the log.

