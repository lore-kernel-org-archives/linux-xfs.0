Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571237;
	b=SI/E7vzoMBxsPOiZ8L5V41P4Z8ukv/c0YgtqtBxT7k88rUlJDTdqCtefjvPLDpgAx5Qs
	 QPBcF2XjPMwAPHHR53NrSnWnMJW6297qDUwwmKpOXSnWZY42HYO0mWLRiL6Wz4+dBjmx4
	 IG2OciRLd+d8o3elIkVlJ0y+5KVofqYYTA/iyLq9UUu/n/Jt7cgQzTHQQ6HL+37H7S9Rb
	 FhSuL6gh6tCHc1K5YVq9KfE495OIXI9KkdOwuE1SOv+iqKQpYPplfGiM3YXFOrf784jbr
	 OyO94N47RhttuFJPPjM3DbE1Vi1/+cLk2MZGlGiuc30ZKAhD0vU+HzIW0NvNbTSnV7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571237;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=q8rH1EerGXOcbNF2NyxvkSKNsMomLcR0GIdkZh+GkXs=;
	b=nzX6WUdezrd8i0Cx3NGlJ9iNmKxmh3CwL6/c0F/zrTVu6QsnimuNk2UmbMkiPqPuMGXd
	 wXgQrdAuN8RsbYUxz47zuL7YXSqOgceAQnc+Lo6weHzqsl7JYvEs3PlDFYzWYCmisVP/+
	 cMGX9siQi3DPjZ8NKUAFfAYtA/7fUNCnYTnvhWCl7b3k5KPIGENzShmHRd3djau6ubLQC
	 RFU0un6Z0Lk2HtSdI3z21ngjt+JE6C2DULLpH7FHMHFibEWB35+9XjaAseeNNGgyeyNQ/
	 gDm7KO2PHtunHCRh5j43aHCCCmRViQqeRcusuSHLfHlaf/Mal5eTR2NcQjo/oEiA9yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d9XI+ous;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A1D606A8AF;
	Fri, 13 Nov 2026 12:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d9XI+ous
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D818A1F000C5;
	Fri, 13 Nov 2026 12:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571236;
	bh=q8rH1EerGXOcbNF2NyxvkSKNsMomLcR0GIdkZh+GkXs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d9XI+ousp8TuvVII27gWXwVXQ4OUsdvQnGR1cvONAt4a3Mbl8Rqyuv9bwe6VU8fPt
	 StFPFBC0N1LS+k2T0lsaM0QeImbS3tENC6Ov4+pF5cFok8cWk0PDU0xUPjgh45gg1R
	 e9Niaww4fqzK94xUSE4k2M8s4SKRGD/6TvgqbZ3CH+oJszHnQFZxhS2TxfgrNDW12Z
	 G5Dx3AwmCcOdLO05VpzYoSqsYrTYHGO8lqFv61/YT+jFnzpguaVHuD5jJeSJlkyxW7
	 D5Po+RzFi91FSmp2DRn0ReAHiRlM0Y06k7YK+DWeOm45kP07jTX1zuDCJX8ae7RYno
	 JwIqZ0d8XXIXg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:02 +0100
Subject: [PATCH v3 06/33] ext2: don't set SB_RDONLY after filesystem errors
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-6-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Karl Mehltretter <kmehltretter@gmail.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5325; i=brauner@kernel.org;
 h=from:subject:message-id; bh=epfxXPNa/jx7o9G3z9Hy+9Q1z78RlflSeD6BYjxn3fk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+73gVxTjSZ3XdVwrow+UqT7f3t2jNt3t1PLZiVUSL
 3hPxWcWdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExEkYGRYcGN/D9mL3kWBbYa
 f5SzubH7xbR9+tePSTzr/5nUH3DmbzrD/+xfn1X+ltUwrVptPOPJwYz1q94tXtI+0ccoatah/q5
 DGewA
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
modifications. ext2 still refuses allocations and ext2_xattr_set()
itself, ecryptfs calls the latter without write access on the lower
mount. Unlinked inodes are left to e2fsck. ext2_write_inode() keeps
working because writeback still writes data, bitmaps, indirect and
directory blocks after the error and they'd be lost without the inode.
A thaw after an error while frozen still writes the superblock but
EXT2_ERROR_FS stays set in it.

After a remount to read-only a remount to read-write fails until umount.
A plain remount to read-write right after the error succeeds but the
filesystem stays read-only. Writes through file descriptors opened
before the error fail with EROFS.

[1]: https://lore.kernel.org/r/hyhuckyohsabx2suvq3z7uy3pbgmihva6wgzxr3op7pzcrlu33@p7zzlgp2ehjf

Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext2/balloc.c |  5 +++++
 fs/ext2/ialloc.c |  2 ++
 fs/ext2/inode.c  |  4 +++-
 fs/ext2/super.c  | 13 ++++++++-----
 fs/ext2/xattr.c  |  2 ++
 5 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 80acc1e193871..77f2ed5a76a28 100644
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
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index bf21b57cf98cd..2741ecd2b94fc 100644
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
index 12ac4cfe15003..dd28637c60737 100644
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
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index fb217ef2d69f0..10d5165459749 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -53,7 +53,7 @@ void ext2_error(struct super_block *sb, const char *function,
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	struct ext2_super_block *es = sbi->s_es;
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly_any(sb)) {
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
+	if (!sb_rdonly_any(sb)) {
 		struct ext2_super_block *es = sbi->s_es;
 
 		spin_lock(&sbi->s_lock);
@@ -1360,6 +1360,9 @@ static int ext2_reconfigure(struct fs_context *fc)
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
index 8f608930a48c6..12dfffff189cb 100644
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

