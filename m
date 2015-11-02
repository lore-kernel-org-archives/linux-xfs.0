Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8F3A229DF5
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 13:53:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 299A4AC002
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 11:53:05 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pJq5CHtmIVZH9F5f (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 Nov 2015 11:53:05 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 2/2] xfs: invalidate cached acl if set via ioctl
Date: Mon,  2 Nov 2015 20:52:54 +0100
Message-Id: <1446493974-24669-3-git-send-email-agruenba@redhat.com>
In-Reply-To: <1446493974-24669-1-git-send-email-agruenba@redhat.com>
References: <1446493974-24669-1-git-send-email-agruenba@redhat.com>
References: <1446217508-22157-1-git-send-email-agruenba@redhat.com>
	<20151102025352.GY19199@dastard>
In-Reply-To: <20151102025352.GY19199@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, xfs@oss.sgi.com

Setting or removing the "SGI_ACL_[FILE|DEFAULT]" attributes via the
XFS_IOC_ATTRMULTI_BY_HANDLE ioctl completely bypasses the POSIX ACL
infrastructure, like setting the "trusted.SGI_ACL_[FILE|DEFAULT]" xattrs
did until commit 6caa1056.  Similar to that commit, invalidate cached
acls when setting/removing them via the ioctl as well.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_acl.h   |  3 +++
 fs/xfs/xfs_ioctl.c | 10 +++++++++-
 fs/xfs/xfs_xattr.c | 38 ++++++++++++++++++++++++--------------
 3 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 3841b07..75af0a4 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -36,4 +36,7 @@ static inline struct posix_acl *xfs_get_acl(struct inode *inode, int type)
 # define posix_acl_access_exists(inode)			0
 # define posix_acl_default_exists(inode)		0
 #endif /* CONFIG_XFS_POSIX_ACL */
+
+extern void xfs_forget_acl(struct inode *inode, const char *name, int xflags);
+
 #endif	/* __XFS_ACL_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 66bcfbd..d42738d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -40,6 +40,7 @@
 #include "xfs_symlink.h"
 #include "xfs_trans.h"
 #include "xfs_pnfs.h"
+#include "xfs_acl.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -494,6 +495,8 @@ xfs_attrmulti_attr_set(
 		return PTR_ERR(kbuf);
 
 	error = xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
+	if (!error)
+		xfs_forget_acl(inode, name, flags);
 	kfree(kbuf);
 	return error;
 }
@@ -504,9 +507,14 @@ xfs_attrmulti_attr_remove(
 	unsigned char		*name,
 	__uint32_t		flags)
 {
+	int			error;
+
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
-	return xfs_attr_remove(XFS_I(inode), name, flags);
+	error = xfs_attr_remove(XFS_I(inode), name, flags);
+	if (!error)
+		xfs_forget_acl(inode, name, flags);
+	return error;
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 1542d64..8294f86 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -53,6 +53,28 @@ xfs_xattr_get(struct dentry *dentry, const char *name,
 	return asize;
 }
 
+void
+xfs_forget_acl(
+	struct inode		*inode,
+	const char		*name,
+	int			xflags)
+{
+	/*
+	 * Invalidate any cached ACLs if the user has bypassed the ACL
+	 * interface. We don't validate the content whatsoever so it is caller
+	 * responsibility to provide data in valid format and ensure i_mode is
+	 * consistent.
+	 */
+	if (xflags & ATTR_ROOT) {
+#ifdef CONFIG_XFS_POSIX_ACL
+		if (!strcmp(name, SGI_ACL_FILE))
+			forget_cached_acl(inode, ACL_TYPE_ACCESS);
+		else if (!strcmp(name, SGI_ACL_DEFAULT))
+			forget_cached_acl(inode, ACL_TYPE_DEFAULT);
+#endif
+	}
+}
+
 static int
 xfs_xattr_set(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags, int xflags)
@@ -73,20 +95,8 @@ xfs_xattr_set(struct dentry *dentry, const char *name, const void *value,
 		return xfs_attr_remove(ip, (unsigned char *)name, xflags);
 	error = xfs_attr_set(ip, (unsigned char *)name,
 				(void *)value, size, xflags);
-	/*
-	 * Invalidate any cached ACLs if the user has bypassed the ACL
-	 * interface. We don't validate the content whatsoever so it is caller
-	 * responsibility to provide data in valid format and ensure i_mode is
-	 * consistent.
-	 */
-	if (!error && (xflags & ATTR_ROOT)) {
-#ifdef CONFIG_XFS_POSIX_ACL
-		if (!strcmp(name, SGI_ACL_FILE)
-			forget_cached_acl(VFS_I(ip), ACL_TYPE_ACCESS);
-		else if (!strcmp(name, SGI_ACL_DEFAULT))
-			forget_cached_acl(VFS_I(ip), ACL_TYPE_DEFAULT);
-#endif
-	}
+	if (!error)
+		xfs_forget_acl(d_inode(dentry), name, xflags);
 
 	return error;
 }
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
