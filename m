Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6G1LWaw228045 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:21:32 -0500
Received: from e3.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9A2F75A3F
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:21:31 -0700 (PDT)
Received: from e3.ny.us.ibm.com (e3.ny.us.ibm.com [32.97.182.143]) by
	cuda.sgi.com with ESMTP id die6nsDJDXCymJoa for
	<xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:21:31 -0700 (PDT)
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6G0w8af028007
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:58:08 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6G1LUnD083556 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:21:30 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6G1LUAj015119 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:21:30 -0400
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 15 Jul 2011 18:21:29 -0700
Message-Id: <20110716012129.6629.54791.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 04/12] xfs: Remove macro XFS_BUF_BUSY and family
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

Remove the definitions and uses of the macros XFS_BUF_BUSY,
XFS_BUF_UNBUSY, and XFS_BUF_ISBUSY.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    1 -
 fs/xfs/linux-2.6/xfs_buf.h |    4 ----
 fs/xfs/quota/xfs_dquot.c   |    4 ----
 fs/xfs/xfs_buf_item.c      |    2 --
 fs/xfs/xfs_log.c           |    4 ----
 fs/xfs/xfs_log_recover.c   |    2 --
 fs/xfs/xfs_trans_buf.c     |    9 ---------
 7 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index b9bddee..c881c2e 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -684,7 +684,6 @@ xfs_buf_read_uncached(
 	xfs_buf_lock(bp);
 	XFS_BUF_SET_ADDR(bp, daddr);
 	XFS_BUF_READ(bp);
-	XFS_BUF_BUSY(bp);
 
 	xfsbdstrat(mp, bp);
 	error = xfs_buf_iowait(bp);
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 3dd1643..ce554d9 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -250,10 +250,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNDONE(bp)	((bp)->b_flags &= ~XBF_DONE)
 #define XFS_BUF_ISDONE(bp)	((bp)->b_flags & XBF_DONE)
 
-#define XFS_BUF_BUSY(bp)	do { } while (0)
-#define XFS_BUF_UNBUSY(bp)	do { } while (0)
-#define XFS_BUF_ISBUSY(bp)	(1)
-
 #define XFS_BUF_ASYNC(bp)	((bp)->b_flags |= XBF_ASYNC)
 #define XFS_BUF_UNASYNC(bp)	((bp)->b_flags &= ~XBF_ASYNC)
 #define XFS_BUF_ISASYNC(bp)	((bp)->b_flags & XBF_ASYNC)
diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index 055e747..fa3c150 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -317,7 +317,6 @@ xfs_qm_init_dquot_blk(
 	int		curid, i;
 
 	ASSERT(tp);
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 
 	d = (xfs_dqblk_t *)XFS_BUF_PTR(bp);
@@ -533,7 +532,6 @@ xfs_qm_dqtobp(
 			return XFS_ERROR(error);
 	}
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 
 	/*
@@ -552,7 +550,6 @@ xfs_qm_dqtobp(
 			xfs_trans_brelse(tp, bp);
 			return XFS_ERROR(EIO);
 		}
-		XFS_BUF_BUSY(bp); /* We dirtied this */
 	}
 
 	*O_bpp = bp;
@@ -621,7 +618,6 @@ xfs_qm_dqread(
 	 * this particular dquot was repaired. We still aren't afraid to
 	 * brelse it because we have the changes incore.
 	 */
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 	xfs_trans_brelse(tp, bp);
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 4ce25c9..d04046f 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -373,7 +373,6 @@ xfs_buf_item_pin(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 
-	ASSERT(XFS_BUF_ISBUSY(bip->bli_buf));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
@@ -904,7 +903,6 @@ xfs_buf_attach_iodone(
 {
 	xfs_log_item_t	*head_lip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 
 	lip->li_cb = cb;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a9aa791..721a63d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1058,7 +1058,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		goto out_free_log;
 	XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
 	XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 	log->l_xbuf = bp;
 
@@ -1117,7 +1116,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		iclog->ic_callback_tail = &(iclog->ic_callback);
 		iclog->ic_datap = (char *)iclog->ic_data + log->l_iclog_hsize;
 
-		ASSERT(XFS_BUF_ISBUSY(iclog->ic_bp));
 		ASSERT(XFS_BUF_VALUSEMA(iclog->ic_bp) <= 0);
 		init_waitqueue_head(&iclog->ic_force_wait);
 		init_waitqueue_head(&iclog->ic_write_wait);
@@ -1368,7 +1366,6 @@ xlog_sync(xlog_t		*log,
 	XFS_BUF_SET_COUNT(bp, count);
 	XFS_BUF_SET_FSPRIVATE(bp, iclog);	/* save for later */
 	bp->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED);
-	XFS_BUF_BUSY(bp);
 	XFS_BUF_ASYNC(bp);
 	bp->b_flags |= XBF_LOG_BUFFER;
 
@@ -1413,7 +1410,6 @@ xlog_sync(xlog_t		*log,
 		XFS_BUF_SET_FSPRIVATE(bp, iclog);
 		bp->b_flags &=
 			~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED);
-		XFS_BUF_BUSY(bp);
 		XFS_BUF_ASYNC(bp);
 		bp->b_flags |= XBF_LOG_BUFFER;
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b1778d6..fa0c0d6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -174,7 +174,6 @@ xlog_bread_noalign(
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_READ(bp);
-	XFS_BUF_BUSY(bp);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
 	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
 
@@ -262,7 +261,6 @@ xlog_bwrite(
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	bp->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED);
-	XFS_BUF_BUSY(bp);
 	XFS_BUF_HOLD(bp);
 	XFS_BUF_PSEMA(bp, PRIBIO);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index cf2a8ab..73f3685 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -80,7 +80,6 @@ _xfs_trans_bjoin(
 {
 	struct xfs_buf_log_item	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, void *) == NULL);
 
 	/*
@@ -583,7 +582,6 @@ xfs_trans_bhold(xfs_trans_t	*tp,
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
@@ -605,7 +603,6 @@ xfs_trans_bhold_release(xfs_trans_t	*tp,
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
@@ -636,7 +633,6 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 	ASSERT((first <= last) && (last < XFS_BUF_COUNT(bp)));
@@ -708,7 +704,6 @@ xfs_trans_binval(
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
@@ -782,7 +777,6 @@ xfs_trans_inode_buf(
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
@@ -808,7 +802,6 @@ xfs_trans_stale_inode_buf(
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
@@ -835,7 +828,6 @@ xfs_trans_inode_alloc_buf(
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
@@ -865,7 +857,6 @@ xfs_trans_dquot_buf(
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 	ASSERT(type == XFS_BLF_UDQUOT_BUF ||
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
