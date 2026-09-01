Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1532C39A054;
	Tue,  1 Sep 2026 12:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264968; cv=none; b=BTaGF7orILKaDIdntDsVbMzM5ucXcBCGL3+YQf1ne62JqTp2B4P5+o2FhBGf37XSVb01Og2Ef3Rfrj39x5XXri1cFaVMOKNY4CsxT6A9bgp9BdaDJ4B5dJwtiS+xMZ+tKNA2JnPHI7m00mk92zRL50pUKd5Rpt7tiB7AJP0y56E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264968; c=relaxed/simple;
	bh=3Mro/ggXkaCxVSnTsfuyaZMnBiMWnW8eMM7VsiPQcEA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iwJqbx3eh0t/7XXENLDqMZSZ5I61WCc3/79b9LV3dnRce6REpDr3817BWNSA1R0dBAYNKDnHE5ivdDPEmESCZ15SWvJC9cWzw6hlzOmZYtaHHwnZSV/9CK77xRjDOcQnHyqc+6j8+fT8wPKLJeQ8t8HvT4mIeSqNssPmcSY+Z8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izeiK/M/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izeiK/M/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBBC1F00A3D;
	Tue,  1 Sep 2026 12:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264964;
	bh=RerMGPYC376/ZSTkEUCz2Jeflowfq5Rxn7cWt0+cEuQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=izeiK/M/TB4pLbNXTvyAnh2xKEw+ybulnyQotVIw1+FVArpBUXI/cWJVg0AcNQTqf
	 /+k4P0tm3IiGcTc87yA1BC+s5GTsQyvq7YFmAWDv7Q/ekYsEb9pLqVjjM4QCj8Mu80
	 Yg/SMIi6XgBCGbn99RdFTHHGiCho6P9YYU7THzF8L7TsXvg0ewZjZA1s8UbPNzbx5X
	 LVN15jOQU7Zvqo0FXb4xt8+Wfmv1BrBzBu0Dv455I6ScGW21X3bA6jUhEXX6p4bmg+
	 YoaUag//IYE476OxAqwRc+N2ojJXnJLKR4GlzzvQaDk0i8PU2ygoj23Cn/AseBMMB/
	 0Q4+5JYv7rfDQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:41 +0200
Subject: [PATCH 16/27] fs: port ->get_acl() to pass const mnt_idmap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-16-54ccd48e100b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=14066; i=brauner@kernel.org;
 h=from:subject:message-id; bh=3Mro/ggXkaCxVSnTsfuyaZMnBiMWnW8eMM7VsiPQcEA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7g2WPJA3a4D16PSe79u0I89JsWjcKPk2yuJa7tFn
 dkfmRTu7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZgIiwTD/0qztYfqEybeDTy8
 c7G36uoX3/XMz7PyXN3osupYqoXRPwdGhkPGWyZVaDpJdbGuiEj/kBsR0yTe9PhXwapum7VuunI
 LeQE=
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
 fs/9p/acl.c                           | 2 +-
 fs/9p/acl.h                           | 2 +-
 fs/ecryptfs/inode.c                   | 2 +-
 fs/fuse/acl.c                         | 2 +-
 fs/fuse/fuse_i.h                      | 2 +-
 fs/internal.h                         | 4 ++--
 fs/ntfs/ea.c                          | 2 +-
 fs/ntfs/ea.h                          | 2 +-
 fs/ntfs3/ntfs_fs.h                    | 2 +-
 fs/ntfs3/xattr.c                      | 2 +-
 fs/overlayfs/overlayfs.h              | 2 +-
 fs/posix_acl.c                        | 6 +++---
 fs/smb/client/cifsacl.c               | 2 +-
 fs/smb/client/cifsproto.h             | 2 +-
 fs/xattr.c                            | 2 +-
 include/linux/fs.h                    | 2 +-
 include/linux/posix_acl.h             | 4 ++--
 19 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index b95cd4992896..167988321a8c 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -91,7 +91,7 @@ prototypes::
 	int (*fileattr_set)(const struct mnt_idmap *idmap,
 			    struct dentry *dentry, struct file_kattr *fa);
 	int (*fileattr_get)(struct dentry *dentry, struct file_kattr *fa);
-	struct posix_acl * (*get_acl)(struct mnt_idmap *, struct dentry *, int);
+	struct posix_acl * (*get_acl)(const struct mnt_idmap *, struct dentry *, int);
 	struct offset_ctx *(*get_offset_ctx)(struct inode *inode);
 
 locking rules:
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index d0dd2be3885b..6adb1061a9b6 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -439,7 +439,7 @@ As of kernel 2.6.22, the following members are defined:
 		int (*atomic_open)(struct inode *, struct dentry *, struct file *,
 				   unsigned open_flag, umode_t create_mode);
 		int (*tmpfile) (struct mnt_idmap *, struct inode *, struct file *, umode_t);
-		struct posix_acl * (*get_acl)(struct mnt_idmap *, struct dentry *, int);
+		struct posix_acl * (*get_acl)(const struct mnt_idmap *, struct dentry *, int);
 	        int (*set_acl)(const struct mnt_idmap *, struct dentry *, struct posix_acl *, int);
 		int (*fileattr_set)(const struct mnt_idmap *idmap,
 				    struct dentry *dentry, struct file_kattr *fa);
diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index d09a41336d0d..c6c7c47d32b9 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -140,7 +140,7 @@ struct posix_acl *v9fs_iop_get_inode_acl(struct inode *inode, int type, bool rcu
 
 }
 
-struct posix_acl *v9fs_iop_get_acl(struct mnt_idmap *idmap,
+struct posix_acl *v9fs_iop_get_acl(const struct mnt_idmap *idmap,
 				   struct dentry *dentry, int type)
 {
 	struct v9fs_session_info *v9ses;
diff --git a/fs/9p/acl.h b/fs/9p/acl.h
index 7de74704c465..2d1b24abcd3f 100644
--- a/fs/9p/acl.h
+++ b/fs/9p/acl.h
@@ -10,7 +10,7 @@
 int v9fs_get_acl(struct inode *inode, struct p9_fid *fid);
 struct posix_acl *v9fs_iop_get_inode_acl(struct inode *inode, int type,
 				   bool rcu);
-struct posix_acl *v9fs_iop_get_acl(struct mnt_idmap *idmap,
+struct posix_acl *v9fs_iop_get_acl(const struct mnt_idmap *idmap,
 					  struct dentry *dentry, int type);
 int v9fs_iop_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		     struct posix_acl *acl, int type);
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 1e5146485214..bd1187661d6d 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1090,7 +1090,7 @@ static int ecryptfs_fileattr_set(const struct mnt_idmap *idmap,
 	return rc;
 }
 
-static struct posix_acl *ecryptfs_get_acl(struct mnt_idmap *idmap,
+static struct posix_acl *ecryptfs_get_acl(const struct mnt_idmap *idmap,
 					  struct dentry *dentry, int type)
 {
 	return vfs_get_acl(idmap, ecryptfs_dentry_to_lower(dentry),
diff --git a/fs/fuse/acl.c b/fs/fuse/acl.c
index c3813fff4f27..738abed9a816 100644
--- a/fs/fuse/acl.c
+++ b/fs/fuse/acl.c
@@ -62,7 +62,7 @@ static inline bool fuse_no_acl(const struct fuse_conn *fc,
 	return !fc->posix_acl && (i_user_ns(inode) != &init_user_ns);
 }
 
-struct posix_acl *fuse_get_acl(struct mnt_idmap *idmap,
+struct posix_acl *fuse_get_acl(const struct mnt_idmap *idmap,
 			       struct dentry *dentry, int type)
 {
 	struct inode *inode = d_inode(dentry);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 561ada21ea86..9bf4c738bd74 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1205,7 +1205,7 @@ extern const struct xattr_handler * const fuse_xattr_handlers[];
 
 struct posix_acl;
 struct posix_acl *fuse_get_inode_acl(struct inode *inode, int type, bool rcu);
-struct posix_acl *fuse_get_acl(struct mnt_idmap *idmap,
+struct posix_acl *fuse_get_acl(const struct mnt_idmap *idmap,
 			       struct dentry *dentry, int type);
 int fuse_set_acl(const struct mnt_idmap *, struct dentry *dentry,
 		 struct posix_acl *acl, int type);
diff --git a/fs/internal.h b/fs/internal.h
index 8ba0a1613d20..8a1c7c05c5a2 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -304,7 +304,7 @@ int may_write_xattr(const struct mnt_idmap *idmap, struct inode *inode);
 #ifdef CONFIG_FS_POSIX_ACL
 int do_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	       const char *acl_name, const void *kvalue, size_t size);
-ssize_t do_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+ssize_t do_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		   const char *acl_name, void *kvalue, size_t size);
 #else
 static inline int do_set_acl(const struct mnt_idmap *idmap,
@@ -313,7 +313,7 @@ static inline int do_set_acl(const struct mnt_idmap *idmap,
 {
 	return -EOPNOTSUPP;
 }
-static inline ssize_t do_get_acl(struct mnt_idmap *idmap,
+static inline ssize_t do_get_acl(const struct mnt_idmap *idmap,
 				 struct dentry *dentry, const char *acl_name,
 				 void *kvalue, size_t size)
 {
diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index 063cc15f1626..ed31f0e9f5d2 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -954,7 +954,7 @@ const struct xattr_handler * const ntfs_xattr_handlers[] = {
 // clang-format on
 
 #ifdef CONFIG_NTFS_FS_POSIX_ACL
-struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+struct posix_acl *ntfs_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 			       int type)
 {
 	struct inode *inode = d_inode(dentry);
diff --git a/fs/ntfs/ea.h b/fs/ntfs/ea.h
index 6d98e7487a2c..690fafe181fb 100644
--- a/fs/ntfs/ea.h
+++ b/fs/ntfs/ea.h
@@ -17,7 +17,7 @@ int ntfs_ea_set_wsl_inode(struct inode *inode, dev_t rdev, __le16 *ea_size,
 ssize_t ntfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
 #ifdef CONFIG_NTFS_FS_POSIX_ACL
-struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+struct posix_acl *ntfs_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 			       int type);
 int ntfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type);
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 0a5e81d420f0..d89609a17886 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -963,7 +963,7 @@ unsigned long ntfs_names_hash(const u16 *name, size_t len, const u16 *upcase,
 
 /* globals from xattr.c */
 #ifdef CONFIG_NTFS3_FS_POSIX_ACL
-struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+struct posix_acl *ntfs_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 			       int type);
 int ntfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type);
diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 2d17b80999ca..941d516ab8dd 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -543,7 +543,7 @@ static noinline int ntfs_set_ea(struct inode *inode, const char *name,
 /*
  * ntfs_get_acl - inode_operations::get_acl
  */
-struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+struct posix_acl *ntfs_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 			       int type)
 {
 	struct inode *inode = d_inode(dentry);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 8b335993bf56..1759221dcad5 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -814,7 +814,7 @@ static inline struct posix_acl *ovl_get_inode_acl(struct inode *inode, int type,
 {
 	return do_ovl_get_acl(&nop_mnt_idmap, inode, type, rcu, true);
 }
-static inline struct posix_acl *ovl_get_acl(struct mnt_idmap *idmap,
+static inline struct posix_acl *ovl_get_acl(const struct mnt_idmap *idmap,
 					    struct dentry *dentry, int type)
 {
 	return do_ovl_get_acl(idmap, d_inode(dentry), type, false, false);
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index cec7fb557278..fe77934ea8f2 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -118,7 +118,7 @@ void forget_all_cached_acls(struct inode *inode)
 }
 EXPORT_SYMBOL(forget_all_cached_acls);
 
-static struct posix_acl *__get_acl(struct mnt_idmap *idmap,
+static struct posix_acl *__get_acl(const struct mnt_idmap *idmap,
 				   struct dentry *dentry, struct inode *inode,
 				   int type)
 {
@@ -1168,7 +1168,7 @@ EXPORT_SYMBOL_GPL(vfs_set_acl);
  *
  * Return: On success POSIX ACLs in VFS format, on error negative errno.
  */
-struct posix_acl *vfs_get_acl(struct mnt_idmap *idmap,
+struct posix_acl *vfs_get_acl(const struct mnt_idmap *idmap,
 			      struct dentry *dentry, const char *acl_name)
 {
 	struct inode *inode = d_inode(dentry);
@@ -1286,7 +1286,7 @@ int do_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	return error;
 }
 
-ssize_t do_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+ssize_t do_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		   const char *acl_name, void *kvalue, size_t size)
 {
 	ssize_t error;
diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 0a05b6b0be5f..084a4460ca19 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1867,7 +1867,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 	return rc;
 }
 
-struct posix_acl *cifs_get_acl(struct mnt_idmap *idmap,
+struct posix_acl *cifs_get_acl(const struct mnt_idmap *idmap,
 			       struct dentry *dentry, int type)
 {
 #if defined(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) && defined(CONFIG_CIFS_POSIX)
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 565697c233a9..e6beff8aafe0 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -212,7 +212,7 @@ struct smb_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
 struct smb_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
 				     const struct cifs_fid *cifsfid,
 				     u32 *pacllen, u32 info);
-struct posix_acl *cifs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+struct posix_acl *cifs_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 			       int type);
 int cifs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type);
diff --git a/fs/xattr.c b/fs/xattr.c
index 758a7ffe3a86..d9f035610f0b 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -787,7 +787,7 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
  * Extended attribute GET operations
  */
 static ssize_t
-do_getxattr(struct mnt_idmap *idmap, struct dentry *d,
+do_getxattr(const struct mnt_idmap *idmap, struct dentry *d,
 	struct kernel_xattr_ctx *ctx)
 {
 	ssize_t error;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9186d9bb2697..9809e7c3aa0d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2026,7 +2026,7 @@ struct inode_operations {
 			   umode_t create_mode);
 	int (*tmpfile) (struct mnt_idmap *, struct inode *,
 			struct file *, umode_t);
-	struct posix_acl *(*get_acl)(struct mnt_idmap *, struct dentry *,
+	struct posix_acl *(*get_acl)(const struct mnt_idmap *, struct dentry *,
 				     int);
 	int (*set_acl)(const struct mnt_idmap *, struct dentry *,
 		       struct posix_acl *, int);
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 9220fe0c965d..caf500bed993 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -107,7 +107,7 @@ static inline void cache_no_acl(struct inode *inode)
 
 int vfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		const char *acl_name, struct posix_acl *kacl);
-struct posix_acl *vfs_get_acl(struct mnt_idmap *idmap,
+struct posix_acl *vfs_get_acl(const struct mnt_idmap *idmap,
 			      struct dentry *dentry, const char *acl_name);
 int vfs_remove_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		   const char *acl_name);
@@ -148,7 +148,7 @@ static inline int vfs_set_acl(const struct mnt_idmap *idmap,
 	return -EOPNOTSUPP;
 }
 
-static inline struct posix_acl *vfs_get_acl(struct mnt_idmap *idmap,
+static inline struct posix_acl *vfs_get_acl(const struct mnt_idmap *idmap,
 					    struct dentry *dentry,
 					    const char *acl_name)
 {

-- 
2.53.0

