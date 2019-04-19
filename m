Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53148 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfDSAXn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Apr 2019 20:23:43 -0400
Subject: [PATCH 5/5] xfs: add online scrub for superblock counters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 18 Apr 2019 17:21:29 -0700
Message-ID: <155563328923.112668.18007995408695103782.stgit@magnolia>
In-Reply-To: <155563325882.112668.3605935077532891922.stgit@magnolia>
References: <155563325882.112668.3605935077532891922.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach online scrub how to check the filesystem summary counters.  We use
the incore delalloc block counter along with the incore AG headers to
compute expected values for fdblocks, icount, and ifree, and then check
that the percpu counter is within a certain threshold of the expected
value.  This is done to avoid having to freeze or otherwise lock the
filesystem, which means that we're only checking that the counters are
fairly close, not that they're exactly correct.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile           |    1 
 fs/xfs/libxfs/xfs_fs.h    |    3 
 fs/xfs/libxfs/xfs_types.c |    2 
 fs/xfs/libxfs/xfs_types.h |    2 
 fs/xfs/scrub/common.c     |    9 +
 fs/xfs/scrub/common.h     |    2 
 fs/xfs/scrub/fscounters.c |  348 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/health.c     |    1 
 fs/xfs/scrub/scrub.c      |    6 +
 fs/xfs/scrub/scrub.h      |    7 +
 fs/xfs/scrub/trace.h      |   66 ++++++++-
 11 files changed, 444 insertions(+), 3 deletions(-)
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
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index de310712dd6d..d51acc95bc00 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -185,7 +185,7 @@ xfs_verify_rtbno(
 }
 
 /* Calculate the range of valid icount values. */
-static void
+void
 xfs_icount_range(
 	struct xfs_mount	*mp,
 	unsigned long long	*min,
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index c5a25403b4db..802b34cd10fe 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -191,5 +191,7 @@ bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
 bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
 bool xfs_verify_dablk(struct xfs_mount *mp, xfs_fileoff_t off);
+void xfs_icount_range(struct xfs_mount *mp, unsigned long long *min,
+		unsigned long long *max);
 
 #endif	/* __XFS_TYPES_H__ */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 7d7e91a7bb86..973aa59975e3 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -209,6 +209,15 @@ xchk_ino_set_preen(
 	trace_xchk_ino_preen(sc, ino, __return_address);
 }
 
+/* Record something being wrong with the filesystem primary superblock. */
+void
+xchk_set_corrupt(
+	struct xfs_scrub	*sc)
+{
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	trace_xchk_fs_error(sc, 0, __return_address);
+}
+
 /* Record a corrupt block. */
 void
 xchk_block_set_corrupt(
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 84900bfad852..003a772cd26c 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -39,6 +39,7 @@ void xchk_block_set_preen(struct xfs_scrub *sc,
 		struct xfs_buf *bp);
 void xchk_ino_set_preen(struct xfs_scrub *sc, xfs_ino_t ino);
 
+void xchk_set_corrupt(struct xfs_scrub *sc);
 void xchk_block_set_corrupt(struct xfs_scrub *sc,
 		struct xfs_buf *bp);
 void xchk_ino_set_corrupt(struct xfs_scrub *sc, xfs_ino_t ino);
@@ -105,6 +106,7 @@ xchk_setup_quota(struct xfs_scrub *sc, struct xfs_inode *ip)
 	return -ENOENT;
 }
 #endif
+int xchk_setup_fscounters(struct xfs_scrub *sc, struct xfs_inode *ip);
 
 void xchk_ag_free(struct xfs_scrub *sc, struct xchk_ag *sa);
 int xchk_ag_init(struct xfs_scrub *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
new file mode 100644
index 000000000000..c48a8c1ae978
--- /dev/null
+++ b/fs/xfs/scrub/fscounters.c
@@ -0,0 +1,348 @@
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
+ *
+ * So the first thing we do is warm up the buffer cache in the setup routine
+ * by walking all the AGs to make sure the incore per-AG structure has been
+ * initialized.  The expected value calculation then iterates the incore per-AG
+ * structures as quickly as it can.  We snapshot the percpu counters before and
+ * after this operation and use the difference in counter values to guess at
+ * our tolerance for mismatch between expected and actual counter values.
+ */
+
+/*
+ * Since the expected value computation is lockless but only browses incore
+ * values, the percpu counters should be fairly close to each other.  However,
+ * we'll allow ourselves to be off by at least this (arbitrary) amount.
+ */
+#define XCHK_FSC_MIN_VARIANCE	(512)
+
+/*
+ * Make sure the per-AG structure has been initialized from the on-disk header
+ * contents and that the incore counters match the ondisk counters.  Do this
+ * from the setup function so that the inner summation loop runs as quickly
+ * as possible.
+ */
+STATIC int
+xchk_fsc_warmup(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_buf		*agi_bp = NULL;
+	struct xfs_buf		*agf_bp = NULL;
+	struct xfs_agi		*agi;
+	struct xfs_agf		*agf;
+	struct xfs_perag	*pag = NULL;
+	xfs_agnumber_t		agno;
+	int			error = 0;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		/* Lock both AG headers. */
+		error = xfs_ialloc_read_agi(mp, sc->tp, agno, &agi_bp);
+		if (error)
+			break;
+		error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &agf_bp);
+		if (error)
+			break;
+		error = -ENOMEM;
+		if (!agf_bp)
+			break;
+
+		pag = xfs_perag_get(mp, agno);
+
+		/*
+		 * These are supposed to be initialized by the header read
+		 * function.
+		 */
+		error = -EFSCORRUPTED;
+		if (!pag->pagi_init || !pag->pagf_init)
+			break;
+
+		/* Spot-check the incore counters against the ondisk headers */
+		agi = XFS_BUF_TO_AGI(agi_bp);
+		agf = XFS_BUF_TO_AGF(agf_bp);
+		if (pag->pagi_count != be32_to_cpu(agi->agi_count))
+			break;
+		if (pag->pagi_freecount != be32_to_cpu(agi->agi_freecount))
+			break;
+		if (pag->pagf_freeblks != be32_to_cpu(agf->agf_freeblks))
+			break;
+		if (pag->pagf_flcount != be32_to_cpu(agf->agf_flcount))
+			break;
+		if (pag->pagf_btreeblks != be32_to_cpu(agf->agf_btreeblks))
+			break;
+
+		xfs_perag_put(pag);
+		pag = NULL;
+		xfs_buf_relse(agf_bp);
+		agf_bp = NULL;
+		xfs_buf_relse(agi_bp);
+		agi_bp = NULL;
+		error = 0;
+	}
+
+	if (pag)
+		xfs_perag_put(pag);
+	if (agf_bp)
+		xfs_buf_relse(agf_bp);
+	if (agi_bp)
+		xfs_buf_relse(agi_bp);
+	return error;
+}
+
+int
+xchk_setup_fscounters(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip)
+{
+	int			error;
+
+	sc->buf = kmem_zalloc(sizeof(struct xchk_fscounters), KM_SLEEP);
+	if (!sc->buf)
+		return -ENOMEM;
+
+	/* We must get the incore counters set up before we can proceed. */
+	error = xchk_fsc_warmup(sc);
+	if (error)
+		return error;
+
+	/*
+	 * Pause background reclaim while we're scrubbing to reduce the
+	 * likelihood of background perturbations to the counters throwing
+	 * off our calculations.
+	 */
+	xchk_stop_reaping(sc);
+
+	return xchk_trans_alloc(sc, 0);
+}
+
+/*
+ * Calculate what the global in-core counters ought to be from the incore
+ * per-AG structure.  Callers can compare this to the actual in-core counters
+ * to estimate by how much both in-core and on-disk counters need to be
+ * adjusted.
+ */
+STATIC int
+xchk_fsc_calc(
+	struct xfs_scrub	*sc,
+	struct xchk_fscounters	*fsc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_perag	*pag;
+	unsigned long long	min_icount, max_icount;
+	uint64_t		delayed;
+	xfs_agnumber_t		agno;
+	int			tries = 8;
+
+retry:
+	fsc->icount = 0;
+	fsc->ifree = 0;
+	fsc->fdblocks = 0;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		pag = xfs_perag_get(mp, agno);
+
+		/* This somehow got unset since the warmup? */
+		if (!pag->pagi_init || !pag->pagf_init) {
+			xfs_perag_put(pag);
+			return -EFSCORRUPTED;
+		}
+
+		/* Count all the inodes */
+		fsc->icount += pag->pagi_count;
+		fsc->ifree += pag->pagi_freecount;
+
+		/* Add up the free/freelist/bnobt/cntbt blocks */
+		fsc->fdblocks += pag->pagf_freeblks;
+		fsc->fdblocks += pag->pagf_flcount;
+		fsc->fdblocks += pag->pagf_btreeblks;
+
+		/*
+		 * Per-AG reservations are taken out of the incore counters,
+		 * so they must be left out of the free blocks computation.
+		 */
+		fsc->fdblocks -= pag->pag_meta_resv.ar_reserved;
+		fsc->fdblocks -= pag->pag_rmapbt_resv.ar_orig_reserved;
+
+		xfs_perag_put(pag);
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
+	xfs_icount_range(mp, &min_icount, &max_icount);
+
+	/* Bail out if the values we compute are totally nonsense. */
+	if (!xfs_verify_icount(mp, fsc->icount) ||
+	    fsc->fdblocks > mp->m_sb.sb_dblocks ||
+	    fsc->ifree > max_icount)
+		return -EFSCORRUPTED;
+
+	/*
+	 * If ifree > icount then we probably had some perturbation in the
+	 * counters while we were calculating things.  We'll try a few times
+	 * to maintain ifree <= icount before giving up.
+	 */
+	if (fsc->ifree > fsc->icount) {
+		if (tries--)
+			goto retry;
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+/*
+ * Is the @counter reasonably close to the @expected value?
+ *
+ * We neither locked nor froze anything in the filesystem while calculating
+ * @expected, which means that the counter could have changed.  We know the
+ * @old_value of the counter, which means that we also know how much the counter
+ * changed while calculating the expected value, and we'll take that as a rough
+ * guess at how accurate we have to be.  The expected value calculation runs in
+ * memory and never does any IO, so the window ought to be pretty small.
+ *
+ * First, ensure that @counter must never be negative.
+ *
+ * Next, compute the variance from the expected value that we'll accept.
+ * For now we'll use twice the change in the counter from start to finish
+ * or the minimum variance, whichever is larger.
+ */
+static inline bool
+xchk_fsc_within_range(
+	struct xfs_scrub	*sc,
+	const int64_t		old_value,
+	struct percpu_counter	*counter,
+	uint64_t		expected)
+{
+	int64_t			curr_value = percpu_counter_sum(counter);
+	int64_t			range;
+
+	range = abs(2 * (curr_value - old_value));
+	if (range < XCHK_FSC_MIN_VARIANCE)
+		range = XCHK_FSC_MIN_VARIANCE;
+
+	trace_xchk_fscounters_within_range(sc->mp, expected, curr_value,
+			old_value, range);
+
+	if (curr_value < 0)
+		return false;
+	if (curr_value == expected)
+		return true;
+	if (range < expected && curr_value < expected - range)
+		return false;
+	if ((int64_t)(expected + range) >= 0 && curr_value > expected + range)
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
+	/* Snapshot the percpu counters. */
+	icount = percpu_counter_sum(&mp->m_icount);
+	ifree = percpu_counter_sum(&mp->m_ifree);
+	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+
+	/* No negative values, please! */
+	if (icount < 0 || ifree < 0 || fdblocks < 0)
+		xchk_set_corrupt(sc);
+
+	/* See if icount is obviously wrong. */
+	if (!xfs_verify_icount(mp, icount))
+		xchk_set_corrupt(sc);
+
+	/* See if fdblocks is obviously wrong. */
+	if (fdblocks > mp->m_sb.sb_dblocks)
+		xchk_set_corrupt(sc);
+
+	/*
+	 * If ifree exceeds icount by more than the minimum variance then
+	 * something's probably wrong with the counters.
+	 */
+	if (ifree > icount && ifree - icount > XCHK_FSC_MIN_VARIANCE)
+		xchk_set_corrupt(sc);
+
+	/* Walk the incore AG headers to calculate the expected counters. */
+	error = xchk_fsc_calc(sc, fsc);
+	if (!xchk_process_error(sc, 0, XFS_SB_BLOCK(mp), &error))
+		return error;
+
+	/* Compare the in-core counters with whatever we counted. */
+	if (!xchk_fsc_within_range(sc, icount, &mp->m_icount, fsc->icount))
+		xchk_set_corrupt(sc);
+
+	if (!xchk_fsc_within_range(sc, ifree, &mp->m_ifree, fsc->ifree))
+		xchk_set_corrupt(sc);
+
+	if (!xchk_fsc_within_range(sc, fdblocks, &mp->m_fdblocks,
+				fsc->fdblocks))
+		xchk_set_corrupt(sc);
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
index ce13c1c366db..f630389ee176 100644
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
index 01986ed364db..aa3d395d5287 100644
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
index 3c83e8b3b39c..7763d7043915 100644
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
@@ -223,6 +225,7 @@ DEFINE_EVENT(xchk_block_error_class, name, \
 		 void *ret_ip), \
 	TP_ARGS(sc, daddr, ret_ip))
 
+DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_fs_error);
 DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_block_error);
 DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_block_preen);
 
@@ -590,6 +593,67 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
 		  __entry->cluster_ino)
 )
 
+TRACE_EVENT(xchk_fscounters_calc,
+	TP_PROTO(struct xfs_mount *mp, uint64_t icount, uint64_t ifree,
+		 uint64_t fdblocks, uint64_t delalloc),
+	TP_ARGS(mp, icount, ifree, fdblocks, delalloc),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int64_t, icount_sb)
+		__field(uint64_t, icount_calculated)
+		__field(int64_t, ifree_sb)
+		__field(uint64_t, ifree_calculated)
+		__field(int64_t, fdblocks_sb)
+		__field(uint64_t, fdblocks_calculated)
+		__field(uint64_t, delalloc)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->icount_sb = mp->m_sb.sb_icount;
+		__entry->icount_calculated = icount;
+		__entry->ifree_sb = mp->m_sb.sb_ifree;
+		__entry->ifree_calculated = ifree;
+		__entry->fdblocks_sb = mp->m_sb.sb_fdblocks;
+		__entry->fdblocks_calculated = fdblocks;
+		__entry->delalloc = delalloc;
+	),
+	TP_printk("dev %d:%d icount %lld:%llu ifree %lld::%llu fdblocks %lld::%llu delalloc %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->icount_sb,
+		  __entry->icount_calculated,
+		  __entry->ifree_sb,
+		  __entry->ifree_calculated,
+		  __entry->fdblocks_sb,
+		  __entry->fdblocks_calculated,
+		  __entry->delalloc)
+)
+
+TRACE_EVENT(xchk_fscounters_within_range,
+	TP_PROTO(struct xfs_mount *mp, uint64_t expected, int64_t curr_value,
+		 int64_t old_value, int64_t range),
+	TP_ARGS(mp, expected, curr_value, old_value, range),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(uint64_t, expected)
+		__field(int64_t, curr_value)
+		__field(int64_t, old_value)
+		__field(int64_t, range)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->expected = expected;
+		__entry->curr_value = curr_value;
+		__entry->old_value = old_value;
+		__entry->range = range;
+	),
+	TP_printk("dev %d:%d expected %llu curr_value %lld old_value %lld range %lld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->expected,
+		  __entry->curr_value,
+		  __entry->old_value,
+		  __entry->range)
+)
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 
