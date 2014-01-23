Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 314857F5D
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 04:24:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 14A668F8070
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 02:24:11 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	1zNWJRKdOsTCQ8Gr for <xfs@oss.sgi.com>;
	Thu, 23 Jan 2014 02:24:08 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W6HS4-0004fG-BV
	for xfs@oss.sgi.com; Thu, 23 Jan 2014 21:24:00 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W6HS4-0004Vf-AH
	for xfs@oss.sgi.com; Thu, 23 Jan 2014 21:24:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/5] metadump: fully support discontiguous directory blocks
Date: Thu, 23 Jan 2014 21:23:55 +1100
Message-Id: <1390472635-17225-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1390472635-17225-1-git-send-email-david@fromorbit.com>
References: <1390472635-17225-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now that directory block obfuscation can handle single contiguous
directory blocks, we can make the multi-block code use discontiguous
buffers to read in an entire directory block at a time. This allows
us to pass a complete directory object to the processing function
and hence be able to process any sort of directory object regardless
of it's underlying layout.

With the, we can remove the multi-block loop from the directory
processing code and get rid of allt eh structures used to hold
inter-call state. This graeatly simplifies the code as well as
adding the additional functionality.

With this patch, a CRC enabled filesystem now passes xfs/291.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/metadump.c | 280 ++++++++++++++++++++++++++++------------------------------
 1 file changed, 133 insertions(+), 147 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index e973c5e..6ed392b 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1111,24 +1111,11 @@ obfuscate_sf_attr(
 	}
 }
 
-/*
- * dir_data structure is used to track multi-fsblock dir2 blocks between extent
- * processing calls.
- */
-
-static struct dir_data_s {
-	int			end_of_data;
-	int			block_index;
-	int			offset_to_entry;
-	int			bad_block;
-} dir_data;
-
 static void
-obfuscate_dir_data_blocks(
-	char			*block,
-	xfs_dfiloff_t		offset,
-	xfs_dfilblks_t		count,
-	int			is_block_format)
+obfuscate_dir_data_block(
+	char		*block,
+	xfs_dfiloff_t	offset,
+	int		is_block_format)
 {
 	/*
 	 * we have to rely on the fileoffset and signature of the block to
@@ -1136,123 +1123,96 @@ obfuscate_dir_data_blocks(
 	 * for multi-fsblock dir blocks, if a name crosses an extent boundary,
 	 * ignore it and continue.
 	 */
-	int			c;
-	int			dir_offset;
-	char			*ptr;
-	char			*endptr;
-
-	if (is_block_format && count != mp->m_dirblkfsbs)
-		return; /* too complex to handle this rare case */
-
-	for (c = 0, endptr = block; c < count; c++) {
-
-		if (dir_data.block_index == 0) {
-			int		wantmagic;
-			struct xfs_dir2_data_hdr *datahdr;
-
-			datahdr = (struct xfs_dir2_data_hdr *)block;
-
-			if (offset % mp->m_dirblkfsbs != 0)
-				return;	/* corrupted, leave it alone */
-
-			dir_data.bad_block = 0;
-
-			if (is_block_format) {
-				xfs_dir2_leaf_entry_t	*blp;
-				xfs_dir2_block_tail_t	*btp;
-
-				btp = xfs_dir2_block_tail_p(mp, datahdr);
-				blp = xfs_dir2_block_leaf_p(btp);
-				if ((char *)blp > (char *)btp)
-					blp = (xfs_dir2_leaf_entry_t *)btp;
-
-				dir_data.end_of_data = (char *)blp - block;
-				wantmagic = XFS_DIR2_BLOCK_MAGIC;
-			} else { /* leaf/node format */
-				dir_data.end_of_data = mp->m_dirblkfsbs <<
-						mp->m_sb.sb_blocklog;
-				wantmagic = XFS_DIR2_DATA_MAGIC;
-			}
-			dir_data.offset_to_entry =
-					xfs_dir3_data_entry_offset(datahdr);
-
-			if (be32_to_cpu(datahdr->magic) != wantmagic) {
-				if (show_warnings)
-					print_warning("invalid magic in dir "
-						"inode %llu block %ld",
-						(long long)cur_ino,
-						(long)offset);
-				dir_data.bad_block = 1;
-			}
-		}
-		dir_data.block_index++;
-		if (dir_data.block_index == mp->m_dirblkfsbs)
-			dir_data.block_index = 0;
+	int		dir_offset;
+	char		*ptr;
+	char		*endptr;
+	int		end_of_data;
+	int		wantmagic;
+	struct xfs_dir2_data_hdr *datahdr;
+
+	datahdr = (struct xfs_dir2_data_hdr *)block;
+
+	if (offset % mp->m_dirblkfsbs != 0)
+		return;	/* corrupted, leave it alone */
+
+	if (is_block_format) {
+		xfs_dir2_leaf_entry_t	*blp;
+		xfs_dir2_block_tail_t	*btp;
+
+		btp = xfs_dir2_block_tail_p(mp, datahdr);
+		blp = xfs_dir2_block_leaf_p(btp);
+		if ((char *)blp > (char *)btp)
+			blp = (xfs_dir2_leaf_entry_t *)btp;
+
+		end_of_data = (char *)blp - block;
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			wantmagic = XFS_DIR3_BLOCK_MAGIC;
+		else
+			wantmagic = XFS_DIR2_BLOCK_MAGIC;
+	} else { /* leaf/node format */
+		end_of_data = mp->m_dirblkfsbs << mp->m_sb.sb_blocklog;
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			wantmagic = XFS_DIR3_DATA_MAGIC;
+		else
+			wantmagic = XFS_DIR2_DATA_MAGIC;
+	}
+
+	if (be32_to_cpu(datahdr->magic) != wantmagic) {
+		if (show_warnings)
+			print_warning(
+		"invalid magic in dir inode %llu block %ld",
+					(long long)cur_ino, (long)offset);
+		return;
+	}
 
-		if (dir_data.bad_block)
-			continue;
+	dir_offset = xfs_dir3_data_entry_offset(datahdr);
+	ptr = block + dir_offset;
+	endptr = block + mp->m_sb.sb_blocksize;
 
-		dir_offset = (dir_data.block_index << mp->m_sb.sb_blocklog) +
-				dir_data.offset_to_entry;
-
-		ptr = endptr + dir_data.offset_to_entry;
-		endptr += mp->m_sb.sb_blocksize;
-
-		while (ptr < endptr && dir_offset < dir_data.end_of_data) {
-			xfs_dir2_data_entry_t	*dep;
-			xfs_dir2_data_unused_t	*dup;
-			int			length;
-
-			dup = (xfs_dir2_data_unused_t *)ptr;
-
-			if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-				int	length = be16_to_cpu(dup->length);
-				if (dir_offset + length > dir_data.end_of_data ||
-						length == 0 || (length &
-						 (XFS_DIR2_DATA_ALIGN - 1))) {
-					if (show_warnings)
-						print_warning("invalid length "
-							"for dir free space in "
-							"inode %llu",
-							(long long)cur_ino);
-					dir_data.bad_block = 1;
-					break;
-				}
-				if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
-						dir_offset) {
-					dir_data.bad_block = 1;
-					break;
-				}
-				dir_offset += length;
-				ptr += length;
-				if (dir_offset >= dir_data.end_of_data ||
-						ptr >= endptr)
-					break;
-			}
+	while (ptr < endptr && dir_offset < end_of_data) {
+		xfs_dir2_data_entry_t	*dep;
+		xfs_dir2_data_unused_t	*dup;
+		int			length;
 
-			dep = (xfs_dir2_data_entry_t *)ptr;
-			length = xfs_dir3_data_entsize(mp, dep->namelen);
+		dup = (xfs_dir2_data_unused_t *)ptr;
 
-			if (dir_offset + length > dir_data.end_of_data ||
-					ptr + length > endptr) {
+		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+			int	length = be16_to_cpu(dup->length);
+			if (dir_offset + length > end_of_data ||
+			    !length || (length & (XFS_DIR2_DATA_ALIGN - 1))) {
 				if (show_warnings)
-					print_warning("invalid length for "
-						"dir entry name in inode %llu",
+					print_warning(
+			"invalid length for dir free space in inode %llu",
 						(long long)cur_ino);
-				break;
-			}
-			if (be16_to_cpu(*xfs_dir3_data_entry_tag_p(mp, dep)) !=
-					dir_offset) {
-				dir_data.bad_block = 1;
-				break;
+				return;
 			}
-			generate_obfuscated_name(be64_to_cpu(dep->inumber),
-					dep->namelen, &dep->name[0]);
+			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
+					dir_offset)
+				return;
 			dir_offset += length;
 			ptr += length;
+			if (dir_offset >= end_of_data || ptr >= endptr)
+				return;
+		}
+
+		dep = (xfs_dir2_data_entry_t *)ptr;
+		length = xfs_dir3_data_entsize(mp, dep->namelen);
+
+		if (dir_offset + length > end_of_data ||
+		    ptr + length > endptr) {
+			if (show_warnings)
+				print_warning(
+			"invalid length for dir entry name in inode %llu",
+					(long long)cur_ino);
+			return;
 		}
-		dir_data.offset_to_entry = dir_offset &
-						(mp->m_sb.sb_blocksize - 1);
+		if (be16_to_cpu(*xfs_dir3_data_entry_tag_p(mp, dep)) !=
+				dir_offset)
+			return;
+		generate_obfuscated_name(be64_to_cpu(dep->inumber),
+					 dep->namelen, &dep->name[0]);
+		dir_offset += length;
+		ptr += length;
 	}
 }
 
@@ -1399,8 +1359,8 @@ process_single_fsb_objects(
 			if (o >= mp->m_dirleafblk)
 				break;
 
-			obfuscate_dir_data_blocks(dp, o, 1,
-						  last == mp->m_dirblkfsbs);
+			obfuscate_dir_data_block(dp, o,
+						 last == mp->m_dirblkfsbs);
 			break;
 		case TYP_SYMLINK:
 			obfuscate_symlink_block(dp);
@@ -1421,6 +1381,12 @@ out_pop:
 	return ret;
 }
 
+/*
+ * Static map to aggregate multiple extents into a single directory block.
+ */
+static struct bbmap mfsb_map;
+static int mfsb_length;
+
 static int
 process_multi_fsb_objects(
 	xfs_dfiloff_t	o,
@@ -1436,33 +1402,54 @@ process_multi_fsb_objects(
 		return -EINVAL;
 	}
 
-	push_cur();
-	set_cur(&typtab[btype], XFS_FSB_TO_DADDR(mp, s), c * blkbb,
-			DB_RING_IGN, NULL);
+	while (c > 0) {
+		unsigned int	bm_len;
 
-	if (!iocur_top->data) {
-		xfs_agnumber_t	agno = XFS_FSB_TO_AGNO(mp, s);
-		xfs_agblock_t	agbno = XFS_FSB_TO_AGBNO(mp, s);
+		if (mfsb_length + c >= mp->m_dirblkfsbs) {
+			bm_len = mp->m_dirblkfsbs - mfsb_length;
+			mfsb_length = 0;
+		} else {
+			mfsb_length += c;
+			bm_len = c;
+		}
 
-		print_warning("cannot read %s block %u/%u (%llu)",
-				typtab[btype].name, agno, agbno, s);
-		if (stop_on_read_error)
-			ret = -EIO;
-		goto out_pop;
+		mfsb_map.b[mfsb_map.nmaps].bm_bn = XFS_FSB_TO_DADDR(mp, s);
+		mfsb_map.b[mfsb_map.nmaps].bm_len = XFS_FSB_TO_BB(mp, bm_len);
+		mfsb_map.nmaps++;
 
-	}
+		if (mfsb_length == 0) {
+			push_cur();
+			set_cur(&typtab[btype], 0, 0, DB_RING_IGN, &mfsb_map);
+			if (!iocur_top->data) {
+				xfs_agnumber_t	agno = XFS_FSB_TO_AGNO(mp, s);
+				xfs_agblock_t	agbno = XFS_FSB_TO_AGBNO(mp, s);
 
-	if (dont_obfuscate || o >= mp->m_dirleafblk) {
-		ret = write_buf(iocur_top);
-		goto out_pop;
-	}
+				print_warning("cannot read %s block %u/%u (%llu)",
+						typtab[btype].name, agno, agbno, s);
+				if (stop_on_read_error)
+					ret = -1;
+				goto out_pop;
 
-	obfuscate_dir_data_blocks(iocur_top->data, o, c,
-				 last == mp->m_dirblkfsbs);
-	ret = write_buf(iocur_top);
+			}
 
+			if (dont_obfuscate || o >= mp->m_dirleafblk) {
+				ret = write_buf(iocur_top);
+				goto out_pop;
+			}
+
+			obfuscate_dir_data_block(iocur_top->data, o,
+						  last == mp->m_dirblkfsbs);
+			ret = write_buf(iocur_top);
 out_pop:
-	pop_cur();
+			pop_cur();
+			mfsb_map.nmaps = 0;
+			if (ret)
+				break;
+		}
+		c -= bm_len;
+		s += bm_len;
+	}
+
 	return ret;
 }
 
@@ -1750,7 +1737,6 @@ process_inode(
 	/* copy appropriate data fork metadata */
 	switch (be16_to_cpu(dip->di_mode) & S_IFMT) {
 		case S_IFDIR:
-			memset(&dir_data, 0, sizeof(dir_data));
 			success = process_inode_data(dip, TYP_DIR2);
 			break;
 		case S_IFLNK:
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
