Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 320C7C3A5A9
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09EF422CF7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="osIQrFMd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfIDEh0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:37:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58500 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbfIDEhZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:37:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844aSKe040119;
        Wed, 4 Sep 2019 04:37:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=TM2l5QEtQv4Et0fAKIzk0H+fH2wdtQjbwZwuI2USnt0=;
 b=osIQrFMdr/vO061YzJ9PtSmKjGcDfDKF/aI/pDVJVU70Jm7Rx5F7zfEq14ys/L6d6Ht9
 w3ZBK0mhvR6NQAKOsUSowArrzrST+OcmX0b5vZmT6NEYuwAJJgQ2WeI7Mhzw8P+mWZhT
 z853rfBuIHiOvCc5Mn2T7yGcOx9SD9sCtDzelcr7cBOzdKKmyoH+K7lhB5yDfZ4OCCxy
 CrOs2/g+NK3wKfUf+F5CaOh6bvvu6rrGTp3qZjnVzVpjtqT9dLrHZz+/0Ve23XMuWix4
 u4xH9hL8lz7scYzVlD6EF1XEZ75+pKrBjJ/Ft0elN2aTOTjwZacbJojd/TtR6ZexVCmA VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ut6d1r05g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XFRm055573;
        Wed, 4 Sep 2019 04:36:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2us5phmsny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:36:35 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x844aZoA030718;
        Wed, 4 Sep 2019 04:36:35 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:36:35 -0700
Subject: [PATCH 08/12] libfrog: move workqueue.h to libfrog/
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:36:34 -0700
Message-ID: <156757179417.1838135.16722106490569097057.stgit@magnolia>
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
 include/workqueue.h |   41 -----------------------------------------
 libfrog/Makefile    |    3 ++-
 libfrog/workqueue.h |   41 +++++++++++++++++++++++++++++++++++++++++
 repair/threads.h    |    2 +-
 scrub/fscounters.c  |    2 +-
 scrub/inodes.c      |    2 +-
 scrub/phase1.c      |    2 +-
 scrub/phase2.c      |    2 +-
 scrub/phase3.c      |    2 +-
 scrub/phase4.c      |    2 +-
 scrub/phase5.c      |    2 +-
 scrub/phase6.c      |    2 +-
 scrub/read_verify.c |    2 +-
 scrub/spacemap.c    |    2 +-
 scrub/vfs.c         |    2 +-
 15 files changed, 55 insertions(+), 54 deletions(-)
 delete mode 100644 include/workqueue.h
 create mode 100644 libfrog/workqueue.h


diff --git a/include/workqueue.h b/include/workqueue.h
deleted file mode 100644
index c45dc4fb..00000000
--- a/include/workqueue.h
+++ /dev/null
@@ -1,41 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * Copyright (C) 2017 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
- */
-#ifndef	_WORKQUEUE_H_
-#define	_WORKQUEUE_H_
-
-#include <pthread.h>
-
-struct workqueue;
-
-typedef void workqueue_func_t(struct workqueue *wq, uint32_t index, void *arg);
-
-struct workqueue_item {
-	struct workqueue	*queue;
-	struct workqueue_item	*next;
-	workqueue_func_t	*function;
-	void			*arg;
-	uint32_t		index;
-};
-
-struct workqueue {
-	void			*wq_ctx;
-	pthread_t		*threads;
-	struct workqueue_item	*next_item;
-	struct workqueue_item	*last_item;
-	pthread_mutex_t		lock;
-	pthread_cond_t		wakeup;
-	unsigned int		item_count;
-	unsigned int		thread_count;
-	bool			terminate;
-};
-
-int workqueue_create(struct workqueue *wq, void *wq_ctx,
-		unsigned int nr_workers);
-int workqueue_add(struct workqueue *wq, workqueue_func_t fn,
-		uint32_t index, void *arg);
-void workqueue_destroy(struct workqueue *wq);
-
-#endif	/* _WORKQUEUE_H_ */
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 482893ef..5506c96f 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -37,7 +37,8 @@ crc32table.h \
 fsgeom.h \
 ptvar.h \
 radix-tree.h \
-topology.h
+topology.h \
+workqueue.h
 
 LSRCFILES += gen_crc32table.c
 
diff --git a/libfrog/workqueue.h b/libfrog/workqueue.h
new file mode 100644
index 00000000..a1f3a57c
--- /dev/null
+++ b/libfrog/workqueue.h
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef	__LIBFROG_WORKQUEUE_H__
+#define	__LIBFROG_WORKQUEUE_H__
+
+#include <pthread.h>
+
+struct workqueue;
+
+typedef void workqueue_func_t(struct workqueue *wq, uint32_t index, void *arg);
+
+struct workqueue_item {
+	struct workqueue	*queue;
+	struct workqueue_item	*next;
+	workqueue_func_t	*function;
+	void			*arg;
+	uint32_t		index;
+};
+
+struct workqueue {
+	void			*wq_ctx;
+	pthread_t		*threads;
+	struct workqueue_item	*next_item;
+	struct workqueue_item	*last_item;
+	pthread_mutex_t		lock;
+	pthread_cond_t		wakeup;
+	unsigned int		item_count;
+	unsigned int		thread_count;
+	bool			terminate;
+};
+
+int workqueue_create(struct workqueue *wq, void *wq_ctx,
+		unsigned int nr_workers);
+int workqueue_add(struct workqueue *wq, workqueue_func_t fn,
+		uint32_t index, void *arg);
+void workqueue_destroy(struct workqueue *wq);
+
+#endif	/* __LIBFROG_WORKQUEUE_H__ */
diff --git a/repair/threads.h b/repair/threads.h
index 22f74d1f..55c7c632 100644
--- a/repair/threads.h
+++ b/repair/threads.h
@@ -3,7 +3,7 @@
 #ifndef	_XFS_REPAIR_THREADS_H_
 #define	_XFS_REPAIR_THREADS_H_
 
-#include "workqueue.h"
+#include "libfrog/workqueue.h"
 
 void	thread_init(void);
 
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index f8cc1e94..9635c44f 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -11,7 +11,7 @@
 #include "xfs_arch.h"
 #include "xfs_format.h"
 #include "path.h"
-#include "workqueue.h"
+#include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "fscounters.h"
diff --git a/scrub/inodes.c b/scrub/inodes.c
index faffef54..19923de5 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -13,7 +13,7 @@
 #include "xfs_format.h"
 #include "handle.h"
 #include "path.h"
-#include "workqueue.h"
+#include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "inodes.h"
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 23df9a15..d0e77cab 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -14,7 +14,7 @@
 #include <stdint.h>
 #include <pthread.h>
 #include "libfrog.h"
-#include "workqueue.h"
+#include "libfrog/workqueue.h"
 #include "input.h"
 #include "path.h"
 #include "handle.h"
diff --git a/scrub/phase2.c b/scrub/phase2.c
index a80da7fd..baec11dd 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -9,7 +9,7 @@
 #include <sys/statvfs.h>
 #include "list.h"
 #include "path.h"
-#include "workqueue.h"
+#include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "scrub.h"
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 8c02f1cb..64a499c3 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -9,7 +9,7 @@
 #include <sys/statvfs.h>
 #include "list.h"
 #include "path.h"
-#include "workqueue.h"
+#include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "counter.h"
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 49f00723..14074835 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -10,7 +10,7 @@
 #include <sys/statvfs.h>
 #include "list.h"
 #include "path.h"
-#include "workqueue.h"
+#include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "progress.h"
diff --git a/scrub/phase5.c b/scrub/phase5.c
index f3ee22e6..ab015821 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -15,7 +15,7 @@
 #include "handle.h"
 #include "list.h"
 #include "path.h"
-#include "workqueue.h"
+#include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "inodes.h"
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 9b0d228a..d0e62cea 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -9,7 +9,7 @@
 #include <sys/statvfs.h>
 #include "handle.h"
 #include "path.h"
-#include "workqueue.h"
+#include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "libfrog/bitmap.h"
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index d56f4893..828f6be6 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -8,7 +8,7 @@
 #include <stdlib.h>
 #include <sys/statvfs.h>
 #include "libfrog/ptvar.h"
-#include "workqueue.h"
+#include "libfrog/workqueue.h"
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index c3621a3a..774efbaa 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -8,7 +8,7 @@
 #include <string.h>
 #include <pthread.h>
 #include <sys/statvfs.h>
-#include "workqueue.h"
+#include "libfrog/workqueue.h"
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 7b0b5bcd..7d79e7f7 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -10,7 +10,7 @@
 #include <sys/statvfs.h>
 #include "handle.h"
 #include "path.h"
-#include "workqueue.h"
+#include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "vfs.h"

