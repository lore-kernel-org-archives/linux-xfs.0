Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56440 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751595AbeDJFU7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Apr 2018 01:20:59 -0400
Date: Mon, 9 Apr 2018 22:20:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_repair: fix getsubopt name definitions to use enums
Message-ID: <20180410052053.GS7500@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert the getsubopt usage in xfs_repair to use enums and explicitly
initialized array elements, similar to mkfs.  This also fixes the hole
in the o_opts table caused by 42fa89bc1b8dc8 ("xfs_repair: remove
pre_65_beta option") that causes segfaults in xfs/179 and xfs/202.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/xfs_repair.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index b2a2432..ff6a738 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -46,29 +46,37 @@
 /*
  * -o: user-supplied override options
  */
+enum o_opt_nums {
+	ASSUME_XFS = 0,
+	IHASH_SIZE,
+	BHASH_SIZE,
+	AG_STRIDE,
+	FORCE_GEO,
+	PHASE2_THREADS,
+	O_MAX_OPTS,
+};
+
 static char *o_opts[] = {
-#define ASSUME_XFS	0
-	"assume_xfs",
-#define	IHASH_SIZE	2
-	"ihash",
-#define	BHASH_SIZE	3
-	"bhash",
-#define	AG_STRIDE	4
-	"ag_stride",
-#define FORCE_GEO	5
-	"force_geometry",
-#define PHASE2_THREADS	6
-	"phase2_threads",
-	NULL
+	[ASSUME_XFS]		= "assume_xfs",
+	[IHASH_SIZE]		= "ihash",
+	[BHASH_SIZE]		= "bhash",
+	[AG_STRIDE]		= "ag_stride",
+	[FORCE_GEO]		= "force_geometry",
+	[PHASE2_THREADS]	= "phase2_threads",
+	[O_MAX_OPTS]		= NULL,
 };
 
 /*
  * -c: conversion options
  */
+enum c_opt_nums {
+	CONVERT_LAZY_COUNT = 0,
+	C_MAX_OPTS,
+};
+
 static char *c_opts[] = {
-#define CONVERT_LAZY_COUNT	0
-	"lazycount",
-	NULL
+	[CONVERT_LAZY_COUNT]	= "lazycount",
+	[C_MAX_OPTS]		= NULL,
 };
 
 
