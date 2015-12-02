Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4252A29E0C
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 07:45:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F3F9C8F80E7
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 05:45:15 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id moqHcPc2A9g43t9X (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 05:45:14 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 08/11] xfs: Change how listxattr generates synthetic
	attributes
Date: Wed,  2 Dec 2015 14:44:40 +0100
Message-Id: <1449063883-22097-9-git-send-email-agruenba@redhat.com>
In-Reply-To: <1449063883-22097-1-git-send-email-agruenba@redhat.com>
References: <1449063883-22097-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, xfs@oss.sgi.com

Instead of adding the synthesized POSIX ACL attribute names after listing all
non-synthesized attributes, generate them immediately when listing the
non-synthesized attributes.

In addition, merge xfs_xattr_put_listent and xfs_xattr_put_listent_sizes to
ensure that the list size is computed correctly; the split version was
overestimating the list size for non-root users.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com
---
 fs/xfs/xfs_acl.c   |  23 ---------
 fs/xfs/xfs_acl.h   |   4 --
 fs/xfs/xfs_xattr.c | 137 +++++++++++++++++++++++------------------------------
 3 files changed, 59 insertions(+), 105 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 6bb470f..2d5df1f 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -252,29 +252,6 @@ xfs_set_mode(struct inode *inode, umode_t mode)
 	return error;
 }
 
-static int
-xfs_acl_exists(struct inode *inode, unsigned char *name)
-{
-	int len = XFS_ACL_MAX_SIZE(XFS_M(inode->i_sb));
-
-	return (xfs_attr_get(XFS_I(inode), name, NULL, &len,
-			    ATTR_ROOT|ATTR_KERNOVAL) == 0);
-}
-
-int
-posix_acl_access_exists(struct inode *inode)
-{
-	return xfs_acl_exists(inode, SGI_ACL_FILE);
-}
-
-int
-posix_acl_default_exists(struct inode *inode)
-{
-	if (!S_ISDIR(inode->i_mode))
-		return 0;
-	return xfs_acl_exists(inode, SGI_ACL_DEFAULT);
-}
-
 int
 xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 52f8255..286fa89 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -24,16 +24,12 @@ struct posix_acl;
 #ifdef CONFIG_XFS_POSIX_ACL
 extern struct posix_acl *xfs_get_acl(struct inode *inode, int type);
 extern int xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
-extern int posix_acl_access_exists(struct inode *inode);
-extern int posix_acl_default_exists(struct inode *inode);
 #else
 static inline struct posix_acl *xfs_get_acl(struct inode *inode, int type)
 {
 	return NULL;
 }
 # define xfs_set_acl					NULL
-# define posix_acl_access_exists(inode)			0
-# define posix_acl_default_exists(inode)		0
 #endif /* CONFIG_XFS_POSIX_ACL */
 
 extern void xfs_forget_acl(struct inode *inode, const char *name, int xflags);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 36a4385..110f1d7 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -129,47 +129,19 @@ const struct xattr_handler *xfs_xattr_handlers[] = {
 	NULL
 };
 
-static unsigned int xfs_xattr_prefix_len(int flags)
-{
-	if (flags & XFS_ATTR_SECURE)
-		return sizeof("security");
-	else if (flags & XFS_ATTR_ROOT)
-		return sizeof("trusted");
-	else
-		return sizeof("user");
-}
-
-static const char *xfs_xattr_prefix(int flags)
-{
-	if (flags & XFS_ATTR_SECURE)
-		return xfs_xattr_security_handler.prefix;
-	else if (flags & XFS_ATTR_ROOT)
-		return xfs_xattr_trusted_handler.prefix;
-	else
-		return xfs_xattr_user_handler.prefix;
-}
-
 static int
-xfs_xattr_put_listent(
+__xfs_xattr_put_listent(
 	struct xfs_attr_list_context *context,
-	int		flags,
-	unsigned char	*name,
-	int		namelen,
-	int		valuelen,
-	unsigned char	*value)
+	char *prefix,
+	int prefix_len,
+	unsigned char *name,
+	int namelen)
 {
-	unsigned int prefix_len = xfs_xattr_prefix_len(flags);
 	char *offset;
 	int arraytop;
 
-	ASSERT(context->count >= 0);
-
-	/*
-	 * Only show root namespace entries if we are actually allowed to
-	 * see them.
-	 */
-	if ((flags & XFS_ATTR_ROOT) && !capable(CAP_SYS_ADMIN))
-		return 0;
+	if (!context->alist)
+		goto compute_size;
 
 	arraytop = context->count + prefix_len + namelen + 1;
 	if (arraytop > context->firstu) {
@@ -177,17 +149,19 @@ xfs_xattr_put_listent(
 		return 1;
 	}
 	offset = (char *)context->alist + context->count;
-	strncpy(offset, xfs_xattr_prefix(flags), prefix_len);
+	strncpy(offset, prefix, prefix_len);
 	offset += prefix_len;
 	strncpy(offset, (char *)name, namelen);			/* real name */
 	offset += namelen;
 	*offset = '\0';
+
+compute_size:
 	context->count += prefix_len + namelen + 1;
 	return 0;
 }
 
 static int
-xfs_xattr_put_listent_sizes(
+xfs_xattr_put_listent(
 	struct xfs_attr_list_context *context,
 	int		flags,
 	unsigned char	*name,
@@ -195,24 +169,55 @@ xfs_xattr_put_listent_sizes(
 	int		valuelen,
 	unsigned char	*value)
 {
-	context->count += xfs_xattr_prefix_len(flags) + namelen + 1;
-	return 0;
-}
+	char *prefix;
+	int prefix_len;
 
-static int
-list_one_attr(const char *name, const size_t len, void *data,
-		size_t size, ssize_t *result)
-{
-	char *p = data + *result;
+	ASSERT(context->count >= 0);
 
-	*result += len;
-	if (!size)
-		return 0;
-	if (*result > size)
-		return -ERANGE;
+	if (flags & XFS_ATTR_ROOT) {
+#ifdef CONFIG_XFS_POSIX_ACL
+		if (namelen == SGI_ACL_FILE_SIZE &&
+		    strncmp(name, SGI_ACL_FILE,
+			    SGI_ACL_FILE_SIZE) == 0) {
+			int ret = __xfs_xattr_put_listent(
+					context, XATTR_SYSTEM_PREFIX,
+					XATTR_SYSTEM_PREFIX_LEN,
+					XATTR_POSIX_ACL_ACCESS,
+					strlen(XATTR_POSIX_ACL_ACCESS));
+			if (ret)
+				return ret;
+		} else if (namelen == SGI_ACL_DEFAULT_SIZE &&
+			 strncmp(name, SGI_ACL_DEFAULT,
+				 SGI_ACL_DEFAULT_SIZE) == 0) {
+			int ret = __xfs_xattr_put_listent(
+					context, XATTR_SYSTEM_PREFIX,
+					XATTR_SYSTEM_PREFIX_LEN,
+					XATTR_POSIX_ACL_DEFAULT,
+					strlen(XATTR_POSIX_ACL_DEFAULT));
+			if (ret)
+				return ret;
+		}
+#endif
 
-	strcpy(p, name);
-	return 0;
+		/*
+		 * Only show root namespace entries if we are actually allowed to
+		 * see them.
+		 */
+		if (!capable(CAP_SYS_ADMIN))
+			return 0;
+
+		prefix = XATTR_TRUSTED_PREFIX;
+		prefix_len = XATTR_TRUSTED_PREFIX_LEN;
+	} else if (flags & XFS_ATTR_SECURE) {
+		prefix = XATTR_SECURITY_PREFIX;
+		prefix_len = XATTR_SECURITY_PREFIX_LEN;
+	} else {
+		prefix = XATTR_USER_PREFIX;
+		prefix_len = XATTR_USER_PREFIX_LEN;
+	}
+
+	return __xfs_xattr_put_listent(context, prefix, prefix_len, name,
+				       namelen);
 }
 
 ssize_t
@@ -221,7 +226,6 @@ xfs_vn_listxattr(struct dentry *dentry, char *data, size_t size)
 	struct xfs_attr_list_context context;
 	struct attrlist_cursor_kern cursor = { 0 };
 	struct inode		*inode = d_inode(dentry);
-	int			error;
 
 	/*
 	 * First read the regular on-disk attributes.
@@ -230,37 +234,14 @@ xfs_vn_listxattr(struct dentry *dentry, char *data, size_t size)
 	context.dp = XFS_I(inode);
 	context.cursor = &cursor;
 	context.resynch = 1;
-	context.alist = data;
+	context.alist = size ? data : NULL;
 	context.bufsize = size;
 	context.firstu = context.bufsize;
-
-	if (size)
-		context.put_listent = xfs_xattr_put_listent;
-	else
-		context.put_listent = xfs_xattr_put_listent_sizes;
+	context.put_listent = xfs_xattr_put_listent;
 
 	xfs_attr_list_int(&context);
 	if (context.count < 0)
 		return -ERANGE;
 
-	/*
-	 * Then add the two synthetic ACL attributes.
-	 */
-	if (posix_acl_access_exists(inode)) {
-		error = list_one_attr(XATTR_NAME_POSIX_ACL_ACCESS,
-				strlen(XATTR_NAME_POSIX_ACL_ACCESS) + 1,
-				data, size, &context.count);
-		if (error)
-			return error;
-	}
-
-	if (posix_acl_default_exists(inode)) {
-		error = list_one_attr(XATTR_NAME_POSIX_ACL_DEFAULT,
-				strlen(XATTR_NAME_POSIX_ACL_DEFAULT) + 1,
-				data, size, &context.count);
-		if (error)
-			return error;
-	}
-
 	return context.count;
 }
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
