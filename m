Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Sep 2008 04:51:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m88Bpbe5013576
	for <xfs@oss.sgi.com>; Mon, 8 Sep 2008 04:51:37 -0700
Received: from tyo202.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1FB781BCF1EC
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2008 04:52:56 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206]) by cuda.sgi.com with ESMTP id ogFKfbsje4MKTb7c for <xfs@oss.sgi.com>; Mon, 08 Sep 2008 04:52:56 -0700 (PDT)
Subject: [PATCH 1/3] Implement generic freeze feature
Message-Id: <20080908205245t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Mon, 8 Sep 2008 20:52:45 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

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
 fs/buffer.c                 |   34 ++++++++++++++++++++++++++++++-
 fs/ioctl.c                  |   47 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/buffer_head.h |    2 -
 include/linux/fs.h          |    7 ++++++
 5 files changed, 90 insertions(+), 2 deletions(-)

diff -uprN -X linux-2.6.27-rc5.org/Documentation/dontdiff linux-2.6.27-rc5.org/fs/block_dev.c linux-2.6.27-rc5-freeze/fs
/block_dev.c
--- linux-2.6.27-rc5.org/fs/block_dev.c	2008-08-29 07:52:02.000000000 +0900
+++ linux-2.6.27-rc5-freeze/fs/block_dev.c	2008-09-05 20:00:29.000000000 +0900
@@ -285,6 +285,8 @@ static void init_once(void *foo)
 	INIT_LIST_HEAD(&bdev->bd_holder_list);
 #endif
 	inode_init_once(&ei->vfs_inode);
+	/* Initialize mutex for freeze. */
+	mutex_init(&bdev->bd_fsfreeze_mutex);
 }
 
 static inline void __bd_forget(struct inode *inode)
diff -uprN -X linux-2.6.27-rc5.org/Documentation/dontdiff linux-2.6.27-rc5.org/fs/buffer.c linux-2.6.27-rc5-freeze/fs/bu
ffer.c
--- linux-2.6.27-rc5.org/fs/buffer.c	2008-08-29 07:52:02.000000000 +0900
+++ linux-2.6.27-rc5-freeze/fs/buffer.c	2008-09-05 20:23:13.000000000 +0900
@@ -196,11 +196,25 @@ int fsync_bdev(struct block_device *bdev
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
 
+	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	if (bdev->bd_fsfreeze_count > 0) {
+		bdev->bd_fsfreeze_count++;
+		sb = get_super(bdev);
+		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		return sb;
+	}
+	bdev->bd_fsfreeze_count++;
+
 	down(&bdev->bd_mount_sem);
 	sb = get_super(bdev);
 	if (sb && !(sb->s_flags & MS_RDONLY)) {
@@ -219,6 +233,8 @@ struct super_block *freeze_bdev(struct b
 	}
 
 	sync_blockdev(bdev);
+	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+
 	return sb;	/* thaw_bdev releases s->s_umount and bd_mount_sem */
 }
 EXPORT_SYMBOL(freeze_bdev);
@@ -230,8 +246,22 @@ EXPORT_SYMBOL(freeze_bdev);
  *
  * Unlocks the filesystem and marks it writeable again after freeze_bdev().
  */
-void thaw_bdev(struct block_device *bdev, struct super_block *sb)
+int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 {
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
 
@@ -244,6 +274,8 @@ void thaw_bdev(struct block_device *bdev
 	}
 
 	up(&bdev->bd_mount_sem);
+	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+	return 0;
 }
 EXPORT_SYMBOL(thaw_bdev);
 
diff -uprN -X linux-2.6.27-rc5.org/Documentation/dontdiff linux-2.6.27-rc5.org/fs/ioctl.c linux-2.6.27-rc5-freeze/fs/ioc
tl.c
--- linux-2.6.27-rc5.org/fs/ioctl.c	2008-08-29 07:52:02.000000000 +0900
+++ linux-2.6.27-rc5-freeze/fs/ioctl.c	2008-09-05 20:22:46.000000000 +0900
@@ -13,6 +13,7 @@
 #include <linux/security.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
+#include <linux/buffer_head.h>
 
 #include <asm/ioctls.h>
 
@@ -140,6 +141,43 @@ static int ioctl_fioasync(unsigned int f
 	return error;
 }
 
+static int ioctl_freeze(struct file *filp)
+{
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* If filesystem doesn't support freeze feature, return. */
+	if (sb->s_op->write_super_lockfs == NULL)
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
+static int ioctl_thaw(struct file *filp)
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
+		error = ioctl_freeze(filp);
+		break;
+
+	case FITHAW:
+		error = ioctl_thaw(filp);
+		break;
+
 	default:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff -uprN -X linux-2.6.27-rc5.org/Documentation/dontdiff linux-2.6.27-rc5.org/include/linux/buffer_head.h linux-2.6.27-
rc5-freeze/include/linux/buffer_head.h
--- linux-2.6.27-rc5.org/include/linux/buffer_head.h	2008-08-29 07:52:02.000000000 +0900
+++ linux-2.6.27-rc5-freeze/include/linux/buffer_head.h	2008-09-05 20:16:12.000000000 +0900
@@ -170,7 +170,7 @@ void __wait_on_buffer(struct buffer_head
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
 struct super_block *freeze_bdev(struct block_device *);
-void thaw_bdev(struct block_device *, struct super_block *);
+int thaw_bdev(struct block_device *, struct super_block *);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
 struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,
diff -uprN -X linux-2.6.27-rc5.org/Documentation/dontdiff linux-2.6.27-rc5.org/include/linux/fs.h linux-2.6.27-rc5-freez
e/include/linux/fs.h
--- linux-2.6.27-rc5.org/include/linux/fs.h	2008-08-29 07:52:02.000000000 +0900
+++ linux-2.6.27-rc5-freeze/include/linux/fs.h	2008-09-05 20:18:21.000000000 +0900
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
