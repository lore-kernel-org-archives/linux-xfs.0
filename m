Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752214AbdEPRQi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 May 2017 13:16:38 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D84AC04BD2E
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2017 17:16:37 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52B66BC6AC
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2017 17:16:31 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH RFC] xfsprogs: consolidate filesystem info reporting
Message-ID: <361e6e5f-aa3a-9fa0-6948-e18b8b781a83@redhat.com>
Date: Tue, 16 May 2017 12:16:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

mkfs.xfs and xfs_growfs/xfs_info had /almost/ the same
output format, but not quite.  Differences included
"internal" vs "internal log," "spinodes" vs. "sparse,"
commas in one and not the other, etc.

xfs_growfs uses report_info() to encapsulate this printing;
sharing with mkfs is a little awkward because growfs is using
an xfs_fsop_geom_t geo to query a mounted filesystem, whereas
mkfs has an xfs superblock for an unmounted filesystem, so some
translation is needed.

This patch makes a new libxcmd/util.c file for the report_info
function, and uses it for both mkfs and xfs_growfs with minor
tweaks on each side for consistency.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I don't know if the console output for mkfs & growfs are considered
an informal API - if so, then this patch should just be ignored and
we'll have to live with the inconsistencies that are in the wild
already.

This is only lightly tested because I want to address the API aspect
of it before going off and writing tests, etc.

 growfs/xfs_growfs.c |   52 ++--------------------------------------
 include/libxcmd.h   |   19 +++++++++++++-
 libxcmd/Makefile    |    2 -
 libxcmd/util.c      |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c     |   50 ++++++++++++++++++++------------------
 5 files changed, 115 insertions(+), 75 deletions(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index a294e14..2ff33c1 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -17,6 +17,7 @@
  */
 
 #include "libxfs.h"
+#include "libxcmd.h"
 #include "path.h"
 
 static void
@@ -42,53 +43,6 @@ Options:\n\
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
 
 int
 main(int argc, char **argv)
@@ -259,7 +213,7 @@ main(int argc, char **argv)
 	rmapbt_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_RMAPBT ? 1 : 0;
 	reflink_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_REFLINK ? 1 : 0;
 	if (nflag) {
-		report_info(geo, datadev, isint, logdev, rtdev,
+		report_info(geo, datadev, logdev, rtdev,
 				lazycount, dirversion, logversion,
 				attrversion, projid32bit, crcs_enabled, ci,
 				ftype_enabled, finobt_enabled, spinodes,
@@ -298,7 +252,7 @@ main(int argc, char **argv)
 		exit(1);
 	}
 
-	report_info(geo, datadev, isint, logdev, rtdev,
+	report_info(geo, datadev, logdev, rtdev,
 			lazycount, dirversion, logversion,
 			attrversion, projid32bit, crcs_enabled, ci, ftype_enabled,
 			finobt_enabled, spinodes, rmapbt_enabled,
diff --git a/include/libxcmd.h b/include/libxcmd.h
index e8d2ffc..5635e8e 100644
--- a/include/libxcmd.h
+++ b/include/libxcmd.h
@@ -51,6 +51,23 @@ extern int
 check_overwrite(
 	const char	*device);
 
-
+extern void
+report_info(
+        xfs_fsop_geom_t geo,
+        char            *mntpoint,
+        char            *logname,
+        char            *rtname,
+        int             lazycount,
+        int             dirversion,
+        int             logversion,
+        int             attrversion,
+        int             projid32bit,
+        int             crcs_enabled,
+        int             cimode,
+        int             ftype_enabled,
+        int             finobt_enabled,
+        int             spinodes,
+        int             rmapbt_enabled,
+        int             reflink_enabled);
 
 #endif	/* __LIBXCMD_H__ */
diff --git a/libxcmd/Makefile b/libxcmd/Makefile
index aab8d6d..931dc7d 100644
--- a/libxcmd/Makefile
+++ b/libxcmd/Makefile
@@ -10,7 +10,7 @@ LT_CURRENT = 0
 LT_REVISION = 0
 LT_AGE = 0
 
-CFILES = command.c input.c paths.c projects.c help.c quit.c topology.c
+CFILES = command.c input.c paths.c projects.c help.c quit.c topology.c util.c
 
 ifeq ($(HAVE_GETMNTENT),yes)
 LCFLAGS += -DHAVE_GETMNTENT
diff --git a/libxcmd/util.c b/libxcmd/util.c
new file mode 100644
index 0000000..f9c3953
--- /dev/null
+++ b/libxcmd/util.c
@@ -0,0 +1,67 @@
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
+
+#include "libxfs.h"
+
+void
+report_info(
+	xfs_fsop_geom_t	geo,
+	char		*mntpoint,
+	char		*logname,
+	char		*rtname,
+	int		lazycount,
+	int		dirversion,
+	int		logversion,
+	int		attrversion,
+	int		projid32bit,
+	int		crcs_enabled,
+	int		cimode,
+	int		ftype_enabled,
+	int		finobt_enabled,
+	int		spinodes,
+	int		rmapbt_enabled,
+	int		reflink_enabled)
+{
+	printf(_(
+	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
+	    "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
+	    "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
+	    "         =%-22s reflink=%u\n"
+	    "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
+	    "         =%-22s sunit=%-6u swidth=%u blks\n"
+	    "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
+	    "log      =%-22s bsize=%-6u blocks=%u, version=%u\n"
+	    "         =%-22s sectsz=%-5u sunit=%u blks, lazy-count=%u\n"
+	    "realtime =%-22s extsz=%-6u blocks=%llu, rtextents=%llu\n"),
+
+		mntpoint, geo.inodesize, geo.agcount, geo.agblocks,
+		"", geo.sectsize, attrversion, projid32bit,
+		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
+		"", reflink_enabled,
+		"", geo.blocksize, (unsigned long long)geo.datablocks,
+			geo.imaxpct,
+		"", geo.sunit, geo.swidth,
+  		dirversion, geo.dirblocksize, cimode, ftype_enabled,
+		geo.logstart > 0 ? _("internal") : logname ?
+						logname : _("external"),
+			geo.blocksize, geo.logblocks, logversion,
+		"", geo.logsectsize, geo.logsunit / geo.blocksize, lazycount,
+		!geo.rtblocks ? _("none") : rtname ? rtname : _("external"),
+		geo.rtextsize * geo.blocksize, (unsigned long long)geo.rtblocks,
+			(unsigned long long)geo.rtextents);
+}
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 930f3d2..e11b4b4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2754,30 +2754,32 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	validate_log_size(logblocks, blocklog, min_logblocks);
 
 	if (!qflag || Nflag) {
-		printf(_(
-		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
-		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
-		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
-		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
-		   "         =%-22s sunit=%-6u swidth=%u blks\n"
-		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
-		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
-		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
-		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
-			dfile, isize, (long long)agcount, (long long)agsize,
-			"", sectorsize, sb_feat.attr_version,
-				    !sb_feat.projid16bit,
-			"", sb_feat.crcs_enabled, sb_feat.finobt, sb_feat.spinodes,
-			sb_feat.rmapbt, sb_feat.reflink,
-			"", blocksize, (long long)dblocks, imaxpct,
-			"", dsunit, dswidth,
-			sb_feat.dir_version, dirblocksize, sb_feat.nci,
-				sb_feat.dirftype,
-			logfile, 1 << blocklog, (long long)logblocks,
-			sb_feat.log_version, "", lsectorsize, lsunit,
-				sb_feat.lazy_sb_counters,
-			rtfile, rtextblocks << blocklog,
-			(long long)rtblocks, (long long)rtextents);
+		xfs_fsop_geom_t	geo;
+
+		geo.inodesize = isize;
+		geo.agcount = agcount;
+		geo.agblocks = agsize;
+		geo.sectsize = sectorsize;
+		geo.blocksize = blocksize;
+		geo.datablocks = dblocks;
+		geo.imaxpct = imaxpct;
+		geo.sunit = dsunit;
+		geo.swidth = dswidth;
+		geo.dirblocksize = dirblocksize;
+		geo.logstart = logstart;
+		geo.logblocks =	logblocks;
+		geo.logsectsize = lsectorsize;
+		geo.logsunit = lsunit;
+		geo.rtblocks = rtblocks;
+		geo.rtextsize = rtextblocks;
+		geo.rtextents = rtextents;
+
+		report_info(geo, dfile, logfile, rtfile,
+			    sb_feat.lazy_sb_counters, sb_feat.dir_version,
+			    sb_feat.log_version, sb_feat.attr_version,
+			    !sb_feat.projid16bit, sb_feat.crcs_enabled,
+			    sb_feat.nci, sb_feat.dirftype, sb_feat.finobt,
+			    sb_feat.spinodes, sb_feat.rmapbt, sb_feat.reflink);
 		if (Nflag)
 			exit(0);
 	}

