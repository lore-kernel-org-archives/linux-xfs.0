Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o26JXE1R114893 for <xfs@oss.sgi.com>; Sat, 6 Mar 2010 13:33:15 -0600
Received: from borg.medozas.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 010DB2205E3
	for <xfs@oss.sgi.com>; Sat,  6 Mar 2010 11:34:43 -0800 (PST)
Received: from borg.medozas.de (borg.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id RPeLwI1Md7xVEvR4 for
	<xfs@oss.sgi.com>; Sat, 06 Mar 2010 11:34:43 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by borg.medozas.de (Postfix) with ESMTP id 7C09C69E9
	for <xfs@oss.sgi.com>; Sat,  6 Mar 2010 20:34:39 +0100 (CET)
Date: Sat, 6 Mar 2010 20:34:39 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: xfs: add fs name to kthreads
Message-ID: <alpine.LSU.2.01.1003062033100.16438@obet.zrqbmnf.qr>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---

 fs/xfs/linux-2.6/xfs_buf.c   |   10 ++++++----
 fs/xfs/linux-2.6/xfs_buf.h   |    2 +-
 fs/xfs/linux-2.6/xfs_super.c |   11 ++++++-----
 fs/xfs/linux-2.6/xfs_sync.c  |    2 +-
 fs/xfs/xfs_trans_ail.c       |    2 +-
 fs/xfs/xfs_trans_priv.h      |    2 +-
 6 files changed, 16 insertions(+), 13 deletions(-)


Index: linux-2.6.33/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.33.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6.33/fs/xfs/linux-2.6/xfs_buf.c
@@ -1527,7 +1527,8 @@ xfs_mapping_buftarg(
 
 STATIC int
 xfs_alloc_delwrite_queue(
-	xfs_buftarg_t		*btp)
+	xfs_buftarg_t		*btp,
+	const char *fsname)
 {
 	int	error = 0;
 
@@ -1535,7 +1536,7 @@ xfs_alloc_delwrite_queue(
 	INIT_LIST_HEAD(&btp->bt_delwrite_queue);
 	spin_lock_init(&btp->bt_delwrite_lock);
 	btp->bt_flags = 0;
-	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd");
+	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd/%s", fsname);
 	if (IS_ERR(btp->bt_task)) {
 		error = PTR_ERR(btp->bt_task);
 		goto out_error;
@@ -1548,7 +1549,8 @@ out_error:
 xfs_buftarg_t *
 xfs_alloc_buftarg(
 	struct block_device	*bdev,
-	int			external)
+	int			external,
+	const char *fsname)
 {
 	xfs_buftarg_t		*btp;
 
@@ -1560,7 +1562,7 @@ xfs_alloc_buftarg(
 		goto error;
 	if (xfs_mapping_buftarg(btp, bdev))
 		goto error;
-	if (xfs_alloc_delwrite_queue(btp))
+	if (xfs_alloc_delwrite_queue(btp, fsname))
 		goto error;
 	xfs_alloc_bufhash(btp, external);
 	return btp;
Index: linux-2.6.33/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- linux-2.6.33.orig/fs/xfs/linux-2.6/xfs_buf.h
+++ linux-2.6.33/fs/xfs/linux-2.6/xfs_buf.h
@@ -419,7 +419,7 @@ static inline int XFS_bwrite(xfs_buf_t *
 /*
  *	Handling of buftargs.
  */
-extern xfs_buftarg_t *xfs_alloc_buftarg(struct block_device *, int);
+extern xfs_buftarg_t *xfs_alloc_buftarg(struct block_device *, int, const char *);
 extern void xfs_free_buftarg(struct xfs_mount *, struct xfs_buftarg *);
 extern void xfs_wait_buftarg(xfs_buftarg_t *);
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
Index: linux-2.6.33/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.33.orig/fs/xfs/linux-2.6/xfs_super.c
+++ linux-2.6.33/fs/xfs/linux-2.6/xfs_super.c
@@ -788,18 +788,18 @@ xfs_open_devices(
 	 * Setup xfs_mount buffer target pointers
 	 */
 	error = ENOMEM;
-	mp->m_ddev_targp = xfs_alloc_buftarg(ddev, 0);
+	mp->m_ddev_targp = xfs_alloc_buftarg(ddev, 0, mp->m_fsname);
 	if (!mp->m_ddev_targp)
 		goto out_close_rtdev;
 
 	if (rtdev) {
-		mp->m_rtdev_targp = xfs_alloc_buftarg(rtdev, 1);
+		mp->m_rtdev_targp = xfs_alloc_buftarg(rtdev, 1, mp->m_fsname);
 		if (!mp->m_rtdev_targp)
 			goto out_free_ddev_targ;
 	}
 
 	if (logdev && logdev != ddev) {
-		mp->m_logdev_targp = xfs_alloc_buftarg(logdev, 1);
+		mp->m_logdev_targp = xfs_alloc_buftarg(logdev, 1, mp->m_fsname);
 		if (!mp->m_logdev_targp)
 			goto out_free_rtdev_targ;
 	} else {
@@ -899,10 +899,11 @@ xfsaild(
 
 int
 xfsaild_start(
-	struct xfs_ail	*ailp)
+	struct xfs_ail	*ailp,
+	const char *fsname)
 {
 	ailp->xa_target = 0;
-	ailp->xa_task = kthread_run(xfsaild, ailp, "xfsaild");
+	ailp->xa_task = kthread_run(xfsaild, ailp, "xfsaild/%s", fsname);
 	if (IS_ERR(ailp->xa_task))
 		return -PTR_ERR(ailp->xa_task);
 	return 0;
Index: linux-2.6.33/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux-2.6.33.orig/fs/xfs/linux-2.6/xfs_sync.c
+++ linux-2.6.33/fs/xfs/linux-2.6/xfs_sync.c
@@ -658,7 +658,7 @@ xfs_syncd_init(
 	mp->m_sync_work.w_syncer = xfs_sync_worker;
 	mp->m_sync_work.w_mount = mp;
 	mp->m_sync_work.w_completion = NULL;
-	mp->m_sync_task = kthread_run(xfssyncd, mp, "xfssyncd");
+	mp->m_sync_task = kthread_run(xfssyncd, mp, "xfssyncd/%s", mp->m_fsname);
 	if (IS_ERR(mp->m_sync_task))
 		return -PTR_ERR(mp->m_sync_task);
 	return 0;
Index: linux-2.6.33/fs/xfs/xfs_trans_ail.c
===================================================================
--- linux-2.6.33.orig/fs/xfs/xfs_trans_ail.c
+++ linux-2.6.33/fs/xfs/xfs_trans_ail.c
@@ -598,7 +598,7 @@ xfs_trans_ail_init(
 	ailp->xa_mount = mp;
 	INIT_LIST_HEAD(&ailp->xa_ail);
 	spin_lock_init(&ailp->xa_lock);
-	error = xfsaild_start(ailp);
+	error = xfsaild_start(ailp, mp->m_fsname);
 	if (error)
 		goto out_free_ailp;
 	mp->m_ail = ailp;
Index: linux-2.6.33/fs/xfs/xfs_trans_priv.h
===================================================================
--- linux-2.6.33.orig/fs/xfs/xfs_trans_priv.h
+++ linux-2.6.33/fs/xfs/xfs_trans_priv.h
@@ -107,7 +107,7 @@ void			xfs_trans_ail_cursor_done(struct
 
 long	xfsaild_push(struct xfs_ail *, xfs_lsn_t *);
 void	xfsaild_wakeup(struct xfs_ail *, xfs_lsn_t);
-int	xfsaild_start(struct xfs_ail *);
+int	xfsaild_start(struct xfs_ail *, const char *);
 void	xfsaild_stop(struct xfs_ail *);
 
 #if BITS_PER_LONG != 64

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
