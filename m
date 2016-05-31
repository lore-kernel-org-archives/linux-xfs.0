Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A321F7CBA
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 06:52:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 671D1304048
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 04:52:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6cJHyuCqbHDOY8vo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 04:52:33 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v22 13/22] vfs: Cache richacl in struct inode
Date: Tue, 31 May 2016 13:50:45 +0200
Message-Id: <1464695454-18557-14-git-send-email-agruenba@redhat.com>
In-Reply-To: <1464695454-18557-1-git-send-email-agruenba@redhat.com>
References: <1464695454-18557-1-git-send-email-agruenba@redhat.com>
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

Cache richacls in struct inode so that this doesn't have to be done
individually in each filesystem.  This is similar to POSIX ACLs.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/inode.c              | 13 +++++---
 fs/richacl.c            | 81 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h      |  5 ++-
 include/linux/richacl.h | 11 +++++++
 4 files changed, 105 insertions(+), 5 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 40c03a7..7dbb09c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -181,8 +181,11 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
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
@@ -238,17 +241,19 @@ void __destroy_inode(struct inode *inode)
 		atomic_long_dec(&inode->i_sb->s_remove_count);
 	}
 
-#ifdef CONFIG_FS_POSIX_ACL
+#if defined(CONFIG_FS_POSIX_ACL) || defined(CONFIG_FS_RICHACL)
 	if (inode->i_acl && !is_uncached_acl(inode->i_acl))
 		base_acl_put(inode->i_acl);
+# if defined(CONFIG_FS_POSIX_ACL)
 	if (inode->i_default_acl && !is_uncached_acl(inode->i_default_acl))
 		base_acl_put(inode->i_default_acl);
+# endif
 #endif
 	this_cpu_dec(nr_inodes);
 }
 EXPORT_SYMBOL(__destroy_inode);
 
-#ifdef CONFIG_FS_POSIX_ACL
+#if defined(CONFIG_FS_POSIX_ACL) || defined(CONFIG_FS_RICHACL)
 struct base_acl *__get_cached_acl(struct base_acl **p)
 {
 	struct base_acl *base_acl;
diff --git a/fs/richacl.c b/fs/richacl.c
index 8971ead..b2a03c1 100644
--- a/fs/richacl.c
+++ b/fs/richacl.c
@@ -20,6 +20,87 @@
 #include <linux/slab.h>
 #include <linux/richacl.h>
 
+void set_cached_richacl(struct inode *inode, struct richacl *acl)
+{
+	struct base_acl *old;
+
+	old = xchg(&inode->i_acl, &richacl_get(acl)->a_base);
+	if (!is_uncached_acl(old))
+		base_acl_put(old);
+}
+EXPORT_SYMBOL_GPL(set_cached_richacl);
+
+void forget_cached_richacl(struct inode *inode)
+{
+	__forget_cached_acl(&inode->i_acl);
+}
+EXPORT_SYMBOL_GPL(forget_cached_richacl);
+
+struct richacl *get_richacl(struct inode *inode)
+{
+	struct base_acl *sentinel, *base_acl;
+	struct richacl *acl;
+
+	if (!IS_RICHACL(inode))
+		return NULL;
+
+	/*
+	 * The sentinel is used to detect when another operation like
+	 * set_cached_richacl() or forget_cached_richacl() races with
+	 * get_richacl().
+	 * It is guaranteed that is_uncached_acl(sentinel) is true.
+	 */
+
+	base_acl = __get_cached_acl(&inode->i_acl);
+	if (!is_uncached_acl(base_acl))
+		return richacl(base_acl);
+
+	sentinel = uncached_acl_sentinel(current);
+
+	/*
+	 * If the ACL isn't being read yet, set our sentinel.  Otherwise, the
+	 * current value of the ACL will not be ACL_NOT_CACHED and so our own
+	 * sentinel will not be set; another task will update the cache.  We
+	 * could wait for that other task to complete its job, but it's easier
+	 * to just call ->get_acl to fetch the ACL ourself.  (This is going to
+	 * be an unlikely race.)
+	 */
+	if (cmpxchg(&inode->i_acl, ACL_NOT_CACHED, sentinel) != ACL_NOT_CACHED)
+		/* fall through */ ;
+
+	/*
+	 * Normally, the ACL returned by ->get_richacl will be cached.
+	 * A filesystem can prevent that by calling
+	 * forget_cached_richacl(inode) in ->get_richacl.
+	 *
+	 * If the filesystem doesn't have a ->get_richacl function at all,
+	 * we'll just create the negative cache entry.
+	 */
+	if (!inode->i_op->get_richacl) {
+		set_cached_richacl(inode, NULL);
+		return NULL;
+	}
+
+	acl = inode->i_op->get_richacl(inode);
+	if (IS_ERR(acl)) {
+		/*
+		 * Remove our sentinel so that we don't block future attempts
+		 * to cache the ACL.
+		 */
+		cmpxchg(&inode->i_acl, sentinel, ACL_NOT_CACHED);
+		return acl;
+	}
+
+	/*
+	 * Cache the result, but only if our sentinel is still in place.
+	 */
+	richacl_get(acl);
+	if (unlikely(cmpxchg(&inode->i_acl, sentinel, &acl->a_base) != sentinel))
+		richacl_put(acl);
+	return acl;
+}
+EXPORT_SYMBOL_GPL(get_richacl);
+
 /**
  * richacl_alloc  -  allocate a richacl
  * @count:	number of entries
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ac96bda..4d72a6d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -589,6 +589,7 @@ struct base_acl {
 	};
 };
 struct posix_acl;
+struct richacl;
 #define ACL_NOT_CACHED ((void *)(-1))
 
 static inline struct base_acl *
@@ -619,9 +620,11 @@ struct inode {
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
index 35a5bcb..3e05c94 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -70,6 +70,17 @@ richacl_put(struct richacl *acl)
 	base_acl_put(&acl->a_base);
 }
 
+static inline struct richacl *
+richacl(struct base_acl *base_acl)
+{
+	BUILD_BUG_ON(offsetof(struct richacl, a_base) != 0);
+	return container_of(base_acl, struct richacl, a_base);
+}
+
+extern void set_cached_richacl(struct inode *, struct richacl *);
+extern void forget_cached_richacl(struct inode *);
+extern struct richacl *get_richacl(struct inode *);
+
 /**
  * richace_is_owner  -  check if @ace is an OWNER@ entry
  */
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
