Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2DB247F56
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 17:25:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1CD428F8050
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 15:25:34 -0700 (PDT)
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id x8OjDpMiV6MRSy1w (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 15:25:33 -0700 (PDT)
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 27 Jun 2013 16:25:32 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 2D5373E4003F
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:10 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5RMPTfC160790 for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:29 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5RMPTqL018780
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:29 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v10 06/11] xfs: Change xfs_dquot_acct to be a 2-dimensional
	array
Date: Thu, 27 Jun 2013 17:25:09 -0500
Message-Id: <1372371914-11370-7-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

In preparation for combined pquota/gquota support, for the sake
of readability, change xfs_dquot_acct to be a 2-dimensional array.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_qm.h          |   12 ++++++++----
 fs/xfs/xfs_trans_dquot.c |   31 ++++++++++++-------------------
 2 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index d6d71f0..9efec02 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -116,11 +116,15 @@ extern void	xfs_trans_log_dquot(struct xfs_trans *, struct xfs_dquot *);
  * to do at commit time. All transactions that we know of at this point
  * affect no more than two dquots of one type. Hence, the TRANS_MAXDQS value.
  */
+enum {
+	XFS_QM_TRANS_USR = 0,
+	XFS_QM_TRANS_GRP,
+	XFS_QM_TRANS_DQTYPES
+};
 #define XFS_QM_TRANS_MAXDQS		2
-typedef struct xfs_dquot_acct {
-	xfs_dqtrx_t	dqa_usrdquots[XFS_QM_TRANS_MAXDQS];
-	xfs_dqtrx_t	dqa_grpdquots[XFS_QM_TRANS_MAXDQS];
-} xfs_dquot_acct_t;
+struct xfs_dquot_acct {
+	struct xfs_dqtrx	dqs[XFS_QM_TRANS_DQTYPES][XFS_QM_TRANS_MAXDQS];
+};
 
 /*
  * Users are allowed to have a usage exceeding their softlimit for
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 45b3e2d..7ea7485 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -103,8 +103,6 @@ xfs_trans_dup_dqinfo(
 		return;
 
 	xfs_trans_alloc_dqinfo(ntp);
-	oqa = otp->t_dqinfo->dqa_usrdquots;
-	nqa = ntp->t_dqinfo->dqa_usrdquots;
 
 	/*
 	 * Because the quota blk reservation is carried forward,
@@ -113,7 +111,9 @@ xfs_trans_dup_dqinfo(
 	if(otp->t_flags & XFS_TRANS_DQ_DIRTY)
 		ntp->t_flags |= XFS_TRANS_DQ_DIRTY;
 
-	for (j = 0; j < 2; j++) {
+	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
+		oqa = otp->t_dqinfo->dqs[j];
+		nqa = ntp->t_dqinfo->dqs[j];
 		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 			if (oqa[i].qt_dquot == NULL)
 				break;
@@ -138,8 +138,6 @@ xfs_trans_dup_dqinfo(
 			oq->qt_ino_res = oq->qt_ino_res_used;
 
 		}
-		oqa = otp->t_dqinfo->dqa_grpdquots;
-		nqa = ntp->t_dqinfo->dqa_grpdquots;
 	}
 }
 
@@ -177,8 +175,10 @@ xfs_trans_get_dqtrx(
 	int			i;
 	struct xfs_dqtrx	*qa;
 
-	qa = XFS_QM_ISUDQ(dqp) ?
-		tp->t_dqinfo->dqa_usrdquots : tp->t_dqinfo->dqa_grpdquots;
+	if (XFS_QM_ISUDQ(dqp))
+		qa = tp->t_dqinfo->dqs[XFS_QM_TRANS_USR];
+	else
+		qa = tp->t_dqinfo->dqs[XFS_QM_TRANS_GRP];
 
 	for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 		if (qa[i].qt_dquot == NULL ||
@@ -338,12 +338,10 @@ xfs_trans_apply_dquot_deltas(
 		return;
 
 	ASSERT(tp->t_dqinfo);
-	qa = tp->t_dqinfo->dqa_usrdquots;
-	for (j = 0; j < 2; j++) {
-		if (qa[0].qt_dquot == NULL) {
-			qa = tp->t_dqinfo->dqa_grpdquots;
+	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
+		qa = tp->t_dqinfo->dqs[j];
+		if (qa[0].qt_dquot == NULL)
 			continue;
-		}
 
 		/*
 		 * Lock all of the dquots and join them to the transaction.
@@ -494,10 +492,6 @@ xfs_trans_apply_dquot_deltas(
 			ASSERT(dqp->q_res_rtbcount >=
 				be64_to_cpu(dqp->q_core.d_rtbcount));
 		}
-		/*
-		 * Do the group quotas next
-		 */
-		qa = tp->t_dqinfo->dqa_grpdquots;
 	}
 }
 
@@ -520,9 +514,9 @@ xfs_trans_unreserve_and_mod_dquots(
 	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
 		return;
 
-	qa = tp->t_dqinfo->dqa_usrdquots;
+	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
+		qa = tp->t_dqinfo->dqs[j];
 
-	for (j = 0; j < 2; j++) {
 		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 			qtrx = &qa[i];
 			/*
@@ -564,7 +558,6 @@ xfs_trans_unreserve_and_mod_dquots(
 				xfs_dqunlock(dqp);
 
 		}
-		qa = tp->t_dqinfo->dqa_grpdquots;
 	}
 }
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
