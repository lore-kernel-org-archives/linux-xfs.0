Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53m9h135285 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:48 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5VAP4FUdo4hnWU70 for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:33 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pap-0003HT-Ct
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:31 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaV-0003fD-9I
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 049/102] xfs: use per-filesystem I/O completion workqueues
Date: Thu, 23 Aug 2012 15:02:07 +1000
Message-Id: <1345698180-13612-50-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: aa6bf01d391935a8929333bc2e243084ea0c58db

The new concurrency managed workqueues are cheap enough that we can create
per-filesystem instead of global workqueues.  This allows us to remove the
trylock or defer scheme on the ilock, which is not helpful once we have
outstanding log reservations until finishing a size update.

Also allow the default concurrency on this workqueues so that I/O completions
blocking on the ilock for one inode do not block process for another inode.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c  |   39 ++++++++-----------------------
 fs/xfs/linux-2.6/xfs_aops.h  |    2 --
 fs/xfs/linux-2.6/xfs_buf.c   |   17 --------------
 fs/xfs/linux-2.6/xfs_super.c |   53 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_mount.h           |    5 ++++
 5 files changed, 67 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 91aa080..6a3cafc 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -160,21 +160,15 @@ static inline bool xfs_ioend_is_append(struct xfs_ioend *ioend)
 
 /*
  * Update on-disk file size now that data has been written to disk.
- *
- * This function does not block as blocking on the inode lock in IO completion
- * can lead to IO completion order dependency deadlocks.. If it can't get the
- * inode ilock it will return EAGAIN. Callers must handle this.
  */
-STATIC int
+STATIC void
 xfs_setfilesize(
-	xfs_ioend_t		*ioend)
+	struct xfs_ioend	*ioend)
 {
-	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	xfs_fsize_t		isize;
 
-	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
-		return EAGAIN;
-
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	isize = xfs_ioend_new_eof(ioend);
 	if (isize) {
 		ip->i_d.di_size = isize;
@@ -182,7 +176,6 @@ xfs_setfilesize(
 	}
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return 0;
 }
 
 /*
@@ -196,10 +189,12 @@ xfs_finish_ioend(
 	struct xfs_ioend	*ioend)
 {
 	if (atomic_dec_and_test(&ioend->io_remaining)) {
+		struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
+
 		if (ioend->io_type == IO_UNWRITTEN)
-			queue_work(xfsconvertd_workqueue, &ioend->io_work);
+			queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
 		else if (xfs_ioend_is_append(ioend))
-			queue_work(xfsdatad_workqueue, &ioend->io_work);
+			queue_work(mp->m_data_workqueue, &ioend->io_work);
 		else
 			xfs_destroy_ioend(ioend);
 	}
@@ -240,23 +235,9 @@ xfs_end_io(
 	 * We might have to update the on-disk file size after extending
 	 * writes.
 	 */
-	error = xfs_setfilesize(ioend);
-	ASSERT(!error || error == EAGAIN);
-
+	xfs_setfilesize(ioend);
 done:
-	/*
-	 * If we didn't complete processing of the ioend, requeue it to the
-	 * tail of the workqueue for another attempt later. Otherwise destroy
-	 * it.
-	 */
-	if (error == EAGAIN) {
-		atomic_inc(&ioend->io_remaining);
-		xfs_finish_ioend(ioend);
-		/* ensure we don't spin on blocked ioends */
-		delay(1);
-	} else {
-		xfs_destroy_ioend(ioend);
-	}
+	xfs_destroy_ioend(ioend);
 }
 
 /*
diff --git a/fs/xfs/linux-2.6/xfs_aops.h b/fs/xfs/linux-2.6/xfs_aops.h
index ce3dcb5..4b48afc 100644
--- a/fs/xfs/linux-2.6/xfs_aops.h
+++ b/fs/xfs/linux-2.6/xfs_aops.h
@@ -18,8 +18,6 @@
 #ifndef __XFS_AOPS_H__
 #define __XFS_AOPS_H__
 
-extern struct workqueue_struct *xfsdatad_workqueue;
-extern struct workqueue_struct *xfsconvertd_workqueue;
 extern mempool_t *xfs_ioend_pool;
 
 /*
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 4508ec2..2df0b4a 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -46,8 +46,6 @@ STATIC int xfsbufd(void *);
 STATIC void xfs_buf_delwri_queue(xfs_buf_t *, int);
 
 static struct workqueue_struct *xfslogd_workqueue;
-struct workqueue_struct *xfsdatad_workqueue;
-struct workqueue_struct *xfsconvertd_workqueue;
 
 #ifdef XFS_BUF_LOCK_TRACKING
 # define XB_SET_OWNER(bp)	((bp)->b_last_holder = current->pid)
@@ -1856,21 +1854,8 @@ xfs_buf_init(void)
 	if (!xfslogd_workqueue)
 		goto out_free_buf_zone;
 
-	xfsdatad_workqueue = alloc_workqueue("xfsdatad", WQ_MEM_RECLAIM, 1);
-	if (!xfsdatad_workqueue)
-		goto out_destroy_xfslogd_workqueue;
-
-	xfsconvertd_workqueue = alloc_workqueue("xfsconvertd",
-						WQ_MEM_RECLAIM, 1);
-	if (!xfsconvertd_workqueue)
-		goto out_destroy_xfsdatad_workqueue;
-
 	return 0;
 
- out_destroy_xfsdatad_workqueue:
-	destroy_workqueue(xfsdatad_workqueue);
- out_destroy_xfslogd_workqueue:
-	destroy_workqueue(xfslogd_workqueue);
  out_free_buf_zone:
 	kmem_zone_destroy(xfs_buf_zone);
  out:
@@ -1880,8 +1865,6 @@ xfs_buf_init(void)
 void
 xfs_buf_terminate(void)
 {
-	destroy_workqueue(xfsconvertd_workqueue);
-	destroy_workqueue(xfsdatad_workqueue);
 	destroy_workqueue(xfslogd_workqueue);
 	kmem_zone_destroy(xfs_buf_zone);
 }
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 04dd4d4..1a1c26e 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -768,6 +768,50 @@ xfs_setup_devices(
 	return 0;
 }
 
+STATIC int
+xfs_init_mount_workqueues(
+	struct xfs_mount	*mp)
+{
+	mp->m_data_wq_name = kmalloc(strlen(mp->m_fsname) +
+					strlen("xfs-data/") + 1, GFP_KERNEL);
+	if (!mp->m_data_wq_name)
+		goto out;
+	sprintf(mp->m_data_wq_name, "xfs-data/%s", mp->m_fsname);
+	mp->m_data_workqueue = alloc_workqueue(mp->m_data_wq_name,
+						WQ_MEM_RECLAIM, 0);
+	if (!mp->m_data_workqueue)
+		goto out;
+
+	mp->m_unwritten_wq_name = kmalloc(strlen(mp->m_fsname) +
+					strlen("xfs-conv/") + 1, GFP_KERNEL);
+	if (!mp->m_unwritten_wq_name)
+		goto out_destroy_data_iodone_queue;
+	sprintf(mp->m_unwritten_wq_name, "xfs-conv/%s", mp->m_fsname);
+	mp->m_unwritten_workqueue = alloc_workqueue(mp->m_unwritten_wq_name,
+						WQ_MEM_RECLAIM, 0);
+	if (!mp->m_unwritten_workqueue)
+		goto out_destroy_data_iodone_queue;
+
+	return 0;
+
+out_destroy_data_iodone_queue:
+	destroy_workqueue(mp->m_data_workqueue);
+out:
+	kfree(mp->m_data_wq_name);
+	kfree(mp->m_unwritten_wq_name);
+	return -ENOMEM;
+}
+
+STATIC void
+xfs_destroy_mount_workqueues(
+	struct xfs_mount	*mp)
+{
+	destroy_workqueue(mp->m_data_workqueue);
+	destroy_workqueue(mp->m_unwritten_workqueue);
+	kfree(mp->m_data_wq_name);
+	kfree(mp->m_unwritten_wq_name);
+}
+
 /* Catch misguided souls that try to use this interface on XFS */
 STATIC struct inode *
 xfs_fs_alloc_inode(
@@ -1008,6 +1052,7 @@ xfs_fs_put_super(
 	xfs_unmountfs(mp);
 	xfs_freesb(mp);
 	xfs_icsb_destroy_counters(mp);
+	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);
 	xfs_free_fsname(mp);
 	kfree(mp);
@@ -1341,10 +1386,14 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_fsname;
 
-	error = xfs_icsb_init_counters(mp);
+	error = xfs_init_mount_workqueues(mp);
 	if (error)
 		goto out_close_devices;
 
+	error = xfs_icsb_init_counters(mp);
+	if (error)
+		goto out_destroy_workqueues;
+
 	error = xfs_readsb(mp, flags);
 	if (error)
 		goto out_destroy_counters;
@@ -1410,6 +1459,8 @@ xfs_fs_fill_super(
 	xfs_freesb(mp);
  out_destroy_counters:
 	xfs_icsb_destroy_counters(mp);
+out_destroy_workqueues:
+	xfs_destroy_mount_workqueues(mp);
  out_close_devices:
 	xfs_close_devices(mp);
  out_free_fsname:
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 3d68bb2..fdcb826 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -211,6 +211,11 @@ typedef struct xfs_mount {
 	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
+
+	struct workqueue_struct	*m_data_workqueue;
+	struct workqueue_struct	*m_unwritten_workqueue;
+	char			*m_data_wq_name;
+	char			*m_unwritten_wq_name;
 } xfs_mount_t;
 
 /*
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
