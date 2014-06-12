Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 739877F3F
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 03:56:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5FDDF304048
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 01:56:54 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	w5crfZJw9uKcZo88 for <xfs@oss.sgi.com>;
	Thu, 12 Jun 2014 01:56:49 -0700 (PDT)
Date: Thu, 12 Jun 2014 18:56:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] [RFC] fs_mark: add asynchronous fsync
Message-ID: <20140612085645.GP9508@dastard>
References: <1402562047-31276-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1402562047-31276-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: rwheeler@redhat.com

From: Dave Chinner <dchinner@redhat.com>

to be able to test the performance impact of asynchronous bulk
fsync of newly created files, add an option to fsmark to be able
to use libaio for dispatch and collection of fsync operations. This
requires a filesystem that has wired up IO_CMD_FSYNC in the kernel.

This is all a bit hacky, but it does wait for all fsyncs to
complete. aio contexts have to be set up after the runner thread
have been forked, so it's not really using a global iocb and event
array as the code appears - there's one per child process doing
work, and hence there's no need for locking or other fancy stuff.

No attempt has been made to tune the number of AIOs allowed to be in
flight, nor has there been any attempt to optimise the collection of
completion events nor return errors if an fsync fails. It works well
enough for testing the new XFS code and that's all I need from it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

--- a/fs_mark.c	2011-07-30 10:09:43.000000000 +1000
+++ b/fs_mark.c	2014-06-12 18:01:43.000000000 +1000
@@ -41,6 +41,7 @@
 #include <dirent.h>
 #include <ctype.h>
 #include <time.h>
+#include <libaio.h>
 
 #include <linux/types.h>
 #include <linux/limits.h>
@@ -68,6 +69,7 @@
 		"\t-S Sync Method (0:No Sync, 1:fsyncBeforeClose, "
 		"2:sync/1_fsync, 3:PostReverseFsync, "
 		"4:syncPostReverseFsync, 5:PostFsync, 6:syncPostFsync)\n",
+		"\t-A <use aio_fsync>\n"
 		"\t[-D number (of subdirectories)]\n",
 		"\t[-N number (of files in each subdirectory in Round Robin mode)]\n",
 		"\t[-d dir1 ... -d dirN]\n", "\t[-l log_file_name]\n",
@@ -84,18 +86,101 @@
 }
 
 /*
+ * aio for fsync
+ */
+#define MAX_AIO_EVENTS 1024
+io_context_t ctxp;
+struct iocb *iocbs[MAX_AIO_EVENTS];
+struct io_event ioevents[MAX_AIO_EVENTS];
+int aio_next;
+int aio_flight;
+
+void
+init_aio_fsync(void)
+{
+	int i, r;
+
+        memset(&ctxp, 0, sizeof(ctxp));
+	r = io_setup(MAX_AIO_EVENTS, &ctxp);
+	if (r) {
+		printf("FAIL! io_setup returned %d\n", r);
+		cleanup_exit();
+	}
+	for (i = 0; i < MAX_AIO_EVENTS; ++i) {
+		iocbs[i] = calloc(1, sizeof(struct iocb));
+		if (iocbs[i] == NULL) {
+			printf("failed to allocate an iocb\n");
+			cleanup_exit();
+		}
+	}
+
+}
+
+void
+get_fsync_completions(int threshold)
+{
+	int i, r;
+
+	if (!(sync_method & FSYNC_ASYNC))
+		return;
+
+	while (aio_flight > threshold) {
+		/* gather up some completions */
+		r = io_getevents(ctxp, 1, MAX_AIO_EVENTS, ioevents, NULL);
+		if (r < 0)  {
+			printf("FAIL! io_getevents returned %d\n", r);
+			cleanup_exit();
+		}
+
+		aio_flight -= r;
+		for (i = 0; i < r; ++i) {
+			if (ioevents[i].res)
+				printf("FAIL! aio_fsync returned %d\n",
+					ioevents[i].res);
+		}
+		usleep(1000);
+	}
+}
+
+int
+do_fsync(int fd)
+{
+	int r, i;
+
+	if (!(sync_method & FSYNC_ASYNC))
+		return fsync(fd);
+
+
+	get_fsync_completions(MAX_AIO_EVENTS / 2);
+
+	/* submit the fsync */
+	i = aio_next++ % MAX_AIO_EVENTS;
+	aio_flight++;
+	r = io_fsync(ctxp, iocbs[i], NULL, fd);
+	if (r != 1) {
+		printf("FAIL! io_submit returned %d\n", r);
+		cleanup_exit();
+	}
+
+}
+
+/*
  * Run through the specified arguments and make sure that they make sense.
  */
 void process_args(int argc, char **argv, char **envp)
 {
 	int ret;
+	int fsync_async = 0;
 
 	/*
 	 * Parse all of the options that the user specified.
 	 */
 	while ((ret =
-		getopt(argc, argv, "vhkFr:S:N:D:d:l:L:n:p:s:t:w:")) != EOF) {
+		getopt(argc, argv, "AvhkFr:S:N:D:d:l:L:n:p:s:t:w:")) != EOF) {
 		switch (ret) {
+		case 'A':
+			fsync_async++;
+			break;
 		case 'v':	/* verbose stats */
 			verbose_stats = 1;
 			break;
@@ -250,6 +335,8 @@
 			" for -N num_per_subdir to make sense\n");
 		usage();
 	}
+	if (fsync_async)
+		sync_method |= FSYNC_ASYNC;
 
 	/*
 	 * We need at least one thread per specified directory.
@@ -650,6 +737,8 @@
 	close_usec = max_close_usec = min_close_usec = 0ULL;
 	unlink_usec = max_unlink_usec = min_unlink_usec = 0ULL;
 
+	init_aio_fsync();
+
 	/*
 	 * MAIN FILE WRITE LOOP:
 	 * This loop measures the specific steps in creating files:
@@ -714,7 +803,7 @@
 		if (sync_method & FSYNC_BEFORE_CLOSE) {
 			start(0);
 
-			if (fsync(fd) == -1) {
+			if (do_fsync(fd) == -1) {
 				fprintf(stderr, "fs_mark: fsync failed %s\n",
 					strerror(errno));
 				cleanup_exit();
@@ -775,7 +864,7 @@
 				cleanup_exit();
 			}
 
-			if (fsync(fd) == -1) {
+			if (do_fsync(fd) == -1) {
 				fprintf(stderr, "fs_mark: fsync failed %s\n",
 					strerror(errno));
 				cleanup_exit();
@@ -813,7 +902,7 @@
 				cleanup_exit();
 			}
 
-			if (fsync(fd) == -1) {
+			if (do_fsync(fd) == -1) {
 				fprintf(stderr, "fs_mark: fsync failed %s\n",
 					strerror(errno));
 				cleanup_exit();
@@ -849,7 +938,7 @@
 			cleanup_exit();
 		}
 
-		if (fsync(fd) == -1) {
+		if (do_fsync(fd) == -1) {
 			fprintf(stderr, "fs_mark: fsync failed %s\n",
 				strerror(errno));
 			cleanup_exit();
@@ -859,6 +948,8 @@
 		fsync_usec += stop(0, 0);
 	}
 
+	get_fsync_completions(0);
+
 	/*
 	 * Record the total time spent in the file writing loop - we ignore the time spent unlinking files
 	 */
@@ -1209,6 +1300,8 @@
 		fs_mark_version, num_threads, ctime(&time_run));
 	fprintf(log_fp, "#\tSync method: %s\n",
 		sync_policy_string[sync_method_type]);
+	if (sync_method & FSYNC_ASYNC)
+		fprintf(log_fp, "#\tUsing aio_fsync\n");
 	if (num_subdirs > 1) {
 		fprintf(log_fp,
 			"#\tDirectories:  %s across %d subdirectories with %d %s.\n",
--- a/fs_mark.h	2011-07-30 10:09:43.000000000 +1000
+++ b/fs_mark.h	2014-06-12 18:01:43.000000000 +1000
@@ -70,6 +70,7 @@
 #define FSYNC_FIRST_FILE	(0x4)
 #define FSYNC_POST_REVERSE	(0x8)
 #define FSYNC_POST_IN_ORDER	(0x10)
+#define FSYNC_ASYNC		(0x20)
 
 
 #define SYNC_TEST_NONE		(0)	    					/* -S 0 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
