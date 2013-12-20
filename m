Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 34A1229E10
	for <xfs@oss.sgi.com>; Fri, 20 Dec 2013 07:25:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8E90304093
	for <xfs@oss.sgi.com>; Fri, 20 Dec 2013 05:25:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id P8BAvKPA2URKfWmz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Dec 2013 05:25:33 -0800 (PST)
Message-Id: <20131220132522.037610446@bombadil.infradead.org>
Date: Fri, 20 Dec 2013 05:16:41 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/21] fs: make posix_acl_chmod more useful
References: <20131220131635.650823732@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0006-fs-make-posix_acl_chmod-more-useful.patch
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

Rename the current posix_acl_chmod to __posix_acl_chmod and add
a fully featured ACL chmod helper that uses the ->set_acl inode
operation.

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
 fs/ocfs2/acl.c            |    2 +-
 fs/posix_acl.c            |   30 +++++++++++++++++++++++++++---
 fs/reiserfs/xattr_acl.c   |    2 +-
 fs/xfs/xfs_acl.c          |    2 +-
 include/linux/posix_acl.h |   17 +++++++++++++----
 16 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index 7af425f..f5ce5c5 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -156,7 +156,7 @@ int v9fs_acl_chmod(struct inode *inode, struct p9_fid *fid)
 		return -EOPNOTSUPP;
 	acl = v9fs_get_cached_acl(inode, ACL_TYPE_ACCESS);
 	if (acl) {
-		retval = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+		retval = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
 		if (retval)
 			return retval;
 		set_cached_acl(inode, ACL_TYPE_ACCESS, acl);
diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 0890c83..1af04ff 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -256,7 +256,7 @@ int btrfs_acl_chmod(struct inode *inode)
 	if (IS_ERR_OR_NULL(acl))
 		return PTR_ERR(acl);
 
-	ret = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+	ret = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
 	if (ret)
 		return ret;
 	ret = btrfs_set_acl(NULL, inode, acl, ACL_TYPE_ACCESS);
diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
index 110b6b3..7006ced 100644
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -308,7 +308,7 @@ ext2_acl_chmod(struct inode *inode)
 	acl = ext2_get_acl(inode, ACL_TYPE_ACCESS);
 	if (IS_ERR(acl) || !acl)
 		return PTR_ERR(acl);
-	error = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+	error = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
 	if (error)
 		return error;
 	error = ext2_set_acl(inode, ACL_TYPE_ACCESS, acl);
diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index dbb5ad5..6691a6c 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -314,7 +314,7 @@ ext3_acl_chmod(struct inode *inode)
 	acl = ext3_get_acl(inode, ACL_TYPE_ACCESS);
 	if (IS_ERR(acl) || !acl)
 		return PTR_ERR(acl);
-	error = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+	error = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
 	if (error)
 		return error;
 retry:
diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 39a54a0..2eebe02 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -320,7 +320,7 @@ ext4_acl_chmod(struct inode *inode)
 	acl = ext4_get_acl(inode, ACL_TYPE_ACCESS);
 	if (IS_ERR(acl) || !acl)
 		return PTR_ERR(acl);
-	error = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+	error = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
 	if (error)
 		return error;
 retry:
diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index d0fc287..14c4df0 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -311,7 +311,7 @@ int f2fs_acl_chmod(struct inode *inode)
 	if (IS_ERR(acl) || !acl)
 		return PTR_ERR(acl);
 
-	error = posix_acl_chmod(&acl, GFP_KERNEL, mode);
+	error = __posix_acl_chmod(&acl, GFP_KERNEL, mode);
 	if (error)
 		return error;
 
diff --git a/fs/generic_acl.c b/fs/generic_acl.c
index b3f3676..46a5076 100644
--- a/fs/generic_acl.c
+++ b/fs/generic_acl.c
@@ -158,7 +158,7 @@ generic_acl_chmod(struct inode *inode)
 		return -EOPNOTSUPP;
 	acl = get_cached_acl(inode, ACL_TYPE_ACCESS);
 	if (acl) {
-		error = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+		error = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
 		if (error)
 			return error;
 		set_cached_acl(inode, ACL_TYPE_ACCESS, acl);
diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index f69ac0a..3e200c7 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -162,7 +162,7 @@ int gfs2_acl_chmod(struct gfs2_inode *ip, struct iattr *attr)
 	if (!acl)
 		return gfs2_setattr_simple(inode, attr);
 
-	error = posix_acl_chmod(&acl, GFP_NOFS, attr->ia_mode);
+	error = __posix_acl_chmod(&acl, GFP_NOFS, attr->ia_mode);
 	if (error)
 		return error;
 
diff --git a/fs/hfsplus/posix_acl.c b/fs/hfsplus/posix_acl.c
index b609cc1..cab5fd6 100644
--- a/fs/hfsplus/posix_acl.c
+++ b/fs/hfsplus/posix_acl.c
@@ -167,7 +167,7 @@ int hfsplus_posix_acl_chmod(struct inode *inode)
 	if (IS_ERR(acl) || !acl)
 		return PTR_ERR(acl);
 
-	err = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+	err = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
 	if (unlikely(err))
 		return err;
 
diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 223283c..5853969 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -335,7 +335,7 @@ int jffs2_acl_chmod(struct inode *inode)
 	acl = jffs2_get_acl(inode, ACL_TYPE_ACCESS);
 	if (IS_ERR(acl) || !acl)
 		return PTR_ERR(acl);
-	rc = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+	rc = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
 	if (rc)
 		return rc;
 	rc = jffs2_set_acl(inode, ACL_TYPE_ACCESS, acl);
diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
index d254d6d..9c0fca8 100644
--- a/fs/jfs/acl.c
+++ b/fs/jfs/acl.c
@@ -161,7 +161,7 @@ int jfs_acl_chmod(struct inode *inode)
 	if (IS_ERR(acl) || !acl)
 		return PTR_ERR(acl);
 
-	rc = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+	rc = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
 	if (rc)
 		return rc;
 
diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index b4f788e..73ccf0e 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -350,7 +350,7 @@ int ocfs2_acl_chmod(struct inode *inode)
 	acl = ocfs2_get_acl(inode, ACL_TYPE_ACCESS);
 	if (IS_ERR(acl) || !acl)
 		return PTR_ERR(acl);
-	ret = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+	ret = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
 	if (ret)
 		return ret;
 	ret = ocfs2_set_acl(NULL, inode, NULL, ACL_TYPE_ACCESS,
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 3c0f659..6952970 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -363,7 +363,7 @@ static int posix_acl_create_masq(struct posix_acl *acl, umode_t *mode_p)
 /*
  * Modify the ACL for the chmod syscall.
  */
-static int posix_acl_chmod_masq(struct posix_acl *acl, umode_t mode)
+static int __posix_acl_chmod_masq(struct posix_acl *acl, umode_t mode)
 {
 	struct posix_acl_entry *group_obj = NULL, *mask_obj = NULL;
 	struct posix_acl_entry *pa, *pe;
@@ -427,12 +427,12 @@ posix_acl_create(struct posix_acl **acl, gfp_t gfp, umode_t *mode_p)
 EXPORT_SYMBOL(posix_acl_create);
 
 int
-posix_acl_chmod(struct posix_acl **acl, gfp_t gfp, umode_t mode)
+__posix_acl_chmod(struct posix_acl **acl, gfp_t gfp, umode_t mode)
 {
 	struct posix_acl *clone = posix_acl_clone(*acl, gfp);
 	int err = -ENOMEM;
 	if (clone) {
-		err = posix_acl_chmod_masq(clone, mode);
+		err = __posix_acl_chmod_masq(clone, mode);
 		if (err) {
 			posix_acl_release(clone);
 			clone = NULL;
@@ -442,6 +442,30 @@ posix_acl_chmod(struct posix_acl **acl, gfp_t gfp, umode_t mode)
 	*acl = clone;
 	return err;
 }
+EXPORT_SYMBOL(__posix_acl_chmod);
+
+int
+posix_acl_chmod(struct inode *inode)
+{
+	struct posix_acl *acl;
+	int ret = 0;
+
+	if (!IS_POSIXACL(inode))
+		return 0;
+	if (!inode->i_op->set_acl)
+		return -EOPNOTSUPP;
+
+	acl = get_acl(inode, ACL_TYPE_ACCESS);
+	if (IS_ERR_OR_NULL(acl))
+		return PTR_ERR(acl);
+
+	ret = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+	if (ret)
+		return ret;
+	ret = inode->i_op->set_acl(inode, acl, ACL_TYPE_ACCESS);
+	posix_acl_release(acl);
+	return ret;
+}
 EXPORT_SYMBOL(posix_acl_chmod);
 
 /*
diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index 6f721ea..ea4e443 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -463,7 +463,7 @@ int reiserfs_acl_chmod(struct inode *inode)
 		return 0;
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
-	error = posix_acl_chmod(&acl, GFP_NOFS, inode->i_mode);
+	error = __posix_acl_chmod(&acl, GFP_NOFS, inode->i_mode);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 370eb3e..4eac105 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -334,7 +334,7 @@ xfs_acl_chmod(struct inode *inode)
 	if (IS_ERR(acl) || !acl)
 		return PTR_ERR(acl);
 
-	error = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+	error = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
 	if (error)
 		return error;
 
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index a8d9918..8b64e78 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -89,12 +89,14 @@ extern int posix_acl_permission(struct inode *, const struct posix_acl *, int);
 extern struct posix_acl *posix_acl_from_mode(umode_t, gfp_t);
 extern int posix_acl_equiv_mode(const struct posix_acl *, umode_t *);
 extern int posix_acl_create(struct posix_acl **, gfp_t, umode_t *);
-extern int posix_acl_chmod(struct posix_acl **, gfp_t, umode_t);
+extern int __posix_acl_chmod(struct posix_acl **, gfp_t, umode_t);
 
 extern struct posix_acl *get_posix_acl(struct inode *, int);
 extern int set_posix_acl(struct inode *, int, struct posix_acl *);
 
 #ifdef CONFIG_FS_POSIX_ACL
+extern int posix_acl_chmod(struct inode *);
+
 static inline struct posix_acl **acl_by_type(struct inode *inode, int type)
 {
 	switch (type) {
@@ -165,15 +167,22 @@ static inline void forget_all_cached_acls(struct inode *inode)
 	if (old_default != ACL_NOT_CACHED)
 		posix_acl_release(old_default);
 }
-#endif
 
 static inline void cache_no_acl(struct inode *inode)
 {
-#ifdef CONFIG_FS_POSIX_ACL
 	inode->i_acl = NULL;
 	inode->i_default_acl = NULL;
-#endif
 }
+#else
+static inline int posix_acl_chmod(struct inode *inode)
+{
+	return 0;
+}
+
+static inline void cache_no_acl(struct inode *inode)
+{
+}
+#endif /* CONFIG_FS_POSIX_ACL */
 
 struct posix_acl *get_acl(struct inode *inode, int type);
 
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
