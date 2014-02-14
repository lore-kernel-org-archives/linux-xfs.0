Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DAFA57F63
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 18:24:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C61A38F8037
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 16:24:34 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qLwXCsoFVyTGozLW for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 16:24:32 -0800 (PST)
Date: Fri, 14 Feb 2014 11:24:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140214002427.GN13997@dastard>
References: <20140211210841.GM13647@dastard> <52FA9ADA.9040803@sandeen.net>
	<20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212071829.GE13997@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140212071829.GE13997@dastard>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, Feb 12, 2014 at 06:18:29PM +1100, Dave Chinner wrote:
> > It looks like just "do_signal()" has a stack frame that is about 230
> > bytes even under normal circumstancs (largely due to "struct ksignal"
> > - which in turn is largely due to the insane 128-byte padding in
> > siginfo_t). Add a few other frames in there, and I guess that if it
> > was close before, the coredump path just makes it go off.
> 
> Yup. But it's when you see this sort of thing you realise that
> almost no GFP_KERNEL memory allocation is really safe from stack
> overruns, though:
> 
>   0)     6064      64   update_group_power+0x2c/0x270
>   1)     6000     384   find_busiest_group+0x10a/0x8b0
>   2)     5616     288   load_balance+0x165/0x870
>   3)     5328      96   idle_balance+0x106/0x1b0
>   4)     5232     112   __schedule+0x7b6/0x7e0
>   5)     5120      16   schedule+0x29/0x70
>   6)     5104     176   percpu_ida_alloc+0x1b3/0x3d0
>   7)     4928      32   blk_mq_wait_for_tags+0x1f/0x40
>   8)     4896      80   blk_mq_alloc_request_pinned+0x4e/0x110
>   9)     4816     128   blk_mq_make_request+0x42b/0x510
>  10)     4688      48   generic_make_request+0xc0/0x110
>  11)     4640      96   submit_bio+0x71/0x120
>  12)     4544     192   _xfs_buf_ioapply+0x2cc/0x3b0
>  13)     4352      48   xfs_buf_iorequest+0x6f/0xc0
>  14)     4304      32   xlog_bdstrat+0x23/0x60
>  15)     4272      96   xlog_sync+0x3a4/0x5c0
>  16)     4176      48   xlog_state_release_iclog+0x121/0x130
>  17)     4128     192   xlog_write+0x700/0x7c0
>  18)     3936     192   xlog_cil_push+0x2ae/0x3d0
>  19)     3744     128   xlog_cil_force_lsn+0x1b8/0x1e0
>  20)     3616     144   _xfs_log_force_lsn+0x7c/0x300
>  21)     3472      48   xfs_log_force_lsn+0x3b/0xa0
>  22)     3424     112   xfs_iunpin_wait+0xd7/0x160
>  23)     3312      80   xfs_reclaim_inode+0xd0/0x350
>  24)     3232     432   xfs_reclaim_inodes_ag+0x277/0x3d0
>  25)     2800      48   xfs_reclaim_inodes_nr+0x33/0x40
>  26)     2752      16   xfs_fs_free_cached_objects+0x15/0x20
>  27)     2736      80   super_cache_scan+0x169/0x170
>  28)     2656     160   shrink_slab_node+0x133/0x290
>  29)     2496      80   shrink_slab+0x122/0x160
>  30)     2416     112   do_try_to_free_pages+0x1de/0x360
>  31)     2304     192   try_to_free_pages+0x110/0x190
>  32)     2112     256   __alloc_pages_nodemask+0x5a2/0x8e0
>  33)     1856      80   alloc_pages_current+0xb2/0x170
>  34)     1776      64   new_slab+0x265/0x2e0
>  35)     1712     240   __slab_alloc+0x2fb/0x4c4
>  36)     1472      80   kmem_cache_alloc+0x10b/0x140
> 
> That's almost 4700 bytes of stack usage from the
> kmem_cache_alloc(GFP_KERNEL) call because it entered the IO path.
> Yes, it's an extreme case, but if you're looking for a smoking
> gun.... :/
> 
> I can fix this one easily - we already have a workqueue for doing
> async log pushes (will split the stack between xlog_cil_force_lsn
> and xlog_cil_push), but the reason we haven't used it for synchronous
> log forces is that screws up fsync performance on CFQ. We don't
> recommend CFQ with XFS anyway, so I think I'll make this change
> anyway.

Dave, the patch below should chop off the stack usage from
xfs_log_force_lsn() issuing IO by deferring it to the CIL workqueue.
Can you given this a run?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: always do log forces via the workqueue

From: Dave Chinner <dchinner@redhat.com>

Log forces can occur deep in the call chain when we have relatively
little stack free. Log forces can also happen at close to the call
chain leaves (e.g. xfs_buf_lock()) and hence we can trigger IO from
places where we really don't want to add more stack overhead.

This stack overhead occurs because log forces do foreground CIL
pushes (xlog_cil_push_foreground()) rather than waking the
background push wq and waiting for the for the push to complete.
This foreground push was done to avoid confusing the CFQ Io
scheduler when fsync()s were issued, as it has trouble dealing with
dependent IOs being issued from different process contexts.

Avoiding blowing the stack is much more critical than performance
optimisations for CFQ, especially as we've been recommending against
the use of CFQ for XFS since 3.2 kernels were release because of
it's problems with multi-threaded IO workloads.

Hence convert xlog_cil_push_foreground() to move the push work
to the CIL workqueue. We already do the waiting for the push to
complete in xlog_cil_force_lsn(), so there's nothing else we need to
modify to make this work.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 52 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b57a8e0..7e54553 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -499,13 +499,6 @@ xlog_cil_push(
 	cil->xc_ctx = new_ctx;
 
 	/*
-	 * mirror the new sequence into the cil structure so that we can do
-	 * unlocked checks against the current sequence in log forces without
-	 * risking deferencing a freed context pointer.
-	 */
-	cil->xc_current_sequence = new_ctx->sequence;
-
-	/*
 	 * The switch is now done, so we can drop the context lock and move out
 	 * of a shared context. We can't just go straight to the commit record,
 	 * though - we need to synchronise with previous and future commits so
@@ -523,8 +516,15 @@ xlog_cil_push(
 	 * Hence we need to add this context to the committing context list so
 	 * that higher sequences will wait for us to write out a commit record
 	 * before they do.
+	 *
+	 * xfs_log_force_lsn requires us to mirror the new sequence into the cil
+	 * structure atomically with the addition of this sequence to the
+	 * committing list. This also ensures that we can do unlocked checks
+	 * against the current sequence in log forces without risking
+	 * deferencing a freed context pointer.
 	 */
 	spin_lock(&cil->xc_push_lock);
+	cil->xc_current_sequence = new_ctx->sequence;
 	list_add(&ctx->committing, &cil->xc_committing);
 	spin_unlock(&cil->xc_push_lock);
 	up_write(&cil->xc_ctx_lock);
@@ -662,8 +662,14 @@ xlog_cil_push_background(
 
 }
 
+/*
+ * xlog_cil_push_now() is used to trigger an immediate CIL push to the sequence
+ * number that is passed. When it returns, the work will be queued for
+ * @push_seq, but it won't be completed. The caller is expected to do any
+ * waiting for push_seq to complete if it is required.
+ */
 static void
-xlog_cil_push_foreground(
+xlog_cil_push_now(
 	struct xlog	*log,
 	xfs_lsn_t	push_seq)
 {
@@ -688,10 +694,8 @@ xlog_cil_push_foreground(
 	}
 
 	cil->xc_push_seq = push_seq;
+	queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
 	spin_unlock(&cil->xc_push_lock);
-
-	/* do the push now */
-	xlog_cil_push(log);
 }
 
 bool
@@ -795,7 +799,8 @@ xlog_cil_force_lsn(
 	 * xlog_cil_push() handles racing pushes for the same sequence,
 	 * so no need to deal with it here.
 	 */
-	xlog_cil_push_foreground(log, sequence);
+restart:
+	xlog_cil_push_now(log, sequence);
 
 	/*
 	 * See if we can find a previous sequence still committing.
@@ -803,7 +808,6 @@ xlog_cil_force_lsn(
 	 * before allowing the force of push_seq to go ahead. Hence block
 	 * on commits for those as well.
 	 */
-restart:
 	spin_lock(&cil->xc_push_lock);
 	list_for_each_entry(ctx, &cil->xc_committing, committing) {
 		if (ctx->sequence > sequence)
@@ -821,6 +825,28 @@ restart:
 		/* found it! */
 		commit_lsn = ctx->commit_lsn;
 	}
+
+	/*
+	 * The call to xlog_cil_push_now() executes the push in the background.
+	 * Hence by the time we have got here it our sequence may not have been
+	 * pushed yet. This is true if the current sequence still matches the
+	 * push sequence after the above wait loop and the CIL still contains
+	 * dirty objects.
+	 *
+	 * When the push occurs, it will empty the CIL and
+	 * atomically increment the currect sequence past the push sequence and
+	 * move it into the committing list. Of course, if the CIL is clean at
+	 * the time of the push, it won't have pushed the CIL at all, so in that
+	 * case we should try the push for this sequence again from the start
+	 * just in case.
+	 */
+
+	if (sequence == cil->xc_current_sequence &&
+	    !list_empty(&cil->xc_cil)) {
+		spin_unlock(&cil->xc_push_lock);
+		goto restart;
+	}
+
 	spin_unlock(&cil->xc_push_lock);
 	return commit_lsn;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
