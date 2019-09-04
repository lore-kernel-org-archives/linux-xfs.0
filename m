Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C0AC3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E1C122CED
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:43:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YkQReK7a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfIDEn0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:43:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58046 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728399AbfIDEn0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:43:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844fWBu030410;
        Wed, 4 Sep 2019 04:43:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=d5tKReb/jsZQ6EkNXuwpS9y3Z0SOm5Sjta0Mp9qaFa0=;
 b=YkQReK7aPQOD4e0gk6IzkwgRj22zn+hHH6RSZVPKGd5Cwvy2pOqr/8MMRddj95n5Am1a
 v67jduiiBzfYWVj1EPypAxD2Yx8KLQjcIY1wzPjs9Uge10bAyzy+diNI0+0OIXCTjeHS
 kVaHHXEh8aJChIj6NhkojF6fRg0QW1EeVc1PxXM+59GJgZmaY4eL+0YFaRDNY+qzhYrb
 VEVIv/M0AWIGAfsqsE5caFOFVuKz98bJ9L6VFe/4tx1gooNwoQ9Wh74vrKn0TMWAkaIX
 XZNyvz+1b+dv0JxsgaaRPxO2wmEDU5SFiUC3h+Jl7mhx2be3K66EQg9ZdWHYN8OVj9fN DQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ut6f3005h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:43:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XGuv027504;
        Wed, 4 Sep 2019 04:36:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ut1hmtuyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:36:23 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844aMdv023483;
        Wed, 4 Sep 2019 04:36:23 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:36:22 -0700
Subject: [PATCH 06/12] libfrog: move ptvar.h to libfrog/
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:36:21 -0700
Message-ID: <156757178170.1838135.6590442147207941895.stgit@magnolia>
In-Reply-To: <156757174409.1838135.8885359673458816401.stgit@magnolia>
References: <156757174409.1838135.8885359673458816401.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040048
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move this header to libfrog since the code is there already.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/ptvar.h     |   18 ------------------
 libfrog/Makefile    |    1 +
 libfrog/ptvar.h     |   18 ++++++++++++++++++
 scrub/counter.c     |    2 +-
 scrub/phase7.c      |    2 +-
 scrub/read_verify.c |    2 +-
 6 files changed, 22 insertions(+), 21 deletions(-)
 delete mode 100644 include/ptvar.h
 create mode 100644 libfrog/ptvar.h


diff --git a/include/ptvar.h b/include/ptvar.h
deleted file mode 100644
index 90823da9..00000000
--- a/include/ptvar.h
+++ /dev/null
@@ -1,18 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
- */
-#ifndef LIBFROG_PERCPU_H_
-#define LIBFROG_PERCPU_H_
-
-struct ptvar;
-
-typedef bool (*ptvar_iter_fn)(struct ptvar *ptv, void *data, void *foreach_arg);
-
-struct ptvar *ptvar_init(size_t nr, size_t size);
-void ptvar_free(struct ptvar *ptv);
-void *ptvar_get(struct ptvar *ptv);
-bool ptvar_foreach(struct ptvar *ptv, ptvar_iter_fn fn, void *foreach_arg);
-
-#endif /* LIBFROG_PERCPU_H_ */
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 98f2feb5..25ea248e 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -35,6 +35,7 @@ convert.h \
 crc32defs.h \
 crc32table.h \
 fsgeom.h \
+ptvar.h \
 topology.h
 
 LSRCFILES += gen_crc32table.c
diff --git a/libfrog/ptvar.h b/libfrog/ptvar.h
new file mode 100644
index 00000000..a8803c64
--- /dev/null
+++ b/libfrog/ptvar.h
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __LIBFROG_PTVAR_H__
+#define __LIBFROG_PTVAR_H__
+
+struct ptvar;
+
+typedef bool (*ptvar_iter_fn)(struct ptvar *ptv, void *data, void *foreach_arg);
+
+struct ptvar *ptvar_init(size_t nr, size_t size);
+void ptvar_free(struct ptvar *ptv);
+void *ptvar_get(struct ptvar *ptv);
+bool ptvar_foreach(struct ptvar *ptv, ptvar_iter_fn fn, void *foreach_arg);
+
+#endif /* __LIBFROG_PTVAR_H__ */
diff --git a/scrub/counter.c b/scrub/counter.c
index 4800e751..43444927 100644
--- a/scrub/counter.c
+++ b/scrub/counter.c
@@ -9,7 +9,7 @@
 #include <string.h>
 #include <assert.h>
 #include <pthread.h>
-#include "ptvar.h"
+#include "libfrog/ptvar.h"
 #include "counter.h"
 
 /*
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 8a028e19..8ac1da07 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -8,7 +8,7 @@
 #include <stdlib.h>
 #include <sys/statvfs.h>
 #include "path.h"
-#include "ptvar.h"
+#include "libfrog/ptvar.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "fscounters.h"
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 4a9b91f2..d56f4893 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -7,7 +7,7 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <sys/statvfs.h>
-#include "ptvar.h"
+#include "libfrog/ptvar.h"
 #include "workqueue.h"
 #include "path.h"
 #include "xfs_scrub.h"

