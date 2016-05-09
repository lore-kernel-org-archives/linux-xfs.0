Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 981957CA6
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 17:04:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3381F8F8035
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 15:04:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EHxBdcdyqa26aWb2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 May 2016 15:04:20 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v21 11/22] vfs: Cache base_acl objects in inodes
Date: Tue, 10 May 2016 00:02:44 +0200
Message-Id: <1462831375-23017-12-git-send-email-agruenba@redhat.com>
In-Reply-To: <1462831375-23017-1-git-send-email-agruenba@redhat.com>
References: <1462831375-23017-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

POSIX ACLs and richacls are both objects allocated by kmalloc() with a
reference count which are freed by kfree_rcu().  An inode can either
cache an access and a default POSIX ACL, or a richacl (richacls do not
have default acls).  To allow an inode to cache either of the two kinds
of acls, introduce a new base_acl type and convert i_acl and
i_default_acl to that type. In most cases, the vfs then doesn't care which
kind of acl an inode caches (if any).

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Andreas Dilger <adilger@dilger.ca>
---
 drivers/staging/lustre/lustre/llite/llite_lib.c |  2 +-
 fs/9p/acl.c                                     |  8 +--
 fs/f2fs/acl.c                                   |  4 +-
 fs/inode.c                                      | 32 +++++++++++-
 fs/jffs2/acl.c                                  |  6 ++-
 fs/namei.c                                      | 33 ++++++------
 fs/nfs/nfs3acl.c                                | 14 ++---
 fs/posix_acl.c                                  | 69 +++++++------------------
 fs/richacl.c                                    |  4 +-
 include/linux/fs.h                              | 41 +++++++++++++--
 include/linux/posix_acl.h                       | 21 ++++----
 include/linux/richacl.h                         |  9 ++--
 12 files changed, 139 insertions(+), 104 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 6d6bb33..6084093 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1074,7 +1074,7 @@ void ll_clear_inode(struct inode *inode)
 	}
 #ifdef CONFIG_FS_POSIX_ACL
 	else if (lli->lli_posix_acl) {
-		LASSERT(atomic_read(&lli->lli_posix_acl->a_refcount) == 1);
+		LASSERT(base_acl_refcount(&lli->lli_posix_acl->a_base) == 1);
 		LASSERT(!lli->lli_remote_perms);
 		posix_acl_release(lli->lli_posix_acl);
 		lli->lli_posix_acl = NULL;
diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index 2d94e94..8bf700f 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -87,14 +87,14 @@ int v9fs_get_acl(struct inode *inode, struct p9_fid *fid)
 
 static struct posix_acl *v9fs_get_cached_acl(struct inode *inode, int type)
 {
-	struct posix_acl *acl;
+	struct base_acl *base_acl;
 	/*
 	 * 9p Always cache the acl value when
 	 * instantiating the inode (v9fs_inode_from_fid)
 	 */
-	acl = get_cached_acl(inode, type);
-	BUG_ON(is_uncached_acl(acl));
-	return acl;
+	base_acl = get_cached_acl(inode, type);
+	BUG_ON(is_uncached_acl(base_acl));
+	return posix_acl(base_acl);
 }
 
 struct posix_acl *v9fs_iop_get_acl(struct inode *inode, int type)
diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index 6f1fdda..cd40777 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -267,7 +267,7 @@ static struct posix_acl *f2fs_acl_clone(const struct posix_acl *acl,
 				sizeof(struct posix_acl_entry);
 		clone = kmemdup(acl, size, flags);
 		if (clone)
-			atomic_set(&clone->a_refcount, 1);
+			base_acl_init(&clone->a_base);
 	}
 	return clone;
 }
@@ -279,7 +279,7 @@ static int f2fs_acl_create_masq(struct posix_acl *acl, umode_t *mode_p)
 	umode_t mode = *mode_p;
 	int not_equiv = 0;
 
-	/* assert(atomic_read(acl->a_refcount) == 1); */
+	/* assert(base_acl_refcount(&acl->a_base) == 1); */
 
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
 		switch(pa->e_tag) {
diff --git a/fs/inode.c b/fs/inode.c
index 4202aac..e937039 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -239,14 +239,42 @@ void __destroy_inode(struct inode *inode)
 
 #ifdef CONFIG_FS_POSIX_ACL
 	if (inode->i_acl && !is_uncached_acl(inode->i_acl))
-		posix_acl_release(inode->i_acl);
+		base_acl_put(inode->i_acl);
 	if (inode->i_default_acl && !is_uncached_acl(inode->i_default_acl))
-		posix_acl_release(inode->i_default_acl);
+		base_acl_put(inode->i_default_acl);
 #endif
 	this_cpu_dec(nr_inodes);
 }
 EXPORT_SYMBOL(__destroy_inode);
 
+#ifdef CONFIG_FS_POSIX_ACL
+struct base_acl *__get_cached_acl(struct base_acl **p)
+{
+	struct base_acl *base_acl;
+
+	for (;;) {
+		rcu_read_lock();
+		base_acl = rcu_dereference(*p);
+		if (!base_acl || is_uncached_acl(base_acl) ||
+		    atomic_inc_not_zero(&base_acl->ba_refcount))
+			break;
+		rcu_read_unlock();
+		cpu_relax();
+	}
+	rcu_read_unlock();
+	return base_acl;
+}
+
+void __forget_cached_acl(struct base_acl **p)
+{
+	struct base_acl *old;
+
+	old = xchg(p, ACL_NOT_CACHED);
+	if (!is_uncached_acl(old))
+		base_acl_put(old);
+}
+#endif
+
 static void i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index bc2693d..6c11909 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -292,13 +292,15 @@ int jffs2_init_acl_post(struct inode *inode)
 	int rc;
 
 	if (inode->i_default_acl) {
-		rc = __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_DEFAULT, inode->i_default_acl);
+		rc = __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_DEFAULT,
+				     posix_acl(inode->i_default_acl));
 		if (rc)
 			return rc;
 	}
 
 	if (inode->i_acl) {
-		rc = __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_ACCESS, inode->i_acl);
+		rc = __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_ACCESS,
+				     posix_acl(inode->i_acl));
 		if (rc)
 			return rc;
 	}
diff --git a/fs/namei.c b/fs/namei.c
index 858ed96..2b1bf71 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -258,25 +258,28 @@ void putname(struct filename *name)
 static int check_acl(struct inode *inode, int mask)
 {
 #ifdef CONFIG_FS_POSIX_ACL
-	struct posix_acl *acl;
-
 	if (mask & MAY_NOT_BLOCK) {
-		acl = get_cached_acl_rcu(inode, ACL_TYPE_ACCESS);
-	        if (!acl)
+		struct base_acl *base_acl;
+
+		base_acl = rcu_dereference(inode->i_acl);
+	        if (!base_acl)
 	                return -EAGAIN;
 		/* no ->get_acl() calls in RCU mode... */
-		if (is_uncached_acl(acl))
+		if (is_uncached_acl(base_acl))
 			return -ECHILD;
-	        return posix_acl_permission(inode, acl, mask & ~MAY_NOT_BLOCK);
-	}
-
-	acl = get_acl(inode, ACL_TYPE_ACCESS);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	if (acl) {
-	        int error = posix_acl_permission(inode, acl, mask);
-	        posix_acl_release(acl);
-	        return error;
+	        return posix_acl_permission(inode, posix_acl(base_acl),
+					    mask & ~MAY_NOT_BLOCK);
+	} else {
+		struct posix_acl *acl;
+
+		acl = get_acl(inode, ACL_TYPE_ACCESS);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		if (acl) {
+			int error = posix_acl_permission(inode, acl, mask);
+			posix_acl_release(acl);
+			return error;
+		}
 	}
 #endif
 
diff --git a/fs/nfs/nfs3acl.c b/fs/nfs/nfs3acl.c
index 720d92f5..2b70944 100644
--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -16,28 +16,28 @@
  * caching get_acl results in a race-free way.  See fs/posix_acl.c:get_acl()
  * for explanations.
  */
-static void nfs3_prepare_get_acl(struct posix_acl **p)
+static void nfs3_prepare_get_acl(struct base_acl **p)
 {
-	struct posix_acl *sentinel = uncached_acl_sentinel(current);
+	struct base_acl *sentinel = uncached_acl_sentinel(current);
 
 	if (cmpxchg(p, ACL_NOT_CACHED, sentinel) != ACL_NOT_CACHED) {
 		/* Not the first reader or sentinel already in place. */
 	}
 }
 
-static void nfs3_complete_get_acl(struct posix_acl **p, struct posix_acl *acl)
+static void nfs3_complete_get_acl(struct base_acl **p, struct posix_acl *acl)
 {
-	struct posix_acl *sentinel = uncached_acl_sentinel(current);
+	struct base_acl *sentinel = uncached_acl_sentinel(current);
 
 	/* Only cache the ACL if our sentinel is still in place. */
 	posix_acl_dup(acl);
-	if (cmpxchg(p, sentinel, acl) != sentinel)
+	if (cmpxchg(p, sentinel, &acl->a_base) != sentinel)
 		posix_acl_release(acl);
 }
 
-static void nfs3_abort_get_acl(struct posix_acl **p)
+static void nfs3_abort_get_acl(struct base_acl **p)
 {
-	struct posix_acl *sentinel = uncached_acl_sentinel(current);
+	struct base_acl *sentinel = uncached_acl_sentinel(current);
 
 	/* Remove our sentinel upon failure. */
 	cmpxchg(p, sentinel, ACL_NOT_CACHED);
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index db1fb0f..e202e79 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -21,7 +21,7 @@
 #include <linux/export.h>
 #include <linux/user_namespace.h>
 
-static struct posix_acl **acl_by_type(struct inode *inode, int type)
+static inline struct base_acl **acl_by_type(struct inode *inode, int type)
 {
 	switch (type) {
 	case ACL_TYPE_ACCESS:
@@ -33,51 +33,23 @@ static struct posix_acl **acl_by_type(struct inode *inode, int type)
 	}
 }
 
-struct posix_acl *get_cached_acl(struct inode *inode, int type)
+struct base_acl *get_cached_acl(struct inode *inode, int type)
 {
-	struct posix_acl **p = acl_by_type(inode, type);
-	struct posix_acl *acl;
-
-	for (;;) {
-		rcu_read_lock();
-		acl = rcu_dereference(*p);
-		if (!acl || is_uncached_acl(acl) ||
-		    atomic_inc_not_zero(&acl->a_refcount))
-			break;
-		rcu_read_unlock();
-		cpu_relax();
-	}
-	rcu_read_unlock();
-	return acl;
+	return __get_cached_acl(acl_by_type(inode, type));
 }
 EXPORT_SYMBOL(get_cached_acl);
 
-struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type)
-{
-	return rcu_dereference(*acl_by_type(inode, type));
-}
-EXPORT_SYMBOL(get_cached_acl_rcu);
-
 void set_cached_acl(struct inode *inode, int type, struct posix_acl *acl)
 {
-	struct posix_acl **p = acl_by_type(inode, type);
-	struct posix_acl *old;
+	struct base_acl **p = acl_by_type(inode, type);
+	struct base_acl *old;
 
-	old = xchg(p, posix_acl_dup(acl));
+	old = xchg(p, &posix_acl_dup(acl)->a_base);
 	if (!is_uncached_acl(old))
-		posix_acl_release(old);
+		base_acl_put(old);
 }
 EXPORT_SYMBOL(set_cached_acl);
 
-static void __forget_cached_acl(struct posix_acl **p)
-{
-	struct posix_acl *old;
-
-	old = xchg(p, ACL_NOT_CACHED);
-	if (!is_uncached_acl(old))
-		posix_acl_release(old);
-}
-
 void forget_cached_acl(struct inode *inode, int type)
 {
 	__forget_cached_acl(acl_by_type(inode, type));
@@ -93,25 +65,24 @@ EXPORT_SYMBOL(forget_all_cached_acls);
 
 struct posix_acl *get_acl(struct inode *inode, int type)
 {
-	void *sentinel;
-	struct posix_acl **p;
+	struct base_acl **p = acl_by_type(inode, type);
+	struct base_acl *sentinel, *base_acl;
 	struct posix_acl *acl;
 
+	if (!IS_POSIXACL(inode))
+		return NULL;
+
 	/*
 	 * The sentinel is used to detect when another operation like
 	 * set_cached_acl() or forget_cached_acl() races with get_acl().
 	 * It is guaranteed that is_uncached_acl(sentinel) is true.
 	 */
 
-	acl = get_cached_acl(inode, type);
-	if (!is_uncached_acl(acl))
-		return acl;
-
-	if (!IS_POSIXACL(inode))
-		return NULL;
+	base_acl = __get_cached_acl(p);
+	if (!is_uncached_acl(base_acl))
+		return posix_acl(base_acl);
 
 	sentinel = uncached_acl_sentinel(current);
-	p = acl_by_type(inode, type);
 
 	/*
 	 * If the ACL isn't being read yet, set our sentinel.  Otherwise, the
@@ -151,7 +122,7 @@ struct posix_acl *get_acl(struct inode *inode, int type)
 	 * Cache the result, but only if our sentinel is still in place.
 	 */
 	posix_acl_dup(acl);
-	if (unlikely(cmpxchg(p, sentinel, acl) != sentinel))
+	if (unlikely(cmpxchg(p, sentinel, &acl->a_base) != sentinel))
 		posix_acl_release(acl);
 	return acl;
 }
@@ -163,7 +134,7 @@ EXPORT_SYMBOL(get_acl);
 void
 posix_acl_init(struct posix_acl *acl, int count)
 {
-	atomic_set(&acl->a_refcount, 1);
+	base_acl_init(&acl->a_base);
 	acl->a_count = count;
 }
 EXPORT_SYMBOL(posix_acl_init);
@@ -196,7 +167,7 @@ posix_acl_clone(const struct posix_acl *acl, gfp_t flags)
 		           sizeof(struct posix_acl_entry);
 		clone = kmemdup(acl, size, flags);
 		if (clone)
-			atomic_set(&clone->a_refcount, 1);
+			base_acl_init(&clone->a_base);
 	}
 	return clone;
 }
@@ -418,7 +389,7 @@ static int posix_acl_create_masq(struct posix_acl *acl, umode_t *mode_p)
 	umode_t mode = *mode_p;
 	int not_equiv = 0;
 
-	/* assert(atomic_read(acl->a_refcount) == 1); */
+	/* assert(base_acl_refcount(&acl->a_base) == 1); */
 
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
                 switch(pa->e_tag) {
@@ -473,7 +444,7 @@ static int __posix_acl_chmod_masq(struct posix_acl *acl, umode_t mode)
 	struct posix_acl_entry *group_obj = NULL, *mask_obj = NULL;
 	struct posix_acl_entry *pa, *pe;
 
-	/* assert(atomic_read(acl->a_refcount) == 1); */
+	/* assert(base_acl_refcount(&acl->a_base) == 1); */
 
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
 		switch(pa->e_tag) {
diff --git a/fs/richacl.c b/fs/richacl.c
index cb0ef3f..8971ead 100644
--- a/fs/richacl.c
+++ b/fs/richacl.c
@@ -31,7 +31,7 @@ richacl_alloc(int count, gfp_t gfp)
 	struct richacl *acl = kzalloc(size, gfp);
 
 	if (acl) {
-		atomic_set(&acl->a_refcount, 1);
+		base_acl_init(&acl->a_base);
 		acl->a_count = count;
 	}
 	return acl;
@@ -50,7 +50,7 @@ richacl_clone(const struct richacl *acl, gfp_t gfp)
 
 	if (dup) {
 		memcpy(dup, acl, size);
-		atomic_set(&dup->a_refcount, 1);
+		base_acl_init(&dup->a_base);
 	}
 	return dup;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 16d2380..c569117 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -581,17 +581,23 @@ static inline void mapping_allow_writable(struct address_space *mapping)
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
 
-static inline struct posix_acl *
+static inline struct base_acl *
 uncached_acl_sentinel(struct task_struct *task)
 {
 	return (void *)task + 1;
 }
 
 static inline bool
-is_uncached_acl(struct posix_acl *acl)
+is_uncached_acl(struct base_acl *acl)
 {
 	return (long)acl & 1;
 }
@@ -612,9 +618,9 @@ struct inode {
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
@@ -3128,4 +3134,29 @@ static inline bool dir_relax(struct inode *inode)
 extern bool path_noexec(const struct path *path);
 extern void inode_nohighmem(struct inode *inode);
 
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
+extern struct base_acl *__get_cached_acl(struct base_acl **);
+extern void __forget_cached_acl(struct base_acl **);
+
 #endif /* _LINUX_FS_H */
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 5b5a80c..daf84fa 100644
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
 
@@ -72,10 +68,16 @@ posix_acl_dup(struct posix_acl *acl)
 static inline void
 posix_acl_release(struct posix_acl *acl)
 {
-	if (acl && atomic_dec_and_test(&acl->a_refcount))
-		kfree_rcu(acl, a_rcu);
+	BUILD_BUG_ON(offsetof(struct posix_acl, a_base) != 0);
+	base_acl_put(&acl->a_base);
 }
 
+static inline struct posix_acl *
+posix_acl(struct base_acl *base_acl)
+{
+	BUILD_BUG_ON(offsetof(struct posix_acl, a_base) != 0);
+	return container_of(base_acl, struct posix_acl, a_base);
+}
 
 /* posix_acl.c */
 
@@ -99,8 +101,7 @@ extern int posix_acl_create(struct inode *, umode_t *, struct posix_acl **,
 extern int simple_set_acl(struct inode *, struct posix_acl *, int);
 extern int simple_acl_create(struct inode *, struct inode *);
 
-struct posix_acl *get_cached_acl(struct inode *inode, int type);
-struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type);
+struct base_acl *get_cached_acl(struct inode *inode, int type);
 void set_cached_acl(struct inode *inode, int type, struct posix_acl *acl);
 void forget_cached_acl(struct inode *inode, int type);
 void forget_all_cached_acls(struct inode *inode);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index be9fb65..35a5bcb 100644
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
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
