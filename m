Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A55537F52
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 13:25:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2767DAC005
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 11:25:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uGjzrIdhpmK5KPrb for
	<xfs@oss.sgi.com>; Tue, 03 Sep 2013 11:25:48 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r83IPlh8007141
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:47 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r83IPkJV005903
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 06/11] xfs: use correct transaction reservations in
	xfs_inactive()
Date: Tue,  3 Sep 2013 14:25:03 -0400
Message-Id: <1378232708-57156-7-git-send-email-bfoster@redhat.com>
In-Reply-To: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
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

The transaction allocated in xfs_inactive() can be passed down into
xfs_inactive_symlink() or xfs_itruncate_extents(), both of which
can commit and reallocate a new transaction. This leads to
reservation issues if the transaction is subsequently passed into
xfs_ifree(), which requires a larger reservation to manage the
finobt.

Reorganize xfs_inactive() to commit any transaction handed back
from symlink or truncate processing and unconditionally allocate
a new transaction for xfs_ifree() with the appropriate reservation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 71 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e3d7538..56cbf63 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1679,7 +1679,6 @@ xfs_inactive(
 	int			committed;
 	struct xfs_trans	*tp;
 	struct xfs_mount	*mp;
-	struct xfs_trans_res	*resp;
 	int			error;
 	int			truncate = 0;
 
@@ -1724,33 +1723,39 @@ xfs_inactive(
 	if (error)
 		return VN_INACTIVE_CACHE;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-	resp = (truncate || S_ISLNK(ip->i_d.di_mode)) ?
-		&M_RES(mp)->tr_itruncate : &M_RES(mp)->tr_ifree;
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-	error = xfs_trans_reserve(tp, resp, 0, 0);
-	if (error) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
-		xfs_trans_cancel(tp, 0);
-		return VN_INACTIVE_CACHE;
-	}
+	if (truncate || S_ISLNK(ip->i_d.di_mode)) {
+		tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, 0);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
+		if (error) {
+			ASSERT(XFS_FORCED_SHUTDOWN(mp));
+			xfs_trans_cancel(tp, 0);
+			return VN_INACTIVE_CACHE;
+		}
 
-	if (S_ISLNK(ip->i_d.di_mode)) {
-		error = xfs_inactive_symlink(ip, &tp);
-		if (error)
-			goto out_cancel;
-	} else if (truncate) {
-		ip->i_d.di_size = 0;
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		xfs_trans_ijoin(tp, ip, 0);
+
+		if (S_ISLNK(ip->i_d.di_mode)) {
+			error = xfs_inactive_symlink(ip, &tp);
+			if (error)
+				goto out_cancel;
+		} else if (truncate) {
+			ip->i_d.di_size = 0;
+			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+			error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK,
+						      0);
+			if (error)
+				goto out_cancel;
 
-		error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
+			ASSERT(ip->i_d.di_nextents == 0);
+		}
+
+		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 		if (error)
 			goto out_cancel;
-
-		ASSERT(ip->i_d.di_nextents == 0);
 	}
 
 	/*
@@ -1762,27 +1767,25 @@ xfs_inactive(
 	if (ip->i_d.di_anextents > 0) {
 		ASSERT(ip->i_d.di_forkoff != 0);
 
-		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-		if (error)
-			goto out_unlock;
-
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 		error = xfs_attr_inactive(ip);
 		if (error)
 			goto out;
 
-		tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, 0, 0);
-		if (error) {
-			xfs_trans_cancel(tp, 0);
-			goto out;
-		}
-
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, 0);
 	}
 
+	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
+				  XFS_IFREE_SPACE_RES(mp), 0);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		goto out_unlock;
+	}
+
+	xfs_trans_ijoin(tp, ip, 0);
+
 	if (ip->i_afp)
 		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
