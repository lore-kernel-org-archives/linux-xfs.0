Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49188 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752066AbdIQVHP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:15 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/47] xfs: remove bli from AIL before release on transaction abort
Date: Sun, 17 Sep 2017 14:06:31 -0700
Message-Id: <20170917210712.10804-7-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit 3d4b4a3e30ae7a949c31e1e10268a3da4723d290 upstream.

When a buffer is modified, logged and committed, it ultimately ends
up sitting on the AIL with a dirty bli waiting for metadata
writeback. If another transaction locks and invalidates the buffer
(freeing an inode chunk, for example) in the meantime, the bli is
flagged as stale, the dirty state is cleared and the bli remains in
the AIL.

If a shutdown occurs before the transaction that has invalidated the
buffer is committed, the transaction is ultimately aborted. The log
items are flagged as such and ->iop_unlock() handles the aborted
items. Because the bli is clean (due to the invalidation),
->iop_unlock() unconditionally releases it. The log item may still
reside in the AIL, however, which means the I/O completion handler
may still run and attempt to access it. This results in assert
failure due to the release of the bli while still present in the AIL
and a subsequent NULL dereference and panic in the buffer I/O
completion handling. This can be reproduced by running generic/388
in repetition.

To avoid this problem, update xfs_buf_item_unlock() to first check
whether the bli is aborted and if so, remove it from the AIL before
it is released. This ensures that the bli is no longer accessed
during the shutdown sequence after it has been freed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 0306168af332..f6a8422e9562 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -636,20 +636,23 @@ xfs_buf_item_unlock(
 
 	/*
 	 * Clean buffers, by definition, cannot be in the AIL. However, aborted
-	 * buffers may be dirty and hence in the AIL. Therefore if we are
-	 * aborting a buffer and we've just taken the last refernce away, we
-	 * have to check if it is in the AIL before freeing it. We need to free
-	 * it in this case, because an aborted transaction has already shut the
-	 * filesystem down and this is the last chance we will have to do so.
+	 * buffers may be in the AIL regardless of dirty state. An aborted
+	 * transaction that invalidates a buffer already in the AIL may have
+	 * marked it stale and cleared the dirty state, for example.
+	 *
+	 * Therefore if we are aborting a buffer and we've just taken the last
+	 * reference away, we have to check if it is in the AIL before freeing
+	 * it. We need to free it in this case, because an aborted transaction
+	 * has already shut the filesystem down and this is the last chance we
+	 * will have to do so.
 	 */
 	if (atomic_dec_and_test(&bip->bli_refcount)) {
-		if (clean)
-			xfs_buf_item_relse(bp);
-		else if (aborted) {
+		if (aborted) {
 			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
 			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
-		}
+		} else if (clean)
+			xfs_buf_item_relse(bp);
 	}
 
 	if (!(flags & XFS_BLI_HOLD))
-- 
2.14.1

