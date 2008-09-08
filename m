Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Sep 2008 04:52:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m88BqUpu013743
	for <xfs@oss.sgi.com>; Mon, 8 Sep 2008 04:52:34 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 964E941924C
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2008 04:53:53 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id jVBzRrmJTNoHDRl1 for <xfs@oss.sgi.com>; Mon, 08 Sep 2008 04:53:53 -0700 (PDT)
Subject: [PATCH 3/3] Add timeout feature
Message-Id: <20080908205337t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Mon, 8 Sep 2008 20:53:37 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

The timeout feature is added to "freeze ioctl" to solve a deadlock
when the freezer accesses a frozen filesystem. And new ioctl
to reset the timeout period is added to extend the timeout period.
For example, the freezer resets the timeout period to 10 seconds every 5
seconds.  In this approach, even if the freezer causes a deadlock by
accessing the frozen filesystem, it will be solved by the timeout
in 10 seconds and the freezer will be able to recognize that
at the next reset of timeout period.
o Freeze the filesystem
  int ioctl(int fd, int FIFREEZE, long *timeout_sec)
    fd: The file descriptor of the mountpoint
    FIFREEZE: request code for the freeze
    timeout_sec: the timeout period in seconds
             If it's 0 or 1, the timeout isn't set.
             This special case of "1" is implemented to keep
             the compatibility with XFS applications.
    Return value: 0 if the operation succeeds. Otherwise, -1

o Reset the timeout period
  int ioctl(int fd, int FIFREEZE_RESET_TIMEOUT, long *timeout_sec)
    fd:file descriptor of mountpoint
    FIFREEZE_RESET_TIMEOUT: request code for reset of timeout period
    timeout_sec: new timeout period in seconds
    Return value: 0 if the operation succeeds. Otherwise, -1
    Error number: If the filesystem has already been unfrozen,
                  errno is set to EINVAL.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 drivers/md/dm.c             |    2 -
 fs/block_dev.c              |    2 +
 fs/buffer.c                 |   44 ++++++++++++++++++++++++---
 fs/ioctl.c                  |   71 ++++++++++++++++++++++++++++++++++++++++++--
 fs/super.c                  |   37 ++++++++++++++++++++++
 fs/xfs/xfs_fsops.c          |    2 -
 include/linux/buffer_head.h |    4 +-
 include/linux/fs.h          |    8 ++++
 8 files changed, 159 insertions(+), 11 deletions(-)

diff -uprN -X linux-2.6.27-rc5.org/Documentation/dontdiff linux-2.6.27-rc5-xfs/drivers/md/dm.c linux-2.6.27-rc5-timeout/
drivers/md/dm.c
--- linux-2.6.27-rc5-xfs/drivers/md/dm.c	2008-09-05 19:59:59.000000000 +0900
+++ linux-2.6.27-rc5-timeout/drivers/md/dm.c	2008-09-05 17:47:47.000000000 +0900
@@ -1451,7 +1451,7 @@ static int lock_fs(struct mapped_device 
 
 	WARN_ON(md->frozen_sb);
 
-	md->frozen_sb = freeze_bdev(md->suspended_bdev);
+	md->frozen_sb = freeze_bdev(md->suspended_bdev, 0);
 	if (IS_ERR(md->frozen_sb)) {
 		r = PTR_ERR(md->frozen_sb);
 		md->frozen_sb = NULL;
diff -uprN -X linux-2.6.27-rc5.org/Documentation/dontdiff linux-2.6.27-rc5-xfs/fs/block_dev.c linux-2.6.27-rc5-timeout/f
s/block_dev.c
--- linux-2.6.27-rc5-xfs/fs/block_dev.c	2008-09-05 20:00:29.000000000 +0900
+++ linux-2.6.27-rc5-timeout/fs/block_dev.c	2008-09-05 17:47:47.000000000 +0900
@@ -287,6 +287,8 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 	/* Initialize mutex for freeze. */
 	mutex_init(&bdev->bd_fsfreeze_mutex);
+	/* Setup freeze timeout function. */
+	INIT_DELAYED_WORK(&bdev->bd_fsfreeze_timeout, fsfreeze_timeout);
 }
 
 static inline void __bd_forget(struct inode *inode)
diff -uprN -X linux-2.6.27-rc5.org/Documentation/dontdiff linux-2.6.27-rc5-xfs/fs/buffer.c linux-2.6.27-rc5-timeout/fs/b
uffer.c
--- linux-2.6.27-rc5-xfs/fs/buffer.c	2008-09-05 20:23:13.000000000 +0900
+++ linux-2.6.27-rc5-timeout/fs/buffer.c	2008-09-05 20:43:40.000000000 +0900
@@ -190,26 +190,36 @@ int fsync_bdev(struct block_device *bdev
 
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
  * The reference counter (bd_fsfreeze_count) guarantees that only the last
  * unfreeze process can unfreeze the frozen filesystem actually when multiple
  * freeze requests arrive simultaneously. It counts up in freeze_bdev() and
  * count down in thaw_bdev(). When it becomes 0, thaw_bdev() will unfreeze
  * actually.
  */
-struct super_block *freeze_bdev(struct block_device *bdev)
+struct super_block *freeze_bdev(struct block_device *bdev,
+				unsigned int timeout_msec)
 {
 	struct super_block *sb;
 
 	mutex_lock(&bdev->bd_fsfreeze_mutex);
 	if (bdev->bd_fsfreeze_count > 0) {
-		bdev->bd_fsfreeze_count++;
-		sb = get_super(bdev);
+		if ((delayed_work_pending(&bdev->bd_fsfreeze_timeout))
+				|| (timeout_msec != 0))
+			sb = ERR_PTR(-EBUSY);
+		else {
+			bdev->bd_fsfreeze_count++;
+			sb = get_super(bdev);
+		}
+
 		mutex_unlock(&bdev->bd_fsfreeze_mutex);
 		return sb;
 	}
@@ -233,6 +243,10 @@ struct super_block *freeze_bdev(struct b
 	}
 
 	sync_blockdev(bdev);
+	/* Setup unfreeze timer. */
+	if (timeout_msec > 0)
+		add_fsfreeze_timeout(bdev, timeout_msec);
+
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
 
 	return sb;	/* thaw_bdev releases s->s_umount and bd_mount_sem */
@@ -248,6 +262,22 @@ EXPORT_SYMBOL(freeze_bdev);
  */
 int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 {
+	return thaw_bdev_core(bdev, sb, 1);
+}
+EXPORT_SYMBOL(thaw_bdev);
+
+/**
+ * thaw_bdev_core  -- unlock filesystem and delete timeout task
+ * @bdev:		blockdevice to unlock
+ * @sb:			associated superblock
+ * @del_timeout_task:	If it is 0 then don't delete timeout task else delete
+ *
+ * Unlocks the filesystem and marks it writeable again after freeze_bdev().
+ * And If del_timeout_task is 0 then don't delete timeout task else delete.
+ */
+int thaw_bdev_core(struct block_device *bdev,
+				struct super_block *sb, int del_timeout_task)
+{
 	mutex_lock(&bdev->bd_fsfreeze_mutex);
 	if (!bdev->bd_fsfreeze_count) {
 		mutex_unlock(&bdev->bd_fsfreeze_mutex);
@@ -262,6 +292,10 @@ int thaw_bdev(struct block_device *bdev,
 		return 0;
 	}
 
+	/* Delete unfreeze timer. */
+	if (del_timeout_task)
+		cancel_delayed_work_sync(&bdev->bd_fsfreeze_timeout);
+
 	if (sb) {
 		BUG_ON(sb->s_bdev != bdev);
 
@@ -277,7 +311,7 @@ int thaw_bdev(struct block_device *bdev,
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
 	return 0;
 }
-EXPORT_SYMBOL(thaw_bdev);
+EXPORT_SYMBOL(thaw_bdev_core);
 
 /*
  * Various filesystems appear to want __find_get_block to be non-blocking.
diff -uprN -X linux-2.6.27-rc5.org/Documentation/dontdiff linux-2.6.27-rc5-xfs/fs/ioctl.c linux-2.6.27-rc5-timeout/fs/io
ctl.c
--- linux-2.6.27-rc5-xfs/fs/ioctl.c	2008-09-05 20:22:46.000000000 +0900
+++ linux-2.6.27-rc5-timeout/fs/ioctl.c	2008-09-05 17:47:47.000000000 +0900
@@ -141,9 +141,12 @@ static int ioctl_fioasync(unsigned int f
 	return error;
 }
 
-static int ioctl_freeze(struct file *filp)
+static int ioctl_freeze(struct file *filp, int __user *argp)
 {
+	int timeout_sec;
+	unsigned int timeout_msec;
 	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+	int error;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -156,8 +159,25 @@ static int ioctl_freeze(struct file *fil
 	if (sb->s_bdev == NULL)
 		return -EINVAL;
 
+	/* arg(sec) to tick value. */
+	error = get_user(timeout_sec, argp);
+	if (error != 0)
+		return error;
+
+	if (timeout_sec < 0 || timeout_sec > UINT_MAX/1000)
+		return -EINVAL;
+
+	/*
+	 * If 1 is specified as the timeout period it is changed into 0
+	 * to retain compatibility with XFS's xfs_freeze.
+	 */
+	if (timeout_sec == 1)
+		timeout_sec = 0;
+
+	timeout_msec = timeout_sec * 1000;
+
 	/* Freeze */
-	sb = freeze_bdev(sb->s_bdev);
+	sb = freeze_bdev(sb->s_bdev, timeout_msec);
 	if (IS_ERR(sb))
 		return PTR_ERR(sb);
 	return 0;
@@ -178,6 +198,47 @@ static int ioctl_thaw(struct file *filp)
 	return thaw_bdev(sb->s_bdev, sb);
 }
 
+static int
+ioctl_freeze_reset_timeout(struct file *filp, int __user *argp)
+{
+	int timeout_sec;
+	unsigned int timeout_msec;
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+	struct block_device *bdev = sb->s_bdev;
+	int error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* If a blockdevice-backed filesystem isn't specified, return EINVAL. */
+	if (bdev == NULL)
+		return -EINVAL;
+
+	/* arg(sec) to tick value */
+	error = get_user(timeout_sec, argp);
+	if (error)
+		return error;
+
+	if (timeout_sec <= 1 || timeout_sec > UINT_MAX/1000)
+		return -EINVAL;
+
+	timeout_msec = timeout_sec * 1000;
+
+	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	if (!bdev->bd_fsfreeze_count) {
+		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		return -EINVAL;
+	} else if (!delayed_work_pending(&bdev->bd_fsfreeze_timeout)) {
+		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		return -EBUSY;
+	}
+	/* setup unfreeze timer */
+	add_fsfreeze_timeout(bdev, timeout_msec);
+	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+
+	return 0;
+}
+
 /*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
@@ -221,13 +282,17 @@ int do_vfs_ioctl(struct file *filp, unsi
 		break;
 
 	case FIFREEZE:
-		error = ioctl_freeze(filp);
+		error = ioctl_freeze(filp, argp);
 		break;
 
 	case FITHAW:
 		error = ioctl_thaw(filp);
 		break;
 
+	case FIFREEZE_RESET_TIMEOUT:
+		error = ioctl_freeze_reset_timeout(filp, argp);
+		break;
+
 	default:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff -uprN -X linux-2.6.27-rc5.org/Documentation/dontdiff linux-2.6.27-rc5-xfs/fs/super.c linux-2.6.27-rc5-timeout/fs/su
per.c
--- linux-2.6.27-rc5-xfs/fs/super.c	2008-09-05 20:13:58.000000000 +0900
+++ linux-2.6.27-rc5-timeout/fs/super.c	2008-09-05 17:47:47.000000000 +0900
@@ -981,3 +981,40 @@ struct vfsmount *kern_mount_data(struct 
 }
 
 EXPORT_SYMBOL_GPL(kern_mount_data);
+
+/*
+ * fsfreeze_timeout - Thaw the filesystem.
+ *
+ * @work:	work queue (delayed_work.work)
+ *
+ * Called by the delayed work when elapsing the timeout period.
+ * Thaw the filesystem.
+ */
+void fsfreeze_timeout(struct work_struct *work)
+{
+	struct block_device *bd = container_of(work,
+			struct block_device, bd_fsfreeze_timeout.work);
+	struct super_block *sb = get_super(bd);
+
+	thaw_bdev_core(bd, sb, 0);
+
+	if (sb)
+		drop_super(sb);
+}
+
+/*
+ * add_fsfreeze_timeout - Add timeout for freeze.
+ *
+ * @bdev:		block device struct
+ * @timeout_msec:	timeout period
+ *
+ * Add the delayed work for freeze timeout to the delayed work queue.
+ */
+void add_fsfreeze_timeout(struct block_device *bdev, unsigned int timeout_msec)
+{
+	s64 timeout_jiffies = msecs_to_jiffies(timeout_msec);
+
+	/* Set delayed work queue */
+	cancel_delayed_work_sync(&bdev->bd_fsfreeze_timeout);
+	schedule_delayed_work(&bdev->bd_fsfreeze_timeout, timeout_jiffies);
+}
diff -uprN -X linux-2.6.27-rc5.org/Documentation/dontdiff linux-2.6.27-rc5-xfs/fs/xfs/xfs_fsops.c linux-2.6.27-rc5-timeo
ut/fs/xfs/xfs_fsops.c
--- linux-2.6.27-rc5-xfs/fs/xfs/xfs_fsops.c	2008-09-05 20:14:45.000000000 +0900
+++ linux-2.6.27-rc5-timeout/fs/xfs/xfs_fsops.c	2008-09-05 17:47:47.000000000 +0900
@@ -621,7 +621,7 @@ xfs_fs_goingdown(
 {
 	switch (inflags) {
 	case XFS_FSOP_GOING_FLAGS_DEFAULT: {
-		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev);
+		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev, 0);
 
 		if (sb && !IS_ERR(sb)) {
 			xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
diff -uprN -X linux-2.6.27-rc5.org/Documentation/dontdiff linux-2.6.27-rc5-xfs/include/linux/buffer_head.h linux-2.6.27-
rc5-timeout/include/linux/buffer_head.h
--- linux-2.6.27-rc5-xfs/include/linux/buffer_head.h	2008-09-05 20:16:12.000000000 +0900
+++ linux-2.6.27-rc5-timeout/include/linux/buffer_head.h	2008-09-05 17:47:47.000000000 +0900
@@ -169,8 +169,10 @@ int sync_blockdev(struct block_device *b
 void __wait_on_buffer(struct buffer_head *);
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
-struct super_block *freeze_bdev(struct block_device *);
+struct super_block *freeze_bdev(struct block_device *,
+				unsigned int timeout_msec);
 int thaw_bdev(struct block_device *, struct super_block *);
+int thaw_bdev_core(struct block_device *, struct super_block *, int);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
 struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,
diff -uprN -X linux-2.6.27-rc5.org/Documentation/dontdiff linux-2.6.27-rc5-xfs/include/linux/fs.h linux-2.6.27-rc5-timeo
ut/include/linux/fs.h
--- linux-2.6.27-rc5-xfs/include/linux/fs.h	2008-09-05 20:18:21.000000000 +0900
+++ linux-2.6.27-rc5-timeout/include/linux/fs.h	2008-09-05 17:47:47.000000000 +0900
@@ -8,6 +8,7 @@
 
 #include <linux/limits.h>
 #include <linux/ioctl.h>
+#include <linux/workqueue.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -228,6 +229,7 @@ extern int dir_notify_enable;
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
 #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
+#define	FIFREEZE_RESET_TIMEOUT	_IO(0x00, 3)	/* Reset freeze timeout */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -581,6 +583,8 @@ struct block_device {
 	int			bd_fsfreeze_count;
 	/* Mutex for freeze */
 	struct mutex		bd_fsfreeze_mutex;
+	/* Delayed work for freeze */
+	struct delayed_work	bd_fsfreeze_timeout;
 };
 
 /*
@@ -2160,5 +2164,9 @@ int proc_nr_files(struct ctl_table *tabl
 
 int get_filesystem_list(char * buf);
 
+extern void add_fsfreeze_timeout(struct block_device *bdev,
+				unsigned int timeout_msec);
+extern void fsfreeze_timeout(struct work_struct *work);
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
