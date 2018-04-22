Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48312 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754465AbeDVPHX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Apr 2018 11:07:23 -0400
Subject: [PATCH 12/13] xfs: rename on-disk dquot counter zap functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 22 Apr 2018 08:07:18 -0700
Message-ID: <152440963795.29601.14844972913332721242.stgit@magnolia>
In-Reply-To: <152440954198.29601.14390250048915099607.stgit@magnolia>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

The function 'xfs_qm_dqiterate' doesn't iterate dquots at all, it
iterates all dquot blocks of a quota inode and clears the counters.
Therefore, change the name to something more descriptive so that we can
introduce a real dquot iterator later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_qm.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 1b94da0..08ec69c 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -889,7 +889,7 @@ xfs_qm_reset_dqcounts(
 }
 
 STATIC int
-xfs_qm_dqiter_bufs(
+xfs_qm_quotip_zero_bufs(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		firstid,
 	xfs_fsblock_t		bno,
@@ -957,11 +957,11 @@ xfs_qm_dqiter_bufs(
 }
 
 /*
- * Iterate over all allocated USR/GRP/PRJ dquots in the system, calling a
- * caller supplied function for every chunk of dquots that we find.
+ * Iterate over all allocated dquot blocks in this quota inode, zeroing all
+ * counters for every chunk of dquots that we find.
  */
 STATIC int
-xfs_qm_dqiterate(
+xfs_qm_quotip_zero(
 	struct xfs_mount	*mp,
 	struct xfs_inode	*qip,
 	uint			flags,
@@ -1037,7 +1037,7 @@ xfs_qm_dqiterate(
 			 * Iterate thru all the blks in the extent and
 			 * reset the counters of all the dquots inside them.
 			 */
-			error = xfs_qm_dqiter_bufs(mp, firstid,
+			error = xfs_qm_quotip_zero_bufs(mp, firstid,
 						   map[i].br_startblock,
 						   map[i].br_blockcount,
 						   flags, buffer_list);
@@ -1299,7 +1299,7 @@ xfs_qm_quotacheck(
 	 * We don't log our changes till later.
 	 */
 	if (uip) {
-		error = xfs_qm_dqiterate(mp, uip, XFS_QMOPT_UQUOTA,
+		error = xfs_qm_quotip_zero(mp, uip, XFS_QMOPT_UQUOTA,
 					 &buffer_list);
 		if (error)
 			goto error_return;
@@ -1307,7 +1307,7 @@ xfs_qm_quotacheck(
 	}
 
 	if (gip) {
-		error = xfs_qm_dqiterate(mp, gip, XFS_QMOPT_GQUOTA,
+		error = xfs_qm_quotip_zero(mp, gip, XFS_QMOPT_GQUOTA,
 					 &buffer_list);
 		if (error)
 			goto error_return;
@@ -1315,7 +1315,7 @@ xfs_qm_quotacheck(
 	}
 
 	if (pip) {
-		error = xfs_qm_dqiterate(mp, pip, XFS_QMOPT_PQUOTA,
+		error = xfs_qm_quotip_zero(mp, pip, XFS_QMOPT_PQUOTA,
 					 &buffer_list);
 		if (error)
 			goto error_return;

