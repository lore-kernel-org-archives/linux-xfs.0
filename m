Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 03:30:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3SAUhvJ001795
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 03:30:49 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C5BA10C367B
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 03:31:25 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id zkEUIAdBJGCk1oNK for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 03:31:25 -0700 (PDT)
Subject: [RFC PATCH 1/3] Implement generic freeze feature
Message-Id: <20080428193123t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Mon, 28 Apr 2008 19:31:23 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
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
 fs/block_dev.c     |    3 +++
 fs/buffer.c        |   25 +++++++++++++++++++++++++
 fs/ioctl.c         |   35 +++++++++++++++++++++++++++++++++++
 fs/super.c         |   32 +++++++++++++++++++++++++++++++-
 include/linux/fs.h |    7 +++++++
 5 files changed, 101 insertions(+), 1 deletion(-)

diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.25.org/fs/block_dev.c linux-2.6.25-freeze/fs/block_dev.c
--- linux-2.6.25.org/fs/block_dev.c	2008-04-17 11:49:44.000000000 +0900
+++ linux-2.6.25-freeze/fs/block_dev.c	2008-04-24 20:43:28.000000000 +0900
@@ -284,6 +284,9 @@ static void init_once(struct kmem_cache 
 	INIT_LIST_HEAD(&bdev->bd_holder_list);
 #endif
 	inode_init_once(&ei->vfs_inode);
+
+	/* Initialize semaphore for freeze. */
+	sema_init(&bdev->bd_freeze_sem, 1);
 }
 
 static inline void __bd_forget(struct inode *inode)
diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.25.org/fs/buffer.c linux-2.6.25-freeze/fs/buffer.c
--- linux-2.6.25.org/fs/buffer.c	2008-04-17 11:49:44.000000000 +0900
+++ linux-2.6.25-freeze/fs/buffer.c	2008-04-24 20:43:28.000000000 +0900
@@ -201,6 +201,19 @@ struct super_block *freeze_bdev(struct b
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
@@ -219,6 +232,9 @@ struct super_block *freeze_bdev(struct b
 	}
 
 	sync_blockdev(bdev);
+
+	up(&bdev->bd_freeze_sem);
+
 	return sb;	/* thaw_bdev releases s->s_umount and bd_mount_sem */
 }
 EXPORT_SYMBOL(freeze_bdev);
@@ -232,6 +248,13 @@ EXPORT_SYMBOL(freeze_bdev);
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
 	if (sb) {
 		BUG_ON(sb->s_bdev != bdev);
 
@@ -244,6 +267,8 @@ void thaw_bdev(struct block_device *bdev
 	}
 
 	up(&bdev->bd_mount_sem);
+
+	up(&bdev->bd_freeze_sem);
 }
 EXPORT_SYMBOL(thaw_bdev);
 
diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.25.org/fs/ioctl.c linux-2.6.25-freeze/fs/ioctl.c
--- linux-2.6.25.org/fs/ioctl.c	2008-04-17 11:49:44.000000000 +0900
+++ linux-2.6.25-freeze/fs/ioctl.c	2008-04-24 20:43:28.000000000 +0900
@@ -13,6 +13,7 @@
 #include <linux/security.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
+#include <linux/buffer_head.h>
 
 #include <asm/ioctls.h>
 
@@ -181,6 +182,40 @@ int do_vfs_ioctl(struct file *filp, unsi
 		} else
 			error = -ENOTTY;
 		break;
+
+	case FIFREEZE: {
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
+		/* Freeze. */
+		freeze_bdev(sb->s_bdev);
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
 	default:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.25.org/fs/super.c linux-2.6.25-freeze/fs/super.c
--- linux-2.6.25.org/fs/super.c	2008-04-17 11:49:44.000000000 +0900
+++ linux-2.6.25-freeze/fs/super.c	2008-04-24 20:43:28.000000000 +0900
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
diff -uprN -X /home/sho/pub/MC/freeze-set/dontdiff linux-2.6.25.org/include/linux/fs.h linux-2.6.25-freeze/include/linux
/fs.h
--- linux-2.6.25.org/include/linux/fs.h	2008-04-17 11:49:44.000000000 +0900
+++ linux-2.6.25-freeze/include/linux/fs.h	2008-04-24 20:43:28.000000000 +0900
@@ -223,6 +223,8 @@ extern int dir_notify_enable;
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
+#define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
+#define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -548,6 +550,9 @@ struct block_device {
 	 * care to not mess up bd_private for that case.
 	 */
 	unsigned long		bd_private;
+
+	/* Semaphore for freeze */
+	struct semaphore	bd_freeze_sem;
 };
 
 /*
@@ -1926,7 +1931,9 @@ extern int do_vfs_ioctl(struct file *fil
 extern void get_filesystem(struct file_system_type *fs);
 extern void put_filesystem(struct file_system_type *fs);
 extern struct file_system_type *get_fs_type(const char *name);
+extern void put_super(struct super_block *sb);
 extern struct super_block *get_super(struct block_device *);
+extern struct super_block *get_super_without_lock(struct block_device *);
 extern struct super_block *user_get_super(dev_t);
 extern void drop_super(struct super_block *sb);
 
