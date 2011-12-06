Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6LwuMV003964 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 15:58:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D01781F45C03
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 13:58:55 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	3U7rnanQnkqdG8SK for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 13:58:55 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RY32N-0006Sj-Ba
	for xfs@oss.sgi.com; Tue, 06 Dec 2011 21:58:55 +0000
Message-Id: <20111206215855.306880439@bombadil.infradead.org>
Date: Tue, 06 Dec 2011 16:58:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 15/19] xfs: simplify xfs_qm_detach_gdquots
References: <20111206215806.844405397@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-simplify-xfs_qm_detach_gdquots
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

There is no reason to drop qi_dqlist_lock around calls to xfs_qm_dqrele
because the free list lock now nests inside qi_dqlist_lock and the
dquot lock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_qm.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-10-27 22:40:07.538179215 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-10-27 22:40:08.124671538 +0200
@@ -449,7 +449,6 @@ xfs_qm_detach_gdquots(
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	struct xfs_dquot	*dqp, *gdqp;
-	int			nrecl;
 
  again:
 	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
@@ -462,25 +461,14 @@ xfs_qm_detach_gdquots(
 			mutex_lock(&q->qi_dqlist_lock);
 			goto again;
 		}
-		if ((gdqp = dqp->q_gdquot)) {
-			xfs_dqlock(gdqp);
+
+		gdqp = dqp->q_gdquot;
+		if (gdqp)
 			dqp->q_gdquot = NULL;
-		}
 		xfs_dqunlock(dqp);
 
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
+		if (gdqp)
+			xfs_qm_dqrele(gdqp);
 	}
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
