Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290102;
	b=gtE2aphrUQp/I0n+qAg7CWzNzb4NFAs06l/Nrb4f7SfpqdBKXdx0ujTxg6KP8m6fBZUz
	 EGTlVwZehhtdyQDKUIjnq9xKsXNIyYvU5Ftvl3FVwU9Y6yZmT5hmPZ4HPuZyBf6fbiuSm
	 rWnXa7JiXACk1HVXwoM9Q6hqNTVuWinIDlHfMUk9Fpx6sYwTYgatWvcD6kZ10+wVQCZo2
	 n0JfKNdA6dsAWDMTFkMn61oZzlEyGPQFtjJQ02D4xNdH6TeFhi94rZwFv6rUxN4OPZtrR
	 KDpAJQ5Zp2vny7jLjchvLDO5LMFp2P59GNcbP5DfiyUwA1XvMdAkOhXxP4gzL1PWIdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290102;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=j99u7pP3jHqCnfV5WtBilQ5GA+9ufePIWzsotxmVBBU=;
	b=1GuoZa2890+/2WVVBmWFvMVGRMmiHwvGa26WClKSXPLgRnFHoBOB4ewaT6fb9xjJq4M5
	 cQT/uQJjt2dKEBKdw1Q9rK301kr6iU3zK56+VA9cRSvGfe9ktbwDSilN7be++h4AyFzNT
	 A0Wwbtvup7l3IERC4AEwOHVLm7q8A+yxYjHtKKIJssBAlKZknF8w7cUc4UIFW0JeIC/5q
	 xV/GzINFiN7B5MPIZVtEiMR1F7BS5Oztvqp2kVoA9iVWX/sQcC9A6O7Udq6YMS2uHz/Cy
	 nCWv5B1k43Tzqkeb6rdtFWtroCSkckDXbdzX9ry6E67xmKLY9w2zubnCKI2338Hzk0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ApHOtygA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF748606A31F;
	Thu, 29 Oct 2026 16:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ApHOtygA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003F01F01825;
	Thu, 29 Oct 2026 16:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290101;
	bh=j99u7pP3jHqCnfV5WtBilQ5GA+9ufePIWzsotxmVBBU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ApHOtygAYie4o6OfC8p8riQyw/hRIKEDv65ljECOi0GbxgJG8hhaZZCSLV1Kaqp/7
	 zEmzGeCD+Mvtk8xp67myAQ9KKZCf2+iEgF4CbfBNy2R/ycA7Ayj9+MHo4CuSKSz61c
	 97AX1RHHqupm/dYhQryHBkxTxqUwAlTMkzWKYY3l5Fy8hBc9SDCG//kmewuIXKdO8Y
	 eNjVoewC3BCUxPV8ygBSL3Q+rzosvTCaK7215ZYw7839CsPKnIY9PEQWrVdUizRJtW
	 0AdJ/13Y/G8NVfaL8At+9hFR7AjOYUc4m9btUTtz5wTd0beeT6PMjKoTfoXo0MFXr6
	 uAmCFZl0/UEiQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:05 +0100
Subject: [PATCH v2 14/34] affs: don't set SB_RDONLY after filesystem errors
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-14-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3169; i=brauner@kernel.org;
 h=from:subject:message-id; bh=aNVN7e+XHpPHKN9tOY57qjlfaGO8JcRJCASZQZdJlkw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zte/Ebh0pecj7qbpW7nSayITpWwXyx4OFPh5/sHzY
 0LrXyq3dJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkETMjw5VvW8XD2QTabio7
 bnE42Suz78+K12eY1aYxP7iW9nt62i5GhqtLpBKr/zsWnqrKZ1e1dVY784VncfucO3Oyrwe/dPn
 4gQ0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

affs_error() sets SB_RDONLY from whatever context hit the error and
without holding s_umount. If that happens while the filesystem is frozen
through bdev_freeze(), e.g. by a device mapper suspend, thaw_super()
sees a read-only superblock and leaves the s_writers rwsems locked so
every writer hangs.

So call sb_set_emergency_ro() instead and let the VFS refuse
modifications. affs_write_inode() refuses as well and
affs_commit_super() leaves the root block alone in that state.

A remount to read-write fails until umount. A remount to read-only works
and keeps the bitmap around because evict and the last close still free
blocks, affs_kill_sb() frees it. Writes through file descriptors opened
before the error fail with EROFS.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/affs/amigaffs.c |  4 ++--
 fs/affs/inode.c    |  2 ++
 fs/affs/super.c    | 14 ++++++++++----
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index affa20d2b73d..40ee1998ff33 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -483,9 +483,9 @@ affs_error(struct super_block *sb, const char *function, const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &args;
 	pr_crit("error (device %s): %s(): %pV\n", sb->s_id, function, &vaf);
-	if (!sb_rdonly(sb))
+	/* SB_RDONLY needs s_umount, see sb_set_emergency_ro(). */
+	if (!sb_rdonly(sb) && sb_set_emergency_ro(sb))
 		pr_warn("Remounting filesystem read-only\n");
-	sb->s_flags |= SB_RDONLY;
 	va_end(args);
 }
 
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index c7de9c793ab8..009245ad6c99 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -173,6 +173,8 @@ affs_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 	pr_debug("write_inode(%llu)\n", inode->i_ino);
 
+	if (sb_emergency_ro(sb))
+		return -EROFS;
 	if (!inode->i_nlink)
 		// possibly free block
 		return 0;
diff --git a/fs/affs/super.c b/fs/affs/super.c
index ed8225b3c93d..655d7282a8de 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -36,6 +36,9 @@ affs_commit_super(struct super_block *sb, int wait)
 	struct buffer_head *bh = sbi->s_root_bh;
 	struct affs_root_tail *tail = AFFS_ROOT_TAIL(sb, bh);
 
+	if (sb_emergency_ro(sb))
+		return;
+
 	lock_buffer(bh);
 	affs_secs_to_datestamp(ktime_get_real_seconds(), &tail->disk_change);
 	affs_fix_checksum(sb, bh);
@@ -82,7 +85,7 @@ void affs_mark_sb_dirty(struct super_block *sb)
 	struct affs_sb_info *sbi = AFFS_SB(sb);
 	unsigned long delay;
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || sb_emergency_ro(sb))
 	       return;
 
 	spin_lock(&sbi->work_lock);
@@ -550,10 +553,13 @@ static int affs_reconfigure(struct fs_context *fc)
 	if ((bool)(fc->sb_flags & SB_RDONLY) == sb_rdonly(sb))
 		return 0;
 
-	if (fc->sb_flags & SB_RDONLY)
-		affs_free_bitmap(sb);
-	else
+	if (fc->sb_flags & SB_RDONLY) {
+		/* After an error evict still frees blocks, keep the bitmap. */
+		if (!sb_emergency_ro(sb))
+			affs_free_bitmap(sb);
+	} else {
 		res = affs_init_bitmap(sb, &fc->sb_flags);
+	}
 
 	return res;
 }

-- 
2.53.0

