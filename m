Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752740AbdIFLNt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 07:13:49 -0400
Date: Wed, 6 Sep 2017 07:13:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: umount XFS hung when stopping the xfsaild kthread
Message-ID: <20170906111347.GB54570@bfoster.bfoster>
References: <c869cd34-269b-a13d-5009-390e70aa47ac@huawei.com>
 <20170905182752.GA51345@bfoster.bfoster>
 <80da6cde-c8aa-d23d-9705-7d3c11507dec@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80da6cde-c8aa-d23d-9705-7d3c11507dec@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On Wed, Sep 06, 2017 at 06:59:26PM +0800, Hou Tao wrote:
> Hi Brian,
> 
> On 2017/9/6 2:27, Brian Foster wrote:
> > On Tue, Sep 05, 2017 at 09:48:45PM +0800, Hou Tao wrote:
> >> Hi all,
> >>
> >> We recently encounter a XFS umount hang problem. As we can see the following
> >> stacks, the umount process was trying to stop the xfsaild kthread and waiting
> >> for the exit of the xfsaild thread, and the xfsaild thread was waiting for
> >> wake-up.
> >>
> >> [<ffffffff810a604a>] kthread_stop+0x4a/0xe0
> >> [<ffffffffa0680317>] xfs_trans_ail_destroy+0x17/0x30 [xfs]
> >> [<ffffffffa067569e>] xfs_log_unmount+0x1e/0x60 [xfs]
> >> [<ffffffffa066ac15>] xfs_unmountfs+0xd5/0x190 [xfs]
> >> [<ffffffffa066da62>] xfs_fs_put_super+0x32/0x90 [xfs]
> >> [<ffffffff811ebad6>] generic_shutdown_super+0x56/0xe0
> >> [<ffffffff811ebf27>] kill_block_super+0x27/0x70
> >> [<ffffffff811ec269>] deactivate_locked_super+0x49/0x60
> >> [<ffffffff811ec866>] deactivate_super+0x46/0x60
> >> [<ffffffff81209995>] mntput_no_expire+0xc5/0x120
> >> [<ffffffff8120aacf>] SyS_umount+0x9f/0x3c0
> >> [<ffffffff81652a09>] system_call_fastpath+0x16/0x1b
> >> [<ffffffffffffffff>] 0xffffffffffffffff
> >>
> >> [<ffffffffa067faa7>] xfsaild+0x537/0x5e0 [xfs]
> >> [<ffffffff810a5ddf>] kthread+0xcf/0xe0
> >> [<ffffffff81652958>] ret_from_fork+0x58/0x90
> >> [<ffffffffffffffff>] 0xffffffffffffffff
> >>
> >> The kernel version is RHEL7.3 and we are trying to reproduce it (not yet).
> >> I have check the related code and suspect the same problem may also exists in
> >> the mainline.
> >>
> >> The following is the possible sequences which may lead to the hang of umount:
> >>
> >> xfsaild: kthread_should_stop() // return false, so xfsaild continue
> >>
> >> umount: set_bit(KTHREAD_SHOULD_STOP, &kthread->flags) // by kthread_stop()
> >>
> >> umount: wake_up_process() // because xfsaild is still running, so 0 is returned
> >>
> >> xfsaild: __set_current_state()
> >> xfsaild: schedule() // Now, on one will wake it up
> >>
> > 
> > That seems plausible to me. kthread_stop() sets the SHOULD_STOP bit and
> > then wakes up the thread. On the other side, xfsaild() checks
> > SHOULD_STOP, sets the task state and sleeps. It seems like it should be
> > possible for this to hang if xfsaild() checks the should stop bit and
> > then kthread_stop() runs before we set the task state (as you've
> > outlined above).
> > 
> >> The solution I think is adding an extra kthread_should_stop() before
> >> invoking schedule(). Maybe a smp_mb() is needed too, because we needs to
> >> ensure the read of the stop flag happens after the write of the task status.
> >> Something likes the following patch:
> >>
> > 
> > I think the important bit is to check after we've set the task state,
> > yes? That way we know either we've seen the bit or kthread_stop() has
> > woken the task (which I think means the task remains runnable and will
> > be rescheduled such that it exits). If so, I'd probably move the check
> > up after the task state set and add a comment.
> Yes, that's what I tries to express (but failed to).
> Yes, moving the check up after the task state set is much clearer.
> 
> >> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> >> index 9056c0f..6313f67 100644
> >> --- a/fs/xfs/xfs_trans_ail.c
> >> +++ b/fs/xfs/xfs_trans_ail.c
> >> @@ -520,6 +520,11 @@ xfsaild(
> >>                 if (!xfs_ail_min(ailp) &&
> >>                     ailp->xa_target == ailp->xa_target_prev) {
> >>                         spin_unlock(&ailp->xa_lock);
> >> +
> >> +                       smp_mb();
> >> +                       if (kthread_should_stop())
> >> +                               break;
> >> +
> >>                         freezable_schedule();
> >>                         tout = 0;
> >>                         continue;
> >>
> >> Any suggestions ?
> >>
> > 
> > Could you try some hacks to verify this problem on an upstream kernel? I
> > think you should be able to add an artificial delay in xfsaild() before
> > we set the task state when the fs is unmounting and the AIL is empty
> > (ie., it looks like we're going to schedule out), then add a smaller
> > delay to xfs_trans_ail_destroy() to make sure we wait for xfsaild() to
> > settle, but run kthread_stop() between the should_stop check and setting
> > the task state. Then we could potentially confirm the problem and verify
> > the fix unwinds everything correctly. Hm?
> Thanks for your suggestion. As per your suggestion, we had reproduced the
> umount hang problem on both RHEL7 kernel and upstream kernel.
> 
> We just add a 50us delay before the kthread_should_stop() and __set_current_state()
> in xfsaild(), and add a 20us delay before kthread_stop() in xfs_trans_ail_destroy().
> After the hacks, we run an infinite loop: mount + do nothing + umount, and then the
> hang of umount will occur after ten minutes or less.
> 

Ok, thanks for testing. I just sent another mail that shows a larger
delay will reproduce the same problem in one test cycle (mount, touch a
file, umount).

Brian

> Regards,
> 
> Tao
> 
> > 
> > Brian
> > 
> >> Regards,
> >>
> >> Tao
> >>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > .
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
