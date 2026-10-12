Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC32B47F2C8;
	Mon, 12 Oct 2026 10:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800576; cv=none; b=piCl8t9M5timpV6SIsKwZ3jgZBcrTQQX1fADLBR0YFau3NuNCzdjHRs697zAPvaCmsWi3Q5CN/5G9NYT2wos7m5wsZoMgS8pCuOX3fCHq+iC5da7H7MarKuWhENOz/GNAAsO2MI6bQ02fH5hoNs4d1aJfwVIPr73y1k1ENbyNZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800576; c=relaxed/simple;
	bh=DGaZ8J+rm6cKBJ/paFb5aFTsl1acSQ3r+Pna/SPIiMU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=r/TSU3kZ7wro36LJQfg6d1IhjwPUZKWTpDcO4SL9O58TIbotFcV32ctnt+rYyyNZv4rXirYitvXVeSXdkJaLVsLG6lWxWMDE32U3REfKVqJVmIlKqYUtreg4NXP58iygdzV8R8J7qe8SrfDiwcgRP3kQFlOBXIKJltp7/iINRmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nd+BoRoS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nd+BoRoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB28B1F0089E;
	Mon, 12 Oct 2026 10:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800560;
	bh=TiQ6u27QVqRkaYucgQwXLnnqNfUXeSgXf9CAfvKz9d0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Nd+BoRoSXunxeXD6pel8QorGHvXnCfizTCXiWBDFQC5CusUwMaocFpZF0TJtyN5E4
	 rj0V6OdhelT0qVqwygoRkTBIXYtkOrC8wJWckiEREToDA5WE9E6CwBuZaSBIB8uHet
	 HvJ1ZsVo3cxm+wGPLta4nnLQZm/aOYOie6B8bAW3n6pf36Z9daWLchB9g4mG1OrFjL
	 6YJBOYyN3YOwkBtE6+VTvD9/DZ1BEfZqxWux8hUpRxmswnJSF0dR4ov9sVGv/Edghc
	 H1yzpKvJNcBkrCYhC7RH5gqbudf9o/D7PXODkqpPGborEGs6o10H4P35Rg0zWl2A71
	 j3gVLyGEceS4g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:21:06 +0200
Subject: [PATCH RFC 21/28] gfs2: don't set SB_RDONLY on withdraw
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-21-60743a3dc326@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=9758; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DGaZ8J+rm6cKBJ/paFb5aFTsl1acSQ3r+Pna/SPIiMU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TLZ4s6NQ1diecLundrMUrljofGkxPUl7txPj8+o8
 r8qKDH/QEcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEwo0ZGVb9aly3J/D1gcr4
 /vokvQXK/kZCMbWb3WI4f1zWFQzYuJ/hD+8uj7wJc8Q1eswCmfbfaV69UCDbL34ql7PDuYTfR91
 42AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

do_withdraw() sets SB_RDONLY from the withdraw work item without holding
sb->s_umount. gfs2_withdraw() sets SDF_WITHDRAWN right away and queues
gfs2_withdraw_func() which runs do_withdraw(). That also happens on a
frozen filesystem. SDF_JOURNAL_LIVE is still set then because the
freeze log flush doesn't clear it.

freeze_super() and thaw_super() both look at sb_rdonly() to figure out
whether the s_writers rwsems need to be taken or released. gfs2 doesn't
even get that far. FITHAW goes through gfs2_thaw_super() to
gfs2_do_thaw() whose gfs2_freeze_lock_shared() fails with -EIO for a
withdrawn filesystem. So FITHAW never gets to thaw_super() and the
filesystem stays frozen. The only ways out are emergency thaw, which
calls thaw_super_locked() directly, and writing 0 to the gfs2 "freeze"
sysfs file, which calls thaw_super() directly. Both see SB_RDONLY and
skip sb_freeze_unlock(). The rwsems stay write-locked, writes through
file descriptors opened before the withdraw hang and umount warns:

  gfs2: fsid=s2test:s2fs.0: can't lock the freeze glock: -5
  gfs2: fsid=s2test:s2fs.0: GFS2: couldn't thaw filesystem: -5
  sysrq: Emergency Thaw of all frozen filesystems
  WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0x143/0x190

  [<0>] percpu_rwsem_wait+0x203/0x500
  [<0>] vfs_write+0xb57/0xfa0

Withdrawing first and freezing afterwards isn't any better.
freeze_super() freezes the read-only superblock without the rwsems,
gfs2_lock_fs_check_clean() fails with -EIO and gfs2_do_thaw() can't get
the freeze glock. FIFREEZE fails with -EIO and the superblock stays
frozen and pinned for good.

SDF_WITHDRAWN already stops all modifications. Glocks fail with -EIO,
gfs2_trans_begin() with -EROFS and log flushes and metadata reads are
refused. So stop setting SB_RDONLY in do_withdraw() like ext4 did in
commit d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem
errors"). A few things have to come with that:

(1) gfs2_evict_inode() and gfs2_quota_sync() check gfs2_withdrawn() next
    to sb_rdonly(). Eviction writes the inode glock's metadata in place
    and umount evicts everything.

(2) gfs2_write_inode() returns -EIO once withdrawn. sync(2), syncfs(2),
    freeze and umount skipped writeback for the read-only superblock.
    Now they reach ->write_inode() which writes the glock address space
    in place without a withdrawn check, and gfs2_ail_drain() leaves
    committed buffers dirty. Data writeback needs no check because the
    block mapping goes through gfs2_meta_read() which fails once
    withdrawn.

(3) gfs2_do_thaw() thaws even if the freeze glock can't be taken again
    because the filesystem withdrew. A withdrawn filesystem can't write
    anything and its lockspace is gone anyway.

(4) gfs2_freeze_super() refuses a withdrawn filesystem with -EIO before
    calling freeze_super(). It can't take the freeze glock anymore and
    freeze_super() would now take the rwsems of the read-write
    superblock before gfs2_lock_fs_check_clean() fails.

Note that the SB_RDONLY change and (3) have to go in together and the
rest has to be in place by then. With only the SB_RDONLY change a freeze
after a withdraw takes the rwsems of the now read-write superblock and
stays frozen for good with writers blocked. With only (3) FITHAW reaches
thaw_super() on the read-only superblock and leaks the rwsems. And
without (4) a freeze after a withdraw goes through the error path of
gfs2_freeze_super() which re-locks sd_freeze_gh while
gfs2_lock_fs_check_clean() still holds it. The umount that is now
possible then hangs in gfs2_wait_glocks().

While withdrawn a remount to read-write fails with -EROFS instead of the
-EIO from gfs2_make_fs_rw(). A remount to read-only goes through
gfs2_make_fs_ro() which writes nothing once do_withdraw() has run, and
since the previous patch gfs2_make_fs_ro() waits for that. So emergency
remount (sysrq u), which now forces every withdrawn gfs2 read-only,
works without a WARN.

We show "withdrawn" in the mount options next to the existing
"demote_interface_used". A withdrawn filesystem stays "rw" so statfs()
doesn't report ST_RDONLY anymore, and the "Mounted RO" line in the sysfs
status file and the RDONLY= uevent field read 0 too. A second mount of
the device and a gfs2meta mount have to be read-write now. And like with
"emergency_ro" on ext4, remount helpers that pass the shown options back
fail. busybox mount for example now gets "Unknown parameter
'withdrawn'".

Path based operations fail with -EIO as before. The mount root is the
exception because it isn't looked up. So operations on it now fail with
-EIO from the glocks instead of -EROFS from mnt_want_write(), and the
same goes for fd based chmod, chown, utimes, setxattr and fileattr
changes. syncfs(2) on a withdrawn filesystem returns gfs2_sync_fs()'s
sd_log_error, e.g. -EIO, instead of 0. FITHAW of a filesystem that
withdrew while frozen works now and FIFREEZE of a withdrawn filesystem
fails with -EIO without freezing it.

Reproducer (the sb_rdonly selftest at the end of this series covers it
as well):

  mkfs.gfs2 -O -p lock_nolock -j 1 -t test:fs img; mount -o loop img /mnt
  exec 3>>/mnt/a 4</mnt          # paths stop working after the withdraw
  fsfreeze -f /mnt
  echo 1 > /sys/fs/gfs2/test:fs/withdraw; sleep 8
  <FITHAW on fd 4>               # before: EIO, stays frozen; after: thawed
  echo j > /proc/sysrq-trigger   # before: the only way out, leaks the rwsems
  echo x >&3                     # before: hangs in percpu_rwsem_wait(); after: EIO
  umount /mnt                    # before: WARNING at rcu_sync_dtor()

Fixes: 601ef0d52e96 ("gfs2: Force withdraw to replay journals and wait for it to finish")
Fixes: b77b4a4815a9 ("gfs2: Rework freeze / thaw logic")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/gfs2/ops_fstype.c |  6 +++++-
 fs/gfs2/quota.c      |  2 +-
 fs/gfs2/super.c      | 19 +++++++++++++++++--
 fs/gfs2/util.c       |  6 ++++--
 4 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 718e0da7dfce..d7f7e8b75971 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1594,7 +1594,11 @@ static int gfs2_reconfigure(struct fs_context *fc)
 		if (fc->sb_flags & SB_RDONLY) {
 			gfs2_make_fs_ro(sdp);
 		} else {
-			error = gfs2_make_fs_rw(sdp);
+			/* A withdrawn filesystem can't go back to read-write. */
+			if (gfs2_withdrawn(sdp))
+				error = -EROFS;
+			else
+				error = gfs2_make_fs_rw(sdp);
 			if (error)
 				errorfc(fc, "unable to remount read-write");
 		}
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 001c8b39ca55..7fac70bae129 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1329,7 +1329,7 @@ int gfs2_quota_sync(struct super_block *sb, int type)
 	u64 sync_gen;
 	int error = 0;
 
-	if (sb_rdonly(sdp->sd_vfs))
+	if (sb_rdonly(sdp->sd_vfs) || gfs2_withdrawn(sdp))
 		return 0;
 
 	qda = kzalloc_objs(struct gfs2_quota_data *, max_qd);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 1d7b39354d65..ec7bce124376 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -456,6 +456,9 @@ static int gfs2_write_inode(struct inode *inode, struct writeback_control *wbc)
 	int ret = 0;
 	bool flush_all = (wbc->sync_mode == WB_SYNC_ALL || gfs2_is_jdata(ip));
 
+	if (gfs2_withdrawn(sdp))
+		return -EIO;
+
 	if (flush_all)
 		gfs2_log_flush(GFS2_SB(inode), ip->i_gl,
 			       GFS2_LOG_HEAD_FLUSH_NORMAL |
@@ -686,7 +689,12 @@ static int gfs2_do_thaw(struct gfs2_sbd *sdp, enum freeze_holder who, const void
 	int error;
 
 	error = gfs2_freeze_lock_shared(sdp);
-	if (error)
+	/*
+	 * A withdrawn filesystem can't get the freeze glock back, but it won't
+	 * write anything either. Thaw it anyway instead of leaving it frozen
+	 * for good.
+	 */
+	if (error && !gfs2_withdrawn(sdp))
 		goto fail;
 	error = thaw_super(sb, who, freeze_owner);
 	if (!error)
@@ -751,6 +759,11 @@ static int gfs2_freeze_super(struct super_block *sb, enum freeze_holder who,
 		mutex_unlock(&sdp->sd_freeze_mutex);
 		return -EBUSY;
 	}
+	/* A withdrawn filesystem can't take the freeze glock anymore. */
+	if (gfs2_withdrawn(sdp)) {
+		mutex_unlock(&sdp->sd_freeze_mutex);
+		return -EIO;
+	}
 
 	for (;;) {
 		error = freeze_super(sb, who, freeze_owner);
@@ -1165,6 +1178,8 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
 		seq_puts(s, ",nobarrier");
 	if (test_bit(SDF_DEMOTE, &sdp->sd_flags))
 		seq_puts(s, ",demote_interface_used");
+	if (gfs2_withdrawn(sdp))
+		seq_puts(s, ",withdrawn");
 	if (args->ar_rgrplvb)
 		seq_puts(s, ",rgrplvb");
 	if (args->ar_loccookie)
@@ -1466,7 +1481,7 @@ static void gfs2_evict_inode(struct inode *inode)
 	int ret;
 
 	gfs2_holder_mark_uninitialized(&gh);
-	if (sb_rdonly(sb) || !ip->i_no_addr || !ip->i_gl)
+	if (sb_rdonly(sb) || gfs2_withdrawn(sdp) || !ip->i_no_addr || !ip->i_gl)
 		goto out;
 
 	/*
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 1535ce2b7aa8..990552f42a0b 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -133,9 +133,11 @@ static void do_withdraw(struct gfs2_sbd *sdp)
 			   gfs2_log_is_empty(sdp),
 			   HZ * 5);
 
-	sdp->sd_vfs->s_flags |= SB_RDONLY;
-
 	/*
+	 * We don't set SB_RDONLY. That requires sb->s_umount, and changing it
+	 * under freeze_super() and thaw_super() leaves the freeze protection
+	 * unbalanced. SDF_WITHDRAWN already stops all modifications.
+	 *
 	 * Dequeue any pending non-system glock holders that can no
 	 * longer be granted because the file system is withdrawn.
 	 */

-- 
2.53.0

