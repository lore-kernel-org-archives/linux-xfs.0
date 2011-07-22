Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6M0X811051437 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 19:33:08 -0500
Received: from e36.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78BFD1D8A83B
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:33:07 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id 1Xelzw5aBQ4Om7uV for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:33:07 -0700 (PDT)
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6M0QqTE012863
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 18:26:52 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6M0X1XO142006 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 18:33:01 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6LIWX19028092
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 12:32:33 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 21 Jul 2011 17:33:00 -0700
Message-Id: <20110722003259.21069.3544.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 704418a..ae2c2e7 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -679,7 +679,6 @@ xfs_buf_read_uncached(
 	/* set up the buffer for a read IO */
 	XFS_BUF_SET_ADDR(bp, daddr);
 	XFS_BUF_READ(bp);
-	XFS_BUF_BUSY(bp);
 
 	xfsbdstrat(mp, bp);
 	error = xfs_buf_iowait(bp);
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index c14297c..ce5c7e2 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -249,10 +249,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
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
index e7e35fb..772ae2a 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -318,7 +318,6 @@ xfs_qm_init_dquot_blk(
 	int		curid, i;
 
 	ASSERT(tp);
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(xfs_buf_islocked(bp));
 
 	d = (xfs_dqblk_t *)XFS_BUF_PTR(bp);
@@ -535,7 +534,6 @@ xfs_qm_dqtobp(
 			return XFS_ERROR(error);
 	}
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(xfs_buf_islocked(bp));
 
 	/*
@@ -554,7 +552,6 @@ xfs_qm_dqtobp(
 			xfs_trans_brelse(tp, bp);
 			return XFS_ERROR(EIO);
 		}
-		XFS_BUF_BUSY(bp); /* We dirtied this */
 	}
 
 	*O_bpp = bp;
@@ -623,7 +620,6 @@ xfs_qm_dqread(
 	 * this particular dquot was repaired. We still aren't afraid to
 	 * brelse it because we have the changes incore.
 	 */
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(xfs_buf_islocked(bp));
 	xfs_trans_brelse(tp, bp);
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 38417ab..9e9b4a7 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -371,7 +371,6 @@ xfs_buf_item_pin(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 
-	ASSERT(XFS_BUF_ISBUSY(bip->bli_buf));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
@@ -895,7 +894,6 @@ xfs_buf_attach_iodone(
 {
 	xfs_log_item_t	*head_lip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(xfs_buf_islocked(bp));
 
 	lip->li_cb = cb;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0a7930a..5805a3a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1051,7 +1051,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	if (!bp)
 		goto out_free_log;
 	bp->b_iodone = xlog_iodone;
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(xfs_buf_islocked(bp));
 	log->l_xbuf = bp;
 
@@ -1108,7 +1107,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		iclog->ic_callback_tail = &(iclog->ic_callback);
 		iclog->ic_datap = (char *)iclog->ic_data + log->l_iclog_hsize;
 
-		ASSERT(XFS_BUF_ISBUSY(iclog->ic_bp));
 		ASSERT(xfs_buf_islocked(iclog->ic_bp));
 		init_waitqueue_head(&iclog->ic_force_wait);
 		init_waitqueue_head(&iclog->ic_write_wait);
@@ -1355,7 +1353,6 @@ xlog_sync(xlog_t		*log,
 	XFS_BUF_SET_COUNT(bp, count);
 	bp->b_fspriv = iclog;
 	bp->b_flags &= ~(XBF_FUA|XBF_FLUSH);
-	XFS_BUF_BUSY(bp);
 	XFS_BUF_ASYNC(bp);
 	bp->b_flags |= XBF_SYNCIO;
 
@@ -1402,7 +1399,6 @@ xlog_sync(xlog_t		*log,
 					    (__psint_t)count), split);
 		bp->b_fspriv = iclog;
 		bp->b_flags &= ~(XBF_FUA|XBF_FLUSH);
-		XFS_BUF_BUSY(bp);
 		XFS_BUF_ASYNC(bp);
 		bp->b_flags |= XBF_SYNCIO;
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2eee6e2..f774713 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -178,7 +178,6 @@ xlog_bread_noalign(
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_READ(bp);
-	XFS_BUF_BUSY(bp);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
 	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
 
@@ -266,7 +265,6 @@ xlog_bwrite(
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	bp->b_flags &= ~(XBF_SYNCIO|XBF_FUA|XBF_FLUSH);
-	XFS_BUF_BUSY(bp);
 	XFS_BUF_HOLD(bp);
 	xfs_buf_lock(bp);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index f9f1bf6..7dd62e2 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -80,7 +80,6 @@ _xfs_trans_bjoin(
 {
 	struct xfs_buf_log_item	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == NULL);
 
 	/*
@@ -580,7 +579,6 @@ xfs_trans_bhold(xfs_trans_t	*tp,
 {
 	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
@@ -601,7 +599,6 @@ xfs_trans_bhold_release(xfs_trans_t	*tp,
 {
 	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
@@ -630,7 +627,6 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 {
 	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT((first <= last) && (last < XFS_BUF_COUNT(bp)));
@@ -701,7 +697,6 @@ xfs_trans_binval(
 {
 	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
@@ -773,7 +768,6 @@ xfs_trans_inode_buf(
 {
 	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
@@ -797,7 +791,6 @@ xfs_trans_stale_inode_buf(
 {
 	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
@@ -822,7 +815,6 @@ xfs_trans_inode_alloc_buf(
 {
 	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
@@ -850,7 +842,6 @@ xfs_trans_dquot_buf(
 {
 	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT(type == XFS_BLF_UDQUOT_BUF ||
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
