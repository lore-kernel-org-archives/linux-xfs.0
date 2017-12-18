Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:56061 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758219AbdLRJMI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 04:12:08 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1eQrSr-0002sr-M3
        for linux-xfs@vger.kernel.org; Mon, 18 Dec 2017 20:12:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1eQrSr-0003qI-Kk
        for linux-xfs@vger.kernel.org; Mon, 18 Dec 2017 20:12:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/7] mkfs: use opts parameter during option parsing
Date: Mon, 18 Dec 2017 20:11:52 +1100
Message-Id: <20171218091158.14537-2-david@fromorbit.com>
In-Reply-To: <20171218091158.14537-1-david@fromorbit.com>
References: <20171218091158.14537-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Rather than hard coding the global table variable into the
parsing functions.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 60 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e38810f53386..f79062da4ff4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1533,29 +1533,29 @@ inode_opts_parser(
 
 	switch (subopt) {
 	case I_ALIGN:
-		cli->sb_feat.inode_align = getnum(value, &iopts, I_ALIGN);
+		cli->sb_feat.inode_align = getnum(value, opts, I_ALIGN);
 		break;
 	case I_LOG:
-		inodelog = getnum(value, &iopts, I_LOG);
+		inodelog = getnum(value, opts, I_LOG);
 		cli->inodesize = 1 << inodelog;
 		break;
 	case I_MAXPCT:
-		cli->imaxpct = getnum(value, &iopts, I_MAXPCT);
+		cli->imaxpct = getnum(value, opts, I_MAXPCT);
 		break;
 	case I_PERBLOCK:
-		cli->inopblock = getnum(value, &iopts, I_PERBLOCK);
+		cli->inopblock = getnum(value, opts, I_PERBLOCK);
 		break;
 	case I_SIZE:
-		cli->inodesize = getnum(value, &iopts, I_SIZE);
+		cli->inodesize = getnum(value, opts, I_SIZE);
 		break;
 	case I_ATTR:
-		cli->sb_feat.attr_version = getnum(value, &iopts, I_ATTR);
+		cli->sb_feat.attr_version = getnum(value, opts, I_ATTR);
 		break;
 	case I_PROJID32BIT:
-		cli->sb_feat.projid16bit = !getnum(value, &iopts, I_PROJID32BIT);
+		cli->sb_feat.projid16bit = !getnum(value, opts, I_PROJID32BIT);
 		break;
 	case I_SPINODES:
-		cli->sb_feat.spinodes = getnum(value, &iopts, I_SPINODES);
+		cli->sb_feat.spinodes = getnum(value, opts, I_SPINODES);
 		break;
 	default:
 		return -EINVAL;
@@ -1574,40 +1574,40 @@ log_opts_parser(
 
 	switch (subopt) {
 	case L_AGNUM:
-		cli->logagno = getnum(value, &lopts, L_AGNUM);
+		cli->logagno = getnum(value, opts, L_AGNUM);
 		break;
 	case L_FILE:
-		cli->xi->lisfile = getnum(value, &lopts, L_FILE);
+		cli->xi->lisfile = getnum(value, opts, L_FILE);
 		break;
 	case L_INTERNAL:
-		cli->loginternal = getnum(value, &lopts, L_INTERNAL);
+		cli->loginternal = getnum(value, opts, L_INTERNAL);
 		break;
 	case L_SU:
-		cli->lsu = getstr(value, &lopts, L_SU);
+		cli->lsu = getstr(value, opts, L_SU);
 		break;
 	case L_SUNIT:
-		cli->lsunit = getnum(value, &lopts, L_SUNIT);
+		cli->lsunit = getnum(value, opts, L_SUNIT);
 		break;
 	case L_NAME:
 	case L_DEV:
-		cli->xi->logname = getstr(value, &lopts, L_NAME);
+		cli->xi->logname = getstr(value, opts, L_NAME);
 		cli->loginternal = 0;
 		break;
 	case L_VERSION:
-		cli->sb_feat.log_version = getnum(value, &lopts, L_VERSION);
+		cli->sb_feat.log_version = getnum(value, opts, L_VERSION);
 		break;
 	case L_SIZE:
-		cli->logsize = getstr(value, &lopts, L_SIZE);
+		cli->logsize = getstr(value, opts, L_SIZE);
 		break;
 	case L_SECTLOG:
-		lsectorlog = getnum(value, &lopts, L_SECTLOG);
+		lsectorlog = getnum(value, opts, L_SECTLOG);
 		cli->lsectorsize = 1 << lsectorlog;
 		break;
 	case L_SECTSIZE:
-		cli->lsectorsize = getnum(value, &lopts, L_SECTSIZE);
+		cli->lsectorsize = getnum(value, opts, L_SECTSIZE);
 		break;
 	case L_LAZYSBCNTR:
-		cli->sb_feat.lazy_sb_counters = getnum(value, &lopts, L_LAZYSBCNTR);
+		cli->sb_feat.lazy_sb_counters = getnum(value, opts, L_LAZYSBCNTR);
 		break;
 	default:
 		return -EINVAL;
@@ -1624,12 +1624,12 @@ meta_opts_parser(
 {
 	switch (subopt) {
 	case M_CRC:
-		cli->sb_feat.crcs_enabled = getnum(value, &mopts, M_CRC);
+		cli->sb_feat.crcs_enabled = getnum(value, opts, M_CRC);
 		if (cli->sb_feat.crcs_enabled)
 			cli->sb_feat.dirftype = true;
 		break;
 	case M_FINOBT:
-		cli->sb_feat.finobt = getnum(value, &mopts, M_FINOBT);
+		cli->sb_feat.finobt = getnum(value, opts, M_FINOBT);
 		break;
 	case M_UUID:
 		if (!value || *value == '\0')
@@ -1638,10 +1638,10 @@ meta_opts_parser(
 			illegal(value, "m uuid");
 		break;
 	case M_RMAPBT:
-		cli->sb_feat.rmapbt = getnum(value, &mopts, M_RMAPBT);
+		cli->sb_feat.rmapbt = getnum(value, opts, M_RMAPBT);
 		break;
 	case M_REFLINK:
-		cli->sb_feat.reflink = getnum(value, &mopts, M_REFLINK);
+		cli->sb_feat.reflink = getnum(value, opts, M_REFLINK);
 		break;
 	default:
 		return -EINVAL;
@@ -1690,20 +1690,20 @@ rtdev_opts_parser(
 {
 	switch (subopt) {
 	case R_EXTSIZE:
-		cli->rtextsize = getstr(value, &ropts, R_EXTSIZE);
+		cli->rtextsize = getstr(value, opts, R_EXTSIZE);
 		break;
 	case R_FILE:
-		cli->xi->risfile = getnum(value, &ropts, R_FILE);
+		cli->xi->risfile = getnum(value, opts, R_FILE);
 		break;
 	case R_NAME:
 	case R_DEV:
-		cli->xi->rtname = getstr(value, &ropts, R_NAME);
+		cli->xi->rtname = getstr(value, opts, R_NAME);
 		break;
 	case R_SIZE:
-		cli->rtsize = getstr(value, &ropts, R_SIZE);
+		cli->rtsize = getstr(value, opts, R_SIZE);
 		break;
 	case R_NOALIGN:
-		cli->sb_feat.nortalign = getnum(value, &ropts, R_NOALIGN);
+		cli->sb_feat.nortalign = getnum(value, opts, R_NOALIGN);
 		break;
 	default:
 		return -EINVAL;
@@ -1725,7 +1725,7 @@ sector_opts_parser(
 	case S_SECTLOG:
 		if (cli->sectorsize)
 			conflict('s', opts->subopts, S_SECTSIZE, S_SECTLOG);
-		sectorlog = getnum(value, &sopts, S_SECTLOG);
+		sectorlog = getnum(value, opts, S_SECTLOG);
 		cli->sectorsize = 1 << sectorlog;
 		cli->lsectorsize = cli->sectorsize;
 		break;
@@ -1733,7 +1733,7 @@ sector_opts_parser(
 	case S_SECTSIZE:
 		if (cli->sectorsize)
 			conflict('s', opts->subopts, S_SECTLOG, S_SECTSIZE);
-		cli->sectorsize = getnum(value, &sopts, S_SECTSIZE);
+		cli->sectorsize = getnum(value, opts, S_SECTSIZE);
 		cli->lsectorsize = cli->sectorsize;
 		break;
 	default:
-- 
2.15.0

