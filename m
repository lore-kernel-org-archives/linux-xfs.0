Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 835B529E19
	for <xfs@oss.sgi.com>; Fri, 20 Dec 2013 07:25:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 12E52AC00C
	for <xfs@oss.sgi.com>; Fri, 20 Dec 2013 05:25:34 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id BgqnQWH5y382xTme (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Dec 2013 05:25:32 -0800 (PST)
Message-Id: <20131220132522.224436375@bombadil.infradead.org>
Date: Fri, 20 Dec 2013 05:16:42 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/21] fs: make posix_acl_create more useful
References: <20131220131635.650823732@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0007-fs-make-posix_acl_create-more-useful.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: viro@zeniv.linux.org.uk
Cc: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>, xfs@oss.sgi.com, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, Joel Becker <jlbec@evilplan.org>, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org

Rename the current posix_acl_created to __posix_acl_create and add
a fully featured helper to set up the ACLs on file creation that
uses get_acl().

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/9p/acl.c               |    2 +-
 fs/btrfs/acl.c            |    2 +-
 fs/ext2/acl.c             |    2 +-
 fs/ext3/acl.c             |    2 +-
 fs/ext4/acl.c             |    2 +-
 fs/f2fs/acl.c             |    2 +-
 fs/generic_acl.c          |    2 +-
 fs/gfs2/acl.c             |    2 +-
 fs/hfsplus/posix_acl.c    |    2 +-
 fs/jffs2/acl.c            |    2 +-
 fs/jfs/acl.c              |    2 +-
 fs/nfs/nfs3acl.c          |    2 +-
 fs/ocfs2/acl.c            |    2 +-
 fs/posix_acl.c            |   57 +++++++++++++++++++++++++++++++++++++++++----
 fs/reiserfs/xattr_acl.c   |    2 +-
 fs/xfs/xfs_acl.c          |    4 ++--
 include/linux/posix_acl.h |    8 ++++---
 17 files changed, 74 insertions(+), 23 deletions(-)

diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index f5ce5c5..8482f2d 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -200,7 +200,7 @@ int v9fs_acl_mode(struct inode *dir, umode_t *modep,
 	if (acl) {
 		if (S_ISDIR(mode))
 			*dpacl = posix_acl_dup(acl);
-		retval = posix_acl_create(&acl, GFP_NOFS, &mode);
+		retval = __posix_acl_create(&acl, GFP_NOFS, &mode);
 		if (retval < 0)
 			return retval;
 		if (retval > 0)
diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 1af04ff..b56519d 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -222,7 +222,7 @@ int btrfs_init_acl(struct btrfs_trans_handle *trans,
 			if (ret)
 				goto failed;
 		}
-		ret = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
+		ret = __posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
 		if (ret < 0)
 			return ret;
 
diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
index 7006ced..6e842a7 100644
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -268,7 +268,7 @@ ext2_init_acl(struct inode *inode, struct inode *dir)
 			if (error)
 				goto cleanup;
 		}
-		error = posix_acl_create(&acl, GFP_KERNEL, &inode->i_mode);
+		error = __posix_acl_create(&acl, GFP_KERNEL, &inode->i_mode);
 		if (error < 0)
 			return error;
 		if (error > 0) {
diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index 6691a6c..4f3d8fa 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -271,7 +271,7 @@ ext3_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
 			if (error)
 				goto cleanup;
 		}
-		error = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
+		error = __posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
 		if (error < 0)
 			return error;
 
diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 2eebe02..f827f3b 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -276,7 +276,7 @@ ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
 			if (error)
 				goto cleanup;
 		}
-		error = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
+		error = __posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
 		if (error < 0)
 			return error;
 
diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index 14c4df0..45e8430 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -285,7 +285,7 @@ int f2fs_init_acl(struct inode *inode, struct inode *dir, struct page *ipage)
 		if (error)
 			goto cleanup;
 	}
-	error = posix_acl_create(&acl, GFP_KERNEL, &inode->i_mode);
+	error = __posix_acl_create(&acl, GFP_KERNEL, &inode->i_mode);
 	if (error < 0)
 		return error;
 	if (error > 0)
diff --git a/fs/generic_acl.c b/fs/generic_acl.c
index 46a5076..4357f39 100644
--- a/fs/generic_acl.c
+++ b/fs/generic_acl.c
@@ -128,7 +128,7 @@ generic_acl_init(struct inode *inode, struct inode *dir)
 	if (acl) {
 		if (S_ISDIR(inode->i_mode))
 			set_cached_acl(inode, ACL_TYPE_DEFAULT, acl);
-		error = posix_acl_create(&acl, GFP_KERNEL, &inode->i_mode);
+		error = __posix_acl_create(&acl, GFP_KERNEL, &inode->i_mode);
 		if (error < 0)
 			return error;
 		if (error > 0)
diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index 3e200c7..e82e4ac 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -131,7 +131,7 @@ int gfs2_acl_create(struct gfs2_inode *dip, struct inode *inode)
 			goto out;
 	}
 
-	error = posix_acl_create(&acl, GFP_NOFS, &mode);
+	error = __posix_acl_create(&acl, GFP_NOFS, &mode);
 	if (error < 0)
 		return error;
 
diff --git a/fs/hfsplus/posix_acl.c b/fs/hfsplus/posix_acl.c
index cab5fd6..277942f 100644
--- a/fs/hfsplus/posix_acl.c
+++ b/fs/hfsplus/posix_acl.c
@@ -137,7 +137,7 @@ int hfsplus_init_posix_acl(struct inode *inode, struct inode *dir)
 				goto init_acl_cleanup;
 		}
 
-		err = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
+		err = __posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
 		if (unlikely(err < 0))
 			return err;
 
diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 5853969..4d6e31b 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -295,7 +295,7 @@ int jffs2_init_acl_pre(struct inode *dir_i, struct inode *inode, umode_t *i_mode
 		if (S_ISDIR(*i_mode))
 			set_cached_acl(inode, ACL_TYPE_DEFAULT, acl);
 
-		rc = posix_acl_create(&acl, GFP_KERNEL, i_mode);
+		rc = __posix_acl_create(&acl, GFP_KERNEL, i_mode);
 		if (rc < 0)
 			return rc;
 		if (rc > 0)
diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
index 9c0fca8..28d529a 100644
--- a/fs/jfs/acl.c
+++ b/fs/jfs/acl.c
@@ -132,7 +132,7 @@ int jfs_init_acl(tid_t tid, struct inode *inode, struct inode *dir)
 			if (rc)
 				goto cleanup;
 		}
-		rc = posix_acl_create(&acl, GFP_KERNEL, &inode->i_mode);
+		rc = __posix_acl_create(&acl, GFP_KERNEL, &inode->i_mode);
 		if (rc < 0)
 			goto cleanup; /* posix_acl_release(NULL) is no-op */
 		if (rc > 0)
diff --git a/fs/nfs/nfs3acl.c b/fs/nfs/nfs3acl.c
index 4a1aafb..e859675 100644
--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -428,7 +428,7 @@ int nfs3_proc_set_default_acl(struct inode *dir, struct inode *inode,
 	if (!dfacl)
 		return 0;
 	acl = posix_acl_dup(dfacl);
-	error = posix_acl_create(&acl, GFP_KERNEL, &mode);
+	error = __posix_acl_create(&acl, GFP_KERNEL, &mode);
 	if (error < 0)
 		goto out_release_dfacl;
 	error = nfs3_proc_setacls(inode, acl, S_ISDIR(inode->i_mode) ?
diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 73ccf0e..c0f9d2f 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -401,7 +401,7 @@ int ocfs2_init_acl(handle_t *handle,
 				goto cleanup;
 		}
 		mode = inode->i_mode;
-		ret = posix_acl_create(&acl, GFP_NOFS, &mode);
+		ret = __posix_acl_create(&acl, GFP_NOFS, &mode);
 		if (ret < 0)
 			return ret;
 
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 6952970..00844a3 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -409,7 +409,7 @@ static int __posix_acl_chmod_masq(struct posix_acl *acl, umode_t mode)
 }
 
 int
-posix_acl_create(struct posix_acl **acl, gfp_t gfp, umode_t *mode_p)
+__posix_acl_create(struct posix_acl **acl, gfp_t gfp, umode_t *mode_p)
 {
 	struct posix_acl *clone = posix_acl_clone(*acl, gfp);
 	int err = -ENOMEM;
@@ -424,7 +424,7 @@ posix_acl_create(struct posix_acl **acl, gfp_t gfp, umode_t *mode_p)
 	*acl = clone;
 	return err;
 }
-EXPORT_SYMBOL(posix_acl_create);
+EXPORT_SYMBOL(__posix_acl_create);
 
 int
 __posix_acl_chmod(struct posix_acl **acl, gfp_t gfp, umode_t mode)
@@ -445,7 +445,7 @@ __posix_acl_chmod(struct posix_acl **acl, gfp_t gfp, umode_t mode)
 EXPORT_SYMBOL(__posix_acl_chmod);
 
 int
-posix_acl_chmod(struct inode *inode)
+posix_acl_chmod(struct inode *inode, umode_t mode)
 {
 	struct posix_acl *acl;
 	int ret = 0;
@@ -459,7 +459,7 @@ posix_acl_chmod(struct inode *inode)
 	if (IS_ERR_OR_NULL(acl))
 		return PTR_ERR(acl);
 
-	ret = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+	ret = __posix_acl_chmod(&acl, GFP_KERNEL, mode);
 	if (ret)
 		return ret;
 	ret = inode->i_op->set_acl(inode, acl, ACL_TYPE_ACCESS);
@@ -468,6 +468,55 @@ posix_acl_chmod(struct inode *inode)
 }
 EXPORT_SYMBOL(posix_acl_chmod);
 
+int
+posix_acl_create(struct inode *dir, umode_t *mode,
+		struct posix_acl **default_acl, struct posix_acl **acl)
+{
+	struct posix_acl *p;
+	int ret;
+
+	if (S_ISLNK(*mode) || !IS_POSIXACL(dir))
+		goto no_acl;
+
+	p = get_acl(dir, ACL_TYPE_DEFAULT);
+	if (IS_ERR(p))
+		return PTR_ERR(p);
+
+	if (!p) {
+		*mode &= ~current_umask();
+		goto no_acl;
+	}
+
+	*acl = posix_acl_clone(p, GFP_NOFS);
+	if (!*acl)
+		return -ENOMEM;
+
+	ret = posix_acl_create_masq(*acl, mode);
+	if (ret < 0) {
+		posix_acl_release(*acl);
+		return -ENOMEM;
+	}
+
+	if (ret == 0) {
+		posix_acl_release(*acl);
+		*acl = NULL;
+	}
+
+	if (!S_ISDIR(*mode)) {
+		posix_acl_release(p);
+		*default_acl = NULL;
+	} else {
+		*default_acl = p;
+	}
+	return 0;
+
+no_acl:
+	*default_acl = NULL;
+	*acl = NULL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(posix_acl_create);
+
 /*
  * Fix up the uids and gids in posix acl extended attributes in place.
  */
diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index ea4e443..d95c959 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -378,7 +378,7 @@ reiserfs_inherit_default_acl(struct reiserfs_transaction_handle *th,
 
 		/* Now we reconcile the new ACL and the mode,
 		   potentially modifying both */
-		err = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
+		err = __posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
 		if (err < 0)
 			return err;
 
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 4eac105..057ae2d 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -297,12 +297,12 @@ xfs_inherit_acl(struct inode *inode, struct posix_acl *acl)
 			goto out;
 	}
 
-	error = posix_acl_create(&acl, GFP_KERNEL, &mode);
+	error = __posix_acl_create(&acl, GFP_KERNEL, &mode);
 	if (error < 0)
 		return error;
 
 	/*
-	 * If posix_acl_create returns a positive value we need to
+	 * If __posix_acl_create returns a positive value we need to
 	 * inherit a permission that can't be represented using the Unix
 	 * mode bits and we actually need to set an ACL.
 	 */
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 8b64e78..2e40aae 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -88,14 +88,16 @@ extern int posix_acl_valid(const struct posix_acl *);
 extern int posix_acl_permission(struct inode *, const struct posix_acl *, int);
 extern struct posix_acl *posix_acl_from_mode(umode_t, gfp_t);
 extern int posix_acl_equiv_mode(const struct posix_acl *, umode_t *);
-extern int posix_acl_create(struct posix_acl **, gfp_t, umode_t *);
+extern int __posix_acl_create(struct posix_acl **, gfp_t, umode_t *);
 extern int __posix_acl_chmod(struct posix_acl **, gfp_t, umode_t);
 
 extern struct posix_acl *get_posix_acl(struct inode *, int);
 extern int set_posix_acl(struct inode *, int, struct posix_acl *);
 
 #ifdef CONFIG_FS_POSIX_ACL
-extern int posix_acl_chmod(struct inode *);
+extern int posix_acl_chmod(struct inode *, umode_t);
+extern int posix_acl_create(struct inode *, umode_t *, struct posix_acl **,
+		struct posix_acl **);
 
 static inline struct posix_acl **acl_by_type(struct inode *inode, int type)
 {
@@ -174,7 +176,7 @@ static inline void cache_no_acl(struct inode *inode)
 	inode->i_default_acl = NULL;
 }
 #else
-static inline int posix_acl_chmod(struct inode *inode)
+static inline int posix_acl_chmod(struct inode *inode, umode_t mode)
 {
 	return 0;
 }
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
