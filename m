Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50226 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbeDRCmt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:42:49 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2gIS6171283
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:49 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2hdrxn8jpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:49 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2gm9m017377
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:49 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2gm0F026329
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:48 GMT
Subject: [PATCH 09/24] xfs: add helpers to attach quotas to inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:42:47 -0700
Message-ID: <152401936727.12079.6450563557458325208.stgit@magnolia>
In-Reply-To: <152401930978.12079.2000682561964128780.stgit@magnolia>
References: <152401930978.12079.2000682561964128780.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a helper routine to attach quota information to inodes that are
about to undergo repair.  If that fails, we need to schedule a
quotacheck for the next mount but allow the corrupted metadata repair to
continue.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |    2 ++
 fs/xfs/xfs_quota.h    |   16 ++++++++++++++
 3 files changed, 75 insertions(+)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 1779590..16f7c5f 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -42,6 +42,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_ag_resv.h"
 #include "xfs_trans_space.h"
+#include "xfs_quota.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -1018,3 +1019,59 @@ xfs_repair_reset_counters(
 
 	return 0;
 }
+
+/* Force a quotacheck the next time we mount. */
+void
+xfs_repair_force_quotacheck(
+	struct xfs_scrub_context	*sc,
+	uint				dqtype)
+{
+	uint				flag;
+
+	flag = xfs_quota_chkd_flag(dqtype);
+	if (!(flag & sc->mp->m_qflags))
+		return;
+
+	sc->mp->m_qflags &= ~flag;
+	spin_lock(&sc->mp->m_sb_lock);
+	sc->mp->m_sb.sb_qflags &= ~flag;
+	spin_unlock(&sc->mp->m_sb_lock);
+	xfs_log_sb(sc->tp);
+}
+
+/*
+ * Ensure that dquots are attached to this inode.   We do not pass DQALLOC
+ * here because we're already in transaction context and the metadata was
+ * pre-existing so the dquot ought to exist already.If the quota code signals
+ * corruption or missing quota information, schedule quotacheck at next mount.
+ */
+int
+xfs_repair_ino_dqattach(
+	struct xfs_scrub_context	*sc)
+{
+	int				error;
+
+	error = xfs_qm_dqattach_locked(sc->ip, 0);
+	switch (error) {
+	case -EFSBADCRC:
+	case -EFSCORRUPTED:
+	case -ENOENT:
+		xfs_err_ratelimited(sc->mp,
+"inode %llu repair encountered quota error %d, quotacheck forced.",
+				(unsigned long long)sc->ip->i_ino, error);
+		if (XFS_IS_UQUOTA_ON(sc->mp) && !sc->ip->i_udquot)
+			xfs_repair_force_quotacheck(sc, XFS_DQ_USER);
+		if (XFS_IS_GQUOTA_ON(sc->mp) && !sc->ip->i_gdquot)
+			xfs_repair_force_quotacheck(sc, XFS_DQ_GROUP);
+		if (XFS_IS_PQUOTA_ON(sc->mp) && !sc->ip->i_pdquot)
+			xfs_repair_force_quotacheck(sc, XFS_DQ_PROJ);
+		/* fall through */
+	case -ESRCH:
+		error = 0;
+		break;
+	default:
+		break;
+	}
+
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index eea32a2..0cb91dc 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -97,6 +97,8 @@ int xfs_repair_find_ag_btree_roots(struct xfs_scrub_context *sc,
 		struct xfs_repair_find_ag_btree *btree_info,
 		struct xfs_buf *agfl_bp);
 int xfs_repair_reset_counters(struct xfs_mount *mp);
+void xfs_repair_force_quotacheck(struct xfs_scrub_context *sc, uint dqtype);
+int xfs_repair_ino_dqattach(struct xfs_scrub_context *sc);
 
 /* Metadata repairers */
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index ce6506a..f6e1cd2 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -48,6 +48,22 @@ struct xfs_trans;
 	 (XFS_IS_PQUOTA_ON(mp) && \
 		(mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD) == 0))
 
+static inline uint
+xfs_quota_chkd_flag(
+	uint		dqtype)
+{
+	switch (dqtype) {
+	case XFS_DQ_USER:
+		return XFS_UQUOTA_CHKD;
+	case XFS_DQ_GROUP:
+		return XFS_GQUOTA_CHKD;
+	case XFS_DQ_PROJ:
+		return XFS_PQUOTA_CHKD;
+	default:
+		return 0;
+	}
+}
+
 /*
  * The structure kept inside the xfs_trans_t keep track of dquot changes
  * within a transaction and apply them later.

