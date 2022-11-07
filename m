Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D8BC433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 14:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiKGOPR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 09:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiKGOPQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 09:15:16 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F23F1BE94
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 06:15:13 -0800 (PST)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N5YCT2FcmzmVhF;
        Mon,  7 Nov 2022 22:15:01 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 7 Nov
 2022 22:15:11 +0800
Date:   Mon, 7 Nov 2022 22:36:48 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>
CC:     <houtao1@huawei.com>, <yi.zhang@huawei.com>,
        <guoxuenan@huawei.com>, <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix incorrect i_nlink caused by inode racing
Message-ID: <20221107143648.GA2013250@ceph-admin>
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

XFS: Assertion failed: VFS_I(ip)->i_nlink >= 2, file: fs/xfs/xfs_inode.c, line: 2925

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

So skip inodes that being flushed and markded as XFS_IRECLAIMABLE, prevent
concurrent read and write to inodes.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_icache.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index eae7427062cf..cc68b0ff50ce 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -514,6 +514,11 @@ xfs_iget_cache_hit(
 	    (ip->i_flags & XFS_IRECLAIMABLE))
 		goto out_skip;
 
+	/* Skip inodes that being flushed */
+	if ((ip->i_flags & XFS_IFLUSHING) &&
+	    (ip->i_flags & XFS_IRECLAIMABLE))
+		goto out_skip;
+
 	/* The inode fits the selection criteria; process it. */
 	if (ip->i_flags & XFS_IRECLAIMABLE) {
 		/* Drops i_flags_lock and RCU read lock. */
-- 
2.31.1

