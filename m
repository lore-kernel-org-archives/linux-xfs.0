Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 53F6E7F88
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 08:29:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E3CB8F8040
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 06:29:24 -0800 (PST)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id 8kBk4eHTj15piA4O (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 06:28:52 -0800 (PST)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Fri, 13 Dec 2013 09:28:22 -0500
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com
	[9.57.198.27])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 3300AC9003E
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 09:28:17 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp23032.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	rBDESIeU9830752 for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 14:28:18 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	rBDESIPX004887 for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 09:28:18 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: [PATCH 4/5] xfs: add a new method xfs_vn_tmpfile()
Date: Fri, 13 Dec 2013 22:27:52 +0800
Message-Id: <1386944873-16796-5-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
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
Cc: linux-fsdevel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Add a new O_TMPFILE method to VFS inteface.
For more info, please refer to:
  http://oss.sgi.com/archives/xfs/2013-08/msg00336.html

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_iops.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index eb55be5..b57cd89 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -39,6 +39,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_dinode.h"
+#include "xfs_trans_space.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -1051,6 +1052,25 @@ xfs_vn_fiemap(
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
+	error = xfs_create_tmpfile(XFS_I(dir), XFS_I(dir)->i_mount,
+				mode, 0, &ip);
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
@@ -1087,6 +1107,7 @@ static const struct inode_operations xfs_dir_inode_operations = {
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
+	.tmpfile		= xfs_vn_tmpfile,
 };
 
 static const struct inode_operations xfs_dir_ci_inode_operations = {
@@ -1113,6 +1134,7 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
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
