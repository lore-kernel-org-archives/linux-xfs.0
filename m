Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27400475333;
	Mon, 12 Oct 2026 10:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800560; cv=none; b=geBJya6hbgUCkEHKaUgI6Va8HoIXvO1FgYxMYKbcPnKbmeq5ozmWepfAkGKRBhhBDuvUg2zD93dQ2zI6VTgwLnbjS+6dO6n54fQQUbECH5G5FV6cwDWauPJqIMCBCxmaNJJ7Y1+bWoSFKkdp5xeoqhwSNMaOvGePgKkgUhez5fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800560; c=relaxed/simple;
	bh=8cupn7/EZREynB4Y9Hfo3FjJBbukyKDW4SYLCZDzvww=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i/4zEA8RdU367M69erYBQxGcMZQhotjt/5u2pGwKQ5xgsx/uuNd7tAlNY/t86fJaY49qYnUvEh3bLafwgvuIHjraZADXg64VDzzGi+i893+XT2xn2N8eZgXpodPniWJ8iwxgLXwqTE9UT5AOfIQsmFyzCabZOg8kw7UVu8VTlPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lCmLFXMM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lCmLFXMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9723C1F0089D;
	Mon, 12 Oct 2026 10:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800540;
	bh=vF6wD0Zll72uTa36p+tHaKIxSo7ysyawmX89JEVH29o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lCmLFXMM5ukkg/GXugz2KLIScCuFj+rFIkgTEm6ia1LAK7q7aSB+WoMZ0pxCxa+jT
	 fkAr8PakZEZhO8yCC3bBbkRpR8w42ACzv7gq+HkfEZl0kBTYx1VwPJpWHquj2l1mtx
	 RQAT0lBXjnQcphTuMivDyejRQChssz2GMhrXCrXRy7iuBABZDqN1MmG248XgdCq2Be
	 es9Q/YhAK/9OfsTyHh/URqK/AMY3OsLaOvnS1nkxJ36lOeoORIy3mIq2TJNH+H/pUZ
	 QJFJ9SWGz+tJ4fpPb1rHNZLD/Tl8zovq+YkaIpA4dc3oYl8BYEOYQKC31q1OVOPJQx
	 klmaHTllYLovw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:21:01 +0200
Subject: [PATCH RFC 16/28] ocfs2: don't set SB_RDONLY after filesystem
 errors
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-16-60743a3dc326@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=18166; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8cupn7/EZREynB4Y9Hfo3FjJBbukyKDW4SYLCZDzvww=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TJ5dfBm3Zw/T3oKxTgTL6UeuvjxzLeUu0/518n01
 1gfWBDu0lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARpnJGhoOHctMntuk9ec43
 5eXUBSKGf82Mlx6POXxm943VVlt9opsZ/tkIfGlXumowRa0/d/uPhPJT6ouSv0QuZdF2Cnjb8NB
 YkBEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

With errors=remount-ro, the default, ocfs2_handle_error() sets SB_RDONLY
on every ocfs2_error() and on local mounts also on ocfs2_abort(). It
does that without holding sb->s_umount.

freeze_super() and thaw_super() both look at sb_rdonly() to figure out
whether the s_writers rwsems need to be taken or released. So an error
while the filesystem is frozen leaves the rwsems write-locked after the
thaw. Writers hang in sb_start_write() and so does umount, forever,
because ocfs2_shutdown_local_alloc() starts a transaction and that needs
sb_start_intwrite():

  OCFS2: ERROR (device dm-0): ocfs2_get_clusters_nocache: Inode 5652 has bad extent record (0, 16, 0)
  OCFS2: File system is now read-only.

  [<0>] percpu_rwsem_wait+0x203/0x500
  [<0>] ocfs2_start_trans+0x580/0x700
  [<0>] ocfs2_shutdown_local_alloc+0x27d/0x800
  [<0>] ocfs2_dismount_volume+0x1ad/0x700
  [<0>] generic_shutdown_super+0x14c/0x530
  [<0>] kill_block_super+0x3b/0xa0

ocfs2 has no ->freeze_fs() so this needs bdev_freeze(), e.g. a device
mapper suspend with lockfs. A read of a file with a bad extent record
whose dinode was cached before the suspend gets there without any I/O.

The existing soft read-only state doesn't stop modifications on its own.
OCFS2_OSB_SOFT_RO is set on every normal read-only mount as well and
those still need transactions for journal and orphan recovery, the local
alloc and the truncate log. So ocfs2_start_trans() can't refuse on it.
The existing ocfs2_emergency_state() checks cover things like fsync,
setattr, fallocate, remap and the resize ioctls. Everything else was
stopped by the VFS because of SB_RDONLY.

So like ext4 did in commit d3476f3dad4a ("ext4: don't set SB_RDONLY
after filesystem errors") stop setting SB_RDONLY. ocfs2_handle_error()
still sets SOFT_RO so all the existing ocfs2_emergency_state() checks
keep working. And it now also sets a new OCFS2_OSB_EMERGENCY_RO flag
which tells the error state apart from a normal read-only mount. Then
refuse what the VFS doesn't refuse for us anymore with -EROFS, before
dquot_initialize() and before taking any cluster lock. That's the
namespace operations, opening for write, write_iter, xattrs and ACLs,
fileattr_set and the reflink ioctl. page_mkwrite fails with
VM_FAULT_SIGBUS. This extends what commit 752ba0976b25 ("ocfs2: add
ocfs2_emergency_state helper and apply to setattr") and
commit 7eff54dfd245 ("ocfs2: convert remaining read-only checks to
ocfs2_emergency_state") started.

The xattr check sits in the xattr handlers and not in ocfs2_xattr_set().
chmod and setfacl store the ACL through it after they already committed
the new mode. Refusing there would leave the new mode without its ACL
when an error hits in between.

quotactl_fd() takes write access to the mount which an error doesn't
take away anymore, and Q_SETQUOTA and Q_SETINFO end in journalled quota
writes. So ocfs2 now uses its own copy of dquot_quotactl_sysfile_ops
whose ->set_dqblk() and ->set_info() refuse in that state. Note that
Q_GETQUOTA and Q_GETNEXTQUOTA can still journal after an error. Reading
a dquot that isn't in memory yet goes through ocfs2_acquire_dquot()
which starts a transaction. quotactl(2) on the block device could always
do that, also for the read-only superblock, and now quotactl_fd() can
too, unprivileged for the caller's own ids. I've left that alone.

Errors during the mount, e.g. from journal recovery, don't make the
mount read-only anymore either. ocfs2_fill_super() didn't enable quotas
on the read-only superblock and now doesn't in the error state either
because loading the local quota files writes to them.

ocfs2_sync_fs() already returned 0 for SOFT_RO but it still flushed the
truncate log and kicked off a journal commit. Skip both. sync(2),
syncfs(2), freeze and umount didn't call it for the read-only superblock
before and normal read-only mounts never get there.

A remount to read-write stays refused through the existing
OCFS2_OSB_ERROR_FS check. A remount to read-only skips
ocfs2_susp_quotas() which would write the quota info. That lets
emergency remount turn an errored ocfs2 read-only without a WARN.
Beyond that the sync_filesystem() every remount does only writes back
data dirtied before the error.

Like ext4 we show "emergency_ro" in the mount options. The mount stays
"rw" until a remount to read-only so statfs() doesn't report ST_RDONLY
anymore, access(W_OK) succeeds and a second read-only mount of the
device fails with -EBUSY. Writes through file descriptors opened before
the error now fail with -EROFS. umount after such an error completes
instead of hanging. ocfs2's internal transactions behave as before. The
truncate log worker, orphan cleanup on evict, the local alloc and slot
updates at umount and quota sync never cared about SB_RDONLY. Neither
did data writeback.

Reproducer:

  truncate -s 512M ocfs2.img; mkfs.ocfs2 -q -M local -b 4096 -C 4096 -N 1 ocfs2.img
  losetup /dev/loop0 ocfs2.img
  mount -t ocfs2 -o heartbeat=none /dev/loop0 /mnt
  dd if=/dev/zero of=/mnt/data bs=64k count=1; ino=$(stat -c %i /mnt/data); umount /mnt
  # zero l_recs[0].e_blkno (byte 0xd8) of data's dinode; the inode number is its block
  dd if=/dev/zero of=/dev/loop0 bs=1 count=8 seek=$((ino * 4096 + 0xd8)) conv=notrunc
  dmsetup create ocfs2 --table "0 $(blockdev --getsz /dev/loop0) linear /dev/loop0 0"
  mount -t ocfs2 -o heartbeat=none,noatime /dev/mapper/ocfs2 /mnt
  stat /mnt/data; getfattr -n user.x /mnt/data   # getxattr caches the dinode
  dmsetup suspend ocfs2
  cat /mnt/data      # ocfs2_get_clusters(): "bad extent record" -> SB_RDONLY while frozen
  dmsetup resume ocfs2
  touch /mnt/x       # hangs in sb_start_write()
  # umount instead of touch: hangs in sb_start_intwrite() from
  # ocfs2_start_trans() <- ocfs2_shutdown_local_alloc()

noatime matters, otherwise the atime transaction of the read waits for
the frozen filesystem.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/acl.c          |  3 +++
 fs/ocfs2/file.c         |  8 +++++++
 fs/ocfs2/ioctl.c        |  3 +++
 fs/ocfs2/mmap.c         |  3 +++
 fs/ocfs2/namei.c        | 21 +++++++++++++++++
 fs/ocfs2/ocfs2.h        | 12 ++++++++++
 fs/ocfs2/refcounttree.c |  3 +++
 fs/ocfs2/super.c        | 63 ++++++++++++++++++++++++++++++++++++++++++++-----
 fs/ocfs2/xattr.c        |  8 +++++++
 9 files changed, 118 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 090ec60fb576..cf23f6b32a52 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -268,6 +268,9 @@ int ocfs2_iop_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct ocfs2_lock_holder oh;
 	struct inode *inode = d_inode(dentry);
 
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(inode->i_sb))))
+		return -EROFS;
+
 	had_lock = ocfs2_inode_lock_tracker(inode, &bh, 1, &oh);
 	if (had_lock < 0)
 		return had_lock;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d6e977ba6565..4c8b3957488f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -91,6 +91,11 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 			      file->f_path.dentry->d_name.name, mode);
 
 	if (file->f_mode & FMODE_WRITE) {
+		if (unlikely(ocfs2_emergency_state(OCFS2_SB(inode->i_sb)))) {
+			status = -EROFS;
+			goto leave;
+		}
+
 		status = dquot_initialize(inode);
 		if (status)
 			goto leave;
@@ -2404,6 +2409,9 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	if (count == 0)
 		return 0;
 
+	if (unlikely(ocfs2_emergency_state(osb)))
+		return -EROFS;
+
 	if (nowait) {
 		if (!inode_trylock(inode))
 			return -EAGAIN;
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index cbe59d231666..1888af1a3cdf 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -97,6 +97,9 @@ int ocfs2_fileattr_set(struct mnt_idmap *idmap,
 	if (fileattr_has_fsx(fa))
 		return -EOPNOTSUPP;
 
+	if (unlikely(ocfs2_emergency_state(osb)))
+		return -EROFS;
+
 	status = ocfs2_inode_lock(inode, &bh, 1);
 	if (status < 0) {
 		mlog_errno(status);
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 6c570157caf1..e873b2082bc6 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -118,6 +118,9 @@ static vm_fault_t ocfs2_page_mkwrite(struct vm_fault *vmf)
 	int err;
 	vm_fault_t ret;
 
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(inode->i_sb))))
+		return VM_FAULT_SIGBUS;
+
 	sb_start_pagefault(inode->i_sb);
 	ocfs2_block_signals(&oldset);
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 58c6061ed983..c43e2d8a6f95 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -262,6 +262,9 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 			  (unsigned long long)OCFS2_I(dir)->ip_blkno,
 			  (unsigned long)dev, mode);
 
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(dir->i_sb))))
+		return -EROFS;
+
 	status = dquot_initialize(dir);
 	if (status) {
 		mlog_errno(status);
@@ -659,6 +662,9 @@ static struct dentry *ocfs2_mkdir(struct mnt_idmap *idmap,
 
 	trace_ocfs2_mkdir(dir, dentry, dentry->d_name.len, dentry->d_name.name,
 			  OCFS2_I(dir)->ip_blkno, mode);
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(dir->i_sb))))
+		return ERR_PTR(-EROFS);
+
 	ret = ocfs2_mknod(&nop_mnt_idmap, dir, dentry, mode, 0);
 	if (ret)
 		mlog_errno(ret);
@@ -675,6 +681,9 @@ static int ocfs2_create(struct mnt_idmap *idmap,
 
 	trace_ocfs2_create(dir, dentry, dentry->d_name.len, dentry->d_name.name,
 			   (unsigned long long)OCFS2_I(dir)->ip_blkno, mode);
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(dir->i_sb))))
+		return -EROFS;
+
 	ret = ocfs2_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFREG, 0);
 	if (ret)
 		mlog_errno(ret);
@@ -703,6 +712,9 @@ static int ocfs2_link(struct dentry *old_dentry,
 			 old_dentry->d_name.len, old_dentry->d_name.name,
 			 dentry->d_name.len, dentry->d_name.name);
 
+	if (unlikely(ocfs2_emergency_state(osb)))
+		return -EROFS;
+
 	if (S_ISDIR(inode->i_mode))
 		return -EPERM;
 
@@ -899,6 +911,9 @@ static int ocfs2_unlink(struct inode *dir,
 			   (unsigned long long)OCFS2_I(dir)->ip_blkno,
 			   (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
+	if (unlikely(ocfs2_emergency_state(osb)))
+		return -EROFS;
+
 	status = dquot_initialize(dir);
 	if (status) {
 		mlog_errno(status);
@@ -1236,6 +1251,9 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 	struct ocfs2_dir_lookup_result target_insert = { NULL, };
 	bool should_add_orphan = false;
 
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(old_dir->i_sb))))
+		return -EROFS;
+
 	if (flags)
 		return -EINVAL;
 
@@ -1843,6 +1861,9 @@ static int ocfs2_symlink(struct mnt_idmap *idmap,
 	trace_ocfs2_symlink_begin(dir, dentry, symname,
 				  dentry->d_name.len, dentry->d_name.name);
 
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(dir->i_sb))))
+		return -EROFS;
+
 	status = dquot_initialize(dir);
 	if (status) {
 		mlog_errno(status);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 62cad6522c7a..dc767efb2f47 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -282,6 +282,7 @@ enum ocfs2_mount_options
 #define OCFS2_OSB_SOFT_RO	0x0001
 #define OCFS2_OSB_HARD_RO	0x0002
 #define OCFS2_OSB_ERROR_FS	0x0004
+#define OCFS2_OSB_EMERGENCY_RO	0x0008	/* error made the fs read-only */
 #define OCFS2_DEFAULT_ATIME_QUANTUM	60
 
 struct ocfs2_triggers {
@@ -688,6 +689,17 @@ static inline int ocfs2_is_readonly(struct ocfs2_super *osb)
 	return ret;
 }
 
+static inline int ocfs2_is_emergency_ro(struct ocfs2_super *osb)
+{
+	int ret;
+
+	spin_lock(&osb->osb_lock);
+	ret = osb->osb_flags & OCFS2_OSB_EMERGENCY_RO;
+	spin_unlock(&osb->osb_lock);
+
+	return ret;
+}
+
 static inline int ocfs2_emergency_state(struct ocfs2_super *osb)
 {
 	if (ocfs2_is_readonly(osb))
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index d9f22b4a2654..2404140c79fb 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4441,6 +4441,9 @@ int ocfs2_reflink_ioctl(struct inode *inode,
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb)))
 		return -EOPNOTSUPP;
 
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(inode->i_sb))))
+		return -EROFS;
+
 	error = user_path_at(AT_FDCWD, oldname, 0, &old_path);
 	if (error) {
 		mlog_errno(error);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 26041371a666..014e7cca21ef 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -125,6 +125,33 @@ static struct dquot __rcu **ocfs2_get_dquots(struct inode *inode)
 	return OCFS2_I(inode)->i_dquot;
 }
 
+/*
+ * quotactl_fd() takes write access to the mount, which an error doesn't take
+ * away anymore. Refuse quota limit and info changes once an error made the
+ * file system read-only: they are journalled writes.
+ */
+static int ocfs2_set_dqinfo(struct super_block *sb, int type,
+			    struct qc_info *ii)
+{
+	if (unlikely(ocfs2_is_emergency_ro(OCFS2_SB(sb))))
+		return -EROFS;
+	return dquot_set_dqinfo(sb, type, ii);
+}
+
+static int ocfs2_set_dqblk(struct super_block *sb, struct kqid qid,
+			   struct qc_dqblk *di)
+{
+	if (unlikely(ocfs2_is_emergency_ro(OCFS2_SB(sb))))
+		return -EROFS;
+	return dquot_set_dqblk(sb, qid, di);
+}
+
+/*
+ * dquot_quotactl_sysfile_ops with set_info and set_dqblk replaced, filled in by
+ * ocfs2_init().
+ */
+static struct quotactl_ops ocfs2_quotactl_ops __ro_after_init;
+
 static const struct super_operations ocfs2_sops = {
 	.statfs		= ocfs2_statfs,
 	.alloc_inode	= ocfs2_alloc_inode,
@@ -402,6 +429,13 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait)
 	if (ocfs2_is_hard_readonly(osb))
 		return -EROFS;
 
+	/*
+	 * An error made the file system read-only: don't flush the truncate
+	 * log or kick off a journal commit.
+	 */
+	if (ocfs2_is_soft_readonly(osb))
+		return 0;
+
 	if (wait) {
 		status = ocfs2_flush_truncate_log(osb);
 		if (status < 0)
@@ -646,8 +680,11 @@ static int ocfs2_reconfigure(struct fs_context *fc)
 
 	/* We're going to/from readonly mode. */
 	if ((bool)(fc->sb_flags & SB_RDONLY) != sb_rdonly(sb)) {
-		/* Disable quota accounting before remounting RO */
-		if (fc->sb_flags & SB_RDONLY) {
+		/*
+		 * Disable quota accounting before remounting RO, unless an
+		 * error made the fs read-only: nothing may be written then.
+		 */
+		if ((fc->sb_flags & SB_RDONLY) && !ocfs2_is_emergency_ro(osb)) {
 			ret = ocfs2_susp_quotas(osb, 0);
 			if (ret < 0)
 				goto out;
@@ -1136,7 +1173,7 @@ static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 	/* Now we can initialize quotas because we can afford to wait
 	 * for cluster locks recovery now. That also means that truncation
 	 * log recovery can happen but that waits for proper quota setup */
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly(sb) && !ocfs2_is_emergency_ro(osb)) {
 		status = ocfs2_enable_quotas(osb);
 		if (status < 0) {
 			/* We have to err-out specially here because
@@ -1460,6 +1497,9 @@ static int ocfs2_show_options(struct seq_file *s, struct dentry *root)
 	else
 		seq_printf(s, ",errors=remount-ro");
 
+	if (ocfs2_is_emergency_ro(osb))
+		seq_puts(s, ",emergency_ro");
+
 	if (osb->preferred_slot != OCFS2_INVALID_SLOT)
 		seq_printf(s, ",preferred_slot=%d", osb->preferred_slot);
 
@@ -1529,6 +1569,10 @@ static int __init ocfs2_init(void)
 
 	ocfs2_set_locking_protocol();
 
+	ocfs2_quotactl_ops = dquot_quotactl_sysfile_ops;
+	ocfs2_quotactl_ops.set_info = ocfs2_set_dqinfo;
+	ocfs2_quotactl_ops.set_dqblk = ocfs2_set_dqblk;
+
 	register_quota_format(&ocfs2_quota_format);
 
 	status = register_filesystem(&ocfs2_fs_type);
@@ -1976,7 +2020,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_op = &ocfs2_sops;
 	set_default_d_op(sb, &ocfs2_dentry_ops);
 	sb->s_export_op = &ocfs2_export_ops;
-	sb->s_qcop = &dquot_quotactl_sysfile_ops;
+	sb->s_qcop = &ocfs2_quotactl_ops;
 	sb->dq_op = &ocfs2_quota_operations;
 	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 	sb->s_xattr = ocfs2_xattr_handlers;
@@ -2497,11 +2541,18 @@ static int ocfs2_handle_error(struct super_block *sb)
 		rv = -EIO;
 	} else { /* default option */
 		rv = -EROFS;
-		if (sb_rdonly(sb) && ocfs2_emergency_state(osb))
+		if (ocfs2_emergency_state(osb))
 			return rv;
 
 		pr_crit("OCFS2: File system is now read-only.\n");
-		sb->s_flags |= SB_RDONLY;
+		/*
+		 * Don't set SB_RDONLY: that needs sb->s_umount and a proper
+		 * remount, and setting it while the file system is frozen
+		 * makes thaw_super() leave the s_writers rwsems locked.  The
+		 * soft read-only flag makes ocfs2_emergency_state() refuse
+		 * modifications until the file system is unmounted.
+		 */
+		ocfs2_set_osb_flag(osb, OCFS2_OSB_EMERGENCY_RO);
 		ocfs2_set_ro_flag(osb, 0);
 	}
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index bfafe059bedf..26afa736b147 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7505,6 +7505,9 @@ static int ocfs2_xattr_security_set(const struct xattr_handler *handler,
 				    const char *name, const void *value,
 				    size_t size, int flags)
 {
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(inode->i_sb))))
+		return -EROFS;
+
 	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY,
 			       name, value, size, flags);
 }
@@ -7600,6 +7603,9 @@ static int ocfs2_xattr_trusted_set(const struct xattr_handler *handler,
 				   const char *name, const void *value,
 				   size_t size, int flags)
 {
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(inode->i_sb))))
+		return -EROFS;
+
 	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_TRUSTED,
 			       name, value, size, flags);
 }
@@ -7635,6 +7641,8 @@ static int ocfs2_xattr_user_set(const struct xattr_handler *handler,
 
 	if (osb->s_mount_opt & OCFS2_MOUNT_NOUSERXATTR)
 		return -EOPNOTSUPP;
+	if (unlikely(ocfs2_emergency_state(osb)))
+		return -EROFS;
 
 	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_USER,
 			       name, value, size, flags);

-- 
2.53.0

