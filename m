Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DB09D7F84
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 03:20:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6127304062
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 01:20:03 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	g8kJavBgQWctEzAv for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 01:20:01 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WiJYV-0001j8-As
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WiJYV-0006wu-9x
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/18] xfs: reduce direct usage of mp->m_dir_geo
Date: Thu,  8 May 2014 18:19:42 +1000
Message-Id: <1399537188-26509-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1399537188-26509-1-git-send-email-david@fromorbit.com>
References: <1399537188-26509-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_dir2.c         |  50 ++++++++++------------
 fs/xfs/xfs_dir2.h         |   4 +-
 fs/xfs/xfs_dir2_readdir.c | 105 ++++++++++++++++++++++------------------------
 3 files changed, 74 insertions(+), 85 deletions(-)

diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index 6e8107c..5a45681 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -273,7 +273,7 @@ xfs_dir_createname(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isblock(dp, &v);
+	rval = xfs_dir2_isblock(args, &v);
 	if (rval)
 		goto out_free;
 	if (v) {
@@ -281,7 +281,7 @@ xfs_dir_createname(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isleaf(dp, &v);
+	rval = xfs_dir2_isleaf(args, &v);
 	if (rval)
 		goto out_free;
 	if (v)
@@ -366,7 +366,7 @@ xfs_dir_lookup(
 		goto out_check_rval;
 	}
 
-	rval = xfs_dir2_isblock(dp, &v);
+	rval = xfs_dir2_isblock(args, &v);
 	if (rval)
 		goto out_free;
 	if (v) {
@@ -374,7 +374,7 @@ xfs_dir_lookup(
 		goto out_check_rval;
 	}
 
-	rval = xfs_dir2_isleaf(dp, &v);
+	rval = xfs_dir2_isleaf(args, &v);
 	if (rval)
 		goto out_free;
 	if (v)
@@ -439,7 +439,7 @@ xfs_dir_removename(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isblock(dp, &v);
+	rval = xfs_dir2_isblock(args, &v);
 	if (rval)
 		goto out_free;
 	if (v) {
@@ -447,7 +447,7 @@ xfs_dir_removename(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isleaf(dp, &v);
+	rval = xfs_dir2_isleaf(args, &v);
 	if (rval)
 		goto out_free;
 	if (v)
@@ -504,7 +504,7 @@ xfs_dir_replace(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isblock(dp, &v);
+	rval = xfs_dir2_isblock(args, &v);
 	if (rval)
 		goto out_free;
 	if (v) {
@@ -512,7 +512,7 @@ xfs_dir_replace(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isleaf(dp, &v);
+	rval = xfs_dir2_isleaf(args, &v);
 	if (rval)
 		goto out_free;
 	if (v)
@@ -564,7 +564,7 @@ xfs_dir_canenter(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isblock(dp, &v);
+	rval = xfs_dir2_isblock(args, &v);
 	if (rval)
 		goto out_free;
 	if (v) {
@@ -572,7 +572,7 @@ xfs_dir_canenter(
 		goto out_free;
 	}
 
-	rval = xfs_dir2_isleaf(dp, &v);
+	rval = xfs_dir2_isleaf(args, &v);
 	if (rval)
 		goto out_free;
 	if (v)
@@ -640,18 +640,16 @@ xfs_dir2_grow_inode(
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
@@ -661,17 +659,15 @@ xfs_dir2_isblock(
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
-	*vp = last == mp->m_dir_geo->leafblk + mp->m_dir_geo->blksize;
+	*vp = last == args->geo->leafblk + args->geo->fsbcount; /* XXX */
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index 85f6be6..f2f6bb8 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -144,8 +144,8 @@ extern int xfs_dir2_sf_to_block(struct xfs_da_args *args);
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
index fa393d5..6a120ca 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -76,28 +76,24 @@ const unsigned char xfs_mode_to_ftype[S_IFMT >> S_SHIFT] = {
 
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
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
 	/*
 	 * Give up if the directory is way too short.
 	 */
 	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
 		return XFS_ERROR(EIO);
 	}
 
@@ -111,7 +107,7 @@ xfs_dir2_sf_getdents(
 	/*
 	 * If the block number in the offset is out of range, we're done.
 	 */
-	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > geo->datablk)
+	if (xfs_dir2_dataptr_to_db(args->geo, ctx->pos) > args->geo->datablk)
 		return 0;
 
 	/*
@@ -120,9 +116,9 @@ xfs_dir2_sf_getdents(
 	 * XXX(hch): the second argument is sometimes 0 and sometimes
 	 * geo->datablk
 	 */
-	dot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
+	dot_offset = xfs_dir2_db_off_to_dataptr(args->geo, args->geo->datablk,
 						dp->d_ops->data_dot_offset);
-	dotdot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
+	dotdot_offset = xfs_dir2_db_off_to_dataptr(args->geo, args->geo->datablk,
 						dp->d_ops->data_dotdot_offset);
 
 	/*
@@ -151,7 +147,7 @@ xfs_dir2_sf_getdents(
 	for (i = 0; i < sfp->count; i++) {
 		__uint8_t filetype;
 
-		off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
+		off = xfs_dir2_db_off_to_dataptr(args->geo, args->geo->datablk,
 				xfs_dir2_sf_get_offset(sfep));
 
 		if (ctx->pos > off) {
@@ -163,13 +159,13 @@ xfs_dir2_sf_getdents(
 		filetype = dp->d_ops->sf_get_ftype(sfep);
 		ctx->pos = off & 0x7fffffff;
 		if (!dir_emit(ctx, (char *)sfep->name, sfep->namelen, ino,
-			    xfs_dir3_get_dtype(mp, filetype)))
+			    xfs_dir3_get_dtype(dp->i_mount, filetype)))
 			return 0;
 		sfep = dp->d_ops->sf_nextentry(sfp, sfep);
 	}
 
-	ctx->pos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk + 1, 0) &
-			0x7fffffff;
+	ctx->pos = xfs_dir2_db_off_to_dataptr(args->geo,
+					args->geo->datablk + 1, 0) & 0x7fffffff;
 	return 0;
 }
 
@@ -178,9 +174,10 @@ xfs_dir2_sf_getdents(
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
@@ -188,18 +185,14 @@ xfs_dir2_block_getdents(
 	xfs_dir2_data_unused_t	*dup;		/* block unused entry */
 	char			*endptr;	/* end of the data entries */
 	int			error;		/* error return value */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	char			*ptr;		/* current data entry */
 	int			wantoff;	/* starting block offset */
 	xfs_off_t		cook;
-	struct xfs_da_geometry	*geo;
 
-	mp = dp->i_mount;
-	geo = mp->m_dir_geo;
 	/*
 	 * If the block number in the offset is out of range, we're done.
 	 */
-	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > geo->datablk)
+	if (xfs_dir2_dataptr_to_db(args->geo, ctx->pos) > args->geo->datablk)
 		return 0;
 
 	error = xfs_dir3_block_read(NULL, dp, &bp);
@@ -210,13 +203,13 @@ xfs_dir2_block_getdents(
 	 * Extract the byte offset we start at from the seek pointer.
 	 * We'll skip entries before this.
 	 */
-	wantoff = xfs_dir2_dataptr_to_off(geo, ctx->pos);
+	wantoff = xfs_dir2_dataptr_to_off(args->geo, ctx->pos);
 	hdr = bp->b_addr;
 	xfs_dir3_data_check(dp, bp);
 	/*
 	 * Set up values for the loop.
 	 */
-	btp = xfs_dir2_block_tail_p(geo, hdr);
+	btp = xfs_dir2_block_tail_p(args->geo, hdr);
 	ptr = (char *)dp->d_ops->data_entry_p(hdr);
 	endptr = (char *)xfs_dir2_block_leaf_p(btp);
 
@@ -248,7 +241,7 @@ xfs_dir2_block_getdents(
 		if ((char *)dep - (char *)hdr < wantoff)
 			continue;
 
-		cook = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
+		cook = xfs_dir2_db_off_to_dataptr(args->geo, args->geo->datablk,
 					    (char *)dep - (char *)hdr);
 
 		ctx->pos = cook & 0x7fffffff;
@@ -258,7 +251,7 @@ xfs_dir2_block_getdents(
 		 */
 		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
 			    be64_to_cpu(dep->inumber),
-			    xfs_dir3_get_dtype(mp, filetype))) {
+			    xfs_dir3_get_dtype(dp->i_mount, filetype))) {
 			xfs_trans_brelse(NULL, bp);
 			return 0;
 		}
@@ -268,8 +261,8 @@ xfs_dir2_block_getdents(
 	 * Reached the end of the block.
 	 * Set the offset to a non-existent block 1 and return.
 	 */
-	ctx->pos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk + 1, 0) &
-			0x7fffffff;
+	ctx->pos = xfs_dir2_db_off_to_dataptr(args->geo,
+					args->geo->datablk + 1, 0) & 0x7fffffff;
 	xfs_trans_brelse(NULL, bp);
 	return 0;
 }
@@ -290,13 +283,13 @@ struct xfs_dir2_leaf_map_info {
 
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
@@ -304,7 +297,7 @@ xfs_dir2_leaf_readbuf(
 	int			length;
 	int			i;
 	int			j;
-	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	struct xfs_da_geometry	*geo = args->geo;
 
 	/*
 	 * If we have a buffer, we need to release it and
@@ -314,7 +307,7 @@ xfs_dir2_leaf_readbuf(
 	if (bp) {
 		xfs_trans_brelse(NULL, bp);
 		bp = NULL;
-		mip->map_blocks -= geo->fsbcount;
+		mip->map_blocks -= args->geo->fsbcount;
 		/*
 		 * Loop to get rid of the extents for the
 		 * directory block.
@@ -338,8 +331,7 @@ xfs_dir2_leaf_readbuf(
 	/*
 	 * Recalculate the readahead blocks wanted.
 	 */
-	mip->ra_want = howmany(bufsize + geo->blksize,
-			       mp->m_sb.sb_blocksize) - 1;
+	mip->ra_want = howmany(bufsize + geo->blksize, (1 << geo->fsblog)) - 1;
 	ASSERT(mip->ra_want >= 0);
 
 	/*
@@ -411,8 +403,8 @@ xfs_dir2_leaf_readbuf(
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
@@ -441,7 +433,7 @@ xfs_dir2_leaf_readbuf(
 		    map[mip->ra_index].br_blockcount >= geo->fsbcount) {
 			xfs_dir3_data_readahead(dp,
 				map[mip->ra_index].br_startoff + mip->ra_offset,
-				XFS_FSB_TO_DADDR(mp,
+				XFS_FSB_TO_DADDR(dp->i_mount,
 					map[mip->ra_index].br_startblock +
 							mip->ra_offset));
 			mip->ra_current = i;
@@ -493,23 +485,23 @@ out:
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
@@ -518,15 +510,12 @@ xfs_dir2_leaf_getdents(
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
@@ -558,7 +547,7 @@ xfs_dir2_leaf_getdents(
 		 */
 		if (!bp || ptr >= (char *)bp->b_addr + geo->blksize) {
 
-			error = xfs_dir2_leaf_readbuf(dp, bufsize, map_info,
+			error = xfs_dir2_leaf_readbuf(args, bufsize, map_info,
 						      &curoff, &bp);
 			if (error || !map_info->map_valid)
 				break;
@@ -566,7 +555,7 @@ xfs_dir2_leaf_getdents(
 			/*
 			 * Having done a read, we need to set a new offset.
 			 */
-			newoff = xfs_dir2_db_off_to_byte(mp->m_dir_geo,
+			newoff = xfs_dir2_db_off_to_byte(geo,
 							 map_info->curdb, 0);
 			/*
 			 * Start of the current block.
@@ -585,7 +574,7 @@ xfs_dir2_leaf_getdents(
 			 * Find our position in the block.
 			 */
 			ptr = (char *)dp->d_ops->data_entry_p(hdr);
-			byteoff = xfs_dir2_byte_to_off(mp->m_dir_geo, curoff);
+			byteoff = xfs_dir2_byte_to_off(geo, curoff);
 			/*
 			 * Skip past the header.
 			 */
@@ -644,7 +633,7 @@ xfs_dir2_leaf_getdents(
 		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
 		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
 			    be64_to_cpu(dep->inumber),
-			    xfs_dir3_get_dtype(mp, filetype)))
+			    xfs_dir3_get_dtype(dp->i_mount, filetype)))
 			break;
 
 		/*
@@ -674,13 +663,14 @@ xfs_dir2_leaf_getdents(
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
 
@@ -690,15 +680,18 @@ xfs_readdir(
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
