Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 900747F5E
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 22:54:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 241AAAC001
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 20:54:42 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PDfXCDxViWxbAwpu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 20:54:40 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id E3B70C0A5170
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 04:54:39 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tAC4scnw032254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 23:54:39 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: create helper for bmap finish & trans join in xfs_attr.c
Message-ID: <56441B8E.6070603@redhat.com>
Date: Wed, 11 Nov 2015 22:54:38 -0600
MIME-Version: 1.0
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
xfs_attr.c.

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

->>> I don't think I broke the logic, but feel free to scrutinize it :)


 xfs_attr.c |  168 ++++++++++++++++---------------------------------------------
 1 file changed, 45 insertions(+), 123 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f949818..2fe1a3b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -193,6 +193,28 @@ xfs_attr_calc_size(
 	return nblks;
 }
 
+STATIC int
+xfs_bmap_finish_and_join(
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
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
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
+			error = xfs_bmap_finish_and_join(&args, dp);
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
+			error = xfs_bmap_finish_and_join(args, dp);
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
+				error = xfs_bmap_finish_and_join(args, dp);
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
+			error = xfs_bmap_finish_and_join(args, dp);
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
+				error = xfs_bmap_finish_and_join(args, dp);
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
+			error = xfs_bmap_finish_and_join(args, dp);
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
+				error = xfs_bmap_finish_and_join(args, dp);
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
+			error = xfs_bmap_finish_and_join(args, dp);
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
+				error = xfs_bmap_finish_and_join(args, dp);
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



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
