Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82HvixB034371 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:57:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6191715B1A28
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:58:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ByHbuwNH3VaytPYI for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:58:41 -0700 (PDT)
Message-Id: <20090902175840.934778714@bombadil.infradead.org>
Date: Wed, 02 Sep 2009 13:55:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/14] repair: use single prefetch queue
References: <20090902175531.469184575@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-use-single-prefetch-queue
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
Cc: Barry Naujok <bnaujok@sgi.com>

We don't need two prefetch queues as we guarantee execution in order anyway.

XXX: description could use some more details.


Signed-off-by: Barry Naujok <bnaujok@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/prefetch.c
===================================================================
--- xfsprogs-dev.orig/repair/prefetch.c	2009-08-20 00:14:08.000000000 +0000
+++ xfsprogs-dev/repair/prefetch.c	2009-08-20 00:16:01.000000000 +0000
@@ -128,8 +128,9 @@
 
 	pthread_mutex_lock(&args->lock);
 
+	btree_insert(args->io_queue, fsbno, bp);
+
 	if (fsbno > args->last_bno_read) {
-		btree_insert(args->primary_io_queue, fsbno, bp);
 		if (B_IS_INODE(flag)) {
 			args->inode_bufs_queued++;
 			if (args->inode_bufs_queued == IO_THRESHOLD)
@@ -152,7 +153,6 @@
 #endif
 		ASSERT(!B_IS_INODE(flag));
 		XFS_BUF_SET_PRIORITY(bp, B_DIR_META_2);
-		btree_insert(args->secondary_io_queue, fsbno, bp);
 	}
 
 	pf_start_processing(args);
@@ -405,7 +405,6 @@
 	pf_which_t		which,
 	void			*buf)
 {
-	struct btree_root	*queue;
 	xfs_buf_t		*bplist[MAX_BUFS];
 	unsigned int		num;
 	off64_t			first_off, last_off, next_off;
@@ -416,19 +415,22 @@
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
@@ -440,21 +442,22 @@
 		 */
 		first_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[0]));
 		last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[num-1])) +
-			XFS_BUF_SIZE(bplist[num-1]);
+						XFS_BUF_SIZE(bplist[num-1]);
 		while (last_off - first_off > pf_max_bytes) {
 			num--;
-			last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[num-1])) +
-				XFS_BUF_SIZE(bplist[num-1]);
+			last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(
+				bplist[num-1])) + XFS_BUF_SIZE(bplist[num-1]);
 		}
-		if (num < ((last_off - first_off) >> (mp->m_sb.sb_blocklog + 3))) {
+		if (num < ((last_off - first_off) >>
+						(mp->m_sb.sb_blocklog + 3))) {
 			/*
 			 * not enough blocks for one big read, so determine
 			 * the number of blocks that are close enough.
 			 */
 			last_off = first_off + XFS_BUF_SIZE(bplist[0]);
 			for (i = 1; i < num; i++) {
-				next_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[i])) +
-						XFS_BUF_SIZE(bplist[i]);
+				next_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(
+					bplist[i])) + XFS_BUF_SIZE(bplist[i]);
 				if (next_off - last_off > pf_batch_bytes)
 					break;
 				last_off = next_off;
@@ -463,7 +466,7 @@
 		}
 
 		for (i = 0; i < num; i++) {
-			if (btree_delete(queue, XFS_DADDR_TO_FSB(mp,
+			if (btree_delete(args->io_queue, XFS_DADDR_TO_FSB(mp,
 					XFS_BUF_ADDR(bplist[i]))) == NULL)
 				do_error(_("prefetch corruption\n"));
 		}
@@ -566,7 +569,7 @@
 		return NULL;
 
 	pthread_mutex_lock(&args->lock);
-	while (!args->queuing_done || btree_find(args->primary_io_queue, 0, NULL)) {
+	while (!args->queuing_done || btree_find(args->io_queue, 0, NULL)) {
 
 #ifdef XR_PF_TRACE
 		pftrace("waiting to start prefetch I/O for AG %d", args->agno);
@@ -692,8 +695,7 @@
 #endif
 	pthread_mutex_lock(&args->lock);
 
-	ASSERT(btree_find(args->primary_io_queue, 0, NULL) == NULL);
-	ASSERT(btree_find(args->secondary_io_queue, 0, NULL) == NULL);
+	ASSERT(btree_find(args->io_queue, 0, NULL) == NULL);
 
 	args->prefetch_done = 1;
 	if (args->next_args)
@@ -751,8 +753,7 @@
 
 	args = calloc(1, sizeof(prefetch_args_t));
 
-	btree_init(&args->primary_io_queue);
-	btree_init(&args->secondary_io_queue);
+	btree_init(&args->io_queue);
 	if (pthread_mutex_init(&args->lock, NULL) != 0)
 		do_error(_("failed to initialize prefetch mutex\n"));
 	if (pthread_cond_init(&args->start_reading, NULL) != 0)
@@ -831,8 +832,7 @@
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
--- xfsprogs-dev.orig/repair/prefetch.h	2009-08-20 00:06:44.000000000 +0000
+++ xfsprogs-dev/repair/prefetch.h	2009-08-20 00:16:01.000000000 +0000
@@ -13,8 +13,7 @@
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
