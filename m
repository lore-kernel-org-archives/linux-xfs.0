Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8214447D45A;
	Mon, 12 Oct 2026 10:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800584; cv=none; b=Swxhcs6X5Plib764pnQ0LFDOXiwc86ocD9dHiONyEveREKQWjV8z8UwAEbaFh5Suux4hVQwvdYyg9qSNMGOvznuQc+5m4PWkdhL/xEL0idpg/R+YMyaH4tBsA5UII1rgwyDMCfM7VvWe9I4P1RvHpm3GBkCwqVdSQ2tZBGIYdk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800584; c=relaxed/simple;
	bh=NsovZOdvlFs8owkMYtEseNRnXFAJ/0Ec36qCfykAhe4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IzS2TE/4l7cXrkKI/liCzt1XSuVX0oaEyTa1werecdsL4D4zTsI8JgzdXcNWvwEkkFPeSFrWoGDEvjjjg3qdanNujMcCSMYpSPbKOUKCzeSog4pwKnGZo1pxBiejTd/QKrRn8Wr+RT46EQ8L1D0zUChOOj+8s7+QhnFGIywjqSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MN1XQBaZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MN1XQBaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358671F0089C;
	Mon, 12 Oct 2026 10:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800568;
	bh=KVYkaLLUhiMDzrS2BxLbzlY1DTidnIauylG8rzJQMmQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MN1XQBaZvMtQfMIA+dEBWMZ85hjFS0nIw4nf+sgcKkzhsqhjVTnKJbwBv02AjZ8Tt
	 3nmKYQIZrDl1Zo1bcv5FtqK8cHHUkbBZk9dV6zKuy5uZzg6fapUDFImJ8HgyR03sMp
	 ZTI9k/HpbatOPH6t0AFSjyslRTlZBGTveenjCPH8rJian3TjYNRW+QaHiChnVl5pMp
	 cWvEdGNQ+duf6kXwWZZ/cH3hVHL7qbPbZgI2N8ez/TfuADpTRBccQPeP8/efGPq7gg
	 sWzcSszCydeTfPiQNL1f618FwAWDs5ITWDs8nWDnSfwxf3LWPfJdQEYCLONXoc/0Ti
	 Br6+o5+kIHaiQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:21:08 +0200
Subject: [PATCH RFC 23/28] ubifs: don't set SB_RDONLY after errors
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-23-60743a3dc326@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9209; i=brauner@kernel.org;
 h=from:subject:message-id; bh=NsovZOdvlFs8owkMYtEseNRnXFAJ/0Ec36qCfykAhe4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TJFX2672fIHBqGKx6yWMNzo+bu/W+u6hGNd0C3WW
 TPdj66u7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIzIcM/2znOGw45Jfvtm+J
 iuiSFzyVW5gezDPJ+HB+8e9NHx/sXneckeHjizinP0tVpqc5z7psE6yoYbVVZ8LkfxL2PrWrOA3
 mbWMFAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

When UBIFS hits an error ubifs_ro_mode() switches it to read-only mode
by setting c->ro_error and SB_RDONLY. It does that from whatever context
found the error, e.g. a failing write to the media, and without holding
sb->s_umount. So it races with everyone else who writes sb->s_flags,
reconfigure_super() included. UBIFS can't be frozen so it doesn't leave
writers hanging after a thaw like the other filesystems did. But it's
still a filesystem changing SB_RDONLY behind the VFS' back.

UBIFS doesn't need it either. c->ro_error already makes every write to
the media fail with -EROFS. So only set SB_RDONLY while the filesystem
is still being mounted, where the mounter holds s_umount, and let UBIFS
refuse what the VFS refused for us so far. A new ubifs_permission() does
what sb_permission() did for the read-only superblock and refuses
MAY_WRITE on regular files, directories and symlinks. That takes care
of the namespace operations, opening for write and truncate(2).
setattr, fileattr_set, timestamp updates and the xattr setters check
c->ro_error as well because they change the inode in memory before
anything is written.

So far a remount to read-only after an error was refused with -EROFS.
That didn't matter because the superblock was read-only already. And a
remount to read-write went through and cleared SB_RDONLY again because
c->ro_mount was never set. Now the remount to read-only is what makes
the superblock read-only so let it through. The writes
ubifs_remount_ro() does fail with -EROFS before doing any I/O. After
that the existing check refuses going back to read-write.

ubifs_fsync() returns 0 right away on a read-only mount. With the
remount to read-only going through after an error that would make
fsync() report success for data that writeback dropped. And
ubifs_write_inode() drops the dirty state of an inode when writing it
fails so fsync() could already report success for an inode update that
never made it to the media. Let fsync() fail with -EROFS after an error
like ext4 does.

Like ext4 we show "emergency_ro" in the mount options while c->ro_error
is set. The mount stays "rw" until a remount to read-only so statfs()
doesn't report ST_RDONLY anymore and syncfs(2) now fails with -EROFS.

Reproducer, with UBI on mtdram:

  modprobe mtdram total_size=32768 erase_size=128
  ubiattach -m 0; ubimkvol /dev/ubi0 -N test -m
  mount -t ubifs ubi0:test /mnt
  echo 1 > /sys/kernel/debug/ubifs/ubi0_0/tst_recovery   # emulate a power cut
  while echo x >> /mnt/f; do sync; done   # until the power cut hits
  grep /mnt /proc/mounts       # before: ro, after: rw,...,emergency_ro
  mount -o remount,ro /mnt     # before: EROFS, after: works
  mount -o remount,rw /mnt     # before: works, after: EROFS

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ubifs/dir.c   |  1 +
 fs/ubifs/file.c  | 24 ++++++++++++++++++++++++
 fs/ubifs/io.c    |  7 ++++++-
 fs/ubifs/ioctl.c |  4 ++++
 fs/ubifs/super.c |  8 ++++----
 fs/ubifs/ubifs.h |  1 +
 fs/ubifs/xattr.c |  6 ++++++
 7 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 23ec924162d6..af01e674eb1b 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1749,6 +1749,7 @@ const struct inode_operations ubifs_dir_inode_operations = {
 	.rmdir       = ubifs_rmdir,
 	.mknod       = ubifs_mknod,
 	.rename      = ubifs_rename,
+	.permission  = ubifs_permission,
 	.setattr     = ubifs_setattr,
 	.getattr     = ubifs_getattr,
 	.listxattr   = ubifs_listxattr,
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index e73c28b12f97..20ff354185b7 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1251,6 +1251,18 @@ static int do_setattr(struct ubifs_info *c, struct inode *inode,
 	return err;
 }
 
+/* Like sb_permission() for a read-only superblock, see ubifs_ro_mode(). */
+int ubifs_permission(struct mnt_idmap *idmap, struct inode *inode, int mask)
+{
+	struct ubifs_info *c = inode->i_sb->s_fs_info;
+
+	if ((mask & MAY_WRITE) && c->ro_error &&
+	    (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+	     S_ISLNK(inode->i_mode)))
+		return -EROFS;
+	return generic_permission(idmap, inode, mask);
+}
+
 int ubifs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		  struct iattr *attr)
 {
@@ -1260,6 +1272,9 @@ int ubifs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 
 	dbg_gen("ino %llu, mode %#x, ia_valid %#x",
 		inode->i_ino, inode->i_mode, attr->ia_valid);
+	if (c->ro_error)
+		return -EROFS;
+
 	err = setattr_prepare(&nop_mnt_idmap, dentry, attr);
 	if (err)
 		return err;
@@ -1310,6 +1325,10 @@ int ubifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 
 	dbg_gen("syncing inode %llu", inode->i_ino);
 
+	/* Writeback drops what it can't write after an error. */
+	if (c->ro_error)
+		return -EROFS;
+
 	if (c->ro_mount)
 		/*
 		 * For some really strange reasons VFS does not filter out
@@ -1374,6 +1393,9 @@ int ubifs_update_time(struct inode *inode, enum fs_update_time type,
 	if (WARN_ON_ONCE(type != FS_UPD_ATIME))
 		return -EIO;
 
+	if (c->ro_error)
+		return -EROFS;
+
 	if (!IS_ENABLED(CONFIG_UBIFS_ATIME_SUPPORT))
 		return generic_update_time(inode, type, flags);
 
@@ -1634,6 +1656,7 @@ const struct address_space_operations ubifs_file_address_operations = {
 };
 
 const struct inode_operations ubifs_file_inode_operations = {
+	.permission  = ubifs_permission,
 	.setattr     = ubifs_setattr,
 	.getattr     = ubifs_getattr,
 	.listxattr   = ubifs_listxattr,
@@ -1644,6 +1667,7 @@ const struct inode_operations ubifs_file_inode_operations = {
 
 const struct inode_operations ubifs_symlink_inode_operations = {
 	.get_link    = ubifs_get_link,
+	.permission  = ubifs_permission,
 	.setattr     = ubifs_setattr,
 	.getattr     = ubifs_symlink_getattr,
 	.listxattr   = ubifs_listxattr,
diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index 6c6d68242779..3d01529a0754 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -72,7 +72,12 @@ void ubifs_ro_mode(struct ubifs_info *c, int err)
 	if (!c->ro_error) {
 		c->ro_error = 1;
 		c->no_chk_data_crc = 0;
-		c->vfs_sb->s_flags |= SB_RDONLY;
+		/*
+		 * Only a mount in progress may set SB_RDONLY, later that needs
+		 * s_umount. UBIFS refuses modifications itself afterwards.
+		 */
+		if (!(c->vfs_sb->s_flags & SB_BORN))
+			c->vfs_sb->s_flags |= SB_RDONLY;
 		ubifs_warn(c, "switched to read-only mode, error %d", err);
 		dump_stack();
 	}
diff --git a/fs/ubifs/ioctl.c b/fs/ubifs/ioctl.c
index 79536b2e3d7a..79cba6750b20 100644
--- a/fs/ubifs/ioctl.c
+++ b/fs/ubifs/ioctl.c
@@ -148,11 +148,15 @@ int ubifs_fileattr_set(struct mnt_idmap *idmap,
 		       struct dentry *dentry, struct file_kattr *fa)
 {
 	struct inode *inode = d_inode(dentry);
+	struct ubifs_info *c = inode->i_sb->s_fs_info;
 	int flags = fa->flags;
 
 	if (d_is_special(dentry))
 		return -ENOTTY;
 
+	if (c->ro_error)
+		return -EROFS;
+
 	if (fileattr_has_fsx(fa))
 		return -EOPNOTSUPP;
 
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 38972786817e..aaaab72e3678 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -454,6 +454,9 @@ static int ubifs_show_options(struct seq_file *s, struct dentry *root)
 			   ubifs_compr_name(c, c->mount_opts.compr_type));
 	}
 
+	if (c->ro_error)
+		seq_puts(s, ",emergency_ro");
+
 	seq_printf(s, ",assert=%s", ubifs_assert_action_name(c));
 	seq_printf(s, ",ubi=%d,vol=%d", c->vi.ubi_num, c->vi.vol_id);
 
@@ -1977,10 +1980,7 @@ static int ubifs_reconfigure(struct fs_context *fc)
 		if (err)
 			return err;
 	} else if (!c->ro_mount && (fc->sb_flags & SB_RDONLY)) {
-		if (c->ro_error) {
-			ubifs_msg(c, "cannot re-mount R/O due to prior errors");
-			return -EROFS;
-		}
+		/* After an error ubifs_remount_ro() can't write but still works. */
 		ubifs_remount_ro(c);
 	}
 
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 00db0d19a85e..687352c16932 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -2020,6 +2020,7 @@ int ubifs_calc_dark(const struct ubifs_info *c, int spc);
 
 /* file.c */
 int ubifs_fsync(struct file *file, loff_t start, loff_t end, int datasync);
+int ubifs_permission(struct mnt_idmap *idmap, struct inode *inode, int mask);
 int ubifs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		  struct iattr *attr);
 int ubifs_update_time(struct inode *inode, enum fs_update_time type,
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index b5a9ab9d8a10..8516aab4d005 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -260,6 +260,9 @@ int ubifs_xattr_set(struct inode *host, const char *name, const void *value,
 	if (check_lock)
 		ubifs_assert(c, inode_is_locked(host));
 
+	if (c->ro_error)
+		return -EROFS;
+
 	if (size > UBIFS_MAX_INO_DATA)
 		return -ERANGE;
 
@@ -564,6 +567,9 @@ static int ubifs_xattr_remove(struct inode *host, const char *name)
 
 	ubifs_assert(c, inode_is_locked(host));
 
+	if (c->ro_error)
+		return -EROFS;
+
 	if (fname_len(&nm) > UBIFS_MAX_NLEN)
 		return -ENAMETOOLONG;
 

-- 
2.53.0

