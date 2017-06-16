Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46854 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751980AbdFPOve (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 10:51:34 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 2/7] GFS2: Implement iomap for block_map
Date: Fri, 16 Jun 2017 16:51:15 +0200
Message-Id: <1497624680-16685-3-git-send-email-agruenba@redhat.com>
In-Reply-To: <1497624680-16685-1-git-send-email-agruenba@redhat.com>
References: <1497624680-16685-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Bob Peterson <rpeterso@redhat.com>, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, Andreas Gruenbacher <agruenba@redhat.com>

From: Bob Peterson <rpeterso@redhat.com>

This patch implements iomap for block mapping, and switches the
block_map function to use it under the covers.

The additional IOMAP_F_BOUNDARY iomap flag indicates when iomap has
reached a "metadata boundary" and fetching the next mapping is likely to
incur an additional I/O.  This flag is used for setting the bh buffer
boundary flag.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/bmap.c        | 249 ++++++++++++++++++++++++++++++++++++--------------
 fs/gfs2/bmap.h        |   4 +
 fs/gfs2/trace_gfs2.h  |  65 +++++++++++++
 include/linux/iomap.h |   3 +-
 4 files changed, 250 insertions(+), 71 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index a431afd..fa33fdc 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -13,6 +13,7 @@
 #include <linux/blkdev.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
+#include <linux/iomap.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -416,7 +417,6 @@ static inline unsigned int gfs2_extent_length(void *start, unsigned int len, __b
 	const __be64 *first = ptr;
 	u64 d = be64_to_cpu(*ptr);
 
-	*eob = 0;
 	do {
 		ptr++;
 		if (ptr >= end)
@@ -504,10 +504,8 @@ static inline unsigned int hptrs(struct gfs2_sbd *sdp, const unsigned int hgt)
  * Returns: errno on error
  */
 
-static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
-			   bool zero_new, struct metapath *mp,
-			   const size_t maxlen, sector_t *dblock,
-			   unsigned *dblks)
+static int gfs2_iomap_alloc(struct inode *inode, struct iomap *iomap,
+			    unsigned flags, struct metapath *mp)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
@@ -515,36 +513,37 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 	struct buffer_head *dibh = mp->mp_bh[0];
 	u64 bn;
 	unsigned n, i, blks, alloced = 0, iblks = 0, branch_start = 0;
+	unsigned dblks = 0;
 	unsigned ptrs_per_blk;
 	const unsigned end_of_metadata = mp->mp_fheight - 1;
 	int ret;
-	int eob = 0;
 	enum alloc_state state;
 	__be64 *ptr;
 	__be64 zero_bn = 0;
+	size_t maxlen = iomap->length >> inode->i_blkbits;
 
 	BUG_ON(mp->mp_aheight < 1);
 	BUG_ON(dibh == NULL);
 
-	*dblock = 0;
-	*dblks = 0;
 	gfs2_trans_add_meta(ip->i_gl, dibh);
 
 	if (mp->mp_fheight == mp->mp_aheight) {
 		struct buffer_head *bh;
+		int eob;
+
 		/* Bottom indirect block exists, find unalloced extent size */
 		ptr = metapointer(end_of_metadata, mp);
 		bh = mp->mp_bh[end_of_metadata];
-		*dblks = gfs2_extent_length(bh->b_data, bh->b_size, ptr,
-					    maxlen, &eob);
-		BUG_ON(*dblks < 1);
+		dblks = gfs2_extent_length(bh->b_data, bh->b_size, ptr,
+					   maxlen, &eob);
+		BUG_ON(dblks < 1);
 		state = ALLOC_DATA;
 	} else {
 		/* Need to allocate indirect blocks */
 		ptrs_per_blk = mp->mp_fheight > 1 ? sdp->sd_inptrs :
 			sdp->sd_diptrs;
-		*dblks = min(maxlen, (size_t)(ptrs_per_blk -
-					      mp->mp_list[end_of_metadata]));
+		dblks = min(maxlen, (size_t)(ptrs_per_blk -
+					     mp->mp_list[end_of_metadata]));
 		if (mp->mp_fheight == ip->i_height) {
 			/* Writing into existing tree, extend tree down */
 			iblks = mp->mp_fheight - mp->mp_aheight;
@@ -560,7 +559,7 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 
 	/* start of the second part of the function (state machine) */
 
-	blks = *dblks + iblks;
+	blks = dblks + iblks;
 	i = mp->mp_aheight;
 	do {
 		int error;
@@ -617,26 +616,28 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 				break;
 		/* Tree complete, adding data blocks */
 		case ALLOC_DATA:
-			BUG_ON(n > *dblks);
+			BUG_ON(n > dblks);
 			BUG_ON(mp->mp_bh[end_of_metadata] == NULL);
 			gfs2_trans_add_meta(ip->i_gl, mp->mp_bh[end_of_metadata]);
-			*dblks = n;
+			dblks = n;
 			ptr = metapointer(end_of_metadata, mp);
-			*dblock = bn;
+			iomap->blkno = bn;
 			while (n-- > 0)
 				*ptr++ = cpu_to_be64(bn++);
-			if (zero_new) {
-				ret = sb_issue_zeroout(sb, *dblock, *dblks,
-						       GFP_NOFS);
+			if (flags & IOMAP_ZERO) {
+				ret = sb_issue_zeroout(sb, iomap->blkno,
+						       dblks, GFP_NOFS);
 				if (ret) {
 					fs_err(sdp,
 					       "Failed to zero data buffers\n");
+					flags &= ~IOMAP_ZERO;
 				}
 			}
 			break;
 		}
-	} while ((state != ALLOC_DATA) || !(*dblock));
+	} while (iomap->blkno == IOMAP_NULL_BLOCK);
 
+	iomap->length = (u64)dblks << inode->i_blkbits;
 	ip->i_height = mp->mp_fheight;
 	gfs2_add_inode_blocks(&ip->i_inode, alloced);
 	gfs2_dinode_out(ip, mp->mp_bh[0]->b_data);
@@ -644,47 +645,101 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 }
 
 /**
- * gfs2_block_map - Map a block from an inode to a disk block
- * @inode: The inode
- * @lblock: The logical block number
- * @bh_map: The bh to be mapped
- * @create: True if its ok to alloc blocks to satify the request
+ * hole_size - figure out the size of a hole
+ * @ip: The inode
+ * @lblock: The logical starting block number
+ * @mp: The metapath
  *
- * Sets buffer_mapped() if successful, sets buffer_boundary() if a
- * read of metadata will be required before the next block can be
- * mapped. Sets buffer_new() if new blocks were allocated.
+ * Returns: The hole size in bytes
  *
- * Returns: errno
  */
+static u64 hole_size(struct inode *inode, sector_t lblock, struct metapath *mp)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct metapath mp_eof;
+	u64 factor = 1;
+	int hgt;
+	u64 holesz = 0;
+	const __be64 *first, *end, *ptr;
+	const struct buffer_head *bh;
+	u64 lblock_stop = (i_size_read(inode) - 1) >> inode->i_blkbits;
+	int zeroptrs;
+	bool done = false;
+
+	/* Get another metapath, to the very last byte */
+	find_metapath(sdp, lblock_stop, &mp_eof, ip->i_height);
+	for (hgt = ip->i_height - 1; hgt >= 0 && !done; hgt--) {
+		bh = mp->mp_bh[hgt];
+		if (bh) {
+			zeroptrs = 0;
+			first = metapointer(hgt, mp);
+			end = (const __be64 *)(bh->b_data + bh->b_size);
+
+			for (ptr = first; ptr < end; ptr++) {
+				if (*ptr) {
+					done = true;
+					break;
+				} else {
+					zeroptrs++;
+				}
+			}
+		} else {
+			zeroptrs = sdp->sd_inptrs;
+		}
+		if (factor * zeroptrs >= lblock_stop - lblock + 1) {
+			holesz = lblock_stop - lblock + 1;
+			break;
+		}
+		holesz += factor * zeroptrs;
 
-int gfs2_block_map(struct inode *inode, sector_t lblock,
-		   struct buffer_head *bh_map, int create)
+		factor *= sdp->sd_inptrs;
+		if (hgt && (mp->mp_list[hgt - 1] < mp_eof.mp_list[hgt - 1]))
+			(mp->mp_list[hgt - 1])++;
+	}
+	return holesz << inode->i_blkbits;
+}
+
+/**
+ * gfs2_get_iomap - Map blocks from an inode to disk blocks
+ * @inode: The inode
+ * @pos: Starting position in bytes
+ * @length: Length to map, in bytes
+ * @flags: iomap flags
+ * @iomap: The iomap structure
+ *
+ * Returns: errno
+ */
+int gfs2_get_iomap(struct inode *inode, loff_t pos, ssize_t length,
+		   unsigned flags, struct iomap *iomap)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct metapath mp = { .mp_aheight = 1, };
 	unsigned int bsize = sdp->sd_sb.sb_bsize;
-	const size_t maxlen = bh_map->b_size >> inode->i_blkbits;
 	const u64 *arr = sdp->sd_heightsize;
 	__be64 *ptr;
-	u64 size;
-	struct metapath mp;
+	sector_t lblock = pos >> inode->i_blkbits;
+	sector_t lend = (pos + length + sdp->sd_sb.sb_bsize - 1) >> inode->i_blkbits;
 	int ret;
-	int eob;
+	int eob = 0;
 	unsigned int len;
 	struct buffer_head *bh;
 	u8 height;
-	bool zero_new = false;
-	sector_t dblock = 0;
-	unsigned dblks;
 
-	BUG_ON(maxlen == 0);
+	trace_gfs2_iomap_start(ip, pos, length, flags);
+	if (!length) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	iomap->offset = lblock << inode->i_blkbits;
+	iomap->blkno = IOMAP_NULL_BLOCK;
+	iomap->type = IOMAP_HOLE;
+	iomap->length = (u64)(lend - lblock) << inode->i_blkbits;
+	iomap->flags = 0;
+	bmap_lock(ip, 0);
 
-	memset(&mp, 0, sizeof(mp));
-	bmap_lock(ip, create);
-	clear_buffer_mapped(bh_map);
-	clear_buffer_new(bh_map);
-	clear_buffer_boundary(bh_map);
-	trace_gfs2_bmap(ip, bh_map, lblock, create, 1);
 	if (gfs2_is_dir(ip)) {
 		bsize = sdp->sd_jbsize;
 		arr = sdp->sd_jheightsize;
@@ -692,56 +747,110 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 
 	ret = gfs2_meta_inode_buffer(ip, &mp.mp_bh[0]);
 	if (ret)
-		goto out;
+		goto out_release;
 
 	height = ip->i_height;
-	size = (lblock + 1) * bsize;
-	while (size > arr[height])
+	while ((lblock + 1) * bsize > arr[height])
 		height++;
 	find_metapath(sdp, lblock, &mp, height);
-	mp.mp_aheight = 1;
 	if (height > ip->i_height || gfs2_is_stuffed(ip))
 		goto do_alloc;
+
 	ret = lookup_metapath(ip, &mp);
 	if (ret < 0)
-		goto out;
+		goto out_release;
+
 	if (mp.mp_aheight != ip->i_height)
 		goto do_alloc;
+
 	ptr = metapointer(ip->i_height - 1, &mp);
 	if (*ptr == 0)
 		goto do_alloc;
-	map_bh(bh_map, inode->i_sb, be64_to_cpu(*ptr));
+
+	iomap->type = IOMAP_MAPPED;
+	iomap->blkno = be64_to_cpu(*ptr);
+
 	bh = mp.mp_bh[ip->i_height - 1];
-	len = gfs2_extent_length(bh->b_data, bh->b_size, ptr, maxlen, &eob);
-	bh_map->b_size = (len << inode->i_blkbits);
+	len = gfs2_extent_length(bh->b_data, bh->b_size, ptr, lend - lblock, &eob);
 	if (eob)
-		set_buffer_boundary(bh_map);
+		iomap->flags |= IOMAP_F_BOUNDARY;
+	iomap->length = (u64)len << inode->i_blkbits;
+
 	ret = 0;
-out:
+
+out_release:
 	release_metapath(&mp);
-	trace_gfs2_bmap(ip, bh_map, lblock, create, ret);
-	bmap_unlock(ip, create);
+	bmap_unlock(ip, 0);
+out:
+	trace_gfs2_iomap_end(ip, iomap, ret);
 	return ret;
 
 do_alloc:
-	/* All allocations are done here, firstly check create flag */
-	if (!create) {
+	if (!(flags & IOMAP_WRITE)) {
+		if (pos >= i_size_read(inode)) {
+			ret = -ENOENT;
+			goto out_release;
+		}
 		BUG_ON(gfs2_is_stuffed(ip));
 		ret = 0;
-		goto out;
+		iomap->length = hole_size(inode, lblock, &mp);
+		goto out_release;
 	}
 
-	/* At this point ret is the tree depth of already allocated blocks */
+	ret = gfs2_iomap_alloc(inode, iomap, flags, &mp);
+	goto out_release;
+}
+
+/**
+ * gfs2_block_map - Map a block from an inode to a disk block
+ * @inode: The inode
+ * @lblock: The logical block number
+ * @bh_map: The bh to be mapped
+ * @create: True if its ok to alloc blocks to satify the request
+ *
+ * Sets buffer_mapped() if successful, sets buffer_boundary() if a
+ * read of metadata will be required before the next block can be
+ * mapped. Sets buffer_new() if new blocks were allocated.
+ *
+ * Returns: errno
+ */
+
+int gfs2_block_map(struct inode *inode, sector_t lblock,
+		   struct buffer_head *bh_map, int create)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct iomap iomap;
+	int ret, flags = 0;
+
+	clear_buffer_mapped(bh_map);
+	clear_buffer_new(bh_map);
+	clear_buffer_boundary(bh_map);
+	trace_gfs2_bmap(ip, bh_map, lblock, create, 1);
+
+	if (create)
+		flags |= IOMAP_WRITE;
 	if (buffer_zeronew(bh_map))
-		zero_new = true;
-	ret = gfs2_bmap_alloc(inode, lblock, zero_new, &mp, maxlen, &dblock,
-			      &dblks);
-	if (ret == 0) {
-		map_bh(bh_map, inode->i_sb, dblock);
-		bh_map->b_size = dblks << inode->i_blkbits;
+		flags |= IOMAP_ZERO;
+	ret = gfs2_get_iomap(inode, lblock << sdp->sd_sb.sb_bsize_shift,
+			     bh_map->b_size, flags, &iomap);
+	if (ret)
+		goto out;
+
+	iomap.length = round_up(iomap.length, sdp->sd_sb.sb_bsize);
+	bh_map->b_size = iomap.length;
+	if (iomap.flags & IOMAP_F_BOUNDARY)
+		set_buffer_boundary(bh_map);
+	if (iomap.blkno != IOMAP_NULL_BLOCK)
+		map_bh(bh_map, inode->i_sb, iomap.blkno);
+	bh_map->b_size = iomap.length;
+	clear_buffer_zeronew(bh_map);
+	if (iomap.flags & IOMAP_F_NEW)
 		set_buffer_new(bh_map);
-	}
-	goto out;
+
+out:
+	trace_gfs2_bmap(ip, bh_map, lblock, create, ret);
+	return ret;
 }
 
 /*
diff --git a/fs/gfs2/bmap.h b/fs/gfs2/bmap.h
index 81ded5e..e904aed 100644
--- a/fs/gfs2/bmap.h
+++ b/fs/gfs2/bmap.h
@@ -10,6 +10,8 @@
 #ifndef __BMAP_DOT_H__
 #define __BMAP_DOT_H__
 
+#include <linux/iomap.h>
+
 #include "inode.h"
 
 struct inode;
@@ -47,6 +49,8 @@ static inline void gfs2_write_calc_reserv(const struct gfs2_inode *ip,
 extern int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page);
 extern int gfs2_block_map(struct inode *inode, sector_t lblock,
 			  struct buffer_head *bh, int create);
+extern int gfs2_get_iomap(struct inode *inode, loff_t pos, ssize_t length,
+			  unsigned flags, struct iomap *iomap);
 extern int gfs2_extent_map(struct inode *inode, u64 lblock, int *new,
 			   u64 *dblock, unsigned *extlen);
 extern int gfs2_setattr_size(struct inode *inode, u64 size);
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index 49ac55d..3c91ae3 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -12,6 +12,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/writeback.h>
 #include <linux/ktime.h>
+#include <linux/iomap.h>
 #include "incore.h"
 #include "glock.h"
 #include "rgrp.h"
@@ -469,6 +470,70 @@ TRACE_EVENT(gfs2_bmap,
 		  __entry->errno)
 );
 
+TRACE_EVENT(gfs2_iomap_start,
+
+	TP_PROTO(const struct gfs2_inode *ip, loff_t pos, ssize_t length,
+		 u16 flags),
+
+	TP_ARGS(ip, pos, length, flags),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	u64,	inum			)
+		__field(	loff_t, pos			)
+		__field(	ssize_t, length			)
+		__field(	u16,	flags			)
+	),
+
+	TP_fast_assign(
+		__entry->dev            = ip->i_gl->gl_name.ln_sbd->sd_vfs->s_dev;
+		__entry->inum		= ip->i_no_addr;
+		__entry->pos		= pos;
+		__entry->length		= length;
+		__entry->flags		= flags;
+	),
+
+	TP_printk("%u,%u bmap %llu iomap start %llu/%lu flags:%08x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long long)__entry->inum,
+		  (unsigned long long)__entry->pos,
+		  (unsigned long)__entry->length, (u16)__entry->flags)
+);
+
+TRACE_EVENT(gfs2_iomap_end,
+
+	TP_PROTO(const struct gfs2_inode *ip, struct iomap *iomap, int ret),
+
+	TP_ARGS(ip, iomap, ret),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	u64,	inum			)
+		__field(	loff_t, offset			)
+		__field(	ssize_t, length			)
+		__field(	u16,	flags			)
+		__field(	u16,	type			)
+		__field(	int,	ret			)
+	),
+
+	TP_fast_assign(
+		__entry->dev            = ip->i_gl->gl_name.ln_sbd->sd_vfs->s_dev;
+		__entry->inum		= ip->i_no_addr;
+		__entry->offset		= iomap->offset;
+		__entry->length		= iomap->length;
+		__entry->flags		= iomap->flags;
+		__entry->type		= iomap->type;
+		__entry->ret		= ret;
+	),
+
+	TP_printk("%u,%u bmap %llu iomap end %llu/%lu ty:%d flags:%08x rc:%d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long long)__entry->inum,
+		  (unsigned long long)__entry->offset,
+		  (unsigned long)__entry->length, (u16)__entry->type,
+		  (u16)__entry->flags, __entry->ret)
+);
+
 /* Keep track of blocks as they are allocated/freed */
 TRACE_EVENT(gfs2_block_alloc,
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index f753e78..9d64933 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -21,7 +21,8 @@ struct vm_fault;
 /*
  * Flags for all iomap mappings:
  */
-#define IOMAP_F_NEW	0x01	/* blocks have been newly allocated */
+#define IOMAP_F_NEW		0x01	/* blocks have been newly allocated */
+#define IOMAP_F_BOUNDARY	0x02	/* mapping ends at metadata boundary */
 
 /*
  * Flags that only need to be reported for IOMAP_REPORT requests:
-- 
2.7.5

