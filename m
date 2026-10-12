Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7190A3F58D9;
	Mon, 12 Oct 2026 10:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800498; cv=none; b=lqAa05IAcwO9EUoCVXbcR2K5QYd9ITMKdkh4a63y7lHw1FJELn7rkN+4rtBSQ7qrwyGSc2kGisXRpfgN+8hbRx5iiHhI3eNcLKkXv+J8kuyUDSA0oyGGr4/A3JEx5tnioxaeAOiE2uJdYoG9IWjUh5L8kR6iUjFS/g9jLh6+Yl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800498; c=relaxed/simple;
	bh=Uk/uCwvVCwW3OV5RA1JSYxM9RoScvZpYZ4JAjXq+PyQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=G0RoYF/A/P7eazgLP21VYzJ/LPSbCoJKFk7ebxIBXppW36/YsUlKVVlNTha3SdQEcV2XJjtvXOowAyawWjhcYXd+16yEEwwpW//9xZHBBOWFy8SRX9IOclWToLd64dFIZsi4WuWY2VaW3Zp2spmx2r5DoqBt6An/aKzQ3GEOzv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LSCUFr7l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LSCUFr7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FAC1F0089E;
	Mon, 12 Oct 2026 10:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800486;
	bh=eqiECI6ZVpCd31L9/dK+Ho21mJ8pOlfOuLIHxnDpdYs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LSCUFr7lfvw3T9l6LGOtDb2CnbsLd9CqmkSpnSm1dgJLfpKFF+frjDmJbYIT4OrAz
	 We8mEtKmi+N+V4ZzPZNCcZAQCTspIekVWCR+9i9G3hcV1ykW4z4JmCiMXHXf4V6AGN
	 wDggu0tDB6DDRdXayuYJchh692vUXJmyeO0jucCCMN6s8/RkdE3pkgQ2/G+AQwF9NI
	 9/pXVMM9P1m0xnaKT+OneJ2YShzwS/OdhqK4KqILehbeO5ZCWNTpoBq7G723aiYU5P
	 RYEWyxPpYXkM/rtQaM1rubwXKQ0BsB5w+MO7nfi6A0uSjnqZzVCOfXnSLn2zYBjixa
	 zffTJOcotRV8w==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:20:48 +0200
Subject: [PATCH RFC 03/28] ext2: don't set SB_RDONLY after filesystem
 errors
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-3-60743a3dc326@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Karl Mehltretter <kmehltretter@gmail.com>
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=18791; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Uk/uCwvVCwW3OV5RA1JSYxM9RoScvZpYZ4JAjXq+PyQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TLpY8sKgSuzz7/8W+/QUs4pseZW5tYfRzcFCbhte
 JbAYXa1oqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi/osZGeazConu3VKn7qJz
 i/u4dEzRu+V7F5beKsv6cWObUKr4XQaGn4zPLt/L3P304cN1bxeumPe7yPuK14rzRxi6rCctDF9
 4TYAXAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

When ext2 is mounted with errors=remount-ro ext2_error() sets SB_RDONLY.
It does that without holding sb->s_umount and from whatever context
found the error. That includes a frozen filesystem. FIFREEZE doesn't
block reads so a lookup in a corrupted directory is enough to get there.

That's a problem because freeze_super() and thaw_super() both look at
sb_rdonly() to figure out whether the s_writers rwsems need to be taken
or released. A read-only superblock is frozen without taking them. So if
SB_RDONLY gets set while the filesystem is frozen thaw_super() takes the
read-only shortcut, skips ->unfreeze_fs() and sb_freeze_unlock() and
marks the superblock unfrozen with all three rwsems still write-locked.
Every writer after that blocks forever in sb_start_write():

  EXT2-fs (vda): error: ext2_check_folio: bad entry in directory #12: : rec_len is smaller than minimal - offset=24, inode=13, rec_len=0, name_len=1
  EXT2-fs (vda): error: remounting filesystem read-only
  [<0>] percpu_rwsem_wait+0x203/0x500
  [<0>] mnt_want_write+0x28f/0x2f0
  [<0>] lookup_open+0x135/0x1b20
  INFO: task touch:106 blocked for more than 30 seconds.

And if we umount instead the rwsems are freed while still locked:

  WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0x143/0x190, CPU#0: kworker/0:1/11
  WARNING: kernel/rcu/sync.c:180 at rcu_sync_dtor+0x14c/0x190
  WARNING: kernel/rcu/sync.c:188 at rcu_sync_dtor+0x13d/0x190

Karl proposed teaching thaw_super() to remember whether the freeze took
the rwsems. But changing SB_RDONLY behind the VFS' back causes more
surprises than confused freezing and Jan preferred fixing the
filesystems instead (cf. [1]). ext4 stopped doing this in
commit d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem
errors") and f2fs followed in commit 930c6ab93492 ("f2fs: fix to don't
set SB_RDONLY in f2fs_handle_critical_error()"). So let's do the same
for ext2.

ext2 has no journal and no shutdown state we could reuse. So add
EXT2_FLAGS_EMERGENCY_RO, set it from ext2_error() instead of SB_RDONLY
and let ext2 refuse modifications with -EROFS itself. The VFS won't do
that for us anymore. Most of it happens where ext2 allocates inodes and
blocks and in ext2_write_inode(). The rest are checks in the remaining
entry points like unlink, rename, setattr, write_iter, opening for
write, xattrs and quota changes. The first error is still recorded in
the superblock as before. After that the superblock isn't written
anymore and an unlinked inode that gets evicted is left to e2fsck.

Every directory change ends in ext2_handle_dirsync() which writes the
directory inode. If another task hits an error after an operation got
past its check that write fails with -EROFS although the directory entry
was already changed. A create would then drop the new inode while its
entry stays around. So treat -EROFS as success there once the flag is
set.

Note that writeback clears the dirty state of an inode before it calls
->write_inode() and doesn't redirty it when that fails. So fsync() would
happily report success for an inode that never made it to disk. Let
fsync() fail with -EROFS instead. Like on ext4 an operation that
completed shortly before the error can end up half-applied on disk and
needs e2fsck. Data that's already in the page cache still goes to blocks
that are already allocated, just like it did with SB_RDONLY.

The flag is never cleared. A remount to read-write fails with -EROFS
until umount while so far "mount -o remount,rw" made the filesystem
writable again after an error. A remount to read-only is allowed and
writes nothing. Otherwise emergency remount (sysrq u) would WARN in
reconfigure_super() for every ext2 that hit an error. Similar to
commit 6b76715d5e41 ("ext4: show 'emergency_ro' when
EXT4_FLAGS_EMERGENCY_RO is set") we show "emergency_ro" in the mount
options.

The superblock itself stays read-write. So statfs() doesn't report
ST_RDONLY anymore and writes through file descriptors that were opened
before the error now fail with -EROFS where they used to succeed. A
second mount of the device has to match the read-only state of the
superblock so a read-only mount now fails with -EBUSY. And a non-forced
remount to read-only fails with -EBUSY while such file descriptors are
still open.

Reproducer (the sb_rdonly selftest at the end of this series covers it
as well):

  truncate -s 64M img; mkfs.ext2 -q -b 4096 img
  mount -o loop,errors=remount-ro img /mnt
  mkdir /mnt/d; touch /mnt/d/f; umount /mnt
  # rec_len of "f", the entry after "." and "..", := 0
  blk=$(debugfs -R 'bmap /d 0' img 2>/dev/null)
  printf '\0\0' | dd of=img bs=1 seek=$((blk * 4096 + 28)) conv=notrunc
  mount -o loop,errors=remount-ro img /mnt
  fsfreeze -f /mnt; ls /mnt/d; fsfreeze -u /mnt
  touch /mnt/x     # blocks forever in sb_start_write()
  # or umount instead: rcu_sync_dtor() warns three times

[1]: https://lore.kernel.org/r/hyhuckyohsabx2suvq3z7uy3pbgmihva6wgzxr3op7pzcrlu33@p7zzlgp2ehjf

Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext2/balloc.c |  5 +++++
 fs/ext2/dir.c    |  5 ++++-
 fs/ext2/ext2.h   | 14 +++++++++++++
 fs/ext2/file.c   | 16 ++++++++++++++-
 fs/ext2/ialloc.c |  2 ++
 fs/ext2/inode.c  | 13 ++++++++++--
 fs/ext2/ioctl.c  |  7 +++++++
 fs/ext2/namei.c  | 10 +++++++++
 fs/ext2/super.c  | 62 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/ext2/xattr.c  |  2 ++
 10 files changed, 124 insertions(+), 12 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index adf0f31fbddd..5ac73a4b4584 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -1232,6 +1232,11 @@ ext2_fsblk_t ext2_new_blocks(struct inode *inode, ext2_fsblk_t goal,
 	*errp = -ENOSPC;
 	sb = inode->i_sb;
 
+	if (ext2_emergency_ro(sb)) {
+		*errp = -EROFS;
+		return 0;
+	}
+
 	/*
 	 * Check quota for allocation of this block.
 	 */
diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index e17bbc7598c1..2d35cfb9c929 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -445,6 +445,9 @@ static int ext2_handle_dirsync(struct inode *dir)
 	err = filemap_write_and_wait(dir->i_mapping);
 	if (!err)
 		err = sync_inode_metadata(dir, 1);
+	/* The change is done, an error made us read-only in the meantime. */
+	if (err == -EROFS && ext2_emergency_ro(dir->i_sb))
+		err = 0;
 	return err;
 }
 
@@ -734,6 +737,6 @@ const struct file_operations ext2_dir_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
-	.fsync		= simple_fsync,
+	.fsync		= ext2_fsync,
 	.setlease	= generic_setlease,
 };
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 5642451bf191..80ddb2e43eea 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -83,6 +83,7 @@ struct ext2_sb_info {
 	struct ext2_super_block * s_es;	/* Pointer to the super block in the buffer */
 	struct buffer_head ** s_group_desc;
 	unsigned long  s_mount_opt;
+	unsigned long s_ext2_flags;	/* EXT2_FLAGS_* runtime state */
 	unsigned long s_sb_block;
 	kuid_t s_resuid;
 	kgid_t s_resgid;
@@ -356,6 +357,18 @@ struct ext2_inode {
 #define	EXT2_VALID_FS			0x0001	/* Unmounted cleanly */
 #define	EXT2_ERROR_FS			0x0002	/* Errors detected */
 
+/*
+ * Runtime state bits in ext2_sb_info->s_ext2_flags
+ */
+enum {
+	EXT2_FLAGS_EMERGENCY_RO,	/* read-only after an error */
+};
+
+static inline bool ext2_emergency_ro(struct super_block *sb)
+{
+	return test_bit(EXT2_FLAGS_EMERGENCY_RO, &EXT2_SB(sb)->s_ext2_flags);
+}
+
 /*
  * Mount flags
  */
@@ -775,6 +788,7 @@ extern const struct file_operations ext2_dir_operations;
 /* file.c */
 extern const struct inode_operations ext2_file_inode_operations;
 extern const struct file_operations ext2_file_operations;
+extern int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 
 /* inode.c */
 extern void ext2_set_file_ops(struct inode *inode);
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index b9020df7d89e..68fb892e3735 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -175,14 +175,28 @@ static ssize_t ext2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 static ssize_t ext2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
+	if (ext2_emergency_ro(file_inode(iocb->ki_filp)->i_sb))
+		return -EROFS;
+
 	if (iocb->ki_flags & IOCB_DIRECT)
 		return ext2_dio_write_iter(iocb, from);
 
 	return generic_file_write_iter(iocb, from);
 }
 
+/* Inodes aren't written back after an error, don't claim they're on disk. */
+int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	if (ext2_emergency_ro(file_inode(file)->i_sb))
+		return -EROFS;
+	return simple_fsync(file, start, end, datasync);
+}
+
 static int ext2_file_open(struct inode *inode, struct file *filp)
 {
+	if ((filp->f_mode & FMODE_WRITE) && ext2_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	filp->f_mode |= FMODE_CAN_ODIRECT;
 	return dquot_file_open(inode, filp);
 }
@@ -198,7 +212,7 @@ const struct file_operations ext2_file_operations = {
 	.mmap_prepare	= generic_file_mmap_prepare,
 	.open		= ext2_file_open,
 	.release	= ext2_release_file,
-	.fsync		= simple_fsync,
+	.fsync		= ext2_fsync,
 	.get_unmapped_area = thp_get_unmapped_area,
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index bf21b57cf98c..679e27f7b2d5 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -433,6 +433,8 @@ struct inode *ext2_new_inode(struct inode *dir, umode_t mode,
 	int err;
 
 	sb = dir->i_sb;
+	if (ext2_emergency_ro(sb))
+		return ERR_PTR(-EROFS);
 	inode = new_inode(sb);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index a9245f0cda4d..d5ddace75f63 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -71,7 +71,9 @@ void ext2_evict_inode(struct inode * inode)
 	struct ext2_block_alloc_info *rsv;
 	int want_delete = 0;
 
-	if (!inode->i_nlink && !is_bad_inode(inode)) {
+	/* After an error made us read-only the inode is left to e2fsck. */
+	if (!inode->i_nlink && !is_bad_inode(inode) &&
+	    !ext2_emergency_ro(inode->i_sb)) {
 		want_delete = 1;
 		dquot_initialize(inode);
 	} else {
@@ -1474,10 +1476,14 @@ int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
 	uid_t uid = i_uid_read(inode);
 	gid_t gid = i_gid_read(inode);
 	struct buffer_head * bh;
-	struct ext2_inode * raw_inode = ext2_get_inode(sb, ino, &bh);
+	struct ext2_inode *raw_inode;
 	int n;
 	int err = 0;
 
+	if (ext2_emergency_ro(sb))
+		return -EROFS;
+
+	raw_inode = ext2_get_inode(sb, ino, &bh);
 	if (IS_ERR(raw_inode))
  		return -EIO;
 
@@ -1623,6 +1629,9 @@ int ext2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	int error;
 
+	if (ext2_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	error = setattr_prepare(&nop_mnt_idmap, dentry, iattr);
 	if (error)
 		return error;
diff --git a/fs/ext2/ioctl.c b/fs/ext2/ioctl.c
index c3fea55b8efa..386f0f4432d2 100644
--- a/fs/ext2/ioctl.c
+++ b/fs/ext2/ioctl.c
@@ -33,6 +33,9 @@ int ext2_fileattr_set(struct mnt_idmap *idmap,
 	struct inode *inode = d_inode(dentry);
 	struct ext2_inode_info *ei = EXT2_I(inode);
 
+	if (ext2_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	if (fileattr_has_fsx(fa))
 		return -EOPNOTSUPP;
 
@@ -71,6 +74,10 @@ long ext2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		ret = mnt_want_write_file(filp);
 		if (ret)
 			return ret;
+		if (ext2_emergency_ro(inode->i_sb)) {
+			ret = -EROFS;
+			goto setversion_out;
+		}
 		if (get_user(generation, (int __user *) arg)) {
 			ret = -EFAULT;
 			goto setversion_out;
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 8666233ec63b..4b51589e167f 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -205,6 +205,10 @@ static int ext2_link (struct dentry * old_dentry, struct inode * dir,
 	struct inode *inode = d_inode(old_dentry);
 	int err;
 
+	/* Refuse before touching the link count and ctime of the inode. */
+	if (ext2_emergency_ro(dir->i_sb))
+		return -EROFS;
+
 	err = dquot_initialize(dir);
 	if (err)
 		return err;
@@ -275,6 +279,9 @@ static int ext2_unlink(struct inode *dir, struct dentry *dentry)
 	struct folio *folio;
 	int err;
 
+	if (ext2_emergency_ro(dir->i_sb))
+		return -EROFS;
+
 	err = dquot_initialize(dir);
 	if (err)
 		goto out;
@@ -333,6 +340,9 @@ static int ext2_rename (struct mnt_idmap * idmap,
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
 
+	if (ext2_emergency_ro(old_dir->i_sb))
+		return -EROFS;
+
 	err = dquot_initialize(old_dir);
 	if (err)
 		return err;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index a40f530872a4..d893fd6f7012 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -53,7 +53,7 @@ void ext2_error(struct super_block *sb, const char *function,
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	struct ext2_super_block *es = sbi->s_es;
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly(sb) && !ext2_emergency_ro(sb)) {
 		spin_lock(&sbi->s_lock);
 		sbi->s_mount_state |= EXT2_ERROR_FS;
 		es->s_state |= cpu_to_le16(EXT2_ERROR_FS);
@@ -73,11 +73,15 @@ void ext2_error(struct super_block *sb, const char *function,
 
 	if (test_opt(sb, ERRORS_PANIC))
 		panic("EXT2-fs: panic from previous error\n");
-	if (!sb_rdonly(sb) && test_opt(sb, ERRORS_RO)) {
+	/*
+	 * Don't set SB_RDONLY, that needs sb->s_umount and a remount. Flipping
+	 * it on a frozen filesystem makes thaw leave s_writers locked forever.
+	 * EXT2_FLAGS_EMERGENCY_RO makes ext2 refuse modifications instead.
+	 */
+	if (!sb_rdonly(sb) && test_opt(sb, ERRORS_RO) &&
+	    !test_and_set_bit(EXT2_FLAGS_EMERGENCY_RO, &sbi->s_ext2_flags))
 		ext2_msg(sb, KERN_CRIT,
 			     "error: remounting filesystem read-only");
-		sb->s_flags |= SB_RDONLY;
-	}
 }
 
 static void ext2_msg_fc(struct fs_context *fc, const char *prefix,
@@ -178,7 +182,7 @@ static void ext2_put_super (struct super_block * sb)
 	ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
 	sbi->s_ea_block_cache = NULL;
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly(sb) && !ext2_emergency_ro(sb)) {
 		struct ext2_super_block *es = sbi->s_es;
 
 		spin_lock(&sbi->s_lock);
@@ -298,6 +302,8 @@ static int ext2_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, ",errors=continue");
 	if (test_opt(sb, ERRORS_PANIC))
 		seq_puts(seq, ",errors=panic");
+	if (ext2_emergency_ro(sb))
+		seq_puts(seq, ",emergency_ro");
 	if (test_opt(sb, NO_UID32))
 		seq_puts(seq, ",nouid32");
 	if (test_opt(sb, DEBUG))
@@ -346,14 +352,30 @@ static struct dquot __rcu **ext2_get_dquots(struct inode *inode)
 	return EXT2_I(inode)->i_dquot;
 }
 
+/* After an error quota changes can't be written anymore. */
+static int ext2_set_dqinfo(struct super_block *sb, int type, struct qc_info *ii)
+{
+	if (ext2_emergency_ro(sb))
+		return -EROFS;
+	return dquot_set_dqinfo(sb, type, ii);
+}
+
+static int ext2_set_dqblk(struct super_block *sb, struct kqid qid,
+			  struct qc_dqblk *di)
+{
+	if (ext2_emergency_ro(sb))
+		return -EROFS;
+	return dquot_set_dqblk(sb, qid, di);
+}
+
 static const struct quotactl_ops ext2_quotactl_ops = {
 	.quota_on	= ext2_quota_on,
 	.quota_off	= ext2_quota_off,
 	.quota_sync	= dquot_quota_sync,
 	.get_state	= dquot_get_state,
-	.set_info	= dquot_set_dqinfo,
+	.set_info	= ext2_set_dqinfo,
 	.get_dqblk	= dquot_get_dqblk,
-	.set_dqblk	= dquot_set_dqblk,
+	.set_dqblk	= ext2_set_dqblk,
 	.get_nextdqblk	= dquot_get_next_dqblk,
 };
 #endif
@@ -1282,6 +1304,10 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
 
+	/* Nothing may be written after an error made us read-only. */
+	if (ext2_emergency_ro(sb))
+		return 0;
+
 	/*
 	 * Write quota structures to quota file, sync_blockdev() will write
 	 * them to disk later
@@ -1302,6 +1328,9 @@ static int ext2_freeze(struct super_block *sb)
 {
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 
+	if (ext2_emergency_ro(sb))
+		return 0;
+
 	/*
 	 * Open but unlinked files present? Keep EXT2_VALID_FS flag cleared
 	 * because we have unattached inodes and thus filesystem is not fully
@@ -1344,7 +1373,9 @@ static int ext2_reconfigure(struct fs_context *fc)
 	int flags = fc->sb_flags;
 	int err;
 
-	sync_filesystem(sb);
+	/* Nothing may be written after an error made us read-only. */
+	if (!ext2_emergency_ro(sb))
+		sync_filesystem(sb);
 
 	new_opts.s_mount_opt = ctx->vals_s_mount_opt;
 	new_opts.s_resuid = ctx->s_resuid;
@@ -1355,6 +1386,9 @@ static int ext2_reconfigure(struct fs_context *fc)
 	if ((bool)(flags & SB_RDONLY) == sb_rdonly(sb))
 		goto out_set;
 	if (flags & SB_RDONLY) {
+		/* After an error nothing may be written, just go read-only. */
+		if (ext2_emergency_ro(sb))
+			goto out_set;
 		if (le16_to_cpu(es->s_state) & EXT2_VALID_FS ||
 		    !(sbi->s_mount_state & EXT2_VALID_FS))
 			goto out_set;
@@ -1375,6 +1409,12 @@ static int ext2_reconfigure(struct fs_context *fc)
 	} else {
 		__le32 ret = EXT2_HAS_RO_COMPAT_FEATURE(sb,
 					       ~EXT2_FEATURE_RO_COMPAT_SUPP);
+
+		/* An error made the filesystem read-only until umount. */
+		if (ext2_emergency_ro(sb)) {
+			spin_unlock(&sbi->s_lock);
+			return -EROFS;
+		}
 		if (ret) {
 			spin_unlock(&sbi->s_lock);
 			ext2_msg(sb, KERN_WARNING,
@@ -1540,6 +1580,9 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
 	struct buffer_head tmp_bh;
 	struct buffer_head *bh;
 
+	if (ext2_emergency_ro(sb))
+		return -EROFS;
+
 	while (towrite > 0) {
 		tocopy = min_t(size_t, sb->s_blocksize - offset, towrite);
 
@@ -1585,6 +1628,9 @@ static int ext2_quota_on(struct super_block *sb, int type, int format_id,
 	int err;
 	struct inode *inode;
 
+	if (ext2_emergency_ro(sb))
+		return -EROFS;
+
 	err = dquot_quota_on(sb, type, format_id, path);
 	if (err)
 		return err;
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 9b68c490ab26..b3c84e5054a4 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -429,6 +429,8 @@ ext2_xattr_set(struct inode *inode, int name_index, const char *name,
 	ea_idebug(inode, "name=%d.%s, value=%p, value_len=%ld",
 		  name_index, name, value, (long)value_len);
 
+	if (ext2_emergency_ro(sb))
+		return -EROFS;
 	if (value == NULL)
 		value_len = 0;
 	if (name == NULL)

-- 
2.53.0

