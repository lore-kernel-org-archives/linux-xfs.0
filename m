Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C7747F72
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 00:29:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E269FAC005
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 22:29:42 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dMETUeFdlf5APox7 for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 22:29:41 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WHp2h-0004rl-TC
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 17:29:31 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WHp2h-0001LN-SG
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 17:29:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/10] repair: limit auto-striding concurrency apprpriately
Date: Mon, 24 Feb 2014 17:29:23 +1100
Message-Id: <1393223369-4696-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1393223369-4696-1-git-send-email-david@fromorbit.com>
References: <1393223369-4696-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

It's possible to have filesystems with hundreds of AGs on systems
with little concurrency and resources. In this case, we can easily
exhaust memory and fail to create threads and have all sorts of
interesting problems.

xfs/250 can cause this to occur, with failures like:

        - agno = 707
        - agno = 692
fatal error -- cannot create worker threads, error = [11] Resource temporarily unavailable

And this:

        - agno = 484
        - agno = 782
failed to create prefetch thread: Resource temporarily unavailable

Because it's trying to create more threads than a poor little 512MB
single CPU ia32 box can handle.

So, limit concurrency to a maximum of numcpus * 8 to prevent this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 include/libxfs.h    |  1 +
 libxfs/init.h       |  1 -
 repair/xfs_repair.c | 21 ++++++++++++++++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index bb0369f..f688598 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -144,6 +144,7 @@ extern void	libxfs_device_close (dev_t);
 extern int	libxfs_device_alignment (void);
 extern void	libxfs_report(FILE *);
 extern void	platform_findsizes(char *path, int fd, long long *sz, int *bsz);
+extern int	platform_nproc(void);
 
 /* check or write log footer: specify device, log size in blocks & uuid */
 typedef xfs_caddr_t (libxfs_get_block_t)(xfs_caddr_t, int, void *);
diff --git a/libxfs/init.h b/libxfs/init.h
index f0b8cb6..112febb 100644
--- a/libxfs/init.h
+++ b/libxfs/init.h
@@ -31,7 +31,6 @@ extern char *platform_findrawpath (char *path);
 extern char *platform_findblockpath (char *path);
 extern int platform_direct_blockdev (void);
 extern int platform_align_blockdev (void);
-extern int platform_nproc(void);
 extern unsigned long platform_physmem(void);	/* in kilobytes */
 extern int platform_has_uuid;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index bac334f..6327076 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -629,13 +629,32 @@ main(int argc, char **argv)
 	 * to target these for an increase in thread count. Hence a stride value
 	 * of 15 is chosen to ensure we get at least 2 AGs being scanned at once
 	 * on such filesystems.
+	 *
+	 * Limit the maximum thread count based on the available CPU power that
+	 * is available. If we use too many threads, we might run out of memory
+	 * and CPU power before we run out of IO concurrency. We limit to 8
+	 * threads/CPU as this is enough threads to saturate a CPU on fast
+	 * devices, yet few enough that it will saturate but won't overload slow
+	 * devices.
 	 */
 	if (!ag_stride && glob_agcount >= 16 && do_prefetch)
 		ag_stride = 15;
 
 	if (ag_stride) {
+		int max_threads = platform_nproc() * 8;
+
 		thread_count = (glob_agcount + ag_stride - 1) / ag_stride;
-		thread_init();
+		while (thread_count > max_threads) {
+			ag_stride *= 2;
+			thread_count = (glob_agcount + ag_stride - 1) /
+								ag_stride;
+		}
+		if (thread_count > 0)
+			thread_init();
+		else {
+			thread_count = 1;
+			ag_stride = 0;
+		}
 	}
 
 	if (ag_stride && report_interval) {
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
