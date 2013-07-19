Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5DE7D7F72
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4F5E5304043
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:39 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	s3naZVMXmlLwgs04 for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:37 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0482-000482-Lx
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:22 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0482-0001xL-L5
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/49] xfs: introduce xfs_quota_defs.h
Date: Fri, 19 Jul 2013 16:24:40 +1000
Message-Id: <1374215120-7271-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

There are a lot of quota flag definitions that are shared by user
and kernel space. Move them all to xfs_quota_defs.h so we can
unshare xfs_quota.h and remove the __KERNEL__ regions from it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_quota.h      | 134 +----------------------------------------
 fs/xfs/xfs_quota_defs.h | 157 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 160 insertions(+), 131 deletions(-)
 create mode 100644 fs/xfs/xfs_quota_defs.h

diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 16bde32..fc2fed6 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -18,141 +18,14 @@
 #ifndef __XFS_QUOTA_H__
 #define __XFS_QUOTA_H__
 
-struct xfs_trans;
+#include "xfs_quota_defs.h"
 
 /*
- * Even though users may not have quota limits occupying all 64-bits,
- * they may need 64-bit accounting. Hence, 64-bit quota-counters,
- * and quota-limits. This is a waste in the common case, but hey ...
+ * Kernel only quota definitions and functions
  */
-typedef __uint64_t	xfs_qcnt_t;
-typedef __uint16_t	xfs_qwarncnt_t;
-
-/*
- * flags for q_flags field in the dquot.
- */
-#define XFS_DQ_USER		0x0001		/* a user quota */
-#define XFS_DQ_PROJ		0x0002		/* project quota */
-#define XFS_DQ_GROUP		0x0004		/* a group quota */
-#define XFS_DQ_DIRTY		0x0008		/* dquot is dirty */
-#define XFS_DQ_FREEING		0x0010		/* dquot is beeing torn down */
-
-#define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
 
-#define XFS_DQ_FLAGS \
-	{ XFS_DQ_USER,		"USER" }, \
-	{ XFS_DQ_PROJ,		"PROJ" }, \
-	{ XFS_DQ_GROUP,		"GROUP" }, \
-	{ XFS_DQ_DIRTY,		"DIRTY" }, \
-	{ XFS_DQ_FREEING,	"FREEING" }
-
-/*
- * We have the possibility of all three quota types being active at once, and
- * hence free space modification requires modification of all three current
- * dquots in a single transaction. For this case we need to have a reservation
- * of at least 3 dquots.
- *
- * However, a chmod operation can change both UID and GID in a single
- * transaction, resulting in requiring {old, new} x {uid, gid} dquots to be
- * modified. Hence for this case we need to reserve space for at least 4 dquots.
- *
- * And in the worst case, there's a rename operation that can be modifying up to
- * 4 inodes with dquots attached to them. In reality, the only inodes that can
- * have their dquots modified are the source and destination directory inodes
- * due to directory name creation and removal. That can require space allocation
- * and/or freeing on both directory inodes, and hence all three dquots on each
- * inode can be modified. And if the directories are world writeable, all the
- * dquots can be unique and so 6 dquots can be modified....
- *
- * And, of course, we also need to take into account the dquot log format item
- * used to describe each dquot.
- */
-#define XFS_DQUOT_LOGRES(mp)	\
-	((sizeof(struct xfs_dq_logformat) + sizeof(struct xfs_disk_dquot)) * 6)
-
-#define XFS_IS_QUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
-#define XFS_IS_UQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_UQUOTA_ACCT)
-#define XFS_IS_PQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_PQUOTA_ACCT)
-#define XFS_IS_GQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_GQUOTA_ACCT)
-#define XFS_IS_UQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_UQUOTA_ENFD)
-#define XFS_IS_GQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_GQUOTA_ENFD)
-#define XFS_IS_PQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_PQUOTA_ENFD)
-
-/*
- * Incore only flags for quotaoff - these bits get cleared when quota(s)
- * are in the process of getting turned off. These flags are in m_qflags but
- * never in sb_qflags.
- */
-#define XFS_UQUOTA_ACTIVE	0x1000  /* uquotas are being turned off */
-#define XFS_GQUOTA_ACTIVE	0x2000  /* gquotas are being turned off */
-#define XFS_PQUOTA_ACTIVE	0x4000  /* pquotas are being turned off */
-#define XFS_ALL_QUOTA_ACTIVE	\
-	(XFS_UQUOTA_ACTIVE | XFS_GQUOTA_ACTIVE | XFS_PQUOTA_ACTIVE)
-
-/*
- * Checking XFS_IS_*QUOTA_ON() while holding any inode lock guarantees
- * quota will be not be switched off as long as that inode lock is held.
- */
-#define XFS_IS_QUOTA_ON(mp)	((mp)->m_qflags & (XFS_UQUOTA_ACTIVE | \
-						   XFS_GQUOTA_ACTIVE | \
-						   XFS_PQUOTA_ACTIVE))
-#define XFS_IS_OQUOTA_ON(mp)	((mp)->m_qflags & (XFS_GQUOTA_ACTIVE | \
-						   XFS_PQUOTA_ACTIVE))
-#define XFS_IS_UQUOTA_ON(mp)	((mp)->m_qflags & XFS_UQUOTA_ACTIVE)
-#define XFS_IS_GQUOTA_ON(mp)	((mp)->m_qflags & XFS_GQUOTA_ACTIVE)
-#define XFS_IS_PQUOTA_ON(mp)	((mp)->m_qflags & XFS_PQUOTA_ACTIVE)
-
-/*
- * Flags to tell various functions what to do. Not all of these are meaningful
- * to a single function. None of these XFS_QMOPT_* flags are meant to have
- * persistent values (ie. their values can and will change between versions)
- */
-#define XFS_QMOPT_DQALLOC	0x0000002 /* alloc dquot ondisk if needed */
-#define XFS_QMOPT_UQUOTA	0x0000004 /* user dquot requested */
-#define XFS_QMOPT_PQUOTA	0x0000008 /* project dquot requested */
-#define XFS_QMOPT_FORCE_RES	0x0000010 /* ignore quota limits */
-#define XFS_QMOPT_SBVERSION	0x0000040 /* change superblock version num */
-#define XFS_QMOPT_DOWARN        0x0000400 /* increase warning cnt if needed */
-#define XFS_QMOPT_DQREPAIR	0x0001000 /* repair dquot if damaged */
-#define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
-#define XFS_QMOPT_ENOSPC	0x0004000 /* enospc instead of edquot (prj) */
-
-/*
- * flags to xfs_trans_mod_dquot to indicate which field needs to be
- * modified.
- */
-#define XFS_QMOPT_RES_REGBLKS	0x0010000
-#define XFS_QMOPT_RES_RTBLKS	0x0020000
-#define XFS_QMOPT_BCOUNT	0x0040000
-#define XFS_QMOPT_ICOUNT	0x0080000
-#define XFS_QMOPT_RTBCOUNT	0x0100000
-#define XFS_QMOPT_DELBCOUNT	0x0200000
-#define XFS_QMOPT_DELRTBCOUNT	0x0400000
-#define XFS_QMOPT_RES_INOS	0x0800000
-
-/*
- * flags for dqalloc.
- */
-#define XFS_QMOPT_INHERIT	0x1000000
-
-/*
- * flags to xfs_trans_mod_dquot.
- */
-#define XFS_TRANS_DQ_RES_BLKS	XFS_QMOPT_RES_REGBLKS
-#define XFS_TRANS_DQ_RES_RTBLKS	XFS_QMOPT_RES_RTBLKS
-#define XFS_TRANS_DQ_RES_INOS	XFS_QMOPT_RES_INOS
-#define XFS_TRANS_DQ_BCOUNT	XFS_QMOPT_BCOUNT
-#define XFS_TRANS_DQ_DELBCOUNT	XFS_QMOPT_DELBCOUNT
-#define XFS_TRANS_DQ_ICOUNT	XFS_QMOPT_ICOUNT
-#define XFS_TRANS_DQ_RTBCOUNT	XFS_QMOPT_RTBCOUNT
-#define XFS_TRANS_DQ_DELRTBCOUNT XFS_QMOPT_DELRTBCOUNT
-
-
-#define XFS_QMOPT_QUOTALL	\
-		(XFS_QMOPT_UQUOTA | XFS_QMOPT_PQUOTA | XFS_QMOPT_GQUOTA)
-#define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
+struct xfs_trans;
 
-#ifdef __KERNEL__
 /*
  * This check is done typically without holding the inode lock;
  * that may seem racy, but it is harmless in the context that it is used.
@@ -289,5 +162,4 @@ extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
 
 extern const struct xfs_buf_ops xfs_dquot_buf_ops;
 
-#endif	/* __KERNEL__ */
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_quota_defs.h b/fs/xfs/xfs_quota_defs.h
new file mode 100644
index 0000000..e6b0d6e
--- /dev/null
+++ b/fs/xfs/xfs_quota_defs.h
@@ -0,0 +1,157 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_QUOTA_DEFS_H__
+#define __XFS_QUOTA_DEFS_H__
+
+/*
+ * Quota definitions shared between user and kernel source trees.
+ */
+
+/*
+ * Even though users may not have quota limits occupying all 64-bits,
+ * they may need 64-bit accounting. Hence, 64-bit quota-counters,
+ * and quota-limits. This is a waste in the common case, but hey ...
+ */
+typedef __uint64_t	xfs_qcnt_t;
+typedef __uint16_t	xfs_qwarncnt_t;
+
+/*
+ * flags for q_flags field in the dquot.
+ */
+#define XFS_DQ_USER		0x0001		/* a user quota */
+#define XFS_DQ_PROJ		0x0002		/* project quota */
+#define XFS_DQ_GROUP		0x0004		/* a group quota */
+#define XFS_DQ_DIRTY		0x0008		/* dquot is dirty */
+#define XFS_DQ_FREEING		0x0010		/* dquot is beeing torn down */
+
+#define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
+
+#define XFS_DQ_FLAGS \
+	{ XFS_DQ_USER,		"USER" }, \
+	{ XFS_DQ_PROJ,		"PROJ" }, \
+	{ XFS_DQ_GROUP,		"GROUP" }, \
+	{ XFS_DQ_DIRTY,		"DIRTY" }, \
+	{ XFS_DQ_FREEING,	"FREEING" }
+
+/*
+ * We have the possibility of all three quota types being active at once, and
+ * hence free space modification requires modification of all three current
+ * dquots in a single transaction. For this case we need to have a reservation
+ * of at least 3 dquots.
+ *
+ * However, a chmod operation can change both UID and GID in a single
+ * transaction, resulting in requiring {old, new} x {uid, gid} dquots to be
+ * modified. Hence for this case we need to reserve space for at least 4 dquots.
+ *
+ * And in the worst case, there's a rename operation that can be modifying up to
+ * 4 inodes with dquots attached to them. In reality, the only inodes that can
+ * have their dquots modified are the source and destination directory inodes
+ * due to directory name creation and removal. That can require space allocation
+ * and/or freeing on both directory inodes, and hence all three dquots on each
+ * inode can be modified. And if the directories are world writeable, all the
+ * dquots can be unique and so 6 dquots can be modified....
+ *
+ * And, of course, we also need to take into account the dquot log format item
+ * used to describe each dquot.
+ */
+#define XFS_DQUOT_LOGRES(mp)	\
+	((sizeof(struct xfs_dq_logformat) + sizeof(struct xfs_disk_dquot)) * 6)
+
+#define XFS_IS_QUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
+#define XFS_IS_UQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_UQUOTA_ACCT)
+#define XFS_IS_PQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_PQUOTA_ACCT)
+#define XFS_IS_GQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_GQUOTA_ACCT)
+#define XFS_IS_UQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_UQUOTA_ENFD)
+#define XFS_IS_GQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_GQUOTA_ENFD)
+#define XFS_IS_PQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_PQUOTA_ENFD)
+
+/*
+ * Incore only flags for quotaoff - these bits get cleared when quota(s)
+ * are in the process of getting turned off. These flags are in m_qflags but
+ * never in sb_qflags.
+ */
+#define XFS_UQUOTA_ACTIVE	0x1000  /* uquotas are being turned off */
+#define XFS_GQUOTA_ACTIVE	0x2000  /* gquotas are being turned off */
+#define XFS_PQUOTA_ACTIVE	0x4000  /* pquotas are being turned off */
+#define XFS_ALL_QUOTA_ACTIVE	\
+	(XFS_UQUOTA_ACTIVE | XFS_GQUOTA_ACTIVE | XFS_PQUOTA_ACTIVE)
+
+/*
+ * Checking XFS_IS_*QUOTA_ON() while holding any inode lock guarantees
+ * quota will be not be switched off as long as that inode lock is held.
+ */
+#define XFS_IS_QUOTA_ON(mp)	((mp)->m_qflags & (XFS_UQUOTA_ACTIVE | \
+						   XFS_GQUOTA_ACTIVE | \
+						   XFS_PQUOTA_ACTIVE))
+#define XFS_IS_OQUOTA_ON(mp)	((mp)->m_qflags & (XFS_GQUOTA_ACTIVE | \
+						   XFS_PQUOTA_ACTIVE))
+#define XFS_IS_UQUOTA_ON(mp)	((mp)->m_qflags & XFS_UQUOTA_ACTIVE)
+#define XFS_IS_GQUOTA_ON(mp)	((mp)->m_qflags & XFS_GQUOTA_ACTIVE)
+#define XFS_IS_PQUOTA_ON(mp)	((mp)->m_qflags & XFS_PQUOTA_ACTIVE)
+
+/*
+ * Flags to tell various functions what to do. Not all of these are meaningful
+ * to a single function. None of these XFS_QMOPT_* flags are meant to have
+ * persistent values (ie. their values can and will change between versions)
+ */
+#define XFS_QMOPT_DQALLOC	0x0000002 /* alloc dquot ondisk if needed */
+#define XFS_QMOPT_UQUOTA	0x0000004 /* user dquot requested */
+#define XFS_QMOPT_PQUOTA	0x0000008 /* project dquot requested */
+#define XFS_QMOPT_FORCE_RES	0x0000010 /* ignore quota limits */
+#define XFS_QMOPT_SBVERSION	0x0000040 /* change superblock version num */
+#define XFS_QMOPT_DOWARN        0x0000400 /* increase warning cnt if needed */
+#define XFS_QMOPT_DQREPAIR	0x0001000 /* repair dquot if damaged */
+#define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
+#define XFS_QMOPT_ENOSPC	0x0004000 /* enospc instead of edquot (prj) */
+
+/*
+ * flags to xfs_trans_mod_dquot to indicate which field needs to be
+ * modified.
+ */
+#define XFS_QMOPT_RES_REGBLKS	0x0010000
+#define XFS_QMOPT_RES_RTBLKS	0x0020000
+#define XFS_QMOPT_BCOUNT	0x0040000
+#define XFS_QMOPT_ICOUNT	0x0080000
+#define XFS_QMOPT_RTBCOUNT	0x0100000
+#define XFS_QMOPT_DELBCOUNT	0x0200000
+#define XFS_QMOPT_DELRTBCOUNT	0x0400000
+#define XFS_QMOPT_RES_INOS	0x0800000
+
+/*
+ * flags for dqalloc.
+ */
+#define XFS_QMOPT_INHERIT	0x1000000
+
+/*
+ * flags to xfs_trans_mod_dquot.
+ */
+#define XFS_TRANS_DQ_RES_BLKS	XFS_QMOPT_RES_REGBLKS
+#define XFS_TRANS_DQ_RES_RTBLKS	XFS_QMOPT_RES_RTBLKS
+#define XFS_TRANS_DQ_RES_INOS	XFS_QMOPT_RES_INOS
+#define XFS_TRANS_DQ_BCOUNT	XFS_QMOPT_BCOUNT
+#define XFS_TRANS_DQ_DELBCOUNT	XFS_QMOPT_DELBCOUNT
+#define XFS_TRANS_DQ_ICOUNT	XFS_QMOPT_ICOUNT
+#define XFS_TRANS_DQ_RTBCOUNT	XFS_QMOPT_RTBCOUNT
+#define XFS_TRANS_DQ_DELRTBCOUNT XFS_QMOPT_DELRTBCOUNT
+
+
+#define XFS_QMOPT_QUOTALL	\
+		(XFS_QMOPT_UQUOTA | XFS_QMOPT_PQUOTA | XFS_QMOPT_GQUOTA)
+#define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
+
+#endif	/* __XFS_QUOTA_H__ */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
