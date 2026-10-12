Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5F1418368;
	Mon, 12 Oct 2026 10:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800539; cv=none; b=TrO9n32WTCXCyg7iofnZHnYTF02NBU2IK3SLE7CMJ27lWHfVb8/JnEsFa3C8gJsCdybCLYnMZgFczjPYNO9ZGo2ATpXorxu8FB2vAuN+dwr0APQXOSuZy0+qVWFLr/96EOnWtsUCZZNX8E+1XboorFuqsOGtYSiz8IB5NDhZhTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800539; c=relaxed/simple;
	bh=7F30BdnFg2n+QREpjRLrVSAQwS+P/nkRsprz6DuTciQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SmoJ9izu4zeedhm3QWQa/KYsaEG40Fxsrw7NTmmu3GABRg3yoyPWnRI4sNuteO3QeF9ndkQnB7XgOWYnj/Ir9/sQn6PDkFwGgGl98pbfI5uo4vD//xujxNDmxY8WrdBKEVvYrdFElzho0SMwEgf57ecUNKSz5j2eljPp9qzrjFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MlmhlCfg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MlmhlCfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C67E1F008A3;
	Mon, 12 Oct 2026 10:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800523;
	bh=O2aGyAbmrrElaF7oKe9fP8zJgSX7Wv1MDggwAQBW2SA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MlmhlCfg50PPkHeBCVsiqT2i9OXwhvhWY5Xn8COSJLkjgvWyLuYQo2nX+BL862R2H
	 02mk51lgOxL1hsl25TldiNktSy7AyH8Puxqrp68f7x0HnFbYB0D1/4DoXyqn6BiI4E
	 nC0YKdGbzqETB9nhynmV5JPFVZxxisiYCXgBA+UoiqO1UGDwppk/w+LJy9ztpbQVF6
	 9gogdu5cYH/XPwnHdn/UsRR4gUCgLV83NwZAjhjT8BbqTUvNgizHGssDJJ3BT5Wqqn
	 k115sLemF2pXk1x8JwHk8OHBus+j+aQV/n9ucuM9q+SpCyoS8TrcxvhqWX2d31bEgW
	 oawbJlWhBMV+A==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:20:57 +0200
Subject: [PATCH RFC 12/28] ufs: don't set SB_RDONLY after filesystem errors
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-12-60743a3dc326@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=19763; i=brauner@kernel.org;
 h=from:subject:message-id; bh=7F30BdnFg2n+QREpjRLrVSAQwS+P/nkRsprz6DuTciQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TK55/y7RXvFDbeppkl533n4O1Rd/dqarmMzdwt3d
 T923nL0dEcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEauIY/srsbe5zm6/37Frk
 dzOmz/P3XVS4Ev1vcmRv3Aru+Qq7y48y/OF8r3GQhWdTuPvl5erHmep9f/B4XkrPcJj2aX2+1fF
 +M0YA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ufs_error() sets SB_RDONLY on every error, whatever onerror= says, and
ufs_panic() sets it as well. Both do that without holding
sb->s_umount.

freeze_super() and thaw_super() both look at sb_rdonly() to figure out
whether the s_writers rwsems need to be taken or released. So an error
while the filesystem is frozen makes thaw_super() skip ->unfreeze_fs()
and sb_freeze_unlock() and leaves all three rwsems write-locked on a
superblock that is marked unfrozen. Writers hang in sb_start_write()
forever and umount warns in rcu_sync_dtor().

ufs has no ->freeze_fs() and can only be frozen through bdev_freeze(),
e.g. by a device mapper suspend with lockfs which holds new I/O as well.
But a directory folio that was read without being checked, by readahead
or fadvise, is checked by ufs_check_folio() on the next readdir or
lookup and that works fine while the device is suspended:

  ufs: error (device dm-0): ufs_check_folio: bad entry in directory #3: inode out of bounds - offset=24, rec_len=488, name_len=6
  ufs: error (device dm-0): ufs_readdir: bad page in #3
  WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0x143/0x190, CPU#3: kworker/3:1/54
  WARNING: kernel/rcu/sync.c:180 at rcu_sync_dtor+0x14c/0x190
  WARNING: kernel/rcu/sync.c:188 at rcu_sync_dtor+0x13d/0x190

and with a create instead of the umount:

  [<0>] percpu_rwsem_wait+0x203/0x500
  [<0>] mnt_want_write+0x28f/0x2f0
  INFO: task touch:122 blocked for more than 30 seconds.

The flip also leaked memory. ufs_put_super() skips
ufs_put_super_internal() for a read-only superblock so after an error
the in-core cylinder group info was never freed and its buffer heads
were never released. And a remount to read-write after the flip read it
in again over the old copy.

Follow what ext4 did in commit d3476f3dad4a ("ext4: don't set SB_RDONLY
after filesystem errors") and record the error in a new
UFS_STATE_EMERGENCY_RO bit instead. ufs_error() and ufs_panic() still
mark the superblock UFS_FSBAD and dirty its buffer which goes out with
the block device. Their ufs_mark_sb_dirty() calls are gone because all
they did was queue ufs_sync_fs() which returns early now.

ufs then refuses modifications with -EROFS itself, in the namespace
operations, setattr and a new ufs_file_write_iter(). Directories get
ufs_setattr() so attribute changes on them are refused too. For
directories it does what simple_setattr() did for them before. Symlinks
and device, fifo and socket inodes still use simple_setattr(). Changing
their attributes succeeds in memory but nothing writes it out anymore.
The superblock is left alone and ufs_put_cylinder() doesn't store the
allocation rotors.

ufs_write_inode() refuses as well. Note that writeback clears the dirty
state of an inode before it calls ->write_inode() and doesn't redirty it
when that fails. So fsync() would happily report success for an inode
that never made it to disk. Let fsync() fail with -EROFS instead. Like
on ext4 an operation that completed shortly before the error can end up
half-applied on disk and needs fsck.

Every directory change ends in ufs_handle_dirsync() which writes the
directory inode. If another task hits an error after an operation got
past its check that write fails with -EROFS although the directory entry
was already changed. So treat -EROFS as success there once the bit is
set, like ext2 does.

A remount to read-write fails with -EROFS until umount while so far
"mount -o remount,rw" made the filesystem writable again after an error.
A remount to read-only is allowed and leaves the superblock alone.
Otherwise emergency remount (sysrq u) would WARN. onerror= can still be
changed.

The remount to read-only keeps the cylinder group info in that state
though. Evicting an inode that was unlinked while it was still open goes
through ufs_free_inode() and ufs_free_blocks() which load cylinder
groups. And a forced remount to read-only, i.e. sysrq u, goes through
while such inodes exist and now reaches errored filesystems as well. So
freeing the info there would be a use-after-free. Note that a healthy
ufs already has that problem with sysrq u. Instead umount frees the info
without writing the summary and the cylinder group totals back.

Like ext4 we show "emergency_ro" in the mount options. The mount stays
"rw" so statfs() doesn't report ST_RDONLY anymore and access(W_OK)
succeeds. Writes through file descriptors that were opened before the
error now fail with -EROFS where they used to succeed. A second
read-only mount of the device fails with -EBUSY and a non-forced remount
to read-only fails with -EBUSY while files are still open for writing.

Reproducer:

  # UFS1 image (NetBSD makefs), "victim"'s directory entry gets an
  # out-of-range inode number (d_ino is 8 bytes before the name)
  mkdir -p t/d && echo x > t/d/victim && makefs -t ffs -s 8m ufs.img t
  off=$(grep -obUa victim ufs.img | cut -d: -f1)
  printf '\377\377\377\177' | dd of=ufs.img bs=1 seek=$((off - 8)) conv=notrunc
  dev=$(losetup -f --show ufs.img)
  dmsetup create ufs --table "0 $(blockdev --getsz $dev) linear $dev 0"
  mount -t ufs -o ufstype=44bsd /dev/mapper/ufs /mnt
  # read the directory page without ufs_check_folio()
  python3 -c 'import os; fd = os.open("/mnt/d", os.O_RDONLY); os.posix_fadvise(fd, 0, 0, os.POSIX_FADV_WILLNEED)'
  dmsetup suspend ufs
  ls /mnt/d               # ufs_check_folio(): inode out of bounds -> ufs_error()
  dmsetup resume ufs
  touch /mnt/x            # hangs
  # instead of touch: umount /mnt -> WARNING in rcu_sync_dtor()

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ufs/cylinder.c | 12 +++++----
 fs/ufs/dir.c      |  5 +++-
 fs/ufs/file.c     | 28 ++++++++++++++++++---
 fs/ufs/inode.c    |  5 ++++
 fs/ufs/namei.c    | 22 +++++++++++++++++
 fs/ufs/super.c    | 74 ++++++++++++++++++++++++++++++++++++++++++-------------
 fs/ufs/ufs.h      | 10 ++++++++
 7 files changed, 130 insertions(+), 26 deletions(-)

diff --git a/fs/ufs/cylinder.c b/fs/ufs/cylinder.c
index b930ee1cf853..12ffd67fd206 100644
--- a/fs/ufs/cylinder.c
+++ b/fs/ufs/cylinder.c
@@ -117,12 +117,14 @@ void ufs_put_cylinder (struct super_block * sb, unsigned bitmap_nr)
 	}
 	/*
 	 * rotor is not so important data, so we put it to disk 
-	 * at the end of working with cylinder
+	 * at the end of working with cylinder, but not after an error
 	 */
-	ucg->cg_rotor = cpu_to_fs32(sb, ucpi->c_rotor);
-	ucg->cg_frotor = cpu_to_fs32(sb, ucpi->c_frotor);
-	ucg->cg_irotor = cpu_to_fs32(sb, ucpi->c_irotor);
-	ubh_mark_buffer_dirty (UCPI_UBH(ucpi));
+	if (!ufs_emergency_ro(sb)) {
+		ucg->cg_rotor = cpu_to_fs32(sb, ucpi->c_rotor);
+		ucg->cg_frotor = cpu_to_fs32(sb, ucpi->c_frotor);
+		ucg->cg_irotor = cpu_to_fs32(sb, ucpi->c_irotor);
+		ubh_mark_buffer_dirty (UCPI_UBH(ucpi));
+	}
 	for (i = 1; i < UCPI_UBH(ucpi)->count; i++) {
 		brelse (UCPI_UBH(ucpi)->bh[i]);
 	}
diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index ce43cf20b07c..a8bc96f1d364 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -64,6 +64,9 @@ static int ufs_handle_dirsync(struct inode *dir)
 	err = filemap_write_and_wait(dir->i_mapping);
 	if (!err)
 		err = sync_inode_metadata(dir, 1);
+	/* The change is done, an error made us read-only in the meantime. */
+	if (err == -EROFS && ufs_emergency_ro(dir->i_sb))
+		err = 0;
 	return err;
 }
 
@@ -652,7 +655,7 @@ const struct file_operations ufs_dir_operations = {
 	.release	= ufs_dir_release,
 	.read		= generic_read_dir,
 	.iterate_shared	= ufs_readdir,
-	.fsync		= simple_fsync,
+	.fsync		= ufs_fsync,
 	.llseek		= ufs_dir_llseek,
 	.setlease	= generic_setlease,
 };
diff --git a/fs/ufs/file.c b/fs/ufs/file.c
index 85c509ced7f9..f60f9dafe477 100644
--- a/fs/ufs/file.c
+++ b/fs/ufs/file.c
@@ -30,6 +30,28 @@
 #include "ufs_fs.h"
 #include "ufs.h"
 
+static ssize_t ufs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	if (ufs_emergency_ro(file_inode(iocb->ki_filp)->i_sb))
+		return -EROFS;
+	return generic_file_write_iter(iocb, from);
+}
+
+/* Inodes aren't written back after an error, don't claim they're on disk. */
+int ufs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	if (ufs_emergency_ro(file_inode(file)->i_sb))
+		return -EROFS;
+	return simple_fsync(file, start, end, datasync);
+}
+
+static int ufs_file_open(struct inode *inode, struct file *filp)
+{
+	if ((filp->f_mode & FMODE_WRITE) && ufs_emergency_ro(inode->i_sb))
+		return -EROFS;
+	return generic_file_open(inode, filp);
+}
+
 /*
  * We have mostly NULL's here: the current defaults are ok for
  * the ufs filesystem.
@@ -38,10 +60,10 @@
 const struct file_operations ufs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
-	.write_iter	= generic_file_write_iter,
+	.write_iter	= ufs_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
-	.open           = generic_file_open,
-	.fsync		= simple_fsync,
+	.open           = ufs_file_open,
+	.fsync		= ufs_fsync,
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.setlease	= generic_setlease,
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 440d014cc5ed..9ecf2f95644b 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -828,6 +828,8 @@ static int ufs_update_inode(struct inode * inode, int do_sync)
 
 int ufs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
+	if (ufs_emergency_ro(inode->i_sb))
+		return -EROFS;
 	return ufs_update_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
 }
 
@@ -1202,6 +1204,9 @@ int ufs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	unsigned int ia_valid = attr->ia_valid;
 	int error;
 
+	if (ufs_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	error = setattr_prepare(&nop_mnt_idmap, dentry, attr);
 	if (error)
 		return error;
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index 6703f3bcf76f..70241893b21c 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -74,6 +74,9 @@ static int ufs_create (struct mnt_idmap * idmap,
 {
 	struct inode *inode;
 
+	if (ufs_emergency_ro(dir->i_sb))
+		return -EROFS;
+
 	inode = ufs_new_inode(dir, mode);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
@@ -91,6 +94,8 @@ static int ufs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	struct inode *inode;
 	int err;
 
+	if (ufs_emergency_ro(dir->i_sb))
+		return -EROFS;
 	if (!old_valid_dev(rdev))
 		return -EINVAL;
 
@@ -113,6 +118,8 @@ static int ufs_symlink (struct mnt_idmap * idmap, struct inode * dir,
 	unsigned l = strlen(symname)+1;
 	struct inode * inode;
 
+	if (ufs_emergency_ro(sb))
+		return -EROFS;
 	if (l > sb->s_blocksize)
 		return -ENAMETOOLONG;
 
@@ -152,6 +159,9 @@ static int ufs_link (struct dentry * old_dentry, struct inode * dir,
 	struct inode *inode = d_inode(old_dentry);
 	int error;
 
+	if (ufs_emergency_ro(dir->i_sb))
+		return -EROFS;
+
 	inode_set_ctime_current(inode);
 	inode_inc_link_count(inode);
 	ihold(inode);
@@ -171,6 +181,9 @@ static struct dentry *ufs_mkdir(struct mnt_idmap * idmap, struct inode * dir,
 	struct inode * inode;
 	int err;
 
+	if (ufs_emergency_ro(dir->i_sb))
+		return ERR_PTR(-EROFS);
+
 	inode_inc_link_count(dir);
 
 	inode = ufs_new_inode(dir, mode);
@@ -211,6 +224,9 @@ static int ufs_unlink(struct inode *dir, struct dentry *dentry)
 	struct folio *folio;
 	int err;
 
+	if (ufs_emergency_ro(dir->i_sb))
+		return -EROFS;
+
 	de = ufs_find_entry(dir, &dentry->d_name, &folio);
 	if (!de)
 		return -ENOENT;
@@ -229,6 +245,8 @@ static int ufs_rmdir (struct inode * dir, struct dentry *dentry)
 	struct inode * inode = d_inode(dentry);
 	int err= -ENOTEMPTY;
 
+	if (ufs_emergency_ro(dir->i_sb))
+		return -EROFS;
 	if (ufs_empty_dir (inode)) {
 		err = ufs_unlink(dir, dentry);
 		if (!err) {
@@ -255,6 +273,9 @@ static int ufs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
 
+	if (ufs_emergency_ro(old_dir->i_sb))
+		return -EROFS;
+
 	old_de = ufs_find_entry(old_dir, &old_dentry->d_name, &old_folio);
 	if (!old_de)
 		return -ENOENT;
@@ -326,4 +347,5 @@ const struct inode_operations ufs_dir_inode_operations = {
 	.rmdir		= ufs_rmdir,
 	.mknod		= ufs_mknod,
 	.rename		= ufs_rename,
+	.setattr	= ufs_setattr,
 };
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 3569ac92b065..ba2dd4502869 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -280,11 +280,17 @@ void ufs_error (struct super_block * sb, const char * function,
 	uspi = UFS_SB(sb)->s_uspi;
 	usb1 = ubh_get_usb_first(uspi);
 	
-	if (!sb_rdonly(sb)) {
+	/*
+	 * Don't set SB_RDONLY: that requires sb->s_umount and a proper
+	 * remount. Set while the superblock is frozen it makes thaw_super()
+	 * skip releasing s_writers and every later writer hangs. Refuse
+	 * modifications until umount instead.
+	 * The superblock buffer marked bad goes out with the block device.
+	 */
+	if (!sb_rdonly(sb) &&
+	    !test_and_set_bit(UFS_STATE_EMERGENCY_RO, &UFS_SB(sb)->s_state)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		ufs_mark_sb_dirty(sb);
-		sb->s_flags |= SB_RDONLY;
 	}
 	va_start(args, fmt);
 	vaf.fmt = fmt;
@@ -314,15 +320,15 @@ void ufs_panic (struct super_block * sb, const char * function,
 	uspi = UFS_SB(sb)->s_uspi;
 	usb1 = ubh_get_usb_first(uspi);
 	
-	if (!sb_rdonly(sb)) {
+	/* See ufs_error(). */
+	if (!sb_rdonly(sb) &&
+	    !test_and_set_bit(UFS_STATE_EMERGENCY_RO, &UFS_SB(sb)->s_state)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		ufs_mark_sb_dirty(sb);
 	}
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	sb->s_flags |= SB_RDONLY;
 	pr_crit("panic (device %s): %s: %pV\n",
 		sb->s_id, function, &vaf);
 	va_end(args);
@@ -512,11 +518,13 @@ static int ufs_read_cylinder_structures(struct super_block *sb)
 
 failed:
 	kfree (base);
+	sbi->s_csp = NULL;
 	if (sbi->s_ucg) {
 		for (i = 0; i < uspi->s_ncg; i++)
 			if (sbi->s_ucg[i])
 				brelse (sbi->s_ucg[i]);
 		kfree (sbi->s_ucg);
+		sbi->s_ucg = NULL;
 		for (i = 0; i < UFS_MAX_GROUP_LOADED; i++)
 			kfree (sbi->s_ucpi[i]);
 	}
@@ -579,7 +587,8 @@ static void ufs_put_cstotal(struct super_block *sb)
  * ufs_put_super_internal() - put on-disk intrenal structures
  * @sb: pointer to super_block structure
  * Put on-disk structures associated with cylinder groups
- * and write them back to disk, also update cs_total on disk
+ * and write them back to disk, also update cs_total on disk.
+ * Nothing is written back after an error.
  */
 static void ufs_put_super_internal(struct super_block *sb)
 {
@@ -591,10 +600,14 @@ static void ufs_put_super_internal(struct super_block *sb)
 	
 	UFSD("ENTER\n");
 
+	base = space = (char*) sbi->s_csp;
+	/* Don't write anything back after an error, see ufs_error(). */
+	if (ufs_emergency_ro(sb))
+		goto release;
+
 	ufs_put_cstotal(sb);
 	size = uspi->s_cssize;
 	blks = (size + uspi->s_fsize - 1) >> uspi->s_fshift;
-	base = space = (char*) sbi->s_csp;
 	for (i = 0; i < blks; i++, space += uspi->s_fsize) {
 		struct buffer_head *bh = sb_bread(sb, uspi->s_csaddr + i);
 
@@ -607,6 +620,7 @@ static void ufs_put_super_internal(struct super_block *sb)
 		mark_buffer_dirty(bh);
 		brelse(bh);
 	}
+release:
 	for (i = 0; i < sbi->s_cg_loaded; i++) {
 		ufs_put_cylinder (sb, i);
 		kfree (sbi->s_ucpi[i]);
@@ -616,7 +630,9 @@ static void ufs_put_super_internal(struct super_block *sb)
 	for (i = 0; i < uspi->s_ncg; i++) 
 		brelse (sbi->s_ucg[i]);
 	kfree (sbi->s_ucg);
+	sbi->s_ucg = NULL;
 	kfree (base);
+	sbi->s_csp = NULL;
 
 	UFSD("EXIT\n");
 }
@@ -628,6 +644,10 @@ static int ufs_sync_fs(struct super_block *sb, int wait)
 	struct ufs_super_block_third * usb3;
 	unsigned flags;
 
+	/* Leave the superblock alone after an error, see ufs_error(). */
+	if (ufs_emergency_ro(sb))
+		return 0;
+
 	mutex_lock(&UFS_SB(sb)->s_lock);
 
 	UFSD("ENTER\n");
@@ -684,7 +704,12 @@ static void ufs_put_super(struct super_block *sb)
 
 	UFSD("ENTER\n");
 
-	if (!sb_rdonly(sb))
+	/*
+	 * Read-write mounts load the cylinder groups. A remount to read-only
+	 * frees them unless it happened in the emergency state. The bit can
+	 * also get set after such a remount freed them.
+	 */
+	if (sbi->s_ucg)
 		ufs_put_super_internal(sb);
 	cancel_delayed_work_sync(&sbi->sync_work);
 
@@ -1260,19 +1285,31 @@ static int ufs_reconfigure(struct fs_context *fc)
 		mutex_unlock(&UFS_SB(sb)->s_lock);
 		return 0;
 	}
+
+	/* After an error, refuse going back to read-write until umount. */
+	if (ufs_emergency_ro(sb) && !(fc->sb_flags & SB_RDONLY)) {
+		mutex_unlock(&UFS_SB(sb)->s_lock);
+		return -EROFS;
+	}
 	
 	/*
 	 * fs was mouted as rw, remounting ro
 	 */
 	if (fc->sb_flags & SB_RDONLY) {
-		ufs_put_super_internal(sb);
-		usb1->fs_time = ufs_get_seconds(sb);
-		if ((flags & UFS_ST_MASK) == UFS_ST_SUN
-		  || (flags & UFS_ST_MASK) == UFS_ST_SUNOS
-		  || (flags & UFS_ST_MASK) == UFS_ST_SUNx86) 
-			ufs_set_fs_state(sb, usb1, usb3,
-				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
-		ubh_mark_buffer_dirty (USPI_UBH(uspi));
+		/*
+		 * After an error leave the superblock alone, see ufs_error(),
+		 * and keep the cylinder groups: evict still uses them.
+		 */
+		if (!ufs_emergency_ro(sb)) {
+			ufs_put_super_internal(sb);
+			usb1->fs_time = ufs_get_seconds(sb);
+			if ((flags & UFS_ST_MASK) == UFS_ST_SUN
+			  || (flags & UFS_ST_MASK) == UFS_ST_SUNOS
+			  || (flags & UFS_ST_MASK) == UFS_ST_SUNx86)
+				ufs_set_fs_state(sb, usb1, usb3,
+					UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
+			ubh_mark_buffer_dirty (USPI_UBH(uspi));
+		}
 		sb->s_flags |= SB_RDONLY;
 	} else {
 	/*
@@ -1322,6 +1359,9 @@ static int ufs_show_options(struct seq_file *seq, struct dentry *root)
 		++tp;
 	seq_printf(seq, ",onerror=%s", tp->name);
 
+	if (ufs_emergency_ro(root->d_sb))
+		seq_puts(seq, ",emergency_ro");
+
 	return 0;
 }
 
diff --git a/fs/ufs/ufs.h b/fs/ufs/ufs.h
index 788e025056b2..012e26de1417 100644
--- a/fs/ufs/ufs.h
+++ b/fs/ufs/ufs.h
@@ -26,6 +26,7 @@ struct ufs_sb_info {
 	unsigned short s_cg_loaded;
 	unsigned s_flavour;
 	unsigned s_on_err;
+	unsigned long s_state;	/* UFS_STATE_* bits */
 	struct super_block *sb;
 	int work_queued; /* non-zero if the delayed work is queued */
 	struct delayed_work sync_work; /* FS sync delayed work */
@@ -52,6 +53,9 @@ struct ufs_inode_info {
 	struct inode vfs_inode;
 };
 
+/* bits in ufs_sb_info->s_state */
+#define UFS_STATE_EMERGENCY_RO	0	/* refuse modifications after an error */
+
 /* mount options */
 #define UFS_MOUNT_ONERROR_PANIC		0x00000001
 #define UFS_MOUNT_ONERROR_LOCK		0x00000002
@@ -109,6 +113,7 @@ int ufs_set_link(struct inode *dir, struct ufs_dir_entry *de,
 /* file.c */
 extern const struct inode_operations ufs_file_inode_operations;
 extern const struct file_operations ufs_file_operations;
+extern int ufs_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 extern const struct address_space_operations ufs_aops;
 
 /* ialloc.c */
@@ -140,6 +145,11 @@ static inline struct ufs_sb_info *UFS_SB(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
+static inline bool ufs_emergency_ro(struct super_block *sb)
+{
+	return test_bit(UFS_STATE_EMERGENCY_RO, &UFS_SB(sb)->s_state);
+}
+
 static inline struct ufs_inode_info *UFS_I(struct inode *inode)
 {
 	return container_of(inode, struct ufs_inode_info, vfs_inode);

-- 
2.53.0

