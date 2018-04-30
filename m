Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50552 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbeD3Fou (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 01:44:50 -0400
Subject: [PATCH 12/13] xfs: rename on-disk dquot counter zap functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 29 Apr 2018 22:44:30 -0700
Message-ID: <152506707010.21553.15727146910203332609.stgit@magnolia>
In-Reply-To: <152506698177.21553.13500862866416804148.stgit@magnolia>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de

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
index c6b1e9bd7a3e..fcbbae70748a 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -889,7 +889,7 @@ xfs_qm_reset_dqcounts(
 }
 
 STATIC int
-xfs_qm_dqiter_bufs(
+xfs_qm_reset_dqcounts_all(
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
+xfs_qm_reset_dqcounts_buf(
 	struct xfs_mount	*mp,
 	struct xfs_inode	*qip,
 	uint			flags,
@@ -1037,7 +1037,7 @@ xfs_qm_dqiterate(
 			 * Iterate thru all the blks in the extent and
 			 * reset the counters of all the dquots inside them.
 			 */
-			error = xfs_qm_dqiter_bufs(mp, firstid,
+			error = xfs_qm_reset_dqcounts_all(mp, firstid,
 						   map[i].br_startblock,
 						   map[i].br_blockcount,
 						   flags, buffer_list);
@@ -1299,7 +1299,7 @@ xfs_qm_quotacheck(
 	 * We don't log our changes till later.
 	 */
 	if (uip) {
-		error = xfs_qm_dqiterate(mp, uip, XFS_QMOPT_UQUOTA,
+		error = xfs_qm_reset_dqcounts_buf(mp, uip, XFS_QMOPT_UQUOTA,
 					 &buffer_list);
 		if (error)
 			goto error_return;
@@ -1307,7 +1307,7 @@ xfs_qm_quotacheck(
 	}
 
 	if (gip) {
-		error = xfs_qm_dqiterate(mp, gip, XFS_QMOPT_GQUOTA,
+		error = xfs_qm_reset_dqcounts_buf(mp, gip, XFS_QMOPT_GQUOTA,
 					 &buffer_list);
 		if (error)
 			goto error_return;
@@ -1315,7 +1315,7 @@ xfs_qm_quotacheck(
 	}
 
 	if (pip) {
-		error = xfs_qm_dqiterate(mp, pip, XFS_QMOPT_PQUOTA,
+		error = xfs_qm_reset_dqcounts_buf(mp, pip, XFS_QMOPT_PQUOTA,
 					 &buffer_list);
 		if (error)
 			goto error_return;

