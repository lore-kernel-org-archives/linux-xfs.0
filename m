Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35913 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753058AbcLGNgH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 08:36:07 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 656067FD44
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 13:27:56 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 15/22] mkfs: replace SUBOPT_NEEDS_VAL for a flag
Date: Wed,  7 Dec 2016 14:27:22 +0100
Message-Id: <1481117249-21273-16-git-send-email-jtulak@redhat.com>
In-Reply-To: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Do not use a special value as a signal for a required value,
as it causes issues when we have more value types.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 93 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 48 insertions(+), 45 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f7eb191..7ffe8ff 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -44,7 +44,6 @@ unsigned int		sectorsize;
 
 #define MAX_OPTS	16
 #define MAX_SUBOPTS	16
-#define SUBOPT_NEEDS_VAL	(-1LL)
 #define MAX_CONFLICTS	32
 #define LAST_CONFLICT	(-1)
 
@@ -193,14 +192,17 @@ unsigned int		sectorsize;
  *     The value used if user specifies the subopt, but no value.
  *     If the subopt accepts some values (-d file=[1|0]), then this
  *     sets what is used with simple specifying the subopt (-d file).
- *     A special SUBOPT_NEEDS_VAL can be used to require a user-given
- *     value in any case.
  *
  *   value INTERNAL
  *     Do not set this on initialization. Use flagval for what you want
  *     to do. This is filled with user input and anything you write here now
  *     is overwritten. (If the user input is a string and not a number, this
  *     value is set to a positive non-zero number.)
+ *
+ *   needs_val OPTIONAL
+ *     Set to true if, when user specifies the option, she has to specify
+ *     a value too. That is, if needs_val is true, then it is not possible to
+ *     use the subopt as a flag.
  */
 struct opt_params {
 	int		index;
@@ -225,6 +227,7 @@ struct opt_params {
 		long long	maxval;
 		long long	flagval;
 		long long	value;
+		bool		needs_val;
 	}		subopt_params[MAX_SUBOPTS];
 } opts[MAX_OPTS] = {
 	{
@@ -243,7 +246,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_BLOCKSIZE_LOG,
 			  .maxval = XFS_MAX_BLOCKSIZE_LOG,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = B_SIZE,
 			  .convert = true,
@@ -254,7 +257,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_BLOCKSIZE,
 			  .maxval = XFS_MAX_BLOCKSIZE,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 		},
 	},
@@ -287,7 +290,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 1,
 			  .maxval = XFS_MAX_AGNUMBER,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = D_FILE,
 			  .conflicts = { {LAST_CONFLICT} },
@@ -297,14 +300,14 @@ struct opt_params {
 			},
 			{ .index = D_NAME,
 			  .conflicts = { {LAST_CONFLICT} },
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = D_SIZE,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .convert = true,
 			  .minval = XFS_AG_MIN_BYTES,
 			  .maxval = LLONG_MAX,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = D_SUNIT,
 			  .conflicts = { {.opt = OPT_D,
@@ -319,7 +322,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = D_SWIDTH,
 			  .conflicts = { {.opt = OPT_D,
@@ -334,7 +337,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = D_AGSIZE,
 			  .conflicts = { {.opt = OPT_D,
@@ -344,7 +347,7 @@ struct opt_params {
 			  .convert = true,
 			  .minval = XFS_AG_MIN_BYTES,
 			  .maxval = XFS_AG_MAX_BYTES,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = D_SU,
 			  .conflicts = { {.opt = OPT_D,
@@ -360,7 +363,7 @@ struct opt_params {
 			  .convert = true,
 			  .minval = 0,
 			  .maxval = UINT_MAX,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = D_SW,
 			  .conflicts = { {.opt = OPT_D,
@@ -375,7 +378,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = D_SECTLOG,
 			  .conflicts = { {.opt = OPT_D,
@@ -384,7 +387,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = D_SECTSIZE,
 			  .conflicts = { {.opt = OPT_D,
@@ -395,7 +398,7 @@ struct opt_params {
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_SECTORSIZE,
 			  .maxval = XFS_MAX_SECTORSIZE,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = D_NOALIGN,
 			  .conflicts = { {.opt = OPT_D,
@@ -425,13 +428,13 @@ struct opt_params {
 			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = D_EXTSZINHERIT,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 		},
 	},
@@ -474,13 +477,13 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_DINODE_MIN_LOG,
 			  .maxval = XFS_DINODE_MAX_LOG,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = I_MAXPCT,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 100,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = I_PERBLOCK,
 			  .conflicts = { {.opt = OPT_I,
@@ -493,7 +496,7 @@ struct opt_params {
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_INODE_PERBLOCK,
 			  .maxval = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = I_SIZE,
 			  .conflicts = { {.opt = OPT_I,
@@ -506,7 +509,7 @@ struct opt_params {
 			  .is_power_2 = true,
 			  .minval = XFS_DINODE_MIN_SIZE,
 			  .maxval = XFS_DINODE_MAX_SIZE,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = I_ATTR,
 			  .conflicts = { {.opt = OPT_M,
@@ -520,7 +523,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 2,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = I_PROJID32BIT,
 			  .conflicts = { {.opt = OPT_M,
@@ -579,7 +582,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = L_INTERNAL,
 			  .conflicts = { {.opt = OPT_L,
@@ -598,7 +601,7 @@ struct opt_params {
 			  .convert = true,
 			  .minval = 2 * 1024 * 1024LL,	/* XXX: XFS_MIN_LOG_BYTES */
 			  .maxval = XFS_MAX_LOG_BYTES,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = L_VERSION,
 			  .conflicts = {{.opt = OPT_M,
@@ -612,7 +615,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 1,
 			  .maxval = 2,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = L_SUNIT,
 			  .conflicts = { {.opt = OPT_L,
@@ -621,7 +624,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 1,
 			  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = L_SU,
 			  .conflicts = { {.opt = OPT_L,
@@ -631,7 +634,7 @@ struct opt_params {
 			  .convert = true,
 			  .minval = BBTOB(1),
 			  .maxval = XLOG_MAX_RECORD_BSIZE,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = L_DEV,
 			  .conflicts = { {.opt = OPT_L,
@@ -641,7 +644,7 @@ struct opt_params {
 					  .subopt = L_INTERNAL,
 					 },
 					 {LAST_CONFLICT} },
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = L_SECTLOG,
 			  .conflicts = { {.opt = OPT_L,
@@ -650,7 +653,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = L_SECTSIZE,
 			  .conflicts = { {.opt = OPT_L,
@@ -661,7 +664,7 @@ struct opt_params {
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_SECTORSIZE,
 			  .maxval = XFS_MAX_SECTORSIZE,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = L_FILE,
 			  .conflicts = { {.opt = OPT_L,
@@ -680,7 +683,7 @@ struct opt_params {
 					  .subopt = L_INTERNAL,
 					 },
 					 {LAST_CONFLICT} },
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = L_LAZYSBCNTR,
 			  .conflicts = { {.opt = OPT_M,
@@ -716,7 +719,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_REC_DIRSIZE,
 			  .maxval = XFS_MAX_BLOCKSIZE_LOG,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = N_SIZE,
 			  .conflicts = { {.opt = OPT_N,
@@ -727,13 +730,13 @@ struct opt_params {
 			  .is_power_2 = true,
 			  .minval = 1 << XFS_MIN_REC_DIRSIZE,
 			  .maxval = XFS_MAX_BLOCKSIZE,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = N_VERSION,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 2,
 			  .maxval = 2,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = N_FTYPE,
 			  .conflicts = {  {.opt = OPT_M,
@@ -769,14 +772,14 @@ struct opt_params {
 			  .convert = true,
 			  .minval = XFS_MIN_RTEXTSIZE,
 			  .maxval = XFS_MAX_RTEXTSIZE,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = R_SIZE,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .convert = true,
 			  .minval = 0,
 			  .maxval = LLONG_MAX,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = R_DEV,
 			  .conflicts = { {.opt = OPT_M,
@@ -788,7 +791,7 @@ struct opt_params {
 					  .message =
 		"rmapbt not supported without CRC support."},
 					 {LAST_CONFLICT} },
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = R_FILE,
 			  .minval = 0,
@@ -806,7 +809,7 @@ struct opt_params {
 					  .message =
 		"rmapbt not supported without CRC support."},
 					 {LAST_CONFLICT} },
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = R_NOALIGN,
 			  .minval = 0,
@@ -837,7 +840,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = S_SECTLOG,
 			  .conflicts = { {.opt = OPT_S,
@@ -849,7 +852,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = S_SIZE,
 			  .conflicts = { {.opt = OPT_S,
@@ -863,7 +866,7 @@ struct opt_params {
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_SECTORSIZE,
 			  .maxval = XFS_MAX_SECTORSIZE,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = S_SECTSIZE,
 			  .conflicts = { {.opt = OPT_S,
@@ -877,7 +880,7 @@ struct opt_params {
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_SECTORSIZE,
 			  .maxval = XFS_MAX_SECTORSIZE,
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 		},
 	},
@@ -995,7 +998,7 @@ struct opt_params {
 			},
 			{ .index = M_UUID,
 			  .conflicts = { {LAST_CONFLICT} },
-			  .flagval = SUBOPT_NEEDS_VAL,
+			  .needs_val = true,
 			},
 			{ .index = M_RMAPBT,
 			.conflicts = { {.opt = OPT_M,
@@ -1039,7 +1042,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
-			  .flagval = 0,
+			  .needs_val = true,
 			},
 		},
 	},
@@ -1715,7 +1718,7 @@ getnum(
 
 	/* empty strings might just return a default value */
 	if (!str || *str == '\0') {
-		if (sp->flagval == SUBOPT_NEEDS_VAL)
+		if (sp->needs_val)
 			reqval(opts->name, (char **)opts->subopts, index);
 		sp->seen = true;
 		return sp->flagval;
-- 
2.8.1

