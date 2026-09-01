Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C5A47D926;
	Tue,  1 Sep 2026 12:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264987; cv=none; b=gj4YFNDmgO58x1DDQwTGJGLHiB5fJKEpPkSpnOSk7urOChieJbNRCbKR56cq/DrL18WtA5wW7lwq/Ph5RoSq1sXshfzJYGAYXWIzRbuMOSRtLSheOJNlRf9d+VFZn1Ckf8iUjhOJwRKQwCR6bjQKQBecgMSpvlBS4UJtFVg4FmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264987; c=relaxed/simple;
	bh=Hg3FLaLdJ2kIoY43h5iXHTOKeMvzgNrnKlJUivdeTxA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DP+PLaia/2l8PevI1CTKILiPLp4acbG1Q4Ckf+O25hQUDv+d0foQEIe86AV/o4xGAGn9HpENhgGADiOkSojW5WZwH+R/3nb/TGMx0vo2XuSQ7On6chrFadBQU3rTTQcjFzLRRuiZsrpPCRVet+SJnEXAGuHozKfPrhdCr9BQ0oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=io5hKQhW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="io5hKQhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E340C1F000E9;
	Tue,  1 Sep 2026 12:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264984;
	bh=uHgsbAAHKjoVUY1cBUf/Xz1S24N3el37nYCUEIRxIuo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=io5hKQhW7ZqfSfXdW2yd25JkbmYEg1CjCwQINbgKmK9bh2alYojTW1KLkG8eFrL8Q
	 MaRKsGLZ+QQ91FXVBHn+kVTow0pHJH3rsYg9vkO5vzyA6S+1F4Ju0se/d8Kh+8tIeU
	 +n9eZhjPN351UJFADNfQmVyOeGZ3Ckq7O2rJa5MRAPPTe4JSuv7sYJerC+h5HbpPEo
	 taUVFL+N4YKV0pH3pKHRiBPmWgcsUUYCyJiQ3U9Le/hlM7bkLAmMBwpTu5giQ2eSuI
	 2al90+BT0oInF5A4qbopsEHQmXkwI1fGJEu2hP1Rty/RYMZQ73CWgtE6/1HFBsW5Wa
	 S45lX2Bkyw9sQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:45 +0200
Subject: [PATCH 20/27] fs: port ->mkdir() to pass const mnt_idmap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-20-54ccd48e100b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=33866; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Hg3FLaLdJ2kIoY43h5iXHTOKeMvzgNrnKlJUivdeTxA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7g2J5Zlggnj9J/G87Q+6QYcquqbc3riBkHHR03sa
 xv/c03/3FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCR6icM/+OZHR+w8M44ZVWl
 u/0tc5yt7F/To61/ar6ETL3WuaL16ntGhmcss1xM1/7Jsj/9bkb0uYQptX/ldVjjHzatebtppsr
 nZYwA
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
 fs/9p/vfs_inode.c                     | 2 +-
 fs/9p/vfs_inode_dotl.c                | 2 +-
 fs/affs/affs.h                        | 2 +-
 fs/affs/namei.c                       | 2 +-
 fs/afs/dir.c                          | 4 ++--
 fs/autofs/root.c                      | 4 ++--
 fs/bad_inode.c                        | 2 +-
 fs/btrfs/inode.c                      | 2 +-
 fs/ceph/dir.c                         | 2 +-
 fs/coda/dir.c                         | 2 +-
 fs/configfs/dir.c                     | 2 +-
 fs/ecryptfs/inode.c                   | 2 +-
 fs/exfat/namei.c                      | 2 +-
 fs/ext2/namei.c                       | 2 +-
 fs/ext4/namei.c                       | 2 +-
 fs/f2fs/namei.c                       | 2 +-
 fs/fat/namei_msdos.c                  | 2 +-
 fs/fat/namei_vfat.c                   | 2 +-
 fs/fuse/dir.c                         | 2 +-
 fs/gfs2/inode.c                       | 2 +-
 fs/hfs/dir.c                          | 2 +-
 fs/hfsplus/dir.c                      | 2 +-
 fs/hostfs/hostfs_kern.c               | 2 +-
 fs/hpfs/namei.c                       | 2 +-
 fs/hugetlbfs/inode.c                  | 2 +-
 fs/jffs2/dir.c                        | 4 ++--
 fs/jfs/namei.c                        | 2 +-
 fs/kernfs/dir.c                       | 2 +-
 fs/minix/namei.c                      | 2 +-
 fs/nfs/dir.c                          | 2 +-
 fs/nfs/internal.h                     | 2 +-
 fs/nilfs2/namei.c                     | 2 +-
 fs/ntfs/namei.c                       | 2 +-
 fs/ntfs3/namei.c                      | 2 +-
 fs/ocfs2/dlmfs/dlmfs.c                | 2 +-
 fs/ocfs2/namei.c                      | 2 +-
 fs/omfs/dir.c                         | 2 +-
 fs/orangefs/namei.c                   | 2 +-
 fs/overlayfs/dir.c                    | 2 +-
 fs/ramfs/inode.c                      | 2 +-
 fs/smb/client/cifsfs.h                | 2 +-
 fs/smb/client/inode.c                 | 2 +-
 fs/tracefs/inode.c                    | 2 +-
 fs/ubifs/dir.c                        | 2 +-
 fs/udf/namei.c                        | 2 +-
 fs/ufs/namei.c                        | 2 +-
 fs/vboxsf/dir.c                       | 2 +-
 fs/xfs/xfs_iops.c                     | 2 +-
 include/linux/fs.h                    | 2 +-
 kernel/bpf/inode.c                    | 2 +-
 mm/shmem.c                            | 2 +-
 security/apparmor/apparmorfs.c        | 2 +-
 54 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 97f8aaff311e..e0851f1859b3 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -66,7 +66,7 @@ prototypes::
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
 	int (*unlink) (struct inode *,struct dentry *);
 	int (*symlink) (struct mnt_idmap *, struct inode *,struct dentry *,const char *);
-	struct dentry *(*mkdir) (struct mnt_idmap *, struct inode *,struct dentry *,umode_t);
+	struct dentry *(*mkdir) (const struct mnt_idmap *, struct inode *,struct dentry *,umode_t);
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (const struct mnt_idmap *, struct inode *,struct dentry *,umode_t,dev_t);
 	int (*rename) (const struct mnt_idmap *, struct inode *, struct dentry *,
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 90f8a0b74249..b16105a81cfe 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -420,7 +420,7 @@ As of kernel 2.6.22, the following members are defined:
 		int (*link) (struct dentry *,struct inode *,struct dentry *);
 		int (*unlink) (struct inode *,struct dentry *);
 		int (*symlink) (struct mnt_idmap *, struct inode *,struct dentry *,const char *);
-		struct dentry *(*mkdir) (struct mnt_idmap *, struct inode *,struct dentry *,umode_t);
+		struct dentry *(*mkdir) (const struct mnt_idmap *, struct inode *,struct dentry *,umode_t);
 		int (*rmdir) (struct inode *,struct dentry *);
 		int (*mknod) (const struct mnt_idmap *, struct inode *,struct dentry *,umode_t,dev_t);
 		int (*rename) (const struct mnt_idmap *, struct inode *, struct dentry *,
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 7d4d5a4481fa..a448e9a9a014 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -679,7 +679,7 @@ v9fs_vfs_create(struct mnt_idmap *idmap, struct inode *dir,
  *
  */
 
-static struct dentry *v9fs_vfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *v9fs_vfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				     struct dentry *dentry, umode_t mode)
 {
 	u32 perm;
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 634c4f5665c3..3c21006203d2 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -344,7 +344,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
  *
  */
 
-static struct dentry *v9fs_vfs_mkdir_dotl(struct mnt_idmap *idmap,
+static struct dentry *v9fs_vfs_mkdir_dotl(const struct mnt_idmap *idmap,
 					  struct inode *dir, struct dentry *dentry,
 					  umode_t omode)
 {
diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index a4b1e449aafc..3dd795ce446e 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -168,7 +168,7 @@ extern struct dentry *affs_lookup(struct inode *dir, struct dentry *dentry, unsi
 extern int	affs_unlink(struct inode *dir, struct dentry *dentry);
 extern int	affs_create(struct mnt_idmap *idmap, struct inode *dir,
 			struct dentry *dentry, umode_t mode);
-extern struct dentry *affs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+extern struct dentry *affs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 			struct dentry *dentry, umode_t mode);
 extern int	affs_rmdir(struct inode *dir, struct dentry *dentry);
 extern int	affs_link(struct dentry *olddentry, struct inode *dir,
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index c9cc0ad5c330..d17f0ba7c33c 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -274,7 +274,7 @@ affs_create(struct mnt_idmap *idmap, struct inode *dir,
 }
 
 struct dentry *
-affs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+affs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 	   struct dentry *dentry, umode_t mode)
 {
 	struct inode		*inode;
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index fee48c544c61..6a3cac50dc61 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -35,7 +35,7 @@ static bool afs_lookup_filldir(struct dir_context *ctx, const char *name, int nl
 #define AFS_LOOKUP ((filldir_t)0x137UL)
 static int afs_create(struct mnt_idmap *idmap, struct inode *dir,
 		      struct dentry *dentry, umode_t mode);
-static struct dentry *afs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *afs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				struct dentry *dentry, umode_t mode);
 static int afs_rmdir(struct inode *dir, struct dentry *dentry);
 static int afs_unlink(struct inode *dir, struct dentry *dentry);
@@ -1310,7 +1310,7 @@ static const struct afs_operation_ops afs_mkdir_operation = {
 /*
  * create a directory on an AFS filesystem
  */
-static struct dentry *afs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *afs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				struct dentry *dentry, umode_t mode)
 {
 	struct afs_operation *op;
diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 3158df448025..c6de44473d6d 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -16,7 +16,7 @@ static int autofs_dir_symlink(struct mnt_idmap *, struct inode *,
 			      struct dentry *, const char *);
 static int autofs_dir_unlink(struct inode *, struct dentry *);
 static int autofs_dir_rmdir(struct inode *, struct dentry *);
-static struct dentry *autofs_dir_mkdir(struct mnt_idmap *, struct inode *,
+static struct dentry *autofs_dir_mkdir(const struct mnt_idmap *, struct inode *,
 				       struct dentry *, umode_t);
 static long autofs_root_ioctl(struct file *, unsigned int, unsigned long);
 #ifdef CONFIG_COMPAT
@@ -724,7 +724,7 @@ static int autofs_dir_rmdir(struct inode *dir, struct dentry *dentry)
 	return 0;
 }
 
-static struct dentry *autofs_dir_mkdir(struct mnt_idmap *idmap,
+static struct dentry *autofs_dir_mkdir(const struct mnt_idmap *idmap,
 				       struct inode *dir, struct dentry *dentry,
 				       umode_t mode)
 {
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index c5c76e9dcf82..f0c56db22223 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -58,7 +58,7 @@ static int bad_inode_symlink(struct mnt_idmap *idmap,
 	return -EIO;
 }
 
-static struct dentry *bad_inode_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *bad_inode_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				      struct dentry *dentry, umode_t mode)
 {
 	return ERR_PTR(-EIO);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e77c791f6efa..dc7e4b68410c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7115,7 +7115,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	return ret;
 }
 
-static struct dentry *btrfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *btrfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				  struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 864b6949fb9f..dd75d4c0a11e 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1106,7 +1106,7 @@ static int ceph_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	return err;
 }
 
-static struct dentry *ceph_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *ceph_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				 struct dentry *dentry, umode_t mode)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index a888a7ef30e5..3a2fa1e13ef8 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -166,7 +166,7 @@ static int coda_create(struct mnt_idmap *idmap, struct inode *dir,
 	return error;
 }
 
-static struct dentry *coda_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *coda_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				 struct dentry *de, umode_t mode)
 {
 	struct inode *inode;
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 3c88f13f1ca2..e0ca643db1ac 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1286,7 +1286,7 @@ int configfs_depend_item_unlocked(struct configfs_subsystem *caller_subsys,
 }
 EXPORT_SYMBOL(configfs_depend_item_unlocked);
 
-static struct dentry *configfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *configfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				     struct dentry *dentry, umode_t mode)
 {
 	int ret = 0;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 7f5396e27752..f5340d2b42f4 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -503,7 +503,7 @@ static int ecryptfs_symlink(struct mnt_idmap *idmap,
 	return rc;
 }
 
-static struct dentry *ecryptfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *ecryptfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				     struct dentry *dentry, umode_t mode)
 {
 	int rc;
diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 863a8c506fe8..4accf96ea7f9 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -825,7 +825,7 @@ static int exfat_unlink(struct inode *dir, struct dentry *dentry)
 	return err;
 }
 
-static struct dentry *exfat_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *exfat_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				  struct dentry *dentry, umode_t mode)
 {
 	struct super_block *sb = dir->i_sb;
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 19e298533699..0b66e7d37464 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -223,7 +223,7 @@ static int ext2_link (struct dentry * old_dentry, struct inode * dir,
 	return err;
 }
 
-static struct dentry *ext2_mkdir(struct mnt_idmap * idmap,
+static struct dentry *ext2_mkdir(const struct mnt_idmap * idmap,
 				 struct inode * dir, struct dentry * dentry,
 				 umode_t mode)
 {
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1fbc2efe23ba..4c0ce31c3ce8 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2994,7 +2994,7 @@ int ext4_init_new_dir(handle_t *handle, struct inode *dir,
 	return err;
 }
 
-static struct dentry *ext4_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *ext4_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				 struct dentry *dentry, umode_t mode)
 {
 	handle_t *handle;
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 87b588b1d34f..c888f02d89fe 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -751,7 +751,7 @@ static int f2fs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	goto out;
 }
 
-static struct dentry *f2fs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *f2fs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				 struct dentry *dentry, umode_t mode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 1af607cf47cf..9ee899391f4f 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -345,7 +345,7 @@ static int msdos_rmdir(struct inode *dir, struct dentry *dentry)
 }
 
 /***** Make a directory */
-static struct dentry *msdos_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *msdos_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				  struct dentry *dentry, umode_t mode)
 {
 	struct super_block *sb = dir->i_sb;
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index d0b161f43a8b..a3f3320fe630 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -846,7 +846,7 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 	return err;
 }
 
-static struct dentry *vfat_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *vfat_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				  struct dentry *dentry, umode_t mode)
 {
 	struct super_block *sb = dir->i_sb;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 51ff444dcf94..88da9010b0ce 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1116,7 +1116,7 @@ static int fuse_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 	return err;
 }
 
-static struct dentry *fuse_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *fuse_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				 struct dentry *entry, umode_t mode)
 {
 	struct fuse_mkdir_in inarg;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 0c00fef40af1..6a1d405aa6e9 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1345,7 +1345,7 @@ static int gfs2_symlink(struct mnt_idmap *idmap, struct inode *dir,
  * Returns: the dentry, or ERR_PTR(errno)
  */
 
-static struct dentry *gfs2_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *gfs2_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				 struct dentry *dentry, umode_t mode)
 {
 	unsigned dsize = gfs2_max_stuffed_size(GFS2_I(dir));
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index 2958ca702be2..d60399c62e99 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -213,7 +213,7 @@ static int hfs_create(struct mnt_idmap *idmap, struct inode *dir,
  * in a directory, given the inode for the parent directory and the
  * name (and its length) of the new directory.
  */
-static struct dentry *hfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *hfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index d26b87066bd0..651b9f73b567 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -567,7 +567,7 @@ static int hfsplus_create(struct mnt_idmap *idmap, struct inode *dir,
 	return hfsplus_mknod(&nop_mnt_idmap, dir, dentry, mode, 0);
 }
 
-static struct dentry *hfsplus_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *hfsplus_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				    struct dentry *dentry, umode_t mode)
 {
 	return ERR_PTR(hfsplus_mknod(&nop_mnt_idmap, dir, dentry, mode, 0));
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 9028c9f27730..2eec9ebe1587 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -686,7 +686,7 @@ static int hostfs_symlink(struct mnt_idmap *idmap, struct inode *ino,
 	return err;
 }
 
-static struct dentry *hostfs_mkdir(struct mnt_idmap *idmap, struct inode *ino,
+static struct dentry *hostfs_mkdir(const struct mnt_idmap *idmap, struct inode *ino,
 				   struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index dfa8e5b7311f..280459b00e56 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -19,7 +19,7 @@ static void hpfs_update_directory_times(struct inode *dir)
 	hpfs_write_inode_nolock(dir);
 }
 
-static struct dentry *hpfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *hpfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				 struct dentry *dentry, umode_t mode)
 {
 	const unsigned char *name = dentry->d_name.name;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 0c9cb8d953ab..6298a30e7343 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -967,7 +967,7 @@ static int hugetlbfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	return 0;
 }
 
-static struct dentry *hugetlbfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *hugetlbfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				      struct dentry *dentry, umode_t mode)
 {
 	int retval = hugetlbfs_mknod(idmap, dir, dentry,
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index c56cd87a2a73..b4f808825738 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -33,7 +33,7 @@ static int jffs2_link (struct dentry *,struct inode *,struct dentry *);
 static int jffs2_unlink (struct inode *,struct dentry *);
 static int jffs2_symlink (struct mnt_idmap *, struct inode *,
 			  struct dentry *, const char *);
-static struct dentry *jffs2_mkdir (struct mnt_idmap *, struct inode *,struct dentry *,
+static struct dentry *jffs2_mkdir (const struct mnt_idmap *, struct inode *,struct dentry *,
 				   umode_t);
 static int jffs2_rmdir (struct inode *,struct dentry *);
 static int jffs2_mknod (const struct mnt_idmap *, struct inode *,struct dentry *,
@@ -448,7 +448,7 @@ static int jffs2_symlink (struct mnt_idmap *idmap, struct inode *dir_i,
 }
 
 
-static struct dentry *jffs2_mkdir (struct mnt_idmap *idmap, struct inode *dir_i,
+static struct dentry *jffs2_mkdir (const struct mnt_idmap *idmap, struct inode *dir_i,
 				   struct dentry *dentry, umode_t mode)
 {
 	struct jffs2_inode_info *f, *dir_f;
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index a384ced308af..305eb2cab105 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -193,7 +193,7 @@ static int jfs_create(struct mnt_idmap *idmap, struct inode *dip,
  * note:
  * EACCES: user needs search+write permission on the parent directory
  */
-static struct dentry *jfs_mkdir(struct mnt_idmap *idmap, struct inode *dip,
+static struct dentry *jfs_mkdir(const struct mnt_idmap *idmap, struct inode *dip,
 				struct dentry *dentry, umode_t mode)
 {
 	int rc = 0;
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index d2e978e4ea6f..943d6ee3e505 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1288,7 +1288,7 @@ static struct dentry *kernfs_iop_lookup(struct inode *dir,
 	return d_splice_alias(inode, dentry);
 }
 
-static struct dentry *kernfs_iop_mkdir(struct mnt_idmap *idmap,
+static struct dentry *kernfs_iop_mkdir(const struct mnt_idmap *idmap,
 				       struct inode *dir, struct dentry *dentry,
 				       umode_t mode)
 {
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index f7aaa19eeac0..abf4575f24b1 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -104,7 +104,7 @@ static int minix_link(struct dentry * old_dentry, struct inode * dir,
 	return add_nondir(dentry, inode);
 }
 
-static struct dentry *minix_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *minix_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				  struct dentry *dentry, umode_t mode)
 {
 	struct inode * inode;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 1161c809c9f1..dfa9dab7fdcc 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2475,7 +2475,7 @@ EXPORT_SYMBOL_GPL(nfs_mknod);
 /*
  * See comments for nfs_proc_create regarding failed operations.
  */
-struct dentry *nfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+struct dentry *nfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 			 struct dentry *dentry, umode_t mode)
 {
 	struct iattr attr;
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index c7928c16352d..da6db93b1730 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -398,7 +398,7 @@ struct dentry *nfs_lookup(struct inode *, struct dentry *, unsigned int);
 void nfs_d_prune_case_insensitive_aliases(struct inode *inode);
 int nfs_create(struct mnt_idmap *, struct inode *, struct dentry *,
 	       umode_t);
-struct dentry *nfs_mkdir(struct mnt_idmap *, struct inode *, struct dentry *,
+struct dentry *nfs_mkdir(const struct mnt_idmap *, struct inode *, struct dentry *,
 			 umode_t);
 int nfs_rmdir(struct inode *, struct dentry *);
 int nfs_unlink(struct inode *, struct dentry *);
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index bfc7c4a06743..b21fd2d8cb4a 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -218,7 +218,7 @@ static int nilfs_link(struct dentry *old_dentry, struct inode *dir,
 	return err;
 }
 
-static struct dentry *nilfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *nilfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				  struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index 431ab27472ab..cbefeabe81b3 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -1049,7 +1049,7 @@ static int ntfs_unlink(struct inode *dir, struct dentry *dentry)
 	return err;
 }
 
-static struct dentry *ntfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *ntfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 		struct dentry *dentry, umode_t mode)
 {
 	struct super_block *sb = dir->i_sb;
diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index 0d9c8bf79947..db02a2fb69c1 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -228,7 +228,7 @@ static int ntfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 /*
  * ntfs_mkdir - inode_operations::mkdir
  */
-static struct dentry *ntfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *ntfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				 struct dentry *dentry, umode_t mode)
 {
 	return ERR_PTR(ntfs_create_inode(idmap, dir, dentry, NULL,
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 53df5dd10ad0..5e544d8ded42 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -402,7 +402,7 @@ static struct inode *dlmfs_get_inode(struct inode *parent,
  * File creation. Allocate an inode, and we're done..
  */
 /* SMP-safe */
-static struct dentry *dlmfs_mkdir(struct mnt_idmap * idmap,
+static struct dentry *dlmfs_mkdir(const struct mnt_idmap * idmap,
 				  struct inode * dir,
 				  struct dentry * dentry,
 				  umode_t mode)
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 05c007213fab..89ac6fae34f8 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -655,7 +655,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 				    suballoc_loc, suballoc_bit);
 }
 
-static struct dentry *ocfs2_mkdir(struct mnt_idmap *idmap,
+static struct dentry *ocfs2_mkdir(const struct mnt_idmap *idmap,
 				  struct inode *dir,
 				  struct dentry *dentry,
 				  umode_t mode)
diff --git a/fs/omfs/dir.c b/fs/omfs/dir.c
index 99e0a7c8e03b..a476675e8e61 100644
--- a/fs/omfs/dir.c
+++ b/fs/omfs/dir.c
@@ -279,7 +279,7 @@ static int omfs_add_node(struct inode *dir, struct dentry *dentry, umode_t mode)
 	return err;
 }
 
-static struct dentry *omfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *omfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				 struct dentry *dentry, umode_t mode)
 {
 	return ERR_PTR(omfs_add_node(dir, dentry, mode));
diff --git a/fs/orangefs/namei.c b/fs/orangefs/namei.c
index 40105ce80bb8..749dfc0735a6 100644
--- a/fs/orangefs/namei.c
+++ b/fs/orangefs/namei.c
@@ -296,7 +296,7 @@ static int orangefs_symlink(struct mnt_idmap *idmap,
 	return ret;
 }
 
-static struct dentry *orangefs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *orangefs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				     struct dentry *dentry, umode_t mode)
 {
 	struct orangefs_inode_s *parent = ORANGEFS_I(dir);
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index cb2b5a8d28bd..6e206220a97f 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -736,7 +736,7 @@ static int ovl_create(struct mnt_idmap *idmap, struct inode *dir,
 	return ovl_create_object(idmap, dentry, (mode & 07777) | S_IFREG, 0, NULL);
 }
 
-static struct dentry *ovl_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *ovl_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				struct dentry *dentry, umode_t mode)
 {
 	return ERR_PTR(ovl_create_object(idmap, dentry, (mode & 07777) | S_IFDIR, 0, NULL));
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 5b09860dc69b..363093354a90 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -118,7 +118,7 @@ ramfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	return error;
 }
 
-static struct dentry *ramfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *ramfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				 struct dentry *dentry, umode_t mode)
 {
 	int retval = ramfs_mknod(&nop_mnt_idmap, dir, dentry, mode, 0);
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index e50edcbb2cd3..908f65001578 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -66,7 +66,7 @@ int cifs_hardlink(struct dentry *old_file, struct inode *inode,
 		  struct dentry *direntry);
 int cifs_mknod(const struct mnt_idmap *idmap, struct inode *inode,
 	       struct dentry *direntry, umode_t mode, dev_t device_number);
-struct dentry *cifs_mkdir(struct mnt_idmap *idmap, struct inode *inode,
+struct dentry *cifs_mkdir(const struct mnt_idmap *idmap, struct inode *inode,
 			  struct dentry *direntry, umode_t mode);
 int cifs_rmdir(struct inode *inode, struct dentry *direntry);
 int cifs_rename2(const struct mnt_idmap *idmap, struct inode *source_dir,
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index eec3a46f6e41..e3610e456bd4 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2276,7 +2276,7 @@ cifs_posix_mkdir(struct inode *inode, struct dentry *dentry, umode_t mode,
 }
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 
-struct dentry *cifs_mkdir(struct mnt_idmap *idmap, struct inode *inode,
+struct dentry *cifs_mkdir(const struct mnt_idmap *idmap, struct inode *inode,
 			  struct dentry *direntry, umode_t mode)
 {
 	int rc = 0;
diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 7cf32384ad50..995b8d0f8d33 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -94,7 +94,7 @@ static struct tracefs_dir_ops {
 	int (*rmdir)(const char *name);
 } tracefs_ops __ro_after_init;
 
-static struct dentry *tracefs_syscall_mkdir(struct mnt_idmap *idmap,
+static struct dentry *tracefs_syscall_mkdir(const struct mnt_idmap *idmap,
 					    struct inode *inode, struct dentry *dentry,
 					    umode_t mode)
 {
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index bff6489c4a5c..c7723f80e258 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1002,7 +1002,7 @@ static int ubifs_rmdir(struct inode *dir, struct dentry *dentry)
 	return err;
 }
 
-static struct dentry *ubifs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *ubifs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				  struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 3fe746911581..7ee11e527377 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -419,7 +419,7 @@ static int udf_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	return udf_add_nondir(dentry, inode);
 }
 
-static struct dentry *udf_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *udf_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index 951c92d37d56..4aee6c3d0f75 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -165,7 +165,7 @@ static int ufs_link (struct dentry * old_dentry, struct inode * dir,
 	return error;
 }
 
-static struct dentry *ufs_mkdir(struct mnt_idmap * idmap, struct inode * dir,
+static struct dentry *ufs_mkdir(const struct mnt_idmap * idmap, struct inode * dir,
 				struct dentry * dentry, umode_t mode)
 {
 	struct inode * inode;
diff --git a/fs/vboxsf/dir.c b/fs/vboxsf/dir.c
index 81b92c6cb201..851e4be5eb0d 100644
--- a/fs/vboxsf/dir.c
+++ b/fs/vboxsf/dir.c
@@ -303,7 +303,7 @@ static int vboxsf_dir_mkfile(struct mnt_idmap *idmap,
 	return vboxsf_dir_create(parent, dentry, mode, false, true, NULL);
 }
 
-static struct dentry *vboxsf_dir_mkdir(struct mnt_idmap *idmap,
+static struct dentry *vboxsf_dir_mkdir(const struct mnt_idmap *idmap,
 				       struct inode *parent, struct dentry *dentry,
 				       umode_t mode)
 {
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 26f9eb41599d..495c7f3dece0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -300,7 +300,7 @@ xfs_vn_create(
 
 STATIC struct dentry *
 xfs_vn_mkdir(
-	struct mnt_idmap	*idmap,
+	const struct mnt_idmap	*idmap,
 	struct inode		*dir,
 	struct dentry		*dentry,
 	umode_t			mode)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2f2a0088e693..b02ae54727cb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2005,7 +2005,7 @@ struct inode_operations {
 	int (*unlink) (struct inode *,struct dentry *);
 	int (*symlink) (struct mnt_idmap *, struct inode *,struct dentry *,
 			const char *);
-	struct dentry *(*mkdir) (struct mnt_idmap *, struct inode *,
+	struct dentry *(*mkdir) (const struct mnt_idmap *, struct inode *,
 				 struct dentry *, umode_t);
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (const struct mnt_idmap *, struct inode *,struct dentry *,
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 11174037a9ca..871825d36c8c 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -176,7 +176,7 @@ static void bpf_dentry_finalize(struct dentry *dentry, struct inode *inode,
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 }
 
-static struct dentry *bpf_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *bpf_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
diff --git a/mm/shmem.c b/mm/shmem.c
index ab5b2cd34c28..e76359582406 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3885,7 +3885,7 @@ shmem_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 	return error;
 }
 
-static struct dentry *shmem_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *shmem_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
 				  struct dentry *dentry, umode_t mode)
 {
 	int error;
diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 5b42140e12e8..d1386722537d 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -2073,7 +2073,7 @@ int __aafs_profile_mkdir(struct aa_profile *profile, struct dentry *parent)
 	return error;
 }
 
-static struct dentry *ns_mkdir_op(struct mnt_idmap *idmap, struct inode *dir,
+static struct dentry *ns_mkdir_op(const struct mnt_idmap *idmap, struct inode *dir,
 				  struct dentry *dentry, umode_t mode)
 {
 	struct aa_ns *ns, *parent;

-- 
2.53.0

