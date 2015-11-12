Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A64C7F55
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 10:32:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 92BF5AC002
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 08:31:57 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Ka9JCfRYZDVKlOEO for <xfs@oss.sgi.com>;
	Thu, 12 Nov 2015 08:31:53 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 059E165FC660
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 10:31:52 -0600 (CST)
Subject: [PATCH V2] xfs: create helper for bmap finish & trans join in attr
	code
References: <56441B8E.6070603@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5644BEF8.6070201@sandeen.net>
Date: Thu, 12 Nov 2015 10:31:52 -0600
MIME-Version: 1.0
In-Reply-To: <56441B8E.6070603@redhat.com>
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
the attribute code.

Factor out a new helper function, xfs_bmap_finish_and_join()
to take care of this.

This also fixes an ASSERT() test of an uninitialized variable
in several locations:

	error = xfs_attr_thing(&args);
	if (!error) {
		error = xfs_bmap_finish(&args.trans, args.flist,
					&committed);
	}
	if (error) {
		ASSERT(committed);

If the first xfs_attr_thing() failed, we'd skip the xfs_bmap_finish,
never set "committed", and then test it in the ASSERT.

Addresses-Coverity-Id: 102360
Addresses-Coverity-Id: 102361
Addresses-Coverity-Id: 102363
Addresses-Coverity-Id: 102364
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Do the same for xfs_attr_remote.c

->>> I don't think I broke the logic, but feel free to scrutinize it :)

 libxfs/xfs_attr.c        |  168 ++++++++++++-----------------------------------
 libxfs/xfs_attr_remote.c |   33 +--------
 xfs_attr.h               |    2 
 3 files changed, 52 insertions(+), 151 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f949818..1bd430e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -194,6 +194,28 @@ xfs_attr_calc_size(
 }
 
 int
+xfs_attr_bmap_finish_and_join(
+	struct xfs_da_args	*args,
+	struct xfs_inode	*dp)
+{
+	int			error, committed;
+
+	error = xfs_bmap_finish(&args->trans, args->flist, &committed);
+	if (error) {
+		ASSERT(committed);
+		return error;
+	}
+	/*
+	 * bmap_finish() may have committed the last trans and started
+	 * a new one.  We need the inode to be in all transactions.
+	 */
+	if (committed)
+		xfs_trans_ijoin(args->trans, dp, 0);
+
+	return 0;
+}
+
+int
 xfs_attr_set(
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
@@ -207,7 +229,7 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	xfs_fsblock_t		firstblock;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
-	int			error, err2, committed, local;
+	int			error, err2, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
 
@@ -334,25 +356,15 @@ xfs_attr_set(
 		 */
 		xfs_bmap_init(args.flist, args.firstblock);
 		error = xfs_attr_shortform_to_leaf(&args);
-		if (!error) {
-			error = xfs_bmap_finish(&args.trans, args.flist,
-						&committed);
-		}
+		if (!error)
+			error = xfs_attr_bmap_finish_and_join(&args, dp);
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
@@ -568,7 +580,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 {
 	xfs_inode_t *dp;
 	struct xfs_buf *bp;
-	int retval, error, committed, forkoff;
+	int retval, error, forkoff;
 
 	trace_xfs_attr_leaf_addname(args);
 
@@ -628,25 +640,15 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 */
 		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_attr3_leaf_to_node(args);
-		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
-		}
+		if (!error)
+			error = xfs_attr_bmap_finish_and_join(args, dp);
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
@@ -729,25 +731,13 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
-			if (!error) {
-				error = xfs_bmap_finish(&args->trans,
-							args->flist,
-							&committed);
-			}
+			if (!error)
+				error = xfs_attr_bmap_finish_and_join(args, dp);
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
@@ -775,7 +765,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 {
 	xfs_inode_t *dp;
 	struct xfs_buf *bp;
-	int error, committed, forkoff;
+	int error, forkoff;
 
 	trace_xfs_attr_leaf_removename(args);
 
@@ -803,23 +793,13 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
-		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
-		}
+		if (!error)
+			error = xfs_attr_bmap_finish_and_join(args, dp);
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
@@ -877,7 +857,7 @@ xfs_attr_node_addname(xfs_da_args_t *args)
 	xfs_da_state_blk_t *blk;
 	xfs_inode_t *dp;
 	xfs_mount_t *mp;
-	int committed, retval, error;
+	int retval, error;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -938,26 +918,13 @@ restart:
 			state = NULL;
 			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr3_leaf_to_node(args);
-			if (!error) {
-				error = xfs_bmap_finish(&args->trans,
-							args->flist,
-							&committed);
-			}
+			if (!error)
+				error = xfs_attr_bmap_finish_and_join(args, dp);
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
-
 			/*
 			 * Commit the node conversion and start the next
 			 * trans in the chain.
@@ -977,23 +944,13 @@ restart:
 		 */
 		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_da3_split(state);
-		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
-		}
+		if (!error)
+			error = xfs_attr_bmap_finish_and_join(args, dp);
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
@@ -1086,25 +1043,13 @@ restart:
 		if (retval && (state->path.active > 1)) {
 			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_da3_join(state);
-			if (!error) {
-				error = xfs_bmap_finish(&args->trans,
-							args->flist,
-							&committed);
-			}
+			if (!error)
+				error = xfs_attr_bmap_finish_and_join(args, dp);
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
@@ -1146,7 +1091,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	xfs_da_state_blk_t *blk;
 	xfs_inode_t *dp;
 	struct xfs_buf *bp;
-	int retval, error, committed, forkoff;
+	int retval, error, forkoff;
 
 	trace_xfs_attr_node_removename(args);
 
@@ -1220,24 +1165,13 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	if (retval && (state->path.active > 1)) {
 		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_da3_join(state);
-		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
-		}
+		if (!error)
+			error = xfs_attr_bmap_finish_and_join(args, dp);
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
@@ -1265,25 +1199,13 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
-			if (!error) {
-				error = xfs_bmap_finish(&args->trans,
-							args->flist,
-							&committed);
-			}
+			if (!error)
+				error = xfs_attr_bmap_finish_and_join(args, dp);
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
index f3ed9bf..b66a83e 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -448,8 +448,6 @@ xfs_attr_rmtval_set(
 	 * Roll through the "value", allocating blocks on disk as required.
 	 */
 	while (blkcnt > 0) {
-		int	committed;
-
 		/*
 		 * Allocate a single extent, up to the size of the value.
 		 *
@@ -467,24 +465,14 @@ xfs_attr_rmtval_set(
 		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
 				  blkcnt, XFS_BMAPI_ATTRFORK, args->firstblock,
 				  args->total, &map, &nmap, args->flist);
-		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
-		}
+		if (!error)
+			xfs_attr_bmap_finish_and_join(args, dp);
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
@@ -615,31 +603,20 @@ xfs_attr_rmtval_remove(
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
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
-		}
+		if (!error)
+			error = xfs_attr_bmap_finish_and_join(args, args->dp);
+
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
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index dd48245..18813d0 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -144,6 +144,8 @@ int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 		 unsigned char *value, int *valuelenp, int flags);
+int xfs_attr_bmap_finish_and_join(struct xfs_da_args *args,
+				  struct xfs_inode *dp);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 unsigned char *value, int valuelen, int flags);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
