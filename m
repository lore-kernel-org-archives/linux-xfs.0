Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33872 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755147AbeFNMFG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 08:05:06 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] iomap: move bdev and dax_dev in a union
Date: Thu, 14 Jun 2018 14:04:53 +0200
Message-Id: <20180614120457.28285-3-hch@lst.de>
In-Reply-To: <20180614120457.28285-1-hch@lst.de>
References: <20180614120457.28285-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org

We always either ask for a block device or DAX device mapping, so we can
use the same space for both.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ext2/inode.c       | 6 ++++--
 fs/ext4/inode.c       | 6 ++++--
 fs/xfs/xfs_iomap.c    | 6 ++++--
 include/linux/iomap.h | 6 ++++--
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 71635909df3b..8aead4e9dbc1 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -815,9 +815,11 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		return ret;
 
 	iomap->flags = 0;
-	iomap->bdev = inode->i_sb->s_bdev;
 	iomap->offset = (u64)first_block << blkbits;
-	iomap->dax_dev = sbi->s_daxdev;
+	if (IS_DAX(inode))
+		iomap->dax_dev = sbi->s_daxdev;
+	else
+		iomap->bdev = inode->i_sb->s_bdev;
 
 	if (ret == 0) {
 		iomap->type = IOMAP_HOLE;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2ea07efbe016..79027e99118f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3524,8 +3524,10 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	iomap->flags = 0;
 	if (ext4_inode_datasync_dirty(inode))
 		iomap->flags |= IOMAP_F_DIRTY;
-	iomap->bdev = inode->i_sb->s_bdev;
-	iomap->dax_dev = sbi->s_daxdev;
+	if (IS_DAX(inode))
+		iomap->dax_dev = sbi->s_daxdev;
+	else
+		iomap->bdev = inode->i_sb->s_bdev;
 	iomap->offset = (u64)first_block << blkbits;
 	iomap->length = (u64)map.m_len << blkbits;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c6ce6f9335b6..c9c3d0df5e4c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -70,8 +70,10 @@ xfs_bmbt_to_iomap(
 	}
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
-	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
-	iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));
+	if (IS_DAX(VFS_I(ip)))
+		iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));
+	else
+		iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
 }
 
 xfs_extlen_t
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index a044a824da85..212f4d59bcbf 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -53,8 +53,10 @@ struct iomap {
 	u64			length;	/* length of mapping, bytes */
 	u16			type;	/* type of mapping */
 	u16			flags;	/* flags for mapping */
-	struct block_device	*bdev;	/* block device for I/O */
-	struct dax_device	*dax_dev; /* dax_dev for dax operations */
+	union {
+		struct block_device *bdev;
+		struct dax_device   *dax_dev;
+	};
 };
 
 /*
-- 
2.17.1

