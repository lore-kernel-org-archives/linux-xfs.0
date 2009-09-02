Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82Hvi4k034372 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:57:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A23A141E03E
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:58:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bai6ziy09rFjZjzI for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:58:41 -0700 (PDT)
Message-Id: <20090902175841.137658776@bombadil.infradead.org>
Date: Wed, 02 Sep 2009 13:55:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/14] repair: clean up prefetch tracing
References: <20090902175531.469184575@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-cleanup-prefetch-tracing
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

Define a dummy pftrace macro for the non-tracing case to reduce the ifdef hell,
clean up a few trace calls and add proper init/exit handlers for the tracing
setup and teardown.

Signed-off-by: Barry Naujok <bnaujok@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/dino_chunks.c
===================================================================
--- xfsprogs-dev.orig/repair/dino_chunks.c	2009-08-19 23:42:32.000000000 +0000
+++ xfsprogs-dev/repair/dino_chunks.c	2009-08-20 00:16:53.000000000 +0000
@@ -629,10 +629,9 @@
 			cluster_count * sizeof(xfs_buf_t*));
 
 	for (bp_index = 0; bp_index < cluster_count; bp_index++) {
-#ifdef XR_PF_TRACE
 		pftrace("about to read off %llu in AG %d",
 			(long long)XFS_AGB_TO_DADDR(mp, agno, agbno), agno);
-#endif
+
 		bplist[bp_index] = libxfs_readbuf(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, agbno),
 					XFS_FSB_TO_BB(mp, blks_per_cluster), 0);
@@ -650,11 +649,9 @@
 		}
 		agbno += blks_per_cluster;
 
-#ifdef XR_PF_TRACE
 		pftrace("readbuf %p (%llu, %d) in AG %d", bplist[bp_index],
 			(long long)XFS_BUF_ADDR(bplist[bp_index]),
 			XFS_BUF_COUNT(bplist[bp_index]), agno);
-#endif
 	}
 	agbno = XFS_AGINO_TO_AGBNO(mp, first_irec->ino_startnum);
 
@@ -906,10 +903,10 @@
 			 * done! - finished up irec and block simultaneously
 			 */
 			for (bp_index = 0; bp_index < cluster_count; bp_index++) {
-#ifdef XR_PF_TRACE
-				pftrace("put/writebuf %p (%llu) in AG %d", bplist[bp_index],
-					(long long)XFS_BUF_ADDR(bplist[bp_index]), agno);
-#endif
+				pftrace("put/writebuf %p (%llu) in AG %d",
+					bplist[bp_index], (long long)
+					XFS_BUF_ADDR(bplist[bp_index]), agno);
+
 				if (dirty && !no_modify)
 					libxfs_writebuf(bplist[bp_index], 0);
 				else
Index: xfsprogs-dev/repair/dir2.c
===================================================================
--- xfsprogs-dev.orig/repair/dir2.c	2009-08-19 23:42:32.000000000 +0000
+++ xfsprogs-dev/repair/dir2.c	2009-08-20 00:16:53.000000000 +0000
@@ -103,21 +103,19 @@
 		bplist = bparray;
 	}
 	for (i = 0; i < nex; i++) {
-#ifdef XR_PF_TRACE
 		pftrace("about to read off %llu (len = %d)",
 			(long long)XFS_FSB_TO_DADDR(mp, bmp[i].startblock),
 			XFS_FSB_TO_BB(mp, bmp[i].blockcount));
-#endif
+
 		bplist[i] = libxfs_readbuf(mp->m_dev,
 				XFS_FSB_TO_DADDR(mp, bmp[i].startblock),
 				XFS_FSB_TO_BB(mp, bmp[i].blockcount), 0);
 		if (!bplist[i])
 			goto failed;
-#ifdef XR_PF_TRACE
+
 		pftrace("readbuf %p (%llu, %d)", bplist[i],
 			(long long)XFS_BUF_ADDR(bplist[i]),
 			XFS_BUF_COUNT(bplist[i]));
-#endif
 	}
 	dabuf = malloc(XFS_DA_BUF_SIZE(nex));
 	if (dabuf == NULL) {
@@ -248,10 +246,8 @@
 	}
 	da_buf_done(dabuf);
 	for (i = 0; i < nbuf; i++) {
-#ifdef XR_PF_TRACE
 		pftrace("putbuf %p (%llu)", bplist[i],
 					(long long)XFS_BUF_ADDR(bplist[i]));
-#endif
 		libxfs_putbuf(bplist[i]);
 	}
 	if (bplist != &bp)
@@ -538,7 +534,7 @@
 	/*
 	 * bail out if this is the root block (top of tree)
 	 */
-	if (this_level >= cursor->active)  
+	if (this_level >= cursor->active)
 		return(0);
 	/*
 	 * set hashvalue to correctl reflect the now-validated
@@ -1425,7 +1421,7 @@
 		 * numbers.  Do NOT touch the name until after we've computed
 		 * the hashvalue and done a namecheck() on the name.
 		 *
-		 * Conditions must either set clearino to zero or set 
+		 * Conditions must either set clearino to zero or set
 		 * clearreason why it's being cleared.
 		 */
 		if (!ino_discovery && ent_ino == BADFSINO) {
@@ -1456,7 +1452,7 @@
 				if (ino_discovery) {
 					add_inode_uncertain(mp, ent_ino, 0);
 					clearino = 0;
-				} else 
+				} else
 					clearreason = _("non-existent");
 			} else {
 				/*
Index: xfsprogs-dev/repair/globals.h
===================================================================
--- xfsprogs-dev.orig/repair/globals.h	2009-08-19 23:42:32.000000000 +0000
+++ xfsprogs-dev/repair/globals.h	2009-08-20 00:16:53.000000000 +0000
@@ -199,10 +199,6 @@
 EXTERN int 		report_interval;
 EXTERN __uint64_t 	*prog_rpt_done;
 
-#ifdef XR_PF_TRACE
-EXTERN FILE		*pf_trace_file;
-#endif
-
 EXTERN int		ag_stride;
 EXTERN int		thread_count;
 
Index: xfsprogs-dev/repair/init.c
===================================================================
--- xfsprogs-dev.orig/repair/init.c	2009-08-20 00:06:44.000000000 +0000
+++ xfsprogs-dev/repair/init.c	2009-08-20 00:16:53.000000000 +0000
@@ -150,4 +150,5 @@
 	ts_create();
 	ts_init();
 	increase_rlimit();
+	pftrace_init();
 }
Index: xfsprogs-dev/repair/prefetch.c
===================================================================
--- xfsprogs-dev.orig/repair/prefetch.c	2009-08-20 00:16:01.000000000 +0000
+++ xfsprogs-dev/repair/prefetch.c	2009-08-20 00:16:53.000000000 +0000
@@ -83,9 +83,8 @@
 	prefetch_args_t		*args)
 {
 	if (!args->can_start_processing) {
-#ifdef XR_PF_TRACE
 		pftrace("signalling processing for AG %d", args->agno);
-#endif
+
 		args->can_start_processing = 1;
 		pthread_cond_signal(&args->start_processing);
 	}
@@ -96,9 +95,8 @@
 	prefetch_args_t		*args)
 {
 	if (!args->can_start_reading) {
-#ifdef XR_PF_TRACE
 		pftrace("signalling reading for AG %d", args->agno);
-#endif
+
 		args->can_start_reading = 1;
 		pthread_cond_broadcast(&args->start_reading);
 	}
@@ -136,25 +134,16 @@
 			if (args->inode_bufs_queued == IO_THRESHOLD)
 				pf_start_io_workers(args);
 		}
-#ifdef XR_PF_TRACE
-		pftrace("getbuf %c %p (%llu) in AG %d (fsbno = %lu) added to "
-			"primary queue (inode_bufs_queued = %d, last_bno = %lu)",
-			B_IS_INODE(flag) ? 'I' : 'M', bp,
-			(long long)XFS_BUF_ADDR(bp), args->agno, fsbno,
-			args->inode_bufs_queued, args->last_bno_read);
-#endif
 	} else {
-#ifdef XR_PF_TRACE
-		pftrace("getbuf %c %p (%llu) in AG %d (fsbno = %lu) added to "
-			"secondary queue (last_bno = %lu)",
-			B_IS_INODE(flag) ? 'I' : 'M', bp,
-			(long long)XFS_BUF_ADDR(bp), args->agno, fsbno,
-			args->last_bno_read);
-#endif
 		ASSERT(!B_IS_INODE(flag));
 		XFS_BUF_SET_PRIORITY(bp, B_DIR_META_2);
 	}
 
+	pftrace("getbuf %c %p (%llu) in AG %d (fsbno = %lu) added to queue"
+		"(inode_bufs_queued = %d, last_bno = %lu)", B_IS_INODE(flag) ?
+		'I' : 'M', bp, (long long)XFS_BUF_ADDR(bp), args->agno, fsbno,
+		args->inode_bufs_queued, args->last_bno_read);
+
 	pf_start_processing(args);
 
 	pthread_mutex_unlock(&args->lock);
@@ -192,9 +181,9 @@
 
 		while (irec.br_blockcount) {
 			unsigned int	len;
-#ifdef XR_PF_TRACE
+
 			pftrace("queuing dir extent in AG %d", args->agno);
-#endif
+
 			len = (irec.br_blockcount > mp->m_dirblkfsbs) ?
 					mp->m_dirblkfsbs : irec.br_blockcount;
 			pf_queue_io(args, irec.br_startblock, len, B_DIR_META);
@@ -520,20 +509,16 @@
 			}
 		}
 		for (i = 0; i < num; i++) {
-#ifdef XR_PF_TRACE
 			pftrace("putbuf %c %p (%llu) in AG %d",
 				B_IS_INODE(XFS_BUF_PRIORITY(bplist[i])) ? 'I' : 'M',
 				bplist[i], (long long)XFS_BUF_ADDR(bplist[i]),
 				args->agno);
-#endif
 			libxfs_putbuf(bplist[i]);
 		}
 		pthread_mutex_lock(&args->lock);
 		if (which != PF_SECONDARY) {
-#ifdef XR_PF_TRACE
 			pftrace("inode_bufs_queued for AG %d = %d", args->agno,
 				args->inode_bufs_queued);
-#endif
 			/*
 			 * if primary inode queue running low, process metadata
 			 * in boths queues to avoid I/O starvation as the
@@ -542,15 +527,14 @@
 			 */
 			if (which == PF_PRIMARY && !args->queuing_done &&
 					args->inode_bufs_queued < IO_THRESHOLD) {
-#ifdef XR_PF_TRACE
 				pftrace("reading metadata bufs from primary queue for AG %d",
 					args->agno);
-#endif
+
 				pf_batch_read(args, PF_META_ONLY, buf);
-#ifdef XR_PF_TRACE
+
 				pftrace("reading bufs from secondary queue for AG %d",
 					args->agno);
-#endif
+
 				pf_batch_read(args, PF_SECONDARY, buf);
 			}
 		}
@@ -571,20 +555,18 @@
 	pthread_mutex_lock(&args->lock);
 	while (!args->queuing_done || btree_find(args->io_queue, 0, NULL)) {
 
-#ifdef XR_PF_TRACE
 		pftrace("waiting to start prefetch I/O for AG %d", args->agno);
-#endif
+
 		while (!args->can_start_reading && !args->queuing_done)
 			pthread_cond_wait(&args->start_reading, &args->lock);
-#ifdef XR_PF_TRACE
+
 		pftrace("starting prefetch I/O for AG %d", args->agno);
-#endif
+
 		pf_batch_read(args, PF_PRIMARY, buf);
 		pf_batch_read(args, PF_SECONDARY, buf);
 
-#ifdef XR_PF_TRACE
 		pftrace("ran out of bufs to prefetch for AG %d", args->agno);
-#endif
+
 		if (!args->queuing_done)
 			args->can_start_reading = 0;
 	}
@@ -592,9 +574,8 @@
 
 	free(buf);
 
-#ifdef XR_PF_TRACE
 	pftrace("finished prefetch I/O for AG %d", args->agno);
-#endif
+
 	return NULL;
 }
 
@@ -636,10 +617,7 @@
 			break;
 		}
 	}
-
-#ifdef XR_PF_TRACE
 	pftrace("starting prefetch for AG %d", args->agno);
-#endif
 
 	for (irec = findfirst_inode_rec(args->agno); irec != NULL;
 			irec = next_ino_rec(irec)) {
@@ -676,10 +654,9 @@
 
 	pthread_mutex_lock(&args->lock);
 
-#ifdef XR_PF_TRACE
 	pftrace("finished queuing inodes for AG %d (inode_bufs_queued = %d)",
 		args->agno, args->inode_bufs_queued);
-#endif
+
 	args->queuing_done = 1;
 	pf_start_io_workers(args);
 	pf_start_processing(args);
@@ -690,9 +667,8 @@
 		if (args->io_threads[i])
 			pthread_join(args->io_threads[i], NULL);
 
-#ifdef XR_PF_TRACE
 	pftrace("prefetch for AG %d finished", args->agno);
-#endif
+
 	pthread_mutex_lock(&args->lock);
 
 	ASSERT(btree_find(args->io_queue, 0, NULL) == NULL);
@@ -712,9 +688,8 @@
 {
 	int			err;
 
-#ifdef XR_PF_TRACE
 	pftrace("creating queue thread for AG %d", args->agno);
-#endif
+
 	err = pthread_create(&args->queuing_thread, NULL,
 			pf_queuing_worker, args);
 	if (err != 0) {
@@ -801,14 +776,12 @@
 	pthread_mutex_lock(&args->lock);
 
 	while (!args->can_start_processing) {
-#ifdef XR_PF_TRACE
 		pftrace("waiting to start processing AG %d", args->agno);
-#endif
+
 		pthread_cond_wait(&args->start_processing, &args->lock);
 	}
-#ifdef XR_PF_TRACE
 	pftrace("can start processing AG %d", args->agno);
-#endif
+
 	pthread_mutex_unlock(&args->lock);
 }
 
@@ -819,15 +792,13 @@
 	if (args == NULL)
 		return;
 
-#ifdef XR_PF_TRACE
 	pftrace("waiting AG %d prefetch to finish", args->agno);
-#endif
+
 	if (args->queuing_thread)
 		pthread_join(args->queuing_thread, NULL);
 
-#ifdef XR_PF_TRACE
 	pftrace("AG %d prefetch done", args->agno);
-#endif
+
 	pthread_mutex_destroy(&args->lock);
 	pthread_cond_destroy(&args->start_reading);
 	pthread_cond_destroy(&args->start_processing);
@@ -839,6 +810,21 @@
 
 #ifdef XR_PF_TRACE
 
+static FILE	*pf_trace_file;
+
+void
+pftrace_init(void)
+{
+	pf_trace_file = fopen("/tmp/xfs_repair_prefetch.trace", "w");
+	setvbuf(pf_trace_file, NULL, _IOLBF, 1024);
+}
+
+void
+pftrace_done(void)
+{
+	fclose(pf_trace_file);
+}
+
 void
 _pftrace(const char *func, const char *msg, ...)
 {
@@ -853,7 +839,8 @@
 	buf[sizeof(buf)-1] = '\0';
 	va_end(args);
 
-	fprintf(pf_trace_file, "%lu.%06lu  %s: %s\n", tv.tv_sec, tv.tv_usec, func, buf);
+	fprintf(pf_trace_file, "%lu.%06lu  %s: %s\n", tv.tv_sec, tv.tv_usec,
+		func, buf);
 }
 
 #endif
Index: xfsprogs-dev/repair/prefetch.h
===================================================================
--- xfsprogs-dev.orig/repair/prefetch.h	2009-08-20 00:16:01.000000000 +0000
+++ xfsprogs-dev/repair/prefetch.h	2009-08-20 00:16:53.000000000 +0000
@@ -50,8 +50,15 @@
 
 
 #ifdef XR_PF_TRACE
+void	pftrace_init(void);
+void	pftrace_done(void);
+
 #define pftrace(msg...)	_pftrace(__FUNCTION__, ## msg)
 void	_pftrace(const char *, const char *, ...);
+#else
+static inline void pftrace_init(void) { };
+static inline void pftrace_done(void) { };
+static inline void pftrace(const char *msg, ...) { };
 #endif
 
 #endif /* _XFS_REPAIR_PREFETCH_H */
Index: xfsprogs-dev/repair/xfs_repair.c
===================================================================
--- xfsprogs-dev.orig/repair/xfs_repair.c	2009-08-19 23:42:32.000000000 +0000
+++ xfsprogs-dev/repair/xfs_repair.c	2009-08-20 00:16:53.000000000 +0000
@@ -542,11 +542,6 @@
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-#ifdef XR_PF_TRACE
-	pf_trace_file = fopen("/tmp/xfs_repair_prefetch.trace", "w");
-	setvbuf(pf_trace_file, NULL, _IOLBF, 1024);
-#endif
-
 	temp_mp = &xfs_m;
 	setbuf(stdout, NULL);
 
@@ -850,8 +845,7 @@
 	if (verbose)
 		summary_report();
 	do_log(_("done\n"));
-#ifdef XR_PF_TRACE
-	fclose(pf_trace_file);
-#endif
+	pftrace_done();
+
 	return (0);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
