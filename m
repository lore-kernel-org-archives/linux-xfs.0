Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Aug 2006 20:48:16 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7N3lxDW023445
	for <xfs@oss.sgi.com>; Tue, 22 Aug 2006 20:48:05 -0700
Subject: [PATCH] standardize on one sema init macro
Message-Id: <20060823034719.AD5B418DAFEC7@sandeen.net>
Date: Tue, 22 Aug 2006 22:47:19 -0500 (CDT)
From: sandeen@sandeen.net
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

One sema to rule them all, one sema to find them...

how many sema init routines does one really need after all?

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

 linux-2.4/sema.h |    2 --
 linux-2.6/sema.h |    2 --
 xfs_iget.c       |    2 +-
 3 files changed, 1 insertion(+), 5 deletions(-)


Index: xfs-linux/linux-2.4/sema.h
===================================================================
--- xfs-linux.orig/linux-2.4/sema.h
+++ xfs-linux/linux-2.4/sema.h
@@ -29,8 +29,6 @@
 
 typedef struct semaphore sema_t;
 
-#define init_sema(sp, val, c, d)	sema_init(sp, val)
-#define initsema(sp, val)		sema_init(sp, val)
 #define initnsema(sp, val, name)	sema_init(sp, val)
 #define psema(sp, b)			down(sp)
 #define vsema(sp)			up(sp)
Index: xfs-linux/linux-2.6/sema.h
===================================================================
--- xfs-linux.orig/linux-2.6/sema.h
+++ xfs-linux/linux-2.6/sema.h
@@ -29,8 +29,6 @@
 
 typedef struct semaphore sema_t;
 
-#define init_sema(sp, val, c, d)	sema_init(sp, val)
-#define initsema(sp, val)		sema_init(sp, val)
 #define initnsema(sp, val, name)	sema_init(sp, val)
 #define psema(sp, b)			down(sp)
 #define vsema(sp)			up(sp)
Index: xfs-linux/xfs_iget.c
===================================================================
--- xfs-linux.orig/xfs_iget.c
+++ xfs-linux/xfs_iget.c
@@ -546,7 +546,7 @@ xfs_inode_lock_init(
 	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", vp->v_number);
 	init_waitqueue_head(&ip->i_ipin_wait);
 	atomic_set(&ip->i_pincount, 0);
-	init_sema(&ip->i_flock, 1, "xfsfino", vp->v_number);
+	initnsema(&ip->i_flock, 1, "xfsfino");
 }
 
 /*
