Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290127;
	b=dwvRkcS0T9IgpJjGmdbPyZT4qOLdEJT+HZWLWslsbeVpvbm4V96n2jH7Si4F9Qs17pp0
	 K8vJBwvmOkalRAZtKj22/PZHuM/JA5T8wAsBnXspYHDDyB7DqOUJY6bWMjLKbIQM8qjJv
	 FoCGb+AuHUbw6jS6PX022DCM9JX1Tqc6IciNmnt++Se+DL9/jfvJbAc4XrwrzX1bD9+/X
	 nF92C8Ecae9aNPrJ9RV1sv5gkPeDyW/Fd3kSesjsILG318lfGZ9QwGJNwWrFH/dfPruPO
	 nBPOEHZcyWaoEX6jjpAW3GCDVghUnSV2AiR64tLPqybqP0+dUiSJa3Xe/RcVWWnA+/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290127;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Q105NaNGzcv+ybtcMCSNLXMrrR0iIRZiTT+bqhupCBs=;
	b=KMMmbnKuhOo4+XdO2PxAHsgZEps3qQD775K9BDFwxSp+q0yzR1fgo4jkD0RK7/6EnNen
	 tg/GJoDvGvGtGhHYVjjO7CbUyPprbTw6/7vrNKI5mdhaSof4DnpwbDULZIPf+F42Fz5IO
	 ouckxS3+7QFQXB2lmRwih4JqWAIT6yAlsdUtfEb263bGSg0Q2uOeSWoBXywwqstNYe/Wm
	 VlV7QTT4KFp/1OhsTRfdHO+ZlP8BvA6yH+IvQgE1TxDdNNxsExyeiz4AmVxkv9m+BQA34
	 8956/hw2HzYU8FHKbiBBVuVYaufeDpFooO3sqsBwTsXYr4AjYk724s77Bp0jWzDzt6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TCR2LiHA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00E8606A330;
	Thu, 29 Oct 2026 16:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TCR2LiHA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1300B1F01824;
	Thu, 29 Oct 2026 16:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290126;
	bh=Q105NaNGzcv+ybtcMCSNLXMrrR0iIRZiTT+bqhupCBs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TCR2LiHAKNVrELGSJwS3IKXCzsWFwglK/uww6ZC4iUfKBx9r/0Dy9mbDzflG3e36o
	 KLm9gSAo4F4KN843ke0MX+uwUTuEvFbhoakTJTCTSN9QiYdpjFe9wtAmqT5YUvS+J0
	 nhFeqbmdP+p5X0ouI8DpcyMmvCHaDm1nfYnGaUyPWujIQ96i+gmOr9vcLnvPmNhQd2
	 4xIgO7ABmFNo+MnSIsvJPdoaqzFme7N0mveGyRkAy/p4GR0XifyOPuAf3ztEZjSkpv
	 pUrJBujxbU8IJTngm1TwEpuTnEq99+orib0UJDGk8ohtLca4T6CRs1/NLhK5lVsG+o
	 ysaD6V+nnHhBQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:11 +0100
Subject: [PATCH v2 20/34] ocfs2: don't set SB_RDONLY after filesystem
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-20-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5309; i=brauner@kernel.org;
 h=from:subject:message-id; bh=gY1YomGitfi+vkVQ4dUFFU/PnA69rHgOz032eOs1i2s=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztef9vVJWNFhH5bquLdnpesOrPxyy/Dm+6OhJ7OWz
 /YPeCRt21HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARo1qG/zEHWzvUyw2PyK12
 9DkqeuEkY8+pC/a3QhqWflrfbqF7vofhn+aldObsk5X5b/e33Yk9+CDjyoJ7d6yv8EmFHfY7qvb
 qDAMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

With errors=remount-ro, the default, ocfs2_handle_error() sets SB_RDONLY
without holding s_umount. If that happens while the filesystem is frozen
through bdev_freeze() thaw_super() leaves the s_writers rwsems locked.
Writers hang and so does umount because ocfs2_shutdown_local_alloc()
needs sb_start_intwrite().

The soft read-only state doesn't stop modifications on its own. Every
read-only mount sets it and those still need transactions for recovery,
the local alloc and the truncate log. Everything else was stopped by the
VFS because of SB_RDONLY. So call sb_set_emergency_ro() instead which
keeps it that way, and keep setting SOFT_RO for the existing
ocfs2_emergency_state() checks.

The xattr and ACL setters get a check of their own because ecryptfs
calls them without write access on the lower mount. It sits in the xattr
handlers and not in ocfs2_xattr_set() because chmod and setfacl store
the ACL through it after the new mode was already committed.

Quotas aren't enabled at mount in the error state because that writes
the quota files. ocfs2_sync_fs() doesn't flush anything anymore and a
remount to read-only doesn't suspend quotas. Q_GETQUOTA, Q_GETNEXTQUOTA
and Q_SYNC can still start transactions. I've left that alone.

Writes through file descriptors opened before the error fail with EROFS
and umount completes instead of hanging.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/acl.c   |  3 +++
 fs/ocfs2/super.c | 18 +++++++++++++-----
 fs/ocfs2/xattr.c |  8 ++++++++
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 801a2f56ad08..8fb151a55044 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -268,6 +268,9 @@ int ocfs2_iop_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	struct ocfs2_lock_holder oh;
 	struct inode *inode = d_inode(dentry);
 
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(inode->i_sb))))
+		return -EROFS;
+
 	had_lock = ocfs2_inode_lock_tracker(inode, &bh, 1, &oh);
 	if (had_lock < 0)
 		return had_lock;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 67283244426e..6541294641da 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -403,6 +403,10 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait)
 	if (ocfs2_is_hard_readonly(osb))
 		return -EROFS;
 
+	/* Nothing to flush or commit after an error. */
+	if (ocfs2_is_soft_readonly(osb))
+		return 0;
+
 	if (wait) {
 		status = ocfs2_flush_truncate_log(osb);
 		if (status < 0)
@@ -647,8 +651,8 @@ static int ocfs2_reconfigure(struct fs_context *fc)
 
 	/* We're going to/from readonly mode. */
 	if ((bool)(fc->sb_flags & SB_RDONLY) != sb_rdonly(sb)) {
-		/* Disable quota accounting before remounting RO */
-		if (fc->sb_flags & SB_RDONLY) {
+		/* Disable quota accounting before remounting RO, not after an error. */
+		if ((fc->sb_flags & SB_RDONLY) && !sb_emergency_ro(sb)) {
 			ret = ocfs2_susp_quotas(osb, 0);
 			if (ret < 0)
 				goto out;
@@ -1137,7 +1141,7 @@ static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 	/* Now we can initialize quotas because we can afford to wait
 	 * for cluster locks recovery now. That also means that truncation
 	 * log recovery can happen but that waits for proper quota setup */
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly(sb) && !sb_emergency_ro(sb)) {
 		status = ocfs2_enable_quotas(osb);
 		if (status < 0) {
 			/* We have to err-out specially here because
@@ -2519,11 +2523,15 @@ static int ocfs2_handle_error(struct super_block *sb)
 		rv = -EIO;
 	} else { /* default option */
 		rv = -EROFS;
-		if (sb_rdonly(sb) && ocfs2_emergency_state(osb))
+		if (ocfs2_emergency_state(osb))
 			return rv;
 
 		pr_crit("OCFS2: File system is now read-only.\n");
-		sb->s_flags |= SB_RDONLY;
+		/*
+		 * SB_RDONLY needs s_umount, see sb_set_emergency_ro(). The
+		 * soft read-only flag makes ocfs2_emergency_state() refuse.
+		 */
+		sb_set_emergency_ro(sb);
 		ocfs2_set_ro_flag(osb, 0);
 	}
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index b2bd06083a14..a7d0ec8cdc20 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7781,6 +7781,9 @@ static int ocfs2_xattr_security_set(const struct xattr_handler *handler,
 				    const char *name, const void *value,
 				    size_t size, int flags)
 {
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(inode->i_sb))))
+		return -EROFS;
+
 	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY,
 			       name, value, size, flags);
 }
@@ -7929,6 +7932,9 @@ static int ocfs2_xattr_trusted_set(const struct xattr_handler *handler,
 				   const char *name, const void *value,
 				   size_t size, int flags)
 {
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(inode->i_sb))))
+		return -EROFS;
+
 	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_TRUSTED,
 			       name, value, size, flags);
 }
@@ -7964,6 +7970,8 @@ static int ocfs2_xattr_user_set(const struct xattr_handler *handler,
 
 	if (osb->s_mount_opt & OCFS2_MOUNT_NOUSERXATTR)
 		return -EOPNOTSUPP;
+	if (unlikely(ocfs2_emergency_state(osb)))
+		return -EROFS;
 
 	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_USER,
 			       name, value, size, flags);

-- 
2.53.0

