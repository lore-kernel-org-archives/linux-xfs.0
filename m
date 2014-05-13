Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5DFE97F50
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 03:56:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DB0C6AC003
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 01:56:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	k8P05FVIykWhKfIt for <xfs@oss.sgi.com>;
	Tue, 13 May 2014 01:56:25 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wk8VW-0000Je-15
	for xfs@oss.sgi.com; Tue, 13 May 2014 18:56:18 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wk8VW-0001lB-0K
	for xfs@oss.sgi.com; Tue, 13 May 2014 18:56:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 9/9] xfs: list_lru_init returns a negative error
Date: Tue, 13 May 2014 18:56:13 +1000
Message-Id: <1399971373-6242-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1399971373-6242-1-git-send-email-david@fromorbit.com>
References: <1399971373-6242-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

And we don't invert it properly when initialising the dquot lru
list.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_qm.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 348e4d2..dc977b6 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -843,22 +843,17 @@ xfs_qm_init_quotainfo(
 
 	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(xfs_quotainfo_t), KM_SLEEP);
 
-	if ((error = list_lru_init(&qinf->qi_lru))) {
-		kmem_free(qinf);
-		mp->m_quotainfo = NULL;
-		return error;
-	}
+	error = -list_lru_init(&qinf->qi_lru);
+	if (error)
+		goto out_free_qinf;
 
 	/*
 	 * See if quotainodes are setup, and if not, allocate them,
 	 * and change the superblock accordingly.
 	 */
-	if ((error = xfs_qm_init_quotainos(mp))) {
-		list_lru_destroy(&qinf->qi_lru);
-		kmem_free(qinf);
-		mp->m_quotainfo = NULL;
-		return error;
-	}
+	error = xfs_qm_init_quotainos(mp);
+	if (error)
+		goto out_free_lru;
 
 	INIT_RADIX_TREE(&qinf->qi_uquota_tree, GFP_NOFS);
 	INIT_RADIX_TREE(&qinf->qi_gquota_tree, GFP_NOFS);
@@ -918,7 +913,7 @@ xfs_qm_init_quotainfo(
 		qinf->qi_isoftlimit = be64_to_cpu(ddqp->d_ino_softlimit);
 		qinf->qi_rtbhardlimit = be64_to_cpu(ddqp->d_rtb_hardlimit);
 		qinf->qi_rtbsoftlimit = be64_to_cpu(ddqp->d_rtb_softlimit);
- 
+
 		xfs_qm_dqdestroy(dqp);
 	} else {
 		qinf->qi_btimelimit = XFS_QM_BTIMELIMIT;
@@ -935,6 +930,13 @@ xfs_qm_init_quotainfo(
 	qinf->qi_shrinker.flags = SHRINKER_NUMA_AWARE;
 	register_shrinker(&qinf->qi_shrinker);
 	return 0;
+
+out_free_lru:
+	list_lru_destroy(&qinf->qi_lru);
+out_free_qinf:
+	kmem_free(qinf);
+	mp->m_quotainfo = NULL;
+	return error;
 }
 
 
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
