Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52030 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfF0Kst (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 06:48:49 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/13] xfs: remove the unused xfs_count_page_state declaration
Date: Thu, 27 Jun 2019 12:48:25 +0200
Message-Id: <20190627104836.25446-3-hch@lst.de>
In-Reply-To: <20190627104836.25446-1-hch@lst.de>
References: <20190627104836.25446-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index f62b03186c62..45a1ea240cbb 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -28,7 +28,6 @@ extern const struct address_space_operations xfs_dax_aops;
 
 int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
 
-extern void xfs_count_page_state(struct page *, int *, int *);
 extern struct block_device *xfs_find_bdev_for_inode(struct inode *);
 extern struct dax_device *xfs_find_daxdev_for_inode(struct inode *);
 
-- 
2.20.1
