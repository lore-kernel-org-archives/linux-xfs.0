Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C6A107F51
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2014 20:42:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 72373AC007
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2014 18:42:05 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0pA2IqNhnfxHfo1j for <xfs@oss.sgi.com>;
	Sun, 28 Sep 2014 18:42:03 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XYPyJ-0000rX-MG
	for xfs@oss.sgi.com; Mon, 29 Sep 2014 11:41:51 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XYPyJ-0003Ce-L0
	for xfs@oss.sgi.com; Mon, 29 Sep 2014 11:41:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: kill time.h
Date: Mon, 29 Sep 2014 11:41:51 +1000
Message-Id: <1411954911-12278-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The typedef for timespecs and nanotime() are completely unnecessary,
and delay() can be moved to fs/xfs/linux.h, which means this file
can go away.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/kmem.c            |  1 -
 fs/xfs/time.h            | 36 ------------------------------------
 fs/xfs/xfs_inode.c       |  4 ++--
 fs/xfs/xfs_linux.h       |  6 +++++-
 fs/xfs/xfs_trans_inode.c |  2 +-
 5 files changed, 8 insertions(+), 41 deletions(-)
 delete mode 100644 fs/xfs/time.h

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 844e288..53e95b2 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -21,7 +21,6 @@
 #include <linux/swap.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
-#include "time.h"
 #include "kmem.h"
 #include "xfs_message.h"
 
diff --git a/fs/xfs/time.h b/fs/xfs/time.h
deleted file mode 100644
index 387e695..0000000
--- a/fs/xfs/time.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_SUPPORT_TIME_H__
-#define __XFS_SUPPORT_TIME_H__
-
-#include <linux/sched.h>
-#include <linux/time.h>
-
-typedef struct timespec timespec_t;
-
-static inline void delay(long ticks)
-{
-	schedule_timeout_uninterruptible(ticks);
-}
-
-static inline void nanotime(struct timespec *tvp)
-{
-	*tvp = CURRENT_TIME;
-}
-
-#endif /* __XFS_SUPPORT_TIME_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e5bbc1f..f07b443 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -654,7 +654,7 @@ xfs_ialloc(
 	xfs_inode_t	*ip;
 	uint		flags;
 	int		error;
-	timespec_t	tv;
+	struct timespec	tv;
 
 	/*
 	 * Call the space management code to pick
@@ -720,7 +720,7 @@ xfs_ialloc(
 	ip->i_d.di_nextents = 0;
 	ASSERT(ip->i_d.di_nblocks == 0);
 
-	nanotime(&tv);
+	tv = current_fs_time(mp->m_super);
 	ip->i_d.di_mtime.t_sec = (__int32_t)tv.tv_sec;
 	ip->i_d.di_mtime.t_nsec = (__int32_t)tv.tv_nsec;
 	ip->i_d.di_atime = ip->i_d.di_mtime;
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index d10dc8f..6a51619 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -56,7 +56,6 @@ typedef __uint64_t __psunsigned_t;
 
 #include "kmem.h"
 #include "mrlock.h"
-#include "time.h"
 #include "uuid.h"
 
 #include <linux/semaphore.h>
@@ -179,6 +178,11 @@ typedef __uint64_t __psunsigned_t;
 #define MAX(a,b)	(max(a,b))
 #define howmany(x, y)	(((x)+((y)-1))/(y))
 
+static inline void delay(long ticks)
+{
+	schedule_timeout_uninterruptible(ticks);
+}
+
 /*
  * XFS wrapper structure for sysfs support. It depends on external data
  * structures and is embedded in various internal data structures to implement
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 50c3f56..cdb4d86 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -70,7 +70,7 @@ xfs_trans_ichgtime(
 	int			flags)
 {
 	struct inode		*inode = VFS_I(ip);
-	timespec_t		tv;
+	struct timespec		tv;
 
 	ASSERT(tp);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
