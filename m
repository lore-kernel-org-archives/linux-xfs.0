Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571306;
	b=iGoVQ35dNpyMDhsa88PATkU6iccJ0eaevWenxOS/0ghIOZ4HJyi5EfmkHAx5uYsTwCee
	 EIETa8Z2sHWjihD/9vdW06AJ0DPj7mXQCQ9WcR6QzcUrTnLkzTAsO0bVevNwFcLEtqxeA
	 klKN/AtLZqG6aOBbw/RNKNZWYiPO53TWP02NcVs92o8op6rn1zMNvpcUSXWzpS7G7lK4C
	 cQEdqsS8i9O91JItCq8rqNBFZbTk86jmVxSAI/JM9FdI78j+qQ1QrU90RmanapTDVoTzD
	 VpUEmT/HYwJKVFc9DElqsBMDHP8jiSwWdb5Ne1IYfO00QPmQIS6yV/t33OO8tI5tUOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571306;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=L2bkuHXOadcccS9KutaAwBh3c4yXeuMzQRsr1t2tZAQ=;
	b=1jwtmPXhhx2GiSdvT6pMgwJoHLIVYxNh2kQCWx79tSDMi34wENxM/WtUkkcEsAXVUoZZ
	 k6qO7lcXcmHuzIqSfZllwnp4ytkdom5dyepNyCPClCFrDOvu8933azaP+8ueZ5inpDRBI
	 1OhKy8SSFEkcDBqc8o8v1b4F53glLi4tDFeH6xRZTFTuSmgG0+fIX0HyMil5nzEpM/wxV
	 ytUbdArxxXNh+vAbm7HTa8z8Hq8oq6PR5TkHxcjUGI481eBOrRqnz+KykPA8Ygh5jO1Ug
	 l27L7TDoj+R9ter2XgQWtqPBmRzEHonIC3nVvistRANxEbf23OzPCAwLCwvLcNwukkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HPzG1gDM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A3F60A3804;
	Fri, 13 Nov 2026 12:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HPzG1gDM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6069F1F000C7;
	Fri, 13 Nov 2026 12:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571306;
	bh=L2bkuHXOadcccS9KutaAwBh3c4yXeuMzQRsr1t2tZAQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HPzG1gDMq9oGUx6loVCOginIkO9mfxfe1FmcW2RIHVufW9ao3RA4+PrIpVdh2t5Mi
	 BrQttjOWSgGd40OOqWSyK+qrNGcIFzB+44ppeDm/sq5rL3k4WtCfyNhCq+MgHvV5/J
	 9eTva85uZ4YAdhHtKZJR9KR7kSOkALFiJZg0rUJFbkjpahjIMaQpPD2/b0YEl9Ueou
	 IsJjXlLSsfMXMkOvP+FV4pes4iOt4UcUmJnzxPNcTSmFLI0uMlYSHIv/xqWSy+vN6s
	 n3wA8eFiYQ2O+2i6uZAFJ3ugoc//CDl0q8fsRVzy9YxXfwEKj5NyZj0Fpe1/uBLhL0
	 tyHnVGbun1zTw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:18 +0100
Subject: [PATCH v3 22/33] ocfs2: don't set SB_RDONLY after filesystem
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-22-0be92bb73709@kernel.org>
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
 Joseph Qi <joseph.qi@linux.alibaba.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5018; i=brauner@kernel.org;
 h=from:subject:message-id; bh=SsWag1VCpFeS2cP8mxSqB7YuUDxLRDPBLWrwZEnBivY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+735kMq5sLnXjml5ePq+Cf8SlmP6JUnhxbIrJqL/f
 ilurzh3sqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi3nMYGT4Xe95szNt4YbOx
 yKbj3Nc36pS2MW+bpnTi6c6OsugtG3QYGa7FLFt//u35U51nVzdEXYy+aC86I1QzcbkP14M3D7x
 33uYHAA==
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
the quota files. The VFS doesn't call ocfs2_sync_fs() in that state and
a remount to read-only doesn't suspend quotas. Q_GETQUOTA and
Q_GETNEXTQUOTA can still start transactions. I've left that alone.

Writes through file descriptors opened before the error fail with EROFS
and umount completes instead of hanging.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/acl.c   |  3 +++
 fs/ocfs2/super.c | 14 +++++++++-----
 fs/ocfs2/xattr.c |  8 ++++++++
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 801a2f56ad08c..8fb151a550442 100644
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
index 67283244426e0..7b0d9b29d9009 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -647,8 +647,8 @@ static int ocfs2_reconfigure(struct fs_context *fc)
 
 	/* We're going to/from readonly mode. */
 	if ((bool)(fc->sb_flags & SB_RDONLY) != sb_rdonly(sb)) {
-		/* Disable quota accounting before remounting RO */
-		if (fc->sb_flags & SB_RDONLY) {
+		/* Disable quota accounting before remounting RO, not after an error. */
+		if ((fc->sb_flags & SB_RDONLY) && !sb_emergency_ro(sb)) {
 			ret = ocfs2_susp_quotas(osb, 0);
 			if (ret < 0)
 				goto out;
@@ -1137,7 +1137,7 @@ static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 	/* Now we can initialize quotas because we can afford to wait
 	 * for cluster locks recovery now. That also means that truncation
 	 * log recovery can happen but that waits for proper quota setup */
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly_any(sb)) {
 		status = ocfs2_enable_quotas(osb);
 		if (status < 0) {
 			/* We have to err-out specially here because
@@ -2519,11 +2519,15 @@ static int ocfs2_handle_error(struct super_block *sb)
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
index b2bd06083a14d..a7d0ec8cdc202 100644
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

