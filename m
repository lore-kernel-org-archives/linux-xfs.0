Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42714 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751231AbeDDTKW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Apr 2018 15:10:22 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A18C22B0F
        for <linux-xfs@vger.kernel.org>; Wed,  4 Apr 2018 14:09:46 -0500 (CDT)
Subject: [PATCH 5/6] xfs: factor out quota time limit initialization
From: Eric Sandeen <sandeen@sandeen.net>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
Message-ID: <2d87ba58-f713-6326-8683-29185155ee58@sandeen.net>
Date: Wed, 4 Apr 2018 14:10:20 -0500
MIME-Version: 1.0
In-Reply-To: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Factor out the time limit initialization from
xfs_qm_init_quotainfo so that we can delay it until
after quotacheck - it requires reading the default disk
quotas, which may need repair.

No functional changes in this patch.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

nb: the patch itself looks weird, what it really does is move the
timelimit setting /up/ in the file.  You just have to squint
at it.

 fs/xfs/xfs_qm.c | 91 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 328d770..a4da46c 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -594,47 +594,13 @@ struct xfs_qm_isolate {
 	}
 }
 
-/*
- * This initializes all the quota information that's kept in the
- * mount structure
- */
-STATIC int
-xfs_qm_init_quotainfo(
-	xfs_mount_t	*mp)
+STATIC void
+xfs_qm_set_timelimits(
+	struct xfs_mount	*mp,
+	struct xfs_quotainfo	*qinf)
 {
-	xfs_quotainfo_t *qinf;
-	int		error;
-	xfs_dquot_t	*dqp;
-
-	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
-
-	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(xfs_quotainfo_t), KM_SLEEP);
-
-	error = list_lru_init(&qinf->qi_lru);
-	if (error)
-		goto out_free_qinf;
-
-	/*
-	 * See if quotainodes are setup, and if not, allocate them,
-	 * and change the superblock accordingly.
-	 */
-	error = xfs_qm_init_quotainos(mp);
-	if (error)
-		goto out_free_lru;
-
-	INIT_RADIX_TREE(&qinf->qi_uquota_tree, GFP_NOFS);
-	INIT_RADIX_TREE(&qinf->qi_gquota_tree, GFP_NOFS);
-	INIT_RADIX_TREE(&qinf->qi_pquota_tree, GFP_NOFS);
-	mutex_init(&qinf->qi_tree_lock);
-
-	/* mutex used to serialize quotaoffs */
-	mutex_init(&qinf->qi_quotaofflock);
-
-	/* Precalc some constants */
-	qinf->qi_dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
-	qinf->qi_dqperchunk = xfs_calc_dquots_per_chunk(qinf->qi_dqchunklen);
-
-	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
+	int			error;
+	xfs_dquot_t		*dqp;
 
 	/*
 	 * We try to get the limits from the superuser's limits fields.
@@ -691,6 +657,51 @@ struct xfs_qm_isolate {
 		xfs_qm_set_defquota(mp, XFS_DQ_PROJ, qinf);
 
 	qinf->qi_shrinker.count_objects = xfs_qm_shrink_count;
+}
+
+/*
+ * This initializes all the quota information that's kept in the
+ * mount structure
+ */
+STATIC int
+xfs_qm_init_quotainfo(
+	xfs_mount_t	*mp)
+{
+	xfs_quotainfo_t *qinf;
+	int		error;
+
+	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
+
+	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(xfs_quotainfo_t), KM_SLEEP);
+
+	error = list_lru_init(&qinf->qi_lru);
+	if (error)
+		goto out_free_qinf;
+
+	/*
+	 * See if quotainodes are setup, and if not, allocate them,
+	 * and change the superblock accordingly.
+	 */
+	error = xfs_qm_init_quotainos(mp);
+	if (error)
+		goto out_free_lru;
+
+	INIT_RADIX_TREE(&qinf->qi_uquota_tree, GFP_NOFS);
+	INIT_RADIX_TREE(&qinf->qi_gquota_tree, GFP_NOFS);
+	INIT_RADIX_TREE(&qinf->qi_pquota_tree, GFP_NOFS);
+	mutex_init(&qinf->qi_tree_lock);
+
+	/* mutex used to serialize quotaoffs */
+	mutex_init(&qinf->qi_quotaofflock);
+
+	/* Precalc some constants */
+	qinf->qi_dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
+	qinf->qi_dqperchunk = xfs_calc_dquots_per_chunk(qinf->qi_dqchunklen);
+
+	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
+
+	xfs_qm_set_timelimits(mp, qinf);
+
 	qinf->qi_shrinker.scan_objects = xfs_qm_shrink_scan;
 	qinf->qi_shrinker.seeks = DEFAULT_SEEKS;
 	qinf->qi_shrinker.flags = SHRINKER_NUMA_AWARE;
-- 
1.8.3.1

