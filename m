Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 903EB7CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 00:19:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5787C304051
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 22:19:07 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0saJzx61KwOEUJG5 for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 22:19:02 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVCUN-0000MG-JP
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVCUN-0005Gi-Ii
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/14] xfs: eliminate committed arg from xfs_bmap_finish
Date: Mon, 15 Feb 2016 17:18:19 +1100
Message-Id: <1455517105-20033-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1455517105-20033-1-git-send-email-david@fromorbit.com>
References: <1455517105-20033-1-git-send-email-david@fromorbit.com>
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

From: Eric Sandeen <sandeen@sandeen.net>

Source kernel commit f6106efae5f4144b32f6c10de0dc3e7efc9181e3

Calls to xfs_bmap_finish() and xfs_trans_ijoin(), and the
associated comments were replicated several times across
the attribute code, all dealing with what to do if the
transaction was or wasn't committed.

And in that replicated code, an ASSERT() test of an
uninitialized variable occurs in several locations:

	error = xfs_attr_thing(&args);
	if (!error) {
		error = xfs_bmap_finish(&args.trans, args.flist,
					&committed);
	}
	if (error) {
		ASSERT(committed);

If the first xfs_attr_thing() failed, we'd skip the xfs_bmap_finish,
never set "committed", and then test it in the ASSERT.

Fix this up by moving the committed state internal to xfs_bmap_finish,
and add a new inode argument.  If an inode is passed in, it is passed
through to __xfs_trans_roll() and joined to the transaction there if
the transaction was committed.

xfs_qm_dqalloc() was a little unique in that it called bjoin rather
than ijoin, but as Dave points out we can detect the committed state
but checking whether (*tpp != tp).

Addresses-Coverity-Id: 102360
Addresses-Coverity-Id: 102361
Addresses-Coverity-Id: 102363
Addresses-Coverity-Id: 102364
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 include/libxfs.h         |   1 -
 libxfs/util.c            |  19 +++----
 libxfs/xfs_attr.c        | 141 ++++++++---------------------------------------
 libxfs/xfs_attr_remote.c |  31 ++---------
 libxfs/xfs_bmap.c        |   6 +-
 libxfs/xfs_bmap.h        |   2 +-
 mkfs/proto.c             |  14 ++---
 repair/phase6.c          |  33 +++++------
 8 files changed, 57 insertions(+), 190 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 5e8f3d4..cf2e20e 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -163,7 +163,6 @@ extern unsigned int	libxfs_log2_roundup(unsigned int i);
 
 extern int	libxfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
 				xfs_off_t, int, int);
-extern int	libxfs_bmap_finish(xfs_trans_t **, xfs_bmap_free_t *, int *);
 
 extern void 	libxfs_fs_repair_cmn_err(int, struct xfs_mount *, char *, ...);
 extern void	libxfs_fs_cmn_err(int, struct xfs_mount *, char *, ...);
diff --git a/libxfs/util.c b/libxfs/util.c
index ee4bf3c..484a924 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -493,27 +493,25 @@ libxfs_mod_incore_sb(
 
 int
 libxfs_bmap_finish(
-	xfs_trans_t	**tp,
-	xfs_bmap_free_t *flist,
-	int		*committed)
+	struct xfs_trans	**tp,
+	struct xfs_bmap_free	*flist,
+	struct xfs_inode	*ip)
 {
 	xfs_bmap_free_item_t	*free;	/* free extent list item */
 	xfs_bmap_free_item_t	*next;	/* next item on free list */
 	int			error;
 
-	if (flist->xbf_count == 0) {
-		*committed = 0;
+	if (flist->xbf_count == 0)
 		return 0;
-	}
 
 	for (free = flist->xbf_first; free != NULL; free = next) {
 		next = free->xbfi_next;
-		if ((error = xfs_free_extent(*tp, free->xbfi_startblock,
-				free->xbfi_blockcount)))
+		error = xfs_free_extent(*tp, free->xbfi_startblock,
+					free->xbfi_blockcount);
+		if (error)
 			return error;
 		xfs_bmap_del_free(flist, NULL, free);
 	}
-	*committed = 0;
 	return 0;
 }
 
@@ -543,7 +541,6 @@ libxfs_alloc_file_space(
 	xfs_fileoff_t	startoffset_fsb;
 	xfs_trans_t	*tp;
 	int		xfs_bmapi_flags;
-	int		committed;
 	int		error;
 
 	if (len <= 0)
@@ -588,7 +585,7 @@ libxfs_alloc_file_space(
 			goto error0;
 
 		/* complete the transaction */
-		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		error = xfs_bmap_finish(&tp, &free_list, ip);
 		if (error)
 			goto error0;
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 5e79f3d..afe3dcb 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -200,7 +200,7 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	xfs_fsblock_t		firstblock;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
-	int			error, err2, committed, local;
+	int			error, err2, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
 
@@ -327,25 +327,15 @@ xfs_attr_set(
 		 */
 		xfs_bmap_init(args.flist, args.firstblock);
 		error = xfs_attr_shortform_to_leaf(&args);
-		if (!error) {
-			error = xfs_bmap_finish(&args.trans, args.flist,
-						&committed);
-		}
+		if (!error)
+			error = xfs_bmap_finish(&args.trans, args.flist, dp);
 		if (error) {
-			ASSERT(committed);
 			args.trans = NULL;
 			xfs_bmap_cancel(&flist);
 			goto out;
 		}
 
 		/*
-		 * bmap_finish() may have committed the last trans and started
-		 * a new one.  We need the inode to be in all transactions.
-		 */
-		if (committed)
-			xfs_trans_ijoin(args.trans, dp, 0);
-
-		/*
 		 * Commit the leaf transformation.  We'll need another (linked)
 		 * transaction to add the new attribute to the leaf.
 		 */
@@ -561,7 +551,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 {
 	xfs_inode_t *dp;
 	struct xfs_buf *bp;
-	int retval, error, committed, forkoff;
+	int retval, error, forkoff;
 
 	trace_xfs_attr_leaf_addname(args);
 
@@ -621,25 +611,15 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 */
 		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_attr3_leaf_to_node(args);
-		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
-		}
+		if (!error)
+			error = xfs_bmap_finish(&args->trans, args->flist, dp);
 		if (error) {
-			ASSERT(committed);
 			args->trans = NULL;
 			xfs_bmap_cancel(args->flist);
 			return error;
 		}
 
 		/*
-		 * bmap_finish() may have committed the last trans and started
-		 * a new one.  We need the inode to be in all transactions.
-		 */
-		if (committed)
-			xfs_trans_ijoin(args->trans, dp, 0);
-
-		/*
 		 * Commit the current trans (including the inode) and start
 		 * a new one.
 		 */
@@ -722,25 +702,14 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
-			if (!error) {
+			if (!error)
 				error = xfs_bmap_finish(&args->trans,
-							args->flist,
-							&committed);
-			}
+							args->flist, dp);
 			if (error) {
-				ASSERT(committed);
 				args->trans = NULL;
 				xfs_bmap_cancel(args->flist);
 				return error;
 			}
-
-			/*
-			 * bmap_finish() may have committed the last trans
-			 * and started a new one.  We need the inode to be
-			 * in all transactions.
-			 */
-			if (committed)
-				xfs_trans_ijoin(args->trans, dp, 0);
 		}
 
 		/*
@@ -768,7 +737,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 {
 	xfs_inode_t *dp;
 	struct xfs_buf *bp;
-	int error, committed, forkoff;
+	int error, forkoff;
 
 	trace_xfs_attr_leaf_removename(args);
 
@@ -796,23 +765,13 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
-		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
-		}
+		if (!error)
+			error = xfs_bmap_finish(&args->trans, args->flist, dp);
 		if (error) {
-			ASSERT(committed);
 			args->trans = NULL;
 			xfs_bmap_cancel(args->flist);
 			return error;
 		}
-
-		/*
-		 * bmap_finish() may have committed the last trans and started
-		 * a new one.  We need the inode to be in all transactions.
-		 */
-		if (committed)
-			xfs_trans_ijoin(args->trans, dp, 0);
 	}
 	return 0;
 }
@@ -870,7 +829,7 @@ xfs_attr_node_addname(xfs_da_args_t *args)
 	xfs_da_state_blk_t *blk;
 	xfs_inode_t *dp;
 	xfs_mount_t *mp;
-	int committed, retval, error;
+	int retval, error;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -931,27 +890,16 @@ restart:
 			state = NULL;
 			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr3_leaf_to_node(args);
-			if (!error) {
+			if (!error)
 				error = xfs_bmap_finish(&args->trans,
-							args->flist,
-							&committed);
-			}
+							args->flist, dp);
 			if (error) {
-				ASSERT(committed);
 				args->trans = NULL;
 				xfs_bmap_cancel(args->flist);
 				goto out;
 			}
 
 			/*
-			 * bmap_finish() may have committed the last trans
-			 * and started a new one.  We need the inode to be
-			 * in all transactions.
-			 */
-			if (committed)
-				xfs_trans_ijoin(args->trans, dp, 0);
-
-			/*
 			 * Commit the node conversion and start the next
 			 * trans in the chain.
 			 */
@@ -970,23 +918,13 @@ restart:
 		 */
 		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_da3_split(state);
-		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
-		}
+		if (!error)
+			error = xfs_bmap_finish(&args->trans, args->flist, dp);
 		if (error) {
-			ASSERT(committed);
 			args->trans = NULL;
 			xfs_bmap_cancel(args->flist);
 			goto out;
 		}
-
-		/*
-		 * bmap_finish() may have committed the last trans and started
-		 * a new one.  We need the inode to be in all transactions.
-		 */
-		if (committed)
-			xfs_trans_ijoin(args->trans, dp, 0);
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1079,25 +1017,14 @@ restart:
 		if (retval && (state->path.active > 1)) {
 			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_da3_join(state);
-			if (!error) {
+			if (!error)
 				error = xfs_bmap_finish(&args->trans,
-							args->flist,
-							&committed);
-			}
+							args->flist, dp);
 			if (error) {
-				ASSERT(committed);
 				args->trans = NULL;
 				xfs_bmap_cancel(args->flist);
 				goto out;
 			}
-
-			/*
-			 * bmap_finish() may have committed the last trans
-			 * and started a new one.  We need the inode to be
-			 * in all transactions.
-			 */
-			if (committed)
-				xfs_trans_ijoin(args->trans, dp, 0);
 		}
 
 		/*
@@ -1139,7 +1066,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	xfs_da_state_blk_t *blk;
 	xfs_inode_t *dp;
 	struct xfs_buf *bp;
-	int retval, error, committed, forkoff;
+	int retval, error, forkoff;
 
 	trace_xfs_attr_node_removename(args);
 
@@ -1213,24 +1140,13 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	if (retval && (state->path.active > 1)) {
 		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_da3_join(state);
-		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
-		}
+		if (!error)
+			error = xfs_bmap_finish(&args->trans, args->flist, dp);
 		if (error) {
-			ASSERT(committed);
 			args->trans = NULL;
 			xfs_bmap_cancel(args->flist);
 			goto out;
 		}
-
-		/*
-		 * bmap_finish() may have committed the last trans and started
-		 * a new one.  We need the inode to be in all transactions.
-		 */
-		if (committed)
-			xfs_trans_ijoin(args->trans, dp, 0);
-
 		/*
 		 * Commit the Btree join operation and start a new trans.
 		 */
@@ -1258,25 +1174,14 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
-			if (!error) {
+			if (!error)
 				error = xfs_bmap_finish(&args->trans,
-							args->flist,
-							&committed);
-			}
+							args->flist, dp);
 			if (error) {
-				ASSERT(committed);
 				args->trans = NULL;
 				xfs_bmap_cancel(args->flist);
 				goto out;
 			}
-
-			/*
-			 * bmap_finish() may have committed the last trans
-			 * and started a new one.  We need the inode to be
-			 * in all transactions.
-			 */
-			if (committed)
-				xfs_trans_ijoin(args->trans, dp, 0);
 		} else
 			xfs_trans_brelse(args->trans, bp);
 	}
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 95383e3..79d663e 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -443,8 +443,6 @@ xfs_attr_rmtval_set(
 	 * Roll through the "value", allocating blocks on disk as required.
 	 */
 	while (blkcnt > 0) {
-		int	committed;
-
 		/*
 		 * Allocate a single extent, up to the size of the value.
 		 *
@@ -462,24 +460,14 @@ xfs_attr_rmtval_set(
 		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
 				  blkcnt, XFS_BMAPI_ATTRFORK, args->firstblock,
 				  args->total, &map, &nmap, args->flist);
-		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
-		}
+		if (!error)
+			error = xfs_bmap_finish(&args->trans, args->flist, dp);
 		if (error) {
-			ASSERT(committed);
 			args->trans = NULL;
 			xfs_bmap_cancel(args->flist);
 			return error;
 		}
 
-		/*
-		 * bmap_finish() may have committed the last trans and started
-		 * a new one.  We need the inode to be in all transactions.
-		 */
-		if (committed)
-			xfs_trans_ijoin(args->trans, dp, 0);
-
 		ASSERT(nmap == 1);
 		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
 		       (map.br_startblock != HOLESTARTBLOCK));
@@ -610,31 +598,20 @@ xfs_attr_rmtval_remove(
 	blkcnt = args->rmtblkcnt;
 	done = 0;
 	while (!done) {
-		int committed;
-
 		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
 				    XFS_BMAPI_ATTRFORK, 1, args->firstblock,
 				    args->flist, &done);
-		if (!error) {
+		if (!error)
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
-		}
+						args->dp);
 		if (error) {
-			ASSERT(committed);
 			args->trans = NULL;
 			xfs_bmap_cancel(args->flist);
 			return error;
 		}
 
 		/*
-		 * bmap_finish() may have committed the last trans and started
-		 * a new one.  We need the inode to be in all transactions.
-		 */
-		if (committed)
-			xfs_trans_ijoin(args->trans, args->dp, 0);
-
-		/*
 		 * Close out trans and start the next one in the chain.
 		 */
 		error = xfs_trans_roll(&args->trans, args->dp);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index eb19133..8cb89bc 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1109,7 +1109,6 @@ xfs_bmap_add_attrfork(
 	xfs_trans_t		*tp;		/* transaction pointer */
 	int			blks;		/* space reservation */
 	int			version = 1;	/* superblock attr version */
-	int			committed;	/* xaction was committed */
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
 
@@ -1212,7 +1211,7 @@ xfs_bmap_add_attrfork(
 			xfs_log_sb(tp);
 	}
 
-	error = xfs_bmap_finish(&tp, &flist, &committed);
+	error = xfs_bmap_finish(&tp, &flist, NULL);
 	if (error)
 		goto bmap_cancel;
 	error = xfs_trans_commit(tp);
@@ -5949,7 +5948,6 @@ xfs_bmap_split_extent(
 	struct xfs_trans        *tp;
 	struct xfs_bmap_free    free_list;
 	xfs_fsblock_t           firstfsb;
-	int                     committed;
 	int                     error;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
@@ -5970,7 +5968,7 @@ xfs_bmap_split_extent(
 	if (error)
 		goto out;
 
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, NULL);
 	if (error)
 		goto out;
 
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index baec27d..6485403 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -195,7 +195,7 @@ void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_bmap_free *flist,
 			  xfs_fsblock_t bno, xfs_filblks_t len);
 void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
 int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
-			int *committed);
+			struct xfs_inode *ip);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
diff --git a/mkfs/proto.c b/mkfs/proto.c
index cb34b28..21960d5 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -358,7 +358,6 @@ parseproto(
 #define	IF_FIFO		6
 
 	char		*buf;
-	int		committed;
 	int		error;
 	xfs_fsblock_t	first;
 	int		flags;
@@ -481,7 +480,7 @@ parseproto(
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		libxfs_trans_log_inode(tp, ip, flags);
 
-		error = -libxfs_bmap_finish(&tp, &flist, &committed);
+		error = -libxfs_bmap_finish(&tp, &flist, ip);
 		if (error)
 			fail(_("Pre-allocated file creation failed"), error);
 		libxfs_trans_commit(tp);
@@ -563,7 +562,7 @@ parseproto(
 		}
 		newdirectory(mp, tp, ip, pip);
 		libxfs_trans_log_inode(tp, ip, flags);
-		error = -libxfs_bmap_finish(&tp, &flist, &committed);
+		error = -libxfs_bmap_finish(&tp, &flist, ip);
 		if (error)
 			fail(_("Directory creation failed"), error);
 		libxfs_trans_commit(tp);
@@ -589,7 +588,7 @@ parseproto(
 		fail(_("Unknown format"), EINVAL);
 	}
 	libxfs_trans_log_inode(tp, ip, flags);
-	error = -libxfs_bmap_finish(&tp, &flist, &committed);
+	error = -libxfs_bmap_finish(&tp, &flist, ip);
 	if (error) {
 		fail(_("Error encountered creating file from prototype file"),
 			error);
@@ -615,7 +614,6 @@ rtinit(
 	xfs_mount_t	*mp)
 {
 	xfs_fileoff_t	bno;
-	int		committed;
 	xfs_fileoff_t	ebno;
 	xfs_bmbt_irec_t	*ep;
 	int		error;
@@ -700,7 +698,7 @@ rtinit(
 		}
 	}
 
-	error = -libxfs_bmap_finish(&tp, &flist, &committed);
+	error = -libxfs_bmap_finish(&tp, &flist, rbmip);
 	if (error) {
 		fail(_("Completion of the realtime bitmap failed"), error);
 	}
@@ -735,7 +733,7 @@ rtinit(
 			bno += ep->br_blockcount;
 		}
 	}
-	error = -libxfs_bmap_finish(&tp, &flist, &committed);
+	error = -libxfs_bmap_finish(&tp, &flist, rsumip);
 	if (error) {
 		fail(_("Completion of the realtime summary failed"), error);
 	}
@@ -759,7 +757,7 @@ rtinit(
 			fail(_("Error initializing the realtime space"),
 				error);
 		}
-		error = -libxfs_bmap_finish(&tp, &flist, &committed);
+		error = -libxfs_bmap_finish(&tp, &flist, rbmip);
 		if (error) {
 			fail(_("Error completing the realtime space"), error);
 		}
diff --git a/repair/phase6.c b/repair/phase6.c
index 7680deb..eb36520 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -483,7 +483,6 @@ mk_rbmino(xfs_mount_t *mp)
 	xfs_fsblock_t	first;
 	int		i;
 	int		nmap;
-	int		committed;
 	int		error;
 	xfs_bmap_free_t	flist;
 	xfs_fileoff_t	bno;
@@ -578,7 +577,7 @@ mk_rbmino(xfs_mount_t *mp)
 			bno += ep->br_blockcount;
 		}
 	}
-	error = -libxfs_bmap_finish(&tp, &flist, &committed);
+	error = -libxfs_bmap_finish(&tp, &flist, ip);
 	if (error) {
 		do_error(
 		_("allocation of the realtime bitmap failed, error = %d\n"),
@@ -742,7 +741,6 @@ mk_rsumino(xfs_mount_t *mp)
 	xfs_fsblock_t	first;
 	int		i;
 	int		nmap;
-	int		committed;
 	int		error;
 	int		nsumblocks;
 	xfs_bmap_free_t	flist;
@@ -843,7 +841,7 @@ mk_rsumino(xfs_mount_t *mp)
 			bno += ep->br_blockcount;
 		}
 	}
-	error = -libxfs_bmap_finish(&tp, &flist, &committed);
+	error = -libxfs_bmap_finish(&tp, &flist, ip);
 	if (error) {
 		do_error(
 	_("allocation of the realtime summary ino failed, error = %d\n"),
@@ -947,7 +945,6 @@ mk_orphanage(xfs_mount_t *mp)
 	ino_tree_node_t	*irec;
 	int		ino_offset = 0;
 	int		i;
-	int		committed;
 	int		error;
 	xfs_bmap_free_t	flist;
 	const int	mode = 0755;
@@ -1059,7 +1056,7 @@ mk_orphanage(xfs_mount_t *mp)
 	libxfs_dir_init(tp, ip, pip);
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	error = -libxfs_bmap_finish(&tp, &flist, &committed);
+	error = -libxfs_bmap_finish(&tp, &flist, ip);
 	if (error) {
 		do_error(_("%s directory creation failed -- bmapf error %d\n"),
 			ORPHANAGE, error);
@@ -1090,7 +1087,6 @@ mv_orphanage(
 	xfs_fsblock_t		first;
 	xfs_bmap_free_t		flist;
 	int			err;
-	int			committed;
 	unsigned char		fname[MAXPATHLEN + 1];
 	int			nres;
 	int			incr;
@@ -1168,7 +1164,7 @@ mv_orphanage(
 			ino_p->i_d.di_nlink++;
 			libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
 
-			err = -libxfs_bmap_finish(&tp, &flist, &committed);
+			err = -libxfs_bmap_finish(&tp, &flist, ino_p);
 			if (err)
 				do_error(
 	_("bmap finish failed (err - %d), filesystem may be out of space\n"),
@@ -1215,7 +1211,7 @@ mv_orphanage(
 						err);
 			}
 
-			err = -libxfs_bmap_finish(&tp, &flist, &committed);
+			err = -libxfs_bmap_finish(&tp, &flist, ino_p);
 			if (err)
 				do_error(
 	_("bmap finish failed (%d), filesystem may be out of space\n"),
@@ -1254,7 +1250,7 @@ mv_orphanage(
 		ino_p->i_d.di_nlink = 1;
 		libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
 
-		err = -libxfs_bmap_finish(&tp, &flist, &committed);
+		err = -libxfs_bmap_finish(&tp, &flist, ino_p);
 		if (err)
 			do_error(
 	_("bmap finish failed (%d), filesystem may be out of space\n"),
@@ -1306,7 +1302,6 @@ longform_dir2_rebuild(
 	xfs_bmap_free_t		flist;
 	xfs_inode_t		pip;
 	dir_hash_ent_t		*p;
-	int			committed;
 	int			done;
 
 	/*
@@ -1356,7 +1351,7 @@ longform_dir2_rebuild(
 		goto out_bmap_cancel;
 	}
 
-	error = -libxfs_bmap_finish(&tp, &flist, &committed);
+	error = -libxfs_bmap_finish(&tp, &flist, ip);
 
 	libxfs_trans_commit(tp);
 
@@ -1391,7 +1386,7 @@ _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"
 			goto out_bmap_cancel;
 		}
 
-		error = -libxfs_bmap_finish(&tp, &flist, &committed);
+		error = -libxfs_bmap_finish(&tp, &flist, ip);
 		if (error) {
 			do_warn(
 	_("bmap finish failed (%d), filesystem may be out of space\n"),
@@ -1423,7 +1418,6 @@ dir2_kill_block(
 	struct xfs_buf	*bp)
 {
 	xfs_da_args_t	args;
-	int		committed;
 	int		error;
 	xfs_fsblock_t	firstblock;
 	xfs_bmap_free_t	flist;
@@ -1453,7 +1447,7 @@ dir2_kill_block(
 	if (error)
 		do_error(_("shrink_inode failed inode %" PRIu64 " block %u\n"),
 			ip->i_ino, da_bno);
-	libxfs_bmap_finish(&tp, &flist, &committed);
+	libxfs_bmap_finish(&tp, &flist, ip);
 	libxfs_trans_commit(tp);
 }
 
@@ -1479,7 +1473,6 @@ longform_dir2_entry_check_data(
 	xfs_dir2_leaf_entry_t	*blp;
 	struct xfs_buf		*bp;
 	xfs_dir2_block_tail_t	*btp;
-	int			committed;
 	struct xfs_dir2_data_hdr *d;
 	xfs_dir2_db_t		db;
 	xfs_dir2_data_entry_t	*dep;
@@ -1930,7 +1923,7 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 		libxfs_dir2_data_freescan(mp->m_dir_geo, M_DIROPS(mp), d, &i);
 	if (needlog)
 		libxfs_dir2_data_log_header(&da, bp);
-	libxfs_bmap_finish(&tp, &flist, &committed);
+	libxfs_bmap_finish(&tp, &flist, ip);
 	libxfs_trans_commit(tp);
 
 	/* record the largest free space in the freetab for later checking */
@@ -2851,7 +2844,7 @@ process_dir_inode(
 	xfs_inode_t		*ip;
 	xfs_trans_t		*tp;
 	dir_hash_tab_t		*hashtab;
-	int			need_dot, committed;
+	int			need_dot;
 	int			dirty, num_illegal, error, nres;
 
 	ino = XFS_AGINO_TO_INO(mp, agno, irec->ino_startnum + ino_offset);
@@ -2996,7 +2989,7 @@ process_dir_inode(
 
 		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-		error = -libxfs_bmap_finish(&tp, &flist, &committed);
+		error = -libxfs_bmap_finish(&tp, &flist, ip);
 		ASSERT(error == 0);
 		libxfs_trans_commit(tp);
 
@@ -3057,7 +3050,7 @@ process_dir_inode(
 
 			libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-			error = -libxfs_bmap_finish(&tp, &flist, &committed);
+			error = -libxfs_bmap_finish(&tp, &flist, ip);
 			ASSERT(error == 0);
 			libxfs_trans_commit(tp);
 		}
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
