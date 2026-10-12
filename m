Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6F14119F7;
	Mon, 12 Oct 2026 10:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800580; cv=none; b=qEsCqW12vR31Y4yR3WmxXLxgJHLKb4Oc9+w2vBpLndytxSBO9iV3hVFGlfjZmctllFpbxlbuZSAQ7Fq7G7Qn00D3pi492q0E9rSSngeJUzoGHSCzHxSvmnISkGiTA/BQpzRGi//4U3a0TdWsUE3l6b/hkpVy8Gy6hbxw2GcgqOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800580; c=relaxed/simple;
	bh=K7BxUtHzcGy2IpDNps7btvz8womQYnC4QIpoXEvLpxo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BIIi9KKkd4akBTRTAyn3CUyZKlSl0c02JeGKkoTubj1+ol/S+JwiY3i8Ndni1H8qvoH/BELDMemxo4BpLnBExBfZqhzltkaeWTE9aDxBTWEQo9vtT0vQpTZ6ZP0LFFmz8kd9wANLnTGX23C/gbzeZymX6RwFjO0IdAtaVSO9sdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MVMZnRqD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MVMZnRqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067761F0089D;
	Mon, 12 Oct 2026 10:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800564;
	bh=gqfvF8a36bR5GKh2wCGHdgbO3Y2aAKCzNA8Zyg1bWY0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MVMZnRqDc8Fm7sraL5WrRvDqPSOovrtN5JGegbQ+CbaMLgatMADR5C6pISj7faf4O
	 OjVeOIAHYweNfVIbTYOiW46FtkDfNml3S0xc1pJu/mbPOWClkNIMdWFK9ThoyUpbfM
	 StI2vfqVHM8Oo8mbmkMUuUpihCSKLuyVVjk9IlO9N2f9ZhtsfBsgOR70FLEip1TYF+
	 3Lq3cXozFdb5QOodrpxOX/LugyiiwihMee3wftoF0g8zx5Gp5O3re6sTbDJ08AC69C
	 pMF7mV5pubJRt2sFS3fAyjLK0XF7+8bH1F6gh0kGGM13YgSeu31DeQH2V33aMudxx3
	 TPhlFDjPd10lA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:21:07 +0200
Subject: [PATCH RFC 22/28] efivarfs: stop using SB_RDONLY for read-only
 efivar ops
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-22-60743a3dc326@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=11355; i=brauner@kernel.org;
 h=from:subject:message-id; bh=K7BxUtHzcGy2IpDNps7btvz8womQYnC4QIpoXEvLpxo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TIlNcY4kG9uudiLz2F3Je73LxaX2cTDHCPuwMo/k
 eFKxD/zjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlsLGBkON+w7prdRjXFXym6
 DF0ici2ilusvnH1x+oWCcfIP+74v7YwMqxecjgyWKGM2r84Mn1+tffvq3sUvGeo/b5h6u+KMA+9
 7XgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Since commit 94f7f6182c72 ("efivarfs: automatically update super block
flag") efivarfs_ops_notifier() sets or clears SB_RDONLY whenever the
efivar ops switch between ops that can and ops that can't set variables,
e.g. when tee_stmm_efi is probed or removed. The notifier runs from
efivars_register() under efivars_lock at any time and without holding
sb->s_umount.

freeze_super() and thaw_super() both look at sb_rdonly() to figure out
whether the s_writers rwsems need to be taken or released. efivarfs has
->freeze_fs() and ->unfreeze_fs() and is FS_POWER_FREEZE. So a backend
that loads or unloads around suspend and resume hits this without
anybody calling FIFREEZE. If the ops turn read-only while the filesystem
is frozen thaw_super() skips ->unfreeze_fs(), i.e. the variable resync,
and sb_freeze_unlock(). The rwsems stay write-locked, writers hang and
umount warns:

  efivars: Unregistered efivars operations
  efivars: Registered efivars operations
  WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0x143/0x190

  [<0>] percpu_rwsem_wait+0x203/0x500
  [<0>] mnt_want_write+0x28f/0x2f0
  [<0>] filename_unlinkat+0x19f/0x600

In the other direction a filesystem mounted with read-only ops is frozen
without the rwsems. If the ops turn read-write before the thaw
sb_freeze_unlock() releases rwsems nobody holds:

  efivarfs: resyncing variable state
  WARNING: kernel/rcu/sync.c:154 at rcu_sync_exit+0x147/0x1a0, CPU#0: fsfreeze/171
  WARNING: kernel/rcu/sync.c:157 at rcu_sync_exit+0x150/0x1a0, CPU#0: fsfreeze/171

And the unlocked read-modify-write of sb->s_flags also races with every
other writer of it.

So keep the state to efivarfs. efivarfs_fs_info gets a flags word with
EFIVARFS_OPS_RDONLY which the notifier sets and clears instead of
touching SB_RDONLY. efivarfs_fill_super() initializes it from
efivar_supports_writes() and doesn't set SB_RDONLY anymore either, which
it did since commit f88814cc2578 ("efi/efivars: Expose RT service
availability via efivars abstraction"). It samples the ops and registers
the notifier under efivar_lock() so a switch can't slip in between and
leave the flag stale until umount. create, unlink, setattr,
fileattr_set, write and opening for write are refused with -EROFS while
the flag is set. That includes setattr on the root directory.

That means everything is derived from the private state now, mount time
included. The notifier exists so that a mount made while the ops were
read-only becomes writable once tee_stmm_efi loads later. That's the
normal boot order because systemd mounts efivarfs before modules are
loaded. Setting SB_RDONLY in fill_super would leave such mounts
read-only until somebody remounts them. And all SB_RDONLY ever did here
was keep writes away from a NULL ->set_variable (cf.
commit 0e8d2444168d ("efivarfs: force RO when remounting if SetVariable
is not supported")). The private checks do that too, also for writes
through files opened before the ops turned read-only which SB_RDONLY
never stopped. Note that they run without efivars_lock just like the
SB_RDONLY check did. So a write that races with a switch to read-only
ops isn't stopped. That's not new.

efivarfs_reconfigure() now only refuses to remount a read-only mount
read-write while the flag is set, and with -EROFS instead of -EINVAL. It
used to refuse every remount without "ro" while the ops couldn't write.
That would refuse option-only remounts of the now read-write superblock
as well. The check uses the same condition as the VFS' own remount_rw
test so an fspick() reconfigure that doesn't touch the read-only flag
isn't mistaken for one.

We show "ro_ops" in the mount options while the flag is set. IOW, with
read-only ops efivarfs is now mounted "rw,...,ro_ops" instead of "ro".
statfs() doesn't report ST_RDONLY and access(W_OK) doesn't fail with
-EROFS anymore. Variables that efivarfs marks immutable fail with -EPERM
first when opened for write, unlinked or chmod'ed because the
IS_IMMUTABLE() check in the VFS comes before ->open() and ->unlink().
And mkdir and rename, which efivarfs doesn't support, fail with -EPERM
and setxattr with -EOPNOTSUPP instead of -EROFS.

Reproducer. This needs tee_stmm_efi, the only driver that switches
efivar ops while efivarfs can be mounted, or a module that does what it
does: efivars_generic_ops_unregister() and efivars_register() of ops
without ->set_variable, and back:

  mount -t efivarfs efivarfs /sys/firmware/efi/efivars    # read-write ops
  fsfreeze -f /sys/firmware/efi/efivars
  <switch to read-only ops>
  fsfreeze -u /sys/firmware/efi/efivars
  <switch back to read-write ops>
  rm /sys/firmware/efi/efivars/<var>    # before: hangs in percpu_rwsem_wait()
  umount /sys/firmware/efi/efivars      # before: WARNING at rcu_sync_dtor()

The other direction, mounted with read-only ops, frozen, switched to
read-write ops and thawed, warns in rcu_sync_exit() from the thaw.

Fixes: 94f7f6182c72 ("efivarfs: automatically update super block flag")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/efivarfs/file.c     |  6 ++++++
 fs/efivarfs/inode.c    | 15 +++++++++++++++
 fs/efivarfs/internal.h | 14 +++++++++++++-
 fs/efivarfs/super.c    | 31 +++++++++++++++++++++++--------
 4 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index cb1b6d0c3454..a074145fa57e 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -23,6 +23,9 @@ static ssize_t efivarfs_file_write(struct file *file,
 	ssize_t bytes;
 	bool set = false;
 
+	if (efivarfs_ops_rdonly(inode->i_sb))
+		return -EROFS;
+
 	if (count < sizeof(attributes))
 		return -EINVAL;
 
@@ -137,6 +140,9 @@ static int efivarfs_file_open(struct inode *inode, struct file *file)
 {
 	struct efivar_entry *entry = inode->i_private;
 
+	if ((file->f_mode & FMODE_WRITE) && efivarfs_ops_rdonly(inode->i_sb))
+		return -EROFS;
+
 	file->private_data = entry;
 
 	inode_lock(inode);
diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
index f0d009555fc6..6b0540139798 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -15,6 +15,8 @@
 #include "internal.h"
 
 static const struct inode_operations efivarfs_file_inode_operations;
+static int efivarfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
+			    struct iattr *iattr);
 
 struct inode *efivarfs_get_inode(struct super_block *sb,
 				const struct inode *dir, int mode,
@@ -83,6 +85,9 @@ static int efivarfs_create(struct mnt_idmap *idmap, struct inode *dir,
 	bool is_removable = false;
 	efi_guid_t vendor;
 
+	if (efivarfs_ops_rdonly(dir->i_sb))
+		return -EROFS;
+
 	if (!efivarfs_valid_name(dentry->d_name.name, dentry->d_name.len))
 		return -EINVAL;
 
@@ -122,6 +127,9 @@ static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct efivar_entry *var = d_inode(dentry)->i_private;
 
+	if (efivarfs_ops_rdonly(dir->i_sb))
+		return -EROFS;
+
 	if (efivar_entry_delete(var))
 		return -EINVAL;
 
@@ -132,6 +140,7 @@ const struct inode_operations efivarfs_dir_inode_operations = {
 	.lookup = simple_lookup,
 	.unlink = efivarfs_unlink,
 	.create = efivarfs_create,
+	.setattr = efivarfs_setattr,
 };
 
 static int
@@ -155,6 +164,9 @@ efivarfs_fileattr_set(struct mnt_idmap *idmap,
 {
 	unsigned int i_flags = 0;
 
+	if (efivarfs_ops_rdonly(dentry->d_sb))
+		return -EROFS;
+
 	if (fileattr_has_fsx(fa))
 		return -EOPNOTSUPP;
 
@@ -176,6 +188,9 @@ static int efivarfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	int error;
 
+	if (efivarfs_ops_rdonly(inode->i_sb))
+		return -EROFS;
+
 	error = setattr_prepare(idmap, dentry, iattr);
 	if (error)
 		return error;
diff --git a/fs/efivarfs/internal.h b/fs/efivarfs/internal.h
index f913b6824289..c2ca7a073b5d 100644
--- a/fs/efivarfs/internal.h
+++ b/fs/efivarfs/internal.h
@@ -15,10 +15,22 @@ struct efivarfs_mount_opts {
 
 struct efivarfs_fs_info {
 	struct efivarfs_mount_opts mount_opts;
-	struct super_block *sb;
 	struct notifier_block nb;
+	unsigned long flags;
 };
 
+/* efivarfs_fs_info->flags */
+enum {
+	EFIVARFS_OPS_RDONLY,	/* the registered efivar ops can't set variables */
+};
+
+static inline bool efivarfs_ops_rdonly(const struct super_block *sb)
+{
+	const struct efivarfs_fs_info *sfi = sb->s_fs_info;
+
+	return test_bit(EFIVARFS_OPS_RDONLY, &sfi->flags);
+}
+
 struct efi_variable {
 	efi_char16_t  VariableName[EFI_VAR_NAME_LEN/sizeof(efi_char16_t)];
 	efi_guid_t    VendorGuid;
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 8d33f11db2a1..d1ee6abb639f 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -28,12 +28,18 @@ static int efivarfs_ops_notifier(struct notifier_block *nb, unsigned long event,
 {
 	struct efivarfs_fs_info *sfi = container_of(nb, struct efivarfs_fs_info, nb);
 
+	/*
+	 * This runs at any time without sb->s_umount, so don't touch
+	 * SB_RDONLY. Changing it under freeze_super() and thaw_super() leaves
+	 * the freeze protection unbalanced. The modifying operations check
+	 * EFIVARFS_OPS_RDONLY instead.
+	 */
 	switch (event) {
 	case EFIVAR_OPS_RDONLY:
-		sfi->sb->s_flags |= SB_RDONLY;
+		set_bit(EFIVARFS_OPS_RDONLY, &sfi->flags);
 		break;
 	case EFIVAR_OPS_RDWR:
-		sfi->sb->s_flags &= ~SB_RDONLY;
+		clear_bit(EFIVARFS_OPS_RDONLY, &sfi->flags);
 		break;
 	default:
 		return NOTIFY_DONE;
@@ -74,6 +80,8 @@ static int efivarfs_show_options(struct seq_file *m, struct dentry *root)
 	if (!gid_eq(opts->gid, GLOBAL_ROOT_GID))
 		seq_printf(m, ",gid=%u",
 				from_kgid_munged(&init_user_ns, opts->gid));
+	if (efivarfs_ops_rdonly(sb))
+		seq_puts(m, ",ro_ops");
 	return 0;
 }
 
@@ -373,9 +381,6 @@ static int efivarfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_d_flags |= DCACHE_DONTCACHE;
 	sb->s_time_gran         = 1;
 
-	if (!efivar_supports_writes())
-		sb->s_flags |= SB_RDONLY;
-
 	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0, true);
 	if (!inode)
 		return -ENOMEM;
@@ -386,9 +391,15 @@ static int efivarfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (!root)
 		return -ENOMEM;
 
-	sfi->sb = sb;
+	/* The ops can't switch between sampling them and registering. */
+	err = efivar_lock();
+	if (err)
+		return err;
+	if (!efivar_supports_writes())
+		set_bit(EFIVARFS_OPS_RDONLY, &sfi->flags);
 	sfi->nb.notifier_call = efivarfs_ops_notifier;
 	err = blocking_notifier_chain_register(&efivar_ops_nh, &sfi->nb);
+	efivar_unlock();
 	if (err)
 		return err;
 
@@ -402,9 +413,13 @@ static int efivarfs_get_tree(struct fs_context *fc)
 
 static int efivarfs_reconfigure(struct fs_context *fc)
 {
-	if (!efivar_supports_writes() && !(fc->sb_flags & SB_RDONLY)) {
+	struct super_block *sb = fc->root->d_sb;
+
+	/* Only refuse remounting a read-only mount read-write. */
+	if ((fc->sb_flags_mask & SB_RDONLY) && !(fc->sb_flags & SB_RDONLY) &&
+	    sb_rdonly(sb) && efivarfs_ops_rdonly(sb)) {
 		pr_err("Firmware does not support SetVariableRT. Can not remount with rw\n");
-		return -EINVAL;
+		return -EROFS;
 	}
 
 	return 0;

-- 
2.53.0

