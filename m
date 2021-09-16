Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C93C4321E
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 01:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCFCA611CE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 01:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbhIPBsP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 21:48:15 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:60159 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233569AbhIPBsO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Sep 2021 21:48:14 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 83C9882A1C1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Sep 2021 11:46:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mQgUH-00CySm-1n
        for linux-xfs@vger.kernel.org; Thu, 16 Sep 2021 11:46:53 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95-RC2)
        (envelope-from <david@fromorbit.com>)
        id 1mQgUH-007hX0-0Z
        for linux-xfs@vger.kernel.org;
        Thu, 16 Sep 2021 11:46:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] libxfs: add kernel-compatible completion API
Date:   Thu, 16 Sep 2021 11:46:48 +1000
Message-Id: <20210916014649.1835564-5-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916014649.1835564-1-david@fromorbit.com>
References: <20210916013707.GQ2361455@dread.disaster.area>
 <20210916014649.1835564-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=CXAYsMGRYJN6Xb3I1u8A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This is needed for the kernel buffer cache conversion to be able
to wait on IO synchrnously. It is implemented with pthread mutexes
and conditional variables.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile     |  1 +
 include/completion.h | 61 ++++++++++++++++++++++++++++++++++++++++++++
 include/libxfs.h     |  1 +
 libxfs/libxfs_priv.h |  1 +
 4 files changed, 64 insertions(+)
 create mode 100644 include/completion.h

diff --git a/include/Makefile b/include/Makefile
index f7c40a5ce1a1..98031e70fa0d 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -12,6 +12,7 @@ LIBHFILES = libxfs.h \
 	atomic.h \
 	bitops.h \
 	cache.h \
+	completion.h \
 	hlist.h \
 	kmem.h \
 	list.h \
diff --git a/include/completion.h b/include/completion.h
new file mode 100644
index 000000000000..92194c3f1484
--- /dev/null
+++ b/include/completion.h
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019 RedHat, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBXFS_COMPLETION_H__
+#define __LIBXFS_COMPLETION_H__
+
+/*
+ * This implements kernel compatible completion semantics. This is slightly
+ * different to the way pthread conditional variables work in that completions
+ * can be signalled before the waiter tries to wait on the variable. In the
+ * pthread case, the completion is ignored and the waiter goes to sleep, whilst
+ * the kernel will see that the completion has already been completed and so
+ * will not block. This is handled through the addition of the the @signalled
+ * flag in the struct completion.
+ */
+struct completion {
+	pthread_mutex_t		lock;
+	pthread_cond_t		cond;
+	bool			signalled; /* for kernel completion behaviour */
+	int			waiters;
+};
+
+static inline void
+init_completion(struct completion *w)
+{
+	pthread_mutex_init(&w->lock, NULL);
+	pthread_cond_init(&w->cond, NULL);
+	w->signalled = false;
+}
+
+static inline void
+complete(struct completion *w)
+{
+	pthread_mutex_lock(&w->lock);
+	w->signalled = true;
+	pthread_cond_broadcast(&w->cond);
+	pthread_mutex_unlock(&w->lock);
+}
+
+/*
+ * Support for mulitple waiters requires that we count the number of waiters
+ * we have and only clear the signalled variable once all those waiters have
+ * been woken.
+ */
+static inline void
+wait_for_completion(struct completion *w)
+{
+	pthread_mutex_lock(&w->lock);
+	if (!w->signalled) {
+		w->waiters++;
+		pthread_cond_wait(&w->cond, &w->lock);
+		w->waiters--;
+	}
+	if (!w->waiters)
+		w->signalled = false;
+	pthread_mutex_unlock(&w->lock);
+}
+
+#endif /* __LIBXFS_COMPLETION_H__ */
diff --git a/include/libxfs.h b/include/libxfs.h
index a494a1d4b002..61475347b09d 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -19,6 +19,7 @@
 #include "libfrog/radix-tree.h"
 #include "atomic.h"
 #include "spinlock.h"
+#include "completion.h"
 
 #include "xfs_types.h"
 #include "xfs_fs.h"
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index e1e90268c0b7..9f28fd908d43 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -49,6 +49,7 @@
 #include "libfrog/radix-tree.h"
 #include "atomic.h"
 #include "spinlock.h"
+#include "completion.h"
 
 #include "xfs_types.h"
 #include "xfs_arch.h"
-- 
2.33.0

