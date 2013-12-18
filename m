Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 516AC29E05
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 18:23:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3CAB98F8092
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 16:23:07 -0800 (PST)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id Sl77wM8pedPz3eWL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Dec 2013 16:23:05 -0800 (PST)
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Tue, 17 Dec 2013 17:23:05 -0700
Received: from b03cxnp08025.gho.boulder.ibm.com
	(b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 368EF3E4003E
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 17:23:03 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08025.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with
	ESMTP id rBI0N3Xs5505390
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 01:23:03 +0100
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP
	id rBI0N2uw015511
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 17:23:03 -0700
From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: [PATCH v2 2/3] xfs: add O_TMPFILE support
Date: Wed, 18 Dec 2013 08:22:40 +0800
Message-Id: <1387326161-24530-3-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1387326161-24530-1-git-send-email-zwu.kernel@gmail.com>
References: <1387326161-24530-1-git-send-email-zwu.kernel@gmail.com>
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

Add two functions xfs_create_tmpfile() and xfs_vn_tmpfile()
to support O_TMPFILE file creation.

In contrast to xfs_create(), xfs_create_tmpfile() has a different
log reservation to the regular file creation because there is no
directory modification, and doesn't check if an entry can be added
to the directory, but the reservation quotas is required appropriately,
and finally its inode is added to the unlinked list.

xfs_vn_tmpfile() add one O_TMPFILE method to VFS interface and directly
invoke xfs_create_tmpfile().

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_inode.c      |  107 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h      |    2 +
 fs/xfs/xfs_iops.c       |   16 +++++++
 fs/xfs/xfs_shared.h     |    4 +-
 fs/xfs/xfs_trans_resv.c |   36 +++++++++++++++-
 fs/xfs/xfs_trans_resv.h |    2 +
 6 files changed, 164 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c79b875..ac133ea 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1333,6 +1333,113 @@ xfs_create(
 }
 
 int
+xfs_create_tmpfile(
+	struct xfs_inode	*dp,
+	struct dentry		*dentry,
+	umode_t			mode)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_inode	*ip = NULL;
+	struct xfs_trans	*tp = NULL;
+	int			error;
+	uint			cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
+	prid_t                  prid;
+	struct xfs_dquot	*udqp = NULL;
+	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*pdqp = NULL;
+	struct xfs_trans_res	*tres;
+	uint			resblks;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	prid = xfs_get_initial_prid(dp);
+
+	/*
+	 * Make sure that we have allocated dquot(s) on disk.
+	 */
+	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(current_fsuid()),
+				xfs_kgid_to_gid(current_fsgid()), prid,
+				XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
+				&udqp, &gdqp, &pdqp);
+	if (error)
+		return error;
+
+	resblks = XFS_IALLOC_SPACE_RES(mp);
+	tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE_TMPFILE);
+
+	tres = &M_RES(mp)->tr_create_tmpfile;
+	error = xfs_trans_reserve(tp, tres, resblks, 0);
+	if (error == ENOSPC) {
+		/* No space at all so try a "no-allocation" reservation */
+		resblks = 0;
+		error = xfs_trans_reserve(tp, tres, 0, 0);
+	}
+	if (error) {
+		cancel_flags = 0;
+		goto out_trans_cancel;
+	}
+
+	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
+						pdqp, resblks, 1, 0);
+	if (error)
+		goto out_trans_cancel;
+
+	error = xfs_dir_ialloc(&tp, dp, mode, 1, 0,
+				prid, resblks > 0, &ip, NULL);
+	if (error) {
+		if (error == ENOSPC)
+			goto out_trans_cancel;
+		goto out_trans_abort;
+	}
+
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(tp);
+
+	/*
+	 * Attach the dquot(s) to the inodes and modify them incore.
+	 * These ids of the inode couldn't have changed since the new
+	 * inode has been locked ever since it was created.
+	 */
+	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
+
+	ip->i_d.di_nlink--;
+	d_tmpfile(dentry, VFS_I(ip));
+	error = xfs_iunlink(tp, ip);
+	if (error)
+		goto out_trans_abort;
+
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	if (error)
+		goto out_release_inode;
+
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
+
+	return 0;
+
+ out_trans_abort:
+	cancel_flags |= XFS_TRANS_ABORT;
+ out_trans_cancel:
+	xfs_trans_cancel(tp, cancel_flags);
+ out_release_inode:
+	/*
+	 * Wait until after the current transaction is aborted to
+	 * release the inode.  This prevents recursive transactions
+	 * and deadlocks from xfs_inactive.
+	 */
+	if (ip)
+		IRELE(ip);
+
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
+
+	return error;
+}
+
+int
 xfs_link(
 	xfs_inode_t		*tdp,
 	xfs_inode_t		*sip,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 6c58349..3a97820 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -333,6 +333,8 @@ int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
 int		xfs_create(struct xfs_inode *dp, struct xfs_name *name,
 			   umode_t mode, xfs_dev_t rdev, struct xfs_inode **ipp);
+int		xfs_create_tmpfile(struct xfs_inode *dp, struct dentry *dentry,
+			   umode_t mode);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
 int		xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 27e0e54..5ea7f85 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -39,6 +39,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_dinode.h"
+#include "xfs_trans_space.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -1050,6 +1051,19 @@ xfs_vn_fiemap(
 	return 0;
 }
 
+STATIC int
+xfs_vn_tmpfile(
+	struct inode	*dir,
+	struct dentry	*dentry,
+	umode_t		mode)
+{
+	int		error;
+
+	error = xfs_create_tmpfile(XFS_I(dir), dentry, mode);
+
+	return -error;
+}
+
 static const struct inode_operations xfs_inode_operations = {
 	.get_acl		= xfs_get_acl,
 	.getattr		= xfs_vn_getattr,
@@ -1086,6 +1100,7 @@ static const struct inode_operations xfs_dir_inode_operations = {
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
+	.tmpfile		= xfs_vn_tmpfile,
 };
 
 static const struct inode_operations xfs_dir_ci_inode_operations = {
@@ -1112,6 +1127,7 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
+	.tmpfile		= xfs_vn_tmpfile,
 };
 
 static const struct inode_operations xfs_symlink_inode_operations = {
diff --git a/fs/xfs/xfs_shared.h b/fs/xfs/xfs_shared.h
index 8c5035a1..4484e51 100644
--- a/fs/xfs/xfs_shared.h
+++ b/fs/xfs/xfs_shared.h
@@ -104,7 +104,8 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 #define	XFS_TRANS_SB_COUNT		41
 #define	XFS_TRANS_CHECKPOINT		42
 #define	XFS_TRANS_ICREATE		43
-#define	XFS_TRANS_TYPE_MAX		43
+#define	XFS_TRANS_CREATE_TMPFILE	44
+#define	XFS_TRANS_TYPE_MAX		44
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 #define XFS_TRANS_TYPES \
@@ -112,6 +113,7 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 	{ XFS_TRANS_SETATTR_SIZE,	"SETATTR_SIZE" }, \
 	{ XFS_TRANS_INACTIVE,		"INACTIVE" }, \
 	{ XFS_TRANS_CREATE,		"CREATE" }, \
+	{ XFS_TRANS_CREATE_TMPFILE,	"CREATE_TMPFILE" }, \
 	{ XFS_TRANS_CREATE_TRUNC,	"CREATE_TRUNC" }, \
 	{ XFS_TRANS_TRUNCATE_FILE,	"TRUNCATE_FILE" }, \
 	{ XFS_TRANS_REMOVE,		"REMOVE" }, \
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index 2fd59c0..bd3b4b7 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -229,6 +229,18 @@ xfs_calc_link_reservation(
 }
 
 /*
+ * For adding an inode to unlinked list we can modify:
+ *    the agi hash list: sector size
+ *    the unlinked inode: inode size
+ */
+STATIC uint
+xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
+{
+	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		xfs_calc_inode_res(mp, 1);
+}
+
+/*
  * For removing a directory entry we can modify:
  *    the parent directory inode: inode size
  *    the removed inode: inode size
@@ -245,10 +257,11 @@ xfs_calc_remove_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		MAX((xfs_calc_inode_res(mp, 2) +
+		xfs_calc_iunlink_add_reservation(mp) +
+		MAX((xfs_calc_inode_res(mp, 1) +
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
+		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
 		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
 				      XFS_FSB_TO_B(mp, 1))));
 }
@@ -343,6 +356,20 @@ xfs_calc_create_reservation(
 
 }
 
+STATIC uint
+xfs_calc_create_tmpfile_reservation(
+	struct xfs_mount        *mp)
+{
+	uint	res = XFS_DQUOT_LOGRES(mp);
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		res += xfs_calc_icreate_resv_alloc(mp);
+	else
+		res += xfs_calc_create_resv_alloc(mp);
+
+	return res + xfs_calc_iunlink_add_reservation(mp);
+}
+
 /*
  * Making a new directory is the same as creating a new file.
  */
@@ -729,6 +756,11 @@ xfs_trans_resv_calc(
 	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
 	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	resp->tr_create_tmpfile.tr_logres =
+			xfs_calc_create_tmpfile_reservation(mp);
+	resp->tr_create_tmpfile.tr_logcount = XFS_CREATE_TMPFILE_LOG_COUNT;
+	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
 	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
 	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
 	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
diff --git a/fs/xfs/xfs_trans_resv.h b/fs/xfs/xfs_trans_resv.h
index de7de9a..285621d 100644
--- a/fs/xfs/xfs_trans_resv.h
+++ b/fs/xfs/xfs_trans_resv.h
@@ -38,6 +38,7 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_remove;	/* unlink trans */
 	struct xfs_trans_res	tr_symlink;	/* symlink trans */
 	struct xfs_trans_res	tr_create;	/* create trans */
+	struct xfs_trans_res	tr_create_tmpfile; /* create O_TMPFILE trans */
 	struct xfs_trans_res	tr_mkdir;	/* mkdir trans */
 	struct xfs_trans_res	tr_ifree;	/* inode free trans */
 	struct xfs_trans_res	tr_ichange;	/* inode update trans */
@@ -100,6 +101,7 @@ struct xfs_trans_resv {
 #define	XFS_ITRUNCATE_LOG_COUNT		2
 #define XFS_INACTIVE_LOG_COUNT		2
 #define	XFS_CREATE_LOG_COUNT		2
+#define	XFS_CREATE_TMPFILE_LOG_COUNT	2
 #define	XFS_MKDIR_LOG_COUNT		3
 #define	XFS_SYMLINK_LOG_COUNT		3
 #define	XFS_REMOVE_LOG_COUNT		2
-- 
1.7.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
