Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37072 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbdHMOmW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Aug 2017 10:42:22 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dgu5u-0003Ww-6S
        for linux-xfs@vger.kernel.org; Sun, 13 Aug 2017 14:42:22 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] xfs: refactor xfs_trans_roll
Date: Sun, 13 Aug 2017 16:42:14 +0200
Message-Id: <20170813144216.11192-2-hch@lst.de>
In-Reply-To: <20170813144216.11192-1-hch@lst.de>
References: <20170813144216.11192-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Split xfs_trans_roll into a low-level helper that just rolls the
actual transaction and a new higher level xfs_trans_roll_inode
that takes care of logging and rejoining the inode.  This gets
rid of the NULL inode case, and allows to simplify the special
cases in the deferred operation code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c        | 16 ++++++++--------
 fs/xfs/libxfs/xfs_attr_leaf.c   |  6 +++---
 fs/xfs/libxfs/xfs_attr_remote.c |  4 ++--
 fs/xfs/libxfs/xfs_defer.c       | 23 +++++++++--------------
 fs/xfs/xfs_attr_inactive.c      |  6 +++---
 fs/xfs/xfs_inode.c              |  4 ++--
 fs/xfs/xfs_trans.c              | 30 ++++++------------------------
 fs/xfs/xfs_trans.h              |  3 ++-
 fs/xfs/xfs_trans_inode.c        | 14 ++++++++++++++
 9 files changed, 49 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index de7b9bd30bec..bafa0f6bfafa 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -341,7 +341,7 @@ xfs_attr_set(
 		 * transaction to add the new attribute to the leaf.
 		 */
 
-		error = xfs_trans_roll(&args.trans, dp);
+		error = xfs_trans_roll_inode(&args.trans, dp);
 		if (error)
 			goto out;
 
@@ -605,7 +605,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * Commit the current trans (including the inode) and start
 		 * a new one.
 		 */
-		error = xfs_trans_roll(&args->trans, dp);
+		error = xfs_trans_roll_inode(&args->trans, dp);
 		if (error)
 			return error;
 
@@ -620,7 +620,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 	 * Commit the transaction that added the attr name so that
 	 * later routines can manage their own transactions.
 	 */
-	error = xfs_trans_roll(&args->trans, dp);
+	error = xfs_trans_roll_inode(&args->trans, dp);
 	if (error)
 		return error;
 
@@ -697,7 +697,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		/*
 		 * Commit the remove and start the next trans in series.
 		 */
-		error = xfs_trans_roll(&args->trans, dp);
+		error = xfs_trans_roll_inode(&args->trans, dp);
 
 	} else if (args->rmtblkno > 0) {
 		/*
@@ -885,7 +885,7 @@ xfs_attr_node_addname(xfs_da_args_t *args)
 			 * Commit the node conversion and start the next
 			 * trans in the chain.
 			 */
-			error = xfs_trans_roll(&args->trans, dp);
+			error = xfs_trans_roll_inode(&args->trans, dp);
 			if (error)
 				goto out;
 
@@ -925,7 +925,7 @@ xfs_attr_node_addname(xfs_da_args_t *args)
 	 * Commit the leaf addition or btree split and start the next
 	 * trans in the chain.
 	 */
-	error = xfs_trans_roll(&args->trans, dp);
+	error = xfs_trans_roll_inode(&args->trans, dp);
 	if (error)
 		goto out;
 
@@ -1012,7 +1012,7 @@ xfs_attr_node_addname(xfs_da_args_t *args)
 		/*
 		 * Commit and start the next trans in the chain.
 		 */
-		error = xfs_trans_roll(&args->trans, dp);
+		error = xfs_trans_roll_inode(&args->trans, dp);
 		if (error)
 			goto out;
 
@@ -1132,7 +1132,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 		/*
 		 * Commit the Btree join operation and start a new trans.
 		 */
-		error = xfs_trans_roll(&args->trans, dp);
+		error = xfs_trans_roll_inode(&args->trans, dp);
 		if (error)
 			goto out;
 	}
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index c6c15e5717e4..5c16db86b38f 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2608,7 +2608,7 @@ xfs_attr3_leaf_clearflag(
 	/*
 	 * Commit the flag value change and start the next trans in series.
 	 */
-	return xfs_trans_roll(&args->trans, args->dp);
+	return xfs_trans_roll_inode(&args->trans, args->dp);
 }
 
 /*
@@ -2659,7 +2659,7 @@ xfs_attr3_leaf_setflag(
 	/*
 	 * Commit the flag value change and start the next trans in series.
 	 */
-	return xfs_trans_roll(&args->trans, args->dp);
+	return xfs_trans_roll_inode(&args->trans, args->dp);
 }
 
 /*
@@ -2777,7 +2777,7 @@ xfs_attr3_leaf_flipflags(
 	/*
 	 * Commit the flag value change and start the next trans in series.
 	 */
-	error = xfs_trans_roll(&args->trans, args->dp);
+	error = xfs_trans_roll_inode(&args->trans, args->dp);
 
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 5236d8e45146..433c36714e40 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -484,7 +484,7 @@ xfs_attr_rmtval_set(
 		/*
 		 * Start the next trans in the chain.
 		 */
-		error = xfs_trans_roll(&args->trans, dp);
+		error = xfs_trans_roll_inode(&args->trans, dp);
 		if (error)
 			return error;
 	}
@@ -621,7 +621,7 @@ xfs_attr_rmtval_remove(
 		/*
 		 * Close out trans and start the next one in the chain.
 		 */
-		error = xfs_trans_roll(&args->trans, args->dp);
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5c2929f94bd3..87169bf56a09 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -240,23 +240,19 @@ xfs_defer_trans_abort(
 STATIC int
 xfs_defer_trans_roll(
 	struct xfs_trans		**tp,
-	struct xfs_defer_ops		*dop,
-	struct xfs_inode		*ip)
+	struct xfs_defer_ops		*dop)
 {
 	int				i;
 	int				error;
 
-	/* Log all the joined inodes except the one we passed in. */
-	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dop->dop_inodes[i]; i++) {
-		if (dop->dop_inodes[i] == ip)
-			continue;
+	/* Log all the joined inodes. */
+	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dop->dop_inodes[i]; i++)
 		xfs_trans_log_inode(*tp, dop->dop_inodes[i], XFS_ILOG_CORE);
-	}
 
 	trace_xfs_defer_trans_roll((*tp)->t_mountp, dop);
 
 	/* Roll the transaction. */
-	error = xfs_trans_roll(tp, ip);
+	error = __xfs_trans_roll(tp);
 	if (error) {
 		trace_xfs_defer_trans_roll_error((*tp)->t_mountp, dop, error);
 		xfs_defer_trans_abort(*tp, dop, error);
@@ -264,12 +260,9 @@ xfs_defer_trans_roll(
 	}
 	dop->dop_committed = true;
 
-	/* Rejoin the joined inodes except the one we passed in. */
-	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dop->dop_inodes[i]; i++) {
-		if (dop->dop_inodes[i] == ip)
-			continue;
+	/* Rejoin the joined inodes. */
+	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dop->dop_inodes[i]; i++)
 		xfs_trans_ijoin(*tp, dop->dop_inodes[i], 0);
-	}
 
 	return error;
 }
@@ -331,13 +324,15 @@ xfs_defer_finish(
 
 	trace_xfs_defer_finish((*tp)->t_mountp, dop);
 
+	xfs_defer_join(dop, ip);
+
 	/* Until we run out of pending work to finish... */
 	while (xfs_defer_has_unfinished_work(dop)) {
 		/* Log intents for work items sitting in the intake. */
 		xfs_defer_intake_work(*tp, dop);
 
 		/* Roll the transaction. */
-		error = xfs_defer_trans_roll(tp, dop, ip);
+		error = xfs_defer_trans_roll(tp, dop);
 		if (error)
 			goto out;
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index be0b79d8900f..ebd66b19fbfc 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -97,7 +97,7 @@ xfs_attr3_leaf_freextent(
 			/*
 			 * Roll to next transaction.
 			 */
-			error = xfs_trans_roll(trans, dp);
+			error = xfs_trans_roll_inode(trans, dp);
 			if (error)
 				return error;
 		}
@@ -308,7 +308,7 @@ xfs_attr3_node_inactive(
 		/*
 		 * Atomically commit the whole invalidate stuff.
 		 */
-		error = xfs_trans_roll(trans, dp);
+		error = xfs_trans_roll_inode(trans, dp);
 		if (error)
 			return  error;
 	}
@@ -375,7 +375,7 @@ xfs_attr3_root_inactive(
 	/*
 	 * Commit the invalidate and start the next transaction.
 	 */
-	error = xfs_trans_roll(trans, dp);
+	error = xfs_trans_roll_inode(trans, dp);
 
 	return error;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ceef77c0416a..6b9d56637a52 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1053,7 +1053,7 @@ xfs_dir_ialloc(
 			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
 		}
 
-		code = xfs_trans_roll(&tp, NULL);
+		code = __xfs_trans_roll(&tp);
 		if (committed != NULL)
 			*committed = 1;
 
@@ -1609,7 +1609,7 @@ xfs_itruncate_extents(
 		if (error)
 			goto out_bmap_cancel;
 
-		error = xfs_trans_roll(&tp, ip);
+		error = xfs_trans_roll_inode(&tp, ip);
 		if (error)
 			goto out;
 	}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 2011620008de..c43e78b5c035 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1034,26 +1034,19 @@ xfs_trans_cancel(
  * chunk we've been working on and get a new transaction to continue.
  */
 int
-xfs_trans_roll(
-	struct xfs_trans	**tpp,
-	struct xfs_inode	*dp)
+__xfs_trans_roll(
+	struct xfs_trans	**tpp)
 {
-	struct xfs_trans	*trans;
+	struct xfs_trans	*trans = *tpp;
 	struct xfs_trans_res	tres;
 	int			error;
 
 	/*
-	 * Ensure that the inode is always logged.
-	 */
-	trans = *tpp;
-	if (dp)
-		xfs_trans_log_inode(trans, dp, XFS_ILOG_CORE);
-
-	/*
 	 * Copy the critical parameters from one trans to the next.
 	 */
 	tres.tr_logres = trans->t_log_res;
 	tres.tr_logcount = trans->t_log_count;
+
 	*tpp = xfs_trans_dup(trans);
 
 	/*
@@ -1067,10 +1060,8 @@ xfs_trans_roll(
 	if (error)
 		return error;
 
-	trans = *tpp;
-
 	/*
-	 * Reserve space in the log for th next transaction.
+	 * Reserve space in the log for the next transaction.
 	 * This also pushes items in the "AIL", the list of logged items,
 	 * out to disk if they are taking up space at the tail of the log
 	 * that we want to use.  This requires that either nothing be locked
@@ -1078,14 +1069,5 @@ xfs_trans_roll(
 	 * the prior and the next transactions.
 	 */
 	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-	error = xfs_trans_reserve(trans, &tres, 0, 0);
-	/*
-	 *  Ensure that the inode is in the new transaction and locked.
-	 */
-	if (error)
-		return error;
-
-	if (dp)
-		xfs_trans_ijoin(trans, dp, 0);
-	return 0;
+	return xfs_trans_reserve(*tpp, &tres, 0, 0);
 }
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 6bdad6f58934..391d07afd5cb 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -224,7 +224,8 @@ int		xfs_trans_free_extent(struct xfs_trans *,
 				      struct xfs_efd_log_item *, xfs_fsblock_t,
 				      xfs_extlen_t, struct xfs_owner_info *);
 int		xfs_trans_commit(struct xfs_trans *);
-int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
+int		__xfs_trans_roll(struct xfs_trans **);
+int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
 void		xfs_trans_cancel(xfs_trans_t *);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index dab8daa676f9..92558108e677 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -134,3 +134,17 @@ xfs_trans_log_inode(
 	flags |= ip->i_itemp->ili_last_fields;
 	ip->i_itemp->ili_fields |= flags;
 }
+
+int
+xfs_trans_roll_inode(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip)
+{
+	int			error;
+
+	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+	error = __xfs_trans_roll(tpp);
+	if (!error)
+		xfs_trans_ijoin(*tpp, ip, 0);
+	return error;
+}
-- 
2.11.0

