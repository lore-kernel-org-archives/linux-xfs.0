Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2B6FA29E43
	for <xfs@oss.sgi.com>; Fri, 20 Dec 2013 07:25:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DFC4930409B
	for <xfs@oss.sgi.com>; Fri, 20 Dec 2013 05:25:43 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 5BhVwqZ2RJusAII9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Dec 2013 05:25:42 -0800 (PST)
Message-Id: <20131220132524.900291394@bombadil.infradead.org>
Date: Fri, 20 Dec 2013 05:16:56 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 21/21] hfsplus: remove can_set_xattr
References: <20131220131635.650823732@bombadil.infradead.org>
Content-Disposition: inline; filename=0021-hfsplus-remove-can_set_xattr.patch
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

When using the per-superblock xattr handlers permission checking is
done by the generic code.  hfsplus just needs to check for the magic
osx attribute not to leak into protected namespaces.

Also given that the code was obviously copied from JFS the proper
attribution was missing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/hfsplus/xattr.c |   87 ++--------------------------------------------------
 1 file changed, 3 insertions(+), 84 deletions(-)

diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
index bf88baa..0b4a5c9 100644
--- a/fs/hfsplus/xattr.c
+++ b/fs/hfsplus/xattr.c
@@ -52,82 +52,6 @@ static inline int is_known_namespace(const char *name)
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
@@ -350,10 +274,6 @@ int __hfsplus_setxattr(struct inode *inode, const char *name,
 				HFSPLUS_IS_RSRC(inode))
 		return -EOPNOTSUPP;
 
-	err = can_set_xattr(inode, name, value, size);
-	if (err)
-		return err;
-
 	if (strncmp(name, XATTR_MAC_OSX_PREFIX,
 				XATTR_MAC_OSX_PREFIX_LEN) == 0)
 		name += XATTR_MAC_OSX_PREFIX_LEN;
@@ -841,10 +761,6 @@ int hfsplus_removexattr(struct dentry *dentry, const char *name)
 	if (!HFSPLUS_SB(inode->i_sb)->attr_tree)
 		return -EOPNOTSUPP;
 
-	err = can_set_xattr(inode, name, NULL, 0);
-	if (err)
-		return err;
-
 	if (strncmp(name, XATTR_MAC_OSX_PREFIX,
 				XATTR_MAC_OSX_PREFIX_LEN) == 0)
 		name += XATTR_MAC_OSX_PREFIX_LEN;
@@ -941,6 +857,9 @@ static int hfsplus_osx_setxattr(struct dentry *dentry, const char *name,
 	if (len > HFSPLUS_ATTR_MAX_STRLEN)
 		return -EOPNOTSUPP;
 
+	if (is_known_namespace(name))
+		return -EOPNOTSUPP;
+
 	strcpy(xattr_name, XATTR_MAC_OSX_PREFIX);
 	strcpy(xattr_name + XATTR_MAC_OSX_PREFIX_LEN, name);
 
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
