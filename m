Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52842 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfDKBpj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Apr 2019 21:45:39 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3B1hMP2047238
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:45:36 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2rphmepag4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:45:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3B1huog147927
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:45:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2rpkek7695-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:45:35 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3B1jYEi006263
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:45:34 GMT
Subject: [PATCH 1/8] xfs: track metadata health status
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 10 Apr 2019 18:45:32 -0700
Message-ID: <155494713235.1090518.11696420703305243139.stgit@magnolia>
In-Reply-To: <155494712442.1090518.2784809287026447547.stgit@magnolia>
References: <155494712442.1090518.2784809287026447547.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add the necessary in-core metadata fields to keep track of which parts
of the filesystem have been observed and which parts were observed to be
unhealthy, and print a warning at unmount time if we have unfixed
problems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/libxfs/xfs_health.h |  175 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_health.c        |  192 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c        |    8 ++
 fs/xfs/xfs_inode.h         |    8 ++
 fs/xfs/xfs_mount.c         |    1 
 fs/xfs/xfs_mount.h         |   23 +++++
 fs/xfs/xfs_trace.h         |   73 +++++++++++++++++
 8 files changed, 481 insertions(+)
 create mode 100644 fs/xfs/libxfs/xfs_health.h
 create mode 100644 fs/xfs/xfs_health.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7f96bdadc372..786379c143f4 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -73,6 +73,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_fsmap.o \
 				   xfs_fsops.o \
 				   xfs_globals.o \
+				   xfs_health.o \
 				   xfs_icache.o \
 				   xfs_ioctl.o \
 				   xfs_iomap.o \
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
new file mode 100644
index 000000000000..30762a5d4862
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_HEALTH_H__
+#define __XFS_HEALTH_H__
+
+/*
+ * In-Core Filesystem Health Assessments
+ * =====================================
+ *
+ * We'd like to be able to summarize the current health status of the
+ * filesystem so that the administrator knows when it's necessary to schedule
+ * some downtime for repairs.  Until then, we would also like to avoid abrupt
+ * shutdowns due to corrupt metadata.
+ *
+ * The online scrub feature evaluates the health of all filesystem metadata.
+ * When scrub detects corruption in a piece of metadata it will set the
+ * corresponding sickness flag, and repair will clear it if successful.
+ *
+ * If problems remain at unmount time, we can also request manual intervention
+ * by logging a notice to run xfs_repair.
+ */
+
+struct xfs_mount;
+struct xfs_perag;
+struct xfs_inode;
+
+/* Observable health issues for metadata spanning the entire filesystem. */
+#define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
+#define XFS_SICK_FS_UQUOTA	(1 << 1)  /* user quota */
+#define XFS_SICK_FS_GQUOTA	(1 << 2)  /* group quota */
+#define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
+
+/* Observable health issues for realtime volume metadata. */
+#define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
+#define XFS_SICK_RT_SUMMARY	(1 << 1)  /* realtime summary */
+
+/* Observable health issues for AG metadata. */
+#define XFS_SICK_AG_SB		(1 << 0)  /* superblock */
+#define XFS_SICK_AG_AGF		(1 << 1)  /* AGF header */
+#define XFS_SICK_AG_AGFL	(1 << 2)  /* AGFL header */
+#define XFS_SICK_AG_AGI		(1 << 3)  /* AGI header */
+#define XFS_SICK_AG_BNOBT	(1 << 4)  /* free space by block */
+#define XFS_SICK_AG_CNTBT	(1 << 5)  /* free space by length */
+#define XFS_SICK_AG_INOBT	(1 << 6)  /* inode index */
+#define XFS_SICK_AG_FINOBT	(1 << 7)  /* free inode index */
+#define XFS_SICK_AG_RMAPBT	(1 << 8)  /* reverse mappings */
+#define XFS_SICK_AG_REFCNTBT	(1 << 9)  /* reference counts */
+
+/* Observable health issues for inode metadata. */
+#define XFS_SICK_INO_CORE	(1 << 0)  /* inode core */
+#define XFS_SICK_INO_BMBTD	(1 << 1)  /* data fork */
+#define XFS_SICK_INO_BMBTA	(1 << 2)  /* attr fork */
+#define XFS_SICK_INO_BMBTC	(1 << 3)  /* cow fork */
+#define XFS_SICK_INO_DIR	(1 << 4)  /* directory */
+#define XFS_SICK_INO_XATTR	(1 << 5)  /* extended attributes */
+#define XFS_SICK_INO_SYMLINK	(1 << 6)  /* symbolic link remote target */
+#define XFS_SICK_INO_PARENT	(1 << 7)  /* parent pointers */
+
+/* Primary evidence of health problems in a given group. */
+#define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
+				 XFS_SICK_FS_UQUOTA | \
+				 XFS_SICK_FS_GQUOTA | \
+				 XFS_SICK_FS_PQUOTA)
+
+#define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
+				 XFS_SICK_RT_SUMMARY)
+
+#define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
+				 XFS_SICK_AG_AGF | \
+				 XFS_SICK_AG_AGFL | \
+				 XFS_SICK_AG_AGI | \
+				 XFS_SICK_AG_BNOBT | \
+				 XFS_SICK_AG_CNTBT | \
+				 XFS_SICK_AG_INOBT | \
+				 XFS_SICK_AG_FINOBT | \
+				 XFS_SICK_AG_RMAPBT | \
+				 XFS_SICK_AG_REFCNTBT)
+
+#define XFS_SICK_INO_PRIMARY	(XFS_SICK_INO_CORE | \
+				 XFS_SICK_INO_BMBTD | \
+				 XFS_SICK_INO_BMBTA | \
+				 XFS_SICK_INO_BMBTC | \
+				 XFS_SICK_INO_DIR | \
+				 XFS_SICK_INO_XATTR | \
+				 XFS_SICK_INO_SYMLINK | \
+				 XFS_SICK_INO_PARENT)
+
+/* These functions must be provided by the xfs implementation. */
+
+void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask);
+void xfs_fs_mark_healthy(struct xfs_mount *mp, unsigned int mask);
+void xfs_fs_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
+		unsigned int *checked);
+
+void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask);
+void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
+void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
+		unsigned int *checked);
+
+void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
+void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
+void xfs_ag_measure_sickness(struct xfs_perag *pag, unsigned int *sick,
+		unsigned int *checked);
+
+void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask);
+void xfs_inode_mark_healthy(struct xfs_inode *ip, unsigned int mask);
+void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
+		unsigned int *checked);
+
+/* Now some helpers. */
+
+static inline bool
+xfs_fs_has_sickness(struct xfs_mount *mp, unsigned int mask)
+{
+	unsigned int	sick, checked;
+
+	xfs_fs_measure_sickness(mp, &sick, &checked);
+	return sick & mask;
+}
+
+static inline bool
+xfs_rt_has_sickness(struct xfs_mount *mp, unsigned int mask)
+{
+	unsigned int	sick, checked;
+
+	xfs_rt_measure_sickness(mp, &sick, &checked);
+	return sick & mask;
+}
+
+static inline bool
+xfs_ag_has_sickness(struct xfs_perag *pag, unsigned int mask)
+{
+	unsigned int	sick, checked;
+
+	xfs_ag_measure_sickness(pag, &sick, &checked);
+	return sick & mask;
+}
+
+static inline bool
+xfs_inode_has_sickness(struct xfs_inode *ip, unsigned int mask)
+{
+	unsigned int	sick, checked;
+
+	xfs_inode_measure_sickness(ip, &sick, &checked);
+	return sick & mask;
+}
+
+static inline bool
+xfs_fs_is_healthy(struct xfs_mount *mp)
+{
+	return !xfs_fs_has_sickness(mp, -1U);
+}
+
+static inline bool
+xfs_rt_is_healthy(struct xfs_mount *mp)
+{
+	return !xfs_rt_has_sickness(mp, -1U);
+}
+
+static inline bool
+xfs_ag_is_healthy(struct xfs_perag *pag)
+{
+	return !xfs_ag_has_sickness(pag, -1U);
+}
+
+static inline bool
+xfs_inode_is_healthy(struct xfs_inode *ip)
+{
+	return !xfs_inode_has_sickness(ip, -1U);
+}
+
+#endif	/* __XFS_HEALTH_H__ */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
new file mode 100644
index 000000000000..941f33037e2f
--- /dev/null
+++ b/fs/xfs/xfs_health.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_inode.h"
+#include "xfs_trace.h"
+#include "xfs_health.h"
+
+/* Mark unhealthy per-fs metadata. */
+void
+xfs_fs_mark_sick(
+	struct xfs_mount	*mp,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_FS_PRIMARY));
+	trace_xfs_fs_mark_sick(mp, mask);
+
+	spin_lock(&mp->m_sb_lock);
+	mp->m_fs_sick |= mask;
+	mp->m_fs_checked |= mask;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Mark a per-fs metadata healed. */
+void
+xfs_fs_mark_healthy(
+	struct xfs_mount	*mp,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_FS_PRIMARY));
+	trace_xfs_fs_mark_healthy(mp, mask);
+
+	spin_lock(&mp->m_sb_lock);
+	mp->m_fs_sick &= ~mask;
+	mp->m_fs_checked |= mask;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Sample which per-fs metadata are unhealthy. */
+void
+xfs_fs_measure_sickness(
+	struct xfs_mount	*mp,
+	unsigned int		*sick,
+	unsigned int		*checked)
+{
+	spin_lock(&mp->m_sb_lock);
+	*sick = mp->m_fs_sick;
+	*checked = mp->m_fs_checked;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Mark unhealthy realtime metadata. */
+void
+xfs_rt_mark_sick(
+	struct xfs_mount	*mp,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_RT_PRIMARY));
+	trace_xfs_rt_mark_sick(mp, mask);
+
+	spin_lock(&mp->m_sb_lock);
+	mp->m_rt_sick |= mask;
+	mp->m_rt_checked |= mask;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Mark a realtime metadata healed. */
+void
+xfs_rt_mark_healthy(
+	struct xfs_mount	*mp,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_RT_PRIMARY));
+	trace_xfs_rt_mark_healthy(mp, mask);
+
+	spin_lock(&mp->m_sb_lock);
+	mp->m_rt_sick &= ~mask;
+	mp->m_rt_checked |= mask;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Sample which realtime metadata are unhealthy. */
+void
+xfs_rt_measure_sickness(
+	struct xfs_mount	*mp,
+	unsigned int		*sick,
+	unsigned int		*checked)
+{
+	spin_lock(&mp->m_sb_lock);
+	*sick = mp->m_rt_sick;
+	*checked = mp->m_rt_checked;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Mark unhealthy per-ag metadata. */
+void
+xfs_ag_mark_sick(
+	struct xfs_perag	*pag,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_AG_PRIMARY));
+	trace_xfs_ag_mark_sick(pag->pag_mount, pag->pag_agno, mask);
+
+	spin_lock(&pag->pag_state_lock);
+	pag->pag_sick |= mask;
+	pag->pag_checked |= mask;
+	spin_unlock(&pag->pag_state_lock);
+}
+
+/* Mark per-ag metadata ok. */
+void
+xfs_ag_mark_healthy(
+	struct xfs_perag	*pag,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_AG_PRIMARY));
+	trace_xfs_ag_mark_healthy(pag->pag_mount, pag->pag_agno, mask);
+
+	spin_lock(&pag->pag_state_lock);
+	pag->pag_sick &= ~mask;
+	pag->pag_checked |= mask;
+	spin_unlock(&pag->pag_state_lock);
+}
+
+/* Sample which per-ag metadata are unhealthy. */
+void
+xfs_ag_measure_sickness(
+	struct xfs_perag	*pag,
+	unsigned int		*sick,
+	unsigned int		*checked)
+{
+	spin_lock(&pag->pag_state_lock);
+	*sick = pag->pag_sick;
+	*checked = pag->pag_checked;
+	spin_unlock(&pag->pag_state_lock);
+}
+
+/* Mark the unhealthy parts of an inode. */
+void
+xfs_inode_mark_sick(
+	struct xfs_inode	*ip,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_INO_PRIMARY));
+	trace_xfs_inode_mark_sick(ip, mask);
+
+	spin_lock(&ip->i_flags_lock);
+	ip->i_sick |= mask;
+	ip->i_checked |= mask;
+	spin_unlock(&ip->i_flags_lock);
+}
+
+/* Mark parts of an inode healed. */
+void
+xfs_inode_mark_healthy(
+	struct xfs_inode	*ip,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_INO_PRIMARY));
+	trace_xfs_inode_mark_healthy(ip, mask);
+
+	spin_lock(&ip->i_flags_lock);
+	ip->i_sick &= ~mask;
+	ip->i_checked |= mask;
+	spin_unlock(&ip->i_flags_lock);
+}
+
+/* Sample which parts of an inode are unhealthy. */
+void
+xfs_inode_measure_sickness(
+	struct xfs_inode	*ip,
+	unsigned int		*sick,
+	unsigned int		*checked)
+{
+	spin_lock(&ip->i_flags_lock);
+	*sick = ip->i_sick;
+	*checked = ip->i_checked;
+	spin_unlock(&ip->i_flags_lock);
+}
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e70e7db29026..885decab4735 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -73,6 +73,8 @@ xfs_inode_alloc(
 	INIT_WORK(&ip->i_iodone_work, xfs_end_io);
 	INIT_LIST_HEAD(&ip->i_iodone_list);
 	spin_lock_init(&ip->i_iodone_lock);
+	ip->i_sick = 0;
+	ip->i_checked = 0;
 
 	return ip;
 }
@@ -133,6 +135,8 @@ xfs_inode_free(
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags = XFS_IRECLAIM;
 	ip->i_ino = 0;
+	ip->i_sick = 0;
+	ip->i_checked = 0;
 	spin_unlock(&ip->i_flags_lock);
 
 	__xfs_inode_free(ip);
@@ -449,6 +453,8 @@ xfs_iget_cache_hit(
 		ip->i_flags |= XFS_INEW;
 		xfs_inode_clear_reclaim_tag(pag, ip->i_ino);
 		inode->i_state = I_NEW;
+		ip->i_sick = 0;
+		ip->i_checked = 0;
 
 		ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 		init_rwsem(&inode->i_rwsem);
@@ -1177,6 +1183,8 @@ xfs_reclaim_inode(
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags = XFS_IRECLAIM;
 	ip->i_ino = 0;
+	ip->i_sick = 0;
+	ip->i_checked = 0;
 	spin_unlock(&ip->i_flags_lock);
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 88239c2dd824..494e47ef42cb 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -45,6 +45,14 @@ typedef struct xfs_inode {
 	mrlock_t		i_lock;		/* inode lock */
 	mrlock_t		i_mmaplock;	/* inode mmap IO lock */
 	atomic_t		i_pincount;	/* inode pin count */
+
+	/*
+	 * Bitsets of inode metadata that have been checked and/or are sick.
+	 * Callers must hold i_flags_lock before accessing this field.
+	 */
+	uint16_t		i_checked;
+	uint16_t		i_sick;
+
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
 	/* Miscellaneous state. */
 	unsigned long		i_flags;	/* see defined flags below */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fd63b0b1307c..6581381c12be 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -231,6 +231,7 @@ xfs_initialize_perag(
 		error = xfs_iunlink_init(pag);
 		if (error)
 			goto out_hash_destroy;
+		spin_lock_init(&pag->pag_state_lock);
 	}
 
 	index = xfs_set_inode_alloc(mp, agcount);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 110f927cf943..cf7facc36a5f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -60,6 +60,20 @@ struct xfs_error_cfg {
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
+
+	/*
+	 * Bitsets of per-fs metadata that have been checked and/or are sick.
+	 * Callers must hold m_sb_lock to access these two fields.
+	 */
+	uint8_t			m_fs_checked;
+	uint8_t			m_fs_sick;
+	/*
+	 * Bitsets of rt metadata that have been checked and/or are sick.
+	 * Callers must hold m_sb_lock to access this field.
+	 */
+	uint8_t			m_rt_checked;
+	uint8_t			m_rt_sick;
+
 	struct xfs_ail		*m_ail;		/* fs active log item list */
 
 	struct xfs_sb		m_sb;		/* copy of fs superblock */
@@ -369,6 +383,15 @@ typedef struct xfs_perag {
 	xfs_agino_t	pagl_pagino;
 	xfs_agino_t	pagl_leftrec;
 	xfs_agino_t	pagl_rightrec;
+
+	/*
+	 * Bitsets of per-ag metadata that have been checked and/or are sick.
+	 * Callers should hold pag_state_lock before accessing this field.
+	 */
+	uint16_t	pag_checked;
+	uint16_t	pag_sick;
+	spinlock_t	pag_state_lock;
+
 	spinlock_t	pagb_lock;	/* lock for pagb_tree */
 	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
 	unsigned int	pagb_gen;	/* generation count for pagb_tree */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 47fb07d86efd..f079841c7af6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3440,6 +3440,79 @@ DEFINE_AGINODE_EVENT(xfs_iunlink);
 DEFINE_AGINODE_EVENT(xfs_iunlink_remove);
 DEFINE_AG_EVENT(xfs_iunlink_map_prev_fallback);
 
+DECLARE_EVENT_CLASS(xfs_fs_corrupt_class,
+	TP_PROTO(struct xfs_mount *mp, unsigned int flags),
+	TP_ARGS(mp, flags),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->flags = flags;
+	),
+	TP_printk("dev %d:%d flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->flags)
+);
+#define DEFINE_FS_CORRUPT_EVENT(name)	\
+DEFINE_EVENT(xfs_fs_corrupt_class, name,	\
+	TP_PROTO(struct xfs_mount *mp, unsigned int flags), \
+	TP_ARGS(mp, flags))
+DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_sick);
+DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_healthy);
+DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_sick);
+DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_healthy);
+
+DECLARE_EVENT_CLASS(xfs_ag_corrupt_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, unsigned int flags),
+	TP_ARGS(mp, agno, flags),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->flags = flags;
+	),
+	TP_printk("dev %d:%d agno %u flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno, __entry->flags)
+);
+#define DEFINE_AG_CORRUPT_EVENT(name)	\
+DEFINE_EVENT(xfs_ag_corrupt_class, name,	\
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 unsigned int flags), \
+	TP_ARGS(mp, agno, flags))
+DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_sick);
+DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_healthy);
+
+DECLARE_EVENT_CLASS(xfs_inode_corrupt_class,
+	TP_PROTO(struct xfs_inode *ip, unsigned int flags),
+	TP_ARGS(ip, flags),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->flags = flags;
+	),
+	TP_printk("dev %d:%d ino 0x%llx flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->flags)
+);
+#define DEFINE_INODE_CORRUPT_EVENT(name)	\
+DEFINE_EVENT(xfs_inode_corrupt_class, name,	\
+	TP_PROTO(struct xfs_inode *ip, unsigned int flags), \
+	TP_ARGS(ip, flags))
+DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_sick);
+DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
