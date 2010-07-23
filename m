Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NAcPlp195578 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 05:38:25 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F57746B9D4
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 03:41:25 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	7IOFPIpC08YLU1j5 for <xfs@oss.sgi.com>;
	Fri, 23 Jul 2010 03:41:25 -0700 (PDT)
Received: from dastard (unverified [121.44.18.238])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	32660678-1927428
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 20:11:24 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OcFgx-0007Qu-0x
	for xfs@oss.sgi.com; Fri, 23 Jul 2010 20:41:23 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OcFgv-0000RS-I6
	for xfs@oss.sgi.com; Fri, 23 Jul 2010 20:41:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] fs: get_blocks needs an unaligned mapping flag
Date: Fri, 23 Jul 2010 20:41:16 +1000
Message-Id: <1279881678-1660-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1279881678-1660-1-git-send-email-david@fromorbit.com>
References: <1279881678-1660-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When issuing concurrent unaligned direct IO to the same filesystem block, the
direct IO sub-block zeroing code will extend the length of the write being done
when writing into a hole or unwritten extents. If we are writing into unwritten
extents, then the two IOs will both see the extent as unwritten at IO issue
time and attempt to zero the part of the block that they are not writing to.

The result of this is that whichever IO completes last will win and part of the
block will be zero instead of containing the correct data. Eric Sandeen has
demonstrated the problem with xfstest #240. In the case of XFS, we allow
concurrent direct IO writes to occur, but we cannot allow block zeroing to
occur concurrently with other IO.

To allow serialisation of block zeroing across multiple independent IOs, we
need to know if the region being mapped by the IO is fsb-aligned or not. If it
is not aligned, then we need to prevent further direct IO writes from being
executed until the IO that is doing the zeroing completes (i.e. converts the
extent back to written). Passing the fact that the mapping is for an unaligned
IO into the get_blocks calback is sufficient to allow us to implement the
necessary serialisation.

Change the "create" parameter of the get_blocks callback to a flags field,
and define the flags to be backwards compatible as such:

#define GET_BLOCKS_READ		0x00	/* map, no allocation */
#define GET_BLOCKS_CREATE	0x01	/* map, allocate if hole */
#define GET_BLOCKS_UNALIGNED	0x02	/* mapping for unaligned IO */

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/buffer.c        |   17 +++++++++--------
 fs/direct-io.c     |   25 ++++++++++++++++++++++---
 fs/ioctl.c         |    2 +-
 fs/mpage.c         |    6 ++++--
 include/linux/fs.h |   10 +++++++++-
 5 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index d54812b..eda0395 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1680,7 +1680,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 		} else if ((!buffer_mapped(bh) || buffer_delay(bh)) &&
 			   buffer_dirty(bh)) {
 			WARN_ON(bh->b_size != blocksize);
-			err = get_block(inode, block, bh, 1);
+			err = get_block(inode, block, bh, GET_BLOCKS_CREATE);
 			if (err)
 				goto recover;
 			clear_buffer_delay(bh);
@@ -1869,7 +1869,7 @@ static int __block_prepare_write(struct inode *inode, struct page *page,
 			clear_buffer_new(bh);
 		if (!buffer_mapped(bh)) {
 			WARN_ON(bh->b_size != blocksize);
-			err = get_block(inode, block, bh, 1);
+			err = get_block(inode, block, bh, GET_BLOCKS_CREATE);
 			if (err)
 				break;
 			if (buffer_new(bh)) {
@@ -2192,7 +2192,8 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
 			fully_mapped = 0;
 			if (iblock < lblock) {
 				WARN_ON(bh->b_size != blocksize);
-				err = get_block(inode, iblock, bh, 0);
+				err = get_block(inode, iblock, bh,
+							GET_BLOCKS_READ);
 				if (err)
 					SetPageError(page);
 			}
@@ -2583,9 +2584,9 @@ int nobh_write_begin_newtrunc(struct file *file, struct address_space *mapping,
 
 		block_end = block_start + blocksize;
 		bh->b_state = 0;
-		create = 1;
+		create = GET_BLOCKS_CREATE;
 		if (block_start >= to)
-			create = 0;
+			create = GET_BLOCKS_READ;
 		ret = get_block(inode, block_in_file + block_in_page,
 					bh, create);
 		if (ret)
@@ -2816,7 +2817,7 @@ has_buffers:
 
 	map_bh.b_size = blocksize;
 	map_bh.b_state = 0;
-	err = get_block(inode, iblock, &map_bh, 0);
+	err = get_block(inode, iblock, &map_bh, GET_BLOCKS_READ);
 	if (err)
 		goto unlock;
 	/* unmapped? It's a hole - nothing to do */
@@ -2893,7 +2894,7 @@ int block_truncate_page(struct address_space *mapping,
 	err = 0;
 	if (!buffer_mapped(bh)) {
 		WARN_ON(bh->b_size != blocksize);
-		err = get_block(inode, iblock, bh, 0);
+		err = get_block(inode, iblock, bh, GET_BLOCKS_READ);
 		if (err)
 			goto unlock;
 		/* unmapped? It's a hole - nothing to do */
@@ -2987,7 +2988,7 @@ sector_t generic_block_bmap(struct address_space *mapping, sector_t block,
 	tmp.b_state = 0;
 	tmp.b_blocknr = 0;
 	tmp.b_size = 1 << inode->i_blkbits;
-	get_block(inode, block, &tmp, 0);
+	get_block(inode, block, &tmp, GET_BLOCKS_READ);
 	return tmp.b_blocknr;
 }
 EXPORT_SYMBOL(generic_block_bmap);
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 7600aac..a120a3d 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -538,13 +538,33 @@ static int get_more_blocks(struct dio *dio)
 		dio_count = dio->final_block_in_request - dio->block_in_file;
 		fs_count = dio_count >> dio->blkfactor;
 		blkmask = (1 << dio->blkfactor) - 1;
-		if (dio_count & blkmask)	
+		if (dio_count & blkmask) {
 			fs_count++;
+		}
 
 		map_bh->b_state = 0;
 		map_bh->b_size = fs_count << dio->inode->i_blkbits;
 
 		/*
+		 * Because we're mapping full filesystem blocks here to do our
+		 * own sub-block zeroing for writes, we need to tell the fs
+		 * whether we might be doing zeroing so it can synchronise the
+		 * zeroing against other concurrent IO. If we don't do this,
+		 * the two concurrent sub-block IO's to the same fsb can race
+		 * and zero different portions of the sub-block resulting in
+		 * zeros where there should be data. Telling the fs we're doing
+		 * unaligned mappings allows it to serialise such IOs and avoid
+		 * the race condition.
+		 */
+		create = GET_BLOCKS_READ;
+		if (dio->rw & WRITE) {
+			create = GET_BLOCKS_CREATE;
+			if ((dio->block_in_file & blkmask) ||
+			    (dio->final_block_in_request & blkmask))
+				create |= GET_BLOCKS_UNALIGNED;
+		}
+
+		/*
 		 * For writes inside i_size on a DIO_SKIP_HOLES filesystem we
 		 * forbid block creations: only overwrites are permitted.
 		 * We will return early to the caller once we see an
@@ -555,11 +575,10 @@ static int get_more_blocks(struct dio *dio)
 		 * which may decide to handle it or also return an unmapped
 		 * buffer head.
 		 */
-		create = dio->rw & WRITE;
 		if (dio->flags & DIO_SKIP_HOLES) {
 			if (dio->block_in_file < (i_size_read(dio->inode) >>
 							dio->blkbits))
-				create = 0;
+				create = GET_BLOCKS_READ;
 		}
 
 		ret = (*dio->get_block)(dio->inode, fs_startblk,
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 2d140a7..3b6c095 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -295,7 +295,7 @@ int __generic_block_fiemap(struct inode *inode,
 		memset(&map_bh, 0, sizeof(struct buffer_head));
 		map_bh.b_size = len;
 
-		ret = get_block(inode, start_blk, &map_bh, 0);
+		ret = get_block(inode, start_blk, &map_bh, GET_BLOCKS_READ);
 		if (ret)
 			break;
 
diff --git a/fs/mpage.c b/fs/mpage.c
index fd56ca2..66d2acd 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -230,7 +230,8 @@ do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
 
 		if (block_in_file < last_block) {
 			map_bh->b_size = (last_block-block_in_file) << blkbits;
-			if (get_block(inode, block_in_file, map_bh, 0))
+			if (get_block(inode, block_in_file, map_bh,
+							GET_BLOCKS_READ))
 				goto confused;
 			*first_logical_block = block_in_file;
 		}
@@ -533,7 +534,8 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 
 		map_bh.b_state = 0;
 		map_bh.b_size = 1 << blkbits;
-		if (mpd->get_block(inode, block_in_file, &map_bh, 1))
+		if (mpd->get_block(inode, block_in_file, &map_bh,
+							GET_BLOCKS_CREATE))
 			goto confused;
 		if (buffer_new(&map_bh))
 			unmap_underlying_metadata(map_bh.b_bdev,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 68ca1b0..a140472 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -412,8 +412,16 @@ extern int dir_notify_enable;
 #endif
 
 struct buffer_head;
+
+/* get_blocks callback definition and flags */
+#define GET_BLOCKS_READ		0x00	/* map, no allocation */
+#define GET_BLOCKS_CREATE	0x01	/* map, allocate if hole */
+#define GET_BLOCKS_UNALIGNED	0x02	/* mapping for unaligned IO,
+					   only use with GET_BLOCKS_CREATE */
+
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
-			struct buffer_head *bh_result, int create);
+			struct buffer_head *bh_result, int flags);
+
 typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 			ssize_t bytes, void *private);
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
