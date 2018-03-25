Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:45951 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750989AbeCYFRK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 25 Mar 2018 01:17:10 -0400
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] xfs: use hardlimit as sub-fs size if both hard/soft limits are set
Date: Sun, 25 Mar 2018 13:16:36 +0800
Message-Id: <1521954996-203628-1-git-send-email-cgxu519@gmx.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, bfoster@redhat.com, sandeen@sandeen.net, Chengguang Xu <cgxu519@gmx.com>

In current implementation, we size the fs(sub-fs via project quota) at
the soft limit and simply call it 100% used if the limit is exceeded.
It is reasonable when only a soft limit is set, but we should use the
hard limit if both hard/soft limits are set, so that quota-df reflects
the usage information more accurately.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/xfs/xfs_qm_bhv.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 2be6d27..43b0fe8 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -35,9 +35,9 @@
 {
 	uint64_t		limit;
 
-	limit = dqp->q_core.d_blk_softlimit ?
-		be64_to_cpu(dqp->q_core.d_blk_softlimit) :
-		be64_to_cpu(dqp->q_core.d_blk_hardlimit);
+	limit = dqp->q_core.d_blk_hardlimit ?
+		be64_to_cpu(dqp->q_core.d_blk_hardlimit) :
+		be64_to_cpu(dqp->q_core.d_blk_softlimit);
 	if (limit && statp->f_blocks > limit) {
 		statp->f_blocks = limit;
 		statp->f_bfree = statp->f_bavail =
@@ -45,9 +45,9 @@
 			 (statp->f_blocks - dqp->q_res_bcount) : 0;
 	}
 
-	limit = dqp->q_core.d_ino_softlimit ?
-		be64_to_cpu(dqp->q_core.d_ino_softlimit) :
-		be64_to_cpu(dqp->q_core.d_ino_hardlimit);
+	limit = dqp->q_core.d_ino_hardlimit ?
+		be64_to_cpu(dqp->q_core.d_ino_hardlimit) :
+		be64_to_cpu(dqp->q_core.d_ino_softlimit);
 	if (limit && statp->f_files > limit) {
 		statp->f_files = limit;
 		statp->f_ffree =
-- 
1.8.3.1

