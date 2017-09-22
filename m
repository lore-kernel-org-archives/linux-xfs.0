Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27254 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751876AbdIVPOV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2017 11:14:21 -0400
Date: Fri, 22 Sep 2017 08:14:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: check kthread_should_stop() after the setting of
 task state
Message-ID: <20170922151403.GE5728@magnolia>
References: <1505205930-2445-1-git-send-email-houtao1@huawei.com>
 <20170918185200.GM6540@magnolia>
 <436ef067-8608-1da6-ee2f-184314761761@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <436ef067-8608-1da6-ee2f-184314761761@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 22, 2017 at 06:57:00PM +0800, Hou Tao wrote:
> Hi Darrick,
> 
> On 2017/9/19 2:52, Darrick J. Wong wrote:
> > On Tue, Sep 12, 2017 at 04:45:30PM +0800, Hou Tao wrote:
> >> A umount hang is possible when a race occurs between the umount
> >> process and the xfsaild kthread. The following sequences outline
> >> the race:
> >>
> >>     xfsaild: kthread_should_stop()
> >> 	     => return false, so xfsaild continue
> >>
> >>     umount: set_bit(KTHREAD_SHOULD_STOP, &kthread->flags)
> >> 	    => by kthread_stop()
> >>     umount: wake_up_process()
> >> 	    => because xfsaild is still running, so 0 is returned
> >>
> >>     xfsaild: __set_current_state(TASK_INTERRUPTIBLE)
> >>     xfsaild: schedule()
> >> 	    => now, xfsaild will wait indefinitely
> >>
> >>     umount: wait_for_completion()
> >> 	    => and umount will hang
> >>
> >> To fix that, we need to check kthread_should_stop() after we set
> >> the task state, so the xfsaild will either see the stop bit and
> >> exit or the task state is reset to runnable by wake_up_process()
> >> such that it isn't scheduled out indefinitely and detects the stop
> >> bit at the next iteration.
> >>
> >> Reviewed-by: Christoph Hellwig <hch@lst.de>
> >> Reviewed-by: Brian Foster <bfoster@redhat.com>
> >> Signed-off-by: Hou Tao <houtao1@huawei.com>
> > 
> > Looks ok, I guess, but just to reiterate what I said in another email
> > 15 minutes ago, can this be turned into a regression test?
> It's difficult to create an always-happened test for the race, and
> I had test the patch by adding artificial delays (as suggested by Brian Foster) in
> kernel source code. I also have tried to reproduce the problem by lifting up the
> schedule class/priority of the umount process and lifting down the schedule
> class/priorityof the xfsaild kthread, but still can not reproduce the problem,
> so any ideas or suggestions ?

Do the artificial delays make it so that the race happens reliably?
If so, we could just add a debug knob to inject delays, which you could
then call from a xfstest script.

--D

> 
> Regard
> 
> 
> > --D
> > 
> >> ---
> >> v2:
> >> 	* comment updates suggested by Brain Foster
> >> v1:
> >> 	* http://www.spinics.net/lists/linux-xfs/msg10285.html
> >> ---
> >>  fs/xfs/xfs_trans_ail.c | 21 ++++++++++++++++++---
> >>  1 file changed, 18 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> >> index 9056c0f..2d77d9c 100644
> >> --- a/fs/xfs/xfs_trans_ail.c
> >> +++ b/fs/xfs/xfs_trans_ail.c
> >> @@ -499,11 +499,26 @@ xfsaild(
> >>  	current->flags |= PF_MEMALLOC;
> >>  	set_freezable();
> >>  
> >> -	while (!kthread_should_stop()) {
> >> +	while (1) {
> >>  		if (tout && tout <= 20)
> >> -			__set_current_state(TASK_KILLABLE);
> >> +			set_current_state(TASK_KILLABLE);
> >>  		else
> >> -			__set_current_state(TASK_INTERRUPTIBLE);
> >> +			set_current_state(TASK_INTERRUPTIBLE);
> >> +
> >> +		/*
> >> +		 * Check kthread_should_stop() after we set the task state
> >> +		 * to guarantee that we either see the stop bit and exit or
> >> +		 * the task state is reset to runnable such that it's not
> >> +		 * scheduled out indefinitely and detects the stop bit at
> >> +		 * next iteration.
> >> +		 *
> >> +		 * A memory barrier is included in above task state set to
> >> +		 * serialize again kthread_stop().
> >> +		 */
> >> +		if (kthread_should_stop()) {
> >> +			__set_current_state(TASK_RUNNING);
> >> +			break;
> >> +		}
> >>  
> >>  		spin_lock(&ailp->xa_lock);
> >>  
> >> -- 
> >> 2.5.0
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
