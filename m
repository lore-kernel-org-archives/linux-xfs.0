Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3A7C9W0058972 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 02:12:10 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7CyuG45YiB3iqScA for <xfs@oss.sgi.com>;
	Tue, 10 Apr 2012 00:12:07 -0700 (PDT)
Date: Tue, 10 Apr 2012 17:12:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] set freed perag structures to NULL to avoid mount
	failure oops
Message-ID: <20120410071204.GO18323@dastard>
References: <4F7DF263.6060802@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F7DF263.6060802@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Apr 05, 2012 at 12:28:35PM -0700, Eric Sandeen wrote:
> We encountered a bug after log replay failed on mount:
> 
> [14217.617258] XFS (md5): log mount/recovery failed: error 5
> [14217.624037] XFS (md5): log mount failed
> [14234.866732] general protection fault: 0000 [#1] SMP 
> ...
> [14234.913286] RIP: 0010:[<ffffffff810c2cbe>]  [<ffffffff810c2cbe>]
> __lock_acquire+0x2be/0xa20
> [14234.913293] RSP: 0018:ffff880116c6fa38  EFLAGS: 00010002
> [14234.913294] RAX: 6b6b6b6b6b6b6b6b RBX: 0000000000000000 RCX: 0000000000000000
> [14234.913321] Call Trace:
> [14234.913335]  [<ffffffff810c3aad>] lock_acquire+0x9d/0x1f0
> [14234.913365]  [<ffffffff8162f646>] _raw_spin_lock+0x46/0x80
> [14234.913372]  [<ffffffff8130e60d>] _atomic_dec_and_lock+0x4d/0x70
> [14234.913382]  [<ffffffffa0392801>] xfs_buf_rele+0x51/0x1e0 [xfs]
> [14234.913400]  [<ffffffffa039554f>] xfs_flush_buftarg+0x10f/0x130 [xfs]
> [14234.913410]  [<ffffffffa03955a4>] xfs_free_buftarg+0x34/0x70 [xfs]
> [14234.913422]  [<ffffffffa03a4634>] xfs_close_devices+0x64/0x70 [xfs]
> [14234.913433]  [<ffffffffa03a5890>] xfs_fs_fill_super+0x180/0x2a0 [xfs]
> [14234.913436]  [<ffffffff811b7a71>] mount_bdev+0x1d1/0x220
> [14234.913460]  [<ffffffffa03a3ad5>] xfs_fs_mount+0x15/0x20 [xfs]
> [14234.913462]  [<ffffffff811b8603>] mount_fs+0x43/0x1b0
> [14234.913468]  [<ffffffff811d473a>] vfs_kern_mount+0x6a/0xd0
> [14234.913471]  [<ffffffff811d6124>] do_kern_mount+0x54/0x110
> [14234.913473]  [<ffffffff811d7c34>] do_mount+0x1a4/0x260
> [14234.913476]  [<ffffffff811d8100>] sys_mount+0x90/0xe0
> [14234.913478]  [<ffffffff81639202>] system_call_fastpath+0x16/0x1b
> 
> 
> RAX is freed memory.
> 
> After xfs_mountfs() fails to replay the log, it
> goes to out_perag_free: which does xfs_free_perag().
> 
> Later down the mount failure path, xfs_buf_rele() checks for (!pag):
> 
>         if (!pag) {
>                 ASSERT(list_empty(&bp->b_lru));
>                 ASSERT(RB_EMPTY_NODE(&bp->b_rbnode));
>                 if (atomic_dec_and_test(&bp->b_hold))
>                         xfs_buf_free(bp);
>                 return;
>         }
> 
> but we did not set the perag to NULL, so this doesn't get hit.

Sure, bp->b_pag is only set for cached buffers, but it also has a
reference to the perag structure so it is supposed to be guaranteed
that the perag structure is valid until the buffer is freed and the
perag reference is dropped.

> Next we do:
> 
>         if (atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock)) {
> 
> which goes bang if the perag has been freed.

Which means that the unmount has failed to flush all the active
buffers. This woul dhave resulted in an ASSERT() firing in
xfs_free_perag() on a debug kernel....

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Full disclosure: not yet tested, will do soon :)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 1ffead4..ad830f7 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -252,6 +252,7 @@ __xfs_free_perag(
>  
>  	ASSERT(atomic_read(&pag->pag_ref) == 0);

.... right here, or even even before call_rcu() was called

>  	kmem_free(pag);
> +	pag = NULL;
>  }

As it is, I don't quite understand what setting a local variable to
NULL is supposed to acheive here - the perag structure has been
removed from the radix tree and zeroing a local variable doesn't do
anything globally visible...

What is more likely is that the log mount failure path is not
flushing the buftarg correctly before tearing down the perag
structures. Indeed, a log mount failure (and a perag data
intialisation failure) will simply tear down the perag structures
without waiting for cached buffers to be flushed in xfs_mountfs(),
so that is going to the root cause of this problem. i.e. we need
xfs_flush_buftarg() calls in the mountfs error handling path....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
