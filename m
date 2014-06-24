Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AB8977F51
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 22:03:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 958C1304032
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 20:03:32 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	kBz1RNsfhrBdP41s for <xfs@oss.sgi.com>;
	Mon, 23 Jun 2014 20:03:27 -0700 (PDT)
Date: Tue, 24 Jun 2014 13:02:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: On-stack work item completion race? (was Re: XFS crash?)
Message-ID: <20140624030240.GB9508@dastard>
References: <20140305233551.GK6851@dastard>
	<CANGgnMb=2dYGQO4K36pQ9LEb8E4rT6S_VskLF+n=ndd0_kJr_g@mail.gmail.com>
	<CANGgnMa80WwQ8zSkL52yYegmQURVQeZiBFv41=FQXMZJ_NaEDw@mail.gmail.com>
	<20140513034647.GA5421@dastard>
	<CANGgnMZ0q9uE3NHj2i0SBK1d0vdKLx7QBJeFNb+YwP-5EAmejQ@mail.gmail.com>
	<20140513063943.GQ26353@dastard>
	<CANGgnMYn++1++UyX+D2d9GxPxtytpQJv0ThFwdxM-yX7xDWqiA@mail.gmail.com>
	<20140513090321.GR26353@dastard>
	<CANGgnMZqQc_NeaDpO_aX+bndmHrQ9VWo9mkfxhPBkRD-J=N6sQ@mail.gmail.com>
	<CANGgnMZ8OwzfBj5m9H7c6q2yahGhU7oFZLsJfVxnWoqZExkZmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANGgnMZ8OwzfBj5m9H7c6q2yahGhU7oFZLsJfVxnWoqZExkZmQ@mail.gmail.com>
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
To: Austin Schuh <austin@peloton-tech.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, xfs <xfs@oss.sgi.com>

[Adding Tejun and lkml to the cc list]

On Mon, Jun 23, 2014 at 01:05:54PM -0700, Austin Schuh wrote:
> I found 1 bug in XFS which I fixed, and I've uncovered something else that
> I'm not completely sure how to fix.
> 
> In xfs_bmapi_allocate, you create a completion, and use that to wait until
> the work has finished.  Occasionally, I'm seeing a case where I get a
> context switch after the completion has been completed, but before the
> workqueue has finished doing it's internal book-keeping.  This results in
> the work being deleted before the workqueue is done using it, corrupting
> the internal data structures.  I fixed it by waiting using flush_work and
> removing the completion entirely.
> 
> --- a/fs/xfs/xfs_bmap_util.c        2014-06-23 12:59:10.008678410 -0700
> +++ b/fs/xfs/xfs_bmap_util.c      2014-06-23 12:59:14.116678239 -0700
> @@ -263,7 +263,6 @@
>         current_set_flags_nested(&pflags, PF_FSTRANS);
> 
>         args->result = __xfs_bmapi_allocate(args);
> -       complete(args->done);
> 
>         current_restore_flags_nested(&pflags, PF_FSTRANS);
>  }
> @@ -277,16 +276,13 @@
>  xfs_bmapi_allocate(
>         struct xfs_bmalloca     *args)
>  {
> -       DECLARE_COMPLETION_ONSTACK(done);
> -
>         if (!args->stack_switch)
>                 return __xfs_bmapi_allocate(args);
> 
> 
> -       args->done = &done;
>         INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
>         queue_work(xfs_alloc_wq, &args->work);
> -       wait_for_completion(&done);
> +       flush_work(&args->work);
>         destroy_work_on_stack(&args->work);
>         return args->result;
>  }
> --- a/fs/xfs/xfs_bmap_util.h        2014-06-23 12:59:10.008678410 -0700
> +++ b/fs/xfs/xfs_bmap_util.h      2014-06-23 12:59:11.708678340 -0700
> @@ -57,7 +57,6 @@
>         char                    conv;   /* overwriting unwritten extents */
>         char                    stack_switch;
>         int                     flags;
> -       struct completion       *done;
>         struct work_struct      work;
>         int                     result;
>  };

Ok, that's a surprise. However, I can't see how using flush_work()
solves that underlying context switch problem, because it's
implemented the same way:

bool flush_work(struct work_struct *work)
{
        struct wq_barrier barr;

        lock_map_acquire(&work->lockdep_map);
        lock_map_release(&work->lockdep_map);

        if (start_flush_work(work, &barr)) {
                wait_for_completion(&barr.done);
                destroy_work_on_stack(&barr.work);
                return true;
        } else {
                return false;
        }
}

start_flush_work() is effectively a special queue_work()
implementation, so if if it's not safe to call complete() from the
workqueue as the above patch implies then this code has the same
problem.

Tejun - is this "do it yourself completion" a known issue w.r.t.
workqueues? I can't find any documentation that says "don't do
that" so...?

A quick grep also shows up the same queue_work/wait_for_completion
pattern in arch/x86/kernel/hpet.c, drivers/md/dm-thin.c,
fs/fs-writeback.c, drivers/block/drbd/drbd_main.c....

> I enabled event tracing (and added a new event which lists the number of
> workers running in a queue whenever that is changed).
> 
> To me, it looks like work is scheduled from irq/44-ahci-273 that will
> acquire an inode lock.  scp-3986 then acquires the lock, and then goes and
> schedules work.  That work is then scheduled behind the work from
> irq/44-ahci-273 in the same pool.  The first work blocks waiting on the
> lock, and scp-3986 won't finish and release that lock until the second work
> gets run.

IOWs, scp takes an inode lock and queues work to the xfs_alloc_wq,
then schedules. Then a kworker runs an xfs-data work item, which
tries to take the inode lock and blocks.

As I understand it, what then happens is that the workqueue code
grabs another kworker thread and runs the next work item in it's
queue. IOWs, work items can block, but doing that does not prevent
execution of other work items queued on other work queues or even on
the same work queue. Tejun, did I get that correct?

Hence the work on the xfs-data queue will block until another
kworker processes the item on the xfs-alloc-wq which means progress
is made and the inode gets unlocked. Then the kworker for the work
on the xfs-data queue will get the lock, complete it's work and
everything has resolved itself.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
