Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2FE947F56
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 05:53:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B42A4AC002
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 03:53:07 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	yJajh8Yssot02xYt for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 03:53:06 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGRkk-0000sa-FQ
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 20:53:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGRkk-0008Ap-EK
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 20:53:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: fix memory allocation failures with ACLs
Date: Mon,  2 Sep 2013 20:52:59 +1000
Message-Id: <1378119180-31380-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1378119180-31380-1-git-send-email-david@fromorbit.com>
References: <1378119180-31380-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Ever since increasing the number of supported ACLs from 25 to as
many as can fit in an xattr, there have been reports of order 4
memory allocations failing in the ACL code. Fix it in the same way
we've fixed all the xattr read/write code that has the same problem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_acl.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 6951896..4ea73cc 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -152,9 +152,12 @@ xfs_get_acl(struct inode *inode, int type)
 	 * go out to the disk.
 	 */
 	len = XFS_ACL_MAX_SIZE(ip->i_mount);
-	xfs_acl = kzalloc(len, GFP_KERNEL);
-	if (!xfs_acl)
-		return ERR_PTR(-ENOMEM);
+	xfs_acl = kmem_zalloc(len, KM_SLEEP | KM_MAYFAIL);
+	if (!xfs_acl) {
+		xfs_acl = kmem_zalloc_large(len);
+		if (!xfs_acl)
+			return ERR_PTR(-ENOMEM);
+	}
 
 	error = -xfs_attr_get(ip, ea_name, (unsigned char *)xfs_acl,
 							&len, ATTR_ROOT);
@@ -175,10 +178,13 @@ xfs_get_acl(struct inode *inode, int type)
 	if (IS_ERR(acl))
 		goto out;
 
- out_update_cache:
+out_update_cache:
 	set_cached_acl(inode, type, acl);
- out:
-	kfree(xfs_acl);
+out:
+	if (is_vmalloc_addr(xfs_acl))
+		kmem_free_large(xfs_acl);
+	else
+		kfree(xfs_acl);
 	return acl;
 }
 
@@ -209,9 +215,12 @@ xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 		struct xfs_acl *xfs_acl;
 		int len = XFS_ACL_MAX_SIZE(ip->i_mount);
 
-		xfs_acl = kzalloc(len, GFP_KERNEL);
-		if (!xfs_acl)
-			return -ENOMEM;
+		xfs_acl = kmem_zalloc(len, KM_SLEEP | KM_MAYFAIL);
+		if (!xfs_acl) {
+			xfs_acl = kmem_zalloc_large(len);
+			if (!xfs_acl)
+				return -ENOMEM;
+		}
 
 		xfs_acl_to_disk(xfs_acl, acl);
 
@@ -222,7 +231,10 @@ xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 		error = -xfs_attr_set(ip, ea_name, (unsigned char *)xfs_acl,
 				len, ATTR_ROOT);
 
-		kfree(xfs_acl);
+		if (is_vmalloc_addr(xfs_acl))
+			kmem_free_large(xfs_acl);
+		else
+			kfree(xfs_acl);
 	} else {
 		/*
 		 * A NULL ACL argument means we want to remove the ACL.
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
