Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 69FA47F4E
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 08:37:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 54579304075
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 06:37:33 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id YwiJdgpP4kUtEATL (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Dec 2013 06:37:31 -0800 (PST)
Date: Mon, 23 Dec 2013 06:37:06 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 21/21] hfsplus: remove can_set_xattr
Message-ID: <20131223143706.GA8235@infradead.org>
References: <20131220131635.650823732@bombadil.infradead.org>
	<20131220132524.900291394@bombadil.infradead.org>
	<636E01BC-12FD-452B-8B1C-320B6EADAEFD@dubeyko.com>
	<20131222192818.GA32565@infradead.org>
	<1387780809.3991.21.camel@slavad-ubuntu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1387780809.3991.21.camel@slavad-ubuntu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: cluster-devel@redhat.com, xfs@oss.sgi.com, Andreas Gruenbacher <andreas.gruenbacher@linbit.com>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Christoph Hellwig <hch@infradead.org>, linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

On Mon, Dec 23, 2013 at 10:40:09AM +0400, Vyacheslav Dubeyko wrote:
> Maybe I missed something, but I can see that this check is removed only.
> Could you point out the code in your patch that it checks and forbids
> such combination as "osx.security.*", "osx.trusted.*" and so on?

@@ -941,6 +857,9 @@ static int hfsplus_osx_setxattr(struct dentry
*dentry, const char *name,
        if (len > HFSPLUS_ATTR_MAX_STRLEN)
		return -EOPNOTSUPP;

+       if (is_known_namespace(name))
+               return -EOPNOTSUPP;
+


> I can see that is_known_namespace() is called for
> hfsplus_xattr_osx_handler only. But this method doesn't contain
> above-mentioned check. Moreover, hfsplus_xattr_user_handler,
> hfsplus_xattr_trusted_handler, hfsplus_xattr_security_handler will be
> without is_know_namespace() check. What about it?

They only allow you to set user.*, trusted.* and security.* attributs,
because the only get called for it.  For osx.* attributes the osx
handler gets called, and passed the name minus the osx prefix, which
is why the above check will catch it.

> Why bad design? Do you mean that using .removexattr callback is bad
> idea?

Using the handlers for set and get and not using them for remove is a
bad design, because it uses different levels of abstraction for
related operations.  I'm also increasingly of the opnion that we
should not allow the non-handler version, and that we should not permit
filesystems to create their own namespaces, but that's an unrelated
discussion.

> So, if it needs to use xattr handler only for removing then it needs to
> make some refactoring of using __hfsplus_setxattr() and
> hfsplus_removexattr() or merging these two functions into one. And I
> think that merging is better idea.

I've not done the full merge, but below is an updated patch to make
sure hfsplus uses the handlers for the remove case, and making sure
the adding/striping of the prefix for the osv handlers is more
transparent:

diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 9ee6298..bdec665 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -529,7 +529,7 @@ const struct inode_operations hfsplus_dir_inode_operations = {
 	.setxattr		= generic_setxattr,
 	.getxattr		= generic_getxattr,
 	.listxattr		= hfsplus_listxattr,
-	.removexattr		= hfsplus_removexattr,
+	.removexattr		= generic_removexattr,
 #ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
 	.get_acl		= hfsplus_get_posix_acl,
 	.set_acl		= hfsplus_set_posix_acl,
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 2e10993..83c9166 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -390,7 +390,7 @@ static const struct inode_operations hfsplus_file_inode_operations = {
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
 	.listxattr	= hfsplus_listxattr,
-	.removexattr	= hfsplus_removexattr,
+	.removexattr	= generic_removexattr,
 #ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
 	.get_acl	= hfsplus_get_posix_acl,
 	.set_acl	= hfsplus_set_posix_acl,
diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
index bf88baa..c838b84 100644
--- a/fs/hfsplus/xattr.c
+++ b/fs/hfsplus/xattr.c
@@ -11,6 +11,8 @@
 #include "xattr.h"
 #include "acl.h"
 
+static int hfsplus_removexattr(struct inode *inode, const char *name);
+
 const struct xattr_handler *hfsplus_xattr_handlers[] = {
 	&hfsplus_xattr_osx_handler,
 	&hfsplus_xattr_user_handler,
@@ -52,82 +54,6 @@ static inline int is_known_namespace(const char *name)
 	return true;
 }
 
-static int can_set_system_xattr(struct inode *inode, const char *name,
-				const void *value, size_t size)
-{
-#ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
-	struct posix_acl *acl;
-	int err;
-
-	if (!inode_owner_or_capable(inode))
-		return -EPERM;
-
-	/*
-	 * POSIX_ACL_XATTR_ACCESS is tied to i_mode
-	 */
-	if (strcmp(name, POSIX_ACL_XATTR_ACCESS) == 0) {
-		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-		if (IS_ERR(acl))
-			return PTR_ERR(acl);
-		if (acl) {
-			err = posix_acl_equiv_mode(acl, &inode->i_mode);
-			posix_acl_release(acl);
-			if (err < 0)
-				return err;
-			mark_inode_dirty(inode);
-		}
-		/*
-		 * We're changing the ACL.  Get rid of the cached one
-		 */
-		forget_cached_acl(inode, ACL_TYPE_ACCESS);
-
-		return 0;
-	} else if (strcmp(name, POSIX_ACL_XATTR_DEFAULT) == 0) {
-		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-		if (IS_ERR(acl))
-			return PTR_ERR(acl);
-		posix_acl_release(acl);
-
-		/*
-		 * We're changing the default ACL.  Get rid of the cached one
-		 */
-		forget_cached_acl(inode, ACL_TYPE_DEFAULT);
-
-		return 0;
-	}
-#endif /* CONFIG_HFSPLUS_FS_POSIX_ACL */
-	return -EOPNOTSUPP;
-}
-
-static int can_set_xattr(struct inode *inode, const char *name,
-				const void *value, size_t value_len)
-{
-	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
-		return can_set_system_xattr(inode, name, value, value_len);
-
-	if (!strncmp(name, XATTR_MAC_OSX_PREFIX, XATTR_MAC_OSX_PREFIX_LEN)) {
-		/*
-		 * This makes sure that we aren't trying to set an
-		 * attribute in a different namespace by prefixing it
-		 * with "osx."
-		 */
-		if (is_known_namespace(name + XATTR_MAC_OSX_PREFIX_LEN))
-			return -EOPNOTSUPP;
-
-		return 0;
-	}
-
-	/*
-	 * Don't allow setting an attribute in an unknown namespace.
-	 */
-	if (strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) &&
-	    strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) &&
-	    strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
-		return -EOPNOTSUPP;
-
-	return 0;
-}
-
 static void hfsplus_init_header_node(struct inode *attr_file,
 					u32 clump_size,
 					char *buf, u16 node_size)
@@ -350,18 +276,8 @@ int __hfsplus_setxattr(struct inode *inode, const char *name,
 				HFSPLUS_IS_RSRC(inode))
 		return -EOPNOTSUPP;
 
-	err = can_set_xattr(inode, name, value, size);
-	if (err)
-		return err;
-
-	if (strncmp(name, XATTR_MAC_OSX_PREFIX,
-				XATTR_MAC_OSX_PREFIX_LEN) == 0)
-		name += XATTR_MAC_OSX_PREFIX_LEN;
-
-	if (value == NULL) {
-		value = "";
-		size = 0;
-	}
+	if (value == NULL)
+		return hfsplus_removexattr(inode, name);
 
 	err = hfs_find_init(HFSPLUS_SB(inode->i_sb)->cat_tree, &cat_fd);
 	if (err) {
@@ -577,18 +493,6 @@ ssize_t __hfsplus_getxattr(struct inode *inode, const char *name,
 				HFSPLUS_IS_RSRC(inode))
 		return -EOPNOTSUPP;
 
-	if (strncmp(name, XATTR_MAC_OSX_PREFIX,
-				XATTR_MAC_OSX_PREFIX_LEN) == 0) {
-		/* skip "osx." prefix */
-		name += XATTR_MAC_OSX_PREFIX_LEN;
-		/*
-		 * Don't allow retrieving properly prefixed attributes
-		 * by prepending them with "osx."
-		 */
-		if (is_known_namespace(name))
-			return -EOPNOTSUPP;
-	}
-
 	if (!strcmp_xattr_finder_info(name))
 		return hfsplus_getxattr_finder_info(inode, value, size);
 
@@ -823,32 +727,18 @@ end_listxattr:
 	return res;
 }
 
-int hfsplus_removexattr(struct dentry *dentry, const char *name)
+static int hfsplus_removexattr(struct inode *inode, const char *name)
 {
 	int err = 0;
-	struct inode *inode = dentry->d_inode;
 	struct hfs_find_data cat_fd;
 	u16 flags;
 	u16 cat_entry_type;
 	int is_xattr_acl_deleted = 0;
 	int is_all_xattrs_deleted = 0;
 
-	if ((!S_ISREG(inode->i_mode) &&
-			!S_ISDIR(inode->i_mode)) ||
-				HFSPLUS_IS_RSRC(inode))
-		return -EOPNOTSUPP;
-
 	if (!HFSPLUS_SB(inode->i_sb)->attr_tree)
 		return -EOPNOTSUPP;
 
-	err = can_set_xattr(inode, name, NULL, 0);
-	if (err)
-		return err;
-
-	if (strncmp(name, XATTR_MAC_OSX_PREFIX,
-				XATTR_MAC_OSX_PREFIX_LEN) == 0)
-		name += XATTR_MAC_OSX_PREFIX_LEN;
-
 	if (!strcmp_xattr_finder_info(name))
 		return -EOPNOTSUPP;
 
@@ -922,8 +812,12 @@ static int hfsplus_osx_getxattr(struct dentry *dentry, const char *name,
 	if (len > HFSPLUS_ATTR_MAX_STRLEN)
 		return -EOPNOTSUPP;
 
-	strcpy(xattr_name, XATTR_MAC_OSX_PREFIX);
-	strcpy(xattr_name + XATTR_MAC_OSX_PREFIX_LEN, name);
+	/*
+	 * Don't allow retrieving properly prefixed attributes
+	 * by prepending them with "osx."
+	 */
+	if (is_known_namespace(name))
+		return -EOPNOTSUPP;
 
 	return hfsplus_getxattr(dentry, xattr_name, buffer, size);
 }
@@ -941,8 +835,12 @@ static int hfsplus_osx_setxattr(struct dentry *dentry, const char *name,
 	if (len > HFSPLUS_ATTR_MAX_STRLEN)
 		return -EOPNOTSUPP;
 
-	strcpy(xattr_name, XATTR_MAC_OSX_PREFIX);
-	strcpy(xattr_name + XATTR_MAC_OSX_PREFIX_LEN, name);
+	/*
+	 * Don't allow setting properly prefixed attributes
+	 * by prepending them with "osx."
+	 */
+	if (is_known_namespace(name))
+		return -EOPNOTSUPP;
 
 	return hfsplus_setxattr(dentry, xattr_name, buffer, size, flags);
 }
diff --git a/fs/hfsplus/xattr.h b/fs/hfsplus/xattr.h
index 9e21449..288530c 100644
--- a/fs/hfsplus/xattr.h
+++ b/fs/hfsplus/xattr.h
@@ -40,8 +40,6 @@ static inline ssize_t hfsplus_getxattr(struct dentry *dentry,
 
 ssize_t hfsplus_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
-int hfsplus_removexattr(struct dentry *dentry, const char *name);
-
 int hfsplus_init_security(struct inode *inode, struct inode *dir,
 				const struct qstr *qstr);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
