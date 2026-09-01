Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCC5472084;
	Tue,  1 Sep 2026 12:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264962; cv=none; b=QYdSsP6vlkwMhgBIQy7qipb9cWHPS1H3YLMzuXXGdpgz9mlxwGJtz6W/OWtjuw/f6ULjGNT/4UGM+RRF0CtsfkefJIoXxvsPXrPBeRagDlWDaKQ/VjXc4CwG9KsOWjPwLtyDlaL+XRLAAyTEGzNYanjUUyy9CaO15SZgkoCOzkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264962; c=relaxed/simple;
	bh=086SkQQ2jeSjezggo/uGFR2PxvWxOaW9c+GLTBjd1HI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FCLijE2zINU6Q8DGfMCWF9BTrHPE9jM/QIwn5xdRKnbC27tQE0PHlfIz8KyBsO6aB5dEoeQg00WzzLR9WOQk+pZmEUfWYyJBjfC882wZtablhTwCuggM9meDWPc6eDjxoXI0PDwvEOpZo+sEkh3KIuSeow3twurKe4PfT0g8SXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iDuPiu2k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iDuPiu2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0C91F00A3F;
	Tue,  1 Sep 2026 12:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264959;
	bh=YsBPJcZ1ybFdEapB0ophtPws6nIEBMtmOqfItzqjiwI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iDuPiu2ks8NGNuHDxxUREdRncnsHb3HEcxLej5c9D+Afi4fjyMmnfodQheIKo3e43
	 SFTJddD6cjocUHWhYCYfNHgjpw9BUFCLtn8gO854Oh1aQcTUpxb5t7diBeDx6uDlSo
	 vZu/H301XAdAKRWyld1bTb88onUYYV8IDAnbqLHSwmliIlSDSMzk+KAyvs4OUNm254
	 Y7V7ZX5PeP/oMEWUDuo1WVNwuC3WMCN37XPXE747c+c9cSxDL14SBocZGWlbKEgppx
	 Jk/kfx1eSiytatZQzD337O/TgZrWxz8R/eU+FW0QTXmjhkPRKerhR9tiVdE0s2mhCi
	 5yzCFNXah7VKw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:40 +0200
Subject: [PATCH 15/27] fs: port ->set_acl() to pass const mnt_idmap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-15-54ccd48e100b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=34692; i=brauner@kernel.org;
 h=from:subject:message-id; bh=086SkQQ2jeSjezggo/uGFR2PxvWxOaW9c+GLTBjd1HI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7hWfpKkZ937EOmDii+3b3DIU2nls2m8bRw/2UrjV
 djcVUFuHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOZFcnI8CLjyJ0tsabmt+cs
 99qR2haoo/3ucPnvM43HHQ0/rjEvO8fIcLpj8tKXc5ckpD2o+vf5mlzay1dF3k0X2E5M2tE/fet
 3O24A
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
 Documentation/filesystems/vfs.rst |  2 +-
 fs/9p/acl.c                       |  2 +-
 fs/9p/acl.h                       |  2 +-
 fs/bad_inode.c                    |  2 +-
 fs/btrfs/acl.c                    |  2 +-
 fs/btrfs/acl.h                    |  2 +-
 fs/ceph/acl.c                     |  2 +-
 fs/ceph/super.h                   |  2 +-
 fs/ecryptfs/inode.c               |  2 +-
 fs/ext2/acl.c                     |  2 +-
 fs/ext2/acl.h                     |  2 +-
 fs/ext4/acl.c                     |  2 +-
 fs/ext4/acl.h                     |  2 +-
 fs/f2fs/acl.c                     |  2 +-
 fs/f2fs/acl.h                     |  2 +-
 fs/fuse/acl.c                     |  2 +-
 fs/fuse/fuse_i.h                  |  2 +-
 fs/gfs2/acl.c                     |  2 +-
 fs/gfs2/acl.h                     |  2 +-
 fs/internal.h                     |  4 ++--
 fs/jffs2/acl.c                    |  2 +-
 fs/jffs2/acl.h                    |  2 +-
 fs/jfs/acl.c                      |  2 +-
 fs/jfs/jfs_acl.h                  |  2 +-
 fs/nfs/nfs3_fs.h                  |  2 +-
 fs/nfs/nfs3acl.c                  |  2 +-
 fs/ntfs/ea.c                      |  2 +-
 fs/ntfs/ea.h                      |  2 +-
 fs/ntfs3/ntfs_fs.h                |  4 ++--
 fs/ntfs3/xattr.c                  |  4 ++--
 fs/ocfs2/acl.c                    |  2 +-
 fs/ocfs2/acl.h                    |  2 +-
 fs/orangefs/acl.c                 |  2 +-
 fs/orangefs/orangefs-kernel.h     |  2 +-
 fs/overlayfs/inode.c              |  2 +-
 fs/overlayfs/overlayfs.h          |  2 +-
 fs/posix_acl.c                    | 12 ++++++------
 fs/smb/client/cifsacl.c           |  2 +-
 fs/smb/client/cifsproto.h         |  2 +-
 fs/smb/server/vfs.c               |  4 ++--
 fs/smb/server/vfs.h               |  4 ++--
 fs/xattr.c                        |  4 ++--
 fs/xfs/xfs_acl.c                  |  2 +-
 fs/xfs/xfs_acl.h                  |  2 +-
 fs/xfs/xfs_iops.c                 |  4 ++--
 fs/xfs/xfs_iops.h                 |  2 +-
 include/linux/fs.h                |  2 +-
 include/linux/posix_acl.h         | 16 ++++++++--------
 48 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index c43bad400c30..d0dd2be3885b 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -440,7 +440,7 @@ As of kernel 2.6.22, the following members are defined:
 				   unsigned open_flag, umode_t create_mode);
 		int (*tmpfile) (struct mnt_idmap *, struct inode *, struct file *, umode_t);
 		struct posix_acl * (*get_acl)(struct mnt_idmap *, struct dentry *, int);
-	        int (*set_acl)(struct mnt_idmap *, struct dentry *, struct posix_acl *, int);
+	        int (*set_acl)(const struct mnt_idmap *, struct dentry *, struct posix_acl *, int);
 		int (*fileattr_set)(const struct mnt_idmap *idmap,
 				    struct dentry *dentry, struct file_kattr *fa);
 		int (*fileattr_get)(struct dentry *dentry, struct file_kattr *fa);
diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index ae7e7cf7523a..d09a41336d0d 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -152,7 +152,7 @@ struct posix_acl *v9fs_iop_get_acl(struct mnt_idmap *idmap,
 	return v9fs_get_cached_acl(d_inode(dentry), type);
 }
 
-int v9fs_iop_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int v9fs_iop_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		     struct posix_acl *acl, int type)
 {
 	int retval;
diff --git a/fs/9p/acl.h b/fs/9p/acl.h
index 333cfcc281da..7de74704c465 100644
--- a/fs/9p/acl.h
+++ b/fs/9p/acl.h
@@ -12,7 +12,7 @@ struct posix_acl *v9fs_iop_get_inode_acl(struct inode *inode, int type,
 				   bool rcu);
 struct posix_acl *v9fs_iop_get_acl(struct mnt_idmap *idmap,
 					  struct dentry *dentry, int type);
-int v9fs_iop_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int v9fs_iop_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		     struct posix_acl *acl, int type);
 int v9fs_acl_chmod(struct inode *inode, struct p9_fid *fid);
 int v9fs_set_create_acl(struct inode *inode, struct p9_fid *fid,
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index c2cfa9395bc9..6e116810f66d 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -153,7 +153,7 @@ static int bad_inode_tmpfile(struct mnt_idmap *idmap,
 	return -EIO;
 }
 
-static int bad_inode_set_acl(struct mnt_idmap *idmap,
+static int bad_inode_set_acl(const struct mnt_idmap *idmap,
 			     struct dentry *dentry, struct posix_acl *acl,
 			     int type)
 {
diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 662cdd1cbdef..10a0d733bfd1 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -101,7 +101,7 @@ int __btrfs_set_acl(struct btrfs_trans_handle *trans, struct inode *inode,
 	return 0;
 }
 
-int btrfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int btrfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		  struct posix_acl *acl, int type)
 {
 	int ret;
diff --git a/fs/btrfs/acl.h b/fs/btrfs/acl.h
index 0458cd51ed48..6eae2db3654d 100644
--- a/fs/btrfs/acl.h
+++ b/fs/btrfs/acl.h
@@ -15,7 +15,7 @@ struct mnt_idmap;
 struct dentry;
 
 struct posix_acl *btrfs_get_acl(struct inode *inode, int type, bool rcu);
-int btrfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int btrfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		  struct posix_acl *acl, int type);
 int __btrfs_set_acl(struct btrfs_trans_handle *trans, struct inode *inode,
 		    struct posix_acl *acl, int type);
diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index 85d3dd48b167..124f07ae5b2d 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -87,7 +87,7 @@ struct posix_acl *ceph_get_acl(struct inode *inode, int type, bool rcu)
 	return acl;
 }
 
-int ceph_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int ceph_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type)
 {
 	int ret = 0;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ef9861797eb2..fd603be209e4 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1252,7 +1252,7 @@ void ceph_release_acl_sec_ctx(struct ceph_acl_sec_ctx *as_ctx);
 #ifdef CONFIG_CEPH_FS_POSIX_ACL
 
 struct posix_acl *ceph_get_acl(struct inode *, int, bool);
-int ceph_set_acl(struct mnt_idmap *idmap,
+int ceph_set_acl(const struct mnt_idmap *idmap,
 		 struct dentry *dentry, struct posix_acl *acl, int type);
 int ceph_pre_init_acls(struct inode *dir, umode_t *mode,
 		       struct ceph_acl_sec_ctx *as_ctx);
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index b9c32e8f855a..1e5146485214 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1097,7 +1097,7 @@ static struct posix_acl *ecryptfs_get_acl(struct mnt_idmap *idmap,
 			   posix_acl_xattr_name(type));
 }
 
-static int ecryptfs_set_acl(struct mnt_idmap *idmap,
+static int ecryptfs_set_acl(const struct mnt_idmap *idmap,
 			    struct dentry *dentry, struct posix_acl *acl,
 			    int type)
 {
diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
index 7e54c31589c7..b2746657fc53 100644
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -219,7 +219,7 @@ __ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
  * inode->i_mutex: down
  */
 int
-ext2_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+ext2_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	     struct posix_acl *acl, int type)
 {
 	int error;
diff --git a/fs/ext2/acl.h b/fs/ext2/acl.h
index 4a8443a2b8ec..e68bc3545608 100644
--- a/fs/ext2/acl.h
+++ b/fs/ext2/acl.h
@@ -56,7 +56,7 @@ static inline int ext2_acl_count(size_t size)
 
 /* acl.c */
 extern struct posix_acl *ext2_get_acl(struct inode *inode, int type, bool rcu);
-extern int ext2_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+extern int ext2_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 			struct posix_acl *acl, int type);
 extern int ext2_init_acl (struct inode *, struct inode *);
 
diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 3bffe862f954..59fac55a2426 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -225,7 +225,7 @@ __ext4_set_acl(handle_t *handle, struct inode *inode, int type,
 }
 
 int
-ext4_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+ext4_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	     struct posix_acl *acl, int type)
 {
 	handle_t *handle;
diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h
index 0c5a79c3b5d4..a14838c5bc42 100644
--- a/fs/ext4/acl.h
+++ b/fs/ext4/acl.h
@@ -56,7 +56,7 @@ static inline int ext4_acl_count(size_t size)
 
 /* acl.c */
 struct posix_acl *ext4_get_acl(struct inode *inode, int type, bool rcu);
-int ext4_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int ext4_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type);
 extern int ext4_init_acl(handle_t *, struct inode *, struct inode *);
 
diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index e7e0084d0a5f..22ca39e0aad6 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -289,7 +289,7 @@ static int __f2fs_set_acl(const struct mnt_idmap *idmap,
 	return error;
 }
 
-int f2fs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int f2fs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type)
 {
 	struct inode *inode = d_inode(dentry);
diff --git a/fs/f2fs/acl.h b/fs/f2fs/acl.h
index 20e87e63c089..01ec74b6daf2 100644
--- a/fs/f2fs/acl.h
+++ b/fs/f2fs/acl.h
@@ -34,7 +34,7 @@ struct f2fs_acl_header {
 #ifdef CONFIG_F2FS_FS_POSIX_ACL
 
 struct posix_acl *f2fs_get_acl(struct inode *, int, bool);
-int f2fs_set_acl(struct mnt_idmap *, struct dentry *,
+int f2fs_set_acl(const struct mnt_idmap *, struct dentry *,
 			struct posix_acl *, int);
 int f2fs_init_acl(struct inode *, struct inode *, struct folio *ifolio,
 		struct folio *dfolio);
diff --git a/fs/fuse/acl.c b/fs/fuse/acl.c
index 31fb50e16aed..c3813fff4f27 100644
--- a/fs/fuse/acl.c
+++ b/fs/fuse/acl.c
@@ -90,7 +90,7 @@ struct posix_acl *fuse_get_inode_acl(struct inode *inode, int type, bool rcu)
 	return __fuse_get_acl(fc,  inode, type, rcu);
 }
 
-int fuse_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int fuse_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type)
 {
 	struct inode *inode = d_inode(dentry);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 6ca56757869c..561ada21ea86 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1207,7 +1207,7 @@ struct posix_acl;
 struct posix_acl *fuse_get_inode_acl(struct inode *inode, int type, bool rcu);
 struct posix_acl *fuse_get_acl(struct mnt_idmap *idmap,
 			       struct dentry *dentry, int type);
-int fuse_set_acl(struct mnt_idmap *, struct dentry *dentry,
+int fuse_set_acl(const struct mnt_idmap *, struct dentry *dentry,
 		 struct posix_acl *acl, int type);
 
 /* readdir.c */
diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index a5b60778b91c..7b94efbbe8e3 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -102,7 +102,7 @@ int __gfs2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	return error;
 }
 
-int gfs2_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int gfs2_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type)
 {
 	struct inode *inode = d_inode(dentry);
diff --git a/fs/gfs2/acl.h b/fs/gfs2/acl.h
index 82f5b09c04e6..d19d41755936 100644
--- a/fs/gfs2/acl.h
+++ b/fs/gfs2/acl.h
@@ -13,7 +13,7 @@
 
 struct posix_acl *gfs2_get_acl(struct inode *inode, int type, bool rcu);
 int __gfs2_set_acl(struct inode *inode, struct posix_acl *acl, int type);
-int gfs2_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int gfs2_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type);
 
 #endif /* __ACL_DOT_H__ */
diff --git a/fs/internal.h b/fs/internal.h
index a502b1fbacd2..8ba0a1613d20 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -302,12 +302,12 @@ int import_xattr_name(struct xattr_name *kname, const char __user *name);
 int may_write_xattr(const struct mnt_idmap *idmap, struct inode *inode);
 
 #ifdef CONFIG_FS_POSIX_ACL
-int do_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int do_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	       const char *acl_name, const void *kvalue, size_t size);
 ssize_t do_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 		   const char *acl_name, void *kvalue, size_t size);
 #else
-static inline int do_set_acl(struct mnt_idmap *idmap,
+static inline int do_set_acl(const struct mnt_idmap *idmap,
 			     struct dentry *dentry, const char *acl_name,
 			     const void *kvalue, size_t size)
 {
diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index f0f8a4f57add..7548f44bf327 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -228,7 +228,7 @@ static int __jffs2_set_acl(struct inode *inode, int xprefix, struct posix_acl *a
 	return rc;
 }
 
-int jffs2_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int jffs2_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		  struct posix_acl *acl, int type)
 {
 	int rc, xprefix;
diff --git a/fs/jffs2/acl.h b/fs/jffs2/acl.h
index e976b8cb82cf..bc5df521633f 100644
--- a/fs/jffs2/acl.h
+++ b/fs/jffs2/acl.h
@@ -28,7 +28,7 @@ struct jffs2_acl_header {
 #ifdef CONFIG_JFFS2_FS_POSIX_ACL
 
 struct posix_acl *jffs2_get_acl(struct inode *inode, int type, bool rcu);
-int jffs2_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int jffs2_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		  struct posix_acl *acl, int type);
 extern int jffs2_init_acl_pre(struct inode *, struct inode *, umode_t *);
 extern int jffs2_init_acl_post(struct inode *);
diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
index 16b71a23ff1e..6e0a7feb6c80 100644
--- a/fs/jfs/acl.c
+++ b/fs/jfs/acl.c
@@ -89,7 +89,7 @@ static int __jfs_set_acl(tid_t tid, struct inode *inode, int type,
 	return rc;
 }
 
-int jfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int jfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		struct posix_acl *acl, int type)
 {
 	int rc;
diff --git a/fs/jfs/jfs_acl.h b/fs/jfs/jfs_acl.h
index f892e54d0fcd..bda26b333519 100644
--- a/fs/jfs/jfs_acl.h
+++ b/fs/jfs/jfs_acl.h
@@ -8,7 +8,7 @@
 #ifdef CONFIG_JFS_POSIX_ACL
 
 struct posix_acl *jfs_get_acl(struct inode *inode, int type, bool rcu);
-int jfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int jfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		struct posix_acl *acl, int type);
 int jfs_init_acl(tid_t, struct inode *, struct inode *);
 
diff --git a/fs/nfs/nfs3_fs.h b/fs/nfs/nfs3_fs.h
index b333ea119ef5..ffcabadb3546 100644
--- a/fs/nfs/nfs3_fs.h
+++ b/fs/nfs/nfs3_fs.h
@@ -12,7 +12,7 @@
  */
 #ifdef CONFIG_NFS_V3_ACL
 extern struct posix_acl *nfs3_get_acl(struct inode *inode, int type, bool rcu);
-extern int nfs3_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+extern int nfs3_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 			struct posix_acl *acl, int type);
 extern int nfs3_proc_setacls(struct inode *inode, struct posix_acl *acl,
 		struct posix_acl *dfacl);
diff --git a/fs/nfs/nfs3acl.c b/fs/nfs/nfs3acl.c
index a126eb31f62f..2549a1985b9a 100644
--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -254,7 +254,7 @@ int nfs3_proc_setacls(struct inode *inode, struct posix_acl *acl,
 
 }
 
-int nfs3_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int nfs3_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type)
 {
 	struct posix_acl *orig = acl, *dfacl = NULL, *alloc;
diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index 7fd323912510..063cc15f1626 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -1080,7 +1080,7 @@ static noinline int ntfs_set_acl_ex(const struct mnt_idmap *idmap,
 	return err;
 }
 
-int ntfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int ntfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type)
 {
 	return ntfs_set_acl_ex(idmap, d_inode(dentry), acl, type, false);
diff --git a/fs/ntfs/ea.h b/fs/ntfs/ea.h
index 9d17abc2e491..6d98e7487a2c 100644
--- a/fs/ntfs/ea.h
+++ b/fs/ntfs/ea.h
@@ -19,7 +19,7 @@ ssize_t ntfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 #ifdef CONFIG_NTFS_FS_POSIX_ACL
 struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 			       int type);
-int ntfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int ntfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type);
 int ntfs_init_acl(const struct mnt_idmap *idmap, struct inode *inode,
 		  struct inode *dir);
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index e494bed87679..0a5e81d420f0 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -965,7 +965,7 @@ unsigned long ntfs_names_hash(const u16 *name, size_t len, const u16 *upcase,
 #ifdef CONFIG_NTFS3_FS_POSIX_ACL
 struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 			       int type);
-int ntfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int ntfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type);
 int ntfs_init_acl(const struct mnt_idmap *idmap, struct inode *inode,
 		  struct inode *dir);
@@ -974,7 +974,7 @@ int ntfs_init_acl(const struct mnt_idmap *idmap, struct inode *inode,
 #define ntfs_set_acl NULL
 #endif
 
-int ntfs_acl_chmod(struct mnt_idmap *idmap, struct dentry *dentry);
+int ntfs_acl_chmod(const struct mnt_idmap *idmap, struct dentry *dentry);
 ssize_t ntfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 extern const struct xattr_handler *const ntfs_xattr_handlers[];
 
diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 5644167de863..2d17b80999ca 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -677,7 +677,7 @@ static noinline int ntfs_set_acl_ex(const struct mnt_idmap *idmap,
 /*
  * ntfs_set_acl - inode_operations::set_acl
  */
-int ntfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int ntfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type)
 {
 	return ntfs_set_acl_ex(idmap, d_inode(dentry), acl, type, false);
@@ -722,7 +722,7 @@ int ntfs_init_acl(const struct mnt_idmap *idmap, struct inode *inode,
 /*
  * ntfs_acl_chmod - Helper for ntfs_setattr().
  */
-int ntfs_acl_chmod(struct mnt_idmap *idmap, struct dentry *dentry)
+int ntfs_acl_chmod(const struct mnt_idmap *idmap, struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
 	struct super_block *sb = inode->i_sb;
diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 090ec60fb576..801a2f56ad08 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -260,7 +260,7 @@ static int ocfs2_set_acl(handle_t *handle,
 	return ret;
 }
 
-int ocfs2_iop_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int ocfs2_iop_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		      struct posix_acl *acl, int type)
 {
 	struct buffer_head *bh = NULL;
diff --git a/fs/ocfs2/acl.h b/fs/ocfs2/acl.h
index a91f9ce278d6..1ed05899cce1 100644
--- a/fs/ocfs2/acl.h
+++ b/fs/ocfs2/acl.h
@@ -17,7 +17,7 @@ struct ocfs2_acl_entry {
 };
 
 struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type, bool rcu);
-int ocfs2_iop_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int ocfs2_iop_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		      struct posix_acl *acl, int type);
 extern int ocfs2_acl_chmod(struct inode *, struct buffer_head *);
 struct ocfs2_acl_state {
diff --git a/fs/orangefs/acl.c b/fs/orangefs/acl.c
index a01ef0c1b1bf..f31196e4bfaa 100644
--- a/fs/orangefs/acl.c
+++ b/fs/orangefs/acl.c
@@ -112,7 +112,7 @@ int __orangefs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	return error;
 }
 
-int orangefs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int orangefs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		     struct posix_acl *acl, int type)
 {
 	int error;
diff --git a/fs/orangefs/orangefs-kernel.h b/fs/orangefs/orangefs-kernel.h
index c582ceffb26e..a5c9e7be4005 100644
--- a/fs/orangefs/orangefs-kernel.h
+++ b/fs/orangefs/orangefs-kernel.h
@@ -98,7 +98,7 @@ enum orangefs_vfs_op_states {
 extern const struct xattr_handler * const orangefs_xattr_handlers[];
 
 extern struct posix_acl *orangefs_get_acl(struct inode *inode, int type, bool rcu);
-extern int orangefs_set_acl(struct mnt_idmap *idmap,
+extern int orangefs_set_acl(const struct mnt_idmap *idmap,
 			    struct dentry *dentry, struct posix_acl *acl,
 			    int type);
 int __orangefs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 5f4e8b6d9722..18e4cbe154cf 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -536,7 +536,7 @@ static int ovl_set_or_remove_acl(struct dentry *dentry, struct inode *inode,
 	return err;
 }
 
-int ovl_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int ovl_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		struct posix_acl *acl, int type)
 {
 	int err;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 46a5cf5dae4c..8b335993bf56 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -819,7 +819,7 @@ static inline struct posix_acl *ovl_get_acl(struct mnt_idmap *idmap,
 {
 	return do_ovl_get_acl(idmap, d_inode(dentry), type, false, false);
 }
-int ovl_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int ovl_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		struct posix_acl *acl, int type);
 struct posix_acl *ovl_get_acl_path(const struct path *path,
 				   const char *acl_name, bool noperm);
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index b279804ebf56..cec7fb557278 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -608,7 +608,7 @@ EXPORT_SYMBOL(__posix_acl_chmod);
  * performed on the raw inode simply pass @nop_mnt_idmap.
  */
 int
- posix_acl_chmod(struct mnt_idmap *idmap, struct dentry *dentry,
+ posix_acl_chmod(const struct mnt_idmap *idmap, struct dentry *dentry,
 		    umode_t mode)
 {
 	struct inode *inode = d_inode(dentry);
@@ -937,7 +937,7 @@ static ssize_t vfs_posix_acl_to_xattr(const struct mnt_idmap *idmap,
 }
 
 int
-set_posix_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+set_posix_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	      int type, struct posix_acl *acl)
 {
 	struct inode *inode = d_inode(dentry);
@@ -1018,7 +1018,7 @@ const struct xattr_handler nop_posix_acl_default = {
 };
 EXPORT_SYMBOL_GPL(nop_posix_acl_default);
 
-int simple_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int simple_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		   struct posix_acl *acl, int type)
 {
 	int error;
@@ -1091,7 +1091,7 @@ static int vfs_set_acl_idmapped_mnt(const struct mnt_idmap *idmap,
  *
  * Return: On success 0, on error negative errno.
  */
-int vfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int vfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		const char *acl_name, struct posix_acl *kacl)
 {
 	int acl_type;
@@ -1212,7 +1212,7 @@ EXPORT_SYMBOL_GPL(vfs_get_acl);
  *
  * Return: On success 0, on error negative errno.
  */
-int vfs_remove_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int vfs_remove_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		   const char *acl_name)
 {
 	int acl_type;
@@ -1265,7 +1265,7 @@ int vfs_remove_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 }
 EXPORT_SYMBOL_GPL(vfs_remove_acl);
 
-int do_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int do_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	       const char *acl_name, const void *kvalue, size_t size)
 {
 	int error;
diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 12005f46307d..0a05b6b0be5f 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1931,7 +1931,7 @@ struct posix_acl *cifs_get_acl(struct mnt_idmap *idmap,
 #endif
 }
 
-int cifs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int cifs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type)
 {
 #if defined(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) && defined(CONFIG_CIFS_POSIX)
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 00168839c123..565697c233a9 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -214,7 +214,7 @@ struct smb_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
 				     u32 *pacllen, u32 info);
 struct posix_acl *cifs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 			       int type);
-int cifs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int cifs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type);
 int set_cifs_acl(struct smb_ntsd *pnntsd, __u32 acllen, struct inode *inode,
 		 const char *path, int aclflag);
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 3c4d18a4e8d5..75edff8dde31 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1471,7 +1471,7 @@ struct dentry *ksmbd_vfs_kern_path_create(struct ksmbd_work *work,
 	return dent;
 }
 
-int ksmbd_vfs_remove_acl_xattrs(struct mnt_idmap *idmap,
+int ksmbd_vfs_remove_acl_xattrs(const struct mnt_idmap *idmap,
 				const struct path *path)
 {
 	char *name, *xattr_list = NULL;
@@ -2200,7 +2200,7 @@ void ksmbd_vfs_posix_lock_unblock(struct file_lock *flock)
 	locks_delete_block(flock);
 }
 
-int ksmbd_vfs_set_init_posix_acl(struct mnt_idmap *idmap,
+int ksmbd_vfs_set_init_posix_acl(const struct mnt_idmap *idmap,
 				 const struct path *path)
 {
 	struct posix_acl_state acl_state;
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 5e34fc61b48b..67cc48e583c8 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -152,7 +152,7 @@ int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 				struct ksmbd_kstat *ksmbd_kstat);
 void ksmbd_vfs_posix_lock_wait(struct file_lock *flock);
 void ksmbd_vfs_posix_lock_unblock(struct file_lock *flock);
-int ksmbd_vfs_remove_acl_xattrs(struct mnt_idmap *idmap,
+int ksmbd_vfs_remove_acl_xattrs(const struct mnt_idmap *idmap,
 				const struct path *path);
 int ksmbd_vfs_remove_sd_xattrs(const struct mnt_idmap *idmap, const struct path *path);
 int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
@@ -171,7 +171,7 @@ int ksmbd_vfs_set_dos_attrib_xattr(const struct mnt_idmap *idmap,
 int ksmbd_vfs_get_dos_attrib_xattr(const struct mnt_idmap *idmap,
 				   struct dentry *dentry,
 				   struct xattr_dos_attrib *da);
-int ksmbd_vfs_set_init_posix_acl(struct mnt_idmap *idmap,
+int ksmbd_vfs_set_init_posix_acl(const struct mnt_idmap *idmap,
 				 const struct path *path);
 int ksmbd_vfs_inherit_posix_acl(const struct mnt_idmap *idmap,
 				const struct path *path,
diff --git a/fs/xattr.c b/fs/xattr.c
index acdaafb0c7c1..758a7ffe3a86 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -652,7 +652,7 @@ int setxattr_copy(const char __user *name, struct kernel_xattr_ctx *ctx)
 	return error;
 }
 
-static int do_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
+static int do_setxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 		struct kernel_xattr_ctx *ctx)
 {
 	if (is_posix_acl_xattr(ctx->kname->name))
@@ -1029,7 +1029,7 @@ SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
  * Extended attribute REMOVE operations
  */
 static long
-removexattr(struct mnt_idmap *idmap, struct dentry *d, const char *name)
+removexattr(const struct mnt_idmap *idmap, struct dentry *d, const char *name)
 {
 	if (is_posix_acl_xattr(name))
 		return vfs_remove_acl(idmap, d, name);
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index fdfca6fc75b6..20d87b52c4fc 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -243,7 +243,7 @@ xfs_acl_set_mode(
 }
 
 int
-xfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+xfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	    struct posix_acl *acl, int type)
 {
 	umode_t mode;
diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index bf7f960997d3..183526bec32c 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -11,7 +11,7 @@ struct posix_acl;
 
 #ifdef CONFIG_XFS_POSIX_ACL
 extern struct posix_acl *xfs_get_acl(struct inode *inode, int type, bool rcu);
-extern int xfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+extern int xfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		       struct posix_acl *acl, int type);
 extern int __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 void xfs_forget_acl(struct inode *inode, const char *name);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b652f129c85e..25d4d42fbc7f 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -777,7 +777,7 @@ xfs_vn_change_ok(
  */
 static int
 xfs_setattr_nonsize(
-	struct mnt_idmap	*idmap,
+	const struct mnt_idmap	*idmap,
 	struct dentry		*dentry,
 	struct xfs_inode	*ip,
 	struct iattr		*iattr)
@@ -903,7 +903,7 @@ xfs_setattr_nonsize(
  */
 int
 xfs_vn_setattr_size(
-	struct mnt_idmap	*idmap,
+	const struct mnt_idmap	*idmap,
 	struct dentry		*dentry,
 	struct iattr		*iattr)
 {
diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index 0896f6b8b3b8..328305bba19d 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -10,7 +10,7 @@ struct xfs_inode;
 
 extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 
-int xfs_vn_setattr_size(struct mnt_idmap *idmap,
+int xfs_vn_setattr_size(const struct mnt_idmap *idmap,
 		struct dentry *dentry, struct iattr *vap);
 
 int xfs_inode_init_security(struct inode *inode, struct inode *dir,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 764ef2d97a5d..9186d9bb2697 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2028,7 +2028,7 @@ struct inode_operations {
 			struct file *, umode_t);
 	struct posix_acl *(*get_acl)(struct mnt_idmap *, struct dentry *,
 				     int);
-	int (*set_acl)(struct mnt_idmap *, struct dentry *,
+	int (*set_acl)(const struct mnt_idmap *, struct dentry *,
 		       struct posix_acl *, int);
 	int (*fileattr_set)(const struct mnt_idmap *idmap,
 			    struct dentry *dentry, struct file_kattr *fa);
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 7c6cfcae0a9d..9220fe0c965d 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -74,20 +74,20 @@ extern int __posix_acl_create(struct posix_acl **, gfp_t, umode_t *);
 extern int __posix_acl_chmod(struct posix_acl **, gfp_t, umode_t);
 
 extern struct posix_acl *get_posix_acl(struct inode *, int);
-int set_posix_acl(struct mnt_idmap *, struct dentry *, int,
+int set_posix_acl(const struct mnt_idmap *, struct dentry *, int,
 		  struct posix_acl *);
 
 struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type);
 struct posix_acl *posix_acl_clone(const struct posix_acl *acl, gfp_t flags);
 
 #ifdef CONFIG_FS_POSIX_ACL
-int posix_acl_chmod(struct mnt_idmap *, struct dentry *, umode_t);
+int posix_acl_chmod(const struct mnt_idmap *, struct dentry *, umode_t);
 extern int posix_acl_create(struct inode *, umode_t *, struct posix_acl **,
 		struct posix_acl **);
 int posix_acl_update_mode(const struct mnt_idmap *, struct inode *, umode_t *,
 			  struct posix_acl **);
 
-int simple_set_acl(struct mnt_idmap *, struct dentry *,
+int simple_set_acl(const struct mnt_idmap *, struct dentry *,
 		   struct posix_acl *, int);
 extern int simple_acl_create(struct inode *, struct inode *);
 
@@ -105,16 +105,16 @@ static inline void cache_no_acl(struct inode *inode)
 	inode->i_default_acl = NULL;
 }
 
-int vfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int vfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		const char *acl_name, struct posix_acl *kacl);
 struct posix_acl *vfs_get_acl(struct mnt_idmap *idmap,
 			      struct dentry *dentry, const char *acl_name);
-int vfs_remove_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+int vfs_remove_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		   const char *acl_name);
 int posix_acl_listxattr(struct inode *inode, char **buffer,
 			ssize_t *remaining_size);
 #else
-static inline int posix_acl_chmod(struct mnt_idmap *idmap,
+static inline int posix_acl_chmod(const struct mnt_idmap *idmap,
 				  struct dentry *dentry, umode_t mode)
 {
 	return 0;
@@ -141,7 +141,7 @@ static inline void forget_all_cached_acls(struct inode *inode)
 {
 }
 
-static inline int vfs_set_acl(struct mnt_idmap *idmap,
+static inline int vfs_set_acl(const struct mnt_idmap *idmap,
 			      struct dentry *dentry, const char *name,
 			      struct posix_acl *acl)
 {
@@ -155,7 +155,7 @@ static inline struct posix_acl *vfs_get_acl(struct mnt_idmap *idmap,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
-static inline int vfs_remove_acl(struct mnt_idmap *idmap,
+static inline int vfs_remove_acl(const struct mnt_idmap *idmap,
 				 struct dentry *dentry, const char *acl_name)
 {
 	return -EOPNOTSUPP;

-- 
2.53.0

