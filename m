Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Jun 2008 05:22:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5UCMVpK022445
	for <xfs@oss.sgi.com>; Mon, 30 Jun 2008 05:22:31 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7187629D141
	for <xfs@oss.sgi.com>; Mon, 30 Jun 2008 05:23:32 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id tm2twMtUxYrjax8u for <xfs@oss.sgi.com>; Mon, 30 Jun 2008 05:23:32 -0700 (PDT)
Subject: [PATCH 1/3] Implement generic freeze feature
Message-Id: <20080630212323t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Mon, 30 Jun 2008 21:23:23 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, axboe@kernel.dk, mtk.manpages@googlemail.com

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
diff -uprN -X linux-2.6.26-rc7.org/Documentation/dontdiff linux-2.6.26-rc7.org/fs/buffer.c linux-2.6.26-rc7-freeze/fs/bu
ffer.c
--- linux-2.6.26-rc7.org/fs/buffer.c	2008-06-25 12:08:10.000000000 +0900
+++ linux-2.6.26-rc7-freeze/fs/buffer.c	2008-06-27 09:18:19.000000000 +0900
@@ -201,6 +201,21 @@ struct super_block *freeze_bdev(struct b
 {
 	struct super_block *sb;
 
+	if (test_and_set_bit(BD_FREEZE_OP, &bdev->bd_state))
+		return ERR_PTR(-EBUSY);
+
+	sb = get_super(bdev);
+
+	/* If super_block has been already frozen, return. */
+	if (sb && sb->s_frozen != SB_UNFROZEN) {
+		drop_super(sb);
+		clear_bit(BD_FREEZE_OP, &bdev->bd_state);
+		return sb;
+	}
+
+	if (sb)
+		drop_super(sb);
+
 	down(&bdev->bd_mount_sem);
 	sb = get_super(bdev);
 	if (sb && !(sb->s_flags & MS_RDONLY)) {
@@ -219,6 +234,8 @@ struct super_block *freeze_bdev(struct b
 	}
 
 	sync_blockdev(bdev);
+	clear_bit(BD_FREEZE_OP, &bdev->bd_state);
+
 	return sb;	/* thaw_bdev releases s->s_umount and bd_mount_sem */
 }
 EXPORT_SYMBOL(freeze_bdev);
@@ -230,8 +247,17 @@ EXPORT_SYMBOL(freeze_bdev);
  *
  * Unlocks the filesystem and marks it writeable again after freeze_bdev().
  */
-void thaw_bdev(struct block_device *bdev, struct super_block *sb)
+int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 {
+
+	if (test_and_set_bit(BD_FREEZE_OP, &bdev->bd_state))
+		return -EBUSY;
+
+	if (sb && sb->s_frozen == SB_UNFROZEN) {
+		clear_bit(BD_FREEZE_OP, &bdev->bd_state);
+		return 0;
+	}
+
 	if (sb) {
 		BUG_ON(sb->s_bdev != bdev);
 
@@ -244,6 +270,8 @@ void thaw_bdev(struct block_device *bdev
 	}
 
 	up(&bdev->bd_mount_sem);
+	clear_bit(BD_FREEZE_OP, &bdev->bd_state);
+	return 0;
 }
 EXPORT_SYMBOL(thaw_bdev);
 
diff -uprN -X linux-2.6.26-rc7.org/Documentation/dontdiff linux-2.6.26-rc7.org/fs/ioctl.c linux-2.6.26-rc7-freeze/fs/ioc
tl.c
--- linux-2.6.26-rc7.org/fs/ioctl.c	2008-06-25 12:08:14.000000000 +0900
+++ linux-2.6.26-rc7-freeze/fs/ioctl.c	2008-06-25 12:00:41.000000000 +0900
@@ -13,6 +13,7 @@
 #include <linux/security.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
+#include <linux/buffer_head.h>
 
 #include <asm/ioctls.h>
 
@@ -141,6 +142,49 @@ static int ioctl_fioasync(unsigned int f
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
+	/* Thaw */
+	return thaw_bdev(sb->s_bdev, sb);
+}
+
+/*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
  *
@@ -181,6 +225,15 @@ int do_vfs_ioctl(struct file *filp, unsi
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
diff -uprN -X linux-2.6.26-rc7.org/Documentation/dontdiff linux-2.6.26-rc7.org/include/linux/buffer_head.h linux-2.6.26-
rc7-freeze/include/linux/buffer_head.h
--- linux-2.6.26-rc7.org/include/linux/buffer_head.h	2008-06-25 12:08:19.000000000 +0900
+++ linux-2.6.26-rc7-freeze/include/linux/buffer_head.h	2008-06-25 12:00:45.000000000 +0900
@@ -171,7 +171,7 @@ void __wait_on_buffer(struct buffer_head
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
 struct super_block *freeze_bdev(struct block_device *);
-void thaw_bdev(struct block_device *, struct super_block *);
+int thaw_bdev(struct block_device *, struct super_block *);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
 struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,
diff -uprN -X linux-2.6.26-rc7.org/Documentation/dontdiff linux-2.6.26-rc7.org/include/linux/fs.h linux-2.6.26-rc7-freez
e/include/linux/fs.h
--- linux-2.6.26-rc7.org/include/linux/fs.h	2008-06-25 12:08:19.000000000 +0900
+++ linux-2.6.26-rc7-freeze/include/linux/fs.h	2008-06-30 16:40:49.000000000 +0900
@@ -223,6 +223,8 @@ extern int dir_notify_enable;
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
+#define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
+#define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -494,6 +496,13 @@ int pagecache_write_end(struct file *, s
 				loff_t pos, unsigned len, unsigned copied,
 				struct page *page, void *fsdata);
 
+/*
+ * Bits in block_device.bd_state.
+ */
+enum bd_state {
+	BD_FREEZE_OP	/* In freeze operation */
+};
+
 struct backing_dev_info;
 struct address_space {
 	struct inode		*host;		/* owner: inode, block_device */
@@ -547,6 +556,9 @@ struct block_device {
 	 * care to not mess up bd_private for that case.
 	 */
 	unsigned long		bd_private;
+
+	/* State of the block device. (Used by freeze feature) */
+	unsigned long		bd_state;
 };
 
 /*
