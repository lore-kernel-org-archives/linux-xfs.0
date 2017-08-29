Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11621 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751913AbdH2XvL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:11 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002d6-U7
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005WJ-Sp
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 20/42] mkfs: rename top level CLI parameters
Date: Wed, 30 Aug 2017 09:50:30 +1000
Message-Id: <20170829235052.21050-21-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Names like "qflag" and "Nflag" don't tell us what the flag is
supposed to do, so rename them to be obvious in function.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e53e56a1bd47..7b71f59dc654 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2587,11 +2587,11 @@ main(
 	int			norsflag;
 	int			nsflag;
 	int			nvflag;
-	int			Nflag;
+	int			dry_run;
 	int			discard = 1;
 	char			*protofile;
 	char			*protostring;
-	int			qflag;
+	int			quiet;
 	xfs_rfsblock_t		rtblocks;
 	xfs_extlen_t		rtextblocks;
 	xfs_rtblock_t		rtextents;
@@ -2669,9 +2669,9 @@ main(
 	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
 	loginternal = 1;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
-	Nflag = nlflag = nsflag = nvflag = 0;
+	dry_run = nlflag = nsflag = nvflag = 0;
 	dirblocklog = dirblocksize = 0;
-	qflag = 0;
+	quiet = 0;
 	imaxpct = inodelog = inopblock = isize = 0;
 	dfile = logfile = rtfile = NULL;
 	dsize = logsize = rtsize = rtextsize = protofile = NULL;
@@ -2800,7 +2800,7 @@ main(
 			/* end temp don't break code */
 			break;
 		case 'N':
-			Nflag = 1;
+			dry_run = 1;
 			break;
 		case 'K':
 			discard = 0;
@@ -2811,7 +2811,7 @@ main(
 			protofile = optarg;
 			break;
 		case 'q':
-			qflag = 1;
+			quiet = 1;
 			break;
 		case 'r':
 			parse_subopts(c, optarg, &cli);
@@ -2896,14 +2896,14 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 	 * host filesystem.
 	 */
 	check_device_type(dfile, &xi.disfile, !dsize, !dfile,
-			  Nflag ? NULL : &xi.dcreat, force_overwrite, "d");
+			  dry_run ? NULL : &xi.dcreat, force_overwrite, "d");
 	if (!loginternal)
 		check_device_type(xi.logname, &xi.lisfile, !logsize, !xi.logname,
-				  Nflag ? NULL : &xi.lcreat,
+				  dry_run ? NULL : &xi.lcreat,
 				  force_overwrite, "l");
 	if (xi.rtname)
 		check_device_type(xi.rtname, &xi.risfile, !rtsize, !xi.rtname,
-				  Nflag ? NULL : &xi.rcreat,
+				  dry_run ? NULL : &xi.rcreat,
 				  force_overwrite, "r");
 	if (xi.disfile || xi.lisfile || xi.risfile)
 		xi.isdirect = 0;
@@ -3259,7 +3259,7 @@ _("rmapbt not supported with realtime devices\n"));
 
 
 	/* don't do discards on print-only runs or on files */
-	if (discard && !Nflag) {
+	if (discard && !dry_run) {
 		if (!xi.disfile)
 			discard_blocks(xi.ddev, xi.dsize);
 		if (xi.rtdev && !xi.risfile)
@@ -3709,9 +3709,9 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	memcpy(&cfg.sb_feat, &sb_feat, sizeof(sb_feat));
 	/* end temp support code */
 
-	if (!qflag || Nflag) {
+	if (!quiet || dry_run) {
 		print_mkfs_cfg(&cfg, dfile, logfile, rtfile);
-		if (Nflag)
+		if (dry_run)
 			exit(0);
 	}
 
-- 
2.13.3

