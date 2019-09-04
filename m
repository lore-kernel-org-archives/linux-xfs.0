Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED01C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 05:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C39EA2339D
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 05:24:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RCohh6X9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbfIDFYu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 01:24:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43830 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfIDFYu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 01:24:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x845OGRU078109;
        Wed, 4 Sep 2019 05:24:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=APU6PGbNXQ6CJZ1IUm8RmbTLXdUbrCsJ3wypJyQ1VGE=;
 b=RCohh6X9Et7rNl8EUikV6vNsK8J4+Z+89/44jvToUEZGHS3YHeeCjCBLq+CO+Es8rFT/
 Gb1vwOqK8Hi05ETJVJgNqXCvdyglEfEcks5t04xGcvjc/IvXTTtZwdKpWuG9hL05mvkC
 1QZ1qbRpUgTj9hRCSVa8kVh2hv/hQURjGtYuY2hX4SohgNEMhTHmcyG0w6xbZfIUL9kw
 EAyxx/2/n6KPpfIDZq/hRxLJIS+icexMd2UuOawvKIEINynQb0eEiEBfM0xicY4rmJbL
 Ou6rxN/m/3eU07GaGlA5JI5ssj/CD27TqNjtMA+uVkgUcTVf50MFDa0WWl901KaB+KyB 9Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ut72b80b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 05:24:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844WmSA022628;
        Wed, 4 Sep 2019 04:35:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2usu51c3ur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:35:51 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x844ZphK030265;
        Wed, 4 Sep 2019 04:35:51 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:35:51 -0700
Subject: [PATCH 01/12] libxfs: move topology declarations into separate
 header
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:35:50 -0700
Message-ID: <156757175033.1838135.4792741261700306188.stgit@magnolia>
In-Reply-To: <156757174409.1838135.8885359673458816401.stgit@magnolia>
References: <156757174409.1838135.8885359673458816401.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040057
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
 libfrog/Makefile   |    3 ++-
 libfrog/topology.c |    1 +
 libfrog/topology.h |   39 +++++++++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c    |    2 +-
 repair/sb.c        |    1 +
 6 files changed, 44 insertions(+), 33 deletions(-)
 create mode 100644 libfrog/topology.h


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
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 4f6a54ab..37976029 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -30,7 +30,8 @@ workqueue.c
 HFILES = \
 bulkstat.h \
 crc32defs.h \
-crc32table.h
+crc32table.h \
+topology.h
 
 LSRCFILES += gen_crc32table.c
 
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
diff --git a/libfrog/topology.h b/libfrog/topology.h
new file mode 100644
index 00000000..6fde868a
--- /dev/null
+++ b/libfrog/topology.h
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+
+#ifndef __LIBFROG_TOPOLOGY_H__
+#define __LIBFROG_TOPOLOGY_H__
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
+#endif	/* __LIBFROG_TOPOLOGY_H__ */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0bdf6ec3..fd6823c5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -9,7 +9,7 @@
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
 #include "fsgeom.h"
-
+#include "libfrog/topology.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
diff --git a/repair/sb.c b/repair/sb.c
index 119bf219..3955dfba 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -12,6 +12,7 @@
 #include "protos.h"
 #include "err_protos.h"
 #include "xfs_multidisk.h"
+#include "libfrog/topology.h"
 
 #define BSIZE	(1024 * 1024)
 

