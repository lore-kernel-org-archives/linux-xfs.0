Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 72C768058
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 551FF304039
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:48 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	5UFoi6z78G0JPuyv for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:46 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RS-0004If-V9
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RS-0002Ke-Tu
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 20/49] xfs: separate dquot on disk format definitions out of
	xfs_quota.h
Date: Fri, 19 Jul 2013 16:44:55 +1000
Message-Id: <1374216324-8781-21-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-1-git-send-email-david@fromorbit.com>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
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

The on disk format definitions of the on-disk dquot, log formats and
quota off log formats are all intertwined with other definitions for
quotas. Separate them out into their own header file so they can
easily be shared with userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile         |   1 +
 include/libxfs.h         |   1 +
 include/xfs_format.h     |  86 +++++++++++++++++++++++++++++++++++
 include/xfs_log_format.h |  58 ++++++++++++++++++++++++
 include/xfs_quota.h      | 114 -----------------------------------------------
 include/xfs_types.h      |   6 +++
 6 files changed, 152 insertions(+), 114 deletions(-)
 create mode 100644 include/xfs_format.h

diff --git a/include/Makefile b/include/Makefile
index ad2ac46..8f738a8 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -27,6 +27,7 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_cksum.h \
 	xfs_da_btree.h \
 	xfs_dinode.h xfs_dir2.h xfs_dir2_format.h \
+	xfs_format.h \
 	xfs_ialloc.h \
 	xfs_ialloc_btree.h \
 	xfs_icreate_item.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index 40e5e25..646ca79 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -37,6 +37,7 @@
 #include <xfs/xfs_fs.h>
 #include <xfs/xfs_arch.h>
 
+#include <xfs/xfs_format.h>
 #include <xfs/xfs_log_format.h>
 
 #include <xfs/xfs_bit.h>
diff --git a/include/xfs_format.h b/include/xfs_format.h
new file mode 100644
index 0000000..2b4f166
--- /dev/null
+++ b/include/xfs_format.h
@@ -0,0 +1,86 @@
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
+#ifndef __XFS_FORMAT_H__
+#define __XFS_FORMAT_H__
+
+/*
+ * XFS On Disk Format Definitions
+ *
+ * This header file defines all the on-disk format definitions for 
+ * general XFS objects. Directory and attribute related objects are defined in
+ * xfs_da_format.h, which log and log item formats are defined in
+ * xfs_log_format.h. Everything else goes here.
+ */
+
+/*
+ * Dquot and dquot block format definitions
+ */
+#define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
+#define XFS_DQUOT_VERSION	(u_int8_t)0x01	/* latest version number */
+
+/*
+ * This is the main portion of the on-disk representation of quota
+ * information for a user. This is the q_core of the xfs_dquot_t that
+ * is kept in kernel memory. We pad this with some more expansion room
+ * to construct the on disk structure.
+ */
+typedef struct	xfs_disk_dquot {
+	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
+	__u8		d_version;	/* dquot version */
+	__u8		d_flags;	/* XFS_DQ_USER/PROJ/GROUP */
+	__be32		d_id;		/* user,project,group id */
+	__be64		d_blk_hardlimit;/* absolute limit on disk blks */
+	__be64		d_blk_softlimit;/* preferred limit on disk blks */
+	__be64		d_ino_hardlimit;/* maximum # allocated inodes */
+	__be64		d_ino_softlimit;/* preferred inode limit */
+	__be64		d_bcount;	/* disk blocks owned by the user */
+	__be64		d_icount;	/* inodes owned by the user */
+	__be32		d_itimer;	/* zero if within inode limits if not,
+					   this is when we refuse service */
+	__be32		d_btimer;	/* similar to above; for disk blocks */
+	__be16		d_iwarns;	/* warnings issued wrt num inodes */
+	__be16		d_bwarns;	/* warnings issued wrt disk blocks */
+	__be32		d_pad0;		/* 64 bit align */
+	__be64		d_rtb_hardlimit;/* absolute limit on realtime blks */
+	__be64		d_rtb_softlimit;/* preferred limit on RT disk blks */
+	__be64		d_rtbcount;	/* realtime blocks owned */
+	__be32		d_rtbtimer;	/* similar to above; for RT disk blocks */
+	__be16		d_rtbwarns;	/* warnings issued wrt RT disk blocks */
+	__be16		d_pad;
+} xfs_disk_dquot_t;
+
+/*
+ * This is what goes on disk. This is separated from the xfs_disk_dquot because
+ * carrying the unnecessary padding would be a waste of memory.
+ */
+typedef struct xfs_dqblk {
+	xfs_disk_dquot_t  dd_diskdq;	/* portion that lives incore as well */
+	char		  dd_fill[4];	/* filling for posterity */
+
+	/*
+	 * These two are only present on filesystems with the CRC bits set.
+	 */
+	__be32		  dd_crc;	/* checksum */
+	__be64		  dd_lsn;	/* last modification in log */
+	uuid_t		  dd_uuid;	/* location information */
+} xfs_dqblk_t;
+
+#define XFS_DQUOT_CRC_OFF	offsetof(struct xfs_dqblk, dd_crc)
+
+
+#endif /* __XFS_FORMAT_H__ */
diff --git a/include/xfs_log_format.h b/include/xfs_log_format.h
index d1e93d3..5963ec7 100644
--- a/include/xfs_log_format.h
+++ b/include/xfs_log_format.h
@@ -544,4 +544,62 @@ typedef struct xfs_efd_log_format_64 {
 	xfs_extent_64_t		efd_extents[1];	/* array of extents freed */
 } xfs_efd_log_format_64_t;
 
+/*
+ * Dquot Log format definitions.
+ *
+ * The first two fields must be the type and size fitting into
+ * 32 bits : log_recovery code assumes that.
+ */
+typedef struct xfs_dq_logformat {
+	__uint16_t		qlf_type;      /* dquot log item type */
+	__uint16_t		qlf_size;      /* size of this item */
+	xfs_dqid_t		qlf_id;	       /* usr/grp/proj id : 32 bits */
+	__int64_t		qlf_blkno;     /* blkno of dquot buffer */
+	__int32_t		qlf_len;       /* len of dquot buffer */
+	__uint32_t		qlf_boffset;   /* off of dquot in buffer */
+} xfs_dq_logformat_t;
+
+/*
+ * log format struct for QUOTAOFF records.
+ * The first two fields must be the type and size fitting into
+ * 32 bits : log_recovery code assumes that.
+ * We write two LI_QUOTAOFF logitems per quotaoff, the last one keeps a pointer
+ * to the first and ensures that the first logitem is taken out of the AIL
+ * only when the last one is securely committed.
+ */
+typedef struct xfs_qoff_logformat {
+	unsigned short		qf_type;	/* quotaoff log item type */
+	unsigned short		qf_size;	/* size of this item */
+	unsigned int		qf_flags;	/* USR and/or GRP */
+	char			qf_pad[12];	/* padding for future */
+} xfs_qoff_logformat_t;
+
+
+/*
+ * Disk quotas status in m_qflags, and also sb_qflags. 16 bits.
+ */
+#define XFS_UQUOTA_ACCT	0x0001  /* user quota accounting ON */
+#define XFS_UQUOTA_ENFD	0x0002  /* user quota limits enforced */
+#define XFS_UQUOTA_CHKD	0x0004  /* quotacheck run on usr quotas */
+#define XFS_PQUOTA_ACCT	0x0008  /* project quota accounting ON */
+#define XFS_OQUOTA_ENFD	0x0010  /* other (grp/prj) quota limits enforced */
+#define XFS_OQUOTA_CHKD	0x0020  /* quotacheck run on other (grp/prj) quotas */
+#define XFS_GQUOTA_ACCT	0x0040  /* group quota accounting ON */
+
+/*
+ * Conversion to and from the combined OQUOTA flag (if necessary)
+ * is done only in xfs_sb_qflags_to_disk() and xfs_sb_qflags_from_disk()
+ */
+#define XFS_GQUOTA_ENFD	0x0080  /* group quota limits enforced */
+#define XFS_GQUOTA_CHKD	0x0100  /* quotacheck run on group quotas */
+#define XFS_PQUOTA_ENFD	0x0200  /* project quota limits enforced */
+#define XFS_PQUOTA_CHKD	0x0400  /* quotacheck run on project quotas */
+
+#define XFS_ALL_QUOTA_ACCT	\
+		(XFS_UQUOTA_ACCT | XFS_GQUOTA_ACCT | XFS_PQUOTA_ACCT)
+#define XFS_ALL_QUOTA_ENFD	\
+		(XFS_UQUOTA_ENFD | XFS_GQUOTA_ENFD | XFS_PQUOTA_ENFD)
+#define XFS_ALL_QUOTA_CHKD	\
+		(XFS_UQUOTA_CHKD | XFS_GQUOTA_CHKD | XFS_PQUOTA_CHKD)
+
 #endif /* __XFS_LOG_FORMAT_H__ */
diff --git a/include/xfs_quota.h b/include/xfs_quota.h
index c61e31c..18dadf6 100644
--- a/include/xfs_quota.h
+++ b/include/xfs_quota.h
@@ -21,18 +21,6 @@
 struct xfs_trans;
 
 /*
- * The ondisk form of a dquot structure.
- */
-#define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
-#define XFS_DQUOT_VERSION	(u_int8_t)0x01	/* latest version number */
-
-/*
- * uid_t and gid_t are hard-coded to 32 bits in the inode.
- * Hence, an 'id' in a dquot is 32 bits..
- */
-typedef __uint32_t	xfs_dqid_t;
-
-/*
  * Even though users may not have quota limits occupying all 64-bits,
  * they may need 64-bit accounting. Hence, 64-bit quota-counters,
  * and quota-limits. This is a waste in the common case, but hey ...
@@ -41,53 +29,6 @@ typedef __uint64_t	xfs_qcnt_t;
 typedef __uint16_t	xfs_qwarncnt_t;
 
 /*
- * This is the main portion of the on-disk representation of quota
- * information for a user. This is the q_core of the xfs_dquot_t that
- * is kept in kernel memory. We pad this with some more expansion room
- * to construct the on disk structure.
- */
-typedef struct	xfs_disk_dquot {
-	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
-	__u8		d_version;	/* dquot version */
-	__u8		d_flags;	/* XFS_DQ_USER/PROJ/GROUP */
-	__be32		d_id;		/* user,project,group id */
-	__be64		d_blk_hardlimit;/* absolute limit on disk blks */
-	__be64		d_blk_softlimit;/* preferred limit on disk blks */
-	__be64		d_ino_hardlimit;/* maximum # allocated inodes */
-	__be64		d_ino_softlimit;/* preferred inode limit */
-	__be64		d_bcount;	/* disk blocks owned by the user */
-	__be64		d_icount;	/* inodes owned by the user */
-	__be32		d_itimer;	/* zero if within inode limits if not,
-					   this is when we refuse service */
-	__be32		d_btimer;	/* similar to above; for disk blocks */
-	__be16		d_iwarns;	/* warnings issued wrt num inodes */
-	__be16		d_bwarns;	/* warnings issued wrt disk blocks */
-	__be32		d_pad0;		/* 64 bit align */
-	__be64		d_rtb_hardlimit;/* absolute limit on realtime blks */
-	__be64		d_rtb_softlimit;/* preferred limit on RT disk blks */
-	__be64		d_rtbcount;	/* realtime blocks owned */
-	__be32		d_rtbtimer;	/* similar to above; for RT disk blocks */
-	__be16		d_rtbwarns;	/* warnings issued wrt RT disk blocks */
-	__be16		d_pad;
-} xfs_disk_dquot_t;
-
-/*
- * This is what goes on disk. This is separated from the xfs_disk_dquot because
- * carrying the unnecessary padding would be a waste of memory.
- */
-typedef struct xfs_dqblk {
-	xfs_disk_dquot_t  dd_diskdq;	/* portion that lives incore as well */
-	char		  dd_fill[4];	/* filling for posterity */
-
-	/*
-	 * These two are only present on filesystems with the CRC bits set.
-	 */
-	__be32		  dd_crc;	/* checksum */
-	__be64		  dd_lsn;	/* last modification in log */
-	uuid_t		  dd_uuid;	/* location information */
-} xfs_dqblk_t;
-
-/*
  * flags for q_flags field in the dquot.
  */
 #define XFS_DQ_USER		0x0001		/* a user quota */
@@ -111,61 +52,6 @@ typedef struct xfs_dqblk {
  */
 #define XFS_DQUOT_LOGRES(mp)	(sizeof(xfs_disk_dquot_t) * 3)
 
-
-/*
- * These are the structures used to lay out dquots and quotaoff
- * records on the log. Quite similar to those of inodes.
- */
-
-/*
- * log format struct for dquots.
- * The first two fields must be the type and size fitting into
- * 32 bits : log_recovery code assumes that.
- */
-typedef struct xfs_dq_logformat {
-	__uint16_t		qlf_type;      /* dquot log item type */
-	__uint16_t		qlf_size;      /* size of this item */
-	xfs_dqid_t		qlf_id;	       /* usr/grp/proj id : 32 bits */
-	__int64_t		qlf_blkno;     /* blkno of dquot buffer */
-	__int32_t		qlf_len;       /* len of dquot buffer */
-	__uint32_t		qlf_boffset;   /* off of dquot in buffer */
-} xfs_dq_logformat_t;
-
-/*
- * log format struct for QUOTAOFF records.
- * The first two fields must be the type and size fitting into
- * 32 bits : log_recovery code assumes that.
- * We write two LI_QUOTAOFF logitems per quotaoff, the last one keeps a pointer
- * to the first and ensures that the first logitem is taken out of the AIL
- * only when the last one is securely committed.
- */
-typedef struct xfs_qoff_logformat {
-	unsigned short		qf_type;	/* quotaoff log item type */
-	unsigned short		qf_size;	/* size of this item */
-	unsigned int		qf_flags;	/* USR and/or GRP */
-	char			qf_pad[12];	/* padding for future */
-} xfs_qoff_logformat_t;
-
-
-/*
- * Disk quotas status in m_qflags, and also sb_qflags. 16 bits.
- */
-#define XFS_UQUOTA_ACCT	0x0001  /* user quota accounting ON */
-#define XFS_UQUOTA_ENFD	0x0002  /* user quota limits enforced */
-#define XFS_UQUOTA_CHKD	0x0004  /* quotacheck run on usr quotas */
-#define XFS_PQUOTA_ACCT	0x0008  /* project quota accounting ON */
-#define XFS_OQUOTA_ENFD	0x0010  /* other (grp/prj) quota limits enforced */
-#define XFS_OQUOTA_CHKD	0x0020  /* quotacheck run on other (grp/prj) quotas */
-#define XFS_GQUOTA_ACCT	0x0040  /* group quota accounting ON */
-
-/*
- * Quota Accounting/Enforcement flags
- */
-#define XFS_ALL_QUOTA_ACCT	\
-		(XFS_UQUOTA_ACCT | XFS_GQUOTA_ACCT | XFS_PQUOTA_ACCT)
-#define XFS_ALL_QUOTA_ENFD	(XFS_UQUOTA_ENFD | XFS_OQUOTA_ENFD)
-#define XFS_ALL_QUOTA_CHKD	(XFS_UQUOTA_CHKD | XFS_OQUOTA_CHKD)
-
 #define XFS_IS_QUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
 #define XFS_IS_UQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_UQUOTA_ACCT)
 #define XFS_IS_PQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_PQUOTA_ACCT)
diff --git a/include/xfs_types.h b/include/xfs_types.h
index 543fdf0..b144a8f 100644
--- a/include/xfs_types.h
+++ b/include/xfs_types.h
@@ -178,4 +178,10 @@ struct xfs_name {
 	int			len;
 };
 
+/*
+ * uid_t and gid_t are hard-coded to 32 bits in the inode.
+ * Hence, an 'id' in a dquot is 32 bits..
+ */
+typedef __uint32_t	xfs_dqid_t;
+
 #endif	/* __XFS_TYPES_H__ */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
