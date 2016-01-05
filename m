Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A5F1B7F37
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 13:01:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 19B5FAC003
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 11:01:54 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 22HpYFETnYZxvPBg for <xfs@oss.sgi.com>;
	Tue, 05 Jan 2016 11:01:49 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 4ED3663C5FF0
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 13:01:49 -0600 (CST)
Subject: [PATCH V3] xfs: eliminate committed arg from xfs_bmap_finish
References: <56441B8E.6070603@redhat.com> <5644BEF8.6070201@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <568C131C.9080907@sandeen.net>
Date: Tue, 5 Jan 2016 13:01:48 -0600
MIME-Version: 1.0
In-Reply-To: <5644BEF8.6070201@sandeen.net>
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
---

 libxfs/xfs_attr.c        |  114 +++++------------------------------------------
 libxfs/xfs_attr_remote.c |   25 ----------
 libxfs/xfs_bmap.c        |    6 --
 libxfs/xfs_bmap.h        |    2 
 xfs_bmap_util.c          |   28 ++++-------
 xfs_dquot.c              |   12 ++--
 xfs_inode.c              |   22 ++-------
 xfs_iomap.c              |   10 +---
 xfs_rtalloc.c            |    3 -
 xfs_symlink.c            |   12 ----
 10 files changed, 50 insertions(+), 184 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f949818..e16aa32 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -207,7 +207,7 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	xfs_fsblock_t		firstblock;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
-	int			error, err2, committed, local;
+	int			error, err2, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
 
@@ -335,24 +335,15 @@ xfs_attr_set(
 		xfs_bmap_init(args.flist, args.firstblock);
 		error = xfs_attr_shortform_to_leaf(&args);
 		if (!error) {
-			error = xfs_bmap_finish(&args.trans, args.flist,
-						&committed);
+			error = xfs_bmap_finish(&args.trans, args.flist, dp);
 		}
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
@@ -568,7 +559,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 {
 	xfs_inode_t *dp;
 	struct xfs_buf *bp;
-	int retval, error, committed, forkoff;
+	int retval, error, forkoff;
 
 	trace_xfs_attr_leaf_addname(args);
 
@@ -629,24 +620,15 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_attr3_leaf_to_node(args);
 		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+			error = xfs_bmap_finish(&args->trans, args->flist, dp);
 		}
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
@@ -731,23 +713,13 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
-							args->flist,
-							&committed);
+							args->flist, dp);
 			}
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
@@ -775,7 +747,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 {
 	xfs_inode_t *dp;
 	struct xfs_buf *bp;
-	int error, committed, forkoff;
+	int error, forkoff;
 
 	trace_xfs_attr_leaf_removename(args);
 
@@ -804,22 +776,13 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+			error = xfs_bmap_finish(&args->trans, args->flist, dp);
 		}
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
@@ -877,7 +840,7 @@ xfs_attr_node_addname(xfs_da_args_t *args)
 	xfs_da_state_blk_t *blk;
 	xfs_inode_t *dp;
 	xfs_mount_t *mp;
-	int committed, retval, error;
+	int retval, error;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -940,25 +903,15 @@ restart:
 			error = xfs_attr3_leaf_to_node(args);
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
-							args->flist,
-							&committed);
+							args->flist, dp);
 			}
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
@@ -978,22 +931,13 @@ restart:
 		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_da3_split(state);
 		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+			error = xfs_bmap_finish(&args->trans, args->flist, dp);
 		}
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
@@ -1088,23 +1032,13 @@ restart:
 			error = xfs_da3_join(state);
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
-							args->flist,
-							&committed);
+							args->flist, dp);
 			}
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
@@ -1146,7 +1080,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	xfs_da_state_blk_t *blk;
 	xfs_inode_t *dp;
 	struct xfs_buf *bp;
-	int retval, error, committed, forkoff;
+	int retval, error, forkoff;
 
 	trace_xfs_attr_node_removename(args);
 
@@ -1221,23 +1155,13 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_da3_join(state);
 		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+			error = xfs_bmap_finish(&args->trans, args->flist, dp);
 		}
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
@@ -1267,23 +1191,13 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
-							args->flist,
-							&committed);
+							args->flist, dp);
 			}
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
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 5ab95ff..04fa02f 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -447,8 +447,6 @@ xfs_attr_rmtval_set(
 	 * Roll through the "value", allocating blocks on disk as required.
 	 */
 	while (blkcnt > 0) {
-		int	committed;
-
 		/*
 		 * Allocate a single extent, up to the size of the value.
 		 *
@@ -467,23 +465,14 @@ xfs_attr_rmtval_set(
 				  blkcnt, XFS_BMAPI_ATTRFORK, args->firstblock,
 				  args->total, &map, &nmap, args->flist);
 		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+			error = xfs_bmap_finish(&args->trans, args->flist, dp);
 		}
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
@@ -614,31 +603,21 @@ xfs_attr_rmtval_remove(
 	blkcnt = args->rmtblkcnt;
 	done = 0;
 	while (!done) {
-		int committed;
-
 		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
 				    XFS_BMAPI_ATTRFORK, 1, args->firstblock,
 				    args->flist, &done);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
+						args->dp);
 		}
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
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 119c242..f28fa3f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1111,7 +1111,6 @@ xfs_bmap_add_attrfork(
 	xfs_trans_t		*tp;		/* transaction pointer */
 	int			blks;		/* space reservation */
 	int			version = 1;	/* superblock attr version */
-	int			committed;	/* xaction was committed */
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
 
@@ -1214,7 +1213,7 @@ xfs_bmap_add_attrfork(
 			xfs_log_sb(tp);
 	}
 
-	error = xfs_bmap_finish(&tp, &flist, &committed);
+	error = xfs_bmap_finish(&tp, &flist, NULL);
 	if (error)
 		goto bmap_cancel;
 	error = xfs_trans_commit(tp);
@@ -5950,7 +5949,6 @@ xfs_bmap_split_extent(
 	struct xfs_trans        *tp;
 	struct xfs_bmap_free    free_list;
 	xfs_fsblock_t           firstfsb;
-	int                     committed;
 	int                     error;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
@@ -5971,7 +5969,7 @@ xfs_bmap_split_extent(
 	if (error)
 		goto out;
 
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, NULL);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index a160f8a..423a34e 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -195,7 +195,7 @@ void	xfs_bmap_add_free(xfs_fsblock_t bno, xfs_filblks_t len,
 		struct xfs_bmap_free *flist, struct xfs_mount *mp);
 void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
 int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
-			int *committed);
+			struct xfs_inode *ip);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index dbae649..c2a3b5f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -91,32 +91,32 @@ xfs_zero_extent(
  * last due to locking considerations.  We never free any extents in
  * the first transaction.
  *
- * Return 1 if the given transaction was committed and a new one
- * started, and 0 otherwise in the committed parameter.
+ * If an inode *ip is provided, rejoin it to the transaction if
+ * the transaction was committed.
  */
 int						/* error */
 xfs_bmap_finish(
 	struct xfs_trans		**tp,	/* transaction pointer addr */
 	struct xfs_bmap_free		*flist,	/* i/o: list extents to free */
-	int				*committed)/* xact committed or not */
+	xfs_inode_t			*ip)
 {
 	struct xfs_efd_log_item		*efd;	/* extent free data */
 	struct xfs_efi_log_item		*efi;	/* extent free intention */
 	int				error;	/* error return value */
+	int				committed;/* xact committed or not */
 	struct xfs_bmap_free_item	*free;	/* free extent item */
 	struct xfs_bmap_free_item	*next;	/* next item on free list */
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
-	if (flist->xbf_count == 0) {
-		*committed = 0;
+	if (flist->xbf_count == 0)
 		return 0;
-	}
+
 	efi = xfs_trans_get_efi(*tp, flist->xbf_count);
 	for (free = flist->xbf_first; free; free = free->xbfi_next)
 		xfs_trans_log_efi_extent(*tp, efi, free->xbfi_startblock,
 			free->xbfi_blockcount);
 
-	error = __xfs_trans_roll(tp, NULL, committed);
+	error = __xfs_trans_roll(tp, ip, &committed);
 	if (error) {
 		/*
 		 * If the transaction was committed, drop the EFD reference
@@ -128,16 +128,13 @@ xfs_bmap_finish(
 		 * transaction so we should return committed=1 even though we're
 		 * returning an error.
 		 */
-		if (*committed) {
+		if (committed) {
 			xfs_efi_release(efi);
 			xfs_force_shutdown((*tp)->t_mountp,
 				(error == -EFSCORRUPTED) ?
 					SHUTDOWN_CORRUPT_INCORE :
 					SHUTDOWN_META_IO_ERROR);
-		} else {
-			*committed = 1;
 		}
-
 		return error;
 	}
 
@@ -969,7 +966,6 @@ xfs_alloc_file_space(
 	xfs_bmbt_irec_t		imaps[1], *imapp;
 	xfs_bmap_free_t		free_list;
 	uint			qblocks, resblks, resrtextents;
-	int			committed;
 	int			error;
 
 	trace_xfs_alloc_file_space(ip);
@@ -1071,7 +1067,7 @@ xfs_alloc_file_space(
 		/*
 		 * Complete the transaction
 		 */
-		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		error = xfs_bmap_finish(&tp, &free_list, NULL);
 		if (error) {
 			goto error0;
 		}
@@ -1206,7 +1202,6 @@ xfs_free_file_space(
 	xfs_off_t		offset,
 	xfs_off_t		len)
 {
-	int			committed;
 	int			done;
 	xfs_fileoff_t		endoffset_fsb;
 	int			error;
@@ -1353,7 +1348,7 @@ xfs_free_file_space(
 		/*
 		 * complete the transaction
 		 */
-		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		error = xfs_bmap_finish(&tp, &free_list, NULL);
 		if (error) {
 			goto error0;
 		}
@@ -1434,7 +1429,6 @@ xfs_shift_file_space(
 	int			error;
 	struct xfs_bmap_free	free_list;
 	xfs_fsblock_t		first_block;
-	int			committed;
 	xfs_fileoff_t		stop_fsb;
 	xfs_fileoff_t		next_fsb;
 	xfs_fileoff_t		shift_fsb;
@@ -1526,7 +1520,7 @@ xfs_shift_file_space(
 		if (error)
 			goto out_bmap_cancel;
 
-		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		error = xfs_bmap_finish(&tp, &free_list, NULL);
 		if (error)
 			goto out_bmap_cancel;
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 7ac6c5c..d77ba0c 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -306,7 +306,7 @@ xfs_qm_dqalloc(
 	xfs_fsblock_t	firstblock;
 	xfs_bmap_free_t flist;
 	xfs_bmbt_irec_t map;
-	int		nmaps, error, committed;
+	int		nmaps, error;
 	xfs_buf_t	*bp;
 	xfs_trans_t	*tp = *tpp;
 
@@ -379,11 +379,11 @@ xfs_qm_dqalloc(
 
 	xfs_trans_bhold(tp, bp);
 
-	if ((error = xfs_bmap_finish(tpp, &flist, &committed))) {
+	if ((error = xfs_bmap_finish(tpp, &flist, NULL)))
 		goto error1;
-	}
 
-	if (committed) {
+	/* Transaction was committed? */
+	if (*tpp != tp) {
 		tp = *tpp;
 		xfs_trans_bjoin(tp, bp);
 	} else {
@@ -393,9 +393,9 @@ xfs_qm_dqalloc(
 	*O_bpp = bp;
 	return 0;
 
-      error1:
+error1:
 	xfs_bmap_cancel(&flist);
-      error0:
+error0:
 	xfs_iunlock(quotip, XFS_ILOCK_EXCL);
 
 	return error;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8ee3939..0116dd5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1143,7 +1143,6 @@ xfs_create(
 	xfs_bmap_free_t		free_list;
 	xfs_fsblock_t		first_block;
 	bool                    unlock_dp_on_error = false;
-	int			committed;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -1226,7 +1225,7 @@ xfs_create(
 	 * pointing to itself.
 	 */
 	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev,
-			       prid, resblks > 0, &ip, &committed);
+			       prid, resblks > 0, &ip, NULL);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1275,7 +1274,7 @@ xfs_create(
 	 */
 	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, NULL);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -1427,7 +1426,6 @@ xfs_link(
 	int			error;
 	xfs_bmap_free_t         free_list;
 	xfs_fsblock_t           first_block;
-	int			committed;
 	int			resblks;
 
 	trace_xfs_link(tdp, target_name);
@@ -1506,7 +1504,7 @@ xfs_link(
 		xfs_trans_set_sync(tp);
 	}
 
-	error = xfs_bmap_finish (&tp, &free_list, &committed);
+	error = xfs_bmap_finish (&tp, &free_list, NULL);
 	if (error) {
 		xfs_bmap_cancel(&free_list);
 		goto error_return;
@@ -1555,7 +1553,6 @@ xfs_itruncate_extents(
 	xfs_fileoff_t		first_unmap_block;
 	xfs_fileoff_t		last_block;
 	xfs_filblks_t		unmap_len;
-	int			committed;
 	int			error = 0;
 	int			done = 0;
 
@@ -1601,9 +1598,7 @@ xfs_itruncate_extents(
 		 * Duplicate the transaction that has the permanent
 		 * reservation and commit the old transaction.
 		 */
-		error = xfs_bmap_finish(&tp, &free_list, &committed);
-		if (committed)
-			xfs_trans_ijoin(tp, ip, 0);
+		error = xfs_bmap_finish(&tp, &free_list, ip);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -1774,7 +1769,6 @@ xfs_inactive_ifree(
 {
 	xfs_bmap_free_t		free_list;
 	xfs_fsblock_t		first_block;
-	int			committed;
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	int			error;
@@ -1841,7 +1835,7 @@ xfs_inactive_ifree(
 	 * Just ignore errors at this point.  There is nothing we can do except
 	 * to try to keep going. Make sure it's not a silent error.
 	 */
-	error = xfs_bmap_finish(&tp,  &free_list, &committed);
+	error = xfs_bmap_finish(&tp,  &free_list, NULL);
 	if (error) {
 		xfs_notice(mp, "%s: xfs_bmap_finish returned error %d",
 			__func__, error);
@@ -2523,7 +2517,6 @@ xfs_remove(
 	int                     error = 0;
 	xfs_bmap_free_t         free_list;
 	xfs_fsblock_t           first_block;
-	int			committed;
 	uint			resblks;
 
 	trace_xfs_remove(dp, name);
@@ -2624,7 +2617,7 @@ xfs_remove(
 	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
 		xfs_trans_set_sync(tp);
 
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, NULL);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -2701,7 +2694,6 @@ xfs_finish_rename(
 	struct xfs_trans	*tp,
 	struct xfs_bmap_free	*free_list)
 {
-	int			committed = 0;
 	int			error;
 
 	/*
@@ -2711,7 +2703,7 @@ xfs_finish_rename(
 	if (tp->t_mountp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
 		xfs_trans_set_sync(tp);
 
-	error = xfs_bmap_finish(&tp, free_list, &committed);
+	error = xfs_bmap_finish(&tp, free_list, NULL);
 	if (error) {
 		xfs_bmap_cancel(free_list);
 		xfs_trans_cancel(tp);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f4f5b43..ffc7baf 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -129,7 +129,6 @@ xfs_iomap_write_direct(
 	xfs_trans_t	*tp;
 	xfs_bmap_free_t free_list;
 	uint		qblocks, resblks, resrtextents;
-	int		committed;
 	int		error;
 	int		lockmode;
 	int		bmapi_flags = XFS_BMAPI_PREALLOC;
@@ -247,7 +246,7 @@ xfs_iomap_write_direct(
 	/*
 	 * Complete the transaction
 	 */
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, NULL);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -693,7 +692,7 @@ xfs_iomap_write_allocate(
 	xfs_bmap_free_t	free_list;
 	xfs_filblks_t	count_fsb;
 	xfs_trans_t	*tp;
-	int		nimaps, committed;
+	int		nimaps;
 	int		error = 0;
 	int		nres;
 
@@ -794,7 +793,7 @@ xfs_iomap_write_allocate(
 			if (error)
 				goto trans_cancel;
 
-			error = xfs_bmap_finish(&tp, &free_list, &committed);
+			error = xfs_bmap_finish(&tp, &free_list, NULL);
 			if (error)
 				goto trans_cancel;
 
@@ -852,7 +851,6 @@ xfs_iomap_write_unwritten(
 	xfs_bmap_free_t free_list;
 	xfs_fsize_t	i_size;
 	uint		resblks;
-	int		committed;
 	int		error;
 
 	trace_xfs_unwritten_convert(ip, offset, count);
@@ -924,7 +922,7 @@ xfs_iomap_write_unwritten(
 			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 		}
 
-		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		error = xfs_bmap_finish(&tp, &free_list, NULL);
 		if (error)
 			goto error_on_bmapi_transaction;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ab1bac6..be02a68 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -766,7 +766,6 @@ xfs_growfs_rt_alloc(
 {
 	xfs_fileoff_t		bno;		/* block number in file */
 	struct xfs_buf		*bp;	/* temporary buffer for zeroing */
-	int			committed;	/* transaction committed flag */
 	xfs_daddr_t		d;		/* disk block address */
 	int			error;		/* error return value */
 	xfs_fsblock_t		firstblock;/* first block allocated in xaction */
@@ -811,7 +810,7 @@ xfs_growfs_rt_alloc(
 		/*
 		 * Free any blocks freed up in the transaction, then commit.
 		 */
-		error = xfs_bmap_finish(&tp, &flist, &committed);
+		error = xfs_bmap_finish(&tp, &flist, NULL);
 		if (error)
 			goto out_bmap_cancel;
 		error = xfs_trans_commit(tp);
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 996481e..b44284c 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -178,7 +178,6 @@ xfs_symlink(
 	struct xfs_bmap_free	free_list;
 	xfs_fsblock_t		first_block;
 	bool                    unlock_dp_on_error = false;
-	int			committed;
 	xfs_fileoff_t		first_fsb;
 	xfs_filblks_t		fs_blocks;
 	int			nmaps;
@@ -387,7 +386,7 @@ xfs_symlink(
 		xfs_trans_set_sync(tp);
 	}
 
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, NULL);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -434,7 +433,6 @@ xfs_inactive_symlink_rmt(
 	struct xfs_inode *ip)
 {
 	xfs_buf_t	*bp;
-	int		committed;
 	int		done;
 	int		error;
 	xfs_fsblock_t	first_block;
@@ -510,16 +508,10 @@ xfs_inactive_symlink_rmt(
 	/*
 	 * Commit the first transaction.  This logs the EFI and the inode.
 	 */
-	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	error = xfs_bmap_finish(&tp, &free_list, ip);
 	if (error)
 		goto error_bmap_cancel;
 	/*
-	 * The transaction must have been committed, since there were
-	 * actually extents freed by xfs_bunmapi.  See xfs_bmap_finish.
-	 * The new tp has the extent freeing and EFDs.
-	 */
-	ASSERT(committed);
-	/*
 	 * The first xact was committed, so add the inode to the new one.
 	 * Mark it dirty so it will be logged and moved forward in the log as
 	 * part of every commit.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
