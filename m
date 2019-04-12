Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51070 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfDLG3A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Apr 2019 02:29:00 -0400
Subject: [PATCH 8/8] xfs: report inode health via bulkstat
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Apr 2019 23:28:53 -0700
Message-ID: <155505053385.1279757.16593553961664870857.stgit@magnolia>
In-Reply-To: <155505048097.1279757.13952335054480511366.stgit@magnolia>
References: <155505048097.1279757.13952335054480511366.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Use space in the bulkstat ioctl structure to report any problems
observed with the inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_fs.h     |   14 +++++++++++++-
 fs/xfs/libxfs/xfs_health.h |    1 +
 fs/xfs/xfs_health.c        |   34 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_itable.c        |    2 ++
 4 files changed, 50 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 35d60f8017cd..43a53b03247b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -349,13 +349,25 @@ typedef struct xfs_bstat {
 #define	bs_projid	bs_projid_lo	/* (previously just bs_projid)	*/
 	__u16		bs_forkoff;	/* inode fork offset in bytes	*/
 	__u16		bs_projid_hi;	/* higher part of project id	*/
-	unsigned char	bs_pad[6];	/* pad space, unused		*/
+	uint16_t	bs_sick;	/* sick inode metadata		*/
+	uint16_t	bs_checked;	/* checked inode metadata	*/
+	unsigned char	bs_pad[2];	/* pad space, unused		*/
 	__u32		bs_cowextsize;	/* cow extent size		*/
 	__u32		bs_dmevmask;	/* DMIG event mask		*/
 	__u16		bs_dmstate;	/* DMIG state info		*/
 	__u16		bs_aextents;	/* attribute number of extents	*/
 } xfs_bstat_t;
 
+/* bs_sick flags */
+#define XFS_BS_SICK_INODE	(1 << 0)  /* inode core */
+#define XFS_BS_SICK_BMBTD	(1 << 1)  /* data fork */
+#define XFS_BS_SICK_BMBTA	(1 << 2)  /* attr fork */
+#define XFS_BS_SICK_BMBTC	(1 << 3)  /* cow fork */
+#define XFS_BS_SICK_DIR		(1 << 4)  /* directory */
+#define XFS_BS_SICK_XATTR	(1 << 5)  /* extended attributes */
+#define XFS_BS_SICK_SYMLINK	(1 << 6)  /* symbolic link remote target */
+#define XFS_BS_SICK_PARENT	(1 << 7)  /* parent pointers */
+
 /*
  * Project quota id helpers (previously projid was 16bit only
  * and using two 16bit values to hold new 32bit projid was choosen
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index e392457023a4..49ddfeac19f2 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -185,5 +185,6 @@ xfs_inode_is_healthy(struct xfs_inode *ip)
 
 void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
+void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bstat *bs);
 
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 5431c4070f27..4c4929f9e7bf 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -356,3 +356,37 @@ xfs_ag_geom_health(
 			ageo->ag_sick |= m->ioctl_mask;
 	}
 }
+
+static const struct ioctl_sick_map ino_map[] = {
+	{ XFS_SICK_INO_CORE,	XFS_BS_SICK_INODE },
+	{ XFS_SICK_INO_BMBTD,	XFS_BS_SICK_BMBTD },
+	{ XFS_SICK_INO_BMBTA,	XFS_BS_SICK_BMBTA },
+	{ XFS_SICK_INO_BMBTC,	XFS_BS_SICK_BMBTC },
+	{ XFS_SICK_INO_DIR,	XFS_BS_SICK_DIR },
+	{ XFS_SICK_INO_XATTR,	XFS_BS_SICK_XATTR },
+	{ XFS_SICK_INO_SYMLINK,	XFS_BS_SICK_SYMLINK },
+	{ XFS_SICK_INO_PARENT,	XFS_BS_SICK_PARENT },
+	{ 0, 0 },
+};
+
+/* Fill out bulkstat health info. */
+void
+xfs_bulkstat_health(
+	struct xfs_inode		*ip,
+	struct xfs_bstat		*bs)
+{
+	const struct ioctl_sick_map	*m;
+	unsigned int			sick;
+	unsigned int			checked;
+
+	bs->bs_sick = 0;
+	bs->bs_checked = 0;
+
+	xfs_inode_measure_sickness(ip, &sick, &checked);
+	for (m = ino_map; m->sick_mask; m++) {
+		if (checked & m->sick_mask)
+			bs->bs_checked |= m->ioctl_mask;
+		if (sick & m->sick_mask)
+			bs->bs_sick |= m->ioctl_mask;
+	}
+}
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 942e4aa5e729..1e1a0af1dd34 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -18,6 +18,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_health.h"
 
 /*
  * Return stat information for one inode.
@@ -84,6 +85,7 @@ xfs_bulkstat_one_int(
 	buf->bs_extsize = dic->di_extsize << mp->m_sb.sb_blocklog;
 	buf->bs_extents = dic->di_nextents;
 	memset(buf->bs_pad, 0, sizeof(buf->bs_pad));
+	xfs_bulkstat_health(ip, buf);
 	buf->bs_dmevmask = dic->di_dmevmask;
 	buf->bs_dmstate = dic->di_dmstate;
 	buf->bs_aextents = dic->di_anextents;
