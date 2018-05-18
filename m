Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47988 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbeERD6I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 23:58:08 -0400
Date: Thu, 17 May 2018 20:58:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 07/22] xfs: add helpers to attach quotas to inodes
Message-ID: <20180518035802.GE23858@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642366309.1556.5697073197011046065.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152642366309.1556.5697073197011046065.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a helper routine to attach quota information to inodes that are
about to undergo repair.  If that fails, we need to schedule a
quotacheck for the next mount but allow the corrupted metadata repair to
continue.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
v2: improve documentation
---
 fs/xfs/scrub/repair.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |    2 ++
 fs/xfs/xfs_quota.h    |   16 +++++++++++++
 3 files changed, 79 insertions(+)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 4b95a15c0bd0..4d16a9503bf6 100644
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
@@ -1115,3 +1116,63 @@ xfs_repair_reset_counters(
 
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
+ * Attach dquots to this inode, or schedule quotacheck to fix them.
+ *
+ * This function ensures that the appropriate dquots are attached to an inode.
+ * We cannot allow the dquot code to allocate an on-disk dquot block here
+ * because we're already in transaction context with the inode locked.  The
+ * on-disk dquot should already exist anyway.  If the quota code signals
+ * corruption or missing quota information, schedule quotacheck, which will
+ * repair corruptions in the quota metadata.
+ */
+int
+xfs_repair_ino_dqattach(
+	struct xfs_scrub_context	*sc)
+{
+	int				error;
+
+	error = xfs_qm_dqattach_locked(sc->ip, false);
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
index cc590312550a..fbfc7da7b708 100644
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
index 1c79ebbe5236..3edf52b14919 100644
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
