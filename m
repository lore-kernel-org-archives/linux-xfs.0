Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40180 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbfGVJuk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jul 2019 05:50:40 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/12] xfs: refactor the ioend merging code
Date: Mon, 22 Jul 2019 11:50:16 +0200
Message-Id: <20190722095024.19075-5-hch@lst.de>
In-Reply-To: <20190722095024.19075-1-hch@lst.de>
References: <20190722095024.19075-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Introduce two nicely abstracted helper, which can be moved to the
iomap code later.  Also use list_pop_entry and list_first_entry_or_null
to simplify the code a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c | 70 +++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5a48c8aebedf..8a1cd562a358 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -116,6 +116,19 @@ xfs_destroy_ioend(
 	}
 }
 
+static void
+xfs_destroy_ioends(
+	struct xfs_ioend	*ioend,
+	int			error)
+{
+	struct list_head	tmp;
+
+	list_replace_init(&ioend->io_list, &tmp);
+	xfs_destroy_ioend(ioend, error);
+	while ((ioend = list_pop_entry(&tmp, struct xfs_ioend, io_list)))
+		xfs_destroy_ioend(ioend, error);
+}
+
 /*
  * Fast and loose check if this write could update the on-disk inode size.
  */
@@ -230,7 +243,6 @@ STATIC void
 xfs_end_ioend(
 	struct xfs_ioend	*ioend)
 {
-	struct list_head	ioend_list;
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	xfs_off_t		offset = ioend->io_offset;
 	size_t			size = ioend->io_size;
@@ -275,16 +287,7 @@ xfs_end_ioend(
 done:
 	if (ioend->io_append_trans)
 		error = xfs_setfilesize_ioend(ioend, error);
-	list_replace_init(&ioend->io_list, &ioend_list);
-	xfs_destroy_ioend(ioend, error);
-
-	while (!list_empty(&ioend_list)) {
-		ioend = list_first_entry(&ioend_list, struct xfs_ioend,
-				io_list);
-		list_del_init(&ioend->io_list);
-		xfs_destroy_ioend(ioend, error);
-	}
-
+	xfs_destroy_ioends(ioend, error);
 	memalloc_nofs_restore(nofs_flag);
 }
 
@@ -333,17 +336,18 @@ xfs_ioend_try_merge(
 	struct xfs_ioend	*ioend,
 	struct list_head	*more_ioends)
 {
-	struct xfs_ioend	*next_ioend;
+	struct xfs_ioend	*next;
 
-	while (!list_empty(more_ioends)) {
-		next_ioend = list_first_entry(more_ioends, struct xfs_ioend,
-				io_list);
-		if (!xfs_ioend_can_merge(ioend, next_ioend))
+	INIT_LIST_HEAD(&ioend->io_list);
+
+	while ((next = list_first_entry_or_null(more_ioends, struct xfs_ioend,
+			io_list))) {
+		if (!xfs_ioend_can_merge(ioend, next))
 			break;
-		list_move_tail(&next_ioend->io_list, &ioend->io_list);
-		ioend->io_size += next_ioend->io_size;
-		if (next_ioend->io_append_trans)
-			xfs_ioend_merge_append_transactions(ioend, next_ioend);
+		list_move_tail(&next->io_list, &ioend->io_list);
+		ioend->io_size += next->io_size;
+		if (next->io_append_trans)
+			xfs_ioend_merge_append_transactions(ioend, next);
 	}
 }
 
@@ -366,29 +370,31 @@ xfs_ioend_compare(
 	return 0;
 }
 
+static void
+xfs_sort_ioends(
+	struct list_head	*ioend_list)
+{
+	list_sort(NULL, ioend_list, xfs_ioend_compare);
+}
+
 /* Finish all pending io completions. */
 void
 xfs_end_io(
 	struct work_struct	*work)
 {
-	struct xfs_inode	*ip;
+	struct xfs_inode	*ip =
+		container_of(work, struct xfs_inode, i_ioend_work);
 	struct xfs_ioend	*ioend;
-	struct list_head	completion_list;
+	struct list_head	tmp;
 	unsigned long		flags;
 
-	ip = container_of(work, struct xfs_inode, i_ioend_work);
-
 	spin_lock_irqsave(&ip->i_ioend_lock, flags);
-	list_replace_init(&ip->i_ioend_list, &completion_list);
+	list_replace_init(&ip->i_ioend_list, &tmp);
 	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
 
-	list_sort(NULL, &completion_list, xfs_ioend_compare);
-
-	while (!list_empty(&completion_list)) {
-		ioend = list_first_entry(&completion_list, struct xfs_ioend,
-				io_list);
-		list_del_init(&ioend->io_list);
-		xfs_ioend_try_merge(ioend, &completion_list);
+	xfs_sort_ioends(&tmp);
+	while ((ioend = list_pop_entry(&tmp, struct xfs_ioend, io_list))) {
+		xfs_ioend_try_merge(ioend, &tmp);
 		xfs_end_ioend(ioend);
 	}
 }
-- 
2.20.1
