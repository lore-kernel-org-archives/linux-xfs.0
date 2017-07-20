Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54120 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934694AbdGTJ3l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 05:29:41 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2C72830AF65
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 09:29:41 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 4/7] mkfs: merge tables for opts parsing into one table
Date: Thu, 20 Jul 2017 11:29:29 +0200
Message-Id: <20170720092932.32580-5-jtulak@redhat.com>
In-Reply-To: <20170720092932.32580-1-jtulak@redhat.com>
References: <20170720092932.32580-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Merge separate instances of opt_params into one indexable table. Git
makes this patch look complicated, but it does not change
values or structure of anything else. It only moves all the "struct
opt_params dopts = {...}", changes indentation for these substructures
and replaces their usage (dopts -> opts[OPT_D]).

The reason for this is to be able to address all options from any single one,
even across OPT_X. Right now, we can do automated conflict checks only
within one OPT_X, but after this, it is possible to extend the conflict
declaration to other options as well.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
Change:
 * updated description

---

 mkfs/xfs_mkfs.c | 1316 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 683 insertions(+), 633 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 127f14c3..f10cb15a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -39,6 +39,7 @@ static int  ispow2(unsigned int i);
 unsigned int		blocksize;
 unsigned int		sectorsize;
 
+#define MAX_OPTS	16
 #define MAX_SUBOPTS	16
 #define SUBOPT_NEEDS_VAL	(-1LL)
 #define MAX_CONFLICTS	8
@@ -49,6 +50,10 @@ unsigned int		sectorsize;
  *
  * Description of the structure members follows:
  *
+ * index MANDATORY
+ *   An integer denoting the position of the specific option in opts array,
+ *   counting from 0 up to MAX_OPTS.
+ *
  * name MANDATORY
  *   Name is a single char, e.g., for '-d file', name is 'd'.
  *
@@ -114,6 +119,7 @@ unsigned int		sectorsize;
  *
  */
 struct opt_params {
+	int		index;
 	const char	name;
 	const char	*subopts[MAX_SUBOPTS];
 
@@ -129,584 +135,592 @@ struct opt_params {
 		long long	flagval;
 		const char	*raw_input;
 	}		subopt_params[MAX_SUBOPTS];
-};
-
-struct opt_params bopts = {
-	.name = 'b',
-	.subopts = {
+} opts[MAX_OPTS] = {
+#define OPT_B	0
+	{
+		.index = OPT_B,
+		.name = 'b',
+		.subopts = {
 #define	B_LOG		0
-		"log",
+			"log",
 #define	B_SIZE		1
-		"size",
-		NULL
-	},
-	.subopt_params = {
-		{ .index = B_LOG,
-		  .conflicts = { B_SIZE,
-				 LAST_CONFLICT },
-		  .minval = XFS_MIN_BLOCKSIZE_LOG,
-		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
-		  .flagval = SUBOPT_NEEDS_VAL,
+			"size",
+			NULL
 		},
-		{ .index = B_SIZE,
-		  .convert = true,
-		  .is_power_2 = true,
-		  .conflicts = { B_LOG,
-				 LAST_CONFLICT },
-		  .minval = XFS_MIN_BLOCKSIZE,
-		  .maxval = XFS_MAX_BLOCKSIZE,
-		  .flagval = SUBOPT_NEEDS_VAL,
+		.subopt_params = {
+			{ .index = B_LOG,
+			  .conflicts = { B_SIZE,
+					 LAST_CONFLICT },
+			  .minval = XFS_MIN_BLOCKSIZE_LOG,
+			  .maxval = XFS_MAX_BLOCKSIZE_LOG,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = B_SIZE,
+			  .convert = true,
+			  .is_power_2 = true,
+			  .conflicts = { B_LOG,
+					 LAST_CONFLICT },
+			  .minval = XFS_MIN_BLOCKSIZE,
+			  .maxval = XFS_MAX_BLOCKSIZE,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
 		},
 	},
-};
-
-struct opt_params dopts = {
-	.name = 'd',
-	.subopts = {
-#define	D_AGCOUNT	0
-		"agcount",
-#define	D_FILE		1
-		"file",
-#define	D_NAME		2
-		"name",
-#define	D_SIZE		3
-		"size",
-#define D_SUNIT		4
-		"sunit",
-#define D_SWIDTH	5
-		"swidth",
-#define D_AGSIZE	6
-		"agsize",
-#define D_SU		7
-		"su",
-#define D_SW		8
-		"sw",
-#define D_SECTLOG	9
-		"sectlog",
-#define D_SECTSIZE	10
-		"sectsize",
-#define D_NOALIGN	11
-		"noalign",
-#define D_RTINHERIT	12
-		"rtinherit",
-#define D_PROJINHERIT	13
-		"projinherit",
-#define D_EXTSZINHERIT	14
-		"extszinherit",
-		NULL
-	},
-	.subopt_params = {
-		{ .index = D_AGCOUNT,
-		  .conflicts = { D_AGSIZE,
-				 LAST_CONFLICT },
-		  .minval = 1,
-		  .maxval = XFS_MAX_AGNUMBER,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = D_FILE,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = 1,
-		  .flagval = 1,
-		},
-		{ .index = D_NAME,
-		  .conflicts = { LAST_CONFLICT },
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = D_SIZE,
-		  .conflicts = { LAST_CONFLICT },
-		  .convert = true,
-		  .minval = XFS_AG_MIN_BYTES,
-		  .maxval = LLONG_MAX,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = D_SUNIT,
-		  .conflicts = { D_NOALIGN,
-				 D_SU,
-				 D_SW,
-				 LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = UINT_MAX,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = D_SWIDTH,
-		  .conflicts = { D_NOALIGN,
-				 D_SU,
-				 D_SW,
-				 LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = UINT_MAX,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = D_AGSIZE,
-		  .conflicts = { D_AGCOUNT,
-				 LAST_CONFLICT },
-		  .convert = true,
-		  .minval = XFS_AG_MIN_BYTES,
-		  .maxval = XFS_AG_MAX_BYTES,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = D_SU,
-		  .conflicts = { D_NOALIGN,
-				 D_SUNIT,
-				 D_SWIDTH,
-				 LAST_CONFLICT },
-		  .convert = true,
-		  .minval = 0,
-		  .maxval = UINT_MAX,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = D_SW,
-		  .conflicts = { D_NOALIGN,
-				 D_SUNIT,
-				 D_SWIDTH,
-				 LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = UINT_MAX,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = D_SECTLOG,
-		  .conflicts = { D_SECTSIZE,
-				 LAST_CONFLICT },
-		  .minval = XFS_MIN_SECTORSIZE_LOG,
-		  .maxval = XFS_MAX_SECTORSIZE_LOG,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = D_SECTSIZE,
-		  .conflicts = { D_SECTLOG,
-				 LAST_CONFLICT },
-		  .convert = true,
-		  .is_power_2 = true,
-		  .minval = XFS_MIN_SECTORSIZE,
-		  .maxval = XFS_MAX_SECTORSIZE,
-		  .flagval = SUBOPT_NEEDS_VAL,
+#define OPT_D	1
+	{
+		.index = OPT_D,
+		.name = 'd',
+		.subopts = {
+	#define	D_AGCOUNT	0
+			"agcount",
+	#define	D_FILE		1
+			"file",
+	#define	D_NAME		2
+			"name",
+	#define	D_SIZE		3
+			"size",
+	#define D_SUNIT		4
+			"sunit",
+	#define D_SWIDTH	5
+			"swidth",
+	#define D_AGSIZE	6
+			"agsize",
+	#define D_SU		7
+			"su",
+	#define D_SW		8
+			"sw",
+	#define D_SECTLOG	9
+			"sectlog",
+	#define D_SECTSIZE	10
+			"sectsize",
+	#define D_NOALIGN	11
+			"noalign",
+	#define D_RTINHERIT	12
+			"rtinherit",
+	#define D_PROJINHERIT	13
+			"projinherit",
+	#define D_EXTSZINHERIT	14
+			"extszinherit",
+			NULL
 		},
-		{ .index = D_NOALIGN,
-		  .conflicts = { D_SU,
-				 D_SW,
-				 D_SUNIT,
-				 D_SWIDTH,
-				 LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = 1,
-		  .flagval = 1,
-		},
-		{ .index = D_RTINHERIT,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 1,
-		  .maxval = 1,
-		  .flagval = 1,
-		},
-		{ .index = D_PROJINHERIT,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = UINT_MAX,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = D_EXTSZINHERIT,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = UINT_MAX,
-		  .flagval = SUBOPT_NEEDS_VAL,
+		.subopt_params = {
+			{ .index = D_AGCOUNT,
+			  .conflicts = { D_AGSIZE,
+					 LAST_CONFLICT },
+			  .minval = 1,
+			  .maxval = XFS_MAX_AGNUMBER,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = D_FILE,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = 1,
+			  .flagval = 1,
+			},
+			{ .index = D_NAME,
+			  .conflicts = { LAST_CONFLICT },
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = D_SIZE,
+			  .conflicts = { LAST_CONFLICT },
+			  .convert = true,
+			  .minval = XFS_AG_MIN_BYTES,
+			  .maxval = LLONG_MAX,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = D_SUNIT,
+			  .conflicts = { D_NOALIGN,
+					 D_SU,
+					 D_SW,
+					 LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = UINT_MAX,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = D_SWIDTH,
+			  .conflicts = { D_NOALIGN,
+					 D_SU,
+					 D_SW,
+					 LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = UINT_MAX,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = D_AGSIZE,
+			  .conflicts = { D_AGCOUNT,
+					 LAST_CONFLICT },
+			  .convert = true,
+			  .minval = XFS_AG_MIN_BYTES,
+			  .maxval = XFS_AG_MAX_BYTES,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = D_SU,
+			  .conflicts = { D_NOALIGN,
+					 D_SUNIT,
+					 D_SWIDTH,
+					 LAST_CONFLICT },
+			  .convert = true,
+			  .minval = 0,
+			  .maxval = UINT_MAX,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = D_SW,
+			  .conflicts = { D_NOALIGN,
+					 D_SUNIT,
+					 D_SWIDTH,
+					 LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = UINT_MAX,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = D_SECTLOG,
+			  .conflicts = { D_SECTSIZE,
+					 LAST_CONFLICT },
+			  .minval = XFS_MIN_SECTORSIZE_LOG,
+			  .maxval = XFS_MAX_SECTORSIZE_LOG,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = D_SECTSIZE,
+			  .conflicts = { D_SECTLOG,
+					 LAST_CONFLICT },
+			  .convert = true,
+			  .is_power_2 = true,
+			  .minval = XFS_MIN_SECTORSIZE,
+			  .maxval = XFS_MAX_SECTORSIZE,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = D_NOALIGN,
+			  .conflicts = { D_SU,
+					 D_SW,
+					 D_SUNIT,
+					 D_SWIDTH,
+					 LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = 1,
+			  .flagval = 1,
+			},
+			{ .index = D_RTINHERIT,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = 1,
+			  .flagval = 1,
+			},
+			{ .index = D_PROJINHERIT,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = UINT_MAX,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = D_EXTSZINHERIT,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = UINT_MAX,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
 		},
 	},
-};
-
-
-struct opt_params iopts = {
-	.name = 'i',
-	.subopts = {
+#define OPT_I	2
+	{
+		.index = OPT_I,
+		.name = 'i',
+		.subopts = {
 #define	I_ALIGN		0
-		"align",
+			"align",
 #define	I_LOG		1
-		"log",
+			"log",
 #define	I_MAXPCT	2
-		"maxpct",
+			"maxpct",
 #define	I_PERBLOCK	3
-		"perblock",
+			"perblock",
 #define	I_SIZE		4
-		"size",
+			"size",
 #define	I_ATTR		5
-		"attr",
+			"attr",
 #define	I_PROJID32BIT	6
-		"projid32bit",
+			"projid32bit",
 #define I_SPINODES	7
-		"sparse",
-		NULL
-	},
-	.subopt_params = {
-		{ .index = I_ALIGN,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = 1,
-		  .flagval = 1,
-		},
-		{ .index = I_LOG,
-		  .conflicts = { I_PERBLOCK,
-				 I_SIZE,
-				 LAST_CONFLICT },
-		  .minval = XFS_DINODE_MIN_LOG,
-		  .maxval = XFS_DINODE_MAX_LOG,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = I_MAXPCT,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = 100,
-		  .flagval = SUBOPT_NEEDS_VAL,
+			"sparse",
+			NULL
 		},
-		{ .index = I_PERBLOCK,
-		  .conflicts = { I_LOG,
-				 I_SIZE,
-				 LAST_CONFLICT },
-		  .is_power_2 = true,
-		  .minval = XFS_MIN_INODE_PERBLOCK,
-		  .maxval = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = I_SIZE,
-		  .conflicts = { I_PERBLOCK,
-				 I_LOG,
-				 LAST_CONFLICT },
-		  .is_power_2 = true,
-		  .minval = XFS_DINODE_MIN_SIZE,
-		  .maxval = XFS_DINODE_MAX_SIZE,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = I_ATTR,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = 2,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = I_PROJID32BIT,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = 1,
-		  .flagval = 1,
-		},
-		{ .index = I_SPINODES,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = 1,
-		  .flagval = 1,
+		.subopt_params = {
+			{ .index = I_ALIGN,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = 1,
+			  .flagval = 1,
+			},
+			{ .index = I_LOG,
+			  .conflicts = { I_PERBLOCK,
+					 I_SIZE,
+					 LAST_CONFLICT },
+			  .minval = XFS_DINODE_MIN_LOG,
+			  .maxval = XFS_DINODE_MAX_LOG,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = I_MAXPCT,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = 100,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = I_PERBLOCK,
+			  .conflicts = { I_LOG,
+					 I_SIZE,
+					 LAST_CONFLICT },
+			  .is_power_2 = true,
+			  .minval = XFS_MIN_INODE_PERBLOCK,
+			  .maxval = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = I_SIZE,
+			  .conflicts = { I_PERBLOCK,
+					 I_LOG,
+					 LAST_CONFLICT },
+			  .is_power_2 = true,
+			  .minval = XFS_DINODE_MIN_SIZE,
+			  .maxval = XFS_DINODE_MAX_SIZE,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = I_ATTR,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = 2,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = I_PROJID32BIT,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = 1,
+			  .flagval = 1,
+			},
+			{ .index = I_SPINODES,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = 1,
+			  .flagval = 1,
+			},
 		},
 	},
-};
-
-struct opt_params lopts = {
-	.name = 'l',
-	.subopts = {
-#define	L_AGNUM		0
-		"agnum",
-#define	L_INTERNAL	1
-		"internal",
-#define	L_SIZE		2
-		"size",
-#define L_VERSION	3
-		"version",
-#define L_SUNIT		4
-		"sunit",
-#define L_SU		5
-		"su",
-#define L_DEV		6
-		"logdev",
-#define	L_SECTLOG	7
-		"sectlog",
-#define	L_SECTSIZE	8
-		"sectsize",
-#define	L_FILE		9
-		"file",
-#define	L_NAME		10
-		"name",
-#define	L_LAZYSBCNTR	11
-		"lazy-count",
-		NULL
-	},
-	.subopt_params = {
-		{ .index = L_AGNUM,
-		  .conflicts = { L_DEV,
-				 LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = UINT_MAX,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = L_INTERNAL,
-		  .conflicts = { L_FILE,
-				 L_DEV,
-				 LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = 1,
-		  .flagval = 1,
+#define OPT_L	3
+	{
+		.index = OPT_L,
+		.name = 'l',
+		.subopts = {
+	#define	L_AGNUM		0
+			"agnum",
+	#define	L_INTERNAL	1
+			"internal",
+	#define	L_SIZE		2
+			"size",
+	#define L_VERSION	3
+			"version",
+	#define L_SUNIT		4
+			"sunit",
+	#define L_SU		5
+			"su",
+	#define L_DEV		6
+			"logdev",
+	#define	L_SECTLOG	7
+			"sectlog",
+	#define	L_SECTSIZE	8
+			"sectsize",
+	#define	L_FILE		9
+			"file",
+	#define	L_NAME		10
+			"name",
+	#define	L_LAZYSBCNTR	11
+			"lazy-count",
+			NULL
 		},
-		{ .index = L_SIZE,
-		  .conflicts = { LAST_CONFLICT },
-		  .convert = true,
-		  .minval = 2 * 1024 * 1024LL,	/* XXX: XFS_MIN_LOG_BYTES */
-		  .maxval = XFS_MAX_LOG_BYTES,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = L_VERSION,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 1,
-		  .maxval = 2,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = L_SUNIT,
-		  .conflicts = { L_SU,
-				 LAST_CONFLICT },
-		  .minval = 1,
-		  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = L_SU,
-		  .conflicts = { L_SUNIT,
-				 LAST_CONFLICT },
-		  .convert = true,
-		  .minval = BBTOB(1),
-		  .maxval = XLOG_MAX_RECORD_BSIZE,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = L_DEV,
-		  .conflicts = { L_AGNUM,
-				 L_INTERNAL,
-				 LAST_CONFLICT },
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = L_SECTLOG,
-		  .conflicts = { L_SECTSIZE,
-				 LAST_CONFLICT },
-		  .minval = XFS_MIN_SECTORSIZE_LOG,
-		  .maxval = XFS_MAX_SECTORSIZE_LOG,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = L_SECTSIZE,
-		  .conflicts = { L_SECTLOG,
-				 LAST_CONFLICT },
-		  .convert = true,
-		  .is_power_2 = true,
-		  .minval = XFS_MIN_SECTORSIZE,
-		  .maxval = XFS_MAX_SECTORSIZE,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = L_FILE,
-		  .conflicts = { L_INTERNAL,
-				 LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = 1,
-		  .flagval = 1,
-		},
-		{ .index = L_NAME,
-		  .conflicts = { L_AGNUM,
-				 L_INTERNAL,
-				 LAST_CONFLICT },
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = L_LAZYSBCNTR,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = 1,
-		  .flagval = 1,
+		.subopt_params = {
+			{ .index = L_AGNUM,
+			  .conflicts = { L_DEV,
+					 LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = UINT_MAX,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = L_INTERNAL,
+			  .conflicts = { L_FILE,
+					 L_DEV,
+					 LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = 1,
+			  .flagval = 1,
+			},
+			{ .index = L_SIZE,
+			  .conflicts = { LAST_CONFLICT },
+			  .convert = true,
+			  .minval = 2 * 1024 * 1024LL,	/* XXX: XFS_MIN_LOG_BYTES */
+			  .maxval = XFS_MAX_LOG_BYTES,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = L_VERSION,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 1,
+			  .maxval = 2,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = L_SUNIT,
+			  .conflicts = { L_SU,
+					 LAST_CONFLICT },
+			  .minval = 1,
+			  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = L_SU,
+			  .conflicts = { L_SUNIT,
+					 LAST_CONFLICT },
+			  .convert = true,
+			  .minval = BBTOB(1),
+			  .maxval = XLOG_MAX_RECORD_BSIZE,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = L_DEV,
+			  .conflicts = { L_AGNUM,
+					 L_INTERNAL,
+					 LAST_CONFLICT },
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = L_SECTLOG,
+			  .conflicts = { L_SECTSIZE,
+					 LAST_CONFLICT },
+			  .minval = XFS_MIN_SECTORSIZE_LOG,
+			  .maxval = XFS_MAX_SECTORSIZE_LOG,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = L_SECTSIZE,
+			  .conflicts = { L_SECTLOG,
+					 LAST_CONFLICT },
+			  .convert = true,
+			  .is_power_2 = true,
+			  .minval = XFS_MIN_SECTORSIZE,
+			  .maxval = XFS_MAX_SECTORSIZE,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = L_FILE,
+			  .conflicts = { L_INTERNAL,
+					 LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = 1,
+			  .flagval = 1,
+			},
+			{ .index = L_NAME,
+			  .conflicts = { L_AGNUM,
+					 L_INTERNAL,
+					 LAST_CONFLICT },
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = L_LAZYSBCNTR,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = 1,
+			  .flagval = 1,
+			},
 		},
 	},
-};
-
-struct opt_params nopts = {
-	.name = 'n',
-	.subopts = {
-#define	N_LOG		0
-		"log",
-#define	N_SIZE		1
-		"size",
-#define	N_VERSION	2
-		"version",
-#define	N_FTYPE		3
-		"ftype",
-	NULL,
-	},
-	.subopt_params = {
-		{ .index = N_LOG,
-		  .conflicts = { N_SIZE,
-				 LAST_CONFLICT },
-		  .minval = XFS_MIN_REC_DIRSIZE,
-		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = N_SIZE,
-		  .conflicts = { N_LOG,
-				 LAST_CONFLICT },
-		  .convert = true,
-		  .is_power_2 = true,
-		  .minval = 1 << XFS_MIN_REC_DIRSIZE,
-		  .maxval = XFS_MAX_BLOCKSIZE,
-		  .flagval = SUBOPT_NEEDS_VAL,
+#define OPT_N	4
+	{
+		.index = OPT_N,
+		.name = 'n',
+		.subopts = {
+	#define	N_LOG		0
+			"log",
+	#define	N_SIZE		1
+			"size",
+	#define	N_VERSION	2
+			"version",
+	#define	N_FTYPE		3
+			"ftype",
+		NULL,
 		},
-		{ .index = N_VERSION,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 2,
-		  .maxval = 2,
-		  .flagval = SUBOPT_NEEDS_VAL,
+		.subopt_params = {
+			{ .index = N_LOG,
+			  .conflicts = { N_SIZE,
+					 LAST_CONFLICT },
+			  .minval = XFS_MIN_REC_DIRSIZE,
+			  .maxval = XFS_MAX_BLOCKSIZE_LOG,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = N_SIZE,
+			  .conflicts = { N_LOG,
+					 LAST_CONFLICT },
+			  .convert = true,
+			  .is_power_2 = true,
+			  .minval = 1 << XFS_MIN_REC_DIRSIZE,
+			  .maxval = XFS_MAX_BLOCKSIZE,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = N_VERSION,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 2,
+			  .maxval = 2,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = N_FTYPE,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = 1,
+			  .flagval = 1,
+			},
 		},
-		{ .index = N_FTYPE,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = 1,
-		  .flagval = 1,
-		},
-	},
-};
-
-struct opt_params ropts = {
-	.name = 'r',
-	.subopts = {
-#define	R_EXTSIZE	0
-		"extsize",
-#define	R_SIZE		1
-		"size",
-#define	R_DEV		2
-		"rtdev",
-#define	R_FILE		3
-		"file",
-#define	R_NAME		4
-		"name",
-#define R_NOALIGN	5
-		"noalign",
-		NULL
 	},
-	.subopt_params = {
-		{ .index = R_EXTSIZE,
-		  .conflicts = { LAST_CONFLICT },
-		  .convert = true,
-		  .minval = XFS_MIN_RTEXTSIZE,
-		  .maxval = XFS_MAX_RTEXTSIZE,
-		  .flagval = SUBOPT_NEEDS_VAL,
+#define OPT_R	5
+	{
+		.index = OPT_R,
+		.name = 'r',
+		.subopts = {
+	#define	R_EXTSIZE	0
+			"extsize",
+	#define	R_SIZE		1
+			"size",
+	#define	R_DEV		2
+			"rtdev",
+	#define	R_FILE		3
+			"file",
+	#define	R_NAME		4
+			"name",
+	#define R_NOALIGN	5
+			"noalign",
+			NULL
 		},
-		{ .index = R_SIZE,
-		  .conflicts = { LAST_CONFLICT },
-		  .convert = true,
-		  .minval = 0,
-		  .maxval = LLONG_MAX,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = R_DEV,
-		  .conflicts = { LAST_CONFLICT },
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = R_FILE,
-		  .minval = 0,
-		  .maxval = 1,
-		  .flagval = 1,
-		  .conflicts = { LAST_CONFLICT },
-		},
-		{ .index = R_NAME,
-		  .conflicts = { LAST_CONFLICT },
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = R_NOALIGN,
-		  .minval = 0,
-		  .maxval = 1,
-		  .flagval = 1,
-		  .conflicts = { LAST_CONFLICT },
+		.subopt_params = {
+			{ .index = R_EXTSIZE,
+			  .conflicts = { LAST_CONFLICT },
+			  .convert = true,
+			  .minval = XFS_MIN_RTEXTSIZE,
+			  .maxval = XFS_MAX_RTEXTSIZE,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = R_SIZE,
+			  .conflicts = { LAST_CONFLICT },
+			  .convert = true,
+			  .minval = 0,
+			  .maxval = LLONG_MAX,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = R_DEV,
+			  .conflicts = { LAST_CONFLICT },
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = R_FILE,
+			  .minval = 0,
+			  .maxval = 1,
+			  .flagval = 1,
+			  .conflicts = { LAST_CONFLICT },
+			},
+			{ .index = R_NAME,
+			  .conflicts = { LAST_CONFLICT },
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = R_NOALIGN,
+			  .minval = 0,
+			  .maxval = 1,
+			  .flagval = 1,
+			  .conflicts = { LAST_CONFLICT },
+			},
 		},
 	},
-};
-
-struct opt_params sopts = {
-	.name = 's',
-	.subopts = {
-#define	S_LOG		0
-		"log",
-#define	S_SECTLOG	1
-		"sectlog",
-#define	S_SIZE		2
-		"size",
-#define	S_SECTSIZE	3
-		"sectsize",
-		NULL
-	},
-	.subopt_params = {
-		{ .index = S_LOG,
-		  .conflicts = { S_SIZE,
-				 S_SECTSIZE,
-				 LAST_CONFLICT },
-		  .minval = XFS_MIN_SECTORSIZE_LOG,
-		  .maxval = XFS_MAX_SECTORSIZE_LOG,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = S_SECTLOG,
-		  .conflicts = { S_SIZE,
-				 S_SECTSIZE,
-				 LAST_CONFLICT },
-		  .minval = XFS_MIN_SECTORSIZE_LOG,
-		  .maxval = XFS_MAX_SECTORSIZE_LOG,
-		  .flagval = SUBOPT_NEEDS_VAL,
+#define OPT_S	6
+	{
+		.index = OPT_S,
+		.name = 's',
+		.subopts = {
+	#define	S_LOG		0
+			"log",
+	#define	S_SECTLOG	1
+			"sectlog",
+	#define	S_SIZE		2
+			"size",
+	#define	S_SECTSIZE	3
+			"sectsize",
+			NULL
 		},
-		{ .index = S_SIZE,
-		  .conflicts = { S_LOG,
-				 S_SECTLOG,
-				 LAST_CONFLICT },
-		  .convert = true,
-		  .is_power_2 = true,
-		  .minval = XFS_MIN_SECTORSIZE,
-		  .maxval = XFS_MAX_SECTORSIZE,
-		  .flagval = SUBOPT_NEEDS_VAL,
+		.subopt_params = {
+			{ .index = S_LOG,
+			  .conflicts = { S_SIZE,
+					 S_SECTSIZE,
+					 LAST_CONFLICT },
+			  .minval = XFS_MIN_SECTORSIZE_LOG,
+			  .maxval = XFS_MAX_SECTORSIZE_LOG,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = S_SECTLOG,
+			  .conflicts = { S_SIZE,
+					 S_SECTSIZE,
+					 LAST_CONFLICT },
+			  .minval = XFS_MIN_SECTORSIZE_LOG,
+			  .maxval = XFS_MAX_SECTORSIZE_LOG,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = S_SIZE,
+			  .conflicts = { S_LOG,
+					 S_SECTLOG,
+					 LAST_CONFLICT },
+			  .convert = true,
+			  .is_power_2 = true,
+			  .minval = XFS_MIN_SECTORSIZE,
+			  .maxval = XFS_MAX_SECTORSIZE,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = S_SECTSIZE,
+			  .conflicts = { S_LOG,
+					 S_SECTLOG,
+					 LAST_CONFLICT },
+			  .convert = true,
+			  .is_power_2 = true,
+			  .minval = XFS_MIN_SECTORSIZE,
+			  .maxval = XFS_MAX_SECTORSIZE,
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
 		},
-		{ .index = S_SECTSIZE,
-		  .conflicts = { S_LOG,
-				 S_SECTLOG,
-				 LAST_CONFLICT },
-		  .convert = true,
-		  .is_power_2 = true,
-		  .minval = XFS_MIN_SECTORSIZE,
-		  .maxval = XFS_MAX_SECTORSIZE,
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-	},
-};
-
-struct opt_params mopts = {
-	.name = 'm',
-	.subopts = {
-#define	M_CRC		0
-		"crc",
-#define M_FINOBT	1
-		"finobt",
-#define M_UUID		2
-		"uuid",
-#define M_RMAPBT	3
-		"rmapbt",
-#define M_REFLINK	4
-		"reflink",
-		NULL
 	},
-	.subopt_params = {
-		{ .index = M_CRC,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = 1,
-		  .flagval = 1,
+#define OPT_M	7
+	{
+		.index = OPT_M,
+		.name = 'm',
+		.subopts = {
+	#define	M_CRC		0
+			"crc",
+	#define M_FINOBT	1
+			"finobt",
+	#define M_UUID		2
+			"uuid",
+	#define M_RMAPBT	3
+			"rmapbt",
+	#define M_REFLINK	4
+			"reflink",
+			NULL
 		},
-		{ .index = M_FINOBT,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = 1,
-		  .flagval = 1,
-		},
-		{ .index = M_UUID,
-		  .conflicts = { LAST_CONFLICT },
-		  .flagval = SUBOPT_NEEDS_VAL,
-		},
-		{ .index = M_RMAPBT,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = 1,
-		  .flagval = 1,
-		},
-		{ .index = M_REFLINK,
-		  .conflicts = { LAST_CONFLICT },
-		  .minval = 0,
-		  .maxval = 1,
-		  .flagval = 1,
+		.subopt_params = {
+			{ .index = M_CRC,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = 1,
+			  .flagval = 1,
+			},
+			{ .index = M_FINOBT,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = 1,
+			  .flagval = 1,
+			},
+			{ .index = M_UUID,
+			  .conflicts = { LAST_CONFLICT },
+			  .flagval = SUBOPT_NEEDS_VAL,
+			},
+			{ .index = M_RMAPBT,
+			.conflicts = { LAST_CONFLICT },
+			.minval = 0,
+			.maxval = 1,
+			.flagval = 1,
+			},
+			{ .index = M_REFLINK,
+			  .conflicts = { LAST_CONFLICT },
+			  .minval = 0,
+			  .maxval = 1,
+			  .flagval = 1,
+			},
 		},
 	},
 };
@@ -736,15 +750,15 @@ struct opt_params mopts = {
 #define WHACK_SIZE (128 * 1024)
 
 static inline void
-set_conf_raw(struct opt_params *opt, int subopt, const char *value)
+set_conf_raw(int opt, int subopt, const char *value)
 {
-	opt->subopt_params[subopt].raw_input = value;
+	opts[opt].subopt_params[subopt].raw_input = value;
 }
 
 static inline const char *
-get_conf_raw(const struct opt_params *opt, int subopt)
+get_conf_raw(int opt, int subopt)
 {
-	return opt->subopt_params[subopt].raw_input;
+	return opts[opt].subopt_params[subopt].raw_input;
 }
 
 /*
@@ -1345,7 +1359,7 @@ getnum(
 	long long		c;
 
 	check_opt(opts, index, false);
-	set_conf_raw(opts, index, str);
+	set_conf_raw(opts->index, index, str);
 	/* empty strings might just return a default value */
 	if (!str || *str == '\0') {
 		if (sp->flagval == SUBOPT_NEEDS_VAL)
@@ -1559,17 +1573,19 @@ main(
 		case 'b':
 			p = optarg;
 			while (*p != '\0') {
-				char	**subopts = (char **)bopts.subopts;
+				char	**subopts =
+						(char **)opts[OPT_B].subopts;
 				char	*value;
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case B_LOG:
-					blocklog = getnum(value, &bopts, B_LOG);
+					blocklog = getnum(value, &opts[OPT_B],
+								B_LOG);
 					blocksize = 1 << blocklog;
 					blflag = 1;
 					break;
 				case B_SIZE:
-					blocksize = getnum(value, &bopts,
+					blocksize = getnum(value, &opts[OPT_B],
 							   B_SIZE);
 					blocklog = libxfs_highbit32(blocksize);
 					bsflag = 1;
@@ -1582,74 +1598,82 @@ main(
 		case 'd':
 			p = optarg;
 			while (*p != '\0') {
-				char	**subopts = (char **)dopts.subopts;
+				char	**subopts =
+						(char **)opts[OPT_D].subopts;
 				char	*value;
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case D_AGCOUNT:
-					agcount = getnum(value, &dopts,
+					agcount = getnum(value, &opts[OPT_D],
 							 D_AGCOUNT);
 					daflag = 1;
 					break;
 				case D_AGSIZE:
-					agsize = getnum(value, &dopts, D_AGSIZE);
+					agsize = getnum(value, &opts[OPT_D],
+								D_AGSIZE);
 					dasize = 1;
 					break;
 				case D_FILE:
-					xi.disfile = getnum(value, &dopts,
-							    D_FILE);
+					xi.disfile = getnum(value,
+						&opts[OPT_D], D_FILE);
 					break;
 				case D_NAME:
-					xi.dname = getstr(value, &dopts, D_NAME);
+					xi.dname = getstr(value, &opts[OPT_D],
+								D_NAME);
 					break;
 				case D_SIZE:
-					dbytes = getnum(value, &dopts, D_SIZE);
+					dbytes = getnum(value, &opts[OPT_D],
+								D_SIZE);
 					break;
 				case D_SUNIT:
-					dsunit = getnum(value, &dopts, D_SUNIT);
+					dsunit = getnum(value, &opts[OPT_D],
+								D_SUNIT);
 					break;
 				case D_SWIDTH:
-					dswidth = getnum(value, &dopts,
+					dswidth = getnum(value, &opts[OPT_D],
 							 D_SWIDTH);
 					break;
 				case D_SU:
-					dsu = getnum(value, &dopts, D_SU);
+					dsu = getnum(value, &opts[OPT_D],
+								D_SU);
 					break;
 				case D_SW:
-					dsw = getnum(value, &dopts, D_SW);
+					dsw = getnum(value, &opts[OPT_D],
+								D_SW);
 					break;
 				case D_NOALIGN:
-					nodsflag = getnum(value, &dopts,
+					nodsflag = getnum(value, &opts[OPT_D],
 								D_NOALIGN);
 					break;
 				case D_SECTLOG:
-					sectorlog = getnum(value, &dopts,
+					sectorlog = getnum(value, &opts[OPT_D],
 							   D_SECTLOG);
 					sectorsize = 1 << sectorlog;
 					slflag = 1;
 					break;
 				case D_SECTSIZE:
-					sectorsize = getnum(value, &dopts,
-							    D_SECTSIZE);
+					sectorsize = getnum(value,
+						&opts[OPT_D], D_SECTSIZE);
 					sectorlog =
 						libxfs_highbit32(sectorsize);
 					ssflag = 1;
 					break;
 				case D_RTINHERIT:
-					c = getnum(value, &dopts, D_RTINHERIT);
+					c = getnum(value, &opts[OPT_D],
+								D_RTINHERIT);
 					if (c)
 						fsx.fsx_xflags |=
 							XFS_DIFLAG_RTINHERIT;
 					break;
 				case D_PROJINHERIT:
-					fsx.fsx_projid = getnum(value, &dopts,
-								D_PROJINHERIT);
+					fsx.fsx_projid = getnum(value,
+						&opts[OPT_D], D_PROJINHERIT);
 					fsx.fsx_xflags |=
 						XFS_DIFLAG_PROJINHERIT;
 					break;
 				case D_EXTSZINHERIT:
-					fsx.fsx_extsize = getnum(value, &dopts,
-								 D_EXTSZINHERIT);
+					fsx.fsx_extsize = getnum(value,
+						&opts[OPT_D], D_EXTSZINHERIT);
 					fsx.fsx_xflags |=
 						XFS_DIFLAG_EXTSZINHERIT;
 					break;
@@ -1661,46 +1685,51 @@ main(
 		case 'i':
 			p = optarg;
 			while (*p != '\0') {
-				char	**subopts = (char **)iopts.subopts;
+				char	**subopts =
+						(char **)opts[OPT_I].subopts;
 				char	*value;
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case I_ALIGN:
 					sb_feat.inode_align = getnum(value,
-								&iopts, I_ALIGN);
+						&opts[OPT_I], I_ALIGN);
 					break;
 				case I_LOG:
-					inodelog = getnum(value, &iopts, I_LOG);
+					inodelog = getnum(value, &opts[OPT_I],
+								I_LOG);
 					isize = 1 << inodelog;
 					ilflag = 1;
 					break;
 				case I_MAXPCT:
-					imaxpct = getnum(value, &iopts,
+					imaxpct = getnum(value, &opts[OPT_I],
 							 I_MAXPCT);
 					imflag = 1;
 					break;
 				case I_PERBLOCK:
-					inopblock = getnum(value, &iopts,
+					inopblock = getnum(value, &opts[OPT_I],
 							   I_PERBLOCK);
 					ipflag = 1;
 					break;
 				case I_SIZE:
-					isize = getnum(value, &iopts, I_SIZE);
+					isize = getnum(value, &opts[OPT_I],
+								I_SIZE);
 					inodelog = libxfs_highbit32(isize);
 					isflag = 1;
 					break;
 				case I_ATTR:
 					sb_feat.attr_version =
-						getnum(value, &iopts, I_ATTR);
+						getnum(value, &opts[OPT_I],
+								I_ATTR);
 					break;
 				case I_PROJID32BIT:
 					sb_feat.projid16bit =
-						!getnum(value, &iopts,
+						!getnum(value, &opts[OPT_I],
 							I_PROJID32BIT);
 					break;
 				case I_SPINODES:
 					sb_feat.spinodes = getnum(value,
-							&iopts, I_SPINODES);
+								&opts[OPT_I],
+								I_SPINODES);
 					break;
 				default:
 					unknown('i', value);
@@ -1710,63 +1739,70 @@ main(
 		case 'l':
 			p = optarg;
 			while (*p != '\0') {
-				char	**subopts = (char **)lopts.subopts;
+				char	**subopts =
+						(char **)opts[OPT_L].subopts;
 				char	*value;
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case L_AGNUM:
-					logagno = getnum(value, &lopts, L_AGNUM);
+					logagno = getnum(value, &opts[OPT_L],
+								L_AGNUM);
 					laflag = 1;
 					break;
 				case L_FILE:
-					xi.lisfile = getnum(value, &lopts,
-							    L_FILE);
+					xi.lisfile = getnum(value,
+						&opts[OPT_L], L_FILE);
 					break;
 				case L_INTERNAL:
-					loginternal = getnum(value, &lopts,
-							     L_INTERNAL);
+					loginternal = getnum(value,
+						&opts[OPT_L], L_INTERNAL);
 					liflag = 1;
 					break;
 				case L_SU:
-					lsu = getnum(value, &lopts, L_SU);
+					lsu = getnum(value, &opts[OPT_L],
+								L_SU);
 					lsuflag = 1;
 					break;
 				case L_SUNIT:
-					lsunit = getnum(value, &lopts, L_SUNIT);
+					lsunit = getnum(value, &opts[OPT_L],
+								L_SUNIT);
 					lsunitflag = 1;
 					break;
 				case L_NAME:
 				case L_DEV:
-					logfile = getstr(value, &lopts, L_NAME);
+					logfile = getstr(value, &opts[OPT_L],
+								L_NAME);
 					xi.logname = logfile;
 					ldflag = 1;
 					loginternal = 0;
 					break;
 				case L_VERSION:
 					sb_feat.log_version =
-						getnum(value, &lopts, L_VERSION);
+						getnum(value, &opts[OPT_L],
+								L_VERSION);
 					lvflag = 1;
 					break;
 				case L_SIZE:
-					logbytes = getnum(value, &lopts, L_SIZE);
+					logbytes = getnum(value,
+						&opts[OPT_L], L_SIZE);
 					break;
 				case L_SECTLOG:
-					lsectorlog = getnum(value, &lopts,
-							    L_SECTLOG);
+					lsectorlog = getnum(value,
+						&opts[OPT_L], L_SECTLOG);
 					lsectorsize = 1 << lsectorlog;
 					lslflag = 1;
 					break;
 				case L_SECTSIZE:
-					lsectorsize = getnum(value, &lopts,
-							     L_SECTSIZE);
+					lsectorsize = getnum(value,
+						&opts[OPT_L], L_SECTSIZE);
 					lsectorlog =
 						libxfs_highbit32(lsectorsize);
 					lssflag = 1;
 					break;
 				case L_LAZYSBCNTR:
 					sb_feat.lazy_sb_counters =
-							getnum(value, &lopts,
-							       L_LAZYSBCNTR);
+						getnum(value, &opts[OPT_L],
+							L_LAZYSBCNTR);
 					break;
 				default:
 					unknown('l', value);
@@ -1781,19 +1817,21 @@ main(
 		case 'm':
 			p = optarg;
 			while (*p != '\0') {
-				char	**subopts = (char **)mopts.subopts;
+				char	**subopts =
+						(char **)opts[OPT_M].subopts;
 				char	*value;
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case M_CRC:
 					sb_feat.crcs_enabled =
-						getnum(value, &mopts, M_CRC);
+						getnum(value, &opts[OPT_M],
+								M_CRC);
 					if (sb_feat.crcs_enabled)
 						sb_feat.dirftype = true;
 					break;
 				case M_FINOBT:
 					sb_feat.finobt = getnum(
-						value, &mopts, M_FINOBT);
+						value, &opts[OPT_M], M_FINOBT);
 					break;
 				case M_UUID:
 					if (!value || *value == '\0')
@@ -1803,11 +1841,12 @@ main(
 					break;
 				case M_RMAPBT:
 					sb_feat.rmapbt = getnum(
-						value, &mopts, M_RMAPBT);
+						value, &opts[OPT_M], M_RMAPBT);
 					break;
 				case M_REFLINK:
-					sb_feat.reflink = getnum(
-						value, &mopts, M_REFLINK);
+					sb_feat.reflink =
+						getnum(value, &opts[OPT_M],
+							M_REFLINK);
 					break;
 				default:
 					unknown('m', value);
@@ -1817,38 +1856,41 @@ main(
 		case 'n':
 			p = optarg;
 			while (*p != '\0') {
-				char	**subopts = (char **)nopts.subopts;
+				char	**subopts =
+						(char **)opts[OPT_N].subopts;
 				char	*value;
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case N_LOG:
-					dirblocklog = getnum(value, &nopts,
-							     N_LOG);
+					dirblocklog = getnum(value,
+						&opts[OPT_N], N_LOG);
 					dirblocksize = 1 << dirblocklog;
 					nlflag = 1;
 					break;
 				case N_SIZE:
-					dirblocksize = getnum(value, &nopts,
-							      N_SIZE);
+					dirblocksize = getnum(value,
+						&opts[OPT_N], N_SIZE);
 					dirblocklog =
 						libxfs_highbit32(dirblocksize);
 					nsflag = 1;
 					break;
 				case N_VERSION:
-					value = getstr(value, &nopts, N_VERSION);
+					value = getstr(value, &opts[OPT_N],
+								N_VERSION);
 					if (!strcasecmp(value, "ci")) {
 						/* ASCII CI mode */
 						sb_feat.nci = true;
 					} else {
 						sb_feat.dir_version =
-							getnum(value, &nopts,
+							getnum(value,
+							       &opts[OPT_N],
 							       N_VERSION);
 					}
 					nvflag = 1;
 					break;
 				case N_FTYPE:
-					sb_feat.dirftype = getnum(value, &nopts,
-								  N_FTYPE);
+					sb_feat.dirftype = getnum(value,
+						&opts[OPT_N], N_FTYPE);
 					break;
 				default:
 					unknown('n', value);
@@ -1872,27 +1914,30 @@ main(
 		case 'r':
 			p = optarg;
 			while (*p != '\0') {
-				char	**subopts = (char **)ropts.subopts;
+				char	**subopts =
+						(char **)opts[OPT_R].subopts;
 				char	*value;
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case R_EXTSIZE:
-					rtextbytes = getnum(value, &ropts, R_EXTSIZE);
+					rtextbytes = getnum(value,
+						&opts[OPT_R], R_EXTSIZE);
 					break;
 				case R_FILE:
-					xi.risfile = getnum(value, &ropts,
-							    R_FILE);
+					xi.risfile = getnum(value,
+						&opts[OPT_R], R_FILE);
 					break;
 				case R_NAME:
 				case R_DEV:
-					xi.rtname = getstr(value, &ropts,
+					xi.rtname = getstr(value, &opts[OPT_R],
 							   R_NAME);
 					break;
 				case R_SIZE:
-					rtbytes = getnum(value, &ropts, R_SIZE);
+					rtbytes = getnum(value, &opts[OPT_R],
+								R_SIZE);
 					break;
 				case R_NOALIGN:
-					norsflag = getnum(value, &ropts,
+					norsflag = getnum(value, &opts[OPT_R],
 								R_NOALIGN);
 					break;
 				default:
@@ -1903,7 +1948,8 @@ main(
 		case 's':
 			p = optarg;
 			while (*p != '\0') {
-				char	**subopts = (char **)sopts.subopts;
+				char	**subopts =
+						(char **)opts[OPT_S].subopts;
 				char	*value;
 
 				switch (getsubopt(&p, subopts, &value)) {
@@ -1911,8 +1957,9 @@ main(
 				case S_SECTLOG:
 					if (lssflag)
 						conflict('s', subopts,
-							 S_SECTSIZE, S_SECTLOG);
-					sectorlog = getnum(value, &sopts,
+							 S_SECTSIZE,
+							 S_SECTLOG);
+					sectorlog = getnum(value, &opts[OPT_S],
 							   S_SECTLOG);
 					lsectorlog = sectorlog;
 					sectorsize = 1 << sectorlog;
@@ -1922,10 +1969,11 @@ main(
 				case S_SIZE:
 				case S_SECTSIZE:
 					if (lslflag)
-						conflict('s', subopts, S_SECTLOG,
+						conflict('s', subopts,
+							 S_SECTLOG,
 							 S_SECTSIZE);
-					sectorsize = getnum(value, &sopts,
-							    S_SECTSIZE);
+					sectorsize = getnum(value,
+						&opts[OPT_S], S_SECTSIZE);
 					lsectorsize = sectorsize;
 					sectorlog =
 						libxfs_highbit32(sectorsize);
@@ -1948,7 +1996,8 @@ main(
 		fprintf(stderr, _("extra arguments\n"));
 		usage();
 	} else if (argc - optind == 1) {
-		dfile = xi.volname = getstr(argv[optind], &dopts, D_NAME);
+		dfile = xi.volname = getstr(argv[optind],
+					&opts[OPT_D], D_NAME);
 	} else
 		dfile = xi.dname;
 
@@ -2127,7 +2176,8 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 		 * then issue an error.
 		 * The same is also for sparse inodes.
 		 */
-		if (sb_feat.finobt && mopts.subopt_params[M_FINOBT].seen) {
+		if (sb_feat.finobt &&
+		    opts[OPT_M].subopt_params[M_FINOBT].seen) {
 			fprintf(stderr,
 _("finobt not supported without CRC support\n"));
 			usage();
@@ -2372,7 +2422,7 @@ _("rmapbt not supported with realtime devices\n"));
 		fprintf(stderr,
 			_("size %s specified for data subvolume is too large, "
 			"maximum is %lld blocks\n"),
-			get_conf_raw(&dopts, D_SIZE),
+			get_conf_raw(OPT_D, D_SIZE),
 			(long long)DTOBT(xi.dsize));
 		usage();
 	} else if (!dbytes && xi.dsize > 0)
@@ -2421,7 +2471,7 @@ reported by the device (%u).\n"),
 		fprintf(stderr,
 			_("size %s specified for rt subvolume is too large, "
 			"maximum is %lld blocks\n"),
-			get_conf_raw(&ropts, R_SIZE),
+			get_conf_raw(OPT_R, R_SIZE),
 			(long long)DTOBT(xi.rtsize));
 		usage();
 	} else if (!rtbytes && xi.rtsize > 0)
@@ -2637,7 +2687,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	if (logbytes && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
 		fprintf(stderr,
 _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
-			get_conf_raw(&lopts, L_SIZE),
+			get_conf_raw(OPT_L, L_SIZE),
 			(long long)DTOBT(xi.logBBsize));
 		usage();
 	} else if (!logbytes && xi.logBBsize > 0) {
-- 
2.11.0

