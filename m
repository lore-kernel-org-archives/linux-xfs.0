Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2IEBcZs139326 for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 09:11:43 -0500
Received: from borg.medozas.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED10314402E8
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 07:13:11 -0700 (PDT)
Received: from borg.medozas.de (borg.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id qBMZzu9qHbTT91Mf for
	<xfs@oss.sgi.com>; Thu, 18 Mar 2010 07:13:11 -0700 (PDT)
Date: Thu, 18 Mar 2010 15:13:10 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xfs: add fs name to kthreads
In-Reply-To: <20100308012824.GH28189@discord.disaster>
Message-ID: <alpine.LSU.2.01.1003181510240.30506@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1003062033100.16438@obet.zrqbmnf.qr>
	<20100308012824.GH28189@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


On Monday 2010-03-08 02:28, Dave Chinner wrote:
>
>Looks ok, but a couple of things. First, it would be good if you
>supplied a reason/justification for the patch so the commit message
>will tell us why this change was made.
>
>Please keep the same indent style as the rest of the functions. i.e

>>  xfsaild_start(
>> -	struct xfs_ail	*ailp)
>> +	struct xfs_ail	*ailp,
>> +	const char *fsname)
>>  {
>>  	ailp->xa_target = 0;
>> -	ailp->xa_task = kthread_run(xfsaild, ailp, "xfsaild");
>> +	ailp->xa_task = kthread_run(xfsaild, ailp, "xfsaild/%s", fsname);
>
>No need to pass the name into this function. It can be retrieved
>from ailp->xa_mount->m_fsname.

I think I've got that now.

N.B.: The xfslogd/N threads are obvious (percpu workqueue, or
whatever the tech is currently called), but at one time in the
past it struck me that I had lots of xfsbufd/aild/syncd without
the /n suffix.

parent 8bee4bad03c5b601bd6cea123c31025680587ccc (v2.6.34-rc1-1099-g8bee4ba)
commit 5ed80bc8adebca15e73b815aec45d434013c79f0
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Mar 18 14:25:17 2010 +0100

xfs: add blockdev name to kthreads

This allows to see in `ps` and similar tools which kthreads are
allotted to which block device/filesystem, similar to what jbd2
does. As the process name is a fixed 16-char array, no extra
space is needed in tasks.

  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
  197 ?        S      0:00  \_ [jbd2/sda2-8]
  198 ?        S      0:00  \_ [ext4-dio-unwrit]
  204 ?        S      0:00  \_ [flush-8:0]
 2647 ?        S      0:00  \_ [xfs_mru_cache]
 2648 ?        S      0:00  \_ [xfslogd/0]
 2649 ?        S      0:00  \_ [xfsdatad/0]
 2650 ?        S      0:00  \_ [xfsconvertd/0]
 2651 ?        S      0:00  \_ [xfsbufd/ram0]
 2652 ?        S      0:00  \_ [xfsaild/ram0]
 2653 ?        S      0:00  \_ [xfssyncd/ram0]

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 fs/xfs/linux-2.6/xfs_buf.c   |   10 ++++++----
 fs/xfs/linux-2.6/xfs_buf.h   |    2 +-
 fs/xfs/linux-2.6/xfs_super.c |    9 +++++----
 fs/xfs/linux-2.6/xfs_sync.c  |    2 +-
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 6f76ba8..7ea613a 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1684,7 +1684,8 @@ xfs_mapping_buftarg(
 
 STATIC int
 xfs_alloc_delwrite_queue(
-	xfs_buftarg_t		*btp)
+	xfs_buftarg_t		*btp,
+	const char		*fsname)
 {
 	int	error = 0;
 
@@ -1692,7 +1693,7 @@ xfs_alloc_delwrite_queue(
 	INIT_LIST_HEAD(&btp->bt_delwrite_queue);
 	spin_lock_init(&btp->bt_delwrite_lock);
 	btp->bt_flags = 0;
-	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd");
+	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd/%s", fsname);
 	if (IS_ERR(btp->bt_task)) {
 		error = PTR_ERR(btp->bt_task);
 		goto out_error;
@@ -1705,7 +1706,8 @@ out_error:
 xfs_buftarg_t *
 xfs_alloc_buftarg(
 	struct block_device	*bdev,
-	int			external)
+	int			external,
+	const char		*fsname)
 {
 	xfs_buftarg_t		*btp;
 
@@ -1717,7 +1719,7 @@ xfs_alloc_buftarg(
 		goto error;
 	if (xfs_mapping_buftarg(btp, bdev))
 		goto error;
-	if (xfs_alloc_delwrite_queue(btp))
+	if (xfs_alloc_delwrite_queue(btp, fsname))
 		goto error;
 	xfs_alloc_bufhash(btp, external);
 	return btp;
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 386e736..5fbecef 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -390,7 +390,7 @@ static inline void xfs_buf_relse(xfs_buf_t *bp)
 /*
  *	Handling of buftargs.
  */
-extern xfs_buftarg_t *xfs_alloc_buftarg(struct block_device *, int);
+extern xfs_buftarg_t *xfs_alloc_buftarg(struct block_device *, int, const char *);
 extern void xfs_free_buftarg(struct xfs_mount *, struct xfs_buftarg *);
 extern void xfs_wait_buftarg(xfs_buftarg_t *);
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 71345a3..15bea67 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
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
@@ -901,7 +901,8 @@ xfsaild_start(
 	struct xfs_ail	*ailp)
 {
 	ailp->xa_target = 0;
-	ailp->xa_task = kthread_run(xfsaild, ailp, "xfsaild");
+	ailp->xa_task = kthread_run(xfsaild, ailp, "xfsaild/%s",
+				    ailp->xa_mount->m_fsname);
 	if (IS_ERR(ailp->xa_task))
 		return -PTR_ERR(ailp->xa_task);
 	return 0;
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 05cd853..97813e7 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -652,7 +652,7 @@ xfs_syncd_init(
 	mp->m_sync_work.w_syncer = xfs_sync_worker;
 	mp->m_sync_work.w_mount = mp;
 	mp->m_sync_work.w_completion = NULL;
-	mp->m_sync_task = kthread_run(xfssyncd, mp, "xfssyncd");
+	mp->m_sync_task = kthread_run(xfssyncd, mp, "xfssyncd/%s", mp->m_fsname);
 	if (IS_ERR(mp->m_sync_task))
 		return -PTR_ERR(mp->m_sync_task);
 	return 0;
-- 
# Created with git-export-patch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
