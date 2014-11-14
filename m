Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3D3F27F51
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 11:33:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C01F4AC009
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 09:33:53 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XrgBpXbnFf30U5TH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Nov 2014 09:33:52 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAEHXpjT029894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 12:33:51 -0500
Received: from hades.localdomain.com (ovpn-113-81.phx2.redhat.com
	[10.3.113.81])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sAEHXmpW000577
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 12:33:50 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/2] Make xfs_vn_rename compliant with renameat2() syscall
Date: Fri, 14 Nov 2014 15:33:29 -0200
Message-Id: <1415986410-18367-2-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1415986410-18367-1-git-send-email-cmaiolino@redhat.com>
References: <1415986410-18367-1-git-send-email-cmaiolino@redhat.com>
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

To be able to support RENAME_EXCHANGE flag from renameat2() system call, XFS
must have its inode_operations updated, exporting .rename2 method, instead of
.rename.

This patch just replaces the (now old) .rename method by .rename2, using the
same infra-structure, but checking rename flags.

calls to .rename2 using RENAME_EXCHANGE flag, although now handled inside XFS,
still returns -EINVAL.

RENAME_NOREPLACE is handled via VFS and we don't need to care about it inside
xfs_vn_rename.

Changelog:

	V2: Use xfs_vn_rename as-is, instead of rename it to xfs_vn_rename2

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_iops.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ec6dcdc..0b8704c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -383,18 +383,23 @@ xfs_vn_rename(
 	struct inode	*odir,
 	struct dentry	*odentry,
 	struct inode	*ndir,
-	struct dentry	*ndentry)
+	struct dentry	*ndentry,
+	unsigned int	flags)
 {
 	struct inode	*new_inode = ndentry->d_inode;
 	struct xfs_name	oname;
 	struct xfs_name	nname;
 
+	/* XFS does not support RENAME_EXCHANGE yet */
+	if (flags & ~RENAME_NOREPLACE)
+		return -EINVAL;
+
 	xfs_dentry_to_name(&oname, odentry, 0);
 	xfs_dentry_to_name(&nname, ndentry, odentry->d_inode->i_mode);
 
 	return xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
-			  XFS_I(ndir), &nname, new_inode ?
-						XFS_I(new_inode) : NULL);
+			  XFS_I(ndir), &nname,
+			  new_inode ? XFS_I(new_inode) : NULL);
 }
 
 /*
@@ -1147,7 +1152,7 @@ static const struct inode_operations xfs_dir_inode_operations = {
 	 */
 	.rmdir			= xfs_vn_unlink,
 	.mknod			= xfs_vn_mknod,
-	.rename			= xfs_vn_rename,
+	.rename2		= xfs_vn_rename,
 	.get_acl		= xfs_get_acl,
 	.set_acl		= xfs_set_acl,
 	.getattr		= xfs_vn_getattr,
@@ -1175,7 +1180,7 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
 	 */
 	.rmdir			= xfs_vn_unlink,
 	.mknod			= xfs_vn_mknod,
-	.rename			= xfs_vn_rename,
+	.rename2		= xfs_vn_rename,
 	.get_acl		= xfs_get_acl,
 	.set_acl		= xfs_set_acl,
 	.getattr		= xfs_vn_getattr,
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
