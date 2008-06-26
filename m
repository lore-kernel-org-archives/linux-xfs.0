Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 21:41:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q4eOQ4008324
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 21:40:24 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB5462825EA
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 21:41:23 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id BbPctgKMRXI8UP2O for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 21:41:23 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] Replace dquot flush semaphore with a completion
Date: Thu, 26 Jun 2008 14:41:14 +1000
Message-Id: <1214455277-6387-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1214455277-6387-1-git-send-email-david@fromorbit.com>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: matthew@wil.cx, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>

Use the new completion flush code to implement the dquot
flush lock. Removes one of the final users of semaphores
in the XFS code base.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/quota/xfs_dquot.c      |   18 +++++-------------
 fs/xfs/quota/xfs_dquot.h      |   23 +++++++++++++----------
 fs/xfs/quota/xfs_dquot_item.c |    6 +++---
 3 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index fc9f3fb..c3e3080 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -101,7 +101,7 @@ xfs_qm_dqinit(
 	if (brandnewdquot) {
 		dqp->dq_flnext = dqp->dq_flprev = dqp;
 		mutex_init(&dqp->q_qlock);
-		initnsema(&dqp->q_flock, 1, "fdq");
+		init_completion_flush(&dqp->q_flush);
 		sv_init(&dqp->q_pinwait, SV_DEFAULT, "pdq");
 
 #ifdef XFS_DQUOT_TRACE
@@ -150,7 +150,6 @@ xfs_qm_dqdestroy(
 	ASSERT(! XFS_DQ_IS_ON_FREELIST(dqp));
 
 	mutex_destroy(&dqp->q_qlock);
-	freesema(&dqp->q_flock);
 	sv_destroy(&dqp->q_pinwait);
 
 #ifdef XFS_DQUOT_TRACE
@@ -1211,7 +1210,7 @@ xfs_qm_dqflush(
 	int			error;
 
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
-	ASSERT(XFS_DQ_IS_FLUSH_LOCKED(dqp));
+	ASSERT(completion_flush_inprogress(&dqp->q_flush));
 	xfs_dqtrace_entry(dqp, "DQFLUSH");
 
 	/*
@@ -1353,14 +1352,7 @@ int
 xfs_qm_dqflock_nowait(
 	xfs_dquot_t *dqp)
 {
-	int locked;
-
-	locked = cpsema(&((dqp)->q_flock));
-
-	/* XXX ifdef these out */
-	if (locked)
-		(dqp)->dq_flags |= XFS_DQ_FLOCKED;
-	return (locked);
+	return completion_flush_start_nowait(&dqp->q_flush);
 }
 
 
@@ -1368,14 +1360,14 @@ int
 xfs_qm_dqlock_nowait(
 	xfs_dquot_t *dqp)
 {
-	return (mutex_trylock(&((dqp)->q_qlock)));
+	return mutex_trylock(&dqp->q_qlock);
 }
 
 void
 xfs_dqlock(
 	xfs_dquot_t *dqp)
 {
-	mutex_lock(&(dqp->q_qlock));
+	mutex_lock(&dqp->q_qlock);
 }
 
 void
diff --git a/fs/xfs/quota/xfs_dquot.h b/fs/xfs/quota/xfs_dquot.h
index f7393bb..c127a45 100644
--- a/fs/xfs/quota/xfs_dquot.h
+++ b/fs/xfs/quota/xfs_dquot.h
@@ -82,7 +82,7 @@ typedef struct xfs_dquot {
 	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
 	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
 	mutex_t		 q_qlock;	/* quota lock */
-	sema_t		 q_flock;	/* flush lock */
+	struct completion q_flush;	/* flush completion queue */
 	uint		 q_pincount;	/* pin count for this dquot */
 	sv_t		 q_pinwait;	/* sync var for pinning */
 #ifdef XFS_DQUOT_TRACE
@@ -113,17 +113,20 @@ XFS_DQ_IS_LOCKED(xfs_dquot_t *dqp)
 
 
 /*
- * The following three routines simply manage the q_flock
- * semaphore embedded in the dquot.  This semaphore synchronizes
- * processes attempting to flush the in-core dquot back to disk.
+ * Manage the q_flush completion queue embedded in the dquot.  This completion
+ * queue synchronizes processes attempting to flush the in-core dquot back to
+ * disk.
  */
-#define xfs_dqflock(dqp)	 { psema(&((dqp)->q_flock), PINOD | PRECALC);\
-				   (dqp)->dq_flags |= XFS_DQ_FLOCKED; }
-#define xfs_dqfunlock(dqp)	 { ASSERT(issemalocked(&((dqp)->q_flock))); \
-				   vsema(&((dqp)->q_flock)); \
-				   (dqp)->dq_flags &= ~(XFS_DQ_FLOCKED); }
+static inline void xfs_dqflock(xfs_dquot_t *dqp)
+{
+	completion_flush_start(&dqp->q_flush);
+}
+
+static inline void xfs_dqfunlock(xfs_dquot_t *dqp)
+{
+	complete(&dqp->q_flush);
+}
 
-#define XFS_DQ_IS_FLUSH_LOCKED(dqp) (issemalocked(&((dqp)->q_flock)))
 #define XFS_DQ_IS_ON_FREELIST(dqp)  ((dqp)->dq_flnext != (dqp))
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->dq_flags & XFS_DQ_DIRTY)
 #define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)
diff --git a/fs/xfs/quota/xfs_dquot_item.c b/fs/xfs/quota/xfs_dquot_item.c
index 08d2fc8..a91efa8 100644
--- a/fs/xfs/quota/xfs_dquot_item.c
+++ b/fs/xfs/quota/xfs_dquot_item.c
@@ -151,7 +151,7 @@ xfs_qm_dquot_logitem_push(
 	dqp = logitem->qli_dquot;
 
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
-	ASSERT(XFS_DQ_IS_FLUSH_LOCKED(dqp));
+	ASSERT(completion_flush_inprogress(&dqp->q_flush));
 
 	/*
 	 * Since we were able to lock the dquot's flush lock and
@@ -245,7 +245,7 @@ xfs_qm_dquot_logitem_pushbuf(
 	 * inode flush completed and the inode was taken off the AIL.
 	 * So, just get out.
 	 */
-	if (!issemalocked(&(dqp->q_flock))  ||
+	if (!completion_flush_inprogress(&dqp->q_flush)  ||
 	    ((qip->qli_item.li_flags & XFS_LI_IN_AIL) == 0)) {
 		qip->qli_pushbuf_flag = 0;
 		xfs_dqunlock(dqp);
@@ -258,7 +258,7 @@ xfs_qm_dquot_logitem_pushbuf(
 	if (bp != NULL) {
 		if (XFS_BUF_ISDELAYWRITE(bp)) {
 			dopush = ((qip->qli_item.li_flags & XFS_LI_IN_AIL) &&
-				  issemalocked(&(dqp->q_flock)));
+				  completion_flush_inprogress(&dqp->q_flush));
 			qip->qli_pushbuf_flag = 0;
 			xfs_dqunlock(dqp);
 
-- 
1.5.5.4
