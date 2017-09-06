Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45132 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752639AbdIFLLr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 07:11:47 -0400
Date: Wed, 6 Sep 2017 07:11:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: umount XFS hung when stopping the xfsaild kthread
Message-ID: <20170906111145.GA54570@bfoster.bfoster>
References: <c869cd34-269b-a13d-5009-390e70aa47ac@huawei.com>
 <20170905230043.GN17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170905230043.GN17782@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org

On Wed, Sep 06, 2017 at 09:00:43AM +1000, Dave Chinner wrote:
> On Tue, Sep 05, 2017 at 09:48:45PM +0800, Hou Tao wrote:
> > Hi all,
> > 
> > We recently encounter a XFS umount hang problem. As we can see the following
> > stacks, the umount process was trying to stop the xfsaild kthread and waiting
> > for the exit of the xfsaild thread, and the xfsaild thread was waiting for
> > wake-up.
> > 
> > [<ffffffff810a604a>] kthread_stop+0x4a/0xe0
> > [<ffffffffa0680317>] xfs_trans_ail_destroy+0x17/0x30 [xfs]
> > [<ffffffffa067569e>] xfs_log_unmount+0x1e/0x60 [xfs]
> > [<ffffffffa066ac15>] xfs_unmountfs+0xd5/0x190 [xfs]
> > [<ffffffffa066da62>] xfs_fs_put_super+0x32/0x90 [xfs]
> > [<ffffffff811ebad6>] generic_shutdown_super+0x56/0xe0
> > [<ffffffff811ebf27>] kill_block_super+0x27/0x70
> > [<ffffffff811ec269>] deactivate_locked_super+0x49/0x60
> > [<ffffffff811ec866>] deactivate_super+0x46/0x60
> > [<ffffffff81209995>] mntput_no_expire+0xc5/0x120
> > [<ffffffff8120aacf>] SyS_umount+0x9f/0x3c0
> > [<ffffffff81652a09>] system_call_fastpath+0x16/0x1b
> > [<ffffffffffffffff>] 0xffffffffffffffff
> > 
> > [<ffffffffa067faa7>] xfsaild+0x537/0x5e0 [xfs]
> > [<ffffffff810a5ddf>] kthread+0xcf/0xe0
> > [<ffffffff81652958>] ret_from_fork+0x58/0x90
> > [<ffffffffffffffff>] 0xffffffffffffffff
> > 
> > The kernel version is RHEL7.3 and we are trying to reproduce it (not yet).
> > I have check the related code and suspect the same problem may also exists in
> > the mainline.
> > 
> > The following is the possible sequences which may lead to the hang of umount:
> > 
> > xfsaild: kthread_should_stop() // return false, so xfsaild continue
> > 
> > umount: set_bit(KTHREAD_SHOULD_STOP, &kthread->flags) // by kthread_stop()
> > 
> > umount: wake_up_process() // because xfsaild is still running, so 0 is returned
>                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> This, to me, is where the problem lies. By the time unmount is
> asking the aild to stop, the xfsaild should already be idle and
> scheduled because unmount has just completed a syncrhonous push of
> the AIL. i.e.  xfs_ail_push_all_sync()) waits for the AIL to empty
> which should result in the aild returning to the idle state and
> sleeping in freezable_schedule().
> 

I think this behavior is to be expected. The xfsaild() logic schedules
itself out without a timeout when the AIL is empty, but the task may not
see the AIL as empty immediately because the empty state doesn't occur
until I/O completion of the associated buffers removes all of the log
items from the AIL. Therefore, I think it's probably normal for xfsaild
to spin around a bit until that empty state occurs. This is probably
what allows kthread_stop() to race at unmount time.

> Work out why the aild is still running after the log has supposedly
> been emptied and unmount records have been written first, then look
> for a solution. Also, as Brian suggested, reproducing on an upstream
> kernel is a good idea, because it's entirely possible this is a
> vendor kernel (i.e.  RHEL) specific bug....
> 

FWIW, I ran a quick test on for-next since there hasn't been a reply to
this thread in that regard. Add a 10s delay between
kthread_should_stop() and __set_current_state() in xfsaild (when
unmounting and AIL is empty) and a 5s delay before kthread_stop() in
xfs_trans_ail_destroy() and the problem reproduces consistently.

Checking kthread_should_stop() after we set the task state addresses the
problem. This is because of the order of operations between
kthread_stop() and xfsaild(). The former sets the stop bit and wakes the
task. If the latter sets the task state and then checks the stop bit (as
opposed to doing the opposite as it does currently), it will either see
the stop bit and exit or the task state is reset to runnable such that
it isn't blocked indefinitely (and the next iteration detects the stop
bit).

Hou,

Care to update your patch with this information and the previous
suggestions from Dave and I (pull up the check, add a comment, and make
sure to reset the task state)?

Brian

> > xfsaild: __set_current_state()
> > xfsaild: schedule() // Now, on one will wake it up
> > 
> > The solution I think is adding an extra kthread_should_stop() before
> > invoking schedule(). Maybe a smp_mb() is needed too, because we needs to
> > ensure the read of the stop flag happens after the write of the task status.
> > Something likes the following patch:
> > 
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index 9056c0f..6313f67 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -520,6 +520,11 @@ xfsaild(
> >                 if (!xfs_ail_min(ailp) &&
> >                     ailp->xa_target == ailp->xa_target_prev) {
> >                         spin_unlock(&ailp->xa_lock);
> > +
> > +                       smp_mb();
> > +                       if (kthread_should_stop())
> > +                               break;
> > +
> >                         freezable_schedule();
> >                         tout = 0;
> >                         continue;
> 
> This is still racy.  i.e. What happens if the stop bit is set
> between the new kthread_should_stop() check and
> freezable_schedule()? It'll still hang, right?
> 
> Also, breaking out of the loop there leaves the task in
> TASK_INTERRUPTIBLE/TASK_KILLABLE state - it needs to leave this
> function in TASK_RUNNING state.
> 
> FWIW, it is my understanding that the sort of schedule vs ttwu race
> you are implying exists here are avoided by the task state being set
> to TASK_INTERRUPTIBLE/TASK_KILLABLE and schedule only parking the
> task if the task was in this state. i.e. if ttwu is called before
> schedule, then the task state will have been modified to either
> TASK_WAKING or TASK_RUNNING before schedule is called and so
> schedule() is then effectively a no-op.  In that case, we go around
> the loop again, hit the kthread_should_stop() check, and we stop.
> Hence, if I've remembered this all correctly, I don't think adding
> this extra kthread_should_stop() check will make any difference,
> either.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
