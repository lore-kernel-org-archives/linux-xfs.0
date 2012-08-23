Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N536ik134922 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:06 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UPajNLX9pDT3GZ1B for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:51 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZv-0003FZ-DI
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:35 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZq-0003d6-9p
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 024/102] xfs: untangle SYNC_WAIT and SYNC_TRYLOCK meanings for
	xfs_qm_dqflush
Date: Thu, 23 Aug 2012 15:01:42 +1000
Message-Id: <1345698180-13612-25-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: fdedf28b9492d69976110d12cc0d02d33c8ea7ea

Only skip pinned dquots if SYNC_TRYLOCK is specified, and adjust the callers
to keep the behaviour unchanged.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/quota/xfs_dquot.c      |    2 +-
 fs/xfs/quota/xfs_dquot_item.c |    2 +-
 fs/xfs/quota/xfs_qm.c         |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index 478a11b..b8be8a0 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -1173,7 +1173,7 @@ xfs_qm_dqflush(
 	 * If not dirty, or it's pinned and we are not supposed to block, nada.
 	 */
 	if (!XFS_DQ_IS_DIRTY(dqp) ||
-	    (!(flags & SYNC_WAIT) && atomic_read(&dqp->q_pincount) > 0)) {
+	    ((flags & SYNC_TRYLOCK) && atomic_read(&dqp->q_pincount) > 0)) {
 		xfs_dqfunlock(dqp);
 		return 0;
 	}
diff --git a/fs/xfs/quota/xfs_dquot_item.c b/fs/xfs/quota/xfs_dquot_item.c
index 8126fc2..87f10f3 100644
--- a/fs/xfs/quota/xfs_dquot_item.c
+++ b/fs/xfs/quota/xfs_dquot_item.c
@@ -134,7 +134,7 @@ xfs_qm_dquot_logitem_push(
 	 * lock without sleeping, then there must not have been
 	 * anyone in the process of flushing the dquot.
 	 */
-	error = xfs_qm_dqflush(dqp, 0);
+	error = xfs_qm_dqflush(dqp, SYNC_TRYLOCK);
 	if (error)
 		xfs_warn(dqp->q_mount, "%s: push error %d on dqp %p",
 			__func__, error, dqp);
diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index e70c7fc..3d50587 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -1703,7 +1703,7 @@ xfs_qm_quotacheck(
 	 * successfully.
 	 */
 	if (!error)
-		error = xfs_qm_dqflush_all(mp, 0);
+		error = xfs_qm_dqflush_all(mp, SYNC_TRYLOCK);
 
 	/*
 	 * We can get this error if we couldn't do a dquot allocation inside
@@ -1918,7 +1918,7 @@ again:
 			 * We flush it delayed write, so don't bother
 			 * releasing the freelist lock.
 			 */
-			error = xfs_qm_dqflush(dqp, 0);
+			error = xfs_qm_dqflush(dqp, SYNC_TRYLOCK);
 			if (error) {
 				xfs_warn(mp, "%s: dquot %p flush failed",
 					__func__, dqp);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
