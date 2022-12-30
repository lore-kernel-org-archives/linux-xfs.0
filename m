Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03622C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbiLaCaX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbiLaCaW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:30:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5CA1CB17
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7968EB81E75
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D551C433EF;
        Sat, 31 Dec 2022 02:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453818;
        bh=YzhS9LNEQGAZivh6crT/ppNewYPKmkgUGgQ4FXEPkWA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hgRRziAELhsNNjiT0mDVUeYwaTyO7oGMr4d8HzxD7nd5pXJfPFHBINUgcc8GDAKuU
         nFTN8UyIbFaMy1SzwJII19cpLVQxafS4ie3+dxxaml/nR+xfc3u1W+cqI9YsfkkVpm
         0omvu/C4y8zHDbn27ArcqDp0sCwEaLcrgRReiK2nXeJ6w7XbShGhelGKl6LR6nlM7j
         hQBWpg2jJs8SfvANsuslHsedqCy5g7x4LXKWcZzedKeT9ZtOzDtgUWLAY7NurB1HP9
         Y6gR45hSlC03jPUBH7/+IqA1s46j+mscaU3al23b5CIBAsNv0LnPEwyRTD4vUd5uYV
         otWiarstrJ66g==
Subject: [PATCH 01/45] xfs: create incore realtime group structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:43 -0800
Message-ID: <167243878380.731133.6912594788285833701.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create an incore object that will contain information about a realtime
allocation group.  This will eventually enable us to shard the realtime
section in a similar manner to how we shard the data section.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h      |    8 ++
 include/xfs_trace.h      |    5 +
 libxfs/Makefile          |    2 
 libxfs/init.c            |   21 +++++
 libxfs/libxfs_api_defs.h |    2 
 libxfs/xfs_format.h      |    8 ++
 libxfs/xfs_rtgroup.c     |  212 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtgroup.h     |  121 ++++++++++++++++++++++++++
 libxfs/xfs_sb.c          |    5 +
 libxfs/xfs_types.h       |    4 +
 10 files changed, 388 insertions(+)
 create mode 100644 libxfs/xfs_rtgroup.c
 create mode 100644 libxfs/xfs_rtgroup.h


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 6de360d33d3..5987650c639 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -68,6 +68,7 @@ typedef struct xfs_mount {
 	uint8_t			m_sectbb_log;	/* sectorlog - BBSHIFT */
 	uint8_t			m_agno_log;	/* log #ag's */
 	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
+	int8_t			m_rgblklog;	/* log2 of rt group sz if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -88,8 +89,10 @@ typedef struct xfs_mount {
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
 	struct radix_tree_root	m_perag_tree;
+	struct radix_tree_root	m_rtgroup_tree;
 	uint64_t		m_features;	/* active filesystem features */
 	uint64_t		m_rtxblkmask;	/* rt extent block mask */
+	uint64_t		m_rgblkmask;	/* rt group block mask */
 	unsigned long		m_opstate;	/* dynamic state flags */
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	uint			m_qflags;	/* quota status flags */
@@ -126,6 +129,7 @@ typedef struct xfs_mount {
 	 */
 	atomic64_t		m_allocbt_blks;
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
+	spinlock_t		m_rtgroup_lock;	/* lock for m_rtgroup_tree */
 
 } xfs_mount_t;
 
@@ -165,6 +169,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 #define XFS_FEAT_METADIR	(1ULL << 27)	/* metadata directory tree */
+#define XFS_FEAT_RTGROUPS	(1ULL << 28)	/* realtime groups */
 
 #define __XFS_HAS_FEAT(name, NAME) \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
@@ -210,6 +215,7 @@ __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(metadir, METADIR)
+__XFS_HAS_FEAT(rtgroups, RTGROUPS)
 
 /* Kernel mount features that we don't support */
 #define __XFS_UNSUPP_FEAT(name) \
@@ -230,6 +236,7 @@ __XFS_UNSUPP_FEAT(grpid)
 #define XFS_OPSTATE_DEBUGGER		1	/* is this the debugger? */
 #define XFS_OPSTATE_REPORT_CORRUPTION	2	/* report buffer corruption? */
 #define XFS_OPSTATE_PERAG_DATA_LOADED	3	/* per-AG data initialized? */
+#define XFS_OPSTATE_RTGROUP_DATA_LOADED	4	/* rtgroup data initialized? */
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -255,6 +262,7 @@ __XFS_IS_OPSTATE(inode32, INODE32)
 __XFS_IS_OPSTATE(debugger, DEBUGGER)
 __XFS_IS_OPSTATE(reporting_corruption, REPORT_CORRUPTION)
 __XFS_IS_OPSTATE(perag_data_loaded, PERAG_DATA_LOADED)
+__XFS_IS_OPSTATE(rtgroup_data_loaded, RTGROUP_DATA_LOADED)
 
 #define __XFS_UNSUPP_OPSTATE(name) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index fef869dbea3..4c73f86d8f0 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -332,6 +332,11 @@
 #define trace_xfs_rmap_map_error(...)		((void) 0)
 #define trace_xfs_rmap_delete_error(...)	((void) 0)
 
+/* set c = c to avoid unused var warnings */
+#define trace_xfs_rtgroup_bump(...)		((void) 0)
+#define trace_xfs_rtgroup_get(a,b,c,d)		((c) = (c))
+#define trace_xfs_rtgroup_put(a,b,c,d)		((c) = (c))
+
 #define trace_xfs_swapext_defer(...)		((void) 0)
 #define trace_xfs_swapext_delta_nextents(...)	((void) 0)
 #define trace_xfs_swapext_delta_nextents_step(...)	((void) 0)
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 5d6e1c7bcc2..1bd8a2ab01d 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -57,6 +57,7 @@ HFILES = \
 	xfs_rmap.h \
 	xfs_rmap_btree.h \
 	xfs_rtbitmap.h \
+	xfs_rtgroup.h \
 	xfs_sb.h \
 	xfs_shared.h \
 	xfs_swapext.h \
@@ -111,6 +112,7 @@ CFILES = cache.c \
 	xfs_rmap.c \
 	xfs_rmap_btree.c \
 	xfs_rtbitmap.c \
+	xfs_rtgroup.c \
 	xfs_sb.c \
 	xfs_swapext.c \
 	xfs_symlink_remote.c \
diff --git a/libxfs/init.c b/libxfs/init.c
index a440943cbdb..c7f10823870 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -25,6 +25,7 @@
 #include "xfile.h"
 
 #include "libxfs.h"		/* for now */
+#include "xfs_rtgroup.h"
 
 #ifndef HAVE_LIBURCU_ATOMIC64
 pthread_mutex_t	atomic64_lock = PTHREAD_MUTEX_INITIALIZER;
@@ -839,7 +840,9 @@ libxfs_mount(
 {
 	struct xfs_buf		*bp;
 	struct xfs_sb		*sbp;
+	struct xfs_rtgroup	*rtg;
 	xfs_daddr_t		d;
+	xfs_rgnumber_t		rgno;
 	unsigned int		btflags = 0;
 	int			error;
 
@@ -857,9 +860,11 @@ libxfs_mount(
 	xfs_set_inode32(mp);
 	mp->m_sb = *sb;
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
+	INIT_RADIX_TREE(&mp->m_rtgroup_tree, GFP_KERNEL);
 	sbp = &mp->m_sb;
 	spin_lock_init(&mp->m_sb_lock);
 	spin_lock_init(&mp->m_agirotor_lock);
+	spin_lock_init(&mp->m_rtgroup_lock);
 
 	xfs_sb_mount_common(mp, sb);
 
@@ -987,6 +992,20 @@ libxfs_mount(
 
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
@@ -1120,6 +1139,8 @@ libxfs_umount(
 	 * Only try to free the per-AG structures if we set them up in the
 	 * first place.
 	 */
+	if (xfs_is_rtgroup_data_loaded(mp))
+		xfs_free_rtgroups(mp);
 	if (xfs_is_perag_data_loaded(mp))
 		libxfs_free_perag(mp);
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index ca9144dd949..7ce9686c00d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -138,6 +138,7 @@
 #define xfs_fixed_inode_reset		libxfs_fixed_inode_reset
 #define xfs_free_extent			libxfs_free_extent
 #define xfs_free_perag			libxfs_free_perag
+#define xfs_free_rtgroups		libxfs_free_rtgroups
 #define xfs_fs_geometry			libxfs_fs_geometry
 #define xfs_get_projid			libxfs_get_projid
 #define xfs_get_initial_prid		libxfs_get_initial_prid
@@ -174,6 +175,7 @@
 
 #define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
+#define xfs_initialize_rtgroups		libxfs_initialize_rtgroups
 #define xfs_init_local_fork		libxfs_init_local_fork
 
 #define xfs_inobt_maxrecs		libxfs_inobt_maxrecs
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 946870eb492..ca87a3f8704 100644
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
index 00000000000..7d26ef76d3e
--- /dev/null
+++ b/libxfs/xfs_rtgroup.c
@@ -0,0 +1,212 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
+	int			ref = 0;
+
+	rcu_read_lock();
+	rtg = radix_tree_lookup(&mp->m_rtgroup_tree, rgno);
+	if (rtg) {
+		ASSERT(atomic_read(&rtg->rtg_ref) >= 0);
+		ref = atomic_inc_return(&rtg->rtg_ref);
+	}
+	rcu_read_unlock();
+	trace_xfs_rtgroup_get(mp, rgno, ref, _RET_IP_);
+	return rtg;
+}
+
+struct xfs_rtgroup *
+xfs_rtgroup_bump(
+	struct xfs_rtgroup	*rtg)
+{
+	if (!atomic_inc_not_zero(&rtg->rtg_ref)) {
+		ASSERT(0);
+		return NULL;
+	}
+
+	trace_xfs_rtgroup_bump(rtg->rtg_mount, rtg->rtg_rgno,
+			atomic_read(&rtg->rtg_ref), _RET_IP_);
+	return rtg;
+}
+
+void
+xfs_rtgroup_put(
+	struct xfs_rtgroup	*rtg)
+{
+	int			ref;
+
+	ASSERT(atomic_read(&rtg->rtg_ref) > 0);
+	ref = atomic_dec_return(&rtg->rtg_ref);
+	trace_xfs_rtgroup_put(rtg->rtg_mount, rtg->rtg_rgno, ref, _RET_IP_);
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
+#endif /* __KERNEL__ */
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
+		XFS_IS_CORRUPT(rtg->rtg_mount, atomic_read(&rtg->rtg_ref) != 0);
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
index 00000000000..f414218a66f
--- /dev/null
+++ b/libxfs/xfs_rtgroup.h
@@ -0,0 +1,121 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
+	atomic_t		rtg_ref;
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
+struct xfs_rtgroup *xfs_rtgroup_get(struct xfs_mount *mp, xfs_rgnumber_t rgno);
+struct xfs_rtgroup *xfs_rtgroup_bump(struct xfs_rtgroup *rtg);
+void xfs_rtgroup_put(struct xfs_rtgroup *rtg);
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
+static inline struct xfs_rtgroup *xfs_rtgroup_bump(struct xfs_rtgroup *rtg)
+{
+	ASSERT(rtg == NULL);
+	return NULL;
+}
+# define xfs_rtgroup_put(rtg)			((void)0)
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
+	xfs_rtgroup_put(rtg);
+	if (*rgno > end_rgno)
+		return NULL;
+	return xfs_rtgroup_get(mp, *rgno);
+}
+
+#define for_each_rtgroup_range(mp, rgno, end_rgno, rtg) \
+	for ((rtg) = xfs_rtgroup_get((mp), (rgno)); \
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
index 8605c91e212..ac2e9f91989 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -639,6 +639,9 @@ __xfs_sb_from_disk(
 		to->sb_gquotino = NULLFSINO;
 		to->sb_pquotino = NULLFSINO;
 	}
+
+	to->sb_rgcount = 0;
+	to->sb_rgblocks = 0;
 }
 
 void
@@ -952,6 +955,8 @@ xfs_sb_mount_common(
 	mp->m_blockwmask = mp->m_blockwsize - 1;
 	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
 	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
+	mp->m_rgblklog = 0;
+	mp->m_rgblkmask = 0;
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index f4615c5be34..c27c84561b5 100644
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
 #define NULLRTEXTNO	((xfs_rtxnum_t)-1)
 
 #define	NULLAGBLOCK	((xfs_agblock_t)-1)
+#define NULLRGBLOCK	((xfs_rgblock_t)-1)
 #define	NULLAGNUMBER	((xfs_agnumber_t)-1)
+#define	NULLRGNUMBER	((xfs_rgnumber_t)-1)
 
 #define NULLCOMMITLSN	((xfs_lsn_t)-1)
 

