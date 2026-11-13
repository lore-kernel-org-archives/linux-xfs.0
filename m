Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571280;
	b=tun/2sJLjTWVs12GY7NfAkQh6Eq/qt+hZu+2MjgK6wZ4VhtC3XIFyHI2CrkCMOeh8TIW
	 Ofps2kLOW3P5BBk37Y+A2/8GPqwETvlWUG5HK4ooVSeW14XAOcsIsZ1FaRLb83YFpUEaC
	 +YI42wBSNqXUMTv6wUyn4iF3XhlAuD7mwOXRmYUPfht7bGPpHV0sv2EAq0m/wWuwYGdSk
	 7wZTrl41psCMNZXoDZPyW+XqqE0YWDE//+ADGVVaWqDkOn9tefjDJ0PXXn1nbb0xmYK5y
	 DvA87YKBHuq3sTetxAtsNRxCUGjOIPK+kmOLtTMX0Oc+OuvNgiXJ5SNMLP21rkT/ZAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571280;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=GszE2anAQxCWM5fQiE+znviLqpcjSCVYI4wX3Rv50lw=;
	b=bqbjisORrGVCcUw1JhHmrPT26jGAkSXKHhSFp/G5CwjaOCN7XPXGhZTdw9EmYsLsFCky
	 HTk3+VOYazdleu32Pj29I7dghHp7Dl1QvVDgUNOae6Tk/UMs3f5icbkKCnesu2KlfO67b
	 N/8OZW0QKV7IkR3IVimZfU2DTzQ8tcVSazgM1I67ltI5Aac2Hb+V8TeqDRzkUtRXfYx+K
	 zqbxee5FU2mGBjwoW7ryUE1dEQGd/6MrCSWM9/LP8EMWsrmNvesBG2IkMUnI8hCw8tHiC
	 nwfWPad0vL6YUNzx9VU4Kw1+ES1KsEbuSq6UMvM+FYVm4UhuWJXUUixFm0oVX7am/Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TMQuyq+6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADDE606A334;
	Fri, 13 Nov 2026 12:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TMQuyq+6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7672A1F000C5;
	Fri, 13 Nov 2026 12:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571280;
	bh=GszE2anAQxCWM5fQiE+znviLqpcjSCVYI4wX3Rv50lw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TMQuyq+6p608xsqKXRQqwgGlwSiM0dRFCXDUPlf6N0gX0MxCWF3e1DGAdkn//5+tV
	 YznW11mwNZ30EOc7xDIGsEhvmn1N2+9yDClEf9GWCFGLUfO7rdTDHPl2aQPYmVvaao
	 7cZSykBwXej9Oi1uLjQYdatvZ5LdlYdCCuZ9Bs4vgavxO5qtL4zICJHtanvG3kZ+BT
	 9JhSKJhCLFj5pd6NCWDkdrAA9cOVsadSEE6XqCDa3Y+TXkywSsCmzKxTyRVw0UqhRy
	 qD+lu2S/s8bi0oYPoSxdA5pAoL15RT2lffhHegCUbGYXGTDp/icKPjuu+641Ly5cU3
	 Mt1Ch42vm5sEg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:12 +0100
Subject: [PATCH v3 16/33] affs: don't set SB_RDONLY after filesystem errors
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-16-0be92bb73709@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2952; i=brauner@kernel.org;
 h=from:subject:message-id; bh=nlF3ceMBkFeAzDOwb5efWgYEsyPK+IFw+V5w64DXzAA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+71m00LxFRWnTCUtLaYL6N2zbF/MKnflzZQ5Xb5L5
 3k/ObdepKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiS4IZ/tfxTH17ZNFmu+3p
 m3WyZku+DV51TzhCYU9D5u1n6x5fd1vB8Fdq9y35Ywsst0yRestWOvWxToz0LvGtbi8ynL+uPtv
 22ZgVAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

affs_error() sets SB_RDONLY from whatever context hit the error and
without holding s_umount. If that happens while the filesystem is frozen
through bdev_freeze(), e.g. by a device mapper suspend, thaw_super()
sees a read-only superblock and leaves the s_writers rwsems locked so
every writer hangs.

So call sb_set_emergency_ro() instead and let the VFS refuse
modifications. affs_commit_super() leaves the root block alone in that
state. affs_write_inode() keeps working because writeback still writes
the data and the bitmap and extension blocks the inode points at.

After a remount to read-only a remount to read-write fails until umount.
A plain remount to read-write right after the error succeeds but the
filesystem stays read-only. A remount to read-only works and keeps the
bitmap around because evict and the last close still free blocks,
affs_kill_sb() frees it. Writes through file descriptors opened before
the error fail with EROFS.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/affs/amigaffs.c |  4 ++--
 fs/affs/super.c    | 14 ++++++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index affa20d2b73d0..40ee1998ff337 100644
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
 
diff --git a/fs/affs/super.c b/fs/affs/super.c
index ed8225b3c93dd..0957af26652d9 100644
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
+	if (sb_rdonly_any(sb))
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

