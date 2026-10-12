Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B0F40EB8E;
	Mon, 12 Oct 2026 10:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800564; cv=none; b=K0q7VmbToRkQpW/tztqh4AZhQs2RSdjN87UxyBh/6Ult+C20CrCMnVdIeDHGe2GXIxeYMPRluc5+Vkk79C5ih4neP1D5w5xB3idQYiW6awCQpTHU+vqBuEa8orK3dWTmpHw8T79SFZdh+umUk1NAGe9C2ZMj3TzMOQCF0/gqAtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800564; c=relaxed/simple;
	bh=m9HMAv9a1fOM5krgPrYmWQd93RVUYC/3LXzbM13VD1k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=au9G4WkkADQERbfdndEjW++cwAbh1xoHnoTiEXUQsKp6duCMrynGnrSIfKvPvhMIQGvzGDIjMV8KhLOWlkxtutEspeNUjk3mng53jTpPvRjQtd2hL6WQZ9PP9dQ3SKpkcyF+W3L8qROFZxP3Vy8DG1zb+Kp0zjT8GgjEr1aXB+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UhCJdrFt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UhCJdrFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8741C1F0089C;
	Mon, 12 Oct 2026 10:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800552;
	bh=rSIW/rAgL2Kb5V6OxBiMsTNiVXImf8Nqjw/MsA27WOM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UhCJdrFt8l0VL93FCsrxax8gieStVE0sLxm3LTgVfMqxNfZfFPFa0ox0zAsgDM7y7
	 C3lWDoalPShkB1yNXcPE5raU4bRO2KYnUgpZt4udFbD7evp7LCfB0RiiNnLwJ1prAY
	 sIiuz2etN8qtMteoPL8znHEz2kqrXHqTilp2guEasF+HkT3xQEfvlKsgurCLU7GRri
	 /Inn+mU0KefpDRM99JTzhMBRu2LC/GuzWbcUrBKozxiDV4UM7Pzz/bQySfkYXN/v8f
	 R3K0mdMGIxLTfwA3oIhZ5rRYS0NBpaOWFSXzXGIivqnn49CP3q3C7LtwjUpovxpbm1
	 DR5+08uJiRZHg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:21:04 +0200
Subject: [PATCH RFC 19/28] btrfs: don't set SB_RDONLY after filesystem
 errors
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-19-60743a3dc326@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=11699; i=brauner@kernel.org;
 h=from:subject:message-id; bh=m9HMAv9a1fOM5krgPrYmWQd93RVUYC/3LXzbM13VD1k=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TL57A/rFtmrt7VvCej/FCtaWBhTul+45i7/4SBDe
 4ObCTwxHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOZOp2R4eYOl6aJ2lo7/zBV
 sW95MGdDDvtlxtNNSdyKS437i9bVhDMyTHrN5LY76EliS6XnBxn1L57zezNWflrytIvv9AG34B1
 vuAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

__btrfs_handle_fs_error() forces the filesystem read-only through
btrfs_set_sb_rdonly() which sets SB_RDONLY without holding
sb->s_umount. It can run from any context and every transaction abort
ends up there.

That races with every other writer of sb->s_flags. reconfigure_super()
does a WRITE_ONCE() of sb->s_flags and a second mount of the same device
does super_wake(SB_BORN) on the reused superblock. Either side can lose
its update.

It also breaks freezing. freeze_super() and thaw_super() both look at
sb_rdonly() to figure out whether the s_writers rwsems need to be taken
or released. If the handler runs while the filesystem is frozen
thaw_super() skips ->unfreeze_fs() and sb_freeze_unlock() and leaves the
rwsems write-locked. Writers block forever and umount warns:

  BTRFS: error (device vda) in s2_btrfs_err_init:55: errno=-5 IO failure
  BTRFS info (device vda state E): forced readonly

  [<0>] percpu_rwsem_wait+0x203/0x500
  [<0>] mnt_want_write+0x28f/0x2f0
  [<0>] lookup_open+0x135/0x1b20

  WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0x143/0x190, CPU#2: kworker/2:1/50
  Workqueue: events destroy_super_work
   percpu_free_rwsem+0x38/0xa0
   destroy_super_work+0x133/0x2f0

I could only trigger that with a debug module that calls the handler on
a frozen filesystem. Once btrfs_freeze() committed the running
transaction there's no transaction handle left that could be aborted.
And the only asynchronous caller that can still run after ->freeze_fs()
is btrfs_zone_finish_endio_workfn() on zoned devices. But that's luck
and not something we should rely on.

btrfs doesn't need SB_RDONLY for any of this. fs_info->fs_error already
stops new transactions, writes through open files and metadata
writeback. And BTRFS_FS_STATE_RO, which was always set together with
SB_RDONLY, is what btrfs checks at runtime since the previous patch. So
only set BTRFS_FS_STATE_RO in __btrfs_handle_fs_error() like ext4 does
since commit d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem
errors") and f2fs since commit 930c6ab93492 ("f2fs: fix to don't set
SB_RDONLY in f2fs_handle_critical_error()").

The filesystem now stays read-write as far as the VFS is concerned and
statfs() doesn't report ST_RDONLY after an error anymore. So we also set
a new BTRFS_FS_STATE_EMERGENCY_RO bit and show "emergency_ro" in the
mount options like ext4 does. fs_error can't be used for that because
open_ctree() sets it for read-only rescue mounts and for a filesystem
whose superblock carries the error flag as well. It isn't shown after
the shutdown ioctl either.

A remount to read-only after an error now actually does something
instead of being a no-op on an already read-only superblock. But
btrfs_remount_ro() can't commit anything in that state and would fail
with -EROFS after it already made the superblock read-only. So skip
btrfs_commit_super() and return 0 when BTRFS_FS_ERROR() is set. Skip
btrfs_delete_unused_bgs() as well. That can't be committed either and it
can finish zones on zoned devices. That also fixes the read-only remount
after the shutdown ioctl which failed the same way. A remount from
read-only to read-write after an error is still refused but with -EROFS
instead of -EINVAL now, which is what all the other filesystems return.

Freezing has to keep working too. sync_filesystem() and freeze_super()
used to take their read-only shortcuts. Now they call into btrfs and
btrfs_sync_fs() and btrfs_freeze() can't attach or commit a transaction
anymore. So ->sync_fs returns 0 once an error forced the filesystem
read-only and btrfs_freeze() sets BTRFS_FS_FROZEN and skips the commit.
btrfs_unfreeze() skips check_dev_super() in that state because the
superblocks on disk can lag behind after an error and thaw would report
them as modified unexpectedly. So syncfs(2), FIFREEZE, dm suspend with
lockfs (LVM snapshots) and the shutdown ioctl, which freezes first, keep
working. BTRFS_IOC_SYNC still returns -EROFS from
btrfs_start_delalloc_roots().

A few other things change for users. A second read-write mount of the
filesystem now succeeds where it used to fail. A non-forced remount to
read-only fails with -EBUSY while files opened for writing before the
error are still open. And stores through shared mappings set up before
the error get SIGBUS because btrfs_update_time() refuses now.

No btrfs path runs the error handler while frozen today, so the
reproducer needs a debug helper:

  mkfs.btrfs -f img; mount img /mnt
  fsfreeze -f /mnt
  # run __btrfs_handle_fs_error(fs_info, ..., -EIO, NULL) on /mnt, e.g. from
  # a module that resolves the symbol through a kprobe
  fsfreeze -u /mnt
  touch /mnt/x        # before: hangs in percpu_rwsem_wait() from mnt_want_write()
                      # after:  EROFS
  umount /mnt         # before: WARNING at rcu_sync_dtor() from destroy_super_work()

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/fs.h       |  8 ++++++--
 fs/btrfs/messages.c | 13 +++++++++++--
 fs/btrfs/super.c    | 45 +++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 58 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 92ba79cbbc6e..da00cdd89f9e 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -156,6 +156,9 @@ enum {
 	 */
 	BTRFS_FS_STATE_EMERGENCY_SHUTDOWN,
 
+	/* An error forced the fs read-only, see __btrfs_handle_fs_error(). */
+	BTRFS_FS_STATE_EMERGENCY_RO,
+
 	BTRFS_FS_STATE_COUNT
 };
 
@@ -1197,8 +1200,9 @@ static inline int btrfs_need_cleaner_sleep(const struct btrfs_fs_info *fs_info)
 
 /*
  * Check whether the filesystem is read-only. BTRFS_FS_STATE_RO is set and
- * cleared together with SB_RDONLY on mount, on remount and when an error forces
- * the filesystem read-only. Use this instead of sb_rdonly() at runtime.
+ * cleared together with SB_RDONLY on mount and remount. When an error forces
+ * the filesystem read-only BTRFS_FS_STATE_RO gets set without SB_RDONLY, see
+ * __btrfs_handle_fs_error(). Use this instead of sb_rdonly() at runtime.
  */
 static inline bool btrfs_fs_rdonly(const struct btrfs_fs_info *fs_info)
 {
diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index 9aee0e0d7e85..99cdd5f5a111 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -25,6 +25,7 @@ static const char fs_state_chars[] = {
 	[BTRFS_FS_STATE_SKIP_META_CSUMS]	= 'S',
 	[BTRFS_FS_STATE_LOG_CLEANUP_ERROR]	= 'L',
 	[BTRFS_FS_STATE_EMERGENCY_SHUTDOWN]	= 'E',
+	[BTRFS_FS_STATE_EMERGENCY_RO]		= 0,
 };
 
 static void btrfs_state_to_string(const struct btrfs_fs_info *info, char *buf)
@@ -171,8 +172,16 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
 
 	btrfs_discard_stop(fs_info);
 
-	/* Handle error by forcing the filesystem readonly. */
-	btrfs_set_sb_rdonly(sb);
+	/*
+	 * Handle error by forcing the filesystem readonly. We don't set
+	 * SB_RDONLY because that requires sb->s_umount, and changing it under
+	 * freeze_super() and thaw_super() leaves the freeze protection
+	 * unbalanced. The fs_error recorded above stops new transactions and
+	 * BTRFS_FS_STATE_RO makes btrfs refuse modifications, see
+	 * btrfs_fs_rdonly().
+	 */
+	set_bit(BTRFS_FS_STATE_RO, &fs_info->fs_state);
+	set_bit(BTRFS_FS_STATE_EMERGENCY_RO, &fs_info->fs_state);
 	btrfs_info(fs_info, "forced readonly");
 	/*
 	 * Note that a running device replace operation is not canceled here
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index ddb620ac241b..3db2c29f8972 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1044,6 +1044,19 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 	return btrfs_commit_transaction(trans);
 }
 
+/*
+ * Once an error forced the filesystem read-only nothing can be committed
+ * anymore. Don't fail syncfs(2) and freezing because of that. BTRFS_IOC_SYNC
+ * calls btrfs_sync_fs() directly and still reports the error.
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
@@ -1141,6 +1154,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",ref_verify");
 	if (btrfs_test_opt(info, REF_TRACKER))
 		seq_puts(seq, ",ref_tracker");
+	if (test_bit(BTRFS_FS_STATE_EMERGENCY_RO, &info->fs_state))
+		seq_puts(seq, ",emergency_ro");
 	seq_printf(seq, ",subvolid=%llu", btrfs_root_id(BTRFS_I(d_inode(dentry))->root));
 	subvol_name = btrfs_get_subvol_name_from_objectid(info,
 			btrfs_root_id(BTRFS_I(d_inode(dentry))->root));
@@ -1295,7 +1310,7 @@ static int btrfs_remount_rw(struct btrfs_fs_info *fs_info)
 	if (unlikely(BTRFS_FS_ERROR(fs_info))) {
 		btrfs_err(fs_info,
 			  "remounting read-write after error is not allowed");
-		return -EINVAL;
+		return -EROFS;
 	}
 
 	if (fs_info->fs_devices->rw_devices == 0)
@@ -1357,9 +1372,11 @@ static int btrfs_remount_ro(struct btrfs_fs_info *fs_info)
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
@@ -1394,6 +1411,13 @@ static int btrfs_remount_ro(struct btrfs_fs_info *fs_info)
 	 */
 	btrfs_qgroup_wait_for_completion(fs_info, false);
 
+	/*
+	 * Nothing can be committed after an error forced the filesystem
+	 * read-only, so don't fail the remount because of that.
+	 */
+	if (unlikely(BTRFS_FS_ERROR(fs_info)))
+		return 0;
+
 	return btrfs_commit_super(fs_info);
 }
 
@@ -2317,6 +2341,12 @@ static int btrfs_freeze(struct super_block *sb)
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 
 	set_bit(BTRFS_FS_FROZEN, &fs_info->flags);
+	/*
+	 * Nothing can be committed after an error forced the filesystem
+	 * read-only.
+	 */
+	if (btrfs_fs_rdonly(fs_info))
+		return 0;
 	/*
 	 * We don't need a barrier here, we'll wait for any transaction that
 	 * could be in progress on other threads (and do delayed iputs that
@@ -2391,7 +2421,13 @@ static int btrfs_unfreeze(struct super_block *sb)
 	 *
 	 * And since the fs is frozen, no one can modify the fs yet, thus
 	 * we don't need to hold device_list_mutex.
+	 *
+	 * After an error the super blocks on disk may lag behind, don't take
+	 * that for a modification.
 	 */
+	if (btrfs_fs_rdonly(fs_info))
+		goto out;
+
 	list_for_each_entry(device, &fs_info->fs_devices->devices, dev_list) {
 		ret = check_dev_super(device);
 		if (ret < 0) {
@@ -2401,6 +2437,7 @@ static int btrfs_unfreeze(struct super_block *sb)
 			break;
 		}
 	}
+out:
 	clear_bit(BTRFS_FS_FROZEN, &fs_info->flags);
 
 	/*
@@ -2531,7 +2568,7 @@ static const struct super_operations btrfs_super_ops = {
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

