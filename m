Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571241;
	b=d98AnBKHv6/5pzWo1+XooaNGCD0qRmCbNlByIFbO45DjZDMafaJK52GFIqcLImeq26Za
	 IxzjpoTkgKlIsPzJzSVDW8Mi5W725sCe02gUSh1UHOg5c9RPZc2dfN/HdWG4TqHbYBrvD
	 sW9NAyBZcXz0N1UdQMYCXwJzzlOgqWwedgDXyFd58ommz1bNF/X/PiV3iktGcEIdO7910
	 m/Ob7KDs+fumZ1GHinFu74vmehVXg4+thMZORWX+Lo02KBg47KmtxFSIU401APo3E5/5S
	 gLIu5WTyCplWQTkJA66HsCI6k527yfjK/WVeNaQ6fC8zpwy3POV8oo72z6PCDDHNFTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571241;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=nU3OufY6+FaT2mhYk2oVX6KtX/0MjQOWC5b6SehCa5A=;
	b=easRYTAVosQ5fwGFkHXtINFjcbv3Hwwah2fm22lDP9Xf/1SyZZH+FIhPtSCHLphWmHeb
	 4d3WFq9/4h6biLQ/V92gsmyPSMCtsNMz8/Rfux5P4+TCQxI7EyUFrTWa5WWXTdWpzfHQp
	 pi8rwBjjaZ3zurBkJtsJDqj87p2zyljG0UzTGUYX/aSzV9UUz5aoHfGM/AzubkGoZOPzT
	 kx+gBS/Kc3auK+9uG7TWk7qWjzGyBMbV/bn8cXJsxRL7S5zGy9HVX4I3dGzkA1Nk4V3aU
	 ELAMeI1UgsAViqxju+YlqmSnt58knr1D5KUHvpKWF1YN7W3/084N81Gw1YEJejn8GBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="lGt0h/YB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6A4606A8B8;
	Fri, 13 Nov 2026 12:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lGt0h/YB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254151F000C4;
	Fri, 13 Nov 2026 12:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571241;
	bh=nU3OufY6+FaT2mhYk2oVX6KtX/0MjQOWC5b6SehCa5A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lGt0h/YBsqT7OSSFsb5HSFcr33+VxTmIVizXcOzyi63U5oNYzOKL/5m8HJiu59IOs
	 DLPwByIae25b3p2QfF4as6AzLeSJOP0euanhmeh6Q2RtJvpbxDufj3bk+eXM9VAXrw
	 fsTBZoiY1clVi2+EP0LQIrfV797AgrSiArb34Gx+4CWtTKDjXpPcdGw30ELG1xfbN8
	 CqXwE0x5bA7Tm2TtHuWYZ+fRPd8wCxBzWjNld7j5MXx9pINmS06RwnCLFGf3dNvKoN
	 fWG9A/R5xHfNMFbl+ZAfirB91KetEp70qJ94g7nXknO4Sf15PdNVLAGvdoq/gi7sfj
	 VpjBgS2lwtHSg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:03 +0100
Subject: [PATCH v3 07/33] jfs: don't set SB_RDONLY after filesystem errors
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-7-0be92bb73709@kernel.org>
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
 Karl Mehltretter <kmehltretter@gmail.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=10332; i=brauner@kernel.org;
 h=from:subject:message-id; bh=QCdP/lCc0z2rYNymWUec+FNzkOErRfknRyOVNelxSMo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+72wNqO4NFc6v/5tq1LgYxvbTxWMrst2729anX32/
 sRt5zT4OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACby6DQjw8Jp7FcWt/dFnPOo
 4JhieqiRUZ+XUf/ljf6kPQqKTrtcJjH8FVwbya525R5rf7vGxCsBu1d9vHo87tlx24ANnS+FEpw
 OsAAA
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
trips an assert. Allocations writeback hasn't committed yet when the
error hits leave anonymous tlocks behind. So jfs_dirty_inode() still
queues commits for those inodes and extRecord() marks the inode dirty
like extAlloc() does, writeback commits what it still gets to.
jfs_evict_inode() frees whatever is left and only warns if the
filesystem is neither read-only nor in the emergency state.

A resize is refused after an error. And with nointegrity jfs_unfreeze()
records FM_DIRTY again when the error hit while the filesystem was
frozen.

After a remount to read-only a remount to read-write fails until umount.
A plain remount to read-write right after the error succeeds but the
filesystem stays read-only. Writes through file descriptors opened
before the error fail with EROFS.

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
 fs/jfs/super.c      | 36 +++++++++++++++++++++++++++++++-----
 fs/jfs/xattr.c      |  3 +++
 9 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
index 6e0a7feb6c808..ab4c07db7b4ad 100644
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
index 24b51461aacc9..2f9d6d311de91 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -178,7 +178,7 @@ void jfs_evict_inode(struct inode *inode)
 	 * nothing did.
 	 */
 	if (ji->atlhead) {
-		WARN_ON_ONCE(!sb_rdonly(inode->i_sb));
+		WARN_ON_ONCE(!sb_rdonly_any(inode->i_sb));
 		txAbortAnon(inode);
 	}
 	BUG_ON(!list_empty(&ji->anon_inode_list));
@@ -196,6 +196,10 @@ void jfs_dirty_inode(struct inode *inode, int flags)
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
index 27d39cddaca6e..df38ab15e3326 100644
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
index 8ce6e4458cc25..330d291df12af 100644
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
index 46529bcc8297e..ba55e0bbecd24 100644
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
index 5aaafedb8fbce..b8d76415fae76 100644
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
index f10f295d1502f..10e70b5a9c6ff 100644
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
index 8180d83d33fed..e7b43c2860a33 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -63,7 +63,7 @@ static void jfs_handle_error(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly_any(sb))
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
@@ -367,6 +368,10 @@ static int jfs_reconfigure(struct fs_context *fc)
 	int flag = ctx->flag;
 	int ret;
 
+	/* Don't resize based on a block map we don't trust after an error. */
+	if (ctx->resize && sb_emergency_ro(sb))
+		return -EROFS;
+
 	sync_filesystem(sb);
 
 	/* Transfer results of parsing to the sbi */
@@ -382,7 +387,8 @@ static int jfs_reconfigure(struct fs_context *fc)
 	ctx->nls_map = NULL;
 
 	if (ctx->resize) {
-		if (sb_rdonly(sb)) {
+		/* An error can also hit during the sync above. */
+		if (sb_rdonly_any(sb)) {
 			pr_err("JFS: resize requires volume to be mounted read-write\n");
 			return -EROFS;
 		}
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
@@ -616,15 +635,22 @@ static int jfs_unfreeze(struct super_block *sb)
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
+		/* With nointegrity FM_MOUNT forgets an error while frozen. */
+		if (sb_emergency_ro(sb))
+			updateSuper(sb, FM_DIRTY);
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
diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index dcc4a69d44fec..c3216a34fc662 100644
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

