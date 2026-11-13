Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571246;
	b=YH6C6OzEC8u71VEMcHDzlCUHyyevxSEF/lFFL4F63N3DOThc5lXznSHh6u9JQ1N8vXn4
	 oVX2SAMxGy3rFN8k3yNebGwPFfjp1Bq5ShNTeCkaqoaKG+OtYBXLQc73HXJ0iDbHG7GTI
	 1N3KVml5cRFb4NKd2xeHcWCsmpuR2dRIdc5StYVwEfhWoOpvbDfLji7f38ibSL3aSCSeu
	 w/mVGhaJZ+gYME1gLq4kXaMY7QOahSPg4ZOuDLleqZPTIZll+7br3po59BLSHWKnSmgRB
	 SHxAsMLmzCDrDlB5NpWi3zhfJPZExGk36nS2Z3e/nlhWRHWLPd2Grur9sd8Z0rcJKZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571246;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=83Rx4lxHAigAFvMox5os5PJcxLMzTjusx4xtzuuPVx0=;
	b=qRG4SBL5HLxVhanDZBKA/xailmypPDMtV+Nt4foDyT1i1Uy8Ap3mILlkUp68PKSC32UJ
	 85isafpeOzXdy9bfukEwH8mYv77kYHG75TBnaq959da+rs9+FiBDVqsBAFwCHIoKmAGGI
	 3VIV03GZRqPUFjYemHQV5BARtv92p77tGQdjItA+jkUjKCtXotb4d3VfVVHrTRN1O8l5t
	 /6A2RloE606aNhkQ3vHCO05fkyGWg8lSVPHXMvfQoXP7OE8BlBJpxPL1J/4vLZyS2URcz
	 wAn/gWBPTPfXP7rYtc3dXn9od+eEQ4DrZ490T1WXAZKa8pV7o2COyFDgftCzTovmmFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XAhdl4fq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B93606A337;
	Fri, 13 Nov 2026 12:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XAhdl4fq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836A31F000C4;
	Fri, 13 Nov 2026 12:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571245;
	bh=83Rx4lxHAigAFvMox5os5PJcxLMzTjusx4xtzuuPVx0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XAhdl4fqWyAtP/y7HKOpuWHylk9tnSpclY3d0xvy7toUj9pWD67SH7X/5Rv7Shh58
	 Yfr0XmjQwfYEFYQOZQWUkxnQvm21ZpuK/uxUBU550jXaxLQTH408xon+YCRYFH8xfM
	 1xPe9fe7YOrhNN6fu2w7GYhEQSRGCU0sC1GXKFj5/8+ZOqHeHpILFbT47f2Sw78aBh
	 jpL5UMIzft3rxj/lmeKIr/r1pkCbb6OSX07Q3Q5Ngqli1cVTl8tigSp97mWs9uoFgX
	 iWrvhfY4VEZqF4mOswWw5tz3N9TZ7rztQfgtR661VTvw7fv5VLssx4qGSCZjYtfwc2
	 rTuo1gmQUdJgQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:04 +0100
Subject: [PATCH v3 08/33] nilfs2: don't set SB_RDONLY after filesystem
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-8-0be92bb73709@kernel.org>
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
 Karl Mehltretter <kmehltretter@gmail.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=8933; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ChCf728zzziUBmxI/JldYwrjB7RGogCjXnmWzqdckL4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+73owrGwiugnyd8uKXX8lSgV6ompEfy3jqEiu6ycP
 VdhctuJjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkU2jAyvK5KjLrE3j2jM1xN
 9yjjCdt9u7YfFPM4e6t32zIO4z02FYwMPxU8n4u++2I2T9z/R9IJxcRLOyX6GnT+uUvJLvnzyZW
 dBwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

With errors=remount-ro, the nilfs2 default, __nilfs_error() sets
SB_RDONLY from whatever context hit the error and without holding
s_umount. If that happens while the filesystem is frozen thaw_super()
sees a read-only superblock and leaves the s_writers rwsems locked so
every writer hangs.

nilfs2 already treats a runtime SB_RDONLY as "degraded because of
corruption" in a lot of places and that can stay. So call
sb_set_emergency_ro() instead and use sb_rdonly_any() for every
sb_rdonly() check that guards a write. FITRIM is refused and a remount
to read-only doesn't write anything anymore. The VFS doesn't call
nilfs_sync_fs() in that state.

nilfs2 explicitly supported "mount -o remount,rw" after an error so far.
Now the state lasts until umount like on ext4. That includes a mount
that reconfigures a superblock only snapshots kept alive.
nilfs_get_tree() does that without reconfigure_super() so
nilfs_reconfigure() refuses going read-write itself. Writes through file
descriptors opened before the error fail with EROFS now instead of being
dropped.

Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/nilfs2/inode.c   |  4 ++--
 fs/nilfs2/ioctl.c   |  4 ++++
 fs/nilfs2/mdt.c     |  2 +-
 fs/nilfs2/page.c    |  2 +-
 fs/nilfs2/segment.c | 13 ++++++-------
 fs/nilfs2/sufile.h  |  2 +-
 fs/nilfs2/super.c   | 25 ++++++++++++++++++-------
 7 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index a99a69e9f91b7..1e336af4a471e 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -162,7 +162,7 @@ static int nilfs_writepages(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	int err = 0;
 
-	if (sb_rdonly(inode->i_sb)) {
+	if (sb_rdonly_any(inode->i_sb)) {
 		nilfs_clear_dirty_pages(mapping, false);
 		return -EROFS;
 	}
@@ -848,7 +848,7 @@ void nilfs_evict_inode(struct inode *inode)
 	truncate_inode_pages_final(&inode->i_data);
 
 	nilfs = sb->s_fs_info;
-	if (unlikely(sb_rdonly(sb) || !nilfs->ns_writer)) {
+	if (unlikely(sb_rdonly_any(sb) || !nilfs->ns_writer)) {
 		/*
 		 * If this inode is about to be disposed after the file system
 		 * has been degraded to read-only due to file system corruption
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 686ac53498bcf..42848601b394c 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1050,6 +1050,10 @@ static int nilfs_ioctl_trim_fs(struct inode *inode, void __user *argp)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/* Don't trust the segment usage after an error. */
+	if (sb_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	if (!bdev_max_discard_sectors(nilfs->ns_bdev))
 		return -EOPNOTSUPP;
 
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 77dc2be2ce652..876a32eedbb17 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -400,7 +400,7 @@ static int nilfs_mdt_writeback(struct address_space *mapping,
 	if (!inode)
 		return 0;
 
-	if (sb_rdonly(inode->i_sb)) {
+	if (sb_rdonly_any(inode->i_sb)) {
 		/*
 		 * It means that filesystem was remounted in read-only
 		 * mode because of error or metadata corruption. But we
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 857926da9f21d..9d787c6dc6190 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -259,7 +259,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 
 		folio_lock(folio);
 		if (unlikely(!folio_test_dirty(folio))) {
-			if (WARN_ONCE(!sb_rdonly(smap_inode->i_sb),
+			if (WARN_ONCE(!sb_rdonly_any(smap_inode->i_sb),
 					"inconsistent dirty state\n"))
 				goto unlock_folio;
 
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index af0c3560444f5..05c33c978b82b 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -317,7 +317,7 @@ void nilfs_relax_pressure_in_lock(struct super_block *sb)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
-	if (sb_rdonly(sb) || unlikely(!sci) || !sci->sc_flush_request)
+	if (sb_rdonly_any(sb) || unlikely(!sci) || !sci->sc_flush_request)
 		return;
 
 	set_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags);
@@ -2099,7 +2099,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int err;
 
-	if (sb_rdonly(sci->sc_super))
+	if (sb_rdonly_any(sci->sc_super))
 		return -EROFS;
 
 	nilfs_sc_cstage_set(sci, NILFS_ST_INIT);
@@ -2323,7 +2323,7 @@ int nilfs_construct_segment(struct super_block *sb)
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_transaction_info *ti;
 
-	if (sb_rdonly(sb) || unlikely(!sci))
+	if (sb_rdonly_any(sb) || unlikely(!sci))
 		return -EROFS;
 
 	/* A call inside transactions causes a deadlock. */
@@ -2356,7 +2356,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	struct nilfs_transaction_info ti;
 	int err = 0;
 
-	if (sb_rdonly(sb) || unlikely(!sci))
+	if (sb_rdonly_any(sb) || unlikely(!sci))
 		return -EROFS;
 
 	nilfs_transaction_lock(sb, &ti, 0);
@@ -2870,9 +2870,8 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 
 	if (nilfs->ns_writer) {
 		/*
-		 * This happens if the filesystem is made read-only by
-		 * __nilfs_error or nilfs_remount and then remounted
-		 * read/write.  In these cases, reuse the existing
+		 * This happens if the filesystem is remounted read-only and
+		 * then read/write again.  In this case, reuse the existing
 		 * writer.
 		 */
 		return 0;
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 5888ed479c8bd..4711d75e92357 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -76,7 +76,7 @@ int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range);
 		int _err = (err);					\
 									\
 		if (unlikely(_err))					\
-			_err = WARN_ONCE(!sb_rdonly((sufile)->i_sb),	\
+			_err = WARN_ONCE(!sb_rdonly_any((sufile)->i_sb), \
 				"unexpected sufile error %d\n", _err) ? \
 				-EIO : -EROFS;				\
 		_err;							\
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 2e3b591c117c9..add1bb8a16646 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -137,12 +137,13 @@ void __nilfs_error(struct super_block *sb, const char *function,
 
 	va_end(args);
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly_any(sb)) {
 		nilfs_set_error(sb);
 
 		if (nilfs_test_opt(nilfs, ERRORS_RO)) {
 			printk(KERN_CRIT "Remounting filesystem read-only\n");
-			sb->s_flags |= SB_RDONLY;
+			/* SB_RDONLY needs s_umount, see sb_set_emergency_ro(). */
+			sb_set_emergency_ro(sb);
 		}
 	}
 
@@ -508,7 +509,7 @@ static void nilfs_put_super(struct super_block *sb)
 
 	nilfs_detach_log_writer(sb);
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly_any(sb)) {
 		down_write(&nilfs->ns_sem);
 		nilfs_cleanup_super(sb);
 		up_write(&nilfs->ns_sem);
@@ -588,7 +589,7 @@ static int nilfs_freeze(struct super_block *sb)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	int err;
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly_any(sb))
 		return 0;
 
 	/* Mark super block clean */
@@ -602,7 +603,7 @@ static int nilfs_unfreeze(struct super_block *sb)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly_any(sb))
 		return 0;
 
 	down_write(&nilfs->ns_sem);
@@ -1083,7 +1084,7 @@ nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto failed_unload;
 	}
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly_any(sb)) {
 		err = nilfs_attach_log_writer(sb, fsroot);
 		if (err)
 			goto failed_checkpoint;
@@ -1095,7 +1096,7 @@ nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	nilfs_put_root(fsroot);
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly_any(sb)) {
 		down_write(&nilfs->ns_sem);
 		nilfs_setup_super(sb, true);
 		up_write(&nilfs->ns_sem);
@@ -1141,6 +1142,10 @@ static int nilfs_reconfigure(struct fs_context *fc)
 	if (fc->sb_flags & SB_RDONLY) {
 		sb->s_flags |= SB_RDONLY;
 
+		/* After an error nothing may be written, just go read-only. */
+		if (sb_emergency_ro(sb))
+			goto out;
+
 		/*
 		 * Remounting a valid RW partition RDONLY, so set
 		 * the RDONLY flag and then mark the partition as valid again.
@@ -1152,6 +1157,12 @@ static int nilfs_reconfigure(struct fs_context *fc)
 		__u64 features;
 		struct nilfs_root *root;
 
+		/* The VFS doesn't refuse this when nilfs_get_tree() calls us. */
+		if (sb_emergency_ro(sb)) {
+			err = -EROFS;
+			goto ignore_opts;
+		}
+
 		/*
 		 * Mounting a RDONLY partition read-write, so reread and
 		 * store the current valid flag.  (It may have been changed

-- 
2.53.0

