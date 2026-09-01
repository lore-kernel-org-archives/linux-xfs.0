Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96FB3CAE60;
	Tue,  1 Sep 2026 12:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264907; cv=none; b=JO+3ozHK/8jD8PMdI3J+TpHabSfZP4VFWFK2xIVuDNBzwXymBskAmmJGp8TTtSunBmjn9pKgPdmYOQS1M23KYsp36CsnEeZyvIoFj3yI/OBPHtyMuSRb+KklL9v/2QhcsP0c+YSxdI/qf6fx6i7xg5b+16PgkCmhGmumb0Pcg9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264907; c=relaxed/simple;
	bh=4sg2VKPHTlY8dSs2jnmAAtUJS55xM+K+bPToWkz/0D8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LZWxd4aRp1u7nfjbLaJByfbiRIHyjWWT81BlnzpL6ukSTLvvzftPYBcEVgd3cvgArRD9/VnUs9+A+UTtoCSURoVwTzQQ3jrEVN4xFJJr3Zu8nnpJWxuEbtL3a50XBzm2ksSrOlqtrjUV2bmBhVv9J0y59JVr7aQeavD6ywlStUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CU+knrgF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CU+knrgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0AB1F0155F;
	Tue,  1 Sep 2026 12:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264905;
	bh=zToFqtoYNQ1tsslY07AViNG5aSHq/TIO1tus4GBter8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CU+knrgFAo5h9gO8pw2LZznnAG9deXaYmEVeJ9nCbBDbtW5yU1N8LfnCOgsRxPOOC
	 /CA4m2dfTe/FlVKOfqWRCWdk0WMsAlcm3Pk7n47MxVLj7inmHamAsDE95iIIKvjfRW
	 aqKtMYbkTM9RW0/6uaPNsDTZ/I9qd/YTKSyv284eaYp2B7uGt3BLQZ+wWz+DQn27m8
	 CMLWwbtVHV0LxcUx6OTksNS5CgcpU8InVwUCgwsV2T8uOGprpL7cOilQqQC1Sb5YI2
	 5uAM7oDazK799dJUXlSHr+XPeG2KSVAaLiPzEuPF6IKfuIYQXNfGsKPaj1k8vbyXFb
	 zBSv3pZ23DMtA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:29 +0200
Subject: [PATCH 04/27] fs: port fs{g,u}id helpers to const mnt_idmap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-4-54ccd48e100b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7890; i=brauner@kernel.org;
 h=from:subject:message-id; bh=4sg2VKPHTlY8dSs2jnmAAtUJS55xM+K+bPToWkz/0D8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7gmvcKEk6VjhcZOg6nxd1KnVU1zcbg8s6hQ/NQ2C
 //zXEFfOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbS0cHI8CS49AuDk6Sie0pE
 4p+yVoNPnRESkh1Vh+Pq0pd/l7RaDFTxcSKz5kSxF73nL7Y6ZEpt+ujk9TbA7i4fu2PXl3+tAsw A
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
 fs/ceph/mds_client.h          |  2 +-
 fs/fuse/dir.c                 | 13 +++++++------
 fs/fuse/fuse_i.h              |  4 ++--
 fs/fuse/req.c                 |  8 +++++---
 include/linux/fs.h            |  6 +++---
 include/linux/mnt_idmapping.h |  4 ++--
 6 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 3c62e3c3530b..1ac8a7e08e5c 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -375,7 +375,7 @@ struct ceph_mds_request {
 	int r_fmode;        /* file mode, if expecting cap */
 	int r_request_release_offset;
 	const struct cred *r_cred;
-	struct mnt_idmap *r_mnt_idmap;
+	const struct mnt_idmap *r_mnt_idmap;
 	struct timespec64 r_stamp;
 
 	/* for choosing which mds to send this request to */
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 0d297f74c663..7a204f55ca84 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -820,7 +820,7 @@ static void free_ext_value(struct fuse_args *args)
  * If the filesystem doesn't support this, then fall back to separate
  * 'mknod' + 'open' requests.
  */
-static int fuse_create_open(struct mnt_idmap *idmap, struct inode *dir,
+static int fuse_create_open(const struct mnt_idmap *idmap, struct inode *dir,
 			    struct dentry *entry, struct file *file,
 			    unsigned int flags, umode_t mode, u32 opcode)
 {
@@ -980,7 +980,7 @@ static int fuse_atomic_open(struct inode *dir, struct dentry *entry,
 /*
  * Code shared between mknod, mkdir, symlink and link
  */
-static struct dentry *create_new_entry(struct mnt_idmap *idmap, struct fuse_mount *fm,
+static struct dentry *create_new_entry(const struct mnt_idmap *idmap, struct fuse_mount *fm,
 				       struct fuse_args *args, struct inode *dir,
 				       struct dentry *entry, umode_t mode)
 {
@@ -1053,7 +1053,7 @@ static struct dentry *create_new_entry(struct mnt_idmap *idmap, struct fuse_moun
 	return ERR_PTR(err);
 }
 
-static int create_new_nondir(struct mnt_idmap *idmap, struct fuse_mount *fm,
+static int create_new_nondir(const struct mnt_idmap *idmap, struct fuse_mount *fm,
 			     struct fuse_args *args, struct inode *dir,
 			     struct dentry *entry, umode_t mode)
 {
@@ -1256,9 +1256,10 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 	return err;
 }
 
-static int fuse_rename_common(struct mnt_idmap *idmap, struct inode *olddir, struct dentry *oldent,
-			      struct inode *newdir, struct dentry *newent,
-			      unsigned int flags, int opcode, size_t argsize)
+static int fuse_rename_common(const struct mnt_idmap *idmap, struct inode *olddir,
+			      struct dentry *oldent, struct inode *newdir,
+			      struct dentry *newent, unsigned int flags,
+			      int opcode, size_t argsize)
 {
 	int err;
 	struct fuse_rename2_in inarg;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index c8d4c5f3af7e..a07c75377a30 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1003,7 +1003,7 @@ void __exit fuse_ctl_cleanup(void);
 /*
  * Simple request sending that does request allocation and freeing
  */
-ssize_t __fuse_simple_request(struct mnt_idmap *idmap,
+ssize_t __fuse_simple_request(const struct mnt_idmap *idmap,
 			      struct fuse_mount *fm,
 			      struct fuse_args *args);
 
@@ -1012,7 +1012,7 @@ static inline ssize_t fuse_simple_request(struct fuse_mount *fm, struct fuse_arg
 	return __fuse_simple_request(&invalid_mnt_idmap, fm, args);
 }
 
-static inline ssize_t fuse_simple_idmap_request(struct mnt_idmap *idmap,
+static inline ssize_t fuse_simple_idmap_request(const struct mnt_idmap *idmap,
 						struct fuse_mount *fm,
 						struct fuse_args *args)
 {
diff --git a/fs/fuse/req.c b/fs/fuse/req.c
index a01ee743d31e..a133b012d041 100644
--- a/fs/fuse/req.c
+++ b/fs/fuse/req.c
@@ -3,7 +3,8 @@
 #include "dev.h"
 #include "fuse_i.h"
 
-static int fuse_fill_creds(struct fuse_mount *fm, struct fuse_args *args, struct mnt_idmap *idmap)
+static int fuse_fill_creds(struct fuse_mount *fm, struct fuse_args *args,
+			   const struct mnt_idmap *idmap)
 {
 	struct fuse_conn *fc = fm->fc;
 	bool no_idmap = !fm->sb || (fm->sb->s_iflags & SB_I_NOIDMAP);
@@ -49,7 +50,8 @@ static int fuse_fill_creds(struct fuse_mount *fm, struct fuse_args *args, struct
 	return 0;
 }
 
-static int fuse_req_prep(struct fuse_mount *fm, struct fuse_args *args, struct mnt_idmap *idmap)
+static int fuse_req_prep(struct fuse_mount *fm, struct fuse_args *args,
+			 const struct mnt_idmap *idmap)
 {
 	if (!args->force && fm->fc->conn_error)
 		return -ECONNREFUSED;
@@ -57,7 +59,7 @@ static int fuse_req_prep(struct fuse_mount *fm, struct fuse_args *args, struct m
 	return fuse_fill_creds(fm, args, idmap);
 }
 
-ssize_t __fuse_simple_request(struct mnt_idmap *idmap, struct fuse_mount *fm,
+ssize_t __fuse_simple_request(const struct mnt_idmap *idmap, struct fuse_mount *fm,
 			      struct fuse_args *args)
 {
 	struct fuse_conn *fc = fm->fc;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f9d1e05e8ae6..959c747ef75a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1544,7 +1544,7 @@ static inline void i_gid_update(struct mnt_idmap *idmap,
  * an idmapped mount map the caller's fsuid according to @idmap.
  */
 static inline void inode_fsuid_set(struct inode *inode,
-				   struct mnt_idmap *idmap)
+				   const struct mnt_idmap *idmap)
 {
 	inode->i_uid = mapped_fsuid(idmap, i_user_ns(inode));
 }
@@ -1558,7 +1558,7 @@ static inline void inode_fsuid_set(struct inode *inode,
  * an idmapped mount map the caller's fsgid according to @idmap.
  */
 static inline void inode_fsgid_set(struct inode *inode,
-				   struct mnt_idmap *idmap)
+				   const struct mnt_idmap *idmap)
 {
 	inode->i_gid = mapped_fsgid(idmap, i_user_ns(inode));
 }
@@ -1575,7 +1575,7 @@ static inline void inode_fsgid_set(struct inode *inode,
  * Return: true if fsuid and fsgid is mapped, false if not.
  */
 static inline bool fsuidgid_has_mapping(struct super_block *sb,
-					struct mnt_idmap *idmap)
+					const struct mnt_idmap *idmap)
 {
 	struct user_namespace *fs_userns = sb->s_user_ns;
 	kuid_t kuid;
diff --git a/include/linux/mnt_idmapping.h b/include/linux/mnt_idmapping.h
index b16f52d27ba0..6656aea23be2 100644
--- a/include/linux/mnt_idmapping.h
+++ b/include/linux/mnt_idmapping.h
@@ -225,7 +225,7 @@ static inline kgid_t vfsgid_into_kgid(vfsgid_t vfsgid)
  *
  * Return: the caller's current fsuid mapped up according to @idmap.
  */
-static inline kuid_t mapped_fsuid(struct mnt_idmap *idmap,
+static inline kuid_t mapped_fsuid(const struct mnt_idmap *idmap,
 				  struct user_namespace *fs_userns)
 {
 	return from_vfsuid(idmap, fs_userns, VFSUIDT_INIT(current_fsuid()));
@@ -244,7 +244,7 @@ static inline kuid_t mapped_fsuid(struct mnt_idmap *idmap,
  *
  * Return: the caller's current fsgid mapped up according to @idmap.
  */
-static inline kgid_t mapped_fsgid(struct mnt_idmap *idmap,
+static inline kgid_t mapped_fsgid(const struct mnt_idmap *idmap,
 				  struct user_namespace *fs_userns)
 {
 	return from_vfsgid(idmap, fs_userns, VFSGIDT_INIT(current_fsgid()));

-- 
2.53.0

