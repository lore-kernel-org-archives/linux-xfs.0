Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8BDE07F7B
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2014 15:40:13 -0500 (CDT)
Date: Thu, 11 Sep 2014 15:40:10 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 1/9] xfs: return the first match during case-insensitive
	lookup.
Message-ID: <20140911204010.GA13262@sgi.com>
References: <20140911203735.GA19952@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140911203735.GA19952@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: tinguely@sgi.com, olaf@sgi.com

From: Olaf Weber <olaf@sgi.com>

Change the XFS case-insensitive lookup code to return the first match
found, even if it is not an exact match. Whether a filesystem uses
case-insensitive lookups is determined by a superblock bit set during
filesystem creation.  This means that normal use cannot create two files
that both match the same filename.

Signed-off-by: Olaf Weber <olaf@sgi.com>
---
 fs/xfs/libxfs/xfs_dir2_block.c | 17 +++------
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 37 ++++----------------
 fs/xfs/libxfs/xfs_dir2_node.c  | 79 ++++++++++++++++--------------------------
 fs/xfs/libxfs/xfs_dir2_sf.c    |  8 ++---
 4 files changed, 45 insertions(+), 96 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 9628cec..990bf0c 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -725,28 +725,21 @@ xfs_dir2_block_lookup_int(
 		dep = (xfs_dir2_data_entry_t *)
 			((char *)hdr + xfs_dir2_dataptr_to_off(args->geo, addr));
 		/*
-		 * Compare name and if it's an exact match, return the index
-		 * and buffer. If it's the first case-insensitive match, store
-		 * the index and buffer and continue looking for an exact match.
+		 * Compare name and if it's a match, return the
+		 * index and buffer.
 		 */
 		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
-		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
+		if (cmp != XFS_CMP_DIFFERENT) {
 			args->cmpresult = cmp;
 			*bpp = bp;
 			*entno = mid;
-			if (cmp == XFS_CMP_EXACT)
-				return 0;
+			return 0;
 		}
 	} while (++mid < be32_to_cpu(btp->count) &&
 			be32_to_cpu(blp[mid].hashval) == hash);
 
 	ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
-	/*
-	 * Here, we can only be doing a lookup (not a rename or replace).
-	 * If a case-insensitive match was found earlier, return success.
-	 */
-	if (args->cmpresult == XFS_CMP_CASE)
-		return 0;
+	ASSERT(args->cmpresult == XFS_CMP_DIFFERENT);
 	/*
 	 * No match, release the buffer and return ENOENT.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index a19174e..3d572ee 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1226,7 +1226,6 @@ xfs_dir2_leaf_lookup_int(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_dir2_db_t		newdb;		/* new data block number */
 	xfs_trans_t		*tp;		/* transaction pointer */
-	xfs_dir2_db_t		cidb = -1;	/* case match data block no. */
 	enum xfs_dacmp		cmp;		/* name compare result */
 	struct xfs_dir2_leaf_entry *ents;
 	struct xfs_dir3_icleaf_hdr leafhdr;
@@ -1290,46 +1289,22 @@ xfs_dir2_leaf_lookup_int(
 						be32_to_cpu(lep->address)));
 		/*
 		 * Compare name and if it's an exact match, return the index
-		 * and buffer. If it's the first case-insensitive match, store
-		 * the index and buffer and continue looking for an exact match.
+		 * and buffer
 		 */
 		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
-		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
+		if (cmp != XFS_CMP_DIFFERENT) {
 			args->cmpresult = cmp;
 			*indexp = index;
-			/* case exact match: return the current buffer. */
-			if (cmp == XFS_CMP_EXACT) {
-				*dbpp = dbp;
-				return 0;
-			}
-			cidb = curdb;
+			*dbpp = dbp;
+			return 0;
 		}
 	}
 	ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
-	/*
-	 * Here, we can only be doing a lookup (not a rename or remove).
-	 * If a case-insensitive match was found earlier, re-read the
-	 * appropriate data block if required and return it.
-	 */
-	if (args->cmpresult == XFS_CMP_CASE) {
-		ASSERT(cidb != -1);
-		if (cidb != curdb) {
-			xfs_trans_brelse(tp, dbp);
-			error = xfs_dir3_data_read(tp, dp,
-					   xfs_dir2_db_to_da(args->geo, cidb),
-					   -1, &dbp);
-			if (error) {
-				xfs_trans_brelse(tp, lbp);
-				return error;
-			}
-		}
-		*dbpp = dbp;
-		return 0;
-	}
+	ASSERT(args->cmpresult == XFS_CMP_DIFFERENT);
+
 	/*
 	 * No match found, return -ENOENT.
 	 */
-	ASSERT(cidb == -1);
 	if (dbp)
 		xfs_trans_brelse(tp, dbp);
 	xfs_trans_brelse(tp, lbp);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 2ae6ac2..1778c40 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -679,6 +679,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	xfs_dir2_data_entry_t	*dep;		/* data block entry */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return value */
+	int			di = -1;	/* data entry index */
 	int			index;		/* leaf entry index */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
@@ -709,6 +710,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	if (state->extravalid) {
 		curbp = state->extrablk.bp;
 		curdb = state->extrablk.blkno;
+		di = state->extrablk.index;
 	}
 	/*
 	 * Loop over leaf entries with the right hash value.
@@ -734,28 +736,20 @@ xfs_dir2_leafn_lookup_for_entry(
 		 */
 		if (newdb != curdb) {
 			/*
-			 * If we had a block before that we aren't saving
-			 * for a CI name, drop it
+			 * If we had a block, drop it
 			 */
-			if (curbp && (args->cmpresult == XFS_CMP_DIFFERENT ||
-						curdb != state->extrablk.blkno))
+			if (curbp) {
 				xfs_trans_brelse(tp, curbp);
+				di = -1;
+			}
 			/*
-			 * If needing the block that is saved with a CI match,
-			 * use it otherwise read in the new data block.
+			 * Read in the new data block.
 			 */
-			if (args->cmpresult != XFS_CMP_DIFFERENT &&
-					newdb == state->extrablk.blkno) {
-				ASSERT(state->extravalid);
-				curbp = state->extrablk.bp;
-			} else {
-				error = xfs_dir3_data_read(tp, dp,
-						xfs_dir2_db_to_da(args->geo,
-								  newdb),
+			error = xfs_dir3_data_read(tp, dp,
+					xfs_dir2_db_to_da(args->geo, newdb),
 						-1, &curbp);
-				if (error)
-					return error;
-			}
+			if (error)
+				return error;
 			xfs_dir3_data_check(dp, curbp);
 			curdb = newdb;
 		}
@@ -766,53 +760,40 @@ xfs_dir2_leafn_lookup_for_entry(
 			xfs_dir2_dataptr_to_off(args->geo,
 						be32_to_cpu(lep->address)));
 		/*
-		 * Compare the entry and if it's an exact match, return
-		 * EEXIST immediately. If it's the first case-insensitive
-		 * match, store the block & inode number and continue looking.
+		 * Compare the entry and if it's a match, return
+		 * EEXIST immediately.
 		 */
 		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
-		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
-			/* If there is a CI match block, drop it */
-			if (args->cmpresult != XFS_CMP_DIFFERENT &&
-						curdb != state->extrablk.blkno)
-				xfs_trans_brelse(tp, state->extrablk.bp);
+		if (cmp != XFS_CMP_DIFFERENT) {
 			args->cmpresult = cmp;
 			args->inumber = be64_to_cpu(dep->inumber);
 			args->filetype = dp->d_ops->data_get_ftype(dep);
-			*indexp = index;
-			state->extravalid = 1;
-			state->extrablk.bp = curbp;
-			state->extrablk.blkno = curdb;
-			state->extrablk.index = (int)((char *)dep -
-							(char *)curbp->b_addr);
-			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
 			curbp->b_ops = &xfs_dir3_data_buf_ops;
 			xfs_trans_buf_set_type(tp, curbp, XFS_BLFT_DIR_DATA_BUF);
-			if (cmp == XFS_CMP_EXACT)
-				return -EEXIST;
+			di = (int)((char *)dep - (char *)curbp->b_addr);
+			error = -EEXIST;
+			goto out;
+
 		}
 	}
+	/* Didn't find a match */
+	error = -ENOENT;
 	ASSERT(index == leafhdr.count || (args->op_flags & XFS_DA_OP_OKNOENT));
+out:
 	if (curbp) {
-		if (args->cmpresult == XFS_CMP_DIFFERENT) {
-			/* Giving back last used data block. */
-			state->extravalid = 1;
-			state->extrablk.bp = curbp;
-			state->extrablk.index = -1;
-			state->extrablk.blkno = curdb;
-			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
-			curbp->b_ops = &xfs_dir3_data_buf_ops;
-			xfs_trans_buf_set_type(tp, curbp, XFS_BLFT_DIR_DATA_BUF);
-		} else {
-			/* If the curbp is not the CI match block, drop it */
-			if (state->extrablk.bp != curbp)
-				xfs_trans_brelse(tp, curbp);
-		}
+		/* Giving back last used data block. */
+		state->extravalid = 1;
+		state->extrablk.bp = curbp;
+		state->extrablk.index = di;
+		state->extrablk.blkno = curdb;
+		state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
+		curbp->b_ops = &xfs_dir3_data_buf_ops;
+		xfs_trans_buf_set_type(tp, curbp, XFS_BLFT_DIR_DATA_BUF);
 	} else {
 		state->extravalid = 0;
 	}
 	*indexp = index;
-	return -ENOENT;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 5079e05..e69fdb7 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -757,19 +757,19 @@ xfs_dir2_sf_lookup(
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->count;
 	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep)) {
 		/*
-		 * Compare name and if it's an exact match, return the inode
-		 * number. If it's the first case-insensitive match, store the
-		 * inode number and continue looking for an exact match.
+		 * Compare name and if it's a match, return the inode
+		 * number.
 		 */
 		cmp = dp->i_mount->m_dirnameops->compname(args, sfep->name,
 								sfep->namelen);
-		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
+		if (cmp != XFS_CMP_DIFFERENT) {
 			args->cmpresult = cmp;
 			args->inumber = dp->d_ops->sf_get_ino(sfp, sfep);
 			args->filetype = dp->d_ops->sf_get_ftype(sfep);
 			if (cmp == XFS_CMP_EXACT)
 				return -EEXIST;
 			ci_sfep = sfep;
+			break;
 		}
 	}
 	ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
