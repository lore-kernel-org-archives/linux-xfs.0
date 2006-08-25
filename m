Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Aug 2006 19:24:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7P2OPDW010653
	for <xfs@oss.sgi.com>; Thu, 24 Aug 2006 19:24:26 -0700
Subject: [PATCH] collapse sv_init, init_sv on linux
Message-Id: <20060825022352.7E22C18DAFEC7@sandeen.net>
Date: Thu, 24 Aug 2006 21:23:52 -0500 (CDT)
From: sandeen@sandeen.net
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Change the one caller of init_sv on linux2.4 to sv_init, since there
is no difference between sv_init & init_sv on linux anyway.

Then get rid of now unused init_sv.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

 linux-2.4/sv.h        |    2 --
 linux-2.4/xfs_vnode.c |    2 +-
 linux-2.6/sv.h        |    2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

Index: xfs-linux/linux-2.4/sv.h
===================================================================
--- xfs-linux.orig/linux-2.4/sv.h
+++ xfs-linux/linux-2.4/sv.h
@@ -53,8 +53,6 @@ static inline void _sv_wait(sv_t *sv, sp
 	remove_wait_queue(&sv->waiters, &wait);
 }
 
-#define init_sv(sv,type,name,flag) \
-	init_waitqueue_head(&(sv)->waiters)
 #define sv_init(sv,flag,name) \
 	init_waitqueue_head(&(sv)->waiters)
 #define sv_destroy(sv) \
Index: xfs-linux/linux-2.4/xfs_vnode.c
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_vnode.c
+++ xfs-linux/linux-2.4/xfs_vnode.c
@@ -35,7 +35,7 @@ vn_init(void)
 	register int i;
 
 	for (svp = vsync, i = 0; i < NVSYNC; i++, svp++)
-		init_sv(svp, SV_DEFAULT, "vsy", i);
+		sv_init(svp, SV_DEFAULT, "vsy");
 }
 
 struct bhv_vnode *
Index: xfs-linux/linux-2.6/sv.h
===================================================================
--- xfs-linux.orig/linux-2.6/sv.h
+++ xfs-linux/linux-2.6/sv.h
@@ -53,8 +53,6 @@ static inline void _sv_wait(sv_t *sv, sp
 	remove_wait_queue(&sv->waiters, &wait);
 }
 
-#define init_sv(sv,type,name,flag) \
-	init_waitqueue_head(&(sv)->waiters)
 #define sv_init(sv,flag,name) \
 	init_waitqueue_head(&(sv)->waiters)
 #define sv_destroy(sv) \
