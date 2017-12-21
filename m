Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34686 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754712AbdLUUSW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Dec 2017 15:18:22 -0500
Received: by mail-lf0-f67.google.com with SMTP id y78so23597299lfd.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Dec 2017 12:18:21 -0800 (PST)
From: Aliaksei Karaliou <akaraliou.dev@gmail.com>
Subject: [PATCH 2/2] xfs: quota: check result of register_shrinker()
Date: Thu, 21 Dec 2017 23:17:43 +0300
Message-Id: <20171221201743.18016-2-akaraliou.dev@gmail.com>
In-Reply-To: <20171221201743.18016-1-akaraliou.dev@gmail.com>
References: <20171221201743.18016-1-akaraliou.dev@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: Aliaksei Karaliou <akaraliou.dev@gmail.com>, linux-xfs@vger.kernel.org

xfs_qm_init_quotainfo() does not check result of register_shrinker()
which was tagged as __must_check recently, reported by sparse.

Signed-off-by: Aliaksei Karaliou <akaraliou.dev@gmail.com>
---
 fs/xfs/xfs_qm.c | 43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index d0053115427f..b27a019a844d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -48,7 +48,7 @@
 STATIC int	xfs_qm_init_quotainos(xfs_mount_t *);
 STATIC int	xfs_qm_init_quotainfo(xfs_mount_t *);
 
-
+STATIC void	xfs_qm_destroy_quotainos(xfs_quotainfo_t *qi);
 STATIC void	xfs_qm_dqfree_one(struct xfs_dquot *dqp);
 /*
  * We use the batch lookup interface to iterate over the dquots as it
@@ -695,9 +695,17 @@ xfs_qm_init_quotainfo(
 	qinf->qi_shrinker.scan_objects = xfs_qm_shrink_scan;
 	qinf->qi_shrinker.seeks = DEFAULT_SEEKS;
 	qinf->qi_shrinker.flags = SHRINKER_NUMA_AWARE;
-	register_shrinker(&qinf->qi_shrinker);
+
+	error = register_shrinker(&qinf->qi_shrinker);
+	if (error)
+		goto out_free_inos;
+
 	return 0;
 
+out_free_inos:
+	mutex_destroy(&qinf->qi_quotaofflock);
+	mutex_destroy(&qinf->qi_tree_lock);
+	xfs_qm_destroy_quotainos(qinf);
 out_free_lru:
 	list_lru_destroy(&qinf->qi_lru);
 out_free_qinf:
@@ -706,6 +714,23 @@ xfs_qm_init_quotainfo(
 	return error;
 }
 
+STATIC void
+xfs_qm_destroy_quotainos(
+	xfs_quotainfo_t	*qi)
+{
+	if (qi->qi_uquotaip) {
+		IRELE(qi->qi_uquotaip);
+		qi->qi_uquotaip = NULL; /* paranoia */
+	}
+	if (qi->qi_gquotaip) {
+		IRELE(qi->qi_gquotaip);
+		qi->qi_gquotaip = NULL;
+	}
+	if (qi->qi_pquotaip) {
+		IRELE(qi->qi_pquotaip);
+		qi->qi_pquotaip = NULL;
+	}
+}
 
 /*
  * Gets called when unmounting a filesystem or when all quotas get
@@ -723,19 +748,7 @@ xfs_qm_destroy_quotainfo(
 
 	unregister_shrinker(&qi->qi_shrinker);
 	list_lru_destroy(&qi->qi_lru);
-
-	if (qi->qi_uquotaip) {
-		IRELE(qi->qi_uquotaip);
-		qi->qi_uquotaip = NULL; /* paranoia */
-	}
-	if (qi->qi_gquotaip) {
-		IRELE(qi->qi_gquotaip);
-		qi->qi_gquotaip = NULL;
-	}
-	if (qi->qi_pquotaip) {
-		IRELE(qi->qi_pquotaip);
-		qi->qi_pquotaip = NULL;
-	}
+	xfs_qm_destroy_quotainos(qi);
 	mutex_destroy(&qi->qi_tree_lock);
 	mutex_destroy(&qi->qi_quotaofflock);
 	kmem_free(qi);
-- 
2.11.0

