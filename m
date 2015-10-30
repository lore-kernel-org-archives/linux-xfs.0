Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A50E97F3F
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 09:46:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 392E3AC001
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 07:46:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RIRSAhJYk6kHZdFj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2015 07:46:38 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id C9C5B344EB4
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 14:46:37 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-105.bos.redhat.com [10.18.41.105])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t9UEkbbR020956
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 10:46:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: invalidate cached acl if set directly via xattr
Date: Fri, 30 Oct 2015 10:46:36 -0400
Message-Id: <1446216396-10608-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

ACLs are stored as extended attributes of the inode to which they apply.
XFS converts the standard "system.posix_acl_[access|default]" attribute
names used to control ACLs to "trusted.SGI_ACL_[FILE|DEFAULT]" as stored
on-disk. These xattrs are directly exposed in on-disk format via
getxattr/setxattr, without any ACL aware code in the path to perform
validation, etc. This is partly historical and supports backup/restore
applications such as xfsdump to back up and restore the binary blob that
represents ACLs as-is.

Andreas reports that the ACLs observed via the getfacl interface is not
consistent when ACLs are set directly via the setxattr path. This occurs
because the ACLs are cached in-core against the inode and the xattr path
has no knowledge that the operation relates to ACLs.

Update the xattr set codepath to trap writes of the special XFS ACL
attributes and invalidate the associated cached ACL when this occurs.
This ensures that the correct ACLs are used on a subsequent operation
through the actual ACL interface.

Note that this does not update or add support for setting the ACL xattrs
directly beyond the restore use case that requires a correctly formatted
binary blob and to restore a consistent i_mode at the same time. It is
still possible for a root user to set an invalid or inconsistent (with
i_mode) ACL blob on-disk and potentially cause corruption.

Reported-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

It appears that we don't have much agreement on the best way (and to
what degree) to deal with the historical SGI_ACL_* xattrs. What we do
know is that the cached ACLs are inconsistent when these xattrs are set
directly and this is problematic for the primary backup/restore use
case. This patch purely addresses the caching problem.

Brian

 fs/xfs/xfs_xattr.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index c0368151..2e1eb80 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -57,7 +57,8 @@ static int
 xfs_xattr_set(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags, int xflags)
 {
-	struct xfs_inode *ip = XFS_I(d_inode(dentry));
+	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
+	int			error;
 
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
@@ -70,8 +71,22 @@ xfs_xattr_set(struct dentry *dentry, const char *name, const void *value,
 
 	if (!value)
 		return xfs_attr_remove(ip, (unsigned char *)name, xflags);
-	return xfs_attr_set(ip, (unsigned char *)name,
+	error = xfs_attr_set(ip, (unsigned char *)name,
 				(void *)value, size, xflags);
+	/*
+	 * Invalidate any cached ACLs if the user has bypassed the ACL
+	 * interface. We don't validate the content whatsoever so it is caller
+	 * responsibility to provide data in valid format and ensure i_mode is
+	 * consistent.
+	 */
+	if (!error && (xflags & ATTR_ROOT)) {
+		if (!strncmp(name, SGI_ACL_FILE, strlen(name)))
+			forget_cached_acl(VFS_I(ip), ACL_TYPE_ACCESS);
+		else if (!strncmp(name, SGI_ACL_DEFAULT, strlen(name)))
+			forget_cached_acl(VFS_I(ip), ACL_TYPE_DEFAULT);
+	}
+
+	return error;
 }
 
 static const struct xattr_handler xfs_xattr_user_handler = {
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
