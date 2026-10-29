Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290143;
	b=DBHef2oa6QqlP+AQpdSDvGli49r/sWL0wmm+dH+HfVSCR/w/CDrhOHRBzfQhlIgGrKHX
	 2RA+ae+mSvZiAedl4+8SIYx5OzK2AHDvl6Px8+1WwyADmklP1j17elXQYiNScWBliyR7K
	 d9JvW2g+Qer7oDuczw1CMXgoI4a+UQNvByOVlHriGUkiIN+GgUVXfvdHxAYWKWwU0sdfa
	 DkhuU0zfk2xBKiXSsN5GNME3VkNVIh5JBbHitbC3zf02o2i4vYkTFc06wpGjVB6Sw7D7L
	 EcPuX4gaWPSvdO4JrAxhwM1ZzNm5eEkb6uKpWre8+Aw4Wda0sgvW9cuHGjNnanDbD0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290143;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=VMmV1HjKwS2t3cIFIFMQEeXvmjZcFVkEtfvXpaBoIbc=;
	b=fBGtHIljwCEJ5PJW8PyqQ0ygruW4TNiSjy3VAUzCWzIDpGUN/89qwrWPNmu/PQqBsIkf
	 ooLqdB3reYJujHtB1Xy8ir7X5UmZ8H6dX7cuCBlMYpTosaLQh7DDZMyuscSDo1Osamnqi
	 82SZPRm1XBT0M4lD49jmvXklHlIXXgGWL+VJ4O4MExoUzN5SY98hHqpj84LQG2f5OzYWU
	 BqZtKYxPs600OKDU3sDuFqLO8grB3Ve7DQaAmv9jBm9OPifmP0SBHl/P1xFL92mVR6TPI
	 YGN0c7Wiz+B6sIy8qFKx3pPxjTyrVQ+Kg9NcrSfXA+Z5dEFhw1sDHzXmVmYEKiSvTpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WjyM4Lca;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D82606A326;
	Thu, 29 Oct 2026 16:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WjyM4Lca
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA39C1F01824;
	Thu, 29 Oct 2026 16:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290143;
	bh=VMmV1HjKwS2t3cIFIFMQEeXvmjZcFVkEtfvXpaBoIbc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WjyM4LcavVSXWExa7KaOhY6Q9yH84Fyeo9Od9x/l0YIPdjuBj/9T8AKsQg0JhHXqX
	 CogoL2OmTJqgK2kqdSY5vVVcHR1skRbO4d1cLLtwT5oXhRSyQU2jjI8o+rvLL+EpQ/
	 lReqibcCJA7Yy5PHFLxJCiU/v8b7rCxWgZPcL+EpjW5bTqiPaYwFeZWZd+wAPVLh/H
	 tRRQOHxC7OOMTAHZKiNIf9oChLLzdl6KRT2ixdock9zX+e0CpX4CKe2zUCfIxU/s3b
	 0bdY0H/6EvwmlZMxlFcC4emeiPyxCFkLq/1GyXIS5hs0r2RAi6APOg3PA16aS19tbe
	 scCsX4ASfVkwQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:15 +0100
Subject: [PATCH v2 24/34] btrfs: don't set SB_RDONLY after filesystem
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-24-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6579; i=brauner@kernel.org;
 h=from:subject:message-id; bh=7AnW6mFvT4UU2Yt5m3ZEeRnneAJadQLaXrcqQlZGYy8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjdI/jn126kwnbiXy+Mld19beOaqllKuwtut8/4s+
 +r99ED0oo5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJuGswMhwoktBS97Jh4bki
 tUb36hvJV4uXd6RwTnhttJOh8NhHhtkM//0ibvxNNfml/+isryjP38r84HsO+7vcH/EG/tk652p
 ZDRMA
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
superblock as read-only. That's not done for the shutdown ioctl, rescue
mounts or a superblock that already carries the error flag.

A remount to read-only now actually happens after an error, so
btrfs_remount_ro() skips the commit and the unused block group pass that
can't succeed anymore. Going read-write fails with EROFS instead of
EINVAL. ->sync_fs returns 0 and btrfs_freeze() skips its commit in that
state so freezing keeps working, and the thaw skips check_dev_super()
because the superblocks on disk may not match after an error.

A second read-write mount of the filesystem succeeds now. A non-forced
remount to read-only fails with EBUSY while files that were opened for
writing before the error are still open.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/fs.h       |  5 ++---
 fs/btrfs/messages.c |  8 ++++++--
 fs/btrfs/super.c    | 35 +++++++++++++++++++++++++++++++----
 3 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 024c3ec7d058..b121fa969b89 100644
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
diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index cedca4050831..3a768e2ac1cc 100644
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
index b424cc836bd4..ff61ec9ebfa7 100644
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

