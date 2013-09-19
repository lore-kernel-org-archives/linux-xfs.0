Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C56E229E04
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 14:15:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8922230404E
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 12:15:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lwnFCVZCUYFhq6CP for
	<xfs@oss.sgi.com>; Thu, 19 Sep 2013 12:15:23 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8JJFM1U009041
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 15:15:23 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r8JJFL6H022418
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 15:15:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 3/4] xfs: push down inactive transaction mgmt for ifree
Date: Thu, 19 Sep 2013 15:15:20 -0400
Message-Id: <1379618121-35105-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1379618121-35105-1-git-send-email-bfoster@redhat.com>
References: <1379618121-35105-1-git-send-email-bfoster@redhat.com>
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

Push the inode free work performed during xfs_inactive() down into
a new xfs_inactive_ifree() helper. This clears xfs_inactive() from
all inode locking and transaction management more directly
associated with freeing the inode xattrs, extents and the inode
itself.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 121 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 71 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 33bb9be..dde182e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1715,6 +1715,74 @@ error_trans_cancel:
 }
 
 /*
+ * xfs_inactive_ifree()
+ *
+ * Perform the inode free when an inode is unlinked.
+ */
+STATIC int
+xfs_inactive_ifree(
+	struct xfs_inode *ip)
+{
+	xfs_bmap_free_t		free_list;
+	xfs_fsblock_t		first_block;
+	int			committed;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, 0, 0);
+	if (error) {
+		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
+		return error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	xfs_bmap_init(&free_list, &first_block);
+	error = xfs_ifree(tp, ip, &free_list);
+	if (error) {
+		/*
+		 * If we fail to free the inode, shut down.  The cancel
+		 * might do that, we need to make sure.  Otherwise the
+		 * inode might be lost for a long time or forever.
+		 */
+		if (!XFS_FORCED_SHUTDOWN(mp)) {
+			xfs_notice(mp, "%s: xfs_ifree returned error %d",
+				__func__, error);
+			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+		}
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
+		return error;
+	}
+
+	/*
+	 * Credit the quota account(s). The inode is gone.
+	 */
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_ICOUNT, -1);
+
+	/*
+	 * Just ignore errors at this point.  There is nothing we can
+	 * do except to try to keep going. Make sure it's not a silent
+	 * error.
+	 */
+	error = xfs_bmap_finish(&tp,  &free_list, &committed);
+	if (error)
+		xfs_notice(mp, "%s: xfs_bmap_finish returned error %d",
+			__func__, error);
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	if (error)
+		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
+			__func__, error);
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return 0;
+}
+
+/*
  * xfs_inactive
  *
  * This is called when the vnode reference count for the vnode
@@ -1726,10 +1794,6 @@ int
 xfs_inactive(
 	xfs_inode_t	*ip)
 {
-	xfs_bmap_free_t		free_list;
-	xfs_fsblock_t		first_block;
-	int			committed;
-	struct xfs_trans	*tp;
 	struct xfs_mount	*mp;
 	int			error;
 	int			truncate = 0;
@@ -1801,60 +1865,17 @@ xfs_inactive(
 
 	ASSERT(ip->i_d.di_anextents == 0);
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, 0, 0);
-	if (error) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
-		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
-		goto out;
-	}
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, 0);
-
 	/*
 	 * Free the inode.
 	 */
-	xfs_bmap_init(&free_list, &first_block);
-	error = xfs_ifree(tp, ip, &free_list);
-	if (error) {
-		/*
-		 * If we fail to free the inode, shut down.  The cancel
-		 * might do that, we need to make sure.  Otherwise the
-		 * inode might be lost for a long time or forever.
-		 */
-		if (!XFS_FORCED_SHUTDOWN(mp)) {
-			xfs_notice(mp, "%s: xfs_ifree returned error %d",
-				__func__, error);
-			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
-		}
-		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
-	} else {
-		/*
-		 * Credit the quota account(s). The inode is gone.
-		 */
-		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_ICOUNT, -1);
-
-		/*
-		 * Just ignore errors at this point.  There is nothing we can
-		 * do except to try to keep going. Make sure it's not a silent
-		 * error.
-		 */
-		error = xfs_bmap_finish(&tp,  &free_list, &committed);
-		if (error)
-			xfs_notice(mp, "%s: xfs_bmap_finish returned error %d",
-				__func__, error);
-		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-		if (error)
-			xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
-				__func__, error);
-	}
+	error = xfs_inactive_ifree(ip);
+	if (error)
+		goto out;
 
 	/*
 	 * Release the dquots held by inode, if any.
 	 */
 	xfs_qm_dqdetach(ip);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out:
 	return VN_INACTIVE_CACHE;
 }
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
