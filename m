Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1bP8b082139 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:37:25 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89D5013F6558
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:39:05 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	gcGOkxTK5iZkwflX for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:39:05 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	47821785-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 12:09:04 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMshq-0000e5-0L
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:39:02 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMsha-0005cu-Hk
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/14] xfs: remove sv wrappers
Date: Mon, 29 Nov 2010 12:38:32 +1100
Message-Id: <1290994712-21376-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1290994712-21376-1-git-send-email-david@fromorbit.com>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The sv_t type is no longer used in XFS. Remove the header file defining the
wrapper and the fragments that still reference it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/sv.h        |   59 ------------------------------------------
 fs/xfs/linux-2.6/xfs_linux.h |    1 -
 fs/xfs/quota/xfs_dquot.c     |    1 -
 3 files changed, 0 insertions(+), 61 deletions(-)
 delete mode 100644 fs/xfs/linux-2.6/sv.h

diff --git a/fs/xfs/linux-2.6/sv.h b/fs/xfs/linux-2.6/sv.h
deleted file mode 100644
index 4dfc7c3..0000000
--- a/fs/xfs/linux-2.6/sv.h
+++ /dev/null
@@ -1,59 +0,0 @@
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
-#ifndef __XFS_SUPPORT_SV_H__
-#define __XFS_SUPPORT_SV_H__
-
-#include <linux/wait.h>
-#include <linux/sched.h>
-#include <linux/spinlock.h>
-
-/*
- * Synchronisation variables.
- *
- * (Parameters "pri", "svf" and "rts" are not implemented)
- */
-
-typedef struct sv_s {
-	wait_queue_head_t waiters;
-} sv_t;
-
-static inline void _sv_wait(sv_t *sv, spinlock_t *lock)
-{
-	DECLARE_WAITQUEUE(wait, current);
-
-	add_wait_queue_exclusive(&sv->waiters, &wait);
-	__set_current_state(TASK_UNINTERRUPTIBLE);
-	spin_unlock(lock);
-
-	schedule();
-
-	remove_wait_queue(&sv->waiters, &wait);
-}
-
-#define sv_init(sv,flag,name) \
-	init_waitqueue_head(&(sv)->waiters)
-#define sv_destroy(sv) \
-	/*NOTHING*/
-#define sv_wait(sv, pri, lock, s) \
-	_sv_wait(sv, lock)
-#define sv_signal(sv) \
-	wake_up(&(sv)->waiters)
-#define sv_broadcast(sv) \
-	wake_up_all(&(sv)->waiters)
-
-#endif /* __XFS_SUPPORT_SV_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 559bf25..e7cfa27 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -37,7 +37,6 @@
 
 #include <kmem.h>
 #include <mrlock.h>
-#include <sv.h>
 #include <time.h>
 
 #include <support/debug.h>
diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index faf8e1a..d22aa31 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -149,7 +149,6 @@ xfs_qm_dqdestroy(
 	ASSERT(list_empty(&dqp->q_freelist));
 
 	mutex_destroy(&dqp->q_qlock);
-	sv_destroy(&dqp->q_pinwait);
 	kmem_zone_free(xfs_Gqm->qm_dqzone, dqp);
 
 	atomic_dec(&xfs_Gqm->qm_totaldquots);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
