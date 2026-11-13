Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571293;
	b=lPC+hLtp+3oJpbC2/nblN2Pkn6CPmVyMpzqw+R46WLJKggjXnRaKWMc0MrJXCNvVOlZe
	 Zr4cWZtr+MMBderM0VKBtcFt0kR366UTKYw2+NCU1WhrqevgHqGOxnhnwmnN5qvynMqvd
	 7wFmTjjhoMBBZmnCOLlxZlmWyItR412vUtK0KuzkDpawWqDVfgtOUTW3P3RhrE0iWHCss
	 KiiBruB7AM1D5fl03HAVMS+uo3t5txxZzji3KFsMX+jBHYvpPyGvffP/te1Zx1Boyt3rk
	 YXo5tUuBEnvzc8VySEpqGeKwh28Ak1fkgcAFG95akJHvxyQW7zpU7ENsWo52eJKKgDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571293;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=x+otvhjJPm5ntt/PAzEuYSZmhHNq9ZCZn10vLrRTpX8=;
	b=w56MijfcWs2xw7rQpmYpHHB85SBCYl57iuxhvTCGZc77qFZbdnDG9h0RvuVIX+2n8MnD
	 0GFWQ8tPmcNI4o9B47/fXW8IvRhJG8iIZwvyBxbSs82asipmlsvyWYFIIzmatrP1hHxBT
	 p+K9bEX3fNh+ty/8K4PkiRxbI1thqjT9z3i/0DZvxk/vFOgST9LR5Qcfgd3e642w6PFL6
	 DKQwZbx0tB/IbeWLSa1INqpi8G3ODnm7oiMrHVDaMTsSuOXQLzBfVRQdQcafF7li4iPL6
	 GnblOSD91kWnJiTKia/24Of2PX5ZzfCOkRu+FdkKbmZi2daMv/cfQXwd1tQY+eas0rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KwuZUcNd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5648D606C087;
	Fri, 13 Nov 2026 12:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KwuZUcNd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00291F000C6;
	Fri, 13 Nov 2026 12:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571293;
	bh=x+otvhjJPm5ntt/PAzEuYSZmhHNq9ZCZn10vLrRTpX8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KwuZUcNdQdVHgprqiJ3uq/gI6hTbQb3aWzULYGs+nQqVuHlh9565GnGNpDWSAcrOI
	 iAaKrX+CFg8RP5+bjHjCOy9vYkLFPbthDwyapVflaCCodejkHK+M2Brh/zV9uQNcFb
	 EZ75GXsxnzGRMelcW/npDzPB78NMAQcDXSnYOoqYrXVqQN0JA7vcWPLj8cjPU8d/jN
	 ruN3bcBjpvwkNpXyJwD1U4nS4O3r53YGtl2gQhHFZNUZcUFeQ9Nxhay6gIcV07VNEO
	 /xdhRHwFKdagkcmcDpzxzOAzGJnwzgcHX7hiztyHNzeLXspZYALssHvpd0I44zhVf2
	 5Uj+30htseVAA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:15 +0100
Subject: [PATCH v3 19/33] ntfs: don't set SB_RDONLY after filesystem errors
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-19-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Hyunchul Lee <hyc.lee@gmail.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=23594; i=brauner@kernel.org;
 h=from:subject:message-id; bh=kfbX+b6TREq2jo26Ol06Rdc8hNyMqpLspLjjDVxckMw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+70h9DfLlRP/LzCd1JK65DL1ANfjf38NC78///cyc
 eat1Xz9jztKWRjEuBhkxRRZHNpNwuWW81RsNsrUgJnDygQyhIGLUwAm4s7E8N/98yZe8eNzfdjn
 dv6K7fDlK+9m6q/q+Pyqvu3PxtpDqlaMDJ3fFsVMO3xVorgj8FbS/KOSV9wmPb/a1hInvvDJZp6
 zBzkB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

With errors=remount-ro every ntfs_error() ends up in ntfs_handle_error()
which sets SB_RDONLY without holding s_umount. If that happens while the
volume is frozen through bdev_freeze() thaw_super() sees a read-only
superblock and leaves the s_writers rwsems locked so every writer hangs.

So set NV_Errors and a new NV_EmergencyRO flag instead like ext4 does.
ntfs_emergency_state() returns EIO after a shutdown and EROFS after an
error and the write side shutdown checks use it now. fallocate,
->set_acl(), FS_IOC_SETFSLABEL, FITRIM and ntfs_mft_record_free() get a
check as well. Errors while mounting still set SB_RDONLY, nothing can
freeze the superblock before SB_BORN.

NV_Errors already refuses a remount to read-write and since
commit 521978c4f444 ("ntfs: sync the volume dirty bit with the recorded
error state") the volume stays marked dirty once errors were recorded.
But the dirty bit may not be on disk yet when the error hits and
writeback is refused from then on, dirty data from before the error is
dropped like after a shutdown. So a work item writes it right away
because ntfs_error() can be called with mft records locked, and umount
lets a pending one run first.

Unlinked inodes are left to chkdsk in that state. Their mft records are
freed with direct bios while the index and bitmap updates of the
deletion can't be written back anymore. And writing to an encrypted file
only warns now. It called ntfs_error() which let anyone put the volume
into the emergency state.

/proc/mounts keeps showing the volume read-write. Writes through file
descriptors opened before the error fail with EROFS.

Fixes: 6251f0b0de7d ("ntfs: update super block operations")
Cc: stable@vger.kernel.org
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ntfs/aops.c         |  5 ++--
 fs/ntfs/dir.c          |  5 ++--
 fs/ntfs/ea.c           | 10 ++++++--
 fs/ntfs/file.c         | 63 ++++++++++++++++++++++++++++++++++++--------------
 fs/ntfs/inode.c        | 18 +++++++++++----
 fs/ntfs/iomap.c        |  6 +++--
 fs/ntfs/mft.c          | 10 ++++++--
 fs/ntfs/named_stream.c | 43 +++++++++++++++++-----------------
 fs/ntfs/namei.c        | 40 +++++++++++++++++++-------------
 fs/ntfs/super.c        | 52 ++++++++++++++++++++++++++++++++++++-----
 fs/ntfs/volume.h       | 16 +++++++++++++
 11 files changed, 194 insertions(+), 74 deletions(-)

diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index ad781674fef1a..872c039f6c02d 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -263,8 +263,9 @@ static int ntfs_writepages(struct address_space *mapping,
 	bool need_iput = false;
 	int ret;
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	ret = ntfs_emergency_state(ni->vol);
+	if (ret)
+		return ret;
 
 	if (!NInoNonResident(ni))
 		return 0;
diff --git a/fs/ntfs/dir.c b/fs/ntfs/dir.c
index fce10baa2b93f..6314f115e6e99 100644
--- a/fs/ntfs/dir.c
+++ b/fs/ntfs/dir.c
@@ -1131,8 +1131,9 @@ static int ntfs_dir_fsync(struct file *filp, loff_t start, loff_t end,
 
 	ntfs_debug("Entering for inode 0x%llx.", ni->mft_no);
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	ctx = ntfs_attr_get_search_ctx(ni, NULL);
 	if (!ctx)
diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index fa5c5c6257510..0cf3a63af912f 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -907,8 +907,9 @@ static int ntfs_setxattr(const struct xattr_handler *handler,
 
 	if (ntfs_inode_is_named_stream(ni))
 		return -EOPNOTSUPP;
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(ni->vol);
+	if (err)
+		return err;
 
 	/* Only fileattr_set may change the flags and their cached state. */
 	if (!strcmp(name, "$LINUXFLAGS"))
@@ -1193,6 +1194,11 @@ static noinline int ntfs_set_acl_ex(const struct mnt_idmap *idmap,
 int ntfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type)
 {
+	int err;
+
+	err = ntfs_emergency_state(NTFS_I(d_inode(dentry))->vol);
+	if (err)
+		return err;
 	return ntfs_set_acl_ex(idmap, d_inode(dentry), acl, type, false);
 }
 
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index b2f5882d9990d..fbfbd94c60924 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -55,9 +55,14 @@
 int ntfs_file_open(struct inode *vi, struct file *filp)
 {
 	struct ntfs_inode *ni = NTFS_I(vi);
+	int err;
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	if (filp->f_mode & FMODE_WRITE)
+		err = ntfs_emergency_state(ni->vol);
+	else
+		err = NVolShutdown(ni->vol) ? -EIO : 0;
+	if (err)
+		return err;
 
 	if (sizeof(unsigned long) < 8) {
 		if (i_size_read(vi) > MAX_LFS_FILESIZE)
@@ -210,8 +215,9 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 	bool forced_immutable;
 	int err;
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(ni->vol);
+	if (err)
+		return err;
 
 	if (fileattr_has_fsx(fa))
 		return -EOPNOTSUPP;
@@ -305,8 +311,9 @@ int ntfs_file_fsync(struct file *filp, loff_t start, loff_t end,
 
 	ntfs_debug("Entering for inode 0x%llx.", ni->mft_no);
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	err = file_write_and_wait_range(filp, start, end);
 	if (err)
@@ -459,8 +466,11 @@ int ntfs_setattr_size(struct inode *vi, struct iattr *attr)
 	int err;
 	loff_t old_size = vi->i_size;
 
-	if (stream && NVolShutdown(ni->vol))
-		return -EIO;
+	if (stream) {
+		err = ntfs_emergency_state(ni->vol);
+		if (err)
+			return err;
+	}
 
 	if (NInoCompressed(ni) || NInoEncrypted(ni) || NInoWofCompressed(ni)) {
 		ntfs_warning(
@@ -544,8 +554,9 @@ int ntfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 	struct ntfs_inode *ni = NTFS_I(vi);
 	struct ntfs_volume *vol = ni->vol;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	err = setattr_prepare(idmap, dentry, attr);
 	if (err)
@@ -860,15 +871,16 @@ ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	int err;
 	loff_t old_data_size, old_init_size;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	if (NInoWofCompressed(ni))
 		return -EOPNOTSUPP;
 
 	if (NInoEncrypted(ni)) {
-		ntfs_error(vi->i_sb, "Writing for %s files is not supported yet",
-			   NInoCompressed(ni) ? "Compressed" : "Encrypted");
+		ntfs_warning(vi->i_sb, "Writing for %s files is not supported yet",
+			     NInoCompressed(ni) ? "Compressed" : "Encrypted");
 		return -EOPNOTSUPP;
 	}
 
@@ -1037,9 +1049,15 @@ int ntfs_file_mmap_prepare(struct vm_area_desc *desc)
 {
 	struct file *file = desc->file;
 	struct inode *inode = file_inode(file);
+	struct ntfs_volume *vol = NTFS_SB(file->f_mapping->host->i_sb);
+	int ret;
 
-	if (NVolShutdown(NTFS_SB(file->f_mapping->host->i_sb)))
-		return -EIO;
+	if (file->f_mode & FMODE_WRITE)
+		ret = ntfs_emergency_state(vol);
+	else
+		ret = NVolShutdown(vol) ? -EIO : 0;
+	if (ret)
+		return ret;
 
 	if (NInoCompressed(NTFS_I(inode)) || NInoWofCompressed(NTFS_I(inode)))
 		return -EOPNOTSUPP;
@@ -1165,7 +1183,9 @@ static int ntfs_ioctl_set_volume_label(struct file *filp, unsigned long arg)
 	if (ret)
 		goto out;
 
-	ret = ntfs_write_volume_label(vol, label);
+	ret = ntfs_emergency_state(vol);
+	if (!ret)
+		ret = ntfs_write_volume_label(vol, label);
 	mnt_drop_write_file(filp);
 out:
 	kfree(label);
@@ -1182,6 +1202,11 @@ static int ntfs_ioctl_fitrim(struct ntfs_volume *vol, unsigned long arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/* Don't trust $Bitmap after an error. */
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
+
 	dev = vol->sb->s_bdev;
 	if (!bdev_max_discard_sectors(dev))
 		return -EOPNOTSUPP;
@@ -1478,6 +1503,10 @@ long ntfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (mode & ~(NTFS_FALLOC_FL_SUPPORTED))
 		return -EOPNOTSUPP;
 
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
+
 	if (NInoCompressed(ni) || NInoEncrypted(ni) || NInoWofCompressed(ni))
 		return -EOPNOTSUPP;
 
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 206db4e99ef13..8d6564133c87a 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -425,7 +425,8 @@ int ntfs_drop_big_inode(struct inode *inode)
 			if (!inode->i_nlink) {
 				struct ntfs_inode *ni = NTFS_I(inode);
 
-				if (ni->data_size == 0)
+				/* Like ntfs_evict_big_inode(), leave it to chkdsk. */
+				if (ni->data_size == 0 || ntfs_emergency_state(ni->vol))
 					return 0;
 
 				/* To avoid evict_inode call simultaneously */
@@ -2434,7 +2435,11 @@ void ntfs_evict_big_inode(struct inode *vi)
 
 	truncate_inode_pages_final(&vi->i_data);
 
-	if (!vi->i_nlink) {
+	/*
+	 * After an error the freed mft record would go out right away while
+	 * the rest of the deletion can't, leave the inode to chkdsk.
+	 */
+	if (!vi->i_nlink && !ntfs_emergency_state(ni->vol)) {
 		if (!NInoAttr(ni)) {
 			/* Never called with extent inodes */
 			WARN_ON(ni->nr_extents == -1);
@@ -2907,8 +2912,13 @@ int __ntfs_write_inode(struct inode *vi, int sync)
 	ntfs_debug("Entering for %sinode 0x%llx.", NInoAttr(ni) ? "attr " : "",
 			ni->mft_no);
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	/* After an error only $Volume is still written, see ntfs_error_work(). */
+	err = ntfs_emergency_state(ni->vol);
+	if (err) {
+		if (err != -EROFS || vi != ni->vol->vol_ino)
+			return err;
+		err = 0;
+	}
 
 	/*
 	 * Dirty attribute inodes are written via their real inodes so just
diff --git a/fs/ntfs/iomap.c b/fs/ntfs/iomap.c
index 6e51cce3aeba1..4dc5fa29c166b 100644
--- a/fs/ntfs/iomap.c
+++ b/fs/ntfs/iomap.c
@@ -739,9 +739,11 @@ static int __ntfs_write_iomap_begin(struct inode *inode, loff_t offset,
 {
 	struct ntfs_inode *ni = NTFS_I(inode);
 	struct ntfs_inode *mrec_ni;
+	int err;
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(ni->vol);
+	if (err)
+		return err;
 
 	if (!NInoNonResident(ni)) {
 		mrec_ni = ntfs_inode_is_named_stream(ni) ?
diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 89288b794348b..45232f8fc0895 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -2956,6 +2956,11 @@ int ntfs_mft_record_free(struct ntfs_volume *vol, struct ntfs_inode *ni)
 	if (!vol || !ni)
 		return -EINVAL;
 
+	/* The freed record goes out right away, the rest of the deletion can't. */
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
+
 	ntfs_debug("Entering for inode 0x%llx.\n", (long long)ni->mft_no);
 
 	ni_mrec = map_mft_record(ni);
@@ -3423,8 +3428,9 @@ int ntfs_mft_writepages(struct address_space *mapping,
 	struct folio *folio = NULL;
 	int error;
 
-	if (NVolShutdown(NTFS_I(mapping->host)->vol))
-		return -EIO;
+	error = ntfs_emergency_state(NTFS_I(mapping->host)->vol);
+	if (error)
+		return error;
 
 	while ((folio = writeback_iter(mapping, wbc, folio, &error)))
 		error = ntfs_write_mft_block(folio, wbc);
diff --git a/fs/ntfs/named_stream.c b/fs/ntfs/named_stream.c
index 95a3c05f98211..64d9acd7617dd 100644
--- a/fs/ntfs/named_stream.c
+++ b/fs/ntfs/named_stream.c
@@ -587,10 +587,9 @@ struct inode *ntfs_create_named_stream(const struct mnt_idmap *idmap,
 
 	base_ni = NTFS_I(base_vi);
 	mutex_lock(&base_ni->mrec_lock);
-	if (NVolShutdown(base_ni->vol)) {
-		err = -EIO;
+	err = ntfs_emergency_state(base_ni->vol);
+	if (err)
 		goto out_unlock;
-	}
 	if (NInoBeingDeleted(base_ni) || !base_vi->i_nlink) {
 		err = -ENOENT;
 		goto out_unlock;
@@ -613,10 +612,9 @@ struct inode *ntfs_create_named_stream(const struct mnt_idmap *idmap,
 		else
 			err = -EEXIST;
 	} else if (err == -ENOENT) {
-		if (NVolShutdown(base_ni->vol)) {
-			err = -EIO;
+		err = ntfs_emergency_state(base_ni->vol);
+		if (err)
 			goto out_put_ctx;
-		}
 		err = ntfs_attr_add(base_ni, AT_DATA, stream_name, stream_len,
 				NULL, 0);
 		if (!err) {
@@ -926,8 +924,9 @@ static int ntfs_stream_setattr(const struct mnt_idmap *idmap,
 	bool claimed = false;
 	int err;
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(ni->vol);
+	if (err)
+		return err;
 
 	if (!(attr->ia_valid & ATTR_FILE)) {
 		err = ntfs_stream_claim(inode);
@@ -954,16 +953,16 @@ static int ntfs_stream_update_time_common(struct inode *inode,
 	struct inode *base_vi = VFS_I(base_ni);
 	int err;
 
-	if (NVolShutdown(base_ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(base_ni->vol);
+	if (err)
+		return err;
 	if (flags & IOCB_NOWAIT)
 		return -EAGAIN;
 
 	mutex_lock(&base_ni->mrec_lock);
-	if (NVolShutdown(base_ni->vol)) {
-		err = -EIO;
+	err = ntfs_emergency_state(base_ni->vol);
+	if (err)
 		goto out_mrec;
-	}
 	err = ntfs_stream_inode_validate(inode);
 	if (!err) {
 		err = generic_update_time(base_vi, type, flags);
@@ -1028,10 +1027,9 @@ static int ntfs_stream_finish_remove(struct inode *attr_vi)
 	truncate_inode_pages(attr_vi->i_mapping, 0);
 
 	mutex_lock(&ni->mrec_lock);
-	if (NVolShutdown(ni->vol)) {
-		err = -EIO;
+	err = ntfs_emergency_state(ni->vol);
+	if (err)
 		goto out_unlock;
-	}
 	if (NInoBeingDeleted(ni) || !VFS_I(ni)->i_nlink) {
 		remove_inode_hash(attr_vi);
 		err = 0;
@@ -1092,8 +1090,9 @@ int ntfs_remove_named_stream(struct ntfs_inode *ni, __le16 *uname,
 
 	if (!ni || !uname || uname_len == 0)
 		return -EINVAL;
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(ni->vol);
+	if (err)
+		return err;
 	if ((ni->flags & FILE_ATTR_READONLY) ||
 	    IS_APPEND(VFS_I(ni)) || IS_IMMUTABLE(VFS_I(ni)))
 		return -EPERM;
@@ -1245,10 +1244,12 @@ static int ntfs_stream_ioctl_get_inode(struct inode *base_vi, __le16 *sname,
 	*stream_vi = NULL;
 
 	mutex_lock(&base_ni->mrec_lock);
-	if (NVolShutdown(base_ni->vol)) {
-		err = -EIO;
+	if (create)
+		err = ntfs_emergency_state(base_ni->vol);
+	else
+		err = NVolShutdown(base_ni->vol) ? -EIO : 0;
+	if (err)
 		goto out_unlock;
-	}
 	if (NInoBeingDeleted(base_ni) || !base_vi->i_nlink) {
 		err = -ENOENT;
 		goto out_unlock;
diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index 62b01646c2623..ebeea6ea3ac32 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -782,8 +782,9 @@ static int ntfs_create(const struct mnt_idmap *idmap, struct inode *dir,
 	__le16 *uname, *base_name = NULL, *stream_name = NULL;
 	int uname_len, stream_len, path_result, err;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	path_result = ntfs_stream_path_names(vol, &dentry->d_name, &base_name,
 			&uname_len, &stream_name, &stream_len);
@@ -1088,8 +1089,9 @@ static int ntfs_unlink(struct inode *dir, struct dentry *dentry)
 	__le16 *uname = NULL;
 	int uname_len;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	if (ntfs_stream_path_has_colon(vol, &dentry->d_name))
 		return ntfs_unlink_named_stream(dir, dentry);
@@ -1136,8 +1138,9 @@ static struct dentry *ntfs_mkdir(const struct mnt_idmap *idmap, struct inode *di
 	__le16 *uname;
 	int uname_len;
 
-	if (NVolShutdown(vol))
-		return ERR_PTR(-EIO);
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return ERR_PTR(err);
 
 	err = ntfs_stream_path_check(vol, &dentry->d_name);
 	if (err)
@@ -1181,8 +1184,9 @@ static int ntfs_rmdir(struct inode *dir, struct dentry *dentry)
 	__le16 *uname = NULL;
 	int uname_len;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	err = ntfs_stream_path_check(vol, &dentry->d_name);
 	if (err)
@@ -1349,8 +1353,9 @@ static int ntfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 	struct ntfs_inode *old_dir_ni = NTFS_I(old_dir), *new_dir_ni = NTFS_I(new_dir);
 	bool new_dir_first = false;
 
-	if (NVolShutdown(old_dir_ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	err = ntfs_stream_path_check(vol, &old_dentry->d_name);
 	if (err)
@@ -1503,8 +1508,9 @@ static int ntfs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 	int usrc_len;
 	int symlen = strlen(symname);
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	err = ntfs_stream_path_check(vol, &dentry->d_name);
 	if (err)
@@ -1552,8 +1558,9 @@ static int ntfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	__le16 *uname = NULL;
 	int uname_len;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	err = ntfs_stream_path_check(vol, &dentry->d_name);
 	if (err)
@@ -1608,8 +1615,9 @@ static int ntfs_link(struct dentry *old_dentry, struct inode *dir,
 	int err;
 	struct ntfs_inode *ni = NTFS_I(vi), *dir_ni = NTFS_I(dir);
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	if (NInoAttr(ni))
 		return -EOPNOTSUPP;
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 71f0aea46bf8f..91290688d2898 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -305,6 +305,8 @@ static int ntfs_reconfigure(struct fs_context *fc)
 
 	ntfs_debug("Entering with remount");
 
+	/* Mark the volume dirty first if an error made it read-only. */
+	flush_work(&vol->error_work);
 	err = sync_filesystem(sb);
 	if (err) {
 		ntfs_warning(sb, "Failed to sync the filesystem.");
@@ -434,7 +436,21 @@ void ntfs_handle_error(struct super_block *sb)
 		return;
 
 	if (vol->on_errors == ON_ERRORS_REMOUNT_RO) {
-		sb->s_flags |= SB_RDONLY;
+		if (!(sb->s_flags & SB_BORN)) {
+			/* Before SB_BORN the mounter holds s_umount. */
+			sb->s_flags |= SB_RDONLY;
+		} else {
+			/*
+			 * NV_EmergencyRO makes the volume refuse modifications
+			 * instead and NV_Errors keeps it from being remounted
+			 * read-write. The error work marks the volume dirty on
+			 * disk.
+			 */
+			NVolSetErrors(vol);
+			if (test_and_set_bit(NV_EmergencyRO, &vol->flags))
+				return;
+			queue_work(ntfs_wq, &vol->error_work);
+		}
 		pr_crit("(device %s): Filesystem has been set read-only\n",
 			sb->s_id);
 	} else if (vol->on_errors == ON_ERRORS_PANIC) {
@@ -557,18 +573,18 @@ int ntfs_set_volume_flags(struct ntfs_volume *vol, __le16 flags)
  * last one, ntfs_put_super(), runs after evict_inodes() on a quiesced
  * filesystem, so a volume that is read-write at unmount time cannot
  * unmount clean.  A volume that is already read-only when the error is
- * recorded (errors=remount-ro flips the superblock on the first error,
- * as does an earlier remount-ro) has no persistence point left and
+ * recorded (an earlier remount-ro) has no persistence point left and
  * keeps whatever on-disk bit it had; that behaviour is unchanged.  The
  * residual window is a crash between the error and the next
- * persistence point.
+ * persistence point.  errors=remount-ro keeps the superblock read-write
+ * and ntfs_error_work() persists the error state right away.
  *
  * This is the single point that persists the in-memory error state to disk.
  * The runtime error paths only record NVolErrors() because they run under a
  * variety of ntfs locks the dirty-bit write cannot be taken under (runlist
  * locks, vol->lcnbmp_lock, vol->mftbmp_lock, mrec_locks); a sync of a
- * volume with recorded errors, a remount to read-only, or the unmount,
- * then persists the flag here.
+ * volume with recorded errors, ntfs_error_work(), a remount to read-only,
+ * or the unmount, then persists the flag here.
  *
  * A hibernated volume is not written from these persistence paths:
  * resuming Windows from a modified image corrupts it, so the dirty bit
@@ -583,6 +599,25 @@ static int ntfs_sync_volume_dirty_state(struct ntfs_volume *vol)
 	return ntfs_write_volume_flags(vol, 0, VOLUME_IS_DIRTY, true);
 }
 
+/*
+ * ntfs_error_work - mark the volume dirty on disk after an error
+ * @work:	the error_work of the ntfs volume
+ *
+ * VOLUME_IS_DIRTY is set lazily and may not be on disk yet when the error hits.
+ * A work item because ntfs_error() may be called with mft records locked, and
+ * sb_start_intwrite() waits for a frozen volume to be thawed.
+ */
+static void ntfs_error_work(struct work_struct *work)
+{
+	struct ntfs_volume *vol = container_of(work, struct ntfs_volume,
+					       error_work);
+
+	sb_start_intwrite(vol->sb);
+	if (!ntfs_sync_volume_dirty_state(vol))
+		ntfs_commit_inode(vol->vol_ino);
+	sb_end_intwrite(vol->sb);
+}
+
 int ntfs_write_volume_label(struct ntfs_volume *vol, char *label)
 {
 	struct ntfs_inode *vol_ni = NTFS_I(vol->vol_ino);
@@ -2080,6 +2115,10 @@ static void ntfs_put_super(struct super_block *sb)
 
 	cancel_work_sync(&vol->precalc_work);
 
+	/* Let a pending error work persist the error state first. */
+	flush_work(&vol->error_work);
+	disable_work_sync(&vol->error_work);
+
 	/*
 	 * Commit all inodes while they are still open in case some of them
 	 * cause others to be dirtied.
@@ -2998,6 +3037,7 @@ static int ntfs_init_fs_context(struct fs_context *fc)
 	init_rwsem(&vol->mftbmp_lock);
 	init_rwsem(&vol->lcnbmp_lock);
 	mutex_init(&vol->volume_label_lock);
+	INIT_WORK(&vol->error_work, ntfs_error_work);
 
 	fc->s_fs_info = vol;
 	fc->ops = &ntfs_context_ops;
diff --git a/fs/ntfs/volume.h b/fs/ntfs/volume.h
index ed5c0ccb9cd9f..1ce81b260b15c 100644
--- a/fs/ntfs/volume.h
+++ b/fs/ntfs/volume.h
@@ -92,6 +92,7 @@
  * @sparse_compression_unit: Size of compression/sparse unit in clusters.
  * @lcn_empty_bits_per_page: Number of empty bits per page in the LCN bitmap.
  * @precalc_work: Work structure for background pre-calculation tasks.
+ * @error_work: Marks the volume dirty on disk after an error made it read-only.
  * @preallocated_size: reallocation size (in bytes).
  */
 struct ntfs_volume {
@@ -166,6 +167,7 @@ struct ntfs_volume {
 	u8 sparse_compression_unit;
 	unsigned int *lcn_empty_bits_per_page;
 	struct work_struct precalc_work;
+	struct work_struct error_work;
 	loff_t preallocated_size;
 };
 
@@ -198,6 +200,8 @@ struct ntfs_volume {
  * NV_NativeSymlinkRel		Translate absolute Windows reparse targets (native_symlink=rel).
  * NV_MftBootstrap		Mount is still assembling $MFT's own runlist.
  * NV_StreamsWindows		Interpret the final path component as file:stream.
+ * NV_EmergencyRO		An error made the volume read-only until it is
+ *				unmounted (errors=remount-ro).
  */
 enum {
 	NV_Errors,
@@ -220,6 +224,7 @@ enum {
 	NV_SymlinkNative,
 	NV_MftBootstrap,
 	NV_StreamsWindows,
+	NV_EmergencyRO,
 };
 
 /*
@@ -261,6 +266,17 @@ DEFINE_NVOL_BIT_OPS(NativeSymlinkRel)
 DEFINE_NVOL_BIT_OPS(SymlinkNative)
 DEFINE_NVOL_BIT_OPS(MftBootstrap)
 DEFINE_NVOL_BIT_OPS(StreamsWindows)
+DEFINE_NVOL_BIT_OPS(EmergencyRO)
+
+/* -EIO after a shutdown, -EROFS after an error with errors=remount-ro */
+static inline int ntfs_emergency_state(struct ntfs_volume *vol)
+{
+	if (unlikely(NVolShutdown(vol)))
+		return -EIO;
+	if (unlikely(NVolEmergencyRO(vol)))
+		return -EROFS;
+	return 0;
+}
 
 static inline void ntfs_inc_free_clusters(struct ntfs_volume *vol, s64 nr)
 {

-- 
2.53.0

