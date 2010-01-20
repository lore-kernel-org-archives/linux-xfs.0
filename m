Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K3bJBA235613 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 21:37:20 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47724177467
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:38:17 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	IhBv9TIb6PWPH0BO for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 19:38:17 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11651449-1927428
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 14:08:15 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NXROY-00053F-85
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:14 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NXROX-00008O-5F
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] xfstests: fix printf format warnings in aio-stress.c
Date: Wed, 20 Jan 2010 14:38:04 +1100
Message-Id: <1263958688-435-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1263958688-435-1-git-send-email-david@fromorbit.com>
References: <1263958688-435-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 ltp/aio-stress.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/ltp/aio-stress.c b/ltp/aio-stress.c
index ab9e006..57a2158 100644
--- a/ltp/aio-stress.c
+++ b/ltp/aio-stress.c
@@ -1167,9 +1167,9 @@ restart:
 
     if (t->stage_mb_trans && t->num_files > 0) {
         double seconds = time_since_now(&stage_time);
-	fprintf(stderr, "thread %d %s totals (%.2f MB/s) %.2f MB in %.2fs\n", 
-	        t - global_thread_info, this_stage, t->stage_mb_trans/seconds, 
-		t->stage_mb_trans, seconds);
+	fprintf(stderr, "thread %llu %s totals (%.2f MB/s) %.2f MB in %.2fs\n",
+	        (unsigned long long)(t - global_thread_info), this_stage,
+		t->stage_mb_trans/seconds, t->stage_mb_trans, seconds);
     }
 
     if (num_threads > 1) {
@@ -1449,16 +1449,19 @@ int main(int ac, char **av)
 
     if (file_size < num_contexts * context_offset) {
         fprintf(stderr, "file size %Lu too small for %d contexts\n", 
-	        file_size, num_contexts);
+	        (unsigned long long)file_size, num_contexts);
 	exit(1);
     }
 
-    fprintf(stderr, "file size %LuMB, record size %luKB, depth %d, ios per iteration %d\n", file_size / (1024 * 1024), rec_len / 1024, depth, io_iter);
+    fprintf(stderr, "file size %LuMB, record size %luKB, depth %d, ios per iteration %d\n",
+	    (unsigned long long)file_size / (1024 * 1024),
+	    rec_len / 1024, depth, io_iter);
     fprintf(stderr, "max io_submit %d, buffer alignment set to %luKB\n", 
             max_io_submit, (page_size_mask + 1)/1024);
     fprintf(stderr, "threads %d files %d contexts %d context offset %LuMB verification %s\n", 
             num_threads, num_files, num_contexts, 
-	    context_offset / (1024 * 1024), verify ? "on" : "off");
+	    (unsigned long long)context_offset / (1024 * 1024),
+	    verify ? "on" : "off");
     /* open all the files and do any required setup for them */
     for (i = optind ; i < ac ; i++) {
 	int thread_index;
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
