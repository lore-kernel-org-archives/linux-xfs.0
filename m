Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAS8Sctx225875 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 02:28:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E41174FAB45
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 00:28:37 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Nq8kLp39iI1JurSd for <xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 00:28:37 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RUwZp-0000w4-9k
	for xfs@oss.sgi.com; Mon, 28 Nov 2011 08:28:37 +0000
Message-Id: <20111128082837.263453373@bombadil.infradead.org>
Date: Mon, 28 Nov 2011 03:27:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/16] xfs: cleanup xfs_qm_dqlookup
References: <20111128082722.604873274@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_qm_dqlookup
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

Rearrange the code to avoid the conditional locking around the flist_locked
variable.  This means we lose a (rather pointless) assert, and hold the
freelist lock a bit longer for one corner case.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c |   25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-10-27 22:40:02.250173174 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-10-27 22:40:02.770171231 +0200
@@ -710,12 +710,9 @@ xfs_qm_dqlookup(
 	xfs_dquot_t		**O_dqpp)
 {
 	xfs_dquot_t		*dqp;
-	uint			flist_locked;
 
 	ASSERT(mutex_is_locked(&qh->qh_lock));
 
-	flist_locked = B_FALSE;
-
 	/*
 	 * Traverse the hashchain looking for a match
 	 */
@@ -750,31 +747,19 @@ xfs_qm_dqlookup(
 					xfs_dqlock(dqp);
 					dqp->dq_flags &= ~(XFS_DQ_WANT);
 				}
-				flist_locked = B_TRUE;
-			}
-
-			/*
-			 * id couldn't have changed; we had the hashlock all
-			 * along
-			 */
-			ASSERT(be32_to_cpu(dqp->q_core.d_id) == id);
 
-			if (flist_locked) {
-				if (dqp->q_nrefs != 0) {
-					mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
-					flist_locked = B_FALSE;
-				} else {
+				if (dqp->q_nrefs == 0) {
 					/* take it off the freelist */
 					trace_xfs_dqlookup_freelist(dqp);
 					list_del_init(&dqp->q_freelist);
 					xfs_Gqm->qm_dqfrlist_cnt--;
 				}
+				XFS_DQHOLD(dqp);
+				mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
+			} else {
+				XFS_DQHOLD(dqp);
 			}
 
-			XFS_DQHOLD(dqp);
-
-			if (flist_locked)
-				mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 			/*
 			 * move the dquot to the front of the hashchain
 			 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
