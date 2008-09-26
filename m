Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 01:55:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q8tq7u031000
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:55:52 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ACA0E1AF42F9
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:57:26 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id Vmh2bwMSUe8kjAOt for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:57:26 -0700 (PDT)
Subject: [PATCH 1/10] VFS: Fix error handling of write_super_lockfs/unlockfs
Message-Id: <20080926175712t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Fri, 26 Sep 2008 17:57:12 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

I've changed the type of write_super_lockfs and unlockfs from "void" to
"int" so that they can return an error 
and renamed write_super_lockfs/unlockfs of the super block operation
freeze_fs/unfreeze_fs to avoid a confusion.


Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 Documentation/filesystems/Locking |    8 ++++----
 Documentation/filesystems/vfs.txt |    8 ++++----
 fs/buffer.c                       |    8 ++++----
 include/linux/fs.h                |    4 ++--
 4 files changed, 14 insertions(+), 14 deletions(-)

diff -uprN -X linux-2.6.27-rc7/Documentation/dontdiff linux-2.6.27-rc7/Documentation/filesystems/Locking linux-2.6.27-rc
7-lockfs/Documentation/filesystems/Locking
--- linux-2.6.27-rc7/Documentation/filesystems/Locking	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs/Documentation/filesystems/Locking	2008-09-26 18:47:47.000000000 +0900
@@ -97,8 +97,8 @@ prototypes:
 	void (*put_super) (struct super_block *);
 	void (*write_super) (struct super_block *);
 	int (*sync_fs)(struct super_block *sb, int wait);
-	void (*write_super_lockfs) (struct super_block *);
-	void (*unlockfs) (struct super_block *);
+	int (*freeze_fs) (struct super_block *);
+	int (*unfreeze_fs) (struct super_block *);
 	int (*statfs) (struct dentry *, struct kstatfs *);
 	int (*remount_fs) (struct super_block *, int *, char *);
 	void (*clear_inode) (struct inode *);
@@ -119,8 +119,8 @@ delete_inode:		no
 put_super:		yes	yes	no
 write_super:		no	yes	read
 sync_fs:		no	no	read
-write_super_lockfs:	?
-unlockfs:		?
+freeze_fs:		?
+unfreeze_fs:		?
 statfs:			no	no	no
 remount_fs:		yes	yes	maybe		(see below)
 clear_inode:		no
diff -uprN -X linux-2.6.27-rc7/Documentation/dontdiff linux-2.6.27-rc7/Documentation/filesystems/vfs.txt linux-2.6.27-rc
7-lockfs/Documentation/filesystems/vfs.txt
--- linux-2.6.27-rc7/Documentation/filesystems/vfs.txt	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs/Documentation/filesystems/vfs.txt	2008-09-26 18:43:49.000000000 +0900
@@ -210,8 +210,8 @@ struct super_operations {
         void (*put_super) (struct super_block *);
         void (*write_super) (struct super_block *);
         int (*sync_fs)(struct super_block *sb, int wait);
-        void (*write_super_lockfs) (struct super_block *);
-        void (*unlockfs) (struct super_block *);
+        int (*freeze_fs) (struct super_block *);
+        int (*unfreeze_fs) (struct super_block *);
         int (*statfs) (struct dentry *, struct kstatfs *);
         int (*remount_fs) (struct super_block *, int *, char *);
         void (*clear_inode) (struct inode *);
@@ -270,11 +270,11 @@ or bottom half).
   	a superblock. The second parameter indicates whether the method
 	should wait until the write out has been completed. Optional.
 
-  write_super_lockfs: called when VFS is locking a filesystem and
+  freeze_fs: called when VFS is locking a filesystem and
   	forcing it into a consistent state.  This method is currently
   	used by the Logical Volume Manager (LVM).
 
-  unlockfs: called when VFS is unlocking a filesystem and making it writable
+  unfreeze_fs: called when VFS is unlocking a filesystem and making it writable
   	again.
 
   statfs: called when the VFS needs to get filesystem statistics. This
diff -uprN -X linux-2.6.27-rc7/Documentation/dontdiff linux-2.6.27-rc7/fs/buffer.c linux-2.6.27-rc7-lockfs/fs/buffer.c
--- linux-2.6.27-rc7/fs/buffer.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs/fs/buffer.c	2008-09-26 18:41:12.000000000 +0900
@@ -214,8 +214,8 @@ struct super_block *freeze_bdev(struct b
 
 		sync_blockdev(sb->s_bdev);
 
-		if (sb->s_op->write_super_lockfs)
-			sb->s_op->write_super_lockfs(sb);
+		if (sb->s_op->freeze_fs)
+			sb->s_op->freeze_fs(sb);
 	}
 
 	sync_blockdev(bdev);
@@ -235,8 +235,8 @@ void thaw_bdev(struct block_device *bdev
 	if (sb) {
 		BUG_ON(sb->s_bdev != bdev);
 
-		if (sb->s_op->unlockfs)
-			sb->s_op->unlockfs(sb);
+		if (sb->s_op->unfreeze_fs)
+			sb->s_op->unfreeze_fs(sb);
 		sb->s_frozen = SB_UNFROZEN;
 		smp_wmb();
 		wake_up(&sb->s_wait_unfrozen);
diff -uprN -X linux-2.6.27-rc7/Documentation/dontdiff linux-2.6.27-rc7/include/linux/fs.h linux-2.6.27-rc7-lockfs/includ
e/linux/fs.h
--- linux-2.6.27-rc7/include/linux/fs.h	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs/include/linux/fs.h	2008-09-26 18:44:27.000000000 +0900
@@ -1314,8 +1314,8 @@ struct super_operations {
 	void (*put_super) (struct super_block *);
 	void (*write_super) (struct super_block *);
 	int (*sync_fs)(struct super_block *sb, int wait);
-	void (*write_super_lockfs) (struct super_block *);
-	void (*unlockfs) (struct super_block *);
+	int (*freeze_fs) (struct super_block *);
+	int (*unfreeze_fs) (struct super_block *);
 	int (*statfs) (struct dentry *, struct kstatfs *);
 	int (*remount_fs) (struct super_block *, int *, char *);
 	void (*clear_inode) (struct inode *);
