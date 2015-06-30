Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 206067F9B
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 22:26:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F246B304039
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:26:34 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id LjIXyeuG1WOtX0ae (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 20:26:33 -0700 (PDT)
Subject: [PATCH 08/15] xfs_growfs: report the presence of the reflink feature
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 20:26:30 -0700
Message-ID: <20150630032630.572.41612.stgit@birch.djwong.org>
In-Reply-To: <20150630032538.572.20293.stgit@birch.djwong.org>
References: <20150630032538.572.20293.stgit@birch.djwong.org>
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
 growfs/xfs_growfs.c |   14 +++++++++-----
 libxfs/xfs_fs.h     |    1 +
 2 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 4a344fe..362d499 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -58,12 +58,13 @@ report_info(
 	int		cimode,
 	int		ftype_enabled,
 	int		finobt_enabled,
-	int		spinodes)
+	int		spinodes,
+	int		reflink_enabled)
 {
 	printf(_(
 	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
 	    "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
-	    "         =%-22s crc=%-8u finobt=%u spinodes=%u\n"
+	    "         =%-22s crc=%-8u finobt=%u spinodes=%u reflink=%u\n"
 	    "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 	    "         =%-22s sunit=%-6u swidth=%u blks\n"
 	    "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
@@ -73,7 +74,7 @@ report_info(
 
 		mntpoint, geo.inodesize, geo.agcount, geo.agblocks,
 		"", geo.sectsize, attrversion, projid32bit,
-		"", crcs_enabled, finobt_enabled, spinodes,
+		"", crcs_enabled, finobt_enabled, spinodes, reflink_enabled,
 		"", geo.blocksize, (unsigned long long)geo.datablocks,
 			geo.imaxpct,
 		"", geo.sunit, geo.swidth,
@@ -127,6 +128,7 @@ main(int argc, char **argv)
 	int			ftype_enabled = 0;
 	int			finobt_enabled;	/* free inode btree */
 	int			spinodes;
+	int			reflink_enabled;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -250,11 +252,13 @@ main(int argc, char **argv)
 	ftype_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_FTYPE ? 1 : 0;
 	finobt_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_FINOBT ? 1 : 0;
 	spinodes = geo.flags & XFS_FSOP_GEOM_FLAGS_SPINODES ? 1 : 0;
+	reflink_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_REFLINK ? 1 : 0;
 	if (nflag) {
 		report_info(geo, datadev, isint, logdev, rtdev,
 				lazycount, dirversion, logversion,
 				attrversion, projid32bit, crcs_enabled, ci,
-				ftype_enabled, finobt_enabled, spinodes);
+				ftype_enabled, finobt_enabled, spinodes,
+				reflink_enabled);
 		exit(0);
 	}
 
@@ -292,7 +296,7 @@ main(int argc, char **argv)
 	report_info(geo, datadev, isint, logdev, rtdev,
 			lazycount, dirversion, logversion,
 			attrversion, projid32bit, crcs_enabled, ci, ftype_enabled,
-			finobt_enabled, spinodes);
+			finobt_enabled, spinodes, reflink_enabled);
 
 	ddsize = xi.dsize;
 	dlsize = ( xi.logBBsize? xi.logBBsize :
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 0c922ad..1ce122f 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -240,6 +240,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */
 #define XFS_FSOP_GEOM_FLAGS_FINOBT	0x20000	/* free inode btree */
 #define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
+#define XFS_FSOP_GEOM_FLAGS_REFLINK	0x100000 /* reflink */
 
 /*
  * Minimum and maximum sizes need for growth checks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
