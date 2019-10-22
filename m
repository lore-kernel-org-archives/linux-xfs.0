Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D0FCA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5806D20B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:48:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ND9t3Hxm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732542AbfJVSsh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:48:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48864 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729696AbfJVSsg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:48:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiEpt089167;
        Tue, 22 Oct 2019 18:48:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=d/gUV+Ntgf+Y3KPdvO2ATREAJpJxBTubkbpwG13rrS8=;
 b=ND9t3Hxms3ehiDS4yVK753Dwb05+xjh4dLVoTl+P1ys8yra9FtE+YmltTBs0z/hICkR6
 QatamXyAI7QIGRIHbrLCmgYlxO35/J5cLH6vNmL8Z/jgIfJC5Zzd78aEJXRt3V6mbDKY
 se0ANv9eMY+zZHnfksaLwd37eaKa3WE1owBFfJM6tytip7oEPZl87Q8RVjYDMpbr2kI8
 9mTjKskjLwaWmMJ+we2EmBaMmYaH+O94tWEG6UqtqrxAAbxHk+P+uNOzHZtZDKqsSBjf
 OltkKaMrJ3ljnZoBv/oSqcI0R1DL8pFbdVnswe/3l8vmd5v/xNgtW/hisUvQgvAyhnH8 EA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vqu4qrk62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiOBp064377;
        Tue, 22 Oct 2019 18:48:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vt2hdke2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:48:33 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MImX6H029817;
        Tue, 22 Oct 2019 18:48:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:48:33 -0700
Subject: [PATCH 4/4] libfrog: take over platform headers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:48:31 -0700
Message-ID: <157177011182.1460186.9452615454342854032.stgit@magnolia>
In-Reply-To: <157177008495.1460186.12329293699422541895.stgit@magnolia>
References: <157177008495.1460186.12329293699422541895.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move all the declarations for platform-specific functions into
libfrog/platform.h, since they're a part of libfrog now.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h    |    1 -
 libfrog/platform.h  |   26 ++++++++++++++++++++++++++
 libfrog/topology.c  |    1 +
 libxfs/init.c       |    1 +
 libxfs/init.h       |   14 --------------
 repair/xfs_repair.c |    1 +
 6 files changed, 29 insertions(+), 15 deletions(-)
 create mode 100644 libfrog/platform.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 0cc0820b..85ced52a 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -134,7 +134,6 @@ extern dev_t	libxfs_device_open (char *, int, int, int);
 extern void	libxfs_device_close (dev_t);
 extern int	libxfs_device_alignment (void);
 extern void	libxfs_report(FILE *);
-extern void	platform_findsizes(char *path, int fd, long long *sz, int *bsz);
 
 /* check or write log footer: specify device, log size in blocks & uuid */
 typedef char	*(libxfs_get_block_t)(char *, int, void *);
diff --git a/libfrog/platform.h b/libfrog/platform.h
new file mode 100644
index 00000000..76887e5e
--- /dev/null
+++ b/libfrog/platform.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+
+#ifndef __LIBFROG_PLATFORM_H__
+#define __LIBFROG_PLATFORM_H__
+
+int platform_check_ismounted(char *path, char *block, struct stat *sptr,
+		int verbose);
+int platform_check_iswritable(char *path, char *block, struct stat *sptr);
+int platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
+		int fatal);
+void platform_flush_device(int fd, dev_t device);
+char *platform_findrawpath(char *path);
+char *platform_findblockpath(char *path);
+int platform_direct_blockdev(void);
+int platform_align_blockdev(void);
+unsigned long platform_physmem(void);	/* in kilobytes */
+void platform_findsizes(char *path, int fd, long long *sz, int *bsz);
+int platform_nproc(void);
+
+void platform_findsizes(char *path, int fd, long long *sz, int *bsz);
+
+#endif /* __LIBFROG_PLATFORM_H__ */
diff --git a/libfrog/topology.c b/libfrog/topology.c
index e2f87415..b1b470c9 100644
--- a/libfrog/topology.c
+++ b/libfrog/topology.c
@@ -11,6 +11,7 @@
 #endif /* ENABLE_BLKID */
 #include "xfs_multidisk.h"
 #include "topology.h"
+#include "platform.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
diff --git a/libxfs/init.c b/libxfs/init.c
index 537b73bd..a0d4b7f4 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -21,6 +21,7 @@
 #include "xfs_trans.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
+#include "libfrog/platform.h"
 
 #include "libxfs.h"		/* for now */
 
diff --git a/libxfs/init.h b/libxfs/init.h
index b23e493c..df49a99a 100644
--- a/libxfs/init.h
+++ b/libxfs/init.h
@@ -9,18 +9,4 @@
 struct stat;
 extern int     use_xfs_buf_lock;
 
-extern int platform_check_ismounted (char *path, char *block,
-					struct stat *sptr, int verbose);
-extern int platform_check_iswritable (char *path, char *block, struct stat *sptr);
-extern int platform_set_blocksize (int fd, char *path, dev_t device, int bsz, int fatal);
-extern void platform_flush_device (int fd, dev_t device);
-extern char *platform_findrawpath(char *path);
-extern char *platform_findrawpath (char *path);
-extern char *platform_findblockpath (char *path);
-extern int platform_direct_blockdev (void);
-extern int platform_align_blockdev (void);
-extern unsigned long platform_physmem(void);	/* in kilobytes */
-extern void platform_findsizes(char *path, int fd, long long *sz, int *bsz);
-extern int platform_nproc(void);
-
 #endif	/* LIBXFS_INIT_H */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index df65b6c5..3338a7b8 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -23,6 +23,7 @@
 #include "slab.h"
 #include "rmap.h"
 #include "libfrog/fsgeom.h"
+#include "libfrog/platform.h"
 
 /*
  * option tables for getsubopt calls

