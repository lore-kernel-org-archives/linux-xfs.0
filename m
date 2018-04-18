Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51968 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbeDRCqq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:46:46 -0400
Subject: [PATCH 9/9] xfs_growfs: refactor geometry reporting
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:46:27 -0700
Message-ID: <152401958770.13048.16460296024921613094.stgit@magnolia>
In-Reply-To: <152401952391.13048.15040850425873030425.stgit@magnolia>
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the new geometry pretty-printing function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 growfs/xfs_growfs.c |   88 +--------------------------------------------------
 1 file changed, 2 insertions(+), 86 deletions(-)


diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 366176b..8ec445a 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -18,6 +18,7 @@
 
 #include "libxfs.h"
 #include "path.h"
+#include "fsgeom.h"
 
 static void
 usage(void)
@@ -42,54 +43,6 @@ Options:\n\
 	exit(2);
 }
 
-void
-report_info(
-	xfs_fsop_geom_t	geo,
-	char		*mntpoint,
-	int		isint,
-	char		*logname,
-	char		*rtname,
-	int		lazycount,
-	int		dirversion,
-	int		logversion,
-	int		attrversion,
-	int		projid32bit,
-	int		crcs_enabled,
-	int		cimode,
-	int		ftype_enabled,
-	int		finobt_enabled,
-	int		spinodes,
-	int		rmapbt_enabled,
-	int		reflink_enabled)
-{
-	printf(_(
-	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
-	    "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
-	    "         =%-22s crc=%-8u finobt=%u spinodes=%u rmapbt=%u\n"
-	    "         =%-22s reflink=%u\n"
-	    "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
-	    "         =%-22s sunit=%-6u swidth=%u blks\n"
-	    "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
-	    "log      =%-22s bsize=%-6u blocks=%u, version=%u\n"
-	    "         =%-22s sectsz=%-5u sunit=%u blks, lazy-count=%u\n"
-	    "realtime =%-22s extsz=%-6u blocks=%llu, rtextents=%llu\n"),
-
-		mntpoint, geo.inodesize, geo.agcount, geo.agblocks,
-		"", geo.sectsize, attrversion, projid32bit,
-		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
-		"", reflink_enabled,
-		"", geo.blocksize, (unsigned long long)geo.datablocks,
-			geo.imaxpct,
-		"", geo.sunit, geo.swidth,
-  		dirversion, geo.dirblocksize, cimode, ftype_enabled,
-		isint ? _("internal") : logname ? logname : _("external"),
-			geo.blocksize, geo.logblocks, logversion,
-		"", geo.logsectsize, geo.logsunit / geo.blocksize, lazycount,
-		!geo.rtblocks ? _("none") : rtname ? rtname : _("external"),
-		geo.rtextsize * geo.blocksize, (unsigned long long)geo.rtblocks,
-			(unsigned long long)geo.rtextents);
-}
-
 int
 main(int argc, char **argv)
 {
@@ -97,9 +50,6 @@ main(int argc, char **argv)
 	int			c;	/* current option character */
 	long long		ddsize;	/* device size in 512-byte blocks */
 	int			dflag;	/* -d flag */
-	int			attrversion;/* attribute version number */
-	int			dirversion; /* directory version number */
-	int			logversion; /* log version number */
 	long long		dlsize;	/* device size in 512-byte blocks */
 	long long		drsize;	/* device size in 512-byte blocks */
 	long long		dsize;	/* new data size in fs blocks */
@@ -117,8 +67,6 @@ main(int argc, char **argv)
 	xfs_fsop_geom_t		ngeo;	/* new fs geometry */
 	int			rflag;	/* -r flag */
 	long long		rsize;	/* new rt size in fs blocks */
-	int			ci;	/* ASCII case-insensitive fs */
-	int			lazycount; /* lazy superblock counters */
 	int			xflag;	/* -x flag */
 	char			*fname;	/* mount point name */
 	char			*datadev; /* data device name */
@@ -126,13 +74,6 @@ main(int argc, char **argv)
 	char			*rtdev;	/*   RT device name */
 	fs_path_t		*fs;	/* mount point information */
 	libxfs_init_t		xi;	/* libxfs structure */
-	int			projid32bit;
-	int			crcs_enabled;
-	int			ftype_enabled = 0;
-	int			finobt_enabled;	/* free inode btree */
-	int			spinodes;
-	int			rmapbt_enabled;
-	int			reflink_enabled;
 	char			rpath[PATH_MAX];
 
 	progname = basename(argv[0]);
@@ -253,27 +194,6 @@ main(int argc, char **argv)
 		}
 	}
 	isint = geo.logstart > 0;
-	lazycount = geo.flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
-	dirversion = geo.flags & XFS_FSOP_GEOM_FLAGS_DIRV2 ? 2 : 1;
-	logversion = geo.flags & XFS_FSOP_GEOM_FLAGS_LOGV2 ? 2 : 1;
-	attrversion = geo.flags & XFS_FSOP_GEOM_FLAGS_ATTR2 ? 2 : \
-			(geo.flags & XFS_FSOP_GEOM_FLAGS_ATTR ? 1 : 0);
-	ci = geo.flags & XFS_FSOP_GEOM_FLAGS_DIRV2CI ? 1 : 0;
-	projid32bit = geo.flags & XFS_FSOP_GEOM_FLAGS_PROJID32 ? 1 : 0;
-	crcs_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_V5SB ? 1 : 0;
-	ftype_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_FTYPE ? 1 : 0;
-	finobt_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_FINOBT ? 1 : 0;
-	spinodes = geo.flags & XFS_FSOP_GEOM_FLAGS_SPINODES ? 1 : 0;
-	rmapbt_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_RMAPBT ? 1 : 0;
-	reflink_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_REFLINK ? 1 : 0;
-	if (nflag) {
-		report_info(geo, datadev, isint, logdev, rtdev,
-				lazycount, dirversion, logversion,
-				attrversion, projid32bit, crcs_enabled, ci,
-				ftype_enabled, finobt_enabled, spinodes,
-				rmapbt_enabled, reflink_enabled);
-		exit(0);
-	}
 
 	/*
 	 * Need root access from here on (using raw devices)...
@@ -306,11 +226,7 @@ main(int argc, char **argv)
 		exit(1);
 	}
 
-	report_info(geo, datadev, isint, logdev, rtdev,
-			lazycount, dirversion, logversion,
-			attrversion, projid32bit, crcs_enabled, ci, ftype_enabled,
-			finobt_enabled, spinodes, rmapbt_enabled,
-			reflink_enabled);
+	xfs_report_geom(&geo, datadev, logdev, rtdev);
 
 	ddsize = xi.dsize;
 	dlsize = ( xi.logBBsize? xi.logBBsize :

