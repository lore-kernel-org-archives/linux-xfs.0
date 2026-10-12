Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B53E4189C2;
	Mon, 12 Oct 2026 10:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800526; cv=none; b=n8KksxrrxYUZG2C94D27p/C3VqCq0Q8Sf40D0dbwXbHNdbdR7OdfUxbA/zMejcrmRatAKd4NNffraUarGLuC4L8Am7lmezFv0HH0UXONGWjHnC9izDuxiyuKrMK5O8P4wnLeQvW6f7/bsUJ8aoKUb5bw2EiezpGQecYVzPSvAUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800526; c=relaxed/simple;
	bh=u4HeeHJIGSj27nhP3yoa+GGbPXodMSKyu6h1QE2ScZo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i/FIlmMtmz7KCd9l709vv+vciKqmNIiroqTDf+PwifMaj3Snab1lT2OJf+LZ/ksnEC3h/WJPgaHVpTgucXYjQscldXdPgDzbokN+0wMnQN4GeGxvsaUC/X6Yv4o5SYQO/twMIyDRHn3/WX8k/WLIG0MIArVbhN1JPo0aS7RMW8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HimUS9xa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HimUS9xa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D9E1F008A0;
	Mon, 12 Oct 2026 10:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800511;
	bh=bPxhIxwhG7b7Gx6k+wiB4+/VccXTttf5zuadbuljA3s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HimUS9xaungARSBGdWvRNDXTzwbEODrxPk/9O5bYR8xkuuEEHLVP0iKsQRqXCHDzA
	 cKJ+1hfxcrFcqaRhG295HlB3+NrZWgYfZhqidjowrIuJEaU4lokyTeoIznOQcpFZeP
	 muAKoFdt+4XqZAIIhS79frP4umyfwJUNHX9yw/AGH0mRX65ohIp4aggOEcKRlIvOJM
	 2vb4G7MPXQ1Sz47zez70tYI7C1Gfg9LZXBOD9uDUYruWuI+1UjhNC7wUqhZfUqQ9jG
	 a2Vt2Ei/FJ/W3tXbDrVhW6z8SMlnDKxGWtmlb2s2xPeofbIj6g0dFUYiVs7hO3u7m5
	 jXAZOIQ3ixPJQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:20:54 +0200
Subject: [PATCH RFC 09/28] hfs: don't set SB_RDONLY after MDB write errors
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-9-60743a3dc326@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=14255; i=brauner@kernel.org;
 h=from:subject:message-id; bh=u4HeeHJIGSj27nhP3yoa+GGbPXodMSKyu6h1QE2ScZo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TJ5fVjRkeLbduIcJS8u+EpYtPJftGa91f2K13D2/
 e6jGrE8HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPR5WNk2OGS9nLb6m+t/he1
 96zpyn7v/MvlyseQf48Xu5dU738o/JaR4V/1lq3ah04+OHOlUnbKFkV7ndtVu9O2LLzEJfzYx6Z
 RhQ8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Since commit fdbb95ff89b2 ("hfs: don't re-dirty MDB buffers after a
write failure") hfs_mdb_commit() sets SB_RDONLY when the MDB or the
alternate MDB buffer lost BH_Uptodate after a failed write.
hfs_mdb_commit() runs from the flush_mdb work without holding
sb->s_umount and from ->sync_fs(), e.g. for sync(2) which only holds
s_umount shared. Neither may change SB_RDONLY.

freeze_super() decides from sb_rdonly() whether to take the s_writers
rwsems and then drops s_umount while it waits for writers in
sb_wait_write(SB_FREEZE_WRITE). A sync(2) in that window gets to
hfs_mdb_commit() which flips SB_RDONLY. sync_filesystem() in
freeze_super() then returns early for the now read-only superblock, the
freeze completes with all three rwsems held and thaw_super() sees
sb_rdonly() and skips sb_freeze_unlock(). So the rwsems stay
write-locked on a superblock that is marked unfrozen. The commit from
sync(2) reports:

  hfs: primary MDB is corrupt, mounting read-only

and after the thaw writers block forever and umount warns:

  INFO: task s3_fsop:162 blocked for more than 30 seconds.
  WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0x143/0x190

hfs has no ->freeze_fs() so this needs bdev_freeze(), e.g. through a
device mapper suspend with lockfs.

Follow what ext4 did in commit d3476f3dad4a ("ext4: don't set SB_RDONLY
after filesystem errors") and record the condition in a new
HFS_FLG_EMERGENCY_RO bit next to the MDB and bitmap dirty bits instead.
The bit is never cleared. The messages and the -EIO from the call that
detects the problem stay as they are. Later calls to hfs_mdb_commit()
return 0 early exactly like they did for sb_rdonly(), so syncs and
freezes keep working after the error. And the MDB is never marked
cleanly unmounted after the error.

hfs now refuses modifications with -EROFS itself. That's the namespace
operations, setattr, the hfs.type and hfs.creator xattrs, opening for
write, write_begin, O_DIRECT writes and block allocation for files in
hfs_get_block(). hfs_file_truncate() returns early too. It runs from
->release() on the last close and frees preallocated blocks without any
freeze protection.

Note that b-tree growth through hfs_bmap_reserve() isn't refused. A read
that needs another extent record first writes back the cached one. If
that record was created before the error inserting it can need a new
b-tree node and refusing that would make such reads fail with -EIO until
umount.

hfs_write_inode() refuses to write inodes back as well. Writeback clears
the dirty state of an inode before it calls ->write_inode() and doesn't
redirty it when that fails. So fsync() would happily report success for
an inode that never made it to disk. Let fsync() fail with -EROFS
instead. Like on ext4 an operation that completed shortly before the
error can end up half-applied on disk and needs fsck.hfs.

Only the headers of the extents and catalog b-trees are still written.
Writeback writes the b-tree nodes anyway and a node that gets allocated
after the error, e.g. by a read that writes back a cached extent
record, needs a header that knows about it. Otherwise the next mount
starts from a stale root and misses records.

A remount to read-write fails with -EROFS until umount and a remount to
read-only is allowed. Like ext4 we show "emergency_ro" in the mount
options. The mount stays "rw" and writes through file descriptors opened
before the error now fail with -EROFS.

Reproducer. The writer parked in sb_start_write() keeps freeze_super()
in sb_wait_write() with s_umount dropped while sync(2) runs:

  hformat /dev/vdb; N=$(blockdev --getsz /dev/vdb)
  dmsetup create h0 --table "0 $N linear /dev/vdb 0"
  mount -t hfs /dev/mapper/h0 /mnt; echo a > /mnt/f; sync
  printf '0 2 linear /dev/vdb 0\n2 1 error\n3 %d linear /dev/vdb 3\n' $((N-3)) |
          dmsetup load h0             # fail writes to the MDB sector
  dmsetup suspend --nolockfs h0; dmsetup resume h0
  echo b > /mnt/h; sleep 6         # flush_mdb: MDB write fails, mdb_bh !uptodate
  sync /mnt/f                      # fsync(): consumes the bdev mapping's AS_EIO
  <writer: splice() from an empty pipe into /mnt/f>   # parked in sb_start_write()
  dmsetup suspend h0 &             # freeze_super() waits for the writer
  sync                             # hfs_mdb_commit(): "primary MDB is corrupt" -> SB_RDONLY
  <feed the pipe>                  # freeze completes, sync_filesystem() skipped
  dmsetup resume h0                # thaw_super() skips sb_freeze_unlock()
  touch /mnt/x                     # hangs in sb_start_write()

Fixes: fdbb95ff89b2 ("hfs: don't re-dirty MDB buffers after a write failure")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/hfs/attr.c   |  3 +++
 fs/hfs/dir.c    | 12 ++++++++++++
 fs/hfs/extent.c |  5 +++++
 fs/hfs/hfs_fs.h | 11 +++++++++++
 fs/hfs/inode.c  | 30 ++++++++++++++++++++++++++++++
 fs/hfs/mdb.c    | 18 ++++++++++++------
 fs/hfs/super.c  |  7 ++++++-
 7 files changed, 79 insertions(+), 7 deletions(-)

diff --git a/fs/hfs/attr.c b/fs/hfs/attr.c
index f8395cdd1adf..d7f8353322c8 100644
--- a/fs/hfs/attr.c
+++ b/fs/hfs/attr.c
@@ -129,6 +129,9 @@ static int hfs_xattr_set(const struct xattr_handler *handler,
 	if (!value)
 		return -EOPNOTSUPP;
 
+	if (unlikely(hfs_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	return __hfs_setxattr(inode, handler->flags, value, size, flags);
 }
 
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index e1f1fb351464..e7ed6e829b77 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -189,6 +189,9 @@ static int hfs_create(struct mnt_idmap *idmap, struct inode *dir,
 	struct inode *inode;
 	int res;
 
+	if (unlikely(hfs_emergency_ro(dir->i_sb)))
+		return -EROFS;
+
 	inode = hfs_new_inode(dir, &dentry->d_name, mode);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
@@ -219,6 +222,9 @@ static struct dentry *hfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	struct inode *inode;
 	int res;
 
+	if (unlikely(hfs_emergency_ro(dir->i_sb)))
+		return ERR_PTR(-EROFS);
+
 	inode = hfs_new_inode(dir, &dentry->d_name, mode);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
@@ -252,6 +258,9 @@ static int hfs_remove(struct inode *dir, struct dentry *dentry)
 	struct inode *inode = d_inode(dentry);
 	int res;
 
+	if (unlikely(hfs_emergency_ro(sb)))
+		return -EROFS;
+
 	if (S_ISDIR(inode->i_mode) && inode->i_size != 2)
 		return -ENOTEMPTY;
 
@@ -290,6 +299,9 @@ static int hfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
 
+	if (unlikely(hfs_emergency_ro(old_dir->i_sb)))
+		return -EROFS;
+
 	/* Unlink destination if it already exists */
 	if (d_really_is_positive(new_dentry)) {
 		res = hfs_remove(new_dir, new_dentry);
diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
index f066a99a863b..dab31f159b1a 100644
--- a/fs/hfs/extent.c
+++ b/fs/hfs/extent.c
@@ -350,6 +350,9 @@ int hfs_get_block(struct inode *inode, sector_t block,
 		if (block > HFS_I(inode)->fs_blocks)
 			return -EIO;
 		if (ablock >= HFS_I(inode)->alloc_blocks) {
+			/* No new allocations after an error. */
+			if (unlikely(hfs_emergency_ro(sb)))
+				return -EROFS;
 			res = hfs_extend_file(inode);
 			if (res)
 				return res;
@@ -485,6 +488,8 @@ void hfs_file_truncate(struct inode *inode)
 	hfs_dbg("ino %llu, phys_size %llu -> i_size %llu\n",
 		inode->i_ino, (long long)HFS_I(inode)->phys_size,
 		inode->i_size);
+	if (unlikely(hfs_emergency_ro(sb)))
+		return;
 	if (inode->i_size > HFS_I(inode)->phys_size) {
 		struct address_space *mapping = inode->i_mapping;
 		void *fsdata = NULL;
diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index e250f87a5e33..71ab81b649bc 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -143,6 +143,7 @@ struct hfs_sb_info {
 #define HFS_FLG_BITMAP_DIRTY	0
 #define HFS_FLG_MDB_DIRTY	1
 #define HFS_FLG_ALT_MDB_DIRTY	2
+#define HFS_FLG_EMERGENCY_RO	3	/* read-only after an MDB write error */
 
 /* bitmap.c */
 extern u32 hfs_vbm_search_free(struct super_block *sb, u32 goal, u32 *num_bits);
@@ -293,6 +294,16 @@ static inline const char *hfs_mdb_name(struct super_block *sb)
 	return sb->s_id;
 }
 
+/*
+ * Writing back the MDB failed and the filesystem stopped all modifications
+ * until unmount. SB_RDONLY isn't used for that because it must not change
+ * without s_umount.
+ */
+static inline bool hfs_emergency_ro(struct super_block *sb)
+{
+	return test_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
+}
+
 static inline void hfs_bitmap_dirty(struct super_block *sb)
 {
 	set_bit(HFS_FLG_BITMAP_DIRTY, &HFS_SB(sb)->flags);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 2aef3c36a150..42a2c2e390b2 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -54,6 +54,9 @@ int hfs_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 	loff_t total_capacity;
 	int ret;
 
+	if (unlikely(hfs_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	total_capacity = (loff_t)sbi->fs_ablocks * sbi->alloc_blksz;
 
 	if (pos >= total_capacity)
@@ -139,6 +142,10 @@ static ssize_t hfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
+	if (iov_iter_rw(iter) == WRITE &&
+	    unlikely(hfs_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	ret = blockdev_direct_IO(iocb, inode, iter, hfs_get_block);
 
 	/*
@@ -472,6 +479,20 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	int res;
 
 	hfs_dbg("ino %llu\n", inode->i_ino);
+	if (unlikely(hfs_emergency_ro(inode->i_sb))) {
+		/*
+		 * Writeback still writes the b-tree nodes. Keep the headers in
+		 * sync with them so the trees on disk stay intact.
+		 */
+		if (inode->i_ino == HFS_EXT_CNID)
+			hfs_btree_write(HFS_SB(inode->i_sb)->ext_tree);
+		else if (inode->i_ino == HFS_CAT_CNID)
+			hfs_btree_write(HFS_SB(inode->i_sb)->cat_tree);
+		else
+			return -EROFS;
+		return 0;
+	}
+
 	res = hfs_ext_write_extent(inode);
 	if (res)
 		return res;
@@ -619,6 +640,8 @@ void hfs_evict_inode(struct inode *inode)
 
 static int hfs_file_open(struct inode *inode, struct file *file)
 {
+	if ((file->f_mode & FMODE_WRITE) && hfs_emergency_ro(inode->i_sb))
+		return -EROFS;
 	if (HFS_IS_RSRC(inode))
 		inode = HFS_I(inode)->rsrc_inode;
 	atomic_inc(&HFS_I(inode)->opencnt);
@@ -650,6 +673,9 @@ int hfs_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct hfs_sb_info *hsb = HFS_SB(inode->i_sb);
 	int error;
 
+	if (unlikely(hfs_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	error = setattr_prepare(&nop_mnt_idmap, dentry, attr);
 	if (error)
 		return error;
@@ -701,6 +727,10 @@ static int hfs_file_fsync(struct file *filp, loff_t start, loff_t end,
 	struct super_block * sb;
 	int ret, err;
 
+	/* Inodes aren't written back after an error. */
+	if (unlikely(hfs_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	ret = file_write_and_wait_range(filp, start, end);
 	if (ret)
 		return ret;
diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index 277de712f9d4..ce20824bbdc8 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -322,8 +322,8 @@ int hfs_mdb_get(struct super_block *sb)
  *   NONE
  * Returns:
  *   0 on success, -EIO if the MDB or alternate MDB buffer is no longer
- *   valid (e.g. after a prior write error), in which case the volume is
- *   remounted read-only.
+ *   valid (e.g. after a prior write error), in which case the volume
+ *   refuses all further modifications until it is unmounted.
  * Preconditions:
  *   'mdb' points to a "valid" (struct hfs_mdb).
  * Postconditions:
@@ -338,12 +338,18 @@ int hfs_mdb_commit(struct super_block *sb)
 	struct hfs_mdb *mdb = HFS_SB(sb)->mdb;
 	int ret = 0;
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
 		return 0;
 
+	/*
+	 * Don't set SB_RDONLY on errors: changing it requires s_umount and a
+	 * remount. Setting it on a frozen superblock makes thaw_super() mark
+	 * it unfrozen but skip sb_freeze_unlock(), so the s_writers rwsems
+	 * stay write-locked and every writer hangs.
+	 */
 	if (!buffer_uptodate(HFS_SB(sb)->mdb_bh)) {
 		pr_err("primary MDB is corrupt, mounting read-only\n");
-		sb->s_flags |= SB_RDONLY;
+		set_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
 		return -EIO;
 	}
 
@@ -377,7 +383,7 @@ int hfs_mdb_commit(struct super_block *sb)
 	    HFS_SB(sb)->alt_mdb) {
 		if (!buffer_uptodate(HFS_SB(sb)->alt_mdb_bh)) {
 			pr_err("alternate MDB is corrupt, mounting read-only\n");
-			sb->s_flags |= SB_RDONLY;
+			set_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
 			ret = -EIO;
 			goto out;
 		}
@@ -428,7 +434,7 @@ int hfs_mdb_commit(struct super_block *sb)
 void hfs_mdb_close(struct super_block *sb)
 {
 	/* update volume attributes */
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
 		return;
 
 	if (!buffer_uptodate(HFS_SB(sb)->mdb_bh))
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 5e6d66ff4bee..0f2c5ab0caf7 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -82,7 +82,7 @@ void hfs_mark_mdb_dirty(struct super_block *sb)
 	struct hfs_sb_info *sbi = HFS_SB(sb);
 	unsigned long delay;
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
 		return;
 
 	spin_lock(&sbi->work_lock);
@@ -131,6 +131,9 @@ static int hfs_reconfigure(struct fs_context *fc)
 		return 0;
 
 	if (!(fc->sb_flags & SB_RDONLY)) {
+		/* After an MDB write error it stays read-only until unmount. */
+		if (hfs_emergency_ro(sb))
+			return -EROFS;
 		if (!(HFS_SB(sb)->mdb->drAtrb & cpu_to_be16(HFS_SB_ATTRIB_UNMNT))) {
 			pr_warn("filesystem was not cleanly unmounted, running fsck.hfs is recommended.  leaving read-only.\n");
 			sb->s_flags |= SB_RDONLY;
@@ -169,6 +172,8 @@ static int hfs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_printf(seq, ",iocharset=%s", sbi->nls_io->charset);
 	if (sbi->s_quiet)
 		seq_printf(seq, ",quiet");
+	if (hfs_emergency_ro(root->d_sb))
+		seq_puts(seq, ",emergency_ro");
 	return 0;
 }
 

-- 
2.53.0

