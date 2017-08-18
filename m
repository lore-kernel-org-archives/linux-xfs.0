Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59726 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750967AbdHRKj1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Aug 2017 06:39:27 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 510C2C04B303
        for <linux-xfs@vger.kernel.org>; Fri, 18 Aug 2017 10:39:27 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] mkfs: rename defaultval to flagval in opts
Date: Fri, 18 Aug 2017 12:39:32 +0200
Message-Id: <20170818103932.24607-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

The old name 'defaultval' was misleading - it is not the default value,
but the value the option has when used as a flag by an user.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
Reviewed-by: Luis R. Rodriguez <mcgrof@kernel.org>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

---
Picked out of my set which may end up not used at all.
---
 mkfs/xfs_mkfs.c | 120 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 60 insertions(+), 60 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7bb6408f..091ca530 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -101,7 +101,7 @@ unsigned int		sectorsize;
  *     to zero. But if one value is different: minval=0 and maxval=1,
  *     then it is OK.)
  *
- *   defaultval MANDATORY
+ *   flagval MANDATORY
  *     The value used if user specifies the subopt, but no value.
  *     If the subopt accepts some values (-d file=[1|0]), then this
  *     sets what is used with simple specifying the subopt (-d file).
@@ -121,7 +121,7 @@ struct opt_params {
 		int		conflicts[MAX_CONFLICTS];
 		long long	minval;
 		long long	maxval;
-		long long	defaultval;
+		long long	flagval;
 	}		subopt_params[MAX_SUBOPTS];
 };
 
@@ -140,7 +140,7 @@ struct opt_params bopts = {
 				 LAST_CONFLICT },
 		  .minval = XFS_MIN_BLOCKSIZE_LOG,
 		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = B_SIZE,
 		  .convert = true,
@@ -149,7 +149,7 @@ struct opt_params bopts = {
 				 LAST_CONFLICT },
 		  .minval = XFS_MIN_BLOCKSIZE,
 		  .maxval = XFS_MAX_BLOCKSIZE,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 	},
 };
@@ -195,24 +195,24 @@ struct opt_params dopts = {
 				 LAST_CONFLICT },
 		  .minval = 1,
 		  .maxval = XFS_MAX_AGNUMBER,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_FILE,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		},
 		{ .index = D_NAME,
 		  .conflicts = { LAST_CONFLICT },
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SIZE,
 		  .conflicts = { LAST_CONFLICT },
 		  .convert = true,
 		  .minval = XFS_AG_MIN_BYTES,
 		  .maxval = LLONG_MAX,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SUNIT,
 		  .conflicts = { D_NOALIGN,
@@ -221,7 +221,7 @@ struct opt_params dopts = {
 				 LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = UINT_MAX,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SWIDTH,
 		  .conflicts = { D_NOALIGN,
@@ -230,7 +230,7 @@ struct opt_params dopts = {
 				 LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = UINT_MAX,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_AGSIZE,
 		  .conflicts = { D_AGCOUNT,
@@ -238,7 +238,7 @@ struct opt_params dopts = {
 		  .convert = true,
 		  .minval = XFS_AG_MIN_BYTES,
 		  .maxval = XFS_AG_MAX_BYTES,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SU,
 		  .conflicts = { D_NOALIGN,
@@ -248,7 +248,7 @@ struct opt_params dopts = {
 		  .convert = true,
 		  .minval = 0,
 		  .maxval = UINT_MAX,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SW,
 		  .conflicts = { D_NOALIGN,
@@ -257,14 +257,14 @@ struct opt_params dopts = {
 				 LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = UINT_MAX,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SECTLOG,
 		  .conflicts = { D_SECTSIZE,
 				 LAST_CONFLICT },
 		  .minval = XFS_MIN_SECTORSIZE_LOG,
 		  .maxval = XFS_MAX_SECTORSIZE_LOG,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_SECTSIZE,
 		  .conflicts = { D_SECTLOG,
@@ -273,7 +273,7 @@ struct opt_params dopts = {
 		  .is_power_2 = true,
 		  .minval = XFS_MIN_SECTORSIZE,
 		  .maxval = XFS_MAX_SECTORSIZE,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_NOALIGN,
 		  .conflicts = { D_SU,
@@ -283,25 +283,25 @@ struct opt_params dopts = {
 				 LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		},
 		{ .index = D_RTINHERIT,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 1,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		},
 		{ .index = D_PROJINHERIT,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = UINT_MAX,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = D_EXTSZINHERIT,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = UINT_MAX,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 	},
 };
@@ -333,7 +333,7 @@ struct opt_params iopts = {
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		},
 		{ .index = I_LOG,
 		  .conflicts = { I_PERBLOCK,
@@ -341,13 +341,13 @@ struct opt_params iopts = {
 				 LAST_CONFLICT },
 		  .minval = XFS_DINODE_MIN_LOG,
 		  .maxval = XFS_DINODE_MAX_LOG,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_MAXPCT,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 100,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_PERBLOCK,
 		  .conflicts = { I_LOG,
@@ -356,7 +356,7 @@ struct opt_params iopts = {
 		  .is_power_2 = true,
 		  .minval = XFS_MIN_INODE_PERBLOCK,
 		  .maxval = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_SIZE,
 		  .conflicts = { I_PERBLOCK,
@@ -365,25 +365,25 @@ struct opt_params iopts = {
 		  .is_power_2 = true,
 		  .minval = XFS_DINODE_MIN_SIZE,
 		  .maxval = XFS_DINODE_MAX_SIZE,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_ATTR,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 2,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = I_PROJID32BIT,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		},
 		{ .index = I_SPINODES,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		},
 	},
 };
@@ -423,7 +423,7 @@ struct opt_params lopts = {
 				 LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = UINT_MAX,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_INTERNAL,
 		  .conflicts = { L_FILE,
@@ -431,27 +431,27 @@ struct opt_params lopts = {
 				 LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		},
 		{ .index = L_SIZE,
 		  .conflicts = { LAST_CONFLICT },
 		  .convert = true,
 		  .minval = 2 * 1024 * 1024LL,	/* XXX: XFS_MIN_LOG_BYTES */
 		  .maxval = XFS_MAX_LOG_BYTES,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_VERSION,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 1,
 		  .maxval = 2,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_SUNIT,
 		  .conflicts = { L_SU,
 				 LAST_CONFLICT },
 		  .minval = 1,
 		  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_SU,
 		  .conflicts = { L_SUNIT,
@@ -459,20 +459,20 @@ struct opt_params lopts = {
 		  .convert = true,
 		  .minval = BBTOB(1),
 		  .maxval = XLOG_MAX_RECORD_BSIZE,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_DEV,
 		  .conflicts = { L_AGNUM,
 				 L_INTERNAL,
 				 LAST_CONFLICT },
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_SECTLOG,
 		  .conflicts = { L_SECTSIZE,
 				 LAST_CONFLICT },
 		  .minval = XFS_MIN_SECTORSIZE_LOG,
 		  .maxval = XFS_MAX_SECTORSIZE_LOG,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_SECTSIZE,
 		  .conflicts = { L_SECTLOG,
@@ -481,26 +481,26 @@ struct opt_params lopts = {
 		  .is_power_2 = true,
 		  .minval = XFS_MIN_SECTORSIZE,
 		  .maxval = XFS_MAX_SECTORSIZE,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_FILE,
 		  .conflicts = { L_INTERNAL,
 				 LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		},
 		{ .index = L_NAME,
 		  .conflicts = { L_AGNUM,
 				 L_INTERNAL,
 				 LAST_CONFLICT },
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_LAZYSBCNTR,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		},
 	},
 };
@@ -524,7 +524,7 @@ struct opt_params nopts = {
 				 LAST_CONFLICT },
 		  .minval = XFS_MIN_REC_DIRSIZE,
 		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = N_SIZE,
 		  .conflicts = { N_LOG,
@@ -533,19 +533,19 @@ struct opt_params nopts = {
 		  .is_power_2 = true,
 		  .minval = 1 << XFS_MIN_REC_DIRSIZE,
 		  .maxval = XFS_MAX_BLOCKSIZE,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = N_VERSION,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 2,
 		  .maxval = 2,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = N_FTYPE,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		},
 	},
 };
@@ -573,33 +573,33 @@ struct opt_params ropts = {
 		  .convert = true,
 		  .minval = XFS_MIN_RTEXTSIZE,
 		  .maxval = XFS_MAX_RTEXTSIZE,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = R_SIZE,
 		  .conflicts = { LAST_CONFLICT },
 		  .convert = true,
 		  .minval = 0,
 		  .maxval = LLONG_MAX,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = R_DEV,
 		  .conflicts = { LAST_CONFLICT },
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = R_FILE,
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		  .conflicts = { LAST_CONFLICT },
 		},
 		{ .index = R_NAME,
 		  .conflicts = { LAST_CONFLICT },
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = R_NOALIGN,
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		  .conflicts = { LAST_CONFLICT },
 		},
 	},
@@ -625,7 +625,7 @@ struct opt_params sopts = {
 				 LAST_CONFLICT },
 		  .minval = XFS_MIN_SECTORSIZE_LOG,
 		  .maxval = XFS_MAX_SECTORSIZE_LOG,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = S_SECTLOG,
 		  .conflicts = { S_SIZE,
@@ -633,7 +633,7 @@ struct opt_params sopts = {
 				 LAST_CONFLICT },
 		  .minval = XFS_MIN_SECTORSIZE_LOG,
 		  .maxval = XFS_MAX_SECTORSIZE_LOG,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = S_SIZE,
 		  .conflicts = { S_LOG,
@@ -643,7 +643,7 @@ struct opt_params sopts = {
 		  .is_power_2 = true,
 		  .minval = XFS_MIN_SECTORSIZE,
 		  .maxval = XFS_MAX_SECTORSIZE,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = S_SECTSIZE,
 		  .conflicts = { S_LOG,
@@ -653,7 +653,7 @@ struct opt_params sopts = {
 		  .is_power_2 = true,
 		  .minval = XFS_MIN_SECTORSIZE,
 		  .maxval = XFS_MAX_SECTORSIZE,
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 	},
 };
@@ -678,29 +678,29 @@ struct opt_params mopts = {
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		},
 		{ .index = M_FINOBT,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		},
 		{ .index = M_UUID,
 		  .conflicts = { LAST_CONFLICT },
-		  .defaultval = SUBOPT_NEEDS_VAL,
+		  .flagval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = M_RMAPBT,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		},
 		{ .index = M_REFLINK,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 1,
+		  .flagval = 1,
 		},
 	},
 };
@@ -1329,9 +1329,9 @@ getnum(
 	check_opt(opts, index, false);
 	/* empty strings might just return a default value */
 	if (!str || *str == '\0') {
-		if (sp->defaultval == SUBOPT_NEEDS_VAL)
+		if (sp->flagval == SUBOPT_NEEDS_VAL)
 			reqval(opts->name, (char **)opts->subopts, index);
-		return sp->defaultval;
+		return sp->flagval;
 	}
 
 	if (sp->minval == 0 && sp->maxval == 0) {
-- 
2.13.3

