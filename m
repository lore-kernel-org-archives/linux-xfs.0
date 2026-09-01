Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D0331717D;
	Tue,  1 Sep 2026 12:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264913; cv=none; b=P6dA6vvf88tQaGozTeMIOJtaDH8EPWPqsbzb+wrFzA2mYL05eqfyt1l3J3izPtaLZz08XY9+aF66+xPvK2uVo7LqQ3Pv+eeJXXUrdgCH+gFOz3YAZ0FrA/fq7t6+Jpnda836cZ2hmcUsNlJ2VFB9586d40QH+vEBCD3+//5T1cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264913; c=relaxed/simple;
	bh=ogDrhbH7WlVp6Uv2QHyWtgKQkqu869S7NiF9YJK5khY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VZ6eMYx7wbf7ViUDT+2GLtxDjML3IQ9wwAkJlFqRkQ5Yz04KkJDHZJlKBGR6+Q1dxGlG13jGu7QVLzH3tYqu8uySJoouDRxsVUm0ZGyjZU2S57SkeSDP+Ba4mD9nxXVzPdj73Wf9K0/tjtViOVMiY5rHJzKrpZP6s7NMVw4cRTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X4OAbTPG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X4OAbTPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA871F00A3D;
	Tue,  1 Sep 2026 12:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264910;
	bh=G/QOt1UvN1B+4m0ePoWLHjNqC1SRYhOVaU6/ywSpAuE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=X4OAbTPGuaejqbG0AR9BnCM1sDCJlQ9anPSHal8qOwJM6t8OWCt65LmgbdemZiCTM
	 lSpbJzkKA2zmUTaQX5wEZfQ3/RXgUKzJvMUu25scS4nhn5I2wa4z5cb6LQWLLA+qdB
	 Gte8Y3yX4EEwSXxAl1n6wZryTSu5Cq1566yFigjoyTSq/aLhHIzgWLuIKFn+8mWg/y
	 cJ1DS5ZjMAQnlqA2IpLSCEbfCteB6uCtXsS2i8h+KQDBkk4Rf7ELGbUIoDbo8J6oFJ
	 R6E4sKF9ujrNSySDSKcprIJGO59jDFEMbLESB+REdDwASIA+OK+XUrW6MuRTIECsV7
	 xnxUHh8y8VM4Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:30 +0200
Subject: [PATCH 05/27] fs: port i_{g,u}id_into_vfs{g,u}id() to const
 mnt_idmap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-5-54ccd48e100b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=13692; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ogDrhbH7WlVp6Uv2QHyWtgKQkqu869S7NiF9YJK5khY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7jm74sYHWuLxM9qLsml18SmTFR6b29u/r3rUpt6K
 LdtUdv+jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlse8HI8PhApHv76ZtHTa+e
 y+qVLtXb5GlwyGHbzzcrVwgxJb08vY+R4aI+E+fCFzsD1hT8smxnlBdmu7nO8cIasc8Pvn3/ddx
 tJw8A
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
 fs/exfat/file.c                       |  2 +-
 fs/fat/file.c                         |  2 +-
 fs/internal.h                         |  2 +-
 fs/namei.c                            |  2 +-
 fs/smb/server/ndr.c                   |  2 +-
 fs/smb/server/ndr.h                   |  2 +-
 fs/smb/server/smb2pdu.c               |  2 +-
 fs/xattr.c                            |  2 +-
 fs/xfs/xfs_itable.c                   |  2 +-
 fs/xfs/xfs_itable.h                   |  2 +-
 include/linux/fs.h                    |  6 +++---
 security/integrity/ima/ima.h          | 10 +++++-----
 security/integrity/ima/ima_api.c      |  2 +-
 security/integrity/ima/ima_appraise.c |  2 +-
 security/integrity/ima/ima_main.c     |  2 +-
 security/integrity/ima/ima_policy.c   |  4 ++--
 16 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index a2a9ee1a2004..0530803f71e8 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -143,7 +143,7 @@ static long exfat_fallocate(struct file *file, int mode,
 	return err;
 }
 
-static bool exfat_allow_set_time(struct mnt_idmap *idmap,
+static bool exfat_allow_set_time(const struct mnt_idmap *idmap,
 				 struct exfat_sb_info *sbi, struct inode *inode)
 {
 	mode_t allow_utime = sbi->options.allow_utime;
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 1c835ca5f21a..0b8b493d06e4 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -493,7 +493,7 @@ static int fat_sanitize_mode(const struct msdos_sb_info *sbi,
 	return 0;
 }
 
-static int fat_allow_set_time(struct mnt_idmap *idmap,
+static int fat_allow_set_time(const struct mnt_idmap *idmap,
 			      struct msdos_sb_info *sbi, struct inode *inode)
 {
 	umode_t allow_utime = sbi->options.allow_utime;
diff --git a/fs/internal.h b/fs/internal.h
index 87ac96c3e29e..72244e5f4e57 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -299,7 +299,7 @@ int filename_setxattr(int dfd, struct filename *filename,
 int setxattr_copy(const char __user *name, struct kernel_xattr_ctx *ctx);
 int import_xattr_name(struct xattr_name *kname, const char __user *name);
 
-int may_write_xattr(struct mnt_idmap *idmap, struct inode *inode);
+int may_write_xattr(const struct mnt_idmap *idmap, struct inode *inode);
 
 #ifdef CONFIG_FS_POSIX_ACL
 int do_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
diff --git a/fs/namei.c b/fs/namei.c
index 20a6534ea3ef..603d43e4a961 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1407,7 +1407,7 @@ int may_linkat(struct mnt_idmap *idmap, const struct path *link)
  *
  * Returns 0 if the open is allowed, -ve on error.
  */
-static int may_create_in_sticky(struct mnt_idmap *idmap, struct nameidata *nd,
+static int may_create_in_sticky(const struct mnt_idmap *idmap, struct nameidata *nd,
 				struct inode *const inode)
 {
 	umode_t dir_mode = nd->dir_mode;
diff --git a/fs/smb/server/ndr.c b/fs/smb/server/ndr.c
index 58d71560f626..7e546c22e284 100644
--- a/fs/smb/server/ndr.c
+++ b/fs/smb/server/ndr.c
@@ -338,7 +338,7 @@ static int ndr_encode_posix_acl_entry(struct ndr *n, struct xattr_smb_acl *acl)
 }
 
 int ndr_encode_posix_acl(struct ndr *n,
-			 struct mnt_idmap *idmap,
+			 const struct mnt_idmap *idmap,
 			 struct inode *inode,
 			 struct xattr_smb_acl *acl,
 			 struct xattr_smb_acl *def_acl)
diff --git a/fs/smb/server/ndr.h b/fs/smb/server/ndr.h
index f3c108c8cf4d..646568c42e4d 100644
--- a/fs/smb/server/ndr.h
+++ b/fs/smb/server/ndr.h
@@ -14,7 +14,7 @@ struct ndr {
 
 int ndr_encode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da);
 int ndr_decode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da);
-int ndr_encode_posix_acl(struct ndr *n, struct mnt_idmap *idmap,
+int ndr_encode_posix_acl(struct ndr *n, const struct mnt_idmap *idmap,
 			 struct inode *inode, struct xattr_smb_acl *acl,
 			 struct xattr_smb_acl *def_acl);
 int ndr_encode_v4_ntacl(struct ndr *n, struct xattr_ntacl *acl);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a8046f477d54..0789200d602f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3604,7 +3604,7 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
 }
 
 static void ksmbd_acls_fattr(struct smb_fattr *fattr,
-			     struct mnt_idmap *idmap,
+			     const struct mnt_idmap *idmap,
 			     struct inode *inode)
 {
 	vfsuid_t vfsuid = i_uid_into_vfsuid(idmap, inode);
diff --git a/fs/xattr.c b/fs/xattr.c
index d58979115200..c08f188748a9 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -100,7 +100,7 @@ xattr_resolve_name(struct inode *inode, const char **name)
  *
  * Return: On success zero is returned. On error a negative errno is returned.
  */
-int may_write_xattr(struct mnt_idmap *idmap, struct inode *inode)
+int may_write_xattr(const struct mnt_idmap *idmap, struct inode *inode)
 {
 	if (IS_IMMUTABLE(inode))
 		return -EPERM;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 159295c63e8f..a4cf1effa5e6 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -63,7 +63,7 @@ want_metadir_file(
 STATIC int
 xfs_bulkstat_one_int(
 	struct xfs_mount	*mp,
-	struct mnt_idmap	*idmap,
+	const struct mnt_idmap	*idmap,
 	struct xfs_trans	*tp,
 	xfs_ino_t		ino,
 	struct xfs_bstat_chunk	*bc)
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 2d0612f14d6e..c0567bfc30fb 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -8,7 +8,7 @@
 /* In-memory representation of a userspace request for batch inode data. */
 struct xfs_ibulk {
 	struct xfs_mount	*mp;
-	struct mnt_idmap	*idmap;
+	const struct mnt_idmap	*idmap;
 	void __user		*ubuffer; /* user output buffer */
 	xfs_ino_t		startino; /* start with this inode */
 	unsigned int		icount;   /* number of elements in ubuffer */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 959c747ef75a..cec5de83d882 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1439,7 +1439,7 @@ static inline void i_gid_write(struct inode *inode, gid_t gid)
  * Return: whe inode's i_uid mapped down according to @idmap.
  * If the inode's i_uid has no mapping INVALID_VFSUID is returned.
  */
-static inline vfsuid_t i_uid_into_vfsuid(struct mnt_idmap *idmap,
+static inline vfsuid_t i_uid_into_vfsuid(const struct mnt_idmap *idmap,
 					 const struct inode *inode)
 {
 	return make_vfsuid(idmap, i_user_ns(inode), inode->i_uid);
@@ -1491,7 +1491,7 @@ static inline void i_uid_update(struct mnt_idmap *idmap,
  * Return: the inode's i_gid mapped down according to @idmap.
  * If the inode's i_gid has no mapping INVALID_VFSGID is returned.
  */
-static inline vfsgid_t i_gid_into_vfsgid(struct mnt_idmap *idmap,
+static inline vfsgid_t i_gid_into_vfsgid(const struct mnt_idmap *idmap,
 					 const struct inode *inode)
 {
 	return make_vfsgid(idmap, i_user_ns(inode), inode->i_gid);
@@ -2173,7 +2173,7 @@ extern loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 				 (inode)->i_rdev == WHITEOUT_DEV)
 #define IS_ANON_FILE(inode)	((inode)->i_flags & S_ANON_INODE)
 
-static inline bool HAS_UNMAPPED_ID(struct mnt_idmap *idmap,
+static inline bool HAS_UNMAPPED_ID(const struct mnt_idmap *idmap,
 				   struct inode *inode)
 {
 	return !vfsuid_valid(i_uid_into_vfsuid(idmap, inode)) ||
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 10214f73ca1e..b502854f28ee 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -423,7 +423,7 @@ static inline void ima_process_queued_keys(void) {}
 #endif /* CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS */
 
 /* LIM API function definitions */
-int ima_get_action(struct mnt_idmap *idmap, struct inode *inode,
+int ima_get_action(const struct mnt_idmap *idmap, struct inode *inode,
 		   const struct cred *cred, struct lsm_prop *prop, int mask,
 		   enum ima_hooks func, int *pcr,
 		   struct ima_template_desc **template_desc,
@@ -437,7 +437,7 @@ void ima_store_measurement(struct ima_iint_cache *iint, struct file *file,
 			   struct evm_ima_xattr_data *xattr_value,
 			   int xattr_len, const struct modsig *modsig, int pcr,
 			   struct ima_template_desc *template_desc);
-int process_buffer_measurement(struct mnt_idmap *idmap,
+int process_buffer_measurement(const struct mnt_idmap *idmap,
 			       struct inode *inode, const void *buf, int size,
 			       const char *eventname, enum ima_hooks func,
 			       int pcr, const char *func_data,
@@ -454,7 +454,7 @@ void ima_free_template_entry(struct ima_template_entry *entry);
 const char *ima_d_path(const struct path *path, char **pathbuf, char *filename);
 
 /* IMA policy related functions */
-int ima_match_policy(struct mnt_idmap *idmap, struct inode *inode,
+int ima_match_policy(const struct mnt_idmap *idmap, struct inode *inode,
 		     const struct cred *cred, struct lsm_prop *prop,
 		     enum ima_hooks func, int mask, int flags, int *pcr,
 		     struct ima_template_desc **template_desc,
@@ -489,7 +489,7 @@ int ima_appraise_measurement(enum ima_hooks func, struct ima_iint_cache *iint,
 			     struct evm_ima_xattr_data *xattr_value,
 			     int xattr_len, const struct modsig *modsig,
 			     bool bprm_is_check);
-int ima_must_appraise(struct mnt_idmap *idmap, struct inode *inode,
+int ima_must_appraise(const struct mnt_idmap *idmap, struct inode *inode,
 		      int mask, enum ima_hooks func);
 void ima_update_xattr(struct ima_iint_cache *iint, struct file *file);
 enum integrity_status ima_get_cache_status(struct ima_iint_cache *iint,
@@ -519,7 +519,7 @@ static inline int ima_appraise_measurement(enum ima_hooks func,
 	return INTEGRITY_UNKNOWN;
 }
 
-static inline int ima_must_appraise(struct mnt_idmap *idmap,
+static inline int ima_must_appraise(const struct mnt_idmap *idmap,
 				    struct inode *inode, int mask,
 				    enum ima_hooks func)
 {
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 122d127e108d..3c5a23b4a2ff 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -188,7 +188,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
  * Returns IMA_MEASURE, IMA_APPRAISE mask.
  *
  */
-int ima_get_action(struct mnt_idmap *idmap, struct inode *inode,
+int ima_get_action(const struct mnt_idmap *idmap, struct inode *inode,
 		   const struct cred *cred, struct lsm_prop *prop, int mask,
 		   enum ima_hooks func, int *pcr,
 		   struct ima_template_desc **template_desc,
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index ced2e131b061..6b21db789ef1 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -71,7 +71,7 @@ bool is_ima_appraise_enabled(void)
  *
  * Return 1 to appraise or hash
  */
-int ima_must_appraise(struct mnt_idmap *idmap, struct inode *inode,
+int ima_must_appraise(const struct mnt_idmap *idmap, struct inode *inode,
 		      int mask, enum ima_hooks func)
 {
 	struct lsm_prop prop;
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index ab1e53b3210d..8d9c92dc8825 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -1095,7 +1095,7 @@ static int ima_post_load_data(char *buf, loff_t size,
  * has been written to the passed location but not added to a measurement entry,
  * a negative value otherwise.
  */
-int process_buffer_measurement(struct mnt_idmap *idmap,
+int process_buffer_measurement(const struct mnt_idmap *idmap,
 			       struct inode *inode, const void *buf, int size,
 			       const char *eventname, enum ima_hooks func,
 			       int pcr, const char *func_data,
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index f79d07bb63c6..89d197d99383 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -575,7 +575,7 @@ static bool ima_match_rule_data(struct ima_rule_entry *rule,
  * Returns true on rule match, false on failure.
  */
 static bool ima_match_rules(struct ima_rule_entry *rule,
-			    struct mnt_idmap *idmap,
+			    const struct mnt_idmap *idmap,
 			    struct inode *inode, const struct cred *cred,
 			    struct lsm_prop *prop, enum ima_hooks func, int mask,
 			    const char *func_data)
@@ -757,7 +757,7 @@ static int get_subaction(struct ima_rule_entry *rule, enum ima_hooks func)
  * list when walking it.  Reads are many orders of magnitude more numerous
  * than writes so ima_match_policy() is classical RCU candidate.
  */
-int ima_match_policy(struct mnt_idmap *idmap, struct inode *inode,
+int ima_match_policy(const struct mnt_idmap *idmap, struct inode *inode,
 		     const struct cred *cred, struct lsm_prop *prop,
 		     enum ima_hooks func, int mask, int flags, int *pcr,
 		     struct ima_template_desc **template_desc,

-- 
2.53.0

