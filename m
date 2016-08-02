Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 386947CBD
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:42:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0B3CB8F8037
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 08:42:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gtPE6wITbZFEr2sR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 08:42:54 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 022B061E40
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 15:42:54 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 7/8] mkfs: Move opts related #define to one place
Date: Tue,  2 Aug 2016 17:42:18 +0200
Message-Id: <1470152539-18759-8-git-send-email-jtulak@redhat.com>
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

Takes all the "#define M_CRC x" from struct opt_params declaration and moves
them into a single place before the struct. This is because we need to
cross-link conflicts and we can't link -l version to -m crc if M_CRC is defined
after the conflict section.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 134 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 72 insertions(+), 62 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2eca989..91c7fee 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -48,6 +48,78 @@ unsigned int		sectorsize;
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
+
 /*
  * Table for parsing mkfs parameters.
  *
@@ -155,14 +227,11 @@ struct opt_params {
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
@@ -185,40 +254,24 @@ struct opt_params {
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
@@ -338,26 +391,17 @@ struct opt_params {
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
@@ -420,34 +464,21 @@ struct opt_params {
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
@@ -538,18 +569,13 @@ struct opt_params {
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
@@ -584,22 +610,15 @@ struct opt_params {
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
@@ -640,18 +659,13 @@ struct opt_params {
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
@@ -694,16 +708,12 @@ struct opt_params {
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
 			NULL
 		},
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
