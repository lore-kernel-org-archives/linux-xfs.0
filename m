Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57462 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfFMSDX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:23 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/20] xfs: don't cast inode_log_items to get the log_item
Date: Thu, 13 Jun 2019 20:02:49 +0200
Message-Id: <20190613180300.30447-10-hch@lst.de>
In-Reply-To: <20190613180300.30447-1-hch@lst.de>
References: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

The cast is not type safe, and we can just dereference the first
member instead to start with.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 71d216cf6f87..419eae485ff3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -485,7 +485,7 @@ xfs_lock_inodes(
 		 */
 		if (!try_lock) {
 			for (j = (i - 1); j >= 0 && !try_lock; j--) {
-				lp = (xfs_log_item_t *)ips[j]->i_itemp;
+				lp = &ips[j]->i_itemp->ili_item;
 				if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags))
 					try_lock++;
 			}
@@ -585,7 +585,7 @@ xfs_lock_two_inodes(
 	 * the second lock. If we can't get it, we must release the first one
 	 * and try again.
 	 */
-	lp = (xfs_log_item_t *)ip0->i_itemp;
+	lp = &ip0->i_itemp->ili_item;
 	if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags)) {
 		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(ip1_mode, 1))) {
 			xfs_iunlock(ip0, ip0_mode);
-- 
2.20.1
