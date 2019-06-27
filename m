Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52104 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbfF0KtC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 06:49:02 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/13] xfs: allow merging ioends over append boundaries
Date: Thu, 27 Jun 2019 12:48:30 +0200
Message-Id: <20190627104836.25446-8-hch@lst.de>
In-Reply-To: <20190627104836.25446-1-hch@lst.de>
References: <20190627104836.25446-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

There is no real problem merging ioends that go beyond i_size into an
ioend that doesn't.  We just need to move the append transaction to the
base ioend.  Also use the opportunity to use a real error code instead
of the magic 1 to cancel the transactions, and write a comment
explaining the scheme.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8b3070a40245..4ef8343c3759 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -314,11 +314,28 @@ xfs_ioend_can_merge(
 		return false;
 	if (ioend->io_offset + ioend->io_size != next->io_offset)
 		return false;
-	if (xfs_ioend_is_append(ioend) != xfs_ioend_is_append(next))
-		return false;
 	return true;
 }
 
+/*
+ * If the to be merged ioend has a preallocated transaction for file
+ * size updates we need to ensure the ioend it is merged into also
+ * has one.  If it already has one we can simply cancel the transaction
+ * as it is guaranteed to be clean.
+ */
+static void
+xfs_ioend_merge_append_transactions(
+	struct xfs_ioend	*ioend,
+	struct xfs_ioend	*next)
+{
+	if (!ioend->io_append_trans) {
+		ioend->io_append_trans = next->io_append_trans;
+		next->io_append_trans = NULL;
+	} else {
+		xfs_setfilesize_ioend(next, -ECANCELED);
+	}
+}
+
 /* Try to merge adjacent completions. */
 STATIC void
 xfs_ioend_try_merge(
@@ -327,7 +344,6 @@ xfs_ioend_try_merge(
 {
 	struct xfs_ioend	*next_ioend;
 	int			ioend_error;
-	int			error;
 
 	if (list_empty(more_ioends))
 		return;
@@ -341,10 +357,8 @@ xfs_ioend_try_merge(
 			break;
 		list_move_tail(&next_ioend->io_list, &ioend->io_list);
 		ioend->io_size += next_ioend->io_size;
-		if (ioend->io_append_trans) {
-			error = xfs_setfilesize_ioend(next_ioend, 1);
-			ASSERT(error == 1);
-		}
+		if (next_ioend->io_append_trans)
+			xfs_ioend_merge_append_transactions(ioend, next_ioend);
 	}
 }
 
-- 
2.20.1
