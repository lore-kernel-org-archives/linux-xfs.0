Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 312C7C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 02:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238884AbiKQChN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Nov 2022 21:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbiKQChM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2022 21:37:12 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59822ED67
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 18:37:07 -0800 (PST)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NCPF92D1DzRpB1;
        Thu, 17 Nov 2022 10:36:45 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 10:37:05 +0800
Date:   Thu, 17 Nov 2022 10:58:29 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>
CC:     <david@fromorbit.com>, <linux-xfs@vger.kernel.org>,
        <houtao1@huawei.com>, <yi.zhang@huawei.com>, <guoxuenan@huawei.com>
Subject: [PATCH v2] xfs: fix incorrect i_nlink caused by inode racing
Message-ID: <20221117025829.GA1095675@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following error occurred during the fsstress test:

XFS: Assertion failed: VFS_I(ip)->i_nlink >= 2, file: fs/xfs/xfs_inode.c, line: 2452

The problem was that inode race condition causes incorrect i_nlink to be
written to disk, and then it is read into memory. Consider the following
call graph, inodes that are marked as both XFS_IFLUSHING and
XFS_IRECLAIMABLE, i_nlink will be reset to 1 and then restored to original
value in xfs_reinit_inode(). Therefore, the i_nlink of directory on disk
may be set to 1.

  xfsaild
      xfs_inode_item_push
          xfs_iflush_cluster
              xfs_iflush
                  xfs_inode_to_disk

  xfs_iget
      xfs_iget_cache_hit
          xfs_iget_recycle
              xfs_reinit_inode
  	          inode_init_always

xfs_reinit_inode() needs to hold the ILOCK_EXCL as it is changing internal
inode state and can race with other RCU protected inode lookups. On the
read side, xfs_iflush_cluster() grabs the ILOCK_SHARED while under rcu +
ip->i_flags_lock, and so xfs_iflush/xfs_inode_to_disk() are protected from
racing inode updates (during transactions) by that lock.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
v2:
- Modify the assertion error code line number
- Use ILOCK_EXCL to prevent inode racing 

 fs/xfs/xfs_icache.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index eae7427062cf..5a1650e769e7 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -329,7 +329,7 @@ xfs_reinit_inode(
 
 /*
  * Carefully nudge an inode whose VFS state has been torn down back into a
- * usable state.  Drops the i_flags_lock and the rcu read lock.
+ * usable state.  Drops the i_flags_lock, rcu read lock and XFS_ILOCK_EXCL.
  */
 static int
 xfs_iget_recycle(
@@ -355,6 +355,7 @@ xfs_iget_recycle(
 
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	error = xfs_reinit_inode(mp, inode);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	if (error) {
 		/*
 		 * Re-initializing the inode failed, and we are in deep
@@ -516,7 +517,10 @@ xfs_iget_cache_hit(
 
 	/* The inode fits the selection criteria; process it. */
 	if (ip->i_flags & XFS_IRECLAIMABLE) {
-		/* Drops i_flags_lock and RCU read lock. */
+		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
+			goto out_skip;
+
+		/* Drops i_flags_lock, RCU read lock and XFS_ILOCK_EXCL. */
 		error = xfs_iget_recycle(pag, ip);
 		if (error)
 			return error;
-- 
2.31.1

