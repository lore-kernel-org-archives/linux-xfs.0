Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nACA9cWl241285 for <xfs@oss.sgi.com>; Thu, 12 Nov 2009 04:09:38 -0600
Date: Thu, 12 Nov 2009 05:09:57 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/14] repair: use single prefetch queue
Message-ID: <20091112100957.GB25058@infradead.org>
References: <20090902175840.934778714@bombadil.infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE83ADEC@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ADEC@cf--amer001e--3.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 21, 2009 at 12:48:35PM -0500, Alex Elder wrote:
> The following hunk doesn't really do anything but change whitespace.
> It'd be nice if those changes (when there's a bunch like this) were
> limited to a separate no-op patch.

Agreed.  There were lots of hunk like that in Barry's original patches
and I though I caught them all, but this one was left over.

Updated patch below:

--

Subject: repair: use single prefetch queue
From: Barry Naujok <bnaujok@sgi.com>

We don't need two prefetch queues as we guarantee execution in order anyway.


Signed-off-by: Barry Naujok <bnaujok@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfsprogs-dev/repair/prefetch.c
===================================================================
--- xfsprogs-dev.orig/repair/prefetch.c	2009-11-12 11:01:42.533256209 +0100
+++ xfsprogs-dev/repair/prefetch.c	2009-11-12 11:07:32.068006860 +0100
@@ -128,8 +128,9 @@ pf_queue_io(
 
 	pthread_mutex_lock(&args->lock);
 
+	btree_insert(args->io_queue, fsbno, bp);
+
 	if (fsbno > args->last_bno_read) {
-		btree_insert(args->primary_io_queue, fsbno, bp);
 		if (B_IS_INODE(flag)) {
 			args->inode_bufs_queued++;
 			if (args->inode_bufs_queued == IO_THRESHOLD)
@@ -152,7 +153,6 @@ pf_queue_io(
 #endif
 		ASSERT(!B_IS_INODE(flag));
 		XFS_BUF_SET_PRIORITY(bp, B_DIR_META_2);
-		btree_insert(args->secondary_io_queue, fsbno, bp);
 	}
 
 	pf_start_processing(args);
@@ -405,7 +405,6 @@ pf_batch_read(
 	pf_which_t		which,
 	void			*buf)
 {
-	struct btree_root	*queue;
 	xfs_buf_t		*bplist[MAX_BUFS];
 	unsigned int		num;
 	off64_t			first_off, last_off, next_off;
@@ -416,19 +415,22 @@ pf_batch_read(
 	unsigned long		max_fsbno;
 	char			*pbuf;
 
-	queue = (which != PF_SECONDARY) ? args->primary_io_queue
-				: args->secondary_io_queue;
-
-	while (btree_find(queue, 0, &fsbno) != NULL) {
-		max_fsbno = fsbno + pf_max_fsbs;
+	for (;;) {
 		num = 0;
-
-		bplist[0] = btree_lookup(queue, fsbno);
+		if (which == PF_SECONDARY) {
+			bplist[0] = btree_find(args->io_queue, 0, &fsbno);
+			max_fsbno = MIN(fsbno + pf_max_fsbs,
+							args->last_bno_read);
+		} else {
+			bplist[0] = btree_find(args->io_queue,
+						args->last_bno_read, &fsbno);
+			max_fsbno = fsbno + pf_max_fsbs;
+		}
 		while (bplist[num] && num < MAX_BUFS && fsbno < max_fsbno) {
 			if (which != PF_META_ONLY ||
 			    !B_IS_INODE(XFS_BUF_PRIORITY(bplist[num])))
 				num++;
-			bplist[num] = btree_lookup_next(queue, &fsbno);
+			bplist[num] = btree_lookup_next(args->io_queue, &fsbno);
 		}
 		if (!num)
 			return;
@@ -463,7 +465,7 @@ pf_batch_read(
 		}
 
 		for (i = 0; i < num; i++) {
-			if (btree_delete(queue, XFS_DADDR_TO_FSB(mp,
+			if (btree_delete(args->io_queue, XFS_DADDR_TO_FSB(mp,
 					XFS_BUF_ADDR(bplist[i]))) == NULL)
 				do_error(_("prefetch corruption\n"));
 		}
@@ -566,7 +568,7 @@ pf_io_worker(
 		return NULL;
 
 	pthread_mutex_lock(&args->lock);
-	while (!args->queuing_done || !btree_is_empty(args->primary_io_queue)) {
+	while (!args->queuing_done || !btree_is_empty(args->io_queue)) {
 #ifdef XR_PF_TRACE
 		pftrace("waiting to start prefetch I/O for AG %d", args->agno);
 #endif
@@ -691,8 +693,7 @@ pf_queuing_worker(
 #endif
 	pthread_mutex_lock(&args->lock);
 
-	ASSERT(btree_is_empty(args->primary_io_queue));
-	ASSERT(btree_is_empty(args->secondary_io_queue));
+	ASSERT(btree_is_empty(args->io_queue));
 
 	args->prefetch_done = 1;
 	if (args->next_args)
@@ -750,8 +751,7 @@ start_inode_prefetch(
 
 	args = calloc(1, sizeof(prefetch_args_t));
 
-	btree_init(&args->primary_io_queue);
-	btree_init(&args->secondary_io_queue);
+	btree_init(&args->io_queue);
 	if (pthread_mutex_init(&args->lock, NULL) != 0)
 		do_error(_("failed to initialize prefetch mutex\n"));
 	if (pthread_cond_init(&args->start_reading, NULL) != 0)
@@ -830,8 +830,7 @@ cleanup_inode_prefetch(
 	pthread_cond_destroy(&args->start_reading);
 	pthread_cond_destroy(&args->start_processing);
 	sem_destroy(&args->ra_count);
-	btree_destroy(args->primary_io_queue);
-	btree_destroy(args->secondary_io_queue);
+	btree_destroy(args->io_queue);
 
 	free(args);
 }
Index: xfsprogs-dev/repair/prefetch.h
===================================================================
--- xfsprogs-dev.orig/repair/prefetch.h	2009-11-12 10:53:01.098026017 +0100
+++ xfsprogs-dev/repair/prefetch.h	2009-11-12 11:07:01.807004122 +0100
@@ -13,8 +13,7 @@ typedef struct prefetch_args {
 	pthread_mutex_t		lock;
 	pthread_t		queuing_thread;
 	pthread_t		io_threads[PF_THREAD_COUNT];
-	struct btree_root	*primary_io_queue;
-	struct btree_root	*secondary_io_queue;
+	struct btree_root	*io_queue;
 	pthread_cond_t		start_reading;
 	pthread_cond_t		start_processing;
 	int			agno;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
