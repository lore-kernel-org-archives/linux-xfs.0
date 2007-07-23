Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jul 2007 19:11:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6N2Atbm006374
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2007 19:10:57 -0700
Date: Mon, 23 Jul 2007 12:10:51 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: demand reaping of filestreams objects
Message-ID: <20070723021051.GV12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Now that the problems with cancel_rearming_delayed_workqueue()
deadlocks have been fixed, we can go back to only running
the reaping when we have objects to time out. This prevents
the reaper from running when there is nothing to do.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_filestream.c |    3 -
 fs/xfs/xfs_mru_cache.c  |   76 +++++++++++++++++++-----------------------------
 fs/xfs/xfs_mru_cache.h  |    6 +--
 3 files changed, 34 insertions(+), 51 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_filestream.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_filestream.c	2007-07-16 20:32:59.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_filestream.c	2007-07-17 09:38:37.713952011 +1000
@@ -462,8 +462,7 @@ void
 xfs_filestream_flush(
 	xfs_mount_t	*mp)
 {
-	/* point in time flush, so keep the reaper running */
-	xfs_mru_cache_flush(mp->m_filestream, 1);
+	xfs_mru_cache_flush(mp->m_filestream);
 }
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/xfs_mru_cache.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mru_cache.c	2007-07-09 16:06:24.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mru_cache.c	2007-07-17 12:26:47.033984467 +1000
@@ -206,8 +206,12 @@ _xfs_mru_cache_list_insert(
 	 */
 	if (!_xfs_mru_cache_migrate(mru, now)) {
 		mru->time_zero = now;
-		if (!mru->next_reap)
-			mru->next_reap = mru->grp_count * mru->grp_time;
+		if (!mru->queued) {
+			printk("reaper started\n");
+			mru->queued = 1;
+			queue_delayed_work(xfs_mru_reap_wq, &mru->work,
+			                   mru->grp_count * mru->grp_time);
+		}
 	} else {
 		grp = (now - mru->time_zero) / mru->grp_time;
 		grp = (mru->lru_grp + grp) % mru->grp_count;
@@ -271,29 +275,27 @@ _xfs_mru_cache_reap(
 	struct work_struct	*work)
 {
 	xfs_mru_cache_t		*mru = container_of(work, xfs_mru_cache_t, work.work);
-	unsigned long		now;
+	unsigned long		now, next;
 
 	ASSERT(mru && mru->lists);
 	if (!mru || !mru->lists)
 		return;
 
 	mutex_spinlock(&mru->lock);
-	now = jiffies;
-	if (mru->reap_all ||
-	    (mru->next_reap && time_after(now, mru->next_reap))) {
-		if (mru->reap_all)
-			now += mru->grp_count * mru->grp_time * 2;
-		mru->next_reap = _xfs_mru_cache_migrate(mru, now);
-		_xfs_mru_cache_clear_reap_list(mru);
-	}
+	next = _xfs_mru_cache_migrate(mru, jiffies);
+	_xfs_mru_cache_clear_reap_list(mru);
+
+	mru->queued = next;
+	if ((mru->queued > 0)) {
+		now = jiffies;
+		if (next <= now)
+			next = 0;
+		else
+			next -= now;
+		queue_delayed_work(xfs_mru_reap_wq, &mru->work, next);
+	} else
+		printk("reaper stopped\n");
 
-	/*
-	 * the process that triggered the reap_all is responsible
-	 * for restating the periodic reap if it is required.
-	 */
-	if (!mru->reap_all)
-		queue_delayed_work(xfs_mru_reap_wq, &mru->work, mru->grp_time);
-	mru->reap_all = 0;
 	mutex_spinunlock(&mru->lock, 0);
 }
 
@@ -352,7 +354,7 @@ xfs_mru_cache_create(
 
 	/* An extra list is needed to avoid reaping up to a grp_time early. */
 	mru->grp_count = grp_count + 1;
-	mru->lists = kmem_alloc(mru->grp_count * sizeof(*mru->lists), KM_SLEEP);
+	mru->lists = kmem_zalloc(mru->grp_count * sizeof(*mru->lists), KM_SLEEP);
 
 	if (!mru->lists) {
 		err = ENOMEM;
@@ -374,11 +376,6 @@ xfs_mru_cache_create(
 	mru->grp_time  = grp_time;
 	mru->free_func = free_func;
 
-	/* start up the reaper event */
-	mru->next_reap = 0;
-	mru->reap_all = 0;
-	queue_delayed_work(xfs_mru_reap_wq, &mru->work, mru->grp_time);
-
 	*mrup = mru;
 
 exit:
@@ -394,35 +391,25 @@ exit:
  * Call xfs_mru_cache_flush() to flush out all cached entries, calling their
  * free functions as they're deleted.  When this function returns, the caller is
  * guaranteed that all the free functions for all the elements have finished
- * executing.
- *
- * While we are flushing, we stop the periodic reaper event from triggering.
- * Normally, we want to restart this periodic event, but if we are shutting
- * down the cache we do not want it restarted. hence the restart parameter
- * where 0 = do not restart reaper and 1 = restart reaper.
+ * executing and the reaper is not running.
  */
 void
 xfs_mru_cache_flush(
-	xfs_mru_cache_t		*mru,
-	int			restart)
+	xfs_mru_cache_t		*mru)
 {
 	if (!mru || !mru->lists)
 		return;
 
-	cancel_rearming_delayed_workqueue(xfs_mru_reap_wq, &mru->work);
-
 	mutex_spinlock(&mru->lock);
-	mru->reap_all = 1;
-	mutex_spinunlock(&mru->lock, 0);
+	if (mru->queued) {
+		mutex_spinunlock(&mru->lock, 0);
+		cancel_rearming_delayed_workqueue(xfs_mru_reap_wq, &mru->work);
+		mutex_spinlock(&mru->lock);
+	}
 
-	queue_work(xfs_mru_reap_wq, &mru->work.work);
-	flush_workqueue(xfs_mru_reap_wq);
+	_xfs_mru_cache_migrate(mru, jiffies + mru->grp_count * mru->grp_time);
+	_xfs_mru_cache_clear_reap_list(mru);
 
-	mutex_spinlock(&mru->lock);
-	WARN_ON_ONCE(mru->reap_all != 0);
-	mru->reap_all = 0;
-	if (restart)
-		queue_delayed_work(xfs_mru_reap_wq, &mru->work, mru->grp_time);
 	mutex_spinunlock(&mru->lock, 0);
 }
 
@@ -433,8 +420,7 @@ xfs_mru_cache_destroy(
 	if (!mru || !mru->lists)
 		return;
 
-	/* we don't want the reaper to restart here */
-	xfs_mru_cache_flush(mru, 0);
+	xfs_mru_cache_flush(mru);
 
 	kmem_free(mru->lists, mru->grp_count * sizeof(*mru->lists));
 	kmem_free(mru, sizeof(*mru));
Index: 2.6.x-xfs-new/fs/xfs/xfs_mru_cache.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mru_cache.h	2007-07-09 16:06:24.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mru_cache.h	2007-07-17 09:35:34.169898762 +1000
@@ -32,11 +32,9 @@ typedef struct xfs_mru_cache
 	unsigned int		grp_time;  /* Time period spanned by grps.  */
 	unsigned int		lru_grp;   /* Group containing time zero.   */
 	unsigned long		time_zero; /* Time first element was added. */
-	unsigned long		next_reap; /* Time that the reaper should
-					      next do something. */
-	unsigned int		reap_all;  /* if set, reap all lists */
 	xfs_mru_cache_free_func_t free_func; /* Function pointer for freeing. */
 	struct delayed_work	work;      /* Workqueue data for reaping.   */
+	unsigned int		queued;	   /* work has been queued */
 } xfs_mru_cache_t;
 
 int xfs_mru_cache_init(void);
@@ -44,7 +42,7 @@ void xfs_mru_cache_uninit(void);
 int xfs_mru_cache_create(struct xfs_mru_cache **mrup, unsigned int lifetime_ms,
 			     unsigned int grp_count,
 			     xfs_mru_cache_free_func_t free_func);
-void xfs_mru_cache_flush(xfs_mru_cache_t *mru, int restart);
+void xfs_mru_cache_flush(xfs_mru_cache_t *mru);
 void xfs_mru_cache_destroy(struct xfs_mru_cache *mru);
 int xfs_mru_cache_insert(struct xfs_mru_cache *mru, unsigned long key,
 				void *value);
