Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 02:36:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M9ac0A018307
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 02:36:39 -0700
Received: from tyo202.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69461E7DF6A
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 02:37:46 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206]) by cuda.sgi.com with ESMTP id aAONXhBmDO9zziCN for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 02:37:46 -0700 (PDT)
Subject: [PATCH 1/3] Implement generic freeze feature
Message-Id: <20080722183734t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Tue, 22 Jul 2008 18:37:34 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

When multiple freeze requests arrive simultaneously, only the last
unfreeze process should unfreeze the frozen filesystem actually
(as Dave Chinner, Eric Sandeen and Alasdair G Kergon commented).
So I've added the reference counter to the freeze feature.
It counts up in freeze_bdev() and counts down in thaw_bdev().
When it becomes "0", thaw_bdev() will unfreeze actually.

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
 fs/buffer.c                 |   27 ++++++++++++++++++-
 fs/ioctl.c                  |   61 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/buffer_head.h |    2 -
 include/linux/fs.h          |    6 ++++
 5 files changed, 96 insertions(+), 2 deletions(-)

diff -uprN -X linux-2.6.26.org/Documentation/dontdiff linux-2.6.26.org/fs/block_dev.c linux-2.6.26-freeze/fs/block_dev.c
--- linux-2.6.26.org/fs/block_dev.c	2008-07-14 06:51:29.000000000 +0900
+++ linux-2.6.26-freeze/fs/block_dev.c	2008-07-18 15:38:03.000000000 +0900
@@ -285,6 +285,8 @@ static void init_once(struct kmem_cache 
 	INIT_LIST_HEAD(&bdev->bd_holder_list);
 #endif
 	inode_init_once(&ei->vfs_inode);
+	/* Initialize semaphore for freeze. */
+	sema_init(&bdev->bd_freeze_sem, 1);
 }
 
 static inline void __bd_forget(struct inode *inode)
diff -uprN -X linux-2.6.26.org/Documentation/dontdiff linux-2.6.26.org/fs/buffer.c linux-2.6.26-freeze/fs/buffer.c
--- linux-2.6.26.org/fs/buffer.c	2008-07-14 06:51:29.000000000 +0900
+++ linux-2.6.26-freeze/fs/buffer.c	2008-07-18 15:45:17.000000000 +0900
@@ -201,6 +201,15 @@ struct super_block *freeze_bdev(struct b
 {
 	struct super_block *sb;
 
+	down(&bdev->bd_freeze_sem);
+	bdev->bd_freeze_count++;
+	if (bdev->bd_freeze_count > 1) {
+		sb = get_super(bdev);
+		drop_super(sb);
+		up(&bdev->bd_freeze_sem);
+		return sb;
+	}
+
 	down(&bdev->bd_mount_sem);
 	sb = get_super(bdev);
 	if (sb && !(sb->s_flags & MS_RDONLY)) {
@@ -219,6 +228,8 @@ struct super_block *freeze_bdev(struct b
 	}
 
 	sync_blockdev(bdev);
+	up(&bdev->bd_freeze_sem);
+
 	return sb;	/* thaw_bdev releases s->s_umount and bd_mount_sem */
 }
 EXPORT_SYMBOL(freeze_bdev);
@@ -230,8 +241,20 @@ EXPORT_SYMBOL(freeze_bdev);
  *
  * Unlocks the filesystem and marks it writeable again after freeze_bdev().
  */
-void thaw_bdev(struct block_device *bdev, struct super_block *sb)
+int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 {
+
+	down(&bdev->bd_freeze_sem);
+	if (!bdev->bd_freeze_count) {
+		up(&bdev->bd_freeze_sem);
+		return 0;
+	}
+	bdev->bd_freeze_count--;
+	if (bdev->bd_freeze_count > 0) {
+		up(&bdev->bd_freeze_sem);
+		return 0;
+	}
+
 	if (sb) {
 		BUG_ON(sb->s_bdev != bdev);
 
@@ -244,6 +267,8 @@ void thaw_bdev(struct block_device *bdev
 	}
 
 	up(&bdev->bd_mount_sem);
+	up(&bdev->bd_freeze_sem);
+	return 0;
 }
 EXPORT_SYMBOL(thaw_bdev);
 
diff -uprN -X linux-2.6.26.org/Documentation/dontdiff linux-2.6.26.org/fs/ioctl.c linux-2.6.26-freeze/fs/ioctl.c
--- linux-2.6.26.org/fs/ioctl.c	2008-07-14 06:51:29.000000000 +0900
+++ linux-2.6.26-freeze/fs/ioctl.c	2008-07-18 21:24:42.000000000 +0900
@@ -13,6 +13,7 @@
 #include <linux/security.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
+#include <linux/buffer_head.h>
 
 #include <asm/ioctls.h>
 
@@ -141,6 +142,57 @@ static int ioctl_fioasync(unsigned int f
 }
 
 /*
+ * ioctl_freeze - Freeze the filesystem.
+ *
+ * @filp:	target file
+ *
+ * Call freeze_bdev() to freeze the filesystem.
+ */
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
+	/* If a regular file or a directory isn't specified, return. */
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
+/*
+ * ioctl_thaw - Thaw the filesystem.
+ *
+ * @filp:	target file
+ *
+ * Call thaw_bdev() to thaw the filesystem.
+ */
+static int ioctl_thaw(struct file *filp)
+{
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* If a regular file or a directory isn't specified, return EINVAL. */
+	if (sb->s_bdev == NULL)
+		return -EINVAL;
+
+	/* Thaw */
+	return thaw_bdev(sb->s_bdev, sb);
+}
+
+/*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
  *
@@ -181,6 +233,15 @@ int do_vfs_ioctl(struct file *filp, unsi
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
diff -uprN -X linux-2.6.26.org/Documentation/dontdiff linux-2.6.26.org/include/linux/buffer_head.h linux-2.6.26-freeze/i
nclude/linux/buffer_head.h
--- linux-2.6.26.org/include/linux/buffer_head.h	2008-07-14 06:51:29.000000000 +0900
+++ linux-2.6.26-freeze/include/linux/buffer_head.h	2008-07-17 11:32:37.000000000 +0900
@@ -171,7 +171,7 @@ void __wait_on_buffer(struct buffer_head
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
 struct super_block *freeze_bdev(struct block_device *);
-void thaw_bdev(struct block_device *, struct super_block *);
+int thaw_bdev(struct block_device *, struct super_block *);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
 struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,
diff -uprN -X linux-2.6.26.org/Documentation/dontdiff linux-2.6.26.org/include/linux/fs.h linux-2.6.26-freeze/include/li
nux/fs.h
--- linux-2.6.26.org/include/linux/fs.h	2008-07-14 06:51:29.000000000 +0900
+++ linux-2.6.26-freeze/include/linux/fs.h	2008-07-18 15:34:46.000000000 +0900
@@ -224,6 +224,8 @@ extern int dir_notify_enable;
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
+#define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
+#define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -548,6 +550,10 @@ struct block_device {
 	 * care to not mess up bd_private for that case.
 	 */
 	unsigned long		bd_private;
+	/* The counter of freeze processes */
+	int			bd_freeze_count;
+	/* Semaphore for freeze */
+	struct semaphore	bd_freeze_sem;
 };
 
 /*
