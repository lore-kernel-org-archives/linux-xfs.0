Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 206E57F3F
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 13:18:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 004478F8040
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 11:18:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FxzTtdn2AezkDxwJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Oct 2014 11:18:17 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9FIIGFu007377
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 14:18:17 -0400
Received: from hades.localdomain.com (ovpn-113-106.phx2.redhat.com
	[10.3.113.106])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s9FIHsmO014766
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 14:18:14 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/2] Add support to RENAME_EXCHANGE flag
Date: Wed, 15 Oct 2014 15:17:22 -0300
Message-Id: <1413397042-32229-3-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1413397042-32229-1-git-send-email-cmaiolino@redhat.com>
References: <1413397042-32229-1-git-send-email-cmaiolino@redhat.com>
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

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_inode.c | 187 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h |   4 ++
 fs/xfs/xfs_iops.c  |   7 +-
 3 files changed, 197 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fea3c92..a5bc88d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2920,6 +2920,193 @@ xfs_rename(
 	return error;
 }
 
+/* xfs_cross_rename()
+ *
+ * responsible to handle RENAME_EXCHANGE flag
+ * in renameat2() sytemcall
+ */
+int
+xfs_cross_rename(
+	xfs_inode_t	*src_dp,
+	struct xfs_name	*src_name,
+	xfs_inode_t	*src_ip,
+	xfs_inode_t	*target_dp,
+	struct xfs_name	*target_name,
+	xfs_inode_t	*target_ip)
+{
+	xfs_trans_t	*tp = NULL;
+	xfs_mount_t	*mp = src_dp->i_mount;
+	int		new_parent;		/* Crossing from different parents */
+	int		src_is_directory;
+	int		tgt_is_directory;
+	int		error;
+	xfs_bmap_free_t	free_list;
+	xfs_fsblock_t	first_block;
+	int		cancel_flags;
+	int		committed;
+	xfs_inode_t	*inodes[4];
+	int		spaceres;
+	int		num_inodes;
+
+	new_parent = (src_dp != target_dp);
+	src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
+	tgt_is_directory = S_ISDIR(target_ip->i_d.di_mode);
+
+	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip,
+				inodes, &num_inodes);
+
+	xfs_bmap_init(&free_list, &first_block);
+	tp = xfs_trans_alloc(mp, XFS_TRANS_RENAME);
+	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
+	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, spaceres, 0);
+
+	if (error == -ENOSPC) {
+		spaceres = 0;
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, 0, 0);
+	}
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		goto std_return;
+	}
+
+	/*
+	 * Attach the dquots to the inodes
+	 */
+	error = xfs_qm_vop_rename_dqattach(inodes);
+	if (error) {
+		xfs_trans_cancel(tp, cancel_flags);
+		goto std_return;
+	}
+
+	/*
+	 * Lock all participating inodes. In case of RENAME_EXCHANGE, target
+	 * must exist, so we'll be locking at least 3 inodes here.
+	 */
+	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
+
+	/*
+	 * Join all the inodes to the transaction. From this point on,
+	 * we can rely on either trans_commit or trans_cancel to unlock
+	 * them.
+	 * target_ip will always exist, so, no need to check its existence.
+	 */
+	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	if (new_parent)
+		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
+
+	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+
+	/*
+	* If we are using project inheritance, we only allow RENAME_EXCHANGE
+	* into our tree when the project IDs are the same; else the tree quota
+	* mechanism would be circumvented.
+	*/
+	if (unlikely(((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
+		     (src_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)) &&
+		     (xfs_get_projid(src_dp) != xfs_get_projid(target_dp)) )) {
+		error = -EXDEV;
+		goto error_return;
+	}
+
+	error = xfs_dir_replace(tp, src_dp, src_name,
+				target_ip->i_ino,
+				&first_block, &free_list, spaceres);
+	if (error)
+		goto abort_return;
+
+	/*
+	 * Update ".." entry to match the new parent
+	 */
+	if (new_parent && tgt_is_directory) {
+		error = xfs_dir_replace(tp, target_ip, &xfs_name_dotdot,
+					src_dp->i_ino, &first_block, &free_list, spaceres);
+		if (error)
+			goto abort_return;
+	}
+
+	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+	error = xfs_dir_replace(tp, target_dp, target_name,
+				src_ip->i_ino,
+				&first_block, &free_list, spaceres);
+	if (error)
+		goto abort_return;
+
+	/*
+	 * Update ".." entry to match the new parent
+	 */
+	if (new_parent && src_is_directory) {
+		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
+					target_dp->i_ino, &first_block, &free_list, spaceres);
+		if (error)
+			goto abort_return;
+	}
+
+	/*
+	 * In case we are crossing different file types between different
+	 * parents, we must update parent's link count to match the ".."
+	 * entry of the new child (or the removal of it).
+	 */
+	if (new_parent) {
+		xfs_trans_ichgtime(tp, target_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+		if (src_is_directory && !tgt_is_directory) {
+			error = xfs_droplink(tp, src_dp);
+				if (error)
+					goto abort_return;
+			error = xfs_bumplink(tp, target_dp);
+				if (error)
+					goto abort_return;
+		}
+
+		if (tgt_is_directory && !src_is_directory) {
+			error = xfs_droplink(tp, target_dp);
+				if (error)
+					goto abort_return;
+			error = xfs_bumplink(tp, src_dp);
+				if (error)
+					goto abort_return;
+		}
+
+		/*
+		 * We don't need to log the source dir if
+		 * this is the same as the target.
+		 */
+		xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
+	}
+
+	xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
+	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
+	xfs_trans_log_inode(tp, target_ip, XFS_ILOG_CORE);
+
+	/*
+	 * If this is a synchronous mount, make sure the rename transaction goes
+	 * to disk before returning to the user.
+	 */
+	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
+		xfs_trans_set_sync(tp);
+
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	if (error) {
+		xfs_bmap_cancel(&free_list);
+		xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT));
+		goto std_return;
+	}
+
+	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+
+abort_return:
+	cancel_flags |= XFS_TRANS_ABORT;
+error_return:
+	xfs_bmap_cancel(&free_list);
+	xfs_trans_cancel(tp, cancel_flags);
+std_return:
+	return error;
+
+}
+
 STATIC int
 xfs_iflush_cluster(
 	xfs_inode_t	*ip,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c10e3fa..16889d3 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -341,6 +341,10 @@ int		xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
 			   struct xfs_inode *src_ip, struct xfs_inode *target_dp,
 			   struct xfs_name *target_name,
 			   struct xfs_inode *target_ip);
+int		xfs_cross_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
+			   struct xfs_inode *src_ip, struct xfs_inode *target_dp,
+			   struct xfs_name *target_name,
+			   struct xfs_inode *target_ip);
 
 void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b2b92c7..bc164df 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -391,12 +391,17 @@ xfs_vn_rename2(
 	struct xfs_name	nname;
 
 	/* XFS does not support RENAME_EXCHANGE yet */
-	if (flags & ~RENAME_NOREPLACE)
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
 	xfs_dentry_to_name(&oname, odentry, 0);
 	xfs_dentry_to_name(&nname, ndentry, odentry->d_inode->i_mode);
 
+	if (flags & RENAME_EXCHANGE)
+		return xfs_cross_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
+					XFS_I(ndir), &nname,
+					new_inode ? XFS_I(new_inode) : NULL);
+
 	return xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
 			  XFS_I(ndir), &nname,
 			  new_inode ? XFS_I(new_inode) : NULL);
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
