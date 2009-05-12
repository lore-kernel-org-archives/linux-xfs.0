Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4CLIu2n098745 for <xfs@oss.sgi.com>; Tue, 12 May 2009 16:18:56 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 415BD27F6D8
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 14:19:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7fCku3lG58xQOsxE for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 14:19:03 -0700 (PDT)
Message-Id: <20090512211902.592264000@bombadil.infradead.org>
Date: Tue, 12 May 2009 17:16:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/7] xfs: improve xfs_inobt_get_rec prototype
References: <20090512211607.197071000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-better-xfs_inobt_get_rec-prototype
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

Most callers of xfs_inobt_get_rec need to fill a xfs_inobt_rec_incore_t, and
those who don't yet are fine with a xfs_inobt_rec_incore_t, instead of the
three individual variables, too.  So just change xfs_inobt_get_rec to write
the output into a xfs_inobt_rec_incore_t directly.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2009-05-12 22:42:28.693659122 +0200
+++ xfs/fs/xfs/xfs_ialloc.c	2009-05-12 22:45:59.518658886 +0200
@@ -135,9 +135,7 @@ xfs_inobt_update(
 int					/* error */
 xfs_inobt_get_rec(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_agino_t		*ino,	/* output: starting inode of chunk */
-	__int32_t		*fcnt,	/* output: number of free inodes */
-	xfs_inofree_t		*free,	/* output: free inode mask */
+	xfs_inobt_rec_incore_t	*irec,	/* btree record */
 	int			*stat)	/* output: success/failure */
 {
 	union xfs_btree_rec	*rec;
@@ -145,9 +143,9 @@ xfs_inobt_get_rec(
 
 	error = xfs_btree_get_rec(cur, &rec, stat);
 	if (!error && *stat == 1) {
-		*ino = be32_to_cpu(rec->inobt.ir_startino);
-		*fcnt = be32_to_cpu(rec->inobt.ir_freecount);
-		*free = be64_to_cpu(rec->inobt.ir_free);
+		irec->ir_startino = be32_to_cpu(rec->inobt.ir_startino);
+		irec->ir_freecount = be32_to_cpu(rec->inobt.ir_freecount);
+		irec->ir_free = be64_to_cpu(rec->inobt.ir_free);
 	}
 	return error;
 }
@@ -746,8 +744,8 @@ nextag:
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		do {
-			if ((error = xfs_inobt_get_rec(cur, &rec.ir_startino,
-					&rec.ir_freecount, &rec.ir_free, &i)))
+			error = xfs_inobt_get_rec(cur, &rec, &i);
+			if (error)
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			freecount += rec.ir_freecount;
@@ -766,8 +764,7 @@ nextag:
 		if ((error = xfs_inobt_lookup_le(cur, pagino, 0, 0, &i)))
 			goto error0;
 		if (i != 0 &&
-		    (error = xfs_inobt_get_rec(cur, &rec.ir_startino,
-			    &rec.ir_freecount, &rec.ir_free, &j)) == 0 &&
+		    (error = xfs_inobt_get_rec(cur, &rec, &j)) == 0 &&
 		    j == 1 &&
 		    rec.ir_freecount > 0) {
 			/*
@@ -799,10 +796,8 @@ nextag:
 				goto error1;
 			doneleft = !i;
 			if (!doneleft) {
-				if ((error = xfs_inobt_get_rec(tcur,
-						&trec.ir_startino,
-						&trec.ir_freecount,
-						&trec.ir_free, &i)))
+				error = xfs_inobt_get_rec(tcur, &trec, &i);
+				if (error)
 					goto error1;
 				XFS_WANT_CORRUPTED_GOTO(i == 1, error1);
 			}
@@ -813,10 +808,8 @@ nextag:
 				goto error1;
 			doneright = !i;
 			if (!doneright) {
-				if ((error = xfs_inobt_get_rec(cur,
-						&rec.ir_startino,
-						&rec.ir_freecount,
-						&rec.ir_free, &i)))
+				error = xfs_inobt_get_rec(cur, &rec, &i);
+				if (error)
 					goto error1;
 				XFS_WANT_CORRUPTED_GOTO(i == 1, error1);
 			}
@@ -876,11 +869,9 @@ nextag:
 						goto error1;
 					doneleft = !i;
 					if (!doneleft) {
-						if ((error = xfs_inobt_get_rec(
-							    tcur,
-							    &trec.ir_startino,
-							    &trec.ir_freecount,
-							    &trec.ir_free, &i)))
+						error = xfs_inobt_get_rec(
+							    tcur, &trec, &i);
+						if (error)
 							goto error1;
 						XFS_WANT_CORRUPTED_GOTO(i == 1,
 							error1);
@@ -896,11 +887,9 @@ nextag:
 						goto error1;
 					doneright = !i;
 					if (!doneright) {
-						if ((error = xfs_inobt_get_rec(
-							    cur,
-							    &rec.ir_startino,
-							    &rec.ir_freecount,
-							    &rec.ir_free, &i)))
+						error = xfs_inobt_get_rec(
+							    cur, &rec, &i);
+						if (error)
 							goto error1;
 						XFS_WANT_CORRUPTED_GOTO(i == 1,
 							error1);
@@ -919,8 +908,7 @@ nextag:
 				be32_to_cpu(agi->agi_newino), 0, 0, &i)))
 			goto error0;
 		if (i == 1 &&
-		    (error = xfs_inobt_get_rec(cur, &rec.ir_startino,
-			    &rec.ir_freecount, &rec.ir_free, &j)) == 0 &&
+		    (error = xfs_inobt_get_rec(cur, &rec, &j)) == 0 &&
 		    j == 1 &&
 		    rec.ir_freecount > 0) {
 			/*
@@ -938,10 +926,8 @@ nextag:
 				goto error0;
 			ASSERT(i == 1);
 			for (;;) {
-				if ((error = xfs_inobt_get_rec(cur,
-						&rec.ir_startino,
-						&rec.ir_freecount, &rec.ir_free,
-						&i)))
+				error = xfs_inobt_get_rec(cur, &rec, &i);
+				if (error)
 					goto error0;
 				XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 				if (rec.ir_freecount > 0)
@@ -975,8 +961,8 @@ nextag:
 		if ((error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &i)))
 			goto error0;
 		do {
-			if ((error = xfs_inobt_get_rec(cur, &rec.ir_startino,
-					&rec.ir_freecount, &rec.ir_free, &i)))
+			error = xfs_inobt_get_rec(cur, &rec, &i);
+			if (error)
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			freecount += rec.ir_freecount;
@@ -1084,8 +1070,8 @@ xfs_difree(
 		if ((error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &i)))
 			goto error0;
 		do {
-			if ((error = xfs_inobt_get_rec(cur, &rec.ir_startino,
-					&rec.ir_freecount, &rec.ir_free, &i)))
+			error = xfs_inobt_get_rec(cur, &rec, &i);
+			if (error)
 				goto error0;
 			if (i) {
 				freecount += rec.ir_freecount;
@@ -1107,8 +1093,8 @@ xfs_difree(
 		goto error0;
 	}
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-	if ((error = xfs_inobt_get_rec(cur, &rec.ir_startino, &rec.ir_freecount,
-			&rec.ir_free, &i))) {
+	error = xfs_inobt_get_rec(cur, &rec, &i);
+	if (error) {
 		cmn_err(CE_WARN,
 			"xfs_difree: xfs_inobt_get_rec()  returned an error %d on %s.  Returning error.",
 			error, mp->m_fsname);
@@ -1187,10 +1173,8 @@ xfs_difree(
 		if ((error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &i)))
 			goto error0;
 		do {
-			if ((error = xfs_inobt_get_rec(cur,
-					&rec.ir_startino,
-					&rec.ir_freecount,
-					&rec.ir_free, &i)))
+			error = xfs_inobt_get_rec(cur, &rec, &i);
+			if (error)
 				goto error0;
 			if (i) {
 				freecount += rec.ir_freecount;
@@ -1312,9 +1296,7 @@ xfs_imap(
 		chunk_agbno = agbno - offset_agbno;
 	} else {
 		xfs_btree_cur_t	*cur;	/* inode btree cursor */
-		xfs_agino_t	chunk_agino; /* first agino in inode chunk */
-		__int32_t	chunk_cnt; /* count of free inodes in chunk */
-		xfs_inofree_t	chunk_free; /* mask of free inodes in chunk */
+		xfs_inobt_rec_incore_t chunk_rec;
 		xfs_buf_t	*agbp;	/* agi buffer */
 		int		i;	/* temp state */
 
@@ -1337,8 +1319,7 @@ xfs_imap(
 			goto error0;
 		}
 
-		error = xfs_inobt_get_rec(cur, &chunk_agino, &chunk_cnt,
-				&chunk_free, &i);
+		error = xfs_inobt_get_rec(cur, &chunk_rec, &i);
 		if (error) {
 			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
 					"xfs_inobt_get_rec() failed");
@@ -1356,7 +1337,7 @@ xfs_imap(
 		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 		if (error)
 			return error;
-		chunk_agbno = XFS_AGINO_TO_AGBNO(mp, chunk_agino);
+		chunk_agbno = XFS_AGINO_TO_AGBNO(mp, chunk_rec.ir_startino);
 		offset_agbno = agbno - chunk_agbno;
 	}
 
Index: xfs/fs/xfs/xfs_ialloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.h	2009-05-12 22:42:25.220812390 +0200
+++ xfs/fs/xfs/xfs_ialloc.h	2009-05-12 22:45:59.518658886 +0200
@@ -166,7 +166,7 @@ int xfs_inobt_lookup_le(struct xfs_btree
 /*
  * Get the data from the pointed-to record.
  */
-extern int xfs_inobt_get_rec(struct xfs_btree_cur *cur, xfs_agino_t *ino,
-			     __int32_t *fcnt, xfs_inofree_t *free, int *stat);
+extern int xfs_inobt_get_rec(struct xfs_btree_cur *cur,
+		xfs_inobt_rec_incore_t *rec, int *stat);
 
 #endif	/* __XFS_IALLOC_H__ */
Index: xfs/fs/xfs/xfs_itable.c
===================================================================
--- xfs.orig/fs/xfs/xfs_itable.c	2009-05-12 22:42:25.233785061 +0200
+++ xfs/fs/xfs/xfs_itable.c	2009-05-12 22:45:59.519658874 +0200
@@ -353,9 +353,6 @@ xfs_bulkstat(
 	int			end_of_ag; /* set if we've seen the ag end */
 	int			error;	/* error code */
 	int                     fmterror;/* bulkstat formatter result */
-	__int32_t		gcnt;	/* current btree rec's count */
-	xfs_inofree_t		gfree;	/* current btree rec's free mask */
-	xfs_agino_t		gino;	/* current btree rec's start inode */
 	int			i;	/* loop index */
 	int			icount;	/* count of inodes good in irbuf */
 	size_t			irbsize; /* size of irec buffer in bytes */
@@ -442,6 +439,8 @@ xfs_bulkstat(
 		 * we need to get the remainder of the chunk we're in.
 		 */
 		if (agino > 0) {
+			xfs_inobt_rec_incore_t r;
+
 			/*
 			 * Lookup the inode chunk that this inode lives in.
 			 */
@@ -449,33 +448,33 @@ xfs_bulkstat(
 			if (!error &&	/* no I/O error */
 			    tmp &&	/* lookup succeeded */
 					/* got the record, should always work */
-			    !(error = xfs_inobt_get_rec(cur, &gino, &gcnt,
-				    &gfree, &i)) &&
+			    !(error = xfs_inobt_get_rec(cur, &r, &i)) &&
 			    i == 1 &&
 					/* this is the right chunk */
-			    agino < gino + XFS_INODES_PER_CHUNK &&
+			    agino < r.ir_startino + XFS_INODES_PER_CHUNK &&
 					/* lastino was not last in chunk */
-			    (chunkidx = agino - gino + 1) <
+			    (chunkidx = agino - r.ir_startino + 1) <
 				    XFS_INODES_PER_CHUNK &&
 					/* there are some left allocated */
 			    xfs_inobt_maskn(chunkidx,
-				    XFS_INODES_PER_CHUNK - chunkidx) & ~gfree) {
+				    XFS_INODES_PER_CHUNK - chunkidx) &
+				    ~r.ir_free) {
 				/*
 				 * Grab the chunk record.  Mark all the
 				 * uninteresting inodes (because they're
 				 * before our start point) free.
 				 */
 				for (i = 0; i < chunkidx; i++) {
-					if (XFS_INOBT_MASK(i) & ~gfree)
-						gcnt++;
+					if (XFS_INOBT_MASK(i) & ~r.ir_free)
+						r.ir_freecount++;
 				}
-				gfree |= xfs_inobt_maskn(0, chunkidx);
-				irbp->ir_startino = gino;
-				irbp->ir_freecount = gcnt;
-				irbp->ir_free = gfree;
+				r.ir_free |= xfs_inobt_maskn(0, chunkidx);
+				irbp->ir_startino = r.ir_startino;
+				irbp->ir_freecount = r.ir_freecount;
+				irbp->ir_free = r.ir_free;
 				irbp++;
-				agino = gino + XFS_INODES_PER_CHUNK;
-				icount = XFS_INODES_PER_CHUNK - gcnt;
+				agino = r.ir_startino + XFS_INODES_PER_CHUNK;
+				icount = XFS_INODES_PER_CHUNK - r.ir_freecount;
 			} else {
 				/*
 				 * If any of those tests failed, bump the
@@ -501,6 +500,8 @@ xfs_bulkstat(
 		 * until we run out of inodes or space in the buffer.
 		 */
 		while (irbp < irbufend && icount < ubcount) {
+			xfs_inobt_rec_incore_t r;
+
 			/*
 			 * Loop as long as we're unable to read the
 			 * inode btree.
@@ -518,43 +519,47 @@ xfs_bulkstat(
 			 * If ran off the end of the ag either with an error,
 			 * or the normal way, set end and stop collecting.
 			 */
-			if (error ||
-			    (error = xfs_inobt_get_rec(cur, &gino, &gcnt,
-				    &gfree, &i)) ||
-			    i == 0) {
+			if (error) {
+				end_of_ag = 1;
+				break;
+			}
+
+			error = xfs_inobt_get_rec(cur, &r, &i);
+			if (error || i == 0) {
 				end_of_ag = 1;
 				break;
 			}
+
 			/*
 			 * If this chunk has any allocated inodes, save it.
 			 * Also start read-ahead now for this chunk.
 			 */
-			if (gcnt < XFS_INODES_PER_CHUNK) {
+			if (r.ir_freecount < XFS_INODES_PER_CHUNK) {
 				/*
 				 * Loop over all clusters in the next chunk.
 				 * Do a readahead if there are any allocated
 				 * inodes in that cluster.
 				 */
-				for (agbno = XFS_AGINO_TO_AGBNO(mp, gino),
-				     chunkidx = 0;
+				agbno = XFS_AGINO_TO_AGBNO(mp, r.ir_startino);
+				for (chunkidx = 0;
 				     chunkidx < XFS_INODES_PER_CHUNK;
 				     chunkidx += nicluster,
 				     agbno += nbcluster) {
-					if (xfs_inobt_maskn(chunkidx,
-							    nicluster) & ~gfree)
+					if (xfs_inobt_maskn(chunkidx, nicluster)
+							& ~r.ir_free)
 						xfs_btree_reada_bufs(mp, agno,
 							agbno, nbcluster);
 				}
-				irbp->ir_startino = gino;
-				irbp->ir_freecount = gcnt;
-				irbp->ir_free = gfree;
+				irbp->ir_startino = r.ir_startino;
+				irbp->ir_freecount = r.ir_freecount;
+				irbp->ir_free = r.ir_free;
 				irbp++;
-				icount += XFS_INODES_PER_CHUNK - gcnt;
+				icount += XFS_INODES_PER_CHUNK - r.ir_freecount;
 			}
 			/*
 			 * Set agino to after this chunk and bump the cursor.
 			 */
-			agino = gino + XFS_INODES_PER_CHUNK;
+			agino = r.ir_startino + XFS_INODES_PER_CHUNK;
 			error = xfs_btree_increment(cur, 0, &tmp);
 			cond_resched();
 		}
@@ -820,9 +825,7 @@ xfs_inumbers(
 	int		bufidx;
 	xfs_btree_cur_t	*cur;
 	int		error;
-	__int32_t	gcnt;
-	xfs_inofree_t	gfree;
-	xfs_agino_t	gino;
+	xfs_inobt_rec_incore_t r;
 	int		i;
 	xfs_ino_t	ino;
 	int		left;
@@ -870,9 +873,8 @@ xfs_inumbers(
 				continue;
 			}
 		}
-		if ((error = xfs_inobt_get_rec(cur, &gino, &gcnt, &gfree,
-			&i)) ||
-		    i == 0) {
+		error = xfs_inobt_get_rec(cur, &r, &i);
+		if (error || i == 0) {
 			xfs_buf_relse(agbp);
 			agbp = NULL;
 			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
@@ -881,10 +883,12 @@ xfs_inumbers(
 			agino = 0;
 			continue;
 		}
-		agino = gino + XFS_INODES_PER_CHUNK - 1;
-		buffer[bufidx].xi_startino = XFS_AGINO_TO_INO(mp, agno, gino);
-		buffer[bufidx].xi_alloccount = XFS_INODES_PER_CHUNK - gcnt;
-		buffer[bufidx].xi_allocmask = ~gfree;
+		agino = r.ir_startino + XFS_INODES_PER_CHUNK - 1;
+		buffer[bufidx].xi_startino =
+			XFS_AGINO_TO_INO(mp, agno, r.ir_startino);
+		buffer[bufidx].xi_alloccount =
+			XFS_INODES_PER_CHUNK - r.ir_freecount;
+		buffer[bufidx].xi_allocmask = ~r.ir_free;
 		bufidx++;
 		left--;
 		if (bufidx == bcount) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
