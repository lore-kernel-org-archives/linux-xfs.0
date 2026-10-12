Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A241412269;
	Mon, 12 Oct 2026 10:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800514; cv=none; b=OIPvOyZiFPcag09oMLbkAbjaNj8JBP7OhXGHwJ4WHISWYNY8cQ75PDtmpEVX8wp2FsXnRqyG2w3LhEjcXbvD/jeGfCgq2J3TaRqQmkVhrxixdxDhcyL81Bq+tcT8HtofkEwBObly1lO85t0nt1ErwWBqKVAE5fQgzUCxb63sWRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800514; c=relaxed/simple;
	bh=KuJEEFuAYfLbCKHgQghNWOlxgH9KI0vKPiB8pe0ymQM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VTx032CLgqvsYpt9ZjZf8jQvz6kePwrZLHoYMl3nQZQ9qtFnpNz0OTxD4Z2EY3sKalWVo6vdEJ+H/2PgtO81tPsly3h/dlOIhp5gPkBn+311Q9K0PypwTHpzG7JcClMGH6q/C1ht1VTqhN8FMzMA1pTE9J1j6eGFPG1CNpDXSj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NanhayQO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NanhayQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E6A1F0089B;
	Mon, 12 Oct 2026 10:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800499;
	bh=q6waVOCyO2gR6GFI/cCkHVbkmOjqTA7TjVCuAr4GVPU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NanhayQO7fKCpXAvOHVCc/+ipt0ogA6orLuENoRyKF9svLTBIrGiBgrCAhxHa8p5j
	 cv0OCXInnB5lbUS7H/u8kmS4DcDmKRcNvLeDAXG+tCj+egY+ttLTKV6S7/Hy18/NZ6
	 eIoi04NxxhXGfuMem0THMkWaoFKzmOeQFTZSA6Melyqh94tfxyREaHq8+GaLMZdnOk
	 eMNsW319FUhDNnSJ8BOiE/Kw3dNoxFC6jU4M4By3f64Ikb34Y7P1PggtoFui3BsKf/
	 4ZiZ32adjM6hcrpW9WDQnu+rNk+0gWVc5BgVWk2ZJQ2OEpv3Y6oKaFzA4+vLAZh9Vs
	 cpMJSnzq6LZlA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:20:51 +0200
Subject: [PATCH RFC 06/28] fat: don't set SB_RDONLY after filesystem errors
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-6-60743a3dc326@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=18315; i=brauner@kernel.org;
 h=from:subject:message-id; bh=KuJEEFuAYfLbCKHgQghNWOlxgH9KI0vKPiB8pe0ymQM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TJp7uu/E/9nxZ877RHf6rzo75rSnusOq5ecPzUlL
 /LX9IZvuzpKWRjEuBhkxRRZHNpNwuWW81RsNsrUgJnDygQyhIGLUwAmclSCkWFzGcM1ZU9OyWud
 S9Y+fRaxaf2+6JVaNuWrHzP94pb/zfmDkeHFUr/87XcWsm8zdfldckfjwY81Sz2fH6vxqlVMXHi
 bNZMDAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

With errors=remount-ro, which is the default, __fat_fs_error() sets
SB_RDONLY. It does that without holding sb->s_umount and from whatever
context found the error.

freeze_super() and thaw_super() both look at sb_rdonly() to figure out
whether the s_writers rwsems need to be taken or released. So if the
error happens while the filesystem is frozen thaw_super() takes the
read-only shortcut, skips sb_freeze_unlock() and the rwsems stay
write-locked. Every writer after that blocks forever in sb_start_write()
and umount warns in rcu_sync_dtor().

FAT has no ->freeze_fs() so FIFREEZE refuses it. But bdev_freeze() still
freezes it, e.g. when device mapper suspends the device with lockfs.
That also holds new I/O so the error has to come from cached metadata.
A file whose directory entry has an invalid start cluster does the job.
stat() instantiates the inode without reading any data and reading the
file after the suspend fails in fat_get_cluster() before a bio is ever
submitted:

  FAT-fs (dm-0): error, fat_get_cluster: invalid start cluster (i_pos 4161, start 00000001)
  FAT-fs (dm-0): Filesystem has been set read-only

After the resume a create hangs:

  percpu_rwsem_wait+0x203/0x500
  mnt_want_write+0x28f/0x2f0
  lookup_open+0x135/0x1b20
  INFO: task s3_fsop:134 blocked for more than 30 seconds.

and umount warns:

  WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0x143/0x190, CPU#0: kworker/0:1/11
  Workqueue: events destroy_super_work
   percpu_free_rwsem+0x38/0xa0
   destroy_super_work+0x133/0x2f0

Follow what ext4 did in commit d3476f3dad4a ("ext4: don't set SB_RDONLY
after filesystem errors") and record the error in a new
FAT_FLAGS_EMERGENCY_RO bit instead. The bit is never cleared and FAT
refuses modifications with -EROFS itself while it is set. Directory
entries are added in fat_add_entries() and every FAT entry write and
cluster allocation goes through fatent.c so that's where most of the
checks live. unlink, rmdir and rename are refused before they touch any
directory entry, and setattr, opening for write, write_begin, O_DIRECT
writes and timestamp updates check the bit as well.

fat_set_state() and mark_fsinfo_dirty() now skip their writes in that
state just like they do for a read-only superblock. So the volume stays
marked dirty on disk.

fat_write_inode() refuses to write inodes back too. Note that writeback
clears the dirty state of an inode before it calls ->write_inode() and
doesn't redirty it when that fails. So fat_file_fsync() would happily
report success for an inode that never made it to disk. Let fsync() fail
with -EROFS instead. Like on ext4 an operation that completed shortly
before the error can end up half-applied on disk and needs fsck.fat.
FITRIM is refused as well. And eviction doesn't try to free fallocated
clusters past the end of a file anymore. That can't work in that state
and only logs a warning that asks to run fsck.

With the flush mount option msdos writes the inodes back through
fat_flush_inodes() after every create, unlink, rmdir and rename. If an
error hits after such an operation got past its check, from another
task or from msdos_rmdir() itself finding a bad link count on the
parent, that fails with -EROFS although the directory entries were
already changed. The VFS then keeps e.g. an unlinked name in the
dcache. So treat -EROFS as success there once the bit is set, like
ext2 does for dirsync.

A remount to read-write fails with -EROFS until umount. A remount to
read-only is allowed and doesn't mark the volume clean. Otherwise
emergency remount (sysrq u) would WARN in reconfigure_super(). The
comment above __fat_fs_error() promised that a filesystem made
read-only by an error can be made writable again by remounting it.
That's no longer true for errors after the mount.

Errors reported while the filesystem is still being mounted keep
setting SB_RDONLY. Until SB_BORN the mounter holds s_umount and nothing
can freeze the superblock, so that's fine. Such a mount still comes up
read-only and can be remounted read-write. Right now every
fat_fs_error() that fat_fill_super() can reach fails the mount anyway.

Like ext4 we show "emergency_ro" in the mount options. The mount itself
stays "rw" and writes through file descriptors opened before the error
now fail with -EROFS. Data pages dirtied before the error and stores
through shared mappings still reach blocks that are already allocated,
just like they did with SB_RDONLY. That includes mappings set up after
the error through a file descriptor that was opened for writing before
it.

Reproducer. FAT can only be frozen through a device mapper suspend,
which also holds I/O, so the error has to come from cached metadata:

  mkfs.vfat /dev/vdb
  dmsetup create f0 --table "0 $(blockdev --getsz /dev/vdb) linear /dev/vdb 0"
  mount /dev/mapper/f0 /mnt; echo hello > /mnt/BAD.TXT; umount /mnt
  # set BAD.TXT's start cluster (dir entry bytes 20 and 26) to 1
  mount /dev/mapper/f0 /mnt
  stat /mnt/BAD.TXT        # instantiates the inode, reads no data
  dmsetup suspend f0       # freeze_super(), takes the s_writers rwsems
  cat /mnt/BAD.TXT         # fat_get_cluster(): invalid start cluster -> SB_RDONLY
  dmsetup resume f0        # thaw_super() sees SB_RDONLY, skips sb_freeze_unlock()
  touch /mnt/x             # hangs in sb_start_write()
  # or umount: WARNING at kernel/rcu/sync.c:177 rcu_sync_dtor()

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fat/dir.c         |  3 +++
 fs/fat/fat.h         | 13 +++++++++++++
 fs/fat/fatent.c      | 11 ++++++++++-
 fs/fat/file.c        | 19 +++++++++++++++++++
 fs/fat/inode.c       | 26 ++++++++++++++++++++++++--
 fs/fat/misc.c        | 29 ++++++++++++++++++++++-------
 fs/fat/namei_msdos.c |  9 +++++++++
 fs/fat/namei_vfat.c  |  9 +++++++++
 8 files changed, 109 insertions(+), 10 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 35bdb62944a2..a6a870a2d471 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1329,6 +1329,9 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 	loff_t pos;
 	bool saw_eod;
 
+	if (unlikely(fat_emergency_ro(sb)))
+		return -EROFS;
+
 	sinfo->nr_slots = nr_slots;
 
 	/* First stage: search free directory entries */
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 61338413d9f3..b43cf9d8449f 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -28,6 +28,9 @@ struct file_kattr;
 #define FAT_NFS_STALE_RW	1      /* NFS RW support, can cause ESTALE */
 #define FAT_NFS_NOSTALE_RO	2      /* NFS RO support, no ESTALE issue */
 
+/* bits in msdos_sb_info->flags */
+#define FAT_FLAGS_EMERGENCY_RO	0      /* read-only after an error */
+
 struct fat_mount_options {
 	kuid_t fs_uid;
 	kgid_t fs_gid;
@@ -106,6 +109,7 @@ struct msdos_sb_info {
 	struct hlist_head dir_hashtable[FAT_HASH_SIZE];
 
 	unsigned int dirty;           /* fs state before mount */
+	unsigned long flags;	      /* FAT_FLAGS_* */
 	struct rcu_head rcu;
 };
 
@@ -149,6 +153,15 @@ static inline struct msdos_sb_info *MSDOS_SB(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
+/*
+ * An error with errors=remount-ro stopped all modifications until unmount.
+ * SB_RDONLY isn't used for that because it must not change without s_umount.
+ */
+static inline bool fat_emergency_ro(struct super_block *sb)
+{
+	return test_bit(FAT_FLAGS_EMERGENCY_RO, &MSDOS_SB(sb)->flags);
+}
+
 /*
  * Functions that determine the variant of the FAT file system (i.e.,
  * whether this is FAT12, FAT16 or FAT32.
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index f0801d99dd62..cad045772b48 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -314,7 +314,7 @@ static void mark_fsinfo_dirty(struct super_block *sb)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
-	if (sb_rdonly(sb) || !is_fat32(sbi))
+	if (sb_rdonly(sb) || fat_emergency_ro(sb) || !is_fat32(sbi))
 		return;
 
 	__mark_inode_dirty(sbi->fsinfo_inode, I_DIRTY_SYNC);
@@ -419,6 +419,9 @@ int fat_ent_write(struct inode *inode, struct fat_entry *fatent,
 	const struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
 	int err;
 
+	if (unlikely(fat_emergency_ro(sb)))
+		return -EROFS;
+
 	ops->ent_put(fatent, new);
 	if (wait) {
 		err = fat_sync_bhs(fatent->bhs, fatent->nr_bhs);
@@ -479,6 +482,9 @@ int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 
 	BUG_ON(nr_cluster > (MAX_BUF_PER_PAGE / 2));	/* fixed limit */
 
+	if (unlikely(fat_emergency_ro(sb)))
+		return -EROFS;
+
 	lock_fat(sbi);
 	if (sbi->free_clusters != -1 && sbi->free_clus_valid &&
 	    sbi->free_clusters < nr_cluster) {
@@ -566,6 +572,9 @@ int fat_free_clusters(struct inode *inode, int cluster)
 	int i, err, nr_bhs;
 	int first_cl = cluster, dirty_fsinfo = 0;
 
+	if (unlikely(fat_emergency_ro(sb)))
+		return -EROFS;
+
 	nr_bhs = 0;
 	fatent_init(&fatent);
 	lock_fat(sbi);
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 1c835ca5f21a..320f018961e3 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -135,6 +135,10 @@ static int fat_ioctl_fitrim(struct inode *inode, unsigned long arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/* Don't trust the FAT after an error. */
+	if (unlikely(fat_emergency_ro(sb)))
+		return -EROFS;
+
 	if (!bdev_max_discard_sectors(sb->s_bdev))
 		return -EOPNOTSUPP;
 
@@ -173,6 +177,13 @@ long fat_generic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 }
 
+static int fat_file_open(struct inode *inode, struct file *filp)
+{
+	if ((filp->f_mode & FMODE_WRITE) && fat_emergency_ro(inode->i_sb))
+		return -EROFS;
+	return 0;
+}
+
 static int fat_file_release(struct inode *inode, struct file *filp)
 {
 	if ((filp->f_mode & FMODE_WRITE) &&
@@ -190,6 +201,10 @@ int fat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 	struct inode *fat_inode = MSDOS_SB(inode->i_sb)->fat_inode;
 	int err;
 
+	/* Inodes aren't written back after an error. */
+	if (unlikely(fat_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	err = simple_fsync_noflush(filp, start, end, datasync);
 	if (err)
 		return err;
@@ -207,6 +222,7 @@ const struct file_operations fat_file_operations = {
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
+	.open		= fat_file_open,
 	.release	= fat_file_release,
 	.unlocked_ioctl	= fat_generic_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
@@ -522,6 +538,9 @@ int fat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	unsigned int ia_valid;
 	int error;
 
+	if (unlikely(fat_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	/* Check for setting the inode time. */
 	ia_valid = attr->ia_valid;
 	if (ia_valid & TIMES_SET_FLAGS) {
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index f775a004cae1..1751983fd8c3 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -227,6 +227,9 @@ static int fat_write_begin(const struct kiocb *iocb,
 {
 	int err;
 
+	if (unlikely(fat_emergency_ro(mapping->host->i_sb)))
+		return -EROFS;
+
 	err = cont_write_begin(iocb, mapping, pos, len,
 				foliop, fsdata, fat_get_block,
 				&MSDOS_I(mapping->host)->mmu_private);
@@ -263,6 +266,8 @@ static ssize_t fat_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	ssize_t ret;
 
 	if (iov_iter_rw(iter) == WRITE) {
+		if (unlikely(fat_emergency_ro(inode->i_sb)))
+			return -EROFS;
 		/*
 		 * FIXME: blockdev_direct_IO() doesn't use ->write_begin(),
 		 * so we need to update the ->mmu_private to block boundary.
@@ -661,6 +666,10 @@ static int fat_sync_inode_metadata(struct inode *inode,
 
 static void fat_free_eofblocks(struct inode *inode)
 {
+	/* Nothing can be freed after an error. */
+	if (fat_emergency_ro(inode->i_sb))
+		return;
+
 	/* Release unwritten fallocated blocks on inode eviction. */
 	if ((inode->i_blocks << 9) >
 			round_up(MSDOS_I(inode)->mmu_private,
@@ -709,8 +718,11 @@ static void fat_set_state(struct super_block *sb,
 	struct fat_boot_sector *b;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
-	/* do not change any thing if mounted read only */
-	if (sb_rdonly(sb) && !force)
+	/*
+	 * do not change any thing if mounted read only, or after an error
+	 * stopped modifications: the volume stays marked dirty then
+	 */
+	if ((sb_rdonly(sb) && !force) || fat_emergency_ro(sb))
 		return;
 
 	/* do not change state if fs was dirty */
@@ -856,6 +868,8 @@ int fat_reconfigure(struct fs_context *fc)
 	if (new_rdonly != sb_rdonly(sb)) {
 		if (new_rdonly)
 			fat_set_state(sb, 0, 0);
+		else if (fat_emergency_ro(sb))
+			return -EROFS;
 		else
 			fat_set_state(sb, 1, 1);
 	}
@@ -953,6 +967,9 @@ static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int err;
 
+	if (unlikely(fat_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	if (inode->i_ino == MSDOS_FSINFO_INO) {
 		struct super_block *sb = inode->i_sb;
 
@@ -1065,6 +1082,8 @@ static int fat_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",discard");
 	if (opts->dos1xfloppy)
 		seq_puts(m, ",dos1xfloppy");
+	if (fat_emergency_ro(root->d_sb))
+		seq_puts(m, ",emergency_ro");
 
 	return 0;
 }
@@ -1938,6 +1957,9 @@ int fat_flush_inodes(struct super_block *sb, struct inode *i1, struct inode *i2)
 		ret = writeback_inode(i2);
 	if (!ret)
 		ret = sync_blockdev_nowait(sb->s_bdev);
+	/* The change is done, an error made us read-only in the meantime. */
+	if (ret == -EROFS && fat_emergency_ro(sb))
+		ret = 0;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(fat_flush_inodes);
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index e79762cf1975..ecba57df83ca 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -14,13 +14,14 @@
  * fat_fs_error reports a file system problem that might indicate fa data
  * corruption/inconsistency. Depending on 'errors' mount option the
  * panic() is called, or error message is printed FAT and nothing is done,
- * or filesystem is remounted read-only (default behavior).
- * In case the file system is remounted read-only, it can be made writable
- * again by remounting it.
+ * or the filesystem is made read-only (default behavior): a mount in
+ * progress comes up read-only, a mounted filesystem refuses all further
+ * modifications until it is unmounted.
  */
 void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 {
-	struct fat_mount_options *opts = &MSDOS_SB(sb)->options;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct fat_mount_options *opts = &sbi->options;
 	va_list args;
 	struct va_format vaf;
 
@@ -32,10 +33,22 @@ void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 		va_end(args);
 	}
 
-	if (opts->errors == FAT_ERRORS_PANIC)
+	if (opts->errors == FAT_ERRORS_PANIC) {
 		panic("FAT-fs (%s): fs panic from previous error\n", sb->s_id);
-	else if (opts->errors == FAT_ERRORS_RO && !sb_rdonly(sb)) {
-		sb->s_flags |= SB_RDONLY;
+	} else if (opts->errors == FAT_ERRORS_RO && !sb_rdonly(sb)) {
+		/*
+		 * Only a mount in progress may still set SB_RDONLY: the
+		 * mounter holds s_umount and nothing can freeze the superblock
+		 * before SB_BORN. Later, setting it without s_umount on a
+		 * frozen superblock makes thaw_super() mark it unfrozen but
+		 * skip sb_freeze_unlock(), so the s_writers rwsems stay
+		 * write-locked and every writer hangs. Refuse modifications
+		 * until umount instead.
+		 */
+		if (!(sb->s_flags & SB_BORN))
+			sb->s_flags |= SB_RDONLY;
+		else if (test_and_set_bit(FAT_FLAGS_EMERGENCY_RO, &sbi->flags))
+			return;
 		fat_msg(sb, KERN_ERR, "Filesystem has been set read-only");
 	}
 }
@@ -342,6 +355,8 @@ EXPORT_SYMBOL_GPL(fat_truncate_time);
 int fat_update_time(struct inode *inode, enum fs_update_time type,
 		unsigned int flags)
 {
+	if (unlikely(fat_emergency_ro(inode->i_sb)))
+		return -EROFS;
 	if (inode->i_ino != MSDOS_ROOT_INO) {
 		fat_truncate_time(inode, NULL, type == FS_UPD_ATIME ?
 				FAT_UPDATE_ATIME : FAT_UPDATE_CMTIME);
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index d46d1a3851f2..459fc4c8f3f2 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -316,6 +316,9 @@ static int msdos_rmdir(struct inode *dir, struct dentry *dentry)
 	struct fat_slot_info sinfo;
 	int err;
 
+	if (unlikely(fat_emergency_ro(sb)))
+		return -EROFS;
+
 	mutex_lock(&MSDOS_SB(sb)->s_lock);
 	err = fat_dir_empty(inode);
 	if (err)
@@ -412,6 +415,9 @@ static int msdos_unlink(struct inode *dir, struct dentry *dentry)
 	struct fat_slot_info sinfo;
 	int err;
 
+	if (unlikely(fat_emergency_ro(sb)))
+		return -EROFS;
+
 	mutex_lock(&MSDOS_SB(sb)->s_lock);
 	err = msdos_find(dir, dentry->d_name.name, dentry->d_name.len, &sinfo);
 	if (err)
@@ -612,6 +618,9 @@ static int msdos_rename(struct mnt_idmap *idmap,
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
 
+	if (unlikely(fat_emergency_ro(sb)))
+		return -EROFS;
+
 	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = msdos_format_name(old_dentry->d_name.name,
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index da3e89c0b16a..73f7f11b0590 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -791,6 +791,9 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
 	struct fat_slot_info sinfo;
 	int err;
 
+	if (unlikely(fat_emergency_ro(sb)))
+		return -EROFS;
+
 	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = fat_dir_empty(inode);
@@ -827,6 +830,9 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 	struct fat_slot_info sinfo;
 	int err;
 
+	if (unlikely(fat_emergency_ro(sb)))
+		return -EROFS;
+
 	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = vfat_find(dir, &dentry->d_name, &sinfo);
@@ -1167,6 +1173,9 @@ static int vfat_rename2(struct mnt_idmap *idmap, struct inode *old_dir,
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
+	if (unlikely(fat_emergency_ro(old_dir->i_sb)))
+		return -EROFS;
+
 	if (flags & RENAME_EXCHANGE) {
 		return vfat_rename_exchange(old_dir, old_dentry,
 					    new_dir, new_dentry);

-- 
2.53.0

