Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41450 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752943AbdIFMSR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 08:18:17 -0400
Date: Wed, 6 Sep 2017 08:18:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: umount XFS hung when stopping the xfsaild kthread
Message-ID: <20170906121815.GD54570@bfoster.bfoster>
References: <c869cd34-269b-a13d-5009-390e70aa47ac@huawei.com>
 <20170905230043.GN17782@dastard>
 <20170906111145.GA54570@bfoster.bfoster>
 <20170906114742.GT17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906114742.GT17782@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org

On Wed, Sep 06, 2017 at 09:47:42PM +1000, Dave Chinner wrote:
> On Wed, Sep 06, 2017 at 07:11:45AM -0400, Brian Foster wrote:
> > On Wed, Sep 06, 2017 at 09:00:43AM +1000, Dave Chinner wrote:
> > > On Tue, Sep 05, 2017 at 09:48:45PM +0800, Hou Tao wrote:
> > > > Hi all,
> > > > 
> > > > We recently encounter a XFS umount hang problem. As we can see the following
> > > > stacks, the umount process was trying to stop the xfsaild kthread and waiting
> > > > for the exit of the xfsaild thread, and the xfsaild thread was waiting for
> > > > wake-up.
> > > > 
> > > > [<ffffffff810a604a>] kthread_stop+0x4a/0xe0
> > > > [<ffffffffa0680317>] xfs_trans_ail_destroy+0x17/0x30 [xfs]
> > > > [<ffffffffa067569e>] xfs_log_unmount+0x1e/0x60 [xfs]
> > > > [<ffffffffa066ac15>] xfs_unmountfs+0xd5/0x190 [xfs]
> > > > [<ffffffffa066da62>] xfs_fs_put_super+0x32/0x90 [xfs]
> > > > [<ffffffff811ebad6>] generic_shutdown_super+0x56/0xe0
> > > > [<ffffffff811ebf27>] kill_block_super+0x27/0x70
> > > > [<ffffffff811ec269>] deactivate_locked_super+0x49/0x60
> > > > [<ffffffff811ec866>] deactivate_super+0x46/0x60
> > > > [<ffffffff81209995>] mntput_no_expire+0xc5/0x120
> > > > [<ffffffff8120aacf>] SyS_umount+0x9f/0x3c0
> > > > [<ffffffff81652a09>] system_call_fastpath+0x16/0x1b
> > > > [<ffffffffffffffff>] 0xffffffffffffffff
> > > > 
> > > > [<ffffffffa067faa7>] xfsaild+0x537/0x5e0 [xfs]
> > > > [<ffffffff810a5ddf>] kthread+0xcf/0xe0
> > > > [<ffffffff81652958>] ret_from_fork+0x58/0x90
> > > > [<ffffffffffffffff>] 0xffffffffffffffff
> > > > 
> > > > The kernel version is RHEL7.3 and we are trying to reproduce it (not yet).
> > > > I have check the related code and suspect the same problem may also exists in
> > > > the mainline.
> > > > 
> > > > The following is the possible sequences which may lead to the hang of umount:
> > > > 
> > > > xfsaild: kthread_should_stop() // return false, so xfsaild continue
> > > > 
> > > > umount: set_bit(KTHREAD_SHOULD_STOP, &kthread->flags) // by kthread_stop()
> > > > 
> > > > umount: wake_up_process() // because xfsaild is still running, so 0 is returned
> > >                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > 
> > > This, to me, is where the problem lies. By the time unmount is
> > > asking the aild to stop, the xfsaild should already be idle and
> > > scheduled because unmount has just completed a syncrhonous push of
> > > the AIL. i.e.  xfs_ail_push_all_sync()) waits for the AIL to empty
> > > which should result in the aild returning to the idle state and
> > > sleeping in freezable_schedule().
> > > 
> > 
> > I think this behavior is to be expected. The xfsaild() logic schedules
> > itself out without a timeout when the AIL is empty, but the task may not
> > see the AIL as empty immediately because the empty state doesn't occur
> > until I/O completion of the associated buffers removes all of the log
> > items from the AIL.
> 
> Sure, but xfs_ail_push_all_sync() doesn't return until the AIL is
> empty:
> 
>         spin_lock(&ailp->xa_lock);                                               
>         while ((lip = xfs_ail_max(ailp)) != NULL) {                              
>                 prepare_to_wait(&ailp->xa_empty, &wait, TASK_UNINTERRUPTIBLE);   
>                 ailp->xa_target = lip->li_lsn;                                   
>                 wake_up_process(ailp->xa_task);                                  
>                 spin_unlock(&ailp->xa_lock);                                     
>                 schedule();                                                      
>                 spin_lock(&ailp->xa_lock);                                       
>         }                                                                        
>         spin_unlock(&ailp->xa_lock);                                             
> 
> And so the xfsaild should also be entering the empty, idle state on
> it's next pass. Given that we then run a buftarg wait, cycle
> superblock buffer locks and write an unmount record before we
> tear down the AIL, I'm kinda suprised that the AIL hasn't actually
> entered the full idle state here.
> 

Perhaps, but there's mutual exclusion and a wakeup event involved here
as well. If this task schedules first based on the wakeup event and
xfsaild happens to be just entering a max timeout sleep, it doesn't seem
that out of the ordinary for that to be enough time for the unmount
thread to move along far enough for the stop to race. It may be
interesting to see if bumping the "empty" timeout improves the ability
to reproduce, but even without the timeout, I don't think there's any
guarantee xfsaild ends up scheduled between the last sleep and before
the kthread_stop(). It seems to me we're simply subject to
nondeterministic scheduler conditions at that point (or maybe an
interrupt or something occurs, etc.). This seems to be quite rare, after
all.

...
> > Hou,
> > 
> > Care to update your patch with this information and the previous
> > suggestions from Dave and I (pull up the check, add a comment, and make
> > sure to reset the task state)?
> 
> The loop really needs to be completely restructured - we should only
> need to check kthread_should_stop() once per loop cycle...
> 

Ok, it seems reasonable to me to clean up the whole thing a bit.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
