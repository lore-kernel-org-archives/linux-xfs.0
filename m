Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C67361959;
	Tue,  1 Sep 2026 12:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264902; cv=none; b=NuX+77BkY/Js1H8m0ysP1aOy7hN12rDxsvF+D2u+B59AuBV3AsJ4fkHcNrRiq7mdhAf/vGvaijpWtttyrzRMJkloQyt1cJ3tnfumcpDQLl3DPBVxOf1ydxda41ps2XHhyDl01lvQujbUrmuLxUBYkAV9B6Wl2Q2p64pq8NXvA3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264902; c=relaxed/simple;
	bh=zAbcPx16AdV8NekL0Sa9l5NROp0/aast7WuyLqXNS+M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lsCsfAnPeucKSObhIzrMvPAcKpS2zQWgCvG1oTEIWkjUug4CuBPmpZNZiFVmRvU9nLjCK7qVHFF58ZoEyPaA1moZij8308rMHcYJlwsOWpWvVj3whpnunuBmHb6XDkU02NcD3Y0u19/dpuGQSBqPvaWHG9gjibol2OWExSgx/k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iQpG1+Iv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iQpG1+Iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255501F0155B;
	Tue,  1 Sep 2026 12:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264900;
	bh=sPMH4hcWPB1KEQ5MOIhGUDnKQkscn1Hobei9PAFmnhA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iQpG1+IvIxrjk8o59F3PzephX5e0tkGtEVDfmt4lxeIWPtWlENGssWf1WprVGzXjN
	 w9c5alLhbLL7Z4MDLBausg4xCcC8Jqqs6QhiSdaYQ++Le+5sQWzFgnnTKo1o7ZJ4HM
	 xoAHrfQ4B0h36a7iJnYrGyqAN7V2n80YySkOpwEYcJpeBcq8cMqYEeCi6Grrx7DOTz
	 PTF8imfzhKP/IqQmBiEgzuiiNzDJT6f3/1n1r9lwpJ4/MaY4TbXkk4xiyssSPChrqE
	 uMeH5yL1hdzclIwtUdZV5zKmx4joydYufcPPARpjlPkW0q2YRnWPqBxVTSSw4HsmtZ
	 04PtOqEjd5ubg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:28 +0200
Subject: [PATCH 03/27] fs: port vfs{g,u}id helpers to const mnt_idmap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-3-54ccd48e100b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=17874; i=brauner@kernel.org;
 h=from:subject:message-id; bh=zAbcPx16AdV8NekL0Sa9l5NROp0/aast7WuyLqXNS+M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7jGbqVMVffDhLV3fecdXBYdu2yZo+SEpx9ucq1e1
 K0sdrSrt6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi5ZEM/8NuWkbrP+VaO/PY
 qcacs99cJbfcYpPfWmbHtW36l+kVWUIM/6M4zFa5VF9ivvNcUuTc85ucr0680rGzvRz267TvyQf
 sDNwA
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
 fs/ceph/inode.c                   |  2 +-
 fs/ceph/super.h                   |  2 +-
 fs/fuse/dir.c                     | 12 ++++++------
 fs/internal.h                     |  2 +-
 fs/mnt_idmapping.c                | 15 ++++++++-------
 fs/overlayfs/inode.c              |  4 ++--
 fs/overlayfs/overlayfs.h          |  2 +-
 fs/posix_acl.c                    |  2 +-
 fs/smb/server/smbacl.c            | 14 +++++++-------
 fs/smb/server/smbacl.h            |  8 ++++----
 fs/smb/server/vfs.c               |  4 ++--
 fs/smb/server/vfs.h               |  2 +-
 include/linux/mnt_idmapping.h     | 12 ++++++------
 security/integrity/evm/evm_main.c |  4 ++--
 14 files changed, 43 insertions(+), 42 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index d52e2b389e0b..3921b601ad59 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2568,7 +2568,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
 	return ret;
 }
 
-int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
+int __ceph_setattr(const struct mnt_idmap *idmap, struct inode *inode,
 		   struct iattr *attr, struct ceph_iattr *cia)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 72d4e30304dc..e9a9d5737c80 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1173,7 +1173,7 @@ struct ceph_iattr {
 	struct ceph_fscrypt_auth	*fscrypt_auth;
 };
 
-extern int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
+extern int __ceph_setattr(const struct mnt_idmap *idmap, struct inode *inode,
 			  struct iattr *attr, struct ceph_iattr *cia);
 extern int ceph_setattr(struct mnt_idmap *idmap,
 			struct dentry *dentry, struct iattr *attr);
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index e49b4e874b15..0d297f74c663 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -751,7 +751,7 @@ static u32 fuse_ext_size(size_t size)
 /*
  * This adds just a single supplementary group that matches the parent's group.
  */
-static int get_create_supp_group(struct mnt_idmap *idmap,
+static int get_create_supp_group(const struct mnt_idmap *idmap,
 				 struct inode *dir,
 				 struct fuse_in_arg *ext)
 {
@@ -782,7 +782,7 @@ static int get_create_supp_group(struct mnt_idmap *idmap,
 	return 0;
 }
 
-static int get_create_ext(struct mnt_idmap *idmap,
+static int get_create_ext(const struct mnt_idmap *idmap,
 			  struct fuse_args *args,
 			  struct inode *dir, struct dentry *dentry,
 			  umode_t mode)
@@ -1375,7 +1375,7 @@ static int fuse_link(struct dentry *entry, struct inode *newdir,
 	return err;
 }
 
-static void fuse_fillattr(struct mnt_idmap *idmap, struct inode *inode,
+static void fuse_fillattr(const struct mnt_idmap *idmap, struct inode *inode,
 			  struct fuse_attr *attr, struct kstat *stat)
 {
 	unsigned int blkbits;
@@ -1429,7 +1429,7 @@ static void fuse_statx_to_attr(struct fuse_statx *sx, struct fuse_attr *attr)
 	attr->blksize = sx->blksize;
 }
 
-static int fuse_do_statx(struct mnt_idmap *idmap, struct inode *inode,
+static int fuse_do_statx(const struct mnt_idmap *idmap, struct inode *inode,
 			 struct file *file, struct kstat *stat)
 {
 	int err;
@@ -1490,7 +1490,7 @@ static int fuse_do_statx(struct mnt_idmap *idmap, struct inode *inode,
 	return 0;
 }
 
-static int fuse_do_getattr(struct mnt_idmap *idmap, struct inode *inode,
+static int fuse_do_getattr(const struct mnt_idmap *idmap, struct inode *inode,
 			   struct kstat *stat, struct file *file)
 {
 	int err;
@@ -2000,7 +2000,7 @@ static bool update_mtime(unsigned ivalid, bool trust_local_mtime)
 	return true;
 }
 
-static void iattr_to_fattr(struct mnt_idmap *idmap, struct fuse_conn *fc,
+static void iattr_to_fattr(const struct mnt_idmap *idmap, struct fuse_conn *fc,
 			   struct iattr *iattr, struct fuse_setattr_in *arg,
 			   bool trust_local_cmtime)
 {
diff --git a/fs/internal.h b/fs/internal.h
index 581aaa2d6510..87ac96c3e29e 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -354,7 +354,7 @@ static inline bool path_mounted(const struct path *path)
 }
 void file_f_owner_release(struct file *file);
 bool file_seek_cur_needs_f_lock(struct file *file);
-int statmount_mnt_idmap(struct mnt_idmap *idmap, struct seq_file *seq, bool uid_map);
+int statmount_mnt_idmap(const struct mnt_idmap *idmap, struct seq_file *seq, bool uid_map);
 struct dentry *find_next_child(struct dentry *parent, struct dentry *prev);
 int anon_inode_getattr(struct mnt_idmap *idmap, const struct path *path,
 		       struct kstat *stat, u32 request_mask,
diff --git a/fs/mnt_idmapping.c b/fs/mnt_idmapping.c
index cc6c5f1cfba8..4d5fbf185608 100644
--- a/fs/mnt_idmapping.c
+++ b/fs/mnt_idmapping.c
@@ -77,7 +77,7 @@ static inline bool initial_idmapping(const struct user_namespace *ns)
  * returned.
  */
 
-vfsuid_t make_vfsuid(struct mnt_idmap *idmap,
+vfsuid_t make_vfsuid(const struct mnt_idmap *idmap,
 		     struct user_namespace *fs_userns,
 		     kuid_t kuid)
 {
@@ -117,7 +117,7 @@ EXPORT_SYMBOL_GPL(make_vfsuid);
  * If @kgid has no mapping in either @idmap or @fs_userns INVALID_GID is
  * returned.
  */
-vfsgid_t make_vfsgid(struct mnt_idmap *idmap,
+vfsgid_t make_vfsgid(const struct mnt_idmap *idmap,
 		     struct user_namespace *fs_userns, kgid_t kgid)
 {
 	gid_t gid;
@@ -147,7 +147,7 @@ EXPORT_SYMBOL_GPL(make_vfsgid);
  *
  * Return: @vfsuid mapped into the filesystem idmapping
  */
-kuid_t from_vfsuid(struct mnt_idmap *idmap,
+kuid_t from_vfsuid(const struct mnt_idmap *idmap,
 		   struct user_namespace *fs_userns, vfsuid_t vfsuid)
 {
 	uid_t uid;
@@ -176,7 +176,7 @@ EXPORT_SYMBOL_GPL(from_vfsuid);
  *
  * Return: @vfsgid mapped into the filesystem idmapping
  */
-kgid_t from_vfsgid(struct mnt_idmap *idmap,
+kgid_t from_vfsgid(const struct mnt_idmap *idmap,
 		   struct user_namespace *fs_userns, vfsgid_t vfsgid)
 {
 	gid_t gid;
@@ -340,9 +340,10 @@ void mnt_idmap_put(const struct mnt_idmap *idmap)
 }
 EXPORT_SYMBOL_GPL(mnt_idmap_put);
 
-int statmount_mnt_idmap(struct mnt_idmap *idmap, struct seq_file *seq, bool uid_map)
+int statmount_mnt_idmap(const struct mnt_idmap *idmap, struct seq_file *seq, bool uid_map)
 {
-	struct uid_gid_map *map, *map_up;
+	const struct uid_gid_map *map;
+	struct uid_gid_map *map_up;
 	u32 idx, nr_mappings;
 
 	if (!is_valid_mnt_idmap(idmap))
@@ -362,7 +363,7 @@ int statmount_mnt_idmap(struct mnt_idmap *idmap, struct seq_file *seq, bool uid_
 
 	for (idx = 0, nr_mappings = 0; idx < map->nr_extents; idx++) {
 		uid_t lower;
-		struct uid_gid_extent *extent;
+		const struct uid_gid_extent *extent;
 
 		if (map->nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
 			extent = &map->extent[idx];
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 401cb8c75520..0364e7d08ad7 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -355,7 +355,7 @@ static const char *ovl_get_link(struct dentry *dentry,
  * alter the POSIX ACLs for the underlying filesystem.
  */
 static void ovl_idmap_posix_acl(const struct inode *realinode,
-				struct mnt_idmap *idmap,
+				const struct mnt_idmap *idmap,
 				struct posix_acl *acl)
 {
 	struct user_namespace *fs_userns = i_user_ns(realinode);
@@ -447,7 +447,7 @@ struct posix_acl *ovl_get_acl_path(const struct path *path,
  *
  * This is obviously only relevant when idmapped layers are used.
  */
-struct posix_acl *do_ovl_get_acl(struct mnt_idmap *idmap,
+struct posix_acl *do_ovl_get_acl(const struct mnt_idmap *idmap,
 				 struct inode *inode, int type,
 				 bool rcu, bool noperm)
 {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e0d8c6152e9f..6508f30aaaca 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -806,7 +806,7 @@ int ovl_permission(struct mnt_idmap *idmap, struct inode *inode,
 		   int mask);
 
 #ifdef CONFIG_FS_POSIX_ACL
-struct posix_acl *do_ovl_get_acl(struct mnt_idmap *idmap,
+struct posix_acl *do_ovl_get_acl(const struct mnt_idmap *idmap,
 				 struct inode *inode, int type,
 				 bool rcu, bool noperm);
 static inline struct posix_acl *ovl_get_inode_acl(struct inode *inode, int type,
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 18b302f94174..f9c55a59c6c6 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -1057,7 +1057,7 @@ int simple_acl_create(struct inode *dir, struct inode *inode)
 	return 0;
 }
 
-static int vfs_set_acl_idmapped_mnt(struct mnt_idmap *idmap,
+static int vfs_set_acl_idmapped_mnt(const struct mnt_idmap *idmap,
 				    struct user_namespace *fs_userns,
 				    struct posix_acl *acl)
 {
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 8ad2e5a5cca8..915dbfab62ea 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -257,7 +257,7 @@ void id_to_sid(unsigned int cid, uint sidtype, struct smb_sid *ssid)
 	ssid->num_subauth++;
 }
 
-static int sid_to_id(struct mnt_idmap *idmap,
+static int sid_to_id(const struct mnt_idmap *idmap,
 		     struct smb_sid *psid, uint sidtype,
 		     struct smb_fattr *fattr)
 {
@@ -383,7 +383,7 @@ void free_acl_state(struct posix_acl_state *state)
 	kfree(state->groups);
 }
 
-static void parse_dacl(struct mnt_idmap *idmap,
+static void parse_dacl(const struct mnt_idmap *idmap,
 		       struct smb_acl *pdacl, char *end_of_acl,
 		       struct smb_sid *pownersid, struct smb_sid *pgrpsid,
 		       struct smb_fattr *fattr)
@@ -608,7 +608,7 @@ static void parse_dacl(struct mnt_idmap *idmap,
 	free_acl_state(&default_acl_state);
 }
 
-static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
+static void set_posix_acl_entries_dacl(const struct mnt_idmap *idmap,
 				       struct smb_ace *pndace,
 				       struct smb_fattr *fattr, u16 *num_aces,
 				       u16 *size, u16 existing_nt_aces,
@@ -739,7 +739,7 @@ static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
 	}
 }
 
-static void set_ntacl_dacl(struct mnt_idmap *idmap,
+static void set_ntacl_dacl(const struct mnt_idmap *idmap,
 			   struct smb_acl *pndacl,
 			   struct smb_acl *nt_dacl,
 			   unsigned int aces_size,
@@ -798,7 +798,7 @@ static void set_ntacl_dacl(struct mnt_idmap *idmap,
 	pndacl->size = cpu_to_le16(le16_to_cpu(pndacl->size) + size);
 }
 
-static void set_mode_dacl(struct mnt_idmap *idmap,
+static void set_mode_dacl(const struct mnt_idmap *idmap,
 			  struct smb_acl *pndacl, struct smb_fattr *fattr)
 {
 	struct smb_ace *pace, *pndace;
@@ -884,7 +884,7 @@ static int parse_sid(struct smb_sid *psid, char *end_of_acl)
 }
 
 /* Convert CIFS ACL to POSIX form */
-int parse_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
+int parse_sec_desc(const struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 		   int acl_len, struct smb_fattr *fattr)
 {
 	int rc = 0;
@@ -1017,7 +1017,7 @@ size_t smb_acl_sec_desc_scratch_len(struct smb_fattr *fattr,
 }
 
 /* Convert permission bits from mode to equivalent CIFS ACL */
-int build_sec_desc(struct mnt_idmap *idmap,
+int build_sec_desc(const struct mnt_idmap *idmap,
 		   struct smb_ntsd *pntsd, struct smb_ntsd *ppntsd,
 		   int ppntsd_size, int addition_info, __u32 *secdesclen,
 		   struct smb_fattr *fattr)
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index 01810c16cc04..28d215807faa 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -81,9 +81,9 @@ struct posix_acl_state {
 	struct posix_ace_state_array *groups;
 };
 
-int parse_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
+int parse_sec_desc(const struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 		   int acl_len, struct smb_fattr *fattr);
-int build_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
+int build_sec_desc(const struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 		   struct smb_ntsd *ppntsd, int ppntsd_size, int addition_info,
 		   __u32 *secdesclen, struct smb_fattr *fattr);
 int init_acl_state(struct posix_acl_state *state, u16 cnt);
@@ -105,7 +105,7 @@ void ksmbd_init_domain(u32 *sub_auth);
 size_t smb_acl_sec_desc_scratch_len(struct smb_fattr *fattr,
 		struct smb_ntsd *ppntsd, int ppntsd_size, int addition_info);
 
-static inline uid_t posix_acl_uid_translate(struct mnt_idmap *idmap,
+static inline uid_t posix_acl_uid_translate(const struct mnt_idmap *idmap,
 					    struct posix_acl_entry *pace)
 {
 	vfsuid_t vfsuid;
@@ -117,7 +117,7 @@ static inline uid_t posix_acl_uid_translate(struct mnt_idmap *idmap,
 	return from_kuid(&init_user_ns, vfsuid_into_kuid(vfsuid));
 }
 
-static inline gid_t posix_acl_gid_translate(struct mnt_idmap *idmap,
+static inline gid_t posix_acl_gid_translate(const struct mnt_idmap *idmap,
 					    struct posix_acl_entry *pace)
 {
 	vfsgid_t vfsgid;
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index d2b524f79cbe..cb52dce113b9 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1540,7 +1540,7 @@ int ksmbd_vfs_remove_sd_xattrs(struct mnt_idmap *idmap, const struct path *path)
 	return err;
 }
 
-static struct xattr_smb_acl *ksmbd_vfs_make_xattr_posix_acl(struct mnt_idmap *idmap,
+static struct xattr_smb_acl *ksmbd_vfs_make_xattr_posix_acl(const struct mnt_idmap *idmap,
 							    struct inode *inode,
 							    int acl_type)
 {
@@ -2253,7 +2253,7 @@ int ksmbd_vfs_set_init_posix_acl(struct mnt_idmap *idmap,
 	return rc;
 }
 
-int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
+int ksmbd_vfs_inherit_posix_acl(const struct mnt_idmap *idmap,
 				const struct path *path, struct inode *parent_inode)
 {
 	struct posix_acl *acls;
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 55d099de71f5..9f4b003166e5 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -173,7 +173,7 @@ int ksmbd_vfs_get_dos_attrib_xattr(struct mnt_idmap *idmap,
 				   struct xattr_dos_attrib *da);
 int ksmbd_vfs_set_init_posix_acl(struct mnt_idmap *idmap,
 				 const struct path *path);
-int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
+int ksmbd_vfs_inherit_posix_acl(const struct mnt_idmap *idmap,
 				const struct path *path,
 				struct inode *parent_inode);
 void ksmbd_vfs_update_compressed_fattr(struct dentry *dentry, __le32 *fattr);
diff --git a/include/linux/mnt_idmapping.h b/include/linux/mnt_idmapping.h
index e5bee8b41094..b16f52d27ba0 100644
--- a/include/linux/mnt_idmapping.h
+++ b/include/linux/mnt_idmapping.h
@@ -124,16 +124,16 @@ int vfsgid_in_group_p(vfsgid_t vfsgid);
 struct mnt_idmap *mnt_idmap_get(const struct mnt_idmap *idmap);
 void mnt_idmap_put(const struct mnt_idmap *idmap);
 
-vfsuid_t make_vfsuid(struct mnt_idmap *idmap,
+vfsuid_t make_vfsuid(const struct mnt_idmap *idmap,
 		     struct user_namespace *fs_userns, kuid_t kuid);
 
-vfsgid_t make_vfsgid(struct mnt_idmap *idmap,
+vfsgid_t make_vfsgid(const struct mnt_idmap *idmap,
 		     struct user_namespace *fs_userns, kgid_t kgid);
 
-kuid_t from_vfsuid(struct mnt_idmap *idmap,
+kuid_t from_vfsuid(const struct mnt_idmap *idmap,
 		   struct user_namespace *fs_userns, vfsuid_t vfsuid);
 
-kgid_t from_vfsgid(struct mnt_idmap *idmap,
+kgid_t from_vfsgid(const struct mnt_idmap *idmap,
 		   struct user_namespace *fs_userns, vfsgid_t vfsgid);
 
 /**
@@ -148,7 +148,7 @@ kgid_t from_vfsgid(struct mnt_idmap *idmap,
  *
  * Return: true if @vfsuid has a mapping in the filesystem, false if not.
  */
-static inline bool vfsuid_has_fsmapping(struct mnt_idmap *idmap,
+static inline bool vfsuid_has_fsmapping(const struct mnt_idmap *idmap,
 					struct user_namespace *fs_userns,
 					vfsuid_t vfsuid)
 {
@@ -186,7 +186,7 @@ static inline kuid_t vfsuid_into_kuid(vfsuid_t vfsuid)
  *
  * Return: true if @vfsgid has a mapping in the filesystem, false if not.
  */
-static inline bool vfsgid_has_fsmapping(struct mnt_idmap *idmap,
+static inline bool vfsgid_has_fsmapping(const struct mnt_idmap *idmap,
 					struct user_namespace *fs_userns,
 					vfsgid_t vfsgid)
 {
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index b59e3f121b8a..66f27653cdac 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -481,7 +481,7 @@ static enum integrity_status evm_verify_current_integrity(struct dentry *dentry)
  *
  * Returns 1 if passed xattr value differs from current value, 0 otherwise.
  */
-static int evm_xattr_change(struct mnt_idmap *idmap,
+static int evm_xattr_change(const struct mnt_idmap *idmap,
 			    struct dentry *dentry, const char *xattr_name,
 			    const void *xattr_value, size_t xattr_value_len)
 {
@@ -517,7 +517,7 @@ static int evm_xattr_change(struct mnt_idmap *idmap,
  * For posix xattr acls only, permit security.evm, even if it currently
  * doesn't exist, to be updated unless the EVM signature is immutable.
  */
-static int evm_protect_xattr(struct mnt_idmap *idmap,
+static int evm_protect_xattr(const struct mnt_idmap *idmap,
 			     struct dentry *dentry, const char *xattr_name,
 			     const void *xattr_value, size_t xattr_value_len)
 {

-- 
2.53.0

