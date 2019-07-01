Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44626 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfGAVzF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 17:55:05 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/15] FOLD: iomap: make ->submit_ioend optional
Date: Mon,  1 Jul 2019 23:54:26 +0200
Message-Id: <20190701215439.19162-3-hch@lst.de>
In-Reply-To: <20190701215439.19162-1-hch@lst.de>
References: <20190701215439.19162-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com

Provide a default end_io handler that comple file systems can override
if they need deferred action.  With that we don't need an submit_ioend
method for simple file systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c        | 26 +++++++++++++++++++++-----
 fs/xfs/xfs_aops.c | 23 ++++++++++-------------
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index ebfff663b2a9..7574f63939cc 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -2350,6 +2350,13 @@ iomap_sort_ioends(struct list_head *ioend_list)
 }
 EXPORT_SYMBOL_GPL(iomap_sort_ioends);
 
+static void iomap_writepage_end_bio(struct bio *bio)
+{
+	struct iomap_ioend *ioend = bio->bi_private;
+
+	iomap_finish_ioend(ioend, blk_status_to_errno(bio->bi_status));
+}
+
 /*
  * Submit the bio for an ioend. We are passed an ioend with a bio attached to
  * it, and we submit that bio. The ioend may be used for multiple bio
@@ -2368,14 +2375,23 @@ static int
 iomap_submit_ioend(struct iomap_writepage_ctx *wpc, struct iomap_ioend *ioend,
 		int error)
 {
+	ioend->io_bio->bi_private = ioend;
+	ioend->io_bio->bi_end_io = iomap_writepage_end_bio;
+
 	/*
-	 * If we are failing the IO now, just mark the ioend with an error and
-	 * finish it.  This will run IO completion immediately as there is only
-	 * one reference to the ioend at this point in time.
+	 * File systems can perform actions at submit time and/or override
+	 * the end_io handler here for complex operations like copy on write
+	 * extent manipulation or unwritten extent conversions.
 	 */
-	ioend->io_bio->bi_private = ioend;
-	error = wpc->ops->submit_ioend(ioend, error);
+	if (wpc->ops->submit_ioend)
+		error = wpc->ops->submit_ioend(ioend, error);
 	if (error) {
+		/*
+		 * If we are failing the IO now, just mark the ioend with an
+		 * error and finish it.  This will run IO completion immediately
+		 * as there is only one reference to the ioend at this point in
+		 * time.
+		 */
 		ioend->io_bio->bi_status = errno_to_blk_status(error);
 		bio_endio(ioend->io_bio);
 		return error;
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 0821312a1d11..ac1404bc583c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -265,20 +265,14 @@ xfs_end_bio(
 {
 	struct iomap_ioend	*ioend = bio->bi_private;
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
-	struct xfs_mount	*mp = ip->i_mount;
 	unsigned long		flags;
 
-	if ((ioend->io_flags & IOMAP_F_SHARED) ||
-	    ioend->io_type == IOMAP_UNWRITTEN ||
-	    ioend->io_private) {
-		spin_lock_irqsave(&ip->i_ioend_lock, flags);
-		if (list_empty(&ip->i_ioend_list))
-			WARN_ON_ONCE(!queue_work(mp->m_unwritten_workqueue,
-						 &ip->i_ioend_work));
-		list_add_tail(&ioend->io_list, &ip->i_ioend_list);
-		spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
-	} else
-		iomap_finish_ioend(ioend, blk_status_to_errno(bio->bi_status));
+	spin_lock_irqsave(&ip->i_ioend_lock, flags);
+	if (list_empty(&ip->i_ioend_list))
+		WARN_ON_ONCE(!queue_work(ip->i_mount->m_unwritten_workqueue,
+					 &ip->i_ioend_work));
+	list_add_tail(&ioend->io_list, &ip->i_ioend_list);
+	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
 }
 
 /*
@@ -531,7 +525,10 @@ xfs_submit_ioend(
 
 	memalloc_nofs_restore(nofs_flag);
 
-	ioend->io_bio->bi_end_io = xfs_end_bio;
+	if ((ioend->io_flags & IOMAP_F_SHARED) ||
+	    ioend->io_type == IOMAP_UNWRITTEN ||
+	    ioend->io_private)
+		ioend->io_bio->bi_end_io = xfs_end_bio;
 	return status;
 }
 
-- 
2.20.1
