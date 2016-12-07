Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752923AbcLGNgn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 08:36:43 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2974CC0528A8
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 13:27:52 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 11/22] mkfs: add test_default_value into conflict struct
Date: Wed,  7 Dec 2016 14:27:18 +0100
Message-Id: <1481117249-21273-12-git-send-email-jtulak@redhat.com>
In-Reply-To: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Add a flag signalising that a subopt can be conflicting with
default value of another option.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 156 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 80 insertions(+), 76 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b3625ed..58cc24a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -172,6 +172,8 @@ unsigned int		sectorsize;
  *     on the CLI, no matter its value. The field .message contains an optional
  *     explanatory string for the user. This string can't be translated here,
  *     so it has to be enveloped with _() when printed.
+ *     The .test_default_value is used when .test_values is true, and extends
+ *     the check also for default values.
  *     The last member of this list has to be {LAST_CONFLICT}.
  *
  *   minval, maxval OPTIONAL
@@ -214,6 +216,7 @@ struct opt_params {
 			int		opt;
 			int		subopt;
 			bool		test_values;
+			bool		test_default_value;
 			long long	invalid_value;
 			long long	at_value;
 			const char	*message;
@@ -234,7 +237,7 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = B_LOG,
-			  .conflicts = { {OPT_B, B_SIZE, false, 0, 0},
+			  .conflicts = { {OPT_B, B_SIZE, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_BLOCKSIZE_LOG,
 			  .maxval = XFS_MAX_BLOCKSIZE_LOG,
@@ -243,7 +246,7 @@ struct opt_params {
 			{ .index = B_SIZE,
 			  .convert = true,
 			  .is_power_2 = true,
-			  .conflicts = { {OPT_B, B_LOG, false, 0, 0},
+			  .conflicts = { {OPT_B, B_LOG, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_BLOCKSIZE,
 			  .maxval = XFS_MAX_BLOCKSIZE,
@@ -274,7 +277,7 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = D_AGCOUNT,
-			  .conflicts = { {OPT_D, D_AGSIZE, false, 0, 0},
+			  .conflicts = { {OPT_D, D_AGSIZE, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = 1,
 			  .maxval = XFS_MAX_AGNUMBER,
@@ -298,25 +301,25 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SUNIT,
-			  .conflicts = { {OPT_D, D_NOALIGN, false, 0, 0},
-					 {OPT_D, D_SU, false, 0, 0},
-					 {OPT_D, D_SW, false, 0, 0},
+			  .conflicts = { {OPT_D, D_NOALIGN, false, false, 0, 0},
+					 {OPT_D, D_SU, false, false, 0, 0},
+					 {OPT_D, D_SW, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SWIDTH,
-			  .conflicts = { {OPT_D, D_NOALIGN, false, 0, 0},
-					 {OPT_D, D_SU, false, 0, 0},
-					 {OPT_D, D_SW, false, 0, 0},
+			  .conflicts = { {OPT_D, D_NOALIGN, false, false, 0, 0},
+					 {OPT_D, D_SU, false, false, 0, 0},
+					 {OPT_D, D_SW, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_AGSIZE,
-			  .conflicts = { {OPT_D, D_AGCOUNT, false, 0, 0},
+			  .conflicts = { {OPT_D, D_AGCOUNT, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .minval = XFS_AG_MIN_BYTES,
@@ -324,9 +327,9 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SU,
-			  .conflicts = { {OPT_D, D_NOALIGN, false, 0, 0},
-					 {OPT_D, D_SUNIT, false, 0, 0},
-					 {OPT_D, D_SWIDTH, false, 0, 0},
+			  .conflicts = { {OPT_D, D_NOALIGN, false, false, 0, 0},
+					 {OPT_D, D_SUNIT, false, false, 0, 0},
+					 {OPT_D, D_SWIDTH, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .minval = 0,
@@ -334,23 +337,23 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SW,
-			  .conflicts = { {OPT_D, D_NOALIGN, false, 0, 0},
-					 {OPT_D, D_SUNIT, false, 0, 0},
-					 {OPT_D, D_SWIDTH, false, 0, 0},
+			  .conflicts = { {OPT_D, D_NOALIGN, false, false, 0, 0},
+					 {OPT_D, D_SUNIT, false, false, 0, 0},
+					 {OPT_D, D_SWIDTH, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SECTLOG,
-			  .conflicts = { {OPT_D, D_SECTSIZE, false, 0, 0},
+			  .conflicts = { {OPT_D, D_SECTSIZE, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SECTSIZE,
-			  .conflicts = { {OPT_D, D_SECTLOG, false, 0, 0},
+			  .conflicts = { {OPT_D, D_SECTLOG, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .is_power_2 = true,
@@ -359,10 +362,10 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_NOALIGN,
-			  .conflicts = { {OPT_D, D_SU, false, 0, 0},
-					 {OPT_D, D_SW, false, 0, 0},
-					 {OPT_D, D_SUNIT, false, 0, 0},
-					 {OPT_D, D_SWIDTH, false, 0, 0},
+			  .conflicts = { {OPT_D, D_SU, false, false, 0, 0},
+					 {OPT_D, D_SW, false, false, 0, 0},
+					 {OPT_D, D_SUNIT, false, false, 0, 0},
+					 {OPT_D, D_SWIDTH, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
@@ -404,7 +407,7 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = I_ALIGN,
-			  .conflicts = { {OPT_M, M_CRC, true, 1, 0,
+			  .conflicts = { {OPT_M, M_CRC, true, true, 1, 0,
 		"Inodes always aligned for CRC enabled filesytems."},
 					 {LAST_CONFLICT} },
 			  .minval = 0,
@@ -412,8 +415,8 @@ struct opt_params {
 			  .defaultval = 1,
 			},
 			{ .index = I_LOG,
-			  .conflicts = { {OPT_I, I_PERBLOCK, false, 0, 0},
-					 {OPT_I, I_SIZE, false, 0, 0},
+			  .conflicts = { {OPT_I, I_PERBLOCK, false, false, 0, 0},
+					 {OPT_I, I_SIZE, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = XFS_DINODE_MIN_LOG,
 			  .maxval = XFS_DINODE_MAX_LOG,
@@ -426,8 +429,8 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_PERBLOCK,
-			  .conflicts = { {OPT_I, I_LOG, false, 0, 0},
-					 {OPT_I, I_SIZE, false, 0, 0},
+			  .conflicts = { {OPT_I, I_LOG, false, false, 0, 0},
+					 {OPT_I, I_SIZE, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_INODE_PERBLOCK,
@@ -435,8 +438,8 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_SIZE,
-			  .conflicts = { {OPT_I, I_PERBLOCK, false, 0, 0},
-					 {OPT_I, I_LOG, false, 0, 0},
+			  .conflicts = { {OPT_I, I_PERBLOCK, false, false, 0, 0},
+					 {OPT_I, I_LOG, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .is_power_2 = true,
 			  .minval = XFS_DINODE_MIN_SIZE,
@@ -444,7 +447,7 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_ATTR,
-			  .conflicts = { {OPT_M, M_CRC, true, 1, 1,
+			  .conflicts = { {OPT_M, M_CRC, true, true, 1, 1,
 		"V2 attribute format always enabled on CRC enabled filesytems."},
 					 {LAST_CONFLICT} },
 			  .minval = 0,
@@ -452,7 +455,7 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_PROJID32BIT,
-			  .conflicts = { {OPT_M, M_CRC, true, 1, 0,
+			  .conflicts = { {OPT_M, M_CRC, true, true, 1, 0,
 		"32 bit Project IDs always enabled on CRC enabled filesytems."},
 					 {LAST_CONFLICT} },
 
@@ -461,7 +464,7 @@ struct opt_params {
 			  .defaultval = 1,
 			},
 			{ .index = I_SPINODES,
-			  .conflicts = { {OPT_M, M_CRC, true, 0, 1,
+			  .conflicts = { {OPT_M, M_CRC, true, true, 0, 1,
 		"Sparse inodes not supported without CRC support."},
 					 {LAST_CONFLICT} },
 			  .minval = 0,
@@ -490,15 +493,15 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = L_AGNUM,
-			  .conflicts = { {OPT_L, L_DEV, false, 0, 0},
+			  .conflicts = { {OPT_L, L_DEV, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_INTERNAL,
-			  .conflicts = { {OPT_L, L_FILE, false, 0, 0},
-					 {OPT_L, L_DEV, false, 0, 0},
+			  .conflicts = { {OPT_L, L_FILE, false, false, 0, 0},
+					 {OPT_L, L_DEV, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
@@ -512,7 +515,7 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_VERSION,
-			  .conflicts = { {OPT_M, M_CRC, true, 1, 1,
+			  .conflicts = { {OPT_M, M_CRC, true, true, 1, 1,
 				"V2 logs are required for CRC enabled filesystems."},
 					 {LAST_CONFLICT} },
 			  .minval = 1,
@@ -520,14 +523,14 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_SUNIT,
-			  .conflicts = { {OPT_L, L_SU, false, 0, 0},
+			  .conflicts = { {OPT_L, L_SU, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = 1,
 			  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_SU,
-			  .conflicts = { {OPT_L, L_SUNIT, false, 0, 0},
+			  .conflicts = { {OPT_L, L_SUNIT, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .minval = BBTOB(1),
@@ -535,20 +538,20 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_DEV,
-			  .conflicts = { {OPT_L, L_AGNUM, false, 0, 0},
-					 {OPT_L, L_INTERNAL, false, 0, 0},
+			  .conflicts = { {OPT_L, L_AGNUM, false, false, 0, 0},
+					 {OPT_L, L_INTERNAL, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_SECTLOG,
-			  .conflicts = { {OPT_L, L_SECTSIZE, false, 0, 0},
+			  .conflicts = { {OPT_L, L_SECTSIZE, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_SECTSIZE,
-			  .conflicts = { {OPT_L, L_SECTLOG, false, 0, 0},
+			  .conflicts = { {OPT_L, L_SECTLOG, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .is_power_2 = true,
@@ -557,20 +560,20 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_FILE,
-			  .conflicts = { {OPT_L, L_INTERNAL, false, 0, 0},
+			  .conflicts = { {OPT_L, L_INTERNAL, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
 			},
 			{ .index = L_NAME,
-			  .conflicts = { {OPT_L, L_AGNUM, false, 0, 0},
-					 {OPT_L, L_INTERNAL, false, 0, 0},
+			  .conflicts = { {OPT_L, L_AGNUM, false, false, 0, 0},
+					 {OPT_L, L_INTERNAL, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_LAZYSBCNTR,
-			  .conflicts = { {OPT_M, M_CRC, true, 1, 0,
+			  .conflicts = { {OPT_M, M_CRC, true, true, 1, 0,
 		"Lazy superblock counted always enabled for CRC enabled filesytems."},
 					 {LAST_CONFLICT} },
 			  .minval = 0,
@@ -591,14 +594,14 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = N_LOG,
-			  .conflicts = { {OPT_N, N_SIZE, false, 0, 0},
+			  .conflicts = { {OPT_N, N_SIZE, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_REC_DIRSIZE,
 			  .maxval = XFS_MAX_BLOCKSIZE_LOG,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = N_SIZE,
-			  .conflicts = { {OPT_N, N_LOG, false, 0, 0},
+			  .conflicts = { {OPT_N, N_LOG, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .is_power_2 = true,
@@ -613,7 +616,7 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = N_FTYPE,
-			  .conflicts = {  {OPT_M, M_CRC, true, 1, 0,
+			  .conflicts = {  {OPT_M, M_CRC, true, true, 1, 0,
 		"Cannot disable ftype with crcs enabled."},
 					  {LAST_CONFLICT} },
 			  .minval = 0,
@@ -650,7 +653,7 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = R_DEV,
-			  .conflicts = { {OPT_M, M_RMAPBT, false, 0, 0,
+			  .conflicts = { {OPT_M, M_RMAPBT, false, true, 0, 0,
 		"rmapbt not supported without CRC support."},
 					 {LAST_CONFLICT} },
 			  .defaultval = SUBOPT_NEEDS_VAL,
@@ -662,7 +665,7 @@ struct opt_params {
 			  .conflicts = { {LAST_CONFLICT} },
 			},
 			{ .index = R_NAME,
-			  .conflicts = { {OPT_M, M_RMAPBT, false, 0, 0,
+			  .conflicts = { {OPT_M, M_RMAPBT, false, true, 0, 0,
 		"rmapbt not supported without CRC support."},
 					 {LAST_CONFLICT} },
 			  .defaultval = SUBOPT_NEEDS_VAL,
@@ -687,24 +690,24 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = S_LOG,
-			  .conflicts = { {OPT_S, S_SIZE, false, 0, 0},
-					 {OPT_S, S_SECTSIZE, false, 0, 0},
+			  .conflicts = { {OPT_S, S_SIZE, false, false, 0, 0},
+					 {OPT_S, S_SECTSIZE, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = S_SECTLOG,
-			  .conflicts = { {OPT_S, S_SIZE, false, 0, 0},
-					 {OPT_S, S_SECTSIZE, false, 0, 0},
+			  .conflicts = { {OPT_S, S_SIZE, false, false, 0, 0},
+					 {OPT_S, S_SECTSIZE, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = S_SIZE,
-			  .conflicts = { {OPT_S, S_LOG, false, 0, 0},
-					 {OPT_S, S_SECTLOG, false, 0, 0},
+			  .conflicts = { {OPT_S, S_LOG, false, false, 0, 0},
+					 {OPT_S, S_SECTLOG, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .is_power_2 = true,
@@ -713,8 +716,8 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = S_SECTSIZE,
-			  .conflicts = { {OPT_S, S_LOG, false, 0, 0},
-					 {OPT_S, S_SECTLOG, false, 0, 0},
+			  .conflicts = { {OPT_S, S_LOG, false, false, 0, 0},
+					 {OPT_S, S_SECTLOG, false, false, 0, 0},
 					 {LAST_CONFLICT} },
 			  .convert = true,
 			  .is_power_2 = true,
@@ -737,25 +740,25 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = M_CRC,
-			  .conflicts = { {OPT_L, L_VERSION, true, 1, 1,
+			  .conflicts = { {OPT_L, L_VERSION, true, true, 1, 1,
 		"V2 logs are required for CRC enabled filesystems."},
-					 {OPT_I, I_ALIGN, true, 0, 1,
+					 {OPT_I, I_ALIGN, false, true, 0, 1,
 		"Inodes always aligned for CRC enabled filesytems."},
-					 {OPT_I, I_PROJID32BIT, true, 0, 1,
+					 {OPT_I, I_PROJID32BIT, true, true, 0, 1,
 		"32 bit Project IDs always enabled on CRC enabled filesytems."},
-					 {OPT_I, I_ATTR, true, 1, 1,
+					 {OPT_I, I_ATTR, true, true, 1, 1,
 		"V2 attribute format always enabled on CRC enabled filesytems."},
-					 {OPT_L, L_LAZYSBCNTR, true, 0, 1,
+					 {OPT_L, L_LAZYSBCNTR, true, true, 0, 1,
 		"Lazy superblock counted always enabled for CRC enabled filesytems."},
-					 {OPT_M, M_FINOBT, true, 1, 0,
+					 {OPT_M, M_FINOBT, true, true, 1, 0,
 		"Finobt not supported without CRC support."},
-					 {OPT_M, M_RMAPBT, true, 1, 0,
+					 {OPT_M, M_RMAPBT, true, true, 1, 0,
 		"rmapbt not supported without CRC support."},
-					 {OPT_M, M_REFLINK, true, 1, 0,
+					 {OPT_M, M_REFLINK, true, true, 1, 0,
 		"reflink not supported without CRC support."},
-					 {OPT_I, I_SPINODES, true, 1, 0,
+					 {OPT_I, I_SPINODES, true, true, 1, 0,
 		"Sparse inodes not supported without CRC support."},
-					 {OPT_N, N_FTYPE, true, 0, 1,
+					 {OPT_N, N_FTYPE, true, true, 0, 1,
 		"Cannot disable ftype with crcs enabled."},
 					 {LAST_CONFLICT} },
 			  .minval = 0,
@@ -763,8 +766,8 @@ struct opt_params {
 			  .defaultval = 1,
 			},
 			{ .index = M_FINOBT,
-			  .conflicts = { {OPT_M, M_CRC, true, 0, 1,
-		"Finobt not supported without CRC support\n"},
+			  .conflicts = { {OPT_M, M_CRC, true, true, 0, 1,
+		"Finobt not supported without CRC support."},
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
@@ -775,11 +778,11 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = M_RMAPBT,
-			.conflicts = { {OPT_M, M_CRC, true, 0, 1,
+			.conflicts = { {OPT_M, M_CRC, true, true, 0, 1,
 		"rmapbt not supported without CRC support."},
-					{OPT_R, R_NAME, false, 0, 0,
+					{OPT_R, R_NAME, false, true, 0, 0,
 		"rmapbt not supported with realtime devices."},
-					{OPT_R, R_DEV, false, 0, 0,
+					{OPT_R, R_DEV, false, true, 0, 0,
 		"rmapbt not supported with realtime devices."},
 				       {LAST_CONFLICT} },
 			.minval = 0,
@@ -787,7 +790,7 @@ struct opt_params {
 			.defaultval = 0,
 			},
 			{ .index = M_REFLINK,
-			  .conflicts = { {OPT_M, M_CRC, true, 0, 1,
+			  .conflicts = { {OPT_M, M_CRC, true, true, 0, 1,
 		"reflink not supported without CRC support."},
 					 {LAST_CONFLICT} },
 			  .minval = 0,
@@ -1417,7 +1420,8 @@ check_subopt_value(
 			break;
 		if (!conflict_opt.test_values)
 			break;
-		if (opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].seen &&
+		if ( (opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].seen ||
+		      conflict_opt.test_default_value) &&
 		    opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].value
 				== conflict_opt.invalid_value &&
 		    value == conflict_opt.at_value) {
-- 
2.8.1

