Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45393 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729370AbfG3CcS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jul 2019 22:32:18 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2] fs: xfs: Fix possible null-pointer dereferences in xchk_da_btree_block_check_sibling()
Date: Tue, 30 Jul 2019 10:32:06 +0800
Message-Id: <20190730023206.14587-1-baijiaju1990@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com, bfoster@redhat.com, sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>

In xchk_da_btree_block_check_sibling(), there is an if statement on
line 274 to check whether ds->state->altpath.blk[level].bp is NULL:
    if (ds->state->altpath.blk[level].bp)

When ds->state->altpath.blk[level].bp is NULL, it is used on line 281:
    xfs_trans_brelse(..., ds->state->altpath.blk[level].bp);
        struct xfs_buf_log_item *bip = bp->b_log_item;
        ASSERT(bp->b_transp == tp);

Thus, possible null-pointer dereferences may occur.

To fix these bugs, ds->state->altpath.blk[level].bp is checked before
being used.

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
v2:
* Adjust the code and add an assignment. 
  Thank Darrick J. Wong for helpful advice. 

---
 fs/xfs/scrub/dabtree.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 94c4f1de1922..77ff9f97bcda 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -278,7 +278,11 @@ xchk_da_btree_block_check_sibling(
 	/* Compare upper level pointer to sibling pointer. */
 	if (ds->state->altpath.blk[level].blkno != sibling)
 		xchk_da_set_corrupt(ds, level);
-	xfs_trans_brelse(ds->dargs.trans, ds->state->altpath.blk[level].bp);
+	if (ds->state->altpath.blk[level].bp) {
+		xfs_trans_brelse(ds->dargs.trans,
+				ds->state->altpath.blk[level].bp);
+		ds->state->altpath.blk[level].bp = NULL;
+	}
 out:
 	return error;
 }
-- 
2.17.0
