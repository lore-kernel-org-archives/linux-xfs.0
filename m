Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752918AbcLGNfG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 08:35:06 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5BFEE7AEA1
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 13:27:55 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 14/22] mkfs: rename defaultval to flagval in opts
Date: Wed,  7 Dec 2016 14:27:21 +0100
Message-Id: <1481117249-21273-15-git-send-email-jtulak@redhat.com>
In-Reply-To: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

The old name 'defaultval' was misleading - it is not the default value,
but the value the option has when used as a flag by an user.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 122 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 61 insertions(+), 61 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 61caceb..f7eb191 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -189,7 +189,7 @@ unsigned int		sectorsize;
  *     to zero. But if one value is different: minval=0 and maxval=1,
  *     then it is OK.)
  *
- *   defaultval MANDATORY
+ *   flagval MANDATORY
  *     The value used if user specifies the subopt, but no value.
  *     If the subopt accepts some values (-d file=[1|0]), then this
  *     sets what is used with simple specifying the subopt (-d file).
@@ -197,7 +197,7 @@ unsigned int		sectorsize;
  *     value in any case.
  *
  *   value INTERNAL
- *     Do not set this on initialization. Use defaultval for what you want
+ *     Do not set this on initialization. Use flagval for what you want
  *     to do. This is filled with user input and anything you write here now
  *     is overwritten. (If the user input is a string and not a number, this
  *     value is set to a positive non-zero number.)
@@ -223,7 +223,7 @@ struct opt_params {
 		}		conflicts [MAX_CONFLICTS];
 		long long	minval;
 		long long	maxval;
-		long long	defaultval;
+		long long	flagval;
 		long long	value;
 	}		subopt_params[MAX_SUBOPTS];
 } opts[MAX_OPTS] = {
@@ -243,7 +243,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_BLOCKSIZE_LOG,
 			  .maxval = XFS_MAX_BLOCKSIZE_LOG,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = B_SIZE,
 			  .convert = true,
@@ -254,7 +254,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_BLOCKSIZE,
 			  .maxval = XFS_MAX_BLOCKSIZE,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 		},
 	},
@@ -287,24 +287,24 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 1,
 			  .maxval = XFS_MAX_AGNUMBER,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_FILE,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
-			  .defaultval = 1,
+			  .flagval = 1,
 			},
 			{ .index = D_NAME,
 			  .conflicts = { {LAST_CONFLICT} },
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SIZE,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .convert = true,
 			  .minval = XFS_AG_MIN_BYTES,
 			  .maxval = LLONG_MAX,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SUNIT,
 			  .conflicts = { {.opt = OPT_D,
@@ -319,7 +319,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SWIDTH,
 			  .conflicts = { {.opt = OPT_D,
@@ -334,7 +334,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_AGSIZE,
 			  .conflicts = { {.opt = OPT_D,
@@ -344,7 +344,7 @@ struct opt_params {
 			  .convert = true,
 			  .minval = XFS_AG_MIN_BYTES,
 			  .maxval = XFS_AG_MAX_BYTES,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SU,
 			  .conflicts = { {.opt = OPT_D,
@@ -360,7 +360,7 @@ struct opt_params {
 			  .convert = true,
 			  .minval = 0,
 			  .maxval = UINT_MAX,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SW,
 			  .conflicts = { {.opt = OPT_D,
@@ -375,7 +375,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SECTLOG,
 			  .conflicts = { {.opt = OPT_D,
@@ -384,7 +384,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_SECTSIZE,
 			  .conflicts = { {.opt = OPT_D,
@@ -395,7 +395,7 @@ struct opt_params {
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_SECTORSIZE,
 			  .maxval = XFS_MAX_SECTORSIZE,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_NOALIGN,
 			  .conflicts = { {.opt = OPT_D,
@@ -413,25 +413,25 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
-			  .defaultval = 1,
+			  .flagval = 1,
 			},
 			{ .index = D_RTINHERIT,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 1,
 			  .maxval = 1,
-			  .defaultval = 1,
+			  .flagval = 1,
 			},
 			{ .index = D_PROJINHERIT,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = D_EXTSZINHERIT,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 		},
 	},
@@ -462,7 +462,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
-			  .defaultval = 1,
+			  .flagval = 1,
 			},
 			{ .index = I_LOG,
 			  .conflicts = { {.opt = OPT_I,
@@ -474,13 +474,13 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_DINODE_MIN_LOG,
 			  .maxval = XFS_DINODE_MAX_LOG,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_MAXPCT,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 100,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_PERBLOCK,
 			  .conflicts = { {.opt = OPT_I,
@@ -493,7 +493,7 @@ struct opt_params {
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_INODE_PERBLOCK,
 			  .maxval = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_SIZE,
 			  .conflicts = { {.opt = OPT_I,
@@ -506,7 +506,7 @@ struct opt_params {
 			  .is_power_2 = true,
 			  .minval = XFS_DINODE_MIN_SIZE,
 			  .maxval = XFS_DINODE_MAX_SIZE,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_ATTR,
 			  .conflicts = { {.opt = OPT_M,
@@ -520,7 +520,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 2,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_PROJID32BIT,
 			  .conflicts = { {.opt = OPT_M,
@@ -535,7 +535,7 @@ struct opt_params {
 
 			  .minval = 0,
 			  .maxval = 1,
-			  .defaultval = 1,
+			  .flagval = 1,
 			},
 			{ .index = I_SPINODES,
 			  .conflicts = { {.opt = OPT_M,
@@ -549,7 +549,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
-			  .defaultval = 1,
+			  .flagval = 1,
 			},
 		},
 	},
@@ -579,7 +579,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = UINT_MAX,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_INTERNAL,
 			  .conflicts = { {.opt = OPT_L,
@@ -591,14 +591,14 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
-			  .defaultval = 1,
+			  .flagval = 1,
 			},
 			{ .index = L_SIZE,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .convert = true,
 			  .minval = 2 * 1024 * 1024LL,	/* XXX: XFS_MIN_LOG_BYTES */
 			  .maxval = XFS_MAX_LOG_BYTES,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_VERSION,
 			  .conflicts = {{.opt = OPT_M,
@@ -612,7 +612,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 1,
 			  .maxval = 2,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_SUNIT,
 			  .conflicts = { {.opt = OPT_L,
@@ -621,7 +621,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 1,
 			  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_SU,
 			  .conflicts = { {.opt = OPT_L,
@@ -631,7 +631,7 @@ struct opt_params {
 			  .convert = true,
 			  .minval = BBTOB(1),
 			  .maxval = XLOG_MAX_RECORD_BSIZE,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_DEV,
 			  .conflicts = { {.opt = OPT_L,
@@ -641,7 +641,7 @@ struct opt_params {
 					  .subopt = L_INTERNAL,
 					 },
 					 {LAST_CONFLICT} },
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_SECTLOG,
 			  .conflicts = { {.opt = OPT_L,
@@ -650,7 +650,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_SECTSIZE,
 			  .conflicts = { {.opt = OPT_L,
@@ -661,7 +661,7 @@ struct opt_params {
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_SECTORSIZE,
 			  .maxval = XFS_MAX_SECTORSIZE,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_FILE,
 			  .conflicts = { {.opt = OPT_L,
@@ -670,7 +670,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
-			  .defaultval = 1,
+			  .flagval = 1,
 			},
 			{ .index = L_NAME,
 			  .conflicts = { {.opt = OPT_L,
@@ -680,7 +680,7 @@ struct opt_params {
 					  .subopt = L_INTERNAL,
 					 },
 					 {LAST_CONFLICT} },
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_LAZYSBCNTR,
 			  .conflicts = { {.opt = OPT_M,
@@ -694,7 +694,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
-			  .defaultval = 1,
+			  .flagval = 1,
 			},
 		},
 	},
@@ -716,7 +716,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_REC_DIRSIZE,
 			  .maxval = XFS_MAX_BLOCKSIZE_LOG,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = N_SIZE,
 			  .conflicts = { {.opt = OPT_N,
@@ -727,13 +727,13 @@ struct opt_params {
 			  .is_power_2 = true,
 			  .minval = 1 << XFS_MIN_REC_DIRSIZE,
 			  .maxval = XFS_MAX_BLOCKSIZE,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = N_VERSION,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .minval = 2,
 			  .maxval = 2,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = N_FTYPE,
 			  .conflicts = {  {.opt = OPT_M,
@@ -747,7 +747,7 @@ struct opt_params {
 					  {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
-			  .defaultval = 1,
+			  .flagval = 1,
 			},
 		},
 	},
@@ -769,14 +769,14 @@ struct opt_params {
 			  .convert = true,
 			  .minval = XFS_MIN_RTEXTSIZE,
 			  .maxval = XFS_MAX_RTEXTSIZE,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = R_SIZE,
 			  .conflicts = { {LAST_CONFLICT} },
 			  .convert = true,
 			  .minval = 0,
 			  .maxval = LLONG_MAX,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = R_DEV,
 			  .conflicts = { {.opt = OPT_M,
@@ -788,12 +788,12 @@ struct opt_params {
 					  .message =
 		"rmapbt not supported without CRC support."},
 					 {LAST_CONFLICT} },
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = R_FILE,
 			  .minval = 0,
 			  .maxval = 1,
-			  .defaultval = 1,
+			  .flagval = 1,
 			  .conflicts = { {LAST_CONFLICT} },
 			},
 			{ .index = R_NAME,
@@ -806,12 +806,12 @@ struct opt_params {
 					  .message =
 		"rmapbt not supported without CRC support."},
 					 {LAST_CONFLICT} },
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = R_NOALIGN,
 			  .minval = 0,
 			  .maxval = 1,
-			  .defaultval = 1,
+			  .flagval = 1,
 			  .conflicts = { {LAST_CONFLICT} },
 			},
 		},
@@ -837,7 +837,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = S_SECTLOG,
 			  .conflicts = { {.opt = OPT_S,
@@ -849,7 +849,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
 			  .maxval = XFS_MAX_SECTORSIZE_LOG,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = S_SIZE,
 			  .conflicts = { {.opt = OPT_S,
@@ -863,7 +863,7 @@ struct opt_params {
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_SECTORSIZE,
 			  .maxval = XFS_MAX_SECTORSIZE,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = S_SECTSIZE,
 			  .conflicts = { {.opt = OPT_S,
@@ -877,7 +877,7 @@ struct opt_params {
 			  .is_power_2 = true,
 			  .minval = XFS_MIN_SECTORSIZE,
 			  .maxval = XFS_MAX_SECTORSIZE,
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 		},
 	},
@@ -977,7 +977,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
-			  .defaultval = 1,
+			  .flagval = 1,
 			},
 			{ .index = M_FINOBT,
 			  .conflicts = { {.opt = OPT_M,
@@ -991,11 +991,11 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
-			  .defaultval = 1,
+			  .flagval = 1,
 			},
 			{ .index = M_UUID,
 			  .conflicts = { {LAST_CONFLICT} },
-			  .defaultval = SUBOPT_NEEDS_VAL,
+			  .flagval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = M_RMAPBT,
 			.conflicts = { {.opt = OPT_M,
@@ -1025,7 +1025,7 @@ struct opt_params {
 				       {LAST_CONFLICT} },
 			.minval = 0,
 			.maxval = 1,
-			.defaultval = 0,
+			.flagval = 0,
 			},
 			{ .index = M_REFLINK,
 			.conflicts = { {.opt = OPT_M,
@@ -1039,7 +1039,7 @@ struct opt_params {
 					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
-			  .defaultval = 0,
+			  .flagval = 0,
 			},
 		},
 	},
@@ -1715,10 +1715,10 @@ getnum(
 
 	/* empty strings might just return a default value */
 	if (!str || *str == '\0') {
-		if (sp->defaultval == SUBOPT_NEEDS_VAL)
+		if (sp->flagval == SUBOPT_NEEDS_VAL)
 			reqval(opts->name, (char **)opts->subopts, index);
 		sp->seen = true;
-		return sp->defaultval;
+		return sp->flagval;
 	}
 
 	sp->seen = true;
-- 
2.8.1

