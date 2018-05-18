Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36142 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751844AbeERD42 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 23:56:28 -0400
Date: Thu, 17 May 2018 20:56:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 06/22] xfs: add a repair helper to reset superblock
 counters
Message-ID: <20180518035623.GD23858@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642365674.1556.6776151224606075985.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152642365674.1556.6776151224606075985.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a helper function to reset the superblock inode and block counters.
The AG rebuilding functions will need these to adjust the counts if they
need to change as a part of recovering from corruption.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
v2: improve documentation
---
 fs/xfs/scrub/repair.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |    7 ++++
 fs/xfs/scrub/scrub.c  |    2 +
 fs/xfs/scrub/scrub.h  |    1 +
 4 files changed, 99 insertions(+)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 877488ce4bc8..4b95a15c0bd0 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1026,3 +1026,92 @@ xfs_repair_find_ag_btree_roots(
 
 	return error;
 }
+
+/*
+ * Reset the superblock counters.
+ *
+ * If a repair function changes the inode or free block counters, it must set
+ * reset_counters to push this function to reset the global counters.  Repair
+ * functions are responsible for resetting all other in-core state.  This
+ * function runs outside of transaction context after the repair context has
+ * been torn down, so if there's further filesystem corruption we'll error out
+ * to userspace and give userspace a chance to call back to fix the further
+ * errors.
+ */
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
index c922ef06b894..cc590312550a 100644
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
index c5999c28c20c..bf5e8dd66133 100644
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
index 636424d5e2ee..52b2be2df143 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -78,6 +78,7 @@ struct xfs_scrub_context {
 	uint				ilock_flags;
 	bool				try_harder;
 	bool				has_quotaofflock;
+	bool				reset_counters;
 
 	/* State tracking for single-AG operations. */
 	struct xfs_scrub_ag		sa;
