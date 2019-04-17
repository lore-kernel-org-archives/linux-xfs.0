Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38436 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728514AbfDQBk1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 21:40:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H1ccu8097335
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:25 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2rusnewxmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H1e6xL019487
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2rwe7a41g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:24 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3H1eMBI022234
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:23 GMT
Subject: [PATCH 3/3] xfs: add online scrub/repair for superblock counters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 16 Apr 2019 18:40:21 -0700
Message-ID: <155546522160.176278.12189319767486072198.stgit@magnolia>
In-Reply-To: <155546519998.176278.8300210828717055034.stgit@magnolia>
References: <155546519998.176278.8300210828717055034.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach online scrub and repair how to check and reset the superblock
inode and block counters.  The AG rebuilding functions will need these
to adjust the counts if they need to change as a part of recovering from
corruption.  We must use the repair freeze mechanism to prevent any
other changes while we do this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile           |    1 
 fs/xfs/libxfs/xfs_fs.h    |    3 -
 fs/xfs/scrub/common.h     |    1 
 fs/xfs/scrub/fscounters.c |  229 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/health.c     |    1 
 fs/xfs/scrub/scrub.c      |    6 +
 fs/xfs/scrub/scrub.h      |    7 +
 fs/xfs/scrub/trace.h      |   48 +++++++++
 8 files changed, 294 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/fscounters.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index b20964e26a22..1dfc6df2e2bd 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -143,6 +143,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   common.o \
 				   dabtree.o \
 				   dir.o \
+				   fscounters.o \
 				   health.o \
 				   ialloc.o \
 				   inode.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 43a53b03247b..e7382c780ed7 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -578,9 +578,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_UQUOTA	21	/* user quotas */
 #define XFS_SCRUB_TYPE_GQUOTA	22	/* group quotas */
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
+#define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	24
+#define XFS_SCRUB_TYPE_NR	25
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 2288f45a5606..7de945eace00 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -105,6 +105,7 @@ xchk_setup_quota(struct xfs_scrub *sc, struct xfs_inode *ip)
 	return -ENOENT;
 }
 #endif
+int xchk_setup_fscounters(struct xfs_scrub *sc, struct xfs_inode *ip);
 
 void xchk_ag_free(struct xfs_scrub *sc, struct xchk_ag *sa);
 int xchk_ag_init(struct xfs_scrub *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
new file mode 100644
index 000000000000..c809213d8cfe
--- /dev/null
+++ b/fs/xfs/scrub/fscounters.c
@@ -0,0 +1,229 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_rmap.h"
+#include "xfs_error.h"
+#include "xfs_errortag.h"
+#include "xfs_icache.h"
+#include "xfs_health.h"
+#include "xfs_bmap.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+
+/*
+ * FS Summary Counters
+ * ===================
+ *
+ * The basics of filesystem summary counter checking are that we iterate the
+ * AGs counting the number of free blocks, free space btree blocks, per-AG
+ * reservations, inodes, delayed allocation reservations, and free inodes.
+ * Then we compare what we computed against the in-core counters.
+ *
+ * However, the reality is that summary counters are a tricky beast to check.
+ * While we /could/ freeze the filesystem and scramble around the AGs counting
+ * the free blocks, in practice we prefer not do that for a scan because
+ * freezing is costly.  To get around this, we added a per-cpu counter of the
+ * delalloc reservations so that we can rotor around the AGs relatively
+ * quickly, and we allow the counts to be slightly off because we're not
+ * taking any locks while we do this.
+ */
+
+int
+xchk_setup_fscounters(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip)
+{
+	sc->buf = kmem_zalloc(sizeof(struct xchk_fscounters), KM_SLEEP);
+	if (!sc->buf)
+		return -ENOMEM;
+
+	/*
+	 * Pause background reclaim while we're scrubbing to reduce the
+	 * likelihood of background perturbations to the counters throwing
+	 * off our calculations.
+	 */
+	xchk_disable_reclaim(sc);
+
+	return xchk_trans_alloc(sc, 0);
+}
+
+/*
+ * Calculate what the global in-core counters ought to be from the AG header
+ * contents.  Callers can compare this to the actual in-core counters to
+ * calculate by how much both in-core and on-disk counters need to be
+ * adjusted.
+ */
+STATIC int
+xchk_fscounters_calc(
+	struct xfs_scrub	*sc,
+	struct xchk_fscounters	*fsc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_buf		*agi_bp;
+	struct xfs_buf		*agf_bp;
+	struct xfs_agi		*agi;
+	struct xfs_agf		*agf;
+	struct xfs_perag	*pag;
+	uint64_t		delayed;
+	xfs_agnumber_t		agno;
+	int			error;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		/* Lock both AG headers. */
+		error = xfs_ialloc_read_agi(mp, sc->tp, agno, &agi_bp);
+		if (error)
+			return error;
+		error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &agf_bp);
+		if (error)
+			return error;
+		if (!agf_bp)
+			return -ENOMEM;
+
+		/* Count all the inodes */
+		agi = XFS_BUF_TO_AGI(agi_bp);
+		fsc->icount += be32_to_cpu(agi->agi_count);
+		fsc->ifree += be32_to_cpu(agi->agi_freecount);
+
+		/* Add up the free/freelist/bnobt/cntbt blocks */
+		agf = XFS_BUF_TO_AGF(agf_bp);
+		fsc->fdblocks += be32_to_cpu(agf->agf_freeblks);
+		fsc->fdblocks += be32_to_cpu(agf->agf_flcount);
+		fsc->fdblocks += be32_to_cpu(agf->agf_btreeblks);
+
+		/*
+		 * Per-AG reservations are taken out of the incore counters,
+		 * so they must be left out of the free blocks computation.
+		 */
+		pag = xfs_perag_get(mp, agno);
+		fsc->fdblocks -= pag->pag_meta_resv.ar_reserved;
+		fsc->fdblocks -= pag->pag_rmapbt_resv.ar_orig_reserved;
+		xfs_perag_put(pag);
+
+		xfs_trans_brelse(sc->tp, agf_bp);
+		xfs_trans_brelse(sc->tp, agi_bp);
+	}
+
+	/*
+	 * The global incore space reservation is taken from the incore
+	 * counters, so leave that out of the computation.
+	 */
+	fsc->fdblocks -= mp->m_resblks_avail;
+
+	/*
+	 * Delayed allocation reservations are taken out of the incore counters
+	 * but not recorded on disk, so leave them and their indlen blocks out
+	 * of the computation.
+	 */
+	delayed = percpu_counter_sum(&mp->m_delalloc_blks);
+	fsc->fdblocks -= delayed;
+
+	trace_xchk_fscounters_calc(mp, fsc->icount, fsc->ifree, fsc->fdblocks,
+			delayed);
+
+	/* Bail out if the values we compute are totally nonsense. */
+	if (!xfs_verify_icount(mp, fsc->icount) ||
+	    fsc->fdblocks > mp->m_sb.sb_dblocks ||
+	    fsc->ifree > fsc->icount)
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
+/*
+ * Is the @counter within an acceptable range of @expected?
+ *
+ * Currently that means 1/16th (6%) or @nr_range of the @expected value.
+ */
+static inline bool
+xchk_fscounter_within_range(
+	struct xfs_scrub	*sc,
+	struct percpu_counter	*counter,
+	uint64_t		expected,
+	uint64_t		nr_range)
+{
+	int64_t			value = percpu_counter_sum(counter);
+	uint64_t		range;
+
+	range = max_t(uint64_t, expected >> 4, nr_range);
+	if (value < 0)
+		return false;
+	if (range < expected && value < expected - range)
+		return false;
+	if ((int64_t)(expected + range) >= 0 && value > expected + range)
+		return false;
+	return true;
+}
+
+/* Check the superblock counters. */
+int
+xchk_fscounters(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xchk_fscounters	*fsc = sc->buf;
+	int64_t			icount, ifree, fdblocks;
+	int			error;
+
+	icount = percpu_counter_sum(&sc->mp->m_icount);
+	ifree = percpu_counter_sum(&sc->mp->m_ifree);
+	fdblocks = percpu_counter_sum(&sc->mp->m_fdblocks);
+
+	if (icount < 0 || ifree < 0 || fdblocks < 0)
+		xchk_block_set_corrupt(sc, mp->m_sb_bp);
+
+	/* See if icount is obviously wrong. */
+	if (!xfs_verify_icount(mp, icount))
+		xchk_block_set_corrupt(sc, mp->m_sb_bp);
+
+	/* See if fdblocks / ifree are obviously wrong. */
+	if (fdblocks > mp->m_sb.sb_dblocks)
+		xchk_block_set_corrupt(sc, mp->m_sb_bp);
+	if (ifree > icount)
+		xchk_block_set_corrupt(sc, mp->m_sb_bp);
+
+	/* If we already know it's bad, we can skip the AG iteration. */
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return 0;
+
+	/* Counters seem ok, but let's count them. */
+	error = xchk_fscounters_calc(sc, fsc);
+	if (!xchk_process_error(sc, 0, XFS_SB_BLOCK(sc->mp), &error))
+		return error;
+
+	/*
+	 * Compare the in-core counters with whatever we counted.  We'll
+	 * consider the inode counts ok if they're within 1024 inodes, and the
+	 * free block counts if they're within 1/64th of the filesystem size.
+	 */
+	if (!xchk_fscounter_within_range(sc, &mp->m_icount, fsc->icount, 1024))
+		xchk_block_set_corrupt(sc, mp->m_sb_bp);
+
+	if (!xchk_fscounter_within_range(sc, &mp->m_ifree, fsc->ifree, 1024))
+		xchk_block_set_corrupt(sc, mp->m_sb_bp);
+
+	if (!xchk_fscounter_within_range(sc, &mp->m_fdblocks, fsc->fdblocks,
+			mp->m_sb.sb_dblocks >> 6))
+		xchk_block_set_corrupt(sc, mp->m_sb_bp);
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 16b536aa125e..23cf8e2f25db 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -109,6 +109,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_UQUOTA]		= { XHG_FS,  XFS_SICK_FS_UQUOTA },
 	[XFS_SCRUB_TYPE_GQUOTA]		= { XHG_FS,  XFS_SICK_FS_GQUOTA },
 	[XFS_SCRUB_TYPE_PQUOTA]		= { XHG_FS,  XFS_SICK_FS_PQUOTA },
+	[XFS_SCRUB_TYPE_FSCOUNTERS]	= { XHG_FS,  XFS_SICK_FS_COUNTERS },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 421c22a0bf39..4d5d00d35ef7 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -352,6 +352,12 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.scrub	= xchk_quota,
 		.repair	= xrep_notsupported,
 	},
+	[XFS_SCRUB_TYPE_FSCOUNTERS] = {	/* fs summary counters */
+		.type	= ST_FS,
+		.setup	= xchk_setup_fscounters,
+		.scrub	= xchk_fscounters,
+		.repair	= xrep_notsupported,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 1f6de7bbb9f5..caa90ea5a22e 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -127,6 +127,7 @@ xchk_quota(struct xfs_scrub *sc)
 	return -ENOENT;
 }
 #endif
+int xchk_fscounters(struct xfs_scrub *sc);
 
 /* cross-referencing helpers */
 void xchk_xref_is_used_space(struct xfs_scrub *sc, xfs_agblock_t agbno,
@@ -152,4 +153,10 @@ void xchk_xref_is_used_rt_space(struct xfs_scrub *sc, xfs_rtblock_t rtbno,
 # define xchk_xref_is_used_rt_space(sc, rtbno, len) do { } while (0)
 #endif
 
+struct xchk_fscounters {
+	uint64_t		icount;
+	uint64_t		ifree;
+	uint64_t		fdblocks;
+};
+
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 3c83e8b3b39c..7120aee4a506 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -50,6 +50,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTSUM);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_UQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_GQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -75,7 +76,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
 	{ XFS_SCRUB_TYPE_RTSUM,		"rtsummary" }, \
 	{ XFS_SCRUB_TYPE_UQUOTA,	"usrquota" }, \
 	{ XFS_SCRUB_TYPE_GQUOTA,	"grpquota" }, \
-	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }
+	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }, \
+	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }
 
 DECLARE_EVENT_CLASS(xchk_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
@@ -590,6 +592,50 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
 		  __entry->cluster_ino)
 )
 
+TRACE_EVENT(xchk_fscounters_calc,
+	TP_PROTO(struct xfs_mount *mp, uint64_t icount, uint64_t ifree,
+		 uint64_t fdblocks, uint64_t delalloc),
+	TP_ARGS(mp, icount, ifree, fdblocks, delalloc),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int64_t, icount_sb)
+		__field(int64_t, icount_percpu)
+		__field(uint64_t, icount_calculated)
+		__field(int64_t, ifree_sb)
+		__field(int64_t, ifree_percpu)
+		__field(uint64_t, ifree_calculated)
+		__field(int64_t, fdblocks_sb)
+		__field(int64_t, fdblocks_percpu)
+		__field(uint64_t, fdblocks_calculated)
+		__field(uint64_t, delalloc)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->icount_sb = mp->m_sb.sb_icount;
+		__entry->icount_percpu = percpu_counter_sum(&mp->m_icount);
+		__entry->icount_calculated = icount;
+		__entry->ifree_sb = mp->m_sb.sb_ifree;
+		__entry->ifree_percpu = percpu_counter_sum(&mp->m_ifree);
+		__entry->ifree_calculated = ifree;
+		__entry->fdblocks_sb = mp->m_sb.sb_fdblocks;
+		__entry->fdblocks_percpu = percpu_counter_sum(&mp->m_fdblocks);
+		__entry->fdblocks_calculated = fdblocks;
+		__entry->delalloc = delalloc;
+	),
+	TP_printk("dev %d:%d icount %lld:%lld:%llu ifree %lld:%lld:%llu fdblocks %lld:%lld:%llu delalloc %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->icount_sb,
+		  __entry->icount_percpu,
+		  __entry->icount_calculated,
+		  __entry->ifree_sb,
+		  __entry->ifree_percpu,
+		  __entry->ifree_calculated,
+		  __entry->fdblocks_sb,
+		  __entry->fdblocks_percpu,
+		  __entry->fdblocks_calculated,
+		  __entry->delalloc)
+)
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 
