Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571323;
	b=GJrQQeMJfx+sDf6TWwN23cvOyJ+mDJz4A3Tk9czUoK+1JNDoVgj/TrJRzDCHQ3/KZeTO
	 rGZ2FX0PNs7vo747Qwma5Y/rNlUfPxtiN008jvbjl8sTz9jiFAWdN9P4Sa3w3cb3AwkQI
	 ixt4A5u/pFu5QuCtPJVT0DCPMW3++huIy3fPV1jYQy7tsAFHSd1oX+FF1ykui3S2V/z40
	 hfbkzJ7XSW+DUluEwtHYhjfyXc2IC19meUJmh3MiUaRV5cdLziP4Pl/gh2kN99q8nrvef
	 2c7LV8MsRSWGxgE10xe/FTHzId83jSmPbOWdY1Pgk+PWz1Wmou8qj4U5tkudEqfJQbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571323;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=+Ow1hJfO48deuGkhrYlAsCvQdwxNlOUTrn1uGHKQmZQ=;
	b=dJ8Fa6uqQrnImoFbNO/kXKm6KW5V0wAwPRlZV1+mmI8Y2Lakbs7Kf1yaixVJW1Tc4qBb
	 AO/cc3gnvyjpjvlWpwREdYALQ/EqBymCDlRoh8VWqpIHQVp6jfqnjHgDXcPiG17hL9vYX
	 RAUFsRB9n/v4IC+uiCcaV7PkJkb/6lFI0hqOJ6Va+qh1m72Ac41VeG+hn5aSXu5jwY4+U
	 eK09cOGzqIm6Ms+dSxQ0mrwEzWQh/BHylpRbIG5GiDso2w5E2kCtVjGGjsK2JmpE8KVsN
	 6dUtK/z6Jld/qkxFeunBFkZVdD35XzB6kixGWEgvVGCoi+NcDXpdgS2F1tph7Z1yGNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jTTdJq3Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9745F606A88D;
	Fri, 13 Nov 2026 12:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jTTdJq3Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B921F000C4;
	Fri, 13 Nov 2026 12:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571323;
	bh=+Ow1hJfO48deuGkhrYlAsCvQdwxNlOUTrn1uGHKQmZQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jTTdJq3ZHQO17xb1iVOpqx2VTyAHhHtIJVfqcsF5CgXMewwsOUDO0PGAsvU6p+LpF
	 TV3JzlautUj4L70UOUEDWlY3bZSV1dPbUEsN/m0YfrITpmQP/KGytfNTOcJ0W7x19D
	 DzQ8NvQQLP8CLRtZb9XUNruqdy7nHLpZC8fV1S5w5MpXFNHWC7YQCnw0k1qtN9ShWb
	 ReInI2kgJadpToBmQGYul0Y7E0e7OnBYAAdW0Z/rTwv5T2xYp5tAJvPpMUxrxKckqV
	 Zt6tG2Qg3OiYXPBetd6NbpVajzfYTqXiNREfZPOS/6Ga6R4dRpmzpZ58YMWSjwasFU
	 kb++q785qgsFQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:22 +0100
Subject: [PATCH v3 26/33] btrfs: don't set SB_RDONLY after filesystem
 errors
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-26-0be92bb73709@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8494; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qEpzIjmevC5rqt8moTob6So4JiC8WNq/cSBOGdRGEnE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+71jTyXTxEnTJTw5T1bwJM7ZOevytnVXb85fZKKeq
 GvuY7DVv6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiRt8ZGaYy9WnGRbe0X/Xm
 2rVCWIqpcfvTrtcb6nbvqNVcyPHNwY6R4cj3j63L2l2Z5Th0yhfO+hpVwdUd4/Fi3dqpUi96JSY
 m8AAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

__btrfs_handle_fs_error() sets SB_RDONLY through btrfs_set_sb_rdonly()
without holding s_umount. It runs from any context and every transaction
abort ends up there. That races with everyone else changing sb->s_flags.
And if it happens while the filesystem is frozen thaw_super() sees a
read-only superblock and leaves the s_writers rwsems locked. Today only
btrfs_zone_finish_endio_workfn() can get there after ->freeze_fs() but
that's luck.

btrfs doesn't need SB_RDONLY for any of this. fs_error already stops new
transactions and BTRFS_FS_STATE_RO is what btrfs checks since the
previous patch. So only set that like ext4 and f2fs do and call
sb_set_emergency_ro() so the VFS refuses modifications and reports the
superblock as read-only. That's not done for rescue mounts or a
superblock that already carries the error flag. btrfs_force_shutdown()
sets BTRFS_FS_STATE_RO too but not the VFS state, so opening a file for
writing fails with EROFS instead of EIO after a shutdown.

A remount to read-only now actually happens after an error, so
btrfs_remount_ro() skips the commit and the unused block group pass that
can't succeed anymore. Going read-write fails with EROFS instead of
EINVAL. The VFS doesn't call ->sync_fs in that state and refuses a new
freeze with EROFS, so BTRFS_IOC_SHUTDOWN shuts down without the freeze
after an error. btrfs_freeze() still skips its commit after a shutdown
or when the error races the freeze, and the thaw skips
check_dev_super() because the superblocks on disk may not match after
an error.

A second read-write mount of the filesystem succeeds now. A non-forced
remount to read-only fails with EBUSY while files that were opened for
writing before the error are still open.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/fs.h       | 16 ++++++----------
 fs/btrfs/ioctl.c    |  5 +++++
 fs/btrfs/messages.c |  8 ++++++--
 fs/btrfs/super.c    | 35 +++++++++++++++++++++++++++++++----
 4 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 024c3ec7d0583..39fd1a04d25ba 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -1195,9 +1195,8 @@ static inline int btrfs_need_cleaner_sleep(const struct btrfs_fs_info *fs_info)
 }
 
 /*
- * Check whether the filesystem is read-only. BTRFS_FS_STATE_RO is set and
- * cleared together with SB_RDONLY on mount, on remount and when an error forces
- * the filesystem read-only. Use this instead of sb_rdonly() at runtime.
+ * Set and cleared with SB_RDONLY on mount and remount but set alone after an
+ * error. Use this instead of sb_rdonly() at runtime.
  */
 static inline bool btrfs_fs_rdonly(const struct btrfs_fs_info *fs_info)
 {
@@ -1233,15 +1232,12 @@ static inline bool btrfs_is_shutdown(const struct btrfs_fs_info *fs_info)
 static inline void btrfs_force_shutdown(struct btrfs_fs_info *fs_info)
 {
 	/*
-	 * Here we do not want to use handle_fs_error(), which will mark the fs
-	 * read-only.
-	 * Some call sites like shutdown ioctl will mark the fs shutdown when
-	 * the fs is frozen. But thaw path will handle RO and RW fs
-	 * differently.
-	 *
-	 * So here we only mark the fs error without flipping it RO.
+	 * A shutdown isn't an error, so don't use btrfs_handle_fs_error().
+	 * BTRFS_FS_STATE_RO doesn't touch SB_RDONLY, so it's fine while the
+	 * filesystem is frozen, e.g. for the shutdown ioctl.
 	 */
 	WRITE_ONCE(fs_info->fs_error, -EIO);
+	set_bit(BTRFS_FS_STATE_RO, &fs_info->fs_state);
 	if (!test_and_set_bit(BTRFS_FS_STATE_EMERGENCY_SHUTDOWN, &fs_info->fs_state)) {
 		btrfs_crit(fs_info, "emergency shutdown");
 		fserror_report_shutdown(fs_info->sb, GFP_KERNEL);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2063075906c8f..7f88eeb8afc57 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5165,6 +5165,11 @@ static int btrfs_ioctl_shutdown(struct btrfs_fs_info *fs_info, unsigned long arg
 	if (btrfs_is_shutdown(fs_info))
 		return 0;
 
+	/* After an error there is nothing to flush and freezing fails. */
+	if (flags != BTRFS_SHUTDOWN_FLAGS_NOLOGFLUSH &&
+	    sb_emergency_ro(fs_info->sb))
+		flags = BTRFS_SHUTDOWN_FLAGS_NOLOGFLUSH;
+
 	switch (flags) {
 	case BTRFS_SHUTDOWN_FLAGS_LOGFLUSH:
 	case BTRFS_SHUTDOWN_FLAGS_DEFAULT:
diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index cedca40508315..3a768e2ac1ccf 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -173,8 +173,12 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
 
 	btrfs_discard_stop(fs_info);
 
-	/* Handle error by forcing the filesystem readonly. */
-	btrfs_set_sb_rdonly(sb);
+	/*
+	 * Handle error by forcing the filesystem readonly. SB_RDONLY needs
+	 * s_umount, see sb_set_emergency_ro().
+	 */
+	set_bit(BTRFS_FS_STATE_RO, &fs_info->fs_state);
+	sb_set_emergency_ro(sb);
 	btrfs_info(fs_info, "forced readonly");
 	/*
 	 * Note that a running device replace operation is not canceled here
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b424cc836bd4a..ff61ec9ebfa79 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1041,6 +1041,18 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 	return btrfs_commit_transaction(trans);
 }
 
+/*
+ * Nothing can be committed after an error, don't fail syncfs(2) and freezing.
+ * BTRFS_IOC_SYNC calls btrfs_sync_fs() directly and still gets the error.
+ */
+static int btrfs_super_sync_fs(struct super_block *sb, int wait)
+{
+	if (btrfs_fs_rdonly(btrfs_sb(sb)))
+		return 0;
+
+	return btrfs_sync_fs(sb, wait);
+}
+
 static void print_rescue_option(struct seq_file *seq, const char *s, bool *printed)
 {
 	seq_printf(seq, "%s%s", (*printed) ? ":" : ",rescue=", s);
@@ -1286,7 +1298,7 @@ static int btrfs_remount_rw(struct btrfs_fs_info *fs_info)
 	if (unlikely(BTRFS_FS_ERROR(fs_info))) {
 		btrfs_err(fs_info,
 			  "remounting read-write after error is not allowed");
-		return -EINVAL;
+		return -EROFS;
 	}
 
 	if (fs_info->fs_devices->rw_devices == 0)
@@ -1348,9 +1360,11 @@ static int btrfs_remount_ro(struct btrfs_fs_info *fs_info)
 	 * Setting SB_RDONLY will put the cleaner thread to sleep at the next
 	 * loop if it's already active.  If it's already asleep, we'll leave
 	 * unused block groups on disk until we're mounted read-write again
-	 * unless we clean them up here.
+	 * unless we clean them up here. Not after an error though, that can't be
+	 * committed anymore and may still finish zones.
 	 */
-	btrfs_delete_unused_bgs(fs_info);
+	if (!BTRFS_FS_ERROR(fs_info))
+		btrfs_delete_unused_bgs(fs_info);
 
 	/*
 	 * The cleaner task could be already running before we set the flag
@@ -1385,6 +1399,10 @@ static int btrfs_remount_ro(struct btrfs_fs_info *fs_info)
 	 */
 	btrfs_qgroup_wait_for_completion(fs_info, false);
 
+	/* Nothing can be committed after an error, don't fail the remount. */
+	if (unlikely(BTRFS_FS_ERROR(fs_info)))
+		return 0;
+
 	return btrfs_commit_super(fs_info);
 }
 
@@ -2308,6 +2326,9 @@ static int btrfs_freeze(struct super_block *sb)
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 
 	set_bit(BTRFS_FS_FROZEN, &fs_info->flags);
+	/* Nothing can be committed after an error. */
+	if (btrfs_fs_rdonly(fs_info))
+		return 0;
 	/*
 	 * We don't need a barrier here, we'll wait for any transaction that
 	 * could be in progress on other threads (and do delayed iputs that
@@ -2382,7 +2403,12 @@ static int btrfs_unfreeze(struct super_block *sb)
 	 *
 	 * And since the fs is frozen, no one can modify the fs yet, thus
 	 * we don't need to hold device_list_mutex.
+	 *
+	 * After an error the super blocks on disk may lag behind, skip it.
 	 */
+	if (btrfs_fs_rdonly(fs_info))
+		goto out;
+
 	list_for_each_entry(device, &fs_info->fs_devices->devices, dev_list) {
 		ret = check_dev_super(device);
 		if (ret < 0) {
@@ -2392,6 +2418,7 @@ static int btrfs_unfreeze(struct super_block *sb)
 			break;
 		}
 	}
+out:
 	clear_bit(BTRFS_FS_FROZEN, &fs_info->flags);
 
 	/*
@@ -2522,7 +2549,7 @@ static const struct super_operations btrfs_super_ops = {
 	.drop_inode	= btrfs_drop_inode,
 	.evict_inode	= btrfs_evict_inode,
 	.put_super	= btrfs_put_super,
-	.sync_fs	= btrfs_sync_fs,
+	.sync_fs	= btrfs_super_sync_fs,
 	.show_options	= btrfs_show_options,
 	.show_devname	= btrfs_show_devname,
 	.alloc_inode	= btrfs_alloc_inode,

-- 
2.53.0

