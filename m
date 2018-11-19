Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33082 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbeKTAKI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Nov 2018 19:10:08 -0500
Received: from 089144201193.atnat0010.highway.a1.net ([89.144.201.193] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gOjsh-0004t4-WD
        for linux-xfs@vger.kernel.org; Mon, 19 Nov 2018 13:46:28 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/9] xfs: handle -EAGAIN from xfs_iomap_write_allocate
Date: Mon, 19 Nov 2018 14:46:12 +0100
Message-Id: <20181119134619.16812-3-hch@lst.de>
In-Reply-To: <20181119134619.16812-1-hch@lst.de>
References: <20181119134619.16812-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

-EAGAIN from xfs_iomap_write_allocate means that due to a racing
truncate there is no actual mapping at this offset anymore, and we
need to skip the block during writeback.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 338b9d9984e0..da520860c85e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -349,6 +349,7 @@ xfs_map_blocks(
 	imap_valid = offset_fsb >= wpc->imap.br_startoff &&
 		     offset_fsb < wpc->imap.br_startoff + wpc->imap.br_blockcount;
 	if (imap_valid &&
+	    !WARN_ON_ONCE(wpc->imap.br_startblock == HOLESTARTBLOCK) &&
 	    (!xfs_inode_has_cow_data(ip) ||
 	     wpc->io_type == XFS_IO_COW ||
 	     wpc->cow_seq == READ_ONCE(ip->i_cowfp->if_seq)))
@@ -454,8 +455,14 @@ xfs_map_blocks(
 allocate_blocks:
 	error = xfs_iomap_write_allocate(ip, whichfork, offset, &imap,
 			&wpc->cow_seq);
-	if (error)
+	if (error) {
+		if (error == -EAGAIN) {
+			/* we might have raced with truncate */
+			wpc->io_type = XFS_IO_HOLE;
+			error = 0;
+		}
 		return error;
+	}
 	ASSERT(whichfork == XFS_COW_FORK || cow_fsb == NULLFILEOFF ||
 	       imap.br_startoff + imap.br_blockcount <= cow_fsb);
 	wpc->imap = imap;
-- 
2.19.1
