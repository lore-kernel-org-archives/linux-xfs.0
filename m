Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Nov 2006 19:20:59 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAB3KqaG013566
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 19:20:53 -0800
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD039D1CB308
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 19:20:04 -0800 (PST)
Received: from [10.0.0.4] (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 063E018D9035E
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 21:20:04 -0600 (CST)
Message-ID: <45554163.9060608@sandeen.net>
Date: Fri, 10 Nov 2006 21:20:03 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove flag-less mraccessf/mrupdatef
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

mraccessf & mrupdatef are supposed to be the "flags" versions of
the functions, but they

a) ignore the flags parameter completely, and
b) are never called directly, only via the flag-less defines anyway

So, drop the #define indirection, and rename mraccessf to mraccess,
etc.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

 linux-2.4/mrlock.c       |    4 ++--
 linux-2.4/mrlock_rwsem.h |    6 ++----
 linux-2.6/mrlock.h       |    6 ++----
 3 files changed, 6 insertions(+), 10 deletions(-)

Index: xfs-linux-allpatches/linux-2.6/mrlock.h
===================================================================
--- xfs-linux-allpatches.orig/linux-2.6/mrlock.h
+++ xfs-linux-allpatches/linux-2.6/mrlock.h
@@ -31,15 +31,13 @@ typedef struct {
 	do { (mrp)->mr_writer = 0; init_rwsem(&(mrp)->mr_lock); } while (0)
 #define mrlock_init(mrp, t,n,s)	mrinit(mrp, n)
 #define mrfree(mrp)		do { } while (0)
-#define mraccess(mrp)		mraccessf(mrp, 0)
-#define mrupdate(mrp)		mrupdatef(mrp, 0)
 
-static inline void mraccessf(mrlock_t *mrp, int flags)
+static inline void mraccess(mrlock_t *mrp)
 {
 	down_read(&mrp->mr_lock);
 }
 
-static inline void mrupdatef(mrlock_t *mrp, int flags)
+static inline void mrupdate(mrlock_t *mrp)
 {
 	down_write(&mrp->mr_lock);
 	mrp->mr_writer = 1;
Index: xfs-linux-allpatches/linux-2.4/mrlock.c
===================================================================
--- xfs-linux-allpatches.orig/linux-2.4/mrlock.c
+++ xfs-linux-allpatches/linux-2.4/mrlock.c
@@ -116,7 +116,7 @@ mrlock(mrlock_t *mrp, int type, int flag
 
 /* ARGSUSED */
 void
-mraccessf(mrlock_t *mrp, int flags)
+mraccess(mrlock_t *mrp)
 {
 	MRLOCK(mrp);
 	if(mrp->mr_writes_waiting > 0) {
@@ -135,7 +135,7 @@ mraccessf(mrlock_t *mrp, int flags)
 
 /* ARGSUSED */
 void
-mrupdatef(mrlock_t *mrp, int flags)
+mrupdate(mrlock_t *mrp)
 {
 	MRLOCK(mrp);
 	while(mrp->mr_count) {
Index: xfs-linux-allpatches/linux-2.4/mrlock_rwsem.h
===================================================================
--- xfs-linux-allpatches.orig/linux-2.4/mrlock_rwsem.h
+++ xfs-linux-allpatches/linux-2.4/mrlock_rwsem.h
@@ -31,15 +31,13 @@ typedef struct {
 	( (mrp)->mr_writer = 0, init_rwsem(&(mrp)->mr_lock) )
 #define mrlock_init(mrp, t,n,s)	mrinit(mrp, n)
 #define mrfree(mrp)		do { } while (0)
-#define mraccess(mrp)		mraccessf(mrp, 0)
-#define mrupdate(mrp)		mrupdatef(mrp, 0)
 
-static inline void mraccessf(mrlock_t *mrp, int flags)
+static inline void mraccess(mrlock_t *mrp)
 {
 	down_read(&mrp->mr_lock);
 }
 
-static inline void mrupdatef(mrlock_t *mrp, int flags)
+static inline void mrupdate(mrlock_t *mrp)
 {
 	down_write(&mrp->mr_lock);
 	mrp->mr_writer = 1;
