Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 01:58:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q8vqDg032237
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:57:52 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4C11486D71
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:59:26 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id a3HUgbz4G5PUN0Xu for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:59:26 -0700 (PDT)
Subject: [PATCH 8/10] Implement generic freeze feature
Message-Id: <20080926175912t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Fri, 26 Sep 2008 17:59:12 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

The ioctls for the generic freeze feature are below.
o Freeze the filesystem
  int ioctl(int fd, int FIFREEZE, arg)
    fd: The file descriptor of the mountpoint
    FIFREEZE: request code for the freeze
    arg: Ignored
    Return value: 0 if the operation succeeds. Otherwise, -1

o Unfreeze the filesystem
  int ioctl(int fd, int FITHAW, arg)
    fd: The file descriptor of the mountpoint
    FITHAW: request code for unfreeze
    arg: Ignored
    Return value: 0 if the operation succeeds. Otherwise, -1

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 fs/block_dev.c              |    2 +
 fs/buffer.c                 |   74 ++++++++++++++++++++++++++++++++++++++------
 fs/ioctl.c                  |   47 +++++++++++++++++++++++++++
 include/linux/buffer_head.h |    2 -
 include/linux/fs.h          |    7 ++++
 5 files changed, 122 insertions(+), 10 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-jfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs-jfs/fs/block_dev.c linux-2.6.27
-rc7-freeze/fs/block_dev.c
--- linux-2.6.27-rc7-lockfs-jfs/fs/block_dev.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-freeze/fs/block_dev.c	2008-09-26 20:57:53.000000000 +0900
@@ -285,6 +285,8 @@ static void init_once(void *foo)
 	INIT_LIST_HEAD(&bdev->bd_holder_list);
 #endif
 	inode_init_once(&ei->vfs_inode);
+	/* Initialize mutex for freeze. */
+	mutex_init(&bdev->bd_fsfreeze_mutex);
 }
 
 static inline void __bd_forget(struct inode *inode)
diff -uprN -X linux-2.6.27-rc7-lockfs-jfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs-jfs/fs/buffer.c linux-2.6.27-rc
7-freeze/fs/buffer.c
--- linux-2.6.27-rc7-lockfs-jfs/fs/buffer.c	2008-09-26 20:56:46.000000000 +0900
+++ linux-2.6.27-rc7-freeze/fs/buffer.c	2008-09-26 20:58:38.000000000 +0900
@@ -196,10 +196,25 @@ int fsync_bdev(struct block_device *bdev
  * happen on bdev until thaw_bdev() is called.
  * If a superblock is found on this device, we take the s_umount semaphore
  * on it to make sure nobody unmounts until the snapshot creation is done.
+ * The reference counter (bd_fsfreeze_count) guarantees that only the last
+ * unfreeze process can unfreeze the frozen filesystem actually when multiple
+ * freeze requests arrive simultaneously. It counts up in freeze_bdev() and
+ * count down in thaw_bdev(). When it becomes 0, thaw_bdev() will unfreeze
+ * actually.
  */
 struct super_block *freeze_bdev(struct block_device *bdev)
 {
 	struct super_block *sb;
+	int error = 0;
+
+	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	if (bdev->bd_fsfreeze_count > 0) {
+		bdev->bd_fsfreeze_count++;
+		sb = get_super(bdev);
+		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		return sb;
+	}
+	bdev->bd_fsfreeze_count++;
 
 	down(&bdev->bd_mount_sem);
 	sb = get_super(bdev);
@@ -214,11 +229,24 @@ struct super_block *freeze_bdev(struct b
 
 		sync_blockdev(sb->s_bdev);
 
-		if (sb->s_op->freeze_fs)
-			sb->s_op->freeze_fs(sb);
+		if (sb->s_op->freeze_fs) {
+			error = sb->s_op->freeze_fs(sb);
+			if (error) {
+				printk(KERN_ERR
+					"VFS:Filesystem freeze failed\n");
+				sb->s_frozen = SB_UNFROZEN;
+				drop_super(sb);
+				up(&bdev->bd_mount_sem);
+				bdev->bd_fsfreeze_count--;
+				mutex_unlock(&bdev->bd_fsfreeze_mutex);
+				return ERR_PTR(error);
+			}
+		}
 	}
 
 	sync_blockdev(bdev);
+	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+
 	return sb;	/* thaw_bdev releases s->s_umount and bd_mount_sem */
 }
 EXPORT_SYMBOL(freeze_bdev);
@@ -230,20 +258,48 @@ EXPORT_SYMBOL(freeze_bdev);
  *
  * Unlocks the filesystem and marks it writeable again after freeze_bdev().
  */
-void thaw_bdev(struct block_device *bdev, struct super_block *sb)
+int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 {
+	int error = 0;
+
+	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	if (!bdev->bd_fsfreeze_count) {
+		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		return 0;
+	}
+
+	bdev->bd_fsfreeze_count--;
+	if (bdev->bd_fsfreeze_count > 0) {
+		if (sb)
+			drop_super(sb);
+		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		return 0;
+	}
+
 	if (sb) {
 		BUG_ON(sb->s_bdev != bdev);
-
-		if (sb->s_op->unfreeze_fs)
-			sb->s_op->unfreeze_fs(sb);
-		sb->s_frozen = SB_UNFROZEN;
-		smp_wmb();
-		wake_up(&sb->s_wait_unfrozen);
+		if (!(sb->s_flags & MS_RDONLY)) {
+			if (sb->s_op->unfreeze_fs) {
+				error = sb->s_op->unfreeze_fs(sb);
+				if (error) {
+					printk(KERN_ERR
+						"VFS:Filesystem thaw failed\n");
+					sb->s_frozen = SB_FREEZE_TRANS;
+					bdev->bd_fsfreeze_count++;
+					mutex_unlock(&bdev->bd_fsfreeze_mutex);
+					return error;
+				}
+			}
+			sb->s_frozen = SB_UNFROZEN;
+			smp_wmb();
+			wake_up(&sb->s_wait_unfrozen);
+		}
 		drop_super(sb);
 	}
 
 	up(&bdev->bd_mount_sem);
+	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+	return 0;
 }
 EXPORT_SYMBOL(thaw_bdev);
 
diff -uprN -X linux-2.6.27-rc7-lockfs-jfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs-jfs/fs/ioctl.c linux-2.6.27-rc7
-freeze/fs/ioctl.c
--- linux-2.6.27-rc7-lockfs-jfs/fs/ioctl.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-freeze/fs/ioctl.c	2008-09-26 20:57:53.000000000 +0900
@@ -13,6 +13,7 @@
 #include <linux/security.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
+#include <linux/buffer_head.h>
 
 #include <asm/ioctls.h>
 
@@ -140,6 +141,43 @@ static int ioctl_fioasync(unsigned int f
 	return error;
 }
 
+static int ioctl_fsfreeze(struct file *filp)
+{
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* If filesystem doesn't support freeze feature, return. */
+	if (sb->s_op->freeze_fs == NULL)
+		return -EOPNOTSUPP;
+
+	/* If a blockdevice-backed filesystem isn't specified, return. */
+	if (sb->s_bdev == NULL)
+		return -EINVAL;
+
+	/* Freeze */
+	sb = freeze_bdev(sb->s_bdev);
+	if (IS_ERR(sb))
+		return PTR_ERR(sb);
+	return 0;
+}
+
+static int ioctl_fsthaw(struct file *filp)
+{
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* If a blockdevice-backed filesystem isn't specified, return EINVAL. */
+	if (sb->s_bdev == NULL)
+		return -EINVAL;
+
+	/* Thaw */
+	return thaw_bdev(sb->s_bdev, sb);
+}
+
 /*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
@@ -181,6 +219,15 @@ int do_vfs_ioctl(struct file *filp, unsi
 		} else
 			error = -ENOTTY;
 		break;
+
+	case FIFREEZE:
+		error = ioctl_fsfreeze(filp);
+		break;
+
+	case FITHAW:
+		error = ioctl_fsthaw(filp);
+		break;
+
 	default:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff -uprN -X linux-2.6.27-rc7-lockfs-jfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs-jfs/include/linux/buffer_head.h
 linux-2.6.27-rc7-freeze/include/linux/buffer_head.h
--- linux-2.6.27-rc7-lockfs-jfs/include/linux/buffer_head.h	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-freeze/include/linux/buffer_head.h	2008-09-26 20:57:53.000000000 +0900
@@ -170,7 +170,7 @@ void __wait_on_buffer(struct buffer_head
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
 struct super_block *freeze_bdev(struct block_device *);
-void thaw_bdev(struct block_device *, struct super_block *);
+int thaw_bdev(struct block_device *, struct super_block *);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
 struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,
diff -uprN -X linux-2.6.27-rc7-lockfs-jfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs-jfs/include/linux/fs.h linux-2.
6.27-rc7-freeze/include/linux/fs.h
--- linux-2.6.27-rc7-lockfs-jfs/include/linux/fs.h	2008-09-26 20:56:46.000000000 +0900
+++ linux-2.6.27-rc7-freeze/include/linux/fs.h	2008-09-26 20:57:53.000000000 +0900
@@ -226,6 +226,8 @@ extern int dir_notify_enable;
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
+#define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
+#define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -574,6 +576,11 @@ struct block_device {
 	 * care to not mess up bd_private for that case.
 	 */
 	unsigned long		bd_private;
+
+	/* The counter of freeze processes */
+	int			bd_fsfreeze_count;
+	/* Mutex for freeze */
+	struct mutex		bd_fsfreeze_mutex;
 };
 
 /*
