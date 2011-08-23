Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7N8TFZg164718 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 03:29:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7431C1392309
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 01:31:53 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	kpVh1MJhGb3KJyed for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 01:31:53 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QvmMC-000624-Nx
	for xfs@oss.sgi.com; Tue, 23 Aug 2011 08:29:12 +0000
Message-Id: <20110823082912.696841224@bombadil.infradead.org>
Date: Tue, 23 Aug 2011 04:28:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/11] xfs: let xfs_bwrite callers handle the xfs_buf_relse
References: <20110823082802.335389799@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bwrite-dont-unlock
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

Remove the xfs_buf_relse from xfs_bwrite and let the caller handle it to
mirror the delwri and read paths.

Also remove the mount pointer passed to xfs_bwrite, which is superflous now
that we have a mount pointer in the buftarg.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-08-13 06:37:41.257300430 -0700
+++ xfs/fs/xfs/xfs_buf.c	2011-08-13 06:38:15.950445815 -0700
@@ -1014,7 +1014,6 @@ xfs_buf_ioerror(
 
 int
 xfs_bwrite(
-	struct xfs_mount	*mp,
 	struct xfs_buf		*bp)
 {
 	int			error;
@@ -1026,9 +1025,10 @@ xfs_bwrite(
 	xfs_bdstrat_cb(bp);
 
 	error = xfs_buf_iowait(bp);
-	if (error)
-		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
-	xfs_buf_relse(bp);
+	if (error) {
+		xfs_force_shutdown(bp->b_target->bt_mount,
+				   SHUTDOWN_META_IO_ERROR);
+	}
 	return error;
 }
 
Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2011-08-13 06:37:41.257300430 -0700
+++ xfs/fs/xfs/xfs_buf.h	2011-08-13 06:38:15.950445815 -0700
@@ -197,7 +197,7 @@ extern void xfs_buf_unlock(xfs_buf_t *);
 	((bp)->b_sema.count <= 0)
 
 /* Buffer Read and Write Routines */
-extern int xfs_bwrite(struct xfs_mount *mp, struct xfs_buf *bp);
+extern int xfs_bwrite(struct xfs_buf *bp);
 
 extern void xfsbdstrat(struct xfs_mount *, struct xfs_buf *);
 extern int xfs_bdstrat_cb(struct xfs_buf *);
Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2011-08-13 06:35:33.177994295 -0700
+++ xfs/fs/xfs/xfs_sync.c	2011-08-13 06:38:15.950445815 -0700
@@ -322,6 +322,7 @@ xfs_sync_fsdata(
 	struct xfs_mount	*mp)
 {
 	struct xfs_buf		*bp;
+	int			error;
 
 	/*
 	 * If the buffer is pinned then push on the log so we won't get stuck
@@ -334,8 +335,9 @@ xfs_sync_fsdata(
 	bp = xfs_getsb(mp, 0);
 	if (xfs_buf_ispinned(bp))
 		xfs_log_force(mp, 0);
-
-	return xfs_bwrite(mp, bp);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	return error;
 }
 
 /*
Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-08-13 06:37:41.260633745 -0700
+++ xfs/fs/xfs/xfs_dquot.c	2011-08-13 06:38:15.953779130 -0700
@@ -1242,11 +1242,11 @@ xfs_qm_dqflush(
 	}
 
 	if (flags & SYNC_WAIT)
-		error = xfs_bwrite(mp, bp);
-	else {
+		error = xfs_bwrite(bp);
+	else
 		xfs_buf_delwri_queue(bp);
-		xfs_buf_relse(bp);
-	}
+
+	xfs_buf_relse(bp);
 
 	trace_xfs_dqflush_done(dqp);
 
Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2011-08-13 06:37:41.000000000 -0700
+++ xfs/fs/xfs/xfs_attr.c	2011-08-13 06:38:15.957112445 -0700
@@ -2128,9 +2128,10 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		xfs_buf_iomove(bp, 0, tmp, src, XBRW_WRITE);
 		if (tmp < XFS_BUF_SIZE(bp))
 			xfs_buf_zero(bp, tmp, XFS_BUF_SIZE(bp) - tmp);
-		if ((error = xfs_bwrite(mp, bp))) {/* GROT: NOTE: synchronous write */
-			return (error);
-		}
+		error = xfs_bwrite(bp);	/* GROT: NOTE: synchronous write */
+		xfs_buf_relse(bp);
+		if (error)
+			return error;
 		src += tmp;
 		valuelen -= tmp;
 
Index: xfs/fs/xfs/xfs_fsops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fsops.c	2011-08-13 06:35:14.000000000 -0700
+++ xfs/fs/xfs/xfs_fsops.c	2011-08-13 06:38:15.957112445 -0700
@@ -216,10 +216,11 @@ xfs_growfs_data_private(
 		tmpsize = agsize - XFS_PREALLOC_BLOCKS(mp);
 		agf->agf_freeblks = cpu_to_be32(tmpsize);
 		agf->agf_longest = cpu_to_be32(tmpsize);
-		error = xfs_bwrite(mp, bp);
-		if (error) {
+		error = xfs_bwrite(bp);
+		xfs_buf_relse(bp);
+		if (error)
 			goto error0;
-		}
+
 		/*
 		 * AG inode header block
 		 */
@@ -240,10 +241,11 @@ xfs_growfs_data_private(
 		agi->agi_dirino = cpu_to_be32(NULLAGINO);
 		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
 			agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
-		error = xfs_bwrite(mp, bp);
-		if (error) {
+		error = xfs_bwrite(bp);
+		xfs_buf_relse(bp);
+		if (error)
 			goto error0;
-		}
+
 		/*
 		 * BNO btree root block
 		 */
@@ -262,10 +264,11 @@ xfs_growfs_data_private(
 		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
 		arec->ar_blockcount = cpu_to_be32(
 			agsize - be32_to_cpu(arec->ar_startblock));
-		error = xfs_bwrite(mp, bp);
-		if (error) {
+		error = xfs_bwrite(bp);
+		xfs_buf_relse(bp);
+		if (error)
 			goto error0;
-		}
+
 		/*
 		 * CNT btree root block
 		 */
@@ -285,10 +288,11 @@ xfs_growfs_data_private(
 		arec->ar_blockcount = cpu_to_be32(
 			agsize - be32_to_cpu(arec->ar_startblock));
 		nfree += be32_to_cpu(arec->ar_blockcount);
-		error = xfs_bwrite(mp, bp);
-		if (error) {
+		error = xfs_bwrite(bp);
+		xfs_buf_relse(bp);
+		if (error)
 			goto error0;
-		}
+
 		/*
 		 * INO btree root block
 		 */
@@ -303,10 +307,10 @@ xfs_growfs_data_private(
 		block->bb_numrecs = 0;
 		block->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
 		block->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
-		error = xfs_bwrite(mp, bp);
-		if (error) {
+		error = xfs_bwrite(bp);
+		xfs_buf_relse(bp);
+		if (error)
 			goto error0;
-		}
 	}
 	xfs_trans_agblocks_delta(tp, nfree);
 	/*
@@ -396,9 +400,9 @@ xfs_growfs_data_private(
 		 * just issue a warning and continue.  The real work is
 		 * already done and committed.
 		 */
-		if (!(error = xfs_bwrite(mp, bp))) {
-			continue;
-		} else {
+		error = xfs_bwrite(bp);
+		xfs_buf_relse(bp);
+		if (error) {
 			xfs_warn(mp,
 		"write error %d updating secondary superblock for ag %d",
 				error, agno);
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-08-13 06:37:41.000000000 -0700
+++ xfs/fs/xfs/xfs_inode.c	2011-08-13 06:38:15.960445760 -0700
@@ -2597,11 +2597,11 @@ xfs_iflush(
 		goto cluster_corrupt_out;
 
 	if (flags & SYNC_WAIT)
-		error = xfs_bwrite(mp, bp);
-	else {
+		error = xfs_bwrite(bp);
+	else
 		xfs_buf_delwri_queue(bp);
-		xfs_buf_relse(bp);
-	}
+
+	xfs_buf_relse(bp);
 	return error;
 
 corrupt_out:
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2011-08-13 06:37:41.000000000 -0700
+++ xfs/fs/xfs/xfs_log_recover.c	2011-08-13 06:38:15.960445760 -0700
@@ -268,9 +268,12 @@ xlog_bwrite(
 	xfs_buf_lock(bp);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
 
-	if ((error = xfs_bwrite(log->l_mp, bp)))
+	error = xfs_bwrite(bp);
+	if (error) {
 		xfs_ioerror_alert("xlog_bwrite", log->l_mp,
 				  bp, XFS_BUF_ADDR(bp));
+	}
+	xfs_buf_relse(bp);
 	return error;
 }
 
@@ -2172,15 +2175,15 @@ xlog_recover_buffer_pass2(
 	    (XFS_BUF_COUNT(bp) != MAX(log->l_mp->m_sb.sb_blocksize,
 			(__uint32_t)XFS_INODE_CLUSTER_SIZE(log->l_mp)))) {
 		XFS_BUF_STALE(bp);
-		error = xfs_bwrite(mp, bp);
+		error = xfs_bwrite(bp);
 	} else {
 		ASSERT(bp->b_target->bt_mount == mp);
 		bp->b_iodone = xlog_recover_iodone;
 		xfs_buf_delwri_queue(bp);
-		xfs_buf_relse(bp);
 	}
 
-	return (error);
+	xfs_buf_relse(bp);
+	return error;
 }
 
 STATIC int

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
