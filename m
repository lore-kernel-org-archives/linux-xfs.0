Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40330 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965410AbeEJPae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 11:30:34 -0400
Subject: [PATCH 13/14] xfs: rename on-disk dquot counter zap functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 10 May 2018 08:30:13 -0700
Message-ID: <152596621328.27525.8570053354806323352.stgit@magnolia>
In-Reply-To: <152596612549.27525.9876256551560849585.stgit@magnolia>
References: <152596612549.27525.9876256551560849585.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

The function 'xfs_qm_dqiterate' doesn't iterate dquots at all, it
iterates all dquot blocks of a quota inode and clears the counters.
Therefore, change the name to something more descriptive so that we can
introduce a real dquot iterator later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_qm.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 50ba0ea6165f..f927b7d72db1 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -884,7 +884,7 @@ xfs_qm_reset_dqcounts(
 }
 
 STATIC int
-xfs_qm_dqiter_bufs(
+xfs_qm_reset_dqcounts_all(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		firstid,
 	xfs_fsblock_t		bno,
@@ -952,11 +952,11 @@ xfs_qm_dqiter_bufs(
 }
 
 /*
- * Iterate over all allocated USR/GRP/PRJ dquots in the system, calling a
- * caller supplied function for every chunk of dquots that we find.
+ * Iterate over all allocated dquot blocks in this quota inode, zeroing all
+ * counters for every chunk of dquots that we find.
  */
 STATIC int
-xfs_qm_dqiterate(
+xfs_qm_reset_dqcounts_buf(
 	struct xfs_mount	*mp,
 	struct xfs_inode	*qip,
 	uint			flags,
@@ -1032,7 +1032,7 @@ xfs_qm_dqiterate(
 			 * Iterate thru all the blks in the extent and
 			 * reset the counters of all the dquots inside them.
 			 */
-			error = xfs_qm_dqiter_bufs(mp, firstid,
+			error = xfs_qm_reset_dqcounts_all(mp, firstid,
 						   map[i].br_startblock,
 						   map[i].br_blockcount,
 						   flags, buffer_list);
@@ -1293,7 +1293,7 @@ xfs_qm_quotacheck(
 	 * We don't log our changes till later.
 	 */
 	if (uip) {
-		error = xfs_qm_dqiterate(mp, uip, XFS_QMOPT_UQUOTA,
+		error = xfs_qm_reset_dqcounts_buf(mp, uip, XFS_QMOPT_UQUOTA,
 					 &buffer_list);
 		if (error)
 			goto error_return;
@@ -1301,7 +1301,7 @@ xfs_qm_quotacheck(
 	}
 
 	if (gip) {
-		error = xfs_qm_dqiterate(mp, gip, XFS_QMOPT_GQUOTA,
+		error = xfs_qm_reset_dqcounts_buf(mp, gip, XFS_QMOPT_GQUOTA,
 					 &buffer_list);
 		if (error)
 			goto error_return;
@@ -1309,7 +1309,7 @@ xfs_qm_quotacheck(
 	}
 
 	if (pip) {
-		error = xfs_qm_dqiterate(mp, pip, XFS_QMOPT_PQUOTA,
+		error = xfs_qm_reset_dqcounts_buf(mp, pip, XFS_QMOPT_PQUOTA,
 					 &buffer_list);
 		if (error)
 			goto error_return;

