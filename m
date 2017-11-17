Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25125 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752245AbdKQUOz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 15:14:55 -0500
Subject: [PATCH 12/12] xfs_repair: remove old workqueue implementation in
 favor of libfrog code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 12:14:49 -0800
Message-ID: <151094968960.29763.2893569964931043236.stgit@magnolia>
In-Reply-To: <151094960522.29763.11622891165765932168.stgit@magnolia>
References: <151094960522.29763.11622891165765932168.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've made a generic workqueue in libfrog, we can remove the
implementation in xfs_repair and turn the old functions into do_error
wrappers.  There are no functional changes in this patch, though some of
the names and types have changed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase3.c   |   16 +++----
 repair/phase4.c   |   26 ++++++-----
 repair/phase6.c   |    4 +-
 repair/phase7.c   |    9 ++--
 repair/prefetch.c |   20 ++++----
 repair/prefetch.h |    4 +-
 repair/scan.c     |   16 +++----
 repair/slab.c     |    4 +-
 repair/threads.c  |  125 +++++++----------------------------------------------
 repair/threads.h  |   38 +++-------------
 10 files changed, 74 insertions(+), 188 deletions(-)


diff --git a/repair/phase3.c b/repair/phase3.c
index 17b1c28..8ebe1ae 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -66,7 +66,7 @@ process_agi_unlinked(
 
 static void
 process_ag_func(
-	work_queue_t		*wq,
+	struct workqueue	*wq,
 	xfs_agnumber_t 		agno,
 	void			*arg)
 {
@@ -76,7 +76,7 @@ process_ag_func(
 	 */
 	wait_for_inode_prefetch(arg);
 	do_log(_("        - agno = %d\n"), agno);
-	process_aginodes(wq->mp, arg, agno, 1, 0, 1);
+	process_aginodes(wq->wq_ctx, arg, agno, 1, 0, 1);
 	blkmap_free_final();
 	cleanup_inode_prefetch(arg);
 }
@@ -90,13 +90,13 @@ process_ags(
 
 static void
 do_uncertain_aginodes(
-	work_queue_t	*wq,
-	xfs_agnumber_t	agno,
-	void		*arg)
+	struct workqueue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
 {
-	int		*count = arg;
+	int			*count = arg;
 
-	*count = process_uncertain_aginodes(wq->mp, agno);
+	*count = process_uncertain_aginodes(wq->wq_ctx, agno);
 
 #ifdef XR_INODE_TRACE
 	fprintf(stderr,
@@ -114,7 +114,7 @@ phase3(
 {
 	int			i, j;
 	int			*counts;
-	work_queue_t		wq;
+	struct workqueue	wq;
 
 	do_log(_("Phase 3 - for each AG...\n"));
 	if (!no_modify)
diff --git a/repair/phase4.c b/repair/phase4.c
index cc17ec0..0a02b7d 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -134,13 +134,13 @@ quota_sb_check(xfs_mount_t *mp)
 
 static void
 process_ag_func(
-	work_queue_t		*wq,
+	struct workqueue	*wq,
 	xfs_agnumber_t 		agno,
 	void			*arg)
 {
 	wait_for_inode_prefetch(arg);
 	do_log(_("        - agno = %d\n"), agno);
-	process_aginodes(wq->mp, arg, agno, 0, 1, 0);
+	process_aginodes(wq->wq_ctx, arg, agno, 0, 1, 0);
 	blkmap_free_final();
 	cleanup_inode_prefetch(arg);
 
@@ -169,23 +169,23 @@ _("unable to finish adding attr/data fork reverse-mapping data for AG %u.\n"),
 
 static void
 check_rmap_btrees(
-	work_queue_t	*wq,
+	struct workqueue*wq,
 	xfs_agnumber_t	agno,
 	void		*arg)
 {
 	int		error;
 
-	error = rmap_add_fixed_ag_rec(wq->mp, agno);
+	error = rmap_add_fixed_ag_rec(wq->wq_ctx, agno);
 	if (error)
 		do_error(
 _("unable to add AG %u metadata reverse-mapping data.\n"), agno);
 
-	error = rmap_fold_raw_recs(wq->mp, agno);
+	error = rmap_fold_raw_recs(wq->wq_ctx, agno);
 	if (error)
 		do_error(
 _("unable to merge AG %u metadata reverse-mapping data.\n"), agno);
 
-	error = rmaps_verify_btree(wq->mp, agno);
+	error = rmaps_verify_btree(wq->wq_ctx, agno);
 	if (error)
 		do_error(
 _("%s while checking reverse-mappings"),
@@ -194,13 +194,13 @@ _("%s while checking reverse-mappings"),
 
 static void
 compute_ag_refcounts(
-	work_queue_t	*wq,
+	struct workqueue*wq,
 	xfs_agnumber_t	agno,
 	void		*arg)
 {
 	int		error;
 
-	error = compute_refcounts(wq->mp, agno);
+	error = compute_refcounts(wq->wq_ctx, agno);
 	if (error)
 		do_error(
 _("%s while computing reference count records.\n"),
@@ -209,13 +209,13 @@ _("%s while computing reference count records.\n"),
 
 static void
 process_inode_reflink_flags(
-	struct work_queue	*wq,
+	struct workqueue	*wq,
 	xfs_agnumber_t		agno,
 	void			*arg)
 {
 	int			error;
 
-	error = fix_inode_reflink_flags(wq->mp, agno);
+	error = fix_inode_reflink_flags(wq->wq_ctx, agno);
 	if (error)
 		do_error(
 _("%s while fixing inode reflink flags.\n"),
@@ -224,13 +224,13 @@ _("%s while fixing inode reflink flags.\n"),
 
 static void
 check_refcount_btrees(
-	work_queue_t	*wq,
+	struct workqueue*wq,
 	xfs_agnumber_t	agno,
 	void		*arg)
 {
 	int		error;
 
-	error = check_refcounts(wq->mp, agno);
+	error = check_refcounts(wq->wq_ctx, agno);
 	if (error)
 		do_error(
 _("%s while checking reference counts"),
@@ -241,7 +241,7 @@ static void
 process_rmap_data(
 	struct xfs_mount	*mp)
 {
-	struct work_queue	wq;
+	struct workqueue	wq;
 	xfs_agnumber_t		i;
 
 	if (!rmap_needs_work(mp))
diff --git a/repair/phase6.c b/repair/phase6.c
index f3b8378..b326929 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3125,7 +3125,7 @@ check_for_orphaned_inodes(
 
 static void
 traverse_function(
-	work_queue_t		*wq,
+	struct workqueue	*wq,
 	xfs_agnumber_t 		agno,
 	void			*arg)
 {
@@ -3154,7 +3154,7 @@ traverse_function(
 
 		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
 			if (inode_isadir(irec, i))
-				process_dir_inode(wq->mp, agno, irec, i);
+				process_dir_inode(wq->wq_ctx, agno, irec, i);
 		}
 	}
 	cleanup_inode_prefetch(pf_args);
diff --git a/repair/phase7.c b/repair/phase7.c
index 4ffb81a..b495ec2 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -98,10 +98,11 @@ update_inode_nlinks(
  */
 static void
 do_link_updates(
-	struct work_queue	*wq,
+	struct workqueue	*wq,
 	xfs_agnumber_t		agno,
 	void			*arg)
 {
+	struct xfs_mount	*mp = wq->wq_ctx;
 	ino_tree_node_t		*irec;
 	int			j;
 	uint32_t		nrefs;
@@ -120,8 +121,8 @@ do_link_updates(
 			ASSERT(no_modify || nrefs > 0);
 
 			if (get_inode_disk_nlinks(irec, j) != nrefs)
-				update_inode_nlinks(wq->mp,
-					XFS_AGINO_TO_INO(wq->mp, agno,
+				update_inode_nlinks(wq->wq_ctx,
+					XFS_AGINO_TO_INO(mp, agno,
 						irec->ino_startnum + j),
 					nrefs);
 		}
@@ -135,7 +136,7 @@ phase7(
 	struct xfs_mount	*mp,
 	int			scan_threads)
 {
-	struct work_queue	wq;
+	struct workqueue	wq;
 	int			agno;
 
 	if (!no_modify)
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 4c74b6e..9c68e35 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -943,11 +943,11 @@ start_inode_prefetch(
  */
 static void
 prefetch_ag_range(
-	struct work_queue	*work,
+	struct workqueue	*work,
 	xfs_agnumber_t		start_ag,
 	xfs_agnumber_t		end_ag,
 	bool			dirs_only,
-	void			(*func)(struct work_queue *,
+	void			(*func)(struct workqueue *,
 					xfs_agnumber_t, void *))
 {
 	int			i;
@@ -967,12 +967,12 @@ struct pf_work_args {
 	xfs_agnumber_t	start_ag;
 	xfs_agnumber_t	end_ag;
 	bool		dirs_only;
-	void		(*func)(struct work_queue *, xfs_agnumber_t, void *);
+	void		(*func)(struct workqueue *, xfs_agnumber_t, void *);
 };
 
 static void
 prefetch_ag_range_work(
-	struct work_queue	*work,
+	struct workqueue	*work,
 	xfs_agnumber_t		unused,
 	void			*args)
 {
@@ -991,14 +991,14 @@ void
 do_inode_prefetch(
 	struct xfs_mount	*mp,
 	int			stride,
-	void			(*func)(struct work_queue *,
+	void			(*func)(struct workqueue *,
 					xfs_agnumber_t, void *),
 	bool			check_cache,
 	bool			dirs_only)
 {
 	int			i;
-	struct work_queue	queue;
-	struct work_queue	*queues;
+	struct workqueue	queue;
+	struct workqueue	*queues;
 	int			queues_started = 0;
 
 	/*
@@ -1008,7 +1008,7 @@ do_inode_prefetch(
 	 * CPU to maximise parallelism of the queue to be processed.
 	 */
 	if (check_cache && !libxfs_bcache_overflowed()) {
-		queue.mp = mp;
+		queue.wq_ctx = mp;
 		create_work_queue(&queue, mp, libxfs_nproc());
 		for (i = 0; i < mp->m_sb.sb_agcount; i++)
 			queue_work(&queue, func, i, NULL);
@@ -1021,7 +1021,7 @@ do_inode_prefetch(
 	 * directly after each AG is queued.
 	 */
 	if (!stride) {
-		queue.mp = mp;
+		queue.wq_ctx = mp;
 		prefetch_ag_range(&queue, 0, mp->m_sb.sb_agcount,
 				  dirs_only, func);
 		return;
@@ -1030,7 +1030,7 @@ do_inode_prefetch(
 	/*
 	 * create one worker thread for each segment of the volume
 	 */
-	queues = malloc(thread_count * sizeof(work_queue_t));
+	queues = malloc(thread_count * sizeof(struct workqueue));
 	for (i = 0; i < thread_count; i++) {
 		struct pf_work_args *wargs;
 
diff --git a/repair/prefetch.h b/repair/prefetch.h
index b837752..8652707 100644
--- a/repair/prefetch.h
+++ b/repair/prefetch.h
@@ -4,7 +4,7 @@
 #include <semaphore.h>
 #include "incore.h"
 
-struct work_queue;
+struct workqueue;
 
 extern int 	do_prefetch;
 
@@ -45,7 +45,7 @@ void
 do_inode_prefetch(
 	struct xfs_mount	*mp,
 	int			stride,
-	void			(*func)(struct work_queue *,
+	void			(*func)(struct workqueue *,
 					xfs_agnumber_t, void *),
 	bool			check_cache,
 	bool			dirs_only);
diff --git a/repair/scan.c b/repair/scan.c
index 22c7331..e4ac4a7 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -2342,7 +2342,7 @@ validate_agi(
  */
 static void
 scan_ag(
-	work_queue_t	*wq,
+	struct workqueue*wq,
 	xfs_agnumber_t	agno,
 	void		*arg)
 {
@@ -2504,13 +2504,13 @@ scan_ags(
 	struct xfs_mount	*mp,
 	int			scan_threads)
 {
-	struct aghdr_cnts *agcnts;
-	uint64_t	fdblocks = 0;
-	uint64_t	icount = 0;
-	uint64_t	ifreecount = 0;
-	uint64_t	usedblocks = 0;
-	xfs_agnumber_t	i;
-	work_queue_t	wq;
+	struct aghdr_cnts	*agcnts;
+	uint64_t		fdblocks = 0;
+	uint64_t		icount = 0;
+	uint64_t		ifreecount = 0;
+	uint64_t		usedblocks = 0;
+	xfs_agnumber_t		i;
+	struct workqueue	wq;
 
 	agcnts = malloc(mp->m_sb.sb_agcount * sizeof(*agcnts));
 	if (!agcnts) {
diff --git a/repair/slab.c b/repair/slab.c
index d47448a..b04c3b8 100644
--- a/repair/slab.c
+++ b/repair/slab.c
@@ -211,7 +211,7 @@ struct qsort_slab {
 
 static void
 qsort_slab_helper(
-	struct work_queue	*wq,
+	struct workqueue	*wq,
 	xfs_agnumber_t		agno,
 	void			*arg)
 {
@@ -231,7 +231,7 @@ qsort_slab(
 	struct xfs_slab		*slab,
 	int (*compare_fn)(const void *, const void *))
 {
-	struct work_queue	wq;
+	struct workqueue	wq;
 	struct xfs_slab_hdr	*hdr;
 	struct qsort_slab	*qs;
 
diff --git a/repair/threads.c b/repair/threads.c
index 631531f..7a7f748 100644
--- a/repair/threads.c
+++ b/repair/threads.c
@@ -6,50 +6,6 @@
 #include "protos.h"
 #include "globals.h"
 
-static void *
-worker_thread(void *arg)
-{
-	work_queue_t	*wq;
-	work_item_t	*wi;
-
-	wq = (work_queue_t*)arg;
-
-	/*
-	 * Loop pulling work from the passed in work queue.
-	 * Check for notification to exit after every chunk of work.
-	 */
-	while (1) {
-		pthread_mutex_lock(&wq->lock);
-
-		/*
-		 * Wait for work.
-		 */
-		while (wq->next_item == NULL && !wq->terminate) {
-			ASSERT(wq->item_count == 0);
-			pthread_cond_wait(&wq->wakeup, &wq->lock);
-		}
-		if (wq->next_item == NULL && wq->terminate) {
-			pthread_mutex_unlock(&wq->lock);
-			break;
-		}
-
-		/*
-		 *  Dequeue work from the head of the list.
-		 */
-		ASSERT(wq->item_count > 0);
-		wi = wq->next_item;
-		wq->next_item = wi->next;
-		wq->item_count--;
-
-		pthread_mutex_unlock(&wq->lock);
-
-		(wi->function)(wi->queue, wi->agno, wi->arg);
-		free(wi);
-	}
-
-	return NULL;
-}
-
 void
 thread_init(void)
 {
@@ -67,85 +23,36 @@ thread_init(void)
 
 void
 create_work_queue(
-	work_queue_t		*wq,
-	xfs_mount_t		*mp,
-	int			nworkers)
+	struct workqueue	*wq,
+	struct xfs_mount	*mp,
+	unsigned int		nworkers)
 {
 	int			err;
-	int			i;
-
-	memset(wq, 0, sizeof(work_queue_t));
 
-	pthread_cond_init(&wq->wakeup, NULL);
-	pthread_mutex_init(&wq->lock, NULL);
-
-	wq->mp = mp;
-	wq->thread_count = nworkers;
-	wq->threads = malloc(nworkers * sizeof(pthread_t));
-	wq->terminate = 0;
-
-	for (i = 0; i < nworkers; i++) {
-		err = pthread_create(&wq->threads[i], NULL, worker_thread, wq);
-		if (err != 0) {
-			do_error(_("cannot create worker threads, error = [%d] %s\n"),
+	err = workqueue_create(wq, mp, nworkers);
+	if (err)
+		do_error(_("cannot create worker threads, error = [%d] %s\n"),
 				err, strerror(err));
-		}
-	}
-
 }
 
 void
 queue_work(
-	work_queue_t	*wq,
-	work_func_t	func,
-	xfs_agnumber_t	agno,
-	void		*arg)
+	struct workqueue	*wq,
+	workqueue_func_t	func,
+	xfs_agnumber_t		agno,
+	void			*arg)
 {
-	work_item_t	*wi;
+	int			err;
 
-	wi = (work_item_t *)malloc(sizeof(work_item_t));
-	if (wi == NULL)
+	err = workqueue_add(wq, func, agno, arg);
+	if (err)
 		do_error(_("cannot allocate worker item, error = [%d] %s\n"),
-			errno, strerror(errno));
-
-	wi->function = func;
-	wi->agno = agno;
-	wi->arg = arg;
-	wi->queue = wq;
-	wi->next = NULL;
-
-	/*
-	 *  Now queue the new work structure to the work queue.
-	 */
-	pthread_mutex_lock(&wq->lock);
-	if (wq->next_item == NULL) {
-		wq->next_item = wi;
-		ASSERT(wq->item_count == 0);
-		pthread_cond_signal(&wq->wakeup);
-	} else {
-		wq->last_item->next = wi;
-	}
-	wq->last_item = wi;
-	wq->item_count++;
-	pthread_mutex_unlock(&wq->lock);
+				err, strerror(err));
 }
 
 void
 destroy_work_queue(
-	work_queue_t	*wq)
+	struct workqueue	*wq)
 {
-	int		i;
-
-	pthread_mutex_lock(&wq->lock);
-	wq->terminate = 1;
-	pthread_mutex_unlock(&wq->lock);
-
-	pthread_cond_broadcast(&wq->wakeup);
-
-	for (i = 0; i < wq->thread_count; i++)
-		pthread_join(wq->threads[i], NULL);
-
-	free(wq->threads);
-	pthread_mutex_destroy(&wq->lock);
-	pthread_cond_destroy(&wq->wakeup);
+	workqueue_destroy(wq);
 }
diff --git a/repair/threads.h b/repair/threads.h
index bb0b8f8..fce520a 100644
--- a/repair/threads.h
+++ b/repair/threads.h
@@ -1,47 +1,25 @@
 #ifndef	_XFS_REPAIR_THREADS_H_
 #define	_XFS_REPAIR_THREADS_H_
 
-void	thread_init(void);
-
-struct  work_queue;
-
-typedef void work_func_t(struct work_queue *, xfs_agnumber_t, void *);
+#include "workqueue.h"
 
-typedef struct work_item {
-	struct work_item	*next;
-	work_func_t		*function;
-	struct work_queue	*queue;
-	xfs_agnumber_t		agno;
-	void			*arg;
-} work_item_t;
-
-typedef struct  work_queue {
-	work_item_t		*next_item;
-	work_item_t		*last_item;
-	int			item_count;
-	int			thread_count;
-	pthread_t		*threads;
-	xfs_mount_t		*mp;
-	pthread_mutex_t		lock;
-	pthread_cond_t		wakeup;
-	int			terminate;
-} work_queue_t;
+void	thread_init(void);
 
 void
 create_work_queue(
-	work_queue_t		*wq,
-	xfs_mount_t		*mp,
-	int			nworkers);
+	struct workqueue	*wq,
+	struct xfs_mount	*mp,
+	unsigned int		nworkers);
 
 void
 queue_work(
-	work_queue_t		*wq,
-	work_func_t 		func,
+	struct workqueue	*wq,
+	workqueue_func_t	func,
 	xfs_agnumber_t 		agno,
 	void			*arg);
 
 void
 destroy_work_queue(
-	work_queue_t		*wq);
+	struct workqueue	*wq);
 
 #endif	/* _XFS_REPAIR_THREADS_H_ */

