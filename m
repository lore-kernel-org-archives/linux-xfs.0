Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59712 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729924AbfDARKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 13:10:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x31H9GZl131412
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:10:19 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2rhyvt0cs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 01 Apr 2019 17:10:18 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x31HAHP3011207
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:10:17 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x31HAGvL017472
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:10:17 GMT
Subject: [PATCH 01/10] xfs: track metadata health levels
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Apr 2019 10:10:15 -0700
Message-ID: <155413861577.4966.12311071928325570886.stgit@magnolia>
In-Reply-To: <155413860964.4966.6087725033542837255.stgit@magnolia>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
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
of the filesystem have been observed to be unhealthy, and print a
warning at unmount time if we have unfixed problems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/libxfs/xfs_health.h |  201 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_health.c        |  192 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h         |    7 ++
 fs/xfs/xfs_mount.c         |    1 
 fs/xfs/xfs_mount.h         |   23 +++++
 fs/xfs/xfs_trace.h         |   73 ++++++++++++++++
 7 files changed, 498 insertions(+)
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
index 000000000000..0d51bd2689ea
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -0,0 +1,201 @@
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
+ *
+ * Evidence of health problems can be sorted into three basic categories:
+ *
+ * a) Primary evidence, which signals that something is defective within the
+ *    general grouping of metadata.
+ *
+ * b) Secondary evidence, which are side effects of primary problem but are
+ *    not themselves problems.  These can be forgotten when the primary
+ *    health problems are addressed.
+ *
+ * c) Indirect evidence, which points to something being wrong in another
+ *    group, but we had to release resources and this is all that's left of
+ *    that state.
+ */
+
+struct xfs_mount;
+struct xfs_perag;
+struct xfs_inode;
+
+/* Observable health issues for metadata spanning the entire filesystem. */
+#define XFS_HEALTH_FS_COUNTERS	(1 << 0)  /* summary counters */
+#define XFS_HEALTH_FS_UQUOTA	(1 << 1)  /* user quota */
+#define XFS_HEALTH_FS_GQUOTA	(1 << 2)  /* group quota */
+#define XFS_HEALTH_FS_PQUOTA	(1 << 3)  /* project quota */
+
+/* Observable health issues for realtime volume metadata. */
+#define XFS_HEALTH_RT_BITMAP	(1 << 0)  /* realtime bitmap */
+#define XFS_HEALTH_RT_SUMMARY	(1 << 1)  /* realtime summary */
+
+/* Observable health issues for AG metadata. */
+#define XFS_HEALTH_AG_SB	(1 << 0)  /* superblock */
+#define XFS_HEALTH_AG_AGF	(1 << 1)  /* AGF header */
+#define XFS_HEALTH_AG_AGFL	(1 << 2)  /* AGFL header */
+#define XFS_HEALTH_AG_AGI	(1 << 3)  /* AGI header */
+#define XFS_HEALTH_AG_BNOBT	(1 << 4)  /* free space by block */
+#define XFS_HEALTH_AG_CNTBT	(1 << 5)  /* free space by length */
+#define XFS_HEALTH_AG_INOBT	(1 << 6)  /* inode index */
+#define XFS_HEALTH_AG_FINOBT	(1 << 7)  /* free inode index */
+#define XFS_HEALTH_AG_RMAPBT	(1 << 8)  /* reverse mappings */
+#define XFS_HEALTH_AG_REFCNTBT	(1 << 9)  /* reference counts */
+
+/* Observable health issues for inode metadata. */
+#define XFS_HEALTH_INO_CORE	(1 << 0)  /* inode core */
+#define XFS_HEALTH_INO_BMBTD	(1 << 1)  /* data fork */
+#define XFS_HEALTH_INO_BMBTA	(1 << 2)  /* attr fork */
+#define XFS_HEALTH_INO_BMBTC	(1 << 3)  /* cow fork */
+#define XFS_HEALTH_INO_DIR	(1 << 4)  /* directory */
+#define XFS_HEALTH_INO_XATTR	(1 << 5)  /* extended attributes */
+#define XFS_HEALTH_INO_SYMLINK	(1 << 6)  /* symbolic link remote target */
+#define XFS_HEALTH_INO_PARENT	(1 << 7)  /* parent pointers */
+
+/* Primary evidence of health problems in a given group. */
+#define XFS_HEALTH_FS_PRIMARY	(XFS_HEALTH_FS_COUNTERS | \
+				 XFS_HEALTH_FS_UQUOTA | \
+				 XFS_HEALTH_FS_GQUOTA | \
+				 XFS_HEALTH_FS_PQUOTA)
+
+#define XFS_HEALTH_RT_PRIMARY	(XFS_HEALTH_RT_BITMAP | \
+				 XFS_HEALTH_RT_SUMMARY)
+
+#define XFS_HEALTH_AG_PRIMARY	(XFS_HEALTH_AG_SB | \
+				 XFS_HEALTH_AG_AGF | \
+				 XFS_HEALTH_AG_AGFL | \
+				 XFS_HEALTH_AG_AGI | \
+				 XFS_HEALTH_AG_BNOBT | \
+				 XFS_HEALTH_AG_CNTBT | \
+				 XFS_HEALTH_AG_INOBT | \
+				 XFS_HEALTH_AG_FINOBT | \
+				 XFS_HEALTH_AG_RMAPBT | \
+				 XFS_HEALTH_AG_REFCNTBT)
+
+#define XFS_HEALTH_INO_PRIMARY	(XFS_HEALTH_INO_CORE | \
+				 XFS_HEALTH_INO_BMBTD | \
+				 XFS_HEALTH_INO_BMBTA | \
+				 XFS_HEALTH_INO_BMBTC | \
+				 XFS_HEALTH_INO_DIR | \
+				 XFS_HEALTH_INO_XATTR | \
+				 XFS_HEALTH_INO_SYMLINK | \
+				 XFS_HEALTH_INO_PARENT)
+
+/* Secondary state related to (but not primary evidence of) health problems. */
+#define XFS_HEALTH_FS_SECONDARY	(0)
+#define XFS_HEALTH_RT_SECONDARY	(0)
+#define XFS_HEALTH_AG_SECONDARY	(0)
+#define XFS_HEALTH_INO_SECONDARY (0)
+
+/* Evidence of health problems elsewhere. */
+#define XFS_HEALTH_FS_INDIRECT	(0)
+#define XFS_HEALTH_RT_INDIRECT	(0)
+#define XFS_HEALTH_AG_INDIRECT	(0)
+#define XFS_HEALTH_INO_INDIRECT	(0)
+
+/* All health masks. */
+#define XFS_HEALTH_FS_ALL	(XFS_HEALTH_FS_PRIMARY | \
+				 XFS_HEALTH_FS_SECONDARY | \
+				 XFS_HEALTH_FS_INDIRECT)
+
+#define XFS_HEALTH_RT_ALL	(XFS_HEALTH_RT_PRIMARY | \
+				 XFS_HEALTH_RT_SECONDARY | \
+				 XFS_HEALTH_RT_INDIRECT)
+
+#define XFS_HEALTH_AG_ALL	(XFS_HEALTH_AG_PRIMARY | \
+				 XFS_HEALTH_AG_SECONDARY | \
+				 XFS_HEALTH_AG_INDIRECT)
+
+#define XFS_HEALTH_INO_ALL	(XFS_HEALTH_INO_PRIMARY | \
+				 XFS_HEALTH_INO_SECONDARY | \
+				 XFS_HEALTH_INO_INDIRECT)
+
+/* These functions must be provided by the xfs implementation. */
+
+void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask);
+void xfs_fs_mark_healthy(struct xfs_mount *mp, unsigned int mask);
+unsigned int xfs_fs_measure_sickness(struct xfs_mount *mp);
+
+void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask);
+void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
+unsigned int xfs_rt_measure_sickness(struct xfs_mount *mp);
+
+void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
+void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
+unsigned int xfs_ag_measure_sickness(struct xfs_perag *pag);
+
+void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask);
+void xfs_inode_mark_healthy(struct xfs_inode *ip, unsigned int mask);
+unsigned int xfs_inode_measure_sickness(struct xfs_inode *ip);
+
+/* Now some helpers. */
+
+static inline bool
+xfs_fs_is_sick(struct xfs_mount *mp, unsigned int mask)
+{
+	return (xfs_fs_measure_sickness(mp) & mask) != 0;
+}
+
+static inline bool
+xfs_rt_is_sick(struct xfs_mount *mp, unsigned int mask)
+{
+	return (xfs_rt_measure_sickness(mp) & mask) != 0;
+}
+
+static inline bool
+xfs_ag_is_sick(struct xfs_perag *pag, unsigned int mask)
+{
+	return (xfs_ag_measure_sickness(pag) & mask) != 0;
+}
+
+static inline bool
+xfs_inode_is_sick(struct xfs_inode *ip, unsigned int mask)
+{
+	return (xfs_inode_measure_sickness(ip) & mask) != 0;
+}
+
+static inline bool
+xfs_fs_healthy(struct xfs_mount *mp)
+{
+	return xfs_fs_measure_sickness(mp) == 0;
+}
+
+static inline bool
+xfs_rt_healthy(struct xfs_mount *mp)
+{
+	return xfs_rt_measure_sickness(mp) == 0;
+}
+
+static inline bool
+xfs_ag_healthy(struct xfs_perag *pag)
+{
+	return xfs_ag_measure_sickness(pag) == 0;
+}
+
+static inline bool
+xfs_inode_healthy(struct xfs_inode *ip)
+{
+	return xfs_inode_measure_sickness(ip) == 0;
+}
+
+#endif	/* __XFS_HEALTH_H__ */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
new file mode 100644
index 000000000000..e9d6859f7501
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
+	ASSERT(!(mask & ~XFS_HEALTH_FS_ALL));
+	trace_xfs_fs_mark_sick(mp, mask);
+
+	spin_lock(&mp->m_sb_lock);
+	mp->m_sick |= mask;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Mark a per-fs metadata healed. */
+void
+xfs_fs_mark_healthy(
+	struct xfs_mount	*mp,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_HEALTH_FS_ALL));
+	trace_xfs_fs_mark_healthy(mp, mask);
+
+	spin_lock(&mp->m_sb_lock);
+	mp->m_sick &= ~mask;
+	if (!(mp->m_sick & XFS_HEALTH_FS_PRIMARY))
+		mp->m_sick &= ~XFS_HEALTH_FS_SECONDARY;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Sample which per-fs metadata are unhealthy. */
+unsigned int
+xfs_fs_measure_sickness(
+	struct xfs_mount	*mp)
+{
+	unsigned int		ret;
+
+	spin_lock(&mp->m_sb_lock);
+	ret = mp->m_sick;
+	spin_unlock(&mp->m_sb_lock);
+	return ret;
+}
+
+/* Mark unhealthy realtime metadata. */
+void
+xfs_rt_mark_sick(
+	struct xfs_mount	*mp,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_HEALTH_RT_ALL));
+	trace_xfs_rt_mark_sick(mp, mask);
+
+	spin_lock(&mp->m_sb_lock);
+	mp->m_rt_sick |= mask;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Mark a realtime metadata healed. */
+void
+xfs_rt_mark_healthy(
+	struct xfs_mount	*mp,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_HEALTH_RT_ALL));
+	trace_xfs_rt_mark_healthy(mp, mask);
+
+	spin_lock(&mp->m_sb_lock);
+	mp->m_rt_sick &= ~mask;
+	if (!(mp->m_rt_sick & XFS_HEALTH_RT_PRIMARY))
+		mp->m_rt_sick &= ~XFS_HEALTH_RT_SECONDARY;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Sample which realtime metadata are unhealthy. */
+unsigned int
+xfs_rt_measure_sickness(
+	struct xfs_mount	*mp)
+{
+	unsigned int		ret;
+
+	spin_lock(&mp->m_sb_lock);
+	ret = mp->m_rt_sick;
+	spin_unlock(&mp->m_sb_lock);
+	return ret;
+}
+
+/* Mark unhealthy per-ag metadata. */
+void
+xfs_ag_mark_sick(
+	struct xfs_perag	*pag,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_HEALTH_AG_ALL));
+	trace_xfs_ag_mark_sick(pag->pag_mount, pag->pag_agno, mask);
+
+	spin_lock(&pag->pag_state_lock);
+	pag->pag_sick |= mask;
+	spin_unlock(&pag->pag_state_lock);
+}
+
+/* Mark per-ag metadata ok. */
+void
+xfs_ag_mark_healthy(
+	struct xfs_perag	*pag,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_HEALTH_AG_ALL));
+	trace_xfs_ag_mark_healthy(pag->pag_mount, pag->pag_agno, mask);
+
+	spin_lock(&pag->pag_state_lock);
+	pag->pag_sick &= ~mask;
+	if (!(pag->pag_sick & XFS_HEALTH_AG_PRIMARY))
+		pag->pag_sick &= ~XFS_HEALTH_AG_SECONDARY;
+	spin_unlock(&pag->pag_state_lock);
+}
+
+/* Sample which per-ag metadata are unhealthy. */
+unsigned int
+xfs_ag_measure_sickness(
+	struct xfs_perag	*pag)
+{
+	unsigned int		ret;
+
+	spin_lock(&pag->pag_state_lock);
+	ret = pag->pag_sick;
+	spin_unlock(&pag->pag_state_lock);
+	return ret;
+}
+
+/* Mark the unhealthy parts of an inode. */
+void
+xfs_inode_mark_sick(
+	struct xfs_inode	*ip,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_HEALTH_INO_ALL));
+	trace_xfs_inode_mark_sick(ip, mask);
+
+	spin_lock(&ip->i_flags_lock);
+	ip->i_sick |= mask;
+	spin_unlock(&ip->i_flags_lock);
+}
+
+/* Mark parts of an inode healed. */
+void
+xfs_inode_mark_healthy(
+	struct xfs_inode	*ip,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_HEALTH_INO_ALL));
+	trace_xfs_inode_mark_healthy(ip, mask);
+
+	spin_lock(&ip->i_flags_lock);
+	ip->i_sick &= ~mask;
+	if (!(ip->i_sick & XFS_HEALTH_INO_PRIMARY))
+		ip->i_sick &= ~XFS_HEALTH_INO_SECONDARY;
+	spin_unlock(&ip->i_flags_lock);
+}
+
+/* Sample which parts of an inode are unhealthy. */
+unsigned int
+xfs_inode_measure_sickness(
+	struct xfs_inode	*ip)
+{
+	unsigned int		ret;
+
+	spin_lock(&ip->i_flags_lock);
+	ret = ip->i_sick;
+	spin_unlock(&ip->i_flags_lock);
+	return ret;
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 88239c2dd824..877acdd5f026 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -45,6 +45,13 @@ typedef struct xfs_inode {
 	mrlock_t		i_lock;		/* inode lock */
 	mrlock_t		i_mmaplock;	/* inode mmap IO lock */
 	atomic_t		i_pincount;	/* inode pin count */
+
+	/*
+	 * Bitset noting which parts of an inode are not healthy.
+	 * Callers must hold i_flags_lock before accessing this field.
+	 */
+	unsigned int		i_sick;
+
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
 	/* Miscellaneous state. */
 	unsigned long		i_flags;	/* see defined flags below */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 950752e5ec2c..fc1f24dd0386 100644
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
index 15dc02964113..63bbafb01eb5 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -60,6 +60,13 @@ struct xfs_error_cfg {
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
+
+	/*
+	 * Bitset of unhealthy per-fs metadata.
+	 * Callers must hold m_sb_lock to access this field.
+	 */
+	unsigned int		m_sick;
+
 	struct xfs_ail		*m_ail;		/* fs active log item list */
 
 	struct xfs_sb		m_sb;		/* copy of fs superblock */
@@ -71,6 +78,11 @@ typedef struct xfs_mount {
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
 	char			*m_fsname;	/* filesystem name */
 	int			m_fsname_len;	/* strlen of fs name */
+	/*
+	 * Bitset of unhealthy rt volume metadata.
+	 * Callers must hold m_sb_lock to access this field.
+	 */
+	unsigned int		m_rt_sick;
 	char			*m_rtname;	/* realtime device name */
 	char			*m_logname;	/* external log device name */
 	int			m_bsize;	/* fs logical block size */
@@ -389,6 +401,17 @@ typedef struct xfs_perag {
 	 * or have some other means to control concurrency.
 	 */
 	struct rhashtable	pagi_unlinked_hash;
+
+	/* Spinlock to protect in-core per-ag state */
+	spinlock_t	pag_state_lock;
+
+	/*
+	 * Bitset of unhealthy AG metadata.
+	 *
+	 * Callers should hold pag_state_lock and the relevant AG header buffer
+	 * lock before accessing this field.
+	 */
+	unsigned int	pag_sick;
 } xfs_perag_t;
 
 static inline struct xfs_ag_resv *
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
