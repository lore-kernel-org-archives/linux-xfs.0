Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:47:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDlJdd026147
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:47:19 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1372354B8D5
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:47:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id VNOQ6WJgzMrKIysy for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:47:18 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSRC-0001c9-HM
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:47:18 +0000
Date: Mon, 27 Oct 2008 09:47:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/10] remove dead code from sv_t implementation
Message-ID: <20081027134718.GF5730@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-simplify-sv
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/sv.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/sv.h	2008-09-29 10:45:36.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/sv.h	2008-09-29 10:49:16.000000000 +0200
@@ -32,23 +32,15 @@ typedef struct sv_s {
 	wait_queue_head_t waiters;
 } sv_t;
 
-#define SV_FIFO		0x0		/* sv_t is FIFO type */
-#define SV_LIFO		0x2		/* sv_t is LIFO type */
-#define SV_PRIO		0x4		/* sv_t is PRIO type */
-#define SV_KEYED	0x6		/* sv_t is KEYED type */
-#define SV_DEFAULT      SV_FIFO
-
-
-static inline void _sv_wait(sv_t *sv, spinlock_t *lock, int state,
-			     unsigned long timeout)
+static inline void _sv_wait(sv_t *sv, spinlock_t *lock)
 {
 	DECLARE_WAITQUEUE(wait, current);
 
 	add_wait_queue_exclusive(&sv->waiters, &wait);
-	__set_current_state(state);
+	__set_current_state(TASK_UNINTERRUPTIBLE);
 	spin_unlock(lock);
 
-	schedule_timeout(timeout);
+	schedule();
 
 	remove_wait_queue(&sv->waiters, &wait);
 }
@@ -58,13 +50,7 @@ static inline void _sv_wait(sv_t *sv, sp
 #define sv_destroy(sv) \
 	/*NOTHING*/
 #define sv_wait(sv, pri, lock, s) \
-	_sv_wait(sv, lock, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT)
-#define sv_wait_sig(sv, pri, lock, s)   \
-	_sv_wait(sv, lock, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT)
-#define sv_timedwait(sv, pri, lock, s, svf, ts, rts) \
-	_sv_wait(sv, lock, TASK_UNINTERRUPTIBLE, timespec_to_jiffies(ts))
-#define sv_timedwait_sig(sv, pri, lock, s, svf, ts, rts) \
-	_sv_wait(sv, lock, TASK_INTERRUPTIBLE, timespec_to_jiffies(ts))
+	_sv_wait(sv, lock)
 #define sv_signal(sv) \
 	wake_up(&(sv)->waiters)
 #define sv_broadcast(sv) \

-- 
