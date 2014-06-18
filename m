Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C01D7F3F
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 03:55:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0BE7DAC003
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 01:55:47 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	bQ4c9hfltlMZm4gm for <xfs@oss.sgi.com>;
	Wed, 18 Jun 2014 01:55:44 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WxBef-0006wB-Jc
	for xfs@oss.sgi.com; Wed, 18 Jun 2014 18:55:41 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1WxBef-0001Ck-IP
	for xfs@oss.sgi.com; Wed, 18 Jun 2014 18:55:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: refine the allocation stack switch
Date: Wed, 18 Jun 2014 18:55:41 +1000
Message-Id: <1403081741-4596-1-git-send-email-david@fromorbit.com>
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

The allocation stack switch at xfs_bmapi_allocate() has served it's
purpose, but is no longer a sufficient solution to the stack usage
problem we have in the XFS allocation path.

Whilst the kernel stack size is now 16k, that is not a valid reason
for undoing all our "keep stack usage down" modifications. What it
does allow us to do is have the freedom to refine and perfect the
modifications knowing that if we get it wrong it won't blow up in
our faces - we have a safety net now.

This is important because we still have the issue of older kernels
having smaller stacks and that they are still supported and are
demonstrating a wide range of different stack overflows.  Red Hat
has several open bugs for allocation based stack overflows from
directory modifications and direct IO block allocation and these
problems still need to be solved. If we can solve them upstream,
then distro's won't need to bake their own unique solutions.

To that end, I've observed that every allocation based stack
overflow report has had a specific characteristic - it has happened
during or directly after a bmap btree block split. That event
requires a new block to be allocated to the tree, and so we
effectively stack one allocation stack on top of another, and that's
when we get into trouble.

A further observation is that bmap btree block splits are much rarer
than writeback allocation - over a range of different workloads I've
observed the ratio of bmap btree inserts to splits ranges from 100:1
(xfstests run) to 10000:1 (local VM image server with sparse files
that range in the hundreds of thousands to millions of extents).
Either way, bmap btree split events are much, much rarer than
allocation events.

Finally, we have to move the kswapd state tothe allocation workqueue
work when allocation is done on behalf of kswapd. This is proving to
cause significant perturbation in performance under memory pressure
and appears to be generating allocation deadlock warnings under some
workloads, so avoiding the use of a workqueue for the majority of
kswapd writeback allocation will minimise the impact of such
behaviour.

Hence it makes sense to move the stack switch to xfs_btree_split()
and only do it for bmap btree splits. Stack switches during
allocation will be much rarer, so there won't be significant
performacne overhead caused by switching stacks. The worse case
stack from all allocation paths will be split, not just writeback.
And the majority of memory allocations will be done in the correct
context (e.g. kswapd) without causing additional latency, and so we
simplify the memory reclaim interactions between processes,
workqueues and kswapd.

The worst stack I've been able to generate with this patch in place
is 5600 bytes deep. It's very revealing because we exit XFS at:

37)     1768      64   kmem_cache_alloc+0x13b/0x170

about 1800 bytes of stack consumed, and the remaining 3800 bytes
(and 36 functions) is memory reclaim, swap and the IO stack. And
this occurs in the inode allocation from an open(O_CREAT) syscall,
not writeback.

The amount of stack being used is much less than I've previously be
able to generate - fs_mark testing has been able to generate stack
usage of around 7k without too much trouble; with this patch it's
only just getting to 5.5k. This is primarily because the metadata
allocation paths (e.g. directory blocks) are no longer causing
double splits on the same stack, and hence now stack tracing is
showing swapping being the worst stack consumer rather than XFS.

Performance of fs_mark inode create workloads is unchanged.
Performance of fs_mark async fsync workloads is consistently good
with context switches reduced by around 150,000/s (30%).
Performance of dbench, streaming IO and postmark is unchanged.
Allocation deadlock warnings have not been seen on the workloads
that generated them since adding this patch.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c  |  4 +--
 fs/xfs/libxfs/xfs_btree.c | 84 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_bmap_util.c    | 53 ------------------------------
 fs/xfs/xfs_bmap_util.h    |  2 --
 4 files changed, 84 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 72a110e..d40cef0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4298,8 +4298,8 @@ xfs_bmapi_delay(
 }
 
 
-int
-__xfs_bmapi_allocate(
+static int
+xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
 {
 	struct xfs_mount	*mp = bma->ip->i_mount;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 0097c42..9de1153 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -33,6 +33,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
+#include "xfs_alloc.h"
 
 /*
  * Cursor allocation zone.
@@ -2322,8 +2323,8 @@ error1:
  * Return new block number and the key to its first
  * record (to be inserted into parent).
  */
-STATIC int					/* error */
-xfs_btree_split(
+int					/* error */
+__xfs_btree_split(
 	struct xfs_btree_cur	*cur,
 	int			level,
 	union xfs_btree_ptr	*ptrp,
@@ -2503,6 +2504,85 @@ error0:
 	return error;
 }
 
+struct xfs_btree_split_args {
+	struct xfs_btree_cur	*cur;
+	int			level;
+	union xfs_btree_ptr	*ptrp;
+	union xfs_btree_key	*key;
+	struct xfs_btree_cur	**curp;
+	int			*stat;		/* success/failure */
+	int			result;
+	bool			kswapd;	/* allocation in kswapd context */
+	struct completion	*done;
+	struct work_struct	work;
+};
+
+/*
+ * Stack switching interfaces for allocation
+ */
+static void
+xfs_btree_split_worker(
+	struct work_struct	*work)
+{
+	struct xfs_btree_split_args	*args = container_of(work,
+						struct xfs_btree_split_args, work);
+	unsigned long		pflags;
+	unsigned long		new_pflags = PF_FSTRANS;
+
+	/*
+	 * we are in a transaction context here, but may also be doing work
+	 * in kswapd context, and hence we may need to inherit that state
+	 * temporarily to ensure that we don't block waiting for memory reclaim
+	 * in any way.
+	 */
+	if (args->kswapd)
+		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
+
+	current_set_flags_nested(&pflags, new_pflags);
+
+	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
+					 args->key, args->curp, args->stat);
+	complete(args->done);
+
+	current_restore_flags_nested(&pflags, new_pflags);
+}
+
+/*
+ * BMBT split requests often come in with little stack to work on. Push
+ * them off to a worker thread so there is lots of stack to use. For the other
+ * btree types, just call directly to avoid the context switch overhead here.
+ */
+STATIC int					/* error */
+xfs_btree_split(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	union xfs_btree_ptr	*ptrp,
+	union xfs_btree_key	*key,
+	struct xfs_btree_cur	**curp,
+	int			*stat)		/* success/failure */
+{
+	struct xfs_btree_split_args	args;
+	DECLARE_COMPLETION_ONSTACK(done);
+
+	if (cur->bc_btnum != XFS_BTNUM_BMAP)
+		return __xfs_btree_split(cur, level, ptrp, key, curp, stat);
+
+	args.cur = cur;
+	args.level = level;
+	args.ptrp = ptrp;
+	args.key = key;
+	args.curp = curp;
+	args.stat = stat;
+	args.done = &done;
+	args.kswapd = current_is_kswapd();
+	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
+	queue_work(xfs_alloc_wq, &args.work);
+	wait_for_completion(&done);
+	destroy_work_on_stack(&args.work);
+	return args.result;
+}
+
+
 /*
  * Copy the old inode root contents into a real block and make the
  * broot point to it.
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 56f050e..43a9744 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -249,59 +249,6 @@ xfs_bmap_rtalloc(
 }
 
 /*
- * Stack switching interfaces for allocation
- */
-static void
-xfs_bmapi_allocate_worker(
-	struct work_struct	*work)
-{
-	struct xfs_bmalloca	*args = container_of(work,
-						struct xfs_bmalloca, work);
-	unsigned long		pflags;
-	unsigned long		new_pflags = PF_FSTRANS;
-
-	/*
-	 * we are in a transaction context here, but may also be doing work
-	 * in kswapd context, and hence we may need to inherit that state
-	 * temporarily to ensure that we don't block waiting for memory reclaim
-	 * in any way.
-	 */
-	if (args->kswapd)
-		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
-
-	current_set_flags_nested(&pflags, new_pflags);
-
-	args->result = __xfs_bmapi_allocate(args);
-	complete(args->done);
-
-	current_restore_flags_nested(&pflags, new_pflags);
-}
-
-/*
- * Some allocation requests often come in with little stack to work on. Push
- * them off to a worker thread so there is lots of stack to use. Otherwise just
- * call directly to avoid the context switch overhead here.
- */
-int
-xfs_bmapi_allocate(
-	struct xfs_bmalloca	*args)
-{
-	DECLARE_COMPLETION_ONSTACK(done);
-
-	if (!args->stack_switch)
-		return __xfs_bmapi_allocate(args);
-
-
-	args->done = &done;
-	args->kswapd = current_is_kswapd();
-	INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
-	queue_work(xfs_alloc_wq, &args->work);
-	wait_for_completion(&done);
-	destroy_work_on_stack(&args->work);
-	return args->result;
-}
-
-/*
  * Check if the endoff is outside the last extent. If so the caller will grow
  * the allocation to a stripe unit boundary.  All offsets are considered outside
  * the end of file for an empty fork, so 1 is returned in *eof in that case.
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 075f722..5f8abb9 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -66,8 +66,6 @@ struct xfs_bmalloca {
 int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
 			int *committed);
 int	xfs_bmap_rtalloc(struct xfs_bmalloca *ap);
-int	xfs_bmapi_allocate(struct xfs_bmalloca *args);
-int	__xfs_bmapi_allocate(struct xfs_bmalloca *args);
 int	xfs_bmap_eof(struct xfs_inode *ip, xfs_fileoff_t endoff,
 		     int whichfork, int *eof);
 int	xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
