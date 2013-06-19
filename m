Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0765829E7E
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:52:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8819DAC005
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:52:43 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YU7niYB1vor1lCF0 for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:52:40 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpANf-00030H-TJ
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:28 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpANf-00006Z-Q6
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 38/60] xfs: separate dquot on disk format definitions out of
	xfs_quota.h
Date: Wed, 19 Jun 2013 14:50:46 +1000
Message-Id: <1371617468-32559-39-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_dquot_format.h |  132 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_quota.h        |  114 +--------------------------------------
 2 files changed, 134 insertions(+), 112 deletions(-)
 create mode 100644 fs/xfs/xfs_dquot_format.h

diff --git a/fs/xfs/xfs_dquot_format.h b/fs/xfs/xfs_dquot_format.h
new file mode 100644
index 0000000..f34615b
--- /dev/null
+++ b/fs/xfs/xfs_dquot_format.h
@@ -0,0 +1,132 @@
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
+#ifndef __XFS_DQUOT_FORMAT_H__
+#define __XFS_DQUOT_FORMAT_H__
+
+/*
+ * The ondisk form of a dquot structure.
+ */
+#define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
+#define XFS_DQUOT_VERSION	(u_int8_t)0x01	/* latest version number */
+
+/*
+ * uid_t and gid_t are hard-coded to 32 bits in the inode.
+ * Hence, an 'id' in a dquot is 32 bits..
+ */
+typedef __uint32_t	xfs_dqid_t;
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
+/*
+ * These are the structures used to lay out dquots and quotaoff
+ * records on the log. Quite similar to those of inodes.
+ */
+
+/*
+ * log format struct for dquots.
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
+/*
+ * Disk quotas status in m_qflags, sb_qflags and xfs_qoff_logformat. 16 bits.
+ */
+#define XFS_UQUOTA_ACCT	0x0001  /* user quota accounting ON */
+#define XFS_UQUOTA_ENFD	0x0002  /* user quota limits enforced */
+#define XFS_UQUOTA_CHKD	0x0004  /* quotacheck run on usr quotas */
+#define XFS_PQUOTA_ACCT	0x0008  /* project quota accounting ON */
+#define XFS_OQUOTA_ENFD	0x0010  /* other (grp/prj) quota limits enforced */
+#define XFS_OQUOTA_CHKD	0x0020  /* quotacheck run on other (grp/prj) quotas */
+#define XFS_GQUOTA_ACCT	0x0040  /* group quota accounting ON */
+
+#define XFS_ALL_QUOTA_ACCT	\
+		(XFS_UQUOTA_ACCT | XFS_GQUOTA_ACCT | XFS_PQUOTA_ACCT)
+#define XFS_ALL_QUOTA_ENFD	(XFS_UQUOTA_ENFD | XFS_OQUOTA_ENFD)
+#define XFS_ALL_QUOTA_CHKD	(XFS_UQUOTA_CHKD | XFS_OQUOTA_CHKD)
+
+#endif /* __XFS_DQUOT_FORMAT_H__ */
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index c38068f..634132d 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -18,19 +18,9 @@
 #ifndef __XFS_QUOTA_H__
 #define __XFS_QUOTA_H__
 
-struct xfs_trans;
-
-/*
- * The ondisk form of a dquot structure.
- */
-#define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
-#define XFS_DQUOT_VERSION	(u_int8_t)0x01	/* latest version number */
+#include "xfs_dquot_format.h"
 
-/*
- * uid_t and gid_t are hard-coded to 32 bits in the inode.
- * Hence, an 'id' in a dquot is 32 bits..
- */
-typedef __uint32_t	xfs_dqid_t;
+struct xfs_trans;
 
 /*
  * Even though users may not have quota limits occupying all 64-bits,
@@ -41,55 +31,6 @@ typedef __uint64_t	xfs_qcnt_t;
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
-#define XFS_DQUOT_CRC_OFF	offsetof(struct xfs_dqblk, dd_crc)
-
-/*
  * flags for q_flags field in the dquot.
  */
 #define XFS_DQ_USER		0x0001		/* a user quota */
@@ -113,60 +54,9 @@ typedef struct xfs_dqblk {
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
 /*
  * Quota Accounting/Enforcement flags
  */
-#define XFS_ALL_QUOTA_ACCT	\
-		(XFS_UQUOTA_ACCT | XFS_GQUOTA_ACCT | XFS_PQUOTA_ACCT)
-#define XFS_ALL_QUOTA_ENFD	(XFS_UQUOTA_ENFD | XFS_OQUOTA_ENFD)
-#define XFS_ALL_QUOTA_CHKD	(XFS_UQUOTA_CHKD | XFS_OQUOTA_CHKD)
 
 #define XFS_IS_QUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
 #define XFS_IS_UQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_UQUOTA_ACCT)
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
