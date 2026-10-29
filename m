Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290110;
	b=xj1XEmzZFsnOElHKl7KJMAsigKeG2+6eR9AXv78pA1IW19EpOgKYPOxkg6zrLuV7XaHY
	 Igh7QXy7NPI0A6Gxhetqh/hZcTAfoT2MXuyq7bRihozuFjThxQsye+1Str2Widgl4EyUb
	 KpOva1u/bpQrGu6VzOPRNmDM8IEkKBpFpcaJOTdaYRzbUs+d740Mn1enWJ2F3rB39QR/A
	 7TAd0vkQu+dezP1WS8JG/ECIKo4N3BJjbtwvjvx7GUQhy9fQ4pgX9TOjkcUp5cWS3omwF
	 f3XvZUVaDPZu+kBtGQwwxFS1JXC+9Qtw0g+JlukWj1uRWDzP8q8wjtRy/vvLoBvkzBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290110;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=lOdaf0Zf7Tx/CylsO5jKdAcnuGg+xFWYSOeHAoH3mNc=;
	b=nwY5/57TtLUQXdG9C9g+JKmF/jhpgtE6TDj9VNunehqxMVmKaGOHk6d3p2ANwOlNeNYW
	 6Ihsa5hUKOphYQqK7LITueDP7kdGzlHr2sntkX3Fo4DYd/ZJggHqYF5+2dLtJwuel1MsZ
	 aiVbiTbUOHPX3Hmf+AiUXn0ozgRQszvodCrfAFSZ54bcXLqEVea8nPdV+ujzkgvCpTFUs
	 WNGV7lMndigRIsnGNMrvnoyX4i/5MOF+C+MPRufhe9mSfIzYPi/K7SdCbDt4SpU0/3DAK
	 v7jGs7iV3KnNyQcs9hfnRJ1dvfOX+QATaozUx8tcaypT2AtY69T17wfqfkaqm0z/WGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Mkkh/6Ad";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5148B606A31C;
	Thu, 29 Oct 2026 16:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mkkh/6Ad
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC6A1F01826;
	Thu, 29 Oct 2026 16:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290109;
	bh=lOdaf0Zf7Tx/CylsO5jKdAcnuGg+xFWYSOeHAoH3mNc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Mkkh/6AdRYfvSfyjpLwbroR31lzxLlJFZEp5FSNJ/gv/Y2ksuNNMnQ7DNOpxkFJZs
	 H83BjlVu+Ow4K2PY+bVZIdujbY8jRUosS55d6uMBxaEbOVWjifjTtQxwXpQbmotZwa
	 ItPwCURgbjN3znNMx9+vi6oI7MD5hB4GZLh+yTtQFSA6hw9ritBvSwoFIcVGsxL74p
	 cOIZZ7MhC3xEAHShIX+IwymVOtNP+lQy3SvX8HJZwqCK00aPdqC0gLmGjwNZyVbtAs
	 B17SiqaVnq6QhU+0td2yT+ST7BNJyJCQAidTifAqGK7AHn3T+wC4LuwZ/CyKJandiB
	 uBreV+q7tvzQA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:07 +0100
Subject: [PATCH v2 16/34] hpfs: don't set SB_RDONLY after filesystem errors
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-16-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4412; i=brauner@kernel.org;
 h=from:subject:message-id; bh=HjY2TpU2zaQJA3Ncvw1b4w9QnMNY6uHTIkSft5aNRTE=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGrjby+jQvJKYk2QQRQ1L8q//FVvZJgprvAFPf0r1TvUIMCe+
 oh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmrjby8ACgkQkcYbwGV43KJSKwD+MnJY
 PXjYZUPCVMbe+ntVEdsrAo9wqFKueXJYeySUyQkA/RQp/pST8RDbnSwtc7r5VAOV4jWHE1f9RMH
 rZe91yVII
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

With errors=remount-ro, the hpfs default, hpfs_error() sets SB_RDONLY on
the first error without holding s_umount. If that happens while the
filesystem is frozen through bdev_freeze() thaw_super() sees a read-only
superblock and leaves the s_writers rwsems locked so every writer hangs.

hpfs_error() is also called from hpfs_fill_super() where nothing can
freeze the superblock yet, so keep setting SB_RDONLY there. After that
call sb_set_emergency_ro() instead and let the VFS refuse modifications.
FITRIM is refused and unmark_dirty() does nothing in that state so the
next mount reports the volume as improperly stopped. hpfs_map_dnode()
and hpfs_lookup() treat the state like read-only so lookups behave as
before.

A remount to read-write fails until umount and a remount to read-only
doesn't write the spare block. Writes through file descriptors opened
before the error fail with EROFS.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/hpfs/alloc.c |  4 ++--
 fs/hpfs/dir.c   |  3 ++-
 fs/hpfs/map.c   |  3 ++-
 fs/hpfs/super.c | 11 +++++++++--
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/hpfs/alloc.c b/fs/hpfs/alloc.c
index f5150372618e..8c84126ea038 100644
--- a/fs/hpfs/alloc.c
+++ b/fs/hpfs/alloc.c
@@ -539,7 +539,7 @@ int hpfs_trim_fs(struct super_block *s, u64 start, u64 end, u64 minlen, unsigned
 		return 0;
 	if (start < sbi->sb_dirband_start + sbi->sb_dirband_size && end > sbi->sb_dirband_start) {
 		hpfs_lock(s);
-		if (sb_rdonly(s)) {
+		if (sb_rdonly(s) || sb_emergency_ro(s)) {
 			err = -EROFS;
 			goto unlock_1;
 		}
@@ -560,7 +560,7 @@ int hpfs_trim_fs(struct super_block *s, u64 start, u64 end, u64 minlen, unsigned
 	end_bmp = (end + 0x3fff) >> 14;
 	while (start_bmp < end_bmp && !err) {
 		hpfs_lock(s);
-		if (sb_rdonly(s)) {
+		if (sb_rdonly(s) || sb_emergency_ro(s)) {
 			err = -EROFS;
 			goto unlock_2;
 		}
diff --git a/fs/hpfs/dir.c b/fs/hpfs/dir.c
index 3bf11202e2d3..1fd35a98a5f1 100644
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -265,7 +265,8 @@ struct dentry *hpfs_lookup(struct inode *dir, struct dentry *dentry, unsigned in
 	hpfs_result = hpfs_i(result);
 	if (!de->directory) hpfs_result->i_parent_dir = dir->i_ino;
 
-	if (de->has_acl || de->has_xtd_perm) if (!sb_rdonly(dir->i_sb)) {
+	if ((de->has_acl || de->has_xtd_perm) &&
+	    !sb_rdonly(dir->i_sb) && !sb_emergency_ro(dir->i_sb)) {
 		hpfs_error(result->i_sb, "ACLs or XPERM found. This is probably HPFS386. This driver doesn't support it now. Send me some info on these structures");
 		iput(result);
 		result = ERR_PTR(-EINVAL);
diff --git a/fs/hpfs/map.c b/fs/hpfs/map.c
index be73233502f8..e9af634e54fa 100644
--- a/fs/hpfs/map.c
+++ b/fs/hpfs/map.c
@@ -288,7 +288,8 @@ struct dnode *hpfs_map_dnode(struct super_block *s, unsigned secno,
 					goto bail;
 				}
 				if (((31 + de->namelen + de->down*4 + 3) & ~3) != le16_to_cpu(de->length)) {
-					if (((31 + de->namelen + de->down*4 + 3) & ~3) < le16_to_cpu(de->length) && s->s_flags & SB_RDONLY) goto ok;
+					if (((31 + de->namelen + de->down*4 + 3) & ~3) < le16_to_cpu(de->length) &&
+					    (sb_rdonly(s) || sb_emergency_ro(s))) goto ok;
 					hpfs_error(s, "namelen does not match dirent size in dnode %08x, dirent %03x, last %03x", secno, p, pp);
 					goto bail;
 				}
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 8fbdbf080627..ab89e624cd51 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -44,7 +44,7 @@ static void unmark_dirty(struct super_block *s)
 {
 	struct buffer_head *bh;
 	struct hpfs_spare_block *sb;
-	if (sb_rdonly(s)) return;
+	if (sb_rdonly(s) || sb_emergency_ro(s)) return;
 	sync_blockdev(s->s_bdev);
 	if ((sb = hpfs_map_sector(s, 17, &bh, 0))) {
 		sb->dirty = hpfs_sb(s)->sb_chkdsk > 1 - hpfs_sb(s)->sb_was_error;
@@ -81,7 +81,14 @@ void hpfs_error(struct super_block *s, const char *fmt, ...)
 			else {
 				pr_cont("; remounting read-only\n");
 				mark_dirty(s, 0);
-				s->s_flags |= SB_RDONLY;
+				/*
+				 * Before SB_BORN the mounter holds s_umount,
+				 * later see sb_set_emergency_ro().
+				 */
+				if (s->s_flags & SB_BORN)
+					sb_set_emergency_ro(s);
+				else
+					s->s_flags |= SB_RDONLY;
 			}
 		} else if (sb_rdonly(s))
 				pr_cont("; going on - but anything won't be destroyed because it's read-only\n");

-- 
2.53.0

