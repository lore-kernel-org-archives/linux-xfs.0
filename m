Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4CLIv1N098763 for <xfs@oss.sgi.com>; Tue, 12 May 2009 16:18:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E18F1D2B1AD
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 14:19:04 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9RsTPC3x4FDCmeCw for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 14:19:04 -0700 (PDT)
Message-Id: <20090512211903.765192000@bombadil.infradead.org>
Date: Tue, 12 May 2009 17:16:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/7] xfs: rationalize xfs_inobt_lookup*
References: <20090512211607.197071000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-inobt-lookup
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Currenly we have a xfs_inobt_lookup* variant for each comparism direction,
and all these get all three fields of the inobt records passed, while the
common case is just looking for the inode number and we have only marginally
more callers than xfs_inobt_lookup* variants.

So opencode a direct call to xfs_btree_lookup for the single case where we
need all fields, and replace xfs_inobt_lookup* with a xfs_inobt_looku that
just takes the inode number and the direction for all other callers.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2009-02-25 20:16:04.395799709 +0100
+++ xfs/fs/xfs/xfs_ialloc.c	2009-02-25 20:16:10.253670750 +0100
@@ -57,56 +57,19 @@ xfs_ialloc_cluster_alignment(
 }
 
 /*
- * Lookup the record equal to ino in the btree given by cur.
+ * Lookup a record by ino in the btree given by cur.
  */
 STATIC int				/* error */
-xfs_inobt_lookup_eq(
+xfs_inobt_lookup(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agino_t		ino,	/* starting inode of chunk */
-	__int32_t		fcnt,	/* free inode count */
-	xfs_inofree_t		free,	/* free inode mask */
+	xfs_lookup_t		dir,	/* <=, >=, == */
 	int			*stat)	/* success/failure */
 {
 	cur->bc_rec.i.ir_startino = ino;
-	cur->bc_rec.i.ir_freecount = fcnt;
-	cur->bc_rec.i.ir_free = free;
-	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
-}
-
-/*
- * Lookup the first record greater than or equal to ino
- * in the btree given by cur.
- */
-int					/* error */
-xfs_inobt_lookup_ge(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_agino_t		ino,	/* starting inode of chunk */
-	__int32_t		fcnt,	/* free inode count */
-	xfs_inofree_t		free,	/* free inode mask */
-	int			*stat)	/* success/failure */
-{
-	cur->bc_rec.i.ir_startino = ino;
-	cur->bc_rec.i.ir_freecount = fcnt;
-	cur->bc_rec.i.ir_free = free;
-	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
-}
-
-/*
- * Lookup the first record less than or equal to ino
- * in the btree given by cur.
- */
-int					/* error */
-xfs_inobt_lookup_le(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_agino_t		ino,	/* starting inode of chunk */
-	__int32_t		fcnt,	/* free inode count */
-	xfs_inofree_t		free,	/* free inode mask */
-	int			*stat)	/* success/failure */
-{
-	cur->bc_rec.i.ir_startino = ino;
-	cur->bc_rec.i.ir_freecount = fcnt;
-	cur->bc_rec.i.ir_free = free;
-	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
+	cur->bc_rec.i.ir_freecount = 0;
+	cur->bc_rec.i.ir_free = 0;
+	return xfs_btree_lookup(cur, dir, stat);
 }
 
 /*
@@ -162,7 +125,7 @@ xfs_check_agi_freecount(
 		int		error;
 		int		i;
 
-		error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &i);
+		error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
 		if (error)
 			return error;
 
@@ -431,13 +394,17 @@ xfs_ialloc_ag_alloc(
 	for (thisino = newino;
 	     thisino < newino + newlen;
 	     thisino += XFS_INODES_PER_CHUNK) {
-		if ((error = xfs_inobt_lookup_eq(cur, thisino,
-				XFS_INODES_PER_CHUNK, XFS_INOBT_ALL_FREE, &i))) {
+		cur->bc_rec.i.ir_startino = thisino;
+		cur->bc_rec.i.ir_freecount = XFS_INODES_PER_CHUNK;
+		cur->bc_rec.i.ir_free = XFS_INOBT_ALL_FREE;
+		error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, &i);
+		if (error) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 			return error;
 		}
 		ASSERT(i == 0);
-		if ((error = xfs_btree_insert(cur, &i))) {
+		error = xfs_btree_insert(cur, &i);
+		if (error) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 			return error;
 		}
@@ -818,7 +785,7 @@ nextag:
 		int		doneleft;	/* done, to the left */
 		int		doneright;	/* done, to the right */
 
-		error = xfs_inobt_lookup_le(cur, pagino, 0, 0, &i);
+		error = xfs_inobt_lookup(cur, pagino, XFS_LOOKUP_LE, &i);
 		if (error)
 			goto error0;
 		XFS_WANT_CORRUPTED_RETURN(i == 1);
@@ -902,8 +869,8 @@ nextag:
 	 * See if the most recently allocated block has any free.
 	 */
 	else if (be32_to_cpu(agi->agi_newino) != NULLAGINO) {
-		error = xfs_inobt_lookup_eq(cur, be32_to_cpu(agi->agi_newino),
-					    0, 0, &i);
+		error = xfs_inobt_lookup(cur, be32_to_cpu(agi->agi_newino),
+					 XFS_LOOKUP_EQ, &i);
 		if (error)
 			goto error0;
 
@@ -924,7 +891,7 @@ nextag:
 		/*
 		 * None left in the last group, search the whole AG
 		 */
-		error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &i);
+		error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
 		if (error)
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
@@ -1063,9 +1030,9 @@ xfs_difree(
 	/*
 	 * Look for the entry describing this inode.
 	 */
-	if ((error = xfs_inobt_lookup_le(cur, agino, 0, 0, &i))) {
+	if ((error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i))) {
 		cmn_err(CE_WARN,
-			"xfs_difree: xfs_inobt_lookup_le returned()  an error %d on %s.  Returning error.",
+			"xfs_difree: xfs_inobt_lookup returned()  an error %d on %s.  Returning error.",
 			error, mp->m_fsname);
 		goto error0;
 	}
@@ -1275,10 +1242,10 @@ xfs_imap(
 		}
 
 		cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
-		error = xfs_inobt_lookup_le(cur, agino, 0, 0, &i);
+		error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
 		if (error) {
 			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
-					"xfs_inobt_lookup_le() failed");
+					"xfs_inobt_lookup() failed");
 			goto error0;
 		}
 
Index: xfs/fs/xfs/xfs_ialloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.h	2009-02-25 20:11:57.475795139 +0100
+++ xfs/fs/xfs/xfs_ialloc.h	2009-02-25 20:16:10.253670750 +0100
@@ -150,18 +150,10 @@ xfs_ialloc_pagi_init(
         xfs_agnumber_t  agno);		/* allocation group number */
 
 /*
- * Lookup the first record greater than or equal to ino
- * in the btree given by cur.
+ * Lookup a record by ino in the btree given by cur.
  */
-int xfs_inobt_lookup_ge(struct xfs_btree_cur *cur, xfs_agino_t ino,
-		__int32_t fcnt,	xfs_inofree_t free, int *stat);
-
-/*
- * Lookup the first record less than or equal to ino
- * in the btree given by cur.
- */
-int xfs_inobt_lookup_le(struct xfs_btree_cur *cur, xfs_agino_t ino,
-		__int32_t fcnt,	xfs_inofree_t free, int *stat);
+int xfs_inobt_lookup(struct xfs_btree_cur *cur, xfs_agino_t ino,
+		xfs_lookup_t dir, int *stat);
 
 /*
  * Get the data from the pointed-to record.
Index: xfs/fs/xfs/xfs_itable.c
===================================================================
--- xfs.orig/fs/xfs/xfs_itable.c	2009-02-25 20:11:57.484695574 +0100
+++ xfs/fs/xfs/xfs_itable.c	2009-02-25 20:16:10.254670179 +0100
@@ -444,7 +444,8 @@ xfs_bulkstat(
 			/*
 			 * Lookup the inode chunk that this inode lives in.
 			 */
-			error = xfs_inobt_lookup_le(cur, agino, 0, 0, &tmp);
+			error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE,
+						 &tmp);
 			if (!error &&	/* no I/O error */
 			    tmp &&	/* lookup succeeded */
 					/* got the record, should always work */
@@ -492,7 +493,7 @@ xfs_bulkstat(
 			/*
 			 * Start of ag.  Lookup the first inode chunk.
 			 */
-			error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &tmp);
+			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &tmp);
 			icount = 0;
 		}
 		/*
@@ -511,8 +512,8 @@ xfs_bulkstat(
 				if (XFS_AGINO_TO_AGBNO(mp, agino) >=
 						be32_to_cpu(agi->agi_length))
 					break;
-				error = xfs_inobt_lookup_ge(cur, agino, 0, 0,
-							    &tmp);
+				error = xfs_inobt_lookup(cur, agino,
+							 XFS_LOOKUP_GE, &tmp);
 				cond_resched();
 			}
 			/*
@@ -858,7 +859,8 @@ xfs_inumbers(
 				continue;
 			}
 			cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno);
-			error = xfs_inobt_lookup_ge(cur, agino, 0, 0, &tmp);
+			error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE,
+						 &tmp);
 			if (error) {
 				xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 				cur = NULL;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
