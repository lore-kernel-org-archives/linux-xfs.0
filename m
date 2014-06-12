Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B380E7F3F
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 03:34:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A20CB8F8033
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 01:34:14 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	U8wwuJeSrrJ8PSmu for <xfs@oss.sgi.com>;
	Thu, 12 Jun 2014 01:34:11 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wv0SV-0004ej-Fc
	for xfs@oss.sgi.com; Thu, 12 Jun 2014 18:34:07 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Wv0SV-000894-DW
	for xfs@oss.sgi.com; Thu, 12 Jun 2014 18:34:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] [RFC] xfs: wire up aio_fsync method
Date: Thu, 12 Jun 2014 18:34:07 +1000
Message-Id: <1402562047-31276-1-git-send-email-david@fromorbit.com>
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

We've had plenty of requests for an asynchronous fsync over the past
few years, and we've got the infrastructure there to do it. But
nobody has wired it up to test it. The common request we get from
userspace storage applications is to do a post-write pass over a set
of files that were just written (i.e. bulk background fsync) for
point-in-time checkpointing or flushing purposes.

So, just to see if I could brute force an effective implementation,
wire up aio_fsync, add a workqueue and push all the fsync calls off
to the workqueue. The workqueue will allow parallel dispatch, switch
execution if a fsync blocks for any reason, etc. Brute force and
very effective....

So, I hacked up fs_mark to enable fsync via the libaio io_fsync()
interface to run some tests. The quick test is:

	- write 10000 4k files into the cache
	- run a post write open-fsync-close pass (sync mode 5)
	- run 5 iterations
	- run a single thread, then 4 threads.

First I ran it on a 500TB sparse filesystem on a SSD.

FSUse%        Count         Size    Files/sec     App Overhead
     0        10000         4096        599.1           153855
     0        20000         4096        739.2           151228
     0        30000         4096        672.2           152937
     0        40000         4096        719.9           150615
     0        50000         4096        708.4           154889

real    1m13.121s
user    0m0.825s
sys     0m11.024s

Runs at around 500 log forces a second and 1500 IOPS.

Using io_fsync():

FSUse%        Count         Size    Files/sec     App Overhead
     0        10000         4096       2700.5           130313
     0        20000         4096       3938.8           133602
     0        30000         4096       4608.7           107871
     0        40000         4096       4768.4            82965
     0        50000         4096       4615.0            89220

real    0m12.691s
user    0m0.460s
sys     0m7.389s

Runs at around 4,000 log forces a second and 4500 IOPS. Massive
reduction in runtime through parallel dispatch of the fsync calls.

Run the same workload, 4 threads at a time. Normal fsync:

FSUse%        Count         Size    Files/sec     App Overhead
     0        40000         4096       2151.5           617010
     0        80000         4096       1953.0           613470
     0       120000         4096       1874.4           625027
     0       160000         4096       1907.4           624319
     0       200000         4096       1924.3           627567

real    1m42.243s
user    0m3.552s
sys     0m49.118s

Runs at ~2000 log forces/s and 3,500 IOPS.

Using io_fsync():

FSUse%        Count         Size    Files/sec     App Overhead
     0        40000         4096      11518.9           427666
     0        80000         4096      15668.8           401661
     0       120000         4096      15607.0           382279
     0       160000         4096      14935.0           399097
     0       200000         4096      15198.6           413965

real    0m14.192s
user    0m1.891s
sys     0m30.136s

Almost perfect scaling! ~15,000 log forces a second and ~20,000 IOPS.

Now run the tests on a HW RAID0 of spinning disk:

Threads		files/s	   run time	log force/s	IOPS
 1, fsync	  800	    1m 5.1s	   800		 1500
 1, io_fsync	 6000	       8.4s	  5000		 5500
 4, fsync	 1800	    1m47.1s	  2200		 3500
 4, io_fsync	19000	      10.3s	 21000		26000

Pretty much the same results. Spinning disks don't scale much
further. The SSD can go a bit higher, with 8 threads generating
a consistent 24,000 files/s, but at that point we're starting to see
non-linear system CPU usage (probably lock contention in the log).

But, regardless, there's a massive potential for speed gains for
applications that need to do bulk fsync operations and don't need to
care about the IO latency of individual fsync operations....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c  | 41 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h |  2 ++
 fs/xfs/xfs_super.c |  9 +++++++++
 3 files changed, 52 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 077bcc8..9cdecee 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -45,6 +45,7 @@
 #include <linux/pagevec.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
+struct workqueue_struct *xfs_aio_fsync_wq;
 
 /*
  * Locking primitives for read and write IO paths to ensure we consistently use
@@ -228,6 +229,45 @@ xfs_file_fsync(
 	return error;
 }
 
+struct xfs_afsync_args {
+	struct work_struct	work;
+	struct kiocb		*iocb;
+	struct file		*file;
+	int			datasync;
+};
+
+STATIC void
+xfs_file_aio_fsync_work(
+	struct work_struct	*work)
+{
+	struct xfs_afsync_args	*args = container_of(work,
+						struct xfs_afsync_args, work);
+	int			error;
+
+	error = xfs_file_fsync(args->file, 0, -1LL, args->datasync);
+	aio_complete(args->iocb, error, 0);
+	kmem_free(args);
+}
+
+STATIC int
+xfs_file_aio_fsync(
+	struct kiocb		*iocb,
+	int			datasync)
+{
+	struct xfs_afsync_args	*args;
+
+	args = kmem_zalloc(sizeof(struct xfs_afsync_args), KM_SLEEP|KM_MAYFAIL);
+	if (!args)
+		return -ENOMEM;
+
+	INIT_WORK(&args->work, xfs_file_aio_fsync_work);
+	args->iocb = iocb;
+	args->file = iocb->ki_filp;
+	args->datasync = datasync;
+	queue_work(xfs_aio_fsync_wq, &args->work);
+	return -EIOCBQUEUED;
+}
+
 STATIC ssize_t
 xfs_file_aio_read(
 	struct kiocb		*iocb,
@@ -1475,6 +1515,7 @@ const struct file_operations xfs_file_operations = {
 	.open		= xfs_file_open,
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
+	.aio_fsync	= xfs_file_aio_fsync,
 	.fallocate	= xfs_file_fallocate,
 };
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7295a0b..dfcf37b 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -390,6 +390,8 @@ extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
 
 extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 
+extern struct workqueue_struct *xfs_aio_fsync_wq;
+
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f2e5f8a..86d4923 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1718,12 +1718,21 @@ xfs_init_workqueues(void)
 	if (!xfs_alloc_wq)
 		return -ENOMEM;
 
+	xfs_aio_fsync_wq = alloc_workqueue("xfsfsync", 0, 0);
+	if (!xfs_aio_fsync_wq)
+		goto destroy_alloc_wq;
+
 	return 0;
+
+destroy_alloc_wq:
+	destroy_workqueue(xfs_alloc_wq);
+	return -ENOMEM;
 }
 
 STATIC void
 xfs_destroy_workqueues(void)
 {
+	destroy_workqueue(xfs_aio_fsync_wq);
 	destroy_workqueue(xfs_alloc_wq);
 }
 
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
