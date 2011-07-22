Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MNe0MR117597 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 18:40:00 -0500
Received: from e4.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6629E8F9D7
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:39:59 -0700 (PDT)
Received: from e4.ny.us.ibm.com (e4.ny.us.ibm.com [32.97.182.144]) by
	cuda.sgi.com with ESMTP id CXFbswl40dZCE83r for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:39:59 -0700 (PDT)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6MNHYuH016815
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 19:17:34 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6MNdx85178582 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 19:39:59 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6MJdkoZ007585 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:39:46 -0300
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 22 Jul 2011 16:39:57 -0700
Message-Id: <20110722233957.14612.8415.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 04/12 v3] xfs: Remove macro XFS_BUF_BUSY and family
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
Reviewed-by: Alex Elder <aelder@sgi.com>
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
index 784019d..0e12861 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -318,7 +318,6 @@ xfs_qm_init_dquot_blk(
 	int		curid, i;
 
 	ASSERT(tp);
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(xfs_buf_islocked(bp));
 
 	d = (xfs_dqblk_t *)XFS_BUF_PTR(bp);
@@ -534,7 +533,6 @@ xfs_qm_dqtobp(
 			return XFS_ERROR(error);
 	}
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(xfs_buf_islocked(bp));
 
 	/*
@@ -553,7 +551,6 @@ xfs_qm_dqtobp(
 			xfs_trans_brelse(tp, bp);
 			return XFS_ERROR(EIO);
 		}
-		XFS_BUF_BUSY(bp); /* We dirtied this */
 	}
 
 	*O_bpp = bp;
@@ -622,7 +619,6 @@ xfs_qm_dqread(
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
index 7da3dd5..d147ae5 100644
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
 	}
 	XFS_BUF_SET_COUNT(bp, count);
 	bp->b_fspriv = iclog;
-	XFS_BUF_BUSY(bp);
 	XFS_BUF_ASYNC(bp);
 	bp->b_flags |= XBF_SYNCIO;
 
@@ -1401,7 +1398,6 @@ xlog_sync(xlog_t		*log,
 		XFS_BUF_SET_PTR(bp, (xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
 					    (__psint_t)count), split);
 		bp->b_fspriv = iclog;
-		XFS_BUF_BUSY(bp);
 		XFS_BUF_ASYNC(bp);
 		bp->b_flags |= XBF_SYNCIO;
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7d96b69..b07482c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -178,7 +178,6 @@ xlog_bread_noalign(
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_READ(bp);
-	XFS_BUF_BUSY(bp);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
 	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
 
@@ -265,7 +264,6 @@ xlog_bwrite(
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
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
