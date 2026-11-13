Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571250;
	b=ki8joO0GJCdrRBXmtBptMWh8bgrV5kq3ZvwYxjTuT/W500LM5shuckHRFqSBfA6KCxez
	 tyHsQlXYoBJ1RODt+qIvFUCDEjUjGLx5ScaYWYnEukCNHTPvOzgSVtYxL0R7InM3fa6+p
	 511T4qyLOORRaQbucpsBu7vqOlPN78tFF1Pq0w3hr8nAnTvXfaGEdilXsUW0juvwwfAfg
	 HkD4yZbWQLU0Xod/tWFiAPyEInrLKJOzwS0hFvQuTaNi40ZpGnz17ptr8cBJFoj8Gx7dh
	 sxRvkzF1njGHGn36/aurXhzXvNMbsjtmoz0nBVGz+ubes2F4rkvZuYSm2MIt0iYvVjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571250;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=fO/77PxjazTXozaWYmXfnUNBIcfWAA9M213KUMdEO2E=;
	b=w6eGC6yytHsoXmYVJB7r9hwi6Y6J18TzznPOS6zz4mlqR5+z9Qlrq1u2yZBWFGDA6EmE
	 9OFW1TgfZcygtVC6fbno60i8Zp7RnsLmNjtdj6e2FoqSf7aBmsFEuG0wKzIPBvJpVq6kI
	 itsHCpGJa5iebCdBITwuJagBfZHQHKlXHykN7ob5oRElNh89elhj8mC4/OlybvhQiCgNi
	 SLb1xdm8ZXxqePzt1hcrX1YZvLLVVputW1l/DY4L81wZfJa4SOeHRSM8C2FPtO7NzKBbl
	 TthU8oBeSxcs68p2g/8amDm/P9/xMz0gxhV4h+zqQdnIXSgzyRL7i5CqDePf44hSEgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O4PJhCa9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40471606A88B;
	Fri, 13 Nov 2026 12:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O4PJhCa9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4455C1F000D0;
	Fri, 13 Nov 2026 12:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571249;
	bh=fO/77PxjazTXozaWYmXfnUNBIcfWAA9M213KUMdEO2E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O4PJhCa9GmprnCSodb1Tvbb5kApzBmc9OY3BjB+klV4lzQqGkYLRy4J9XCwPWpgSe
	 xbwQUYHBIhjx2aSoPuJ+YCZ0M9uzKPLEU0OXxmpUcPq28r/yrwofrICt9RE2KfGMXT
	 0P9zk91R8g/+C8WyS8lIR7JipZtseBKB75Vi3tDqIhrAXzoU2OeaLi8XuvQiCB+ydM
	 mHYj9piJvtVu4YrS77Kz4D0t0eLFN08qSngK45yf60mjQ0rcyERqc2U9vHRbawZQPm
	 kewOhL5htAQCPY93n9kLf/hq1uqgXcQIM0wC6m59Nfoyxu2ghl71D/f9J8gPuPh0Yt
	 gB3NCmsUUkouw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:05 +0100
Subject: [PATCH v3 09/33] fat: don't set SB_RDONLY after filesystem errors
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-9-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6918; i=brauner@kernel.org;
 h=from:subject:message-id; bh=hJjqcETpnF8Bw85Y5EMVd99FPp/4PHlnKsk14i9xJCk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+73k3peNa5ziZH+ZT1ELYw4+uesn+5H7Rk2sP/jlF
 yvX+fnodJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkTx/Db9Yqy4MBDS6hZlsO
 Lplv8Oe/8oaXf4q65T7I7D50+OGTnXwM/wNW7r0ZHML9PKJIeIqbSv6pmtDjirnnKx9OyT79Pvy
 hFgMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

With errors=remount-ro, the default, __fat_fs_error() sets SB_RDONLY
from whatever context hit the error and without holding s_umount. If
that happens while the filesystem is frozen through bdev_freeze(), e.g.
by a device mapper suspend, thaw_super() sees a read-only superblock and
leaves the s_writers rwsems locked so every writer hangs.

So call sb_set_emergency_ro() instead and let the VFS refuse
modifications. fat still refuses FAT writes, cluster allocation,
write_begin, O_DIRECT writes and FITRIM itself, leaves the volume marked
dirty and doesn't free fallocated clusters on evict. fat_write_inode()
keeps working. Writeback still writes the FAT and the directory blocks
and rename and create leave the new entry with cluster 0 and size 0
until fat_write_inode() fills them in. Errors while mounting still set
SB_RDONLY, nothing can freeze the superblock before SB_BORN.

After a remount to read-only a remount to read-write fails until umount.
A plain remount to read-write right after the error succeeds but the
filesystem stays read-only. A remount to read-only doesn't mark the
volume clean. Writes through file descriptors opened before the error
fail with EROFS.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fat/dir.c    |  3 +++
 fs/fat/fatent.c | 11 ++++++++++-
 fs/fat/file.c   |  4 ++++
 fs/fat/inode.c  | 13 +++++++++++--
 fs/fat/misc.c   | 19 +++++++++++++------
 5 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 35bdb62944a2e..553034bcbed40 100644
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
index 2d10a815a5797..9e4bb0140320f 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -314,7 +314,7 @@ static void mark_fsinfo_dirty(struct super_block *sb)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
-	if (sb_rdonly(sb) || !is_fat32(sbi))
+	if (sb_rdonly_any(sb) || !is_fat32(sbi))
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
index d4f1b360b9743..3d0a81994fb70 100644
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
index d85c8fbdcca46..2779583c64423 100644
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
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 65d02f2edec38..05d061b594a67 100644
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

