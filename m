Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D494F485CC3;
	Tue,  1 Sep 2026 12:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264977; cv=none; b=bWdC4i+rDSPOxtBXIfoNHK6XYydDEARmD8/MjzyMOAsr9KAxjO03NNu5fnj5n9tXXPh9R8lZLqrRyEhpgIa3uOAK1Xf0MAcCYCoW4GNJQ0K8CQsUYPIFsPjYK8VFesj28HH4wUNeYEVSHPMZ2vdNSvpCRIUaiaA9woi+XqpPvuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264977; c=relaxed/simple;
	bh=YzOHXkY2tlEm7yN6+JN7QqgwpGpgZjXhRN0ypMClH5E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=I5pWGVjDk/dy+wB4fXz1QfU4x902pU8m1SzAmWHX9E9IVNCwBRo6nUh1dqRImrUwuQcCo1oFWXQKH6McIrkarVekn99ZK1GCsH78rCGfEwc3Uz8hKbdJ9NoaTTxCYEaQZZxK9D3ol+HiEiraquieoWd+6Z9ayM/+iYo5YewIR7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BYKasO1x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BYKasO1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B271F00A3D;
	Tue,  1 Sep 2026 12:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264974;
	bh=dnd0QJYTrAfooU99QRFJNcH7l/ZO+HRFzG0/3caoU0g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BYKasO1xhGRkUO+mpnZUVaIwd+BQy+n477iSWTYKy4WjkT906dTvc3xWf2LyehcAV
	 CGDymT4xvkeSptUOaIK0mrsbkqW4B1fHq/Syow5Gso7OdneU+z/xrw8I7anCJsdc2Y
	 KDeA1FJRFWXSeyv1aaquMMmG3AjfNPLyPaIacbSYec9MibN+aCxRrXJtw0EiCEFHti
	 M4RNvsotCDPseAqAyQ/SFpV584U70sW2EAPok6I45SIjBx6NDSAfpBdOmmlCzG+SGr
	 hD9elRqerOAFWUa/tCy8cTwHitSDk8vdyltBZpIhiO3qos+XbgHZNX0yA8Mk9676Xm
	 6medTQtzqtikg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:43 +0200
Subject: [PATCH 18/27] fs: port ->mknod() to pass const mnt_idmap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-18-54ccd48e100b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=27017; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YzOHXkY2tlEm7yN6+JN7QqgwpGpgZjXhRN0ypMClH5E=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7iW786584vnO8z53Cql9tftkrBhwSvG1BP2bz//O
 FXKHNdzuKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiy7wY/se16HNIZsuc+Nfx
 Ifvlca1nl4qcIvKPveY5w7fdp+XTdX2Gv5LZh6xmqSyoZ9XRFqkSCpErT48UkeM+sXkZ4xGOU4e
 z+AA=
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
 fs/9p/vfs_inode_dotl.c                | 4 ++--
 fs/bad_inode.c                        | 2 +-
 fs/btrfs/inode.c                      | 2 +-
 fs/ceph/dir.c                         | 2 +-
 fs/ecryptfs/inode.c                   | 2 +-
 fs/ext2/namei.c                       | 2 +-
 fs/ext4/namei.c                       | 2 +-
 fs/f2fs/namei.c                       | 2 +-
 fs/fuse/dir.c                         | 4 ++--
 fs/gfs2/inode.c                       | 2 +-
 fs/hfsplus/dir.c                      | 2 +-
 fs/hostfs/hostfs_kern.c               | 2 +-
 fs/hpfs/namei.c                       | 2 +-
 fs/hugetlbfs/inode.c                  | 2 +-
 fs/jffs2/dir.c                        | 4 ++--
 fs/jfs/namei.c                        | 2 +-
 fs/minix/namei.c                      | 2 +-
 fs/nfs/dir.c                          | 2 +-
 fs/nfs/internal.h                     | 2 +-
 fs/nilfs2/namei.c                     | 2 +-
 fs/ntfs/namei.c                       | 2 +-
 fs/ntfs3/namei.c                      | 2 +-
 fs/ocfs2/namei.c                      | 2 +-
 fs/overlayfs/dir.c                    | 2 +-
 fs/ramfs/inode.c                      | 2 +-
 fs/smb/client/cifsfs.h                | 2 +-
 fs/smb/client/dir.c                   | 2 +-
 fs/ubifs/dir.c                        | 2 +-
 fs/udf/namei.c                        | 2 +-
 fs/ufs/namei.c                        | 2 +-
 fs/xfs/xfs_iops.c                     | 2 +-
 include/linux/fs.h                    | 2 +-
 include/linux/lsm_hook_defs.h         | 2 +-
 include/linux/security.h              | 4 ++--
 mm/shmem.c                            | 4 ++--
 security/integrity/evm/evm_main.c     | 2 +-
 security/integrity/ima/ima_main.c     | 2 +-
 security/security.c                   | 2 +-
 41 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index e4948ddc0a5f..1cfdad9286d5 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -68,7 +68,7 @@ prototypes::
 	int (*symlink) (struct mnt_idmap *, struct inode *,struct dentry *,const char *);
 	struct dentry *(*mkdir) (struct mnt_idmap *, struct inode *,struct dentry *,umode_t);
 	int (*rmdir) (struct inode *,struct dentry *);
-	int (*mknod) (struct mnt_idmap *, struct inode *,struct dentry *,umode_t,dev_t);
+	int (*mknod) (const struct mnt_idmap *, struct inode *,struct dentry *,umode_t,dev_t);
 	int (*rename) (struct mnt_idmap *, struct inode *, struct dentry *,
 			struct inode *, struct dentry *, unsigned int);
 	int (*readlink) (struct dentry *, char __user *,int);
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index e960257ef14a..d7ab34e101eb 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -422,7 +422,7 @@ As of kernel 2.6.22, the following members are defined:
 		int (*symlink) (struct mnt_idmap *, struct inode *,struct dentry *,const char *);
 		struct dentry *(*mkdir) (struct mnt_idmap *, struct inode *,struct dentry *,umode_t);
 		int (*rmdir) (struct inode *,struct dentry *);
-		int (*mknod) (struct mnt_idmap *, struct inode *,struct dentry *,umode_t,dev_t);
+		int (*mknod) (const struct mnt_idmap *, struct inode *,struct dentry *,umode_t,dev_t);
 		int (*rename) (struct mnt_idmap *, struct inode *, struct dentry *,
 			       struct inode *, struct dentry *, unsigned int);
 		int (*readlink) (struct dentry *, char __user *,int);
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 3829554ca369..81fb5f8ec7e9 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1304,7 +1304,7 @@ v9fs_vfs_link(struct dentry *old_dentry, struct inode *dir,
  */
 
 static int
-v9fs_vfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+v9fs_vfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	       struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dir);
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 116b29e95f21..634c4f5665c3 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -29,7 +29,7 @@
 #include "acl.h"
 
 static int
-v9fs_vfs_mknod_dotl(struct mnt_idmap *idmap, struct inode *dir,
+v9fs_vfs_mknod_dotl(const struct mnt_idmap *idmap, struct inode *dir,
 		    struct dentry *dentry, umode_t omode, dev_t rdev);
 
 /**
@@ -809,7 +809,7 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
  *
  */
 static int
-v9fs_vfs_mknod_dotl(struct mnt_idmap *idmap, struct inode *dir,
+v9fs_vfs_mknod_dotl(const struct mnt_idmap *idmap, struct inode *dir,
 		    struct dentry *dentry, umode_t omode, dev_t rdev)
 {
 	int err;
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index d8c0ce62cc63..9b7baf1367a6 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -69,7 +69,7 @@ static int bad_inode_rmdir (struct inode *dir, struct dentry *dentry)
 	return -EIO;
 }
 
-static int bad_inode_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int bad_inode_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 			   struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	return -EIO;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 092057508ae9..32b5648fdf81 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7004,7 +7004,7 @@ static int btrfs_create_common(struct inode *dir, struct dentry *dentry,
 	return ret;
 }
 
-static int btrfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int btrfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 		       struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	struct inode *inode;
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 2e5c0ccb1b34..0f3c54dc97c6 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -921,7 +921,7 @@ int ceph_handle_notrace_create(struct inode *dir, struct dentry *dentry)
 	return PTR_ERR(result);
 }
 
-static int ceph_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int ceph_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 		      struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index bd1187661d6d..411aa024d4b8 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -562,7 +562,7 @@ static int ecryptfs_rmdir(struct inode *dir, struct dentry *dentry)
 }
 
 static int
-ecryptfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+ecryptfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	       struct dentry *dentry, umode_t mode, dev_t dev)
 {
 	int rc;
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 108dc52cedfc..f175b59cccd7 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -131,7 +131,7 @@ static int ext2_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 	return finish_open_simple(file, 0);
 }
 
-static int ext2_mknod (struct mnt_idmap * idmap, struct inode * dir,
+static int ext2_mknod (const struct mnt_idmap * idmap, struct inode * dir,
 	struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	struct inode * inode;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 0bff01fb052a..d7a58d82f320 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2847,7 +2847,7 @@ static int ext4_create(struct mnt_idmap *idmap, struct inode *dir,
 	return err;
 }
 
-static int ext4_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int ext4_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 		      struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	handle_t *handle;
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 3adc2345a204..0773f64396f8 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -810,7 +810,7 @@ static int f2fs_rmdir(struct inode *dir, struct dentry *dentry)
 	return -ENOTEMPTY;
 }
 
-static int f2fs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int f2fs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 		      struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 14dc9318cd57..3250598e06f2 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -934,7 +934,7 @@ static int fuse_create_open(const struct mnt_idmap *idmap, struct inode *dir,
 	return err;
 }
 
-static int fuse_mknod(struct mnt_idmap *, struct inode *, struct dentry *,
+static int fuse_mknod(const struct mnt_idmap *, struct inode *, struct dentry *,
 		      umode_t, dev_t);
 static int fuse_atomic_open(struct inode *dir, struct dentry *entry,
 			    struct file *file, unsigned flags,
@@ -1069,7 +1069,7 @@ static int create_new_nondir(const struct mnt_idmap *idmap, struct fuse_mount *f
 	return PTR_ERR(create_new_entry(idmap, fm, args, dir, entry, mode));
 }
 
-static int fuse_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int fuse_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 		      struct dentry *entry, umode_t mode, dev_t rdev)
 {
 	struct fuse_mknod_in inarg;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 1b1d22abe1d4..733f74603eaf 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1363,7 +1363,7 @@ static struct dentry *gfs2_mkdir(struct mnt_idmap *idmap, struct inode *dir,
  *
  */
 
-static int gfs2_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int gfs2_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 		      struct dentry *dentry, umode_t mode, dev_t dev)
 {
 	return gfs2_create_inode(dir, dentry, NULL, mode, dev, NULL, 0, 0);
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 51fcba2e6d40..7d31211cee97 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -511,7 +511,7 @@ static int hfsplus_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	return res;
 }
 
-static int hfsplus_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int hfsplus_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 			 struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(dir->i_sb);
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 0d5c5f11f913..71d15396235a 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -719,7 +719,7 @@ static int hostfs_rmdir(struct inode *ino, struct dentry *dentry)
 	return err;
 }
 
-static int hostfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int hostfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 			struct dentry *dentry, umode_t mode, dev_t dev)
 {
 	struct inode *inode;
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index 9446f4038874..ed749e1684d2 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -215,7 +215,7 @@ static int hpfs_create(struct mnt_idmap *idmap, struct inode *dir,
 	return err;
 }
 
-static int hpfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int hpfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 		      struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	const unsigned char *name = dentry->d_name.name;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 8a07a3f18c05..0c9cb8d953ab 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -954,7 +954,7 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 /*
  * File creation. Allocate an inode, and we're done..
  */
-static int hugetlbfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int hugetlbfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 			   struct dentry *dentry, umode_t mode, dev_t dev)
 {
 	struct inode *inode;
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 656c920864c5..6d4b26d625c7 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -36,7 +36,7 @@ static int jffs2_symlink (struct mnt_idmap *, struct inode *,
 static struct dentry *jffs2_mkdir (struct mnt_idmap *, struct inode *,struct dentry *,
 				   umode_t);
 static int jffs2_rmdir (struct inode *,struct dentry *);
-static int jffs2_mknod (struct mnt_idmap *, struct inode *,struct dentry *,
+static int jffs2_mknod (const struct mnt_idmap *, struct inode *,struct dentry *,
 			umode_t,dev_t);
 static int jffs2_rename (struct mnt_idmap *, struct inode *,
 			 struct dentry *, struct inode *, struct dentry *,
@@ -620,7 +620,7 @@ static int jffs2_rmdir (struct inode *dir_i, struct dentry *dentry)
 	return ret;
 }
 
-static int jffs2_mknod (struct mnt_idmap *idmap, struct inode *dir_i,
+static int jffs2_mknod (const struct mnt_idmap *idmap, struct inode *dir_i,
 		        struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	struct jffs2_inode_info *f, *dir_f;
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 8a36c218f0f7..82a5dbdaf93d 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1355,7 +1355,7 @@ static int jfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
  *
  * FUNCTION:	Create a special file (device)
  */
-static int jfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int jfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 		     struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	struct jfs_inode_info *jfs_ip;
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 0575dea16a3b..57b3c2c5b688 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -33,7 +33,7 @@ static struct dentry *minix_lookup(struct inode * dir, struct dentry *dentry, un
 	return d_splice_alias(inode, dentry);
 }
 
-static int minix_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int minix_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 		       struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	struct inode *inode;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 7574bc2fb677..10c48672a79d 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2448,7 +2448,7 @@ EXPORT_SYMBOL_GPL(nfs_create);
  * See comments for nfs_proc_create regarding failed operations.
  */
 int
-nfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+nfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	  struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	struct iattr attr;
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index abc81f5ae578..ec37568d197b 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -405,7 +405,7 @@ int nfs_unlink(struct inode *, struct dentry *);
 int nfs_symlink(struct mnt_idmap *, struct inode *, struct dentry *,
 		const char *);
 int nfs_link(struct dentry *, struct inode *, struct dentry *);
-int nfs_mknod(struct mnt_idmap *, struct inode *, struct dentry *, umode_t,
+int nfs_mknod(const struct mnt_idmap *, struct inode *, struct dentry *, umode_t,
 	      dev_t);
 int nfs_rename(struct mnt_idmap *, struct inode *, struct dentry *,
 	       struct inode *, struct dentry *, unsigned int);
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index e037e0c6e31a..ea3df1d5ec29 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -113,7 +113,7 @@ static int nilfs_create(struct mnt_idmap *idmap, struct inode *dir,
 }
 
 static int
-nilfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+nilfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	    struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	struct inode *inode;
diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index e2cf1ab6935a..82da5f14efa4 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -1447,7 +1447,7 @@ static int ntfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	return err;
 }
 
-static int ntfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int ntfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 		struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	struct super_block *sb = dir->i_sb;
diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index ec59bbabd3c5..dfafadcd8fda 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -121,7 +121,7 @@ static int ntfs_create(struct mnt_idmap *idmap, struct inode *dir,
 /*
  * ntfs_mknod - inode_operations::mknod
  */
-static int ntfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int ntfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 		      struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	return ntfs_create_inode(idmap, dir, dentry, NULL, mode, rdev, NULL, 0,
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index e9c7774ccf91..6cd77f295939 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -227,7 +227,7 @@ static void ocfs2_cleanup_add_entry_failure(struct ocfs2_super *osb,
 	iput(inode);
 }
 
-static int ocfs2_mknod(struct mnt_idmap *idmap,
+static int ocfs2_mknod(const struct mnt_idmap *idmap,
 		       struct inode *dir,
 		       struct dentry *dentry,
 		       umode_t mode,
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 4f3f1e2bafff..6d4b511dc3ca 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -742,7 +742,7 @@ static struct dentry *ovl_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	return ERR_PTR(ovl_create_object(idmap, dentry, (mode & 07777) | S_IFDIR, 0, NULL));
 }
 
-static int ovl_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int ovl_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 		     struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	/* Don't allow creation of "whiteout" on overlay */
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index fc9a79af4840..5b09860dc69b 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -95,7 +95,7 @@ struct inode *ramfs_get_inode(struct super_block *sb,
  */
 /* SMP-safe */
 static int
-ramfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+ramfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	    struct dentry *dentry, umode_t mode, dev_t dev)
 {
 	struct inode * inode = ramfs_get_inode(dir->i_sb, dir, mode, dev);
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 255f478d3a18..db7aebb8599e 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -64,7 +64,7 @@ struct dentry *cifs_lookup(struct inode *parent_dir_inode,
 int cifs_unlink(struct inode *dir, struct dentry *dentry);
 int cifs_hardlink(struct dentry *old_file, struct inode *inode,
 		  struct dentry *direntry);
-int cifs_mknod(struct mnt_idmap *idmap, struct inode *inode,
+int cifs_mknod(const struct mnt_idmap *idmap, struct inode *inode,
 	       struct dentry *direntry, umode_t mode, dev_t device_number);
 struct dentry *cifs_mkdir(struct mnt_idmap *idmap, struct inode *inode,
 			  struct dentry *direntry, umode_t mode);
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 56a3e1966257..95da43ad7c02 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -696,7 +696,7 @@ int cifs_create(struct mnt_idmap *idmap, struct inode *dir,
 	return rc;
 }
 
-int cifs_mknod(struct mnt_idmap *idmap, struct inode *inode,
+int cifs_mknod(const struct mnt_idmap *idmap, struct inode *inode,
 	       struct dentry *direntry, umode_t mode, dev_t device_number)
 {
 	int rc = -EPERM;
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 0e1a4de9bb18..50068515f680 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1077,7 +1077,7 @@ static struct dentry *ubifs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	return ERR_PTR(err);
 }
 
-static int ubifs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int ubifs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 		       struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	struct inode *inode;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 8b5873b53324..4f7200e6046e 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -403,7 +403,7 @@ static int udf_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 	return finish_open_simple(file, 0);
 }
 
-static int udf_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int udf_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 		     struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	struct inode *inode;
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index 6703f3bcf76f..a38975b3885e 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -85,7 +85,7 @@ static int ufs_create (struct mnt_idmap * idmap,
 	return ufs_add_nondir(dentry, inode);
 }
 
-static int ufs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+static int ufs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 		     struct dentry *dentry, umode_t mode, dev_t rdev)
 {
 	struct inode *inode;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 06ca999d0927..13e57b0e7cae 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -279,7 +279,7 @@ xfs_generic_create(
 
 STATIC int
 xfs_vn_mknod(
-	struct mnt_idmap	*idmap,
+	const struct mnt_idmap	*idmap,
 	struct inode		*dir,
 	struct dentry		*dentry,
 	umode_t			mode,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 92161c224856..4ca59a110d17 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2008,7 +2008,7 @@ struct inode_operations {
 	struct dentry *(*mkdir) (struct mnt_idmap *, struct inode *,
 				 struct dentry *, umode_t);
 	int (*rmdir) (struct inode *,struct dentry *);
-	int (*mknod) (struct mnt_idmap *, struct inode *,struct dentry *,
+	int (*mknod) (const struct mnt_idmap *, struct inode *,struct dentry *,
 		      umode_t,dev_t);
 	int (*rename) (struct mnt_idmap *, struct inode *, struct dentry *,
 			struct inode *, struct dentry *, unsigned int);
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 470de3fb22c1..ad05971e6137 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -94,7 +94,7 @@ LSM_HOOK(int, 0, path_mkdir, const struct path *dir, struct dentry *dentry,
 LSM_HOOK(int, 0, path_rmdir, const struct path *dir, struct dentry *dentry)
 LSM_HOOK(int, 0, path_mknod, const struct path *dir, struct dentry *dentry,
 	 umode_t mode, unsigned int dev)
-LSM_HOOK(void, LSM_RET_VOID, path_post_mknod, struct mnt_idmap *idmap,
+LSM_HOOK(void, LSM_RET_VOID, path_post_mknod, const struct mnt_idmap *idmap,
 	 struct dentry *dentry)
 LSM_HOOK(int, 0, path_truncate, const struct path *path)
 LSM_HOOK(int, 0, path_symlink, const struct path *dir, struct dentry *dentry,
diff --git a/include/linux/security.h b/include/linux/security.h
index b07a85e6aed4..d4100396da27 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2085,7 +2085,7 @@ int security_path_mkdir(const struct path *dir, struct dentry *dentry, umode_t m
 int security_path_rmdir(const struct path *dir, struct dentry *dentry);
 int security_path_mknod(const struct path *dir, struct dentry *dentry, umode_t mode,
 			unsigned int dev);
-void security_path_post_mknod(struct mnt_idmap *idmap, struct dentry *dentry);
+void security_path_post_mknod(const struct mnt_idmap *idmap, struct dentry *dentry);
 int security_path_truncate(const struct path *path);
 int security_path_symlink(const struct path *dir, struct dentry *dentry,
 			  const char *old_name);
@@ -2120,7 +2120,7 @@ static inline int security_path_mknod(const struct path *dir, struct dentry *den
 	return 0;
 }
 
-static inline void security_path_post_mknod(struct mnt_idmap *idmap,
+static inline void security_path_post_mknod(const struct mnt_idmap *idmap,
 					    struct dentry *dentry)
 { }
 
diff --git a/mm/shmem.c b/mm/shmem.c
index a107940660a8..16a4ea914bdb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3818,7 +3818,7 @@ static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
  * File creation. Allocate an inode, and we're done..
  */
 static int
-shmem_mknod(struct mnt_idmap *idmap, struct inode *dir,
+shmem_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	    struct dentry *dentry, umode_t mode, dev_t dev)
 {
 	struct inode *inode;
@@ -3970,7 +3970,7 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
 	return shmem_unlink(dir, dentry);
 }
 
-static int shmem_whiteout(struct mnt_idmap *idmap,
+static int shmem_whiteout(const struct mnt_idmap *idmap,
 			  struct inode *old_dir, struct dentry *old_dentry)
 {
 	struct dentry *whiteout;
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 94928549bfab..10a0b39dd9b7 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -1140,7 +1140,7 @@ static void evm_file_release(struct file *file)
 		iint->flags &= ~EVM_NEW_FILE;
 }
 
-static void evm_post_path_mknod(struct mnt_idmap *idmap, struct dentry *dentry)
+static void evm_post_path_mknod(const struct mnt_idmap *idmap, struct dentry *dentry)
 {
 	struct inode *inode = d_backing_inode(dentry);
 	struct evm_iint_cache *iint = evm_iint_inode(inode);
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 72ecacda7528..7ac38a98b1f9 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -879,7 +879,7 @@ static void ima_post_create_tmpfile(const struct mnt_idmap *idmap,
  * Mark files created via the mknodat syscall as new, so that the
  * file data can be written later.
  */
-static void ima_post_path_mknod(struct mnt_idmap *idmap, struct dentry *dentry)
+static void ima_post_path_mknod(const struct mnt_idmap *idmap, struct dentry *dentry)
 {
 	struct ima_iint_cache *iint;
 	struct inode *inode = dentry->d_inode;
diff --git a/security/security.c b/security/security.c
index 4e4ef1c496ad..9a3ae6746fb3 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1425,7 +1425,7 @@ EXPORT_SYMBOL(security_path_mknod);
  *
  * Update inode security field after a regular file has been created.
  */
-void security_path_post_mknod(struct mnt_idmap *idmap, struct dentry *dentry)
+void security_path_post_mknod(const struct mnt_idmap *idmap, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
 		return;

-- 
2.53.0

