Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C4A747F47
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 08:23:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A4F4D304039
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 06:23:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id laP1cNh2DMsCKSKJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 11 Oct 2015 06:23:18 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH] xfs: Fix error path in xfs_get_acl
Date: Sun, 11 Oct 2015 15:23:11 +0200
Message-Id: <1444569791-26719-1-git-send-email-agruenba@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

Error codes from xfs_attr_get other than -ENOATTR were not properly 
reported.  Fix that, and clean the code up somewhat.

In addition, the declaration of struct xfs_inode in xfs_acl.h isn't needed.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_acl.c | 19 +++++++------------
 fs/xfs/xfs_acl.h |  1 -
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 4b64167..0f4ee92 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -122,7 +122,7 @@ struct posix_acl *
 xfs_get_acl(struct inode *inode, int type)
 {
 	struct xfs_inode *ip = XFS_I(inode);
-	struct posix_acl *acl = NULL;
+	struct posix_acl *acl;
 	struct xfs_acl *xfs_acl;
 	unsigned char *ea_name;
 	int error;
@@ -158,18 +158,13 @@ xfs_get_acl(struct inode *inode, int type)
 		 * cache entry, for any other error assume it is transient and
 		 * leave the cache entry as ACL_NOT_CACHED.
 		 */
-		if (error == -ENOATTR)
-			goto out_update_cache;
-		goto out;
-	}
+		acl = (error == -ENOATTR) ? NULL : ERR_PTR(error);
+	} else
+		acl = xfs_acl_from_disk(xfs_acl,
+					XFS_ACL_MAX_ENTRIES(ip->i_mount));
 
-	acl = xfs_acl_from_disk(xfs_acl, XFS_ACL_MAX_ENTRIES(ip->i_mount));
-	if (IS_ERR(acl))
-		goto out;
-
-out_update_cache:
-	set_cached_acl(inode, type, acl);
-out:
+	if (!IS_ERR(acl))
+		set_cached_acl(inode, type, acl);
 	kmem_free(xfs_acl);
 	return acl;
 }
diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 3841b07..9ee0a0d 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -20,7 +20,6 @@
 
 struct inode;
 struct posix_acl;
-struct xfs_inode;
 
 #ifdef CONFIG_XFS_POSIX_ACL
 extern struct posix_acl *xfs_get_acl(struct inode *inode, int type);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
