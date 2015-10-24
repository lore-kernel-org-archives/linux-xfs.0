Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2961C7F62
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 16:16:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 163CA8F8033
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 14:16:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1crQDSH8CmMU2cEF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 24 Oct 2015 14:16:18 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 7CE86A84
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 21:16:17 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 2/4] xfs: SGI ACLs: Fix caching and mode setting
Date: Sat, 24 Oct 2015 23:16:07 +0200
Message-Id: <1445721369-25679-3-git-send-email-agruenba@redhat.com>
In-Reply-To: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
References: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

POSIX ACLs on XFS are exposed as system.posix_acl_* as well as
trusted.SGI_ACL_*.  Setting the system attributes updates inode->i_mode,
inode->i_acl, and inode->i_default_acl as it should, but setting the trusted
attributes does not do that.  Fix that by adding xattr handlers for the two
trusted.SGI_ACL_* attributes.

The handlers must be installed before the trusted.* xattr handler in
xfs_xattr_handlers to take effect.

Other than before, trusted.SGI_ACL_* attribute values are now verified and
cannot be set to invalid values anymore.  Access to those attributes is still
limited to users capable of CAP_SYS_ADMIN, while the system.posix_acl_*
attributes can be read by anyone and set by the file owner.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_acl.c   | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_acl.h   |  3 +++
 fs/xfs/xfs_xattr.c |  4 ++-
 3 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 763e365..0eea7ee 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -305,3 +305,79 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
  set_acl:
 	return __xfs_set_acl(inode, type, acl);
 }
+
+static int
+xfs_xattr_acl_get(struct dentry *dentry, const char *name,
+		  void *value, size_t size, int type)
+{
+	struct inode *inode = d_inode(dentry);
+	struct posix_acl *acl;
+	int error;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	acl = get_acl(inode, type);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+
+	error = XFS_ACL_SIZE(acl->a_count);
+	if (value) {
+		if (error > size)
+			error = -ERANGE;
+		else
+			xfs_acl_to_disk(value, acl);
+	}
+
+	posix_acl_release(acl);
+	return error;
+}
+
+static int
+xfs_xattr_acl_set(struct dentry *dentry, const char *name,
+		  const void *value, size_t size, int flags, int type)
+{
+	struct inode *inode = d_inode(dentry);
+	struct xfs_inode *ip = XFS_I(inode);
+	struct posix_acl *acl = NULL;
+	int error;
+
+	if (!inode->i_op->set_acl)
+		return -EOPNOTSUPP;
+
+	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
+		return value ? -EACCES : 0;
+
+	if (value) {
+		acl = xfs_acl_from_disk(value, size, XFS_ACL_MAX_ENTRIES(ip->i_mount));
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+
+		if (acl) {
+			error = posix_acl_valid(acl);
+			if (error)
+				goto out;
+		}
+	}
+
+	error = inode->i_op->set_acl(inode, acl, type);
+out:
+	posix_acl_release(acl);
+	return error;
+}
+
+const struct xattr_handler xfs_xattr_sgi_acl_file = {
+	.prefix = XATTR_TRUSTED_PREFIX SGI_ACL_FILE,
+	.flags	= ACL_TYPE_ACCESS,
+	.get	= xfs_xattr_acl_get,
+	.set	= xfs_xattr_acl_set,
+};
+
+const struct xattr_handler xfs_xattr_sgi_acl_default = {
+	.prefix = XATTR_TRUSTED_PREFIX SGI_ACL_DEFAULT,
+	.flags	= ACL_TYPE_DEFAULT,
+	.get	= xfs_xattr_acl_get,
+	.set	= xfs_xattr_acl_set,
+};
diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 3841b07..461dea6 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -27,6 +27,9 @@ extern struct posix_acl *xfs_get_acl(struct inode *inode, int type);
 extern int xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 extern int posix_acl_access_exists(struct inode *inode);
 extern int posix_acl_default_exists(struct inode *inode);
+
+extern const struct xattr_handler xfs_xattr_sgi_acl_file;
+extern const struct xattr_handler xfs_xattr_sgi_acl_default;
 #else
 static inline struct posix_acl *xfs_get_acl(struct inode *inode, int type)
 {
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index c0368151..7534cb5 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -97,12 +97,14 @@ static const struct xattr_handler xfs_xattr_security_handler = {
 
 const struct xattr_handler *xfs_xattr_handlers[] = {
 	&xfs_xattr_user_handler,
-	&xfs_xattr_trusted_handler,
 	&xfs_xattr_security_handler,
 #ifdef CONFIG_XFS_POSIX_ACL
 	&posix_acl_access_xattr_handler,
 	&posix_acl_default_xattr_handler,
+	&xfs_xattr_sgi_acl_file,
+	&xfs_xattr_sgi_acl_default,
 #endif
+	&xfs_xattr_trusted_handler,
 	NULL
 };
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
