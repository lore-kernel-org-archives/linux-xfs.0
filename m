Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33813C3A5A4
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0295323402
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:17:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dmkfJBfe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbfIDGRP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 02:17:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45734 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbfIDGRP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 02:17:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8469DNo118032;
        Wed, 4 Sep 2019 06:17:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=eq6tUapnh6ynSf7E11FqJUmu9IMTQUBnXOYxp4+tfq8=;
 b=dmkfJBfeLoGyynAXP1X9E9y4tCQFlAqLAfnMEqmq8c/TgSTiQAOOLQLuODskd9b7mHzF
 cvh67xqAEMgBHXkc+ka8QZa8yXVCN/DTV/OAnCWuYTfZtUxiovHWJor0bCcMvZOJMxOG
 nCC7XJqeBXMM3L4gN9dhQjtz63amTN+TCYgdPvnnzowrIs4YOwX4APLNA1zf/UGe3+m8
 k4ANOUbZon2+bZjcAGoxWwhK8HbW53nkpDeU3wTrk063vy/wKHj4EjNvrvvgVRjQh1+0
 UhfO3k8Y5d9+5M6ypyXt2y6pkIuDwvwJI/4Zvf5TkcnFxd0rYjoWuySI/hI/Z5gyEp+v aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ut7qrg3td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 06:17:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XFW2055557;
        Wed, 4 Sep 2019 04:36:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2us5phmsdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:36:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x844aAML030427;
        Wed, 4 Sep 2019 04:36:10 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:36:10 -0700
Subject: [PATCH 04/12] libfrog: move convert.h to libfrog/
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:36:09 -0700
Message-ID: <156757176903.1838135.5839329434103512872.stgit@magnolia>
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
 definitions=main-1909040066
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move this header to libfrog since the code is there already.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/convert.h |   25 -------------------------
 include/input.h   |    2 +-
 libfrog/Makefile  |    1 +
 libfrog/convert.h |   25 +++++++++++++++++++++++++
 4 files changed, 27 insertions(+), 26 deletions(-)
 delete mode 100644 include/convert.h
 create mode 100644 libfrog/convert.h


diff --git a/include/convert.h b/include/convert.h
deleted file mode 100644
index 0489a1db..00000000
--- a/include/convert.h
+++ /dev/null
@@ -1,25 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-#ifndef __CONVERT_H__
-#define __CONVERT_H__
-
-extern int64_t	cvt_s64(char *s, int base);
-extern int32_t	cvt_s32(char *s, int base);
-extern int16_t	cvt_s16(char *s, int base);
-
-extern uint64_t	cvt_u64(char *s, int base);
-extern uint32_t	cvt_u32(char *s, int base);
-extern uint16_t	cvt_u16(char *s, int base);
-
-extern long long cvtnum(size_t blocksize, size_t sectorsize, char *s);
-extern void cvtstr(double value, char *str, size_t sz);
-extern unsigned long cvttime(char *s);
-
-extern uid_t	uid_from_string(char *user);
-extern gid_t	gid_from_string(char *group);
-extern prid_t	prid_from_string(char *project);
-
-#endif	/* __CONVERT_H__ */
diff --git a/include/input.h b/include/input.h
index 6d8dbcc4..57fdd343 100644
--- a/include/input.h
+++ b/include/input.h
@@ -10,7 +10,7 @@
 #include <grp.h>
 #include <sys/types.h>
 #include "project.h"
-#include "convert.h"
+#include "libfrog/convert.h"
 #include <stdbool.h>
 
 extern char	**breakline(char *input, int *count);
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 2b199b45..5ba32a22 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -31,6 +31,7 @@ HFILES = \
 avl64.h \
 bulkstat.h \
 bitmap.h \
+convert.h \
 crc32defs.h \
 crc32table.h \
 topology.h
diff --git a/libfrog/convert.h b/libfrog/convert.h
new file mode 100644
index 00000000..321540aa
--- /dev/null
+++ b/libfrog/convert.h
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_CONVERT_H__
+#define __LIBFROG_CONVERT_H__
+
+extern int64_t	cvt_s64(char *s, int base);
+extern int32_t	cvt_s32(char *s, int base);
+extern int16_t	cvt_s16(char *s, int base);
+
+extern uint64_t	cvt_u64(char *s, int base);
+extern uint32_t	cvt_u32(char *s, int base);
+extern uint16_t	cvt_u16(char *s, int base);
+
+extern long long cvtnum(size_t blocksize, size_t sectorsize, char *s);
+extern void cvtstr(double value, char *str, size_t sz);
+extern unsigned long cvttime(char *s);
+
+extern uid_t	uid_from_string(char *user);
+extern gid_t	gid_from_string(char *group);
+extern prid_t	prid_from_string(char *project);
+
+#endif	/* __LIBFROG_CONVERT_H__ */

