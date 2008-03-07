Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Mar 2008 01:13:29 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m279D6P7025897
	for <xfs@oss.sgi.com>; Fri, 7 Mar 2008 01:13:09 -0800
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB48E124F6BE
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2008 01:13:35 -0800 (PST)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id hVgmQuiuU6KOKQ4N for <xfs@oss.sgi.com>; Fri, 07 Mar 2008 01:13:35 -0800 (PST)
Subject: [RFC] freeze feature ver 1.0
In-reply-to: <20080219202706t-sato@mail.jp.nec.com>
References: <20080219202706t-sato@mail.jp.nec.com>
Message-Id: <20080307181331t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Fri, 7 Mar 2008 18:13:31 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi,

I have re-based my freeze patch from linux-2.6.25-rc3 to
linux-2.6.25-rc4.
There is no functional change from the previous version.
All of comments from ML have already been reflected in this patch.
The ioctls for the freeze feature are below.

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
  This is useful for the application to set the timeval more accurately.
  For example, the freezer resets the timeval to 10 seconds every 5
  seconds.  In this approach, even if the freezer causes a deadlock
  by accessing the frozen filesystem, it will be solved by the timeout
  in 10 seconds and the freezer can recognize that at the next reset
  of timeval.
  int ioctl(int fd, int FIFREEZE_RESET_TIMEOUT, long *timeval)
    fd:file descriptor of mountpoint
    FIFREEZE_RESET_TIMEOUT: request code for reset of timeout period
    timeval: new timeout period in seconds
    Return value: 0 if the operation succeeds. Otherwise, -1
    Error number: If the filesystem has already been unfrozen,
                  errno is set to EINVAL.

o Unfreeze the filesystem
  int ioctl(int fd, int FITHAW, long *timeval)
    fd: The file descriptor of the mountpoint
    FITHAW: request code for unfreeze
    timeval: Ignored
    Return value: 0 if the operation succeeds. Otherwise, -1

Any comments are very welcome.

Cheers, Takashi

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
---
diff -uprN -X linux-2.6.25-rc4-freeze/Documentation/dontdiff linux-2.6.25-rc4/drivers/md/dm.c linux-2.6.25-rc4-freeze/dr
ivers/md/dm.c
--- linux-2.6.25-rc4/drivers/md/dm.c	2008-03-05 13:33:54.000000000 +0900
+++ linux-2.6.25-rc4-freeze/drivers/md/dm.c	2008-03-07 20:34:43.000000000 +0900
@@ -1407,7 +1407,7 @@ static int lock_fs(struct mapped_device 
 
 	WARN_ON(md->frozen_sb);
 
-	md->frozen_sb = freeze_bdev(md->suspended_bdev);
+	md->frozen_sb = freeze_bdev(md->suspended_bdev, 0);
 	if (IS_ERR(md->frozen_sb)) {
 		r = PTR_ERR(md->frozen_sb);
 		md->frozen_sb = NULL;
diff -uprN -X linux-2.6.25-rc4-freeze/Documentation/dontdiff linux-2.6.25-rc4/fs/block_dev.c linux-2.6.25-rc4-freeze/fs/
block_dev.c
--- linux-2.6.25-rc4/fs/block_dev.c	2008-03-05 13:33:54.000000000 +0900
+++ linux-2.6.25-rc4-freeze/fs/block_dev.c	2008-03-07 20:34:43.000000000 +0900
@@ -284,6 +284,11 @@ static void init_once(struct kmem_cache 
 	INIT_LIST_HEAD(&bdev->bd_holder_list);
 #endif
 	inode_init_once(&ei->vfs_inode);
+
+	/* Initialize semaphore for freeze. */
+	sema_init(&bdev->bd_freeze_sem, 1);
+	/* Setup freeze timeout function. */
+	INIT_DELAYED_WORK(&bdev->bd_freeze_timeout, freeze_timeout);
 }
 
 static inline void __bd_forget(struct inode *inode)
diff -uprN -X linux-2.6.25-rc4-freeze/Documentation/dontdiff linux-2.6.25-rc4/fs/buffer.c linux-2.6.25-rc4-freeze/fs/buf
fer.c
--- linux-2.6.25-rc4/fs/buffer.c	2008-03-05 13:33:54.000000000 +0900
+++ linux-2.6.25-rc4-freeze/fs/buffer.c	2008-03-07 20:34:43.000000000 +0900
@@ -190,17 +190,33 @@ int fsync_bdev(struct block_device *bdev
 
 /**
  * freeze_bdev  --  lock a filesystem and force it into a consistent state
- * @bdev:	blockdevice to lock
+ * @bdev:		blockdevice to lock
+ * @timeout_msec:	timeout period
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
 
+	down(&bdev->bd_freeze_sem);
+	sb = get_super_without_lock(bdev);
+
+	/* If super_block has been already frozen, return. */
+	if (sb && sb->s_frozen != SB_UNFROZEN) {
+		put_super(sb);
+		up(&bdev->bd_freeze_sem);
+		return sb;
+	}
+
+	if (sb)
+		put_super(sb);
+
 	down(&bdev->bd_mount_sem);
 	sb = get_super(bdev);
 	if (sb && !(sb->s_flags & MS_RDONLY)) {
@@ -219,6 +235,13 @@ struct super_block *freeze_bdev(struct b
 	}
 
 	sync_blockdev(bdev);
+
+	/* Setup unfreeze timer. */
+	if (timeout_msec > 0)
+		add_freeze_timeout(bdev, timeout_msec);
+
+	up(&bdev->bd_freeze_sem);
+
 	return sb;	/* thaw_bdev releases s->s_umount and bd_mount_sem */
 }
 EXPORT_SYMBOL(freeze_bdev);
@@ -232,6 +255,16 @@ EXPORT_SYMBOL(freeze_bdev);
  */
 void thaw_bdev(struct block_device *bdev, struct super_block *sb)
 {
+	down(&bdev->bd_freeze_sem);
+
+	if (sb && sb->s_frozen == SB_UNFROZEN) {
+		up(&bdev->bd_freeze_sem);
+		return;
+	}
+
+	/* Delete unfreeze timer. */
+	del_freeze_timeout(bdev);
+
 	if (sb) {
 		BUG_ON(sb->s_bdev != bdev);
 
@@ -244,6 +277,8 @@ void thaw_bdev(struct block_device *bdev
 	}
 
 	up(&bdev->bd_mount_sem);
+
+	up(&bdev->bd_freeze_sem);
 }
 EXPORT_SYMBOL(thaw_bdev);
 
diff -uprN -X linux-2.6.25-rc4-freeze/Documentation/dontdiff linux-2.6.25-rc4/fs/ioctl.c linux-2.6.25-rc4-freeze/fs/ioct
l.c
--- linux-2.6.25-rc4/fs/ioctl.c	2008-03-05 13:33:54.000000000 +0900
+++ linux-2.6.25-rc4-freeze/fs/ioctl.c	2008-03-07 20:40:03.000000000 +0900
@@ -13,6 +13,7 @@
 #include <linux/security.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
+#include <linux/buffer_head.h>
 
 #include <asm/ioctls.h>
 
@@ -181,6 +182,102 @@ int do_vfs_ioctl(struct file *filp, unsi
 		} else
 			error = -ENOTTY;
 		break;
+
+	case FIFREEZE: {
+		long timeout_sec;
+		long timeout_msec;
+		struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+
+		if (!capable(CAP_SYS_ADMIN)) {
+			error = -EPERM;
+			break;
+		}
+
+		/* If filesystem doesn't support freeze feature, return. */
+		if (sb->s_op->write_super_lockfs == NULL) {
+			error = -EINVAL;
+			break;
+		}
+
+		/* arg(sec) to tick value. */
+		error = get_user(timeout_sec, (long __user *) arg);
+		if (error != 0)
+			break;
+		/*
+		 * If 1 is specified as the timeout period,
+		 * it will be changed into 0 to keep the compatibility
+		 * of XFS application(xfs_freeze).
+		 */
+		if (timeout_sec < 0) {
+			error = -EINVAL;
+			break;
+		} else if (timeout_sec < 2) {
+			timeout_sec = 0;
+		}
+
+		timeout_msec = timeout_sec * 1000;
+		/* overflow case */
+		if (timeout_msec < 0) {
+			error = -EINVAL;
+			break;
+		}
+
+		/* Freeze. */
+		freeze_bdev(sb->s_bdev, timeout_msec);
+
+		break;
+	}
+
+	case FITHAW: {
+		struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+
+		if (!capable(CAP_SYS_ADMIN)) {
+			error = -EPERM;
+			break;
+		}
+
+		/* Thaw. */
+		thaw_bdev(sb->s_bdev, sb);
+		break;
+	}
+
+	case FIFREEZE_RESET_TIMEOUT: {
+		long timeout_sec;
+		long timeout_msec;
+		struct super_block *sb
+			= filp->f_path.dentry->d_inode->i_sb;
+
+		if (!capable(CAP_SYS_ADMIN)) {
+			error = -EPERM;
+			break;
+		}
+
+		/* arg(sec) to tick value */
+		error = get_user(timeout_sec, (long __user *) arg);
+		if (error)
+			break;
+		timeout_msec = timeout_sec * 1000;
+		if (timeout_msec < 0) {
+			error = -EINVAL;
+			break;
+		}
+
+		if (sb) {
+			down(&sb->s_bdev->bd_freeze_sem);
+			if (sb->s_frozen == SB_UNFROZEN) {
+				up(&sb->s_bdev->bd_freeze_sem);
+				error = -EINVAL;
+				break;
+			}
+			/* setup unfreeze timer */
+			if (timeout_msec > 0)
+				add_freeze_timeout(sb->s_bdev,
+					timeout_msec);
+			up(&sb->s_bdev->bd_freeze_sem);
+		}
+		break;
+	}
+
 	default:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff -uprN -X linux-2.6.25-rc4-freeze/Documentation/dontdiff linux-2.6.25-rc4/fs/super.c linux-2.6.25-rc4-freeze/fs/supe
r.c
--- linux-2.6.25-rc4/fs/super.c	2008-03-05 13:33:54.000000000 +0900
+++ linux-2.6.25-rc4-freeze/fs/super.c	2008-03-07 20:36:25.000000000 +0900
@@ -154,7 +154,7 @@ int __put_super_and_need_restart(struct 
  *	Drops a temporary reference, frees superblock if there's no
  *	references left.
  */
-static void put_super(struct super_block *sb)
+void put_super(struct super_block *sb)
 {
 	spin_lock(&sb_lock);
 	__put_super(sb);
@@ -507,6 +507,36 @@ rescan:
 
 EXPORT_SYMBOL(get_super);
  
+/*
+ * get_super_without_lock - Get super_block from block_device without lock.
+ * @bdev:	block device struct
+ *
+ * Scan the superblock list and finds the superblock of the file system
+ * mounted on the block device given. This doesn't lock anyone.
+ * %NULL is returned if no match is found.
+ */
+struct super_block *get_super_without_lock(struct block_device *bdev)
+{
+	struct super_block *sb;
+
+	if (!bdev)
+		return NULL;
+
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		if (sb->s_bdev == bdev) {
+			if (sb->s_root) {
+				sb->s_count++;
+				spin_unlock(&sb_lock);
+				return sb;
+			}
+		}
+	}
+	spin_unlock(&sb_lock);
+	return NULL;
+}
+EXPORT_SYMBOL(get_super_without_lock);
+
 struct super_block * user_get_super(dev_t dev)
 {
 	struct super_block *sb;
@@ -952,3 +982,55 @@ struct vfsmount *kern_mount_data(struct 
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
+
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
diff -uprN -X linux-2.6.25-rc4-freeze/Documentation/dontdiff linux-2.6.25-rc4/fs/xfs/linux-2.6/xfs_ioctl.c linux-2.6.25-
rc4-freeze/fs/xfs/linux-2.6/xfs_ioctl.c
--- linux-2.6.25-rc4/fs/xfs/linux-2.6/xfs_ioctl.c	2008-03-05 13:33:54.000000000 +0900
+++ linux-2.6.25-rc4-freeze/fs/xfs/linux-2.6/xfs_ioctl.c	2008-03-07 20:34:43.000000000 +0900
@@ -911,7 +911,7 @@ xfs_ioctl(
 			return -EPERM;
 
 		if (inode->i_sb->s_frozen == SB_UNFROZEN)
-			freeze_bdev(inode->i_sb->s_bdev);
+			freeze_bdev(inode->i_sb->s_bdev, 0);
 		return 0;
 
 	case XFS_IOC_THAW:
diff -uprN -X linux-2.6.25-rc4-freeze/Documentation/dontdiff linux-2.6.25-rc4/fs/xfs/xfs_fsops.c linux-2.6.25-rc4-freeze
/fs/xfs/xfs_fsops.c
--- linux-2.6.25-rc4/fs/xfs/xfs_fsops.c	2008-03-05 13:33:54.000000000 +0900
+++ linux-2.6.25-rc4-freeze/fs/xfs/xfs_fsops.c	2008-03-07 20:34:43.000000000 +0900
@@ -623,7 +623,7 @@ xfs_fs_goingdown(
 {
 	switch (inflags) {
 	case XFS_FSOP_GOING_FLAGS_DEFAULT: {
-		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev);
+		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev, 0);
 
 		if (sb && !IS_ERR(sb)) {
 			xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
diff -uprN -X linux-2.6.25-rc4-freeze/Documentation/dontdiff linux-2.6.25-rc4/include/linux/buffer_head.h linux-2.6.25-r
c4-freeze/include/linux/buffer_head.h
--- linux-2.6.25-rc4/include/linux/buffer_head.h	2008-03-05 13:33:54.000000000 +0900
+++ linux-2.6.25-rc4-freeze/include/linux/buffer_head.h	2008-03-07 20:34:43.000000000 +0900
@@ -170,7 +170,7 @@ int sync_blockdev(struct block_device *b
 void __wait_on_buffer(struct buffer_head *);
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
-struct super_block *freeze_bdev(struct block_device *);
+struct super_block *freeze_bdev(struct block_device *, long timeout_msec);
 void thaw_bdev(struct block_device *, struct super_block *);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
diff -uprN -X linux-2.6.25-rc4-freeze/Documentation/dontdiff linux-2.6.25-rc4/include/linux/fs.h linux-2.6.25-rc4-freeze
/include/linux/fs.h
--- linux-2.6.25-rc4/include/linux/fs.h	2008-03-05 13:33:54.000000000 +0900
+++ linux-2.6.25-rc4-freeze/include/linux/fs.h	2008-03-07 20:34:43.000000000 +0900
@@ -8,6 +8,7 @@
 
 #include <linux/limits.h>
 #include <linux/ioctl.h>
+#include <linux/workqueue.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -223,6 +224,9 @@ extern int dir_notify_enable;
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
+#define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
+#define FITHAW		_IOWR('X', 120, int)	/* Thaw */
+#define	FIFREEZE_RESET_TIMEOUT	_IO(0x00, 3)	/* Reset freeze timeout */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -548,6 +552,11 @@ struct block_device {
 	 * care to not mess up bd_private for that case.
 	 */
 	unsigned long		bd_private;
+
+	/* Delayed work for freeze */
+	struct delayed_work	bd_freeze_timeout;
+	/* Semaphore for freeze */
+	struct semaphore	bd_freeze_sem;
 };
 
 /*
@@ -1926,7 +1935,9 @@ extern int do_vfs_ioctl(struct file *fil
 extern void get_filesystem(struct file_system_type *fs);
 extern void put_filesystem(struct file_system_type *fs);
 extern struct file_system_type *get_fs_type(const char *name);
+extern void put_super(struct super_block *sb);
 extern struct super_block *get_super(struct block_device *);
+extern struct super_block *get_super_without_lock(struct block_device *);
 extern struct super_block *user_get_super(dev_t);
 extern void drop_super(struct super_block *sb);
 
@@ -2097,5 +2108,9 @@ int proc_nr_files(struct ctl_table *tabl
 
 int get_filesystem_list(char * buf);
 
+extern void add_freeze_timeout(struct block_device *bdev, long timeout_msec);
+extern void del_freeze_timeout(struct block_device *bdev);
+extern void freeze_timeout(struct work_struct *work);
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
