Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39463 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdIQVHP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:15 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/47] xfs: release bli from transaction properly on fs shutdown
Date: Sun, 17 Sep 2017 14:06:30 -0700
Message-Id: <20170917210712.10804-6-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit 79e641ce29cfae5b8fc55fb77ac62d11d2d849c0 upstream.

If a filesystem shutdown occurs with a buffer log item in the CIL
and a log force occurs, the ->iop_unpin() handler is generally
expected to tear down the bli properly. This entails freeing the bli
memory and releasing the associated hold on the buffer so it can be
released and the filesystem unmounted.

If this sequence occurs while ->bli_refcount is elevated (i.e.,
another transaction is open and attempting to modify the buffer),
however, ->iop_unpin() may not be responsible for releasing the bli.
Instead, the transaction may release the final ->bli_refcount
reference and thus xfs_trans_brelse() is responsible for tearing
down the bli.

While xfs_trans_brelse() does drop the reference count, it only
attempts to release the bli if it is clean (i.e., not in the
CIL/AIL). If the filesystem is shutdown and the bli is sitting dirty
in the CIL as noted above, this ends up skipping the last
opportunity to release the bli. In turn, this leaves the hold on the
buffer and causes an unmount hang. This can be reproduced by running
generic/388 in repetition.

Update xfs_trans_brelse() to handle this shutdown corner case
correctly. If the final bli reference is dropped and the filesystem
is shutdown, remove the bli from the AIL (if necessary) and release
the bli to drop the buffer hold and ensure an unmount does not hang.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trans_buf.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 8ee29ca132dc..86987d823d76 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -356,6 +356,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 		 xfs_buf_t	*bp)
 {
 	xfs_buf_log_item_t	*bip;
+	int			freed;
 
 	/*
 	 * Default to a normal brelse() call if the tp is NULL.
@@ -419,16 +420,22 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	/*
 	 * Drop our reference to the buf log item.
 	 */
-	atomic_dec(&bip->bli_refcount);
+	freed = atomic_dec_and_test(&bip->bli_refcount);
 
 	/*
-	 * If the buf item is not tracking data in the log, then
-	 * we must free it before releasing the buffer back to the
-	 * free pool.  Before releasing the buffer to the free pool,
-	 * clear the transaction pointer in b_fsprivate2 to dissolve
-	 * its relation to this transaction.
+	 * If the buf item is not tracking data in the log, then we must free it
+	 * before releasing the buffer back to the free pool.
+	 *
+	 * If the fs has shutdown and we dropped the last reference, it may fall
+	 * on us to release a (possibly dirty) bli if it never made it to the
+	 * AIL (e.g., the aborted unpin already happened and didn't release it
+	 * due to our reference). Since we're already shutdown and need xa_lock,
+	 * just force remove from the AIL and release the bli here.
 	 */
-	if (!xfs_buf_item_dirty(bip)) {
+	if (XFS_FORCED_SHUTDOWN(tp->t_mountp) && freed) {
+		xfs_trans_ail_remove(&bip->bli_item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_buf_item_relse(bp);
+	} else if (!xfs_buf_item_dirty(bip)) {
 /***
 		ASSERT(bp->b_pincount == 0);
 ***/
-- 
2.14.1

