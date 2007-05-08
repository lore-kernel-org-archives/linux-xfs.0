Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 23:51:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l486pWfB030333
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 23:51:34 -0700
Date: Tue, 8 May 2007 16:51:26 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: unwritten extent conversion vs synchronous direct I/O
Message-ID: <20070508065126.GK32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


Back in 2.6.13, unwritten extent conversion was changed to be done
via a workqueue because we can't do conversion in interrupt context
(AIO issue). The problem was that the changes extent conversion to
run asynchronously w.r.t I/o completion.

Under heavy load (e.g. 100 fsstress processes), a direct write into
an unwritten extent can complete and return to userspace before
the unwritten extent is converted. If that range of the file is
then read immediately, it will return zeros - unwritten - instead
of the data that was written and is present on disk.

A simpl etest case to show this is to run 100 fsstress processes,
the loop doing:

	prealloc
	direct write
	bmap

and at some point during this time, the bmap will return an
unwritten extent spanning a range that has already been written.

The following patch fixes the synchronous direct I/O by triggering
a workqueue flush on detection of a sync direct I/O into an
unwritten extent after queuing the conversion work. The other
approach that could be taken is to simply do the conversion
without passing it off to a work queue. Anyone have a preference
on which would be the better method to choose?

The patch below passes the QA test I wrote to exercise this
bug.

Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/linux-2.6/xfs_aops.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-04-26 09:25:26.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c	2007-05-08 14:28:20.854616591 +1000
@@ -108,14 +108,19 @@ xfs_page_trace(
 
 /*
  * Schedule IO completion handling on a xfsdatad if this was
- * the final hold on this ioend.
+ * the final hold on this ioend. If we are asked to wait,
+ * flush the workqueue.
  */
 STATIC void
 xfs_finish_ioend(
-	xfs_ioend_t		*ioend)
+	xfs_ioend_t	*ioend,
+	int		wait)
 {
-	if (atomic_dec_and_test(&ioend->io_remaining))
+	if (atomic_dec_and_test(&ioend->io_remaining)) {
 		queue_work(xfsdatad_workqueue, &ioend->io_work);
+		if (wait)
+			flush_workqueue(xfsdatad_workqueue);
+	}
 }
 
 /*
@@ -334,7 +339,7 @@ xfs_end_bio(
 	bio->bi_end_io = NULL;
 	bio_put(bio);
 
-	xfs_finish_ioend(ioend);
+	xfs_finish_ioend(ioend, 0);
 	return 0;
 }
 
@@ -470,7 +475,7 @@ xfs_submit_ioend(
 		}
 		if (bio)
 			xfs_submit_ioend_bio(ioend, bio);
-		xfs_finish_ioend(ioend);
+		xfs_finish_ioend(ioend, 0);
 	} while ((ioend = next) != NULL);
 }
 
@@ -1408,6 +1413,13 @@ xfs_end_io_direct(
 	 * This is not necessary for synchronous direct I/O, but we do
 	 * it anyway to keep the code uniform and simpler.
 	 *
+	 * Well, if only it were that simple. Because synchronous direct I/O
+	 * requires extent conversion to occur *before* we return to userspace,
+	 * we have to wait for extent conversion to complete. Look at the
+	 * iocb that has been passed to use to determine if this is AIO or
+	 * not. If it is synchronous, tell xfs_finish_ioend() to kick the
+	 * workqueue and wait for it to complete.
+	 *
 	 * The core direct I/O code might be changed to always call the
 	 * completion handler in the future, in which case all this can
 	 * go away.
@@ -1415,9 +1427,9 @@ xfs_end_io_direct(
 	ioend->io_offset = offset;
 	ioend->io_size = size;
 	if (ioend->io_type == IOMAP_READ) {
-		xfs_finish_ioend(ioend);
+		xfs_finish_ioend(ioend, 0);
 	} else if (private && size > 0) {
-		xfs_finish_ioend(ioend);
+		xfs_finish_ioend(ioend, is_sync_kiocb(iocb) ? 1 : 0);
 	} else {
 		/*
 		 * A direct I/O write ioend starts it's life in unwritten
@@ -1426,7 +1438,7 @@ xfs_end_io_direct(
 		 * handler.
 		 */
 		INIT_WORK(&ioend->io_work, xfs_end_bio_written);
-		xfs_finish_ioend(ioend);
+		xfs_finish_ioend(ioend, 0);
 	}
 
 	/*
