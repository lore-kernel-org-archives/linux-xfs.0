Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 02E8B7CA6
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:42:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5BFDDAC004
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 08:42:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6AOk64XWMOBcgCdt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 08:42:55 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id F066485541
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 15:42:54 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 8/8] mkfs: move conflicts into the table
Date: Tue,  2 Aug 2016 17:42:19 +0200
Message-Id: <1470152539-18759-9-git-send-email-jtulak@redhat.com>
In-Reply-To: <1470152539-18759-1-git-send-email-jtulak@redhat.com>
References: <1470152539-18759-1-git-send-email-jtulak@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jan Tulak <jtulak@redhat.com>

Fill the table with conflicts data and remove now-duplicate code for their
detection from other parts of mkfs.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 109 ++++++++++++++++++++++++++------------------------------
 1 file changed, 50 insertions(+), 59 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 91c7fee..44fa65a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -45,7 +45,7 @@ unsigned int		sectorsize;
 #define MAX_OPTS	16
 #define MAX_SUBOPTS	16
 #define SUBOPT_NEEDS_VAL	(-1LL)
-#define MAX_CONFLICTS	8
+#define MAX_CONFLICTS	32
 #define LAST_CONFLICT	(-1)
 
 #define OPT_B		0
@@ -407,7 +407,9 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = I_ALIGN,
-			  .conflicts = { {LAST_CONFLICT} },
+			  .conflicts = { {OPT_M, M_CRC, true, 1, 0,
+		"Inodes always aligned for CRC enabled filesytems."},
+					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
@@ -445,19 +447,26 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_ATTR,
-			  .conflicts = { {LAST_CONFLICT} },
+			  .conflicts = { {OPT_M, M_CRC, true, 1, 1,
+		"V2 attribute format always enabled on CRC enabled filesytems."},
+					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 2,
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = I_PROJID32BIT,
-			  .conflicts = { {LAST_CONFLICT} },
+			  .conflicts = { {OPT_M, M_CRC, true, 1, 0,
+		"32 bit Project IDs always enabled on CRC enabled filesytems."},
+					 {LAST_CONFLICT} },
+
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
 			},
 			{ .index = I_SPINODES,
-			  .conflicts = { {LAST_CONFLICT} },
+			  .conflicts = { {OPT_M, M_CRC, true, 0, 1,
+		"Sparse inodes not supported without CRC support."},
+					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
@@ -506,7 +515,9 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_VERSION,
-			  .conflicts = { {LAST_CONFLICT} },
+			  .conflicts = { {OPT_M, M_CRC, true, 1, 1,
+				"V2 logs are required for CRC enabled filesystems."},
+					 {LAST_CONFLICT} },
 			  .minval = 1,
 			  .maxval = 2,
 			  .defaultval = SUBOPT_NEEDS_VAL,
@@ -562,7 +573,9 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = L_LAZYSBCNTR,
-			  .conflicts = { {LAST_CONFLICT} },
+			  .conflicts = { {OPT_M, M_CRC, true, 1, 0,
+		"Lazy superblock counted always enabled for CRC enabled filesytems."},
+					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
@@ -603,7 +616,9 @@ struct opt_params {
 			  .defaultval = SUBOPT_NEEDS_VAL,
 			},
 			{ .index = N_FTYPE,
-			  .conflicts = { {LAST_CONFLICT} },
+			  .conflicts = {  {OPT_M, M_CRC, true, 1, 0,
+		"Cannot disable ftype with crcs enabled."},
+					  {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
@@ -719,13 +734,31 @@ struct opt_params {
 		},
 		.subopt_params = {
 			{ .index = M_CRC,
-			  .conflicts = { {LAST_CONFLICT} },
+			  .conflicts = { {OPT_L, L_VERSION, true, 1, 1,
+		"V2 logs are required for CRC enabled filesystems."},
+					 {OPT_I, I_ALIGN, true, 0, 1,
+		"Inodes always aligned for CRC enabled filesytems."},
+					 {OPT_I, I_PROJID32BIT, true, 0, 1,
+		"32 bit Project IDs always enabled on CRC enabled filesytems."},
+					 {OPT_I, I_ATTR, true, 1, 1,
+		"V2 attribute format always enabled on CRC enabled filesytems."},
+					 {OPT_L, L_LAZYSBCNTR, true, 0, 1,
+		"Lazy superblock counted always enabled for CRC enabled filesytems."},
+					 {OPT_M, M_FINOBT, true, 1, 0,
+		"Finobt not supported without CRC support."},
+					 {OPT_I, I_SPINODES, true, 1, 0,
+		"Sparse inodes not supported without CRC support."},
+					 {OPT_N, N_FTYPE, true, 0, 1,
+		"Cannot disable ftype with crcs enabled."},
+					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
 			},
 			{ .index = M_FINOBT,
-			  .conflicts = { {LAST_CONFLICT} },
+			  .conflicts = { {OPT_M, M_CRC, true, 0, 1,
+		"Finobt not supported without CRC support."},
+					 {LAST_CONFLICT} },
 			  .minval = 0,
 			  .maxval = 1,
 			  .defaultval = 1,
@@ -2157,11 +2190,16 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 			XFS_MIN_CRC_BLOCKSIZE);
 		usage();
 	}
+
+	/*
+	 * If user explicitly stated -m crc=1 -n ftype=0, an error was already
+	 * issued. But if -n ftype=0 was stated alone, then it is a conflict
+	 * with a default value for crc enabled and has to be detected here.
+	 */
 	if (sb_feat.crcs_enabled && !sb_feat.dirftype) {
 		fprintf(stderr, _("cannot disable ftype with crcs enabled\n"));
 		usage();
 	}
-
 	if (!slflag && !ssflag) {
 		sectorlog = XFS_MIN_SECTORSIZE_LOG;
 		sectorsize = XFS_MIN_SECTORSIZE;
@@ -2267,42 +2305,6 @@ _("Minimum inode size for CRCs is %d bytes\n"),
 				1 << XFS_DINODE_DFL_CRC_LOG);
 			usage();
 		}
-
-		/* inodes always aligned */
-		if (!sb_feat.inode_align) {
-			fprintf(stderr,
-_("Inodes always aligned for CRC enabled filesytems\n"));
-			usage();
-		}
-
-		/* lazy sb counters always on */
-		if (!sb_feat.lazy_sb_counters) {
-			fprintf(stderr,
-_("Lazy superblock counted always enabled for CRC enabled filesytems\n"));
-			usage();
-		}
-
-		/* version 2 logs always on */
-		if (sb_feat.log_version != 2) {
-			fprintf(stderr,
-_("V2 logs always enabled for CRC enabled filesytems\n"));
-			usage();
-		}
-
-		/* attr2 always on */
-		if (sb_feat.attr_version != 2) {
-			fprintf(stderr,
-_("V2 attribute format always enabled on CRC enabled filesytems\n"));
-			usage();
-		}
-
-		/* 32 bit project quota always on */
-		/* attr2 always on */
-		if (sb_feat.projid16bit) {
-			fprintf(stderr,
-_("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
-			usage();
-		}
 	} else {
 		/*
 		 * The kernel doesn't currently support crc=0,finobt=1
@@ -2310,21 +2312,10 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 		 * explicitly turned finobt on, then silently turn it off to
 		 * avoid an unnecessary warning.
 		 * If the user explicitly tried to use crc=0,finobt=1,
-		 * then issue an error.
+		 * the error was already issued during args parsing.
 		 * The same is also for sparse inodes.
 		 */
-		if (sb_feat.finobt && opts[OPT_M].subopt_params[M_FINOBT].seen) {
-			fprintf(stderr,
-_("finobt not supported without CRC support\n"));
-			usage();
-		}
 		sb_feat.finobt = 0;
-
-		if (sb_feat.spinodes) {
-			fprintf(stderr,
-_("sparse inodes not supported without CRC support\n"));
-			usage();
-		}
 		sb_feat.spinodes = 0;
 
 	}
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
