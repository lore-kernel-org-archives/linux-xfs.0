Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD2CC7EE2E
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jun 2023 03:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjFMDVm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 23:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjFMDVl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 23:21:41 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FB9EC
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 20:21:39 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QgD1M0K5fz4f3tpW
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jun 2023 11:04:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id Syh0CgBnVuTC3IdkRFP8LQ--.37435S6;
        Tue, 13 Jun 2023 11:04:39 +0800 (CST)
From:   Zhang Yi <yi.zhang@huaweicloud.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, dchinner@redhat.com, yi.zhang@huawei.com,
        yi.zhang@huaweicloud.com, leo.lilong@huawei.com, yukuai3@huawei.com
Subject: [PATCH 2/2] xfs: atomic drop extent entries when inactiving attr
Date:   Tue, 13 Jun 2023 11:04:34 +0800
Message-Id: <20230613030434.2944173-3-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230613030434.2944173-1-yi.zhang@huaweicloud.com>
References: <20230613030434.2944173-1-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgBnVuTC3IdkRFP8LQ--.37435S6
X-Coremail-Antispam: 1UD129KBjvJXoW3GF1UAr48GrW3Gr1rWr1rZwb_yoWxGr1Upr
        98G3s8Grs5tw17Ar1vyr45X3W5Jw1xAFW8Jr1rJwn2yay8JF17J34Utry0gFWDGrZ5X3Wj
        qr4UW34DK3y3Jw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9v14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
        x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdM2
        8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
        xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
        vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
        r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxC20s
        026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_
        JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14
        v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xva
        j40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JV
        W8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjYiiDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

When inactiving an unlinked inode and it's attrs, if xlog is shutdown
either during or just after the process of recurse deleting attribute
nodes/leafs in xfs_attr3_root_inactive(), the log will records some
buffer cancel items, but doesn't contain the corresponding extent
entries and inode updates, this is incomplete and inconsistent. Because
of the inactiving process is not completed and the unlinked inode is
still in the agi_unlinked table, it will continue to be inactived after
replaying the log on the next mount, the attr node/leaf blocks' created
record before the cancel items could not be replayed but the inode
does. So we could get corrupted data when reading the canceled blocks.

 XFS (pmem0): Metadata corruption detected at
 xfs_da3_node_read_verify+0x53/0x220, xfs_da3_node block 0x78
 XFS (pmem0): Unmount and run xfs_repair
 XFS (pmem0): First 128 bytes of corrupted metadata buffer:
 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 XFS (pmem0): metadata I/O error in "xfs_da_read_buf+0x104/0x190" at daddr 0x78 len 8 error 117

In order to fix the issue, we need to remove the extent entries, update
inode and attr btree atomically when staling attr node/leaf blocks. And
note that we may also need to log and update the parent attr node
entry when removing child or leaf attr block. Fortunately, it doesn't
have to be so complicated, we could leave the removed entres as
holes and skip them if we need to do re-inactiving, the whole node tree
will be removed completely in the end.

Cc: stable@vger.kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/xfs/xfs_attr_inactive.c | 62 ++++++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 5db87b34fb6e..bb83915ddcfe 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -23,6 +23,7 @@
 #include "xfs_quota.h"
 #include "xfs_dir2.h"
 #include "xfs_error.h"
+#include "xfs_defer.h"
 
 /*
  * Invalidate any incore buffers associated with this remote attribute value
@@ -139,7 +140,8 @@ xfs_attr3_node_inactive(
 	xfs_daddr_t		parent_blkno, child_blkno;
 	struct xfs_buf		*child_bp;
 	struct xfs_da3_icnode_hdr ichdr;
-	int			error, i;
+	int			error, i, done;
+	xfs_filblks_t		count = mp->m_attr_geo->fsbcount;
 
 	/*
 	 * Since this code is recursive (gasp!) we must protect ourselves.
@@ -172,10 +174,13 @@ xfs_attr3_node_inactive(
 		 * traversal of the tree so we may deal with many blocks
 		 * before we come back to this one.
 		 */
-		error = xfs_da3_node_read(*trans, dp, child_fsb, &child_bp,
-					  XFS_ATTR_FORK);
+		error = __xfs_da3_node_read(*trans, dp, child_fsb,
+					    XFS_DABUF_MAP_HOLE_OK, &child_bp,
+					    XFS_ATTR_FORK);
 		if (error)
 			return error;
+		if (!child_bp)
+			goto next_entry;
 
 		/* save for re-read later */
 		child_blkno = xfs_buf_daddr(child_bp);
@@ -207,14 +212,32 @@ xfs_attr3_node_inactive(
 		 * Remove the subsidiary block from the cache and from the log.
 		 */
 		error = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
-				child_blkno,
-				XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0,
-				&child_bp);
+					  child_blkno, XFS_FSB_TO_BB(mp, count),
+					  0, &child_bp);
 		if (error)
 			return error;
+
+		error = xfs_bunmapi(*trans, dp, child_fsb, count,
+				    XFS_BMAPI_ATTRFORK, 0, &done);
+		if (error) {
+			xfs_trans_brelse(*trans, child_bp);
+			return error;
+		}
 		xfs_trans_binval(*trans, child_bp);
+
+		error = xfs_defer_finish(trans);
+		if (error)
+			return error;
 		child_bp = NULL;
 
+		/*
+		 * Atomically commit the whole invalidate stuff.
+		 */
+		error = xfs_trans_roll_inode(trans, dp);
+		if (error)
+			return  error;
+
+next_entry:
 		/*
 		 * If we're not done, re-read the parent to get the next
 		 * child block number.
@@ -232,12 +255,6 @@ xfs_attr3_node_inactive(
 			xfs_trans_brelse(*trans, bp);
 			bp = NULL;
 		}
-		/*
-		 * Atomically commit the whole invalidate stuff.
-		 */
-		error = xfs_trans_roll_inode(trans, dp);
-		if (error)
-			return  error;
 	}
 
 	return 0;
@@ -258,7 +275,8 @@ xfs_attr3_root_inactive(
 	struct xfs_da_blkinfo	*info;
 	struct xfs_buf		*bp;
 	xfs_daddr_t		blkno;
-	int			error;
+	xfs_filblks_t		count = mp->m_attr_geo->fsbcount;
+	int			error, done;
 
 	/*
 	 * Read block 0 to see what we have to work with.
@@ -266,8 +284,9 @@ xfs_attr3_root_inactive(
 	 * the extents in reverse order the extent containing
 	 * block 0 must still be there.
 	 */
-	error = xfs_da3_node_read(*trans, dp, 0, &bp, XFS_ATTR_FORK);
-	if (error)
+	error = __xfs_da3_node_read(*trans, dp, 0, XFS_DABUF_MAP_HOLE_OK,
+				    &bp, XFS_ATTR_FORK);
+	if (error || !bp)
 		return error;
 	blkno = xfs_buf_daddr(bp);
 
@@ -298,7 +317,7 @@ xfs_attr3_root_inactive(
 	 * Invalidate the incore copy of the root block.
 	 */
 	error = xfs_trans_get_buf(*trans, mp->m_ddev_targp, blkno,
-			XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0, &bp);
+				  XFS_FSB_TO_BB(mp, count), 0, &bp);
 	if (error)
 		return error;
 	error = bp->b_error;
@@ -306,7 +325,17 @@ xfs_attr3_root_inactive(
 		xfs_trans_brelse(*trans, bp);
 		return error;
 	}
+
+	error = xfs_bunmapi(*trans, dp, 0, count, XFS_BMAPI_ATTRFORK, 0, &done);
+	if (error) {
+		xfs_trans_brelse(*trans, bp);
+		return error;
+	}
 	xfs_trans_binval(*trans, bp);	/* remove from cache */
+
+	error = xfs_defer_finish(trans);
+	if (error)
+		return error;
 	/*
 	 * Commit the invalidate and start the next transaction.
 	 */
@@ -369,6 +398,7 @@ xfs_attr_inactive(
 		if (error)
 			goto out_cancel;
 
+		/* Remove the potential leftover remote attr blocks. */
 		error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0);
 		if (error)
 			goto out_cancel;
-- 
2.31.1

