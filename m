Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E73B7F57
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 21:09:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6E1A33040C0
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 19:09:07 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HzgNCZZx6SRLcGex for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 19:09:04 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Xvdpl-0004QC-9A
	for xfs@oss.sgi.com; Tue, 02 Dec 2014 14:09:01 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Xvdpl-0002vd-8K
	for xfs@oss.sgi.com; Tue, 02 Dec 2014 14:09:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix set-but-unused warnings
Date: Tue,  2 Dec 2014 14:09:01 +1100
Message-Id: <1417489741-11223-1-git-send-email-david@fromorbit.com>
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

The kernel compile doesn't turn on these checks by default, so it's
only when I do a kernel-user sync that I find that there are lots of
compiler warnings waiting to be fixed. Fix up these set-but-unused
warnings.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |  2 --
 fs/xfs/libxfs/xfs_da_btree.c   |  4 ----
 fs/xfs/libxfs/xfs_dir2_block.c |  8 --------
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 10 ----------
 fs/xfs/libxfs/xfs_dir2_node.c  | 12 ------------
 fs/xfs/libxfs/xfs_dir2_sf.c    | 10 ----------
 fs/xfs/xfs_inode.c             | 12 ++----------
 fs/xfs/xfs_iomap.c             |  2 --
 fs/xfs/xfs_itable.c            |  2 --
 9 files changed, 2 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ecc4d01..b5eb474 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5447,13 +5447,11 @@ xfs_bmse_merge(
 	struct xfs_btree_cur		*cur,
 	int				*logflags)	/* output */
 {
-	struct xfs_ifork		*ifp;
 	struct xfs_bmbt_irec		got;
 	struct xfs_bmbt_irec		left;
 	xfs_filblks_t			blockcount;
 	int				error, i;
 
-	ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_bmbt_get_all(gotp, &got);
 	xfs_bmbt_get_all(leftp, &left);
 	blockcount = left.br_blockcount + got.br_blockcount;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index c41e751..9cb0115 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -512,7 +512,6 @@ xfs_da3_root_split(
 	struct xfs_buf		*bp;
 	struct xfs_inode	*dp;
 	struct xfs_trans	*tp;
-	struct xfs_mount	*mp;
 	struct xfs_dir2_leaf	*leaf;
 	xfs_dablk_t		blkno;
 	int			level;
@@ -532,7 +531,6 @@ xfs_da3_root_split(
 
 	dp = args->dp;
 	tp = args->trans;
-	mp = state->mp;
 	error = xfs_da_get_buf(tp, dp, blkno, -1, &bp, args->whichfork);
 	if (error)
 		return error;
@@ -2340,14 +2338,12 @@ xfs_da_shrink_inode(
 	xfs_inode_t *dp;
 	int done, error, w, count;
 	xfs_trans_t *tp;
-	xfs_mount_t *mp;
 
 	trace_xfs_da_shrink_inode(args);
 
 	dp = args->dp;
 	w = args->whichfork;
 	tp = args->trans;
-	mp = dp->i_mount;
 	count = args->geo->fsbcount;
 	for (;;) {
 		/*
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index c2e34c5..9354e19 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -350,7 +350,6 @@ xfs_dir2_block_addname(
 	int			low;		/* low index for binary srch */
 	int			lowstale;	/* low stale index */
 	int			mid=0;		/* midpoint for binary srch */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	int			needlog;	/* need to log header */
 	int			needscan;	/* need to rescan freespace */
 	__be16			*tagp;		/* pointer to tag value */
@@ -360,7 +359,6 @@ xfs_dir2_block_addname(
 
 	dp = args->dp;
 	tp = args->trans;
-	mp = dp->i_mount;
 
 	/* Read the (one and only) directory block into bp. */
 	error = xfs_dir3_block_read(tp, dp, &bp);
@@ -615,7 +613,6 @@ xfs_dir2_block_lookup(
 	xfs_inode_t		*dp;		/* incore inode */
 	int			ent;		/* entry index */
 	int			error;		/* error return value */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 
 	trace_xfs_dir2_block_lookup(args);
 
@@ -626,7 +623,6 @@ xfs_dir2_block_lookup(
 	if ((error = xfs_dir2_block_lookup_int(args, &bp, &ent)))
 		return error;
 	dp = args->dp;
-	mp = dp->i_mount;
 	hdr = bp->b_addr;
 	xfs_dir3_data_check(dp, bp);
 	btp = xfs_dir2_block_tail_p(args->geo, hdr);
@@ -767,7 +763,6 @@ xfs_dir2_block_removename(
 	xfs_inode_t		*dp;		/* incore inode */
 	int			ent;		/* block leaf entry index */
 	int			error;		/* error return value */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	int			needlog;	/* need to log block header */
 	int			needscan;	/* need to fixup bestfree */
 	xfs_dir2_sf_hdr_t	sfh;		/* shortform header */
@@ -785,7 +780,6 @@ xfs_dir2_block_removename(
 	}
 	dp = args->dp;
 	tp = args->trans;
-	mp = dp->i_mount;
 	hdr = bp->b_addr;
 	btp = xfs_dir2_block_tail_p(args->geo, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
@@ -849,7 +843,6 @@ xfs_dir2_block_replace(
 	xfs_inode_t		*dp;		/* incore inode */
 	int			ent;		/* leaf entry index */
 	int			error;		/* error return value */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 
 	trace_xfs_dir2_block_replace(args);
 
@@ -861,7 +854,6 @@ xfs_dir2_block_replace(
 		return error;
 	}
 	dp = args->dp;
-	mp = dp->i_mount;
 	hdr = bp->b_addr;
 	btp = xfs_dir2_block_tail_p(args->geo, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index ed41a0e..1061199 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -382,7 +382,6 @@ xfs_dir2_block_to_leaf(
 	xfs_dir2_db_t		ldb;		/* leaf block's bno */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_tail_t	*ltp;		/* leaf's tail */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	int			needlog;	/* need to log block header */
 	int			needscan;	/* need to rescan bestfree */
 	xfs_trans_t		*tp;		/* transaction pointer */
@@ -393,7 +392,6 @@ xfs_dir2_block_to_leaf(
 	trace_xfs_dir2_block_to_leaf(args);
 
 	dp = args->dp;
-	mp = dp->i_mount;
 	tp = args->trans;
 	/*
 	 * Add the leaf block to the inode.
@@ -624,7 +622,6 @@ xfs_dir2_leaf_addname(
 	int			lfloghigh;	/* high leaf logging index */
 	int			lowstale;	/* index of prev stale leaf */
 	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail pointer */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	int			needbytes;	/* leaf block bytes needed */
 	int			needlog;	/* need to log data header */
 	int			needscan;	/* need to rescan data free */
@@ -639,7 +636,6 @@ xfs_dir2_leaf_addname(
 
 	dp = args->dp;
 	tp = args->trans;
-	mp = dp->i_mount;
 
 	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
 	if (error)
@@ -1354,11 +1350,9 @@ xfs_dir2_leaf_removename(
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail structure */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	int			needlog;	/* need to log data header */
 	int			needscan;	/* need to rescan data frees */
 	xfs_dir2_data_off_t	oldbest;	/* old value of best free */
-	xfs_trans_t		*tp;		/* transaction pointer */
 	struct xfs_dir2_data_free *bf;		/* bestfree table */
 	struct xfs_dir2_leaf_entry *ents;
 	struct xfs_dir3_icleaf_hdr leafhdr;
@@ -1372,8 +1366,6 @@ xfs_dir2_leaf_removename(
 		return error;
 	}
 	dp = args->dp;
-	tp = args->trans;
-	mp = dp->i_mount;
 	leaf = lbp->b_addr;
 	hdr = dbp->b_addr;
 	xfs_dir3_data_check(dp, dbp);
@@ -1605,11 +1597,9 @@ xfs_dir2_leaf_trim_data(
 	int			error;		/* error return value */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail structure */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
 	dp = args->dp;
-	mp = dp->i_mount;
 	tp = args->trans;
 	/*
 	 * Read the offending data block.  We need its buffer.
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 78ceda1..41b80d3 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -295,7 +295,6 @@ xfs_dir2_leaf_to_node(
 	int			i;		/* leaf freespace index */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail structure */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	int			n;		/* count of live freespc ents */
 	xfs_dir2_data_off_t	off;		/* freespace entry value */
 	__be16			*to;		/* pointer to freespace entry */
@@ -305,7 +304,6 @@ xfs_dir2_leaf_to_node(
 	trace_xfs_dir2_leaf_to_node(args);
 
 	dp = args->dp;
-	mp = dp->i_mount;
 	tp = args->trans;
 	/*
 	 * Add a freespace block to the directory.
@@ -385,16 +383,12 @@ xfs_dir2_leafn_add(
 	int			lfloghigh;	/* high leaf entry logging */
 	int			lfloglow;	/* low leaf entry logging */
 	int			lowstale;	/* previous stale entry */
-	xfs_mount_t		*mp;		/* filesystem mount point */
-	xfs_trans_t		*tp;		/* transaction pointer */
 	struct xfs_dir3_icleaf_hdr leafhdr;
 	struct xfs_dir2_leaf_entry *ents;
 
 	trace_xfs_dir2_leafn_add(args, index);
 
 	dp = args->dp;
-	mp = dp->i_mount;
-	tp = args->trans;
 	leaf = bp->b_addr;
 	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
@@ -1168,7 +1162,6 @@ xfs_dir2_leafn_remove(
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	int			longest;	/* longest data free entry */
 	int			off;		/* data block entry offset */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	int			needlog;	/* need to log data header */
 	int			needscan;	/* need to rescan data frees */
 	xfs_trans_t		*tp;		/* transaction pointer */
@@ -1180,7 +1173,6 @@ xfs_dir2_leafn_remove(
 
 	dp = args->dp;
 	tp = args->trans;
-	mp = dp->i_mount;
 	leaf = bp->b_addr;
 	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
@@ -1321,7 +1313,6 @@ xfs_dir2_leafn_split(
 	xfs_da_args_t		*args;		/* operation arguments */
 	xfs_dablk_t		blkno;		/* new leaf block number */
 	int			error;		/* error return value */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	struct xfs_inode	*dp;
 
 	/*
@@ -1329,7 +1320,6 @@ xfs_dir2_leafn_split(
 	 */
 	args = state->args;
 	dp = args->dp;
-	mp = dp->i_mount;
 	ASSERT(oldblk->magic == XFS_DIR2_LEAFN_MAGIC);
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error) {
@@ -2229,12 +2219,10 @@ xfs_dir2_node_trim_free(
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return code */
 	xfs_dir2_free_t		*free;		/* freespace structure */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_trans_t		*tp;		/* transaction pointer */
 	struct xfs_dir3_icfree_hdr freehdr;
 
 	dp = args->dp;
-	mp = dp->i_mount;
 	tp = args->trans;
 	/*
 	 * Read the freespace block.
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 2baedc4..974d62e 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -452,13 +452,11 @@ xfs_dir2_sf_addname_hard(
 	xfs_dir2_sf_hdr_t	*oldsfp;	/* original shortform dir */
 	xfs_dir2_sf_entry_t	*sfep;		/* entry in new dir */
 	xfs_dir2_sf_hdr_t	*sfp;		/* new shortform dir */
-	struct xfs_mount	*mp;
 
 	/*
 	 * Copy the old directory to the stack buffer.
 	 */
 	dp = args->dp;
-	mp = dp->i_mount;
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	old_isize = (int)dp->i_d.di_size;
@@ -539,7 +537,6 @@ xfs_dir2_sf_addname_pick(
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			holefit;	/* found hole it will fit in */
 	int			i;		/* entry number */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_dir2_data_aoff_t	offset;		/* data block offset */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
@@ -547,7 +544,6 @@ xfs_dir2_sf_addname_pick(
 	int			used;		/* data bytes used */
 
 	dp = args->dp;
-	mp = dp->i_mount;
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	size = dp->d_ops->data_entsize(args->namelen);
@@ -613,10 +609,8 @@ xfs_dir2_sf_check(
 	int			offset;		/* data offset */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform dir entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
-	struct xfs_mount	*mp;
 
 	dp = args->dp;
-	mp = dp->i_mount;
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	offset = dp->d_ops->data_first_offset;
@@ -1013,12 +1007,10 @@ xfs_dir2_sf_toino4(
 	int			oldsize;	/* old inode size */
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
-	struct xfs_mount	*mp;
 
 	trace_xfs_dir2_sf_toino4(args);
 
 	dp = args->dp;
-	mp = dp->i_mount;
 
 	/*
 	 * Copy the old directory to the buffer.
@@ -1091,12 +1083,10 @@ xfs_dir2_sf_toino8(
 	int			oldsize;	/* old inode size */
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
-	struct xfs_mount	*mp;
 
 	trace_xfs_dir2_sf_toino8(args);
 
 	dp = args->dp;
-	mp = dp->i_mount;
 
 	/*
 	 * Copy the old directory to the buffer.
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fb2f900..41f804e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2483,9 +2483,7 @@ xfs_remove(
 	xfs_fsblock_t           first_block;
 	int			cancel_flags;
 	int			committed;
-	int			link_zero;
 	uint			resblks;
-	uint			log_count;
 
 	trace_xfs_remove(dp, name);
 
@@ -2500,13 +2498,10 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
-	if (is_dir) {
+	if (is_dir)
 		tp = xfs_trans_alloc(mp, XFS_TRANS_RMDIR);
-		log_count = XFS_DEFAULT_LOG_COUNT;
-	} else {
+	else
 		tp = xfs_trans_alloc(mp, XFS_TRANS_REMOVE);
-		log_count = XFS_REMOVE_LOG_COUNT;
-	}
 	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 
 	/*
@@ -2574,9 +2569,6 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	/* Determine if this is the last link while the inode is locked */
-	link_zero = (ip->i_d.di_nlink == 0);
-
 	xfs_bmap_init(&free_list, &first_block);
 	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
 					&first_block, &free_list, resblks);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 2262ce3..788b5fa 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -261,7 +261,6 @@ xfs_iomap_eof_want_preallocate(
 {
 	xfs_fileoff_t   start_fsb;
 	xfs_filblks_t   count_fsb;
-	xfs_fsblock_t	firstblock;
 	int		n, error, imaps;
 	int		found_delalloc = 0;
 
@@ -286,7 +285,6 @@ xfs_iomap_eof_want_preallocate(
 	count_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	while (count_fsb > 0) {
 		imaps = nimaps;
-		firstblock = NULLFSBLOCK;
 		error = xfs_bmapi_read(ip, start_fsb, count_fsb, imap, &imaps,
 				       0);
 		if (error)
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 5930d66..82e3142 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -348,7 +348,6 @@ xfs_bulkstat(
 	int			*done)	/* 1 if there are more stats to get */
 {
 	xfs_buf_t		*agbp;	/* agi header buffer */
-	xfs_agi_t		*agi;	/* agi header data */
 	xfs_agino_t		agino;	/* inode # in allocation group */
 	xfs_agnumber_t		agno;	/* allocation group number */
 	xfs_btree_cur_t		*cur;	/* btree cursor for ialloc btree */
@@ -399,7 +398,6 @@ xfs_bulkstat(
 		error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
 		if (error)
 			break;
-		agi = XFS_BUF_TO_AGI(agbp);
 		/*
 		 * Allocate and initialize a btree cursor for ialloc btree.
 		 */
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
