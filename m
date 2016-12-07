Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54476 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752278AbcLGNee (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 08:34:34 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EDB22C054929
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 13:27:47 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 07/22] mkfs: Move opts related #define to one place
Date: Wed,  7 Dec 2016 14:27:14 +0100
Message-Id: <1481117249-21273-8-git-send-email-jtulak@redhat.com>
In-Reply-To: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Takes all the "#define M_CRC x" from struct opt_params declaration and moves
them into a single place before the struct. This is because we need to
cross-link conflicts and we can't link -l version to -m crc if M_CRC is defined
after the conflict section.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 138 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 74 insertions(+), 64 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e46b55c..2122d1c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -48,6 +48,80 @@ unsigned int		sectorsize;
 #define MAX_CONFLICTS	8
 #define LAST_CONFLICT	(-1)
 
+#define OPT_B		0
+#define B_LOG		0
+#define B_SIZE		1
+
+#define OPT_D		1
+#define D_AGCOUNT	0
+#define D_FILE		1
+#define D_NAME		2
+#define D_SIZE		3
+#define D_SUNIT 	4
+#define D_SWIDTH	5
+#define D_AGSIZE	6
+#define D_SU		7
+#define D_SW		8
+#define D_SECTLOG	9
+#define D_SECTSIZE	10
+#define D_NOALIGN	11
+#define D_RTINHERIT	12
+#define D_PROJINHERIT	13
+#define D_EXTSZINHERIT	14
+
+
+#define OPT_I		2
+#define I_ALIGN 	0
+#define I_LOG		1
+#define I_MAXPCT	2
+#define I_PERBLOCK	3
+#define I_SIZE		4
+#define I_ATTR		5
+#define I_PROJID32BIT	6
+#define I_SPINODES	7
+
+#define OPT_L		3
+#define L_AGNUM 	0
+#define L_INTERNAL	1
+#define L_SIZE		2
+#define L_VERSION	3
+#define L_SUNIT 	4
+#define L_SU		5
+#define L_DEV		6
+#define L_SECTLOG	7
+#define L_SECTSIZE	8
+#define L_FILE		9
+#define L_NAME		10
+#define L_LAZYSBCNTR	11
+
+
+#define OPT_N		4
+#define N_LOG		0
+#define N_SIZE		1
+#define N_VERSION	2
+#define N_FTYPE 	3
+
+#define OPT_R		5
+#define R_EXTSIZE	0
+#define R_SIZE		1
+#define R_DEV		2
+#define R_FILE		3
+#define R_NAME		4
+#define R_NOALIGN	5
+
+#define OPT_S		6
+#define S_LOG		0
+#define S_SECTLOG	1
+#define S_SIZE		2
+#define S_SECTSIZE	3
+
+#define OPT_M		7
+#define M_CRC		0
+#define M_FINOBT	1
+#define M_UUID		2
+#define M_RMAPBT	3
+#define M_REFLINK	4
+
 /*
  * Table for parsing mkfs parameters.
  *
@@ -155,14 +229,11 @@ struct opt_params {
 		long long	value;
 	}		subopt_params[MAX_SUBOPTS];
 } opts[MAX_OPTS] = {
-#define OPT_B	0
 	{
 		.index = OPT_B,
 		.name = 'b',
 		.subopts = {
-#define	B_LOG		0
 			"log",
-#define	B_SIZE		1
 			"size",
 			NULL
 		},
@@ -185,40 +256,24 @@ struct opt_params {
 			},
 		},
 	},
-#define OPT_D	1
 	{
 		.index = OPT_D,
 		.name = 'd',
 		.subopts = {
-	#define	D_AGCOUNT	0
 			"agcount",
-	#define	D_FILE		1
 			"file",
-	#define	D_NAME		2
 			"name",
-	#define	D_SIZE		3
 			"size",
-	#define D_SUNIT		4
 			"sunit",
-	#define D_SWIDTH	5
 			"swidth",
-	#define D_AGSIZE	6
 			"agsize",
-	#define D_SU		7
 			"su",
-	#define D_SW		8
 			"sw",
-	#define D_SECTLOG	9
 			"sectlog",
-	#define D_SECTSIZE	10
 			"sectsize",
-	#define D_NOALIGN	11
 			"noalign",
-	#define D_RTINHERIT	12
 			"rtinherit",
-	#define D_PROJINHERIT	13
 			"projinherit",
-	#define D_EXTSZINHERIT	14
 			"extszinherit",
 			NULL
 		},
@@ -338,26 +393,17 @@ struct opt_params {
 			},
 		},
 	},
-#define OPT_I	2
 	{
 		.index = OPT_I,
 		.name = 'i',
 		.subopts = {
-#define	I_ALIGN		0
 			"align",
-#define	I_LOG		1
 			"log",
-#define	I_MAXPCT	2
 			"maxpct",
-#define	I_PERBLOCK	3
 			"perblock",
-#define	I_SIZE		4
 			"size",
-#define	I_ATTR		5
 			"attr",
-#define	I_PROJID32BIT	6
 			"projid32bit",
-#define I_SPINODES	7
 			"sparse",
 			NULL
 		},
@@ -420,34 +466,21 @@ struct opt_params {
 			},
 		},
 	},
-#define OPT_L	3
 	{
 		.index = OPT_L,
 		.name = 'l',
 		.subopts = {
-	#define	L_AGNUM		0
 			"agnum",
-	#define	L_INTERNAL	1
 			"internal",
-	#define	L_SIZE		2
 			"size",
-	#define L_VERSION	3
 			"version",
-	#define L_SUNIT		4
 			"sunit",
-	#define L_SU		5
 			"su",
-	#define L_DEV		6
 			"logdev",
-	#define	L_SECTLOG	7
 			"sectlog",
-	#define	L_SECTSIZE	8
 			"sectsize",
-	#define	L_FILE		9
 			"file",
-	#define	L_NAME		10
 			"name",
-	#define	L_LAZYSBCNTR	11
 			"lazy-count",
 			NULL
 		},
@@ -538,18 +571,13 @@ struct opt_params {
 			},
 		},
 	},
-#define OPT_N	4
 	{
 		.index = OPT_N,
 		.name = 'n',
 		.subopts = {
-	#define	N_LOG		0
 			"log",
-	#define	N_SIZE		1
 			"size",
-	#define	N_VERSION	2
 			"version",
-	#define	N_FTYPE		3
 			"ftype",
 		NULL,
 		},
@@ -584,22 +612,15 @@ struct opt_params {
 			},
 		},
 	},
-#define OPT_R	5
 	{
 		.index = OPT_R,
 		.name = 'r',
 		.subopts = {
-	#define	R_EXTSIZE	0
 			"extsize",
-	#define	R_SIZE		1
 			"size",
-	#define	R_DEV		2
 			"rtdev",
-	#define	R_FILE		3
 			"file",
-	#define	R_NAME		4
 			"name",
-	#define R_NOALIGN	5
 			"noalign",
 			NULL
 		},
@@ -640,18 +661,13 @@ struct opt_params {
 			},
 		},
 	},
-#define OPT_S	6
 	{
 		.index = OPT_S,
 		.name = 's',
 		.subopts = {
-	#define	S_LOG		0
 			"log",
-	#define	S_SECTLOG	1
 			"sectlog",
-	#define	S_SIZE		2
 			"size",
-	#define	S_SECTSIZE	3
 			"sectsize",
 			NULL
 		},
@@ -694,20 +710,14 @@ struct opt_params {
 			},
 		},
 	},
-#define OPT_M	7
 	{
 		.index = OPT_M,
 		.name = 'm',
 		.subopts = {
-	#define	M_CRC		0
 			"crc",
-	#define M_FINOBT	1
 			"finobt",
-	#define M_UUID		2
 			"uuid",
-	#define M_RMAPBT	3
 			"rmapbt",
-	#define M_REFLINK	4
 			"reflink",
 			NULL
 		},
-- 
2.8.1

