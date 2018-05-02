Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49706 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751140AbeEBQnZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 12:43:25 -0400
Date: Wed, 2 May 2018 09:43:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 13/13] xfs: refactor dquot iteration
Message-ID: <20180502164303.GW4127@magnolia>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
 <152506707631.21553.6110605230681161129.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152506707631.21553.6110605230681161129.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a helper function to iterate all the dquots of a given type in
the system, and refactor the dquot scrub to use it.  This will get more
use in the quota repair code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
v2: fix compiler warning about uninitialized offset
---
 fs/xfs/scrub/quota.c |   56 +++++++++++++++++++++++---------------------------
 fs/xfs/xfs_dquot.c   |   32 +++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot.h   |    5 ++++
 3 files changed, 63 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 50415e8e5dd1..ba87c3aaa8b7 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -77,14 +77,20 @@ xfs_scrub_setup_quota(
 
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
+	void				*priv)
 {
+	struct xfs_scrub_quota_info	*sqi = priv;
+	struct xfs_scrub_context	*sc = sqi->sc;
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_disk_dquot		*d = &dq->q_core;
 	struct xfs_quotainfo		*qi = mp->m_quotainfo;
@@ -99,17 +105,18 @@ xfs_scrub_quota_item(
 	unsigned long long		icount;
 	unsigned long long		rcount;
 	xfs_ino_t			fs_icount;
-
-	offset = id / qi->qi_dqperchunk;
+	xfs_dqid_t			id = be32_to_cpu(d->d_id);
 
 	/*
-	 * We fed $id and DQNEXT into the xfs_qm_dqget call, which means
-	 * that the actual dquot we got must either have the same id or
-	 * the next higher id.
+	 * Except for the root dquot, the actual dquot we got must either have
+	 * the same or higher id as we saw before.
 	 */
-	if (id > be32_to_cpu(d->d_id))
+	offset = id / qi->qi_dqperchunk;
+	if (id && id <= sqi->last_id)
 		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
+	sqi->last_id = id;
+
 	/* Did we get the dquot type we wanted? */
 	if (dqtype != (d->d_flags & XFS_DQ_ALLTYPES))
 		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
@@ -183,6 +190,8 @@ xfs_scrub_quota_item(
 		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 	if (id != 0 && rhard != 0 && rcount > rhard)
 		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
+
+	return 0;
 }
 
 /* Scrub all of a quota type's items. */
@@ -191,13 +200,12 @@ xfs_scrub_quota(
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
@@ -264,24 +272,12 @@ xfs_scrub_quota(
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
index 4b76ae00e69b..f8b8c99e3e73 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1212,3 +1212,35 @@ xfs_qm_exit(void)
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
+		error = iter_fn(dq, dqtype, priv);
+		id = be32_to_cpu(dq->q_core.d_id);
+		xfs_qm_dqput(dq);
+		id++;
+	} while (error == 0 && id != 0);
+
+	return error;
+}
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 6959f0135f36..417ac03b8d7b 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -193,4 +193,9 @@ static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 	return dqp;
 }
 
+typedef int (*xfs_qm_dqiterate_fn)(struct xfs_dquot *dq, uint dqtype,
+		void *priv);
+int xfs_qm_dqiterate(struct xfs_mount *mp, uint dqtype,
+		xfs_qm_dqiterate_fn iter_fn, void *priv);
+
 #endif /* __XFS_DQUOT_H__ */
