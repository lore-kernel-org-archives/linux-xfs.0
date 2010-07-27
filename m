Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6R83Xfu173682 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 03:03:33 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1FD911BE87C0
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 01:06:36 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ApVHYeNkov7oPQ3K for <xfs@oss.sgi.com>;
	Tue, 27 Jul 2010 01:06:36 -0700 (PDT)
Date: Tue, 27 Jul 2010 18:06:32 +1000
From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: VFS scalability git tree
Message-ID: <20100727080632.GA4958@amd>
References: <20100722190100.GA22269@amd> <20100723135514.GJ32635@dastard>
	<20100727070538.GA2893@amd>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100727070538.GA2893@amd>
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
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

On Tue, Jul 27, 2010 at 05:05:39PM +1000, Nick Piggin wrote:
> On Fri, Jul 23, 2010 at 11:55:14PM +1000, Dave Chinner wrote:
> > On Fri, Jul 23, 2010 at 05:01:00AM +1000, Nick Piggin wrote:
> > > I'm pleased to announce I have a git tree up of my vfs scalability work.
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
> > > http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git
> > > 
> > > Branch vfs-scale-working
> > 
> > With a production build (i.e. no lockdep, no xfs debug), I'll
> > run the same fs_mark parallel create/unlink workload to show
> > scalability as I ran here:
> > 
> > http://oss.sgi.com/archives/xfs/2010-05/msg00329.html
> 
> I've made a similar setup, 2s8c machine, but using 2GB ramdisk instead
> of a real disk (I don't have easy access to a good disk setup ATM, but
> I guess we're more interested in code above the block layer anyway).
> 
> Made an XFS on /dev/ram0 with 16 ags, 64MB log, otherwise same config as
> yours.
> 
> I found that performance is a little unstable, so I sync and echo 3 >
> drop_caches between each run. When it starts reclaiming memory, things
> get a bit more erratic (and XFS seemed to be almost livelocking for tens
> of seconds in inode reclaim).

So about this XFS livelock type thingy. It looks like this, and happens
periodically while running the above fs_mark benchmark requiring reclaim
of inodes:

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
15  0   6900  31032    192 471852    0    0    28 183296 8520 46672  5 91  4  0
19  0   7044  22928    192 466712   96  144  1056 115586 8622 41695  3 96  1  0
19  0   7136  59884    192 471200  160   92  6768 34564  995  542  1 99 0  0
19  0   7244  17008    192 467860    0  104  2068 32953 1044  630  1 99 0  0
18  0   7244  43436    192 467324    0    0    12     0  817  405  0 100 0  0
18  0   7244  43684    192 467324    0    0     0     0  806  425  0 100 0  0
18  0   7244  43932    192 467324    0    0     0     0  808  403  0 100 0  0
18  0   7244  44924    192 467324    0    0     0     0  808  398  0 100 0  0
18  0   7244  45456    192 467324    0    0     0     0  809  409  0 100 0  0
18  0   7244  45472    192 467324    0    0     0     0  805  412  0 100 0  0
18  0   7244  46392    192 467324    0    0     0     0  807  401  0 100 0  0
18  0   7244  47012    192 467324    0    0     0     0  810  414  0 100 0  0
18  0   7244  47260    192 467324    0    0     0     0  806  396  0 100 0  0
18  0   7244  47752    192 467324    0    0     0     0  806  403  0 100 0  0
18  0   7244  48204    192 467324    0    0     0     0  810  409  0 100 0  0
18  0   7244  48608    192 467324    0    0     0     0  807  412  0 100 0  0
18  0   7244  48876    192 467324    0    0     0     0  805  406  0 100 0  0
18  0   7244  49000    192 467324    0    0     0     0  809  402  0 100 0  0
18  0   7244  49408    192 467324    0    0     0     0  807  396  0 100 0  0
18  0   7244  49908    192 467324    0    0     0     0  809  406  0 100 0  0
18  0   7244  50032    192 467324    0    0     0     0  805  404  0 100 0  0
18  0   7244  50032    192 467324    0    0     0     0  805  406  0 100 0  0
19  0   7244  73436    192 467324    0    0     0  6340  808  384  0 100 0  0
20  0   7244 490220    192 467324    0    0     0  8411  830  389  0 100 0  0
18  0   7244 620092    192 467324    0    0     0     4  809  435  0 100 0  0
18  0   7244 620344    192 467324    0    0     0     0  806  430  0 100 0  0
16  0   7244 682620    192 467324    0    0    44    80  890  326  0 100 0  0
12  0   7244 604464    192 479308   76    0 11716 73555 2242 14318  2 94 4  0
12  0   7244 556700    192 483488    0    0  4276 77680 6576 92285  1 97 2  0
17  0   7244 502508    192 485456    0    0  2092 98368 6308 91919  1 96 4  0
11  0   7244 416500    192 487116    0    0  1760 114844 7414 63025  2 96  2  0

Nothing much happening except 100% system time for seconds at a time
(length of time varies). This is on a ramdisk, so it isn't waiting
for IO.

During this time, lots of things are contending on the lock:

    60.37%         fs_mark  [kernel.kallsyms]   [k] __write_lock_failed
     4.30%         kswapd0  [kernel.kallsyms]   [k] __write_lock_failed
     3.70%         fs_mark  [kernel.kallsyms]   [k] try_wait_for_completion
     3.59%         fs_mark  [kernel.kallsyms]   [k] _raw_write_lock
     3.46%         kswapd1  [kernel.kallsyms]   [k] __write_lock_failed
                   |
                   --- __write_lock_failed
                      |
                      |--99.92%-- xfs_inode_ag_walk
                      |          xfs_inode_ag_iterator
                      |          xfs_reclaim_inode_shrink
                      |          shrink_slab
                      |          shrink_zone
                      |          balance_pgdat
                      |          kswapd
                      |          kthread
                      |          kernel_thread_helper
                       --0.08%-- [...]

     3.02%         fs_mark  [kernel.kallsyms]   [k] _raw_spin_lock
     1.82%         fs_mark  [kernel.kallsyms]   [k] _xfs_buf_find
     1.16%         fs_mark  [kernel.kallsyms]   [k] memcpy
     0.86%         fs_mark  [kernel.kallsyms]   [k] _raw_spin_lock_irqsave
     0.75%         fs_mark  [kernel.kallsyms]   [k] xfs_log_commit_cil
                   |
                   --- xfs_log_commit_cil
                       _xfs_trans_commit
                      |
                      |--60.00%-- xfs_remove
                      |          xfs_vn_unlink
                      |          vfs_unlink
                      |          do_unlinkat
                      |          sys_unlink

I'm not sure if there was a long-running read locker in there causing
all the write lockers to fail, or if they are just running into one
another. But anyway, I hacked the following patch which seemed to
improve that behaviour. I haven't run any throughput numbers on it yet,
but I could if you're interested (and it's not completely broken!)

Batch pag_ici_lock acquisition on the reclaim path, and also skip inodes
that appear to be busy to improve locking efficiency.

Index: source/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- source.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-07-26 21:12:11.000000000 +1000
+++ source/fs/xfs/linux-2.6/xfs_sync.c	2010-07-26 21:58:59.000000000 +1000
@@ -87,6 +87,91 @@ xfs_inode_ag_lookup(
 	return ip;
 }
 
+#define RECLAIM_BATCH_SIZE	32
+STATIC int
+xfs_inode_ag_walk_reclaim(
+	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
+	int			(*execute)(struct xfs_inode *ip,
+					   struct xfs_perag *pag, int flags),
+	int			flags,
+	int			tag,
+	int			exclusive,
+	int			*nr_to_scan)
+{
+	uint32_t		first_index;
+	int			last_error = 0;
+	int			skipped;
+	xfs_inode_t		*batch[RECLAIM_BATCH_SIZE];
+	int			batchnr;
+	int			i;
+
+	BUG_ON(!exclusive);
+
+restart:
+	skipped = 0;
+	first_index = 0;
+next_batch:
+	batchnr = 0;
+	/* fill the batch */
+	write_lock(&pag->pag_ici_lock);
+	do {
+		xfs_inode_t	*ip;
+
+		ip = xfs_inode_ag_lookup(mp, pag, &first_index, tag);
+		if (!ip)
+			break;	
+		if (!(flags & SYNC_WAIT) &&
+				(!xfs_iflock_free(ip) ||
+				__xfs_iflags_test(ip, XFS_IRECLAIM)))
+			continue;
+
+		/*
+		 * The radix tree lock here protects a thread in xfs_iget from
+		 * racing with us starting reclaim on the inode.  Once we have
+		 * the XFS_IRECLAIM flag set it will not touch us.
+		 */
+		spin_lock(&ip->i_flags_lock);
+		ASSERT_ALWAYS(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+		if (__xfs_iflags_test(ip, XFS_IRECLAIM)) {
+			/* ignore as it is already under reclaim */
+			spin_unlock(&ip->i_flags_lock);
+			continue;
+		}
+		__xfs_iflags_set(ip, XFS_IRECLAIM);
+		spin_unlock(&ip->i_flags_lock);
+
+		batch[batchnr++] = ip;
+	} while ((*nr_to_scan)-- && batchnr < RECLAIM_BATCH_SIZE);
+	write_unlock(&pag->pag_ici_lock);
+
+	for (i = 0; i < batchnr; i++) {
+		int		error = 0;
+		xfs_inode_t	*ip = batch[i];
+
+		/* execute doesn't require pag->pag_ici_lock */
+		error = execute(ip, pag, flags);
+		if (error == EAGAIN) {
+			skipped++;
+			continue;
+		}
+		if (error)
+			last_error = error;
+
+		/* bail out if the filesystem is corrupted.  */
+		if (error == EFSCORRUPTED)
+			break;
+	}
+	if (batchnr == RECLAIM_BATCH_SIZE)
+		goto next_batch;
+
+	if (0 && skipped) {
+		delay(1);
+		goto restart;
+	}
+	return last_error;
+}
+
 STATIC int
 xfs_inode_ag_walk(
 	struct xfs_mount	*mp,
@@ -113,6 +198,7 @@ restart:
 			write_lock(&pag->pag_ici_lock);
 		else
 			read_lock(&pag->pag_ici_lock);
+
 		ip = xfs_inode_ag_lookup(mp, pag, &first_index, tag);
 		if (!ip) {
 			if (exclusive)
@@ -198,8 +284,12 @@ xfs_inode_ag_iterator(
 	nr = nr_to_scan ? *nr_to_scan : INT_MAX;
 	ag = 0;
 	while ((pag = xfs_inode_ag_iter_next_pag(mp, &ag, tag))) {
-		error = xfs_inode_ag_walk(mp, pag, execute, flags, tag,
-						exclusive, &nr);
+		if (tag == XFS_ICI_RECLAIM_TAG)
+			error = xfs_inode_ag_walk_reclaim(mp, pag, execute,
+						flags, tag, exclusive, &nr);
+		else
+			error = xfs_inode_ag_walk(mp, pag, execute,
+						flags, tag, exclusive, &nr);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
@@ -789,23 +879,6 @@ xfs_reclaim_inode(
 {
 	int	error = 0;
 
-	/*
-	 * The radix tree lock here protects a thread in xfs_iget from racing
-	 * with us starting reclaim on the inode.  Once we have the
-	 * XFS_IRECLAIM flag set it will not touch us.
-	 */
-	spin_lock(&ip->i_flags_lock);
-	ASSERT_ALWAYS(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));
-	if (__xfs_iflags_test(ip, XFS_IRECLAIM)) {
-		/* ignore as it is already under reclaim */
-		spin_unlock(&ip->i_flags_lock);
-		write_unlock(&pag->pag_ici_lock);
-		return 0;
-	}
-	__xfs_iflags_set(ip, XFS_IRECLAIM);
-	spin_unlock(&ip->i_flags_lock);
-	write_unlock(&pag->pag_ici_lock);
-
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (!xfs_iflock_nowait(ip)) {
 		if (!(sync_mode & SYNC_WAIT))
Index: source/fs/xfs/xfs_inode.h
===================================================================
--- source.orig/fs/xfs/xfs_inode.h	2010-07-26 21:10:33.000000000 +1000
+++ source/fs/xfs/xfs_inode.h	2010-07-26 21:11:59.000000000 +1000
@@ -349,6 +349,11 @@ static inline int xfs_iflock_nowait(xfs_
 	return try_wait_for_completion(&ip->i_flush);
 }
 
+static inline int xfs_iflock_free(xfs_inode_t *ip)
+{
+	return completion_done(&ip->i_flush);
+}
+
 static inline void xfs_ifunlock(xfs_inode_t *ip)
 {
 	complete(&ip->i_flush);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
