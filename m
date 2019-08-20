Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CCFC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB5732332A
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:31:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TnJPCnJA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbfHTUb2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:31:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45766 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730092AbfHTUb2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:31:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKSw0m151484;
        Tue, 20 Aug 2019 20:31:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=u3BETOqj/MIWmZ7VhcfIEaAgXDWaQH0oW/CF101gXX8=;
 b=TnJPCnJAlYT7yM/bJBmB3ltLjmydZZeAkdLV9BUO9KfMf4xvq6GcqQo9SdNkwhrnbMVU
 yWGOg1YAYLVc7l+kWSaQPGdoMs4CRDECFg7nH2xKWAIO3UzQyit3aJoAUv9Tut5BpGqh
 8sNogac1jCS+BiagqbC1ORrbZKEoKzRLeVGZsgbTsOxJjpQoC/K0G51DtVrX+gBY0r8g
 D2N4+Pcqijq5zRh25RM15XWCagW2w/y7klXQ6rkb3DtLedzXkcrvmKa2+QfgB4jLbCNd
 p7aZRPXfSiApzaIDVyrhgWS6dsg6gNLF8z5LnwzMXh3tCu+k36TMgTwCTCN92eh0Sza7 5g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ue90th5tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:31:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKSo07160309;
        Tue, 20 Aug 2019 20:31:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ug1g9rk6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:31:25 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7KKVPgk028281;
        Tue, 20 Aug 2019 20:31:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:31:24 -0700
Subject: [PATCH 02/12] libxfs: move topology declarations into separate
 header
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:31:24 -0700
Message-ID: <156633308405.1215978.11329921136072672886.stgit@magnolia>
In-Reply-To: <156633307176.1215978.17394956977918540525.stgit@magnolia>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The topology functions live in libfrog now, which means their
declarations don't belong in libxcmd.h.  Create new header file for
them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxcmd.h  |   31 -------------------------------
 include/topology.h |   39 +++++++++++++++++++++++++++++++++++++++
 libfrog/topology.c |    1 +
 mkfs/xfs_mkfs.c    |    2 +-
 repair/sb.c        |    1 +
 5 files changed, 42 insertions(+), 32 deletions(-)
 create mode 100644 include/topology.h


diff --git a/include/libxcmd.h b/include/libxcmd.h
index 20e5d834..7b889b0a 100644
--- a/include/libxcmd.h
+++ b/include/libxcmd.h
@@ -10,35 +10,4 @@
 #include "libxfs.h"
 #include <sys/time.h>
 
-/*
- * Device topology information.
- */
-typedef struct fs_topology {
-	int	dsunit;		/* stripe unit - data subvolume */
-	int	dswidth;	/* stripe width - data subvolume */
-	int	rtswidth;	/* stripe width - rt subvolume */
-	int	lsectorsize;	/* logical sector size &*/
-	int	psectorsize;	/* physical sector size */
-} fs_topology_t;
-
-extern void
-get_topology(
-	libxfs_init_t		*xi,
-	struct fs_topology	*ft,
-	int			force_overwrite);
-
-extern void
-calc_default_ag_geometry(
-	int		blocklog,
-	uint64_t	dblocks,
-	int		multidisk,
-	uint64_t	*agsize,
-	uint64_t	*agcount);
-
-extern int
-check_overwrite(
-	const char	*device);
-
-
-
 #endif	/* __LIBXCMD_H__ */
diff --git a/include/topology.h b/include/topology.h
new file mode 100644
index 00000000..61ede23a
--- /dev/null
+++ b/include/topology.h
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+
+#ifndef __TOPOLOGY_H__
+#define __TOPOLOGY_H__
+
+/*
+ * Device topology information.
+ */
+typedef struct fs_topology {
+	int	dsunit;		/* stripe unit - data subvolume */
+	int	dswidth;	/* stripe width - data subvolume */
+	int	rtswidth;	/* stripe width - rt subvolume */
+	int	lsectorsize;	/* logical sector size &*/
+	int	psectorsize;	/* physical sector size */
+} fs_topology_t;
+
+extern void
+get_topology(
+	libxfs_init_t		*xi,
+	struct fs_topology	*ft,
+	int			force_overwrite);
+
+extern void
+calc_default_ag_geometry(
+	int		blocklog,
+	uint64_t	dblocks,
+	int		multidisk,
+	uint64_t	*agsize,
+	uint64_t	*agcount);
+
+extern int
+check_overwrite(
+	const char	*device);
+
+#endif	/* __TOPOLOGY_H__ */
diff --git a/libfrog/topology.c b/libfrog/topology.c
index cac164f3..e2f87415 100644
--- a/libfrog/topology.c
+++ b/libfrog/topology.c
@@ -10,6 +10,7 @@
 #  include <blkid/blkid.h>
 #endif /* ENABLE_BLKID */
 #include "xfs_multidisk.h"
+#include "topology.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0bdf6ec3..d05a6898 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -9,7 +9,7 @@
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
 #include "fsgeom.h"
-
+#include "topology.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
diff --git a/repair/sb.c b/repair/sb.c
index 119bf219..547969f7 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -12,6 +12,7 @@
 #include "protos.h"
 #include "err_protos.h"
 #include "xfs_multidisk.h"
+#include "topology.h"
 
 #define BSIZE	(1024 * 1024)
 

