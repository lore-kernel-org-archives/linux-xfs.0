Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290135;
	b=f9l0oXdE4NtNU+5kqJ9VC2huimQuapdG03HACcSmXFQ+LOyb5Bu6blURU6bd6jQ9WkUX
	 zEfXbBihVX304eg9cyC959olChVwKW6Pl4ADL703hhwBdL8N5umDpvlXt0c9TDyRAu4I2
	 zb25HzDqPAVwiE8aHxgz5UsVDAdIK5aDi84gCtQyoeXhHyXgF2uPiMyIGNunNogCADg2l
	 b62v+aC0C5N+hjApEkaSUmkR/q4fXkn+qX4c1eFmIFh4Eu7Bd3g8he8dsDon0dR39ojHS
	 dcX5bWikYx/Q2f9Qj7Rmtk3xEd9WRm/9wD8IKqhoT9IDOyhkwK95y3Rz8KKfFLW1Vrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290135;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=yi2j2PwGFXAZdOVVF9qglPFKtSCcEqxM1FclZnJpM9s=;
	b=QPanZ1ozFHmgDvaPMUt2cWw9zdN6Aq9mFy3PzszKUr8N4kJ6k3DLixzSRARng9G93nR3
	 +KVX/UolQevF9dAkr+v/6m6HzK1kiqMRVYwNZ8SephXAGR6ky9xUlC02LUZhe8Glkhz+4
	 0bWGqm9gK1j3CAhf9r6FzPLK9qG3rN6pauYHItbMeACeYQja1PAooSBz2748gjaRA+jwS
	 Voj8FlXweTlos1Vg9tDwrD+dV9Z0P5fGFIRkXje849fFTnhq8hLYyONmykO1IuCuHASLF
	 Xbok3NqOenLm3kWbU1FzmgPnRcestgvVd+lbfHWb3+3Es79zXG7XLNrv6qU9kn7Wxmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fEou4OZE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9408260A260F;
	Thu, 29 Oct 2026 16:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fEou4OZE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7B51F01825;
	Thu, 29 Oct 2026 16:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290135;
	bh=yi2j2PwGFXAZdOVVF9qglPFKtSCcEqxM1FclZnJpM9s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fEou4OZEGqFblEGsYDsHSiid2asP7SWQTcZPRuVX6a7fvWfOcqG5G84hu1FtZKcdk
	 t0t5w3mQ58vtEuOIZ+6y0GwHXodI0AhW8meU8oAkw7jpggw+TJGDq5Pg/69vjYVBC7
	 dTKkI4G0OOQJryETPJK46s+rmGmDyo4xtNzvT1+T/sQVpJYcDeB2DKy9PnfNQuHnso
	 jcXU1kyYWmKuM63FU5c/tqAcQ6lg6Rwd8B44c8O2oyDOdunEI+gp8QBNBJ3rtt7Niu
	 IsEK2TUKdu9ld5YTQOtdNj6DvHXKfRi+DujKAt9QCFNwWMaYCWrB+ZtxeDCbmz9bRp
	 8HnjYzNj8NOzA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:13 +0100
Subject: [PATCH v2 22/34] zonefs: use the generic emergency read-only state
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-22-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4544; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9hLkgbjux0pplAV/6nJwgZMVd9flGZzP5a74/P2yvYY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjdwtmXnEt925qBkxqSGZNHZaTPNg/XPL6h4+N07P
 /u9oXp6RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETsPjEyNHLHOcl/npN97fuT
 +7ziVpXTtitq6y26/+rI54sWYgfkNjIyTBVYctGc4cXO8rWTf+wMPecn1D+1uJ5//u+SNJ0H94z
 O8QEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Set SB_STATE_EMERGENCY_RO instead of a private bit and drop the checks
the VFS does now. /proc/mounts and statfs() report the filesystem as
read-only again. zonefs_set_emergency_ro() still prints the warning
once. The check in zonefs_seq_file_write_close() stays so a failed zone
close doesn't make the filesystem read-only a second time. And so does
the one in zonefs_file_write_iter() because the loop driver, nfs localio
and others call ->write_iter() without rw_verify_area().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/zonefs/file.c   | 10 ++++------
 fs/zonefs/super.c  | 11 +----------
 fs/zonefs/zonefs.h | 15 ---------------
 3 files changed, 5 insertions(+), 31 deletions(-)

diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index 8959b6b36a83..e5f8c9bca662 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -299,7 +299,7 @@ static vm_fault_t zonefs_filemap_page_mkwrite(struct vm_fault *vmf)
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	vm_fault_t ret;
 
-	if (unlikely(IS_IMMUTABLE(inode) || zonefs_emergency_ro(inode->i_sb)))
+	if (unlikely(IS_IMMUTABLE(inode)))
 		return VM_FAULT_SIGBUS;
 
 	/*
@@ -601,7 +601,8 @@ static ssize_t zonefs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (unlikely(IS_IMMUTABLE(inode)))
 		return -EPERM;
 
-	if (sb_rdonly(inode->i_sb) || zonefs_emergency_ro(inode->i_sb))
+	/* loop and others call ->write_iter() without rw_verify_area() */
+	if (sb_rdonly(inode->i_sb) || sb_emergency_ro(inode->i_sb))
 		return -EROFS;
 
 	/* Write operations beyond the zone capacity are not allowed */
@@ -788,9 +789,6 @@ static int zonefs_file_open(struct inode *inode, struct file *file)
 {
 	int ret;
 
-	if ((file->f_mode & FMODE_WRITE) && zonefs_emergency_ro(inode->i_sb))
-		return -EROFS;
-
 	file->f_mode |= FMODE_CAN_ODIRECT;
 	ret = generic_file_open(inode, file);
 	if (ret)
@@ -832,7 +830,7 @@ static void zonefs_seq_file_write_close(struct inode *inode)
 			 * file system read-only.
 			 */
 			if (z->z_flags & ZONEFS_ZONE_OPEN &&
-			    !sb_rdonly(sb) && !zonefs_emergency_ro(sb)) {
+			    !sb_rdonly(sb) && !sb_emergency_ro(sb)) {
 				zonefs_warn(sb,
 					"closing zone at %llu failed %d\n",
 					z->z_sector, ret);
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index e7c97b75c601..342dcc261906 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -253,8 +253,7 @@ static void zonefs_inode_update_mode(struct inode *inode)
  */
 void zonefs_set_emergency_ro(struct super_block *sb)
 {
-	if (sb_rdonly(sb) ||
-	    test_and_set_bit(ZONEFS_SB_EMERGENCY_RO, &ZONEFS_SB(sb)->s_state))
+	if (sb_rdonly(sb) || !sb_set_emergency_ro(sb))
 		return;
 
 	zonefs_warn(sb, "remounting filesystem read-only\n");
@@ -549,9 +548,6 @@ static int zonefs_inode_setattr(const struct mnt_idmap *idmap,
 	struct inode *inode = d_inode(dentry);
 	int ret;
 
-	if (unlikely(zonefs_emergency_ro(inode->i_sb)))
-		return -EROFS;
-
 	if (unlikely(IS_IMMUTABLE(inode)))
 		return -EPERM;
 
@@ -1382,11 +1378,6 @@ static int zonefs_reconfigure(struct fs_context *fc)
 	struct super_block *sb = fc->root->d_sb;
 	struct zonefs_sb_info *sbi = sb->s_fs_info;
 
-	/* An error made the file system read-only until it is unmounted. */
-	if (sb_rdonly(sb) && !(fc->sb_flags & SB_RDONLY) &&
-	    zonefs_emergency_ro(sb))
-		return -EROFS;
-
 	sync_filesystem(fc->root->d_sb);
 	/* Copy new options from ctx into sbi. */
 	sbi->s_mount_opts = ctx->s_mount_opts;
diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
index b14822cb9c02..24029c0e23db 100644
--- a/fs/zonefs/zonefs.h
+++ b/fs/zonefs/zonefs.h
@@ -241,16 +241,6 @@ struct zonefs_sb_info {
 	bool			s_sysfs_registered;
 	struct kobject		s_kobj;
 	struct completion	s_kobj_unregister;
-
-	unsigned long		s_state;
-};
-
-/*
- * Super block state bits (s_state).
- */
-enum {
-	/* An error made the file system read-only until it is unmounted */
-	ZONEFS_SB_EMERGENCY_RO,
 };
 
 static inline struct zonefs_sb_info *ZONEFS_SB(struct super_block *sb)
@@ -258,11 +248,6 @@ static inline struct zonefs_sb_info *ZONEFS_SB(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
-static inline bool zonefs_emergency_ro(struct super_block *sb)
-{
-	return test_bit(ZONEFS_SB_EMERGENCY_RO, &ZONEFS_SB(sb)->s_state);
-}
-
 #define zonefs_info(sb, format, args...)	\
 	pr_info("zonefs (%s): " format, sb->s_id, ## args)
 #define zonefs_err(sb, format, args...)		\

-- 
2.53.0

