Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:44184 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932479AbdDSBe4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Apr 2017 21:34:56 -0400
Date: Wed, 19 Apr 2017 11:34:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: refactor dir2 leaf readahead shadow buffer
 cleverness
Message-ID: <20170419013450.GF12369@dastard>
References: <20170419001434.GF5193@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170419001434.GF5193@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Brian Foster <bfoster@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Carlos Maiolino <cmaiolin@redhat.com>, billodo@redhat.com

On Tue, Apr 18, 2017 at 05:14:34PM -0700, Darrick J. Wong wrote:
> Currently, the dir2 leaf block getdents function uses a complex state
> tracking mechanism to create a shadow copy of the block mappings and
> then uses the shadow copy to schedule readahead.  Since the read and
> readahead functions are perfectly capable of reading the mappings
> themselves, we can tear all that out in favor of a simpler function that
> simply keeps pushing the readahead window further out.
> 
> Inspired-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

FWIW, here's the patch in progress I had. I hadn't removed any of
the old code, just added a bunch of comments explaining everything
and added the new search loop. It should also handle discontiguous
directory blocks correctly, which using xfs_bmapi_read() directly
won't do...

-Dave.

----

Rework directory readahead to avoid lockdep issues...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_da_btree.c     |   2 +-
 fs/xfs/xfs_da_btree.h     |   3 +
 fs/xfs/xfs_dir2_readdir.c | 155 +++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 137 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 9eec594..35e6aeb 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2460,7 +2460,7 @@ xfs_buf_map_from_irec(
  *	 0 - if we mapped the block successfully
  *	>0 - positive error number if there was an error.
  */
-static int
+int
 xfs_dabuf_map(
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index c824a0a..dddc355 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -188,6 +188,9 @@ int	xfs_da_read_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 xfs_daddr_t	xfs_da_reada_buf(struct xfs_inode *dp, xfs_dablk_t bno,
 				xfs_daddr_t mapped_bno, int whichfork,
 				const struct xfs_buf_ops *ops);
+int	xfs_dabuf_map(struct xfs_inode *dp, xfs_dablk_t bno,
+		      xfs_daddr_t mappedbno, int whichfork,
+		      struct xfs_buf_map **map, int *nmaps);
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 					  struct xfs_buf *dead_buf);
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 50b72f7..726701f 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -270,6 +270,58 @@ xfs_dir2_block_getdents(
 	return 0;
 }
 
+/*
+ * Directory leaf/node format readahead
+ *
+ * Readahead is done on a directory block basis. We can't
+ * hold the ilock across the entire readdir call because filldir can trigger
+ * page faults on user buffers, and that causes potential problems with page
+ * fault processing. There are no known problems, though lockdep gets
+ * *extremely* unhappy with us taking page faults with the ilock held.
+ *
+ * THis is because the regular file IO path lock order is:
+ *
+ *	iolock -> page fault -> mmap_sem -> ilock
+ *
+ * and we are effectively under the same lock order constraints with readdir.
+ * The directory dirent data is the "file data" and hence lockdep has trouble
+ * telling the difference between regular file and directory inode contexts,
+ * especially with respect to memroy reclaim contexts.
+ *
+ * To avoid this entire class of problem, and to avoid needing to use the iolock
+ * on directories to protect readdir operations from directory modifications, we
+ * can make use of the fact that while we hold the directory buffer lock, the
+ * directory block we are reading cannot be modified. Hence we can serialise
+ * readdir within a data block by grabbing the ilock to stabilise the mapping
+ * and lock out modifications, then read the directory block. Once we have read
+ * the directory block and hold it's lock, we can drop the ilock knowing that
+ * any modification to that block will be held off until we drop the buffer
+ * lock.
+ *
+ * We can do this block-by-block lock-map-read on individual blocks because
+ * readdir already has to handle continuation between disjoint syscalls, and so
+ * if we miss an entry due to racing with a modification between block reads,
+ * the result is no different to userspace doing two smaller reads and racing
+ * with the same modification.
+ *
+ * Further, the directory DATA segment contains only dirent data, and none of
+ * the directory indexes. Hence we don't have to care about racing with index
+ * tree updates as index updates only occur once the data buffer has already
+ * been locked into a transaction.
+ *
+ * Hence readahead does not store any state from block read to block read. There
+ * are no cached mappings between readahead calls - we simply map ahead a
+ * certain number of directory blocks and issue readahead on them immediately.
+ * We don't bother trying to keep a sliding window or be smart - we simply pass
+ * back the last offset we issued readahead on and on the next readbuf call we
+ * simply extend out the readahead from that last offset.
+ *
+ * If buffers are modified between the readahead call and when we actually read
+ * them, we don't care due to the fact we map the buffer and read it in a
+ * serialisable manner. if the block is removed from the directory, then it will
+ * be a hole mapping and so we skip over it rather than try to read a stale
+ * buffer.
+ */
 struct xfs_dir2_leaf_map_info {
 	xfs_extlen_t	map_blocks;	/* number of fsbs in map */
 	xfs_dablk_t	map_off;	/* last mapped file offset */
@@ -484,6 +536,59 @@ out:
 }
 
 /*
+ * readahead a number of entire directory blocks.
+ *
+ * To support discontiguous directory blocks, we leave the mapping of the
+ * individual blocks to the readahead code. If it lands in a hole, it will
+ * return the block at the end of the hole for the next pass.
+ */
+STATIC void
+xfs_dir2_leaf_getdents_readahead(
+	struct xfs_inode	*dp,
+	xfs_dablk_t		curoff,
+	int			dirblks)
+{
+	struct xfs_buf_map	map;
+	struct xfs_buf_map	*mapp = &map;
+	int			nmaps = 1;
+	int			error;
+
+
+	while (dirblks > 0) {
+		mapp = &map;
+		nmaps = 1;
+		error = xfs_dabuf_map(dp, curoff, -2, XFS_DATA_FORK,
+				      &mapp, &nmaps);
+		if (error == -1) {
+			/* map points to a hole, skip it */
+			while (--nmaps >= 0)
+				curoff += XFS_BB_TO_FSB(dp->i_mount,
+							mapp[nmaps].bm_len);
+
+			if (mapp != &map)
+				kmem_free(mapp);
+			continue;
+		}
+		if (error)
+			break;
+
+		dirblks--;
+		error = xfs_dir3_data_readahead(dp, curoff, -1);
+		if (error < 0)
+			break;
+
+		/* wind the current offset forwards */
+		while (--nmaps >= 0)
+			curoff += XFS_BB_TO_FSB(dp->i_mount, mapp[nmaps].bm_len);
+		if (curoff >= XFS_DIR2_LEAF_OFFSET)
+			break;
+	}
+
+	if (mapp != &map)
+		kmem_free(mapp);
+}
+
+/*
  * Getdents (readdir) for leaf and node directories.
  * This reads the data blocks only, so is the same for both forms.
  */
@@ -504,7 +609,8 @@ xfs_dir2_leaf_getdents(
 	xfs_dir2_off_t		curoff;		/* current overall offset */
 	xfs_dir2_off_t		newoff;		/* new curoff after new blk */
 	char			*ptr = NULL;	/* pointer to current data */
-	struct xfs_dir2_leaf_map_info *map_info;
+	xfs_dir2_db_t		curdb;		/* db for current block */
+	xfs_dablk_t		map_off;	/* last mapped file offset */
 
 	/*
 	 * If the offset is at or past the largest allowed value,
@@ -516,18 +622,6 @@ xfs_dir2_leaf_getdents(
 	mp = dp->i_mount;
 
 	/*
-	 * Set up to bmap a number of blocks based on the caller's
-	 * buffer size, the directory block size, and the filesystem
-	 * block size.
-	 */
-	length = howmany(bufsize + mp->m_dirblksize,
-				     mp->m_sb.sb_blocksize);
-	map_info = kmem_zalloc(offsetof(struct xfs_dir2_leaf_map_info, map) +
-				(length * sizeof(struct xfs_bmbt_irec)),
-			       KM_SLEEP | KM_NOFS);
-	map_info->map_size = length;
-
-	/*
 	 * Inside the loop we keep the main offset value as a byte offset
 	 * in the directory file.
 	 */
@@ -537,8 +631,15 @@ xfs_dir2_leaf_getdents(
 	 * Force this conversion through db so we truncate the offset
 	 * down to get the start of the data block.
 	 */
-	map_info->map_off = xfs_dir2_db_to_da(mp,
-					      xfs_dir2_byte_to_db(mp, curoff));
+	map_off = xfs_dir2_db_to_da(mp, xfs_dir2_byte_to_db(mp, curoff));
+
+	/*
+	 * Set up readahead based on the caller's buffer size and the directory
+	 * block size We double the buffer size because we expect to be called
+	 * again soon to read the next buffer's worth of dirents.
+	 */
+	length = 2 * howmany(bufsize + mp->m_dirblksize, mp->m_dirblksize);
+	xfs_dir2_leaf_getdents_readahead(dp, map_off, length);
 
 	/*
 	 * Loop over directory entries until we reach the end offset.
@@ -552,16 +653,25 @@ xfs_dir2_leaf_getdents(
 		 * current buffer, need to get another one.
 		 */
 		if (!bp || ptr >= (char *)bp->b_addr + mp->m_dirblksize) {
+			if (bp)
+				xfs_trans_brelse(NULL, bp);
 
-			error = xfs_dir2_leaf_readbuf(dp, bufsize, map_info,
-						      &curoff, &bp);
-			if (error || !map_info->map_valid)
+			curdb = xfs_dir2_da_to_db(mp, curoff);
+			error = xfs_dir3_data_read(NULL, dp, curoff, -1, &bp);
+			if (error)
 				break;
+			if (!bp) {
+				/* landed in a hole */
+				/* XXX: need to map and skip hole! */
+				curoff += mp->m_dirblksize;
+				continue;
+			}
 
 			/*
 			 * Having done a read, we need to set a new offset.
 			 */
-			newoff = xfs_dir2_db_off_to_byte(mp, map_info->curdb, 0);
+			newoff = xfs_dir2_db_off_to_byte(mp, curdb, 0);
+
 			/*
 			 * Start of the current block.
 			 */
@@ -571,15 +681,17 @@ xfs_dir2_leaf_getdents(
 			 * Make sure we're in the right block.
 			 */
 			else if (curoff > newoff)
-				ASSERT(xfs_dir2_byte_to_db(mp, curoff) ==
-				       map_info->curdb);
+				ASSERT(xfs_dir2_byte_to_db(mp, curoff) == curdb);
+
 			hdr = bp->b_addr;
 			xfs_dir3_data_check(dp, bp);
+
 			/*
 			 * Find our position in the block.
 			 */
 			ptr = (char *)dp->d_ops->data_entry_p(hdr);
 			byteoff = xfs_dir2_byte_to_off(mp, curoff);
+
 			/*
 			 * Skip past the header.
 			 */
@@ -657,7 +769,6 @@ xfs_dir2_leaf_getdents(
 		ctx->pos = XFS_DIR2_MAX_DATAPTR & 0x7fffffff;
 	else
 		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
-	kmem_free(map_info);
 	if (bp)
 		xfs_trans_brelse(NULL, bp);
 	return error;


-- 
Dave Chinner
david@fromorbit.com
