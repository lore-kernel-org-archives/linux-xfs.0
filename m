Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56572 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752409AbdFVNb2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jun 2017 09:31:28 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/11] xfs: Don't clear SGID when inheriting ACLs
Date: Thu, 22 Jun 2017 15:31:15 +0200
Message-Id: <20170622133115.16968-12-jack@suse.cz>
In-Reply-To: <20170622133115.16968-1-jack@suse.cz>
References: <20170622133115.16968-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>, stable@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

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
CC: stable@vger.kernel.org
CC: Darrick J. Wong <darrick.wong@oracle.com>
CC: linux-xfs@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_acl.c  | 6 +++---
 fs/xfs/xfs_acl.h  | 1 +
 fs/xfs/xfs_iops.c | 4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index b468e041f207..7034e17535de 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -170,8 +170,8 @@ xfs_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
-STATIC int
-__xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
+int
+__xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	struct xfs_inode *ip = XFS_I(inode);
 	unsigned char *ea_name;
@@ -268,5 +268,5 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	}
 
  set_acl:
-	return __xfs_set_acl(inode, type, acl);
+	return __xfs_set_acl(inode, acl, type);
 }
diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 286fa89217f5..04327318ef67 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -24,6 +24,7 @@ struct posix_acl;
 #ifdef CONFIG_XFS_POSIX_ACL
 extern struct posix_acl *xfs_get_acl(struct inode *inode, int type);
 extern int xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
+extern int __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 #else
 static inline struct posix_acl *xfs_get_acl(struct inode *inode, int type)
 {
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ebfc13350f9a..077e2b2ac773 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -190,12 +190,12 @@ xfs_generic_create(
 
 #ifdef CONFIG_XFS_POSIX_ACL
 	if (default_acl) {
-		error = xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
+		error = __xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
 		if (error)
 			goto out_cleanup_inode;
 	}
 	if (acl) {
-		error = xfs_set_acl(inode, acl, ACL_TYPE_ACCESS);
+		error = __xfs_set_acl(inode, acl, ACL_TYPE_ACCESS);
 		if (error)
 			goto out_cleanup_inode;
 	}
-- 
2.12.3

