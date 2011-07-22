Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6M0WvuA051412 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 19:32:57 -0500
Received: from e8.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 050EDEEEC4E
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:32:56 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id GkF1PMs3d9o3Cd5q for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:32:56 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6M0KKBL020814
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 20:20:20 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6M0WtLi080488 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 20:32:55 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6LIWsBF009081
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 12:32:54 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 21 Jul 2011 17:32:54 -0700
Message-Id: <20110722003254.21069.27101.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
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
 fs/xfs/quota/xfs_dquot.c   |    3 ++-
 fs/xfs/xfs_alloc.c         |    7 +++----
 fs/xfs/xfs_attr.c          |    3 +--
 fs/xfs/xfs_btree.c         |   17 ++++++-----------
 fs/xfs/xfs_buf_item.c      |    4 ++--
 fs/xfs/xfs_da_btree.c      |    2 +-
 fs/xfs/xfs_ialloc.c        |    5 ++---
 fs/xfs/xfs_inode.c         |    2 +-
 fs/xfs/xfs_log.c           |    4 ++--
 fs/xfs/xfs_log_recover.c   |   12 +++++-------
 fs/xfs/xfs_rtalloc.c       |    2 +-
 fs/xfs/xfs_rw.c            |    6 +++---
 fs/xfs/xfs_trans_buf.c     |   15 +++++++--------
 fs/xfs/xfs_vnodeops.c      |    4 ++--
 16 files changed, 41 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 969fd15..704418a 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -596,7 +596,7 @@ _xfs_buf_read(
 	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
 
 	status = xfs_buf_iorequest(bp);
-	if (status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC))
+	if (status || bp->b_error || (flags & XBF_ASYNC))
 		return status;
 	return xfs_buf_iowait(bp);
 }
@@ -1069,7 +1069,7 @@ xfs_bioerror(
 	/*
 	 * No need to wait until the buffer is unpinned, we aren't flushing it.
 	 */
-	XFS_BUF_ERROR(bp, EIO);
+	xfs_buf_ioerror(bp, EIO);
 
 	/*
 	 * We're calling xfs_buf_ioend, so delete XBF_DONE flag.
@@ -1115,7 +1115,7 @@ xfs_bioerror_relse(
 		 * There's no reason to mark error for
 		 * ASYNC buffers.
 		 */
-		XFS_BUF_ERROR(bp, EIO);
+		xfs_buf_ioerror(bp, EIO);
 		XFS_BUF_FINISH_IOWAIT(bp);
 	} else {
 		xfs_buf_relse(bp);
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index d7df7b6..c14297c 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -245,10 +245,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
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
index 837f311..e7e35fb 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -403,7 +403,8 @@ xfs_qm_dqalloc(
 			       dqp->q_blkno,
 			       mp->m_quotainfo->qi_dqchunklen,
 			       0);
-	if (!bp || (error = XFS_BUF_GETERROR(bp)))
+	error = xfs_buf_geterror(bp);
+	if (error)
 		goto error1;
 	/*
 	 * Make a chunk of dquots out of this buffer and log
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 1e00b3e..bdd9cb5 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -451,8 +451,7 @@ xfs_alloc_read_agfl(
 			XFS_FSS_TO_BB(mp, 1), 0, &bp);
 	if (error)
 		return error;
-	ASSERT(bp);
-	ASSERT(!XFS_BUF_GETERROR(bp));
+	ASSERT(!xfs_buf_geterror(bp));
 	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGFL, XFS_AGFL_REF);
 	*bpp = bp;
 	return 0;
@@ -2116,7 +2115,7 @@ xfs_read_agf(
 	if (!*bpp)
 		return 0;
 
-	ASSERT(!XFS_BUF_GETERROR(*bpp));
+	ASSERT(!(*bpp)->b_error);
 	agf = XFS_BUF_TO_AGF(*bpp);
 
 	/*
@@ -2168,7 +2167,7 @@ xfs_alloc_read_agf(
 		return error;
 	if (!*bpp)
 		return 0;
-	ASSERT(!XFS_BUF_GETERROR(*bpp));
+	ASSERT(!(*bpp)->b_error);
 
 	agf = XFS_BUF_TO_AGF(*bpp);
 	pag = xfs_perag_get(mp, agno);
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index cbae424..160bcdc 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -2121,8 +2121,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 
 		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, blkcnt,
 				 XBF_LOCK | XBF_DONT_BLOCK);
-		ASSERT(bp);
-		ASSERT(!XFS_BUF_GETERROR(bp));
+		ASSERT(!xfs_buf_geterror(bp));
 
 		tmp = (valuelen < XFS_BUF_SIZE(bp)) ? valuelen :
 							XFS_BUF_SIZE(bp);
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index cabf4b5..2b9fd38 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -275,8 +275,7 @@ xfs_btree_dup_cursor(
 				return error;
 			}
 			new->bc_bufs[i] = bp;
-			ASSERT(bp);
-			ASSERT(!XFS_BUF_GETERROR(bp));
+			ASSERT(!xfs_buf_geterror(bp));
 		} else
 			new->bc_bufs[i] = NULL;
 	}
@@ -467,8 +466,7 @@ xfs_btree_get_bufl(
 	ASSERT(fsbno != NULLFSBLOCK);
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
 	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, lock);
-	ASSERT(bp);
-	ASSERT(!XFS_BUF_GETERROR(bp));
+	ASSERT(!xfs_buf_geterror(bp));
 	return bp;
 }
 
@@ -491,8 +489,7 @@ xfs_btree_get_bufs(
 	ASSERT(agbno != NULLAGBLOCK);
 	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
 	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, lock);
-	ASSERT(bp);
-	ASSERT(!XFS_BUF_GETERROR(bp));
+	ASSERT(!xfs_buf_geterror(bp));
 	return bp;
 }
 
@@ -632,7 +629,7 @@ xfs_btree_read_bufl(
 			mp->m_bsize, lock, &bp))) {
 		return error;
 	}
-	ASSERT(!bp || !XFS_BUF_GETERROR(bp));
+	ASSERT(!xfs_buf_geterror(bp));
 	if (bp)
 		XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, refval);
 	*bpp = bp;
@@ -973,8 +970,7 @@ xfs_btree_get_buf_block(
 	*bpp = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d,
 				 mp->m_bsize, flags);
 
-	ASSERT(*bpp);
-	ASSERT(!XFS_BUF_GETERROR(*bpp));
+	ASSERT(!xfs_buf_geterror(*bpp));
 
 	*block = XFS_BUF_TO_BLOCK(*bpp);
 	return 0;
@@ -1006,8 +1002,7 @@ xfs_btree_read_buf_block(
 	if (error)
 		return error;
 
-	ASSERT(*bpp != NULL);
-	ASSERT(!XFS_BUF_GETERROR(*bpp));
+	ASSERT(!xfs_buf_geterror(*bpp));
 
 	xfs_btree_set_refs(cur, *bpp);
 	*block = XFS_BUF_TO_BLOCK(*bpp);
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 8849291..38417ab 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -960,7 +960,7 @@ xfs_buf_iodone_callbacks(
 	static ulong		lasttime;
 	static xfs_buftarg_t	*lasttarg;
 
-	if (likely(!XFS_BUF_GETERROR(bp)))
+	if (likely(!xfs_buf_geterror(bp)))
 		goto do_callbacks;
 
 	/*
@@ -991,7 +991,7 @@ xfs_buf_iodone_callbacks(
 	 * around.
 	 */
 	if (XFS_BUF_ISASYNC(bp)) {
-		XFS_BUF_ERROR(bp, 0); /* errno of 0 unsets the flag */
+		xfs_buf_ioerror(bp, 0); /* errno of 0 unsets the flag */
 
 		if (!XFS_BUF_ISSTALE(bp)) {
 			XFS_BUF_DELAYWRITE(bp);
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 2925726..5d9290d 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2040,7 +2040,7 @@ xfs_da_do_buf(
 		case 0:
 			bp = xfs_trans_get_buf(trans, mp->m_ddev_targp,
 				mappedbno, nmapped, 0);
-			error = bp ? XFS_BUF_GETERROR(bp) : XFS_ERROR(EIO);
+			error = bp ? bp->b_error : XFS_ERROR(EIO);
 			break;
 		case 1:
 		case 2:
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index dd5628b..9f24ec2 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -202,8 +202,7 @@ xfs_ialloc_inode_init(
 		fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
 					 mp->m_bsize * blks_per_cluster,
 					 XBF_LOCK);
-		ASSERT(fbuf);
-		ASSERT(!XFS_BUF_GETERROR(fbuf));
+		ASSERT(!xfs_buf_geterror(fbuf));
 
 		/*
 		 * Initialize all inodes in this buffer and then log them.
@@ -1486,7 +1485,7 @@ xfs_read_agi(
 	if (error)
 		return error;
 
-	ASSERT(*bpp && !XFS_BUF_GETERROR(*bpp));
+	ASSERT(!xfs_buf_geterror(*bpp));
 	agi = XFS_BUF_TO_AGI(*bpp);
 
 	/*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3cc21dd..bdb47b2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2473,7 +2473,7 @@ cluster_corrupt_out:
 		if (bp->b_iodone) {
 			XFS_BUF_UNDONE(bp);
 			XFS_BUF_STALE(bp);
-			XFS_BUF_ERROR(bp,EIO);
+			xfs_buf_ioerror(bp, EIO);
 			xfs_buf_ioend(bp, 0);
 		} else {
 			XFS_BUF_STALE(bp);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5319a95..0a7930a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -878,7 +878,7 @@ xlog_iodone(xfs_buf_t *bp)
 	/*
 	 * Race to shutdown the filesystem if we see an error.
 	 */
-	if (XFS_TEST_ERROR((XFS_BUF_GETERROR(bp)), l->l_mp,
+	if (XFS_TEST_ERROR((xfs_buf_geterror(bp)), l->l_mp,
 			XFS_ERRTAG_IODONE_IOERR, XFS_RANDOM_IODONE_IOERR)) {
 		xfs_ioerror_alert("xlog_iodone", l->l_mp, bp, XFS_BUF_ADDR(bp));
 		XFS_BUF_STALE(bp);
@@ -1248,7 +1248,7 @@ xlog_bdstrat(
 	struct xlog_in_core	*iclog = bp->b_fspriv;
 
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
-		XFS_BUF_ERROR(bp, EIO);
+		xfs_buf_ioerror(bp, EIO);
 		XFS_BUF_STALE(bp);
 		xfs_buf_ioend(bp, 0);
 		/*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3913b2f..2eee6e2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -360,7 +360,7 @@ STATIC void
 xlog_recover_iodone(
 	struct xfs_buf	*bp)
 {
-	if (XFS_BUF_GETERROR(bp)) {
+	if (bp->b_error) {
 		/*
 		 * We're not going to bother about retrying
 		 * this during recovery. One strike!
@@ -2135,15 +2135,14 @@ xlog_recover_buffer_pass2(
 
 	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
 			  buf_flags);
-	if (XFS_BUF_ISERROR(bp)) {
+	error = bp->b_error;
+	if (error) {
 		xfs_ioerror_alert("xlog_recover_do..(read#1)", mp,
 				  bp, buf_f->blf_blkno);
-		error = XFS_BUF_GETERROR(bp);
 		xfs_buf_relse(bp);
 		return error;
 	}
 
-	error = 0;
 	if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
 		error = xlog_recover_do_inode_buffer(mp, item, bp, buf_f);
 	} else if (buf_f->blf_flags &
@@ -2227,14 +2226,13 @@ xlog_recover_inode_pass2(
 
 	bp = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
 			  XBF_LOCK);
-	if (XFS_BUF_ISERROR(bp)) {
+	error = bp->b_error;
+	if (error) {
 		xfs_ioerror_alert("xlog_recover_do..(read#2)", mp,
 				  bp, in_f->ilf_blkno);
-		error = XFS_BUF_GETERROR(bp);
 		xfs_buf_relse(bp);
 		goto error;
 	}
-	error = 0;
 	ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
 	dip = (xfs_dinode_t *)xfs_buf_offset(bp, in_f->ilf_boffset);
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8f76fdf..cb8132c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -883,7 +883,7 @@ xfs_rtbuf_get(
 	if (error) {
 		return error;
 	}
-	ASSERT(bp && !XFS_BUF_GETERROR(bp));
+	ASSERT(!xfs_buf_geterror(bp));
 	*bpp = bp;
 	return 0;
 }
diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
index d6d6fdf..d1f76f8 100644
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
@@ -106,7 +106,7 @@ xfs_ioerror_alert(
 		 "       (\"%s\") error %d buf count %zd",
 		XFS_BUFTARG_NAME(XFS_BUF_TARGET(bp)),
 		(__uint64_t)blkno, func,
-		XFS_BUF_GETERROR(bp), XFS_BUF_COUNT(bp));
+		bp->b_error, XFS_BUF_COUNT(bp));
 }
 
 /*
@@ -137,8 +137,8 @@ xfs_read_buf(
 	bp = xfs_buf_read(target, blkno, len, flags);
 	if (!bp)
 		return XFS_ERROR(EIO);
-	error = XFS_BUF_GETERROR(bp);
-	if (bp && !error && !XFS_FORCED_SHUTDOWN(mp)) {
+	error = bp->b_error;
+	if (!error && !XFS_FORCED_SHUTDOWN(mp)) {
 		*bpp = bp;
 	} else {
 		*bpp = NULL;
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 1bc04d4..f9f1bf6 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -194,7 +194,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 		return NULL;
 	}
 
-	ASSERT(!XFS_BUF_GETERROR(bp));
+	ASSERT(!bp->b_error);
 
 	_xfs_trans_bjoin(tp, bp, 1);
 	trace_xfs_trans_get_buf(bp->b_fspriv);
@@ -293,10 +293,10 @@ xfs_trans_read_buf(
 			return (flags & XBF_TRYLOCK) ?
 					EAGAIN : XFS_ERROR(ENOMEM);
 
-		if (XFS_BUF_GETERROR(bp) != 0) {
+		if (bp->b_error) {
+			error = bp->b_error;
 			xfs_ioerror_alert("xfs_trans_read_buf", mp,
 					  bp, blkno);
-			error = XFS_BUF_GETERROR(bp);
 			xfs_buf_relse(bp);
 			return error;
 		}
@@ -330,7 +330,7 @@ xfs_trans_read_buf(
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_transp == tp);
 		ASSERT(bp->b_fspriv != NULL);
-		ASSERT((XFS_BUF_ISERROR(bp)) == 0);
+		ASSERT(!bp->b_error);
 		if (!(XFS_BUF_ISDONE(bp))) {
 			trace_xfs_trans_read_buf_io(bp, _RET_IP_);
 			ASSERT(!XFS_BUF_ISASYNC(bp));
@@ -386,10 +386,9 @@ xfs_trans_read_buf(
 		return (flags & XBF_TRYLOCK) ?
 					0 : XFS_ERROR(ENOMEM);
 	}
-	if (XFS_BUF_GETERROR(bp) != 0) {
-	    XFS_BUF_SUPER_STALE(bp);
-		error = XFS_BUF_GETERROR(bp);
-
+	if (bp->b_error) {
+		error = bp->b_error;
+		XFS_BUF_SUPER_STALE(bp);
 		xfs_ioerror_alert("xfs_trans_read_buf", mp,
 				  bp, blkno);
 		if (tp->t_flags & XFS_TRANS_DIRTY)
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 88d1214..97daa35 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -83,7 +83,7 @@ xfs_readlink_bmap(
 
 		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt),
 				  XBF_LOCK | XBF_MAPPED | XBF_DONT_BLOCK);
-		error = XFS_BUF_GETERROR(bp);
+		error = bp->b_error;
 		if (error) {
 			xfs_ioerror_alert("xfs_readlink",
 				  ip->i_mount, bp, XFS_BUF_ADDR(bp));
@@ -1648,7 +1648,7 @@ xfs_symlink(
 			byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
 					       BTOBB(byte_cnt), 0);
-			ASSERT(bp && !XFS_BUF_GETERROR(bp));
+			ASSERT(!xfs_buf_geterror(bp));
 			if (pathlen < byte_cnt) {
 				byte_cnt = pathlen;
 			}
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
