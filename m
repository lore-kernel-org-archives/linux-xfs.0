Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49068 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCkE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:40:04 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2aM2i167664
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:04 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2hdrxn8jjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:03 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2e3XZ012955
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:03 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3I2e2MG026427
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:03 GMT
Subject: [PATCH 04/11] xfs: refactor dquot iteration
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:40:01 -0700
Message-ID: <152401920165.11465.7352161536009977149.stgit@magnolia>
In-Reply-To: <152401916729.11465.4212188839231900136.stgit@magnolia>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a helper function to iterate all the dquots of a given type in
the system, and refactor the dquot scrub to use it.  This will get more
use in the quota repair code.  Note that the new function differs from
xfs_qm_dqiterate in that _dqiterate iterates dquot buffers, not the
in-core structures themselves.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/quota.c |   46 +++++++++++++++++++++-------------------------
 fs/xfs/xfs_dquot.c   |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot.h   |    5 +++++
 3 files changed, 67 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 6ba465e..363e318 100644
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
@@ -264,25 +273,12 @@ xfs_scrub_quota(
 		goto out;
 
 	/* Check all the quota items. */
-	while (id < ((xfs_dqid_t)-1ULL)) {
-		if (xfs_scrub_should_terminate(sc, &error))
-			break;
-
-		error = xfs_qm_dqget(mp, NULL, id, dqtype, XFS_QMOPT_DQNEXT,
-				&dq);
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
+	error = xfs_dquot_iterate(mp, dqtype, 0, xfs_scrub_quota_item, &sqi);
+	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK,
+			sqi.last_id * qi->qi_dqperchunk, &error))
+		goto out;
 
 out:
 	/* We set sc->ip earlier, so make sure we clear it now. */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ed2e37c..ec00402 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1127,3 +1127,44 @@ xfs_qm_exit(void)
 	kmem_zone_destroy(xfs_qm_dqtrxzone);
 	kmem_zone_destroy(xfs_qm_dqzone);
 }
+
+/*
+ * Iterate every dquot of a particular type.  The caller must ensure that the
+ * particular quota type is active.  iter_fn can return negative error codes,
+ * or XFS_BTREE_QUERY_RANGE_ABORT to indicate that it wants to stop iterating.
+ *
+ * Note that xfs_qm_dqiterate iterates all the dquot bufs, not the dquots
+ * themselves.
+ */
+int
+xfs_dquot_iterate(
+	struct xfs_mount	*mp,
+	uint			dqtype,
+	uint			iter_flags,
+	xfs_dquot_iterate_fn	iter_fn,
+	void			*priv)
+{
+	struct xfs_dquot	*dq;
+	xfs_dqid_t		id = 0;
+	int			error;
+
+	while (id < ((xfs_dqid_t)-1ULL)) {
+		error = xfs_qm_dqget(mp, NULL, id, dqtype,
+				XFS_QMOPT_DQNEXT | iter_flags, &dq);
+		if (error == -ENOENT) {
+			error = 0;
+			break;
+		}
+		if (error)
+			break;
+
+		id = be32_to_cpu(dq->q_core.d_id);
+		error = iter_fn(dq, dqtype, id, priv);
+		xfs_qm_dqput(dq);
+		id++;
+		if (error || id == 0)
+			break;
+	}
+
+	return error;
+}
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 2f536f3..db0511e 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -185,4 +185,9 @@ static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 	return dqp;
 }
 
+typedef int (*xfs_dquot_iterate_fn)(struct xfs_dquot *dq, uint dqtype,
+		xfs_dqid_t id, void *priv);
+int xfs_dquot_iterate(struct xfs_mount *mp, uint dqtype, uint iter_flags,
+		xfs_dquot_iterate_fn iter_fn, void *priv);
+
 #endif /* __XFS_DQUOT_H__ */

