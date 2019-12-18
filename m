Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CF7C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 23:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE9A92176D
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 23:14:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gGNNsSYz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfLRXON (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:14:13 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54990 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfLRXON (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 18:14:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIN9gdg113240;
        Wed, 18 Dec 2019 23:14:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=GrVcBrtNA78FptlKlNcR5e+UY7mEu7XSTcaQQSe4lVw=;
 b=gGNNsSYz/bmFoU3T61imPEH852aBkOsed+1TFXTDuQ0g2m+7paU8zOGIpJYN1VPn4Cvm
 oxeEu12NfsqPB+e4LtRUlFpreQLQK/q++6uJyq1gIX7VFL4iImZifGT8GM8q0rMaakWK
 EZTzHz3fuPQCPnnt11JhyB+EnU+f43guDepyBKA812/TjyMbzp29ahNVRneZvrGZhQXx
 6dSOwt5uvAsR+iAzYQwdDjg1ZUuvxZOewgUpGU5444jLLvNbTb7xQKM4yi6EK3Alk49r
 1/LmtToMby2J56roZX/+kuMrLc4roPXo8xc2w0S1KR6YAicqiV1nytv/8v5f+F9N4wPi KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wvq5urrgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 23:14:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIN9pjx064683;
        Wed, 18 Dec 2019 23:14:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wyp08e5sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 23:14:10 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBINE92e008786;
        Wed, 18 Dec 2019 23:14:09 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 15:14:09 -0800
Subject: [PATCH 1/2] libfrog: remove libxfs.h dependencies in fsgeom.c and
 linux.c
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 18 Dec 2019 15:14:08 -0800
Message-ID: <157671084856.190323.6646004639671192722.stgit@magnolia>
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

libfrog isn't supposed to depend on libxfs, so don't include the header
file in the libfrog source code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/fsgeom.c |    4 +++-
 libfrog/linux.c  |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 19a4911f..bd93924e 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -2,7 +2,9 @@
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc. All Rights Reserved.
  */
-#include "libxfs.h"
+#include "platform_defs.h"
+#include "xfs.h"
+#include "bitops.h"
 #include "fsgeom.h"
 #include "util.h"
 
diff --git a/libfrog/linux.c b/libfrog/linux.c
index 79bd79eb..41a168b4 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -9,8 +9,8 @@
 #include <sys/ioctl.h>
 #include <sys/sysinfo.h>
 
-#include "libxfs_priv.h"
-#include "xfs_fs.h"
+#include "platform_defs.h"
+#include "xfs.h"
 #include "init.h"
 
 extern char *progname;

