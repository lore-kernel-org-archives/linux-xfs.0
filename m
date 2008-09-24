Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:24:42 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O7Ocph029978
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:24:38 -0700
Message-ID: <48D9EB8F.1070104@sgi.com>
Date: Wed, 24 Sep 2008 17:26:07 +1000
From: Peter Leckie <pleckie@sgi.com>
MIME-Version: 1.0
Subject: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
References: <48D9C1DD.6030607@sgi.com>
In-Reply-To: <48D9C1DD.6030607@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

During a heavy workload with quota's enabled the system can stall

with every process requesting log space, however the log is full
of dquots.The aild is trying to push the tail of the log however
every item in the log had previously been pushed by the aild and was
marked as clean so the aild aborts pushing the items in the log.

The reason the log items are still in the log is because the iodone
routine xfs_qm_dqflush_done detected that the log sequence number(lsn)
had changed and assumed the log item had been re-dirtied so it should
be left in the log.  However the log item had not been re-dirtied so
it was still marked as clean preventing it from being pushed again
causing the log item to be stuck in the log. After a while the log
eventually filled with these dquot log items.

The reason the lsn had changed was due to it not being initialized by
the time a copy of the lsn was taken in xfs_qm_dqflush().  The lsn was
then latter updated causing the test in xfs_qm_dqflush_done() to fail.

Synchronizations between the 2 functions is done by the pincount in
struct xfs_dquot_t  and xfs_qm_dqflush() calls xfs_qm_dqunpin_wait()
to wait for the pincount == 0. However after been woken up it does not
validate the pincount is actually 0, allowing a false wake up by the
scheduler to cause xfs_qm_dqflush() to prematurely start processing
the dquot.

So this patch uses an atomic_t to track the pincount which allows us
to easily use the wait_event macro to wait, this will guarantee that
when we return from xfs_qm_dqunpin_wait() that the pincount == 0.
We also remove the global qi_pinlock from xfs_quotainfo which may
also reduce contention when pinning dquot's.

Signed-off-by: Peter Leckie <pleckie@sgi.com>


Index: 2.6.x-xfs/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/quota/xfs_dquot_item.c	2008-09-24 14:45:29.270573668 +1000
+++ 2.6.x-xfs/fs/xfs/quota/xfs_dquot_item.c	2008-09-24 16:36:06.748350869 +1000
@@ -88,25 +88,22 @@ xfs_qm_dquot_logitem_format(
 
 /*
  * Increment the pin count of the given dquot.
- * This value is protected by pinlock spinlock in the xQM structure.
  */
 STATIC void
 xfs_qm_dquot_logitem_pin(
 	xfs_dq_logitem_t *logitem)
 {
-	xfs_dquot_t *dqp;
+	xfs_dquot_t *dqp = logitem->qli_dquot;
 
-	dqp = logitem->qli_dquot;
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
-	spin_lock(&(XFS_DQ_TO_QINF(dqp)->qi_pinlock));
-	dqp->q_pincount++;
-	spin_unlock(&(XFS_DQ_TO_QINF(dqp)->qi_pinlock));
+	atomic_inc(dqp->q_pincount);
 }
 
 /*
  * Decrement the pin count of the given dquot, and wake up
  * anyone in xfs_dqwait_unpin() if the count goes to 0.	 The
- * dquot must have been previously pinned with a call to xfs_dqpin().
+ * dquot must have been previously pinned with a call to
+ * xfs_qm_dquot_logitem_pin().
  */
 /* ARGSUSED */
 STATIC void
@@ -114,16 +111,11 @@ xfs_qm_dquot_logitem_unpin(
 	xfs_dq_logitem_t *logitem,
 	int		  stale)
 {
-	xfs_dquot_t *dqp;
+	xfs_dquot_t *dqp = logitem->qli_dquot;
 
-	dqp = logitem->qli_dquot;
-	ASSERT(dqp->q_pincount > 0);
-	spin_lock(&(XFS_DQ_TO_QINF(dqp)->qi_pinlock));
-	dqp->q_pincount--;
-	if (dqp->q_pincount == 0) {
-		sv_broadcast(&dqp->q_pinwait);
-	}
-	spin_unlock(&(XFS_DQ_TO_QINF(dqp)->qi_pinlock));
+	ASSERT(atomic_read(&dqp->q_pincount) > 0);
+	if (atomic_dec_and_test(&dqp->q_pincount))
+		wake_up(&dqp->q_pinwait);
 }
 
 /* ARGSUSED */
@@ -193,21 +185,14 @@ xfs_qm_dqunpin_wait(
 	xfs_dquot_t	*dqp)
 {
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
-	if (dqp->q_pincount == 0) {
+	if (atomic_read(&dqp->q_pincount) == 0)
 		return;
-	}
 
 	/*
 	 * Give the log a push so we don't wait here too long.
 	 */
 	xfs_log_force(dqp->q_mount, (xfs_lsn_t)0, XFS_LOG_FORCE);
-	spin_lock(&(XFS_DQ_TO_QINF(dqp)->qi_pinlock));
-	if (dqp->q_pincount == 0) {
-		spin_unlock(&(XFS_DQ_TO_QINF(dqp)->qi_pinlock));
-		return;
-	}
-	sv_wait(&(dqp->q_pinwait), PINOD,
-		&(XFS_DQ_TO_QINF(dqp)->qi_pinlock), s);
+	wait_event(dqp->q_pinwait, (atomic_read(&dqp->q_pincount) == 0));
 }
 
 /*
@@ -310,7 +295,7 @@ xfs_qm_dquot_logitem_trylock(
 	uint			retval;
 
 	dqp = qip->qli_dquot;
-	if (dqp->q_pincount > 0)
+	if (atomic_read(&dqp->q_pincount) > 0)
 		return (XFS_ITEM_PINNED);
 
 	if (! xfs_qm_dqlock_nowait(dqp))
Index: 2.6.x-xfs/fs/xfs/quota/xfs_dquot.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/quota/xfs_dquot.h	2008-09-24 14:45:29.270573668 +1000
+++ 2.6.x-xfs/fs/xfs/quota/xfs_dquot.h	2008-09-24 16:24:58.623139695 +1000
@@ -83,8 +83,8 @@ typedef struct xfs_dquot {
 	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
 	mutex_t		 q_qlock;	/* quota lock */
 	struct completion q_flush;	/* flush completion queue */
-	uint		 q_pincount;	/* pin count for this dquot */
-	sv_t		 q_pinwait;	/* sync var for pinning */
+	atomic_t          q_pincount;	/* dquot pin count */
+	wait_queue_head_t q_pinwait;	/* dquot pinning wait queue */
 #ifdef XFS_DQUOT_TRACE
 	struct ktrace	*q_trace;	/* trace header structure */
 #endif
Index: 2.6.x-xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/quota/xfs_dquot.c	2008-09-24 14:45:29.270573668 +1000
+++ 2.6.x-xfs/fs/xfs/quota/xfs_dquot.c	2008-09-24 16:24:58.623139695 +1000
@@ -101,7 +101,7 @@ xfs_qm_dqinit(
 	if (brandnewdquot) {
 		dqp->dq_flnext = dqp->dq_flprev = dqp;
 		mutex_init(&dqp->q_qlock);
-		sv_init(&dqp->q_pinwait, SV_DEFAULT, "pdq");
+		init_waitqueue_head(&dqp->q_pinwait);
 
 		/*
 		 * Because we want to use a counting completion, complete
@@ -131,7 +131,7 @@ xfs_qm_dqinit(
 		 dqp->q_res_bcount = 0;
 		 dqp->q_res_icount = 0;
 		 dqp->q_res_rtbcount = 0;
-		 dqp->q_pincount = 0;
+		 atomic_set(&dqp->q_pincount, 0);
 		 dqp->q_hash = NULL;
 		 ASSERT(dqp->dq_flnext == dqp->dq_flprev);
 
@@ -1489,7 +1489,7 @@ xfs_qm_dqpurge(
 				"xfs_qm_dqpurge: dquot %p flush failed", dqp);
 		xfs_dqflock(dqp);
 	}
-	ASSERT(dqp->q_pincount == 0);
+	ASSERT(atomic_read(&dqp->q_pincount) == 0);
 	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
 	       !(dqp->q_logitem.qli_item.li_flags & XFS_LI_IN_AIL));
 
Index: 2.6.x-xfs/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfsidbg.c	2008-09-24 14:45:29.270573668 +1000
+++ 2.6.x-xfs/fs/xfs/xfsidbg.c	2008-09-24 16:24:58.627139176 +1000
@@ -6577,7 +6577,7 @@ xfsidbg_xqm_dquot(xfs_dquot_t *dqp)
 		(unsigned long long)dqp->q_res_rtbcount);
 	kdb_printf("qlock 0x%p  &q_flush 0x%p (%d) pincount 0x%x\n",
 		&dqp->q_qlock, &dqp->q_flush,
-		dqp->q_flush.done, dqp->q_pincount);
+		dqp->q_flush.done, atomic_read(&dqp->q_pincount));
 #ifdef XFS_DQUOT_TRACE
 	qprintf("dqtrace 0x%p\n", dqp->q_trace);
 #endif
@@ -6761,10 +6761,9 @@ xfsidbg_xqm_qinfo(xfs_mount_t *mp)
 		return;
 	}
 
-	kdb_printf("uqip 0x%p, gqip 0x%p, &pinlock 0x%p &dqlist 0x%p\n",
+	kdb_printf("uqip 0x%p, gqip 0x%p, &dqlist 0x%p\n",
 		mp->m_quotainfo->qi_uquotaip,
 		mp->m_quotainfo->qi_gquotaip,
-		&mp->m_quotainfo->qi_pinlock,
 		&mp->m_quotainfo->qi_dqlist);
 
 	kdb_printf("btmlimit 0x%x, itmlimit 0x%x, RTbtmlim 0x%x\n",
Index: 2.6.x-xfs/fs/xfs/quota/xfs_qm.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/quota/xfs_qm.h	2008-09-24 14:45:29.270573668 +1000
+++ 2.6.x-xfs/fs/xfs/quota/xfs_qm.h	2008-09-24 16:24:58.627139176 +1000
@@ -106,7 +106,6 @@ typedef struct xfs_qm {
 typedef struct xfs_quotainfo {
 	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
 	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
-	spinlock_t	 qi_pinlock;	 /* dquot pinning lock */
 	xfs_dqlist_t	 qi_dqlist;	 /* all dquots in filesys */
 	int		 qi_dqreclaims;	 /* a change here indicates
 					    a removal in the dqlist */
Index: 2.6.x-xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/quota/xfs_qm.c	2008-09-24 14:45:29.270573668 +1000
+++ 2.6.x-xfs/fs/xfs/quota/xfs_qm.c	2008-09-24 16:24:58.631138657 +1000
@@ -1137,7 +1137,6 @@ xfs_qm_init_quotainfo(
 		return error;
 	}
 
-	spin_lock_init(&qinf->qi_pinlock);
 	xfs_qm_list_init(&qinf->qi_dqlist, "mpdqlist", 0);
 	qinf->qi_dqreclaims = 0;
 
@@ -1234,7 +1233,6 @@ xfs_qm_destroy_quotainfo(
 	 */
 	xfs_qm_rele_quotafs_ref(mp);
 
-	spinlock_destroy(&qi->qi_pinlock);
 	xfs_qm_list_destroy(&qi->qi_dqlist);
 
 	if (qi->qi_uquotaip) {
