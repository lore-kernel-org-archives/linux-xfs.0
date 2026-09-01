Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C3747CC75;
	Tue,  1 Sep 2026 12:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264982; cv=none; b=usBdXcyX1XFG4ivxWKlK/e/+FvoKqk71a2Mm4AOumD6aWh/UixROFRGLZIUuy4vPB6yDOv5FHD4zQW4/J8kTIWn9ro8KLsC5dETz7n7y/PqNBY+FEqGNJLG1Yf6imfIvbsO10tWfrRHHeA7WDG/1hmIJgdx2kc+48BRF3CXKqhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264982; c=relaxed/simple;
	bh=GhdthHsUtL1413InhlXP0kh48FcJh7t3akAKEapwlhk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CcJkDfnqjVKW7++trFLrLIScD1MQhB85QxgCq/GuOeQ8p2nOvVCsrJDnHt0iTpo+TARsRN/1azTq31LkJOVTfusETWps0qmUTfL/V4X3ZqsTBO0vkzdH1lZv6DwtlFbQ7Pq08/1VqjOEz8oH9K/x1g4c4ZN08GtEP8s87elBLu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fJ/PuwVJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fJ/PuwVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0913C1F00ACA;
	Tue,  1 Sep 2026 12:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264979;
	bh=UzQvhDE9NYTcJkZHVUdMr01IFoThCOaH3F2Tr9Gdycg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fJ/PuwVJWBpawNycf6T3mSVGuNobaIwEzgYo3oV2NwJBexEN7EcXb/6gKE+AKmoDu
	 lMEwdJtWBNvn2EMZXrx/hmDtL9Vkvl7Hgl24U2LvLVRPMM5IaIKqgc7JUZmL0KBHxa
	 T3EYS+oImkBs72uThTKMBTiveM87xhqpvBBR+roEHcHIPrFaxG5qNq0o6U28sTJZIE
	 VWKmoSmYioqL9SmFdIO7/JJvuEYvn/L9wUrhq5jpGWsDMkTsQ9UUl8EnnGMqt+mBdt
	 pIoBH2oNXbiqEERYEY+0dTb0/RA3XJaCjUIMK4tUEhzuZvAuDaT0Iq8W8l2jGi6ELA
	 Rwy0yTHXQ0yzg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:44 +0200
Subject: [PATCH 19/27] fs: port ->rename() to pass const mnt_idmap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-19-54ccd48e100b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=32041; i=brauner@kernel.org;
 h=from:subject:message-id; bh=GhdthHsUtL1413InhlXP0kh48FcJh7t3akAKEapwlhk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7h2YhWzvDqvyXa7zzcN116JmzHr9re4Q/O9F59xE
 OuzS1PV7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIoDPDXynHHOn6/+WMOywf
 N16Td/urcT/frEImtmb21wMpD+1OcjAyLJU49HZnQdCsKDZGxVaGBUuO8dcctPcqT76wrsvhhY4
 FNwA=
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
 Documentation/filesystems/locking.rst  | 2 +-
 Documentation/filesystems/vfs.rst      | 2 +-
 drivers/android/binder/rust_binderfs.c | 2 +-
 drivers/android/binderfs.c             | 2 +-
 fs/9p/v9fs.h                           | 2 +-
 fs/9p/vfs_inode.c                      | 2 +-
 fs/affs/affs.h                         | 2 +-
 fs/affs/namei.c                        | 2 +-
 fs/afs/dir.c                           | 4 ++--
 fs/bad_inode.c                         | 2 +-
 fs/bfs/dir.c                           | 2 +-
 fs/btrfs/inode.c                       | 2 +-
 fs/ceph/dir.c                          | 2 +-
 fs/coda/dir.c                          | 2 +-
 fs/ecryptfs/inode.c                    | 2 +-
 fs/exfat/namei.c                       | 2 +-
 fs/ext2/namei.c                        | 2 +-
 fs/ext4/namei.c                        | 2 +-
 fs/f2fs/namei.c                        | 2 +-
 fs/fat/namei_msdos.c                   | 2 +-
 fs/fat/namei_vfat.c                    | 2 +-
 fs/fuse/dir.c                          | 2 +-
 fs/gfs2/inode.c                        | 2 +-
 fs/hfs/dir.c                           | 2 +-
 fs/hfsplus/dir.c                       | 2 +-
 fs/hostfs/hostfs_kern.c                | 2 +-
 fs/hpfs/namei.c                        | 2 +-
 fs/jffs2/dir.c                         | 4 ++--
 fs/jfs/namei.c                         | 2 +-
 fs/kernfs/dir.c                        | 2 +-
 fs/libfs.c                             | 2 +-
 fs/minix/namei.c                       | 2 +-
 fs/nfs/dir.c                           | 2 +-
 fs/nfs/internal.h                      | 2 +-
 fs/nilfs2/namei.c                      | 2 +-
 fs/ntfs/namei.c                        | 2 +-
 fs/ntfs3/namei.c                       | 2 +-
 fs/ocfs2/namei.c                       | 2 +-
 fs/omfs/dir.c                          | 2 +-
 fs/orangefs/namei.c                    | 2 +-
 fs/overlayfs/dir.c                     | 2 +-
 fs/smb/client/cifsfs.h                 | 2 +-
 fs/smb/client/inode.c                  | 2 +-
 fs/ubifs/dir.c                         | 2 +-
 fs/udf/namei.c                         | 2 +-
 fs/ufs/namei.c                         | 2 +-
 fs/vboxsf/dir.c                        | 2 +-
 fs/xfs/xfs_iops.c                      | 2 +-
 include/linux/fs.h                     | 4 ++--
 mm/shmem.c                             | 2 +-
 50 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 1cfdad9286d5..97f8aaff311e 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -69,7 +69,7 @@ prototypes::
 	struct dentry *(*mkdir) (struct mnt_idmap *, struct inode *,struct dentry *,umode_t);
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (const struct mnt_idmap *, struct inode *,struct dentry *,umode_t,dev_t);
-	int (*rename) (struct mnt_idmap *, struct inode *, struct dentry *,
+	int (*rename) (const struct mnt_idmap *, struct inode *, struct dentry *,
 			struct inode *, struct dentry *, unsigned int);
 	int (*readlink) (struct dentry *, char __user *,int);
 	const char *(*get_link) (struct dentry *, struct inode *, struct delayed_call *);
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index d7ab34e101eb..90f8a0b74249 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -423,7 +423,7 @@ As of kernel 2.6.22, the following members are defined:
 		struct dentry *(*mkdir) (struct mnt_idmap *, struct inode *,struct dentry *,umode_t);
 		int (*rmdir) (struct inode *,struct dentry *);
 		int (*mknod) (const struct mnt_idmap *, struct inode *,struct dentry *,umode_t,dev_t);
-		int (*rename) (struct mnt_idmap *, struct inode *, struct dentry *,
+		int (*rename) (const struct mnt_idmap *, struct inode *, struct dentry *,
 			       struct inode *, struct dentry *, unsigned int);
 		int (*readlink) (struct dentry *, char __user *,int);
 		const char *(*get_link) (struct dentry *, struct inode *,
diff --git a/drivers/android/binder/rust_binderfs.c b/drivers/android/binder/rust_binderfs.c
index 300cc65562d1..e98e6ca163df 100644
--- a/drivers/android/binder/rust_binderfs.c
+++ b/drivers/android/binder/rust_binderfs.c
@@ -338,7 +338,7 @@ static inline bool is_binderfs_control_device(const struct dentry *dentry)
 	return info->control_dentry == dentry;
 }
 
-static int binderfs_rename(struct mnt_idmap *idmap,
+static int binderfs_rename(const struct mnt_idmap *idmap,
 			   struct inode *old_dir, struct dentry *old_dentry,
 			   struct inode *new_dir, struct dentry *new_dentry,
 			   unsigned int flags)
diff --git a/drivers/android/binderfs.c b/drivers/android/binderfs.c
index 361d69f756f5..087eae6ca8ec 100644
--- a/drivers/android/binderfs.c
+++ b/drivers/android/binderfs.c
@@ -344,7 +344,7 @@ static inline bool is_binderfs_control_device(const struct dentry *dentry)
 	return info->control_dentry == dentry;
 }
 
-static int binderfs_rename(struct mnt_idmap *idmap,
+static int binderfs_rename(const struct mnt_idmap *idmap,
 			   struct inode *old_dir, struct dentry *old_dentry,
 			   struct inode *new_dir, struct dentry *new_dentry,
 			   unsigned int flags)
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index a462bcbfc7da..54a4a4ec5c15 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -188,7 +188,7 @@ extern struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 				      unsigned int flags);
 extern int v9fs_vfs_unlink(struct inode *i, struct dentry *d);
 extern int v9fs_vfs_rmdir(struct inode *i, struct dentry *d);
-extern int v9fs_vfs_rename(struct mnt_idmap *idmap,
+extern int v9fs_vfs_rename(const struct mnt_idmap *idmap,
 			   struct inode *old_dir, struct dentry *old_dentry,
 			   struct inode *new_dir, struct dentry *new_dentry,
 			   unsigned int flags);
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 81fb5f8ec7e9..7d4d5a4481fa 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -858,7 +858,7 @@ int v9fs_vfs_rmdir(struct inode *i, struct dentry *d)
  */
 
 int
-v9fs_vfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+v9fs_vfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		struct dentry *old_dentry, struct inode *new_dir,
 		struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index d1c506c1f310..a4b1e449aafc 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -176,7 +176,7 @@ extern int	affs_link(struct dentry *olddentry, struct inode *dir,
 extern int	affs_symlink(struct mnt_idmap *idmap,
 			struct inode *dir, struct dentry *dentry,
 			const char *symname);
-extern int	affs_rename2(struct mnt_idmap *idmap,
+extern int	affs_rename2(const struct mnt_idmap *idmap,
 			struct inode *old_dir, struct dentry *old_dentry,
 			struct inode *new_dir, struct dentry *new_dentry,
 			unsigned int flags);
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index 6cb52efafe5f..c9cc0ad5c330 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -503,7 +503,7 @@ affs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	return retval;
 }
 
-int affs_rename2(struct mnt_idmap *idmap, struct inode *old_dir,
+int affs_rename2(const struct mnt_idmap *idmap, struct inode *old_dir,
 		 struct dentry *old_dentry, struct inode *new_dir,
 		 struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 81565366d937..fee48c544c61 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -43,7 +43,7 @@ static int afs_link(struct dentry *from, struct inode *dir,
 		    struct dentry *dentry);
 static int afs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		       struct dentry *dentry, const char *content);
-static int afs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+static int afs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		      struct dentry *old_dentry, struct inode *new_dir,
 		      struct dentry *new_dentry, unsigned int flags);
 static int afs_dir_writepages(struct address_space *mapping,
@@ -2067,7 +2067,7 @@ static const struct afs_operation_ops afs_rename_exchange_operation = {
 /*
  * rename a file in an AFS filesystem and/or move it between directories
  */
-static int afs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+static int afs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		      struct dentry *old_dentry, struct inode *new_dir,
 		      struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 9b7baf1367a6..c5c76e9dcf82 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -75,7 +75,7 @@ static int bad_inode_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	return -EIO;
 }
 
-static int bad_inode_rename2(struct mnt_idmap *idmap,
+static int bad_inode_rename2(const struct mnt_idmap *idmap,
 			     struct inode *old_dir, struct dentry *old_dentry,
 			     struct inode *new_dir, struct dentry *new_dentry,
 			     unsigned int flags)
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 91a4871fa051..80534d04db9d 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -199,7 +199,7 @@ static int bfs_unlink(struct inode *dir, struct dentry *dentry)
 	return error;
 }
 
-static int bfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+static int bfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		      struct dentry *old_dentry, struct inode *new_dir,
 		      struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 32b5648fdf81..e77c791f6efa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8835,7 +8835,7 @@ static int btrfs_rename(const struct mnt_idmap *idmap,
 	return ret;
 }
 
-static int btrfs_rename2(struct mnt_idmap *idmap, struct inode *old_dir,
+static int btrfs_rename2(const struct mnt_idmap *idmap, struct inode *old_dir,
 			 struct dentry *old_dentry, struct inode *new_dir,
 			 struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 0f3c54dc97c6..864b6949fb9f 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1478,7 +1478,7 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 	return err;
 }
 
-static int ceph_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+static int ceph_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		       struct dentry *old_dentry, struct inode *new_dir,
 		       struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index e8db5960b61b..a888a7ef30e5 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -300,7 +300,7 @@ static int coda_rmdir(struct inode *dir, struct dentry *de)
 }
 
 /* rename */
-static int coda_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+static int coda_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		       struct dentry *old_dentry, struct inode *new_dir,
 		       struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 411aa024d4b8..7f5396e27752 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -590,7 +590,7 @@ ecryptfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 }
 
 static int
-ecryptfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+ecryptfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		struct dentry *old_dentry, struct inode *new_dir,
 		struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index a4dc83b5949c..863a8c506fe8 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1263,7 +1263,7 @@ static int __exfat_rename(struct inode *old_parent_inode,
 	return ret;
 }
 
-static int exfat_rename(struct mnt_idmap *idmap,
+static int exfat_rename(const struct mnt_idmap *idmap,
 			struct inode *old_dir, struct dentry *old_dentry,
 			struct inode *new_dir, struct dentry *new_dentry,
 			unsigned int flags)
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index f175b59cccd7..19e298533699 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -316,7 +316,7 @@ static int ext2_rmdir (struct inode * dir, struct dentry *dentry)
 	return err;
 }
 
-static int ext2_rename (struct mnt_idmap * idmap,
+static int ext2_rename (const struct mnt_idmap * idmap,
 			struct inode * old_dir, struct dentry * old_dentry,
 			struct inode * new_dir, struct dentry * new_dentry,
 			unsigned int flags)
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index d7a58d82f320..1fbc2efe23ba 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -4191,7 +4191,7 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	return retval;
 }
 
-static int ext4_rename2(struct mnt_idmap *idmap,
+static int ext4_rename2(const struct mnt_idmap *idmap,
 			struct inode *old_dir, struct dentry *old_dentry,
 			struct inode *new_dir, struct dentry *new_dentry,
 			unsigned int flags)
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 0773f64396f8..87b588b1d34f 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1341,7 +1341,7 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	return err;
 }
 
-static int f2fs_rename2(struct mnt_idmap *idmap,
+static int f2fs_rename2(const struct mnt_idmap *idmap,
 			struct inode *old_dir, struct dentry *old_dentry,
 			struct inode *new_dir, struct dentry *new_dentry,
 			unsigned int flags)
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index d46d1a3851f2..1af607cf47cf 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -600,7 +600,7 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 }
 
 /***** Rename, a wrapper for rename_same_dir & rename_diff_dir */
-static int msdos_rename(struct mnt_idmap *idmap,
+static int msdos_rename(const struct mnt_idmap *idmap,
 			struct inode *old_dir, struct dentry *old_dentry,
 			struct inode *new_dir, struct dentry *new_dentry,
 			unsigned int flags)
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index da3e89c0b16a..d0b161f43a8b 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -1160,7 +1160,7 @@ static int vfat_rename_exchange(struct inode *old_dir, struct dentry *old_dentry
 	goto out;
 }
 
-static int vfat_rename2(struct mnt_idmap *idmap, struct inode *old_dir,
+static int vfat_rename2(const struct mnt_idmap *idmap, struct inode *old_dir,
 			struct dentry *old_dentry, struct inode *new_dir,
 			struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 3250598e06f2..51ff444dcf94 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1307,7 +1307,7 @@ static int fuse_rename_common(const struct mnt_idmap *idmap, struct inode *olddi
 	return err;
 }
 
-static int fuse_rename2(struct mnt_idmap *idmap, struct inode *olddir,
+static int fuse_rename2(const struct mnt_idmap *idmap, struct inode *olddir,
 			struct dentry *oldent, struct inode *newdir,
 			struct dentry *newent, unsigned int flags)
 {
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 733f74603eaf..0c00fef40af1 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1877,7 +1877,7 @@ static int gfs2_exchange(struct inode *odir, struct dentry *odentry,
 	return error;
 }
 
-static int gfs2_rename2(struct mnt_idmap *idmap, struct inode *odir,
+static int gfs2_rename2(const struct mnt_idmap *idmap, struct inode *odir,
 			struct dentry *odentry, struct inode *ndir,
 			struct dentry *ndentry, unsigned int flags)
 {
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index e1f1fb351464..2958ca702be2 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -281,7 +281,7 @@ static int hfs_remove(struct inode *dir, struct dentry *dentry)
  * new file/directory.
  * XXX: how do you handle must_be dir?
  */
-static int hfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+static int hfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		      struct dentry *old_dentry, struct inode *new_dir,
 		      struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 7d31211cee97..d26b87066bd0 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -573,7 +573,7 @@ static struct dentry *hfsplus_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	return ERR_PTR(hfsplus_mknod(&nop_mnt_idmap, dir, dentry, mode, 0));
 }
 
-static int hfsplus_rename(struct mnt_idmap *idmap,
+static int hfsplus_rename(const struct mnt_idmap *idmap,
 			  struct inode *old_dir, struct dentry *old_dentry,
 			  struct inode *new_dir, struct dentry *new_dentry,
 			  unsigned int flags)
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 71d15396235a..9028c9f27730 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -745,7 +745,7 @@ static int hostfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	return 0;
 }
 
-static int hostfs_rename2(struct mnt_idmap *idmap,
+static int hostfs_rename2(const struct mnt_idmap *idmap,
 			  struct inode *old_dir, struct dentry *old_dentry,
 			  struct inode *new_dir, struct dentry *new_dentry,
 			  unsigned int flags)
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index ed749e1684d2..dfa8e5b7311f 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -500,7 +500,7 @@ const struct address_space_operations hpfs_symlink_aops = {
 	.read_folio	= hpfs_symlink_read_folio
 };
 
-static int hpfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+static int hpfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		       struct dentry *old_dentry, struct inode *new_dir,
 		       struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 6d4b26d625c7..c56cd87a2a73 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -38,7 +38,7 @@ static struct dentry *jffs2_mkdir (struct mnt_idmap *, struct inode *,struct den
 static int jffs2_rmdir (struct inode *,struct dentry *);
 static int jffs2_mknod (const struct mnt_idmap *, struct inode *,struct dentry *,
 			umode_t,dev_t);
-static int jffs2_rename (struct mnt_idmap *, struct inode *,
+static int jffs2_rename (const struct mnt_idmap *, struct inode *,
 			 struct dentry *, struct inode *, struct dentry *,
 			 unsigned int);
 
@@ -769,7 +769,7 @@ static int jffs2_mknod (const struct mnt_idmap *idmap, struct inode *dir_i,
 	return ret;
 }
 
-static int jffs2_rename (struct mnt_idmap *idmap,
+static int jffs2_rename (const struct mnt_idmap *idmap,
 			 struct inode *old_dir_i, struct dentry *old_dentry,
 			 struct inode *new_dir_i, struct dentry *new_dentry,
 			 unsigned int flags)
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 82a5dbdaf93d..a384ced308af 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1066,7 +1066,7 @@ static int jfs_symlink(struct mnt_idmap *idmap, struct inode *dip,
  *
  * FUNCTION:	rename a file or directory
  */
-static int jfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+static int jfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		      struct dentry *old_dentry, struct inode *new_dir,
 		      struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 82bbaeb326aa..d2e978e4ea6f 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1326,7 +1326,7 @@ static int kernfs_iop_rmdir(struct inode *dir, struct dentry *dentry)
 	return ret;
 }
 
-static int kernfs_iop_rename(struct mnt_idmap *idmap,
+static int kernfs_iop_rename(const struct mnt_idmap *idmap,
 			     struct inode *old_dir, struct dentry *old_dentry,
 			     struct inode *new_dir, struct dentry *new_dentry,
 			     unsigned int flags)
diff --git a/fs/libfs.c b/fs/libfs.c
index 27d7dc16fcb0..8b379230b64f 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -867,7 +867,7 @@ int simple_rename_exchange(struct inode *old_dir, struct dentry *old_dentry,
 }
 EXPORT_SYMBOL_GPL(simple_rename_exchange);
 
-int simple_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+int simple_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		  struct dentry *old_dentry, struct inode *new_dir,
 		  struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 57b3c2c5b688..f7aaa19eeac0 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -187,7 +187,7 @@ static int minix_rmdir(struct inode * dir, struct dentry *dentry)
 	return err;
 }
 
-static int minix_rename(struct mnt_idmap *idmap,
+static int minix_rename(const struct mnt_idmap *idmap,
 			struct inode *old_dir, struct dentry *old_dentry,
 			struct inode *new_dir, struct dentry *new_dentry,
 			unsigned int flags)
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 10c48672a79d..1161c809c9f1 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2771,7 +2771,7 @@ static bool nfs_rename_is_unsafe_cross_dir(struct dentry *old_dentry,
  * If these conditions are met, we can drop the dentries before doing
  * the rename.
  */
-int nfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+int nfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 	       struct dentry *old_dentry, struct inode *new_dir,
 	       struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index ec37568d197b..c7928c16352d 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -407,7 +407,7 @@ int nfs_symlink(struct mnt_idmap *, struct inode *, struct dentry *,
 int nfs_link(struct dentry *, struct inode *, struct dentry *);
 int nfs_mknod(const struct mnt_idmap *, struct inode *, struct dentry *, umode_t,
 	      dev_t);
-int nfs_rename(struct mnt_idmap *, struct inode *, struct dentry *,
+int nfs_rename(const struct mnt_idmap *, struct inode *, struct dentry *,
 	       struct inode *, struct dentry *, unsigned int);
 
 #ifdef CONFIG_NFS_V4_2
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index ea3df1d5ec29..bfc7c4a06743 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -358,7 +358,7 @@ static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
 	return err;
 }
 
-static int nilfs_rename(struct mnt_idmap *idmap,
+static int nilfs_rename(const struct mnt_idmap *idmap,
 			struct inode *old_dir, struct dentry *old_dentry,
 			struct inode *new_dir, struct dentry *new_dentry,
 			unsigned int flags)
diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index 82da5f14efa4..431ab27472ab 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -1248,7 +1248,7 @@ static int __ntfs_link(struct ntfs_inode *ni, struct ntfs_inode *dir_ni,
 	return err;
 }
 
-static int ntfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+static int ntfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		struct dentry *old_dentry, struct inode *new_dir,
 		struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index dfafadcd8fda..0d9c8bf79947 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -262,7 +262,7 @@ static int ntfs_rmdir(struct inode *dir, struct dentry *dentry)
 /*
  * ntfs_rename - inode_operations::rename
  */
-static int ntfs_rename(struct mnt_idmap *idmap, struct inode *dir,
+static int ntfs_rename(const struct mnt_idmap *idmap, struct inode *dir,
 		       struct dentry *dentry, struct inode *new_dir,
 		       struct dentry *new_dentry, u32 flags)
 {
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 6cd77f295939..05c007213fab 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1211,7 +1211,7 @@ static void ocfs2_double_unlock(struct inode *inode1, struct inode *inode2)
 		ocfs2_inode_unlock(inode2, 1);
 }
 
-static int ocfs2_rename(struct mnt_idmap *idmap,
+static int ocfs2_rename(const struct mnt_idmap *idmap,
 			struct inode *old_dir,
 			struct dentry *old_dentry,
 			struct inode *new_dir,
diff --git a/fs/omfs/dir.c b/fs/omfs/dir.c
index 692297cf84e7..99e0a7c8e03b 100644
--- a/fs/omfs/dir.c
+++ b/fs/omfs/dir.c
@@ -370,7 +370,7 @@ static bool omfs_fill_chain(struct inode *dir, struct dir_context *ctx,
 	return true;
 }
 
-static int omfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+static int omfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		       struct dentry *old_dentry, struct inode *new_dir,
 		       struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/orangefs/namei.c b/fs/orangefs/namei.c
index 8ebc34e112d5..40105ce80bb8 100644
--- a/fs/orangefs/namei.c
+++ b/fs/orangefs/namei.c
@@ -364,7 +364,7 @@ static struct dentry *orangefs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	return ret ? ERR_PTR(ret) : NULL;
 }
 
-static int orangefs_rename(struct mnt_idmap *idmap,
+static int orangefs_rename(const struct mnt_idmap *idmap,
 			struct inode *old_dir,
 			struct dentry *old_dentry,
 			struct inode *new_dir,
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 6d4b511dc3ca..cb2b5a8d28bd 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1344,7 +1344,7 @@ static void ovl_rename_end(struct ovl_renamedata *ovlrd)
 		ovl_drop_write(ovlrd->old_dentry);
 }
 
-static int ovl_rename(struct mnt_idmap *idmap, struct inode *olddir,
+static int ovl_rename(const struct mnt_idmap *idmap, struct inode *olddir,
 		      struct dentry *old, struct inode *newdir,
 		      struct dentry *new, unsigned int flags)
 {
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index db7aebb8599e..e50edcbb2cd3 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -69,7 +69,7 @@ int cifs_mknod(const struct mnt_idmap *idmap, struct inode *inode,
 struct dentry *cifs_mkdir(struct mnt_idmap *idmap, struct inode *inode,
 			  struct dentry *direntry, umode_t mode);
 int cifs_rmdir(struct inode *inode, struct dentry *direntry);
-int cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
+int cifs_rename2(const struct mnt_idmap *idmap, struct inode *source_dir,
 		 struct dentry *source_dentry, struct inode *target_dir,
 		 struct dentry *target_dentry, unsigned int flags);
 int cifs_revalidate_file_attr(struct file *filp);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 12ed8db10e00..eec3a46f6e41 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2526,7 +2526,7 @@ cifs_do_rename(const unsigned int xid, struct dentry *from_dentry,
 }
 
 int
-cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
+cifs_rename2(const struct mnt_idmap *idmap, struct inode *source_dir,
 	     struct dentry *source_dentry, struct inode *target_dir,
 	     struct dentry *target_dentry, unsigned int flags)
 {
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 50068515f680..bff6489c4a5c 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1642,7 +1642,7 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	return err;
 }
 
-static int ubifs_rename(struct mnt_idmap *idmap,
+static int ubifs_rename(const struct mnt_idmap *idmap,
 			struct inode *old_dir, struct dentry *old_dentry,
 			struct inode *new_dir, struct dentry *new_dentry,
 			unsigned int flags)
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 4f7200e6046e..3fe746911581 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -762,7 +762,7 @@ static int udf_link(struct dentry *old_dentry, struct inode *dir,
 /* Anybody can rename anything with this: the permission checks are left to the
  * higher-level routines.
  */
-static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+static int udf_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		      struct dentry *old_dentry, struct inode *new_dir,
 		      struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index a38975b3885e..951c92d37d56 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -240,7 +240,7 @@ static int ufs_rmdir (struct inode * dir, struct dentry *dentry)
 	return err;
 }
 
-static int ufs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
+static int ufs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		      struct dentry *old_dentry, struct inode *new_dir,
 		      struct dentry *new_dentry, unsigned int flags)
 {
diff --git a/fs/vboxsf/dir.c b/fs/vboxsf/dir.c
index 0b9eab157432..81b92c6cb201 100644
--- a/fs/vboxsf/dir.c
+++ b/fs/vboxsf/dir.c
@@ -382,7 +382,7 @@ static int vboxsf_dir_unlink(struct inode *parent, struct dentry *dentry)
 	return 0;
 }
 
-static int vboxsf_dir_rename(struct mnt_idmap *idmap,
+static int vboxsf_dir_rename(const struct mnt_idmap *idmap,
 			     struct inode *old_parent,
 			     struct dentry *old_dentry,
 			     struct inode *new_parent,
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 13e57b0e7cae..26f9eb41599d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -466,7 +466,7 @@ xfs_vn_symlink(
 
 STATIC int
 xfs_vn_rename(
-	struct mnt_idmap	*idmap,
+	const struct mnt_idmap	*idmap,
 	struct inode		*odir,
 	struct dentry		*odentry,
 	struct inode		*ndir,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4ca59a110d17..2f2a0088e693 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2010,7 +2010,7 @@ struct inode_operations {
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (const struct mnt_idmap *, struct inode *,struct dentry *,
 		      umode_t,dev_t);
-	int (*rename) (struct mnt_idmap *, struct inode *, struct dentry *,
+	int (*rename) (const struct mnt_idmap *, struct inode *, struct dentry *,
 			struct inode *, struct dentry *, unsigned int);
 	int (*setattr) (struct mnt_idmap *, struct dentry *, struct iattr *);
 	int (*getattr) (struct mnt_idmap *, const struct path *,
@@ -3276,7 +3276,7 @@ void simple_rename_timestamp(struct inode *old_dir, struct dentry *old_dentry,
 			     struct inode *new_dir, struct dentry *new_dentry);
 extern int simple_rename_exchange(struct inode *old_dir, struct dentry *old_dentry,
 				  struct inode *new_dir, struct dentry *new_dentry);
-extern int simple_rename(struct mnt_idmap *, struct inode *,
+extern int simple_rename(const struct mnt_idmap *, struct inode *,
 			 struct dentry *, struct inode *, struct dentry *,
 			 unsigned int);
 extern void simple_recursive_removal(struct dentry *,
diff --git a/mm/shmem.c b/mm/shmem.c
index 16a4ea914bdb..ab5b2cd34c28 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3991,7 +3991,7 @@ static int shmem_whiteout(const struct mnt_idmap *idmap,
  * it exists so that the VFS layer correctly free's it when it
  * gets overwritten.
  */
-static int shmem_rename2(struct mnt_idmap *idmap,
+static int shmem_rename2(const struct mnt_idmap *idmap,
 			 struct inode *old_dir, struct dentry *old_dentry,
 			 struct inode *new_dir, struct dentry *new_dentry,
 			 unsigned int flags)

-- 
2.53.0

