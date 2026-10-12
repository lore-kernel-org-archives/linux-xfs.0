Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF41D4519A6;
	Mon, 12 Oct 2026 10:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800545; cv=none; b=Dyx4nUutFV3cgta+AtUWJQCiIcZFM1hsIWPPmcYH4UeJvqqSUzeIgQpMYYZJePMyiIOu04N92mmkZqaQlwOj1734qrKmgzYFxPmfxifdwOEQIbV71sA6H49ToanAfQSAECPmv9YF+tkbRSP26qiMTjSlDAqR6xGyyX3yvoMQBH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800545; c=relaxed/simple;
	bh=3dX7JQUhz+2uCP72KoInu90B1u/eYxYjBnyUPuSxVmM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JevIyl8gJIlcoYN2t53s7mfPl/Z+09uGYVX6RBZGuakS6oo6+bqhUuQsdP/yoX61g8fqVoGcm7TCDDz6UfI8tNdC/RL0+b8TGiUo1eJgGXB+SgoKGn1izos5/t+jb3YKGh6zL7J2zzTPVvUc31hjwL8YpUgq8TCCBzt97TrrDys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KozTg57Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KozTg57Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6779C1F0089B;
	Mon, 12 Oct 2026 10:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800527;
	bh=R8MtnDEhaLaFQWMfm22wLVmTlisY6RqGmKdB5q9YCW4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KozTg57YUv8uNSducV+7VtX4AfGJlE1AxyeX0JUrGy9TG1Qlls+wFY2VYedDt+FRU
	 dcKbNF/ejY0xSaOwBjmacrOeIgDbUoK8F5hNx8XMBB4JJYgAytZfqy+RSEwO8ELAIB
	 OeNLwcAkyJaAr/yMsaQTqzMLJowTbJvma0aP4W829lrtdTPqlmchYiewxyx9PyDuua
	 +iOhgQxDOKplZYq/PxxDV6UwgmP+653MBUday1kP5yvwyluNHW4UHgBRzs4LfRS8er
	 TFxgWMcteHhSizR7+x21I/+44i+Yr8PNZUjoPbNtD8JTjA47OetafSNQvKf/z7dcEY
	 0bP1xi075HMKg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:20:58 +0200
Subject: [PATCH RFC 13/28] hpfs: don't set SB_RDONLY after filesystem
 errors
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-13-60743a3dc326@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=14135; i=brauner@kernel.org;
 h=from:subject:message-id; bh=3dX7JQUhz+2uCP72KoInu90B1u/eYxYjBnyUPuSxVmM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TK5YE0i+2MDXtu+tSH701s++ZsdCchrV9x8z6uz6
 fgGLTfFjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlM1mZk6EqpLT/HZvi95nW5
 75ZZYXYn/D90e24+8o9FasljdpeG9wz/vWfUH/+abP/oWOqSiw9Nvnx/xsrO+dRO/eSOpcKMXTk
 mnAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

With errors=remount-ro, the hpfs default, hpfs_error() sets SB_RDONLY
on the first error. That happens without holding sb->s_umount, also
while the filesystem is frozen.

freeze_super() and thaw_super() both look at sb_rdonly() to figure out
whether the s_writers rwsems need to be taken or released. So after an
error on a frozen filesystem thaw_super() skips ->unfreeze_fs() and
sb_freeze_unlock() and the rwsems stay write-locked. Writers block
forever in sb_start_write() and umount warns in rcu_sync_dtor().

hpfs has no ->freeze_fs() and is only frozen through bdev_freeze(), e.g.
when device mapper suspends the device with lockfs. That holds new I/O
as well. But hpfs metadata lives in the block device page cache so a bad
fnode or dnode is still found from the cache:

  hpfs: filesystem error: bad magic on fnode 00000031; remounting read-only
  WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0x143/0x190, CPU#1: kworker/1:1/31
  WARNING: kernel/rcu/sync.c:180 at rcu_sync_dtor+0x14c/0x190
  WARNING: kernel/rcu/sync.c:188 at rcu_sync_dtor+0x13d/0x190

and with a create instead of the umount:

  [<0>] percpu_rwsem_wait+0x203/0x500
  [<0>] mnt_want_write+0x28f/0x2f0
  INFO: task s5_dm:129 blocked for more than 30 seconds.

This is deterministic with chkdsk=no. With the default chkdsk=errors
hpfs_error() first writes the spare block synchronously, which waits for
the resume and then races with the thaw.

hpfs_error() is also called from hpfs_fill_super(), e.g. for a volume
that wasn't cleanly unmounted. Setting SB_RDONLY there is fine because
the mounter holds s_umount and the superblock can't be frozen before
SB_BORN. So keep doing that during mount. Such mounts stay read-only and
can be remounted read-write as before.

At runtime follow what ext4 did in commit d3476f3dad4a ("ext4: don't
set SB_RDONLY after filesystem errors") and record the error in a new
HPFS_STATE_EMERGENCY_RO bit instead. It gets its own word because the
existing sb_* bitfields all share one. hpfs then refuses modifications
with -EROFS itself, in the namespace operations, setattr on files and
directories, a new ->open() for opening for write and a new
hpfs_file_write_iter(). FITRIM doesn't trim based on possibly bad
bitmaps anymore. And unmark_dirty() does nothing in that state just like
it did for the flipped superblock. So the spare block stays dirty and
the next mount reports the volume as improperly stopped.

Symlinks and device, fifo and socket inodes still use simple_setattr().
Changing their attributes succeeds in memory but nothing writes it out.
That's no different from a healthy hpfs though. It has no ->write_inode
and only writes inodes from its own setattr, truncate and release paths
and those inodes don't go through any of them.

There are two places that relax their checks on a read-only superblock.
hpfs_map_dnode() accepts over-long dirents and hpfs_lookup() tolerates
HPFS386 ACL and XPERM entries. Both treat the emergency state like
read-only so lookups behave as they did after the old flip.

A remount to read-write fails with -EROFS until umount while so far
"mount -o remount,rw" made the filesystem writable again after an error.
A remount to read-only is allowed and doesn't write the spare block.
Otherwise emergency remount (sysrq u) would WARN.

Like ext4 we show "emergency_ro" in the mount options. The mount stays
"rw" so statfs() doesn't report ST_RDONLY anymore and access(W_OK)
succeeds. Writes through file descriptors that were opened before the
error now fail with -EROFS where they used to succeed. A second
read-only mount of the device fails with -EBUSY and a non-forced remount
to read-only fails with -EBUSY while files are still open for writing.

Reproducer. There's no mkfs for hpfs in Linux userspace. hpfs.img is an
empty 8 MiB HPFS image (superblock, spare block, bitmaps, directory
band, root fnode and dnode):

  dev=$(losetup -f --show hpfs.img)
  dmsetup create hpfs --table "0 $(blockdev --getsz $dev) linear $dev 0"
  mount -t hpfs /dev/mapper/hpfs /mnt && mkdir /mnt/d
  ino=$(stat -c %i /mnt/d) && umount /mnt
  dd if=/dev/zero of=/dev/mapper/hpfs bs=512 seek=$ino count=1 conv=notrunc
  mount -t hpfs -o errors=remount-ro,chkdsk=no /dev/mapper/hpfs /mnt
  dd if=/dev/mapper/hpfs of=/dev/null bs=1M   # cache the fnode of "d"
  dmsetup suspend hpfs
  stat /mnt/d             # bad magic on fnode -> hpfs_error() -> SB_RDONLY
  dmsetup resume hpfs
  touch /mnt/x            # hangs
  # instead of touch: umount /mnt -> WARNING in rcu_sync_dtor()

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/hpfs/alloc.c   |  4 ++--
 fs/hpfs/dir.c     |  3 ++-
 fs/hpfs/file.c    | 17 ++++++++++++++++-
 fs/hpfs/hpfs_fn.h |  9 +++++++++
 fs/hpfs/inode.c   |  2 ++
 fs/hpfs/map.c     |  3 ++-
 fs/hpfs/namei.c   | 14 ++++++++++++++
 fs/hpfs/super.c   | 22 ++++++++++++++++++++--
 8 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/fs/hpfs/alloc.c b/fs/hpfs/alloc.c
index f5150372618e..061b34dfbd9f 100644
--- a/fs/hpfs/alloc.c
+++ b/fs/hpfs/alloc.c
@@ -539,7 +539,7 @@ int hpfs_trim_fs(struct super_block *s, u64 start, u64 end, u64 minlen, unsigned
 		return 0;
 	if (start < sbi->sb_dirband_start + sbi->sb_dirband_size && end > sbi->sb_dirband_start) {
 		hpfs_lock(s);
-		if (sb_rdonly(s)) {
+		if (sb_rdonly(s) || hpfs_emergency_ro(s)) {
 			err = -EROFS;
 			goto unlock_1;
 		}
@@ -560,7 +560,7 @@ int hpfs_trim_fs(struct super_block *s, u64 start, u64 end, u64 minlen, unsigned
 	end_bmp = (end + 0x3fff) >> 14;
 	while (start_bmp < end_bmp && !err) {
 		hpfs_lock(s);
-		if (sb_rdonly(s)) {
+		if (sb_rdonly(s) || hpfs_emergency_ro(s)) {
 			err = -EROFS;
 			goto unlock_2;
 		}
diff --git a/fs/hpfs/dir.c b/fs/hpfs/dir.c
index 3bf11202e2d3..be5d09545667 100644
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -265,7 +265,8 @@ struct dentry *hpfs_lookup(struct inode *dir, struct dentry *dentry, unsigned in
 	hpfs_result = hpfs_i(result);
 	if (!de->directory) hpfs_result->i_parent_dir = dir->i_ino;
 
-	if (de->has_acl || de->has_xtd_perm) if (!sb_rdonly(dir->i_sb)) {
+	if ((de->has_acl || de->has_xtd_perm) &&
+	    !sb_rdonly(dir->i_sb) && !hpfs_emergency_ro(dir->i_sb)) {
 		hpfs_error(result->i_sb, "ACLs or XPERM found. This is probably HPFS386. This driver doesn't support it now. Send me some info on these structures");
 		iput(result);
 		result = ERR_PTR(-EINVAL);
diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index 6a629ab956fc..0332cf74dbe3 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -256,12 +256,27 @@ const struct address_space_operations hpfs_aops = {
 	.migrate_folio = buffer_migrate_folio,
 };
 
+static ssize_t hpfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	if (hpfs_emergency_ro(file_inode(iocb->ki_filp)->i_sb))
+		return -EROFS;
+	return generic_file_write_iter(iocb, from);
+}
+
+static int hpfs_file_open(struct inode *inode, struct file *filp)
+{
+	if ((filp->f_mode & FMODE_WRITE) && hpfs_emergency_ro(inode->i_sb))
+		return -EROFS;
+	return 0;
+}
+
 const struct file_operations hpfs_file_ops =
 {
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
-	.write_iter	= generic_file_write_iter,
+	.write_iter	= hpfs_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
+	.open		= hpfs_file_open,
 	.release	= hpfs_file_release,
 	.fsync		= hpfs_file_fsync,
 	.splice_read	= filemap_splice_read,
diff --git a/fs/hpfs/hpfs_fn.h b/fs/hpfs/hpfs_fn.h
index 237c1c23e855..9358a5b2e029 100644
--- a/fs/hpfs/hpfs_fn.h
+++ b/fs/hpfs/hpfs_fn.h
@@ -80,6 +80,7 @@ struct hpfs_sb_info {
 	unsigned sb_lowercase : 1;	/* downcase filenames hackery */
 	unsigned sb_was_error : 1;	/* there was an error, set dirty flag */
 	unsigned sb_chkdsk : 2;		/* chkdsk: 0-no, 1-on errs, 2-allways */
+	unsigned long sb_state;		/* HPFS_STATE_* bits */
 	unsigned char *sb_cp_table;	/* code page tables: */
 					/* 	128 bytes uppercasing table & */
 					/*	128 bytes lowercasing table */
@@ -94,6 +95,9 @@ struct hpfs_sb_info {
 	secno hotfix_to[256];
 };
 
+/* bits in hpfs_sb_info->sb_state */
+#define HPFS_STATE_EMERGENCY_RO	0	/* refuse modifications after an error */
+
 /* Four 512-byte buffers and the 2k block obtained by concatenating them */
 
 struct quad_buffer_head {
@@ -322,6 +326,11 @@ static inline struct hpfs_sb_info *hpfs_sb(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
+static inline bool hpfs_emergency_ro(struct super_block *sb)
+{
+	return test_bit(HPFS_STATE_EMERGENCY_RO, &hpfs_sb(sb)->sb_state);
+}
+
 /* super.c */
 
 __printf(2, 3)
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index 1b4fcf760aad..e18cf16d6625 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -263,6 +263,8 @@ int hpfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	int error = -EINVAL;
 
+	if (hpfs_emergency_ro(inode->i_sb))
+		return -EROFS;
 	hpfs_lock(inode->i_sb);
 	if (inode->i_ino == hpfs_sb(inode->i_sb)->sb_root)
 		goto out_unlock;
diff --git a/fs/hpfs/map.c b/fs/hpfs/map.c
index be73233502f8..69c3d003daf0 100644
--- a/fs/hpfs/map.c
+++ b/fs/hpfs/map.c
@@ -288,7 +288,8 @@ struct dnode *hpfs_map_dnode(struct super_block *s, unsigned secno,
 					goto bail;
 				}
 				if (((31 + de->namelen + de->down*4 + 3) & ~3) != le16_to_cpu(de->length)) {
-					if (((31 + de->namelen + de->down*4 + 3) & ~3) < le16_to_cpu(de->length) && s->s_flags & SB_RDONLY) goto ok;
+					if (((31 + de->namelen + de->down*4 + 3) & ~3) < le16_to_cpu(de->length) &&
+					    (sb_rdonly(s) || hpfs_emergency_ro(s))) goto ok;
 					hpfs_error(s, "namelen does not match dirent size in dnode %08x, dirent %03x, last %03x", secno, p, pp);
 					goto bail;
 				}
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index 9446f4038874..307a178aba18 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -35,6 +35,8 @@ static struct dentry *hpfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	int r;
 	struct hpfs_dirent dee;
 	int err;
+	if (hpfs_emergency_ro(dir->i_sb))
+		return ERR_PTR(-EROFS);
 	if ((err = hpfs_chk_name(name, &len))) return ERR_PTR(err==-ENOENT ? -EINVAL : err);
 	hpfs_lock(dir->i_sb);
 	err = -ENOSPC;
@@ -140,6 +142,8 @@ static int hpfs_create(struct mnt_idmap *idmap, struct inode *dir,
 	int r;
 	struct hpfs_dirent dee;
 	int err;
+	if (hpfs_emergency_ro(dir->i_sb))
+		return -EROFS;
 	if ((err = hpfs_chk_name(name, &len)))
 		return err==-ENOENT ? -EINVAL : err;
 	hpfs_lock(dir->i_sb);
@@ -227,6 +231,8 @@ static int hpfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	struct hpfs_dirent dee;
 	struct inode *result = NULL;
 	int err;
+	if (hpfs_emergency_ro(dir->i_sb))
+		return -EROFS;
 	if ((err = hpfs_chk_name(name, &len))) return err==-ENOENT ? -EINVAL : err;
 	if (hpfs_sb(dir->i_sb)->sb_eas < 2) return -EPERM;
 	hpfs_lock(dir->i_sb);
@@ -301,6 +307,8 @@ static int hpfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	struct hpfs_dirent dee;
 	struct inode *result;
 	int err;
+	if (hpfs_emergency_ro(dir->i_sb))
+		return -EROFS;
 	if ((err = hpfs_chk_name(name, &len))) return err==-ENOENT ? -EINVAL : err;
 	hpfs_lock(dir->i_sb);
 	if (hpfs_sb(dir->i_sb)->sb_eas < 2) {
@@ -380,6 +388,8 @@ static int hpfs_unlink(struct inode *dir, struct dentry *dentry)
 	int r;
 	int err;
 
+	if (hpfs_emergency_ro(dir->i_sb))
+		return -EROFS;
 	hpfs_lock(dir->i_sb);
 	hpfs_adjust_length(name, &len);
 
@@ -432,6 +442,8 @@ static int hpfs_rmdir(struct inode *dir, struct dentry *dentry)
 	int err;
 	int r;
 
+	if (hpfs_emergency_ro(dir->i_sb))
+		return -EROFS;
 	hpfs_adjust_length(name, &len);
 	hpfs_lock(dir->i_sb);
 	err = -ENOENT;
@@ -522,6 +534,8 @@ static int hpfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
 
+	if (hpfs_emergency_ro(old_dir->i_sb))
+		return -EROFS;
 	if ((err = hpfs_chk_name(new_name, &new_len))) return err;
 	err = 0;
 	hpfs_adjust_length(old_name, &old_len);
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 8fbdbf080627..cff963cabbb6 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -44,7 +44,7 @@ static void unmark_dirty(struct super_block *s)
 {
 	struct buffer_head *bh;
 	struct hpfs_spare_block *sb;
-	if (sb_rdonly(s)) return;
+	if (sb_rdonly(s) || hpfs_emergency_ro(s)) return;
 	sync_blockdev(s->s_bdev);
 	if ((sb = hpfs_map_sector(s, 17, &bh, 0))) {
 		sb->dirty = hpfs_sb(s)->sb_chkdsk > 1 - hpfs_sb(s)->sb_was_error;
@@ -81,7 +81,18 @@ void hpfs_error(struct super_block *s, const char *fmt, ...)
 			else {
 				pr_cont("; remounting read-only\n");
 				mark_dirty(s, 0);
-				s->s_flags |= SB_RDONLY;
+				/*
+				 * Only a mount in progress may still set
+				 * SB_RDONLY: later that needs s->s_umount,
+				 * and on a frozen superblock it makes
+				 * thaw_super() leave s_writers locked.
+				 * Refuse modifications until umount instead.
+				 */
+				if (s->s_flags & SB_BORN)
+					set_bit(HPFS_STATE_EMERGENCY_RO,
+						&hpfs_sb(s)->sb_state);
+				else
+					s->s_flags |= SB_RDONLY;
 			}
 		} else if (sb_rdonly(s))
 				pr_cont("; going on - but anything won't be destroyed because it's read-only\n");
@@ -426,6 +437,11 @@ static int hpfs_reconfigure(struct fs_context *fc)
 	struct super_block *s = fc->root->d_sb;
 	struct hpfs_sb_info *sbi = hpfs_sb(s);
 
+	/* After an error, refuse going back to read-write until umount. */
+	if (hpfs_emergency_ro(s) && sb_rdonly(s) &&
+	    !(fc->sb_flags & SB_RDONLY))
+		return -EROFS;
+
 	sync_filesystem(s);
 
 	fc->sb_flags |= SB_NOATIME;
@@ -483,6 +499,8 @@ static int hpfs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_printf(seq, ",eas=ro");
 	if (sbi->sb_timeshift)
 		seq_printf(seq, ",timeshift=%d", sbi->sb_timeshift);
+	if (hpfs_emergency_ro(root->d_sb))
+		seq_puts(seq, ",emergency_ro");
 	return 0;
 }
 

-- 
2.53.0

