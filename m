Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2465C424664;
	Mon, 12 Oct 2026 10:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800535; cv=none; b=BC78QAEdXq7pSUu3CAFJBVMwAkuc6zgMwDvw4AQdah0xu9CqeXpoo8Sry9thzL8t9zq0t2R0d5VWGLmJssJzyIw/3spDlOvjPIFVkksCunCc6hEOWzYHqgMVarxf4wHXvkHMF4z9UmPplHRpvoLGpGUiN8SXPQ5o6va3U0tzaoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800535; c=relaxed/simple;
	bh=6anLCPpwN73VxuPpEMeUkbDbEGbtdtAByt0MCWOz6uo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OaKHO0PL4DrHN6P8ZJnvT56/eP/uvn3nyJDJnKaxDsFonsmS5sEZj/FgPJ/YW+956B9vxKe0tnNYNq87rgeSfhZFjHTz0OS1SyMCAzRGlvu9iDF3NIm17TLZ2IiSsR0R/c7fk5pHccbeBCwJkUxuDEtv3GUmneHw44ozFKmiroQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SBygnPpW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SBygnPpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AC71F0089D;
	Mon, 12 Oct 2026 10:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800519;
	bh=IJigOaOilzYVKcuivesHJ4xgfHrsueOec/ivWLVEycM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SBygnPpWTnxHw3t7Qqkehnfr7os8oPi2tibjRBO6pqLqsH5XM7mYcr0HIjk8VH13i
	 4xDtP/zuPo4Wa5HaAed77efDVgGbNF4gwOxLll7F/LkbdsQ66KEv8dqonvHsoHdoP9
	 ooVRvWrzfSAj5jjYXEMxmnr9uRzxOglDWOHXRwONFFO1J8V8JP3oF5HxTRBjni9hOM
	 WVPhhOxIBBovRO4r9Snly9V1fknrRHGApHgOypBuWm4w4CCAtbD2/uzWWIfHZ7/7h+
	 Yq2MsUUSNE00KOfgcqMdlr4Bi7hEEx6LBYxyYnP74bsshAjznFUXDANcABiZjAefEQ
	 QV77o9W1mlyxg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:20:56 +0200
Subject: [PATCH RFC 11/28] affs: don't set SB_RDONLY after filesystem
 errors
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-11-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
To: Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
 ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
 gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
 linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=12830; i=brauner@kernel.org;
 h=from:subject:message-id; bh=6anLCPpwN73VxuPpEMeUkbDbEGbtdtAByt0MCWOz6uo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TKZV29biHBz2MQ50ntkU3j0m/3ZjR8oTmC7sHtRG
 F+0yMTsjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInsVWP47ztBWSz75G318pgf
 PTt5u3Wk0pYL7HRad8jZ9eKWzA6Heoa/8i4vgjJC3UzZNmSrp8tHx/M+EGS8e0b5/13xd7xmLwv
 4AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

affs_error() sets SB_RDONLY without holding sb->s_umount and it can be
called at any time, including while the filesystem is frozen.

freeze_super() and thaw_super() both look at sb_rdonly() to figure out
whether the s_writers rwsems need to be taken or released. So if
affs_error() flips SB_RDONLY while the filesystem is frozen
thaw_super() skips sb_freeze_unlock() and the rwsems stay write-locked.
Every writer after that hangs in sb_start_write() and umount warns in
rcu_sync_dtor().

affs has no ->freeze_fs() but bdev_freeze() still freezes it, e.g. when
device mapper suspends the device with lockfs. That holds new I/O but
affs_bread() refuses blocks outside the partition without doing any
I/O. So a cached directory with a bogus block in its hash table is
enough:

  affs: error (device dm-0): readdir(): Cannot read block 1048576
  affs: Remounting filesystem read-only

After the resume umount warns:

  WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0x143/0x190, CPU#1: kworker/1:0/25
    percpu_free_rwsem+0x38/0xa0
    destroy_super_work+0x133/0x2f0
  WARNING: kernel/rcu/sync.c:180 at rcu_sync_dtor+0x14c/0x190
  WARNING: kernel/rcu/sync.c:188 at rcu_sync_dtor+0x13d/0x190

and a create instead of the umount blocks forever:

  [<0>] percpu_rwsem_wait+0x203/0x500
  [<0>] mnt_want_write+0x28f/0x2f0
  [<0>] lookup_open+0x135/0x1b20
  INFO: task s5_dm:119 blocked for more than 30 seconds.

So do what ext4 did in commit d3476f3dad4a ("ext4: don't set SB_RDONLY
after filesystem errors"). Record the error in a new
AFFS_STATE_EMERGENCY_RO bit and let affs refuse modifications with
-EROFS itself. The bit lives in a new s_state word because sbi->s_flags
holds the mount options and affs_reconfigure() rewrites it on every
remount. affs_commit_super(), which ->sync_fs() and the superblock work
call, just returns early now so the root block isn't updated anymore
either.

Note that writeback clears the dirty state of an inode before it calls
->write_inode() and doesn't redirty it when that fails. So fsync() would
happily report success for an inode that never made it to disk. Let
fsync() fail with -EROFS instead. Like on ext4 an operation that
completed shortly before the error can end up half-applied on disk and
needs fsck.

Going back to read-write fails with -EROFS until umount. So far
"mount -o remount,rw" made the filesystem writable again after an
error. Going read-only is still allowed. Otherwise emergency remount
(sysrq u) would WARN for every affs that hit an error. The bitmap stays
around in that case because evict and the last close still hand
preallocated blocks back. affs_kill_sb() frees it once all inodes are
gone.

Like ext4 we show "emergency_ro" in the mount options. The mount stays
"rw". Opening a file for writing still fails with -EROFS. It's just
affs that refuses it now instead of sb_permission(). And a new
affs_file_write_iter() takes care of file descriptors that were opened
before the error. Writes through those used to succeed.

Reproducer. There's no mkfs for affs in Linux userspace. affs.img is a
1 MiB FFS image with a directory "d" whose hash table has a slot
pointing at block 0x100000, outside the partition, with valid checksums:

  dev=$(losetup -f --show affs.img)
  dmsetup create affs --table "0 $(blockdev --getsz $dev) linear $dev 0"
  mount -t affs /dev/mapper/affs /mnt
  stat /mnt/d             # caches the header block of "d"
  dmsetup suspend affs    # lock_fs() -> bdev_freeze() -> freeze_super()
  ls /mnt/d               # affs_error() -> SB_RDONLY while frozen
  dmsetup resume affs     # thaw sees SB_RDONLY, s_writers stay locked
  touch /mnt/x            # hangs in sb_start_write() forever
  # instead of touch: umount /mnt -> WARNING in rcu_sync_dtor()

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/affs/affs.h     |  9 +++++++++
 fs/affs/amigaffs.c | 10 ++++++++--
 fs/affs/file.c     | 16 +++++++++++++++-
 fs/affs/inode.c    |  5 +++++
 fs/affs/namei.c    | 18 ++++++++++++++++++
 fs/affs/super.c    | 24 ++++++++++++++++++++----
 6 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index d1c506c1f310..3a914fb4c6e1 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -86,6 +86,7 @@ struct affs_sb_info {
 	u32 s_root_block;		/* FFS root block number. */
 	int s_hashsize;			/* Size of hash table. */
 	unsigned long s_flags;		/* See below. */
+	unsigned long s_state;		/* AFFS_STATE_* bits. */
 	kuid_t s_uid;			/* uid to override */
 	kgid_t s_gid;			/* gid to override */
 	umode_t s_mode;			/* mode to override */
@@ -119,6 +120,9 @@ struct affs_sb_info {
 #define AFFS_MOUNT_SF_VERBOSE		0x0800 /* Talk about fs when mounting */
 #define AFFS_MOUNT_SF_NO_TRUNCATE	0x1000 /* Don't truncate filenames */
 
+/* Bits in affs_sb_info->s_state. */
+#define AFFS_STATE_EMERGENCY_RO	0	/* Refuse modifications after an error */
+
 #define affs_clear_opt(o, opt)    (o &= ~AFFS_MOUNT_##opt)
 #define affs_set_opt(o, opt)      (o |= AFFS_MOUNT_##opt)
 #define affs_test_opt(o, opt)     ((o) & AFFS_MOUNT_##opt)
@@ -129,6 +133,11 @@ static inline struct affs_sb_info *AFFS_SB(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
+static inline bool affs_emergency_ro(struct super_block *sb)
+{
+	return test_bit(AFFS_STATE_EMERGENCY_RO, &AFFS_SB(sb)->s_state);
+}
+
 void affs_mark_sb_dirty(struct super_block *sb);
 
 /* amigaffs.c */
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index 6cc0fc9a4cbf..813e55bf1121 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -479,9 +479,15 @@ affs_error(struct super_block *sb, const char *function, const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &args;
 	pr_crit("error (device %s): %s(): %pV\n", sb->s_id, function, &vaf);
-	if (!sb_rdonly(sb))
+	/*
+	 * Don't set SB_RDONLY: that requires sb->s_umount and a proper
+	 * remount. Set while the superblock is frozen it makes thaw_super()
+	 * skip releasing s_writers and every later writer hangs. Refuse
+	 * modifications until umount instead.
+	 */
+	if (!sb_rdonly(sb) &&
+	    !test_and_set_bit(AFFS_STATE_EMERGENCY_RO, &AFFS_SB(sb)->s_state))
 		pr_warn("Remounting filesystem read-only\n");
-	sb->s_flags |= SB_RDONLY;
 	va_end(args);
 }
 
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 23e088a7ed4f..9e048de21234 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -26,6 +26,8 @@ affs_file_open(struct inode *inode, struct file *filp)
 {
 	pr_debug("open(%llu,%d)\n",
 		 inode->i_ino, atomic_read(&AFFS_I(inode)->i_opencnt));
+	if ((filp->f_mode & FMODE_WRITE) && affs_emergency_ro(inode->i_sb))
+		return -EROFS;
 	atomic_inc(&AFFS_I(inode)->i_opencnt);
 	return 0;
 }
@@ -988,6 +990,10 @@ int affs_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 	struct inode *inode = filp->f_mapping->host;
 	int ret, err;
 
+	/* Inodes aren't written back after an error. */
+	if (affs_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	err = file_write_and_wait_range(filp, start, end);
 	if (err)
 		return err;
@@ -1000,10 +1006,18 @@ int affs_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 	inode_unlock(inode);
 	return ret;
 }
+
+static ssize_t affs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	if (affs_emergency_ro(file_inode(iocb->ki_filp)->i_sb))
+		return -EROFS;
+	return generic_file_write_iter(iocb, from);
+}
+
 const struct file_operations affs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
-	.write_iter	= generic_file_write_iter,
+	.write_iter	= affs_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
 	.open		= affs_file_open,
 	.release	= affs_file_release,
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index d4a3f381c4bc..61a80d42297b 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -173,6 +173,8 @@ affs_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 	pr_debug("write_inode(%llu)\n", inode->i_ino);
 
+	if (affs_emergency_ro(sb))
+		return -EROFS;
 	if (!inode->i_nlink)
 		// possibly free block
 		return 0;
@@ -220,6 +222,9 @@ affs_setattr(struct mnt_idmap *idmap, struct dentry *dentry, struct iattr *attr)
 
 	pr_debug("setattr(%llu,0x%x)\n", inode->i_ino, attr->ia_valid);
 
+	if (affs_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	error = setattr_prepare(&nop_mnt_idmap, dentry, attr);
 	if (error)
 		goto out;
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index 6cb52efafe5f..00f02ca25dbe 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -238,6 +238,8 @@ affs_unlink(struct inode *dir, struct dentry *dentry)
 	pr_debug("%s(dir=%llu, %llu \"%pd\")\n", __func__, dir->i_ino,
 		 d_inode(dentry)->i_ino, dentry);
 
+	if (affs_emergency_ro(dir->i_sb))
+		return -EROFS;
 	return affs_remove_header(dentry);
 }
 
@@ -252,6 +254,9 @@ affs_create(struct mnt_idmap *idmap, struct inode *dir,
 	pr_debug("%s(%llu,\"%pd\",0%ho)\n",
 		 __func__, dir->i_ino, dentry, mode);
 
+	if (affs_emergency_ro(sb))
+		return -EROFS;
+
 	inode = affs_new_inode(dir);
 	if (!inode)
 		return -ENOSPC;
@@ -283,6 +288,9 @@ affs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	pr_debug("%s(%llu,\"%pd\",0%ho)\n",
 		 __func__, dir->i_ino, dentry, mode);
 
+	if (affs_emergency_ro(dir->i_sb))
+		return ERR_PTR(-EROFS);
+
 	inode = affs_new_inode(dir);
 	if (!inode)
 		return ERR_PTR(-ENOSPC);
@@ -309,6 +317,8 @@ affs_rmdir(struct inode *dir, struct dentry *dentry)
 	pr_debug("%s(dir=%llu, %llu \"%pd\")\n", __func__, dir->i_ino,
 		 d_inode(dentry)->i_ino, dentry);
 
+	if (affs_emergency_ro(dir->i_sb))
+		return -EROFS;
 	return affs_remove_header(dentry);
 }
 
@@ -326,6 +336,9 @@ affs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	pr_debug("%s(%llu,\"%pd\" -> \"%s\")\n",
 		 __func__, dir->i_ino, dentry, symname);
 
+	if (affs_emergency_ro(sb))
+		return -EROFS;
+
 	maxlen = AFFS_SB(sb)->s_hashsize * sizeof(u32) - 1;
 	inode  = affs_new_inode(dir);
 	if (!inode)
@@ -398,6 +411,8 @@ affs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 	pr_debug("%s(%llu, %llu, \"%pd\")\n", __func__, inode->i_ino, dir->i_ino,
 		 dentry);
 
+	if (affs_emergency_ro(dir->i_sb))
+		return -EROFS;
 	return affs_add_entry(dir, inode, dentry, ST_LINKFILE);
 }
 
@@ -514,6 +529,9 @@ int affs_rename2(struct mnt_idmap *idmap, struct inode *old_dir,
 	pr_debug("%s(old=%llu,\"%pd\" to new=%llu,\"%pd\")\n", __func__,
 		 old_dir->i_ino, old_dentry, new_dir->i_ino, new_dentry);
 
+	if (affs_emergency_ro(old_dir->i_sb))
+		return -EROFS;
+
 	if (flags & RENAME_EXCHANGE)
 		return affs_xrename(old_dir, old_dentry, new_dir, new_dentry);
 
diff --git a/fs/affs/super.c b/fs/affs/super.c
index ed8225b3c93d..7b5fa2c092f7 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -36,6 +36,9 @@ affs_commit_super(struct super_block *sb, int wait)
 	struct buffer_head *bh = sbi->s_root_bh;
 	struct affs_root_tail *tail = AFFS_ROOT_TAIL(sb, bh);
 
+	if (affs_emergency_ro(sb))
+		return;
+
 	lock_buffer(bh);
 	affs_secs_to_datestamp(ktime_get_real_seconds(), &tail->disk_change);
 	affs_fix_checksum(sb, bh);
@@ -82,7 +85,7 @@ void affs_mark_sb_dirty(struct super_block *sb)
 	struct affs_sb_info *sbi = AFFS_SB(sb);
 	unsigned long delay;
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || affs_emergency_ro(sb))
 	       return;
 
 	spin_lock(&sbi->work_lock);
@@ -296,6 +299,8 @@ static int affs_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",verbose");
 	if (sbi->s_volume[0])
 		seq_printf(m, ",volume=%s", sbi->s_volume);
+	if (affs_emergency_ro(sb))
+		seq_puts(m, ",emergency_ro");
 	return 0;
 }
 
@@ -524,6 +529,11 @@ static int affs_reconfigure(struct fs_context *fc)
 	struct affs_sb_info	*sbi = AFFS_SB(sb);
 	int			 res = 0;
 
+	/* After an error, refuse going back to read-write until umount. */
+	if (affs_emergency_ro(sb) && sb_rdonly(sb) &&
+	    !(fc->sb_flags & SB_RDONLY))
+		return -EROFS;
+
 	sync_filesystem(sb);
 	fc->sb_flags |= SB_NODIRATIME;
 
@@ -550,10 +560,16 @@ static int affs_reconfigure(struct fs_context *fc)
 	if ((bool)(fc->sb_flags & SB_RDONLY) == sb_rdonly(sb))
 		return 0;
 
-	if (fc->sb_flags & SB_RDONLY)
-		affs_free_bitmap(sb);
-	else
+	if (fc->sb_flags & SB_RDONLY) {
+		/*
+		 * After an error evict and release still hand preallocated
+		 * and truncated blocks back, keep the bitmap until umount.
+		 */
+		if (!affs_emergency_ro(sb))
+			affs_free_bitmap(sb);
+	} else {
 		res = affs_init_bitmap(sb, &fc->sb_flags);
+	}
 
 	return res;
 }

-- 
2.53.0

