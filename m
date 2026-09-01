Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65AB3D9539;
	Tue,  1 Sep 2026 12:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264972; cv=none; b=LeCAoQzQKIXCBz2LbpB1eKCaCEpyhJHF7IgutNN7uIL4+juDfbbwnPat3FdetuBdMx3HQJ5R+5oQ0AviRV4u62ZPiGBQiuYMGDh3I9DKTm+NV6c5QaIrJWnUV7MbcQbUa4HI9QN5txkRXSWroEmLyb5mpYu45GS4hm4RCqIxmHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264972; c=relaxed/simple;
	bh=F7KxA2ypPxg442mD4S44U1llQFKAMmz1tfZv1MKEMxQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QhTcgiaCAp5jH8gL6jYJZBvqG7syQ/XxFzsByEc2H2m8OrgRPx+GMUCu7JR9cj5c6Q64mT9dW4qVXGOysPLgudi5mSfHm2Bq7bsiBl5Q/VcES4sQC7LD0qUhXGtHGHWxy7+9nvjxpnj60oYb3EDkmJhsHaK2XaBtNpQ5aQw2D+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bZ/DCsEG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bZ/DCsEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C76A1F000E9;
	Tue,  1 Sep 2026 12:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264969;
	bh=/wUyYxXQT98D7qDh7Mnb7O9j3hKFdTUHB1n+7yJD2Gs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bZ/DCsEGaFfJj9Or8EJXHfsLRgHMCqAkAChSyHYQPOMX3qFInAzUkKDxRLhw0D7/v
	 5qd5PJuLf+QZI1uI3AZdyHbp2tHKkYOlsj9p2XSbRgAjOWdRvQ4Q7YRb59HDJyTQ3q
	 QcjXw2mdWLBDEAnWf4t8uTB5yikQfUxM/aFisRqTENHkr1UXjSmKz945yaSL1Uv1bm
	 L0dxf64MIiDDBu/SmZUNw32zay5HcleWikaz61uOzdxVC/3MwuMR+V7mlVSYapmdHZ
	 A8rLWXbBBZcTbi2K6CMeG1dPHD/Z85DSljg18Kp39pWhPC+kS1z7j6MULdiWIBU6DX
	 DoHT80mQriZ6g==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:42 +0200
Subject: [PATCH 17/27] fs: port ->tmpfile() to pass const mnt_idmap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-17-54ccd48e100b@kernel.org>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
In-Reply-To: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@lst.de>, Seth Forshee <sforshee@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, linux-security-module@vger.kernel.org, 
 Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, 
 Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 linux-unionfs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>, 
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=14642; i=brauner@kernel.org;
 h=from:subject:message-id; bh=F7KxA2ypPxg442mD4S44U1llQFKAMmz1tfZv1MKEMxQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7j2s0d9TnLUFle3+PLf0TNtVvDc+LE0Un/rv6WdC
 z3PvgtT6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhI2UGGf6qbRVesNQqfxTpV
 4t9VhzuT8rgtJkltWj7Nl0NHM8l7lhMjwwpHQ90XrL8vxM/7tsW8t8LUi2ub+x0zMfNjDHMuH0z
 WYwYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Convert to const struct mnt_idmap.

A mount's idmapping is immutable. The only thing that is allowed to be
modified afterwards is the reference count and that is hidden behind
mnt_idmap_get() and mnt_idmap_put(). Everything else only ever reads
from the idmapping. This is the same model that struct cred uses and the
idmapping is also rather sensitive.

So make the idmap argument const wherever we can. The conversion is done
from the bottom up so callers can continue to pass a non-const pointer
to a const parameter until the conversion is finished.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/locking.rst | 2 +-
 Documentation/filesystems/vfs.rst     | 2 +-
 fs/bad_inode.c                        | 2 +-
 fs/btrfs/inode.c                      | 2 +-
 fs/ext2/namei.c                       | 2 +-
 fs/ext4/namei.c                       | 2 +-
 fs/f2fs/namei.c                       | 2 +-
 fs/fuse/dir.c                         | 2 +-
 fs/hugetlbfs/inode.c                  | 2 +-
 fs/minix/namei.c                      | 2 +-
 fs/overlayfs/dir.c                    | 2 +-
 fs/ramfs/inode.c                      | 2 +-
 fs/smb/client/cifsfs.h                | 2 +-
 fs/smb/client/dir.c                   | 2 +-
 fs/ubifs/dir.c                        | 2 +-
 fs/udf/namei.c                        | 2 +-
 fs/xfs/xfs_iops.c                     | 2 +-
 include/linux/fs.h                    | 2 +-
 include/linux/lsm_hook_defs.h         | 2 +-
 include/linux/security.h              | 4 ++--
 mm/shmem.c                            | 2 +-
 security/integrity/ima/ima_main.c     | 2 +-
 security/security.c                   | 2 +-
 23 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 167988321a8c..e4948ddc0a5f 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -86,7 +86,7 @@ prototypes::
 	int (*atomic_open)(struct inode *, struct dentry *,
 				struct file *, unsigned open_flag,
 				umode_t create_mode);
-	int (*tmpfile) (struct mnt_idmap *, struct inode *,
+	int (*tmpfile) (const struct mnt_idmap *, struct inode *,
 			struct file *, umode_t);
 	int (*fileattr_set)(const struct mnt_idmap *idmap,
 			    struct dentry *dentry, struct file_kattr *fa);
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 6adb1061a9b6..e960257ef14a 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -438,7 +438,7 @@ As of kernel 2.6.22, the following members are defined:
 		void (*sync_lazytime)(struct inode *inode);
 		int (*atomic_open)(struct inode *, struct dentry *, struct file *,
 				   unsigned open_flag, umode_t create_mode);
-		int (*tmpfile) (struct mnt_idmap *, struct inode *, struct file *, umode_t);
+		int (*tmpfile) (const struct mnt_idmap *, struct inode *, struct file *, umode_t);
 		struct posix_acl * (*get_acl)(const struct mnt_idmap *, struct dentry *, int);
 	        int (*set_acl)(const struct mnt_idmap *, struct dentry *, struct posix_acl *, int);
 		int (*fileattr_set)(const struct mnt_idmap *idmap,
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 6e116810f66d..d8c0ce62cc63 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -146,7 +146,7 @@ static int bad_inode_atomic_open(struct inode *inode, struct dentry *dentry,
 	return -EIO;
 }
 
-static int bad_inode_tmpfile(struct mnt_idmap *idmap,
+static int bad_inode_tmpfile(const struct mnt_idmap *idmap,
 			     struct inode *inode, struct file *file,
 			     umode_t mode)
 {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7bf38f069116..092057508ae9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9391,7 +9391,7 @@ static int btrfs_permission(const struct mnt_idmap *idmap,
 	return generic_permission(idmap, inode, mask);
 }
 
-static int btrfs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+static int btrfs_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 			 struct file *file, umode_t mode)
 {
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(dir);
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 8666233ec63b..108dc52cedfc 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -117,7 +117,7 @@ static int ext2_create (struct mnt_idmap * idmap,
 	return ext2_add_nondir(dentry, inode);
 }
 
-static int ext2_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+static int ext2_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 			struct file *file, umode_t mode)
 {
 	struct inode *inode = ext2_new_inode(dir, mode, NULL);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index edc12599e64d..0bff01fb052a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2881,7 +2881,7 @@ static int ext4_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	return err;
 }
 
-static int ext4_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+static int ext4_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 			struct file *file, umode_t mode)
 {
 	handle_t *handle;
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index e33780294713..3adc2345a204 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -928,7 +928,7 @@ static int __f2fs_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 	return err;
 }
 
-static int f2fs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+static int f2fs_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 			struct file *file, umode_t mode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 0dbe3c6560f8..14dc9318cd57 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1098,7 +1098,7 @@ static int fuse_create(struct mnt_idmap *idmap, struct inode *dir,
 	return fuse_mknod(idmap, dir, entry, mode, 0);
 }
 
-static int fuse_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+static int fuse_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 			struct file *file, umode_t mode)
 {
 	struct fuse_conn *fc = get_fuse_conn(dir);
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 4bd3adc20a47..8a07a3f18c05 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -984,7 +984,7 @@ static int hugetlbfs_create(struct mnt_idmap *idmap,
 	return hugetlbfs_mknod(idmap, dir, dentry, mode | S_IFREG, 0);
 }
 
-static int hugetlbfs_tmpfile(struct mnt_idmap *idmap,
+static int hugetlbfs_tmpfile(const struct mnt_idmap *idmap,
 			     struct inode *dir, struct file *file,
 			     umode_t mode)
 {
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 5525ba367ed7..0575dea16a3b 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -50,7 +50,7 @@ static int minix_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	return add_nondir(dentry, inode);
 }
 
-static int minix_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+static int minix_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 			 struct file *file, umode_t mode)
 {
 	struct inode *inode = minix_new_inode(dir, mode);
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index a022dc7781bf..4f3f1e2bafff 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1420,7 +1420,7 @@ static int ovl_dummy_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int ovl_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+static int ovl_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 		       struct file *file, umode_t mode)
 {
 	int err;
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 0a88ede48e0a..fc9a79af4840 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -163,7 +163,7 @@ static int ramfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	return error;
 }
 
-static int ramfs_tmpfile(struct mnt_idmap *idmap,
+static int ramfs_tmpfile(const struct mnt_idmap *idmap,
 			 struct inode *dir, struct file *file, umode_t mode)
 {
 	struct inode *inode;
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 0c85daa8386e..255f478d3a18 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -57,7 +57,7 @@ int cifs_create(struct mnt_idmap *idmap, struct inode *dir,
 		struct dentry *direntry, umode_t mode);
 int cifs_atomic_open(struct inode *dir, struct dentry *direntry,
 		     struct file *file, unsigned int oflags, umode_t mode);
-int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+int cifs_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 		 struct file *file, umode_t mode);
 struct dentry *cifs_lookup(struct inode *parent_dir_inode,
 			   struct dentry *direntry, unsigned int flags);
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 6fa6d48fdfd3..56a3e1966257 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -1059,7 +1059,7 @@ static int set_tmpfile_attr(const unsigned int xid, unsigned int oflags,
  * The initial dentry state is unhashed-negative.  On success, dentry will
  * become unhashed-positive by calling d_instantiate().
  */
-int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+int cifs_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 		 struct file *file, umode_t mode)
 {
 	struct dentry *dentry = file->f_path.dentry;
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 23ec924162d6..0e1a4de9bb18 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -440,7 +440,7 @@ static void unlock_2_inodes(struct inode *inode1, struct inode *inode2)
 	mutex_unlock(&ubifs_inode(inode1)->ui_mutex);
 }
 
-static int ubifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+static int ubifs_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 			 struct file *file, umode_t mode)
 {
 	struct dentry *dentry = file->f_path.dentry;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index b90841ac0a40..8b5873b53324 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -386,7 +386,7 @@ static int udf_create(struct mnt_idmap *idmap, struct inode *dir,
 	return udf_add_nondir(dentry, inode);
 }
 
-static int udf_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+static int udf_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 		       struct file *file, umode_t mode)
 {
 	struct inode *inode = udf_new_inode(dir, mode);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 25d4d42fbc7f..06ca999d0927 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1250,7 +1250,7 @@ xfs_vn_fiemap(
 
 STATIC int
 xfs_vn_tmpfile(
-	struct mnt_idmap	*idmap,
+	const struct mnt_idmap	*idmap,
 	struct inode		*dir,
 	struct file		*file,
 	umode_t			mode)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9809e7c3aa0d..92161c224856 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2024,7 +2024,7 @@ struct inode_operations {
 	int (*atomic_open)(struct inode *, struct dentry *,
 			   struct file *, unsigned open_flag,
 			   umode_t create_mode);
-	int (*tmpfile) (struct mnt_idmap *, struct inode *,
+	int (*tmpfile) (const struct mnt_idmap *, struct inode *,
 			struct file *, umode_t);
 	struct posix_acl *(*get_acl)(const struct mnt_idmap *, struct dentry *,
 				     int);
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index e8638f7d2245..470de3fb22c1 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -122,7 +122,7 @@ LSM_HOOK(int, 0, inode_init_security_anon, struct inode *inode,
 	 const struct qstr *name, const struct inode *context_inode)
 LSM_HOOK(int, 0, inode_create, struct inode *dir, struct dentry *dentry,
 	 umode_t mode)
-LSM_HOOK(void, LSM_RET_VOID, inode_post_create_tmpfile, struct mnt_idmap *idmap,
+LSM_HOOK(void, LSM_RET_VOID, inode_post_create_tmpfile, const struct mnt_idmap *idmap,
 	 struct inode *inode)
 LSM_HOOK(int, 0, inode_link, struct dentry *old_dentry, struct inode *dir,
 	 struct dentry *new_dentry)
diff --git a/include/linux/security.h b/include/linux/security.h
index d5832750418a..b07a85e6aed4 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -405,7 +405,7 @@ int security_inode_init_security_anon(struct inode *inode,
 				      const struct qstr *name,
 				      const struct inode *context_inode);
 int security_inode_create(struct inode *dir, struct dentry *dentry, umode_t mode);
-void security_inode_post_create_tmpfile(struct mnt_idmap *idmap,
+void security_inode_post_create_tmpfile(const struct mnt_idmap *idmap,
 					struct inode *inode);
 int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry);
@@ -910,7 +910,7 @@ static inline int security_inode_create(struct inode *dir,
 }
 
 static inline void
-security_inode_post_create_tmpfile(struct mnt_idmap *idmap, struct inode *inode)
+security_inode_post_create_tmpfile(const struct mnt_idmap *idmap, struct inode *inode)
 { }
 
 static inline int security_inode_link(struct dentry *old_dentry,
diff --git a/mm/shmem.c b/mm/shmem.c
index 097699ea2762..a107940660a8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3857,7 +3857,7 @@ shmem_mknod(struct mnt_idmap *idmap, struct inode *dir,
 }
 
 static int
-shmem_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+shmem_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 	      struct file *file, umode_t mode)
 {
 	struct inode *inode;
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 8d9c92dc8825..72ecacda7528 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -846,7 +846,7 @@ EXPORT_SYMBOL_GPL(ima_inode_hash);
  * Skip calling process_measurement(), but indicate which newly, created
  * tmpfiles are in policy.
  */
-static void ima_post_create_tmpfile(struct mnt_idmap *idmap,
+static void ima_post_create_tmpfile(const struct mnt_idmap *idmap,
 				    struct inode *inode)
 
 {
diff --git a/security/security.c b/security/security.c
index e3a14c958bc4..4e4ef1c496ad 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1638,7 +1638,7 @@ EXPORT_SYMBOL_GPL(security_inode_create);
  *
  * Update inode security data after a tmpfile has been created.
  */
-void security_inode_post_create_tmpfile(struct mnt_idmap *idmap,
+void security_inode_post_create_tmpfile(const struct mnt_idmap *idmap,
 					struct inode *inode)
 {
 	if (unlikely(IS_PRIVATE(inode)))

-- 
2.53.0

