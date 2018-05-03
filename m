Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47824 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbeECRyb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 13:54:31 -0400
Date: Thu, 3 May 2018 10:54:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0.2/13] xfs: don't spray logs when dquot flush/purge fail
Message-ID: <20180503175409.GG4127@magnolia>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152506698177.21553.13500862866416804148.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

When dquot flush or purge fail there's no need to spam the logs, we've
already logged the IO error or fs shutdown that caused the flush
failures.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot_item.c |    5 +----
 fs/xfs/xfs_qm.c         |   10 ++--------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 4b331e354da7..d632ba403527 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -209,10 +209,7 @@ xfs_qm_dquot_logitem_push(
 	spin_unlock(&lip->li_ailp->ail_lock);
 
 	error = xfs_qm_dqflush(dqp, &bp);
-	if (error) {
-		xfs_warn(dqp->q_mount, "%s: push error %d on dqp "PTR_FMT,
-			__func__, error, dqp);
-	} else {
+	if (!error) {
 		if (!xfs_buf_delwri_queue(bp, buffer_list))
 			rval = XFS_ITEM_FLUSHING;
 		xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ec39ae274c78..579de656bc25 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -161,10 +161,7 @@ xfs_qm_dqpurge(
 		 * to purge this dquot anyway, so we go ahead regardless.
 		 */
 		error = xfs_qm_dqflush(dqp, &bp);
-		if (error) {
-			xfs_warn(mp, "%s: dquot "PTR_FMT" flush failed",
-				__func__, dqp);
-		} else {
+		if (!error) {
 			error = xfs_bwrite(bp);
 			xfs_buf_relse(bp);
 		}
@@ -479,11 +476,8 @@ xfs_qm_dquot_isolate(
 		spin_unlock(lru_lock);
 
 		error = xfs_qm_dqflush(dqp, &bp);
-		if (error) {
-			xfs_warn(dqp->q_mount, "%s: dquot "PTR_FMT" flush failed",
-				 __func__, dqp);
+		if (error)
 			goto out_unlock_dirty;
-		}
 
 		xfs_buf_delwri_queue(bp, &isol->buffers);
 		xfs_buf_relse(bp);
