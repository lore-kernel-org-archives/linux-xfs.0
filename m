Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3BDC3A5A8
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76C632339D
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:58:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ddAvrmht"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbfIDG6l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 02:58:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41914 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbfIDG6k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 02:58:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x846wcRo157959;
        Wed, 4 Sep 2019 06:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=VDmdS5SGiKMIT+UuVtSKgQVhnHWO9v9X/tkj0zQpuIQ=;
 b=ddAvrmhtQxFH2rJT6t/OH+Dzz7GUzjj2j8fhqpGnH1ES49S7+oIqXrwNwOFzk8gu5Dz5
 W8Cc/b6jTcSNm/KIZeUx5ZkZTJiwvBv9HJkFWvk25z1hkj7mkN42rHFWMRKBpb3k9rb5
 JFTotWouvF3spAgD7hWjj7YEa8AHBLaRJvxvjTjlSunCGiuxL2XEi1AF1lemgWukxm3t
 tlgOTsNVANUI+A9+No/S6zE9OWyf7t9h7ba1BmRepM9cTpThVgOrPX7m/nGZli49+eVS
 ZOWKLHc6/gRy5iaIhoDkcesX10JSSCemfhefDjFyrYuyoa/DByEUtRIkN4sVR/avLce9 sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ut8f2g0cd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 06:58:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XkCN163059;
        Wed, 4 Sep 2019 04:36:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2usu52bh39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:36:29 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x844aTZC004249;
        Wed, 4 Sep 2019 04:36:29 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:36:28 -0700
Subject: [PATCH 07/12] libfrog: move radix-tree.h to libfrog/
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:36:27 -0700
Message-ID: <156757178787.1838135.2734255452017147470.stgit@magnolia>
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
 definitions=main-1909040071
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move this header to libfrog since the code is there already.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/Makefile     |    1 -
 include/libxfs.h     |    2 +-
 include/radix-tree.h |   63 --------------------------------------------------
 libfrog/Makefile     |    1 +
 libfrog/radix-tree.h |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_priv.h |    2 +-
 6 files changed, 66 insertions(+), 66 deletions(-)
 delete mode 100644 include/radix-tree.h
 create mode 100644 libfrog/radix-tree.h


diff --git a/include/Makefile b/include/Makefile
index 7b922420..2a00dea9 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -16,7 +16,6 @@ LIBHFILES = libxfs.h \
 	kmem.h \
 	list.h \
 	parent.h \
-	radix-tree.h \
 	xfs_btree_trace.h \
 	xfs_inode.h \
 	xfs_log_recover.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index dd5fe542..663063bc 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -16,7 +16,7 @@
 #include "cache.h"
 #include "bitops.h"
 #include "kmem.h"
-#include "radix-tree.h"
+#include "libfrog/radix-tree.h"
 #include "atomic.h"
 
 #include "xfs_types.h"
diff --git a/include/radix-tree.h b/include/radix-tree.h
deleted file mode 100644
index 81ee010c..00000000
--- a/include/radix-tree.h
+++ /dev/null
@@ -1,63 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * Copyright (C) 2001 Momchil Velikov
- * Portions Copyright (C) 2001 Christoph Hellwig
- */
-#ifndef __XFS_SUPPORT_RADIX_TREE_H__
-#define __XFS_SUPPORT_RADIX_TREE_H__
-
-#define RADIX_TREE_TAGS
-
-struct radix_tree_root {
-	unsigned int		height;
-	struct radix_tree_node	*rnode;
-};
-
-#define RADIX_TREE_INIT(mask)	{					\
-	.height = 0,							\
-	.rnode = NULL,							\
-}
-
-#define RADIX_TREE(name, mask) \
-	struct radix_tree_root name = RADIX_TREE_INIT(mask)
-
-#define INIT_RADIX_TREE(root, mask)					\
-do {									\
-	(root)->height = 0;						\
-	(root)->rnode = NULL;						\
-} while (0)
-
-#ifdef RADIX_TREE_TAGS
-#define RADIX_TREE_MAX_TAGS 2
-#endif
-
-int radix_tree_insert(struct radix_tree_root *, unsigned long, void *);
-void *radix_tree_lookup(struct radix_tree_root *, unsigned long);
-void **radix_tree_lookup_slot(struct radix_tree_root *, unsigned long);
-void *radix_tree_lookup_first(struct radix_tree_root *, unsigned long *);
-void *radix_tree_delete(struct radix_tree_root *, unsigned long);
-unsigned int
-radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
-			unsigned long first_index, unsigned int max_items);
-unsigned int
-radix_tree_gang_lookup_ex(struct radix_tree_root *root, void **results,
-			unsigned long first_index, unsigned long last_index,
-			unsigned int max_items);
-
-void radix_tree_init(void);
-
-#ifdef RADIX_TREE_TAGS
-void *radix_tree_tag_set(struct radix_tree_root *root,
-			unsigned long index, unsigned int tag);
-void *radix_tree_tag_clear(struct radix_tree_root *root,
-			unsigned long index, unsigned int tag);
-int radix_tree_tag_get(struct radix_tree_root *root,
-			unsigned long index, unsigned int tag);
-unsigned int
-radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
-			unsigned long first_index, unsigned int max_items,
-			unsigned int tag);
-int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag);
-#endif
-
-#endif /* __XFS_SUPPORT_RADIX_TREE_H__ */
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 25ea248e..482893ef 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -36,6 +36,7 @@ crc32defs.h \
 crc32table.h \
 fsgeom.h \
 ptvar.h \
+radix-tree.h \
 topology.h
 
 LSRCFILES += gen_crc32table.c
diff --git a/libfrog/radix-tree.h b/libfrog/radix-tree.h
new file mode 100644
index 00000000..f08156b9
--- /dev/null
+++ b/libfrog/radix-tree.h
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2001 Momchil Velikov
+ * Portions Copyright (C) 2001 Christoph Hellwig
+ */
+#ifndef __LIBFROG_RADIX_TREE_H__
+#define __LIBFROG_RADIX_TREE_H__
+
+#define RADIX_TREE_TAGS
+
+struct radix_tree_root {
+	unsigned int		height;
+	struct radix_tree_node	*rnode;
+};
+
+#define RADIX_TREE_INIT(mask)	{					\
+	.height = 0,							\
+	.rnode = NULL,							\
+}
+
+#define RADIX_TREE(name, mask) \
+	struct radix_tree_root name = RADIX_TREE_INIT(mask)
+
+#define INIT_RADIX_TREE(root, mask)					\
+do {									\
+	(root)->height = 0;						\
+	(root)->rnode = NULL;						\
+} while (0)
+
+#ifdef RADIX_TREE_TAGS
+#define RADIX_TREE_MAX_TAGS 2
+#endif
+
+int radix_tree_insert(struct radix_tree_root *, unsigned long, void *);
+void *radix_tree_lookup(struct radix_tree_root *, unsigned long);
+void **radix_tree_lookup_slot(struct radix_tree_root *, unsigned long);
+void *radix_tree_lookup_first(struct radix_tree_root *, unsigned long *);
+void *radix_tree_delete(struct radix_tree_root *, unsigned long);
+unsigned int
+radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
+			unsigned long first_index, unsigned int max_items);
+unsigned int
+radix_tree_gang_lookup_ex(struct radix_tree_root *root, void **results,
+			unsigned long first_index, unsigned long last_index,
+			unsigned int max_items);
+
+void radix_tree_init(void);
+
+#ifdef RADIX_TREE_TAGS
+void *radix_tree_tag_set(struct radix_tree_root *root,
+			unsigned long index, unsigned int tag);
+void *radix_tree_tag_clear(struct radix_tree_root *root,
+			unsigned long index, unsigned int tag);
+int radix_tree_tag_get(struct radix_tree_root *root,
+			unsigned long index, unsigned int tag);
+unsigned int
+radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
+			unsigned long first_index, unsigned int max_items,
+			unsigned int tag);
+int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag);
+#endif
+
+#endif /* __LIBFROG_RADIX_TREE_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 8b3de170..ec4d7d3b 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -46,7 +46,7 @@
 #include "cache.h"
 #include "bitops.h"
 #include "kmem.h"
-#include "radix-tree.h"
+#include "libfrog/radix-tree.h"
 #include "atomic.h"
 
 #include "xfs_types.h"

