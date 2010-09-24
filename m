Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8OCUi66180974 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 07:30:45 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B79714FBFF7
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 05:44:18 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	h5P9fdhCa50EW43Z for <xfs@oss.sgi.com>;
	Fri, 24 Sep 2010 05:44:18 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	40176988-1927428
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 22:01:36 +0930 (CST)
Received: from [192.168.1.9] (helo=disturbed) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Oz7R8-0007Us-CE
	for xfs@oss.sgi.com; Fri, 24 Sep 2010 22:31:34 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1Oz7Qu-00060C-6Q
	for xfs@oss.sgi.com; Fri, 24 Sep 2010 22:31:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/18] xfs: store xfs_mount in the buftarg instead of in the
	xfs_buf
Date: Fri, 24 Sep 2010 22:31:06 +1000
Message-Id: <1285331476-23015-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1285331476-23015-1-git-send-email-david@fromorbit.com>
References: <1285331476-23015-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Each buffer contains both a buftarg pointer and a mount pointer. If
we add a mount pointer into the buftarg, we can avoid needing the
b_mount field in every buffer and grab it from the buftarg when
needed instead. This shrinks the xfs_buf by 8 bytes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c   |    9 ++++-----
 fs/xfs/linux-2.6/xfs_buf.h   |    5 +++--
 fs/xfs/linux-2.6/xfs_super.c |    8 +++++---
 fs/xfs/xfs_buf_item.c        |    3 +--
 fs/xfs/xfs_log_recover.c     |   16 +++++++---------
 5 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 22c7bff..d692897 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -894,7 +894,7 @@ xfs_buf_lock(
 	trace_xfs_buf_lock(bp, _RET_IP_);
 
 	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
-		xfs_log_force(bp->b_mount, 0);
+		xfs_log_force(bp->b_target->bt_mount, 0);
 	if (atomic_read(&bp->b_io_remaining))
 		blk_run_address_space(bp->b_target->bt_mapping);
 	down(&bp->b_sema);
@@ -1017,7 +1017,6 @@ xfs_bwrite(
 {
 	int			error;
 
-	bp->b_mount = mp;
 	bp->b_flags |= XBF_WRITE;
 	bp->b_flags &= ~(XBF_ASYNC | XBF_READ);
 
@@ -1038,8 +1037,6 @@ xfs_bdwrite(
 {
 	trace_xfs_buf_bdwrite(bp, _RET_IP_);
 
-	bp->b_mount = mp;
-
 	bp->b_flags &= ~XBF_READ;
 	bp->b_flags |= (XBF_DELWRI | XBF_ASYNC);
 
@@ -1128,7 +1125,7 @@ int
 xfs_bdstrat_cb(
 	struct xfs_buf	*bp)
 {
-	if (XFS_FORCED_SHUTDOWN(bp->b_mount)) {
+	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
 		trace_xfs_bdstrat_shut(bp, _RET_IP_);
 		/*
 		 * Metadata write that didn't get logged but
@@ -1644,6 +1641,7 @@ out_error:
 
 xfs_buftarg_t *
 xfs_alloc_buftarg(
+	struct xfs_mount	*mp,
 	struct block_device	*bdev,
 	int			external,
 	const char		*fsname)
@@ -1652,6 +1650,7 @@ xfs_alloc_buftarg(
 
 	btp = kmem_zalloc(sizeof(*btp), KM_SLEEP);
 
+	btp->bt_mount = mp;
 	btp->bt_dev =  bdev->bd_dev;
 	btp->bt_bdev = bdev;
 	if (xfs_setsize_buftarg_early(btp, bdev))
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 57eedc7..def2cea 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -132,6 +132,7 @@ typedef struct xfs_buftarg {
 	dev_t			bt_dev;
 	struct block_device	*bt_bdev;
 	struct address_space	*bt_mapping;
+	struct xfs_mount	*bt_mount;
 	unsigned int		bt_bsize;
 	unsigned int		bt_sshift;
 	size_t			bt_smask;
@@ -189,7 +190,6 @@ typedef struct xfs_buf {
 	struct completion	b_iowait;	/* queue for I/O waiters */
 	void			*b_fspriv;
 	void			*b_fspriv2;
-	struct xfs_mount	*b_mount;
 	unsigned short		b_error;	/* error code on I/O */
 	unsigned int		b_page_count;	/* size of page array */
 	unsigned int		b_offset;	/* page offset in first page */
@@ -377,7 +377,8 @@ static inline void xfs_buf_relse(xfs_buf_t *bp)
 /*
  *	Handling of buftargs.
  */
-extern xfs_buftarg_t *xfs_alloc_buftarg(struct block_device *, int, const char *);
+extern xfs_buftarg_t *xfs_alloc_buftarg(struct xfs_mount *,
+			struct block_device *, int, const char *);
 extern void xfs_free_buftarg(struct xfs_mount *, struct xfs_buftarg *);
 extern void xfs_wait_buftarg(xfs_buftarg_t *);
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 83154c0..4759be4 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -758,18 +758,20 @@ xfs_open_devices(
 	 * Setup xfs_mount buffer target pointers
 	 */
 	error = ENOMEM;
-	mp->m_ddev_targp = xfs_alloc_buftarg(ddev, 0, mp->m_fsname);
+	mp->m_ddev_targp = xfs_alloc_buftarg(mp, ddev, 0, mp->m_fsname);
 	if (!mp->m_ddev_targp)
 		goto out_close_rtdev;
 
 	if (rtdev) {
-		mp->m_rtdev_targp = xfs_alloc_buftarg(rtdev, 1, mp->m_fsname);
+		mp->m_rtdev_targp = xfs_alloc_buftarg(mp, rtdev, 1,
+							mp->m_fsname);
 		if (!mp->m_rtdev_targp)
 			goto out_free_ddev_targ;
 	}
 
 	if (logdev && logdev != ddev) {
-		mp->m_logdev_targp = xfs_alloc_buftarg(logdev, 1, mp->m_fsname);
+		mp->m_logdev_targp = xfs_alloc_buftarg(mp, logdev, 1,
+							mp->m_fsname);
 		if (!mp->m_logdev_targp)
 			goto out_free_rtdev_targ;
 	} else {
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1b09d7a..ee75576 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -692,8 +692,7 @@ xfs_buf_item_init(
 	 * the first.  If we do already have one, there is
 	 * nothing to do here so return.
 	 */
-	if (bp->b_mount != mp)
-		bp->b_mount = mp;
+	ASSERT(bp->b_target->bt_mount == mp);
 	if (XFS_BUF_FSPRIVATE(bp, void *) != NULL) {
 		lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
 		if (lip->li_type == XFS_LI_BUF) {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3d88754..351d711 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -322,10 +322,11 @@ xlog_recover_iodone(
 		 * this during recovery. One strike!
 		 */
 		xfs_ioerror_alert("xlog_recover_iodone",
-				  bp->b_mount, bp, XFS_BUF_ADDR(bp));
-		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
+					bp->b_target->bt_mount, bp,
+					XFS_BUF_ADDR(bp));
+		xfs_force_shutdown(bp->b_target->bt_mount,
+					SHUTDOWN_META_IO_ERROR);
 	}
-	bp->b_mount = NULL;
 	XFS_BUF_CLR_IODONE_FUNC(bp);
 	xfs_biodone(bp);
 }
@@ -2276,8 +2277,7 @@ xlog_recover_do_buffer_trans(
 		XFS_BUF_STALE(bp);
 		error = xfs_bwrite(mp, bp);
 	} else {
-		ASSERT(bp->b_mount == NULL || bp->b_mount == mp);
-		bp->b_mount = mp;
+		ASSERT(bp->b_target->bt_mount == mp);
 		XFS_BUF_SET_IODONE_FUNC(bp, xlog_recover_iodone);
 		xfs_bdwrite(mp, bp);
 	}
@@ -2541,8 +2541,7 @@ xlog_recover_do_inode_trans(
 	}
 
 write_inode_buffer:
-	ASSERT(bp->b_mount == NULL || bp->b_mount == mp);
-	bp->b_mount = mp;
+	ASSERT(bp->b_target->bt_mount == mp);
 	XFS_BUF_SET_IODONE_FUNC(bp, xlog_recover_iodone);
 	xfs_bdwrite(mp, bp);
 error:
@@ -2679,8 +2678,7 @@ xlog_recover_do_dquot_trans(
 	memcpy(ddq, recddq, item->ri_buf[1].i_len);
 
 	ASSERT(dq_f->qlf_size == 2);
-	ASSERT(bp->b_mount == NULL || bp->b_mount == mp);
-	bp->b_mount = mp;
+	ASSERT(bp->b_target->bt_mount == mp);
 	XFS_BUF_SET_IODONE_FUNC(bp, xlog_recover_iodone);
 	xfs_bdwrite(mp, bp);
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
