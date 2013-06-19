Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E2E758008
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:37:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DD4E38F8035
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:37:09 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2bIu8mibrXW0IFou for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:37:07 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4o-0003Ct-US
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4o-0000Gq-Qe
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 43/50] xfs: introduce xfs_quota_defs.h
Date: Wed, 19 Jun 2013 15:36:06 +1000
Message-Id: <1371620173-712-44-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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
 include/Makefile         |    2 +-
 include/libxfs.h         |    2 +-
 include/xfs_quota.h      |  283 ----------------------------------------------
 include/xfs_quota_defs.h |  143 +++++++++++++++++++++++
 4 files changed, 145 insertions(+), 285 deletions(-)
 delete mode 100644 include/xfs_quota.h
 create mode 100644 include/xfs_quota_defs.h

diff --git a/include/Makefile b/include/Makefile
index e64369f..006506b 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -38,7 +38,7 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_log_format.h \
 	xfs_log_recover.h \
 	xfs_metadump.h \
-	xfs_quota.h \
+	xfs_quota_defs.h \
 	xfs_dquot_format.h \
 	xfs_rtalloc.h xfs_sb.h \
 	xfs_symlink_remote.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index 4fb1762..b1ba154 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -443,7 +443,7 @@ extern int libxfs_ihash_size;
 extern void	libxfs_iomove (xfs_buf_t *, uint, int, void *, int);
 
 
-#include <xfs/xfs_quota.h>
+#include <xfs/xfs_quota_defs.h>
 #include <xfs/xfs_dquot_format.h>
 #include <xfs/xfs_trans_space.h>
 #include <xfs/xfs_log_format.h>
diff --git a/include/xfs_quota.h b/include/xfs_quota.h
deleted file mode 100644
index ec80623..0000000
--- a/include/xfs_quota.h
+++ /dev/null
@@ -1,283 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_QUOTA_H__
-#define __XFS_QUOTA_H__
-
-struct xfs_trans;
-
-/*
- * Even though users may not have quota limits occupying all 64-bits,
- * they may need 64-bit accounting. Hence, 64-bit quota-counters,
- * and quota-limits. This is a waste in the common case, but hey ...
- */
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
-
-#define XFS_DQ_FLAGS \
-	{ XFS_DQ_USER,		"USER" }, \
-	{ XFS_DQ_PROJ,		"PROJ" }, \
-	{ XFS_DQ_GROUP,		"GROUP" }, \
-	{ XFS_DQ_DIRTY,		"DIRTY" }, \
-	{ XFS_DQ_FREEING,	"FREEING" }
-
-/*
- * In the worst case, when both user and group quotas are on,
- * we can have a max of three dquots changing in a single transaction.
- */
-#define XFS_DQUOT_LOGRES(mp)	(sizeof(xfs_disk_dquot_t) * 3)
-
-/*
- * Quota Accounting/Enforcement flags
- */
-
-#define XFS_IS_QUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
-#define XFS_IS_UQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_UQUOTA_ACCT)
-#define XFS_IS_PQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_PQUOTA_ACCT)
-#define XFS_IS_GQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_GQUOTA_ACCT)
-#define XFS_IS_UQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_UQUOTA_ENFD)
-#define XFS_IS_OQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_OQUOTA_ENFD)
-
-/*
- * Incore only flags for quotaoff - these bits get cleared when quota(s)
- * are in the process of getting turned off. These flags are in m_qflags but
- * never in sb_qflags.
- */
-#define XFS_UQUOTA_ACTIVE	0x0100  /* uquotas are being turned off */
-#define XFS_PQUOTA_ACTIVE	0x0200  /* pquotas are being turned off */
-#define XFS_GQUOTA_ACTIVE	0x0400  /* gquotas are being turned off */
-#define XFS_ALL_QUOTA_ACTIVE	\
-	(XFS_UQUOTA_ACTIVE | XFS_PQUOTA_ACTIVE | XFS_GQUOTA_ACTIVE)
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
-
-#ifdef __KERNEL__
-/*
- * This check is done typically without holding the inode lock;
- * that may seem racy, but it is harmless in the context that it is used.
- * The inode cannot go inactive as long a reference is kept, and
- * therefore if dquot(s) were attached, they'll stay consistent.
- * If, for example, the ownership of the inode changes while
- * we didn't have the inode locked, the appropriate dquot(s) will be
- * attached atomically.
- */
-#define XFS_NOT_DQATTACHED(mp, ip) ((XFS_IS_UQUOTA_ON(mp) &&\
-				     (ip)->i_udquot == NULL) || \
-				    (XFS_IS_OQUOTA_ON(mp) && \
-				     (ip)->i_gdquot == NULL))
-
-#define XFS_QM_NEED_QUOTACHECK(mp) \
-	((XFS_IS_UQUOTA_ON(mp) && \
-		(mp->m_sb.sb_qflags & XFS_UQUOTA_CHKD) == 0) || \
-	 (XFS_IS_GQUOTA_ON(mp) && \
-		((mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD) == 0 || \
-		 (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT))) || \
-	 (XFS_IS_PQUOTA_ON(mp) && \
-		((mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD) == 0 || \
-		 (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT))))
-
-#define XFS_MOUNT_QUOTA_SET1	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
-				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
-				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD)
-
-#define XFS_MOUNT_QUOTA_SET2	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
-				 XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|\
-				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD)
-
-#define XFS_MOUNT_QUOTA_ALL	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
-				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
-				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD|\
-				 XFS_GQUOTA_ACCT)
-
-
-/*
- * The structure kept inside the xfs_trans_t keep track of dquot changes
- * within a transaction and apply them later.
- */
-typedef struct xfs_dqtrx {
-	struct xfs_dquot *qt_dquot;	  /* the dquot this refers to */
-	ulong		qt_blk_res;	  /* blks reserved on a dquot */
-	ulong		qt_blk_res_used;  /* blks used from the reservation */
-	ulong		qt_ino_res;	  /* inode reserved on a dquot */
-	ulong		qt_ino_res_used;  /* inodes used from the reservation */
-	long		qt_bcount_delta;  /* dquot blk count changes */
-	long		qt_delbcnt_delta; /* delayed dquot blk count changes */
-	long		qt_icount_delta;  /* dquot inode count changes */
-	ulong		qt_rtblk_res;	  /* # blks reserved on a dquot */
-	ulong		qt_rtblk_res_used;/* # blks used from reservation */
-	long		qt_rtbcount_delta;/* dquot realtime blk changes */
-	long		qt_delrtb_delta;  /* delayed RT blk count changes */
-} xfs_dqtrx_t;
-
-#ifdef CONFIG_XFS_QUOTA
-extern void xfs_trans_dup_dqinfo(struct xfs_trans *, struct xfs_trans *);
-extern void xfs_trans_free_dqinfo(struct xfs_trans *);
-extern void xfs_trans_mod_dquot_byino(struct xfs_trans *, struct xfs_inode *,
-		uint, long);
-extern void xfs_trans_apply_dquot_deltas(struct xfs_trans *);
-extern void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *);
-extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
-		struct xfs_inode *, long, long, uint);
-extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
-		struct xfs_mount *, struct xfs_dquot *,
-		struct xfs_dquot *, long, long, uint);
-
-extern int xfs_qm_vop_dqalloc(struct xfs_inode *, uid_t, gid_t, prid_t, uint,
-		struct xfs_dquot **, struct xfs_dquot **);
-extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
-		struct xfs_dquot *, struct xfs_dquot *);
-extern int xfs_qm_vop_rename_dqattach(struct xfs_inode **);
-extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
-		struct xfs_inode *, struct xfs_dquot **, struct xfs_dquot *);
-extern int xfs_qm_vop_chown_reserve(struct xfs_trans *, struct xfs_inode *,
-		struct xfs_dquot *, struct xfs_dquot *, uint);
-extern int xfs_qm_dqattach(struct xfs_inode *, uint);
-extern int xfs_qm_dqattach_locked(struct xfs_inode *, uint);
-extern void xfs_qm_dqdetach(struct xfs_inode *);
-extern void xfs_qm_dqrele(struct xfs_dquot *);
-extern void xfs_qm_statvfs(struct xfs_inode *, struct kstatfs *);
-extern int xfs_qm_newmount(struct xfs_mount *, uint *, uint *);
-extern void xfs_qm_mount_quotas(struct xfs_mount *);
-extern void xfs_qm_unmount(struct xfs_mount *);
-extern void xfs_qm_unmount_quotas(struct xfs_mount *);
-
-#else
-static inline int
-xfs_qm_vop_dqalloc(struct xfs_inode *ip, uid_t uid, gid_t gid, prid_t prid,
-		uint flags, struct xfs_dquot **udqp, struct xfs_dquot **gdqp)
-{
-	*udqp = NULL;
-	*gdqp = NULL;
-	return 0;
-}
-#define xfs_trans_dup_dqinfo(tp, tp2)
-#define xfs_trans_free_dqinfo(tp)
-#define xfs_trans_mod_dquot_byino(tp, ip, fields, delta)
-#define xfs_trans_apply_dquot_deltas(tp)
-#define xfs_trans_unreserve_and_mod_dquots(tp)
-static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
-		struct xfs_inode *ip, long nblks, long ninos, uint flags)
-{
-	return 0;
-}
-static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
-		struct xfs_mount *mp, struct xfs_dquot *udqp,
-		struct xfs_dquot *gdqp, long nblks, long nions, uint flags)
-{
-	return 0;
-}
-#define xfs_qm_vop_create_dqattach(tp, ip, u, g)
-#define xfs_qm_vop_rename_dqattach(it)					(0)
-#define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
-#define xfs_qm_vop_chown_reserve(tp, ip, u, g, fl)			(0)
-#define xfs_qm_dqattach(ip, fl)						(0)
-#define xfs_qm_dqattach_locked(ip, fl)					(0)
-#define xfs_qm_dqdetach(ip)
-#define xfs_qm_dqrele(d)
-#define xfs_qm_statvfs(ip, s)
-#define xfs_qm_newmount(mp, a, b)					(0)
-#define xfs_qm_mount_quotas(mp)
-#define xfs_qm_unmount(mp)
-#define xfs_qm_unmount_quotas(mp)
-#endif /* CONFIG_XFS_QUOTA */
-
-#define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
-	xfs_trans_reserve_quota_nblks(tp, ip, -(nblks), -(ninos), flags)
-#define xfs_trans_reserve_quota(tp, mp, ud, gd, nb, ni, f) \
-	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, nb, ni, \
-				f | XFS_QMOPT_RES_REGBLKS)
-
-extern int xfs_qm_dqcheck(struct xfs_mount *, xfs_disk_dquot_t *,
-				xfs_dqid_t, uint, uint, char *);
-extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
-
-extern const struct xfs_buf_ops xfs_dquot_buf_ops;
-
-#endif	/* __KERNEL__ */
-#endif	/* __XFS_QUOTA_H__ */
diff --git a/include/xfs_quota_defs.h b/include/xfs_quota_defs.h
new file mode 100644
index 0000000..2460f59
--- /dev/null
+++ b/include/xfs_quota_defs.h
@@ -0,0 +1,143 @@
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
+ * In the worst case, when both user and group quotas are on,
+ * we can have a max of three dquots changing in a single transaction.
+ */
+#define XFS_DQUOT_LOGRES(mp)	(sizeof(xfs_disk_dquot_t) * 3)
+
+/*
+ * Quota Accounting/Enforcement flags
+ */
+
+#define XFS_IS_QUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
+#define XFS_IS_UQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_UQUOTA_ACCT)
+#define XFS_IS_PQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_PQUOTA_ACCT)
+#define XFS_IS_GQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_GQUOTA_ACCT)
+#define XFS_IS_UQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_UQUOTA_ENFD)
+#define XFS_IS_OQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_OQUOTA_ENFD)
+
+/*
+ * Incore only flags for quotaoff - these bits get cleared when quota(s)
+ * are in the process of getting turned off. These flags are in m_qflags but
+ * never in sb_qflags.
+ */
+#define XFS_UQUOTA_ACTIVE	0x0100  /* uquotas are being turned off */
+#define XFS_PQUOTA_ACTIVE	0x0200  /* pquotas are being turned off */
+#define XFS_GQUOTA_ACTIVE	0x0400  /* gquotas are being turned off */
+#define XFS_ALL_QUOTA_ACTIVE	\
+	(XFS_UQUOTA_ACTIVE | XFS_PQUOTA_ACTIVE | XFS_GQUOTA_ACTIVE)
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
+
+#endif /* __XFS_QUOTA_DEFS_H__ */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
