Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B0E9C29EDC
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:09:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2296FAC005
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:09:51 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id eYAf0Ih4Ts7TKfUI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:09:49 -0700 (PDT)
Subject: [PATCH 42/51] xfs_growfs: report the presence of the reflink feature
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:09:46 -0700
Message-ID: <20151007050946.1504.35739.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Report the presence of the reflink feature in xfs_info.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 growfs/xfs_growfs.c |   12 +++++++++---
 libxfs/xfs_fs.h     |    3 ++-
 2 files changed, 11 insertions(+), 4 deletions(-)


diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 2b46480..a294e14 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -59,12 +59,14 @@ report_info(
 	int		ftype_enabled,
 	int		finobt_enabled,
 	int		spinodes,
-	int		rmapbt_enabled)
+	int		rmapbt_enabled,
+	int		reflink_enabled)
 {
 	printf(_(
 	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
 	    "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 	    "         =%-22s crc=%-8u finobt=%u spinodes=%u rmapbt=%u\n"
+	    "         =%-22s reflink=%u\n"
 	    "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 	    "         =%-22s sunit=%-6u swidth=%u blks\n"
 	    "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
@@ -75,6 +77,7 @@ report_info(
 		mntpoint, geo.inodesize, geo.agcount, geo.agblocks,
 		"", geo.sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
+		"", reflink_enabled,
 		"", geo.blocksize, (unsigned long long)geo.datablocks,
 			geo.imaxpct,
 		"", geo.sunit, geo.swidth,
@@ -129,6 +132,7 @@ main(int argc, char **argv)
 	int			finobt_enabled;	/* free inode btree */
 	int			spinodes;
 	int			rmapbt_enabled;
+	int			reflink_enabled;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -253,12 +257,13 @@ main(int argc, char **argv)
 	finobt_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_FINOBT ? 1 : 0;
 	spinodes = geo.flags & XFS_FSOP_GEOM_FLAGS_SPINODES ? 1 : 0;
 	rmapbt_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_RMAPBT ? 1 : 0;
+	reflink_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_REFLINK ? 1 : 0;
 	if (nflag) {
 		report_info(geo, datadev, isint, logdev, rtdev,
 				lazycount, dirversion, logversion,
 				attrversion, projid32bit, crcs_enabled, ci,
 				ftype_enabled, finobt_enabled, spinodes,
-				rmapbt_enabled);
+				rmapbt_enabled, reflink_enabled);
 		exit(0);
 	}
 
@@ -296,7 +301,8 @@ main(int argc, char **argv)
 	report_info(geo, datadev, isint, logdev, rtdev,
 			lazycount, dirversion, logversion,
 			attrversion, projid32bit, crcs_enabled, ci, ftype_enabled,
-			finobt_enabled, spinodes, rmapbt_enabled);
+			finobt_enabled, spinodes, rmapbt_enabled,
+			reflink_enabled);
 
 	ddsize = xi.dsize;
 	dlsize = ( xi.logBBsize? xi.logBBsize :
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index b17ccd5..0dcffc8 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -241,7 +241,8 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */
 #define XFS_FSOP_GEOM_FLAGS_FINOBT	0x20000	/* free inode btree */
 #define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
-#define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000 /* reverse-mapping btree */
+#define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000	/* reverse mapping btree */
+#define XFS_FSOP_GEOM_FLAGS_REFLINK	0x100000 /* files can share blocks */
 
 /*
  * Minimum and maximum sizes need for growth checks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
