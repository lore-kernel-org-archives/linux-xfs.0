Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7A5C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4B8E22CED
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iyDbv3uH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfIDEhZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:37:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58434 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDEhZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:37:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844aras040765;
        Wed, 4 Sep 2019 04:37:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kN17y487xZ/bDzhKg1BVQ01V6Vo+gxRdB64VZoTaeM0=;
 b=iyDbv3uHJhhDIuu8vkqv80LMVzRHTyGS1O43hO/trJDsQNT/fbtcPrvlBh5fSAV5OSPX
 xCBSHzNu8QnKoPXXeeyhYiipAAIkAbTGXdxQ2iSATeCGmXQDswTRW/Zdj3R8yTwvsOHP
 V4N7ONHvctFi9fJWfJC/4ZAtew5IIhtzF0/iaBS9byPz9IPyXmA2EJ+ABgj3LlswR2Co
 m8GWECtDVvb3M+M6f0rRAftuWiYa3lYjB2eELeThUI+EfI7etLMWLxXUvbkPr35OpBo/
 rKANf37IbIEQkv049zAYO1DKPsGyV4ZU8NpNb3NisdQdGmt2CNw1GbQ5rNwtGOGPBwk8 rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ut6d1r042-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XkCE162997;
        Wed, 4 Sep 2019 04:37:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2usu52bhu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:01 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844b1Rh016089;
        Wed, 4 Sep 2019 04:37:01 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:37:00 -0700
Subject: [PATCH 12/12] libfrog: move libfrog.h to libfrog/util.h
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:36:59 -0700
Message-ID: <156757181991.1838135.14133183998288030723.stgit@magnolia>
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
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move this header to libfrog since the code is there already.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libfrog.h |   11 -----------
 libfrog/fsgeom.c  |    2 +-
 libfrog/util.c    |    2 +-
 libfrog/util.h    |   11 +++++++++++
 mkfs/xfs_mkfs.c   |    2 +-
 repair/sb.c       |    2 +-
 scrub/disk.c      |    2 +-
 scrub/phase1.c    |    2 +-
 8 files changed, 17 insertions(+), 17 deletions(-)
 delete mode 100644 include/libfrog.h
 create mode 100644 libfrog/util.h


diff --git a/include/libfrog.h b/include/libfrog.h
deleted file mode 100644
index d33f0146..00000000
--- a/include/libfrog.h
+++ /dev/null
@@ -1,11 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-#ifndef __LIBFROG_UTIL_H_
-#define __LIBFROG_UTIL_H_
-
-unsigned int	log2_roundup(unsigned int i);
-
-#endif /* __LIBFROG_UTIL_H_ */
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 9a428bf6..bc872834 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -4,7 +4,7 @@
  */
 #include "libxfs.h"
 #include "fsgeom.h"
-#include "libfrog.h"
+#include "util.h"
 
 void
 xfs_report_geom(
diff --git a/libfrog/util.c b/libfrog/util.c
index ff935184..8fb10cf8 100644
--- a/libfrog/util.c
+++ b/libfrog/util.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 #include "platform_defs.h"
-#include "libfrog.h"
+#include "util.h"
 
 /*
  * libfrog is a collection of miscellaneous userspace utilities.
diff --git a/libfrog/util.h b/libfrog/util.h
new file mode 100644
index 00000000..1b97881b
--- /dev/null
+++ b/libfrog/util.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_UTIL_H__
+#define __LIBFROG_UTIL_H__
+
+unsigned int	log2_roundup(unsigned int i);
+
+#endif /* __LIBFROG_UTIL_H__ */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 50913866..6254fd42 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libfrog.h"
+#include "libfrog/util.h"
 #include "libxfs.h"
 #include <ctype.h>
 #include "xfs_multidisk.h"
diff --git a/repair/sb.c b/repair/sb.c
index 3955dfba..91a36dd3 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libfrog.h"
+#include "libfrog/util.h"
 #include "libxfs.h"
 #include "libxcmd.h"
 #include "libxlog.h"
diff --git a/scrub/disk.c b/scrub/disk.c
index 91e13140..dcdd5ba8 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -17,7 +17,7 @@
 # include <linux/hdreg.h>
 #endif
 #include "platform_defs.h"
-#include "libfrog.h"
+#include "libfrog/util.h"
 #include "libfrog/paths.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/phase1.c b/scrub/phase1.c
index d123c419..3211a488 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -13,7 +13,7 @@
 #include <dirent.h>
 #include <stdint.h>
 #include <pthread.h>
-#include "libfrog.h"
+#include "libfrog/util.h"
 #include "libfrog/workqueue.h"
 #include "input.h"
 #include "libfrog/paths.h"

