Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D184A47DD5F;
	Tue,  1 Sep 2026 12:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264991; cv=none; b=UVBnKt3R/R4HTN41NgHb/gBW/1+CR9A3vHEHge0Vg/Bs2j7/vRwgwcMb1GRFR5OKsV8r+qo/T17+YIAsPCJvey87sRdhNbb0ofjNJGrWCMk6+6R5WmclREvQeX7SISv6zHn1+MKEKOfpeELx4dXIHmgYJAVyKOQc+at8vo47xLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264991; c=relaxed/simple;
	bh=9xh6g8jzcNxj9eqjORZE9yydYrlqSNznQza217OZ3zI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=u5rJIcL/v/jbi6h8chOBl+cWdu22WyllRs34DHuExxHPq3tGP3EWU3VkPTGQbCxuwGQNTO+Ek4wOZffr209Ippli77J2P3/akrmNh+pozS518TC1z/14I8WzYdsSdg7VgAJx2Ecygs1FqRImLU0IpEfDX9PA0FOIgdWsHzLP8eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VF4bWHaa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VF4bWHaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9D81F00A3D;
	Tue,  1 Sep 2026 12:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264989;
	bh=NZSFtHj0Axk1gAWw5x/nDwUicF7gMDlFWj55TTRveEk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VF4bWHaa+7Hy0mmdOg1Hbn27lhWg5jR2sJQRBOtgEtqNo4We/7Tfv/tAFJhA34u3L
	 8gxYHti7erEe8cQAQe8J8pbBwwXKWT9Ld8Ax8CziMtJ99KDkwmn6NhyUmug07F/14G
	 dAZj3vQCzEg0igfvBq0gr+Ubhp0xDl5c+aJSRHh+vidbkCEs+uz8LxZlHh3j3p2y4R
	 sTObi/zLzhBovK2fWp3PF3j+oGWEi/7LSmAk+8Y9MX/ZxSHJerEKwJLIGPx6k5mqmH
	 sUkquL8Lg+H5C1vlUBGQ7zaLh3E09MXua/ccoFy6yNPAnsJ/+BZV3U0N1UzysDH7UB
	 B7l2hAnU8LNxQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:46 +0200
Subject: [PATCH 21/27] fs: port ->symlink() to pass const mnt_idmap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-21-54ccd48e100b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=28396; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9xh6g8jzcNxj9eqjORZE9yydYrlqSNznQza217OZ3zI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7juHYuywcuVkZ/r3Kf8/XxKbCtTVID4qd3x77Jub
 rurzMin11HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAnCRHob/7j2Xb2x+unVe4/Q2
 pznqHPLBxn9bU5NV0vcIeh+5uTN3OyPDnyXBNW/NmSTecilNPf7iFdONX5MmHmUo8u/sf3Toyv8
 SNgA=
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
 fs/configfs/configfs_internal.h       | 2 +-
 fs/configfs/symlink.c                 | 2 +-
 fs/ecryptfs/inode.c                   | 2 +-
 fs/ext2/namei.c                       | 2 +-
 fs/ext4/namei.c                       | 2 +-
 fs/f2fs/namei.c                       | 2 +-
 fs/fuse/dir.c                         | 2 +-
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
 fs/orangefs/namei.c                   | 2 +-
 fs/overlayfs/dir.c                    | 2 +-
 fs/ramfs/inode.c                      | 2 +-
 fs/smb/client/cifsfs.h                | 2 +-
 fs/smb/client/link.c                  | 2 +-
 fs/ubifs/dir.c                        | 2 +-
 fs/udf/namei.c                        | 2 +-
 fs/ufs/namei.c                        | 2 +-
 fs/vboxsf/dir.c                       | 2 +-
 fs/xfs/xfs_iops.c                     | 2 +-
 include/linux/fs.h                    | 2 +-
 kernel/bpf/inode.c                    | 2 +-
 mm/shmem.c                            | 2 +-
 46 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index e0851f1859b3..856b9cc88c76 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -65,7 +65,7 @@ prototypes::
 	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
 	int (*unlink) (struct inode *,struct dentry *);
-	int (*symlink) (struct mnt_idmap *, struct inode *,struct dentry *,const char *);
+	int (*symlink) (const struct mnt_idmap *, struct inode *,struct dentry *,const char *);
 	struct dentry *(*mkdir) (const struct mnt_idmap *, struct inode *,struct dentry *,umode_t);
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (const struct mnt_idmap *, struct inode *,struct dentry *,umode_t,dev_t);
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index b16105a81cfe..5a9203e98bb6 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -419,7 +419,7 @@ As of kernel 2.6.22, the following members are defined:
 		struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
 		int (*link) (struct dentry *,struct inode *,struct dentry *);
 		int (*unlink) (struct inode *,struct dentry *);
-		int (*symlink) (struct mnt_idmap *, struct inode *,struct dentry *,const char *);
+		int (*symlink) (const struct mnt_idmap *, struct inode *,struct dentry *,const char *);
 		struct dentry *(*mkdir) (const struct mnt_idmap *, struct inode *,struct dentry *,umode_t);
 		int (*rmdir) (struct inode *,struct dentry *);
 		int (*mknod) (const struct mnt_idmap *, struct inode *,struct dentry *,umode_t,dev_t);
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index a448e9a9a014..cc52c244bb95 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1249,7 +1249,7 @@ static int v9fs_vfs_mkspecial(struct inode *dir, struct dentry *dentry,
  */
 
 static int
-v9fs_vfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
+v9fs_vfs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 		 struct dentry *dentry, const char *symname)
 {
 	p9_debug(P9_DEBUG_VFS, " %llu,%pd,%s\n",
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 3c21006203d2..ec58718eec4a 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -682,7 +682,7 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode,
 }
 
 static int
-v9fs_vfs_symlink_dotl(struct mnt_idmap *idmap, struct inode *dir,
+v9fs_vfs_symlink_dotl(const struct mnt_idmap *idmap, struct inode *dir,
 		      struct dentry *dentry, const char *symname)
 {
 	int err;
diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 3dd795ce446e..b1047766a829 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -173,7 +173,7 @@ extern struct dentry *affs_mkdir(const struct mnt_idmap *idmap, struct inode *di
 extern int	affs_rmdir(struct inode *dir, struct dentry *dentry);
 extern int	affs_link(struct dentry *olddentry, struct inode *dir,
 			  struct dentry *dentry);
-extern int	affs_symlink(struct mnt_idmap *idmap,
+extern int	affs_symlink(const struct mnt_idmap *idmap,
 			struct inode *dir, struct dentry *dentry,
 			const char *symname);
 extern int	affs_rename2(const struct mnt_idmap *idmap,
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index d17f0ba7c33c..1d609355fc3f 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -313,7 +313,7 @@ affs_rmdir(struct inode *dir, struct dentry *dentry)
 }
 
 int
-affs_symlink(struct mnt_idmap *idmap, struct inode *dir,
+affs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 	     struct dentry *dentry, const char *symname)
 {
 	struct super_block	*sb = dir->i_sb;
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 6a3cac50dc61..603dd9323ed2 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -41,7 +41,7 @@ static int afs_rmdir(struct inode *dir, struct dentry *dentry);
 static int afs_unlink(struct inode *dir, struct dentry *dentry);
 static int afs_link(struct dentry *from, struct inode *dir,
 		    struct dentry *dentry);
-static int afs_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int afs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 		       struct dentry *dentry, const char *content);
 static int afs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 		      struct dentry *old_dentry, struct inode *new_dir,
@@ -1779,7 +1779,7 @@ static const struct afs_operation_ops afs_symlink_operation = {
 /*
  * create a symlink in an AFS filesystem
  */
-static int afs_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int afs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 		       struct dentry *dentry, const char *content)
 {
 	struct afs_operation *op;
diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index c6de44473d6d..28f38f5d0236 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -12,7 +12,7 @@
 #include "autofs_i.h"
 
 static int autofs_dir_permission(const struct mnt_idmap *, struct inode *, int);
-static int autofs_dir_symlink(struct mnt_idmap *, struct inode *,
+static int autofs_dir_symlink(const struct mnt_idmap *, struct inode *,
 			      struct dentry *, const char *);
 static int autofs_dir_unlink(struct inode *, struct dentry *);
 static int autofs_dir_rmdir(struct inode *, struct dentry *);
@@ -572,7 +572,7 @@ static int autofs_dir_permission(const struct mnt_idmap *idmap,
 	return generic_permission(idmap, inode, mask);
 }
 
-static int autofs_dir_symlink(struct mnt_idmap *idmap,
+static int autofs_dir_symlink(const struct mnt_idmap *idmap,
 			      struct inode *dir, struct dentry *dentry,
 			      const char *symname)
 {
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index f0c56db22223..096e6afb5e07 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -51,7 +51,7 @@ static int bad_inode_unlink(struct inode *dir, struct dentry *dentry)
 	return -EIO;
 }
 
-static int bad_inode_symlink(struct mnt_idmap *idmap,
+static int bad_inode_symlink(const struct mnt_idmap *idmap,
 			     struct inode *dir, struct dentry *dentry,
 			     const char *symname)
 {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dc7e4b68410c..9b5e3a67122d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9023,7 +9023,7 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
 	return ret;
 }
 
-static int btrfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int btrfs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 			 struct dentry *dentry, const char *symname)
 {
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(dir);
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index dd75d4c0a11e..5417a9948e98 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1032,7 +1032,7 @@ static int prep_encrypted_symlink_target(struct ceph_mds_request *req,
 }
 #endif
 
-static int ceph_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int ceph_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 			struct dentry *dentry, const char *dest)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 3a2fa1e13ef8..02b8259b6a0e 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -233,7 +233,7 @@ static int coda_link(struct dentry *source_de, struct inode *dir_inode,
 }
 
 
-static int coda_symlink(struct mnt_idmap *idmap,
+static int coda_symlink(const struct mnt_idmap *idmap,
 			struct inode *dir_inode, struct dentry *de,
 			const char *symname)
 {
diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index acdeea8e2d69..63d70dc05444 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -90,7 +90,7 @@ extern const struct inode_operations configfs_root_inode_operations;
 extern const struct inode_operations configfs_symlink_inode_operations;
 extern const struct dentry_operations configfs_dentry_ops;
 
-extern int configfs_symlink(struct mnt_idmap *idmap,
+extern int configfs_symlink(const struct mnt_idmap *idmap,
 			    struct inode *dir, struct dentry *dentry,
 			    const char *symname);
 extern int configfs_unlink(struct inode *dir, struct dentry *dentry);
diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 31eb28b27309..a07c346817f5 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -132,7 +132,7 @@ static int get_target(const char *symname, struct config_item **target,
 }
 
 
-int configfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
+int configfs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 		     struct dentry *dentry, const char *symname)
 {
 	int ret;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index f5340d2b42f4..f9a3c88c4fbd 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -462,7 +462,7 @@ static int ecryptfs_unlink(struct inode *dir, struct dentry *dentry)
 	return ecryptfs_do_unlink(dir, dentry, d_inode(dentry));
 }
 
-static int ecryptfs_symlink(struct mnt_idmap *idmap,
+static int ecryptfs_symlink(const struct mnt_idmap *idmap,
 			    struct inode *dir, struct dentry *dentry,
 			    const char *symname)
 {
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 0b66e7d37464..7da42f071eab 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -152,7 +152,7 @@ static int ext2_mknod (const struct mnt_idmap * idmap, struct inode * dir,
 	return err;
 }
 
-static int ext2_symlink (struct mnt_idmap * idmap, struct inode * dir,
+static int ext2_symlink (const struct mnt_idmap * idmap, struct inode * dir,
 	struct dentry * dentry, const char * symname)
 {
 	struct super_block * sb = dir->i_sb;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 4c0ce31c3ce8..6e493b4d205f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3360,7 +3360,7 @@ static int ext4_init_symlink_block(handle_t *handle, struct inode *inode,
 	return err;
 }
 
-static int ext4_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int ext4_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 			struct dentry *dentry, const char *symname)
 {
 	handle_t *handle;
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index c888f02d89fe..b2e99822d8b4 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -662,7 +662,7 @@ static const char *f2fs_get_link(struct dentry *dentry,
 	return link;
 }
 
-static int f2fs_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int f2fs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 			struct dentry *dentry, const char *symname)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 88da9010b0ce..3d8246ff061e 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1146,7 +1146,7 @@ static struct dentry *fuse_mkdir(const struct mnt_idmap *idmap, struct inode *di
 	return create_new_entry(idmap, fm, &args, dir, entry, S_IFDIR);
 }
 
-static int fuse_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int fuse_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 			struct dentry *entry, const char *link)
 {
 	struct fuse_mount *fm = get_fuse_mount(dir);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 6a1d405aa6e9..c8f2b01e8cf5 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1323,7 +1323,7 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
  * Returns: errno
  */
 
-static int gfs2_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int gfs2_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 			struct dentry *dentry, const char *symname)
 {
 	unsigned int size;
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 651b9f73b567..1b59ddb6d1e1 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -460,7 +460,7 @@ static int hfsplus_rmdir(struct inode *dir, struct dentry *dentry)
 	return res;
 }
 
-static int hfsplus_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int hfsplus_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 			   struct dentry *dentry, const char *symname)
 {
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(dir->i_sb);
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 2eec9ebe1587..ef03763aa074 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -673,7 +673,7 @@ static int hostfs_unlink(struct inode *ino, struct dentry *dentry)
 	return err;
 }
 
-static int hostfs_symlink(struct mnt_idmap *idmap, struct inode *ino,
+static int hostfs_symlink(const struct mnt_idmap *idmap, struct inode *ino,
 			  struct dentry *dentry, const char *to)
 {
 	char *file;
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index 280459b00e56..44a7fb797633 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -289,7 +289,7 @@ static int hpfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	return err;
 }
 
-static int hpfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int hpfs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 			struct dentry *dentry, const char *symlink)
 {
 	const unsigned char *name = dentry->d_name.name;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 6298a30e7343..9e937602b2ec 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -998,7 +998,7 @@ static int hugetlbfs_tmpfile(const struct mnt_idmap *idmap,
 	return finish_open_simple(file, 0);
 }
 
-static int hugetlbfs_symlink(struct mnt_idmap *idmap,
+static int hugetlbfs_symlink(const struct mnt_idmap *idmap,
 			     struct inode *dir, struct dentry *dentry,
 			     const char *symname)
 {
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index b4f808825738..7d23be0bab72 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -31,7 +31,7 @@ static struct dentry *jffs2_lookup (struct inode *,struct dentry *,
 				    unsigned int);
 static int jffs2_link (struct dentry *,struct inode *,struct dentry *);
 static int jffs2_unlink (struct inode *,struct dentry *);
-static int jffs2_symlink (struct mnt_idmap *, struct inode *,
+static int jffs2_symlink (const struct mnt_idmap *, struct inode *,
 			  struct dentry *, const char *);
 static struct dentry *jffs2_mkdir (const struct mnt_idmap *, struct inode *,struct dentry *,
 				   umode_t);
@@ -284,7 +284,7 @@ static int jffs2_link (struct dentry *old_dentry, struct inode *dir_i, struct de
 
 /***********************************************************************/
 
-static int jffs2_symlink (struct mnt_idmap *idmap, struct inode *dir_i,
+static int jffs2_symlink (const struct mnt_idmap *idmap, struct inode *dir_i,
 			  struct dentry *dentry, const char *target)
 {
 	struct jffs2_inode_info *f, *dir_f;
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 305eb2cab105..6009d65ab53f 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -876,7 +876,7 @@ static int jfs_link(struct dentry *old_dentry,
  * an intermediate result whose length exceeds PATH_MAX [XPG4.2]
 */
 
-static int jfs_symlink(struct mnt_idmap *idmap, struct inode *dip,
+static int jfs_symlink(const struct mnt_idmap *idmap, struct inode *dip,
 		       struct dentry *dentry, const char *name)
 {
 	int rc;
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index abf4575f24b1..11b66a25e92b 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -69,7 +69,7 @@ static int minix_create(struct mnt_idmap *idmap, struct inode *dir,
 	return minix_mknod(&nop_mnt_idmap, dir, dentry, mode, 0);
 }
 
-static int minix_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int minix_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 			 struct dentry *dentry, const char *symname)
 {
 	int i = strlen(symname)+1;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index dfa9dab7fdcc..a917c008a05a 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2641,7 +2641,7 @@ EXPORT_SYMBOL_GPL(nfs_unlink);
  * now have a new file handle and can instantiate an in-core NFS inode
  * and move the raw page into its mapping.
  */
-int nfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
+int nfs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 		struct dentry *dentry, const char *symname)
 {
 	struct folio *folio;
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index da6db93b1730..4c966dac7f7d 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -402,7 +402,7 @@ struct dentry *nfs_mkdir(const struct mnt_idmap *, struct inode *, struct dentry
 			 umode_t);
 int nfs_rmdir(struct inode *, struct dentry *);
 int nfs_unlink(struct inode *, struct dentry *);
-int nfs_symlink(struct mnt_idmap *, struct inode *, struct dentry *,
+int nfs_symlink(const struct mnt_idmap *, struct inode *, struct dentry *,
 		const char *);
 int nfs_link(struct dentry *, struct inode *, struct dentry *);
 int nfs_mknod(const struct mnt_idmap *, struct inode *, struct dentry *, umode_t,
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index b21fd2d8cb4a..8762fdc16c05 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -138,7 +138,7 @@ nilfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	return err;
 }
 
-static int nilfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int nilfs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 			 struct dentry *dentry, const char *symname)
 {
 	struct nilfs_transaction_info ti;
diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index cbefeabe81b3..637bc3690844 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -1399,7 +1399,7 @@ static int ntfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 	return err;
 }
 
-static int ntfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int ntfs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 		struct dentry *dentry, const char *symname)
 {
 	struct super_block *sb = dir->i_sb;
diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index db02a2fb69c1..289796da6ba5 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -209,7 +209,7 @@ static int ntfs_unlink(struct inode *dir, struct dentry *dentry)
 /*
  * ntfs_symlink - inode_operations::symlink
  */
-static int ntfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int ntfs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 			struct dentry *dentry, const char *symname)
 {
 	u32 size = strlen(symname);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 89ac6fae34f8..dfa2cb2bcb12 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1815,7 +1815,7 @@ static int ocfs2_create_symlink_data(struct ocfs2_super *osb,
 	return status;
 }
 
-static int ocfs2_symlink(struct mnt_idmap *idmap,
+static int ocfs2_symlink(const struct mnt_idmap *idmap,
 			 struct inode *dir,
 			 struct dentry *dentry,
 			 const char *symname)
diff --git a/fs/orangefs/namei.c b/fs/orangefs/namei.c
index 749dfc0735a6..f5deb8cdbf2f 100644
--- a/fs/orangefs/namei.c
+++ b/fs/orangefs/namei.c
@@ -211,7 +211,7 @@ static int orangefs_unlink(struct inode *dir, struct dentry *dentry)
 	return ret;
 }
 
-static int orangefs_symlink(struct mnt_idmap *idmap,
+static int orangefs_symlink(const struct mnt_idmap *idmap,
 		         struct inode *dir,
 			 struct dentry *dentry,
 			 const char *symname)
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 6e206220a97f..f7a3fd3a25b9 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -752,7 +752,7 @@ static int ovl_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	return ovl_create_object(idmap, dentry, mode, rdev, NULL);
 }
 
-static int ovl_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int ovl_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 		       struct dentry *dentry, const char *link)
 {
 	return ovl_create_object(idmap, dentry, S_IFLNK, 0, link);
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 363093354a90..cc06d806b214 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -133,7 +133,7 @@ static int ramfs_create(struct mnt_idmap *idmap, struct inode *dir,
 	return ramfs_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFREG, 0);
 }
 
-static int ramfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int ramfs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 			 struct dentry *dentry, const char *symname)
 {
 	struct inode *inode;
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 908f65001578..483d2b23fc23 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -129,7 +129,7 @@ struct vfsmount *cifs_d_automount(struct path *path);
 /* Functions related to symlinks */
 const char *cifs_get_link(struct dentry *dentry, struct inode *inode,
 			  struct delayed_call *done);
-int cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
+int cifs_symlink(const struct mnt_idmap *idmap, struct inode *inode,
 		 struct dentry *direntry, const char *symname);
 
 #ifdef CONFIG_CIFS_XATTR
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 8d5d6aca742a..76df31abeaea 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -533,7 +533,7 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
 }
 
 int
-cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
+cifs_symlink(const struct mnt_idmap *idmap, struct inode *inode,
 	     struct dentry *direntry, const char *symname)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index c7723f80e258..d784283d427f 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1170,7 +1170,7 @@ static int ubifs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	return err;
 }
 
-static int ubifs_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int ubifs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 			 struct dentry *dentry, const char *symname)
 {
 	struct inode *inode;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 7ee11e527377..002e79052f92 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -567,7 +567,7 @@ static int udf_unlink(struct inode *dir, struct dentry *dentry)
 	return ret;
 }
 
-static int udf_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int udf_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 		       struct dentry *dentry, const char *symname)
 {
 	struct inode *inode;
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index 4aee6c3d0f75..9231a5cda08e 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -105,7 +105,7 @@ static int ufs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	return err;
 }
 
-static int ufs_symlink (struct mnt_idmap * idmap, struct inode * dir,
+static int ufs_symlink (const struct mnt_idmap * idmap, struct inode * dir,
 	struct dentry * dentry, const char * symname)
 {
 	struct super_block * sb = dir->i_sb;
diff --git a/fs/vboxsf/dir.c b/fs/vboxsf/dir.c
index 851e4be5eb0d..9db16e90f670 100644
--- a/fs/vboxsf/dir.c
+++ b/fs/vboxsf/dir.c
@@ -425,7 +425,7 @@ static int vboxsf_dir_rename(const struct mnt_idmap *idmap,
 	return err;
 }
 
-static int vboxsf_dir_symlink(struct mnt_idmap *idmap,
+static int vboxsf_dir_symlink(const struct mnt_idmap *idmap,
 			      struct inode *parent, struct dentry *dentry,
 			      const char *symname)
 {
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 495c7f3dece0..fe388619a138 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -425,7 +425,7 @@ xfs_vn_unlink(
 
 STATIC int
 xfs_vn_symlink(
-	struct mnt_idmap	*idmap,
+	const struct mnt_idmap	*idmap,
 	struct inode		*dir,
 	struct dentry		*dentry,
 	const char		*symname)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b02ae54727cb..f2c7838644c3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2003,7 +2003,7 @@ struct inode_operations {
 		       umode_t);
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
 	int (*unlink) (struct inode *,struct dentry *);
-	int (*symlink) (struct mnt_idmap *, struct inode *,struct dentry *,
+	int (*symlink) (const struct mnt_idmap *, struct inode *,struct dentry *,
 			const char *);
 	struct dentry *(*mkdir) (const struct mnt_idmap *, struct inode *,
 				 struct dentry *, umode_t);
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 871825d36c8c..c6f328e4752e 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -424,7 +424,7 @@ bpf_lookup(struct inode *dir, struct dentry *dentry, unsigned flags)
 	return simple_lookup(dir, dentry, flags);
 }
 
-static int bpf_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int bpf_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 		       struct dentry *dentry, const char *target)
 {
 	struct inode *inode;
diff --git a/mm/shmem.c b/mm/shmem.c
index e76359582406..f633af032a08 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4047,7 +4047,7 @@ static int shmem_rename2(const struct mnt_idmap *idmap,
 	return 0;
 }
 
-static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
+static int shmem_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 			 struct dentry *dentry, const char *symname)
 {
 	int error;

-- 
2.53.0

