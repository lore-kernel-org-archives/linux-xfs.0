Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290059;
	b=Xm7yKQecN9mi203xA5fneyzPMQSD1NxvmlD3Ro1RV+7s39JwJTOgOGerWuHjA6w84F77
	 APu3x2W9UeT4/bBfAjfdJM5nV7/1sXbMjYYapzgyR95D2utSnmJcr8aHDTqjSwcvfk7hz
	 In1xINM8U1SJT5ikdSyWJY8KvJkDgQvUn5ihadg8E0mJtxb3h+PM0mJIw3u7EjCBayfUj
	 Bl1nxvthIZLVylK5gp5Vky2M67siUic4zWp/zP6TuPswvsL+YCMoD7jZlmodx1Y7bzXhz
	 s1HwIkH5oS2jqzt3G/ExNaMxEF2lDIDrQmtoqDIIxW7Rsa3cKKSg/4/ohB5ob8z++Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290059;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=xNgZk8sqL0pi/BgMC10+2IZal4rVk0LbmvrvuXhJ2Dk=;
	b=dcKWOwdxgXjfAr7r4/03PLelooPvmjfxaRryQLnhDB4aT67DHVPsQBs7dim992ABxsyk
	 emKIgpbLEuwn1kqtF8M4L4UH7S88J0yIjqnFOQHbFtBf3QGTKDPrzXsWC/4QBn8h7f320
	 4sjC9auEfq/Al9l5yAmt3VXJJ/QCj6GNxXYjYBldnkywFJehTh3ClwjFz5vtBqWM99NIm
	 QnuYgaXcVX91RqBs4GETyjJmZo/YjsrnSyaxYbp35fHklfiu4+/kCsVNEJDncBHdeM10R
	 MprIWmFwrfWE3WES2mN9N5bRh03Ovkc9Oywp5IeMGeddStTT8x+pszvVWIYvMRexUDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AlRagrjY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0ECE606A31A;
	Thu, 29 Oct 2026 16:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AlRagrjY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805901F01826;
	Thu, 29 Oct 2026 16:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290058;
	bh=xNgZk8sqL0pi/BgMC10+2IZal4rVk0LbmvrvuXhJ2Dk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AlRagrjY6o1gWRJCJgnfCv2vf7Bcfac+CV9YW1vTP2WwuW9tEuQHBhevP5ePYv6wU
	 tZm/UfOxlRJO5sw/a2Nplq+A8PWYDB8BkatYa8/unWums0YZOd7jiODkUS1bQuoXDc
	 2r237CVoc0X/eY5Af46WpEvX1ZVjahYsPaB2Gk6AXIVz2nlCClJI5khPlYaE7iT7p/
	 XDhxiJCpt5DJKGR+EHHl4F0uT78HBaolBZCT7M33rjZhbbhgAo2PcjBtaKm9eZkw6X
	 NWXJ/Hi6PIE9ox1qUK/7i9IAhFrGTWMyjol5owtz516sIM6RN//r2rt7z0U4U/YYMu
	 YskLTlKankV9Q==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:06:55 +0100
Subject: [PATCH v2 04/34] ext2: don't set SB_RDONLY after filesystem errors
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Karl Mehltretter <kmehltretter@gmail.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=7123; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5u6R9zyuZJuhy+aULhR8Qmnz6ME9R6gfqmURw2sS7bQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztdTcqkry2sNm/UkdlqstlmLZfOJPyXf/Zv1Gi4ds
 vu446ZZRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETmbWBk6NSRkMm8L+79MOZB
 ilh2q/3C3Y21/O3N07TCL2Uniy54yPA/osBzTguz6qL/+QvZjD99OlhX/nB9ZZQO+13e3VnnFGa
 wAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

With errors=remount-ro ext2_error() sets SB_RDONLY from whatever context
hit the error and without holding s_umount. That races with everyone
else changing sb->s_flags and it breaks freezing. If it happens while
the filesystem is frozen thaw_super() sees a read-only superblock and
leaves the s_writers rwsems locked so every writer hangs. A lookup in a
corrupted directory is enough. Karl proposed teaching thaw_super() about
it but Jan preferred fixing the filesystems (cf. [1]) like ext4 and f2fs
already did.

So call sb_set_emergency_ro() instead and let the VFS refuse
modifications. ext2 still refuses allocations, ext2_write_inode(),
ext2_sync_fs() and ext2_xattr_set() itself. The superblock isn't written
after the error is recorded and unlinked inodes are left to e2fsck.
ext2_handle_dirsync() treats EROFS as success in that state because the
entry was already changed.

A remount to read-write fails until umount and writes through file
descriptors opened before the error fail with EROFS.

[1]: https://lore.kernel.org/r/hyhuckyohsabx2suvq3z7uy3pbgmihva6wgzxr3op7pzcrlu33@p7zzlgp2ehjf

Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext2/balloc.c |  5 +++++
 fs/ext2/dir.c    |  3 +++
 fs/ext2/ialloc.c |  2 ++
 fs/ext2/inode.c  | 10 ++++++++--
 fs/ext2/super.c  | 24 ++++++++++++++++++------
 fs/ext2/xattr.c  |  2 ++
 6 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 80acc1e19387..77f2ed5a76a2 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -1236,6 +1236,11 @@ ext2_fsblk_t ext2_new_blocks(struct inode *inode, ext2_fsblk_t goal,
 	*errp = -ENOSPC;
 	sb = inode->i_sb;
 
+	if (sb_emergency_ro(sb)) {
+		*errp = -EROFS;
+		return 0;
+	}
+
 	/*
 	 * Check quota for allocation of this block.
 	 */
diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index e17bbc7598c1..c2c9fc2d0b27 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -445,6 +445,9 @@ static int ext2_handle_dirsync(struct inode *dir)
 	err = filemap_write_and_wait(dir->i_mapping);
 	if (!err)
 		err = sync_inode_metadata(dir, 1);
+	/* The change is done, an error made us read-only in the meantime. */
+	if (err == -EROFS && sb_emergency_ro(dir->i_sb))
+		err = 0;
 	return err;
 }
 
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index bf21b57cf98c..2741ecd2b94f 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -433,6 +433,8 @@ struct inode *ext2_new_inode(struct inode *dir, umode_t mode,
 	int err;
 
 	sb = dir->i_sb;
+	if (sb_emergency_ro(sb))
+		return ERR_PTR(-EROFS);
 	inode = new_inode(sb);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 12ac4cfe1500..5c4831f8f45d 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -71,7 +71,9 @@ void ext2_evict_inode(struct inode * inode)
 	struct ext2_block_alloc_info *rsv;
 	int want_delete = 0;
 
-	if (!inode->i_nlink && !is_bad_inode(inode)) {
+	/* After an error made us read-only the inode is left to e2fsck. */
+	if (!inode->i_nlink && !is_bad_inode(inode) &&
+	    !sb_emergency_ro(inode->i_sb)) {
 		want_delete = 1;
 		dquot_initialize(inode);
 	} else {
@@ -1481,10 +1483,14 @@ int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
 	uid_t uid = i_uid_read(inode);
 	gid_t gid = i_gid_read(inode);
 	struct buffer_head * bh;
-	struct ext2_inode * raw_inode = ext2_get_inode(sb, ino, &bh);
+	struct ext2_inode *raw_inode;
 	int n;
 	int err = 0;
 
+	if (sb_emergency_ro(sb))
+		return -EROFS;
+
+	raw_inode = ext2_get_inode(sb, ino, &bh);
 	if (IS_ERR(raw_inode))
  		return -EIO;
 
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index fb217ef2d69f..804a7224066d 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -53,7 +53,7 @@ void ext2_error(struct super_block *sb, const char *function,
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	struct ext2_super_block *es = sbi->s_es;
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly(sb) && !sb_emergency_ro(sb)) {
 		spin_lock(&sbi->s_lock);
 		sbi->s_mount_state |= EXT2_ERROR_FS;
 		es->s_state |= cpu_to_le16(EXT2_ERROR_FS);
@@ -73,11 +73,11 @@ void ext2_error(struct super_block *sb, const char *function,
 
 	if (test_opt(sb, ERRORS_PANIC))
 		panic("EXT2-fs: panic from previous error\n");
-	if (!sb_rdonly(sb) && test_opt(sb, ERRORS_RO)) {
+	/* SB_RDONLY needs s_umount, see sb_set_emergency_ro(). */
+	if (!sb_rdonly(sb) && test_opt(sb, ERRORS_RO) &&
+	    sb_set_emergency_ro(sb))
 		ext2_msg(sb, KERN_CRIT,
 			     "error: remounting filesystem read-only");
-		sb->s_flags |= SB_RDONLY;
-	}
 }
 
 static void ext2_msg_fc(struct fs_context *fc, const char *prefix,
@@ -179,7 +179,7 @@ static void ext2_put_super (struct super_block * sb)
 	ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
 	sbi->s_ea_block_cache = NULL;
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly(sb) && !sb_emergency_ro(sb)) {
 		struct ext2_super_block *es = sbi->s_es;
 
 		spin_lock(&sbi->s_lock);
@@ -1287,6 +1287,10 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
 
+	/* Nothing may be written after an error made us read-only. */
+	if (sb_emergency_ro(sb))
+		return 0;
+
 	/*
 	 * Write quota structures to quota file, sync_blockdev() will write
 	 * them to disk later
@@ -1307,6 +1311,9 @@ static int ext2_freeze(struct super_block *sb)
 {
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 
+	if (sb_emergency_ro(sb))
+		return 0;
+
 	/*
 	 * Open but unlinked files present? Keep EXT2_VALID_FS flag cleared
 	 * because we have unattached inodes and thus filesystem is not fully
@@ -1349,7 +1356,9 @@ static int ext2_reconfigure(struct fs_context *fc)
 	int flags = fc->sb_flags;
 	int err;
 
-	sync_filesystem(sb);
+	/* Nothing may be written after an error made us read-only. */
+	if (!sb_emergency_ro(sb))
+		sync_filesystem(sb);
 
 	new_opts.s_mount_opt = ctx->vals_s_mount_opt;
 	new_opts.s_resuid = ctx->s_resuid;
@@ -1360,6 +1369,9 @@ static int ext2_reconfigure(struct fs_context *fc)
 	if ((bool)(flags & SB_RDONLY) == sb_rdonly(sb))
 		goto out_set;
 	if (flags & SB_RDONLY) {
+		/* After an error nothing may be written, just go read-only. */
+		if (sb_emergency_ro(sb))
+			goto out_set;
 		if (le16_to_cpu(es->s_state) & EXT2_VALID_FS ||
 		    !(sbi->s_mount_state & EXT2_VALID_FS))
 			goto out_set;
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 8f608930a48c..12dfffff189c 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -429,6 +429,8 @@ ext2_xattr_set(struct inode *inode, int name_index, const char *name,
 	ea_idebug(inode, "name=%d.%s, value=%p, value_len=%ld",
 		  name_index, name, value, (long)value_len);
 
+	if (sb_emergency_ro(sb))
+		return -EROFS;
 	if (value == NULL)
 		value_len = 0;
 	if (name == NULL)

-- 
2.53.0

