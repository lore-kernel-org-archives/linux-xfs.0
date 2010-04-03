Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o33A0DcS036509 for <xfs@oss.sgi.com>; Sat, 3 Apr 2010 05:00:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D262148280B
	for <xfs@oss.sgi.com>; Sat,  3 Apr 2010 03:02:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id kGAs8cMSlg5YisQu for
	<xfs@oss.sgi.com>; Sat, 03 Apr 2010 03:02:01 -0700 (PDT)
Date: Sat, 3 Apr 2010 06:02:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 9/8] xfs: remove xfs_dqmarker
Message-ID: <20100403100200.GJ20166@infradead.org>
References: <1270125691-29266-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1270125691-29266-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.h	2010-04-03 11:50:57.597006532 +0200
+++ xfs/fs/xfs/quota/xfs_dquot.h	2010-04-03 11:54:38.612005622 +0200
@@ -43,21 +43,10 @@ struct xfs_mount;
 struct xfs_trans;
 
 /*
- * This is the marker which is designed to occupy the first few
- * bytes of the xfs_dquot_t structure. Even inside this, the freelist pointers
- * must come first.
- * This serves as the marker ("sentinel") when we have to restart list
- * iterations because of locking considerations.
- */
-typedef struct xfs_dqmarker {
-	uint		 dqm_flags;	/* various flags (XFS_DQ_*) */
-} xfs_dqmarker_t;
-
-/*
  * The incore dquot structure
  */
 typedef struct xfs_dquot {
-	xfs_dqmarker_t	 q_lists;	/* list ptrs, q_flags (marker) */
+	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
 	struct list_head q_freelist;	/* global free list of dquots */
 	struct list_head q_mplist;	/* mount's list of dquots */
 	struct list_head q_hashlist;	/* gloabl hash list of dquots */
@@ -81,13 +70,6 @@ typedef struct xfs_dquot {
 	wait_queue_head_t q_pinwait;	/* dquot pinning wait queue */
 } xfs_dquot_t;
 
-
-#define dq_flnext	q_lists.dqm_flnext
-#define dq_flprev	q_lists.dqm_flprev
-#define dq_mplist	q_lists.dqm_mplist
-#define dq_hashlist	q_lists.dqm_hashlist
-#define dq_flags	q_lists.dqm_flags
-
 /*
  * Lock hierarchy for q_qlock:
  *	XFS_QLOCK_NORMAL is the implicit default,
@@ -121,7 +103,6 @@ static inline void xfs_dqfunlock(xfs_dqu
 }
 
 #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
-#define XFS_DQ_IS_ON_FREELIST(dqp)  ((dqp)->dq_flnext != (dqp))
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->dq_flags & XFS_DQ_DIRTY)
 #define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)
 #define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQ_PROJ)
Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2010-04-03 11:52:38.335003250 +0200
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2010-04-03 11:54:51.139005979 +0200
@@ -930,7 +930,7 @@ struct mutex  qcheck_lock;
 }
 
 typedef struct dqtest {
-	xfs_dqmarker_t	q_lists;
+	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
 	struct list_head q_hashlist;
 	xfs_dqhash_t	*q_hash;	/* the hashchain header */
 	xfs_mount_t	*q_mount;	/* filesystem this relates to */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
