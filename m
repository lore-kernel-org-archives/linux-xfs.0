Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2G7MGk031743 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:07:22 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AF100164F1E2
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:07:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id qRs4QcLXk3cHS6nI for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:07:21 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xly-0007PQ-TY
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:50 +0000
Message-Id: <20081202160650.829703000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:39 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 09/22] remove dead code from sv_t implementation
Content-Disposition: inline; filename=xfs-simplify-sv
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
