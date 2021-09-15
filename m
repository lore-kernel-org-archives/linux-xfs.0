Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9E4C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC5D2600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhIOXIL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhIOXIL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:08:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B28F600D4;
        Wed, 15 Sep 2021 23:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747211;
        bh=BoE6Mah6MLsucmaJwjn541X/VO8tKa+6QXmsPGJ+jMA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BhlSYDsBVK+NssRCIqeS/Q60c9/9NtnXdltq59W6/g84GSoQox7ZgNEASIHgBFjJ1
         04eVNrHKeXaKjoIm/wWWxUQ5JV0lXbCIEiOty3DULl2OUeOcLptYI5br3sIuj9RQqK
         cjYXPWScQ+7QKWbcQ457o/boMJPiwW6xTYvq3YH8Tahg+C7emkqp3j280u0GQk9Tg3
         civY8CHrBTVNo2lj+PBK4h/XP995qf3EDRO7QEVAfeOp0rJCvte0e4rOovz5MZAix7
         oWRYYJcps7y/0dMs3iU/8OKk/TXnWmsWToh5RuBDKYLZyqYD2nkHck+faDwWqoTUuu
         umjSwJ5PBI25A==
Subject: [PATCH 03/61] libfrog: create header file for mocked-up kernel data
 structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:06:51 -0700
Message-ID: <163174721123.350433.6338166230233894732.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a mockups.h for mocked-up versions of kernel data structures to
ease porting of libxfs code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h     |    1 +
 libfrog/Makefile     |    1 +
 libfrog/mockups.h    |   19 +++++++++++++++++++
 libxfs/libxfs_priv.h |    4 +---
 4 files changed, 22 insertions(+), 3 deletions(-)
 create mode 100644 libfrog/mockups.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 36ae86cc..c297152f 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -17,6 +17,7 @@
 #include "bitops.h"
 #include "kmem.h"
 #include "libfrog/radix-tree.h"
+#include "libfrog/mockups.h"
 #include "atomic.h"
 
 #include "xfs_types.h"
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 01107082..5381d9b5 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -41,6 +41,7 @@ crc32defs.h \
 crc32table.h \
 fsgeom.h \
 logging.h \
+mockups.h \
 paths.h \
 projects.h \
 ptvar.h \
diff --git a/libfrog/mockups.h b/libfrog/mockups.h
new file mode 100644
index 00000000..f00a9e41
--- /dev/null
+++ b/libfrog/mockups.h
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_MOCKUPS_H__
+#define __LIBFROG_MOCKUPS_H__
+
+/* Mockups of kernel data structures. */
+
+typedef struct spinlock {
+} spinlock_t;
+
+#define spin_lock_init(lock)	((void) 0)
+
+#define spin_lock(a)		((void) 0)
+#define spin_unlock(a)		((void) 0)
+
+#endif /* __LIBFROG_MOCKUPS_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 7181a858..727f6be8 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -47,6 +47,7 @@
 #include "bitops.h"
 #include "kmem.h"
 #include "libfrog/radix-tree.h"
+#include "libfrog/mockups.h"
 #include "atomic.h"
 
 #include "xfs_types.h"
@@ -205,9 +206,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #endif
 
 /* miscellaneous kernel routines not in user space */
-#define spin_lock_init(a)	((void) 0)
-#define spin_lock(a)		((void) 0)
-#define spin_unlock(a)		((void) 0)
 #define likely(x)		(x)
 #define unlikely(x)		(x)
 #define rcu_read_lock()		((void) 0)

