Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 462D97F47
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 12:13:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2490D8F8035
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 10:13:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RK1FmUFTsXrPhWQf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 10:13:24 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sACIDNV8015754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 13:13:23 -0500
Received: from hades.localdomain.com (ovpn-113-66.phx2.redhat.com
	[10.3.113.66])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sACIDItN005401
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 13:13:22 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/2] Add support to RENAME_EXCHANGE flag V4
Date: Wed, 12 Nov 2014 16:13:03 -0200
Message-Id: <1415815983-5615-3-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1415815983-5615-1-git-send-email-cmaiolino@redhat.com>
References: <1415815983-5615-1-git-send-email-cmaiolino@redhat.com>
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

Adds a new function named xfs_cross_rename(), responsible to handle requests
from sys_renameat2() using RENAME_EXCHANGE flag.

Changelog:

	V2: - refactor xfs_cross_rename() to not duplicate code from xfs_rename()

	V3: - fix indentation to avoid 80 column crossing, decrease the amount of
	      arguments passed to xfs_cross_rename()
	    - Rebase patches over the latest linux code

	v4: - use a label/goto statement instead of an if conditional after
	      xfs_cross_rename() return, to finish the rename operation
	    - Make xfs_cross_rename() static
	    - Fix some comments

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_inode.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_inode.h |   2 +-
 fs/xfs/xfs_iops.c  |   4 +-
 3 files changed, 114 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8ed049d..8014041 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2668,6 +2668,102 @@ xfs_sort_for_rename(
 	}
 }
 
+/* xfs_cross_rename()
+ *
+ * responsible to handle RENAME_EXCHANGE flag
+ * in renameat2() sytemcall
+ */
+STATIC int
+xfs_cross_rename(
+	xfs_trans_t	*tp,
+	xfs_inode_t	*src_dp,
+	struct xfs_name	*src_name,
+	xfs_inode_t	*src_ip,
+	xfs_inode_t	*target_dp,
+	struct xfs_name	*target_name,
+	xfs_inode_t	*target_ip,
+	xfs_bmap_free_t	*free_list,
+	xfs_fsblock_t	*first_block,
+	int		spaceres)
+{
+	int		error = 0;
+	int		new_parent;
+	int		src_is_directory;
+	int		tgt_is_directory;
+
+	new_parent = (src_dp != target_dp);
+	src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
+	tgt_is_directory = S_ISDIR(target_ip->i_d.di_mode);
+
+	/* Replace source inode */
+	error = xfs_dir_replace(tp, src_dp, src_name,
+				target_ip->i_ino,
+				first_block, free_list, spaceres);
+	if (error)
+		goto out;
+
+	/* Replace target inode */
+	error = xfs_dir_replace(tp, target_dp, target_name,
+				src_ip->i_ino,
+				first_block, free_list, spaceres);
+	if (error)
+		goto out;
+
+	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+	/*
+	* If we're renaming one or more directories across different parents,
+	* update the respective ".." entries (and link counts) to match the new
+	* parents.
+	*/
+	if (new_parent) {
+		xfs_trans_ichgtime(tp, target_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+		if (tgt_is_directory) {
+			error = xfs_dir_replace(tp, target_ip, &xfs_name_dotdot,
+						src_dp->i_ino, first_block,
+						free_list, spaceres);
+			if (error)
+				goto out;
+
+			/* transfer target ".." reference to src_dp */
+			if (!src_is_directory) {
+				error = xfs_droplink(tp, target_dp);
+				if (error)
+					goto out;
+				error = xfs_bumplink(tp, src_dp);
+				if (error)
+					goto out;
+			}
+		}
+
+		if (src_is_directory) {
+			error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
+						target_dp->i_ino, first_block,
+						free_list, spaceres);
+			if (error)
+				goto out;
+
+			/* transfer src ".." reference to target_dp */
+			if (!tgt_is_directory) {
+				error = xfs_droplink(tp, src_dp);
+				if (error)
+					goto out;
+				error = xfs_bumplink(tp, target_dp);
+				if (error)
+					goto out;
+			}
+		}
+		xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
+	}
+	xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
+	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
+	xfs_trans_log_inode(tp, target_ip, XFS_ILOG_CORE);
+
+out:
+	return error;
+}
+
 /*
  * xfs_rename
  */
@@ -2678,7 +2774,8 @@ xfs_rename(
 	xfs_inode_t	*src_ip,
 	xfs_inode_t	*target_dp,
 	struct xfs_name	*target_name,
-	xfs_inode_t	*target_ip)
+	xfs_inode_t	*target_ip,
+	unsigned int	flags)
 {
 	xfs_trans_t	*tp = NULL;
 	xfs_mount_t	*mp = src_dp->i_mount;
@@ -2706,6 +2803,7 @@ xfs_rename(
 	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, spaceres, 0);
+
 	if (error == -ENOSPC) {
 		spaceres = 0;
 		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, 0, 0);
@@ -2756,6 +2854,17 @@ xfs_rename(
 	}
 
 	/*
+	 * Handle RENAME_EXCHANGE flags
+	*/
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip, target_dp,
+					 target_name, target_ip, &free_list,
+					 &first_block, spaceres);
+		if (error)
+			goto abort_return;
+		goto finish_rename;
+	}
+	/*
 	 * Set up the target.
 	 */
 	if (target_ip == NULL) {
@@ -2894,6 +3003,7 @@ xfs_rename(
 	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
+finish_rename:
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * rename transaction goes to disk before returning to
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 9af2882..051d9f0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -340,7 +340,7 @@ int		xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
 int		xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
 			   struct xfs_inode *src_ip, struct xfs_inode *target_dp,
 			   struct xfs_name *target_name,
-			   struct xfs_inode *target_ip);
+			   struct xfs_inode *target_ip, unsigned int flags);
 
 void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0b8704c..481ae10 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -391,7 +391,7 @@ xfs_vn_rename(
 	struct xfs_name	nname;
 
 	/* XFS does not support RENAME_EXCHANGE yet */
-	if (flags & ~RENAME_NOREPLACE)
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
 	xfs_dentry_to_name(&oname, odentry, 0);
@@ -399,7 +399,7 @@ xfs_vn_rename(
 
 	return xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
 			  XFS_I(ndir), &nname,
-			  new_inode ? XFS_I(new_inode) : NULL);
+			  new_inode ? XFS_I(new_inode) : NULL, flags);
 }
 
 /*
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
