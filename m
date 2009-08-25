Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7PItqkh218221 for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 13:56:08 -0500
Date: Tue, 25 Aug 2009 14:56:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] inode allocation cleanups
Message-ID: <20090825185644.GA21563@infradead.org>
References: <20090824153030.GA19864@infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE83ABCE@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABCE@cf--amer001e--3.americas.sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Aug 25, 2009 at 12:57:16PM -0500, Alex Elder wrote:
> # [PATCH 5/7] xfs: untangle xfs_dialloc   Christoph Hellwig
>     No cursor cleanup on WANT_CORRUPTED_RETURN() just after "if (pagno == agno)".
>     (Maybe I'm misreading the patch.)  I realize this is still better than the
>     ASSERT() in place currently, but maybe it should be WANT_CORRUPTED_GOTO(error0)
>     instead.

Good catch, the two in xfs_dialloc should indeed be WANT_CORRUPTED_GOTOs.
For the one in xfs_ialloc_next_rec.


Below is the updated version of the patch, still needs to run through
XFSQA again:


Subject: xfs: untangle xfs_dialloc
From: Christoph Hellwig <hch@lst.de>

Clarify the control flow in xfs_dialloc.  Factor out a helper to go to the
next node from the current one and improve the control flow by expanding
composite if statements and using gotos.

The xfs_ialloc_next_rec helper is borrowed from Dave Chinners dynamic
allocation policy patches.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2009-08-25 15:48:34.426442643 -0300
+++ xfs/fs/xfs/xfs_ialloc.c	2009-08-25 15:54:56.312444853 -0300
@@ -589,6 +589,37 @@ nextag:
 	}
 }
 
+/*
+ * Try to retrieve the next record to the left/right from the current one.
+ */
+STATIC int
+xfs_ialloc_next_rec(
+	struct xfs_btree_cur	*cur,
+	xfs_inobt_rec_incore_t	*rec,
+	int			*done,
+	int			left)
+{
+	int                     error;
+	int			i;
+
+	if (left)
+		error = xfs_btree_decrement(cur, 0, &i);
+	else
+		error = xfs_btree_increment(cur, 0, &i);
+
+	if (error)
+		return error;
+	*done = !i;
+	if (i) {
+		error = xfs_inobt_get_rec(cur, rec, &i);
+		if (error)
+			return error;
+		XFS_WANT_CORRUPTED_RETURN(i == 1);
+	}
+
+	return 0;
+}
+
 
 /*
  * Visible inode allocation functions.
@@ -644,8 +675,8 @@ xfs_dialloc(
 	int		j;		/* result code */
 	xfs_mount_t	*mp;		/* file system mount structure */
 	int		offset;		/* index of inode in chunk */
-	xfs_agino_t	pagino;		/* parent's a.g. relative inode # */
-	xfs_agnumber_t	pagno;		/* parent's allocation group number */
+	xfs_agino_t	pagino;		/* parent's AG relative inode # */
+	xfs_agnumber_t	pagno;		/* parent's AG number */
 	xfs_inobt_rec_incore_t rec;	/* inode allocation record */
 	xfs_agnumber_t	tagno;		/* testing allocation group number */
 	xfs_btree_cur_t	*tcur;		/* temp cursor */
@@ -781,186 +812,140 @@ nextag:
 		goto error0;
 
 	/*
-	 * If in the same a.g. as the parent, try to get near the parent.
+	 * If in the same AG as the parent, try to get near the parent.
 	 */
 	if (pagno == agno) {
-		if ((error = xfs_inobt_lookup_le(cur, pagino, 0, 0, &i)))
+		int		doneleft;	/* done, to the left */
+		int		doneright;	/* done, to the right */
+
+		error = xfs_inobt_lookup_le(cur, pagino, 0, 0, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		error = xfs_inobt_get_rec(cur, &rec, &j);
+		if (error)
 			goto error0;
-		if (i != 0 &&
-		    (error = xfs_inobt_get_rec(cur, &rec, &j)) == 0 &&
-		    j == 1 &&
-		    rec.ir_freecount > 0) {
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		if (rec.ir_freecount > 0) {
 			/*
 			 * Found a free inode in the same chunk
-			 * as parent, done.
+			 * as the parent, done.
 			 */
+			goto alloc_inode;
 		}
+
+
 		/*
-		 * In the same a.g. as parent, but parent's chunk is full.
+		 * In the same AG as parent, but parent's chunk is full.
 		 */
-		else {
-			int	doneleft;	/* done, to the left */
-			int	doneright;	/* done, to the right */
 
-			if (error)
-				goto error0;
-			ASSERT(i == 1);
-			ASSERT(j == 1);
-			/*
-			 * Duplicate the cursor, search left & right
-			 * simultaneously.
-			 */
-			if ((error = xfs_btree_dup_cursor(cur, &tcur)))
-				goto error0;
-			/*
-			 * Search left with tcur, back up 1 record.
-			 */
-			if ((error = xfs_btree_decrement(tcur, 0, &i)))
-				goto error1;
-			doneleft = !i;
-			if (!doneleft) {
-				error = xfs_inobt_get_rec(tcur, &trec, &i);
-				if (error)
-					goto error1;
-				XFS_WANT_CORRUPTED_GOTO(i == 1, error1);
+		/* duplicate the cursor, search left & right simultaneously */
+		error = xfs_btree_dup_cursor(cur, &tcur);
+		if (error)
+			goto error0;
+
+		/* search left with tcur, back up 1 record */
+		error = xfs_ialloc_next_rec(tcur, &trec, &doneleft, 1);
+		if (error)
+			goto error1;
+
+		/* search right with cur, go forward 1 record. */
+		error = xfs_ialloc_next_rec(cur, &rec, &doneright, 0);
+		if (error)
+			goto error1;
+
+		/*
+		 * Loop until we find an inode chunk with a free inode.
+		 */
+		while (!doneleft || !doneright) {
+			int	useleft;  /* using left inode chunk this time */
+
+			/* figure out the closer block if both are valid. */
+			if (!doneleft && !doneright) {
+				useleft = pagino -
+				 (trec.ir_startino + XFS_INODES_PER_CHUNK - 1) <
+				  rec.ir_startino - pagino;
+			} else {
+				useleft = !doneleft;
 			}
-			/*
-			 * Search right with cur, go forward 1 record.
-			 */
-			if ((error = xfs_btree_increment(cur, 0, &i)))
-				goto error1;
-			doneright = !i;
-			if (!doneright) {
-				error = xfs_inobt_get_rec(cur, &rec, &i);
-				if (error)
-					goto error1;
-				XFS_WANT_CORRUPTED_GOTO(i == 1, error1);
+
+			/* free inodes to the left? */
+			if (useleft && trec.ir_freecount) {
+				rec = trec;
+				xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+				cur = tcur;
+				goto alloc_inode;
 			}
-			/*
-			 * Loop until we find the closest inode chunk
-			 * with a free one.
-			 */
-			while (!doneleft || !doneright) {
-				int	useleft;  /* using left inode
-						     chunk this time */
 
-				/*
-				 * Figure out which block is closer,
-				 * if both are valid.
-				 */
-				if (!doneleft && !doneright)
-					useleft =
-						pagino -
-						(trec.ir_startino +
-						 XFS_INODES_PER_CHUNK - 1) <
-						 rec.ir_startino - pagino;
-				else
-					useleft = !doneleft;
-				/*
-				 * If checking the left, does it have
-				 * free inodes?
-				 */
-				if (useleft && trec.ir_freecount) {
-					/*
-					 * Yes, set it up as the chunk to use.
-					 */
-					rec = trec;
-					xfs_btree_del_cursor(cur,
-						XFS_BTREE_NOERROR);
-					cur = tcur;
-					break;
-				}
-				/*
-				 * If checking the right, does it have
-				 * free inodes?
-				 */
-				if (!useleft && rec.ir_freecount) {
-					/*
-					 * Yes, it's already set up.
-					 */
-					xfs_btree_del_cursor(tcur,
-						XFS_BTREE_NOERROR);
-					break;
-				}
-				/*
-				 * If used the left, get another one
-				 * further left.
-				 */
-				if (useleft) {
-					if ((error = xfs_btree_decrement(tcur, 0,
-							&i)))
-						goto error1;
-					doneleft = !i;
-					if (!doneleft) {
-						error = xfs_inobt_get_rec(
-							    tcur, &trec, &i);
-						if (error)
-							goto error1;
-						XFS_WANT_CORRUPTED_GOTO(i == 1,
-							error1);
-					}
-				}
-				/*
-				 * If used the right, get another one
-				 * further right.
-				 */
-				else {
-					if ((error = xfs_btree_increment(cur, 0,
-							&i)))
-						goto error1;
-					doneright = !i;
-					if (!doneright) {
-						error = xfs_inobt_get_rec(
-							    cur, &rec, &i);
-						if (error)
-							goto error1;
-						XFS_WANT_CORRUPTED_GOTO(i == 1,
-							error1);
-					}
-				}
+			/* free inodes to the right? */
+			if (!useleft && rec.ir_freecount) {
+				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+				goto alloc_inode;
 			}
-			ASSERT(!doneleft || !doneright);
+
+			/* get next record to check */
+			if (useleft) {
+				error = xfs_ialloc_next_rec(tcur, &trec,
+								 &doneleft, 1);
+			} else {
+				error = xfs_ialloc_next_rec(cur, &rec,
+								 &doneright, 0);
+			}
+			if (error)
+				goto error1;
 		}
+		ASSERT(!doneleft || !doneright);
 	}
+
 	/*
-	 * In a different a.g. from the parent.
+	 * In a different AG from the parent.
 	 * See if the most recently allocated block has any free.
 	 */
 	else if (be32_to_cpu(agi->agi_newino) != NULLAGINO) {
-		if ((error = xfs_inobt_lookup_eq(cur,
-				be32_to_cpu(agi->agi_newino), 0, 0, &i)))
+		error = xfs_inobt_lookup_eq(cur, be32_to_cpu(agi->agi_newino),
+					    0, 0, &i);
+		if (error)
 			goto error0;
-		if (i == 1 &&
-		    (error = xfs_inobt_get_rec(cur, &rec, &j)) == 0 &&
-		    j == 1 &&
-		    rec.ir_freecount > 0) {
-			/*
-			 * The last chunk allocated in the group still has
-			 * a free inode.
-			 */
+
+		if (i == 1) {
+			error = xfs_inobt_get_rec(cur, &rec, &j);
+			if (error)
+				goto error0;
+
+			if (j == 1 && rec.ir_freecount > 0) {
+				/*
+				 * The last chunk allocated in the group
+				 * still has a free inode.
+				 */
+				goto alloc_inode;
+			}
 		}
+
 		/*
-		 * None left in the last group, search the whole a.g.
+		 * None left in the last group, search the whole AG
 		 */
-		else {
+		error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		for (;;) {
+			error = xfs_inobt_get_rec(cur, &rec, &i);
 			if (error)
 				goto error0;
-			if ((error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &i)))
+			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+			if (rec.ir_freecount > 0)
+				break;
+			error = xfs_btree_increment(cur, 0, &i);
+			if (error)
 				goto error0;
-			ASSERT(i == 1);
-			for (;;) {
-				error = xfs_inobt_get_rec(cur, &rec, &i);
-				if (error)
-					goto error0;
-				XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-				if (rec.ir_freecount > 0)
-					break;
-				if ((error = xfs_btree_increment(cur, 0, &i)))
-					goto error0;
-				XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			}
+			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		}
 	}
+
+alloc_inode:
 	offset = xfs_ialloc_find_free(&rec.ir_free);
 	ASSERT(offset >= 0);
 	ASSERT(offset < XFS_INODES_PER_CHUNK);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
