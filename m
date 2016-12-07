Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40606 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932206AbcLGNhH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 08:37:07 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 96B823D97C
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 13:28:00 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 19/22] mkfs: subopt flags should be saved as bool
Date: Wed,  7 Dec 2016 14:27:26 +0100
Message-Id: <1481117249-21273-20-git-send-email-jtulak@redhat.com>
In-Reply-To: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Flag suboptions are not united in what data type they use internally.
Unify them as boolean.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e8fd49b..9e726f7 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -664,10 +664,10 @@ struct opt_params {
 			},
 			{ .index = D_RTINHERIT,
 			  .conflicts = { {LAST_CONFLICT} },
-			  .minval.u = 1,
-			  .maxval.u = 1,
-			  .flagval.u = 1,
-			  .type = UINT,
+			  .minval.b = false,
+			  .maxval.b = true,
+			  .flagval.b = true,
+			  .type = BOOL,
 			},
 			{ .index = D_PROJINHERIT,
 			  .conflicts = { {LAST_CONFLICT} },
@@ -804,10 +804,10 @@ struct opt_params {
 					  .message = \
 		"Sparse inodes not supported without CRC support."},
 					 {LAST_CONFLICT} },
-			  .minval.i = 0,
-			  .maxval.i = 1,
-			  .flagval.i = 1,
-			  .type = INT,
+			  .minval.b = false,
+			  .maxval.b = true,
+			  .flagval.b = true,
+			  .type = BOOL,
 			},
 		},
 	},
@@ -937,10 +937,10 @@ struct opt_params {
 					  .subopt = L_INTERNAL,
 					 },
 					 {LAST_CONFLICT} },
-			  .minval.i = 0,
-			  .maxval.i = 1,
-			  .flagval.i = 1,
-			  .type = INT,
+			  .minval.b = false,
+			  .maxval.b = true,
+			  .flagval.b = true,
+			  .type = BOOL,
 			},
 			{ .index = L_NAME,
 			  .conflicts = { {.opt = OPT_L,
@@ -1070,10 +1070,10 @@ struct opt_params {
 			  .type = STRING,
 			},
 			{ .index = R_FILE,
-			  .minval.i = 0,
-			  .maxval.i = 1,
-			  .flagval.i = 1,
-			  .type = INT,
+			  .minval.b = false,
+			  .maxval.b = true,
+			  .flagval.b = true,
+			  .type = BOOL,
 			  .conflicts = { {LAST_CONFLICT} },
 			},
 			{ .index = R_NAME,
@@ -1090,10 +1090,10 @@ struct opt_params {
 			  .type = STRING,
 			},
 			{ .index = R_NOALIGN,
-			  .minval.i = 0,
-			  .maxval.i = 1,
-			  .flagval.i = 1,
-			  .type = INT,
+			  .minval.b = false,
+			  .maxval.b = true,
+			  .flagval.b = true,
+			  .type = BOOL,
 			  .conflicts = { {LAST_CONFLICT} },
 			},
 		},
@@ -2193,7 +2193,7 @@ main(
 	xfs_extlen_t		nbmblocks;
 	int			nlflag;
 	int			*nodsflag;
-	int			*norsflag;
+	bool			*norsflag;
 	xfs_alloc_rec_t		*nrec;
 	int			nsflag;
 	int			nvflag;
@@ -2256,7 +2256,7 @@ main(
 	dsu = &opts[OPT_D].subopt_params[D_SU].value.i;
 	dsw = &opts[OPT_D].subopt_params[D_SW].value.i;
 	nodsflag = &opts[OPT_D].subopt_params[D_NOALIGN].value.i;
-	norsflag = &opts[OPT_R].subopt_params[R_NOALIGN].value.i;
+	norsflag = &opts[OPT_R].subopt_params[R_NOALIGN].value.b;
 	logagno = &opts[OPT_L].subopt_params[L_AGNUM].value.u;
 	lsu = &opts[OPT_L].subopt_params[L_SU].value.i;
 	lsunit = &opts[OPT_L].subopt_params[L_SUNIT].value.i;
@@ -2391,7 +2391,7 @@ main(
 					if (c)
 						fsx.fsx_xflags |=
 							XFS_DIFLAG_RTINHERIT;
-					opts[OPT_D].subopt_params[D_RTINHERIT].value.u = c;
+					opts[OPT_D].subopt_params[D_RTINHERIT].value.b = c;
 					break;
 				case D_PROJINHERIT:
 					fsx.fsx_projid = getnum(value, &opts[OPT_D],
@@ -2727,15 +2727,15 @@ main(
 	opts[OPT_D].subopt_params[D_FILE].value.i  = xi.disfile;
 	opts[OPT_D].subopt_params[D_PROJINHERIT].value.u = fsx.fsx_projid;
 	opts[OPT_D].subopt_params[D_EXTSZINHERIT].value.u = fsx.fsx_extsize;
-	opts[OPT_L].subopt_params[L_FILE].value.i = xi.lisfile;
+	opts[OPT_L].subopt_params[L_FILE].value.b = xi.lisfile;
 	opts[OPT_L].subopt_params[L_VERSION].value.i = sb_feat.log_version;
 	opts[OPT_L].subopt_params[L_LAZYSBCNTR].value.b = sb_feat.lazy_sb_counters;
 	opts[OPT_I].subopt_params[I_ATTR].value.i = sb_feat.attr_version ;
 	opts[OPT_I].subopt_params[I_PROJID32BIT].value.b = !sb_feat.projid16bit ;
-	opts[OPT_I].subopt_params[I_SPINODES].value.i = sb_feat.spinodes ;
+	opts[OPT_I].subopt_params[I_SPINODES].value.b = sb_feat.spinodes ;
 	opts[OPT_M].subopt_params[M_FINOBT].value.i = sb_feat.finobt ;
 	opts[OPT_M].subopt_params[M_RMAPBT].value.b = sb_feat.rmapbt ;
-	opts[OPT_R].subopt_params[R_FILE].value.i = xi.risfile ;
+	opts[OPT_R].subopt_params[R_FILE].value.b = xi.risfile ;
 	opts[OPT_R].subopt_params[R_NAME].value.s = xi.rtname;
 	opts[OPT_R].subopt_params[R_DEV].value.s = xi.rtname;
 	opts[OPT_S].subopt_params[S_LOG].value.u = sectorsize;
-- 
2.8.1

