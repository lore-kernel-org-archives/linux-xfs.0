Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242ED2737F9;
	Tue,  1 Sep 2026 12:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264941; cv=none; b=mX/Uk53ON6e+eaQflOck2VAIKBc4FUJ4EvsEzvpdkngy7vjb4NmCUetED3SDxGD7A7cIefkiT4MxJRGG0zQxdV31CJnW/u32lczA/5Wob21R4Sq350RGKm6xVXE+rdHX2XRvL3MjZwYOFciUHXqQQkqMYM+MzRwsyqdTtDdTiuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264941; c=relaxed/simple;
	bh=qy9XcKanPj+htf+xSmQLLVd4CKdjqT+bYJk8o7hKXEo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VuuMyqNvYX9ZevkY/HNDBAzIW0abKKKfL5QX3efAh55dl2QdmDpFusE1WAyjYtC2Puh5WQF+Tdqa9D+KnZ2W19kg6weI9HCUJQd97NCOC04GpaEKLphND106oMZpL2IYfPm86FchIW8/GH3DcKn8seq0yPRq7st9l6Hc4lgFjpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i2kKKF16; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i2kKKF16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA441F00A3D;
	Tue,  1 Sep 2026 12:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264939;
	bh=WDY8H3MaG9kK9POoq90aNN9DCiEJzaVaRPF+c/QBIMk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=i2kKKF16N8IKOjVqC1T/rq57nk+cUJTXLUnyCCjnxXjvl+JpOahWJ3SH+7np1UZPD
	 TtsANnpsRLOmNF9FXvzaAggW66Co5PmnaiGiXA0sV85wjLpZXhpjQvnYhOVwCOmZtl
	 GQMaRvPdQudcOH76okH03nY0u6Jj+/GIS8/xg/gkjYL9zHorr5fSa3INPp7GRIX9DS
	 KzbP7Qb/3kc0WZjRBNfU1nR/R+Hh+kJ+CcqwXASy8mXX6/MklTW52FVyg3354e1haf
	 R/DUtVlfNL6rPth0zFZ1guq5WjZFdAK9PPbI1TfIT8vNSWiEVWY6q2n7w2ZAPRTqg/
	 HwXtICvqQTAcQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:36 +0200
Subject: [PATCH 11/27] fs: port acl to const mnt_idmap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-11-54ccd48e100b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=19692; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qy9XcKanPj+htf+xSmQLLVd4CKdjqT+bYJk8o7hKXEo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7j2dKdz368DJpO0J37vOiF+N33D+YUPOQ/Ehc4x4
 9t55Zb78o5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJbNrFyPBbuL5u10xV0zlF
 KnZXE1YYLDu0a+GCM9+C9prY++o7CT5gZLi1pO/O3nn1M7xnlsYtt9tT+/iZYZeXduqMrQ88TNW
 +zmADAA==
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
 fs/ntfs/ea.c                          |  4 ++--
 fs/ntfs/ea.h                          |  2 +-
 fs/ntfs/namei.c                       |  2 +-
 fs/ntfs3/inode.c                      |  2 +-
 fs/ntfs3/ntfs_fs.h                    |  4 ++--
 fs/ntfs3/xattr.c                      |  4 ++--
 fs/posix_acl.c                        |  6 +++---
 include/linux/lsm_hook_defs.h         |  8 ++++----
 include/linux/posix_acl.h             |  4 ++--
 include/linux/security.h              | 16 ++++++++--------
 security/integrity/evm/evm_main.c     | 10 +++++-----
 security/integrity/ima/ima_appraise.c |  4 ++--
 security/security.c                   |  8 ++++----
 security/selinux/hooks.c              |  6 +++---
 security/smack/smack_lsm.c            |  6 +++---
 15 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index cdd306933d73..744ea8c446e5 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -998,7 +998,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	return acl;
 }
 
-static noinline int ntfs_set_acl_ex(struct mnt_idmap *idmap,
+static noinline int ntfs_set_acl_ex(const struct mnt_idmap *idmap,
 				    struct inode *inode, struct posix_acl *acl,
 				    int type, bool init_acl)
 {
@@ -1086,7 +1086,7 @@ int ntfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	return ntfs_set_acl_ex(idmap, d_inode(dentry), acl, type, false);
 }
 
-int ntfs_init_acl(struct mnt_idmap *idmap, struct inode *inode,
+int ntfs_init_acl(const struct mnt_idmap *idmap, struct inode *inode,
 		  struct inode *dir)
 {
 	struct posix_acl *default_acl, *acl;
diff --git a/fs/ntfs/ea.h b/fs/ntfs/ea.h
index acb39c2a6fbc..9d17abc2e491 100644
--- a/fs/ntfs/ea.h
+++ b/fs/ntfs/ea.h
@@ -21,7 +21,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 			       int type);
 int ntfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type);
-int ntfs_init_acl(struct mnt_idmap *idmap, struct inode *inode,
+int ntfs_init_acl(const struct mnt_idmap *idmap, struct inode *inode,
 		  struct inode *dir);
 #else
 #define ntfs_get_acl NULL
diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index 7091b2496fac..e2cf1ab6935a 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -391,7 +391,7 @@ static int ntfs_sd_add_everyone(struct ntfs_inode *ni)
 	return ret;
 }
 
-static struct ntfs_inode *__ntfs_create(struct mnt_idmap *idmap, struct inode *dir,
+static struct ntfs_inode *__ntfs_create(const struct mnt_idmap *idmap, struct inode *dir,
 		__le16 *name, u8 name_len, mode_t mode, dev_t dev,
 		const char *target, int target_len)
 {
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 56b4f6469a28..a9fdd33f2886 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1381,7 +1381,7 @@ ntfs_create_reparse_buffer(struct ntfs_sb_info *sbi, const char *symname,
  *
  * NOTE: if fnd != NULL (ntfs_atomic_open) then @dir is locked
  */
-int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
+int ntfs_create_inode(const struct mnt_idmap *idmap, struct inode *dir,
 		      struct dentry *dentry, const struct cpu_str *uni,
 		      umode_t mode, dev_t dev, const char *symname, u32 size,
 		      struct ntfs_fnd *fnd)
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 5811d89d67b3..a2b74f41048f 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -803,7 +803,7 @@ int ntfs_set_size(struct inode *inode, u64 new_size);
 int ntfs3_write_inode(struct inode *inode, struct writeback_control *wbc);
 int ntfs_sync_inode(struct inode *inode);
 int inode_read_data(struct inode *inode, void *data, size_t bytes);
-int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
+int ntfs_create_inode(const struct mnt_idmap *idmap, struct inode *dir,
 		      struct dentry *dentry, const struct cpu_str *uni,
 		      umode_t mode, dev_t dev, const char *symname, u32 size,
 		      struct ntfs_fnd *fnd);
@@ -967,7 +967,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 			       int type);
 int ntfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type);
-int ntfs_init_acl(struct mnt_idmap *idmap, struct inode *inode,
+int ntfs_init_acl(const struct mnt_idmap *idmap, struct inode *inode,
 		  struct inode *dir);
 #else
 #define ntfs_get_acl NULL
diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 594ef6860b93..d800735477c3 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -595,7 +595,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	return acl;
 }
 
-static noinline int ntfs_set_acl_ex(struct mnt_idmap *idmap,
+static noinline int ntfs_set_acl_ex(const struct mnt_idmap *idmap,
 				    struct inode *inode, struct posix_acl *acl,
 				    int type, bool init_acl)
 {
@@ -688,7 +688,7 @@ int ntfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
  *
  * Called from ntfs_create_inode().
  */
-int ntfs_init_acl(struct mnt_idmap *idmap, struct inode *inode,
+int ntfs_init_acl(const struct mnt_idmap *idmap, struct inode *inode,
 		  struct inode *dir)
 {
 	struct posix_acl *default_acl, *acl;
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index f9c55a59c6c6..b279804ebf56 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -378,7 +378,7 @@ EXPORT_SYMBOL(posix_acl_from_mode);
  * by the acl. Returns -E... otherwise.
  */
 int
-posix_acl_permission(struct mnt_idmap *idmap, struct inode *inode,
+posix_acl_permission(const struct mnt_idmap *idmap, struct inode *inode,
 		     const struct posix_acl *acl, int want)
 {
 	const struct posix_acl_entry *pa, *pe, *mask_obj;
@@ -709,7 +709,7 @@ EXPORT_SYMBOL_GPL(posix_acl_create);
  *
  * Called from set_acl inode operations.
  */
-int posix_acl_update_mode(struct mnt_idmap *idmap,
+int posix_acl_update_mode(const struct mnt_idmap *idmap,
 			  struct inode *inode, umode_t *mode_p,
 			  struct posix_acl **acl)
 {
@@ -889,7 +889,7 @@ EXPORT_SYMBOL (posix_acl_to_xattr);
  * Return: On success, the size of the stored uapi posix acls, on error a
  * negative errno.
  */
-static ssize_t vfs_posix_acl_to_xattr(struct mnt_idmap *idmap,
+static ssize_t vfs_posix_acl_to_xattr(const struct mnt_idmap *idmap,
 				      struct inode *inode,
 				      const struct posix_acl *acl, void *buffer,
 				      size_t size)
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 65c9609ec207..30897590258f 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -159,15 +159,15 @@ LSM_HOOK(void, LSM_RET_VOID, inode_post_removexattr, struct dentry *dentry,
 	 const char *name)
 LSM_HOOK(int, 0, inode_file_setattr, struct dentry *dentry, struct file_kattr *fa)
 LSM_HOOK(int, 0, inode_file_getattr, struct dentry *dentry, struct file_kattr *fa)
-LSM_HOOK(int, 0, inode_set_acl, struct mnt_idmap *idmap,
+LSM_HOOK(int, 0, inode_set_acl, const struct mnt_idmap *idmap,
 	 struct dentry *dentry, const char *acl_name, struct posix_acl *kacl)
 LSM_HOOK(void, LSM_RET_VOID, inode_post_set_acl, struct dentry *dentry,
 	 const char *acl_name, struct posix_acl *kacl)
-LSM_HOOK(int, 0, inode_get_acl, struct mnt_idmap *idmap,
+LSM_HOOK(int, 0, inode_get_acl, const struct mnt_idmap *idmap,
 	 struct dentry *dentry, const char *acl_name)
-LSM_HOOK(int, 0, inode_remove_acl, struct mnt_idmap *idmap,
+LSM_HOOK(int, 0, inode_remove_acl, const struct mnt_idmap *idmap,
 	 struct dentry *dentry, const char *acl_name)
-LSM_HOOK(void, LSM_RET_VOID, inode_post_remove_acl, struct mnt_idmap *idmap,
+LSM_HOOK(void, LSM_RET_VOID, inode_post_remove_acl, const struct mnt_idmap *idmap,
 	 struct dentry *dentry, const char *acl_name)
 LSM_HOOK(int, 0, inode_need_killpriv, struct dentry *dentry)
 LSM_HOOK(int, 0, inode_killpriv, struct mnt_idmap *idmap,
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 62d497763e25..7c6cfcae0a9d 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -84,7 +84,7 @@ struct posix_acl *posix_acl_clone(const struct posix_acl *acl, gfp_t flags);
 int posix_acl_chmod(struct mnt_idmap *, struct dentry *, umode_t);
 extern int posix_acl_create(struct inode *, umode_t *, struct posix_acl **,
 		struct posix_acl **);
-int posix_acl_update_mode(struct mnt_idmap *, struct inode *, umode_t *,
+int posix_acl_update_mode(const struct mnt_idmap *, struct inode *, umode_t *,
 			  struct posix_acl **);
 
 int simple_set_acl(struct mnt_idmap *, struct dentry *,
@@ -96,7 +96,7 @@ void set_cached_acl(struct inode *inode, int type, struct posix_acl *acl);
 void forget_cached_acl(struct inode *inode, int type);
 void forget_all_cached_acls(struct inode *inode);
 int posix_acl_valid(struct user_namespace *, const struct posix_acl *);
-int posix_acl_permission(struct mnt_idmap *, struct inode *,
+int posix_acl_permission(const struct mnt_idmap *, struct inode *,
 			 const struct posix_acl *, int);
 
 static inline void cache_no_acl(struct inode *inode)
diff --git a/include/linux/security.h b/include/linux/security.h
index 4598a13657ee..12bc12e243bf 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -430,16 +430,16 @@ int security_inode_getattr(const struct path *path);
 int security_inode_setxattr(struct mnt_idmap *idmap,
 			    struct dentry *dentry, const char *name,
 			    const void *value, size_t size, int flags);
-int security_inode_set_acl(struct mnt_idmap *idmap,
+int security_inode_set_acl(const struct mnt_idmap *idmap,
 			   struct dentry *dentry, const char *acl_name,
 			   struct posix_acl *kacl);
 void security_inode_post_set_acl(struct dentry *dentry, const char *acl_name,
 				 struct posix_acl *kacl);
-int security_inode_get_acl(struct mnt_idmap *idmap,
+int security_inode_get_acl(const struct mnt_idmap *idmap,
 			   struct dentry *dentry, const char *acl_name);
-int security_inode_remove_acl(struct mnt_idmap *idmap,
+int security_inode_remove_acl(const struct mnt_idmap *idmap,
 			      struct dentry *dentry, const char *acl_name);
-void security_inode_post_remove_acl(struct mnt_idmap *idmap,
+void security_inode_post_remove_acl(const struct mnt_idmap *idmap,
 				    struct dentry *dentry,
 				    const char *acl_name);
 void security_inode_post_setxattr(struct dentry *dentry, const char *name,
@@ -1003,7 +1003,7 @@ static inline int security_inode_setxattr(struct mnt_idmap *idmap,
 	return cap_inode_setxattr(dentry, name, value, size, flags);
 }
 
-static inline int security_inode_set_acl(struct mnt_idmap *idmap,
+static inline int security_inode_set_acl(const struct mnt_idmap *idmap,
 					 struct dentry *dentry,
 					 const char *acl_name,
 					 struct posix_acl *kacl)
@@ -1016,21 +1016,21 @@ static inline void security_inode_post_set_acl(struct dentry *dentry,
 					       struct posix_acl *kacl)
 { }
 
-static inline int security_inode_get_acl(struct mnt_idmap *idmap,
+static inline int security_inode_get_acl(const struct mnt_idmap *idmap,
 					 struct dentry *dentry,
 					 const char *acl_name)
 {
 	return 0;
 }
 
-static inline int security_inode_remove_acl(struct mnt_idmap *idmap,
+static inline int security_inode_remove_acl(const struct mnt_idmap *idmap,
 					    struct dentry *dentry,
 					    const char *acl_name)
 {
 	return 0;
 }
 
-static inline void security_inode_post_remove_acl(struct mnt_idmap *idmap,
+static inline void security_inode_post_remove_acl(const struct mnt_idmap *idmap,
 						  struct dentry *dentry,
 						  const char *acl_name)
 { }
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 06e187c9912d..aaf228ebed7c 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -652,7 +652,7 @@ static int evm_inode_removexattr(struct mnt_idmap *idmap, struct dentry *dentry,
 }
 
 #ifdef CONFIG_FS_POSIX_ACL
-static int evm_inode_set_acl_change(struct mnt_idmap *idmap,
+static int evm_inode_set_acl_change(const struct mnt_idmap *idmap,
 				    struct dentry *dentry, const char *name,
 				    struct posix_acl *kacl)
 {
@@ -671,7 +671,7 @@ static int evm_inode_set_acl_change(struct mnt_idmap *idmap,
 	return 0;
 }
 #else
-static inline int evm_inode_set_acl_change(struct mnt_idmap *idmap,
+static inline int evm_inode_set_acl_change(const struct mnt_idmap *idmap,
 					   struct dentry *dentry,
 					   const char *name,
 					   struct posix_acl *kacl)
@@ -693,7 +693,7 @@ static inline int evm_inode_set_acl_change(struct mnt_idmap *idmap,
  *
  * Return: zero on success, -EPERM on failure.
  */
-static int evm_inode_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+static int evm_inode_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 			     const char *acl_name, struct posix_acl *kacl)
 {
 	enum integrity_status evm_status;
@@ -745,7 +745,7 @@ static int evm_inode_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
  *
  * Return: zero on success, -EPERM on failure.
  */
-static int evm_inode_remove_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+static int evm_inode_remove_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 				const char *acl_name)
 {
 	return evm_inode_set_acl(idmap, dentry, acl_name, NULL);
@@ -926,7 +926,7 @@ static void evm_inode_post_removexattr(struct dentry *dentry,
  * Update the 'security.evm' xattr with the EVM HMAC re-calculated after
  * removing posix acls.
  */
-static inline void evm_inode_post_remove_acl(struct mnt_idmap *idmap,
+static inline void evm_inode_post_remove_acl(const struct mnt_idmap *idmap,
 					     struct dentry *dentry,
 					     const char *acl_name)
 {
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 6b21db789ef1..1aed041c127a 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -790,7 +790,7 @@ static int ima_inode_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	return result;
 }
 
-static int ima_inode_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+static int ima_inode_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 			     const char *acl_name, struct posix_acl *kacl)
 {
 	if (evm_revalidate_status(acl_name))
@@ -815,7 +815,7 @@ static int ima_inode_removexattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	return result;
 }
 
-static int ima_inode_remove_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+static int ima_inode_remove_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 				const char *acl_name)
 {
 	return ima_inode_set_acl(idmap, dentry, acl_name, NULL);
diff --git a/security/security.c b/security/security.c
index 2ee276ab15c5..e81dcda3050b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1953,7 +1953,7 @@ int security_inode_setxattr(struct mnt_idmap *idmap,
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_inode_set_acl(struct mnt_idmap *idmap,
+int security_inode_set_acl(const struct mnt_idmap *idmap,
 			   struct dentry *dentry, const char *acl_name,
 			   struct posix_acl *kacl)
 {
@@ -1990,7 +1990,7 @@ void security_inode_post_set_acl(struct dentry *dentry, const char *acl_name,
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_inode_get_acl(struct mnt_idmap *idmap,
+int security_inode_get_acl(const struct mnt_idmap *idmap,
 			   struct dentry *dentry, const char *acl_name)
 {
 	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
@@ -2009,7 +2009,7 @@ int security_inode_get_acl(struct mnt_idmap *idmap,
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_inode_remove_acl(struct mnt_idmap *idmap,
+int security_inode_remove_acl(const struct mnt_idmap *idmap,
 			      struct dentry *dentry, const char *acl_name)
 {
 	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
@@ -2026,7 +2026,7 @@ int security_inode_remove_acl(struct mnt_idmap *idmap,
  * Update inode security data after successfully removing posix acls on
  * @dentry in @idmap. The posix acls are identified by @acl_name.
  */
-void security_inode_post_remove_acl(struct mnt_idmap *idmap,
+void security_inode_post_remove_acl(const struct mnt_idmap *idmap,
 				    struct dentry *dentry, const char *acl_name)
 {
 	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 035aaf113d1d..672d6374d8b0 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3453,20 +3453,20 @@ static int selinux_inode_setxattr(struct mnt_idmap *idmap,
 			    &ad);
 }
 
-static int selinux_inode_set_acl(struct mnt_idmap *idmap,
+static int selinux_inode_set_acl(const struct mnt_idmap *idmap,
 				 struct dentry *dentry, const char *acl_name,
 				 struct posix_acl *kacl)
 {
 	return dentry_has_perm(current_cred(), dentry, FILE__SETATTR);
 }
 
-static int selinux_inode_get_acl(struct mnt_idmap *idmap,
+static int selinux_inode_get_acl(const struct mnt_idmap *idmap,
 				 struct dentry *dentry, const char *acl_name)
 {
 	return dentry_has_perm(current_cred(), dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_remove_acl(struct mnt_idmap *idmap,
+static int selinux_inode_remove_acl(const struct mnt_idmap *idmap,
 				    struct dentry *dentry, const char *acl_name)
 {
 	return dentry_has_perm(current_cred(), dentry, FILE__SETATTR);
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 8e88ac65fd7f..244cdb49e928 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1543,7 +1543,7 @@ static int smack_inode_removexattr(struct mnt_idmap *idmap,
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_set_acl(struct mnt_idmap *idmap,
+static int smack_inode_set_acl(const struct mnt_idmap *idmap,
 			       struct dentry *dentry, const char *acl_name,
 			       struct posix_acl *kacl)
 {
@@ -1566,7 +1566,7 @@ static int smack_inode_set_acl(struct mnt_idmap *idmap,
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_get_acl(struct mnt_idmap *idmap,
+static int smack_inode_get_acl(const struct mnt_idmap *idmap,
 			       struct dentry *dentry, const char *acl_name)
 {
 	struct smk_audit_info ad;
@@ -1588,7 +1588,7 @@ static int smack_inode_get_acl(struct mnt_idmap *idmap,
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_remove_acl(struct mnt_idmap *idmap,
+static int smack_inode_remove_acl(const struct mnt_idmap *idmap,
 				  struct dentry *dentry, const char *acl_name)
 {
 	struct smk_audit_info ad;

-- 
2.53.0

