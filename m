Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794503042;
	b=TNueXUizmCKeYS8h9a2hNj2vJL4Xlc0YaGNyhOywxWHtVyZisFZxac85fL6knwFfx4KZ
	 1uee+BclFVmS0IJ3HnuoYpUQzJvZ1BJ2VENYK/3by8FAessJhNA8gcuNnJLzipjmHS4rr
	 1mzi5lfsl/u8qMme/+PxMIcDIyqyoLlGJqZ0+YbG8Q0VPMwy9z568QhBj0Te6A1qJjmjx
	 LnVHu9DAd7fztNZrtiRrFq9FT72+Ii4XQ/VAB9Rumx5RxCsbk247PIWlZmJoBvaymrDoG
	 NVFAeOO65MtY/NVgRWwBPIny22UEpKgGQoXqL/EcqnhKGnrGqA1HDVYNpmQuByS0G9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794503042;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Tnsto3oiPaaydpqyOg//yXc9fozFcn2RguD6V+U0YIc=;
	b=1qGlxAvPSacYI6p352yFVMtOZNW7oLkiZfFi/znJuYNuaGD5Xug1JWr8ijQlxW1VU0sT
	 B3aTFbJHwl8qfUgO6Wcei93hrt4Qj7FyisjOZ/URpVDzDaJkdj7heKmFEqm7447mcr73l
	 5RsWrzOyTd5MPgt+IVmsiARsFPIHL5GU7QtKUMJgfHTQYoQWfZ7z17P2RP+oIb9qiPWt0
	 PzlZhaE34YQB71l8N8r/DtCGzVwxjnzvExJj3Wbfj/CPCz4PD+lF2TC7gAft0svRZa2y9
	 cP9PV2wl/sD1/6ADIRQEDCGF96mkBL7d4G0XwD5YufiNs0/QOeUeh0V9X60/+N1v12w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zf85DQc6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6C7606A321;
	Thu, 12 Nov 2026 17:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zf85DQc6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D3C1F000C4;
	Thu, 12 Nov 2026 17:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794503041;
	bh=Tnsto3oiPaaydpqyOg//yXc9fozFcn2RguD6V+U0YIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zf85DQc6pK7hHpdOfyyEwWFYo25shivjhp9VCLeryfKzdPv1yeOydjI6p0YzDNZYI
	 M+BVzJAlF5ZTlFd/VNz2+1lHlatmhrkC0UTDcQ8+HPg47A9l+LBbIY/cpnU2IwOZwn
	 3arq6wKP65C+CTdJ5UvUVaSl7NEfMJV9kRlrNB0aDds7e9KDFR27O/ajjRBmuwHYi3
	 tq3ba8VzH/X4jSmWAfhmGdCuMULrG6qP70y80wkfxbEc1K8cuUGIypQWKmT4pNRsjA
	 ZcyEm5GxYwVRaVCPxCjlwa3che5c+f0zlFzB5/xeI7emLYt7KVnqJDiVHX3vJGSxaz
	 HCx7Oi3QCP0Yw==
Date: Thu, 12 Nov 2026 18:03:55 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>, Dave Kleikamp <shaggy@kernel.org>
Subject: Re: [PATCH v2 04/34] ext2: don't set SB_RDONLY after filesystem
 errors
Message-ID: <20261112-aktivieren-datteln-assimilieren-062b8257ed49@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
 <5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp>
 <20261110-kargheit-impfen-pausieren-881763d28b19@brauner>
 <za33axmgzmuzsj3zmfeh43fkphtcsqtkhhrauwuvs7aiftelgp@dzl6z322st5f>
 <20261112-wohncontainer-saurier-wonnen-91f30c3b3ae2@brauner>
 <20261112-besorgen-nobel-handschuhe-fb3373259b5f@brauner>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261112-besorgen-nobel-handschuhe-fb3373259b5f@brauner>

Ok, so if I understood you correctly the changes below should be
implementing what you ask, @Jan.

It's a diff against v2:

- jfs: free the anonymous tlocks when evicting an inode the way
  txUnlock() does. That's also a mainline fix.

- fs: sync_filesystem() and sync(2) skip a superblock in the emergency
  state. syncfs(2) and Q_SYNC return EROFS.

- fs: refuse to freeze a superblock in the emergency state. Otherwise
  freeze doesn't sync anything anymore and the flusher keeps writing to
  the frozen filesystem.

  That means, FIFREEZE and dm suspend with lockfs now fail with EROFS on
  an errored ext2, fat etc. I think you said that you expect freeze to
  fail anyway. I think that's right.

  The exfat, ntfs, btrfs and ext4 shutdown ioctls then have to skip the
  freeze after an error.

- ext2, fat, affs, ufs and hfs: drop the ->write_inode() refusals.
  Otherwise the flusher writes data and bitmaps but never the inodes.

- ext2, jfs, nilfs2, ocfs2 and ubifs: their ->sync_fs() checks are dead
  now and go.

- ubifs: drop dirty folios and inodes after an error. Without the sync
  at remount the flusher otherwise hits ubifs' asserts after a remount
  to read-only.

With that nothing is synced on request after an error anymore.

syncfs, fsync and Q_SYNC return EROFS without writing anything and
sync(2) and umount skip the filesystem's own sync.

The flusher and the block device flushes in sync(2) and
kill_block_super() still write. So what ends up on disk is the same as
on mainline today:

Is that what you had in mind?

diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 009245ad6c99c..c7de9c793ab8f 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -173,8 +173,6 @@ affs_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 	pr_debug("write_inode(%llu)\n", inode->i_ino);
 
-	if (sb_emergency_ro(sb))
-		return -EROFS;
 	if (!inode->i_nlink)
 		// possibly free block
 		return 0;
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
diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 67b34cfce247c..b47816f70bb33 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -176,6 +176,11 @@ int exfat_force_shutdown(struct super_block *sb, u32 flags)
 	if (exfat_forced_shutdown(sb))
 		return 0;
 
+	/* After an error there is nothing to sync and freezing fails. */
+	if ((flags == EXFAT_GOING_DOWN_DEFAULT ||
+	     flags == EXFAT_GOING_DOWN_FULLSYNC) && sb_emergency_ro(sb))
+		flags = EXFAT_GOING_DOWN_NOSYNC;
+
 	switch (flags) {
 	case EXFAT_GOING_DOWN_DEFAULT:
 	case EXFAT_GOING_DOWN_FULLSYNC:
diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index c2c9fc2d0b273..e17bbc7598c14 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -445,9 +445,6 @@ static int ext2_handle_dirsync(struct inode *dir)
 	err = filemap_write_and_wait(dir->i_mapping);
 	if (!err)
 		err = sync_inode_metadata(dir, 1);
-	/* The change is done, an error made us read-only in the meantime. */
-	if (err == -EROFS && sb_emergency_ro(dir->i_sb))
-		err = 0;
 	return err;
 }
 
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 5c4831f8f45d2..dd28637c60737 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1483,14 +1483,10 @@ int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
 	uid_t uid = i_uid_read(inode);
 	gid_t gid = i_gid_read(inode);
 	struct buffer_head * bh;
-	struct ext2_inode *raw_inode;
+	struct ext2_inode * raw_inode = ext2_get_inode(sb, ino, &bh);
 	int n;
 	int err = 0;
 
-	if (sb_emergency_ro(sb))
-		return -EROFS;
-
-	raw_inode = ext2_get_inode(sb, ino, &bh);
 	if (IS_ERR(raw_inode))
  		return -EIO;
 
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index a39e0564e3852..c4ac0f8f96de3 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1287,10 +1287,6 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
 
-	/* Nothing may be written after an error made us read-only. */
-	if (sb_emergency_ro(sb))
-		return 0;
-
 	/*
 	 * Write quota structures to quota file, sync_blockdev() will write
 	 * them to disk later
@@ -1353,9 +1349,7 @@ static int ext2_reconfigure(struct fs_context *fc)
 	int flags = fc->sb_flags;
 	int err;
 
-	/* Nothing may be written after an error made us read-only. */
-	if (!sb_emergency_ro(sb))
-		sync_filesystem(sb);
+	sync_filesystem(sb);
 
 	new_opts.s_mount_opt = ctx->vals_s_mount_opt;
 	new_opts.s_resuid = ctx->s_resuid;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e8e579498c990..ce0e0ebdded61 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -821,6 +821,10 @@ int ext4_force_shutdown(struct super_block *sb, u32 flags)
 	ext4_msg(sb, KERN_ALERT, "shut down requested (%d)", flags);
 	trace_ext4_shutdown(sb, flags);
 
+	/* After an error there is nothing to flush and freezing fails. */
+	if (flags == EXT4_GOING_FLAGS_DEFAULT && ext4_emergency_ro(sb))
+		flags = EXT4_GOING_FLAGS_NOLOGFLUSH;
+
 	switch (flags) {
 	case EXT4_GOING_FLAGS_DEFAULT:
 		ret = bdev_freeze(sb->s_bdev);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index afd73dc4ba9a8..2779583c64423 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -963,9 +963,6 @@ static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int err;
 
-	if (unlikely(sb_emergency_ro(inode->i_sb)))
-		return -EROFS;
-
 	if (inode->i_ino == MSDOS_FSINFO_INO) {
 		struct super_block *sb = inode->i_sb;
 
@@ -1961,9 +1958,6 @@ int fat_flush_inodes(struct super_block *sb, struct inode *i1, struct inode *i2)
 		ret = writeback_inode(i2);
 	if (!ret)
 		ret = sync_blockdev_nowait(sb->s_bdev);
-	/* The change is done, an error made us read-only in the meantime. */
-	if (ret == -EROFS && sb_emergency_ro(sb))
-		ret = 0;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(fat_flush_inodes);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 71f7ddf60fb27..7e590e1308eac 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -479,17 +479,6 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	int res;
 
 	hfs_dbg("ino %llu\n", inode->i_ino);
-	if (unlikely(sb_emergency_ro(inode->i_sb))) {
-		/* Keep the headers in sync with the nodes writeback still writes. */
-		if (inode->i_ino == HFS_EXT_CNID)
-			hfs_btree_write(HFS_SB(inode->i_sb)->ext_tree);
-		else if (inode->i_ino == HFS_CAT_CNID)
-			hfs_btree_write(HFS_SB(inode->i_sb)->cat_tree);
-		else
-			return -EROFS;
-		return 0;
-	}
-
 	res = hfs_ext_write_extent(inode);
 	if (res)
 		return res;
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 8ee227006d2fb..4a27d6a7ffdc9 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -172,6 +172,16 @@ void jfs_evict_inode(struct inode *inode)
 	clear_inode(inode);
 	dquot_drop(inode);
 
+	/*
+	 * Writeback commits the anonymous transactions of allocations. If the
+	 * filesystem went read-only without a sync, e.g. after an error,
+	 * nothing did.
+	 */
+	if (ji->atlhead) {
+		WARN_ON_ONCE(!sb_rdonly(inode->i_sb) &&
+			     !sb_emergency_ro(inode->i_sb));
+		txAbortAnon(inode);
+	}
 	BUG_ON(!list_empty(&ji->anon_inode_list));
 
 	spin_lock_irq(&ji->ag_lock);
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 083dbbb0c3268..85192dd4461a4 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -2581,6 +2581,74 @@ void txFreelock(struct inode *ip)
 	TXN_UNLOCK();
 }
 
+/*
+ *	txAbortAnon()
+ *
+ * function:	free the anonymous tlocks of an inode that is evicted
+ *		before writeback committed them, e.g. because an error made
+ *		the filesystem read-only.
+ *
+ * A page that carries nothing but uncommitted changes isn't written home.
+ * A page that is also waiting to go home with committed changes (mp->lsn)
+ * goes home with both, after an error the superblock is marked dirty.
+ */
+void txAbortAnon(struct inode *ip)
+{
+	struct jfs_inode_info *jfs_ip = JFS_IP(ip);
+	struct linelock *linelock;
+	struct metapage *mp;
+	struct tlock *tlck;
+	lid_t lid, next, llid, k;
+
+	/* txQuiesce() and jfs_sync() commit under the commit_mutex */
+	mutex_lock(&jfs_ip->commit_mutex);
+
+	TXN_LOCK();
+	lid = jfs_ip->atlhead;
+	jfs_ip->atlhead = jfs_ip->atltail = 0;
+	list_del_init(&jfs_ip->anon_inode_list);
+	TXN_UNLOCK();
+
+	for (; lid; lid = next) {
+		tlck = lid_to_tlock(lid);
+		next = tlck->next;
+		mp = tlck->mp;
+
+		if (mp && (tlck->flag & tlckPAGELOCK)) {
+			/* undo txLock()'s metapage_nohomeok() */
+			hold_metapage(mp);
+			if (!mp->lsn)
+				clear_bit(META_dirty, &mp->flag);
+			TXN_LOCK();
+			mp->lid = 0;
+			TXN_UNLOCK();
+			_metapage_homeok(mp);
+			put_metapage(mp);
+		} else if (mp) {
+			/* the xtree root in the inode, it isn't written anymore */
+			TXN_LOCK();
+			if (jfs_ip->xtlid == lid)
+				jfs_ip->xtlid = 0;
+			else
+				mp->lid = 0;
+			TXN_UNLOCK();
+		}
+
+		TXN_LOCK();
+		llid = ((struct linelock *) &tlck->lock)->next;
+		while (llid) {
+			linelock = (struct linelock *) lid_to_tlock(llid);
+			k = linelock->next;
+			txLockFree(llid);
+			llid = k;
+		}
+		txLockFree(lid);
+		TXN_UNLOCK();
+	}
+
+	mutex_unlock(&jfs_ip->commit_mutex);
+}
+
 /*
  *	txAbort()
  *
diff --git a/fs/jfs/jfs_txnmgr.h b/fs/jfs/jfs_txnmgr.h
index ba71eb5ced567..e9a7547afd3f6 100644
--- a/fs/jfs/jfs_txnmgr.h
+++ b/fs/jfs/jfs_txnmgr.h
@@ -288,6 +288,7 @@ extern struct linelock *txLinelock(struct linelock *);
 extern void txFreeMap(struct inode *, struct maplock *, struct tblock *, int);
 extern void txEA(tid_t, struct inode *, dxd_t *, dxd_t *);
 extern void txFreelock(struct inode *);
+extern void txAbortAnon(struct inode *);
 extern int lmLog(struct jfs_log *, struct tblock *, struct lrd *,
 		 struct tlock *);
 extern void txQuiesce(struct super_block *);
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 1926019b10949..4dcc1b28e51d0 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -372,7 +372,6 @@ static int jfs_reconfigure(struct fs_context *fc)
 	if (ctx->resize && sb_emergency_ro(sb))
 		return -EROFS;
 
-	/* After an error this only commits what was queued before it. */
 	sync_filesystem(sb);
 
 	/* Transfer results of parsing to the sbi */
@@ -667,10 +666,6 @@ static int jfs_sync_fs(struct super_block *sb, int wait)
 {
 	struct jfs_log *log = JFS_SBI(sb)->log;
 
-	/* After an error only freeze and umount write out the log. */
-	if (sb_emergency_ro(sb))
-		return 0;
-
 	/* log == NULL indicates read-only mount */
 	if (log) {
 		/*
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index edb7d379ecbdf..e2d7865e4b378 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -530,10 +530,6 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 	struct nilfs_super_block **sbp;
 	int err = 0;
 
-	/* Nothing may be written after an error made us read-only. */
-	if (sb_emergency_ro(sb))
-		return 0;
-
 	/* This function is called when super block should be written back */
 	if (wait)
 		err = nilfs_construct_segment(sb);
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 7bc79b7766396..660fd145731fd 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2271,6 +2271,11 @@ int ntfs_force_shutdown(struct super_block *sb, u32 flags)
 	if (NVolShutdown(vol))
 		return 0;
 
+	/* After an error there is nothing to flush and freezing fails. */
+	if ((flags == FS_SHUTDOWN_FLAGS_DEFAULT ||
+	     flags == FS_SHUTDOWN_FLAGS_LOGFLUSH) && sb_emergency_ro(sb))
+		flags = FS_SHUTDOWN_FLAGS_NOLOGFLUSH;
+
 	switch (flags) {
 	case FS_SHUTDOWN_FLAGS_DEFAULT:
 	case FS_SHUTDOWN_FLAGS_LOGFLUSH:
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 6541294641da2..0600203931c42 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -403,10 +403,6 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait)
 	if (ocfs2_is_hard_readonly(osb))
 		return -EROFS;
 
-	/* Nothing to flush or commit after an error. */
-	if (ocfs2_is_soft_readonly(osb))
-		return 0;
-
 	if (wait) {
 		status = ocfs2_flush_truncate_log(osb);
 		if (status < 0)
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index f469e6e18e4ca..75118a8359495 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -777,6 +777,10 @@ int dquot_quota_sync(struct super_block *sb, int type)
 	int cnt;
 	int ret;
 
+	/* An error made the filesystem read-only. */
+	if (sb_emergency_ro(sb))
+		return -EROFS;
+
 	ret = dquot_writeback_dquots(sb, type);
 	if (ret)
 		return ret;
diff --git a/fs/super.c b/fs/super.c
index 0855c96b95b5c..edc767d816597 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -2291,6 +2291,16 @@ int freeze_super(struct super_block *sb, enum freeze_holder who, const void *fre
 		goto retry;
 	}
 
+	/*
+	 * After an error nothing gets synced anymore while the flusher may
+	 * still write, so a new freeze can't give a stable filesystem. Joining
+	 * a freeze that is already in effect above is fine.
+	 */
+	if (sb_emergency_ro(sb)) {
+		deactivate_locked_super(sb);
+		return -EROFS;
+	}
+
 	if (sb_rdonly(sb)) {
 		/* Nothing to do really... */
 		WARN_ON_ONCE(freeze_inc(sb, who) > 1);
@@ -2313,6 +2323,9 @@ int freeze_super(struct super_block *sb, enum freeze_holder who, const void *fre
 
 	/* All writers are done so after syncing there won't be dirty data */
 	ret = sync_filesystem(sb);
+	/* An error while we waited for the writers means nothing was synced. */
+	if (!ret && sb_emergency_ro(sb))
+		ret = -EROFS;
 	if (ret) {
 		sb->s_writers.frozen = SB_UNFROZEN;
 		sb_freeze_unlock(sb, SB_FREEZE_PAGEFAULT);
diff --git a/fs/sync.c b/fs/sync.c
index da1b35bd4445b..e282040b83e71 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -39,8 +39,9 @@ int sync_filesystem(struct super_block *sb)
 
 	/*
 	 * No point in syncing out anything if the filesystem is read-only.
+	 * After an error made it read-only nothing is pushed out anymore.
 	 */
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || sb_emergency_ro(sb))
 		return 0;
 
 	/*
@@ -73,14 +74,14 @@ EXPORT_SYMBOL(sync_filesystem);
 
 static void sync_inodes_one_sb(struct super_block *sb, void *arg)
 {
-	if (!sb_rdonly(sb))
+	if (!sb_rdonly(sb) && !sb_emergency_ro(sb))
 		sync_inodes_sb(sb);
 }
 
 static void sync_fs_one_sb(struct super_block *sb, void *arg)
 {
-	if (!sb_rdonly(sb) && !(sb->s_iflags & SB_I_SKIP_SYNC) &&
-	    sb->s_op->sync_fs)
+	if (!sb_rdonly(sb) && !sb_emergency_ro(sb) &&
+	    !(sb->s_iflags & SB_I_SKIP_SYNC) && sb->s_op->sync_fs)
 		sb->s_op->sync_fs(sb, *(int *)arg);
 }
 
@@ -157,6 +158,9 @@ SYSCALL_DEFINE1(syncfs, int, fd)
 
 	down_read(&sb->s_umount);
 	ret = sync_filesystem(sb);
+	/* An error made the filesystem read-only. */
+	if (!ret && sb_emergency_ro(sb))
+		ret = -EROFS;
 	up_read(&sb->s_umount);
 
 	ret2 = errseq_check_and_advance(&sb->s_wb_err, &fd_file(f)->f_sb_err);
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 99dd52715eee9..4eae6c2ae2eea 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -898,6 +898,13 @@ static int do_writepage(struct folio *folio, size_t len)
 
 	folio_start_writeback(folio);
 
+	/* Nothing gets written after an error, drop the folio. */
+	if (unlikely(c->ro_error)) {
+		err = -EROFS;
+		mapping_set_error(folio->mapping, err);
+		goto out;
+	}
+
 	block = folio->index << UBIFS_BLOCKS_PER_PAGE_SHIFT;
 	for (;;) {
 		blen = min_t(size_t, len, UBIFS_BLOCK_SIZE);
@@ -918,6 +925,7 @@ static int do_writepage(struct folio *folio, size_t len)
 		ubifs_ro_mode(c, err);
 	}
 
+out:
 	ubifs_assert(c, folio->private != NULL);
 	if (folio_test_checked(folio))
 		release_new_page_budget(c);
@@ -997,6 +1005,10 @@ static int ubifs_writepage(struct folio *folio, struct writeback_control *wbc)
 		goto out_unlock;
 	}
 
+	/* After an error do_writepage() drops the folio. */
+	if (unlikely(c->ro_error))
+		return do_writepage(folio, len);
+
 	spin_lock(&ui->ui_lock);
 	synced_i_size = ui->synced_i_size;
 	spin_unlock(&ui->ui_lock);
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index f041fe434d3b9..2d71274e89ad0 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -312,6 +312,12 @@ static int ubifs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		return 0;
 	}
 
+	/* Nothing gets written after an error, drop the change. */
+	if (unlikely(c->ro_error)) {
+		err = -EROFS;
+		goto out;
+	}
+
 	/*
 	 * As an optimization, do not write orphan inodes to the media just
 	 * because this is not needed.
@@ -327,6 +333,7 @@ static int ubifs_write_inode(struct inode *inode, struct writeback_control *wbc)
 			err = dbg_check_inode_size(c, inode, ui->ui_size);
 	}
 
+out:
 	ui->dirty = 0;
 	mutex_unlock(&ui->ui_mutex);
 	ubifs_release_dirty_inode_budget(c, ui);
@@ -473,14 +480,6 @@ static int ubifs_sync_fs(struct super_block *sb, int wait)
 	if (!wait)
 		return 0;
 
-	/*
-	 * Nothing gets written after an error. Fail only here, after the
-	 * !wait return: sync_filesystem() gives up at the first error and
-	 * would skip sync_inodes_sb().
-	 */
-	if (c->ro_error)
-		return -EROFS;
-
 	/*
 	 * Synchronize write buffers, because 'ubifs_run_commit()' does not
 	 * do this if it waits for an already running commit.
diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index 78c8839211153..e96174b738b4c 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -64,9 +64,6 @@ static int ufs_handle_dirsync(struct inode *dir)
 	err = filemap_write_and_wait(dir->i_mapping);
 	if (!err)
 		err = sync_inode_metadata(dir, 1);
-	/* The change is done, an error made us read-only in the meantime. */
-	if (err == -EROFS && sb_emergency_ro(dir->i_sb))
-		err = 0;
 	return err;
 }
 
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index ed5d98c8bfca2..c9ff8673fa668 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -828,8 +828,6 @@ static int ufs_update_inode(struct inode * inode, int do_sync)
 
 int ufs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	if (sb_emergency_ro(inode->i_sb))
-		return -EROFS;
 	return ufs_update_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
 }
 
diff --git a/include/linux/fs/super.h b/include/linux/fs/super.h
index 0fa6eaa93d44d..51810fe95a835 100644
--- a/include/linux/fs/super.h
+++ b/include/linux/fs/super.h
@@ -190,8 +190,8 @@ static inline bool sb_rdonly(const struct super_block *sb)
 
 /*
  * An error made the filesystem read-only. Check this wherever sb_rdonly()
- * gates a write but never where it describes the mount, e.g. in freeze_super()
- * and thaw_super(). It can get set while the superblock is frozen.
+ * gates a write but never where it describes the mount, e.g. in the read-only
+ * shortcuts of freeze_super() and thaw_super(). It can get set while frozen.
  */
 static inline bool sb_emergency_ro(const struct super_block *sb)
 {
diff --git a/tools/testing/selftests/filesystems/sb_rdonly/emergency_ro_test.c b/tools/testing/selftests/filesystems/sb_rdonly/emergency_ro_test.c
index de442b8ee7099..44e92a98477c3 100644
--- a/tools/testing/selftests/filesystems/sb_rdonly/emergency_ro_test.c
+++ b/tools/testing/selftests/filesystems/sb_rdonly/emergency_ro_test.c
@@ -481,9 +481,13 @@ TEST_F_TIMEOUT(emergency_ro, freeze_error_thaw, 120)
 			"a modification did not fail with EROFS");
 	}
 
-	/* freezing still works and doesn't leave writers blocked */
-	ASSERT_EQ(ioctl(rootfd, FIFREEZE, 0), 0);
-	ASSERT_EQ(ioctl(rootfd, FITHAW, 0), 0);
+	/* a new freeze is refused and doesn't leave writers blocked */
+	ret = ioctl(rootfd, FIFREEZE, 0);
+	EXPECT_EQ(ret, -1);
+	EXPECT_EQ(errno, EROFS);
+	ret = ioctl(rootfd, FITHAW, 0);
+	EXPECT_EQ(ret, -1);
+	EXPECT_EQ(errno, EINVAL);
 	ret = run_child(modify_all, self->mnt, prefd);
 	if (ret == -ETIMEDOUT)
 		self->wedged = true;

-- 
