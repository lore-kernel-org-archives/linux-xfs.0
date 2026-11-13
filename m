Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571315;
	b=rx+2qMqNey8A7+RavLOBf2a4bWARauw3PPT0kNdBIpYqRCwjP1F4HwHmsHX8PsyECuBN
	 YVAWkWWtxqCUUWhFVCKJlD/Cv5GlA9ZE6yDvQduxtCUD/2lezPa3OZ+kIqdUQx6QQCXwb
	 5p0mDrLoILSVDYxzfB2ArZiF3vIv7516Mopo0HXBN8TFJhy1Y9/SMKzZb9W/RdU8VAJ6H
	 IeIbRtqx0vgQx6BcisMBZc320K4v5er1rTDhn4u5h/OY3bShhv8nq88pVeXlDfhV9B863
	 W/gFeQyI8srIq7aUiFdBfUos1dsYkK5v8QdTXg4QuvhlpRImY+uEpWRYGGxJc4lwVcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571315;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=O2/MUeVszLfB4RtsOn4WKnrIcUTtO30etZqZbBOXA4s=;
	b=Hq3fAwdcn8T0ssg0+Dya/RfliHsttHSFy4iEL1zgEWl9zVGZqrlfsvZOZvxZJED5u/mB
	 xJqAeaS8aWuy4oDEDWzWzAXDAE0xVGBl82xoUE1UiVJY5Mdu8Ob82LUhmTcnsozCZo+yk
	 HY97p3PjT+MptkjdvT/SCSCCZZBUDgkFbp2MOVJdTV3kp0FGmyH6P1QuSpvkHsjEq7bV+
	 j5hGkKFpuhlbfbfyKFzFoFU5N79ORJfpjRoz0ayt0aB8MounRR/Hwy9CwcE65R3RUk/LU
	 AzOCUv5Qb+HDnr9bB6zTBsMN0fOGco4X1hYzwg0+FsR3lw60iTi4ilTJQurpI2iv+vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eKqQh+7z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B5C60A3837;
	Fri, 13 Nov 2026 12:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eKqQh+7z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4111F000CC;
	Fri, 13 Nov 2026 12:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571314;
	bh=O2/MUeVszLfB4RtsOn4WKnrIcUTtO30etZqZbBOXA4s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eKqQh+7z+yQn8SfRPcQiJrlyaLd+6GVVio057/v2gxV8N2tV8p2k93hVROT5zEjYS
	 pwSvyXLSrsY/MkoD1+ie0kIUz2xD5Gojqu3pg1/5fIIffIeNNjmu3BKigMWVc2uxVb
	 ov5BxBjxQjo1Bhd+lc2Jaw2iA+/IXQAxqRQnRNvUtV9w7AjzBZ7EQjC2tTYmL4EHbr
	 sxdS35mw+qqzalhZpUnEHFw/CUjcs/24PUefi1E5sPn/yTfnCJ4KP8F+lUVIbxKGTL
	 xUQgrDqIyQmwDKtjlkJbIcDA3dMhJjoqjDTJPrfYZnlFiohGMYUqhx3zZzsloxt8xM
	 aSyekIeH8IGyQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:20 +0100
Subject: [PATCH v3 24/33] zonefs: use the generic emergency read-only state
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-24-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4502; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YjmE71/9/Uw3i5bx6DCMi7QXXafvEqrSsF85N/7XKgU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+70twtp+y6Tr14t0N93glXf9H3Fm6YLd7sduzr2xZ
 83k8g+3MzpKWRjEuBhkxRRZHNpNwuWW81RsNsrUgJnDygQyhIGLUwAm4lvHyPD5F9OCH0HbZvqb
 MBl2XtZIjVlyQHtFVg6n4kXZSU+i7z9jZDi6eeX6lh6OZv7dJzV83IzDeOx5lXZpH378Mqi74UR
 0NgcA
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
index 8959b6b36a83a..de1a06d53ec14 100644
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
+	if (sb_rdonly_any(inode->i_sb))
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
+			    !sb_rdonly_any(sb)) {
 				zonefs_warn(sb,
 					"closing zone at %llu failed %d\n",
 					z->z_sector, ret);
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index e7c97b75c6013..342dcc2619065 100644
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
index b14822cb9c02e..24029c0e23dbd 100644
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

