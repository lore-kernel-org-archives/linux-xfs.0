Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F11CC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 05:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D125520820
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 05:06:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gEA3cEDn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfIDFGb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 01:06:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50362 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfIDFGb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 01:06:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8454SjE048468;
        Wed, 4 Sep 2019 05:06:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=aRDS4SZ+404kV20030w00v1zSrfX+pLYLZk8CwWK+hw=;
 b=gEA3cEDn4aHv8Io4r9GXYilZGlxvBt4u/hRqAke5ECjxozNafgu+HwwnXovbm9jvt+M1
 GoFhT+I0MxjUWO11HkqW6+AQvtQYPFpSxlUGZng0Q8Rjed6CT1HMiuvLfGugWyWw1BZ1
 Srv8YyMVAxudCGbPRdQcrHxnvMe3WAJO3BRrEA+1MmA8ibgFj2v8MDlHlZ8YDlBpzlyY
 IbcghH80N5+lsxYj8rBdsf7DiaRTIA9SyZP0ZAwOvsCb/Av+r0vtH7qcAVlbFNYyHiwQ
 6XqCZEGs8CDtRYsteaP+rv0xkejXn867vumNdYzfZ5x36VwXVf3KAPISmCZNeVVflaAL eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ut6q60191-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 05:06:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844WmNX022648;
        Wed, 4 Sep 2019 04:35:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2usu51c3xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:35:58 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844Zvll023262;
        Wed, 4 Sep 2019 04:35:58 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:35:57 -0700
Subject: [PATCH 02/12] libfrog: move avl64.h to libfrog/
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:35:56 -0700
Message-ID: <156757175652.1838135.13049266190478520193.stgit@magnolia>
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
 definitions=main-1909040053
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move this header to libfrog since the code is there already.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/avl64.h     |  127 ---------------------------------------------------
 libfrog/Makefile    |    1 
 libfrog/avl64.h     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/incore_ext.c |    2 -
 repair/xfs_repair.c |    2 -
 scrub/phase1.c      |    2 -
 6 files changed, 131 insertions(+), 130 deletions(-)
 delete mode 100644 include/avl64.h
 create mode 100644 libfrog/avl64.h


diff --git a/include/avl64.h b/include/avl64.h
deleted file mode 100644
index 4042f6c3..00000000
--- a/include/avl64.h
+++ /dev/null
@@ -1,127 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-#ifndef __XR_AVL64_H__
-#define __XR_AVL64_H__
-
-#include <sys/types.h>
-
-typedef struct	avl64node {
-	struct	avl64node	*avl_forw;	/* pointer to right child  (> parent) */
-	struct	avl64node *avl_back;	/* pointer to left child  (< parent) */
-	struct	avl64node *avl_parent;	/* parent pointer */
-	struct	avl64node *avl_nextino;	/* next in-order; NULL terminated list*/
-	char		 avl_balance;	/* tree balance */
-} avl64node_t;
-
-/*
- * avl-tree operations
- */
-typedef struct avl64ops {
-	uint64_t	(*avl_start)(avl64node_t *);
-	uint64_t	(*avl_end)(avl64node_t *);
-} avl64ops_t;
-
-/*
- * avoid complaints about multiple def's since these are only used by
- * the avl code internally
- */
-#ifndef AVL_START
-#define	AVL_START(tree, n)	(*(tree)->avl_ops->avl_start)(n)
-#define	AVL_END(tree, n)	(*(tree)->avl_ops->avl_end)(n)
-#endif
-
-/*
- * tree descriptor:
- *	root points to the root of the tree.
- *	firstino points to the first in the ordered list.
- */
-typedef struct avl64tree_desc {
-	avl64node_t	*avl_root;
-	avl64node_t	*avl_firstino;
-	avl64ops_t	*avl_ops;
-} avl64tree_desc_t;
-
-/* possible values for avl_balance */
-
-#define AVL_BACK	1
-#define AVL_BALANCE	0
-#define AVL_FORW	2
-
-/*
- * 'Exported' avl tree routines
- */
-avl64node_t
-*avl64_insert(
-	avl64tree_desc_t *tree,
-	avl64node_t *newnode);
-
-void
-avl64_delete(
-	avl64tree_desc_t *tree,
-	avl64node_t *np);
-
-void
-avl64_insert_immediate(
-	avl64tree_desc_t *tree,
-	avl64node_t *afterp,
-	avl64node_t *newnode);
-
-avl64node_t *
-avl64_firstino(avl64node_t *root);
-
-avl64node_t *
-avl64_lastino(avl64node_t *root);
-
-void
-avl64_init_tree(
-	avl64tree_desc_t  *tree,
-	avl64ops_t *ops);
-
-avl64node_t *
-avl64_findrange(
-	avl64tree_desc_t *tree,
-	uint64_t value);
-
-avl64node_t *
-avl64_find(
-	avl64tree_desc_t *tree,
-	uint64_t value);
-
-avl64node_t *
-avl64_findanyrange(
-	avl64tree_desc_t *tree,
-	uint64_t	start,
-	uint64_t	end,
-	int     checklen);
-
-
-avl64node_t *
-avl64_findadjacent(
-	avl64tree_desc_t *tree,
-	uint64_t	value,
-	int		dir);
-
-void
-avl64_findranges(
-	avl64tree_desc_t *tree,
-	uint64_t	start,
-	uint64_t	end,
-	avl64node_t	        **startp,
-	avl64node_t		**endp);
-
-/*
- * avoid complaints about multiple def's since these are only used by
- * the avl code internally
- */
-#ifndef AVL_PRECEED
-#define AVL_PRECEED	0x1
-#define AVL_SUCCEED	0x2
-
-#define AVL_INCLUDE_ZEROLEN	0x0000
-#define AVL_EXCLUDE_ZEROLEN	0x0001
-#endif
-
-#endif /* __XR_AVL64_H__ */
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 37976029..e766adba 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -28,6 +28,7 @@ util.c \
 workqueue.c
 
 HFILES = \
+avl64.h \
 bulkstat.h \
 crc32defs.h \
 crc32table.h \
diff --git a/libfrog/avl64.h b/libfrog/avl64.h
new file mode 100644
index 00000000..283fc91c
--- /dev/null
+++ b/libfrog/avl64.h
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_AVL64_H__
+#define __LIBFROG_AVL64_H__
+
+#include <sys/types.h>
+
+typedef struct	avl64node {
+	struct	avl64node	*avl_forw;	/* pointer to right child  (> parent) */
+	struct	avl64node *avl_back;	/* pointer to left child  (< parent) */
+	struct	avl64node *avl_parent;	/* parent pointer */
+	struct	avl64node *avl_nextino;	/* next in-order; NULL terminated list*/
+	char		 avl_balance;	/* tree balance */
+} avl64node_t;
+
+/*
+ * avl-tree operations
+ */
+typedef struct avl64ops {
+	uint64_t	(*avl_start)(avl64node_t *);
+	uint64_t	(*avl_end)(avl64node_t *);
+} avl64ops_t;
+
+/*
+ * avoid complaints about multiple def's since these are only used by
+ * the avl code internally
+ */
+#ifndef AVL_START
+#define	AVL_START(tree, n)	(*(tree)->avl_ops->avl_start)(n)
+#define	AVL_END(tree, n)	(*(tree)->avl_ops->avl_end)(n)
+#endif
+
+/*
+ * tree descriptor:
+ *	root points to the root of the tree.
+ *	firstino points to the first in the ordered list.
+ */
+typedef struct avl64tree_desc {
+	avl64node_t	*avl_root;
+	avl64node_t	*avl_firstino;
+	avl64ops_t	*avl_ops;
+} avl64tree_desc_t;
+
+/* possible values for avl_balance */
+
+#define AVL_BACK	1
+#define AVL_BALANCE	0
+#define AVL_FORW	2
+
+/*
+ * 'Exported' avl tree routines
+ */
+avl64node_t
+*avl64_insert(
+	avl64tree_desc_t *tree,
+	avl64node_t *newnode);
+
+void
+avl64_delete(
+	avl64tree_desc_t *tree,
+	avl64node_t *np);
+
+void
+avl64_insert_immediate(
+	avl64tree_desc_t *tree,
+	avl64node_t *afterp,
+	avl64node_t *newnode);
+
+avl64node_t *
+avl64_firstino(avl64node_t *root);
+
+avl64node_t *
+avl64_lastino(avl64node_t *root);
+
+void
+avl64_init_tree(
+	avl64tree_desc_t  *tree,
+	avl64ops_t *ops);
+
+avl64node_t *
+avl64_findrange(
+	avl64tree_desc_t *tree,
+	uint64_t value);
+
+avl64node_t *
+avl64_find(
+	avl64tree_desc_t *tree,
+	uint64_t value);
+
+avl64node_t *
+avl64_findanyrange(
+	avl64tree_desc_t *tree,
+	uint64_t	start,
+	uint64_t	end,
+	int     checklen);
+
+
+avl64node_t *
+avl64_findadjacent(
+	avl64tree_desc_t *tree,
+	uint64_t	value,
+	int		dir);
+
+void
+avl64_findranges(
+	avl64tree_desc_t *tree,
+	uint64_t	start,
+	uint64_t	end,
+	avl64node_t	        **startp,
+	avl64node_t		**endp);
+
+/*
+ * avoid complaints about multiple def's since these are only used by
+ * the avl code internally
+ */
+#ifndef AVL_PRECEED
+#define AVL_PRECEED	0x1
+#define AVL_SUCCEED	0x2
+
+#define AVL_INCLUDE_ZEROLEN	0x0000
+#define AVL_EXCLUDE_ZEROLEN	0x0001
+#endif
+
+#endif /* __LIBFROG_AVL64_H__ */
diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index e7ef9eb2..7292f5dc 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -12,7 +12,7 @@
 #include "agheader.h"
 #include "protos.h"
 #include "err_protos.h"
-#include "avl64.h"
+#include "libfrog/avl64.h"
 #include "threads.h"
 
 /*
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index e414c4fb..d7e70dd0 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -9,7 +9,7 @@
 #include <sys/resource.h>
 #include "xfs_multidisk.h"
 #include "avl.h"
-#include "avl64.h"
+#include "libfrog/avl64.h"
 #include "globals.h"
 #include "versions.h"
 #include "agheader.h"
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 81b0990d..6d1cbe25 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -19,7 +19,7 @@
 #include "path.h"
 #include "handle.h"
 #include "bitops.h"
-#include "avl64.h"
+#include "libfrog/avl64.h"
 #include "list.h"
 #include "xfs_scrub.h"
 #include "common.h"

