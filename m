Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58430 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbeDRCmn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:42:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2ghKa011020
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:43 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2hdrxnrjuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:42 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2gg8O014825
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:42 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2ggYc026312
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:42 GMT
Subject: [PATCH 08/24] xfs: add a repair helper to reset superblock counters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:42:41 -0700
Message-ID: <152401936109.12079.2961661985307446731.stgit@magnolia>
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

Add a helper function to reset the superblock inode and block counters.
The AG rebuilding functions will need these to adjust the counts if they
need to change as a part of recovering from corruption.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |   79 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |    7 ++++
 fs/xfs/scrub/scrub.c  |    2 +
 fs/xfs/scrub/scrub.h  |    1 +
 4 files changed, 89 insertions(+)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 1004410..1779590 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -939,3 +939,82 @@ xfs_repair_find_ag_btree_roots(
 
 	return error;
 }
+
+/* Reset the superblock counters from the AGF/AGI. */
+int
+xfs_repair_reset_counters(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*agi_bp;
+	struct xfs_buf		*agf_bp;
+	struct xfs_agi		*agi;
+	struct xfs_agf		*agf;
+	xfs_agnumber_t		agno;
+	xfs_ino_t		icount = 0;
+	xfs_ino_t		ifree = 0;
+	xfs_filblks_t		fdblocks = 0;
+	int64_t			delta_icount;
+	int64_t			delta_ifree;
+	int64_t			delta_fdblocks;
+	int			error;
+
+	trace_xfs_repair_reset_counters(mp);
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		/* Count all the inodes... */
+		error = xfs_ialloc_read_agi(mp, NULL, agno, &agi_bp);
+		if (error)
+			return error;
+		agi = XFS_BUF_TO_AGI(agi_bp);
+		icount += be32_to_cpu(agi->agi_count);
+		ifree += be32_to_cpu(agi->agi_freecount);
+		xfs_buf_relse(agi_bp);
+
+		/* Add up the free/freelist/bnobt/cntbt blocks... */
+		error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agf_bp);
+		if (error)
+			return error;
+		if (!agf_bp)
+			return -ENOMEM;
+		agf = XFS_BUF_TO_AGF(agf_bp);
+		fdblocks += be32_to_cpu(agf->agf_freeblks);
+		fdblocks += be32_to_cpu(agf->agf_flcount);
+		fdblocks += be32_to_cpu(agf->agf_btreeblks);
+		xfs_buf_relse(agf_bp);
+	}
+
+	/*
+	 * Reinitialize the counters.  The on-disk and in-core counters differ
+	 * by the number of inodes/blocks reserved by the admin, the per-AG
+	 * reservation, and any transactions in progress, so we have to
+	 * account for that.  First we take the sb lock and update its
+	 * counters...
+	 */
+	spin_lock(&mp->m_sb_lock);
+	delta_icount = (int64_t)mp->m_sb.sb_icount - icount;
+	delta_ifree = (int64_t)mp->m_sb.sb_ifree - ifree;
+	delta_fdblocks = (int64_t)mp->m_sb.sb_fdblocks - fdblocks;
+	mp->m_sb.sb_icount = icount;
+	mp->m_sb.sb_ifree = ifree;
+	mp->m_sb.sb_fdblocks = fdblocks;
+	spin_unlock(&mp->m_sb_lock);
+
+	/* ...and then update the per-cpu counters. */
+	if (delta_icount) {
+		error = xfs_mod_icount(mp, delta_icount);
+		if (error)
+			return error;
+	}
+	if (delta_ifree) {
+		error = xfs_mod_ifree(mp, delta_ifree);
+		if (error)
+			return error;
+	}
+	if (delta_fdblocks) {
+		error = xfs_mod_fdblocks(mp, delta_fdblocks, false);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 5544177..eea32a2 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -96,6 +96,7 @@ int xfs_repair_find_ag_btree_roots(struct xfs_scrub_context *sc,
 		struct xfs_buf *agf_bp,
 		struct xfs_repair_find_ag_btree *btree_info,
 		struct xfs_buf *agfl_bp);
+int xfs_repair_reset_counters(struct xfs_mount *mp);
 
 /* Metadata repairers */
 
@@ -121,6 +122,12 @@ xfs_repair_calc_ag_resblks(
 	return 0;
 }
 
+static inline int xfs_repair_reset_counters(struct xfs_mount *mp)
+{
+	ASSERT(0);
+	return -EIO;
+}
+
 #define xfs_repair_probe		xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 0bfc4e7d..9cdc3f0 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -200,6 +200,8 @@ xfs_scrub_teardown(
 		kmem_free(sc->buf);
 		sc->buf = NULL;
 	}
+	if (sc->reset_counters && !error)
+		error = xfs_repair_reset_counters(sc->mp);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 2f89a84..1aaea39 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -77,6 +77,7 @@ struct xfs_scrub_context {
 	uint				ilock_flags;
 	bool				try_harder;
 	bool				has_quotaofflock;
+	bool				reset_counters;
 
 	/* State tracking for single-AG operations. */
 	struct xfs_scrub_ag		sa;

