Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47838 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfDAHAT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 03:00:19 -0400
Date: Mon, 1 Apr 2019 00:00:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] bootfs: simple bootloader filesystem
Message-ID: <20190401070001.GJ1173@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <djwong@kernel.org>

Does your computer use a bootloader which arrogantly declares that it can
read boot files off a filesystem but isn't sophisticated enough even to
recognize when that filesystem needs journal recovery?

Does your system software deployment program foolishly omit system calls
to flush newly unwrapped packages to disk?  Do you sometimes wonder if
they've forgotten that old maxim, "wait for the disk drive light to turn
off /before/ you power down"?

Are your computer operators aggressively derpy?  Do they have a habit of
leaving disk cables on the floor so they can trip over them twenty times
a day?  Does this leave you with sad files full of zeroes?

If so, bootfs is for you!  This new filesystem type uses journalling to
ensure metadata integrity, but forces all writes and directory tree
updates to be synchronous, fsyncs files on close, and checkpoints its
journal whenever a synchronization event happens.  Some allege this is
very slow, but I've been able to max out the iops on both of my double
height floppy drives!  In a power-cycling stress test, I found that the
switch broke off in my hand before I lost any data.  This concept may
sound terrible, but like any good crutch, it _is_ made of wood!

Singed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/ext4/Kconfig |   23 ++++++++
 fs/ext4/ext4.h  |    3 +
 fs/ext4/file.c  |    2 -
 fs/ext4/fsync.c |    3 +
 fs/ext4/super.c |  152 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 182 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 06f77ca7f36e..44fe22505639 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -105,3 +105,26 @@ config EXT4_DEBUG
 	  If you select Y here, then you will be able to turn on debugging
 	  with a command such as:
 		echo 1 > /sys/module/ext4/parameters/mballoc_debug
+
+config BOOT_FS
+	bool "Simple Bootloader Filesystem"
+	depends on EXT4_FS
+	help
+	  Certain unified bootloaders have incomplete filesystem drivers
+	  which expect never to have to deal with unrecovered logs and
+	  metadata.  This can lead to boot failures if the system goes
+	  down immediately after deploying new boot files.
+
+	  Worse yet, certain package deployment systems still do not call
+	  fsync to force newly deployed file data out to storage, which
+	  can lead to missing or zero-filled files on restart.
+
+	  If your software ecosystem is deficient like this, bootfs can
+	  compensate!  It forces synchronous writes and directory updates
+	  and while it does use a journal for metadata integrity, it forces
+	  journal checkpointing on every fsync and sync call.
+
+	  These special bootfs filesystems can be formatted with the
+	  mkfs.bootfs utility.
+
+	  Say Y here if your software sucks.
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 82ffdacdc7fa..32d53c5069af 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3250,4 +3250,7 @@ extern const struct iomap_ops ext4_iomap_ops;
 #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
 #define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
 
+int bootfs_sync_fs(struct super_block *sb);
+int bootfs_release_file(struct file *file);
+
 #endif	/* _EXT4_H */
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 98ec11f69cd4..393a03e7a311 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -100,7 +100,7 @@ static int ext4_release_file(struct inode *inode, struct file *filp)
 	if (is_dx(inode) && filp->private_data)
 		ext4_htree_free_dir_info(filp->private_data);
 
-	return 0;
+	return bootfs_release_file(filp);
 }
 
 static void ext4_unwritten_wait(struct inode *inode)
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 5508baa11bb6..ff55ac5c1635 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -158,6 +158,9 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		if (!ret)
 			ret = err;
 	}
+
+	if (!ret)
+		ret = bootfs_sync_fs(inode->i_sb);
 out:
 	err = file_check_and_advance_wb_err(file);
 	if (ret == 0)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6ed4eb81e674..cf543bd7040d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -76,6 +76,8 @@ static int ext4_unfreeze(struct super_block *sb);
 static int ext4_freeze(struct super_block *sb);
 static struct dentry *ext4_mount(struct file_system_type *fs_type, int flags,
 		       const char *dev_name, void *data);
+static inline void bootfs_remount(struct super_block *sb, int *flags);
+static inline int bootfs_feature_set_ok(struct super_block *sb);
 static inline int ext2_feature_set_ok(struct super_block *sb);
 static inline int ext3_feature_set_ok(struct super_block *sb);
 static int ext4_feature_set_ok(struct super_block *sb, int readonly);
@@ -113,6 +115,37 @@ static struct inode *ext4_get_journal_inode(struct super_block *sb,
  * transaction start -> page lock(s) -> i_data_sem (rw)
  */
 
+#if defined(CONFIG_BOOT_FS)
+static const char bootfs_data[] =
+		"nodelalloc,errors=remount-ro,acl,block_validity";
+#define BOOTFS_SB_FLAGS	(SB_SYNCHRONOUS | SB_DIRSYNC)
+static struct dentry *bootfs_mount(struct file_system_type *fs_type, int flags,
+				   const char *dev_name, void *data)
+{
+	char *new_data;
+	struct dentry *ret;
+
+	new_data = kstrndup(bootfs_data, sizeof(bootfs_data), GFP_KERNEL);
+	flags |= BOOTFS_SB_FLAGS;
+	ret = ext4_mount(fs_type, flags, dev_name, new_data);
+	kfree(new_data);
+	return ret;
+}
+
+static struct file_system_type bootfs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "bootfs",
+	.mount		= bootfs_mount,
+	.kill_sb	= kill_block_super,
+	.fs_flags	= FS_REQUIRES_DEV,
+};
+MODULE_ALIAS_FS("bootfs");
+MODULE_ALIAS("bootfs");
+#define IS_BOOTFS_SB(sb) ((sb)->s_bdev->bd_holder == &bootfs_type)
+#else
+#define IS_BOOTFS_SB(sb) (0)
+#endif
+
 #if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT2)
 static struct file_system_type ext2_fs_type = {
 	.owner		= THIS_MODULE,
@@ -3799,6 +3832,23 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 	}
 
+	if (IS_BOOTFS_SB(sb)) {
+		if (bootfs_feature_set_ok(sb))
+			ext4_msg(sb, KERN_INFO, "mounting bootfs file system "
+				 "using the ext4 subsystem");
+		else {
+			/*
+			 * If we're probing be silent, if this looks like
+			 * it's actually an ext[34] filesystem.
+			 */
+			if (silent && bootfs_feature_set_ok(sb))
+				goto failed_mount;
+			ext4_msg(sb, KERN_ERR, "couldn't mount as bootfs due "
+				 "to feature incompatibilities");
+			goto failed_mount;
+		}
+	}
+
 	if (IS_EXT2_SB(sb)) {
 		if (ext2_feature_set_ok(sb))
 			ext4_msg(sb, KERN_INFO, "mounting ext2 file system "
@@ -5063,6 +5113,9 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 			ret = err;
 	}
 
+	if (!ret)
+		ret = bootfs_sync_fs(sb);
+
 	return ret;
 }
 
@@ -5161,6 +5214,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	if (data && !orig_data)
 		return -ENOMEM;
 
+	bootfs_remount(sb, flags);
+
 	/* Store the original options */
 	old_sb_flags = sb->s_flags;
 	old_opts.s_mount_opt = sbi->s_mount_opt;
@@ -5924,6 +5979,100 @@ static struct dentry *ext4_mount(struct file_system_type *fs_type, int flags,
 	return mount_bdev(fs_type, flags, dev_name, data, ext4_fill_super);
 }
 
+#if defined(CONFIG_BOOT_FS)
+static inline void register_as_bootfs(void)
+{
+	int err = register_filesystem(&bootfs_type);
+	if (err)
+		printk(KERN_WARNING
+		       "bootfs: Unable to register (%d)\n", err);
+}
+
+static inline void unregister_as_bootfs(void)
+{
+	unregister_filesystem(&bootfs_type);
+}
+
+#define BOOTFS_COMPAT	(EXT4_FEATURE_COMPAT_HAS_JOURNAL | \
+			 EXT4_FEATURE_COMPAT_EXT_ATTR | \
+			 EXT4_FEATURE_COMPAT_RESIZE_INODE | \
+			 EXT4_FEATURE_COMPAT_DIR_INDEX)
+#define BOOTFS_ROCOMPAT	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER | \
+			 EXT4_FEATURE_RO_COMPAT_LARGE_FILE)
+#define BOOTFS_INCOMPAT	(EXT4_FEATURE_INCOMPAT_FILETYPE | \
+			 EXT4_FEATURE_INCOMPAT_EXTENTS)
+static inline int bootfs_feature_set_ok(struct super_block *sb)
+{
+	/* We support a very limited feature set. */
+	if (EXT4_SB(sb)->s_es->s_feature_compat != BOOTFS_COMPAT)
+		return 0;
+	if (EXT4_SB(sb)->s_es->s_feature_ro_compat != BOOTFS_ROCOMPAT)
+		return 0;
+	if ((EXT4_SB(sb)->s_es->s_feature_incompat &
+				~EXT4_FEATURE_INCOMPAT_RECOVER) !=
+			BOOTFS_INCOMPAT)
+		return 0;
+	return 1;
+}
+
+int bootfs_sync_fs(struct super_block *sb)
+{
+	journal_t *journal;
+	int error;
+
+	if (!IS_BOOTFS_SB(sb))
+		return 0;
+
+	journal = EXT4_SB(sb)->s_journal;
+
+	/*
+	 * Lock down the journal and flush it so that filesystem metadata are
+	 * checkpointed back into the filesystem.  Yes, that's what we have to
+	 * do to work around grub being stupid enough to read from a dirty
+	 * filesystem.
+	 */
+	jbd2_journal_lock_updates(journal);
+
+	error = jbd2_journal_flush(journal);
+	if (error < 0)
+		goto out;
+
+	error = ext4_commit_super(sb, 1);
+out:
+	jbd2_journal_unlock_updates(journal);
+	return error;
+}
+
+/* Release file, and if it was written, fsync it & checkpoint journal. */
+int bootfs_release_file(struct file *file)
+{
+	int ret;
+
+	if (!IS_BOOTFS_SB(sb))
+		return 0;
+	if ((file->f_mode & (FMODE_WRITE | FMODE_READ)) == FMODE_READ)
+		return 0;
+
+	return vfs_fsync(file, 1);
+}
+
+static inline void bootfs_remount(struct super_block *sb, int *flags)
+{
+	if (!IS_BOOTFS_SB(sb))
+		return;
+
+	/* No, you don't get to disable synchronous writes. */
+	*flags |= BOOTFS_SB_FLAGS;
+}
+#else
+int bootfs_sync_fs(struct super_block *sb) { return 0; }
+int bootfs_release_file(struct file *file) { return 0; }
+static inline void bootfs_remount(struct super_block *sb, int *flags) { }
+static inline void register_as_bootfs(void) { }
+static inline void unregister_as_bootfs(void) { }
+static inline int bootfs_feature_set_ok(struct super_block *sb) { return 0; }
+#endif
+
 #if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT2)
 static inline void register_as_ext2(void)
 {
@@ -6034,12 +6183,14 @@ static int __init ext4_init_fs(void)
 		goto out1;
 	register_as_ext3();
 	register_as_ext2();
+	register_as_bootfs();
 	err = register_filesystem(&ext4_fs_type);
 	if (err)
 		goto out;
 
 	return 0;
 out:
+	unregister_as_bootfs();
 	unregister_as_ext2();
 	unregister_as_ext3();
 	destroy_inodecache();
@@ -6062,6 +6213,7 @@ static int __init ext4_init_fs(void)
 static void __exit ext4_exit_fs(void)
 {
 	ext4_destroy_lazyinit_thread();
+	unregister_as_bootfs();
 	unregister_as_ext2();
 	unregister_as_ext3();
 	unregister_filesystem(&ext4_fs_type);
