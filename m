Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3HLK7XA107872 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 16:20:07 -0500
Date: Tue, 17 Apr 2012 16:21:55 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 03/18] xfs: Do background CIL flushes via a workqueue
Message-ID: <20120417212155.GA16881@sgi.com>
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1334319061-12968-4-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 13, 2012 at 10:10:46PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Doing background CIL flushes adds significant latency to whatever
> async transaction that triggers it. To avoid blocking async
> transactions on things like waiting for log buffer IO to complete,
> move the CIL push off into a workqueue.  By moving the push work
> into a workqueue, we remove all the latency that the commit adds
> from the foreground transaction commit path. This also means that
> single threaded workloads won't do the CIL push procssing, leaving
> them more CPU to do more async transactions.
> 
> To do this, we need to keep track of the sequence number we have
> pushed work for. This avoids having many transaction commits
> attempting to schedule work for the same sequence, and ensures that
> we only ever have one push (background or forced) in progress at a
> time. It also means that we don't need to take the CIL lock in write
> mode to check for potential background push races, which reduces
> lock contention.
> 
> To avoid potential issues with "smart" IO schedulers, don't use the
> workqueue for log force triggered flushes. Instead, do them directly
> so that the log IO is done directly by the process issuing the log
> force and so doesn't get stuck on IO elevator queue idling
> incorrectly delaying the log IO from the workqueue.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c  |  241 ++++++++++++++++++++++++++++++-------------------
>  fs/xfs/xfs_log_priv.h |    2 +
>  fs/xfs/xfs_mount.h    |    1 +
>  fs/xfs/xfs_super.c    |    7 ++
>  4 files changed, 157 insertions(+), 94 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index d4fadbe..566a2d5 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -32,58 +32,6 @@
>  #include "xfs_discard.h"
>  
>  /*
> - * Perform initial CIL structure initialisation.
> - */
> -int
> -xlog_cil_init(
> -	struct log	*log)
> -{
> -	struct xfs_cil	*cil;
> -	struct xfs_cil_ctx *ctx;
> -
> -	cil = kmem_zalloc(sizeof(*cil), KM_SLEEP|KM_MAYFAIL);
> -	if (!cil)
> -		return ENOMEM;
> -
> -	ctx = kmem_zalloc(sizeof(*ctx), KM_SLEEP|KM_MAYFAIL);
> -	if (!ctx) {
> -		kmem_free(cil);
> -		return ENOMEM;
> -	}
> -
> -	INIT_LIST_HEAD(&cil->xc_cil);
> -	INIT_LIST_HEAD(&cil->xc_committing);
> -	spin_lock_init(&cil->xc_cil_lock);
> -	init_rwsem(&cil->xc_ctx_lock);
> -	init_waitqueue_head(&cil->xc_commit_wait);
> -
> -	INIT_LIST_HEAD(&ctx->committing);
> -	INIT_LIST_HEAD(&ctx->busy_extents);
> -	ctx->sequence = 1;
> -	ctx->cil = cil;
> -	cil->xc_ctx = ctx;
> -	cil->xc_current_sequence = ctx->sequence;
> -
> -	cil->xc_log = log;
> -	log->l_cilp = cil;
> -	return 0;
> -}
> -
> -void
> -xlog_cil_destroy(
> -	struct log	*log)
> -{
> -	if (log->l_cilp->xc_ctx) {
> -		if (log->l_cilp->xc_ctx->ticket)
> -			xfs_log_ticket_put(log->l_cilp->xc_ctx->ticket);
> -		kmem_free(log->l_cilp->xc_ctx);
> -	}
> -
> -	ASSERT(list_empty(&log->l_cilp->xc_cil));
> -	kmem_free(log->l_cilp);
> -}
> -
> -/*
>   * Allocate a new ticket. Failing to get a new ticket makes it really hard to
>   * recover, so we don't allow failure here. Also, we allocate in a context that
>   * we don't want to be issuing transactions from, so we need to tell the
> @@ -426,8 +374,7 @@ xlog_cil_committed(
>   */
>  STATIC int
>  xlog_cil_push(
> -	struct log		*log,
> -	xfs_lsn_t		push_seq)
> +	struct log		*log)
>  {
>  	struct xfs_cil		*cil = log->l_cilp;
>  	struct xfs_log_vec	*lv;
> @@ -443,39 +390,35 @@ xlog_cil_push(
>  	struct xfs_log_iovec	lhdr;
>  	struct xfs_log_vec	lvhdr = { NULL };
>  	xfs_lsn_t		commit_lsn;
> +	xfs_lsn_t		push_seq;
>  
>  	if (!cil)
>  		return 0;
>  
> -	ASSERT(!push_seq || push_seq <= cil->xc_ctx->sequence);
> -
>  	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_SLEEP|KM_NOFS);
>  	new_ctx->ticket = xlog_cil_ticket_alloc(log);
>  
> -	/*
> -	 * Lock out transaction commit, but don't block for background pushes
> -	 * unless we are well over the CIL space limit. See the definition of
> -	 * XLOG_CIL_HARD_SPACE_LIMIT() for the full explanation of the logic
> -	 * used here.
> -	 */
> -	if (!down_write_trylock(&cil->xc_ctx_lock)) {
> -		if (!push_seq &&
> -		    cil->xc_ctx->space_used < XLOG_CIL_HARD_SPACE_LIMIT(log))
> -			goto out_free_ticket;
> -		down_write(&cil->xc_ctx_lock);
> -	}
> +	down_write(&cil->xc_ctx_lock);
>  	ctx = cil->xc_ctx;
>  
> -	/* check if we've anything to push */
> -	if (list_empty(&cil->xc_cil))
> -		goto out_skip;
> +	spin_lock(&cil->xc_cil_lock);
> +	push_seq = cil->xc_push_seq;
> +	ASSERT(push_seq > 0 && push_seq <= ctx->sequence);

Gah! I just hit this assert.  

v3.4-rc2-3-g8a00ebe with:
Christoph's ilock series
Christoph's xfsbufd series
Jan's freeze series
Dave's queue.

nfs7 login: [ 1175.172406] XFS: Assertion failed: push_seq > 0 && push_seq <= ctx->sequence, file: /root/xfs/fs/xfs/xfs_log_cil.c, line: 406
[ 1175.183766] ------------[ cut here ]------------
[ 1175.188010] kernel BUG at /root/xfs/fs/xfs/xfs_message.c:101!
[ 1175.188010] invalid opcode: 0000 [#1] PREEMPT SMP 
[ 1175.188010] Modules linked in: xfs(O) exportfs af_packet dm_mod floppy iTCO_wdt sg i2c_i801 iTCO_vendor_support e7xxx_edac edac_core sr_mod e100 cdrom e1000 shpchp pci_hotplug button serio_raw pcspkr autofs4 processor thermal_sys ata_generic
[ 1175.188010] 
[ 1175.188010] Pid: 2760, comm: kworker/3:2 Tainted: G           O 3.4.0-rc2-1.2-desktop+ #15 TYAN Computer Corp. S2721-533 Thunder i7501 Pro/S2721-533 Thunder i7501 Pro
[ 1175.188010] EIP: 0060:[<faa4f966>] EFLAGS: 00010296 CPU: 3
[ 1175.188010] EIP is at assfail+0x26/0x30 [xfs]
[ 1175.188010] EAX: 00000087 EBX: f1f10980 ECX: 00000079 EDX: 00000046
[ 1175.188010] ESI: f1f10780 EDI: 00000000 EBP: f1d93ec4 ESP: f1d93eb0
[ 1175.188010]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 1175.188010] CR0: 8005003b CR2: b770ee20 CR3: 2779c000 CR4: 000007f0
[ 1175.188010] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1175.188010] DR6: ffff0ff0 DR7: 00000400
[ 1175.188010] Process kworker/3:2 (pid: 2760, ti=f1d92000 task=f1e671e0 task.ti=f1d92000)
[ 1175.188010] Stack:
[ 1175.188010]  00000000 faac7a6c faad0ee4 faad0e28 00000196 f1d93f4c faaacb2c ee24c3b0
[ 1175.188010]  eee1f700 f1d93f00 c0201a8e f1f10994 f1daea00 f1f1098c 00000000 f1e67500
[ 1175.188010]  f1f10c00 00000000 00000000 00000000 00000000 00000000 00000000 c06983de
[ 1175.188010] Call Trace:
[ 1175.188010]  [<faaacb2c>] xlog_cil_push+0x2cc/0x3e0 [xfs]
[ 1175.188010]  [<c0201a8e>] ? __switch_to+0xde/0x2c0
[ 1175.188010]  [<c06983de>] ? __schedule+0x21e/0x7c0
[ 1175.188010]  [<faaacc4b>] xlog_cil_push_work+0xb/0x10 [xfs]
[ 1175.188010]  [<c024bc07>] process_one_work+0xf7/0x3f0
[ 1175.188010]  [<faaacc40>] ? xlog_cil_push+0x3e0/0x3e0 [xfs]
[ 1175.188010]  [<c024c202>] worker_thread+0x122/0x2d0
[ 1175.188010]  [<c024c0e0>] ? rescuer_thread+0x1b0/0x1b0
[ 1175.188010]  [<c024fd6d>] kthread+0x6d/0x80
[ 1175.188010]  [<c024fd00>] ? kthread_freezable_should_stop+0x50/0x50
[ 1175.188010]  [<c06a02b6>] kernel_thread_helper+0x6/0xd
[ 1175.188010] Code: bf 00 00 00 00 55 89 e5 83 ec 14 89 4c 24 10 89 54 24 0c 89 44 24 08 c7 44 24 04 6c 7a ac fa c7 04 24 00 00 00 00 e8 da fd ff ff <0f> 0b 90 8d b4 26 00 00 00 00 55 b9 01 00 00 00 89 e5 83 ec 14 
[ 1175.188010] EIP: [<faa4f966>] assfail+0x26/0x30 [xfs] SS:ESP 0068:f1d93eb0
[ 1175.189377] ---[ end trace b2f84afec1bd6d71 ]---

Unfortunately this machine isn't configured to dump.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
