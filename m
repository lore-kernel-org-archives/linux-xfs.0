Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:40063 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbeCINQM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Mar 2018 08:16:12 -0500
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [RFC][PATCH] xfs: adjust size/used/avail information for quota-df
Date: Fri,  9 Mar 2018 21:15:55 +0800
Message-Id: <1520601355-180600-1-git-send-email-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, Chengguang Xu <cgxu519@gmx.com>

In order to more accurately reflect size/used/avail information
for quota-df, slightly adjust related counting logic.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---

Hello folks,

Recently I’m testing  project quota  for our container users and found
sometimes the result of df command could not exactly represent
block/inode usage amount. So I checked  the logic in function xfs_qm_statvfs()
and I think it might be better if slightly adjusting the counting logic.
What do you think?

Terms:
# Size(F)   - The size field  in df result of filesystem
# Size(Q) - The size field of in df result of pquota-dir
# Used(F) - The used field  in df result of filesystem
# Used(Q) - The used field  in df result of pquota-dir
# Avail(F)  - The avail field  in df result of filesystem
# Avail(Q)  - The avail field  in df result of pquota-dir
# Used(A) - Actual used

Problems that I found.
1) Avail(Q) can be higher than Avail(F)
2) Used(A) can be higher than Used(Q)


 fs/xfs/xfs_qm_bhv.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 2be6d27..cb2e6c9 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -38,21 +38,41 @@
 	limit = dqp->q_core.d_blk_softlimit ?
 		be64_to_cpu(dqp->q_core.d_blk_softlimit) :
 		be64_to_cpu(dqp->q_core.d_blk_hardlimit);
-	if (limit && statp->f_blocks > limit) {
-		statp->f_blocks = limit;
-		statp->f_bfree = statp->f_bavail =
-			(statp->f_blocks > dqp->q_res_bcount) ?
-			 (statp->f_blocks - dqp->q_res_bcount) : 0;
+
+	if (limit) {
+		if (limit > dqp->q_res_bcount + statp->f_bavail)
+			statp->f_blocks = dqp->q_res_bcount + statp->f_bavail;
+		else
+			statp->f_blocks = limit;
+	} else {
+		statp->f_blocks = dqp->q_res_bcount + statp->f_bavail;
+	}
+
+	if (dqp->q_res_bcount >= statp->f_blocks) {
+		statp->f_blocks = dqp->q_res_bcount;
+		statp->f_bfree = statp->f_bavail = 0;
+	} else {
+		statp->f_bfree = statp->f_bavail = statp->f_blocks - dqp->q_res_bcount;
 	}
 
 	limit = dqp->q_core.d_ino_softlimit ?
 		be64_to_cpu(dqp->q_core.d_ino_softlimit) :
 		be64_to_cpu(dqp->q_core.d_ino_hardlimit);
-	if (limit && statp->f_files > limit) {
-		statp->f_files = limit;
-		statp->f_ffree =
-			(statp->f_files > dqp->q_res_icount) ?
-			 (statp->f_ffree - dqp->q_res_icount) : 0;
+
+	if (limit) {
+		if (limit > dqp->q_res_icount + statp->f_ffree)
+			statp->f_files = dqp->q_res_icount + statp->f_ffree;
+		else
+			statp->f_files = limit;
+	} else {
+		statp->f_files = dqp->q_res_icount + statp->f_ffree;
+	}
+
+	if (dqp->q_res_icount >= statp->f_files) {
+		statp->f_files = dqp->q_res_icount;
+		statp->f_ffree = 0;
+	} else {
+		statp->f_ffree = statp->f_files - dqp->q_res_icount;
 	}
 }
 
-- 
1.8.3.1

