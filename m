Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:6392 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758228AbdLRJMM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 04:12:12 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1eQrSr-0002t0-Q8
        for linux-xfs@vger.kernel.org; Mon, 18 Dec 2017 20:12:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1eQrSr-0003qX-P0
        for linux-xfs@vger.kernel.org; Mon, 18 Dec 2017 20:12:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/7] mkfs: resolve sector size CLI conflicts
Date: Mon, 18 Dec 2017 20:11:57 +1100
Message-Id: <20171218091158.14537-7-david@fromorbit.com>
In-Reply-To: <20171218091158.14537-1-david@fromorbit.com>
References: <20171218091158.14537-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now we have a two dimensional conflict array, convert the sector
size CLI option conflict determination to use it. To get the error
specification just right, we also need to tweak how we store
and validate the sector size CLI parameter state in the options
table.

Old:

$ mkfs.xfs -N -s size=4k -d sectsize=512 /dev/pmem0
Cannot specify both -d sectsize and -d sectlog
.....

New:

$ mkfs.xfs -N -s size=4k -d sectsize=512 /dev/pmem0
Cannot specify both -s size and -d sectsize
.....


Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4b79c03e442b..b8752965c6d7 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -230,6 +230,13 @@ struct opt_params {
 	}		subopt_params[MAX_SUBOPTS];
 };
 
+/*
+ * The two dimensional conflict array requires some initialisations to know
+ * about tables that haven't yet been defined. Work around this ordering
+ * issue with extern definitions here.
+ */
+extern struct opt_params sopts;
+
 struct opt_params bopts = {
 	.name = 'b',
 	.subopts = {
@@ -348,6 +355,10 @@ struct opt_params dopts = {
 		},
 		{ .index = D_SECTLOG,
 		  .conflicts = { { &dopts, D_SECTSIZE },
+				 { &sopts, S_SIZE },
+				 { &sopts, S_SECTSIZE },
+				 { &sopts, S_LOG },
+				 { &sopts, S_SECTLOG },
 				 { &dopts, LAST_CONFLICT } },
 		  .minval = XFS_MIN_SECTORSIZE_LOG,
 		  .maxval = XFS_MAX_SECTORSIZE_LOG,
@@ -355,6 +366,10 @@ struct opt_params dopts = {
 		},
 		{ .index = D_SECTSIZE,
 		  .conflicts = { { &dopts, D_SECTLOG },
+				 { &sopts, S_SIZE },
+				 { &sopts, S_SECTSIZE },
+				 { &sopts, S_LOG },
+				 { &sopts, S_SECTLOG },
 				 { &dopts, LAST_CONFLICT } },
 		  .convert = true,
 		  .is_power_2 = true,
@@ -680,6 +695,9 @@ struct opt_params sopts = {
 		{ .index = S_LOG,
 		  .conflicts = { { &sopts, S_SIZE },
 				 { &sopts, S_SECTSIZE },
+				 { &sopts, S_SECTLOG },
+				 { &dopts, D_SECTSIZE },
+				 { &dopts, D_SECTLOG },
 				 { &sopts, LAST_CONFLICT } },
 		  .minval = XFS_MIN_SECTORSIZE_LOG,
 		  .maxval = XFS_MAX_SECTORSIZE_LOG,
@@ -688,6 +706,9 @@ struct opt_params sopts = {
 		{ .index = S_SECTLOG,
 		  .conflicts = { { &sopts, S_SIZE },
 				 { &sopts, S_SECTSIZE },
+				 { &sopts, S_LOG },
+				 { &dopts, D_SECTSIZE },
+				 { &dopts, D_SECTLOG },
 				 { &sopts, LAST_CONFLICT } },
 		  .minval = XFS_MIN_SECTORSIZE_LOG,
 		  .maxval = XFS_MAX_SECTORSIZE_LOG,
@@ -696,6 +717,9 @@ struct opt_params sopts = {
 		{ .index = S_SIZE,
 		  .conflicts = { { &sopts, S_LOG },
 				 { &sopts, S_SECTLOG },
+				 { &sopts, S_SECTSIZE },
+				 { &dopts, D_SECTSIZE },
+				 { &dopts, D_SECTLOG },
 				 { &sopts, LAST_CONFLICT } },
 		  .convert = true,
 		  .is_power_2 = true,
@@ -706,6 +730,9 @@ struct opt_params sopts = {
 		{ .index = S_SECTSIZE,
 		  .conflicts = { { &sopts, S_LOG },
 				 { &sopts, S_SECTLOG },
+				 { &sopts, S_SIZE },
+				 { &dopts, D_SECTSIZE },
+				 { &dopts, D_SECTLOG },
 				 { &sopts, LAST_CONFLICT } },
 		  .convert = true,
 		  .is_power_2 = true,
@@ -964,8 +991,8 @@ conflict(
 	int			conflict)
 {
 	fprintf(stderr, _("Cannot specify both -%c %s and -%c %s\n"),
-			opts->name, opts->subopts[option],
-			con_opts->name, con_opts->subopts[conflict]);
+			con_opts->name, con_opts->subopts[conflict],
+			opts->name, opts->subopts[option]);
 	usage();
 }
 
@@ -1523,14 +1550,10 @@ data_opts_parser(
 		cli->sb_feat.nodalign = getnum(value, opts, D_NOALIGN);
 		break;
 	case D_SECTLOG:
-		if (cli->sectorsize)
-			conflict(opts, D_SECTSIZE, opts, D_SECTLOG);
 		sectorlog = getnum(value, opts, D_SECTLOG);
 		cli->sectorsize = 1 << sectorlog;
 		break;
 	case D_SECTSIZE:
-		if (cli->sectorsize)
-			conflict(opts, D_SECTSIZE, opts, D_SECTLOG);
 		cli->sectorsize = getnum(value, opts, D_SECTSIZE);
 		break;
 	case D_RTINHERIT:
@@ -1756,17 +1779,13 @@ sector_opts_parser(
 	switch (subopt) {
 	case S_LOG:
 	case S_SECTLOG:
-		if (cli->sectorsize)
-			conflict(opts, S_SECTSIZE, opts, S_SECTLOG);
-		sectorlog = getnum(value, opts, S_SECTLOG);
+		sectorlog = getnum(value, opts, subopt);
 		cli->sectorsize = 1 << sectorlog;
 		cli->lsectorsize = cli->sectorsize;
 		break;
 	case S_SIZE:
 	case S_SECTSIZE:
-		if (cli->sectorsize)
-			conflict(opts, S_SECTSIZE, opts, S_SECTLOG);
-		cli->sectorsize = getnum(value, opts, S_SECTSIZE);
+		cli->sectorsize = getnum(value, opts, subopt);
 		cli->lsectorsize = cli->sectorsize;
 		break;
 	default:
-- 
2.15.0

