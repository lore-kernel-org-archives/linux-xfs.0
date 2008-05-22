Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 May 2008 01:51:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4M8pqYl009988
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 01:51:52 -0700
Received: from tyo202.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B6850BC1365
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 01:52:42 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206]) by cuda.sgi.com with ESMTP id EKAPKBZYBRMBj2tH for <xfs@oss.sgi.com>; Thu, 22 May 2008 01:52:42 -0700 (PDT)
Subject: [RFC PATCH 3/3] Add timeout feature
Message-Id: <20080522175229t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Thu, 22 May 2008 17:52:29 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

The timeout feature is added to freeze ioctl.  And new ioctl
to reset the timeout period is added.
o Freeze the filesystem
  int ioctl(int fd, int FIFREEZE, long *timeval)
    fd: The file descriptor of the mountpoint
    FIFREEZE: request code for the freeze
    timeval: the timeout period in seconds
             If it's 0 or 1, the timeout isn't set.
             This special case of "1" is implemented to keep
             the compatibility with XFS applications.
    Return value: 0 if the operation succeeds. Otherwise, -1

o Reset the timeout period
  int ioctl(int fd, int FIFREEZE_RESET_TIMEOUT, long *timeval)
    fd:file descriptor of mountpoint
    FIFREEZE_RESET_TIMEOUT: request code for reset of timeout period
    timeval: new timeout period in seconds
    Return value: 0 if the operation succeeds. Otherwise, -1
    Error number: If the filesystem has already been unfrozen,
                  errno is set to EINVAL.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 drivers/md/dm.c             |    2 -
 fs/block_dev.c              |    2 +
 fs/buffer.c                 |   14 ++++++-
 fs/ioctl.c                  |   78 ++++++++++++++++++++++++++++++++++++++++++--
 fs/super.c                  |   51 ++++++++++++++++++++++++++++
 fs/xfs/xfs_fsops.c          |    2 -
 include/linux/buffer_head.h |    2 -
 include/linux/fs.h          |    8 ++++
 8 files changed, 151 insertions(+), 8 deletions(-)

diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.26-rc3-xfs/drivers/md/dm.c linux-2.6.26-rc3-timeout/drivers
/md/dm.c
--- linux-2.6.26-rc3-xfs/drivers/md/dm.c	2008-05-19 21:03:48.000000000 +0900
+++ linux-2.6.26-rc3-timeout/drivers/md/dm.c	2008-05-19 21:05:46.000000000 +0900
@@ -1407,7 +1407,7 @@ static int lock_fs(struct mapped_device 
 
 	WARN_ON(md->frozen_sb);
 
-	md->frozen_sb = freeze_bdev(md->suspended_bdev);
+	md->frozen_sb = freeze_bdev(md->suspended_bdev, 0);
 	if (IS_ERR(md->frozen_sb)) {
 		r = PTR_ERR(md->frozen_sb);
 		md->frozen_sb = NULL;
diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.26-rc3-xfs/fs/block_dev.c linux-2.6.26-rc3-timeout/fs/block
_dev.c
--- linux-2.6.26-rc3-xfs/fs/block_dev.c	2008-05-19 21:04:00.000000000 +0900
+++ linux-2.6.26-rc3-timeout/fs/block_dev.c	2008-05-19 21:05:46.000000000 +0900
@@ -284,6 +284,8 @@ static void init_once(struct kmem_cache 
 	INIT_LIST_HEAD(&bdev->bd_holder_list);
 #endif
 	inode_init_once(&ei->vfs_inode);
+	/* Setup freeze timeout function. */
+	INIT_DELAYED_WORK(&bdev->bd_freeze_timeout, freeze_timeout);
 }
 
 static inline void __bd_forget(struct inode *inode)
diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.26-rc3-xfs/fs/buffer.c linux-2.6.26-rc3-timeout/fs/buffer.c
--- linux-2.6.26-rc3-xfs/fs/buffer.c	2008-05-19 21:03:59.000000000 +0900
+++ linux-2.6.26-rc3-timeout/fs/buffer.c	2008-05-19 21:05:46.000000000 +0900
@@ -190,14 +190,17 @@ int fsync_bdev(struct block_device *bdev
 
 /**
  * freeze_bdev  --  lock a filesystem and force it into a consistent state
- * @bdev:	blockdevice to lock
+ * @bdev:              blockdevice to lock
+ * @timeout_msec:      timeout period
  *
  * This takes the block device bd_mount_sem to make sure no new mounts
  * happen on bdev until thaw_bdev() is called.
  * If a superblock is found on this device, we take the s_umount semaphore
  * on it to make sure nobody unmounts until the snapshot creation is done.
+ * If timeout_msec is bigger than 0, this registers the delayed work for
+ * timeout of the freeze feature.
  */
-struct super_block *freeze_bdev(struct block_device *bdev)
+struct super_block *freeze_bdev(struct block_device *bdev, long timeout_msec)
 {
 	struct super_block *sb;
 
@@ -234,6 +237,10 @@ struct super_block *freeze_bdev(struct b
 	}
 
 	sync_blockdev(bdev);
+	/* Setup unfreeze timer. */
+	if (timeout_msec > 0)
+		add_freeze_timeout(bdev, timeout_msec);
+
 	clear_bit(BD_FREEZE_OP, &bdev->bd_state);
 
 	return sb;	/* thaw_bdev releases s->s_umount and bd_mount_sem */
@@ -258,6 +265,9 @@ int thaw_bdev(struct block_device *bdev,
 		return 0;
 	}
 
+	/* Delete unfreeze timer. */
+	del_freeze_timeout(bdev);
+
 	if (sb) {
 		BUG_ON(sb->s_bdev != bdev);
 
diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.26-rc3-xfs/fs/ioctl.c linux-2.6.26-rc3-timeout/fs/ioctl.c
--- linux-2.6.26-rc3-xfs/fs/ioctl.c	2008-05-21 11:44:51.000000000 +0900
+++ linux-2.6.26-rc3-timeout/fs/ioctl.c	2008-05-21 11:45:29.000000000 +0900
@@ -145,12 +145,16 @@ static int ioctl_fioasync(unsigned int f
  * ioctl_freeze - Freeze the filesystem.
  *
  * @filp:	target file
+ * @argp:       timeout value(sec)
  *
  * Call freeze_bdev() to freeze the filesystem.
  */
-static int ioctl_freeze(struct file *filp)
+static int ioctl_freeze(struct file *filp, unsigned long arg)
 {
+	long timeout_sec;
+	long timeout_msec;
 	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+	int error;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -159,8 +163,27 @@ static int ioctl_freeze(struct file *fil
 	if (sb->s_op->write_super_lockfs == NULL)
 		return -EOPNOTSUPP;
 
+	/* arg(sec) to tick value. */
+	error = get_user(timeout_sec, (long __user *) arg);
+	if (error != 0)
+		return error;
+	/*
+	 * If 1 is specified as the timeout period,
+	 * it will be changed into 0 to keep the compatibility
+	 * of XFS application(xfs_freeze).
+	 */
+	if (timeout_sec < 0)
+		return -EINVAL;
+	else if (timeout_sec < 2)
+		timeout_sec = 0;
+
+	timeout_msec = timeout_sec * 1000;
+	/* overflow case */
+	if (timeout_msec < 0)
+		return -EINVAL;
+
 	/* Freeze */
-	sb = freeze_bdev(sb->s_bdev);
+	sb = freeze_bdev(sb->s_bdev, timeout_msec);
 	if (IS_ERR(sb))
 		return PTR_ERR(sb);
 	return 0;
@@ -185,6 +208,51 @@ static int ioctl_thaw(struct file *filp)
 }
 
 /*
+ * ioctl_freeze_reset_timeout - Reset timeout for freeze.
+ *
+ * @filp:       target file
+ * @argp:       timeout value(sec)
+ *
+ * Rest timeout for freeze.
+ */
+static int
+ioctl_freeze_reset_timeout(struct file *filp, unsigned long arg)
+{
+	long timeout_sec;
+	long timeout_msec;
+	struct super_block *sb
+			= filp->f_path.dentry->d_inode->i_sb;
+	int error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* arg(sec) to tick value */
+	error = get_user(timeout_sec, (long __user *) arg);
+	if (error)
+		return error;
+	timeout_msec = timeout_sec * 1000;
+	if (timeout_msec < 0)
+		return -EINVAL;
+
+	if (sb) {
+		if (test_and_set_bit(BD_FREEZE_OP, &sb->s_bdev->bd_state))
+			return -EBUSY;
+		if (sb->s_frozen == SB_UNFROZEN) {
+			clear_bit(BD_FREEZE_OP, &sb->s_bdev->bd_state);
+			return -EINVAL;
+		}
+		/* setup unfreeze timer */
+		if (timeout_msec > 0)
+			add_freeze_timeout(sb->s_bdev,
+					timeout_msec);
+		clear_bit(BD_FREEZE_OP, &sb->s_bdev->bd_state);
+	}
+
+	return 0;
+}
+
+/*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
  *
@@ -227,13 +295,17 @@ int do_vfs_ioctl(struct file *filp, unsi
 		break;
 
 	case FIFREEZE:
-		error = ioctl_freeze(filp);
+		error = ioctl_freeze(filp, arg);
 		break;
 
 	case FITHAW:
 		error = ioctl_thaw(filp);
 		break;
 
+	case FIFREEZE_RESET_TIMEOUT:
+		error = ioctl_freeze_reset_timeout(filp, arg);
+		break;
+
 	default:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.26-rc3-xfs/fs/super.c linux-2.6.26-rc3-timeout/fs/super.c
--- linux-2.6.26-rc3-xfs/fs/super.c	2008-05-19 21:04:00.000000000 +0900
+++ linux-2.6.26-rc3-timeout/fs/super.c	2008-05-19 21:05:46.000000000 +0900
@@ -1010,3 +1010,54 @@ struct vfsmount *kern_mount_data(struct 
 }
 
 EXPORT_SYMBOL_GPL(kern_mount_data);
+
+/*
+ * freeze_timeout - Thaw the filesystem.
+ *
+ * @work:	work queue (delayed_work.work)
+ *
+ * Called by the delayed work when elapsing the timeout period.
+ * Thaw the filesystem.
+ */
+void freeze_timeout(struct work_struct *work)
+{
+	struct block_device *bd = container_of(work,
+			struct block_device, bd_freeze_timeout.work);
+	struct super_block *sb = get_super_without_lock(bd);
+
+	thaw_bdev(bd, sb);
+
+	if (sb)
+		put_super(sb);
+}
+EXPORT_SYMBOL_GPL(freeze_timeout);
+
+/*
+ * add_freeze_timeout - Add timeout for freeze.
+ *
+ * @bdev:		block device struct
+ * @timeout_msec:	timeout period
+ *
+ * Add the delayed work for freeze timeout to the delayed work queue.
+ */
+void add_freeze_timeout(struct block_device *bdev, long timeout_msec)
+{
+	s64 timeout_jiffies = msecs_to_jiffies(timeout_msec);
+
+	/* Set delayed work queue */
+	cancel_delayed_work(&bdev->bd_freeze_timeout);
+	schedule_delayed_work(&bdev->bd_freeze_timeout, timeout_jiffies);
+}
+
+/*
+ * del_freeze_timeout - Delete timeout for freeze.
+ *
+ * @bdev:	block device struct
+ *
+ * Delete the delayed work for freeze timeout from the delayed work queue.
+ */
+void del_freeze_timeout(struct block_device *bdev)
+{
+	if (delayed_work_pending(&bdev->bd_freeze_timeout))
+		cancel_delayed_work(&bdev->bd_freeze_timeout);
+}
diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.26-rc3-xfs/fs/xfs/xfs_fsops.c linux-2.6.26-rc3-timeout/fs/x
fs/xfs_fsops.c
--- linux-2.6.26-rc3-xfs/fs/xfs/xfs_fsops.c	2008-05-19 21:04:00.000000000 +0900
+++ linux-2.6.26-rc3-timeout/fs/xfs/xfs_fsops.c	2008-05-19 21:05:46.000000000 +0900
@@ -619,7 +619,7 @@ xfs_fs_goingdown(
 {
 	switch (inflags) {
 	case XFS_FSOP_GOING_FLAGS_DEFAULT: {
-		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev);
+		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev, 0);
 
 		if (sb && !IS_ERR(sb)) {
 			xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.26-rc3-xfs/include/linux/buffer_head.h linux-2.6.26-rc3-tim
eout/include/linux/buffer_head.h
--- linux-2.6.26-rc3-xfs/include/linux/buffer_head.h	2008-05-19 21:04:00.000000000 +0900
+++ linux-2.6.26-rc3-timeout/include/linux/buffer_head.h	2008-05-19 21:05:46.000000000 +0900
@@ -170,7 +170,7 @@ int sync_blockdev(struct block_device *b
 void __wait_on_buffer(struct buffer_head *);
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
-struct super_block *freeze_bdev(struct block_device *);
+struct super_block *freeze_bdev(struct block_device *, long timeout_msec);
 int thaw_bdev(struct block_device *, struct super_block *);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.26-rc3-xfs/include/linux/fs.h linux-2.6.26-rc3-timeout/incl
ude/linux/fs.h
--- linux-2.6.26-rc3-xfs/include/linux/fs.h	2008-05-19 21:04:00.000000000 +0900
+++ linux-2.6.26-rc3-timeout/include/linux/fs.h	2008-05-19 21:05:46.000000000 +0900
@@ -8,6 +8,7 @@
 
 #include <linux/limits.h>
 #include <linux/ioctl.h>
+#include <linux/workqueue.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -225,6 +226,7 @@ extern int dir_notify_enable;
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
 #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
+#define	FIFREEZE_RESET_TIMEOUT	_IO(0x00, 3)	/* Reset freeze timeout */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -559,6 +561,8 @@ struct block_device {
 
 	/* State of the block device. (Used by freeze feature) */
 	unsigned long		bd_state;
+	/* Delayed work for freeze */
+	struct delayed_work     bd_freeze_timeout;
 };
 
 /*
@@ -2146,5 +2150,9 @@ int proc_nr_files(struct ctl_table *tabl
 
 int get_filesystem_list(char * buf);
 
+extern void add_freeze_timeout(struct block_device *bdev, long timeout_msec);
+extern void del_freeze_timeout(struct block_device *bdev);
+extern void freeze_timeout(struct work_struct *work);
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
