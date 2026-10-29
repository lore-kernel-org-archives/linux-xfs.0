Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290072;
	b=Vo628Gip882foFX7RiizprfD2IYVucLlUjKKnGRXLiHIqYvn3YYuHSdx4LcqEw5uM9S6
	 1wtZP/pfTqTkg9m6XaLINSog/AwnmYXUzAZ8UXN0Z7zASK+gRcyFMbHHCgja5qtG2UtjG
	 yt8cRcilB0usq3akL9/TBfEk25lLQi6QkRjqYZQt7r+O0EQCvFUogwbHeqyOO7Qp+jiuK
	 uCuUSKPbfN4gbl3ir4/4DV0q2gM7saFuwuAHSJeHFY/ApLC+ujO3qhNCCDwZj7E1SIn5f
	 V/ekwYOPOHI8prLht1QhS+FpEDCfsaySww3gjtgOaOK1WzMQT4tFGQAPJrb+li/Sb3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290072;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=vWXoC3DGBRzxnPUyhv6W7lJ/GIRbUyR3KNIt8HGMfr4=;
	b=ouhhLRjTpifHCQYRfJrz92AUUUTd8/ScbXGgiDQnMeZNyrpkKtGB2DXUUVMF0TUsQQWC
	 Az1AkVMvqXJuuNygK2cu2d4bO1eU/bwEC2c/J8QmFqzlnygfrGytMulSOwuxoaRS0Kw8Y
	 gCWT/cGniV3Dcso13idW3ms+B79hXxpIjUXLgtPkRsA3OgxxAO36aKVAfN4yOR9I09713
	 FWl0Lgj1s/Urf/lMSgy16QhFRZoD1L7z7QqGZvId26o1QqvxppR4p97QMfZ6WoIXCfGbm
	 bZigWO3c2opWM4x92TSKfsZei9vyf+gIsmgY82GmMfHGARIxVvyFnqQKT25Ca96Q+0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hUtWbXhW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4FA606A31C;
	Thu, 29 Oct 2026 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hUtWbXhW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFADB1F031E1;
	Thu, 29 Oct 2026 16:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290071;
	bh=vWXoC3DGBRzxnPUyhv6W7lJ/GIRbUyR3KNIt8HGMfr4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hUtWbXhW3fJajno1Nrb7Ec4J0dHYN6h6leJoiQclqb/1dXpC0rODkG3fKujqVJr7g
	 34NGOPd1Z8IWVuqab9cP4r7S6etN9kh/tBXDV04IsaZ7rc2d4TTMfJjVR6z3LsJoWX
	 0mS6H/DFYxU2xnNZuLCWw9zQFOsRo2dvw4vxruXIcM2HLQ3+08QrcQNbaK/VZR48kh
	 YE0d2V6FVDCPczojym4K41diZWjEoXTRQZEnMtQK4MjJ5FoKWk6P5rJJAGCIuXKDmD
	 DOfd75tdwmpnHOd2KQUSHKuR9w7mDMj+YlbQ5eIr8OX70MQbHtWSH4qBw84eEdmYXu
	 MtDsALtrfKoSw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:06:58 +0100
Subject: [PATCH v2 07/34] fat: don't set SB_RDONLY after filesystem errors
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-7-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=7436; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8raaRLMglHB1XzqC3kqIXTQ2e6NIuFME1v48GfRyzxs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztfvYHB9vsnz5x3XmYyHfxs2f/r63Dfm+ZOFbRuEH
 52bm8O1pqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAixzcx/BVea9y9bfOv8ijd
 w1cCtgem+tSvUBc8JL28WUXJ6fkhj0UM/x1Lc8MKtk/YanDo+RP+95vm84afb1uT/P97oXVzw79
 bYVwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

With errors=remount-ro, the default, __fat_fs_error() sets SB_RDONLY
from whatever context hit the error and without holding s_umount. If
that happens while the filesystem is frozen through bdev_freeze(), e.g.
by a device mapper suspend, thaw_super() sees a read-only superblock and
leaves the s_writers rwsems locked so every writer hangs.

So call sb_set_emergency_ro() instead and let the VFS refuse
modifications. fat still refuses FAT writes, cluster allocation,
write_begin, O_DIRECT writes, FITRIM and fat_write_inode() itself,
leaves the volume marked dirty and doesn't free fallocated clusters on
evict. With the flush mount option msdos treats EROFS from
fat_flush_inodes() as success in that state because the directory
entries were already changed. Errors while mounting still set SB_RDONLY,
nothing can freeze the superblock before SB_BORN.

A remount to read-write fails until umount and a remount to read-only
doesn't mark the volume clean. Writes through file descriptors opened
before the error fail with EROFS.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fat/dir.c    |  3 +++
 fs/fat/fatent.c | 11 ++++++++++-
 fs/fat/file.c   |  4 ++++
 fs/fat/inode.c  | 19 +++++++++++++++++--
 fs/fat/misc.c   | 19 +++++++++++++------
 5 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 35bdb62944a2..553034bcbed4 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1329,6 +1329,9 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 	loff_t pos;
 	bool saw_eod;
 
+	if (unlikely(sb_emergency_ro(sb)))
+		return -EROFS;
+
 	sinfo->nr_slots = nr_slots;
 
 	/* First stage: search free directory entries */
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 2d10a815a579..158ce7056dcf 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -314,7 +314,7 @@ static void mark_fsinfo_dirty(struct super_block *sb)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
-	if (sb_rdonly(sb) || !is_fat32(sbi))
+	if (sb_rdonly(sb) || sb_emergency_ro(sb) || !is_fat32(sbi))
 		return;
 
 	__mark_inode_dirty(sbi->fsinfo_inode, I_DIRTY_SYNC);
@@ -419,6 +419,9 @@ int fat_ent_write(struct inode *inode, struct fat_entry *fatent,
 	const struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
 	int err;
 
+	if (unlikely(sb_emergency_ro(sb)))
+		return -EROFS;
+
 	ops->ent_put(fatent, new);
 	if (wait) {
 		err = fat_sync_bhs(fatent->bhs, fatent->nr_bhs);
@@ -513,6 +516,9 @@ static int __fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluste
 	struct buffer_head *bhs[MAX_BUF_PER_PAGE];
 	int i, count, err, nr_bhs, idx_clus;
 
+	if (unlikely(sb_emergency_ro(sb)))
+		return -EROFS;
+
 	lock_fat(sbi);
 	if (sbi->free_clusters != -1 && sbi->free_clus_valid &&
 	    sbi->free_clusters < nr_cluster) {
@@ -620,6 +626,9 @@ int fat_free_clusters(struct inode *inode, int cluster)
 	int i, err, nr_bhs;
 	int first_cl = cluster, dirty_fsinfo = 0;
 
+	if (unlikely(sb_emergency_ro(sb)))
+		return -EROFS;
+
 	nr_bhs = 0;
 	fatent_init(&fatent);
 	lock_fat(sbi);
diff --git a/fs/fat/file.c b/fs/fat/file.c
index d4f1b360b974..3d0a81994fb7 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -135,6 +135,10 @@ static int fat_ioctl_fitrim(struct inode *inode, unsigned long arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/* Don't trust the FAT after an error. */
+	if (unlikely(sb_emergency_ro(sb)))
+		return -EROFS;
+
 	if (!bdev_max_discard_sectors(sb->s_bdev))
 		return -EOPNOTSUPP;
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index d85c8fbdcca4..afd73dc4ba9a 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -228,6 +228,9 @@ static int fat_write_begin(const struct kiocb *iocb,
 {
 	int err;
 
+	if (unlikely(sb_emergency_ro(mapping->host->i_sb)))
+		return -EROFS;
+
 	err = cont_write_begin(iocb, mapping, pos, len,
 				foliop, fsdata, fat_get_block,
 				&MSDOS_I(mapping->host)->mmu_private);
@@ -264,6 +267,8 @@ static ssize_t fat_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	ssize_t ret;
 
 	if (iov_iter_rw(iter) == WRITE) {
+		if (unlikely(sb_emergency_ro(inode->i_sb)))
+			return -EROFS;
 		/*
 		 * FIXME: blockdev_direct_IO() doesn't use ->write_begin(),
 		 * so we need to update the ->mmu_private to block boundary.
@@ -662,6 +667,10 @@ static int fat_sync_inode_metadata(struct inode *inode,
 
 static void fat_free_eofblocks(struct inode *inode)
 {
+	/* Nothing can be freed after an error. */
+	if (sb_emergency_ro(inode->i_sb))
+		return;
+
 	/* Release unwritten fallocated blocks on inode eviction. */
 	if ((inode->i_blocks << 9) >
 			round_up(MSDOS_I(inode)->mmu_private,
@@ -710,8 +719,8 @@ static void fat_set_state(struct super_block *sb,
 	struct fat_boot_sector *b;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
-	/* do not change any thing if mounted read only */
-	if (sb_rdonly(sb) && !force)
+	/* do not change any thing if mounted read only or after an error */
+	if ((sb_rdonly(sb) && !force) || sb_emergency_ro(sb))
 		return;
 
 	/* do not change state if fs was dirty */
@@ -954,6 +963,9 @@ static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int err;
 
+	if (unlikely(sb_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	if (inode->i_ino == MSDOS_FSINFO_INO) {
 		struct super_block *sb = inode->i_sb;
 
@@ -1949,6 +1961,9 @@ int fat_flush_inodes(struct super_block *sb, struct inode *i1, struct inode *i2)
 		ret = writeback_inode(i2);
 	if (!ret)
 		ret = sync_blockdev_nowait(sb->s_bdev);
+	/* The change is done, an error made us read-only in the meantime. */
+	if (ret == -EROFS && sb_emergency_ro(sb))
+		ret = 0;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(fat_flush_inodes);
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 65d02f2edec3..05d061b594a6 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -14,9 +14,9 @@
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
@@ -32,10 +32,17 @@ void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 		va_end(args);
 	}
 
-	if (opts->errors == FAT_ERRORS_PANIC)
+	if (opts->errors == FAT_ERRORS_PANIC) {
 		panic("FAT-fs (%s): fs panic from previous error\n", sb->s_id);
-	else if (opts->errors == FAT_ERRORS_RO && !sb_rdonly(sb)) {
-		sb->s_flags |= SB_RDONLY;
+	} else if (opts->errors == FAT_ERRORS_RO && !sb_rdonly(sb)) {
+		/*
+		 * Before SB_BORN the mounter holds s_umount so SB_RDONLY is
+		 * fine. Later it needs a remount, see sb_set_emergency_ro().
+		 */
+		if (!(sb->s_flags & SB_BORN))
+			sb->s_flags |= SB_RDONLY;
+		else if (!sb_set_emergency_ro(sb))
+			return;
 		fat_msg(sb, KERN_ERR, "Filesystem has been set read-only");
 	}
 }

-- 
2.53.0

