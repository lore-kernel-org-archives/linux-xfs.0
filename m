Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D4FC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 13:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239833AbiKQNRg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 08:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239861AbiKQNRf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 08:17:35 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0F01C40A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 05:17:34 -0800 (PST)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NCgNs5YCSzJnmn;
        Thu, 17 Nov 2022 21:14:21 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 21:17:31 +0800
Date:   Thu, 17 Nov 2022 21:38:54 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>
CC:     <david@fromorbit.com>, <linux-xfs@vger.kernel.org>,
        <houtao1@huawei.com>, <yi.zhang@huawei.com>, <guoxuenan@huawei.com>
Subject: [PATCH v3] xfs: fix incorrect i_nlink caused by inode racing
Message-ID: <20221117133854.GA525799@ceph-admin>
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
v3:
- Put ilock and iunlock in the same function

 fs/xfs/xfs_icache.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index eae7427062cf..f35e2cee5265 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -342,6 +342,9 @@ xfs_iget_recycle(
 
 	trace_xfs_iget_recycle(ip);
 
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
+		return -EAGAIN;
+
 	/*
 	 * We need to make it look like the inode is being reclaimed to prevent
 	 * the actual reclaim workers from stomping over us while we recycle
@@ -355,6 +358,7 @@ xfs_iget_recycle(
 
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	error = xfs_reinit_inode(mp, inode);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	if (error) {
 		/*
 		 * Re-initializing the inode failed, and we are in deep
@@ -518,6 +522,8 @@ xfs_iget_cache_hit(
 	if (ip->i_flags & XFS_IRECLAIMABLE) {
 		/* Drops i_flags_lock and RCU read lock. */
 		error = xfs_iget_recycle(pag, ip);
+		if (error == -EAGAIN)
+			goto out_skip;
 		if (error)
 			return error;
 	} else {
-- 
2.31.1

