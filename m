Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 662867F4E
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 01:04:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4C8678F8074
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 23:04:54 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	bys6tOKUJqZK5C9c for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 23:04:51 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WpWyk-0005oi-3K
	for xfs@oss.sgi.com; Wed, 28 May 2014 16:04:46 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WpWyk-0003lY-2S
	for xfs@oss.sgi.com; Wed, 28 May 2014 16:04:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/16] xfs: convert directory segment limits to xfs_da_geometry
Date: Wed, 28 May 2014 16:04:34 +1000
Message-Id: <1401257083-13433-8-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_da_btree.c     | 22 +++++++++++-----------
 fs/xfs/xfs_dir2.c         |  7 ++-----
 fs/xfs/xfs_dir2_block.c   |  6 +++---
 fs/xfs/xfs_dir2_data.c    |  9 +++++----
 fs/xfs/xfs_dir2_leaf.c    | 12 ++++++------
 fs/xfs/xfs_dir2_readdir.c | 18 +++++++++---------
 fs/xfs/xfs_dir2_sf.c      |  2 +-
 fs/xfs/xfs_mount.h        |  3 ---
 8 files changed, 37 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 4db5102..8621202 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -598,7 +598,7 @@ xfs_da3_root_split(
 	 * Set up the new root node.
 	 */
 	error = xfs_da3_node_create(args,
-		(args->whichfork == XFS_DATA_FORK) ? mp->m_dirleafblk : 0,
+		(args->whichfork == XFS_DATA_FORK) ? args->geo->leafblk : 0,
 		level + 1, &bp, args->whichfork);
 	if (error)
 		return error;
@@ -616,10 +616,10 @@ xfs_da3_root_split(
 #ifdef DEBUG
 	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
 	    oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC)) {
-		ASSERT(blk1->blkno >= mp->m_dirleafblk &&
-		       blk1->blkno < mp->m_dirfreeblk);
-		ASSERT(blk2->blkno >= mp->m_dirleafblk &&
-		       blk2->blkno < mp->m_dirfreeblk);
+		ASSERT(blk1->blkno >= args->geo->leafblk &&
+		       blk1->blkno < args->geo->freeblk);
+		ASSERT(blk2->blkno >= args->geo->leafblk &&
+		       blk2->blkno < args->geo->freeblk);
 	}
 #endif
 
@@ -894,8 +894,8 @@ xfs_da3_node_add(
 	ASSERT(oldblk->index >= 0 && oldblk->index <= nodehdr.count);
 	ASSERT(newblk->blkno != 0);
 	if (state->args->whichfork == XFS_DATA_FORK)
-		ASSERT(newblk->blkno >= state->mp->m_dirleafblk &&
-		       newblk->blkno < state->mp->m_dirfreeblk);
+		ASSERT(newblk->blkno >= state->args->geo->leafblk &&
+		       newblk->blkno < state->args->geo->freeblk);
 
 	/*
 	 * We may need to make some room before we insert the new node.
@@ -1472,7 +1472,7 @@ xfs_da3_node_lookup_int(
 	 * Descend thru the B-tree searching each level for the right
 	 * node to use, until the right hashval is found.
 	 */
-	blkno = (args->whichfork == XFS_DATA_FORK)? state->mp->m_dirleafblk : 0;
+	blkno = (args->whichfork == XFS_DATA_FORK)? args->geo->leafblk : 0;
 	for (blk = &state->path.blk[0], state->path.active = 1;
 			 state->path.active <= XFS_DA_NODE_MAXDEPTH;
 			 blk++, state->path.active++) {
@@ -2096,7 +2096,7 @@ xfs_da_grow_inode(
 	trace_xfs_da_grow_inode(args);
 
 	if (args->whichfork == XFS_DATA_FORK) {
-		bno = args->dp->i_mount->m_dirleafblk;
+		bno = args->geo->leafblk;
 		count = args->dp->i_mount->m_dirblkfsbs;
 	} else {
 		bno = 0;
@@ -2158,7 +2158,7 @@ xfs_da3_swap_lastblock(
 	w = args->whichfork;
 	ASSERT(w == XFS_DATA_FORK);
 	mp = dp->i_mount;
-	lastoff = mp->m_dirfreeblk;
+	lastoff = args->geo->freeblk;
 	error = xfs_bmap_last_before(tp, dp, &lastoff, w);
 	if (error)
 		return error;
@@ -2247,7 +2247,7 @@ xfs_da3_swap_lastblock(
 					sizeof(sib_info->back)));
 		sib_buf = NULL;
 	}
-	par_blkno = mp->m_dirleafblk;
+	par_blkno = args->geo->leafblk;
 	level = -1;
 	/*
 	 * Walk down the tree looking for the parent of the moved block.
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index 866a671..cecb3e8 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -147,9 +147,6 @@ xfs_da_mount(
 	/* XXX: these are to be removed as code is converted to use geo */
 	mp->m_dirblksize = mp->m_dir_geo->blksize;
 	mp->m_dirblkfsbs = mp->m_dir_geo->fsbcount;
-	mp->m_dirdatablk = mp->m_dir_geo->datablk;
-	mp->m_dirleafblk = mp->m_dir_geo->leafblk;
-	mp->m_dirfreeblk = mp->m_dir_geo->freeblk;
 	mp->m_dir_node_ents = mp->m_dir_geo->node_ents;
 	mp->m_dir_magicpct = mp->m_dir_geo->magicpct;
 	mp->m_attr_node_ents = mp->m_attr_geo->node_ents;
@@ -690,7 +687,7 @@ xfs_dir2_isleaf(
 	mp = dp->i_mount;
 	if ((rval = xfs_bmap_last_offset(dp, &last, XFS_DATA_FORK)))
 		return rval;
-	*vp = last == mp->m_dirleafblk + (1 << mp->m_sb.sb_dirblklog);
+	*vp = last == mp->m_dir_geo->leafblk + (1 << mp->m_sb.sb_dirblklog);
 	return 0;
 }
 
@@ -763,7 +760,7 @@ xfs_dir2_shrink_inode(
 		 */
 		return error;
 	}
-	if (db == mp->m_dirdatablk)
+	if (db == args->geo->datablk)
 		ASSERT(bno == 0);
 	else
 		ASSERT(bno > 0);
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index bc08216..d950cde 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -136,7 +136,7 @@ xfs_dir3_block_read(
 	struct xfs_mount	*mp = dp->i_mount;
 	int			err;
 
-	err = xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, bpp,
+	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, -1, bpp,
 				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
 	if (!err && tp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
@@ -969,7 +969,7 @@ xfs_dir2_leaf_to_block(
 	 * Read the data block if we don't already have it, give up if it fails.
 	 */
 	if (!dbp) {
-		error = xfs_dir3_data_read(tp, dp, mp->m_dirdatablk, -1, &dbp);
+		error = xfs_dir3_data_read(tp, dp, args->geo->datablk, -1, &dbp);
 		if (error)
 			return error;
 	}
@@ -1034,7 +1034,7 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Pitch the old leaf block.
 	 */
-	error = xfs_da_shrink_inode(args, mp->m_dirleafblk, lbp);
+	error = xfs_da_shrink_inode(args, args->geo->leafblk, lbp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index d355ec7..6c23f86 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -63,8 +63,10 @@ __xfs_dir3_data_check(
 	int			stale;		/* count of stale leaves */
 	struct xfs_name		name;
 	const struct xfs_dir_ops *ops;
+	struct xfs_da_geometry	*geo;
 
 	mp = bp->b_target->bt_mount;
+	geo = mp->m_dir_geo;
 
 	/*
 	 * We can be passed a null dp here from a verifier, so we need to go the
@@ -172,10 +174,9 @@ __xfs_dir3_data_check(
 		lastfree = 0;
 		if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 		    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
-			addr = xfs_dir2_db_off_to_dataptr(mp->m_dir_geo,
-				mp->m_dirdatablk,
-				(xfs_dir2_data_aoff_t)
-				((char *)dep - (char *)hdr));
+			addr = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
+						(xfs_dir2_data_aoff_t)
+						((char *)dep - (char *)hdr));
 			name.name = dep->name;
 			name.len = dep->namelen;
 			hash = mp->m_dirnameops->hashname(&name);
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 2b3ddd0..3eb8b24 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -641,7 +641,7 @@ xfs_dir2_leaf_addname(
 	tp = args->trans;
 	mp = dp->i_mount;
 
-	error = xfs_dir3_leaf_read(tp, dp, mp->m_dirleafblk, -1, &lbp);
+	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
 	if (error)
 		return error;
 
@@ -1232,7 +1232,7 @@ xfs_dir2_leaf_lookup_int(
 	tp = args->trans;
 	mp = dp->i_mount;
 
-	error = xfs_dir3_leaf_read(tp, dp, mp->m_dirleafblk, -1, &lbp);
+	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
 	if (error)
 		return error;
 
@@ -1429,7 +1429,7 @@ xfs_dir2_leaf_removename(
 	 */
 	if (be16_to_cpu(bf[0].length) ==
 			mp->m_dirblksize - dp->d_ops->data_entry_offset) {
-		ASSERT(db != mp->m_dirdatablk);
+		ASSERT(db != args->geo->datablk);
 		if ((error = xfs_dir2_shrink_inode(args, db, dbp))) {
 			/*
 			 * Nope, can't get rid of it because it caused
@@ -1470,7 +1470,7 @@ xfs_dir2_leaf_removename(
 	/*
 	 * If the data block was not the first one, drop it.
 	 */
-	else if (db != mp->m_dirdatablk)
+	else if (db != args->geo->datablk)
 		dbp = NULL;
 
 	xfs_dir3_leaf_check(dp, lbp);
@@ -1722,7 +1722,7 @@ xfs_dir2_node_to_leaf(
 	 * that may have been left behind during no-space-reservation
 	 * operations.
 	 */
-	while (fo > mp->m_dirfreeblk) {
+	while (fo > args->geo->freeblk) {
 		if ((error = xfs_dir2_node_trim_free(args, fo, &rval))) {
 			return error;
 		}
@@ -1752,7 +1752,7 @@ xfs_dir2_node_to_leaf(
 	/*
 	 * Read the freespace block.
 	 */
-	error = xfs_dir2_free_read(tp, dp,  mp->m_dirfreeblk, &fbp);
+	error = xfs_dir2_free_read(tp, dp,  args->geo->freeblk, &fbp);
 	if (error)
 		return error;
 	free = fbp->b_addr;
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index c2a6387..0c8c09c 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -111,18 +111,18 @@ xfs_dir2_sf_getdents(
 	/*
 	 * If the block number in the offset is out of range, we're done.
 	 */
-	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > mp->m_dirdatablk)
+	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > geo->datablk)
 		return 0;
 
 	/*
 	 * Precalculate offsets for . and .. as we will always need them.
 	 *
 	 * XXX(hch): the second argument is sometimes 0 and sometimes
-	 * mp->m_dirdatablk.
+	 * geo->datablk
 	 */
-	dot_offset = xfs_dir2_db_off_to_dataptr(geo, mp->m_dirdatablk,
+	dot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 						dp->d_ops->data_dot_offset);
-	dotdot_offset = xfs_dir2_db_off_to_dataptr(geo, mp->m_dirdatablk,
+	dotdot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 						dp->d_ops->data_dotdot_offset);
 
 	/*
@@ -151,7 +151,7 @@ xfs_dir2_sf_getdents(
 	for (i = 0; i < sfp->count; i++) {
 		__uint8_t filetype;
 
-		off = xfs_dir2_db_off_to_dataptr(geo, mp->m_dirdatablk,
+		off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 				xfs_dir2_sf_get_offset(sfep));
 
 		if (ctx->pos > off) {
@@ -168,7 +168,7 @@ xfs_dir2_sf_getdents(
 		sfep = dp->d_ops->sf_nextentry(sfp, sfep);
 	}
 
-	ctx->pos = xfs_dir2_db_off_to_dataptr(geo, mp->m_dirdatablk + 1, 0) &
+	ctx->pos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk + 1, 0) &
 			0x7fffffff;
 	return 0;
 }
@@ -199,7 +199,7 @@ xfs_dir2_block_getdents(
 	/*
 	 * If the block number in the offset is out of range, we're done.
 	 */
-	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > mp->m_dirdatablk)
+	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > geo->datablk)
 		return 0;
 
 	error = xfs_dir3_block_read(NULL, dp, &bp);
@@ -248,7 +248,7 @@ xfs_dir2_block_getdents(
 		if ((char *)dep - (char *)hdr < wantoff)
 			continue;
 
-		cook = xfs_dir2_db_off_to_dataptr(geo, mp->m_dirdatablk,
+		cook = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 					    (char *)dep - (char *)hdr);
 
 		ctx->pos = cook & 0x7fffffff;
@@ -268,7 +268,7 @@ xfs_dir2_block_getdents(
 	 * Reached the end of the block.
 	 * Set the offset to a non-existent block 1 and return.
 	 */
-	ctx->pos = xfs_dir2_db_off_to_dataptr(geo, mp->m_dirdatablk + 1, 0) &
+	ctx->pos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk + 1, 0) &
 			0x7fffffff;
 	xfs_trans_brelse(NULL, bp);
 	return 0;
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 4dc4193..10f4c2a 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -247,7 +247,7 @@ xfs_dir2_block_to_sf(
 
 	/* now we are done with the block, we can shrink the inode */
 	logflags = XFS_ILOG_CORE;
-	error = xfs_dir2_shrink_inode(args, mp->m_dirdatablk, bp);
+	error = xfs_dir2_shrink_inode(args, args->geo->datablk, bp);
 	if (error) {
 		ASSERT(error != ENOSPC);
 		goto out;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 27cce7b..0a32de0 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -156,9 +156,6 @@ typedef struct xfs_mount {
 	const struct xfs_dir_ops *m_nondir_inode_ops; /* !dir inode ops */
 	int			m_dirblksize;	/* directory block sz--bytes */
 	int			m_dirblkfsbs;	/* directory block sz--fsbs */
-	xfs_dablk_t		m_dirdatablk;	/* blockno of dir data v2 */
-	xfs_dablk_t		m_dirleafblk;	/* blockno of dir non-data v2 */
-	xfs_dablk_t		m_dirfreeblk;	/* blockno of dirfreeindex v2 */
 	uint			m_chsize;	/* size of next field */
 	atomic_t		m_active_trans;	/* number trans frozen */
 #ifdef HAVE_PERCPU_SB
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
