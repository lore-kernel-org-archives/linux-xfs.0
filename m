Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B13BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QzyPH40+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4960C433C8;
	Sun, 31 Dec 2023 21:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057352;
	bh=6gYhs78HbM8RJ74hPLsn6uYLIK8JwaOGxp10HbV1K3A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QzyPH40+3jkTBuAO4RPY+ctsU/7ajbI9Rtuca6fofZz6X1kO1izyzuPJY+lAutXF8
	 L+43dbHw0SmWFNUuGfDqCTyii+JkSiWXudSZ1VfFCXugpEiZWZolrOL4hixK+FpmNc
	 4lG0AO5CG8SWa93/2+bWs9xjxlzMlasrgsIFb0xi6OrJHbRhxjJqeWPhGuBmi4N+iP
	 jZ4EfmXsXDSa5giQ9jHzx8o3F/j9Ea1NWKKD7D0Q8yz3IWuUWqn0EqI5ycwcEUxYi/
	 dtDJ11OPV3749dp8FLQREHyvGlTlB18nDfO6sXq6CIBhwNNzJ0RxwvZiMqs8ZvBZsK
	 103WT7PaGy+tg==
Date: Sun, 31 Dec 2023 13:15:52 -0800
Subject: [PATCH 01/24] xfs: create incore realtime group structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846257.1763124.13866237693545815043.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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
 fs/xfs/Makefile             |    1 
 fs/xfs/libxfs/xfs_format.h  |    8 +
 fs/xfs/libxfs/xfs_rtgroup.c |  251 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |  132 +++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c      |    5 +
 fs/xfs/libxfs/xfs_types.h   |    4 +
 fs/xfs/xfs_log_recover.c    |    6 +
 fs/xfs/xfs_mount.c          |   12 ++
 fs/xfs/xfs_mount.h          |    6 +
 fs/xfs/xfs_rtalloc.c        |    8 +
 fs/xfs/xfs_super.c          |    2 
 fs/xfs/xfs_trace.c          |    1 
 fs/xfs/xfs_trace.h          |   38 +++++++
 13 files changed, 473 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5362a0fb56d77..500dea292a9d6 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -59,6 +59,7 @@ xfs-y				+= $(addprefix libxfs/, \
 # xfs_rtbitmap is shared with libxfs
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
 				   xfs_rtbitmap.o \
+				   xfs_rtgroup.o \
 				   )
 
 # highlevel code
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 0636ca97622dd..3bd93c01bf4bf 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
 
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
new file mode 100644
index 0000000000000..caa82c4813038
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -0,0 +1,251 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
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
+#include "xfs_error.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_trace.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
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
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
new file mode 100644
index 0000000000000..2f0a670217c48
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
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
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 7a20b9b4bccb3..88402cb4a6879 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -701,6 +701,9 @@ __xfs_sb_from_disk(
 		to->sb_gquotino = NULLFSINO;
 		to->sb_pquotino = NULLFSINO;
 	}
+
+	to->sb_rgcount = 0;
+	to->sb_rgblocks = 0;
 }
 
 void
@@ -1015,6 +1018,8 @@ xfs_sb_mount_common(
 	mp->m_blockwmask = mp->m_blockwsize - 1;
 	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
 	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
+	mp->m_rgblklog = 0;
+	mp->m_rgblkmask = 0;
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 5556615a2ff9c..195471c438599 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
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
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 628d7915120b0..5e9562f37dc89 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -28,6 +28,7 @@
 #include "xfs_ag.h"
 #include "xfs_quota.h"
 #include "xfs_reflink.h"
+#include "xfs_rtgroup.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -3347,6 +3348,11 @@ xlog_do_recover(
 		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
 		return error;
 	}
+	error = xfs_initialize_rtgroups(mp, sbp->sb_rgcount);
+	if (error) {
+		xfs_warn(mp, "Failed post-recovery rtgroup init: %d", error);
+		return error;
+	}
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
 	/* Normal transactions can now occur */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 8b61b8c51cd16..ba6c77e7e265d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -35,6 +35,7 @@
 #include "xfs_trace.h"
 #include "xfs_ag.h"
 #include "xfs_imeta.h"
+#include "xfs_rtgroup.h"
 #include "scrub/stats.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -842,10 +843,16 @@ xfs_mountfs(
 		goto out_free_dir;
 	}
 
+	error = xfs_initialize_rtgroups(mp, sbp->sb_rgcount);
+	if (error) {
+		xfs_warn(mp, "Failed rtgroup init: %d", error);
+		goto out_free_perag;
+	}
+
 	if (XFS_IS_CORRUPT(mp, !sbp->sb_logblocks)) {
 		xfs_warn(mp, "no log defined");
 		error = -EFSCORRUPTED;
-		goto out_free_perag;
+		goto out_free_rtgroup;
 	}
 
 	error = xfs_inodegc_register_shrinker(mp);
@@ -1070,6 +1077,8 @@ xfs_mountfs(
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_buftarg_drain(mp->m_logdev_targp);
 	xfs_buftarg_drain(mp->m_ddev_targp);
+ out_free_rtgroup:
+	xfs_free_rtgroups(mp);
  out_free_perag:
 	xfs_free_perag(mp);
  out_free_dir:
@@ -1151,6 +1160,7 @@ xfs_unmountfs(
 	xfs_errortag_clearall(mp);
 #endif
 	shrinker_free(mp->m_inodegc_shrinker);
+	xfs_free_rtgroups(mp);
 	xfs_free_perag(mp);
 
 	xfs_errortag_del(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b45a4f4a8503e..52976a133cec9 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -121,6 +121,7 @@ typedef struct xfs_mount {
 	uint8_t			m_agno_log;	/* log #ag's */
 	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
 	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
+	int8_t			m_rgblklog;	/* log2 of rt group sz if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -155,6 +156,7 @@ typedef struct xfs_mount {
 	uint64_t		m_low_space[XFS_LOWSP_MAX];
 	uint64_t		m_low_rtexts[XFS_LOWSP_MAX];
 	uint64_t		m_rtxblkmask;	/* rt extent block mask */
+	uint64_t		m_rgblkmask;	/* rt group block mask */
 	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
 						/* low free space thresholds */
@@ -203,6 +205,8 @@ typedef struct xfs_mount {
 	 */
 	atomic64_t		m_allocbt_blks;
 
+	struct radix_tree_root	m_rtgroup_tree;	/* per-rt group info */
+	spinlock_t		m_rtgroup_lock;	/* lock for m_rtgroup_tree */
 	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
 	uint64_t		m_resblks;	/* total reserved blocks */
@@ -294,6 +298,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 #define XFS_FEAT_METADIR	(1ULL << 27)	/* metadata directory tree */
+#define XFS_FEAT_RTGROUPS	(1ULL << 28)	/* realtime groups */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -358,6 +363,7 @@ __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(metadir, METADIR)
+__XFS_HAS_FEAT(rtgroups, RTGROUPS)
 
 /*
  * Mount features
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f76ecb9a19b51..59ded74c9007e 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -24,6 +24,7 @@
 #include "xfs_health.h"
 #include "xfs_da_format.h"
 #include "xfs_imeta.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Realtime metadata files are not quite regular files because userspace can't
@@ -1396,6 +1397,8 @@ xfs_rtmount_inodes(
 {
 	struct xfs_trans	*tp;
 	struct xfs_sb		*sbp = &mp->m_sb;
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
 	int			error;
 
 	error = xfs_trans_alloc_empty(mp, &tp);
@@ -1426,6 +1429,11 @@ xfs_rtmount_inodes(
 	if (error)
 		goto out_rele_summary;
 
+	for_each_rtgroup(mp, rgno, rtg) {
+		rtg->rtg_blockcount = xfs_rtgroup_block_count(mp,
+							      rtg->rtg_rgno);
+	}
+
 	xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
 	xfs_trans_cancel(tp);
 	return 0;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 998fa006af5bb..c154e2cb7a18e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2002,6 +2002,8 @@ static int xfs_init_fs_context(
 	spin_lock_init(&mp->m_sb_lock);
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
 	spin_lock_init(&mp->m_perag_lock);
+	INIT_RADIX_TREE(&mp->m_rtgroup_tree, GFP_ATOMIC);
+	spin_lock_init(&mp->m_rtgroup_lock);
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 453cf7ffdea03..21f55b0125fc4 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -44,6 +44,7 @@
 #include "xfs_xchgrange.h"
 #include "xfs_parent.h"
 #include "xfs_imeta.h"
+#include "xfs_rtgroup.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 17f364e1b9613..81c21000d4fea 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -87,6 +87,7 @@ struct xfs_getparents;
 struct xfs_parent_name_irec;
 struct xfs_attrlist_cursor_kern;
 struct xfs_imeta_update;
+struct xfs_rtgroup;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -216,6 +217,43 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_rele);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
 
+#ifdef CONFIG_XFS_RT
+DECLARE_EVENT_CLASS(xfs_rtgroup_class,
+	TP_PROTO(struct xfs_rtgroup *rtg, unsigned long caller_ip),
+	TP_ARGS(rtg, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(int, refcount)
+		__field(int, active_refcount)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = rtg->rtg_mount->m_super->s_dev;
+		__entry->rgno = rtg->rtg_rgno;
+		__entry->refcount = atomic_read(&rtg->rtg_ref);
+		__entry->active_refcount = atomic_read(&rtg->rtg_active_ref);
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d rgno 0x%x passive refs %d active refs %d caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rgno,
+		  __entry->refcount,
+		  __entry->active_refcount,
+		  (char *)__entry->caller_ip)
+);
+
+#define DEFINE_RTGROUP_REF_EVENT(name)	\
+DEFINE_EVENT(xfs_rtgroup_class, name,	\
+	TP_PROTO(struct xfs_rtgroup *rtg, unsigned long caller_ip), \
+	TP_ARGS(rtg, caller_ip))
+DEFINE_RTGROUP_REF_EVENT(xfs_rtgroup_get);
+DEFINE_RTGROUP_REF_EVENT(xfs_rtgroup_hold);
+DEFINE_RTGROUP_REF_EVENT(xfs_rtgroup_put);
+DEFINE_RTGROUP_REF_EVENT(xfs_rtgroup_grab);
+DEFINE_RTGROUP_REF_EVENT(xfs_rtgroup_rele);
+#endif /* CONFIG_XFS_RT */
+
 TRACE_EVENT(xfs_inodegc_worker,
 	TP_PROTO(struct xfs_mount *mp, unsigned int shrinker_hits),
 	TP_ARGS(mp, shrinker_hits),

