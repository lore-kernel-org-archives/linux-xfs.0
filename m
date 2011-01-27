Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R3rcUC184541 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 21:53:38 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90BD3105D4B7
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 19:56:01 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	0DuTra4uhVnkIkJm for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 19:56:01 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PiIxi-0008FW-Ai
	for xfs@oss.sgi.com; Thu, 27 Jan 2011 14:55:58 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PiIvF-0004TL-SR
	for xfs@oss.sgi.com; Thu, 27 Jan 2011 14:53:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] xfs: fix dquot shaker deadlock
Date: Thu, 27 Jan 2011 14:53:21 +1100
Message-Id: <1296100401-17135-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1296100401-17135-1-git-send-email-david@fromorbit.com>
References: <1296100401-17135-1-git-send-email-david@fromorbit.com>
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

Commit 368e136 ("xfs: remove duplicate code from dquot reclaim") fails
to unlock the dquot freelist when the number of loop restarts is
exceeded in xfs_qm_dqreclaim_one(). This causes hangs in memory
reclaim. Remove the bogus loop exit check that causes the problem.

Reported-by: Malcolm Scott <lkml@malc.org.uk>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/quota/xfs_qm.c |   46 +++++++++++++++++++++-------------------------
 1 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index f8e854b..206a281 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -1863,12 +1863,14 @@ xfs_qm_dqreclaim_one(void)
 	xfs_dquot_t	*dqpout;
 	xfs_dquot_t	*dqp;
 	int		restarts;
+	int		startagain;
 
 	restarts = 0;
 	dqpout = NULL;
 
 	/* lockorder: hashchainlock, freelistlock, mplistlock, dqlock, dqflock */
-startagain:
+again:
+	startagain = 0;
 	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
 
 	list_for_each_entry(dqp, &xfs_Gqm->qm_dqfrlist, q_freelist) {
@@ -1885,13 +1887,10 @@ startagain:
 			ASSERT(! (dqp->dq_flags & XFS_DQ_INACTIVE));
 
 			trace_xfs_dqreclaim_want(dqp);
-
-			xfs_dqunlock(dqp);
-			mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
-			if (++restarts >= XFS_QM_RECLAIM_MAX_RESTARTS)
-				return NULL;
 			XQM_STATS_INC(xqmstats.xs_qm_dqwants);
-			goto startagain;
+			restarts++;
+			startagain = 1;
+			goto dqunlock;
 		}
 
 		/*
@@ -1906,23 +1905,20 @@ startagain:
 			ASSERT(list_empty(&dqp->q_mplist));
 			list_del_init(&dqp->q_freelist);
 			xfs_Gqm->qm_dqfrlist_cnt--;
-			xfs_dqunlock(dqp);
 			dqpout = dqp;
 			XQM_STATS_INC(xqmstats.xs_qm_dqinact_reclaims);
-			break;
+			goto dqunlock;
 		}
 
 		ASSERT(dqp->q_hash);
 		ASSERT(!list_empty(&dqp->q_mplist));
 
 		/*
-		 * Try to grab the flush lock. If this dquot is in the process of
-		 * getting flushed to disk, we don't want to reclaim it.
+		 * Try to grab the flush lock. If this dquot is in the process
+		 * of getting flushed to disk, we don't want to reclaim it.
 		 */
-		if (!xfs_dqflock_nowait(dqp)) {
-			xfs_dqunlock(dqp);
-			continue;
-		}
+		if (!xfs_dqflock_nowait(dqp))
+			goto dqunlock;
 
 		/*
 		 * We have the flush lock so we know that this is not in the
@@ -1944,8 +1940,7 @@ startagain:
 				xfs_fs_cmn_err(CE_WARN, mp,
 			"xfs_qm_dqreclaim: dquot %p flush failed", dqp);
 			}
-			xfs_dqunlock(dqp); /* dqflush unlocks dqflock */
-			continue;
+			goto dqunlock;
 		}
 
 		/*
@@ -1967,13 +1962,8 @@ startagain:
 		 */
 		if (!mutex_trylock(&mp->m_quotainfo->qi_dqlist_lock)) {
 			restarts++;
-			mutex_unlock(&dqp->q_hash->qh_lock);
-			xfs_dqfunlock(dqp);
-			xfs_dqunlock(dqp);
-			mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
-			if (restarts++ >= XFS_QM_RECLAIM_MAX_RESTARTS)
-				return NULL;
-			goto startagain;
+			startagain = 1;
+			goto qhunlock;
 		}
 
 		ASSERT(dqp->q_nrefs == 0);
@@ -1986,14 +1976,20 @@ startagain:
 		xfs_Gqm->qm_dqfrlist_cnt--;
 		dqpout = dqp;
 		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
+qhunlock:
 		mutex_unlock(&dqp->q_hash->qh_lock);
 dqfunlock:
 		xfs_dqfunlock(dqp);
+dqunlock:
 		xfs_dqunlock(dqp);
 		if (dqpout)
 			break;
 		if (restarts >= XFS_QM_RECLAIM_MAX_RESTARTS)
-			return NULL;
+			break;
+		if (startagain) {
+			mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
+			goto again;
+		}
 	}
 	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 	return dqpout;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
