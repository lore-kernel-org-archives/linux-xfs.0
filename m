Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4CLIvDV098768 for <xfs@oss.sgi.com>; Tue, 12 May 2009 16:18:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81AE91D2B1B0
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 14:19:04 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1uczDXSHdCoiDujQ for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 14:19:04 -0700 (PDT)
Message-Id: <20090512211903.947685000@bombadil.infradead.org>
Date: Tue, 12 May 2009 17:16:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 7/7] xfs: speed up free inode search
References: <20090512211607.197071000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-inode-search
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
Cc: Dave Chinner <dgc@sgi.com>

From: Dave Chinner <dgc@sgi.com>

Don't search too far - abort if it is outside a certain radius and simply do
a linear search for the first free inode.  In AGs with a million inodes this
can speed up allocation speed by 3-4x.

[hch: ported to the xfs_ialloc.c world order]

Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2009-05-12 23:09:37.446784120 +0200
+++ xfs/fs/xfs/xfs_ialloc.c	2009-05-12 23:11:53.140784530 +0200
@@ -587,6 +587,30 @@ xfs_ialloc_next_rec(
 	return 0;
 }
 
+STATIC int
+xfs_ialloc_get_rec(
+	struct xfs_btree_cur	*cur,
+	xfs_agino_t		agino,
+	xfs_inobt_rec_incore_t	*rec,
+	int			*done,
+	int			left)
+{
+	int                     error;
+	int			i;
+
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_EQ, &i);
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
 
 /*
  * Visible inode allocation functions.
@@ -766,6 +790,8 @@ nextag:
 	 */
 	agno = tagno;
 	*IO_agbp = NULL;
+
+ restart_pagno:
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, be32_to_cpu(agi->agi_seqno));
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
@@ -782,8 +808,10 @@ nextag:
 	 * If in the same AG as the parent, try to get near the parent.
 	 */
 	if (pagno == agno) {
+		xfs_perag_t	*pag = &mp->m_perag[agno];
 		int		doneleft;	/* done, to the left */
 		int		doneright;	/* done, to the right */
+		int		searchdistance = 10;
 
 		error = xfs_inobt_lookup(cur, pagino, XFS_LOOKUP_LE, &i);
 		if (error)
@@ -813,15 +841,33 @@ nextag:
 		if (error)
 			goto error0;
 
-		/* search left with tcur, back up 1 record */
-		error = xfs_ialloc_next_rec(tcur, &trec, &doneleft, 1);
-		if (error)
-			goto error1;
+		/*
+		 * Skip to last blocks looked up if same parent inode.
+		 */
+		if (pagino != NULLAGINO &&
+		    pag->pagl_pagino == pagino &&
+		    pag->pagl_leftrec != NULLAGINO &&
+		    pag->pagl_rightrec != NULLAGINO) {
+			error = xfs_ialloc_get_rec(tcur, pag->pagl_leftrec,
+						   &trec, &doneleft, 1);
+			if (error)
+				goto error1;
 
-		/* search right with cur, go forward 1 record. */
-		error = xfs_ialloc_next_rec(cur, &rec, &doneright, 0);
-		if (error)
-			goto error1;
+			error = xfs_ialloc_get_rec(cur, pag->pagl_rightrec,
+						   &rec, &doneright, 0);
+			if (error)
+				goto error1;
+		} else {
+			/* search left with tcur, back up 1 record */
+			error = xfs_ialloc_next_rec(tcur, &trec, &doneleft, 1);
+			if (error)
+				goto error1;
+
+			/* search right with cur, go forward 1 record. */
+			error = xfs_ialloc_next_rec(cur, &rec, &doneright, 0);
+			if (error)
+				goto error1;
+		}
 
 		/*
 		 * Loop until we find an inode chunk with a free inode.
@@ -829,6 +875,17 @@ nextag:
 		while (!doneleft || !doneright) {
 			int	useleft;  /* using left inode chunk this time */
 
+			if (!--searchdistance) {
+				/*
+				 * Not in range - save last search
+				 * location and allocate a new inode
+				 */
+				pag->pagl_leftrec = trec.ir_startino;
+				pag->pagl_rightrec = rec.ir_startino;
+				pag->pagl_pagino = pagino;
+				goto newino;
+			}
+
 			/* figure out the closer block if both are valid. */
 			if (!doneleft && !doneright) {
 				useleft = pagino -
@@ -843,12 +900,20 @@ nextag:
 				rec = trec;
 				xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 				cur = tcur;
+
+				pag->pagl_leftrec = trec.ir_startino;
+				pag->pagl_rightrec = rec.ir_startino;
+				pag->pagl_pagino = pagino;
 				goto alloc_inode;
 			}
 
 			/* free inodes to the right? */
 			if (!useleft && rec.ir_freecount) {
 				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+
+				pag->pagl_leftrec = trec.ir_startino;
+				pag->pagl_rightrec = rec.ir_startino;
+				pag->pagl_pagino = pagino;
 				goto alloc_inode;
 			}
 
@@ -861,14 +926,28 @@ nextag:
 								 &doneright, 0);
 			}
 		}
-		ASSERT(!doneleft || !doneright);
+
+		/*
+		 * We've reached the end of the btree. because
+		 * we are only searching a small chunk of the
+		 * btree each search, there is obviously free
+		 * inodes closer to the parent inode than we
+		 * are now. restart the search again.
+		 */
+		pag->pagl_pagino = NULLAGINO;
+		pag->pagl_leftrec = NULLAGINO;
+		pag->pagl_rightrec = NULLAGINO;
+		xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		goto restart_pagno;
 	}
 
 	/*
 	 * In a different AG from the parent.
 	 * See if the most recently allocated block has any free.
 	 */
-	else if (be32_to_cpu(agi->agi_newino) != NULLAGINO) {
+newino:
+	if (be32_to_cpu(agi->agi_newino) != NULLAGINO) {
 		error = xfs_inobt_lookup(cur, be32_to_cpu(agi->agi_newino),
 					 XFS_LOOKUP_EQ, &i);
 		if (error)
@@ -887,27 +966,27 @@ nextag:
 				goto alloc_inode;
 			}
 		}
+	}
 
-		/*
-		 * None left in the last group, search the whole AG
-		 */
-		error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
+	/*
+	 * None left in the last group, search the whole AG
+	 */
+	error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
+	if (error)
+		goto error0;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+	for (;;) {
+		error = xfs_inobt_get_rec(cur, &rec, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		if (rec.ir_freecount > 0)
+			break;
+		error = xfs_btree_increment(cur, 0, &i);
 		if (error)
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-
-		for (;;) {
-			error = xfs_inobt_get_rec(cur, &rec, &i);
-			if (error)
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			if (rec.ir_freecount > 0)
-				break;
-			error = xfs_btree_increment(cur, 0, &i);
-			if (error)
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		}
 	}
 
 alloc_inode:
Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2009-05-12 23:11:45.736784323 +0200
+++ xfs/fs/xfs/xfs_ag.h	2009-05-12 23:11:53.139784193 +0200
@@ -198,6 +198,15 @@ typedef struct xfs_perag
 	xfs_agino_t	pagi_count;	/* number of allocated inodes */
 	int		pagb_count;	/* pagb slots in use */
 	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
+
+	/*
+	 * Inode allocation search lookup optimisation.
+	 * If the pagino matches, the search for new inodes
+	 * doesn't need to search the near ones again straight away
+	 */
+	xfs_agino_t	pagl_pagino;
+	xfs_agino_t	pagl_leftrec;
+	xfs_agino_t	pagl_rightrec;
 #ifdef __KERNEL__
 	spinlock_t	pagb_lock;	/* lock for pagb_list */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
