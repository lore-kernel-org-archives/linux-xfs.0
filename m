Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 046DB7F3F
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 05:10:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C99E0304039
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 03:10:43 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Xehx38ncMnmVfRs1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Nov 2015 03:10:42 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v15 13/22] vfs: Cache richacl in struct inode
Date: Mon,  9 Nov 2015 12:08:54 +0100
Message-Id: <1447067343-31479-14-git-send-email-agruenba@redhat.com>
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

Cache richacls in struct inode so that this doesn't have to be done
individually in each filesystem.  This is similar to POSIX ACLs.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/inode.c              | 11 +++++--
 fs/posix_acl.c          |  2 +-
 fs/richacl_inode.c      | 77 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h      |  5 +++-
 include/linux/richacl.h |  6 ++++
 5 files changed, 96 insertions(+), 5 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 5c46ae5..5e8710c 100644
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
 		base_acl_put(inode->i_acl);
+# if defined(CONFIG_FS_POSIX_ACL)
 	if (inode->i_default_acl && inode->i_default_acl != ACL_NOT_CACHED)
 		base_acl_put(inode->i_default_acl);
+# endif
 #endif
 	this_cpu_dec(nr_inodes);
 }
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 4573315..b0eb1dc 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -37,7 +37,7 @@ struct posix_acl *get_cached_acl(struct inode *inode, int type)
 {
 	struct base_acl **p = acl_by_type(inode, type);
 	struct base_acl *acl = ACCESS_ONCE(*p);
-	if (acl) {
+	if (acl && IS_POSIXACL(inode)) {
 		spin_lock(&inode->i_lock);
 		acl = *p;
 		if (acl != ACL_NOT_CACHED)
diff --git a/fs/richacl_inode.c b/fs/richacl_inode.c
index 99b3c93..52c1595 100644
--- a/fs/richacl_inode.c
+++ b/fs/richacl_inode.c
@@ -20,6 +20,83 @@
 #include <linux/slab.h>
 #include <linux/richacl.h>
 
+struct richacl *get_cached_richacl(struct inode *inode)
+{
+	struct base_acl *acl;
+
+	acl = ACCESS_ONCE(inode->i_acl);
+	if (acl && IS_RICHACL(inode)) {
+		spin_lock(&inode->i_lock);
+		acl = inode->i_acl;
+		if (acl != ACL_NOT_CACHED)
+			base_acl_get(acl);
+		spin_unlock(&inode->i_lock);
+	}
+	return container_of(acl, struct richacl, a_base);
+}
+EXPORT_SYMBOL_GPL(get_cached_richacl);
+
+struct richacl *get_cached_richacl_rcu(struct inode *inode)
+{
+	struct base_acl *acl = rcu_dereference(inode->i_acl);
+
+	return container_of(acl, struct richacl, a_base);
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
+		base_acl_put(old);
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
+		base_acl_put(old);
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
index 3c36c72..05fb943 100644
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
index 7628fad..7bf912b6 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -70,6 +70,12 @@ richacl_put(struct richacl *acl)
 	base_acl_put(&acl->a_base);
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
