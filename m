Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 525A47F37
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 11:10:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CFC38AC004
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 09:10:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wMd82fjaFPRk7XNm for
	<xfs@oss.sgi.com>; Wed, 18 Sep 2013 09:10:31 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8IGAUMb032190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 12:10:31 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r8IGAU5Q004658
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 12:10:30 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/3] xfs: push down inactive transaction mgmt for truncate
Date: Wed, 18 Sep 2013 12:15:59 -0400
Message-Id: <1379520960-22972-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1379520960-22972-1-git-send-email-bfoster@redhat.com>
References: <1379520960-22972-1-git-send-email-bfoster@redhat.com>
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

Create the new xfs_inactive_truncate() function to handle the
truncate portion of xfs_inactive(). Push the locking and
transaction management into the new function.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 112 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 63 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 30db70e..9416462 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1663,6 +1663,53 @@ xfs_release(
 }
 
 /*
+ * xfs_inactive_truncate
+ *
+ * Called to perform a truncate when an inode becomes unlinked.
+ */
+STATIC int
+xfs_inactive_truncate(
+	struct xfs_inode *ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
+
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
+	if (error) {
+		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		goto error0;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	ip->i_d.di_size = 0;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
+	if (error)
+		goto error1;
+
+	ASSERT(ip->i_d.di_nextents == 0);
+
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	if (error)
+		goto error1;
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return 0;
+
+error1:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+error0:
+	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	return error;
+}
+
+/*
  * xfs_inactive
  *
  * This is called when the vnode reference count for the vnode
@@ -1679,7 +1726,6 @@ xfs_inactive(
 	int			committed;
 	struct xfs_trans	*tp;
 	struct xfs_mount	*mp;
-	struct xfs_trans_res	*resp;
 	int			error;
 	int			truncate = 0;
 
@@ -1724,35 +1770,12 @@ xfs_inactive(
 	if (error)
 		return VN_INACTIVE_CACHE;
 
-	if (S_ISLNK(ip->i_d.di_mode)) {
+	if (S_ISLNK(ip->i_d.di_mode))
 		error = xfs_inactive_symlink(ip);
-		if (error)
-			goto out;
-	}
-
-	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-	resp = truncate ? &M_RES(mp)->tr_itruncate : &M_RES(mp)->tr_ifree;
-
-	error = xfs_trans_reserve(tp, resp, 0, 0);
-	if (error) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
-		xfs_trans_cancel(tp, 0);
-		return VN_INACTIVE_CACHE;
-	}
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, 0);
-
-	if (truncate) {
-		ip->i_d.di_size = 0;
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-		error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
-		if (error)
-			goto out_cancel;
-
-		ASSERT(ip->i_d.di_nextents == 0);
-	}
+	else if (truncate)
+		error = xfs_inactive_truncate(ip);
+	if (error)
+		goto out;
 
 	/*
 	 * If there are attributes associated with the file then blow them away
@@ -1763,25 +1786,9 @@ xfs_inactive(
 	if (ip->i_d.di_anextents > 0) {
 		ASSERT(ip->i_d.di_forkoff != 0);
 
-		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-		if (error)
-			goto out_unlock;
-
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
 		error = xfs_attr_inactive(ip);
 		if (error)
 			goto out;
-
-		tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, 0, 0);
-		if (error) {
-			xfs_trans_cancel(tp, 0);
-			goto out;
-		}
-
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, 0);
 	}
 
 	if (ip->i_afp)
@@ -1789,6 +1796,17 @@ xfs_inactive(
 
 	ASSERT(ip->i_d.di_anextents == 0);
 
+	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, 0, 0);
+	if (error) {
+		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
+		goto out;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
 	/*
 	 * Free the inode.
 	 */
@@ -1831,13 +1849,9 @@ xfs_inactive(
 	 * Release the dquots held by inode, if any.
 	 */
 	xfs_qm_dqdetach(ip);
-out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out:
 	return VN_INACTIVE_CACHE;
-out_cancel:
-	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
-	goto out_unlock;
 }
 
 /*
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
