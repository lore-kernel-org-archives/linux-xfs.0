Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43462 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754509AbdJINUr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 09:20:47 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 09 Oct 2017 13:44:24 +0100
Message-ID: <lsq.1507553064.729046564@decadent.org.uk>
Subject: [PATCH 3.16 053/192] xfs: Don't clear SGID when inheriting ACLs
In-Reply-To: <lsq.1507553063.449494954@decadent.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

3.16.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 8ba358756aa08414fa9e65a1a41d28304ed6fd7f upstream.

When new directory 'DIR1' is created in a directory 'DIR0' with SGID bit
set, DIR1 is expected to have SGID bit set (and owning group equal to
the owning group of 'DIR0'). However when 'DIR0' also has some default
ACLs that 'DIR1' inherits, setting these ACLs will result in SGID bit on
'DIR1' to get cleared if user is not member of the owning group.

Fix the problem by calling __xfs_set_acl() instead of xfs_set_acl() when
setting up inode in xfs_generic_create(). That prevents SGID bit
clearing and mode is properly set by posix_acl_create() anyway. We also
reorder arguments of __xfs_set_acl() to match the ordering of
xfs_set_acl() to make things consistent.

Fixes: 073931017b49d9458aa351605b43a7e34598caef
CC: Darrick J. Wong <darrick.wong@oracle.com>
CC: linux-xfs@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/xfs/xfs_acl.c  | 6 +++---
 fs/xfs/xfs_acl.h  | 1 +
 fs/xfs/xfs_iops.c | 4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -176,8 +176,8 @@ out:
 	return acl;
 }
 
-STATIC int
-__xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
+int
+__xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	struct xfs_inode *ip = XFS_I(inode);
 	unsigned char *ea_name;
@@ -297,5 +297,5 @@ xfs_set_acl(struct inode *inode, struct
 	}
 
  set_acl:
-	return __xfs_set_acl(inode, type, acl);
+	return __xfs_set_acl(inode, acl, type);
 }
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -61,6 +61,7 @@ struct xfs_acl {
 #ifdef CONFIG_XFS_POSIX_ACL
 extern struct posix_acl *xfs_get_acl(struct inode *inode, int type);
 extern int xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
+extern int __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 extern int posix_acl_access_exists(struct inode *inode);
 extern int posix_acl_default_exists(struct inode *inode);
 #else
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -173,12 +173,12 @@ xfs_generic_create(
 
 #ifdef CONFIG_XFS_POSIX_ACL
 	if (default_acl) {
-		error = -xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
+		error = -__xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
 		if (error)
 			goto out_cleanup_inode;
 	}
 	if (acl) {
-		error = -xfs_set_acl(inode, acl, ACL_TYPE_ACCESS);
+		error = -__xfs_set_acl(inode, acl, ACL_TYPE_ACCESS);
 		if (error)
 			goto out_cleanup_inode;
 	}

