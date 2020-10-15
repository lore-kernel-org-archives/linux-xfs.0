Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF55C35257
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B6082224A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbgJOHWQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:16 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36190 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729106AbgJOHWP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:15 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7D84E58C55E
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaH-000hw5-39
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:57 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qMM-Rz
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 21/27] libxfs: Add kernel list_lru wrapper
Date:   Thu, 15 Oct 2020 18:21:49 +1100
Message-Id: <20201015072155.1631135-22-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=NOW37sSdXo37tZdLik4A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The buffer cache in the kernel uses the list_lru infrastructure
for cache reclaim, so we need to add some wrappers to provide
the necessary functionality to userspace to use the same buffer
cache and buftarg code as the kernel for managing the global
buffer cache LRU.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile     |  1 +
 include/libxfs.h     |  1 +
 include/list_lru.h   | 69 ++++++++++++++++++++++++++++++++++++++++++++
 libxfs/buftarg.c     |  7 ++++-
 libxfs/libxfs_io.h   |  1 +
 libxfs/libxfs_priv.h |  1 +
 libxfs/xfs_buftarg.h |  1 +
 7 files changed, 80 insertions(+), 1 deletion(-)
 create mode 100644 include/list_lru.h

diff --git a/include/Makefile b/include/Makefile
index ce89d0237c19..0bd529545dfc 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -16,6 +16,7 @@ LIBHFILES = libxfs.h \
 	hlist.h \
 	kmem.h \
 	list.h \
+	list_lru.h \
 	parent.h \
 	sema.h \
 	spinlock.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index 72c0b525f9db..7dfc4d2fd3ab 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -21,6 +21,7 @@
 #include "spinlock.h"
 #include "completion.h"
 #include "sema.h"
+#include "list_lru.h"
 
 #include "xfs_types.h"
 #include "xfs_fs.h"
diff --git a/include/list_lru.h b/include/list_lru.h
new file mode 100644
index 000000000000..91c3908432e6
--- /dev/null
+++ b/include/list_lru.h
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020 RedHat, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBXFS_LIST_LRU_H__
+#define __LIBXFS_LIST_LRU_H__
+
+/*
+ * This implements kernel compatible list_lru semantics that the buffer cache
+ * requires. It is not meant as a hugely scalable lru list like the kernel, but
+ * just what is needed for the buffer cache to function in userspace.
+ */
+struct list_lru {
+	struct list_head	l_lru;
+	spinlock_t		l_lock;
+	uint64_t		l_count;
+};
+
+static inline bool
+list_lru_add(
+	struct list_lru		*lru,
+	struct list_head	*item)
+{
+	spin_lock(&lru->l_lock);
+	if (!list_empty(item)) {
+		spin_unlock(&(lru->l_lock));
+		return false;
+	}
+	list_add_tail(item, &lru->l_lru);
+	lru->l_count++;
+	spin_unlock(&(lru->l_lock));
+	return true;
+}
+
+static inline bool
+list_lru_del(
+	struct list_lru		*lru,
+	struct list_head	*item)
+{
+	spin_lock(&lru->l_lock);
+	if (list_empty(item)) {
+		spin_unlock(&(lru->l_lock));
+		return false;
+	}
+	list_del_init(item);
+	lru->l_count--;
+	spin_unlock(&(lru->l_lock));
+	return true;
+}
+
+static inline bool
+list_lru_init(
+	struct list_lru		*lru)
+{
+	list_head_init(&lru->l_lru);
+	spin_lock_init(&lru->l_lock);
+	lru->l_count = 0;
+	return false;
+}
+
+static inline void
+list_lru_destroy(
+	struct list_lru		*lru)
+{
+	return;
+}
+
+#endif /* __LIBXFS_LIST_LRU_H__ */
diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
index dbecab833cb2..6dc8e76d26ef 100644
--- a/libxfs/buftarg.c
+++ b/libxfs/buftarg.c
@@ -78,11 +78,16 @@ xfs_buftarg_alloc(
 	if (xfs_buftarg_setsize_early(btp))
 		goto error_free;
 
-	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
+	if (list_lru_init(&btp->bt_lru))
 		goto error_free;
 
+	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
+		goto error_lru;
+
 	return btp;
 
+error_lru:
+	list_lru_destroy(&btp->bt_lru);
 error_free:
 	free(btp);
 	return NULL;
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 2e7c943d8978..b4022a4e5dd8 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -72,6 +72,7 @@ struct xfs_buf {
 	struct list_head	b_btc_list;
 	unsigned int		b_state;
 	atomic_t		b_lru_ref;
+	struct list_head	b_lru;
 };
 
 bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 151c030b5876..0e04ab910b8b 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -51,6 +51,7 @@
 #include "spinlock.h"
 #include "completion.h"
 #include "sema.h"
+#include "list_lru.h"
 
 #include "xfs_types.h"
 #include "xfs_arch.h"
diff --git a/libxfs/xfs_buftarg.h b/libxfs/xfs_buftarg.h
index 129b43e037ad..98b4996bea53 100644
--- a/libxfs/xfs_buftarg.h
+++ b/libxfs/xfs_buftarg.h
@@ -41,6 +41,7 @@ struct xfs_buftarg {
 
 	uint32_t		bt_io_count;
 	unsigned int		flags;
+	struct list_lru		bt_lru;
 };
 
 /* We purged a dirty buffer and lost a write. */
-- 
2.28.0

