Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD44C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o8HBCMdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E309C433C8;
	Sun, 31 Dec 2023 23:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066470;
	bh=cwzVRdT7sQkb49MkDINdRTKI024a/cs4PHAUeiW9ykY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o8HBCMdo/1ovBCofCz2WJO2Prg4HjcWA++1GeFBB6sh40/gR8Th5hg6aF5Q0NQyfX
	 1j8DNDskRRPvdhYcr0yQ74iKm5AcV+ynWMZOrGBod6n4E5uMvkhNuVcLFXKxiQPrTi
	 +PEkYaaSdpRE76Yw0DRuxvT4oD4cgjwrJIbUmvoiVfkIMWPUCZQSaNGvUfybBde32E
	 Mx3eWVL9MYGdbXHrwomeX8W9SHINTJmD906ChYlYOuqeZJrqDF3Y8qUhxivEiRaIoX
	 QfY51sEHpfpABurgH3PEMBKxi4ytQmikjjVEFQSUk+DNRGhV2TLuHflQbDq7xBcCqq
	 o+FONz9xWgszA==
Date: Sun, 31 Dec 2023 15:47:50 -0800
Subject: [PATCH 01/52] xfs: create incore realtime group structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012180.1811243.7547011198234877187.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create an incore object that will contain information about a realtime
allocation group.  This will eventually enable us to shard the realtime
section in a similar manner to how we shard the data section.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h      |    8 +
 include/xfs_trace.h      |    7 +
 libxfs/Makefile          |    2 
 libxfs/init.c            |   21 ++++
 libxfs/libxfs_api_defs.h |    2 
 libxfs/xfs_format.h      |    8 +
 libxfs/xfs_rtgroup.c     |  249 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtgroup.h     |  132 ++++++++++++++++++++++++
 libxfs/xfs_sb.c          |    5 +
 libxfs/xfs_types.h       |    4 +
 10 files changed, 438 insertions(+)
 create mode 100644 libxfs/xfs_rtgroup.c
 create mode 100644 libxfs/xfs_rtgroup.h


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 8952869d89a..ec0956c539f 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -79,6 +79,7 @@ typedef struct xfs_mount {
 	uint8_t			m_sectbb_log;	/* sectorlog - BBSHIFT */
 	uint8_t			m_agno_log;	/* log #ag's */
 	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
+	int8_t			m_rgblklog;	/* log2 of rt group sz if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -99,9 +100,11 @@ typedef struct xfs_mount {
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
 	struct radix_tree_root	m_perag_tree;
+	struct radix_tree_root	m_rtgroup_tree;
 	uint64_t		m_features;	/* active filesystem features */
 	uint64_t		m_low_space[XFS_LOWSP_MAX];
 	uint64_t		m_rtxblkmask;	/* rt extent block mask */
+	uint64_t		m_rgblkmask;	/* rt group block mask */
 	unsigned long		m_opstate;	/* dynamic state flags */
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	uint			m_qflags;	/* quota status flags */
@@ -138,6 +141,7 @@ typedef struct xfs_mount {
 	 */
 	atomic64_t		m_allocbt_blks;
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
+	spinlock_t		m_rtgroup_lock;	/* lock for m_rtgroup_tree */
 
 } xfs_mount_t;
 
@@ -177,6 +181,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 #define XFS_FEAT_METADIR	(1ULL << 27)	/* metadata directory tree */
+#define XFS_FEAT_RTGROUPS	(1ULL << 28)	/* realtime groups */
 
 #define __XFS_HAS_FEAT(name, NAME) \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
@@ -222,6 +227,7 @@ __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(metadir, METADIR)
+__XFS_HAS_FEAT(rtgroups, RTGROUPS)
 
 /* Kernel mount features that we don't support */
 #define __XFS_UNSUPP_FEAT(name) \
@@ -242,6 +248,7 @@ __XFS_UNSUPP_FEAT(grpid)
 #define XFS_OPSTATE_DEBUGGER		1	/* is this the debugger? */
 #define XFS_OPSTATE_REPORT_CORRUPTION	2	/* report buffer corruption? */
 #define XFS_OPSTATE_PERAG_DATA_LOADED	3	/* per-AG data initialized? */
+#define XFS_OPSTATE_RTGROUP_DATA_LOADED	4	/* rtgroup data initialized? */
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -267,6 +274,7 @@ __XFS_IS_OPSTATE(inode32, INODE32)
 __XFS_IS_OPSTATE(debugger, DEBUGGER)
 __XFS_IS_OPSTATE(reporting_corruption, REPORT_CORRUPTION)
 __XFS_IS_OPSTATE(perag_data_loaded, PERAG_DATA_LOADED)
+__XFS_IS_OPSTATE(rtgroup_data_loaded, RTGROUP_DATA_LOADED)
 
 #define __XFS_UNSUPP_OPSTATE(name) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 2cca9394b70..b3240213364 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -345,6 +345,13 @@
 #define trace_xfs_rmap_map_error(...)		((void) 0)
 #define trace_xfs_rmap_delete_error(...)	((void) 0)
 
+/* set c = c to avoid unused var warnings */
+#define trace_xfs_rtgroup_get(a,b)		((a) = (a))
+#define trace_xfs_rtgroup_hold(a,b)		((a) = (a))
+#define trace_xfs_rtgroup_put(a,b)		((a) = (a))
+#define trace_xfs_rtgroup_grab(a,b)		((a) = (a))
+#define trace_xfs_rtgroup_rele(a,b)		((a) = (a))
+
 #define trace_xfs_swapext_defer(...)		((void) 0)
 #define trace_xfs_swapext_delta_nextents(...)	((void) 0)
 #define trace_xfs_swapext_delta_nextents_step(...)	((void) 0)
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 258ce473200..a37a5263199 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -62,6 +62,7 @@ HFILES = \
 	xfs_rmap.h \
 	xfs_rmap_btree.h \
 	xfs_rtbitmap.h \
+	xfs_rtgroup.h \
 	xfs_sb.h \
 	xfs_shared.h \
 	xfs_swapext.h \
@@ -119,6 +120,7 @@ CFILES = cache.c \
 	xfs_rmap.c \
 	xfs_rmap_btree.c \
 	xfs_rtbitmap.c \
+	xfs_rtgroup.c \
 	xfs_sb.c \
 	xfs_swapext.c \
 	xfs_symlink_remote.c \
diff --git a/libxfs/init.c b/libxfs/init.c
index 67f9e1fe99b..f1ba28a3ca3 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -30,6 +30,7 @@
 #include "xfs_ondisk.h"
 
 #include "libxfs.h"		/* for now */
+#include "xfs_rtgroup.h"
 
 #ifndef HAVE_LIBURCU_ATOMIC64
 pthread_mutex_t	atomic64_lock = PTHREAD_MUTEX_INITIALIZER;
@@ -738,7 +739,9 @@ libxfs_mount(
 {
 	struct xfs_buf		*bp;
 	struct xfs_sb		*sbp;
+	struct xfs_rtgroup	*rtg;
 	xfs_daddr_t		d;
+	xfs_rgnumber_t		rgno;
 	int			error;
 
 	mp->m_features = xfs_sb_version_to_features(sb);
@@ -752,9 +755,11 @@ libxfs_mount(
 	xfs_set_inode32(mp);
 	mp->m_sb = *sb;
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
+	INIT_RADIX_TREE(&mp->m_rtgroup_tree, GFP_KERNEL);
 	sbp = &mp->m_sb;
 	spin_lock_init(&mp->m_sb_lock);
 	spin_lock_init(&mp->m_agirotor_lock);
+	spin_lock_init(&mp->m_rtgroup_lock);
 
 	xfs_sb_mount_common(mp, sb);
 
@@ -884,6 +889,20 @@ libxfs_mount(
 
 	libxfs_mountfs_imeta(mp);
 
+	error = libxfs_initialize_rtgroups(mp, sbp->sb_rgcount);
+	if (error) {
+		fprintf(stderr, _("%s: rtgroup init failed\n"),
+			progname);
+		exit(1);
+	}
+
+	for_each_rtgroup(mp, rgno, rtg) {
+		rtg->rtg_blockcount = xfs_rtgroup_block_count(mp,
+							      rtg->rtg_rgno);
+	}
+
+	xfs_set_rtgroup_data_loaded(mp);
+
 	return mp;
 out_da:
 	xfs_da_unmount(mp);
@@ -1017,6 +1036,8 @@ libxfs_umount(
 	 * Only try to free the per-AG structures if we set them up in the
 	 * first place.
 	 */
+	if (xfs_is_rtgroup_data_loaded(mp))
+		xfs_free_rtgroups(mp);
 	if (xfs_is_perag_data_loaded(mp))
 		libxfs_free_perag(mp);
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 5f2250ac5e2..ce255ec3a87 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -154,6 +154,7 @@
 #define xfs_free_extent			libxfs_free_extent
 #define xfs_free_extent_later		libxfs_free_extent_later
 #define xfs_free_perag			libxfs_free_perag
+#define xfs_free_rtgroups		libxfs_free_rtgroups
 #define xfs_fs_geometry			libxfs_fs_geometry
 #define xfs_get_projid			libxfs_get_projid
 #define xfs_get_initial_prid		libxfs_get_initial_prid
@@ -197,6 +198,7 @@
 
 #define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
+#define xfs_initialize_rtgroups		libxfs_initialize_rtgroups
 #define xfs_init_local_fork		libxfs_init_local_fork
 
 #define xfs_inobt_maxrecs		libxfs_inobt_maxrecs
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 0636ca97622..3bd93c01bf4 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -184,6 +184,14 @@ typedef struct xfs_sb {
 	 */
 	xfs_ino_t	sb_metadirino;
 
+	/*
+	 * Realtime group geometry information.  On disk these fields live in
+	 * the rsumino slot, but we cache them separately in the in-core super
+	 * for easy access.
+	 */
+	xfs_rgblock_t	sb_rgblocks;	/* size of a realtime group */
+	xfs_rgnumber_t	sb_rgcount;	/* number of realtime groups */
+
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
new file mode 100644
index 00000000000..02c0c592c91
--- /dev/null
+++ b/libxfs/xfs_rtgroup.c
@@ -0,0 +1,249 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_rmap.h"
+#include "xfs_ag.h"
+#include "xfs_ag_resv.h"
+#include "xfs_health.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_trace.h"
+#include "xfs_inode.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtbitmap.h"
+
+/*
+ * Passive reference counting access wrappers to the rtgroup structures.  If
+ * the rtgroup structure is to be freed, the freeing code is responsible for
+ * cleaning up objects with passive references before freeing the structure.
+ */
+struct xfs_rtgroup *
+xfs_rtgroup_get(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	struct xfs_rtgroup	*rtg;
+
+	rcu_read_lock();
+	rtg = radix_tree_lookup(&mp->m_rtgroup_tree, rgno);
+	if (rtg) {
+		trace_xfs_rtgroup_get(rtg, _RET_IP_);
+		ASSERT(atomic_read(&rtg->rtg_ref) >= 0);
+		atomic_inc(&rtg->rtg_ref);
+	}
+	rcu_read_unlock();
+	return rtg;
+}
+
+/* Get a passive reference to the given rtgroup. */
+struct xfs_rtgroup *
+xfs_rtgroup_hold(
+	struct xfs_rtgroup	*rtg)
+{
+	ASSERT(atomic_read(&rtg->rtg_ref) > 0 ||
+	       atomic_read(&rtg->rtg_active_ref) > 0);
+
+	trace_xfs_rtgroup_hold(rtg, _RET_IP_);
+	atomic_inc(&rtg->rtg_ref);
+	return rtg;
+}
+
+void
+xfs_rtgroup_put(
+	struct xfs_rtgroup	*rtg)
+{
+	trace_xfs_rtgroup_put(rtg, _RET_IP_);
+	ASSERT(atomic_read(&rtg->rtg_ref) > 0);
+	atomic_dec(&rtg->rtg_ref);
+}
+
+/*
+ * Active references for rtgroup structures. This is for short term access to
+ * the rtgroup structures for walking trees or accessing state. If an rtgroup
+ * is being shrunk or is offline, then this will fail to find that group and
+ * return NULL instead.
+ */
+struct xfs_rtgroup *
+xfs_rtgroup_grab(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_rtgroup	*rtg;
+
+	rcu_read_lock();
+	rtg = radix_tree_lookup(&mp->m_rtgroup_tree, agno);
+	if (rtg) {
+		trace_xfs_rtgroup_grab(rtg, _RET_IP_);
+		if (!atomic_inc_not_zero(&rtg->rtg_active_ref))
+			rtg = NULL;
+	}
+	rcu_read_unlock();
+	return rtg;
+}
+
+void
+xfs_rtgroup_rele(
+	struct xfs_rtgroup	*rtg)
+{
+	trace_xfs_rtgroup_rele(rtg, _RET_IP_);
+	if (atomic_dec_and_test(&rtg->rtg_active_ref))
+		wake_up(&rtg->rtg_active_wq);
+}
+
+int
+xfs_initialize_rtgroups(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgcount)
+{
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		index;
+	xfs_rgnumber_t		first_initialised = NULLRGNUMBER;
+	int			error;
+
+	if (!xfs_has_rtgroups(mp))
+		return 0;
+
+	/*
+	 * Walk the current rtgroup tree so we don't try to initialise rt
+	 * groups that already exist (growfs case). Allocate and insert all the
+	 * rtgroups we don't find ready for initialisation.
+	 */
+	for (index = 0; index < rgcount; index++) {
+		rtg = xfs_rtgroup_get(mp, index);
+		if (rtg) {
+			xfs_rtgroup_put(rtg);
+			continue;
+		}
+
+		rtg = kmem_zalloc(sizeof(struct xfs_rtgroup), KM_MAYFAIL);
+		if (!rtg) {
+			error = -ENOMEM;
+			goto out_unwind_new_rtgs;
+		}
+		rtg->rtg_rgno = index;
+		rtg->rtg_mount = mp;
+
+		error = radix_tree_preload(GFP_NOFS);
+		if (error)
+			goto out_free_rtg;
+
+		spin_lock(&mp->m_rtgroup_lock);
+		if (radix_tree_insert(&mp->m_rtgroup_tree, index, rtg)) {
+			WARN_ON_ONCE(1);
+			spin_unlock(&mp->m_rtgroup_lock);
+			radix_tree_preload_end();
+			error = -EEXIST;
+			goto out_free_rtg;
+		}
+		spin_unlock(&mp->m_rtgroup_lock);
+		radix_tree_preload_end();
+
+#ifdef __KERNEL__
+		/* Place kernel structure only init below this point. */
+		spin_lock_init(&rtg->rtg_state_lock);
+		init_waitqueue_head(&rtg->rtg_active_wq);
+#endif /* __KERNEL__ */
+
+		/* Active ref owned by mount indicates rtgroup is online. */
+		atomic_set(&rtg->rtg_active_ref, 1);
+
+		/* first new rtg is fully initialized */
+		if (first_initialised == NULLRGNUMBER)
+			first_initialised = index;
+	}
+
+	return 0;
+
+out_free_rtg:
+	kmem_free(rtg);
+out_unwind_new_rtgs:
+	/* unwind any prior newly initialized rtgs */
+	for (index = first_initialised; index < rgcount; index++) {
+		rtg = radix_tree_delete(&mp->m_rtgroup_tree, index);
+		if (!rtg)
+			break;
+		kmem_free(rtg);
+	}
+	return error;
+}
+
+STATIC void
+__xfs_free_rtgroups(
+	struct rcu_head		*head)
+{
+	struct xfs_rtgroup	*rtg;
+
+	rtg = container_of(head, struct xfs_rtgroup, rcu_head);
+	kmem_free(rtg);
+}
+
+/*
+ * Free up the rtgroup resources associated with the mount structure.
+ */
+void
+xfs_free_rtgroups(
+	struct xfs_mount	*mp)
+{
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
+
+	if (!xfs_has_rtgroups(mp))
+		return;
+
+	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
+		spin_lock(&mp->m_rtgroup_lock);
+		rtg = radix_tree_delete(&mp->m_rtgroup_tree, rgno);
+		spin_unlock(&mp->m_rtgroup_lock);
+		ASSERT(rtg);
+		XFS_IS_CORRUPT(mp, atomic_read(&rtg->rtg_ref) != 0);
+
+		/* drop the mount's active reference */
+		xfs_rtgroup_rele(rtg);
+		XFS_IS_CORRUPT(mp, atomic_read(&rtg->rtg_active_ref) != 0);
+
+		call_rcu(&rtg->rcu_head, __xfs_free_rtgroups);
+	}
+}
+
+/* Find the size of the rtgroup, in blocks. */
+static xfs_rgblock_t
+__xfs_rtgroup_block_count(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	xfs_rgnumber_t		rgcount,
+	xfs_rfsblock_t		rblocks)
+{
+	ASSERT(rgno < rgcount);
+
+	if (rgno < rgcount - 1)
+		return mp->m_sb.sb_rgblocks;
+	return xfs_rtb_rounddown_rtx(mp,
+			rblocks - (rgno * mp->m_sb.sb_rgblocks));
+}
+
+/* Compute the number of blocks in this realtime group. */
+xfs_rgblock_t
+xfs_rtgroup_block_count(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	return __xfs_rtgroup_block_count(mp, rgno, mp->m_sb.sb_rgcount,
+			mp->m_sb.sb_rblocks);
+}
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
new file mode 100644
index 00000000000..2f0a670217c
--- /dev/null
+++ b/libxfs/xfs_rtgroup.h
@@ -0,0 +1,132 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __LIBXFS_RTGROUP_H
+#define __LIBXFS_RTGROUP_H 1
+
+struct xfs_mount;
+struct xfs_trans;
+
+/*
+ * Realtime group incore structure, similar to the per-AG structure.
+ */
+struct xfs_rtgroup {
+	struct xfs_mount	*rtg_mount;
+	xfs_rgnumber_t		rtg_rgno;
+	atomic_t		rtg_ref;	/* passive reference count */
+	atomic_t		rtg_active_ref;	/* active reference count */
+	wait_queue_head_t	rtg_active_wq;/* woken active_ref falls to zero */
+
+	/* for rcu-safe freeing */
+	struct rcu_head		rcu_head;
+
+	/* Number of blocks in this group */
+	xfs_rgblock_t		rtg_blockcount;
+
+#ifdef __KERNEL__
+	/* -- kernel only structures below this line -- */
+	spinlock_t		rtg_state_lock;
+#endif /* __KERNEL__ */
+};
+
+#ifdef CONFIG_XFS_RT
+/* Passive rtgroup references */
+struct xfs_rtgroup *xfs_rtgroup_get(struct xfs_mount *mp, xfs_rgnumber_t rgno);
+struct xfs_rtgroup *xfs_rtgroup_hold(struct xfs_rtgroup *rtg);
+void xfs_rtgroup_put(struct xfs_rtgroup *rtg);
+
+/* Active rtgroup references */
+struct xfs_rtgroup *xfs_rtgroup_grab(struct xfs_mount *mp, xfs_rgnumber_t rgno);
+void xfs_rtgroup_rele(struct xfs_rtgroup *rtg);
+
+int xfs_initialize_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t rgcount);
+void xfs_free_rtgroups(struct xfs_mount *mp);
+#else
+static inline struct xfs_rtgroup *
+xfs_rtgroup_get(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	return NULL;
+}
+static inline struct xfs_rtgroup *
+xfs_rtgroup_hold(struct xfs_rtgroup *rtg)
+{
+	ASSERT(rtg == NULL);
+	return NULL;
+}
+# define xfs_rtgroup_grab			xfs_rtgroup_get
+# define xfs_rtgroup_put(rtg)			((void)0)
+# define xfs_rtgroup_rele(rtg)			((void)0)
+# define xfs_initialize_rtgroups(mp, rgcount)	(0)
+# define xfs_free_rtgroups(mp)			((void)0)
+#endif /* CONFIG_XFS_RT */
+
+/*
+ * rt group iteration APIs
+ */
+static inline struct xfs_rtgroup *
+xfs_rtgroup_next(
+	struct xfs_rtgroup	*rtg,
+	xfs_rgnumber_t		*rgno,
+	xfs_rgnumber_t		end_rgno)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+
+	*rgno = rtg->rtg_rgno + 1;
+	xfs_rtgroup_rele(rtg);
+	if (*rgno > end_rgno)
+		return NULL;
+	return xfs_rtgroup_grab(mp, *rgno);
+}
+
+#define for_each_rtgroup_range(mp, rgno, end_rgno, rtg) \
+	for ((rtg) = xfs_rtgroup_grab((mp), (rgno)); \
+		(rtg) != NULL; \
+		(rtg) = xfs_rtgroup_next((rtg), &(rgno), (end_rgno)))
+
+#define for_each_rtgroup_from(mp, rgno, rtg) \
+	for_each_rtgroup_range((mp), (rgno), (mp)->m_sb.sb_rgcount - 1, (rtg))
+
+
+#define for_each_rtgroup(mp, rgno, rtg) \
+	(rgno) = 0; \
+	for_each_rtgroup_from((mp), (rgno), (rtg))
+
+static inline bool
+xfs_verify_rgbno(
+	struct xfs_rtgroup	*rtg,
+	xfs_rgblock_t		rgbno)
+{
+	if (rgbno >= rtg->rtg_blockcount)
+		return false;
+	if (rgbno < rtg->rtg_mount->m_sb.sb_rextsize)
+		return false;
+	return true;
+}
+
+static inline bool
+xfs_verify_rgbext(
+	struct xfs_rtgroup	*rtg,
+	xfs_rgblock_t		rgbno,
+	xfs_rgblock_t		len)
+{
+	if (rgbno + len <= rgbno)
+		return false;
+
+	if (!xfs_verify_rgbno(rtg, rgbno))
+		return false;
+
+	return xfs_verify_rgbno(rtg, rgbno + len - 1);
+}
+
+#ifdef CONFIG_XFS_RT
+xfs_rgblock_t xfs_rtgroup_block_count(struct xfs_mount *mp,
+		xfs_rgnumber_t rgno);
+#else
+# define xfs_rtgroup_block_count(mp, rgno)	(0)
+#endif /* CONFIG_XFS_RT */
+
+#endif /* __LIBXFS_RTGROUP_H */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 719da346d36..f3a5af60e2c 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -699,6 +699,9 @@ __xfs_sb_from_disk(
 		to->sb_gquotino = NULLFSINO;
 		to->sb_pquotino = NULLFSINO;
 	}
+
+	to->sb_rgcount = 0;
+	to->sb_rgblocks = 0;
 }
 
 void
@@ -1013,6 +1016,8 @@ xfs_sb_mount_common(
 	mp->m_blockwmask = mp->m_blockwsize - 1;
 	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
 	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
+	mp->m_rgblklog = 0;
+	mp->m_rgblkmask = 0;
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 5556615a2ff..195471c4385 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -9,10 +9,12 @@
 typedef uint32_t	prid_t;		/* project ID */
 
 typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
+typedef uint32_t	xfs_rgblock_t;	/* blockno in realtime group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
 typedef uint32_t	xfs_rtxlen_t;	/* file extent length in rtextents */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
+typedef uint32_t	xfs_rgnumber_t;	/* realtime group number */
 typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
 typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
 typedef int64_t		xfs_fsize_t;	/* bytes in a file */
@@ -54,7 +56,9 @@ typedef void *		xfs_failaddr_t;
 #define	NULLRTEXTNO	((xfs_rtxnum_t)-1)
 
 #define	NULLAGBLOCK	((xfs_agblock_t)-1)
+#define NULLRGBLOCK	((xfs_rgblock_t)-1)
 #define	NULLAGNUMBER	((xfs_agnumber_t)-1)
+#define	NULLRGNUMBER	((xfs_rgnumber_t)-1)
 
 #define NULLCOMMITLSN	((xfs_lsn_t)-1)
 

