Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C934C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 23:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DA3F2176D
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 23:14:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RhUVt0iI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfLRXOT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:14:19 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41854 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfLRXOT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 18:14:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIN9qN2091005;
        Wed, 18 Dec 2019 23:14:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=5a0cftU56Ukoq0rGRnya6i1dDqFYNYBfgGcfVQm/Ybk=;
 b=RhUVt0iIMnVgySd1Xhem5FQy2y9maInWzCW1soBQ83pvtLW6Ad4BLfFTn6VpJ1ZckOax
 X/5qj35lILZP/MJeohrnBjJp1wp1vS9icAMXnF9M+CNFa7QDH9aiAcS5MYdBCmQwS39L
 zLqHUpzKcwKFpweippe5sSSga/r+/pSD5DZVX7kx5FsS9qaueOokcIbbTlEWBSP9emqr
 wr+2tsrflvy4r/B7/p8N5hjJEEh8UhP/LpHShA86p2kjm/8SK1D7yx6iYCvhD5X2XI0w
 JK5wR+ncn8GraWrdfQd3cUcK/pM27KRRwRdB5rrce+3NQMN56dTese6SPhaoTKJTS6lK Zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wvqpqgmf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 23:14:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIN9wKM109073;
        Wed, 18 Dec 2019 23:14:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wyk3bxqtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 23:14:16 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBINEFEv008050;
        Wed, 18 Dec 2019 23:14:16 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 15:14:15 -0800
Subject: [PATCH 2/2] libfrog: move topology.[ch] to libxfs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 18 Dec 2019 15:14:14 -0800
Message-ID: <157671085471.190323.17808121856491080720.stgit@magnolia>
In-Reply-To: <157671084242.190323.8759111252624617622.stgit@magnolia>
References: <157671084242.190323.8759111252624617622.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The functions in libfrog/topology.c rely on internal libxfs symbols and
functions, so move this file from libfrog to libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/Makefile   |    2 --
 libxfs/Makefile    |    2 ++
 libxfs/topology.c  |    4 ++--
 libxfs/topology.h  |    6 +++---
 mkfs/xfs_mkfs.c    |    2 +-
 repair/sb.c        |    2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)
 rename libfrog/topology.c => libxfs/topology.c (99%)
 rename libfrog/topology.h => libxfs/topology.h (88%)


diff --git a/libfrog/Makefile b/libfrog/Makefile
index 780600cd..426fa15f 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -25,7 +25,6 @@ projects.c \
 ptvar.c \
 radix-tree.c \
 scrub.c \
-topology.c \
 util.c \
 workqueue.c
 
@@ -45,7 +44,6 @@ projects.h \
 ptvar.h \
 radix-tree.h \
 scrub.h \
-topology.h \
 workqueue.h
 
 LSRCFILES += gen_crc32table.c
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 8c681e0b..c630a965 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -48,6 +48,7 @@ HFILES = \
 	libxfs_io.h \
 	libxfs_api_defs.h \
 	init.h \
+	topology.h \
 	libxfs_priv.h \
 	xfs_dir2_priv.h
 
@@ -58,6 +59,7 @@ CFILES = cache.c \
 	logitem.c \
 	rdwr.c \
 	trans.c \
+	topology.c \
 	util.c \
 	xfs_ag.c \
 	xfs_ag_resv.c \
diff --git a/libfrog/topology.c b/libxfs/topology.c
similarity index 99%
rename from libfrog/topology.c
rename to libxfs/topology.c
index b1b470c9..9aca1a2b 100644
--- a/libfrog/topology.c
+++ b/libxfs/topology.c
@@ -10,8 +10,8 @@
 #  include <blkid/blkid.h>
 #endif /* ENABLE_BLKID */
 #include "xfs_multidisk.h"
-#include "topology.h"
-#include "platform.h"
+#include "libxfs/topology.h"
+#include "libfrog/platform.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
diff --git a/libfrog/topology.h b/libxfs/topology.h
similarity index 88%
rename from libfrog/topology.h
rename to libxfs/topology.h
index 6fde868a..1a0fe24c 100644
--- a/libfrog/topology.h
+++ b/libxfs/topology.h
@@ -4,8 +4,8 @@
  * All Rights Reserved.
  */
 
-#ifndef __LIBFROG_TOPOLOGY_H__
-#define __LIBFROG_TOPOLOGY_H__
+#ifndef __LIBXFS_TOPOLOGY_H__
+#define __LIBXFS_TOPOLOGY_H__
 
 /*
  * Device topology information.
@@ -36,4 +36,4 @@ extern int
 check_overwrite(
 	const char	*device);
 
-#endif	/* __LIBFROG_TOPOLOGY_H__ */
+#endif	/* __LIBXFS_TOPOLOGY_H__ */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 606f79da..784fe6a9 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -9,7 +9,7 @@
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
 #include "libfrog/fsgeom.h"
-#include "libfrog/topology.h"
+#include "libxfs/topology.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
diff --git a/repair/sb.c b/repair/sb.c
index 91a36dd3..3054cef0 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -12,7 +12,7 @@
 #include "protos.h"
 #include "err_protos.h"
 #include "xfs_multidisk.h"
-#include "libfrog/topology.h"
+#include "libxfs/topology.h"
 
 #define BSIZE	(1024 * 1024)
 

