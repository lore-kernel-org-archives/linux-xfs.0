Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6G1MfpW228191 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:22:41 -0500
Received: from e3.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0ADA475A4F
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:22:40 -0700 (PDT)
Received: from e3.ny.us.ibm.com (e3.ny.us.ibm.com [32.97.182.143]) by
	cuda.sgi.com with ESMTP id G2OSFxdmgYd09eAq for
	<xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:22:40 -0700 (PDT)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6G0xHQb028542
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:59:17 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6G1LO5K168424 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:21:24 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6G1LOp0025477 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 22:21:24 -0300
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 15 Jul 2011 18:21:22 -0700
Message-Id: <20110716012122.6629.95933.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 03/12] xfs: Remove the macro XFS_BUF_ERROR and family
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Remove the definitions and usage of the macros XFS_BUF_ERROR,
XFS_BUF_GETERROR and XFS_BUF_ISERROR.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    6 +++---
 fs/xfs/linux-2.6/xfs_buf.h |    4 ----
 fs/xfs/quota/xfs_dquot.c   |    2 +-
 fs/xfs/xfs_alloc.c         |    6 +++---
 fs/xfs/xfs_attr.c          |    2 +-
 fs/xfs/xfs_btree.c         |   12 ++++++------
 fs/xfs/xfs_buf_item.c      |    4 ++--
 fs/xfs/xfs_da_btree.c      |    2 +-
 fs/xfs/xfs_ialloc.c        |    4 ++--
 fs/xfs/xfs_inode.c         |    2 +-
 fs/xfs/xfs_log.c           |    4 ++--
 fs/xfs/xfs_log_recover.c   |   10 +++++-----
 fs/xfs/xfs_rtalloc.c       |    2 +-
 fs/xfs/xfs_rw.c            |    4 ++--
 fs/xfs/xfs_trans_buf.c     |   12 ++++++------
 fs/xfs/xfs_vnodeops.c      |    4 ++--
 16 files changed, 38 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 8b24dc4..b9bddee 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -600,7 +600,7 @@ _xfs_buf_read(
 			XBF_READ_AHEAD | _XBF_RUN_QUEUES);
 
 	status = xfs_buf_iorequest(bp);
-	if (status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC))
+	if (status || xfs_buf_geterror(bp) || (flags & XBF_ASYNC))
 		return status;
 	return xfs_buf_iowait(bp);
 }
@@ -1085,7 +1085,7 @@ xfs_bioerror(
 	/*
 	 * No need to wait until the buffer is unpinned, we aren't flushing it.
 	 */
-	XFS_BUF_ERROR(bp, EIO);
+	xfs_buf_ioerror(bp, EIO);
 
 	/*
 	 * We're calling xfs_buf_ioend, so delete XBF_DONE flag.
@@ -1131,7 +1131,7 @@ xfs_bioerror_relse(
 		 * There's no reason to mark error for
 		 * ASYNC buffers.
 		 */
-		XFS_BUF_ERROR(bp, EIO);
+		xfs_buf_ioerror(bp, EIO);
 		XFS_BUF_FINISH_IOWAIT(bp);
 	} else {
 		xfs_buf_relse(bp);
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index e8304f1..3dd1643 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -246,10 +246,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNDELAYWRITE(bp)	xfs_buf_delwri_dequeue(bp)
 #define XFS_BUF_ISDELAYWRITE(bp)	((bp)->b_flags & XBF_DELWRI)
 
-#define XFS_BUF_ERROR(bp,no)	xfs_buf_ioerror(bp,no)
-#define XFS_BUF_GETERROR(bp)	xfs_buf_geterror(bp)
-#define XFS_BUF_ISERROR(bp)	(xfs_buf_geterror(bp) ? 1 : 0)
-
 #define XFS_BUF_DONE(bp)	((bp)->b_flags |= XBF_DONE)
 #define XFS_BUF_UNDONE(bp)	((bp)->b_flags &= ~XBF_DONE)
 #define XFS_BUF_ISDONE(bp)	((bp)->b_flags & XBF_DONE)
diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index 6fa2146..055e747 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -402,7 +402,7 @@ xfs_qm_dqalloc(
 			       dqp->q_blkno,
 			       mp->m_quotainfo->qi_dqchunklen,
 			       0);
-	if (!bp || (error = XFS_BUF_GETERROR(bp)))
+	if (!bp || (error = xfs_buf_geterror(bp)))
 		goto error1;
 	/*
 	 * Make a chunk of dquots out of this buffer and log
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 95862bb..bddbafd 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -452,7 +452,7 @@ xfs_alloc_read_agfl(
 	if (error)
 		return error;
 	ASSERT(bp);
-	ASSERT(!XFS_BUF_GETERROR(bp));
+	ASSERT(!xfs_buf_geterror(bp));
 	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGFL, XFS_AGFL_REF);
 	*bpp = bp;
 	return 0;
@@ -2120,7 +2120,7 @@ xfs_read_agf(
 	if (!*bpp)
 		return 0;
 
-	ASSERT(!XFS_BUF_GETERROR(*bpp));
+	ASSERT(!xfs_buf_geterror(*bpp));
 	agf = XFS_BUF_TO_AGF(*bpp);
 
 	/*
@@ -2172,7 +2172,7 @@ xfs_alloc_read_agf(
 		return error;
 	if (!*bpp)
 		return 0;
-	ASSERT(!XFS_BUF_GETERROR(*bpp));
+	ASSERT(!xfs_buf_geterror(*bpp));
 
 	agf = XFS_BUF_TO_AGF(*bpp);
 	pag = xfs_perag_get(mp, agno);
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 01d2072..9607248 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -2119,7 +2119,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, blkcnt,
 				 XBF_LOCK | XBF_DONT_BLOCK);
 		ASSERT(bp);
-		ASSERT(!XFS_BUF_GETERROR(bp));
+		ASSERT(!xfs_buf_geterror(bp));
 
 		tmp = (valuelen < XFS_BUF_SIZE(bp)) ? valuelen :
 							XFS_BUF_SIZE(bp);
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 2f9e97c..974628d 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -277,7 +277,7 @@ xfs_btree_dup_cursor(
 			}
 			new->bc_bufs[i] = bp;
 			ASSERT(bp);
-			ASSERT(!XFS_BUF_GETERROR(bp));
+			ASSERT(!xfs_buf_geterror(bp));
 		} else
 			new->bc_bufs[i] = NULL;
 	}
@@ -469,7 +469,7 @@ xfs_btree_get_bufl(
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
 	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, lock);
 	ASSERT(bp);
-	ASSERT(!XFS_BUF_GETERROR(bp));
+	ASSERT(!xfs_buf_geterror(bp));
 	return bp;
 }
 
@@ -493,7 +493,7 @@ xfs_btree_get_bufs(
 	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
 	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, lock);
 	ASSERT(bp);
-	ASSERT(!XFS_BUF_GETERROR(bp));
+	ASSERT(!xfs_buf_geterror(bp));
 	return bp;
 }
 
@@ -633,7 +633,7 @@ xfs_btree_read_bufl(
 			mp->m_bsize, lock, &bp))) {
 		return error;
 	}
-	ASSERT(!bp || !XFS_BUF_GETERROR(bp));
+	ASSERT(!bp || !xfs_buf_geterror(bp));
 	if (bp)
 		XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, refval);
 	*bpp = bp;
@@ -975,7 +975,7 @@ xfs_btree_get_buf_block(
 				 mp->m_bsize, flags);
 
 	ASSERT(*bpp);
-	ASSERT(!XFS_BUF_GETERROR(*bpp));
+	ASSERT(!xfs_buf_geterror(*bpp));
 
 	*block = XFS_BUF_TO_BLOCK(*bpp);
 	return 0;
@@ -1008,7 +1008,7 @@ xfs_btree_read_buf_block(
 		return error;
 
 	ASSERT(*bpp != NULL);
-	ASSERT(!XFS_BUF_GETERROR(*bpp));
+	ASSERT(!xfs_buf_geterror(*bpp));
 
 	xfs_btree_set_refs(cur, *bpp);
 	*block = XFS_BUF_TO_BLOCK(*bpp);
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 7b7e005..4ce25c9 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -969,7 +969,7 @@ xfs_buf_iodone_callbacks(
 	static ulong		lasttime;
 	static xfs_buftarg_t	*lasttarg;
 
-	if (likely(!XFS_BUF_GETERROR(bp)))
+	if (likely(!xfs_buf_geterror(bp)))
 		goto do_callbacks;
 
 	/*
@@ -1000,7 +1000,7 @@ xfs_buf_iodone_callbacks(
 	 * around.
 	 */
 	if (XFS_BUF_ISASYNC(bp)) {
-		XFS_BUF_ERROR(bp, 0); /* errno of 0 unsets the flag */
+		xfs_buf_ioerror(bp, 0); /* errno of 0 unsets the flag */
 
 		if (!XFS_BUF_ISSTALE(bp)) {
 			XFS_BUF_DELAYWRITE(bp);
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 6102ac6..03de079 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2032,7 +2032,7 @@ xfs_da_do_buf(
 		case 0:
 			bp = xfs_trans_get_buf(trans, mp->m_ddev_targp,
 				mappedbno, nmapped, 0);
-			error = bp ? XFS_BUF_GETERROR(bp) : XFS_ERROR(EIO);
+			error = bp ? xfs_buf_geterror(bp) : XFS_ERROR(EIO);
 			break;
 		case 1:
 		case 2:
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 84ebeec..65cc921 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -203,7 +203,7 @@ xfs_ialloc_inode_init(
 					 mp->m_bsize * blks_per_cluster,
 					 XBF_LOCK);
 		ASSERT(fbuf);
-		ASSERT(!XFS_BUF_GETERROR(fbuf));
+		ASSERT(!xfs_buf_geterror(fbuf));
 
 		/*
 		 * Initialize all inodes in this buffer and then log them.
@@ -1486,7 +1486,7 @@ xfs_read_agi(
 	if (error)
 		return error;
 
-	ASSERT(*bpp && !XFS_BUF_GETERROR(*bpp));
+	ASSERT(*bpp && !xfs_buf_geterror(*bpp));
 	agi = XFS_BUF_TO_AGI(*bpp);
 
 	/*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a098a20..ff8d8ea 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2736,7 +2736,7 @@ cluster_corrupt_out:
 		if (XFS_BUF_IODONE_FUNC(bp)) {
 			XFS_BUF_UNDONE(bp);
 			XFS_BUF_STALE(bp);
-			XFS_BUF_ERROR(bp,EIO);
+			xfs_buf_ioerror(bp, EIO);
 			xfs_buf_ioend(bp, 0);
 		} else {
 			XFS_BUF_STALE(bp);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b17e651..a9aa791 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -884,7 +884,7 @@ xlog_iodone(xfs_buf_t *bp)
 	/*
 	 * Race to shutdown the filesystem if we see an error.
 	 */
-	if (XFS_TEST_ERROR((XFS_BUF_GETERROR(bp)), l->l_mp,
+	if (XFS_TEST_ERROR((xfs_buf_geterror(bp)), l->l_mp,
 			XFS_ERRTAG_IODONE_IOERR, XFS_RANDOM_IODONE_IOERR)) {
 		xfs_ioerror_alert("xlog_iodone", l->l_mp, bp, XFS_BUF_ADDR(bp));
 		XFS_BUF_STALE(bp);
@@ -1258,7 +1258,7 @@ xlog_bdstrat(
 
 	iclog = XFS_BUF_FSPRIVATE(bp, xlog_in_core_t *);
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
-		XFS_BUF_ERROR(bp, EIO);
+		xfs_buf_ioerror(bp, EIO);
 		XFS_BUF_STALE(bp);
 		xfs_buf_ioend(bp, 0);
 		/*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 75ba081..b1778d6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -356,7 +356,7 @@ STATIC void
 xlog_recover_iodone(
 	struct xfs_buf	*bp)
 {
-	if (XFS_BUF_GETERROR(bp)) {
+	if (xfs_buf_geterror(bp)) {
 		/*
 		 * We're not going to bother about retrying
 		 * this during recovery. One strike!
@@ -2131,10 +2131,10 @@ xlog_recover_buffer_pass2(
 
 	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
 			  buf_flags);
-	if (XFS_BUF_ISERROR(bp)) {
+	if (xfs_buf_geterror(bp)) {
 		xfs_ioerror_alert("xlog_recover_do..(read#1)", mp,
 				  bp, buf_f->blf_blkno);
-		error = XFS_BUF_GETERROR(bp);
+		error = xfs_buf_geterror(bp);
 		xfs_buf_relse(bp);
 		return error;
 	}
@@ -2223,10 +2223,10 @@ xlog_recover_inode_pass2(
 
 	bp = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
 			  XBF_LOCK);
-	if (XFS_BUF_ISERROR(bp)) {
+	if (xfs_buf_geterror(bp)) {
 		xfs_ioerror_alert("xlog_recover_do..(read#2)", mp,
 				  bp, in_f->ilf_blkno);
-		error = XFS_BUF_GETERROR(bp);
+		error = xfs_buf_geterror(bp);
 		xfs_buf_relse(bp);
 		goto error;
 	}
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8f76fdf..2243cfb 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -883,7 +883,7 @@ xfs_rtbuf_get(
 	if (error) {
 		return error;
 	}
-	ASSERT(bp && !XFS_BUF_GETERROR(bp));
+	ASSERT(bp && !xfs_buf_geterror(bp));
 	*bpp = bp;
 	return 0;
 }
diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
index d6d6fdf..0e326b4 100644
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
@@ -106,7 +106,7 @@ xfs_ioerror_alert(
 		 "       (\"%s\") error %d buf count %zd",
 		XFS_BUFTARG_NAME(XFS_BUF_TARGET(bp)),
 		(__uint64_t)blkno, func,
-		XFS_BUF_GETERROR(bp), XFS_BUF_COUNT(bp));
+		xfs_buf_geterror(bp), XFS_BUF_COUNT(bp));
 }
 
 /*
@@ -137,7 +137,7 @@ xfs_read_buf(
 	bp = xfs_buf_read(target, blkno, len, flags);
 	if (!bp)
 		return XFS_ERROR(EIO);
-	error = XFS_BUF_GETERROR(bp);
+	error = xfs_buf_geterror(bp);
 	if (bp && !error && !XFS_FORCED_SHUTDOWN(mp)) {
 		*bpp = bp;
 	} else {
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index d54b3f7..cf2a8ab 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -194,7 +194,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 		return NULL;
 	}
 
-	ASSERT(!XFS_BUF_GETERROR(bp));
+	ASSERT(!xfs_buf_geterror(bp));
 
 	_xfs_trans_bjoin(tp, bp, 1);
 	trace_xfs_trans_get_buf(bp->b_fspriv);
@@ -293,10 +293,10 @@ xfs_trans_read_buf(
 			return (flags & XBF_TRYLOCK) ?
 					EAGAIN : XFS_ERROR(ENOMEM);
 
-		if (XFS_BUF_GETERROR(bp) != 0) {
+		if (xfs_buf_geterror(bp) != 0) {
 			xfs_ioerror_alert("xfs_trans_read_buf", mp,
 					  bp, blkno);
-			error = XFS_BUF_GETERROR(bp);
+			error = xfs_buf_geterror(bp);
 			xfs_buf_relse(bp);
 			return error;
 		}
@@ -330,7 +330,7 @@ xfs_trans_read_buf(
 		ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 		ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
-		ASSERT((XFS_BUF_ISERROR(bp)) == 0);
+		ASSERT(!xfs_buf_geterror(bp));
 		if (!(XFS_BUF_ISDONE(bp))) {
 			trace_xfs_trans_read_buf_io(bp, _RET_IP_);
 			ASSERT(!XFS_BUF_ISASYNC(bp));
@@ -386,9 +386,9 @@ xfs_trans_read_buf(
 		return (flags & XBF_TRYLOCK) ?
 					0 : XFS_ERROR(ENOMEM);
 	}
-	if (XFS_BUF_GETERROR(bp) != 0) {
+	if (xfs_buf_geterror(bp) != 0) {
 	    XFS_BUF_SUPER_STALE(bp);
-		error = XFS_BUF_GETERROR(bp);
+		error = xfs_buf_geterror(bp);
 
 		xfs_ioerror_alert("xfs_trans_read_buf", mp,
 				  bp, blkno);
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 6197207..0eb5c48 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -507,7 +507,7 @@ xfs_readlink_bmap(
 
 		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt),
 				  XBF_LOCK | XBF_MAPPED | XBF_DONT_BLOCK);
-		error = XFS_BUF_GETERROR(bp);
+		error = xfs_buf_geterror(bp);
 		if (error) {
 			xfs_ioerror_alert("xfs_readlink",
 				  ip->i_mount, bp, XFS_BUF_ADDR(bp));
@@ -2109,7 +2109,7 @@ xfs_symlink(
 			byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
 					       BTOBB(byte_cnt), 0);
-			ASSERT(bp && !XFS_BUF_GETERROR(bp));
+			ASSERT(bp && !xfs_buf_geterror(bp));
 			if (pathlen < byte_cnt) {
 				byte_cnt = pathlen;
 			}
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
