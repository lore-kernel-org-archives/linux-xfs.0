Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9ADC43457
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E88282224D
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgJOHWI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:08 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60709 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728949AbgJOHWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:04 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3330E3AB090
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hvc-NK
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qLs-FR
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/27] libxfs: add wrappers for kernel semaphores
Date:   Thu, 15 Oct 2020 18:21:39 +1100
Message-Id: <20201015072155.1631135-12-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=y2uvV0bdPpqU0iTU31UA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Implemented vi pthread mutexes.

On Linux, fast pthread mutexes don't actaully check which thread
owns the lock on unlock, so can be used in situations where the
unlock occurs in a different thread to the lock. This is
non-portable behaviour, so if other platforms are supported, this
may need to be converted to posix semaphores.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile     |  1 +
 include/libxfs.h     |  1 +
 include/sema.h       | 35 +++++++++++++++++++++++++++++++++++
 libxfs/libxfs_priv.h |  1 +
 4 files changed, 38 insertions(+)
 create mode 100644 include/sema.h

diff --git a/include/Makefile b/include/Makefile
index 98031e70fa0d..ce89d0237c19 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -17,6 +17,7 @@ LIBHFILES = libxfs.h \
 	kmem.h \
 	list.h \
 	parent.h \
+	sema.h \
 	spinlock.h \
 	xfs_inode.h \
 	xfs_log_recover.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index d03ec8aeaf5c..923a376bd71a 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -20,6 +20,7 @@
 #include "atomic.h"
 #include "spinlock.h"
 #include "completion.h"
+#include "sema.h"
 
 #include "xfs_types.h"
 #include "xfs_fs.h"
diff --git a/include/sema.h b/include/sema.h
new file mode 100644
index 000000000000..bcccb156b0ea
--- /dev/null
+++ b/include/sema.h
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019-20 RedHat, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBXFS_SEMA_H__
+#define __LIBXFS_SEMA_H__
+
+/*
+ * This implements kernel compatible semaphore _exclusion_ semantics. It does
+ * not implement counting semaphore behaviour.
+ *
+ * This makes use of the fact that fast pthread mutexes on Linux don't check
+ * that the unlocker is the same thread that locked the mutex, and hence can be
+ * unlocked in a different thread safely.
+ *
+ * If this needs to be portable or we require counting semaphore behaviour in
+ * libxfs code, this requires re-implementation based on posix semaphores.
+ */
+struct semaphore {
+	pthread_mutex_t		lock;
+};
+
+#define sema_init(l, nolock)		\
+do {					\
+	pthread_mutex_init(&(l)->lock, NULL);	\
+	if (!nolock)			\
+		pthread_mutex_lock(&(l)->lock);	\
+} while (0)
+
+#define down(l)			pthread_mutex_lock(&(l)->lock)
+#define down_trylock(l)		pthread_mutex_trylock(&(l)->lock)
+#define up(l)			pthread_mutex_unlock(&(l)->lock)
+
+#endif /* __LIBXFS_SEMA_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 5cbc4fe69732..7be3f7615fdd 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -50,6 +50,7 @@
 #include "atomic.h"
 #include "spinlock.h"
 #include "completion.h"
+#include "sema.h"
 
 #include "xfs_types.h"
 #include "xfs_arch.h"
-- 
2.28.0

