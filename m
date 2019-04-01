Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46712 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730089AbfDARLK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 13:11:10 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x31H9Hjm134155
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:11:09 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2rhwyd0gnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 01 Apr 2019 17:11:08 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x31HB7Ep017868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:11:07 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x31HB75q012215
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:11:07 GMT
Subject: [PATCH 08/10] xfs: report inode health via bulkstat
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Apr 2019 10:11:02 -0700
Message-ID: <155413866259.4966.15271041361179138786.stgit@magnolia>
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

Use space in the bulkstat ioctl structure to report any problems
observed with the inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h     |   13 ++++++++++++-
 fs/xfs/libxfs/xfs_health.h |    1 +
 fs/xfs/xfs_health.c        |   27 +++++++++++++++++++++++++++
 fs/xfs/xfs_itable.c        |    2 ++
 4 files changed, 42 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index dc2c538e6b92..fffaead718a5 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -346,13 +346,24 @@ typedef struct xfs_bstat {
 #define	bs_projid	bs_projid_lo	/* (previously just bs_projid)	*/
 	__u16		bs_forkoff;	/* inode fork offset in bytes	*/
 	__u16		bs_projid_hi;	/* higher part of project id	*/
-	unsigned char	bs_pad[6];	/* pad space, unused		*/
+	uint16_t	bs_health;	/* sick inode metadata		*/
+	unsigned char	bs_pad[4];	/* pad space, unused		*/
 	__u32		bs_cowextsize;	/* cow extent size		*/
 	__u32		bs_dmevmask;	/* DMIG event mask		*/
 	__u16		bs_dmstate;	/* DMIG state info		*/
 	__u16		bs_aextents;	/* attribute number of extents	*/
 } xfs_bstat_t;
 
+/* bs_health flags */
+#define XFS_BS_HEALTH_INODE	(1 << 0)  /* inode core */
+#define XFS_BS_HEALTH_BMBTD	(1 << 1)  /* data fork */
+#define XFS_BS_HEALTH_BMBTA	(1 << 2)  /* attr fork */
+#define XFS_BS_HEALTH_BMBTC	(1 << 3)  /* cow fork */
+#define XFS_BS_HEALTH_DIR	(1 << 4)  /* directory */
+#define XFS_BS_HEALTH_XATTR	(1 << 5)  /* extended attributes */
+#define XFS_BS_HEALTH_SYMLINK	(1 << 6)  /* symbolic link remote target */
+#define XFS_BS_HEALTH_PARENT	(1 << 7)  /* parent pointers */
+
 /*
  * Project quota id helpers (previously projid was 16bit only
  * and using two 16bit values to hold new 32bit projid was choosen
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 2d3b879da9b5..a6446d1dd8a7 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -204,5 +204,6 @@ xfs_inode_healthy(struct xfs_inode *ip)
 void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_mount *mp, xfs_agnumber_t agno,
 		struct xfs_ag_geometry *ageo);
+void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bstat *bs);
 
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 5ca471bd41ad..1c9b71949410 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -316,3 +316,30 @@ xfs_ag_geom_health(
 		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_REFCNTBT;
 	xfs_perag_put(pag);
 }
+
+/* Fill out bulkstat health info. */
+void
+xfs_bulkstat_health(
+	struct xfs_inode	*ip,
+	struct xfs_bstat	*bs)
+{
+	unsigned int		sick = xfs_inode_measure_sickness(ip);
+
+	bs->bs_health = 0;
+	if (sick & XFS_HEALTH_INO_CORE)
+		bs->bs_health |= XFS_BS_HEALTH_INODE;
+	if (sick & XFS_HEALTH_INO_BMBTD)
+		bs->bs_health |= XFS_BS_HEALTH_BMBTD;
+	if (sick & XFS_HEALTH_INO_BMBTA)
+		bs->bs_health |= XFS_BS_HEALTH_BMBTA;
+	if (sick & XFS_HEALTH_INO_BMBTC)
+		bs->bs_health |= XFS_BS_HEALTH_BMBTC;
+	if (sick & XFS_HEALTH_INO_DIR)
+		bs->bs_health |= XFS_BS_HEALTH_DIR;
+	if (sick & XFS_HEALTH_INO_XATTR)
+		bs->bs_health |= XFS_BS_HEALTH_XATTR;
+	if (sick & XFS_HEALTH_INO_SYMLINK)
+		bs->bs_health |= XFS_BS_HEALTH_SYMLINK;
+	if (sick & XFS_HEALTH_INO_PARENT)
+		bs->bs_health |= XFS_BS_HEALTH_PARENT;
+}
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 1861289bf823..cff28ee73deb 100644
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
