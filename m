Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40624 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965410AbeEJP3U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 11:29:20 -0400
Subject: [PATCH 02/14] xfs: don't spray logs when dquot flush/purge fail
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 10 May 2018 08:28:58 -0700
Message-ID: <152596613825.27525.13579506494815344029.stgit@magnolia>
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

When dquot flush or purge fail there's no need to spam the logs, we've
already logged the IO error or fs shutdown that caused the flush
failures.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_dquot_item.c |    5 +----
 fs/xfs/xfs_qm.c         |   10 ++--------
 2 files changed, 3 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 57df98122156..8eb7415474d6 100644
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
index 62764f3e35e2..eb106366dea1 100644
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

