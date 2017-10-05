Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:12850 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751083AbdJEXjP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2017 19:39:15 -0400
Date: Fri, 6 Oct 2017 10:36:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Circular locking dependency with pblk
Message-ID: <20171005233609.GP3666@dastard>
References: <84EF6A42-AE7A-40B5-AB00-5E4A1617C41E@lightnvm.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84EF6A42-AE7A-40B5-AB00-5E4A1617C41E@lightnvm.io>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Javier =?iso-8859-1?Q?Gonz=E1lez?= <jg@lightnvm.io>
Cc: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, darrick.wong@oracle.com, Christoph Hellwig <hch@infradead.org>, Peter Zijlstra <peterz@infradead.org>

On Thu, Oct 05, 2017 at 12:53:50PM +0200, Javier González wrote:
> Hi,
> 
> lockdep is reporting a circular dependency when using XFS and pblk,
> which I am a bit confused about.
> 
> This happens when XFS sends a number of nested reads and (at least) one
> of them hits partially pblk's cache. In this case, pblk will retrieve
> the cached lbas and form a new bio, which is submitted _synchronously_
> to the media using struct completion. The original bio is then populated
> with the read data.
> 
> What lockdep complains about, is that the unlocking operation in
> complete() has a circular dependency with ionode->i_rwsem when they both
> happen on the same core, which is different from the core that issued
> wait_for_completion_io_timeout() and is waiting for the partial read.
> However, AFAIU complete() happens in interrupt context, so this should
> not be a problem.
> 
> The only thing I can think of is that XFS is making an assumption when
> submitting direct I/O that there will be no synchronous I/O coming from
> anybody underneath.
> 
> Any thoughts?

The new lockdep completion tracking that was included in 4.14 can
throw false positives because it doesn't (yet) have the capability
to understand the multiply layered completion contexts we have in
the storage stack.

Peter, here's another for you to ponder....

> TRACE:
> [ 8557.938336] ======================================================
> [ 8557.944513] WARNING: possible circular locking dependency detected
> [ 8557.950688] 4.14.0-rc2--509811f1f2df #726 Not tainted
> [ 8557.955739] ------------------------------------------------------
> [ 8557.961919] rocksdb:bg11/19129 is trying to acquire lock:
> [ 8557.967319]  (&inode->i_rwsem){++++}, at: [<ffffffffad5648d1>] xfs_ilock+0x1a1/0x230
> [ 8557.975063]
>                but now in release context of a crosslock acquired at the following:
> [ 8557.983921]  ((complete)&wait#5){+.+.}, at: [<ffffffffad933d0a>] pblk_fill_partial_read_bio+0x22a/0x520
> [ 8557.993318]
>                which lock already depends on the new lock.
> 
> [ 8558.001490]
>                the existing dependency chain (in reverse order) is:
> [ 8558.008966]
>                -> #1 ((complete)&wait#5){+.+.}:
> [ 8558.014715]        __lock_acquire+0x1186/0x11d0
> [ 8558.019245]        lock_acquire+0xed/0x1e0
> [ 8558.023337]        wait_for_completion_io_timeout+0x65/0x180
> [ 8558.028989]        pblk_fill_partial_read_bio+0x22a/0x520
> [ 8558.034375]        pblk_submit_read+0x158/0x3a0
> [ 8558.038900]        pblk_make_rq+0xc1/0x110
> [ 8558.042992]        generic_make_request+0x11d/0x3c0
> [ 8558.047862]        submit_bio+0x73/0x140
> [ 8558.051781]        iomap_dio_actor+0x1f8/0x3a0
> [ 8558.056216]        iomap_apply+0xa1/0x110
> [ 8558.060220]        iomap_dio_rw+0x26f/0x3c0
> [ 8558.064398]        xfs_file_dio_aio_read+0x88/0x1c0
> [ 8558.069269]        xfs_file_read_iter+0xab/0xc0
> [ 8558.073794]        __vfs_read+0xef/0x160
> [ 8558.077709]        vfs_read+0xa8/0x150
> [ 8558.081454]        SyS_pread64+0x98/0xc0
> [ 8558.085372]        entry_SYSCALL_64_fastpath+0x23/0xc2

This is completely normal, blocked on a bio completion with a
filesystem lock held. More commonly we see this sort of thing
through through submit_bio_wait().

> [ 8558.125636]  Possible unsafe locking scenario by crosslock:
> 
> [ 8558.132672]        CPU0                    CPU1
> [ 8558.137196]        ----                    ----
> [ 8558.141720]   lock(&inode->i_rwsem);
> [ 8558.145291]   lock((complete)&wait#5);
> [ 8558.149035]                                lock(&inode->i_rwsem);
> [ 8558.155118]                                unlock((complete)&wait#5);
> [ 8558.161550]
>                 *** DEADLOCK ***
> 
> [ 8558.167461] 4 locks held by rocksdb:bg11/19129:
> [ 8558.171984]  #0:  (&inode->i_rwsem){++++}, at: [<ffffffffad5648d1>] xfs_ilock+0x1a1/0x230
> [ 8558.180148]  #1:  (rcu_read_lock){....}, at: [<ffffffffad72b8cc>] __blk_mq_run_hw_queue+0xec/0x1d0
> [ 8558.189091]  #2:  (&(&nvmeq->q_lock)->rlock){-.-.}, at: [<ffffffffad9d438c>] nvme_queue_rq+0x14c/0x9a0
> [ 8558.198384]  #3:  (&x->wait#17){-.-.}, at: [<ffffffffad16444d>] complete+0x1d/0x60
> [ 8558.205948]
>                stack backtrace:
> [ 8558.210300] CPU: 6 PID: 19129 Comm: rocksdb:bg11 Not tainted 4.14.0-rc2--509811f1f2df #726
> [ 8558.218550] Hardware name: Supermicro X10SRA-F/X10SRA-F, BIOS 2.0a 06/23/2016
> [ 8558.225675] Call Trace:
> [ 8558.228123]  dump_stack+0x85/0xc7
> [ 8558.231438]  print_circular_bug+0x226/0x330
> [ 8558.235616]  ? print_bfs_bug+0x40/0x40
> [ 8558.239358]  check_prev_add+0x432/0x840
> [ 8558.243190]  ? __lock_acquire+0x736/0x11d0
> [ 8558.247282]  lock_commit_crosslock+0x3d3/0x5d0
> [ 8558.251718]  ? lock_commit_crosslock+0x3d3/0x5d0
> [ 8558.256328]  complete+0x29/0x60
> [ 8558.259469]  pblk_end_io_sync+0x12/0x20
> [ 8558.263297]  nvm_end_io+0x2b/0x30
> [ 8558.266607]  nvme_nvm_end_io+0x2e/0x50

And this is where lockdep gets confused. Up until this point, it's
only ever seen the bio completion come from /outside/ the XFS
i_rwsem context (i.e. async completion form interupts). With a
synchronous completion like this, the completion has now been done
from inside the i_rwsem context and that is what triggers lockdep.

This is safe to do because even if we have a bio blocked on a
completion queue, we've got all we way down to this complete() call
from a *different bio context* inside a read locked i_rwsem. Hence
there's no way this can be a deadlock even if the two processes are
holding the same i_rwsem.

Therefore: false positive.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
