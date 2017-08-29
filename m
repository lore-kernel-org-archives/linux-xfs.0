Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36957 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751941AbdH2XvJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:09 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002cm-On
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005W1-Nc
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/42] mkfs: factor printing of mkfs config
Date: Wed, 30 Aug 2017 09:50:24 +1000
Message-Id: <20170829235052.21050-15-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 60 +++++++++++++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 25 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b92c3316358f..4c67062047d9 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1881,6 +1881,40 @@ parse_subopts(
 	}
 }
 
+static void
+print_mkfs_cfg(
+	struct mkfs_params	*cfg,
+	char			*dfile,
+	char			*logfile,
+	char			*rtfile)
+{
+	struct sb_feat_args	*fp = &cfg->sb_feat;
+
+	printf(_(
+"meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
+"         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
+"         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
+"data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
+"         =%-22s sunit=%-6u swidth=%u blks\n"
+"naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
+"log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
+"         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
+"realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
+		dfile, cfg->inodesize, (long long)cfg->agcount,
+			(long long)cfg->agsize,
+		"", cfg->sectorsize, fp->attr_version, !fp->projid16bit,
+		"", fp->crcs_enabled, fp->finobt, fp->spinodes, fp->rmapbt,
+			fp->reflink,
+		"", cfg->blocksize, (long long)cfg->dblocks, cfg->imaxpct,
+		"", cfg->dsunit, cfg->dswidth,
+		fp->dir_version, cfg->dirblocksize, fp->nci, fp->dirftype,
+		logfile, cfg->blocksize, (long long)cfg->logblocks,
+			fp->log_version,
+		"", cfg->lsectorsize, cfg->lsunit, fp->lazy_sb_counters,
+		rtfile, (int)cfg->rtextblocks << cfg->blocklog,
+			(long long)cfg->rtblocks, (long long)cfg->rtextents);
+}
+
 int
 main(
 	int			argc,
@@ -3052,35 +3086,11 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	/* end temp support code */
 
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
+		print_mkfs_cfg(&cfg, dfile, logfile, rtfile);
 		if (Nflag)
 			exit(0);
 	}
 
-
 	if (label)
 		strncpy(sbp->sb_fname, label, sizeof(sbp->sb_fname));
 	sbp->sb_magicnum = XFS_SB_MAGIC;
-- 
2.13.3

