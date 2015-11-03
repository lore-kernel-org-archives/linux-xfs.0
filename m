Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 479757F77
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 09:19:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 35658304043
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 07:19:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nhOpB3Afby44qvCr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 07:18:59 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v13 12/51] vfs: Cache richacl in struct inode
Date: Tue,  3 Nov 2015 16:16:48 +0100
Message-Id: <1446563847-14005-13-git-send-email-agruenba@redhat.com>
In-Reply-To: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Cache richacls in struct inode so that this doesn't have to be done
individually in each filesystem.  This is similar to POSIX ACLs.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/inode.c              | 11 ++++++--
 fs/posix_acl.c          |  2 +-
 fs/richacl_base.c       |  4 +--
 fs/richacl_inode.c      | 75 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h      |  5 +++-
 include/linux/richacl.h | 15 ++++++----
 6 files changed, 100 insertions(+), 12 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 2a387f4..8462ddb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -174,8 +174,11 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_private = NULL;
 	inode->i_mapping = mapping;
 	INIT_HLIST_HEAD(&inode->i_dentry);	/* buggered by rcu freeing */
-#ifdef CONFIG_FS_POSIX_ACL
-	inode->i_acl = inode->i_default_acl = ACL_NOT_CACHED;
+#if defined(CONFIG_FS_POSIX_ACL) || defined(CONFIG_FS_RICHACL)
+	inode->i_acl = ACL_NOT_CACHED;
+# if defined(CONFIG_FS_POSIX_ACL)
+	inode->i_default_acl = ACL_NOT_CACHED;
+# endif
 #endif
 
 #ifdef CONFIG_FSNOTIFY
@@ -231,11 +234,13 @@ void __destroy_inode(struct inode *inode)
 		atomic_long_dec(&inode->i_sb->s_remove_count);
 	}
 
-#ifdef CONFIG_FS_POSIX_ACL
+#if defined(CONFIG_FS_POSIX_ACL) || defined(CONFIG_FS_RICHACL)
 	if (inode->i_acl && inode->i_acl != ACL_NOT_CACHED)
 		put_base_acl(inode->i_acl);
+# if defined(CONFIG_FS_POSIX_ACL)
 	if (inode->i_default_acl && inode->i_default_acl != ACL_NOT_CACHED)
 		put_base_acl(inode->i_default_acl);
+# endif
 #endif
 	this_cpu_dec(nr_inodes);
 }
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index b3b2265..1d766a5 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -38,7 +38,7 @@ struct posix_acl *get_cached_acl(struct inode *inode, int type)
 {
 	struct posix_acl **p = acl_by_type(inode, type);
 	struct posix_acl *acl = ACCESS_ONCE(*p);
-	if (acl) {
+	if (acl && IS_POSIXACL(inode)) {
 		spin_lock(&inode->i_lock);
 		acl = *p;
 		if (acl != ACL_NOT_CACHED)
diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index 69b806c..d0ab5e9 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -33,7 +33,7 @@ richacl_alloc(int count, gfp_t gfp)
 	struct richacl *acl = kzalloc(size, gfp);
 
 	if (acl) {
-		atomic_set(&acl->a_refcount, 1);
+		atomic_set(&acl->a_base.ba_refcount, 1);
 		acl->a_count = count;
 	}
 	return acl;
@@ -52,7 +52,7 @@ richacl_clone(const struct richacl *acl, gfp_t gfp)
 
 	if (dup) {
 		memcpy(dup, acl, size);
-		atomic_set(&dup->a_refcount, 1);
+		atomic_set(&dup->a_base.ba_refcount, 1);
 	}
 	return dup;
 }
diff --git a/fs/richacl_inode.c b/fs/richacl_inode.c
index 99b3c93..c41a6c4 100644
--- a/fs/richacl_inode.c
+++ b/fs/richacl_inode.c
@@ -20,6 +20,81 @@
 #include <linux/slab.h>
 #include <linux/richacl.h>
 
+struct richacl *get_cached_richacl(struct inode *inode)
+{
+	struct richacl *acl;
+
+	acl = (struct richacl *)ACCESS_ONCE(inode->i_acl);
+	if (acl && IS_RICHACL(inode)) {
+		spin_lock(&inode->i_lock);
+		acl = (struct richacl *)inode->i_acl;
+		if (acl != ACL_NOT_CACHED)
+			acl = richacl_get(acl);
+		spin_unlock(&inode->i_lock);
+	}
+	return acl;
+}
+EXPORT_SYMBOL_GPL(get_cached_richacl);
+
+struct richacl *get_cached_richacl_rcu(struct inode *inode)
+{
+	return (struct richacl *)rcu_dereference(inode->i_acl);
+}
+EXPORT_SYMBOL_GPL(get_cached_richacl_rcu);
+
+void set_cached_richacl(struct inode *inode, struct richacl *acl)
+{
+	struct base_acl *old = NULL;
+
+	spin_lock(&inode->i_lock);
+	old = inode->i_acl;
+	rcu_assign_pointer(inode->i_acl, &richacl_get(acl)->a_base);
+	spin_unlock(&inode->i_lock);
+	if (old != ACL_NOT_CACHED)
+		put_base_acl(old);
+}
+EXPORT_SYMBOL_GPL(set_cached_richacl);
+
+void forget_cached_richacl(struct inode *inode)
+{
+	struct base_acl *old = NULL;
+
+	spin_lock(&inode->i_lock);
+	old = inode->i_acl;
+	inode->i_acl = ACL_NOT_CACHED;
+	spin_unlock(&inode->i_lock);
+	if (old != ACL_NOT_CACHED)
+		put_base_acl(old);
+}
+EXPORT_SYMBOL_GPL(forget_cached_richacl);
+
+struct richacl *get_richacl(struct inode *inode)
+{
+	struct richacl *acl;
+
+	acl = get_cached_richacl(inode);
+	if (acl != ACL_NOT_CACHED)
+		return acl;
+
+	if (!IS_RICHACL(inode))
+		return NULL;
+
+	/*
+	 * A filesystem can force a ACL callback by just never filling the
+	 * ACL cache. But normally you'd fill the cache either at inode
+	 * instantiation time, or on the first ->get_richacl call.
+	 *
+	 * If the filesystem doesn't have a get_richacl() function at all,
+	 * we'll just create the negative cache entry.
+	 */
+	if (!inode->i_op->get_richacl) {
+		set_cached_richacl(inode, NULL);
+		return NULL;
+	}
+	return inode->i_op->get_richacl(inode);
+}
+EXPORT_SYMBOL_GPL(get_richacl);
+
 /**
  * richacl_permission  -  richacl permission check algorithm
  * @inode:	inode to check
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 08fde42..d91deef 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -583,6 +583,7 @@ struct base_acl {
 	};
 };
 struct posix_acl;
+struct richacl;
 #define ACL_NOT_CACHED ((void *)(-1))
 
 #define IOP_FASTPERM	0x0001
@@ -601,9 +602,11 @@ struct inode {
 	kgid_t			i_gid;
 	unsigned int		i_flags;
 
-#if defined(CONFIG_FS_POSIX_ACL)
+#if defined(CONFIG_FS_POSIX_ACL) || defined(CONFIG_FS_RICHACL)
 	struct base_acl		*i_acl;
+# if defined(CONFIG_FS_POSIX_ACL)
 	struct base_acl		*i_default_acl;
+# endif
 #endif
 
 	const struct inode_operations	*i_op;
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 2baef35..de7d0d9 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -31,7 +31,7 @@ struct richace {
 };
 
 struct richacl {
-	atomic_t	a_refcount;
+	struct base_acl	a_base;
 	unsigned int	a_owner_mask;
 	unsigned int	a_group_mask;
 	unsigned int	a_other_mask;
@@ -56,8 +56,7 @@ struct richacl {
 static inline struct richacl *
 richacl_get(struct richacl *acl)
 {
-	if (acl)
-		atomic_inc(&acl->a_base.ba_refcount);
+	get_base_acl(&acl->a_base);
 	return acl;
 }
 
@@ -67,10 +66,16 @@ richacl_get(struct richacl *acl)
 static inline void
 richacl_put(struct richacl *acl)
 {
-	if (acl && atomic_dec_and_test(&acl->a_refcount))
-		kfree(acl);
+	BUILD_BUG_ON(offsetof(struct richacl, a_base) != 0);
+	put_base_acl(&acl->a_base);
 }
 
+extern struct richacl *get_cached_richacl(struct inode *);
+extern struct richacl *get_cached_richacl_rcu(struct inode *);
+extern void set_cached_richacl(struct inode *, struct richacl *);
+extern void forget_cached_richacl(struct inode *);
+extern struct richacl *get_richacl(struct inode *);
+
 /**
  * richace_is_owner  -  check if @ace is an OWNER@ entry
  */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
