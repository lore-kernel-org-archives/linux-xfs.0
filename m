Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q585dBoN173241 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 00:39:11 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PFX38EBAHE59I3E8 for <xfs@oss.sgi.com>;
	Thu, 07 Jun 2012 22:39:08 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1ScruL-0004hP-15
	for xfs@oss.sgi.com; Fri, 08 Jun 2012 15:38:49 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1ScruK-0002vs-U1
	for xfs@oss.sgi.com; Fri, 08 Jun 2012 15:38:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 9/9] xfs: factor buffer reading from xfs_dir2_leaf_getdents
Date: Fri,  8 Jun 2012 15:38:34 +1000
Message-Id: <1339133914-11148-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1339133914-11148-1-git-send-email-david@fromorbit.com>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
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

The buffer reading code in xfs_dir2_leaf_getdents is complex and difficult to
follow due to the readahead and all the context is carries. it is also badly
indented and so difficult to read. Factor it out into a separate function to
make it easier to understand and optimise in future patches.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_leaf.c |  436 ++++++++++++++++++++++++++----------------------
 1 file changed, 234 insertions(+), 202 deletions(-)

diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 69accf6..dbe8845 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -759,6 +759,222 @@ xfs_dir2_leaf_compact_x1(
 	*highstalep = highstale;
 }
 
+struct _map_info {
+	xfs_bmbt_irec_t	*map;		/* map vector for blocks */
+	xfs_extlen_t	map_blocks;	/* number of fsbs in map */
+	xfs_dablk_t	map_off;	/* last mapped file offset */
+	int		map_size;	/* total entries in *map */
+	int		map_valid;	/* valid entries in *map */
+	int		nmap;		/* mappings to ask xfs_bmapi */
+	xfs_dir2_db_t	curdb;		/* db for current block */
+};
+
+struct _ra_info {
+	int		ra_current;	/* number of read-ahead blks */
+	int		ra_index;	/* *map index for read-ahead */
+	int		ra_offset;	/* map entry offset for ra */
+	int		ra_want;	/* readahead count wanted */
+};
+
+STATIC int
+xfs_dir2_leaf_readbuf(
+	struct xfs_inode	*dp,
+	size_t			bufsize,
+	struct _map_info	*mip,
+	struct _ra_info		*rap,
+	xfs_dir2_off_t		*curoff,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_buf		*bp = *bpp;
+	struct xfs_bmbt_irec	*map = mip->map;
+	int			error = 0;
+	int			length;
+	int			i;
+	int			j;
+
+	/*
+	 * If we have a buffer, we need to release it and
+	 * take it out of the mapping.
+	 */
+
+	if (bp) {
+		xfs_trans_brelse(NULL, bp);
+		bp = NULL;
+		mip->map_blocks -= mp->m_dirblkfsbs;
+		/*
+		 * Loop to get rid of the extents for the
+		 * directory block.
+		 */
+		for (i = mp->m_dirblkfsbs; i > 0; ) {
+			j = min_t(int, map->br_blockcount, i);
+			map->br_blockcount -= j;
+			map->br_startblock += j;
+			map->br_startoff += j;
+			/*
+			 * If mapping is done, pitch it from
+			 * the table.
+			 */
+			if (!map->br_blockcount && --mip->map_valid)
+				memmove(&map[0], &map[1],
+					sizeof(map[0]) * mip->map_valid);
+			i -= j;
+		}
+	}
+
+	/*
+	 * Recalculate the readahead blocks wanted.
+	 */
+	rap->ra_want = howmany(bufsize + mp->m_dirblksize,
+			       mp->m_sb.sb_blocksize) - 1;
+	ASSERT(rap->ra_want >= 0);
+
+	/*
+	 * If we don't have as many as we want, and we haven't
+	 * run out of data blocks, get some more mappings.
+	 */
+	if (1 + rap->ra_want > mip->map_blocks &&
+	    mip->map_off < xfs_dir2_byte_to_da(mp, XFS_DIR2_LEAF_OFFSET)) {
+		/*
+		 * Get more bmaps, fill in after the ones
+		 * we already have in the table.
+		 */
+		mip->nmap = mip->map_size - mip->map_valid;
+		error = xfs_bmapi_read(dp, mip->map_off,
+				xfs_dir2_byte_to_da(mp, XFS_DIR2_LEAF_OFFSET) -
+								mip->map_off,
+				&map[mip->map_valid], &mip->nmap, 0);
+
+		/*
+		 * Don't know if we should ignore this or try to return an
+		 * error.  The trouble with returning errors is that readdir
+		 * will just stop without actually passing the error through.
+		 */
+		if (error)
+			goto out;	/* XXX */
+
+		/*
+		 * If we got all the mappings we asked for, set the final map
+		 * offset based on the last bmap value received.  Otherwise,
+		 * we've reached the end.
+		 */
+		if (mip->nmap == mip->map_size - mip->map_valid) {
+			i = mip->map_valid + mip->nmap - 1;
+			mip->map_off = map[i].br_startoff + map[i].br_blockcount;
+		} else
+			mip->map_off = xfs_dir2_byte_to_da(mp,
+							XFS_DIR2_LEAF_OFFSET);
+
+		/*
+		 * Look for holes in the mapping, and eliminate them.  Count up
+		 * the valid blocks.
+		 */
+		for (i = mip->map_valid; i < mip->map_valid + mip->nmap; ) {
+			if (map[i].br_startblock == HOLESTARTBLOCK) {
+				mip->nmap--;
+				length = mip->map_valid + mip->nmap - i;
+				if (length)
+					memmove(&map[i], &map[i + 1],
+						sizeof(map[i]) * length);
+			} else {
+				mip->map_blocks += map[i].br_blockcount;
+				i++;
+			}
+		}
+		mip->map_valid += mip->nmap;
+	}
+
+	/*
+	 * No valid mappings, so no more data blocks.
+	 */
+	if (!mip->map_valid) {
+		*curoff = xfs_dir2_da_to_byte(mp, mip->map_off);
+		goto out;
+	}
+
+	/*
+	 * Read the directory block starting at the first mapping.
+	 */
+	mip->curdb = xfs_dir2_da_to_db(mp, map->br_startoff);
+	error = xfs_da_read_buf(NULL, dp, map->br_startoff,
+			map->br_blockcount >= mp->m_dirblkfsbs ?
+			    XFS_FSB_TO_DADDR(mp, map->br_startblock) : -1,
+			&bp, XFS_DATA_FORK);
+
+	/*
+	 * Should just skip over the data block instead of giving up.
+	 */
+	if (error)
+		goto out;	/* XXX */
+
+	/*
+	 * Adjust the current amount of read-ahead: we just read a block that
+	 * was previously ra.
+	 */
+	if (rap->ra_current)
+		rap->ra_current -= mp->m_dirblkfsbs;
+
+	/*
+	 * Do we need more readahead?
+	 */
+	for (rap->ra_index = rap->ra_offset = i = 0;
+	     rap->ra_want > rap->ra_current && i < mip->map_blocks;
+	     i += mp->m_dirblkfsbs) {
+		ASSERT(rap->ra_index < mip->map_valid);
+		/*
+		 * Read-ahead a contiguous directory block.
+		 */
+		if (i > rap->ra_current &&
+		    map[rap->ra_index].br_blockcount >= mp->m_dirblkfsbs) {
+			xfs_buf_readahead(mp->m_ddev_targp,
+				XFS_FSB_TO_DADDR(mp,
+					map[rap->ra_index].br_startblock +
+							rap->ra_offset),
+				(int)BTOBB(mp->m_dirblksize));
+			rap->ra_current = i;
+		}
+
+		/*
+		 * Read-ahead a non-contiguous directory block.  This doesn't
+		 * use our mapping, but this is a very rare case.
+		 */
+		else if (i > rap->ra_current) {
+			xfs_da_reada_buf(NULL, dp,
+					map[rap->ra_index].br_startoff +
+							rap->ra_offset,
+					XFS_DATA_FORK);
+			rap->ra_current = i;
+		}
+
+		/*
+		 * Advance offset through the mapping table.
+		 */
+		for (j = 0; j < mp->m_dirblkfsbs; j++) {
+			/*
+			 * The rest of this extent but not more than a dir
+			 * block.
+			 */
+			length = min_t(int, mp->m_dirblkfsbs,
+					map[rap->ra_index].br_blockcount -
+							rap->ra_offset);
+			j += length;
+			rap->ra_offset += length;
+
+			/*
+			 * Advance to the next mapping if this one is used up.
+			 */
+			if (rap->ra_offset == map[rap->ra_index].br_blockcount) {
+				rap->ra_offset = 0;
+				rap->ra_index++;
+			}
+		}
+	}
+
+out:
+	*bpp = bp;
+	return error;
+}
+
 /*
  * Getdents (readdir) for leaf and node directories.
  * This reads the data blocks only, so is the same for both forms.
@@ -771,30 +987,19 @@ xfs_dir2_leaf_getdents(
 	xfs_off_t		*offset,
 	filldir_t		filldir)
 {
-	struct xfs_buf		*bp;		/* data block buffer */
-	int			byteoff;	/* offset in current block */
-	xfs_dir2_db_t		curdb;		/* db for current block */
-	xfs_dir2_off_t		curoff;		/* current overall offset */
+	struct xfs_buf		*bp = NULL;	/* data block buffer */
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_data_entry_t	*dep;		/* data entry */
 	xfs_dir2_data_unused_t	*dup;		/* unused entry */
 	int			error = 0;	/* error return value */
-	int			i;		/* temporary loop index */
-	int			j;		/* temporary loop index */
 	int			length;		/* temporary length value */
-	xfs_bmbt_irec_t		*map;		/* map vector for blocks */
-	xfs_extlen_t		map_blocks;	/* number of fsbs in map */
-	xfs_dablk_t		map_off;	/* last mapped file offset */
-	int			map_size;	/* total entries in *map */
-	int			map_valid;	/* valid entries in *map */
 	xfs_mount_t		*mp;		/* filesystem mount point */
+	int			byteoff;	/* offset in current block */
+	xfs_dir2_off_t		curoff;		/* current overall offset */
 	xfs_dir2_off_t		newoff;		/* new curoff after new blk */
-	int			nmap;		/* mappings to ask xfs_bmapi */
 	char			*ptr = NULL;	/* pointer to current data */
-	int			ra_current;	/* number of read-ahead blks */
-	int			ra_index;	/* *map index for read-ahead */
-	int			ra_offset;	/* map entry offset for ra */
-	int			ra_want;	/* readahead count wanted */
+	struct _map_info	map_info = {};
+	struct _ra_info		ra_info = {};
 
 	/*
 	 * If the offset is at or past the largest allowed value,
@@ -810,10 +1015,10 @@ xfs_dir2_leaf_getdents(
 	 * buffer size, the directory block size, and the filesystem
 	 * block size.
 	 */
-	map_size = howmany(bufsize + mp->m_dirblksize, mp->m_sb.sb_blocksize);
-	map = kmem_alloc(map_size * sizeof(*map), KM_SLEEP);
-	map_valid = ra_index = ra_offset = ra_current = map_blocks = 0;
-	bp = NULL;
+	map_info.map_size = howmany(bufsize + mp->m_dirblksize,
+				     mp->m_sb.sb_blocksize);
+	map_info.map = kmem_zalloc(map_info.map_size *
+					sizeof(struct xfs_bmbt_irec), KM_SLEEP);
 
 	/*
 	 * Inside the loop we keep the main offset value as a byte offset
@@ -825,7 +1030,8 @@ xfs_dir2_leaf_getdents(
 	 * Force this conversion through db so we truncate the offset
 	 * down to get the start of the data block.
 	 */
-	map_off = xfs_dir2_db_to_da(mp, xfs_dir2_byte_to_db(mp, curoff));
+	map_info.map_off = xfs_dir2_db_to_da(mp, xfs_dir2_byte_to_db(mp, curoff));
+
 	/*
 	 * Loop over directory entries until we reach the end offset.
 	 * Get more blocks and readahead as necessary.
@@ -836,190 +1042,16 @@ xfs_dir2_leaf_getdents(
 		 * current buffer, need to get another one.
 		 */
 		if (!bp || ptr >= (char *)bp->b_addr + mp->m_dirblksize) {
-			/*
-			 * If we have a buffer, we need to release it and
-			 * take it out of the mapping.
-			 */
-			if (bp) {
-				xfs_trans_brelse(NULL, bp);
-				bp = NULL;
-				map_blocks -= mp->m_dirblkfsbs;
-				/*
-				 * Loop to get rid of the extents for the
-				 * directory block.
-				 */
-				for (i = mp->m_dirblkfsbs; i > 0; ) {
-					j = MIN((int)map->br_blockcount, i);
-					map->br_blockcount -= j;
-					map->br_startblock += j;
-					map->br_startoff += j;
-					/*
-					 * If mapping is done, pitch it from
-					 * the table.
-					 */
-					if (!map->br_blockcount && --map_valid)
-						memmove(&map[0], &map[1],
-							sizeof(map[0]) *
-							map_valid);
-					i -= j;
-				}
-			}
-			/*
-			 * Recalculate the readahead blocks wanted.
-			 */
-			ra_want = howmany(bufsize + mp->m_dirblksize,
-					  mp->m_sb.sb_blocksize) - 1;
-			ASSERT(ra_want >= 0);
 
-			/*
-			 * If we don't have as many as we want, and we haven't
-			 * run out of data blocks, get some more mappings.
-			 */
-			if (1 + ra_want > map_blocks &&
-			    map_off <
-			    xfs_dir2_byte_to_da(mp, XFS_DIR2_LEAF_OFFSET)) {
-				/*
-				 * Get more bmaps, fill in after the ones
-				 * we already have in the table.
-				 */
-				nmap = map_size - map_valid;
-				error = xfs_bmapi_read(dp, map_off,
-					xfs_dir2_byte_to_da(mp,
-						XFS_DIR2_LEAF_OFFSET) - map_off,
-					&map[map_valid], &nmap, 0);
-				/*
-				 * Don't know if we should ignore this or
-				 * try to return an error.
-				 * The trouble with returning errors
-				 * is that readdir will just stop without
-				 * actually passing the error through.
-				 */
-				if (error)
-					break;	/* XXX */
-				/*
-				 * If we got all the mappings we asked for,
-				 * set the final map offset based on the
-				 * last bmap value received.
-				 * Otherwise, we've reached the end.
-				 */
-				if (nmap == map_size - map_valid)
-					map_off =
-					map[map_valid + nmap - 1].br_startoff +
-					map[map_valid + nmap - 1].br_blockcount;
-				else
-					map_off =
-						xfs_dir2_byte_to_da(mp,
-							XFS_DIR2_LEAF_OFFSET);
-				/*
-				 * Look for holes in the mapping, and
-				 * eliminate them.  Count up the valid blocks.
-				 */
-				for (i = map_valid; i < map_valid + nmap; ) {
-					if (map[i].br_startblock ==
-					    HOLESTARTBLOCK) {
-						nmap--;
-						length = map_valid + nmap - i;
-						if (length)
-							memmove(&map[i],
-								&map[i + 1],
-								sizeof(map[i]) *
-								length);
-					} else {
-						map_blocks +=
-							map[i].br_blockcount;
-						i++;
-					}
-				}
-				map_valid += nmap;
-			}
-			/*
-			 * No valid mappings, so no more data blocks.
-			 */
-			if (!map_valid) {
-				curoff = xfs_dir2_da_to_byte(mp, map_off);
+			error = xfs_dir2_leaf_readbuf(dp, bufsize, &map_info,
+						&ra_info, &curoff, &bp);
+			if (error || !map_info.map_valid)
 				break;
-			}
-			/*
-			 * Read the directory block starting at the first
-			 * mapping.
-			 */
-			curdb = xfs_dir2_da_to_db(mp, map->br_startoff);
-			error = xfs_da_read_buf(NULL, dp, map->br_startoff,
-				map->br_blockcount >= mp->m_dirblkfsbs ?
-				    XFS_FSB_TO_DADDR(mp, map->br_startblock) :
-				    -1,
-				&bp, XFS_DATA_FORK);
-			/*
-			 * Should just skip over the data block instead
-			 * of giving up.
-			 */
-			if (error)
-				break;	/* XXX */
-			/*
-			 * Adjust the current amount of read-ahead: we just
-			 * read a block that was previously ra.
-			 */
-			if (ra_current)
-				ra_current -= mp->m_dirblkfsbs;
-			/*
-			 * Do we need more readahead?
-			 */
-			for (ra_index = ra_offset = i = 0;
-			     ra_want > ra_current && i < map_blocks;
-			     i += mp->m_dirblkfsbs) {
-				ASSERT(ra_index < map_valid);
-				/*
-				 * Read-ahead a contiguous directory block.
-				 */
-				if (i > ra_current &&
-				    map[ra_index].br_blockcount >=
-				    mp->m_dirblkfsbs) {
-					xfs_buf_readahead(mp->m_ddev_targp,
-						XFS_FSB_TO_DADDR(mp,
-						   map[ra_index].br_startblock +
-						   ra_offset),
-						(int)BTOBB(mp->m_dirblksize));
-					ra_current = i;
-				}
-				/*
-				 * Read-ahead a non-contiguous directory block.
-				 * This doesn't use our mapping, but this
-				 * is a very rare case.
-				 */
-				else if (i > ra_current) {
-					(void)xfs_da_reada_buf(NULL, dp,
-						map[ra_index].br_startoff +
-						ra_offset, XFS_DATA_FORK);
-					ra_current = i;
-				}
-				/*
-				 * Advance offset through the mapping table.
-				 */
-				for (j = 0; j < mp->m_dirblkfsbs; j++) {
-					/*
-					 * The rest of this extent but not
-					 * more than a dir block.
-					 */
-					length = MIN(mp->m_dirblkfsbs,
-						(int)(map[ra_index].br_blockcount -
-						ra_offset));
-					j += length;
-					ra_offset += length;
-					/*
-					 * Advance to the next mapping if
-					 * this one is used up.
-					 */
-					if (ra_offset ==
-					    map[ra_index].br_blockcount) {
-						ra_offset = 0;
-						ra_index++;
-					}
-				}
-			}
+
 			/*
 			 * Having done a read, we need to set a new offset.
 			 */
-			newoff = xfs_dir2_db_off_to_byte(mp, curdb, 0);
+			newoff = xfs_dir2_db_off_to_byte(mp, map_info.curdb, 0);
 			/*
 			 * Start of the current block.
 			 */
@@ -1030,7 +1062,7 @@ xfs_dir2_leaf_getdents(
 			 */
 			else if (curoff > newoff)
 				ASSERT(xfs_dir2_byte_to_db(mp, curoff) ==
-				       curdb);
+				       map_info.curdb);
 			hdr = bp->b_addr;
 			xfs_dir2_data_check(dp, bp);
 			/*
@@ -1113,7 +1145,7 @@ xfs_dir2_leaf_getdents(
 		*offset = XFS_DIR2_MAX_DATAPTR & 0x7fffffff;
 	else
 		*offset = xfs_dir2_byte_to_dataptr(mp, curoff) & 0x7fffffff;
-	kmem_free(map);
+	kmem_free(map_info.map);
 	if (bp)
 		xfs_trans_brelse(NULL, bp);
 	return error;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
