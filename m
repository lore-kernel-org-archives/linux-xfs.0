Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9E73A7F54
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 05:32:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6D0C48F8065
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 03:32:55 -0800 (PST)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id mNHWfq8Tj5NXBwKb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 03:32:54 -0800 (PST)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Mon, 25 Nov 2013 06:32:52 -0500
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com
	[9.57.198.24])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 7697038C8047
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 06:32:48 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22034.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	rAPBWnT93146186 for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 11:32:49 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	rAPBWn1v023984 for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 06:32:49 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: [RFC PATCH 3/4] xfs: add a new method xfs_vn_tmpfile()
Date: Mon, 25 Nov 2013 19:32:33 +0800
Message-Id: <1385379154-3802-4-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
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
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Add a new O_TMPFILE method to VFS inteface.

http://oss.sgi.com/archives/xfs/2013-08/msg00336.html

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_iops.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index eb55be5..5d2e781 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -39,6 +39,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_dinode.h"
+#include "xfs_trans_space.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -1051,6 +1052,24 @@ xfs_vn_fiemap(
 	return 0;
 }
 
+STATIC int
+xfs_vn_tmpfile(
+	struct inode	*dir,
+	struct dentry	*dentry,
+	umode_t		mode)
+{
+	struct xfs_inode *ip = NULL;
+	int		error;
+
+	error = xfs_create_tmpfile(XFS_I(dir)->i_mount, mode, 0, &ip);
+	if (error)
+		return -error;
+
+	d_instantiate(dentry, VFS_I(ip));
+
+	return -error;
+}
+
 static const struct inode_operations xfs_inode_operations = {
 	.get_acl		= xfs_get_acl,
 	.getattr		= xfs_vn_getattr,
@@ -1087,6 +1106,7 @@ static const struct inode_operations xfs_dir_inode_operations = {
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
+	.tmpfile		= xfs_vn_tmpfile,
 };
 
 static const struct inode_operations xfs_dir_ci_inode_operations = {
@@ -1113,6 +1133,7 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
+	.tmpfile		= xfs_vn_tmpfile,
 };
 
 static const struct inode_operations xfs_symlink_inode_operations = {
-- 
1.7.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
