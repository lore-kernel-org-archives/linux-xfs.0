Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2C5C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbiLaB1u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236093AbiLaB1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:27:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0001DF3A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:27:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 617DFB81DEC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25746C433EF;
        Sat, 31 Dec 2022 01:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450064;
        bh=DLvFWrCutW2WLkmEIE4W3B1OFOK+Pzdiizpy/al2+GY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CJCvGcR4b4QNMg2Lt1W+F3IgH0MKP70qVVDPZtvnMW51jz99PiPAVATQPF/Oii0zx
         j2e8X73CTvxTk7E5IYY85FfZ6hLQAqBrUqgUoRZB4pNxKx4jnt3/jGpl/byN2X0kWb
         KQLM0jxdK0nws2x8xfpjsCofLxANq/j+WnfadJdWrTAi0kVMFOzyptX8flKKL91wOK
         WuWDbXc5mJnYbS1eR1OMbFxyWVOR++eL8plemGen8xQFZvqpTD+L0CVyw4CCbeBED/
         L0eF+w7XB9ALFMzfYQpPRlTGNCJZQIjVHQpsnmbqN0C5x0k2z9MPJOsG9j3zXexi1M
         x4HtlujD80VSA==
Subject: [PATCH 01/22] xfs: create incore realtime group structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:52 -0800
Message-ID: <167243867284.712847.15864310421589015183.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
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
 fs/xfs/Makefile             |    1 
 fs/xfs/libxfs/xfs_format.h  |    8 ++
 fs/xfs/libxfs/xfs_rtgroup.c |  214 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |  121 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c      |    5 +
 fs/xfs/libxfs/xfs_types.h   |    4 +
 fs/xfs/xfs_log_recover.c    |    6 +
 fs/xfs/xfs_mount.c          |   12 ++
 fs/xfs/xfs_mount.h          |    6 +
 fs/xfs/xfs_rtalloc.c        |   14 ++-
 fs/xfs/xfs_super.c          |    2 
 fs/xfs/xfs_trace.h          |   34 +++++++
 12 files changed, 423 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 3d74696755c3..135a403c0edc 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -57,6 +57,7 @@ xfs-y				+= $(addprefix libxfs/, \
 # xfs_rtbitmap is shared with libxfs
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
 				   xfs_rtbitmap.o \
+				   xfs_rtgroup.o \
 				   )
 
 # highlevel code
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 946870eb492c..ca87a3f8704a 100644
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
index 000000000000..ced2bd896106
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
new file mode 100644
index 000000000000..f414218a66f2
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
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
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 83930abf935f..48cfb9c8296b 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -641,6 +641,9 @@ __xfs_sb_from_disk(
 		to->sb_gquotino = NULLFSINO;
 		to->sb_pquotino = NULLFSINO;
 	}
+
+	to->sb_rgcount = 0;
+	to->sb_rgblocks = 0;
 }
 
 void
@@ -954,6 +957,8 @@ xfs_sb_mount_common(
 	mp->m_blockwmask = mp->m_blockwsize - 1;
 	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
 	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
+	mp->m_rgblklog = 0;
+	mp->m_rgblkmask = 0;
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index f4615c5be34f..c27c84561b5e 100644
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
 #define NULLRTEXTNO	((xfs_rtxnum_t)-1)
 
 #define	NULLAGBLOCK	((xfs_agblock_t)-1)
+#define NULLRGBLOCK	((xfs_rgblock_t)-1)
 #define	NULLAGNUMBER	((xfs_agnumber_t)-1)
+#define	NULLRGNUMBER	((xfs_rgnumber_t)-1)
 
 #define NULLCOMMITLSN	((xfs_lsn_t)-1)
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 006ceff1959d..8e6da3f34585 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -28,6 +28,7 @@
 #include "xfs_ag.h"
 #include "xfs_quota.h"
 #include "xfs_reflink.h"
+#include "xfs_rtgroup.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -3341,6 +3342,11 @@ xlog_do_recover(
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
index 3957c60d5d07..bcfeaaf11536 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -35,6 +35,7 @@
 #include "xfs_trace.h"
 #include "xfs_ag.h"
 #include "xfs_imeta.h"
+#include "xfs_rtgroup.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
@@ -830,10 +831,16 @@ xfs_mountfs(
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
@@ -1058,6 +1065,8 @@ xfs_mountfs(
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_buftarg_drain(mp->m_logdev_targp);
 	xfs_buftarg_drain(mp->m_ddev_targp);
+ out_free_rtgroup:
+	xfs_free_rtgroups(mp);
  out_free_perag:
 	xfs_free_perag(mp);
  out_free_dir:
@@ -1138,6 +1147,7 @@ xfs_unmountfs(
 	xfs_errortag_clearall(mp);
 #endif
 	unregister_shrinker(&mp->m_inodegc_shrinker);
+	xfs_free_rtgroups(mp);
 	xfs_free_perag(mp);
 
 	xfs_errortag_del(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index bad926f3e102..674938008a97 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -119,6 +119,7 @@ typedef struct xfs_mount {
 	uint8_t			m_agno_log;	/* log #ag's */
 	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
 	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
+	int8_t			m_rgblklog;	/* log2 of rt group sz if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -153,6 +154,7 @@ typedef struct xfs_mount {
 	uint64_t		m_low_space[XFS_LOWSP_MAX];
 	uint64_t		m_low_rtexts[XFS_LOWSP_MAX];
 	uint64_t		m_rtxblkmask;	/* rt extent block mask */
+	uint64_t		m_rgblkmask;	/* rt group block mask */
 	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
 						/* low free space thresholds */
@@ -201,6 +203,8 @@ typedef struct xfs_mount {
 	 */
 	atomic64_t		m_allocbt_blks;
 
+	struct radix_tree_root	m_rtgroup_tree;	/* per-rt group info */
+	spinlock_t		m_rtgroup_lock;	/* lock for m_rtgroup_tree */
 	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
 	uint64_t		m_resblks;	/* total reserved blocks */
@@ -285,6 +289,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 #define XFS_FEAT_METADIR	(1ULL << 27)	/* metadata directory tree */
+#define XFS_FEAT_RTGROUPS	(1ULL << 28)	/* realtime groups */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -349,6 +354,7 @@ __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(metadir, METADIR)
+__XFS_HAS_FEAT(rtgroups, RTGROUPS)
 
 /*
  * Mount features
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index c131738efd0f..3b13352cfbfc 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -25,6 +25,7 @@
 #include "xfs_da_format.h"
 #include "xfs_imeta.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Realtime metadata files are not quite regular files because userspace can't
@@ -1409,10 +1410,12 @@ xfs_rtmount_iread_extents(
  */
 int					/* error */
 xfs_rtmount_inodes(
-	xfs_mount_t	*mp)		/* file system mount structure */
+	struct xfs_mount	*mp)		/* file system mount structure */
 {
-	int		error;		/* error return value */
-	xfs_sb_t	*sbp;
+	struct xfs_sb		*sbp;
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
+	int			error;		/* error return value */
 
 	sbp = &mp->m_sb;
 	error = xfs_rt_iget(mp, mp->m_sb.sb_rbmino, &xfs_rbmip_key,
@@ -1439,6 +1442,11 @@ xfs_rtmount_inodes(
 	if (error)
 		goto out_rele_summary;
 
+	for_each_rtgroup(mp, rgno, rtg) {
+		rtg->rtg_blockcount = xfs_rtgroup_block_count(mp,
+							      rtg->rtg_rgno);
+	}
+
 	xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
 	return 0;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 19a22f9225e4..737c51333d09 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1932,6 +1932,8 @@ static int xfs_init_fs_context(
 	spin_lock_init(&mp->m_agirotor_lock);
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
 	spin_lock_init(&mp->m_perag_lock);
+	INIT_RADIX_TREE(&mp->m_rtgroup_tree, GFP_ATOMIC);
+	spin_lock_init(&mp->m_rtgroup_lock);
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b92efe4eaeae..f72f694b4656 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -206,6 +206,40 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_put);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
 
+#ifdef CONFIG_XFS_RT
+DECLARE_EVENT_CLASS(xfs_rtgroup_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_rgnumber_t rgno, int refcount,
+		 unsigned long caller_ip),
+	TP_ARGS(mp, rgno, refcount, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(int, refcount)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->rgno = rgno;
+		__entry->refcount = refcount;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d rgno 0x%x refcount %d caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rgno,
+		  __entry->refcount,
+		  (char *)__entry->caller_ip)
+);
+
+#define DEFINE_RTGROUP_REF_EVENT(name)	\
+DEFINE_EVENT(xfs_rtgroup_class, name,	\
+	TP_PROTO(struct xfs_mount *mp, xfs_rgnumber_t rgno, int refcount,	\
+		 unsigned long caller_ip),					\
+	TP_ARGS(mp, rgno, refcount, caller_ip))
+DEFINE_RTGROUP_REF_EVENT(xfs_rtgroup_get);
+DEFINE_RTGROUP_REF_EVENT(xfs_rtgroup_bump);
+DEFINE_RTGROUP_REF_EVENT(xfs_rtgroup_put);
+#endif /* CONFIG_XFS_RT */
+
 TRACE_EVENT(xfs_inodegc_worker,
 	TP_PROTO(struct xfs_mount *mp, unsigned int shrinker_hits),
 	TP_ARGS(mp, shrinker_hits),

