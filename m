Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1DD2TdS180900 for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 07:02:29 -0600
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DE75192C869
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 05:01:53 -0800 (PST)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de
	[85.214.69.204]) by cuda.sgi.com with ESMTP id xFXWMDVDoQwcI2az
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 05:01:53 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 8F14B400891C
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 14:01:52 +0100 (CET)
Date: Fri, 13 Feb 2009 14:01:52 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: xfs: add device name to kthreads
Message-ID: <alpine.LSU.2.00.0902131357170.9310@fbirervta.pbzchgretzou.qr>
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

Hi developers,


suggestive cosmetic patch. Could also help beginners to identify why 
there are so (potentially) many xfs threads around.

==8<==
parent 87afd28ea9ab9db1c5c8a26741a9b96e10d5b0d4 (v2.6.29-rc4-19-g87afd28)
commit 989a86ff4846d81ad6fbf28432c72df21598c11c
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Feb 9 10:30:40 2009 +0100

xfs: add name to kthreads

I thought it would be nice to see the device name in ps(1)'s, so
let's have it. I am aware that the proc name is limited to 16
characters or so (just being able to fit in xfssyncd/sdxy15), but it
is better than none.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 fs/xfs/linux-2.6/xfs_buf.c   |   10 ++++++----
 fs/xfs/linux-2.6/xfs_buf.h   |    2 +-
 fs/xfs/linux-2.6/xfs_super.c |   11 ++++++-----
 fs/xfs/linux-2.6/xfs_sync.c  |    2 +-
 fs/xfs/xfs_trans_ail.c       |    2 +-
 fs/xfs/xfs_trans_priv.h      |    2 +-
 6 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index d71dc44..e96cce0 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1469,7 +1469,8 @@ xfs_mapping_buftarg(
 
 STATIC int
 xfs_alloc_delwrite_queue(
-	xfs_buftarg_t		*btp)
+	xfs_buftarg_t		*btp,
+	const char *fsname)
 {
 	int	error = 0;
 
@@ -1477,7 +1478,7 @@ xfs_alloc_delwrite_queue(
 	INIT_LIST_HEAD(&btp->bt_delwrite_queue);
 	spin_lock_init(&btp->bt_delwrite_lock);
 	btp->bt_flags = 0;
-	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd");
+	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd/%s", fsname);
 	if (IS_ERR(btp->bt_task)) {
 		error = PTR_ERR(btp->bt_task);
 		goto out_error;
@@ -1490,7 +1491,8 @@ out_error:
 xfs_buftarg_t *
 xfs_alloc_buftarg(
 	struct block_device	*bdev,
-	int			external)
+	int			external,
+	const char *fsname)
 {
 	xfs_buftarg_t		*btp;
 
@@ -1502,7 +1504,7 @@ xfs_alloc_buftarg(
 		goto error;
 	if (xfs_mapping_buftarg(btp, bdev))
 		goto error;
-	if (xfs_alloc_delwrite_queue(btp))
+	if (xfs_alloc_delwrite_queue(btp, fsname))
 		goto error;
 	xfs_alloc_bufhash(btp, external);
 	return btp;
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 288ae7c..185beb9 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -412,7 +412,7 @@ static inline int XFS_bwrite(xfs_buf_t *bp)
 /*
  *	Handling of buftargs.
  */
-extern xfs_buftarg_t *xfs_alloc_buftarg(struct block_device *, int);
+extern xfs_buftarg_t *xfs_alloc_buftarg(struct block_device *, int, const char *);
 extern void xfs_free_buftarg(xfs_buftarg_t *);
 extern void xfs_wait_buftarg(xfs_buftarg_t *);
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index c71e226..0a9b25d 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -789,18 +789,18 @@ xfs_open_devices(
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
@@ -900,10 +900,11 @@ xfsaild(
 
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
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index a608e72..932dd4e 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -545,7 +545,7 @@ xfs_syncd_init(
 {
 	mp->m_sync_work.w_syncer = xfs_sync_worker;
 	mp->m_sync_work.w_mount = mp;
-	mp->m_sync_task = kthread_run(xfssyncd, mp, "xfssyncd");
+	mp->m_sync_task = kthread_run(xfssyncd, mp, "xfssyncd/%s", mp->m_fsname);
 	if (IS_ERR(mp->m_sync_task))
 		return -PTR_ERR(mp->m_sync_task);
 	return 0;
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 2d47f10..912e3d7 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -581,7 +581,7 @@ xfs_trans_ail_init(
 	ailp->xa_mount = mp;
 	INIT_LIST_HEAD(&ailp->xa_ail);
 	spin_lock_init(&ailp->xa_lock);
-	error = xfsaild_start(ailp);
+	error = xfsaild_start(ailp, mp->m_fsname);
 	if (error)
 		goto out_free_ailp;
 	mp->m_ail = ailp;
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 73e2ad3..e8684af 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -107,7 +107,7 @@ void			xfs_trans_ail_cursor_done(struct xfs_ail *ailp,
 
 long	xfsaild_push(struct xfs_ail *, xfs_lsn_t *);
 void	xfsaild_wakeup(struct xfs_ail *, xfs_lsn_t);
-int	xfsaild_start(struct xfs_ail *);
+int	xfsaild_start(struct xfs_ail *, const char *);
 void	xfsaild_stop(struct xfs_ail *);
 
 #if BITS_PER_LONG != 64
-- 
# Created with git-export-patch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
