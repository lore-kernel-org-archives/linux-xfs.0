Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48344 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754767AbeDVPH2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Apr 2018 11:07:28 -0400
Subject: [PATCH 13/13] xfs: refactor dquot iteration
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 22 Apr 2018 08:07:24 -0700
Message-ID: <152440964413.29601.4956532853947603949.stgit@magnolia>
In-Reply-To: <152440954198.29601.14390250048915099607.stgit@magnolia>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a helper function to iterate all the dquots of a given type in
the system, and refactor the dquot scrub to use it.  This will get more
use in the quota repair code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/quota.c |   45 +++++++++++++++++++++------------------------
 fs/xfs/xfs_dquot.c   |   32 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot.h   |    5 +++++
 3 files changed, 58 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 50415e8..0ba3ab4 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -77,14 +77,21 @@ xfs_scrub_setup_quota(
 
 /* Quotas. */
 
+struct xfs_scrub_quota_info {
+	struct xfs_scrub_context	*sc;
+	xfs_dqid_t			last_id;
+};
+
 /* Scrub the fields in an individual quota item. */
-STATIC void
+STATIC int
 xfs_scrub_quota_item(
-	struct xfs_scrub_context	*sc,
-	uint				dqtype,
 	struct xfs_dquot		*dq,
-	xfs_dqid_t			id)
+	uint				dqtype,
+	xfs_dqid_t			id,
+	void				*priv)
 {
+	struct xfs_scrub_quota_info	*sqi = priv;
+	struct xfs_scrub_context	*sc = sqi->sc;
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_disk_dquot		*d = &dq->q_core;
 	struct xfs_quotainfo		*qi = mp->m_quotainfo;
@@ -100,6 +107,7 @@ xfs_scrub_quota_item(
 	unsigned long long		rcount;
 	xfs_ino_t			fs_icount;
 
+	sqi->last_id = id;
 	offset = id / qi->qi_dqperchunk;
 
 	/*
@@ -183,6 +191,8 @@ xfs_scrub_quota_item(
 		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 	if (id != 0 && rhard != 0 && rcount > rhard)
 		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
+
+	return 0;
 }
 
 /* Scrub all of a quota type's items. */
@@ -191,13 +201,12 @@ xfs_scrub_quota(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_bmbt_irec		irec = { 0 };
+	struct xfs_scrub_quota_info	sqi;
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_inode		*ip;
 	struct xfs_quotainfo		*qi = mp->m_quotainfo;
-	struct xfs_dquot		*dq;
 	xfs_fileoff_t			max_dqid_off;
 	xfs_fileoff_t			off = 0;
-	xfs_dqid_t			id = 0;
 	uint				dqtype;
 	int				nimaps;
 	int				error = 0;
@@ -264,24 +273,12 @@ xfs_scrub_quota(
 		goto out;
 
 	/* Check all the quota items. */
-	while (id < ((xfs_dqid_t)-1ULL)) {
-		if (xfs_scrub_should_terminate(sc, &error))
-			break;
-
-		error = xfs_qm_dqget_next(mp, id, dqtype, &dq);
-		if (error == -ENOENT)
-			break;
-		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK,
-				id * qi->qi_dqperchunk, &error))
-			break;
-
-		xfs_scrub_quota_item(sc, dqtype, dq, id);
-
-		id = be32_to_cpu(dq->q_core.d_id) + 1;
-		xfs_qm_dqput(dq);
-		if (!id)
-			break;
-	}
+	sqi.sc = sc;
+	sqi.last_id = 0;
+	error = xfs_qm_dqiterate(mp, dqtype, xfs_scrub_quota_item, &sqi);
+	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK,
+			sqi.last_id * qi->qi_dqperchunk, &error))
+		goto out;
 
 out:
 	/* We set sc->ip earlier, so make sure we clear it now. */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 7ce3dbd..1f1139d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1213,3 +1213,35 @@ xfs_qm_exit(void)
 	kmem_zone_destroy(xfs_qm_dqtrxzone);
 	kmem_zone_destroy(xfs_qm_dqzone);
 }
+
+/*
+ * Iterate every dquot of a particular type.  The caller must ensure that the
+ * particular quota type is active.  iter_fn can return negative error codes,
+ * or XFS_BTREE_QUERY_RANGE_ABORT to indicate that it wants to stop iterating.
+ */
+int
+xfs_qm_dqiterate(
+	struct xfs_mount	*mp,
+	uint			dqtype,
+	xfs_qm_dqiterate_fn	iter_fn,
+	void			*priv)
+{
+	struct xfs_dquot	*dq;
+	xfs_dqid_t		id = 0;
+	int			error;
+
+	do {
+		error = xfs_qm_dqget_next(mp, id, dqtype, &dq);
+		if (error == -ENOENT)
+			return 0;
+		if (error)
+			return error;
+
+		id = be32_to_cpu(dq->q_core.d_id);
+		error = iter_fn(dq, dqtype, id, priv);
+		xfs_qm_dqput(dq);
+		id++;
+	} while (error == 0 && id != 0);
+
+	return error;
+}
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index fe99e43..5427355 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -194,4 +194,9 @@ static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 	return dqp;
 }
 
+typedef int (*xfs_qm_dqiterate_fn)(struct xfs_dquot *dq, uint dqtype,
+		xfs_dqid_t id, void *priv);
+int xfs_qm_dqiterate(struct xfs_mount *mp, uint dqtype,
+		xfs_qm_dqiterate_fn iter_fn, void *priv);
+
 #endif /* __XFS_DQUOT_H__ */

