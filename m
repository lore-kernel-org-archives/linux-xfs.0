Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52112 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbfF0KtE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 06:49:04 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/13] xfs: simplify xfs_ioend_can_merge
Date: Thu, 27 Jun 2019 12:48:31 +0200
Message-Id: <20190627104836.25446-9-hch@lst.de>
In-Reply-To: <20190627104836.25446-1-hch@lst.de>
References: <20190627104836.25446-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Compare the block layer status directly instead of converting it to
an errno first.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4ef8343c3759..cd839f24c7ef 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -299,13 +299,9 @@ xfs_end_ioend(
 static bool
 xfs_ioend_can_merge(
 	struct xfs_ioend	*ioend,
-	int			ioend_error,
 	struct xfs_ioend	*next)
 {
-	int			next_error;
-
-	next_error = blk_status_to_errno(next->io_bio->bi_status);
-	if (ioend_error != next_error)
+	if (ioend->io_bio->bi_status != next->io_bio->bi_status)
 		return false;
 	if ((ioend->io_fork == XFS_COW_FORK) ^ (next->io_fork == XFS_COW_FORK))
 		return false;
@@ -343,17 +339,11 @@ xfs_ioend_try_merge(
 	struct list_head	*more_ioends)
 {
 	struct xfs_ioend	*next_ioend;
-	int			ioend_error;
-
-	if (list_empty(more_ioends))
-		return;
-
-	ioend_error = blk_status_to_errno(ioend->io_bio->bi_status);
 
 	while (!list_empty(more_ioends)) {
 		next_ioend = list_first_entry(more_ioends, struct xfs_ioend,
 				io_list);
-		if (!xfs_ioend_can_merge(ioend, ioend_error, next_ioend))
+		if (!xfs_ioend_can_merge(ioend, next_ioend))
 			break;
 		list_move_tail(&next_ioend->io_list, &ioend->io_list);
 		ioend->io_size += next_ioend->io_size;
-- 
2.20.1
