Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA4ED29E05
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 04:45:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88EEC30406A
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 02:45:44 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ZhVsofKTJS0FuZpO (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 02:45:43 -0800 (PST)
Message-Id: <20131211104529.305937197@bombadil.infradead.org>
Date: Wed, 11 Dec 2013 02:43:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 17/18] nfs: use generic posix ACL infrastructure for v3 Posix
	ACLs
References: <20131211104243.148113893@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0017-nfs-use-generic-posix-ACL-infrastructure-for-v3-Posi.patch
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
Cc: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>, xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, Joel Becker <jlbec@evilplan.org>, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfs/inode.c         |    4 -
 fs/nfs/nfs3acl.c       |  287 +++++++++---------------------------------------
 fs/nfs/nfs3proc.c      |   26 +++--
 fs/nfs/nfs3super.c     |    3 +
 include/linux/nfs_fs.h |   10 +-
 5 files changed, 76 insertions(+), 254 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 00ad1c2..ecd11ba 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1641,10 +1641,6 @@ struct inode *nfs_alloc_inode(struct super_block *sb)
 		return NULL;
 	nfsi->flags = 0UL;
 	nfsi->cache_validity = 0UL;
-#ifdef CONFIG_NFS_V3_ACL
-	nfsi->acl_access = ERR_PTR(-EAGAIN);
-	nfsi->acl_default = ERR_PTR(-EAGAIN);
-#endif
 #if IS_ENABLED(CONFIG_NFS_V4)
 	nfsi->nfs4_acl = NULL;
 #endif /* CONFIG_NFS_V4 */
diff --git a/fs/nfs/nfs3acl.c b/fs/nfs/nfs3acl.c
index e859675..80bfb5b 100644
--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -10,179 +10,7 @@
 
 #define NFSDBG_FACILITY	NFSDBG_PROC
 
-ssize_t nfs3_listxattr(struct dentry *dentry, char *buffer, size_t size)
-{
-	struct inode *inode = dentry->d_inode;
-	struct posix_acl *acl;
-	int pos=0, len=0;
-
-#	define output(s) do {						\
-			if (pos + sizeof(s) <= size) {			\
-				memcpy(buffer + pos, s, sizeof(s));	\
-				pos += sizeof(s);			\
-			}						\
-			len += sizeof(s);				\
-		} while(0)
-
-	acl = nfs3_proc_getacl(inode, ACL_TYPE_ACCESS);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	if (acl) {
-		output("system.posix_acl_access");
-		posix_acl_release(acl);
-	}
-
-	if (S_ISDIR(inode->i_mode)) {
-		acl = nfs3_proc_getacl(inode, ACL_TYPE_DEFAULT);
-		if (IS_ERR(acl))
-			return PTR_ERR(acl);
-		if (acl) {
-			output("system.posix_acl_default");
-			posix_acl_release(acl);
-		}
-	}
-
-#	undef output
-
-	if (!buffer || len <= size)
-		return len;
-	return -ERANGE;
-}
-
-ssize_t nfs3_getxattr(struct dentry *dentry, const char *name,
-		void *buffer, size_t size)
-{
-	struct inode *inode = dentry->d_inode;
-	struct posix_acl *acl;
-	int type, error = 0;
-
-	if (strcmp(name, POSIX_ACL_XATTR_ACCESS) == 0)
-		type = ACL_TYPE_ACCESS;
-	else if (strcmp(name, POSIX_ACL_XATTR_DEFAULT) == 0)
-		type = ACL_TYPE_DEFAULT;
-	else
-		return -EOPNOTSUPP;
-
-	acl = nfs3_proc_getacl(inode, type);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	else if (acl) {
-		if (type == ACL_TYPE_ACCESS && acl->a_count == 0)
-			error = -ENODATA;
-		else
-			error = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
-		posix_acl_release(acl);
-	} else
-		error = -ENODATA;
-
-	return error;
-}
-
-int nfs3_setxattr(struct dentry *dentry, const char *name,
-	     const void *value, size_t size, int flags)
-{
-	struct inode *inode = dentry->d_inode;
-	struct posix_acl *acl;
-	int type, error;
-
-	if (strcmp(name, POSIX_ACL_XATTR_ACCESS) == 0)
-		type = ACL_TYPE_ACCESS;
-	else if (strcmp(name, POSIX_ACL_XATTR_DEFAULT) == 0)
-		type = ACL_TYPE_DEFAULT;
-	else
-		return -EOPNOTSUPP;
-
-	acl = posix_acl_from_xattr(&init_user_ns, value, size);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	error = nfs3_proc_setacl(inode, type, acl);
-	posix_acl_release(acl);
-
-	return error;
-}
-
-int nfs3_removexattr(struct dentry *dentry, const char *name)
-{
-	struct inode *inode = dentry->d_inode;
-	int type;
-
-	if (strcmp(name, POSIX_ACL_XATTR_ACCESS) == 0)
-		type = ACL_TYPE_ACCESS;
-	else if (strcmp(name, POSIX_ACL_XATTR_DEFAULT) == 0)
-		type = ACL_TYPE_DEFAULT;
-	else
-		return -EOPNOTSUPP;
-
-	return nfs3_proc_setacl(inode, type, NULL);
-}
-
-static void __nfs3_forget_cached_acls(struct nfs_inode *nfsi)
-{
-	if (!IS_ERR(nfsi->acl_access)) {
-		posix_acl_release(nfsi->acl_access);
-		nfsi->acl_access = ERR_PTR(-EAGAIN);
-	}
-	if (!IS_ERR(nfsi->acl_default)) {
-		posix_acl_release(nfsi->acl_default);
-		nfsi->acl_default = ERR_PTR(-EAGAIN);
-	}
-}
-
-void nfs3_forget_cached_acls(struct inode *inode)
-{
-	dprintk("NFS: nfs3_forget_cached_acls(%s/%ld)\n", inode->i_sb->s_id,
-		inode->i_ino);
-	spin_lock(&inode->i_lock);
-	__nfs3_forget_cached_acls(NFS_I(inode));
-	spin_unlock(&inode->i_lock);
-}
-
-static struct posix_acl *nfs3_get_cached_acl(struct inode *inode, int type)
-{
-	struct nfs_inode *nfsi = NFS_I(inode);
-	struct posix_acl *acl = ERR_PTR(-EINVAL);
-
-	spin_lock(&inode->i_lock);
-	switch(type) {
-		case ACL_TYPE_ACCESS:
-			acl = nfsi->acl_access;
-			break;
-
-		case ACL_TYPE_DEFAULT:
-			acl = nfsi->acl_default;
-			break;
-
-		default:
-			goto out;
-	}
-	if (IS_ERR(acl))
-		acl = ERR_PTR(-EAGAIN);
-	else
-		acl = posix_acl_dup(acl);
-out:
-	spin_unlock(&inode->i_lock);
-	dprintk("NFS: nfs3_get_cached_acl(%s/%ld, %d) = %p\n", inode->i_sb->s_id,
-		inode->i_ino, type, acl);
-	return acl;
-}
-
-static void nfs3_cache_acls(struct inode *inode, struct posix_acl *acl,
-		    struct posix_acl *dfacl)
-{
-	struct nfs_inode *nfsi = NFS_I(inode);
-
-	dprintk("nfs3_cache_acls(%s/%ld, %p, %p)\n", inode->i_sb->s_id,
-		inode->i_ino, acl, dfacl);
-	spin_lock(&inode->i_lock);
-	__nfs3_forget_cached_acls(NFS_I(inode));
-	if (!IS_ERR(acl))
-		nfsi->acl_access = posix_acl_dup(acl);
-	if (!IS_ERR(dfacl))
-		nfsi->acl_default = posix_acl_dup(dfacl);
-	spin_unlock(&inode->i_lock);
-}
-
-struct posix_acl *nfs3_proc_getacl(struct inode *inode, int type)
+struct posix_acl *nfs3_get_acl(struct inode *inode, int type)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
 	struct page *pages[NFSACL_MAXPAGES] = { };
@@ -198,7 +26,6 @@ struct posix_acl *nfs3_proc_getacl(struct inode *inode, int type)
 		.rpc_argp	= &args,
 		.rpc_resp	= &res,
 	};
-	struct posix_acl *acl;
 	int status, count;
 
 	if (!nfs_server_capable(inode, NFS_CAP_ACLS))
@@ -207,10 +34,6 @@ struct posix_acl *nfs3_proc_getacl(struct inode *inode, int type)
 	status = nfs_revalidate_inode(server, inode);
 	if (status < 0)
 		return ERR_PTR(status);
-	acl = nfs3_get_cached_acl(inode, type);
-	if (acl != ERR_PTR(-EAGAIN))
-		return acl;
-	acl = NULL;
 
 	/*
 	 * Only get the access acl when explicitly requested: We don't
@@ -257,36 +80,37 @@ struct posix_acl *nfs3_proc_getacl(struct inode *inode, int type)
 	}
 
 	if (res.acl_access != NULL) {
-		if (posix_acl_equiv_mode(res.acl_access, NULL) == 0) {
+		if (posix_acl_equiv_mode(res.acl_access, NULL) ||
+		    res.acl_access->a_count == 0) {
 			posix_acl_release(res.acl_access);
 			res.acl_access = NULL;
 		}
 	}
-	nfs3_cache_acls(inode,
-		(res.mask & NFS_ACL)   ? res.acl_access  : ERR_PTR(-EINVAL),
-		(res.mask & NFS_DFACL) ? res.acl_default : ERR_PTR(-EINVAL));
 
-	switch(type) {
-		case ACL_TYPE_ACCESS:
-			acl = res.acl_access;
-			res.acl_access = NULL;
-			break;
+	if (res.mask & NFS_ACL)
+		set_cached_acl(inode, ACL_TYPE_ACCESS, res.acl_access);
+	else
+		forget_cached_acl(inode, ACL_TYPE_ACCESS);
 
-		case ACL_TYPE_DEFAULT:
-			acl = res.acl_default;
-			res.acl_default = NULL;
+	if (res.mask & NFS_DFACL)
+		set_cached_acl(inode, ACL_TYPE_DEFAULT, res.acl_default);
+	else
+		forget_cached_acl(inode, ACL_TYPE_DEFAULT);
+
+	nfs_free_fattr(res.fattr);
+	if (type == ACL_TYPE_ACCESS) {
+		posix_acl_release(res.acl_default);
+		return res.acl_access;
+	} else {
+		posix_acl_release(res.acl_access);
+		return res.acl_default;
 	}
 
 getout:
 	posix_acl_release(res.acl_access);
 	posix_acl_release(res.acl_default);
 	nfs_free_fattr(res.fattr);
-
-	if (status != 0) {
-		posix_acl_release(acl);
-		acl = ERR_PTR(status);
-	}
-	return acl;
+	return ERR_PTR(status);
 }
 
 static int nfs3_proc_setacls(struct inode *inode, struct posix_acl *acl,
@@ -353,7 +177,8 @@ static int nfs3_proc_setacls(struct inode *inode, struct posix_acl *acl,
 	switch (status) {
 		case 0:
 			status = nfs_refresh_inode(inode, fattr);
-			nfs3_cache_acls(inode, acl, dfacl);
+			set_cached_acl(inode, ACL_TYPE_ACCESS, acl);
+			set_cached_acl(inode, ACL_TYPE_DEFAULT, dfacl);
 			break;
 		case -EPFNOSUPPORT:
 		case -EPROTONOSUPPORT:
@@ -373,33 +198,27 @@ out:
 	return status;
 }
 
-int nfs3_proc_setacl(struct inode *inode, int type, struct posix_acl *acl)
+int nfs3_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	struct posix_acl *alloc = NULL, *dfacl = NULL;
 	int status;
 
 	if (S_ISDIR(inode->i_mode)) {
 		switch(type) {
-			case ACL_TYPE_ACCESS:
-				alloc = dfacl = nfs3_proc_getacl(inode,
-						ACL_TYPE_DEFAULT);
-				if (IS_ERR(alloc))
-					goto fail;
-				break;
-
-			case ACL_TYPE_DEFAULT:
-				dfacl = acl;
-				alloc = acl = nfs3_proc_getacl(inode,
-						ACL_TYPE_ACCESS);
-				if (IS_ERR(alloc))
-					goto fail;
-				break;
-
-			default:
-				return -EINVAL;
+		case ACL_TYPE_ACCESS:
+			alloc = dfacl = nfs3_get_acl(inode, ACL_TYPE_DEFAULT);
+			if (IS_ERR(alloc))
+				goto fail;
+			break;
+
+		case ACL_TYPE_DEFAULT:
+			dfacl = acl;
+			alloc = acl = nfs3_get_acl(inode, ACL_TYPE_ACCESS);
+			if (IS_ERR(alloc))
+				goto fail;
+			break;
 		}
-	} else if (type != ACL_TYPE_ACCESS)
-			return -EINVAL;
+	}
 
 	if (acl == NULL) {
 		alloc = acl = posix_acl_from_mode(inode->i_mode, GFP_KERNEL);
@@ -417,24 +236,24 @@ fail:
 int nfs3_proc_set_default_acl(struct inode *dir, struct inode *inode,
 		umode_t mode)
 {
-	struct posix_acl *dfacl, *acl;
-	int error = 0;
+	struct posix_acl *default_acl, *acl;
+	int error;
 
-	dfacl = nfs3_proc_getacl(dir, ACL_TYPE_DEFAULT);
-	if (IS_ERR(dfacl)) {
-		error = PTR_ERR(dfacl);
+	error = posix_acl_create(dir, &mode, &default_acl, &acl);
+	if (error)
 		return (error == -EOPNOTSUPP) ? 0 : error;
-	}
-	if (!dfacl)
-		return 0;
-	acl = posix_acl_dup(dfacl);
-	error = __posix_acl_create(&acl, GFP_KERNEL, &mode);
-	if (error < 0)
-		goto out_release_dfacl;
-	error = nfs3_proc_setacls(inode, acl, S_ISDIR(inode->i_mode) ?
-						      dfacl : NULL);
-	posix_acl_release(acl);
-out_release_dfacl:
-	posix_acl_release(dfacl);
+
+	error = nfs3_proc_setacls(inode, acl, default_acl);
+
+	if (acl)
+		posix_acl_release(acl);
+	if (default_acl)
+		posix_acl_release(default_acl);
 	return error;
 }
+
+const struct xattr_handler *nfs3_xattr_handlers[] = {
+	&posix_acl_access_xattr_handler,
+	&posix_acl_default_xattr_handler,
+	NULL,
+};
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 01b6f6a..ab27a7d1 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -904,20 +904,28 @@ static const struct inode_operations nfs3_dir_inode_operations = {
 	.permission	= nfs_permission,
 	.getattr	= nfs_getattr,
 	.setattr	= nfs_setattr,
-	.listxattr	= nfs3_listxattr,
-	.getxattr	= nfs3_getxattr,
-	.setxattr	= nfs3_setxattr,
-	.removexattr	= nfs3_removexattr,
+	.listxattr	= generic_listxattr,
+	.getxattr	= generic_getxattr,
+	.setxattr	= generic_setxattr,
+	.removexattr	= generic_removexattr,
+#ifdef CONFIG_NFS_V3_ACL
+	.get_acl	= nfs3_get_acl,
+	.set_acl	= nfs3_set_acl,
+#endif
 };
 
 static const struct inode_operations nfs3_file_inode_operations = {
 	.permission	= nfs_permission,
 	.getattr	= nfs_getattr,
 	.setattr	= nfs_setattr,
-	.listxattr	= nfs3_listxattr,
-	.getxattr	= nfs3_getxattr,
-	.setxattr	= nfs3_setxattr,
-	.removexattr	= nfs3_removexattr,
+	.listxattr	= generic_listxattr,
+	.getxattr	= generic_getxattr,
+	.setxattr	= generic_setxattr,
+	.removexattr	= generic_removexattr,
+#ifdef CONFIG_NFS_V3_ACL
+	.get_acl	= nfs3_get_acl,
+	.set_acl	= nfs3_set_acl,
+#endif
 };
 
 const struct nfs_rpc_ops nfs_v3_clientops = {
@@ -965,7 +973,7 @@ const struct nfs_rpc_ops nfs_v3_clientops = {
 	.commit_rpc_prepare = nfs3_proc_commit_rpc_prepare,
 	.commit_done	= nfs3_commit_done,
 	.lock		= nfs3_proc_lock,
-	.clear_acl_cache = nfs3_forget_cached_acls,
+	.clear_acl_cache = forget_all_cached_acls,
 	.close_context	= nfs_close_context,
 	.have_delegation = nfs3_have_delegation,
 	.return_delegation = nfs3_return_delegation,
diff --git a/fs/nfs/nfs3super.c b/fs/nfs/nfs3super.c
index cc471c7..d6a9894 100644
--- a/fs/nfs/nfs3super.c
+++ b/fs/nfs/nfs3super.c
@@ -12,6 +12,9 @@ static struct nfs_subversion nfs_v3 = {
 	.rpc_vers = &nfs_version3,
 	.rpc_ops  = &nfs_v3_clientops,
 	.sops     = &nfs_sops,
+#ifdef CONFIG_NFS_V3_ACL
+	.xattr    = nfs3_xattr_handlers,
+#endif
 };
 
 static int __init init_nfs_v3(void)
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 4899737..176f1d2 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -154,10 +154,6 @@ struct nfs_inode {
 	struct rb_root		access_cache;
 	struct list_head	access_cache_entry_lru;
 	struct list_head	access_cache_inode_lru;
-#ifdef CONFIG_NFS_V3_ACL
-	struct posix_acl	*acl_access;
-	struct posix_acl	*acl_default;
-#endif
 
 	/*
 	 * This is the cookie verifier used for NFSv3 readdir
@@ -564,12 +560,12 @@ extern int  nfs_readpage_async(struct nfs_open_context *, struct inode *,
  * linux/fs/nfs3proc.c
  */
 #ifdef CONFIG_NFS_V3_ACL
-extern struct posix_acl *nfs3_proc_getacl(struct inode *inode, int type);
-extern int nfs3_proc_setacl(struct inode *inode, int type,
-			    struct posix_acl *acl);
+extern struct posix_acl *nfs3_get_acl(struct inode *inode, int type);
+extern int nfs3_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 extern int nfs3_proc_set_default_acl(struct inode *dir, struct inode *inode,
 		umode_t mode);
 extern void nfs3_forget_cached_acls(struct inode *inode);
+extern const struct xattr_handler *nfs3_xattr_handlers[];
 #else
 static inline int nfs3_proc_set_default_acl(struct inode *dir,
 					    struct inode *inode,
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
