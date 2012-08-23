Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N5361I134923 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:06 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	hRWouPdn1I2qdP5G for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:51 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pa0-0003Fk-Eq
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:40 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pa0-0003dK-Bd
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 026/102] xfs: simplify xfs_qm_detach_gdquots
Date: Thu, 23 Aug 2012 15:01:44 +1000
Message-Id: <1345698180-13612-27-git-send-email-david@fromorbit.com>
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

Upstream commit: 28fb588c9bd810dec273d96e80591392f6ce1e1c

There is no reason to drop qi_dqlist_lock around calls to xfs_qm_dqrele
because the free list lock now nests inside qi_dqlist_lock and the
dquot lock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/quota/xfs_qm.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index 0785984..eacf7e0 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -518,31 +518,18 @@ xfs_qm_detach_gdquots(
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	struct xfs_dquot	*dqp, *gdqp;
-	int			nrecl;
 
- again:
 	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
 	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
 		xfs_dqlock(dqp);
-		if ((gdqp = dqp->q_gdquot)) {
-			xfs_dqlock(gdqp);
+
+		gdqp = dqp->q_gdquot;
+		if (gdqp)
 			dqp->q_gdquot = NULL;
-		}
 		xfs_dqunlock(dqp);
+		if (gdqp)
+			xfs_qm_dqrele(gdqp);
 
-		if (gdqp) {
-			/*
-			 * Can't hold the mplist lock across a dqput.
-			 * XXXmust convert to marker based iterations here.
-			 */
-			nrecl = q->qi_dqreclaims;
-			mutex_unlock(&q->qi_dqlist_lock);
-			xfs_qm_dqput(gdqp);
-
-			mutex_lock(&q->qi_dqlist_lock);
-			if (nrecl != q->qi_dqreclaims)
-				goto again;
-		}
 	}
 }
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
