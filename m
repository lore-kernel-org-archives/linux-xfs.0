Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50970C4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Dec 2022 10:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiLIKoc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Dec 2022 05:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLIKob (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Dec 2022 05:44:31 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF37D13F
        for <linux-xfs@vger.kernel.org>; Fri,  9 Dec 2022 02:44:29 -0800 (PST)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NT6wt6S2YzqSrv;
        Fri,  9 Dec 2022 18:40:14 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 9 Dec
 2022 18:44:26 +0800
Date:   Fri, 9 Dec 2022 19:05:19 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>
CC:     <david@fromorbit.com>, <linux-xfs@vger.kernel.org>,
        <houtao1@huawei.com>, <yi.zhang@huawei.com>, <guoxuenan@huawei.com>
Subject: [PATCH] xfs: fix hung when transaction commit fail in
 xfs_inactive_ifree
Message-ID: <20221209110519.GA3741914@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After running unplug disk test and unmount filesystem, the umount thread
hung all the time.

 crash> dmesg
 sd 0:0:0:0: rejecting I/O to offline device
 XFS (sda): log I/O error -5
 XFS (sda): Corruption of in-memory data (0x8) detected at xfs_defer_finish_noroll+0x12e0/0x1cf0
	(fs/xfs/libxfs/xfs_defer.c:504).  Shutting down filesystem.
 XFS (sda): Please unmount the filesystem and rectify the problem(s)
 XFS (sda): xfs_inactive_ifree: xfs_trans_commit returned error -5
 XFS (sda): Unmounting Filesystem

 crash> bt 3368
 PID: 3368   TASK: ffff88801bcd8040  CPU: 3   COMMAND: "umount"
  #0 [ffffc900086a7ae0] __schedule at ffffffff83d3fd25
  #1 [ffffc900086a7be8] schedule at ffffffff83d414dd
  #2 [ffffc900086a7c10] xfs_ail_push_all_sync at ffffffff8256db24
  #3 [ffffc900086a7d18] xfs_unmount_flush_inodes at ffffffff824ee7e2
  #4 [ffffc900086a7d28] xfs_unmountfs at ffffffff824f2eff
  #5 [ffffc900086a7da8] xfs_fs_put_super at ffffffff82503e69
  #6 [ffffc900086a7de8] generic_shutdown_super at ffffffff81aeb8cd
  #7 [ffffc900086a7e10] kill_block_super at ffffffff81aefcfa
  #8 [ffffc900086a7e30] deactivate_locked_super at ffffffff81aeb2da
  #9 [ffffc900086a7e48] deactivate_super at ffffffff81aeb639
 #10 [ffffc900086a7e68] cleanup_mnt at ffffffff81b6ddd5
 #11 [ffffc900086a7ea0] __cleanup_mnt at ffffffff81b6dfdf
 #12 [ffffc900086a7eb0] task_work_run at ffffffff8126e5cf
 #13 [ffffc900086a7ef8] exit_to_user_mode_prepare at ffffffff813fa136
 #14 [ffffc900086a7f28] syscall_exit_to_user_mode at ffffffff83d25dbb
 #15 [ffffc900086a7f40] do_syscall_64 at ffffffff83d1f8d9
 #16 [ffffc900086a7f50] entry_SYSCALL_64_after_hwframe at ffffffff83e00085

When we free a cluster buffer from xfs_ifree_cluster, all the inodes in
cache are marked XFS_ISTALE. On journal commit dirty stale inodes as are
handled by both buffer and inode log items, inodes marked as XFS_ISTALE
in AIL will be removed from the AIL because the buffer log item will clean
it. If the transaction commit fails in the xfs_inactive_ifree(), inodes
marked as XFS_ISTALE will be left in AIL due to buf log item is not
committed, this will cause the unmount thread above to be blocked all the
time. Error handling in xfs_inactive_ifree() is not enough, the above
exception needs to be considered.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_inode.c | 114 +++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_inode.h |   1 -
 2 files changed, 105 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d354ea2b74f9..b6808c0a2868 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -49,6 +49,9 @@ struct kmem_cache *xfs_inode_cache;
 STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
 STATIC int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 	struct xfs_inode *);
+STATIC int xfs_ifree(struct xfs_trans *tp, struct xfs_inode *ip,
+		struct xfs_icluster *xic);
+STATIC void xfs_ifree_abort(struct xfs_inode *ip, struct xfs_icluster *xic);
 
 /*
  * helper function to extract extent size hint from inode
@@ -1544,6 +1547,7 @@ xfs_inactive_ifree(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
+	struct xfs_icluster     xic = { 0 };
 	int			error;
 
 	/*
@@ -1598,7 +1602,7 @@ xfs_inactive_ifree(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-	error = xfs_ifree(tp, ip);
+	error = xfs_ifree(tp, ip, &xic);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	if (error) {
 		/*
@@ -1612,7 +1616,7 @@ xfs_inactive_ifree(
 			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
 		}
 		xfs_trans_cancel(tp);
-		return error;
+		goto out_error;
 	}
 
 	/*
@@ -1625,11 +1629,19 @@ xfs_inactive_ifree(
 	 * to try to keep going. Make sure it's not a silent error.
 	 */
 	error = xfs_trans_commit(tp);
-	if (error)
+	if (error) {
 		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
 			__func__, error);
+		goto out_error;
+	}
 
 	return 0;
+
+out_error:
+	if (xic.deleted)
+		xfs_ifree_abort(ip, &xic);
+
+	return error;
 }
 
 /*
@@ -2259,14 +2271,14 @@ xfs_ifree_cluster(
  * inodes in the AGI. We need to remove the inode from that list atomically with
  * respect to freeing it here.
  */
-int
+STATIC int
 xfs_ifree(
 	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	struct xfs_icluster     *xic)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
-	struct xfs_icluster	xic = { 0 };
 	struct xfs_inode_log_item *iip = ip->i_itemp;
 	int			error;
 
@@ -2284,7 +2296,7 @@ xfs_ifree(
 	 * makes the AGI lock -> unlinked list modification order the same as
 	 * used in O_TMPFILE creation.
 	 */
-	error = xfs_difree(tp, pag, ip->i_ino, &xic);
+	error = xfs_difree(tp, pag, ip->i_ino, xic);
 	if (error)
 		goto out;
 
@@ -2323,13 +2335,97 @@ xfs_ifree(
 	VFS_I(ip)->i_generation++;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	if (xic.deleted)
-		error = xfs_ifree_cluster(tp, pag, ip, &xic);
+	if (xic->deleted)
+		error = xfs_ifree_cluster(tp, pag, ip, xic);
 out:
 	xfs_perag_put(pag);
 	return error;
 }
 
+static void
+xfs_ifree_abort_inode_stale(
+	struct xfs_perag	*pag,
+	xfs_ino_t		inum)
+{
+	struct xfs_mount        *mp = pag->pag_mount;
+	struct xfs_inode_log_item *iip;
+	struct xfs_inode	*ip;
+
+retry:
+	rcu_read_lock();
+	ip = radix_tree_lookup(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, inum));
+
+	/* Inode not in memory, nothing to do */
+	if (!ip) {
+		rcu_read_unlock();
+		return;
+	}
+
+	/* Skip invalid or not stale inode */
+	if (ip->i_ino != inum || !xfs_iflags_test(ip, XFS_ISTALE)) {
+		rcu_read_unlock();
+		return;
+	}
+
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
+		rcu_read_unlock();
+		delay(1);
+		goto retry;
+	}
+
+	iip = ip->i_itemp;
+	if (!iip || list_empty(&iip->ili_item.li_bio_list))
+		goto out_iunlock;
+
+	if (test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags))
+		xfs_iflush_abort(ip);
+	else
+		xfs_iflags_clear(ip, XFS_IFLUSHING);
+
+out_iunlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	rcu_read_unlock();
+}
+
+/*
+ * This is called to clean up inodes marked as stale in xfs_ifree
+ */
+STATIC void
+xfs_ifree_abort(
+	struct xfs_inode	*ip,
+	struct xfs_icluster	*xic)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag        *pag;
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_ino_t		inum = xic->first_ino;
+	int			nbufs;
+	int			i, j;
+	int			ioffset;
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+
+	nbufs = igeo->ialloc_blks / igeo->blocks_per_cluster;
+
+	for (j = 0; j < nbufs; j++, inum += igeo->inodes_per_cluster) {
+		/*
+		 * The allocation bitmap tells us which inodes of the chunk were
+		 * physically allocated. Skip the cluster if an inode falls into
+		 * a sparse region.
+		 */
+		ioffset = inum - xic->first_ino;
+		if ((xic->alloc & XFS_INOBT_MASK(ioffset)) == 0) {
+			ASSERT(ioffset % igeo->inodes_per_cluster == 0);
+			continue;
+		}
+
+		for (i = 0; i < igeo->inodes_per_cluster; i++)
+			xfs_ifree_abort_inode_stale(pag, inum + i);
+
+	}
+	xfs_perag_put(pag);
+}
+
 /*
  * This is called to unpin an inode.  The caller must have the inode locked
  * in at least shared mode so that the buffer cannot be subsequently pinned
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index fa780f08dc89..423542bf6af1 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -499,7 +499,6 @@ uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 
 uint		xfs_ip2xflags(struct xfs_inode *);
-int		xfs_ifree(struct xfs_trans *, struct xfs_inode *);
 int		xfs_itruncate_extents_flags(struct xfs_trans **,
 				struct xfs_inode *, int, xfs_fsize_t, int);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
-- 
2.31.1

