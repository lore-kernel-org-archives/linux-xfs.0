Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBB53EEAE5;
	Mon, 12 Oct 2026 10:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800509; cv=none; b=uA/wJz6Rep5Qp97mH5jWQznCd1qvxPAiEQ0S2sLJ2qaQcKD6Lcf+0ox8lXRDfsnNggSftZzWC4Vu7KOIgzfi9XLXOXN67WR3iW0noBqFwKb7mKcVEPGI4dq+59tfgNPC4NYyu128ufhKuhlrbEmFpRf9KdzU4ywIXRECUaIA/Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800509; c=relaxed/simple;
	bh=/QgNABNKFzI5BqiYYHeDq4XWuR2eeF0uHcBhOU2qIYo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Sa7JYBF9ZvVXTv8XTfe/KTQFLRdFXYC7YVIb7sD48N+AIcRvKp8CjYxiW8J8XKn6NvFOo6rOhHlGQbvsjMm2jhEUWlINtW9oyU10vsilgFBhQFdB1x+nSPMi9MSZQP46qZysU8JAtozhMVTz459O/Vtjw76wvPAcc7kgLW5m6Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GO6WXF5a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GO6WXF5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5406B1F0089C;
	Mon, 12 Oct 2026 10:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800495;
	bh=fB4wonqg/6FYI6FCX3biZXNURAZGn3ZOc8QTfenvMKU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GO6WXF5atc77rYr0YYF59cZEdjDUeUMCmm2k7EITq4umzIf17da81ibIWp1MN/H9f
	 MbMF73GPXkfu1RB37u7Ws4qUaYwbu2jRlKlpOkQ+4CBmIRpd8/B5WJ/hD3njQ2Bdfg
	 WCyXOai6xEOyIapzfeLKyLxSY09iN1K8sDcfy+6UsIe705fVfMoGRdsO9F3q9EJ5eN
	 QqaVINVGhdbvzWtk0dwMnDqPv3li+vMNAvPC7tf/sok9nnRnvG6HM1J/fCy5/LP3ZD
	 tjZqfy7NI2Y4pXM1O21aRP/l050tbJ53VZmel5jJWJtCmqLdaRfrZ2m5ubx/q8dM86
	 FmEckanzxQAoA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:20:50 +0200
Subject: [PATCH RFC 05/28] nilfs2: don't set SB_RDONLY after filesystem
 errors
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-5-60743a3dc326@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=19251; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/QgNABNKFzI5BqiYYHeDq4XWuR2eeF0uHcBhOU2qIYo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TLJrGaZtP0f65vtJ/7GBDHeCZ575GdG06Ttu1ss8
 31UFGe96ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIqxUjw+3WzKfPX0rs9Yg/
 75xRdnd3U9VqhzWcP4tyciS3fosT38vIMP3ApOhPtw/rGASmLpC9Pf9tmfefyLmXyhtX1/YvyY9
 NYQUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

__nilfs_error() sets SB_RDONLY with errors=remount-ro, the nilfs2
default. That happens without holding sb->s_umount and from any context,
also while the filesystem is frozen. FIFREEZE doesn't block reads and a
lookup in a corrupted directory gets there:

  NILFS error (device vda): nilfs_check_folio: bad entry in directory #11: rec_len is smaller than minimal - offset=32, inode=17, rec_len=0, name_len=16
  Remounting filesystem read-only

freeze_super() and thaw_super() both look at sb_rdonly() to figure out
whether the s_writers rwsems need to be taken or released. So the thaw
after such an error skips ->unfreeze_fs() and sb_freeze_unlock() and
leaves all three rwsems write-locked on a superblock that is marked
unfrozen. Writers hang in sb_start_write() and umount warns when the
rwsems are freed:

  WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0x143/0x190, CPU#3: kworker/3:1/54
  WARNING: kernel/rcu/sync.c:180 at rcu_sync_dtor+0x14c/0x190
  WARNING: kernel/rcu/sync.c:188 at rcu_sync_dtor+0x13d/0x190

nilfs2 already treats a runtime SB_RDONLY as "degraded to read-only
because of corruption" in a lot of places. nilfs_writepages() and
nilfs_mdt_write_folio() discard dirty pages, nilfs_evict_inode() skips
the deletion, the segment constructor returns -EROFS and a few
WARN_ONCE()s accept it. That can all stay as it is. Only what triggers
it changes. Like ext4 did in commit d3476f3dad4a ("ext4: don't set
SB_RDONLY after filesystem errors") record the error in a new
THE_NILFS_EMERGENCY_RO bit and add nilfs_sb_rdonly() which is true for
a read-only mount and for the emergency state. Then use that for every
sb_rdonly() check that guards a write.

The VFS won't refuse anything for us anymore so nilfs2 has to do that
itself. nilfs_permission() returns -EROFS for MAY_WRITE in that state,
the same way sb_permission() does for a read-only superblock and the
same way nilfs2 already handles snapshots. That takes care of most
operations. setattr, write_iter and fileattr_set check the bit as well.
Symlinks didn't have a ->setattr so far and get nilfs_setattr() for
that. page_mkwrite fails with VM_FAULT_SIGBUS, the modifying ioctls go
through a new nilfs_mnt_want_write_file() and FITRIM is refused.
nilfs_sync_fs() writes neither a segment nor the superblock anymore.

A remount to read-write fails with -EROFS. Note that nilfs2 explicitly
supported "mount -o remount,rw" after __nilfs_error() so far.
nilfs_attach_log_writer() reuses the existing log writer for exactly
that case. Now the state lasts until umount like on ext4 and the comment
there is updated. A remount to read-only still sets SB_RDONLY but skips
nilfs_cleanup_super() so the superblock isn't written.

Like ext4 we show "emergency_ro" in the mount options. The mount stays
"rw". Writes through file descriptors opened before the error now fail
with -EROFS instead of being accepted and silently dropped by
nilfs_writepages(). Stores through shared mappings set up before the
error get SIGBUS once they fault. Stores to pages that were already
dirty don't fault until nilfs_writepages() discarded the page so those
are still dropped.

While the current tree is mounted a second mount of the device has to
match the read-only state of the superblock. So a read-only mount now
fails with -EBUSY and a read-write mount shares the superblock. If only
snapshot mounts keep the superblock alive a new mount reconfigures it
instead. Then a read-only mount makes it read-only and a read-write
mount after that fails with -EROFS. And a non-forced remount to
read-only fails with -EBUSY while files are still open for writing.

Reproducer (the sb_rdonly selftest at the end of this series covers it
as well):

  truncate -s 512M img; mkfs.nilfs2 -q img
  mount -o loop img /mnt           # errors=remount-ro is the default
  mkdir /mnt/d; touch /mnt/d/marker0123456789; sync
  touch /mnt/z; sync               # keep d's block out of the last log, the
  umount /mnt                      # only one checksummed at mount
  off=$(grep -obUa marker0123456789 img | head -1 | cut -d: -f1)
  printf '\0\0' | dd of=img bs=1 seek=$((off - 4)) conv=notrunc   # rec_len := 0
  mount -o loop img /mnt
  fsfreeze -f /mnt; ls /mnt/d; fsfreeze -u /mnt
  touch /mnt/x     # blocks forever in sb_start_write()
  # or umount instead: rcu_sync_dtor() warns three times

Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/nilfs2/file.c      | 15 ++++++++++++++-
 fs/nilfs2/inode.c     | 13 +++++++++++--
 fs/nilfs2/ioctl.c     | 36 ++++++++++++++++++++++++++++++------
 fs/nilfs2/mdt.c       |  2 +-
 fs/nilfs2/namei.c     |  1 +
 fs/nilfs2/page.c      |  2 +-
 fs/nilfs2/segment.c   | 13 ++++++-------
 fs/nilfs2/sufile.h    |  2 +-
 fs/nilfs2/super.c     | 35 ++++++++++++++++++++++++++++-------
 fs/nilfs2/the_nilfs.h |  8 ++++++++
 10 files changed, 101 insertions(+), 26 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index f93b68c4877c..17d5e932dba5 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -54,6 +54,8 @@ static vm_fault_t nilfs_page_mkwrite(struct vm_fault *vmf)
 
 	if (unlikely(nilfs_near_disk_full(inode->i_sb->s_fs_info)))
 		return VM_FAULT_SIGBUS; /* -ENOSPC */
+	if (unlikely(nilfs_emergency_ro(inode->i_sb->s_fs_info)))
+		return VM_FAULT_SIGBUS; /* -EROFS */
 
 	sb_start_pagefault(inode->i_sb);
 	folio_lock(folio);
@@ -133,6 +135,17 @@ static int nilfs_file_mmap_prepare(struct vm_area_desc *desc)
 	return 0;
 }
 
+static ssize_t nilfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	/* refuse before file_update_time() touches the inode */
+	if (unlikely(nilfs_emergency_ro(inode->i_sb->s_fs_info)))
+		return -EROFS;
+
+	return generic_file_write_iter(iocb, from);
+}
+
 /*
  * We have mostly NULL's here: the current defaults are ok for
  * the nilfs filesystem.
@@ -140,7 +153,7 @@ static int nilfs_file_mmap_prepare(struct vm_area_desc *desc)
 const struct file_operations nilfs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
-	.write_iter	= generic_file_write_iter,
+	.write_iter	= nilfs_file_write_iter,
 	.unlocked_ioctl	= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= nilfs_compat_ioctl,
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 34e6096069ad..7dab8cfaad45 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -162,7 +162,7 @@ static int nilfs_writepages(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	int err = 0;
 
-	if (sb_rdonly(inode->i_sb)) {
+	if (nilfs_sb_rdonly(inode->i_sb)) {
 		nilfs_clear_dirty_pages(mapping);
 		return -EROFS;
 	}
@@ -868,7 +868,7 @@ void nilfs_evict_inode(struct inode *inode)
 	truncate_inode_pages_final(&inode->i_data);
 
 	nilfs = sb->s_fs_info;
-	if (unlikely(sb_rdonly(sb) || !nilfs->ns_writer)) {
+	if (unlikely(nilfs_sb_rdonly(sb) || !nilfs->ns_writer)) {
 		/*
 		 * If this inode is about to be disposed after the file system
 		 * has been degraded to read-only due to file system corruption
@@ -912,6 +912,9 @@ int nilfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct super_block *sb = inode->i_sb;
 	int err;
 
+	if (nilfs_emergency_ro(sb->s_fs_info))
+		return -EROFS;
+
 	err = setattr_prepare(&nop_mnt_idmap, dentry, iattr);
 	if (err)
 		return err;
@@ -952,6 +955,12 @@ int nilfs_permission(struct mnt_idmap *idmap, struct inode *inode,
 	    root->cno != NILFS_CPTREE_CURRENT_CNO)
 		return -EROFS; /* snapshot is not writable */
 
+	/* After an error made us read-only, like sb_permission() would */
+	if ((mask & MAY_WRITE) && nilfs_emergency_ro(inode->i_sb->s_fs_info) &&
+	    (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+	     S_ISLNK(inode->i_mode)))
+		return -EROFS;
+
 	return generic_permission(&nop_mnt_idmap, inode, mask);
 }
 
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 01a04080ef70..ac3e1a770162 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -143,6 +143,9 @@ int nilfs_fileattr_set(struct mnt_idmap *idmap,
 	unsigned int flags, oldflags;
 	int ret;
 
+	if (nilfs_emergency_ro(inode->i_sb->s_fs_info))
+		return -EROFS;
+
 	if (fileattr_has_fsx(fa))
 		return -EOPNOTSUPP;
 
@@ -176,6 +179,23 @@ static int nilfs_ioctl_getversion(struct inode *inode, void __user *argp)
 	return put_user(inode->i_generation, (int __user *)argp);
 }
 
+/*
+ * Like mnt_want_write_file(), but also refuse writers once an error made the
+ * filesystem read-only, the VFS doesn't know about that.
+ */
+static int nilfs_mnt_want_write_file(struct file *filp)
+{
+	struct the_nilfs *nilfs = file_inode(filp)->i_sb->s_fs_info;
+	int ret;
+
+	ret = mnt_want_write_file(filp);
+	if (!ret && nilfs_emergency_ro(nilfs)) {
+		mnt_drop_write_file(filp);
+		ret = -EROFS;
+	}
+	return ret;
+}
+
 /**
  * nilfs_ioctl_change_cpmode - change checkpoint mode (checkpoint/snapshot)
  * @inode: inode object
@@ -203,7 +223,7 @@ static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	ret = mnt_want_write_file(filp);
+	ret = nilfs_mnt_want_write_file(filp);
 	if (ret)
 		return ret;
 
@@ -255,7 +275,7 @@ nilfs_ioctl_delete_checkpoint(struct inode *inode, struct file *filp,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	ret = mnt_want_write_file(filp);
+	ret = nilfs_mnt_want_write_file(filp);
 	if (ret)
 		return ret;
 
@@ -866,7 +886,7 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	ret = mnt_want_write_file(filp);
+	ret = nilfs_mnt_want_write_file(filp);
 	if (ret)
 		return ret;
 
@@ -1014,7 +1034,7 @@ static int nilfs_ioctl_resize(struct inode *inode, struct file *filp,
 	if (!capable(CAP_SYS_ADMIN))
 		goto out;
 
-	ret = mnt_want_write_file(filp);
+	ret = nilfs_mnt_want_write_file(filp);
 	if (ret)
 		goto out;
 
@@ -1050,6 +1070,10 @@ static int nilfs_ioctl_trim_fs(struct inode *inode, void __user *argp)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/* Don't trust the segment usage after an error. */
+	if (nilfs_emergency_ro(nilfs))
+		return -EROFS;
+
 	if (!bdev_max_discard_sectors(nilfs->ns_bdev))
 		return -EOPNOTSUPP;
 
@@ -1202,7 +1226,7 @@ static int nilfs_ioctl_set_suinfo(struct inode *inode, struct file *filp,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	ret = mnt_want_write_file(filp);
+	ret = nilfs_mnt_want_write_file(filp);
 	if (ret)
 		return ret;
 
@@ -1295,7 +1319,7 @@ static int nilfs_ioctl_set_fslabel(struct super_block *sb, struct file *filp,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	ret = mnt_want_write_file(filp);
+	ret = nilfs_mnt_want_write_file(filp);
 	if (ret)
 		return ret;
 
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 2a435349fd21..7863fbc559a2 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -398,7 +398,7 @@ static int nilfs_mdt_write_folio(struct folio *folio,
 	struct super_block *sb;
 	int err = 0;
 
-	if (inode && sb_rdonly(inode->i_sb)) {
+	if (inode && nilfs_sb_rdonly(inode->i_sb)) {
 		/*
 		 * It means that filesystem was remounted in read-only
 		 * mode because of error or metadata corruption. But we
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index e037e0c6e31a..06b928387212 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -583,6 +583,7 @@ const struct inode_operations nilfs_special_inode_operations = {
 
 const struct inode_operations nilfs_symlink_inode_operations = {
 	.get_link	= page_get_link,
+	.setattr	= nilfs_setattr,
 	.permission     = nilfs_permission,
 };
 
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index cf4f1c6798f5..01c80ed12138 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -259,7 +259,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 
 		folio_lock(folio);
 		if (unlikely(!folio_test_dirty(folio))) {
-			if (WARN_ONCE(!sb_rdonly(smap_inode->i_sb),
+			if (WARN_ONCE(!nilfs_sb_rdonly(smap_inode->i_sb),
 					"inconsistent dirty state\n"))
 				goto unlock_folio;
 
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 829573cb6131..eb79245de60d 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -317,7 +317,7 @@ void nilfs_relax_pressure_in_lock(struct super_block *sb)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
-	if (sb_rdonly(sb) || unlikely(!sci) || !sci->sc_flush_request)
+	if (nilfs_sb_rdonly(sb) || unlikely(!sci) || !sci->sc_flush_request)
 		return;
 
 	set_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags);
@@ -2097,7 +2097,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int err;
 
-	if (sb_rdonly(sci->sc_super))
+	if (nilfs_sb_rdonly(sci->sc_super))
 		return -EROFS;
 
 	nilfs_sc_cstage_set(sci, NILFS_ST_INIT);
@@ -2321,7 +2321,7 @@ int nilfs_construct_segment(struct super_block *sb)
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_transaction_info *ti;
 
-	if (sb_rdonly(sb) || unlikely(!sci))
+	if (nilfs_sb_rdonly(sb) || unlikely(!sci))
 		return -EROFS;
 
 	/* A call inside transactions causes a deadlock. */
@@ -2354,7 +2354,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	struct nilfs_transaction_info ti;
 	int err = 0;
 
-	if (sb_rdonly(sb) || unlikely(!sci))
+	if (nilfs_sb_rdonly(sb) || unlikely(!sci))
 		return -EROFS;
 
 	nilfs_transaction_lock(sb, &ti, 0);
@@ -2868,9 +2868,8 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 
 	if (nilfs->ns_writer) {
 		/*
-		 * This happens if the filesystem is made read-only by
-		 * __nilfs_error or nilfs_remount and then remounted
-		 * read/write.  In these cases, reuse the existing
+		 * This happens if the filesystem is remounted read-only and
+		 * then read/write again.  In this case, reuse the existing
 		 * writer.
 		 */
 		return 0;
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 5888ed479c8b..d5e7598e36b3 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -76,7 +76,7 @@ int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range);
 		int _err = (err);					\
 									\
 		if (unlikely(_err))					\
-			_err = WARN_ONCE(!sb_rdonly((sufile)->i_sb),	\
+			_err = WARN_ONCE(!nilfs_sb_rdonly((sufile)->i_sb), \
 				"unexpected sufile error %d\n", _err) ? \
 				-EIO : -EROFS;				\
 		_err;							\
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 893a504cb80c..22ae5b51d4ee 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -137,12 +137,17 @@ void __nilfs_error(struct super_block *sb, const char *function,
 
 	va_end(args);
 
-	if (!sb_rdonly(sb)) {
+	if (!nilfs_sb_rdonly(sb)) {
 		nilfs_set_error(sb);
 
 		if (nilfs_test_opt(nilfs, ERRORS_RO)) {
 			printk(KERN_CRIT "Remounting filesystem read-only\n");
-			sb->s_flags |= SB_RDONLY;
+			/*
+			 * Don't set SB_RDONLY, that needs sb->s_umount and a
+			 * remount. Flipping it on a frozen filesystem makes
+			 * thaw leave s_writers locked forever.
+			 */
+			set_nilfs_emergency_ro(nilfs);
 		}
 	}
 
@@ -508,7 +513,7 @@ static void nilfs_put_super(struct super_block *sb)
 
 	nilfs_detach_log_writer(sb);
 
-	if (!sb_rdonly(sb)) {
+	if (!nilfs_sb_rdonly(sb)) {
 		down_write(&nilfs->ns_sem);
 		nilfs_cleanup_super(sb);
 		up_write(&nilfs->ns_sem);
@@ -529,6 +534,10 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 	struct nilfs_super_block **sbp;
 	int err = 0;
 
+	/* Nothing may be written after an error made us read-only. */
+	if (nilfs_emergency_ro(nilfs))
+		return 0;
+
 	/* This function is called when super block should be written back */
 	if (wait)
 		err = nilfs_construct_segment(sb);
@@ -588,7 +597,7 @@ static int nilfs_freeze(struct super_block *sb)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	int err;
 
-	if (sb_rdonly(sb))
+	if (nilfs_sb_rdonly(sb))
 		return 0;
 
 	/* Mark super block clean */
@@ -602,7 +611,7 @@ static int nilfs_unfreeze(struct super_block *sb)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
 
-	if (sb_rdonly(sb))
+	if (nilfs_sb_rdonly(sb))
 		return 0;
 
 	down_write(&nilfs->ns_sem);
@@ -698,6 +707,8 @@ static int nilfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",norecovery");
 	if (nilfs_test_opt(nilfs, DISCARD))
 		seq_puts(seq, ",discard");
+	if (nilfs_emergency_ro(nilfs))
+		seq_puts(seq, ",emergency_ro");
 
 	return 0;
 }
@@ -1087,7 +1098,7 @@ nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto failed_unload;
 	}
 
-	if (!sb_rdonly(sb)) {
+	if (!nilfs_sb_rdonly(sb)) {
 		err = nilfs_attach_log_writer(sb, fsroot);
 		if (err)
 			goto failed_checkpoint;
@@ -1099,7 +1110,7 @@ nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	nilfs_put_root(fsroot);
 
-	if (!sb_rdonly(sb)) {
+	if (!nilfs_sb_rdonly(sb)) {
 		down_write(&nilfs->ns_sem);
 		nilfs_setup_super(sb, true);
 		up_write(&nilfs->ns_sem);
@@ -1145,6 +1156,10 @@ static int nilfs_reconfigure(struct fs_context *fc)
 	if (fc->sb_flags & SB_RDONLY) {
 		sb->s_flags |= SB_RDONLY;
 
+		/* After an error nothing may be written, just go read-only. */
+		if (nilfs_emergency_ro(nilfs))
+			goto out;
+
 		/*
 		 * Remounting a valid RW partition RDONLY, so set
 		 * the RDONLY flag and then mark the partition as valid again.
@@ -1156,6 +1171,12 @@ static int nilfs_reconfigure(struct fs_context *fc)
 		__u64 features;
 		struct nilfs_root *root;
 
+		/* An error made the filesystem read-only until umount. */
+		if (nilfs_emergency_ro(nilfs)) {
+			err = -EROFS;
+			goto ignore_opts;
+		}
+
 		/*
 		 * Mounting a RDONLY partition read-write, so reread and
 		 * store the current valid flag.  (It may have been changed
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 4776a70f01ae..0b300d08898e 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -30,6 +30,7 @@ enum {
 	THE_NILFS_GC_RUNNING,	/* gc process is running */
 	THE_NILFS_SB_DIRTY,	/* super block is dirty */
 	THE_NILFS_PURGING,	/* disposing dirty files for cleanup */
+	THE_NILFS_EMERGENCY_RO,	/* read-only after an error */
 };
 
 /**
@@ -204,6 +205,13 @@ THE_NILFS_FNS(DISCONTINUED, discontinued)
 THE_NILFS_FNS(GC_RUNNING, gc_running)
 THE_NILFS_FNS(SB_DIRTY, sb_dirty)
 THE_NILFS_FNS(PURGING, purging)
+THE_NILFS_FNS(EMERGENCY_RO, emergency_ro)
+
+/* Mounted read-only or read-only after an error: nothing may be written. */
+static inline bool nilfs_sb_rdonly(struct super_block *sb)
+{
+	return sb_rdonly(sb) || nilfs_emergency_ro(sb->s_fs_info);
+}
 
 /*
  * Mount option operations

-- 
2.53.0

