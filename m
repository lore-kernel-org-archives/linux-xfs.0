Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1A2C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C248622CED
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ojYQ2Zgv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfIDEnP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:43:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57860 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfIDEnO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:43:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844g5Lh031026;
        Wed, 4 Sep 2019 04:43:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=nV0Xyb0PzbL/YpD1dqCGU466g8Cq815jFnv4hrdrSc0=;
 b=ojYQ2ZgvKHc7WTxQX3jCFWeCK6sixQus3vDXmwvpG8+9MJ5kXq3WSLqawb6o6iqHZRDe
 wk6QGIVMHYxSlPkiRBXmA6AL5Mla1J1Kunoyrb4DP7Z8y85wR1/ckX/x5DterhPuCsCD
 ohraghAh9x2/G3JdFWCAbM1tWBMUvcpbE2xw2zXpRUqgpnr8QwCCJzh99qEx7UCeSVlM
 8dvi4++9VOU4UWTEeq5hoDFVoQcyNQyXMTENVC45Dq0Uzh5aqCAa0MH5dloEGC619G2G
 mDNRMlm/zulEcRKMSmd5KG4lAKvsy76/J9H1mrTD0gxggxGu25FMXE46duzkEitXwjZY qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ut6f30056-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:43:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XFR3055541;
        Wed, 4 Sep 2019 04:36:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2us5phmsbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:36:05 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844a4VQ023296;
        Wed, 4 Sep 2019 04:36:04 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:36:03 -0700
Subject: [PATCH 03/12] libfrog: move bitmap.h to libfrog/
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:36:02 -0700
Message-ID: <156757176284.1838135.8194717294650007232.stgit@magnolia>
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
 include/bitmap.h |   24 ------------------------
 libfrog/Makefile |    1 +
 libfrog/bitmap.h |   24 ++++++++++++++++++++++++
 repair/rmap.c    |    2 +-
 scrub/phase6.c   |    2 +-
 5 files changed, 27 insertions(+), 26 deletions(-)
 delete mode 100644 include/bitmap.h
 create mode 100644 libfrog/bitmap.h


diff --git a/include/bitmap.h b/include/bitmap.h
deleted file mode 100644
index 99a2fb23..00000000
--- a/include/bitmap.h
+++ /dev/null
@@ -1,24 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
- */
-#ifndef LIBFROG_BITMAP_H_
-#define LIBFROG_BITMAP_H_
-
-struct bitmap {
-	pthread_mutex_t		bt_lock;
-	struct avl64tree_desc	*bt_tree;
-};
-
-int bitmap_init(struct bitmap **bmap);
-void bitmap_free(struct bitmap **bmap);
-int bitmap_set(struct bitmap *bmap, uint64_t start, uint64_t length);
-int bitmap_iterate(struct bitmap *bmap, int (*fn)(uint64_t, uint64_t, void *),
-		void *arg);
-bool bitmap_test(struct bitmap *bmap, uint64_t start,
-		uint64_t len);
-bool bitmap_empty(struct bitmap *bmap);
-void bitmap_dump(struct bitmap *bmap);
-
-#endif /* LIBFROG_BITMAP_H_ */
diff --git a/libfrog/Makefile b/libfrog/Makefile
index e766adba..2b199b45 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -30,6 +30,7 @@ workqueue.c
 HFILES = \
 avl64.h \
 bulkstat.h \
+bitmap.h \
 crc32defs.h \
 crc32table.h \
 topology.h
diff --git a/libfrog/bitmap.h b/libfrog/bitmap.h
new file mode 100644
index 00000000..40119b9c
--- /dev/null
+++ b/libfrog/bitmap.h
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __LIBFROG_BITMAP_H__
+#define __LIBFROG_BITMAP_H__
+
+struct bitmap {
+	pthread_mutex_t		bt_lock;
+	struct avl64tree_desc	*bt_tree;
+};
+
+int bitmap_init(struct bitmap **bmap);
+void bitmap_free(struct bitmap **bmap);
+int bitmap_set(struct bitmap *bmap, uint64_t start, uint64_t length);
+int bitmap_iterate(struct bitmap *bmap, int (*fn)(uint64_t, uint64_t, void *),
+		void *arg);
+bool bitmap_test(struct bitmap *bmap, uint64_t start,
+		uint64_t len);
+bool bitmap_empty(struct bitmap *bmap);
+void bitmap_dump(struct bitmap *bmap);
+
+#endif /* __LIBFROG_BITMAP_H__ */
diff --git a/repair/rmap.c b/repair/rmap.c
index 47828a06..5dd6557a 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -12,7 +12,7 @@
 #include "dinode.h"
 #include "slab.h"
 #include "rmap.h"
-#include "bitmap.h"
+#include "libfrog/bitmap.h"
 
 #undef RMAP_DEBUG
 
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 5628b926..9b0d228a 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -12,7 +12,7 @@
 #include "workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
-#include "bitmap.h"
+#include "libfrog/bitmap.h"
 #include "disk.h"
 #include "filemap.h"
 #include "fscounters.h"

