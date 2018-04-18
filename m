Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51666 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCqK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:46:10 -0400
Subject: [PATCH 3/9] mkfs: use geometry generation / helper functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:45:42 -0700
Message-ID: <152401954281.13048.8462957622341585756.stgit@magnolia>
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

Since libxfs now has a function to fill out the geometry structure
and libfrog has a function to pretty-print the geometry, have mkfs
use the two helpers instead of open-coding it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/xfs_mkfs.c          |   54 ++++++++++++++--------------------------------
 2 files changed, 18 insertions(+), 37 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 78daca0..09f1428 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -152,5 +152,6 @@
 #define xfs_rmap_compare		libxfs_rmap_compare
 #define xfs_dir_get_ops			libxfs_dir_get_ops
 #define xfs_default_ifork_ops		libxfs_default_ifork_ops
+#define xfs_fs_geometry			libxfs_fs_geometry
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 78d0ce5..81f2123 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -20,7 +20,7 @@
 #include <ctype.h>
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
-
+#include "fsgeom.h"
 
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
@@ -3172,40 +3172,6 @@ initialise_mount(
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 }
 
-static void
-print_mkfs_cfg(
-	struct mkfs_params	*cfg,
-	char			*dfile,
-	char			*logfile,
-	char			*rtfile)
-{
-	struct sb_feat_args	*fp = &cfg->sb_feat;
-
-	printf(_(
-"meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
-"         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
-"         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
-"data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
-"         =%-22s sunit=%-6u swidth=%u blks\n"
-"naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
-"log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
-"         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
-"realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
-		dfile, cfg->inodesize, (long long)cfg->agcount,
-			(long long)cfg->agsize,
-		"", cfg->sectorsize, fp->attr_version, fp->projid32bit,
-		"", fp->crcs_enabled, fp->finobt, fp->spinodes, fp->rmapbt,
-			fp->reflink,
-		"", cfg->blocksize, (long long)cfg->dblocks, cfg->imaxpct,
-		"", cfg->dsunit, cfg->dswidth,
-		fp->dir_version, cfg->dirblocksize, fp->nci, fp->dirftype,
-		logfile, cfg->blocksize, (long long)cfg->logblocks,
-			fp->log_version,
-		"", cfg->lsectorsize, cfg->lsunit, fp->lazy_sb_counters,
-		rtfile, (int)cfg->rtextblocks << cfg->blocklog,
-			(long long)cfg->rtblocks, (long long)cfg->rtextents);
-}
-
 /*
  * Format everything from the generated config into the superblock that
  * will be used to initialise the on-disk superblock. This is the in-memory
@@ -3967,12 +3933,26 @@ main(
 	 */
 	calculate_log_size(&cfg, &cli, mp);
 
+	finish_superblock_setup(&cfg, mp, sbp);
+
+	/* Print the intended geometry of the fs. */
 	if (!quiet || dry_run) {
-		print_mkfs_cfg(&cfg, dfile, logfile, rtfile);
+		struct xfs_fsop_geom	geo;
+		int			error;
+
+		error = -libxfs_fs_geometry(sbp, &geo,
+				XFS_FS_GEOM_MAX_STRUCT_VER);
+		if (error) {
+			fprintf(stderr,
+	_("%s: failed to generate filesystem geometry\n"),
+				progname);
+			exit(1);
+		}
+
+		xfs_report_geom(&geo, dfile, logfile, rtfile);
 		if (dry_run)
 			exit(0);
 	}
-	finish_superblock_setup(&cfg, mp, sbp);
 
 	/*
 	 * we need the libxfs buffer cache from here on in.

