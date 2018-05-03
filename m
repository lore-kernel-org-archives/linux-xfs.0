Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55630 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbeECSGf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 14:06:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w43I0x0f087021
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:06:35 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2hmgxg30pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 03 May 2018 18:06:35 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w43I6YEt031897
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:06:34 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w43I6Xfq027621
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:06:33 GMT
Subject: [PATCH 06/12] xfs: quota scrub should use bmapbtd scrubber
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 May 2018 11:06:32 -0700
Message-ID: <152537079262.16676.17333080911750675574.stgit@magnolia>
In-Reply-To: <152537075334.16676.10600900179473864298.stgit@magnolia>
References: <152537075334.16676.10600900179473864298.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the quota scrubber's open-coded data fork scrubber with a
redirected call to the bmapbtd scrubber.  This strengthens the quota
scrub to include all the cross-referencing that it does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c |   57 ++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h |    2 +
 fs/xfs/scrub/quota.c  |   83 ++++++++++++++++++++++++-------------------------
 3 files changed, 99 insertions(+), 43 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index e9ca5f0802d5..335c7a305e15 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -44,6 +44,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_log.h"
 #include "xfs_trans_priv.h"
+#include "xfs_attr.h"
+#include "xfs_reflink.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -777,3 +779,58 @@ xfs_scrub_buffer_recheck(
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 	trace_xfs_scrub_block_error(sc, bp->b_bn, fa);
 }
+
+/*
+ * Scrub the attr/data forks of a metadata inode.  The metadata inode must be
+ * pointed to by sc->ip and the ILOCK must be held.
+ */
+int
+xfs_scrub_metadata_inode_forks(
+	struct xfs_scrub_context	*sc)
+{
+	__u32				smtype;
+	bool				shared;
+	int				error;
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return 0;
+
+	/* Metadata inodes don't live on the rt device. */
+	if (sc->ip->i_d.di_flags & XFS_DIFLAG_REALTIME) {
+		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
+		return 0;
+	}
+
+	/* They should never participate in reflink. */
+	if (xfs_is_reflink_inode(sc->ip)) {
+		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
+		return 0;
+	}
+
+	/* They also should never have extended attributes. */
+	if (xfs_inode_hasattr(sc->ip)) {
+		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
+		return 0;
+	}
+
+	/* Invoke the data fork scrubber. */
+	smtype = sc->sm->sm_type;
+	sc->sm->sm_type = XFS_SCRUB_TYPE_BMBTD;
+	error = xfs_scrub_bmap_data(sc);
+	sc->sm->sm_type = smtype;
+	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		return error;
+
+	/* Look for incorrect shared blocks. */
+	if (xfs_sb_version_hasreflink(&sc->mp->m_sb)) {
+		error = xfs_reflink_inode_has_shared_extents(sc->tp, sc->ip,
+				&shared);
+		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0,
+				&error))
+			return error;
+		if (shared)
+			xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
+	}
+
+	return error;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 80fa5a67c265..ad736c411287 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -167,4 +167,6 @@ static inline bool xfs_scrub_skip_xref(struct xfs_scrub_metadata *sm)
 			       XFS_SCRUB_OFLAG_XCORRUPT);
 }
 
+int xfs_scrub_metadata_inode_forks(struct xfs_scrub_context *sc);
+
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index d3d08978f53a..15ae4d23d6ac 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -206,65 +206,62 @@ xfs_scrub_quota_item(
 	return 0;
 }
 
-/* Scrub all of a quota type's items. */
-int
-xfs_scrub_quota(
+/* Check the quota's data fork. */
+STATIC int
+xfs_scrub_quota_data_fork(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_bmbt_irec		irec = { 0 };
-	struct xfs_scrub_quota_info	sqi;
-	struct xfs_mount		*mp = sc->mp;
-	struct xfs_quotainfo		*qi = mp->m_quotainfo;
+	struct xfs_iext_cursor		icur;
+	struct xfs_quotainfo		*qi = sc->mp->m_quotainfo;
+	struct xfs_ifork		*ifp;
 	xfs_fileoff_t			max_dqid_off;
-	xfs_fileoff_t			off = 0;
-	uint				dqtype;
-	int				nimaps;
 	int				error = 0;
 
-	dqtype = xfs_scrub_quota_to_dqtype(sc);
+	/* Invoke the fork scrubber. */
+	error = xfs_scrub_metadata_inode_forks(sc);
+	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		return error;
 
-	/* Look for problem extents. */
-	if (sc->ip->i_d.di_flags & XFS_DIFLAG_REALTIME) {
-		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
-		goto out;
-	}
+	/* Check for data fork problems that apply only to quota files. */
 	max_dqid_off = ((xfs_dqid_t)-1) / qi->qi_dqperchunk;
-	while (1) {
+	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+	for_each_xfs_iext(ifp, &icur, &irec) {
 		if (xfs_scrub_should_terminate(sc, &error))
 			break;
-
-		off = irec.br_startoff + irec.br_blockcount;
-		nimaps = 1;
-		error = xfs_bmapi_read(sc->ip, off, -1, &irec, &nimaps,
-				XFS_BMAPI_ENTIRE);
-		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, off,
-				&error))
-			goto out;
-		if (!nimaps)
-			break;
-		if (irec.br_startblock == HOLESTARTBLOCK)
-			continue;
-
-		/* Check the extent record doesn't point to crap. */
-		if (irec.br_startblock + irec.br_blockcount <=
-		    irec.br_startblock)
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
-					irec.br_startoff);
-		if (!xfs_verify_fsbno(mp, irec.br_startblock) ||
-		    !xfs_verify_fsbno(mp, irec.br_startblock +
-					irec.br_blockcount - 1))
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
-					irec.br_startoff);
-
 		/*
-		 * Unwritten extents or blocks mapped above the highest
+		 * delalloc extents or blocks mapped above the highest
 		 * quota id shouldn't happen.
 		 */
 		if (isnullstartblock(irec.br_startblock) ||
 		    irec.br_startoff > max_dqid_off ||
-		    irec.br_startoff + irec.br_blockcount > max_dqid_off + 1)
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
+		    irec.br_startoff + irec.br_blockcount - 1 > max_dqid_off) {
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
+					irec.br_startoff);
+			break;
+		}
 	}
+
+	return error;
+}
+
+/* Scrub all of a quota type's items. */
+int
+xfs_scrub_quota(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_scrub_quota_info	sqi;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_quotainfo		*qi = mp->m_quotainfo;
+	uint				dqtype;
+	int				error = 0;
+
+	dqtype = xfs_scrub_quota_to_dqtype(sc);
+
+	/* Look for problem extents. */
+	error = xfs_scrub_quota_data_fork(sc);
+	if (error)
+		goto out;
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
 

