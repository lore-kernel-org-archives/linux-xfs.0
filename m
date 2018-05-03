Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55968 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbeECSGq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 14:06:46 -0400
Subject: [PATCH 05/12] xfs: avoid ilock games in the quota scrubber
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 May 2018 11:06:26 -0700
Message-ID: <152537078642.16676.622541060040412774.stgit@magnolia>
In-Reply-To: <152537075334.16676.10600900179473864298.stgit@magnolia>
References: <152537075334.16676.10600900179473864298.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the quota scrubber to take the quotaofflock and grab the quota
inode in the setup function so that we can treat quota in the same
"scrub in the context of this inode" (i.e. sc->ip) manner as we treat
any other inode.  We do have to drop the quota inode's ILOCK_EXCL to use
dqiterate, but since dquots have their own individual locks the ILOCK
wasn't helping us anyway.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/scrub/quota.c |   53 ++++++++++++++++++++++++--------------------------
 fs/xfs/scrub/scrub.c |    4 ++++
 fs/xfs/scrub/scrub.h |    1 +
 3 files changed, 30 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index ba87c3aaa8b7..d3d08978f53a 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -66,12 +66,24 @@ xfs_scrub_setup_quota(
 	struct xfs_inode		*ip)
 {
 	uint				dqtype;
+	int				error;
+
+	if (!XFS_IS_QUOTA_RUNNING(sc->mp) || !XFS_IS_QUOTA_ON(sc->mp))
+		return -ENOENT;
 
 	dqtype = xfs_scrub_quota_to_dqtype(sc);
 	if (dqtype == 0)
 		return -EINVAL;
+	sc->has_quotaofflock = true;
+	mutex_lock(&sc->mp->m_quotainfo->qi_quotaofflock);
 	if (!xfs_this_quota_on(sc->mp, dqtype))
 		return -ENOENT;
+	error = xfs_scrub_setup_fs(sc, ip);
+	if (error)
+		return error;
+	sc->ip = xfs_quota_inode(sc->mp, dqtype);
+	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+	sc->ilock_flags = XFS_ILOCK_EXCL;
 	return 0;
 }
 
@@ -202,7 +214,6 @@ xfs_scrub_quota(
 	struct xfs_bmbt_irec		irec = { 0 };
 	struct xfs_scrub_quota_info	sqi;
 	struct xfs_mount		*mp = sc->mp;
-	struct xfs_inode		*ip;
 	struct xfs_quotainfo		*qi = mp->m_quotainfo;
 	xfs_fileoff_t			max_dqid_off;
 	xfs_fileoff_t			off = 0;
@@ -210,25 +221,12 @@ xfs_scrub_quota(
 	int				nimaps;
 	int				error = 0;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
-		return -ENOENT;
-
-	mutex_lock(&qi->qi_quotaofflock);
 	dqtype = xfs_scrub_quota_to_dqtype(sc);
-	if (!xfs_this_quota_on(sc->mp, dqtype)) {
-		error = -ENOENT;
-		goto out_unlock_quota;
-	}
-
-	/* Attach to the quota inode and set sc->ip so that reporting works. */
-	ip = xfs_quota_inode(sc->mp, dqtype);
-	sc->ip = ip;
 
 	/* Look for problem extents. */
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (ip->i_d.di_flags & XFS_DIFLAG_REALTIME) {
+	if (sc->ip->i_d.di_flags & XFS_DIFLAG_REALTIME) {
 		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
-		goto out_unlock_inode;
+		goto out;
 	}
 	max_dqid_off = ((xfs_dqid_t)-1) / qi->qi_dqperchunk;
 	while (1) {
@@ -237,11 +235,11 @@ xfs_scrub_quota(
 
 		off = irec.br_startoff + irec.br_blockcount;
 		nimaps = 1;
-		error = xfs_bmapi_read(ip, off, -1, &irec, &nimaps,
+		error = xfs_bmapi_read(sc->ip, off, -1, &irec, &nimaps,
 				XFS_BMAPI_ENTIRE);
 		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, off,
 				&error))
-			goto out_unlock_inode;
+			goto out;
 		if (!nimaps)
 			break;
 		if (irec.br_startblock == HOLESTARTBLOCK)
@@ -267,26 +265,25 @@ xfs_scrub_quota(
 		    irec.br_startoff + irec.br_blockcount > max_dqid_off + 1)
 			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
 	}
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
 
-	/* Check all the quota items. */
+	/*
+	 * Check all the quota items.  Now that we've checked the quota inode
+	 * data fork we have to drop ILOCK_EXCL to use the regular dquot
+	 * functions.
+	 */
+	xfs_iunlock(sc->ip, sc->ilock_flags);
+	sc->ilock_flags = 0;
 	sqi.sc = sc;
 	sqi.last_id = 0;
 	error = xfs_qm_dqiterate(mp, dqtype, xfs_scrub_quota_item, &sqi);
+	sc->ilock_flags = XFS_ILOCK_EXCL;
+	xfs_ilock(sc->ip, sc->ilock_flags);
 	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK,
 			sqi.last_id * qi->qi_dqperchunk, &error))
 		goto out;
 
 out:
-	/* We set sc->ip earlier, so make sure we clear it now. */
-	sc->ip = NULL;
-out_unlock_quota:
-	mutex_unlock(&qi->qi_quotaofflock);
 	return error;
-
-out_unlock_inode:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	goto out;
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index d9ecbb6ad4a3..ad6eda4fa123 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -42,6 +42,8 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_quota.h"
+#include "xfs_qm.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -166,6 +168,8 @@ xfs_scrub_teardown(
 			iput(VFS_I(sc->ip));
 		sc->ip = NULL;
 	}
+	if (sc->has_quotaofflock)
+		mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
 	if (sc->buf) {
 		kmem_free(sc->buf);
 		sc->buf = NULL;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 0d92af86f67a..5d797319fc9a 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -73,6 +73,7 @@ struct xfs_scrub_context {
 	void				*buf;
 	uint				ilock_flags;
 	bool				try_harder;
+	bool				has_quotaofflock;
 
 	/* State tracking for single-AG operations. */
 	struct xfs_scrub_ag		sa;

