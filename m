Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33682 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbdIQVHc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:32 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 34/47] xfs: open-code xfs_buf_item_dirty()
Date: Sun, 17 Sep 2017 14:06:59 -0700
Message-Id: <20170917210712.10804-35-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit a4f6cf6b2b6b60ec2a05a33a32e65caa4149aa2b upstream.

It checks a single flag and has one caller. It probably isn't worth
its own function.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf_item.c  | 11 -----------
 fs/xfs/xfs_buf_item.h  |  1 -
 fs/xfs/xfs_trans_buf.c |  2 +-
 3 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 573fc72c3f23..cdae0ad5e0a5 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -945,17 +945,6 @@ xfs_buf_item_log(
 }
 
 
-/*
- * Return 1 if the buffer has been logged or ordered in a transaction (at any
- * point, not just the current transaction) and 0 if not.
- */
-uint
-xfs_buf_item_dirty(
-	xfs_buf_log_item_t	*bip)
-{
-	return (bip->bli_flags & XFS_BLI_DIRTY);
-}
-
 STATIC void
 xfs_buf_item_free(
 	xfs_buf_log_item_t	*bip)
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 530686e1afb9..e0e744aefaa8 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -64,7 +64,6 @@ typedef struct xfs_buf_log_item {
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_relse(struct xfs_buf *);
 void	xfs_buf_item_log(xfs_buf_log_item_t *, uint, uint);
-uint	xfs_buf_item_dirty(xfs_buf_log_item_t *);
 void	xfs_buf_attach_iodone(struct xfs_buf *,
 			      void(*)(struct xfs_buf *, xfs_log_item_t *),
 			      xfs_log_item_t *);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 86987d823d76..cac8abbeca3f 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -435,7 +435,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	if (XFS_FORCED_SHUTDOWN(tp->t_mountp) && freed) {
 		xfs_trans_ail_remove(&bip->bli_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_buf_item_relse(bp);
-	} else if (!xfs_buf_item_dirty(bip)) {
+	} else if (!(bip->bli_flags & XFS_BLI_DIRTY)) {
 /***
 		ASSERT(bp->b_pincount == 0);
 ***/
-- 
2.14.1

