Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CEB345741;
	Mon, 12 Oct 2026 10:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800503; cv=none; b=TM+QdUSq7eRTHThbNDL6qm+Ot3BPnLgYc1mbAecwFTygiPGaNB/RbWNGyXSRrUVDgFOnZZPoXZ4sd4krK7V6o6A7NcpZOwyz6GlkaCjtdpv2H/VtjJNdaNwwjkYhAGJvjcR2pjmJkNC7mUazEtNyE9JrzYTIMtE/oHGC6FjVTqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800503; c=relaxed/simple;
	bh=RRieJ4OdCjsHscNVR+xo4MrUAffnBmaTJE9hlDhwoOg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kih44YW3LWkzz1MXpL2urmzh/BGi5aYP/kVzpmaPj650sakAvCU46CJuvr227G9TYXA+fgD1e1KOK1K/BVrYTobM4GrVx/XZpv6h53w0VOPvnX4DVVEVlpaydGJackNak8n5pmY4Uj2wkgKVCMRKGXeQ4ytxtoVj1r8XkCrm/r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KI+ml2F3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KI+ml2F3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9791F0089F;
	Mon, 12 Oct 2026 10:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800490;
	bh=npyuIqFmr3AY/ZHfue4x3Z7ktzBqgrmRktCQqHjkgZM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KI+ml2F3TuxD1AdJGXtnaSP/AfgdMcX6j4D79k4KW35eqYFf/i/XVaFd2naPPoIfF
	 mwGHz/V0VSk21kTfHVX5/qoIOMWD/z5inNINXiQcRAs/gqb95750gKZ/L94zUF6cpR
	 7i8LJ+pXft2dsITGDxX0RQpX6gPhF/RDEDXKk4AcqkJTO2wthhfyUILaFKyYR0QIzb
	 973yVPIgM3HyFYlWApimiV+CKzp06ZUuPKjKVl0yWDAg/ZILxZdqmmS6noqZju1BJl
	 CVTrDEXwpcLK5rMlspL9agKPZOD9wRoq1+8h1FTt4BDWyD18SWDd+cSUlpnHD/PRVa
	 ssoYyubmDqMGg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:20:49 +0200
Subject: [PATCH RFC 04/28] jfs: don't set SB_RDONLY after filesystem errors
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-4-60743a3dc326@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=20040; i=brauner@kernel.org;
 h=from:subject:message-id; bh=RRieJ4OdCjsHscNVR+xo4MrUAffnBmaTJE9hlDhwoOg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TLpUWDJCgfJj90HFJuMhIq3FafMqVh6tPWpIe/S5
 NgrB36wdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzE2JWR4YLXPwuNrY+uV/Nr
 FDndVOAsFJWY4Pem1f37o2nNN4IeyzH8T3H/nBpYNEst+Opxlzt7tkw5dG3uld0+anIz+z94rFV
 QYQUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

jfs_handle_error() sets SB_RDONLY with errors=remount-ro, which is the
jfs default. It does that without holding sb->s_umount and from whatever
context found the error, including on a frozen filesystem. FIFREEZE
doesn't stop reads so looking up a directory with a corrupted dtree root
is enough:

  ERROR: (device vda): copy_from_dinode: Corrupt dtroot

freeze_super() and thaw_super() both look at sb_rdonly() to figure out
whether the s_writers rwsems need to be taken or released. So after the
flip thaw_super() skips jfs_unfreeze() and sb_freeze_unlock(), marks the
superblock unfrozen and every writer after that blocks forever:

  [<0>] percpu_rwsem_wait+0x203/0x500
  [<0>] mnt_want_write+0x28f/0x2f0
  [<0>] lookup_open+0x135/0x1b20
  INFO: task s1_frz:109 blocked for more than 30 seconds.

On jfs a umount after such a thaw even oopses. jfs_freeze() ran
txQuiesce() and lmLogShutdown() which sets log->bp to NULL. Since
jfs_unfreeze() was skipped lmLogInit() and txResume() never ran and
log_QUIESCE stays set. umount then shuts the log down a second time from
lmLogClose() and lmWriteRecord() dereferences the NULL log->bp:

  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000007: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000038-0x000000000000003f]
  RIP: 0010:lmWriteRecord (fs/jfs/jfs_logmgr.c:366)
   lmLogShutdown (fs/jfs/jfs_logmgr.c:1652)
   lmLogClose (fs/jfs/jfs_logmgr.c:1457)
   jfs_put_super (fs/jfs/super.c:194)

Do what ext4 did in commit d3476f3dad4a ("ext4: don't set SB_RDONLY
after filesystem errors") and record the error in jfs' own state. We
can't use sbi->flag for that because it holds the mount options and is
overwritten on remount. So add a separate jfs_flags word with
JFS_FLAGS_EMERGENCY_RO.

jfs_unfreeze() also used sb_rdonly() to figure out whether jfs_freeze()
shut down the log. Record that in JFS_FLAGS_LOG_SHUTDOWN instead so thaw
undoes exactly what freeze did, also if the error happened while the
filesystem was frozen. The bit is only cleared once the log is back up
so a thaw that failed can be retried.

jfs now has to refuse modifications itself. All of the checks come
before txBegin(): inode allocation in ialloc(), block allocation in
extAlloc() and extRecord(), and the remaining entry points like link,
unlink, rename, setattr, write_iter, opening for write, xattrs, ACLs and
quota changes. The existing isReadOnly() checks can't be used for this
because failing txCommit() with tlocks held trips the assert in txEnd().
FITRIM is refused as well.

While at it give slow symlinks jfs_symlink_inode_operations like
jfs_symlink() does. jfs_iget() gave them page_symlink_inode_operations
which has no ->setattr. So their attributes could still be changed and
a chown skipped dquot_transfer().

Allocations that are under way when the error hits still have to be
committed though. extAlloc() and extRecord() leave anonymous tlocks on
the inode that only go away with the next commit of the inode, usually
when it is written back, and jfs_evict_inode() BUGs if any are left. So
jfs_dirty_inode() keeps queueing commits for inodes that have anonymous
tlocks and stops doing so for everything else. And extRecord() now marks
the inode dirty like extAlloc() does.

That's also why a remount to read-only still has to sync. umount doesn't
sync a read-only superblock and can come before writeback got to those
inodes. So the remount runs sync_filesystem() to commit what was queued
before the error. It skips dquot_suspend() and jfs_umount_rw() though
and the log stays open until umount closes it. A remount from read-only
to read-write and resizing fail with -EROFS until umount. So far
"mount -o remount,rw" made the filesystem writable again after an error.

Apart from what was queued before the error only two things still
write: evicting a file that was unlinked before the error, and a write
that was under way and fails in extAlloc() which truncates what it
already allocated. jfs_sync_fs() returns right away. Freezing an errored
filesystem doesn't shut down the log or write the superblock. It only
waits until what was committed before the freeze is in the log. Waiting
for all of it to be written home as well needs a quiesced log. Otherwise
jfs_flush_journal() BUG()s after 50 seconds when other filesystems keep
committing to a shared external log.

Like ext4 we show "emergency_ro" in the mount options. The superblock
stays read-write so writes through file descriptors that were opened
before the error now fail with -EROFS as well, a second read-only mount
of the device fails with -EBUSY and a non-forced remount to read-only
fails with -EBUSY while files are still open for writing.

Reproducer (the sb_rdonly selftest at the end of this series covers it
as well):

  truncate -s 256M img; mkfs.jfs -q img
  mount -o loop img /mnt           # errors=remount-ro is the default
  mkdir /mnt/d; touch /mnt/d/marker; umount /mnt
  # d's only entry sits in the dtree root of d's dinode: the UCS-2 name at
  # dinode+262, the dtroot freecnt at dinode+242; freecnt := -128
  off=$(grep -obUaP 'm\x00a\x00r\x00k\x00e\x00r\x00' img | head -1 | cut -d: -f1)
  printf '\x80' | dd of=img bs=1 seek=$((off - 20)) conv=notrunc
  mount -o loop img /mnt
  fsfreeze -f /mnt; ls -d /mnt/d; fsfreeze -u /mnt   # "copy_from_dinode: Corrupt dtroot"
  touch /mnt/x     # blocks forever in sb_start_write()
  # or umount instead: NULL pointer dereference in lmWriteRecord()

Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/jfs/acl.c        |  3 +++
 fs/jfs/file.c       | 16 ++++++++++++-
 fs/jfs/inode.c      |  6 ++++-
 fs/jfs/ioctl.c      |  7 ++++++
 fs/jfs/jfs_dtree.c  |  3 ++-
 fs/jfs/jfs_extent.c | 10 ++++++++
 fs/jfs/jfs_incore.h | 12 ++++++++++
 fs/jfs/jfs_inode.c  |  3 +++
 fs/jfs/namei.c      | 12 ++++++++++
 fs/jfs/super.c      | 69 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/jfs/xattr.c      |  3 +++
 11 files changed, 135 insertions(+), 9 deletions(-)

diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
index 16b71a23ff1e..fbdf2ae5c443 100644
--- a/fs/jfs/acl.c
+++ b/fs/jfs/acl.c
@@ -98,6 +98,9 @@ int jfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	umode_t mode = inode->i_mode;
 
+	if (jfs_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	tid = txBegin(inode->i_sb, 0);
 	mutex_lock(&JFS_IP(inode)->commit_mutex);
 	if (type == ACL_TYPE_ACCESS && acl) {
diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index 246568cb9a6e..83b9606f201d 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -45,6 +45,9 @@ static int jfs_open(struct inode *inode, struct file *file)
 {
 	int rc;
 
+	if ((file->f_mode & FMODE_WRITE) && jfs_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	if (S_ISREG(inode->i_mode) && inode->i_size < 0)
 		return -EIO;
 
@@ -95,6 +98,9 @@ int jfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	int rc;
 
+	if (jfs_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	rc = setattr_prepare(&nop_mnt_idmap, dentry, iattr);
 	if (rc)
 		return rc;
@@ -131,6 +137,14 @@ int jfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	return rc;
 }
 
+static ssize_t jfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	if (jfs_emergency_ro(file_inode(iocb->ki_filp)->i_sb))
+		return -EROFS;
+
+	return generic_file_write_iter(iocb, from);
+}
+
 const struct inode_operations jfs_file_inode_operations = {
 	.listxattr	= jfs_listxattr,
 	.setattr	= jfs_setattr,
@@ -146,7 +160,7 @@ const struct file_operations jfs_file_operations = {
 	.open		= jfs_open,
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
-	.write_iter	= generic_file_write_iter,
+	.write_iter	= jfs_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index c7914dbc91ed..ed97ef2ce70f 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -47,7 +47,7 @@ struct inode *jfs_iget(struct super_block *sb, unsigned long ino)
 		inode->i_fop = &jfs_dir_operations;
 	} else if (S_ISLNK(inode->i_mode)) {
 		if (inode->i_size >= IDATASIZE) {
-			inode->i_op = &page_symlink_inode_operations;
+			inode->i_op = &jfs_symlink_inode_operations;
 			inode_nohighmem(inode);
 			inode->i_mapping->a_ops = &jfs_aops;
 		} else {
@@ -187,6 +187,10 @@ void jfs_dirty_inode(struct inode *inode, int flags)
 {
 	static int noisy = 5;
 
+	/* After an error only allocations under way still get committed. */
+	if (jfs_emergency_ro(inode->i_sb) && !READ_ONCE(JFS_IP(inode)->atlhead))
+		return;
+
 	if (isReadOnly(inode)) {
 		if (!special_file(inode->i_mode) && noisy) {
 			/* kernel allows writes to devices on read-only
diff --git a/fs/jfs/ioctl.c b/fs/jfs/ioctl.c
index 563f148be8af..f0076a415276 100644
--- a/fs/jfs/ioctl.c
+++ b/fs/jfs/ioctl.c
@@ -77,6 +77,9 @@ int jfs_fileattr_set(struct mnt_idmap *idmap,
 	struct jfs_inode_info *jfs_inode = JFS_IP(inode);
 	unsigned int flags;
 
+	if (jfs_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	if (d_is_special(dentry))
 		return -ENOTTY;
 
@@ -116,6 +119,10 @@ long jfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
+		/* Don't trust the block map after an error. */
+		if (jfs_emergency_ro(sb))
+			return -EROFS;
+
 		if (!bdev_max_discard_sectors(sb->s_bdev)) {
 			jfs_warn("FITRIM not supported on device");
 			return -EOPNOTSUPP;
diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 8ce6e4458cc2..2f8ae131bc49 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -2935,7 +2935,8 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 				if ((jfs_dirent->position < 2) ||
 				    (jfs_dirent->position >=
 				     JFS_IP(ip)->next_index)) {
-					if (!page_fixed && !isReadOnly(ip)) {
+					if (!page_fixed && !isReadOnly(ip) &&
+					    !jfs_emergency_ro(ip->i_sb)) {
 						fix_page = 1;
 						/*
 						 * setting overflow and setting
diff --git a/fs/jfs/jfs_extent.c b/fs/jfs/jfs_extent.c
index 46529bcc8297..a28e7cd908a6 100644
--- a/fs/jfs/jfs_extent.c
+++ b/fs/jfs/jfs_extent.c
@@ -74,6 +74,9 @@ extAlloc(struct inode *ip, s64 xlen, s64 pno, xad_t * xp, bool abnr)
 	int rc;
 	int xflag;
 
+	if (jfs_emergency_ro(ip->i_sb))
+		return -EROFS;
+
 	if (isReadOnly(ip)) {
 		jfs_error(ip->i_sb, "read-only filesystem\n");
 		return -EIO;
@@ -258,6 +261,9 @@ int extRecord(struct inode *ip, xad_t * xp)
 {
 	int rc;
 
+	if (jfs_emergency_ro(ip->i_sb))
+		return -EROFS;
+
 	if (isReadOnly(ip)) {
 		jfs_error(ip->i_sb, "read-only filesystem\n");
 		return -EIO;
@@ -270,6 +276,10 @@ int extRecord(struct inode *ip, xad_t * xp)
 	/* update the extent */
 	rc = xtUpdate(0, ip, xp);
 
+	/* get the anonymous tlocks committed, like extAlloc() does */
+	if (!rc)
+		mark_inode_dirty(ip);
+
 	mutex_unlock(&JFS_IP(ip)->commit_mutex);
 	return rc;
 }
diff --git a/fs/jfs/jfs_incore.h b/fs/jfs/jfs_incore.h
index 5aaafedb8fbc..fa26e0eff937 100644
--- a/fs/jfs/jfs_incore.h
+++ b/fs/jfs/jfs_incore.h
@@ -192,6 +192,7 @@ struct jfs_sb_info {
 	struct inode *direct_inode;	/* metadata inode */
 	uint		state;		/* mount/recovery state	*/
 	unsigned long	flag;		/* mount time flags */
+	unsigned long	jfs_flags;	/* runtime state, JFS_FLAGS_* */
 	uint		p_state;	/* state prior to going no integrity */
 	kuid_t		uid;		/* uid to override on-disk uid */
 	kgid_t		gid;		/* gid to override on-disk gid */
@@ -202,6 +203,12 @@ struct jfs_sb_info {
 /* jfs_sb_info commit_state */
 #define IN_LAZYCOMMIT 1
 
+/* jfs_sb_info jfs_flags bits */
+enum {
+	JFS_FLAGS_EMERGENCY_RO,	/* read-only after an error */
+	JFS_FLAGS_LOG_SHUTDOWN,	/* jfs_freeze() shut the log down */
+};
+
 static inline struct jfs_inode_info *JFS_IP(struct inode *inode)
 {
 	return container_of(inode, struct jfs_inode_info, vfs_inode);
@@ -223,4 +230,9 @@ static inline int isReadOnly(struct inode *inode)
 		return 0;
 	return 1;
 }
+
+static inline bool jfs_emergency_ro(struct super_block *sb)
+{
+	return test_bit(JFS_FLAGS_EMERGENCY_RO, &JFS_SBI(sb)->jfs_flags);
+}
 #endif /* _H_JFS_INCORE */
diff --git a/fs/jfs/jfs_inode.c b/fs/jfs/jfs_inode.c
index f10f295d1502..9085129f61a2 100644
--- a/fs/jfs/jfs_inode.c
+++ b/fs/jfs/jfs_inode.c
@@ -45,6 +45,9 @@ struct inode *ialloc(struct inode *parent, umode_t mode)
 	struct jfs_inode_info *jfs_inode;
 	int rc;
 
+	if (jfs_emergency_ro(sb))
+		return ERR_PTR(-EROFS);
+
 	inode = new_inode(sb);
 	if (!inode) {
 		jfs_warn("ialloc: new_inode returned NULL!");
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 8a36c218f0f7..e667751cf504 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -343,6 +343,9 @@ static int jfs_rmdir(struct inode *dip, struct dentry *dentry)
 
 	jfs_info("jfs_rmdir: dip:0x%p name:%pd", dip, dentry);
 
+	if (jfs_emergency_ro(dip->i_sb))
+		return -EROFS;
+
 	/* Init inode for quota operations. */
 	rc = dquot_initialize(dip);
 	if (rc)
@@ -475,6 +478,9 @@ static int jfs_unlink(struct inode *dip, struct dentry *dentry)
 
 	jfs_info("jfs_unlink: dip:0x%p name:%pd", dip, dentry);
 
+	if (jfs_emergency_ro(dip->i_sb))
+		return -EROFS;
+
 	/* Init inode for quota operations. */
 	rc = dquot_initialize(dip);
 	if (rc)
@@ -797,6 +803,9 @@ static int jfs_link(struct dentry *old_dentry,
 
 	jfs_info("jfs_link: %pd %pd", old_dentry, dentry);
 
+	if (jfs_emergency_ro(dir->i_sb))
+		return -EROFS;
+
 	rc = dquot_initialize(dir);
 	if (rc)
 		goto out;
@@ -1092,6 +1101,9 @@ static int jfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 
 	jfs_info("jfs_rename: %pd %pd", old_dentry, new_dentry);
 
+	if (jfs_emergency_ro(old_dir->i_sb))
+		return -EROFS;
+
 	rc = dquot_initialize(old_dir);
 	if (rc)
 		goto out1;
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 8180d83d33fe..b97716793e27 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -63,7 +63,7 @@ static void jfs_handle_error(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || jfs_emergency_ro(sb))
 		return;
 
 	updateSuper(sb, FM_DIRTY);
@@ -74,7 +74,12 @@ static void jfs_handle_error(struct super_block *sb)
 	else if (sbi->flag & JFS_ERR_REMOUNT_RO) {
 		jfs_err("ERROR: (device %s): remounting filesystem as read-only",
 			sb->s_id);
-		sb->s_flags |= SB_RDONLY;
+		/*
+		 * Don't set SB_RDONLY, that needs sb->s_umount and a remount.
+		 * Flipping it on a frozen filesystem makes thaw skip
+		 * jfs_unfreeze() and leave s_writers locked forever.
+		 */
+		set_bit(JFS_FLAGS_EMERGENCY_RO, &sbi->jfs_flags);
 	}
 
 	/* nothing is done for continue beyond marking the superblock dirty */
@@ -166,14 +171,30 @@ static void jfs_quota_off_umount(struct super_block *sb)
 		jfs_quota_off(sb, type);
 }
 
+/* After an error quota changes can't be written anymore. */
+static int jfs_set_dqinfo(struct super_block *sb, int type, struct qc_info *ii)
+{
+	if (jfs_emergency_ro(sb))
+		return -EROFS;
+	return dquot_set_dqinfo(sb, type, ii);
+}
+
+static int jfs_set_dqblk(struct super_block *sb, struct kqid qid,
+			 struct qc_dqblk *di)
+{
+	if (jfs_emergency_ro(sb))
+		return -EROFS;
+	return dquot_set_dqblk(sb, qid, di);
+}
+
 static const struct quotactl_ops jfs_quotactl_ops = {
 	.quota_on	= jfs_quota_on,
 	.quota_off	= jfs_quota_off,
 	.quota_sync	= dquot_quota_sync,
 	.get_state	= dquot_get_state,
-	.set_info	= dquot_set_dqinfo,
+	.set_info	= jfs_set_dqinfo,
 	.get_dqblk	= dquot_get_dqblk,
-	.set_dqblk	= dquot_set_dqblk,
+	.set_dqblk	= jfs_set_dqblk,
 	.get_nextdqblk	= dquot_get_next_dqblk,
 };
 #else
@@ -367,6 +388,11 @@ static int jfs_reconfigure(struct fs_context *fc)
 	int flag = ctx->flag;
 	int ret;
 
+	/* An error made the filesystem read-only until it is unmounted. */
+	if (jfs_emergency_ro(sb) && (ctx->resize || (sb_rdonly(sb) && !readonly)))
+		return -EROFS;
+
+	/* After an error this only commits what was queued before it. */
 	sync_filesystem(sb);
 
 	/* Transfer results of parsing to the sbi */
@@ -415,6 +441,9 @@ static int jfs_reconfigure(struct fs_context *fc)
 		return ret;
 	}
 	if (!sb_rdonly(sb) && readonly) {
+		/* After an error nothing may be written, umount closes the log. */
+		if (jfs_emergency_ro(sb))
+			return 0;
 		rc = dquot_suspend(sb, -1);
 		if (rc < 0)
 			return rc;
@@ -587,6 +616,17 @@ static int jfs_freeze(struct super_block *sb)
 	int rc = 0;
 
 	if (!sb_rdonly(sb)) {
+		/*
+		 * After an error leave the log open and the superblock alone.
+		 * Only wait until what was committed before is in the log.
+		 * Waiting for all of it to be written home needs a quiesced
+		 * log, otherwise jfs_flush_journal() BUG()s when other
+		 * filesystems keep committing to a shared external log.
+		 */
+		if (jfs_emergency_ro(sb)) {
+			jfs_flush_journal(log, 1);
+			return 0;
+		}
 		txQuiesce(sb);
 		rc = lmLogShutdown(log);
 		if (rc) {
@@ -597,6 +637,7 @@ static int jfs_freeze(struct super_block *sb)
 
 			return rc;
 		}
+		set_bit(JFS_FLAGS_LOG_SHUTDOWN, &sbi->jfs_flags);
 		rc = updateSuper(sb, FM_CLEAN);
 		if (rc) {
 			jfs_err("jfs_freeze: updateSuper failed");
@@ -616,15 +657,19 @@ static int jfs_unfreeze(struct super_block *sb)
 	struct jfs_log *log = sbi->log;
 	int rc = 0;
 
-	if (!sb_rdonly(sb)) {
+	/* Undo what jfs_freeze() did, also if an error happened meanwhile. */
+	if (test_bit(JFS_FLAGS_LOG_SHUTDOWN, &sbi->jfs_flags)) {
 		rc = updateSuper(sb, FM_MOUNT);
 		if (rc) {
 			jfs_error(sb, "updateSuper failed\n");
 			goto out;
 		}
 		rc = lmLogInit(log);
-		if (rc)
+		if (rc) {
 			jfs_error(sb, "lmLogInit failed\n");
+			goto out;
+		}
+		clear_bit(JFS_FLAGS_LOG_SHUTDOWN, &sbi->jfs_flags);
 out:
 		txResume(sb);
 	}
@@ -640,6 +685,10 @@ static int jfs_sync_fs(struct super_block *sb, int wait)
 {
 	struct jfs_log *log = JFS_SBI(sb)->log;
 
+	/* After an error only freeze and umount write out the log. */
+	if (jfs_emergency_ro(sb))
+		return 0;
+
 	/* log == NULL indicates read-only mount */
 	if (log) {
 		/*
@@ -674,6 +723,8 @@ static int jfs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_printf(seq, ",errors=continue");
 	if (sbi->flag & JFS_ERR_PANIC)
 		seq_printf(seq, ",errors=panic");
+	if (jfs_emergency_ro(root->d_sb))
+		seq_puts(seq, ",emergency_ro");
 
 #ifdef CONFIG_QUOTA
 	if (sbi->flag & JFS_USRQUOTA)
@@ -748,6 +799,9 @@ static ssize_t jfs_quota_write(struct super_block *sb, int type,
 	struct buffer_head tmp_bh;
 	struct buffer_head *bh;
 
+	if (jfs_emergency_ro(sb))
+		return -EROFS;
+
 	inode_lock(inode);
 	while (towrite > 0) {
 		tocopy = min_t(size_t, sb->s_blocksize - offset, towrite);
@@ -801,6 +855,9 @@ static int jfs_quota_on(struct super_block *sb, int type, int format_id,
 	int err;
 	struct inode *inode;
 
+	if (jfs_emergency_ro(sb))
+		return -EROFS;
+
 	err = dquot_quota_on(sb, type, format_id, path);
 	if (err)
 		return err;
diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index 11d7f74d207b..d6965098e9e6 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -936,6 +936,9 @@ static int __jfs_xattr_set(struct inode *inode, const char *name,
 	tid_t tid;
 	int rc;
 
+	if (jfs_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	tid = txBegin(inode->i_sb, 0);
 	mutex_lock(&ji->commit_mutex);
 	rc = __jfs_setxattr(tid, inode, name, value, size, flags);

-- 
2.53.0

