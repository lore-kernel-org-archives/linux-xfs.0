Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:56009 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751538AbdFEIPP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Jun 2017 04:15:15 -0400
From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] fs: xfs: Fix a lock-twice and sleep-in-atomic bug in xfs_iget
Date: Mon,  5 Jun 2017 16:17:29 +0800
Message-Id: <1496650649-2296-1-git-send-email-baijiaju1990@163.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>

The driver may sleep under a read rcu lock, and function call path is:
xfs_iget (acquire the lock by rcu_read_lock)
  "goto out_error_or_again" after xfs_iget_cache_hit
    delay
      schedule_timeout_uninterruptible --> may sleep
Meanwhile, the rcu_read_lock will be called twice in this situation.

To fix it, the lock is released before "goto".

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 fs/xfs/xfs_icache.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f61c84f8..c2a4722 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -600,8 +600,10 @@ struct xfs_inode *
 
 	if (ip) {
 		error = xfs_iget_cache_hit(pag, ip, ino, flags, lock_flags);
-		if (error)
+		if (error) {
+			rcu_read_unlock();
 			goto out_error_or_again;
+		}
 	} else {
 		rcu_read_unlock();
 		XFS_STATS_INC(mp, xs_ig_missed);
-- 
1.7.9.5


