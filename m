Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5B0D57F37
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 05:10:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0AB9AC004
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 03:10:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZJhSUmWMAmmluYKl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Nov 2015 03:10:28 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v15 11/22] vfs: Cache base_acl objects in inodes
Date: Mon,  9 Nov 2015 12:08:52 +0100
Message-Id: <1447067343-31479-12-git-send-email-agruenba@redhat.com>
In-Reply-To: <1447067343-31479-1-git-send-email-agruenba@redhat.com>
References: <1447067343-31479-1-git-send-email-agruenba@redhat.com>
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

POSIX ACLs and richacls are both objects allocated by kmalloc() with a
reference count which are freed by kfree_rcu().  An inode can either
cache an access and a default POSIX ACL, or a richacl (richacls do not
have default acls).  To allow an inode to cache either of the two kinds
of acls, introduce a new base_acl type and convert i_acl and
i_default_acl to that type. In most cases, the vfs then doesn't care which
kind of acl an inode caches (if any).

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 drivers/staging/lustre/lustre/llite/llite_lib.c |  2 +-
 fs/f2fs/acl.c                                   |  4 +--
 fs/inode.c                                      |  4 +--
 fs/jffs2/acl.c                                  | 10 ++++--
 fs/posix_acl.c                                  | 41 +++++++++++++------------
 fs/richacl_base.c                               |  4 +--
 include/linux/fs.h                              | 34 ++++++++++++++++++--
 include/linux/posix_acl.h                       | 12 +++-----
 include/linux/richacl.h                         |  9 +++---
 9 files changed, 75 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index b4ed6c8..46912c2 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1118,7 +1118,7 @@ void ll_clear_inode(struct inode *inode)
 	}
 #ifdef CONFIG_FS_POSIX_ACL
 	else if (lli->lli_posix_acl) {
-		LASSERT(atomic_read(&lli->lli_posix_acl->a_refcount) == 1);
+		LASSERT(base_acl_refcount(&lli->lli_posix_acl->a_base) == 1);
 		LASSERT(lli->lli_remote_perms == NULL);
 		posix_acl_release(lli->lli_posix_acl);
 		lli->lli_posix_acl = NULL;
diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index c8f25f7..9646197 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -270,7 +270,7 @@ static struct posix_acl *f2fs_acl_clone(const struct posix_acl *acl,
 				sizeof(struct posix_acl_entry);
 		clone = kmemdup(acl, size, flags);
 		if (clone)
-			atomic_set(&clone->a_refcount, 1);
+			base_acl_init(&clone->a_base);
 	}
 	return clone;
 }
@@ -282,7 +282,7 @@ static int f2fs_acl_create_masq(struct posix_acl *acl, umode_t *mode_p)
 	umode_t mode = *mode_p;
 	int not_equiv = 0;
 
-	/* assert(atomic_read(acl->a_refcount) == 1); */
+	/* assert(base_acl_refcount(&acl->a_base) == 1); */
 
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
 		switch(pa->e_tag) {
diff --git a/fs/inode.c b/fs/inode.c
index 78a17b8..5c46ae5 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -233,9 +233,9 @@ void __destroy_inode(struct inode *inode)
 
 #ifdef CONFIG_FS_POSIX_ACL
 	if (inode->i_acl && inode->i_acl != ACL_NOT_CACHED)
-		posix_acl_release(inode->i_acl);
+		base_acl_put(inode->i_acl);
 	if (inode->i_default_acl && inode->i_default_acl != ACL_NOT_CACHED)
-		posix_acl_release(inode->i_default_acl);
+		base_acl_put(inode->i_default_acl);
 #endif
 	this_cpu_dec(nr_inodes);
 }
diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 2f7a3c0..569cb1b 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -294,13 +294,19 @@ int jffs2_init_acl_post(struct inode *inode)
 	int rc;
 
 	if (inode->i_default_acl) {
-		rc = __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_DEFAULT, inode->i_default_acl);
+		struct posix_acl *default_acl = container_of(
+			inode->i_default_acl, struct posix_acl, a_base);
+
+		rc = __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_DEFAULT, default_acl);
 		if (rc)
 			return rc;
 	}
 
 	if (inode->i_acl) {
-		rc = __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_ACCESS, inode->i_acl);
+		struct posix_acl *acl = container_of(
+			inode->i_acl, struct posix_acl, a_base);
+
+		rc = __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_ACCESS, acl);
 		if (rc)
 			return rc;
 	}
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index aacfb58..4573315 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -21,7 +21,7 @@
 #include <linux/export.h>
 #include <linux/user_namespace.h>
 
-static struct posix_acl **acl_by_type(struct inode *inode, int type)
+static struct base_acl **acl_by_type(struct inode *inode, int type)
 {
 	switch (type) {
 	case ACL_TYPE_ACCESS:
@@ -35,63 +35,64 @@ static struct posix_acl **acl_by_type(struct inode *inode, int type)
 
 struct posix_acl *get_cached_acl(struct inode *inode, int type)
 {
-	struct posix_acl **p = acl_by_type(inode, type);
-	struct posix_acl *acl = ACCESS_ONCE(*p);
+	struct base_acl **p = acl_by_type(inode, type);
+	struct base_acl *acl = ACCESS_ONCE(*p);
 	if (acl) {
 		spin_lock(&inode->i_lock);
 		acl = *p;
 		if (acl != ACL_NOT_CACHED)
-			acl = posix_acl_dup(acl);
+			base_acl_get(acl);
 		spin_unlock(&inode->i_lock);
 	}
-	return acl;
+	return container_of(acl, struct posix_acl, a_base);
 }
 EXPORT_SYMBOL(get_cached_acl);
 
 struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type)
 {
-	return rcu_dereference(*acl_by_type(inode, type));
+	struct base_acl *acl = rcu_dereference(*acl_by_type(inode, type));
+	return container_of(acl, struct posix_acl, a_base);
 }
 EXPORT_SYMBOL(get_cached_acl_rcu);
 
 void set_cached_acl(struct inode *inode, int type, struct posix_acl *acl)
 {
-	struct posix_acl **p = acl_by_type(inode, type);
-	struct posix_acl *old;
+	struct base_acl **p = acl_by_type(inode, type);
+	struct base_acl *old;
 	spin_lock(&inode->i_lock);
 	old = *p;
-	rcu_assign_pointer(*p, posix_acl_dup(acl));
+	rcu_assign_pointer(*p, &posix_acl_dup(acl)->a_base);
 	spin_unlock(&inode->i_lock);
 	if (old != ACL_NOT_CACHED)
-		posix_acl_release(old);
+		base_acl_put(old);
 }
 EXPORT_SYMBOL(set_cached_acl);
 
 void forget_cached_acl(struct inode *inode, int type)
 {
-	struct posix_acl **p = acl_by_type(inode, type);
-	struct posix_acl *old;
+	struct base_acl **p = acl_by_type(inode, type);
+	struct base_acl *old;
 	spin_lock(&inode->i_lock);
 	old = *p;
 	*p = ACL_NOT_CACHED;
 	spin_unlock(&inode->i_lock);
 	if (old != ACL_NOT_CACHED)
-		posix_acl_release(old);
+		base_acl_put(old);
 }
 EXPORT_SYMBOL(forget_cached_acl);
 
 void forget_all_cached_acls(struct inode *inode)
 {
-	struct posix_acl *old_access, *old_default;
+	struct base_acl *old_access, *old_default;
 	spin_lock(&inode->i_lock);
 	old_access = inode->i_acl;
 	old_default = inode->i_default_acl;
 	inode->i_acl = inode->i_default_acl = ACL_NOT_CACHED;
 	spin_unlock(&inode->i_lock);
 	if (old_access != ACL_NOT_CACHED)
-		posix_acl_release(old_access);
+		base_acl_put(old_access);
 	if (old_default != ACL_NOT_CACHED)
-		posix_acl_release(old_default);
+		base_acl_put(old_default);
 }
 EXPORT_SYMBOL(forget_all_cached_acls);
 
@@ -128,7 +129,7 @@ EXPORT_SYMBOL(get_acl);
 void
 posix_acl_init(struct posix_acl *acl, int count)
 {
-	atomic_set(&acl->a_refcount, 1);
+	base_acl_init(&acl->a_base);
 	acl->a_count = count;
 }
 EXPORT_SYMBOL(posix_acl_init);
@@ -161,7 +162,7 @@ posix_acl_clone(const struct posix_acl *acl, gfp_t flags)
 		           sizeof(struct posix_acl_entry);
 		clone = kmemdup(acl, size, flags);
 		if (clone)
-			atomic_set(&clone->a_refcount, 1);
+			base_acl_init(&clone->a_base);
 	}
 	return clone;
 }
@@ -383,7 +384,7 @@ static int posix_acl_create_masq(struct posix_acl *acl, umode_t *mode_p)
 	umode_t mode = *mode_p;
 	int not_equiv = 0;
 
-	/* assert(atomic_read(acl->a_refcount) == 1); */
+	/* assert(base_acl_refcount(&acl->a_base) == 1); */
 
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
                 switch(pa->e_tag) {
@@ -438,7 +439,7 @@ static int __posix_acl_chmod_masq(struct posix_acl *acl, umode_t mode)
 	struct posix_acl_entry *group_obj = NULL, *mask_obj = NULL;
 	struct posix_acl_entry *pa, *pe;
 
-	/* assert(atomic_read(acl->a_refcount) == 1); */
+	/* assert(base_acl_refcount(&acl->a_base) == 1); */
 
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
 		switch(pa->e_tag) {
diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index 69b806c..5826842 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -33,7 +33,7 @@ richacl_alloc(int count, gfp_t gfp)
 	struct richacl *acl = kzalloc(size, gfp);
 
 	if (acl) {
-		atomic_set(&acl->a_refcount, 1);
+		base_acl_init(&acl->a_base);
 		acl->a_count = count;
 	}
 	return acl;
@@ -52,7 +52,7 @@ richacl_clone(const struct richacl *acl, gfp_t gfp)
 
 	if (dup) {
 		memcpy(dup, acl, size);
-		atomic_set(&dup->a_refcount, 1);
+		base_acl_init(&dup->a_base);
 	}
 	return dup;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ba91a89..2fd840e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -576,6 +576,12 @@ static inline void mapping_allow_writable(struct address_space *mapping)
 #define i_size_ordered_init(inode) do { } while (0)
 #endif
 
+struct base_acl {
+	union {
+		atomic_t ba_refcount;
+		struct rcu_head ba_rcu;
+	};
+};
 struct posix_acl;
 #define ACL_NOT_CACHED ((void *)(-1))
 
@@ -595,9 +601,9 @@ struct inode {
 	kgid_t			i_gid;
 	unsigned int		i_flags;
 
-#ifdef CONFIG_FS_POSIX_ACL
-	struct posix_acl	*i_acl;
-	struct posix_acl	*i_default_acl;
+#if defined(CONFIG_FS_POSIX_ACL)
+	struct base_acl		*i_acl;
+	struct base_acl		*i_default_acl;
 #endif
 
 	const struct inode_operations	*i_op;
@@ -3059,4 +3065,26 @@ static inline bool dir_relax(struct inode *inode)
 
 extern bool path_noexec(const struct path *path);
 
+static inline void base_acl_get(struct base_acl *acl)
+{
+	if (acl)
+		atomic_inc(&acl->ba_refcount);
+}
+
+static inline void base_acl_put(struct base_acl *acl)
+{
+	if (acl && atomic_dec_and_test(&acl->ba_refcount))
+		kfree_rcu(acl, ba_rcu);
+}
+
+static inline void base_acl_init(struct base_acl *acl)
+{
+	atomic_set(&acl->ba_refcount, 1);
+}
+
+static inline int base_acl_refcount(struct base_acl *acl)
+{
+	return atomic_read(&acl->ba_refcount);
+}
+
 #endif /* _LINUX_FS_H */
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 5b5a80c..cef5428 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -43,10 +43,7 @@ struct posix_acl_entry {
 };
 
 struct posix_acl {
-	union {
-		atomic_t		a_refcount;
-		struct rcu_head		a_rcu;
-	};
+	struct base_acl		a_base;  /* must be first, see posix_acl_release() */
 	unsigned int		a_count;
 	struct posix_acl_entry	a_entries[0];
 };
@@ -61,8 +58,7 @@ struct posix_acl {
 static inline struct posix_acl *
 posix_acl_dup(struct posix_acl *acl)
 {
-	if (acl)
-		atomic_inc(&acl->a_refcount);
+	base_acl_get(&acl->a_base);
 	return acl;
 }
 
@@ -72,8 +68,8 @@ posix_acl_dup(struct posix_acl *acl)
 static inline void
 posix_acl_release(struct posix_acl *acl)
 {
-	if (acl && atomic_dec_and_test(&acl->a_refcount))
-		kfree_rcu(acl, a_rcu);
+	BUILD_BUG_ON(offsetof(struct posix_acl, a_base) != 0);
+	base_acl_put(&acl->a_base);
 }
 
 
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 1d9f5f7..7628fad 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -31,7 +31,7 @@ struct richace {
 };
 
 struct richacl {
-	atomic_t	a_refcount;
+	struct base_acl	a_base;  /* must be first, see richacl_put() */
 	unsigned int	a_owner_mask;
 	unsigned int	a_group_mask;
 	unsigned int	a_other_mask;
@@ -56,8 +56,7 @@ struct richacl {
 static inline struct richacl *
 richacl_get(struct richacl *acl)
 {
-	if (acl)
-		atomic_inc(&acl->a_refcount);
+	base_acl_get(&acl->a_base);
 	return acl;
 }
 
@@ -67,8 +66,8 @@ richacl_get(struct richacl *acl)
 static inline void
 richacl_put(struct richacl *acl)
 {
-	if (acl && atomic_dec_and_test(&acl->a_refcount))
-		kfree(acl);
+	BUILD_BUG_ON(offsetof(struct richacl, a_base) != 0);
+	base_acl_put(&acl->a_base);
 }
 
 /**
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
