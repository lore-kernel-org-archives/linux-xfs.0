Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 01:44:03 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5R8hlW8025161
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 01:43:48 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AF2D148A05C
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 01:44:47 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id Kcxc9B4BHYeQ0hz3 for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 01:44:47 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] Remove the sema_t from XFS.
Date: Fri, 27 Jun 2008 18:44:44 +1000
Message-Id: <1214556284-4160-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1214556284-4160-1-git-send-email-david@fromorbit.com>
References: <1214556284-4160-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, matthew@wil.cx, dwalker@mvista.com, Dave Chinner <david@fromorbit.com>

Now that all users of the sema_t are gone from XFS we
can finally kill it.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/sema.h      |   52 ------------------------------------------
 fs/xfs/linux-2.6/xfs_linux.h |    2 +-
 2 files changed, 1 insertions(+), 53 deletions(-)
 delete mode 100644 fs/xfs/linux-2.6/sema.h

diff --git a/fs/xfs/linux-2.6/sema.h b/fs/xfs/linux-2.6/sema.h
deleted file mode 100644
index 3abe7e9..0000000
--- a/fs/xfs/linux-2.6/sema.h
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_SUPPORT_SEMA_H__
-#define __XFS_SUPPORT_SEMA_H__
-
-#include <linux/time.h>
-#include <linux/wait.h>
-#include <linux/semaphore.h>
-#include <asm/atomic.h>
-
-/*
- * sema_t structure just maps to struct semaphore in Linux kernel.
- */
-
-typedef struct semaphore sema_t;
-
-#define initnsema(sp, val, name)	sema_init(sp, val)
-#define psema(sp, b)			down(sp)
-#define vsema(sp)			up(sp)
-#define freesema(sema)			do { } while (0)
-
-static inline int issemalocked(sema_t *sp)
-{
-	return down_trylock(sp) || (up(sp), 0);
-}
-
-/*
- * Map cpsema (try to get the sema) to down_trylock. We need to switch
- * the return values since cpsema returns 1 (acquired) 0 (failed) and
- * down_trylock returns the reverse 0 (acquired) 1 (failed).
- */
-static inline int cpsema(sema_t *sp)
-{
-	return down_trylock(sp) ? 0 : 1;
-}
-
-#endif /* __XFS_SUPPORT_SEMA_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 4d45d93..4fb838f 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -45,13 +45,13 @@
 #include <mrlock.h>
 #include <sv.h>
 #include <mutex.h>
-#include <sema.h>
 #include <time.h>
 
 #include <support/ktrace.h>
 #include <support/debug.h>
 #include <support/uuid.h>
 
+#include <linux/semaphore.h>
 #include <linux/mm.h>
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
-- 
1.5.5.4
