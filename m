Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n55GKVkA054997 for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 11:20:31 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABE281BCE1FE
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2009 09:20:48 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 6ulvwIprp0RWTBw2 for <xfs@oss.sgi.com>;
	Fri, 05 Jun 2009 09:20:48 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n55GKmWV006123
	for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 12:20:48 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n55GKlOg008817
	for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 12:20:47 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n55GKiQ7005512
	for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 12:20:45 -0400
Message-ID: <4A2945DC.8040809@redhat.com>
Date: Fri, 05 Jun 2009 11:20:44 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: update aio-stress.c, with copyright information
	intact
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
To: xfs mailing list <xfs@oss.sgi.com>

Pulled from:
http://ltp.cvs.sourceforge.net/viewvc/ltp/ltp/testcases/kernel/io/ltp-aiodio/aio-stress.c
revision 1.8

There are a couple new options, but the main motivator is to
get the license text intact again.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

iff --git a/ltp/aio-stress.c b/ltp/aio-stress.c
index 6ebe082..ab9e006 100644
--- a/ltp/aio-stress.c
+++ b/ltp/aio-stress.c
@@ -1,7 +1,45 @@
 /*
+ * Copyright (c) 2004 SuSE, Inc.  All Rights Reserved.
+ * 
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ * 
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * 
+ * Further, this software is distributed without any warranty that it is
+ * free of the rightful claim of any third person regarding infringement
+ * or the like.  Any license provided herein, whether implied or
+ * otherwise, applies only to this software file.  Patent licenses, if
+ * any, provided herein do not apply to combinations of this program with
+ * other software, or any other product whatsoever.
+ * 
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write the Free Software Foundation, Inc., 59
+ * Temple Place - Suite 330, Boston MA 02111-1307, USA.
+ * 
+ *
+ * aio-stress
+ *
+ * will open or create each file on the command line, and start a series
+ * of aio to it.  
+ *
+ * aio is done in a rotating loop.  first file1 gets 8 requests, then
+ * file2, then file3 etc.  As each file finishes writing, it is switched
+ * to reads
+ *
+ * io buffers are aligned in case you want to do raw io
+ *
+ * compile with gcc -Wall -laio -lpthread -o aio-stress aio-stress.c
+ *
+ * run aio-stress -h to see the options
+ *
+ * Please mail Chris Mason (mason@suse.com) with bug reports or patches
  */
 #define _FILE_OFFSET_BITS 64
-#define PROG_VERSION "0.18"
+#define PROG_VERSION "0.21"
 #define NEW_GETEVENTS
 
 #include <stdio.h>
@@ -50,6 +88,7 @@ unsigned long page_size_mask;
 int o_direct = 0;
 int o_sync = 0;
 int latency_stats = 0;
+int completion_latency_stats = 0;
 int io_iter = 8;
 int iterations = RUN_FOREVER;
 int max_io_submit = 0;
@@ -67,6 +106,7 @@ int padded_reclen = 0;
 int stonewall = 1;
 int verify = 0;
 char *verify_buf = NULL;
+int unlink_files = 0;
 
 struct io_unit;
 struct thread_info;
@@ -164,6 +204,8 @@ struct io_unit {
     long res;
 
     struct io_unit *next;
+
+    struct timeval io_start_time;		/* time of io_submit */
 };
 
 struct thread_info {
@@ -203,15 +245,20 @@ struct thread_info {
 
     /* how much io this thread did in the last stage */
     double stage_mb_trans;
+
+    /* latency completion stats i/o time from io_submit until io_getevents */
+    struct io_latency io_completion_latency;
 };
 
-static double time_since(struct timeval *tv) {
+/*
+ * return seconds between start_tv and stop_tv in double precision
+ */
+static double time_since(struct timeval *start_tv, struct timeval *stop_tv)
+{
     double sec, usec;
     double ret;
-    struct timeval stop;
-    gettimeofday(&stop, NULL);
-    sec = stop.tv_sec - tv->tv_sec;
-    usec = stop.tv_usec - tv->tv_usec;
+    sec = stop_tv->tv_sec - start_tv->tv_sec;
+    usec = stop_tv->tv_usec - start_tv->tv_usec;
     if (sec > 0 && usec < 0) {
         sec--;
 	usec += 1000000;
@@ -222,11 +269,25 @@ static double time_since(struct timeval *tv) {
     return ret;
 }
 
-static void calc_latency(struct timeval *tv, struct io_latency *lat)
+/*
+ * return seconds between start_tv and now in double precision
+ */
+static double time_since_now(struct timeval *start_tv)
+{
+    struct timeval stop_time;
+    gettimeofday(&stop_time, NULL);
+    return time_since(start_tv, &stop_time);
+}
+
+/*
+ * Add latency info to latency struct 
+ */
+static void calc_latency(struct timeval *start_tv, struct timeval *stop_tv,
+			struct io_latency *lat)
 {
     double delta;
     int i;
-    delta = time_since(tv);
+    delta = time_since(start_tv, stop_tv);
     delta = delta * 1000;
 
     if (delta > lat->max)
@@ -344,20 +405,19 @@ static void print_time(struct io_oper *oper) {
     double tput;
     double mb;
 
-    runtime = time_since(&oper->start_time); 
+    runtime = time_since_now(&oper->start_time); 
     mb = oper_mb_trans(oper);
     tput = mb / runtime;
     fprintf(stderr, "%s on %s (%.2f MB/s) %.2f MB in %.2fs\n", 
 	    stage_name(oper->rw), oper->file_name, tput, mb, runtime);
 }
 
-static void print_latency(struct thread_info *t) {
-    struct io_latency *lat = &t->io_submit_latency;
+static void print_lat(char *str, struct io_latency *lat) {
     double avg = lat->total_lat / lat->total_io;
     int i;
     double total_counted = 0;
-    fprintf(stderr, "latency min %.2f avg %.2f max %.2f\n\t", 
-            lat->min, avg, lat->max);
+    fprintf(stderr, "%s min %.2f avg %.2f max %.2f\n\t", 
+            str, lat->min, avg, lat->max);
 
     for (i = 0 ; i < DEVIATIONS ; i++) {
 	fprintf(stderr, " %.0f < %d", lat->deviations[i], deviations[i]);
@@ -366,16 +426,30 @@ static void print_latency(struct thread_info *t) {
     if (total_counted && lat->total_io - total_counted)
         fprintf(stderr, " < %.0f", lat->total_io - total_counted);
     fprintf(stderr, "\n");
-    memset(&t->io_submit_latency, 0, sizeof(t->io_submit_latency));
+    memset(lat, 0, sizeof(*lat));
+}
+
+static void print_latency(struct thread_info *t)
+{
+    struct io_latency *lat = &t->io_submit_latency;
+    print_lat("latency", lat);
+}
+
+static void print_completion_latency(struct thread_info *t)
+{
+    struct io_latency *lat = &t->io_completion_latency;
+    print_lat("completion latency", lat);
 }
 
 /*
  * updates the fields in the io operation struct that belongs to this
  * io unit, and make the io unit reusable again
  */
-void finish_io(struct thread_info *t, struct io_unit *io, long result) {
+void finish_io(struct thread_info *t, struct io_unit *io, long result,
+		struct timeval *tv_now) {
     struct io_oper *oper = io->io_oper;
 
+    calc_latency(&io->io_start_time, tv_now, &t->io_completion_latency);
     io->res = result;
     io->busy = IO_FREE;
     io->next = t->free_ious;
@@ -396,6 +470,7 @@ int read_some_events(struct thread_info *t) {
     int nr;
     int i; 
     int min_nr = io_iter;
+    struct timeval stop_time;
 
     if (t->num_global_pending < io_iter)
         min_nr = t->num_global_pending;
@@ -408,10 +483,11 @@ int read_some_events(struct thread_info *t) {
     if (nr <= 0)
         return nr;
 
+    gettimeofday(&stop_time, NULL);
     for (i = 0 ; i < nr ; i++) {
 	event = t->events + i;
 	event_io = (struct io_unit *)((unsigned long)event->obj); 
-	finish_io(t, event_io, event->res);
+	finish_io(t, event_io, event->res, &stop_time);
     }
     return nr;
 }
@@ -465,9 +541,11 @@ static int io_oper_wait(struct thread_info *t, struct io_oper *oper) {
 #else
     while(io_getevents(t->io_ctx, 1, &event, NULL) > 0) {
 #endif
+	struct timeval tv_now;
         event_io = (struct io_unit *)((unsigned long)event.obj); 
 
-	finish_io(t, event_io, event.res);
+	gettimeofday(&tv_now, NULL);
+	finish_io(t, event_io, event.res, &tv_now);
 
 	if (oper->num_pending == 0)
 	    break;
@@ -641,7 +719,8 @@ int build_oper(struct thread_info *t, struct io_oper *oper, int num_ios,
  * runs through the iocbs in the array provided and updates
  * counters in the associated oper struct
  */
-static void update_iou_counters(struct iocb **my_iocbs, int nr) 
+static void update_iou_counters(struct iocb **my_iocbs, int nr,
+	struct timeval *tv_now) 
 {
     struct io_unit *io;
     int i;
@@ -649,6 +728,7 @@ static void update_iou_counters(struct iocb **my_iocbs, int nr)
 	io = (struct io_unit *)(my_iocbs[i]);
 	io->io_oper->num_pending++;
 	io->io_oper->started_ios++;
+	io->io_start_time = *tv_now;	/* set time of io_submit */
     }
 }
 
@@ -657,15 +737,18 @@ int run_built(struct thread_info *t, int num_ios, struct iocb **my_iocbs)
 {
     int ret;
     struct timeval start_time;
+    struct timeval stop_time;
 
 resubmit:
     gettimeofday(&start_time, NULL);
     ret = io_submit(t->io_ctx, num_ios, my_iocbs);
-    calc_latency(&start_time, &t->io_submit_latency);
+    gettimeofday(&stop_time, NULL);
+    calc_latency(&start_time, &stop_time, &t->io_submit_latency);
+
     if (ret != num_ios) {
 	/* some ios got through */
 	if (ret > 0) {
-	    update_iou_counters(my_iocbs, ret);
+	    update_iou_counters(my_iocbs, ret, &stop_time);
 	    my_iocbs += ret;
 	    t->num_global_pending += ret;
 	    num_ios -= ret;
@@ -675,15 +758,19 @@ resubmit:
 	 * retry
 	 */
 	if (ret > 0 || ret == -EAGAIN) {
+	    int old_ret = ret;
 	    if ((ret = read_some_events(t) > 0)) {
 		goto resubmit;
+	    } else {
+	    	fprintf(stderr, "ret was %d and now is %d\n", ret, old_ret);
+		abort();
 	    }
 	}
 
 	fprintf(stderr, "ret %d (%s) on io_submit\n", ret, strerror(-ret));
 	return -1;
     }
-    update_iou_counters(my_iocbs, ret);
+    update_iou_counters(my_iocbs, ret, &stop_time);
     t->num_global_pending += ret;
     return 0;
 }
@@ -972,7 +1059,7 @@ free_buffers:
  */
 void global_thread_throughput(struct thread_info *t, char *this_stage) {
     int i;
-    double runtime = time_since(&global_stage_start_time);
+    double runtime = time_since_now(&global_stage_start_time);
     double total_mb = 0;
     double min_trans = 0;
 
@@ -1013,121 +1100,109 @@ int worker(struct thread_info *t)
     aio_setup(&t->io_ctx, 512);
 
 restart:
-    printf("Starting %s iter:%d \n", __FUNCTION__,iteration);
     if (num_threads > 1) {
-        printf("num_threads %d \n", num_threads);
         pthread_mutex_lock(&stage_mutex);
-        threads_starting++;
-        if (threads_starting == num_threads) {
-            threads_ending = 0;
-            gettimeofday(&global_stage_start_time, NULL);
-            pthread_cond_broadcast(&stage_cond);
-        }
-        while (threads_starting != num_threads)
-            pthread_cond_wait(&stage_cond, &stage_mutex);
+	threads_starting++;
+	if (threads_starting == num_threads) {
+	    threads_ending = 0;
+	    gettimeofday(&global_stage_start_time, NULL);
+	    pthread_cond_broadcast(&stage_cond);
+	}
+	while (threads_starting != num_threads)
+	    pthread_cond_wait(&stage_cond, &stage_mutex);
         pthread_mutex_unlock(&stage_mutex);
     }
     if (t->active_opers) {
-//        printf("active_opers %p line:%d\n", t->active_opers, __LINE__);
         this_stage = stage_name(t->active_opers->rw);
-        gettimeofday(&stage_time, NULL);
-        t->stage_mb_trans = 0;
+	gettimeofday(&stage_time, NULL);
+	t->stage_mb_trans = 0;
     }
+
     cnt = 0;
     /* first we send everything through aio */
-//    printf("cnt:%d max_iterations:%d oper:%p\n",cnt, iterations,oper);
-                        
-    while (t->active_opers && (cnt < iterations || iterations == RUN_FOREVER)) {
-//        printf("active_opers %p line:%d cnt:%d ", t->active_opers,__LINE__,cnt);
-        if (stonewall && threads_ending) {
-            oper = t->active_opers;     
-            oper->stonewalled = 1;
-            oper_list_del(oper, &t->active_opers);
-            oper_list_add(oper, &t->finished_opers);
-//            printf(" if branch\n");
-        } else {
-            run_active_list(t, io_iter,  max_io_submit);
-//            printf(" else branch\n");
+    while(t->active_opers && (cnt < iterations || iterations == RUN_FOREVER)) {
+	if (stonewall && threads_ending) {
+	    oper = t->active_opers;
+	    oper->stonewalled = 1;
+	    oper_list_del(oper, &t->active_opers);
+	    oper_list_add(oper, &t->finished_opers);
+	} else {
+	    run_active_list(t, io_iter,  max_io_submit);
         }
-        cnt++;
+	cnt++;
     }
-  
     if (latency_stats)
         print_latency(t);
 
+    if (completion_latency_stats)
+	print_completion_latency(t);
+
     /* then we wait for all the operations to finish */
     oper = t->finished_opers;
-//    printf("line:%d oper:%p\n", __LINE__, oper);
     do {
-        io_oper_wait(t, oper);
-        if (oper != NULL) {
-            oper = oper->next;
-        }
-    } while (oper != t->finished_opers);
-//    printf("finished_opers %p line:%d\n", t->finished_opers,__LINE__);
+	if (!oper)
+		break;
+	io_oper_wait(t, oper);
+	oper = oper->next;
+    } while(oper != t->finished_opers);
 
     /* then we do an fsync to get the timing for any future operations
      * right, and check to see if any of these need to get restarted
      */
     oper = t->finished_opers;
-//    printf("oper %p line:%d\n", oper,__LINE__);
-    while (oper) {
-        if (fsync_stages)
+    while(oper) {
+	if (fsync_stages)
             fsync(oper->fd);
-        t->stage_mb_trans += oper_mb_trans(oper);
-        if (restart_oper(oper)) {
-            oper_list_del(oper, &t->finished_opers);
-            oper_list_add(oper, &t->active_opers);
-            oper = t->finished_opers;
-            continue;
-        }
-        oper = oper->next;
-        if (oper == t->finished_opers)
-            break;
+	t->stage_mb_trans += oper_mb_trans(oper);
+	if (restart_oper(oper)) {
+	    oper_list_del(oper, &t->finished_opers);
+	    oper_list_add(oper, &t->active_opers);
+	    oper = t->finished_opers;
+	    continue;
+	}
+	oper = oper->next;
+	if (oper == t->finished_opers)
+	    break;
     } 
 
     if (t->stage_mb_trans && t->num_files > 0) {
-//        printf("num_files %d line:%d\n", t->num_files,__LINE__);
-        double seconds = time_since(&stage_time);
-        fprintf(stderr, "thread %d %s totals (%.2f MB/s) %.2f MB in %.2fs\n", 
-                t - global_thread_info, this_stage, t->stage_mb_trans/seconds, 
-                t->stage_mb_trans, seconds);
+        double seconds = time_since_now(&stage_time);
+	fprintf(stderr, "thread %d %s totals (%.2f MB/s) %.2f MB in %.2fs\n", 
+	        t - global_thread_info, this_stage, t->stage_mb_trans/seconds, 
+		t->stage_mb_trans, seconds);
     }
 
     if (num_threads > 1) {
-//        printf("num_threads %d line:%d\n", num_threads,__LINE__);
-        pthread_mutex_lock(&stage_mutex);
-        threads_ending++;
-        if (threads_ending == num_threads) {
-            threads_starting = 0;
-            pthread_cond_broadcast(&stage_cond);
-            global_thread_throughput(t, this_stage);
-        }
-//        printf("threads_ending %d line:%d\n", threads_ending,__LINE__);
-        while (threads_ending != num_threads)
-            pthread_cond_wait(&stage_cond, &stage_mutex);
-        pthread_mutex_unlock(&stage_mutex);
+	pthread_mutex_lock(&stage_mutex);
+	threads_ending++;
+	if (threads_ending == num_threads) {
+	    threads_starting = 0;
+	    pthread_cond_broadcast(&stage_cond);
+	    global_thread_throughput(t, this_stage);
+	}
+	while(threads_ending != num_threads)
+	    pthread_cond_wait(&stage_cond, &stage_mutex);
+	pthread_mutex_unlock(&stage_mutex);
     }
-
+    
     /* someone got restarted, go back to the beginning */
     if (t->active_opers && (cnt < iterations || iterations == RUN_FOREVER)) {
-        iteration++;
+	iteration++;
         goto restart;
     }
 
     /* finally, free all the ram */
-//    printf("finished_opers %p line:%d\n", t->finished_opers,__LINE__);
-    while (t->finished_opers) {
-        oper = t->finished_opers;
-        oper_list_del(oper, &t->finished_opers);
-        status = finish_oper(t, oper);
+    while(t->finished_opers) {
+	oper = t->finished_opers;
+	oper_list_del(oper, &t->finished_opers);
+	status = finish_oper(t, oper);
     }
 
     if (t->num_global_pending) {
         fprintf(stderr, "global num pending is %d\n", t->num_global_pending);
     }
     io_queue_release(t->io_ctx);
-
+    
     return status;
 }
 
@@ -1138,7 +1213,6 @@ int run_workers(struct thread_info *t, int num_threads)
     int thread_ret;
     int i;
 
-//    printf("%s num_threads %d line:%d\n", __FUNCTION__,num_threads,__LINE__);
     for(i = 0 ; i < num_threads ; i++) {
         ret = pthread_create(&t[i].tid, NULL, (start_routine)worker, t + i);
 	if (ret) {
@@ -1178,6 +1252,10 @@ off_t parse_size(char *size_arg, off_t mult) {
     case 'K':
         mult = 1024;
 	break;
+    case 'b':
+    case 'B':
+        mult = 1;
+	break;
     }
     ret = mult * num;
     return ret;
@@ -1205,7 +1283,9 @@ void print_usage(void) {
     printf("\t-m shmfs mmap a file in /dev/shm for io buffers\n");
     printf("\t-n no fsyncs between write stage and read stage\n");
     printf("\t-l print io_submit latencies after each stage\n");
+    printf("\t-L print io completion latencies after each stage\n");
     printf("\t-t number of threads to run\n");
+    printf("\t-u unlink files after completion\n");
     printf("\t-v verification of bytes written\n");
     printf("\t-x turn off thread stonewalling\n");
     printf("\t-h this message\n");
@@ -1232,7 +1312,7 @@ int main(int ac, char **av)
     page_size_mask = getpagesize() - 1;
 
     while(1) {
-	c = getopt(ac, av, "a:b:c:C:m:s:r:d:i:I:o:t:lnhOSxv");
+	c = getopt(ac, av, "a:b:c:C:m:s:r:d:i:I:o:t:lLnhOSxvu");
 	if  (c < 0)
 	    break;
 
@@ -1270,6 +1350,9 @@ int main(int ac, char **av)
 	case 'l':
 	    latency_stats = 1;
 	    break;
+	case 'L':
+	    completion_latency_stats = 1;
+	    break;
 	case 'm':
 	    if (!strcmp(optarg, "shm")) {
 		fprintf(stderr, "using ipc shm\n");
@@ -1296,6 +1379,9 @@ int main(int ac, char **av)
 	case 'x':
 	    stonewall = 0;
 	    break;
+	case 'u':
+	    unlink_files = 1;
+	    break;
 	case 'v':
 	    verify = 1;
 	    break;
@@ -1379,7 +1465,6 @@ int main(int ac, char **av)
 	for (j = 0 ; j < num_contexts ; j++) {
 	    thread_index = open_fds % num_threads;
 	    open_fds++;
-//	    fprintf(stderr, "adding file %s thread %d\n", av[i], thread_index);
 
 	    rwfd = open(av[i], O_CREAT | O_RDWR | o_direct | o_sync, 0600);
 	    assert(rwfd != -1);
@@ -1407,25 +1492,21 @@ int main(int ac, char **av)
     if (num_threads > 1){
         printf("Running multi thread version num_threads:%d\n", num_threads);
         run_workers(t, num_threads);
-    }
-    else {
+    } else {
         printf("Running single thread version \n");
-        status = worker(t);
+	status = worker(t);
     }
-
-
-    for (i = optind ; i < ac ; i++) {
-        printf("Cleaning up file %s \n", av[i]);
-        unlink(av[i]);
+    if (unlink_files) {
+	for (i = optind ; i < ac ; i++) {
+	    printf("Cleaning up file %s \n", av[i]);
+	    unlink(av[i]);
+	}
     }
 
     if (status) {
-    printf("non zero return %d \n", status);
-    }
-    else{
-        printf("aio-stress Completed successfully %d \n", status);
+	exit(1);
     }
-
-    exit(0);
+    return status;
 }
 
+


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
