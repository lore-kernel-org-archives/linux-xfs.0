Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290063;
	b=Luh0bcSL3Z5Qbwu8nOJ0Wd+gOzwSPAGmOgHchFDqfDznK63pPnyPxka3DnzjNv5lhNCU
	 jUrIgCe8CfGBEi/s1pPa8VAZOgKgzM9ARhQ9j2U3jIVo8/yT9P2nviioDNMzj+WL4ikEX
	 +jRFvimJJbD1NdRai4VF0Exe5RyD6M9KRnO1851huAtgQdFrAqmjHGQZGd1R6SVU2j7JG
	 wWpACMZEUM19/8mvXtzjsLWEIwnxFLUHM2wzEQ5JjGSNtSrMV6CzkjtxpyGAyU8/nBtdL
	 4SZuSChLuaMv6Qtqkr0YHnwUbOIDCW9yDUC4nxKhkHNj7JgArKh9q9BYimtB3YrTRUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290063;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=U6xEl5vN8EuvEulvkIp6GQ6S1/TdAJIG4nKa9XNObos=;
	b=2sHA8UusXOwK7yauWGIpGbvg70LKukHcNrfXOYMvbOtGdbpPHetBve59aRQY+lF5Cq3g
	 piwxDGVWZedIsSedofQtZpUj4hZ3znTEZnd19RJ9jGLu/fJcfm5TcZvegJvfKevPpOltw
	 +SC5Xe1+uQ9etHPglVKGVNOzobsHMDlhstfFSeHQJH+Vpko7ODJl6fMew2m516uBs6DpQ
	 dw14TvLQ67TQzh60I6wvlLXWGxQUuJJAvfqbAQAqXoOXb7uaGD27CagvQKlaxvzR3okLU
	 ZaZEcBbYAzm8oLDStfh/KOO2vc8+cPbb1zCCtmCi8Mtpjr7HBCRBzrFh67bJpVOGZ0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UU43cvTm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAA3606A31F;
	Thu, 29 Oct 2026 16:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UU43cvTm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11F81F01825;
	Thu, 29 Oct 2026 16:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290062;
	bh=U6xEl5vN8EuvEulvkIp6GQ6S1/TdAJIG4nKa9XNObos=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UU43cvTmE1lqx+/ula8mBnoWM+Rng/GOyo0rS6HF96vBkbudL83EP54WZEq/vw2pN
	 gUi04QOD64emHEFXBD9mMAbMO+VBYeAgs9/eGZyoW8+ycNqXD11ljP/oiHfGDvo0uK
	 hz7bWWWOgGFaTHQcVtlNWe7VJEpFUOs27AIfnnkymELZ4eDSGf4XlyubRwcJhkqmxU
	 gFf/xSGP/X9j8mzy7Q0/8G7WbK4JocS8/jtO+kCgdCD9UDYTyibqaGXew8MFXzvpdF
	 EB0c+7yGJ3BhKVmHBJxDcr4kB+TGkxLQ/2IDKhQKHgztbPzDK099Cgn5lnNjeNINt6
	 3p/HCz9d7odbA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:06:56 +0100
Subject: [PATCH v2 05/34] jfs: don't set SB_RDONLY after filesystem errors
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-5-2f44f64f0b66@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Karl Mehltretter <kmehltretter@gmail.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=10151; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jpCwIyV383uyAN1j45EGMVLzYH3R+yIi9RVXDVcMURE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztc7uSPuQMaq1yL3vnvs3/Ure5JK7/Z1TYvfnRTbc
 uette9+gY5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJpM5m+O+w7/eUTx48b545
 sVqcltFYUKClp+zpGGNtmeTstHuHrynD/9ojP0V61+7UM77P+Uo7tV/EuyRi6Z4z1a9Pfwou4lo
 ewQwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

With errors=remount-ro, the jfs default, jfs_handle_error() sets
SB_RDONLY from whatever context hit the error and without holding
s_umount. If that happens while the filesystem is frozen thaw_super()
skips jfs_unfreeze() and leaves the s_writers rwsems locked. Writers
hang and umount shuts the log down a second time and crashes.

So call sb_set_emergency_ro() instead and let the VFS refuse
modifications. jfs_unfreeze() used sb_rdonly() to tell whether
jfs_freeze() shut the log down. Track that in JFS_FLAGS_LOG_SHUTDOWN
instead so thaw undoes exactly what freeze did.

jfs refuses inode and block allocation and the xattr and ACL setters
itself, before txBegin() because failing txCommit() with tlocks held
trips an assert. Allocations that were under way when the error hit
leave anonymous tlocks behind and jfs_evict_inode() BUG()s if they're
never committed. So jfs_dirty_inode() still queues commits for those
inodes and extRecord() marks the inode dirty like extAlloc() does.
That's also why a remount to read-only still syncs.

While at it give slow symlinks jfs_symlink_inode_operations like
jfs_symlink() does so a chown doesn't skip dquot_transfer().

A remount to read-write fails until umount and writes through file
descriptors opened before the error fail with EROFS.

Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/jfs/acl.c        |  3 +++
 fs/jfs/inode.c      |  6 +++++-
 fs/jfs/ioctl.c      |  4 ++++
 fs/jfs/jfs_dtree.c  |  3 ++-
 fs/jfs/jfs_extent.c | 10 ++++++++++
 fs/jfs/jfs_incore.h |  6 ++++++
 fs/jfs/jfs_inode.c  |  3 +++
 fs/jfs/super.c      | 35 +++++++++++++++++++++++++++++++----
 fs/jfs/xattr.c      |  3 +++
 9 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
index 6e0a7feb6c80..ab4c07db7b4a 100644
--- a/fs/jfs/acl.c
+++ b/fs/jfs/acl.c
@@ -98,6 +98,9 @@ int jfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	umode_t mode = inode->i_mode;
 
+	if (sb_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	tid = txBegin(inode->i_sb, 0);
 	mutex_lock(&JFS_IP(inode)->commit_mutex);
 	if (type == ACL_TYPE_ACCESS && acl) {
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index c7914dbc91ed..8ee227006d2f 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -47,7 +47,7 @@ struct inode *jfs_iget(struct super_block *sb, unsigned long ino)
 		inode->i_fop = &jfs_dir_operations;
 	} else if (S_ISLNK(inode->i_mode)) {
 		if (inode->i_size >= IDATASIZE) {
-			inode->i_op = &page_symlink_inode_operations;
+			inode->i_op = &jfs_symlink_inode_operations;
 			inode_nohighmem(inode);
 			inode->i_mapping->a_ops = &jfs_aops;
 		} else {
@@ -187,6 +187,10 @@ void jfs_dirty_inode(struct inode *inode, int flags)
 {
 	static int noisy = 5;
 
+	/* After an error only allocations under way still get committed. */
+	if (sb_emergency_ro(inode->i_sb) && !READ_ONCE(JFS_IP(inode)->atlhead))
+		return;
+
 	if (isReadOnly(inode)) {
 		if (!special_file(inode->i_mode) && noisy) {
 			/* kernel allows writes to devices on read-only
diff --git a/fs/jfs/ioctl.c b/fs/jfs/ioctl.c
index 27d39cddaca6..df38ab15e332 100644
--- a/fs/jfs/ioctl.c
+++ b/fs/jfs/ioctl.c
@@ -116,6 +116,10 @@ long jfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
+		/* Don't trust the block map after an error. */
+		if (sb_emergency_ro(sb))
+			return -EROFS;
+
 		if (!bdev_max_discard_sectors(sb->s_bdev)) {
 			jfs_warn("FITRIM not supported on device");
 			return -EOPNOTSUPP;
diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 8ce6e4458cc2..330d291df12a 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -2935,7 +2935,8 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 				if ((jfs_dirent->position < 2) ||
 				    (jfs_dirent->position >=
 				     JFS_IP(ip)->next_index)) {
-					if (!page_fixed && !isReadOnly(ip)) {
+					if (!page_fixed && !isReadOnly(ip) &&
+					    !sb_emergency_ro(ip->i_sb)) {
 						fix_page = 1;
 						/*
 						 * setting overflow and setting
diff --git a/fs/jfs/jfs_extent.c b/fs/jfs/jfs_extent.c
index 46529bcc8297..ba55e0bbecd2 100644
--- a/fs/jfs/jfs_extent.c
+++ b/fs/jfs/jfs_extent.c
@@ -74,6 +74,9 @@ extAlloc(struct inode *ip, s64 xlen, s64 pno, xad_t * xp, bool abnr)
 	int rc;
 	int xflag;
 
+	if (sb_emergency_ro(ip->i_sb))
+		return -EROFS;
+
 	if (isReadOnly(ip)) {
 		jfs_error(ip->i_sb, "read-only filesystem\n");
 		return -EIO;
@@ -258,6 +261,9 @@ int extRecord(struct inode *ip, xad_t * xp)
 {
 	int rc;
 
+	if (sb_emergency_ro(ip->i_sb))
+		return -EROFS;
+
 	if (isReadOnly(ip)) {
 		jfs_error(ip->i_sb, "read-only filesystem\n");
 		return -EIO;
@@ -270,6 +276,10 @@ int extRecord(struct inode *ip, xad_t * xp)
 	/* update the extent */
 	rc = xtUpdate(0, ip, xp);
 
+	/* get the anonymous tlocks committed, like extAlloc() does */
+	if (!rc)
+		mark_inode_dirty(ip);
+
 	mutex_unlock(&JFS_IP(ip)->commit_mutex);
 	return rc;
 }
diff --git a/fs/jfs/jfs_incore.h b/fs/jfs/jfs_incore.h
index 5aaafedb8fbc..b8d76415fae7 100644
--- a/fs/jfs/jfs_incore.h
+++ b/fs/jfs/jfs_incore.h
@@ -192,6 +192,7 @@ struct jfs_sb_info {
 	struct inode *direct_inode;	/* metadata inode */
 	uint		state;		/* mount/recovery state	*/
 	unsigned long	flag;		/* mount time flags */
+	unsigned long	jfs_flags;	/* runtime state, JFS_FLAGS_* */
 	uint		p_state;	/* state prior to going no integrity */
 	kuid_t		uid;		/* uid to override on-disk uid */
 	kgid_t		gid;		/* gid to override on-disk gid */
@@ -202,6 +203,11 @@ struct jfs_sb_info {
 /* jfs_sb_info commit_state */
 #define IN_LAZYCOMMIT 1
 
+/* jfs_sb_info jfs_flags bits */
+enum {
+	JFS_FLAGS_LOG_SHUTDOWN,	/* jfs_freeze() shut the log down */
+};
+
 static inline struct jfs_inode_info *JFS_IP(struct inode *inode)
 {
 	return container_of(inode, struct jfs_inode_info, vfs_inode);
diff --git a/fs/jfs/jfs_inode.c b/fs/jfs/jfs_inode.c
index f10f295d1502..10e70b5a9c6f 100644
--- a/fs/jfs/jfs_inode.c
+++ b/fs/jfs/jfs_inode.c
@@ -45,6 +45,9 @@ struct inode *ialloc(struct inode *parent, umode_t mode)
 	struct jfs_inode_info *jfs_inode;
 	int rc;
 
+	if (sb_emergency_ro(sb))
+		return ERR_PTR(-EROFS);
+
 	inode = new_inode(sb);
 	if (!inode) {
 		jfs_warn("ialloc: new_inode returned NULL!");
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 8180d83d33fe..bbaba14821e6 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -63,7 +63,7 @@ static void jfs_handle_error(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || sb_emergency_ro(sb))
 		return;
 
 	updateSuper(sb, FM_DIRTY);
@@ -74,7 +74,8 @@ static void jfs_handle_error(struct super_block *sb)
 	else if (sbi->flag & JFS_ERR_REMOUNT_RO) {
 		jfs_err("ERROR: (device %s): remounting filesystem as read-only",
 			sb->s_id);
-		sb->s_flags |= SB_RDONLY;
+		/* SB_RDONLY needs s_umount, see sb_set_emergency_ro(). */
+		sb_set_emergency_ro(sb);
 	}
 
 	/* nothing is done for continue beyond marking the superblock dirty */
@@ -367,6 +368,11 @@ static int jfs_reconfigure(struct fs_context *fc)
 	int flag = ctx->flag;
 	int ret;
 
+	/* Don't resize based on a block map we don't trust after an error. */
+	if (ctx->resize && sb_emergency_ro(sb))
+		return -EROFS;
+
+	/* After an error this only commits what was queued before it. */
 	sync_filesystem(sb);
 
 	/* Transfer results of parsing to the sbi */
@@ -415,6 +421,9 @@ static int jfs_reconfigure(struct fs_context *fc)
 		return ret;
 	}
 	if (!sb_rdonly(sb) && readonly) {
+		/* After an error nothing may be written, umount closes the log. */
+		if (sb_emergency_ro(sb))
+			return 0;
 		rc = dquot_suspend(sb, -1);
 		if (rc < 0)
 			return rc;
@@ -587,6 +596,15 @@ static int jfs_freeze(struct super_block *sb)
 	int rc = 0;
 
 	if (!sb_rdonly(sb)) {
+		/*
+		 * After an error leave the log open and the superblock alone.
+		 * Waiting for everything to be written home needs a quiesced
+		 * log, jfs_flush_journal() BUG()s otherwise.
+		 */
+		if (sb_emergency_ro(sb)) {
+			jfs_flush_journal(log, 1);
+			return 0;
+		}
 		txQuiesce(sb);
 		rc = lmLogShutdown(log);
 		if (rc) {
@@ -597,6 +615,7 @@ static int jfs_freeze(struct super_block *sb)
 
 			return rc;
 		}
+		set_bit(JFS_FLAGS_LOG_SHUTDOWN, &sbi->jfs_flags);
 		rc = updateSuper(sb, FM_CLEAN);
 		if (rc) {
 			jfs_err("jfs_freeze: updateSuper failed");
@@ -616,15 +635,19 @@ static int jfs_unfreeze(struct super_block *sb)
 	struct jfs_log *log = sbi->log;
 	int rc = 0;
 
-	if (!sb_rdonly(sb)) {
+	/* Undo what jfs_freeze() did, also if an error happened meanwhile. */
+	if (test_bit(JFS_FLAGS_LOG_SHUTDOWN, &sbi->jfs_flags)) {
 		rc = updateSuper(sb, FM_MOUNT);
 		if (rc) {
 			jfs_error(sb, "updateSuper failed\n");
 			goto out;
 		}
 		rc = lmLogInit(log);
-		if (rc)
+		if (rc) {
 			jfs_error(sb, "lmLogInit failed\n");
+			goto out;
+		}
+		clear_bit(JFS_FLAGS_LOG_SHUTDOWN, &sbi->jfs_flags);
 out:
 		txResume(sb);
 	}
@@ -640,6 +663,10 @@ static int jfs_sync_fs(struct super_block *sb, int wait)
 {
 	struct jfs_log *log = JFS_SBI(sb)->log;
 
+	/* After an error only freeze and umount write out the log. */
+	if (sb_emergency_ro(sb))
+		return 0;
+
 	/* log == NULL indicates read-only mount */
 	if (log) {
 		/*
diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index dcc4a69d44fe..c3216a34fc66 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -936,6 +936,9 @@ static int __jfs_xattr_set(struct inode *inode, const char *name,
 	tid_t tid;
 	int rc;
 
+	if (sb_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	tid = txBegin(inode->i_sb, 0);
 	mutex_lock(&ji->commit_mutex);
 	rc = __jfs_setxattr(tid, inode, name, value, size, flags);

-- 
2.53.0

