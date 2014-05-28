Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C0FC7F4E
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 01:04:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 62B568F808F
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 23:04:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EETkZNp6Mw46B50r for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 23:04:54 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WpWyk-0005ou-5m
	for xfs@oss.sgi.com; Wed, 28 May 2014 16:04:46 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WpWyk-0003ly-4w
	for xfs@oss.sgi.com; Wed, 28 May 2014 16:04:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/16] xfs: reduce direct usage of mp->m_dir_geo
Date: Wed, 28 May 2014 16:04:39 +1000
Message-Id: <1401257083-13433-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1401257083-13433-1-git-send-email-david@fromorbit.com>
References: <1401257083-13433-1-git-send-email-david@fromorbit.com>
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

There are many places in the directory code were we don't pass the
args into and so have to extract the geometry direct from the mount
structure. Push the args or the geometry into these leaf functions
so that we don't need to grab it from the struct xfs_mount.

This, in turn, brings use to the point where directory geometry is
no longer a property of the struct xfs_mount; it is not a global
property anymore, and hence we can start to consider per-directory
configuration of physical geometries.

Start by converting the xfs_dir_isblock/leaf code - pass in the
xfs_da_args and convert the readdir code to use xfs_da_args like
the rest of the directory code to pass information around.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2.c         | 50 +++++++++++++---------------
 fs/xfs/xfs_dir2.h         |  4 +--
 fs/xfs/xfs_dir2_readdir.c | 85 ++++++++++++++++++++++-------------------------
 3 files changed, 65 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index f62d2e5..79670cd 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -282,7 +282,7 @@ xfs_dir_createname(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isblock(dp, &v);
+	rval = xfs_dir2_isblock(args, &v);
 	if (rval)
 		goto out_free;
 	if (v) {
@@ -290,7 +290,7 @@ xfs_dir_createname(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isleaf(dp, &v);
+	rval = xfs_dir2_isleaf(args, &v);
 	if (rval)
 		goto out_free;
 	if (v)
@@ -375,7 +375,7 @@ xfs_dir_lookup(
 		goto out_check_rval;
 	}
 
-	rval = xfs_dir2_isblock(dp, &v);
+	rval = xfs_dir2_isblock(args, &v);
 	if (rval)
 		goto out_free;
 	if (v) {
@@ -383,7 +383,7 @@ xfs_dir_lookup(
 		goto out_check_rval;
 	}
 
-	rval = xfs_dir2_isleaf(dp, &v);
+	rval = xfs_dir2_isleaf(args, &v);
 	if (rval)
 		goto out_free;
 	if (v)
@@ -448,7 +448,7 @@ xfs_dir_removename(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isblock(dp, &v);
+	rval = xfs_dir2_isblock(args, &v);
 	if (rval)
 		goto out_free;
 	if (v) {
@@ -456,7 +456,7 @@ xfs_dir_removename(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isleaf(dp, &v);
+	rval = xfs_dir2_isleaf(args, &v);
 	if (rval)
 		goto out_free;
 	if (v)
@@ -513,7 +513,7 @@ xfs_dir_replace(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isblock(dp, &v);
+	rval = xfs_dir2_isblock(args, &v);
 	if (rval)
 		goto out_free;
 	if (v) {
@@ -521,7 +521,7 @@ xfs_dir_replace(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isleaf(dp, &v);
+	rval = xfs_dir2_isleaf(args, &v);
 	if (rval)
 		goto out_free;
 	if (v)
@@ -573,7 +573,7 @@ xfs_dir_canenter(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isblock(dp, &v);
+	rval = xfs_dir2_isblock(args, &v);
 	if (rval)
 		goto out_free;
 	if (v) {
@@ -581,7 +581,7 @@ xfs_dir_canenter(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isleaf(dp, &v);
+	rval = xfs_dir2_isleaf(args, &v);
 	if (rval)
 		goto out_free;
 	if (v)
@@ -649,18 +649,16 @@ xfs_dir2_grow_inode(
  */
 int
 xfs_dir2_isblock(
-	xfs_inode_t	*dp,
-	int		*vp)		/* out: 1 is block, 0 is not block */
+	struct xfs_da_args	*args,
+	int			*vp)	/* out: 1 is block, 0 is not block */
 {
-	xfs_fileoff_t	last;		/* last file offset */
-	xfs_mount_t	*mp;
-	int		rval;
+	xfs_fileoff_t		last;	/* last file offset */
+	int			rval;
 
-	mp = dp->i_mount;
-	if ((rval = xfs_bmap_last_offset(dp, &last, XFS_DATA_FORK)))
+	if ((rval = xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK)))
 		return rval;
-	rval = XFS_FSB_TO_B(mp, last) == mp->m_dir_geo->blksize;
-	ASSERT(rval == 0 || dp->i_d.di_size == mp->m_dir_geo->blksize);
+	rval = XFS_FSB_TO_B(args->dp->i_mount, last) == args->geo->blksize;
+	ASSERT(rval == 0 || args->dp->i_d.di_size == args->geo->blksize);
 	*vp = rval;
 	return 0;
 }
@@ -670,17 +668,15 @@ xfs_dir2_isblock(
  */
 int
 xfs_dir2_isleaf(
-	xfs_inode_t	*dp,
-	int		*vp)		/* out: 1 is leaf, 0 is not leaf */
+	struct xfs_da_args	*args,
+	int			*vp)	/* out: 1 is block, 0 is not block */
 {
-	xfs_fileoff_t	last;		/* last file offset */
-	xfs_mount_t	*mp;
-	int		rval;
+	xfs_fileoff_t		last;	/* last file offset */
+	int			rval;
 
-	mp = dp->i_mount;
-	if ((rval = xfs_bmap_last_offset(dp, &last, XFS_DATA_FORK)))
+	if ((rval = xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK)))
 		return rval;
-	*vp = last == mp->m_dir_geo->leafblk + (1 << mp->m_sb.sb_dirblklog);
+	*vp = last == args->geo->leafblk + args->geo->fsbcount;
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index 9b709ae..1292e78 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -146,8 +146,8 @@ extern int xfs_dir2_sf_to_block(struct xfs_da_args *args);
 /*
  * Interface routines used by userspace utilities
  */
-extern int xfs_dir2_isblock(struct xfs_inode *dp, int *r);
-extern int xfs_dir2_isleaf(struct xfs_inode *dp, int *r);
+extern int xfs_dir2_isblock(struct xfs_da_args *args, int *r);
+extern int xfs_dir2_isleaf(struct xfs_da_args *args, int *r);
 extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
 				struct xfs_buf *bp);
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index fa393d5..ca1f43c 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -76,28 +76,25 @@ const unsigned char xfs_mode_to_ftype[S_IFMT >> S_SHIFT] = {
 
 STATIC int
 xfs_dir2_sf_getdents(
-	xfs_inode_t		*dp,		/* incore directory inode */
+	struct xfs_da_args	*args,
 	struct dir_context	*ctx)
 {
 	int			i;		/* shortform entry number */
-	xfs_mount_t		*mp;		/* filesystem mount point */
+	struct xfs_inode	*dp = args->dp;	/* incore directory inode */
 	xfs_dir2_dataptr_t	off;		/* current entry's offset */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 	xfs_dir2_dataptr_t	dot_offset;
 	xfs_dir2_dataptr_t	dotdot_offset;
 	xfs_ino_t		ino;
-	struct xfs_da_geometry	*geo;
-
-	mp = dp->i_mount;
-	geo = mp->m_dir_geo;
+	struct xfs_da_geometry	*geo = args->geo;
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
 	/*
 	 * Give up if the directory is way too short.
 	 */
 	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
 		return XFS_ERROR(EIO);
 	}
 
@@ -163,13 +160,13 @@ xfs_dir2_sf_getdents(
 		filetype = dp->d_ops->sf_get_ftype(sfep);
 		ctx->pos = off & 0x7fffffff;
 		if (!dir_emit(ctx, (char *)sfep->name, sfep->namelen, ino,
-			    xfs_dir3_get_dtype(mp, filetype)))
+			    xfs_dir3_get_dtype(dp->i_mount, filetype)))
 			return 0;
 		sfep = dp->d_ops->sf_nextentry(sfp, sfep);
 	}
 
 	ctx->pos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk + 1, 0) &
-			0x7fffffff;
+								0x7fffffff;
 	return 0;
 }
 
@@ -178,9 +175,10 @@ xfs_dir2_sf_getdents(
  */
 STATIC int
 xfs_dir2_block_getdents(
-	xfs_inode_t		*dp,		/* incore inode */
+	struct xfs_da_args	*args,
 	struct dir_context	*ctx)
 {
+	struct xfs_inode	*dp = args->dp;	/* incore directory inode */
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	struct xfs_buf		*bp;		/* buffer for block */
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
@@ -188,14 +186,11 @@ xfs_dir2_block_getdents(
 	xfs_dir2_data_unused_t	*dup;		/* block unused entry */
 	char			*endptr;	/* end of the data entries */
 	int			error;		/* error return value */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	char			*ptr;		/* current data entry */
 	int			wantoff;	/* starting block offset */
 	xfs_off_t		cook;
-	struct xfs_da_geometry	*geo;
+	struct xfs_da_geometry	*geo = args->geo;
 
-	mp = dp->i_mount;
-	geo = mp->m_dir_geo;
 	/*
 	 * If the block number in the offset is out of range, we're done.
 	 */
@@ -258,7 +253,7 @@ xfs_dir2_block_getdents(
 		 */
 		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
 			    be64_to_cpu(dep->inumber),
-			    xfs_dir3_get_dtype(mp, filetype))) {
+			    xfs_dir3_get_dtype(dp->i_mount, filetype))) {
 			xfs_trans_brelse(NULL, bp);
 			return 0;
 		}
@@ -269,7 +264,7 @@ xfs_dir2_block_getdents(
 	 * Set the offset to a non-existent block 1 and return.
 	 */
 	ctx->pos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk + 1, 0) &
-			0x7fffffff;
+								0x7fffffff;
 	xfs_trans_brelse(NULL, bp);
 	return 0;
 }
@@ -290,13 +285,13 @@ struct xfs_dir2_leaf_map_info {
 
 STATIC int
 xfs_dir2_leaf_readbuf(
-	struct xfs_inode	*dp,
+	struct xfs_da_args	*args,
 	size_t			bufsize,
 	struct xfs_dir2_leaf_map_info *mip,
 	xfs_dir2_off_t		*curoff,
 	struct xfs_buf		**bpp)
 {
-	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf		*bp = *bpp;
 	struct xfs_bmbt_irec	*map = mip->map;
 	struct blk_plug		plug;
@@ -304,7 +299,7 @@ xfs_dir2_leaf_readbuf(
 	int			length;
 	int			i;
 	int			j;
-	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	struct xfs_da_geometry	*geo = args->geo;
 
 	/*
 	 * If we have a buffer, we need to release it and
@@ -338,8 +333,7 @@ xfs_dir2_leaf_readbuf(
 	/*
 	 * Recalculate the readahead blocks wanted.
 	 */
-	mip->ra_want = howmany(bufsize + geo->blksize,
-			       mp->m_sb.sb_blocksize) - 1;
+	mip->ra_want = howmany(bufsize + geo->blksize, (1 << geo->fsblog)) - 1;
 	ASSERT(mip->ra_want >= 0);
 
 	/*
@@ -411,8 +405,8 @@ xfs_dir2_leaf_readbuf(
 	mip->curdb = xfs_dir2_da_to_db(geo, map->br_startoff);
 	error = xfs_dir3_data_read(NULL, dp, map->br_startoff,
 			map->br_blockcount >= geo->fsbcount ?
-			    XFS_FSB_TO_DADDR(mp, map->br_startblock) : -1, &bp);
-
+			    XFS_FSB_TO_DADDR(dp->i_mount, map->br_startblock) :
+			    -1, &bp);
 	/*
 	 * Should just skip over the data block instead of giving up.
 	 */
@@ -441,7 +435,7 @@ xfs_dir2_leaf_readbuf(
 		    map[mip->ra_index].br_blockcount >= geo->fsbcount) {
 			xfs_dir3_data_readahead(dp,
 				map[mip->ra_index].br_startoff + mip->ra_offset,
-				XFS_FSB_TO_DADDR(mp,
+				XFS_FSB_TO_DADDR(dp->i_mount,
 					map[mip->ra_index].br_startblock +
 							mip->ra_offset));
 			mip->ra_current = i;
@@ -493,23 +487,23 @@ out:
  */
 STATIC int
 xfs_dir2_leaf_getdents(
-	xfs_inode_t		*dp,		/* incore directory inode */
+	struct xfs_da_args	*args,
 	struct dir_context	*ctx,
 	size_t			bufsize)
 {
+	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf		*bp = NULL;	/* data block buffer */
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_data_entry_t	*dep;		/* data entry */
 	xfs_dir2_data_unused_t	*dup;		/* unused entry */
 	int			error = 0;	/* error return value */
 	int			length;		/* temporary length value */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	int			byteoff;	/* offset in current block */
 	xfs_dir2_off_t		curoff;		/* current overall offset */
 	xfs_dir2_off_t		newoff;		/* new curoff after new blk */
 	char			*ptr = NULL;	/* pointer to current data */
 	struct xfs_dir2_leaf_map_info *map_info;
-	struct xfs_da_geometry	*geo;
+	struct xfs_da_geometry	*geo = args->geo;
 
 	/*
 	 * If the offset is at or past the largest allowed value,
@@ -518,15 +512,12 @@ xfs_dir2_leaf_getdents(
 	if (ctx->pos >= XFS_DIR2_MAX_DATAPTR)
 		return 0;
 
-	mp = dp->i_mount;
-	geo = mp->m_dir_geo;
-
 	/*
 	 * Set up to bmap a number of blocks based on the caller's
 	 * buffer size, the directory block size, and the filesystem
 	 * block size.
 	 */
-	length = howmany(bufsize + geo->blksize, mp->m_sb.sb_blocksize);
+	length = howmany(bufsize + geo->blksize, (1 << geo->fsblog));
 	map_info = kmem_zalloc(offsetof(struct xfs_dir2_leaf_map_info, map) +
 				(length * sizeof(struct xfs_bmbt_irec)),
 			       KM_SLEEP | KM_NOFS);
@@ -558,7 +549,7 @@ xfs_dir2_leaf_getdents(
 		 */
 		if (!bp || ptr >= (char *)bp->b_addr + geo->blksize) {
 
-			error = xfs_dir2_leaf_readbuf(dp, bufsize, map_info,
+			error = xfs_dir2_leaf_readbuf(args, bufsize, map_info,
 						      &curoff, &bp);
 			if (error || !map_info->map_valid)
 				break;
@@ -566,7 +557,7 @@ xfs_dir2_leaf_getdents(
 			/*
 			 * Having done a read, we need to set a new offset.
 			 */
-			newoff = xfs_dir2_db_off_to_byte(mp->m_dir_geo,
+			newoff = xfs_dir2_db_off_to_byte(geo,
 							 map_info->curdb, 0);
 			/*
 			 * Start of the current block.
@@ -585,7 +576,7 @@ xfs_dir2_leaf_getdents(
 			 * Find our position in the block.
 			 */
 			ptr = (char *)dp->d_ops->data_entry_p(hdr);
-			byteoff = xfs_dir2_byte_to_off(mp->m_dir_geo, curoff);
+			byteoff = xfs_dir2_byte_to_off(geo, curoff);
 			/*
 			 * Skip past the header.
 			 */
@@ -644,7 +635,7 @@ xfs_dir2_leaf_getdents(
 		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
 		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
 			    be64_to_cpu(dep->inumber),
-			    xfs_dir3_get_dtype(mp, filetype)))
+			    xfs_dir3_get_dtype(dp->i_mount, filetype)))
 			break;
 
 		/*
@@ -674,13 +665,14 @@ xfs_dir2_leaf_getdents(
  */
 int
 xfs_readdir(
-	xfs_inode_t	*dp,
-	struct dir_context *ctx,
-	size_t		bufsize)
+	struct xfs_inode	*dp,
+	struct dir_context	*ctx,
+	size_t			bufsize)
 {
-	int		rval;		/* return value */
-	int		v;		/* type-checking value */
-	uint		lock_mode;
+	struct xfs_da_args	args = {0};
+	int			rval;
+	int			v;
+	uint			lock_mode;
 
 	trace_xfs_readdir(dp);
 
@@ -690,15 +682,18 @@ xfs_readdir(
 	ASSERT(S_ISDIR(dp->i_d.di_mode));
 	XFS_STATS_INC(xs_dir_getdents);
 
+	args.dp = dp;
+	args.geo = dp->i_mount->m_dir_geo;
+
 	lock_mode = xfs_ilock_data_map_shared(dp);
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
-		rval = xfs_dir2_sf_getdents(dp, ctx);
-	else if ((rval = xfs_dir2_isblock(dp, &v)))
+		rval = xfs_dir2_sf_getdents(&args, ctx);
+	else if ((rval = xfs_dir2_isblock(&args, &v)))
 		;
 	else if (v)
-		rval = xfs_dir2_block_getdents(dp, ctx);
+		rval = xfs_dir2_block_getdents(&args, ctx);
 	else
-		rval = xfs_dir2_leaf_getdents(dp, ctx, bufsize);
+		rval = xfs_dir2_leaf_getdents(&args, ctx, bufsize);
 	xfs_iunlock(dp, lock_mode);
 
 	return rval;
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
