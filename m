Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290157;
	b=VmevybBo4m0DSEimJKQf+gVDA0CTzWER/ieqpagM6g6Z1adCBiVLX7Rp8Pz5+mberGlv
	 dYMmXkozoG+vGOJ9qXBk4pwDMWU2Yu2n70EUs6GQcVuVou+NgOGxZJqRCj2s0RfXHHORX
	 Jf3FWb7qVaJXtoe28okVfZFPFgHYIAFWWzVsgLL2Sp+fF/+AzxIkjxSxi9V/E+Q9LVx7x
	 yo4AIiXChNqqREakiEC3+0iaIf6maqmV2siCmUGcLswuOzitnp7GqkBA/qKAcW6PCcTUv
	 RkRYcHFaeenKyfhlhLsEASxNEBmzcTGlNIza9wI8oNxwOUTXYd0D12nKcs5YyE1nJqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290157;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=JkdQO+YBsvQjKQworQpYH8vO8/UOr7Qlmxg7K5skePI=;
	b=PO3kWWogKUL7Re/3XTZzOFdbhEm0Iny4WEhGYYoAJd1bfhWU75i01bNFyGR/bCp4sXEZ
	 Z2nP9fhqCzDvybWnhRBKhqyw3tXP8jISbv7IL707CzvXYIgqZ/OESfZ6c3VTV9qv1l3S9
	 ZXbCidjbrh3Vnufp+BXF2AqaNscRGwg+A+c2dBMfxQgmNnnmszBQhlTs0IKC83bpNtoBY
	 N4Zt/HDnAWttp+Gmd9+Kxka9oQe/lA3/UgZ7nLqySpKa7Z/ZwAKAqRHPBg/KeJfl78ROT
	 Rw6C4LRoE2RulBAS91kuVGojiFnzlqkoRTGtiH3OIbx3oJ91uAJH4mGMDu3UEhxcFnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mrrWIVWJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8A5606A334;
	Thu, 29 Oct 2026 16:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mrrWIVWJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58871F01816;
	Thu, 29 Oct 2026 16:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290156;
	bh=JkdQO+YBsvQjKQworQpYH8vO8/UOr7Qlmxg7K5skePI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mrrWIVWJJYtrEyzqalsq+jfAIY1b2XX3XDlFV9LwDMV2wicKmVA1vRfk6egoSDc/a
	 9k5dW5KWy9QFpVHiHBsWPWniS/SvLIk2eSelRkB/Dvv01VeBTfFoPG2PeLB1Zmae4X
	 LZn24GovpqdCh98YcMagqRO+Ax2fTp/vP8zLDcqbenaKTkCLGIQ8BR2/ysxPKerNpm
	 3K3IwC2Bh09JmbBiyq1qDSFFLmGSv5LQPvP1FPxp2F+SxE8rn98ABCXLM8sq9g3xp4
	 Ogc06ku/Uww1/KHqehDyuAAQ1Efit+K/NVAirNGnvLZXP+0n3/emxCEZiIwSFSWR6h
	 5xrlhivctXsWw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:18 +0100
Subject: [PATCH v2 27/34] efivarfs: stop using SB_RDONLY for read-only
 efivar ops
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-27-2f44f64f0b66@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=7542; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9Nzvz+SGSEV2fnN6zHLrFwCHdibkiHMafd4mmQN+cgk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjdwWZvhEPJbr3r2mdvuvucOMOSrrpRbMvMEexp3s
 1mU+bP/HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPZJ8LIMMG7L5ajvvf6dsvL
 2+/JxogGJizke2ndJPFg0dJJOeJ+ggz/zE8f37L5NPu1hgldbOs/HdQ4cEFrCkvgZl7ZCSUOpxy
 TWAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Since commit 94f7f6182c72 ("efivarfs: automatically update super block
flag") efivarfs_ops_notifier() sets or clears SB_RDONLY whenever the
efivar ops switch between ops that can and ops that can't set variables,
e.g. when tee_stmm_efi is probed or removed. It does that at any time
without holding s_umount. efivarfs is frozen on every suspend and if the
ops switch while it's frozen thaw_super() either leaves the s_writers
rwsems locked or releases rwsems nobody holds.

So keep the state in efivarfs. The notifier sets and clears a new
EFIVARFS_OPS_RDONLY flag instead and efivarfs_fill_super() initializes
it under efivar_lock() so a switch can't slip in. fill_super doesn't set
SB_RDONLY either. systemd mounts efivarfs before tee_stmm_efi is loaded
and the mount has to become writable then. create, unlink, setattr,
fileattr_set, write and opening for write fail with EROFS while the flag
is set. Like the SB_RDONLY check this runs without efivars_lock so a
write racing with a switch can still call a NULL ->set_variable. That's
not new.

efivarfs_reconfigure() only refuses a remount from read-only to
read-write while the flag is set and returns EROFS. It used to refuse
every remount without "ro" which would break option-only remounts.

With read-only ops efivarfs is mounted "rw" now. statfs() doesn't report
ST_RDONLY anymore and access(W_OK) succeeds.

Fixes: 94f7f6182c72 ("efivarfs: automatically update super block flag")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/efivarfs/file.c     |  6 ++++++
 fs/efivarfs/inode.c    | 15 +++++++++++++++
 fs/efivarfs/internal.h | 14 +++++++++++++-
 fs/efivarfs/super.c    | 26 ++++++++++++++++++--------
 4 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index cb1b6d0c3454..a074145fa57e 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -23,6 +23,9 @@ static ssize_t efivarfs_file_write(struct file *file,
 	ssize_t bytes;
 	bool set = false;
 
+	if (efivarfs_ops_rdonly(inode->i_sb))
+		return -EROFS;
+
 	if (count < sizeof(attributes))
 		return -EINVAL;
 
@@ -137,6 +140,9 @@ static int efivarfs_file_open(struct inode *inode, struct file *file)
 {
 	struct efivar_entry *entry = inode->i_private;
 
+	if ((file->f_mode & FMODE_WRITE) && efivarfs_ops_rdonly(inode->i_sb))
+		return -EROFS;
+
 	file->private_data = entry;
 
 	inode_lock(inode);
diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
index 07602cd5d33c..be183de4b771 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -15,6 +15,8 @@
 #include "internal.h"
 
 static const struct inode_operations efivarfs_file_inode_operations;
+static int efivarfs_setattr(const struct mnt_idmap *idmap,
+			    struct dentry *dentry, struct iattr *iattr);
 
 struct inode *efivarfs_get_inode(struct super_block *sb,
 				const struct inode *dir, int mode,
@@ -83,6 +85,9 @@ static int efivarfs_create(const struct mnt_idmap *idmap, struct inode *dir,
 	bool is_removable = false;
 	efi_guid_t vendor;
 
+	if (efivarfs_ops_rdonly(dir->i_sb))
+		return -EROFS;
+
 	if (!efivarfs_valid_name(dentry->d_name.name, dentry->d_name.len))
 		return -EINVAL;
 
@@ -122,6 +127,9 @@ static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct efivar_entry *var = d_inode(dentry)->i_private;
 
+	if (efivarfs_ops_rdonly(dir->i_sb))
+		return -EROFS;
+
 	if (efivar_entry_delete(var))
 		return -EINVAL;
 
@@ -132,6 +140,7 @@ const struct inode_operations efivarfs_dir_inode_operations = {
 	.lookup = simple_lookup,
 	.unlink = efivarfs_unlink,
 	.create = efivarfs_create,
+	.setattr = efivarfs_setattr,
 };
 
 static int
@@ -155,6 +164,9 @@ efivarfs_fileattr_set(const struct mnt_idmap *idmap,
 {
 	unsigned int i_flags = 0;
 
+	if (efivarfs_ops_rdonly(dentry->d_sb))
+		return -EROFS;
+
 	if (fileattr_has_fsx(fa))
 		return -EOPNOTSUPP;
 
@@ -176,6 +188,9 @@ static int efivarfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry
 	struct inode *inode = d_inode(dentry);
 	int error;
 
+	if (efivarfs_ops_rdonly(inode->i_sb))
+		return -EROFS;
+
 	error = setattr_prepare(idmap, dentry, iattr);
 	if (error)
 		return error;
diff --git a/fs/efivarfs/internal.h b/fs/efivarfs/internal.h
index f5c1a25be996..34a0c53b5993 100644
--- a/fs/efivarfs/internal.h
+++ b/fs/efivarfs/internal.h
@@ -16,10 +16,22 @@ struct efivarfs_mount_opts {
 
 struct efivarfs_fs_info {
 	struct efivarfs_mount_opts mount_opts;
-	struct super_block *sb;
 	struct notifier_block nb;
+	unsigned long flags;
 };
 
+/* efivarfs_fs_info->flags */
+enum {
+	EFIVARFS_OPS_RDONLY,	/* the registered efivar ops can't set variables */
+};
+
+static inline bool efivarfs_ops_rdonly(const struct super_block *sb)
+{
+	const struct efivarfs_fs_info *sfi = sb->s_fs_info;
+
+	return test_bit(EFIVARFS_OPS_RDONLY, &sfi->flags);
+}
+
 struct efi_variable {
 	efi_char16_t  VariableName[EFI_VAR_NAME_LEN/sizeof(efi_char16_t)];
 	efi_guid_t    VendorGuid;
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 12746ced6dc6..437dfea9aa42 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -28,12 +28,16 @@ static int efivarfs_ops_notifier(struct notifier_block *nb, unsigned long event,
 {
 	struct efivarfs_fs_info *sfi = container_of(nb, struct efivarfs_fs_info, nb);
 
+	/*
+	 * This runs without s_umount so it can't touch SB_RDONLY. The
+	 * modifying operations check EFIVARFS_OPS_RDONLY instead.
+	 */
 	switch (event) {
 	case EFIVAR_OPS_RDONLY:
-		sfi->sb->s_flags |= SB_RDONLY;
+		set_bit(EFIVARFS_OPS_RDONLY, &sfi->flags);
 		break;
 	case EFIVAR_OPS_RDWR:
-		sfi->sb->s_flags &= ~SB_RDONLY;
+		clear_bit(EFIVARFS_OPS_RDONLY, &sfi->flags);
 		break;
 	default:
 		return NOTIFY_DONE;
@@ -384,9 +388,6 @@ static int efivarfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_d_flags |= DCACHE_DONTCACHE;
 	sb->s_time_gran         = 1;
 
-	if (!efivar_supports_writes())
-		sb->s_flags |= SB_RDONLY;
-
 	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0, true);
 	if (!inode)
 		return -ENOMEM;
@@ -397,9 +398,15 @@ static int efivarfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (!root)
 		return -ENOMEM;
 
-	sfi->sb = sb;
+	/* The ops can't switch between sampling them and registering. */
+	err = efivar_lock();
+	if (err)
+		return err;
+	if (!efivar_supports_writes())
+		set_bit(EFIVARFS_OPS_RDONLY, &sfi->flags);
 	sfi->nb.notifier_call = efivarfs_ops_notifier;
 	err = blocking_notifier_chain_register(&efivar_ops_nh, &sfi->nb);
+	efivar_unlock();
 	if (err)
 		return err;
 
@@ -413,12 +420,15 @@ static int efivarfs_get_tree(struct fs_context *fc)
 
 static int efivarfs_reconfigure(struct fs_context *fc)
 {
+	struct super_block *sb = fc->root->d_sb;
 	struct efivarfs_fs_info *sfi = fc->root->d_sb->s_fs_info;
 	struct efivarfs_fs_info *new_sfi = fc->s_fs_info;
 
-	if (!efivar_supports_writes() && !(fc->sb_flags & SB_RDONLY)) {
+	/* Only refuse remounting a read-only mount read-write. */
+	if ((fc->sb_flags_mask & SB_RDONLY) && !(fc->sb_flags & SB_RDONLY) &&
+	    sb_rdonly(sb) && efivarfs_ops_rdonly(sb)) {
 		pr_err("Firmware does not support SetVariableRT. Can not remount with rw\n");
-		return -EINVAL;
+		return -EROFS;
 	}
 
 	/* statfs()/show_options() read nostatfs locklessly; benign race. */

-- 
2.53.0

