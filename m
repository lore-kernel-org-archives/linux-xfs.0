Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAS1wqsh121926 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 19:58:52 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	uupvBusYFjYhxulB for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 18:01:08 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TdWxV-0003zV-Rr
	for xfs@oss.sgi.com; Wed, 28 Nov 2012 13:01:05 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TdWxV-0000SS-OK
	for xfs@oss.sgi.com; Wed, 28 Nov 2012 13:01:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: fix stray dquot unlock when reclaiming dquots
Date: Wed, 28 Nov 2012 13:01:02 +1100
Message-Id: <1354068063-1692-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1354068063-1692-1-git-send-email-david@fromorbit.com>
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When we fail to get a dquot lock during reclaim, we jump to an error
handler that unlocks the dquot. This is wrong as we didn't lock the
dquot, and unlocking it means who-ever is holding the lock has had
it silently taken away, and hence it results in a lock imbalance.

Found by inspection while modifying the code for the numa-lru
patchset. This fixes a random hang I've been seeing on xfstest 232
for the past several months.

cc: <stable@vger.kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_qm.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e6a0af0..60eff47 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1456,7 +1456,7 @@ xfs_qm_dqreclaim_one(
 	int			error;
 
 	if (!xfs_dqlock_nowait(dqp))
-		goto out_busy;
+		goto out_move_tail;
 
 	/*
 	 * This dquot has acquired a reference in the meantime remove it from
@@ -1479,7 +1479,7 @@ xfs_qm_dqreclaim_one(
 	 * getting flushed to disk, we don't want to reclaim it.
 	 */
 	if (!xfs_dqflock_nowait(dqp))
-		goto out_busy;
+		goto out_unlock_move_tail;
 
 	if (XFS_DQ_IS_DIRTY(dqp)) {
 		struct xfs_buf	*bp = NULL;
@@ -1490,7 +1490,7 @@ xfs_qm_dqreclaim_one(
 		if (error) {
 			xfs_warn(mp, "%s: dquot %p flush failed",
 				 __func__, dqp);
-			goto out_busy;
+			goto out_unlock_move_tail;
 		}
 
 		xfs_buf_delwri_queue(bp, buffer_list);
@@ -1499,7 +1499,7 @@ xfs_qm_dqreclaim_one(
 		 * Give the dquot another try on the freelist, as the
 		 * flushing will take some time.
 		 */
-		goto out_busy;
+		goto out_unlock_move_tail;
 	}
 	xfs_dqfunlock(dqp);
 
@@ -1518,14 +1518,13 @@ xfs_qm_dqreclaim_one(
 	XFS_STATS_INC(xs_qm_dqreclaims);
 	return;
 
-out_busy:
-	xfs_dqunlock(dqp);
-
 	/*
 	 * Move the dquot to the tail of the list so that we don't spin on it.
 	 */
+out_unlock_move_tail:
+	xfs_dqunlock(dqp);
+out_move_tail:
 	list_move_tail(&dqp->q_lru, &qi->qi_lru_list);
-
 	trace_xfs_dqreclaim_busy(dqp);
 	XFS_STATS_INC(xs_qm_dqreclaim_misses);
 }
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
