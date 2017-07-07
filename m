Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751828AbdGGV2J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jul 2017 17:28:09 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v4 2/3] iomap: Switch from blkno to physical offset
Date: Fri,  7 Jul 2017 23:28:00 +0200
Message-Id: <1499462881-4238-3-git-send-email-agruenba@redhat.com>
In-Reply-To: <1499462881-4238-1-git-send-email-agruenba@redhat.com>
References: <1499462881-4238-1-git-send-email-agruenba@redhat.com>
In-Reply-To: <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
References: <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

Replace iomap->blkno, the sector number in 512-byte units, into
iomap->pyhsical, the physical offset in bytes.  For invalid physical
offsets, use the special value IOMAP_NULL_PHYSICAL instead of
IOMAP_NULL_BLOCK.  This allows to use iomap for mappings which are not
block aligned, line inline data on ext4.

Add a new IOMAP_F_INLINE flag to indicate that a mapping is in an area
that contains data as well as metadata.  In iomap_fiemap, map that flag
to FIEMAP_EXTENT_DATA_INLINE.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/buffer.c           |  2 +-
 fs/dax.c              |  2 +-
 fs/ext2/inode.c       |  4 ++--
 fs/ext4/inode.c       |  4 ++--
 fs/iomap.c            | 14 ++++++++------
 fs/nfsd/blocklayout.c |  4 ++--
 fs/xfs/xfs_iomap.c    |  6 +++---
 include/linux/iomap.h |  5 +++--
 8 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b3674eb..e16f647 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1982,7 +1982,7 @@ iomap_to_bh(struct inode *inode, sector_t block, struct buffer_head *bh,
 	case IOMAP_MAPPED:
 		if (offset >= i_size_read(inode))
 			set_buffer_new(bh);
-		bh->b_blocknr = (iomap->blkno >> (inode->i_blkbits - 9)) +
+		bh->b_blocknr = (iomap->physical >> inode->i_blkbits) +
 				((offset - iomap->offset) >> inode->i_blkbits);
 		set_buffer_mapped(bh);
 		break;
diff --git a/fs/dax.c b/fs/dax.c
index 9187f3b..926caa5 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -985,7 +985,7 @@ EXPORT_SYMBOL_GPL(__dax_zero_page_range);
 
 static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 {
-	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
+	return (iomap->physical + (pos & PAGE_MASK) - iomap->offset) >> 9;
 }
 
 static loff_t
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 2dcbd56..8e9f109 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -823,11 +823,11 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 	if (ret == 0) {
 		iomap->type = IOMAP_HOLE;
-		iomap->blkno = IOMAP_NULL_BLOCK;
+		iomap->physical = IOMAP_NULL_PHYSICAL;
 		iomap->length = 1 << blkbits;
 	} else {
 		iomap->type = IOMAP_MAPPED;
-		iomap->blkno = (sector_t)bno << (blkbits - 9);
+		iomap->physical = (u64)bno << blkbits;
 		iomap->length = (u64)ret << blkbits;
 		iomap->flags |= IOMAP_F_MERGED;
 	}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 56a3b04..82f3f7d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3454,7 +3454,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 	if (ret == 0) {
 		iomap->type = IOMAP_HOLE;
-		iomap->blkno = IOMAP_NULL_BLOCK;
+		iomap->physical = IOMAP_NULL_PHYSICAL;
 		iomap->length = (u64)map.m_len << blkbits;
 	} else {
 		if (delalloc) {
@@ -3467,7 +3467,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 			WARN_ON_ONCE(1);
 			return -EIO;
 		}
-		iomap->blkno = (sector_t)map.m_pblk << (blkbits - 9);
+		iomap->physical = (u64)map.m_pblk << blkbits;
 		iomap->length = (u64)map.m_len << blkbits;
 	}
 
diff --git a/fs/iomap.c b/fs/iomap.c
index 432eed8..fca7b4c 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -350,8 +350,8 @@ static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
 static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
 		struct iomap *iomap)
 {
-	sector_t sector = iomap->blkno +
-		(((pos & ~(PAGE_SIZE - 1)) - iomap->offset) >> 9);
+	sector_t sector = (iomap->physical +
+			   (pos & ~(PAGE_SIZE - 1)) - iomap->offset) >> 9;
 
 	return __dax_zero_page_range(iomap->bdev, iomap->dax_dev, sector,
 			offset, bytes);
@@ -510,11 +510,13 @@ static int iomap_to_fiemap(struct fiemap_extent_info *fi,
 		flags |= FIEMAP_EXTENT_MERGED;
 	if (iomap->flags & IOMAP_F_SHARED)
 		flags |= FIEMAP_EXTENT_SHARED;
+	if (iomap->flags & IOMAP_F_INLINE)
+		flags |= FIEMAP_EXTENT_DATA_INLINE;
 
 	return fiemap_fill_next_extent(fi, iomap->offset,
-			iomap->blkno != IOMAP_NULL_BLOCK ? iomap->blkno << 9: 0,
+			iomap->physical != IOMAP_NULL_PHYSICAL ?
+					   iomap->physical : 0,
 			iomap->length, flags);
-
 }
 
 static loff_t
@@ -807,7 +809,7 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 	bio = bio_alloc(GFP_KERNEL, 1);
 	bio->bi_bdev = iomap->bdev;
 	bio->bi_iter.bi_sector =
-		iomap->blkno + ((pos - iomap->offset) >> 9);
+		(iomap->physical + pos - iomap->offset) >> 9;
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
@@ -886,7 +888,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 		bio = bio_alloc(GFP_KERNEL, nr_pages);
 		bio->bi_bdev = iomap->bdev;
 		bio->bi_iter.bi_sector =
-			iomap->blkno + ((pos - iomap->offset) >> 9);
+			(iomap->physical + pos - iomap->offset) >> 9;
 		bio->bi_private = dio;
 		bio->bi_end_io = iomap_dio_bio_end_io;
 
diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index fb5213a..6027b45 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -65,7 +65,7 @@ nfsd4_block_proc_layoutget(struct inode *inode, const struct svc_fh *fhp,
 			bex->es = PNFS_BLOCK_READ_DATA;
 		else
 			bex->es = PNFS_BLOCK_READWRITE_DATA;
-		bex->soff = (iomap.blkno << 9);
+		bex->soff = iomap.physical;
 		break;
 	case IOMAP_UNWRITTEN:
 		if (seg->iomode & IOMODE_RW) {
@@ -78,7 +78,7 @@ nfsd4_block_proc_layoutget(struct inode *inode, const struct svc_fh *fhp,
 			}
 
 			bex->es = PNFS_BLOCK_INVALID_DATA;
-			bex->soff = (iomap.blkno << 9);
+			bex->soff = iomap.physical;
 			break;
 		}
 		/*FALLTHRU*/
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 94e5bdf..45b2561 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -54,13 +54,13 @@ xfs_bmbt_to_iomap(
 	struct xfs_mount	*mp = ip->i_mount;
 
 	if (imap->br_startblock == HOLESTARTBLOCK) {
-		iomap->blkno = IOMAP_NULL_BLOCK;
+		iomap->physical = IOMAP_NULL_PHYSICAL;
 		iomap->type = IOMAP_HOLE;
 	} else if (imap->br_startblock == DELAYSTARTBLOCK) {
-		iomap->blkno = IOMAP_NULL_BLOCK;
+		iomap->physical = IOMAP_NULL_PHYSICAL;
 		iomap->type = IOMAP_DELALLOC;
 	} else {
-		iomap->blkno = xfs_fsb_to_db(ip, imap->br_startblock);
+		iomap->physical = xfs_fsb_to_db(ip, imap->br_startblock) << 9;
 		if (imap->br_state == XFS_EXT_UNWRITTEN)
 			iomap->type = IOMAP_UNWRITTEN;
 		else
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 8a03f5d..ad49625 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -28,14 +28,15 @@ struct vm_fault;
  */
 #define IOMAP_F_MERGED	0x10	/* contains multiple blocks/extents */
 #define IOMAP_F_SHARED	0x20	/* block shared with another file */
+#define IOMAP_F_INLINE	0x40	/* data mixed with metadata */
 
 /*
  * Magic value for blkno:
  */
-#define IOMAP_NULL_BLOCK -1LL	/* blkno is not valid */
+#define IOMAP_NULL_PHYSICAL -1LL	/* physical offset is not valid */
 
 struct iomap {
-	sector_t		blkno;	/* 1st sector of mapping, 512b units */
+	u64			physical; /* physical offset of mapping, bytes */
 	loff_t			offset;	/* file offset of mapping, bytes */
 	u64			length;	/* length of mapping, bytes */
 	u16			type;	/* type of mapping */
-- 
2.7.5

