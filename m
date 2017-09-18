Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36052 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753186AbdIRSnw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 14:43:52 -0400
Date: Mon, 18 Sep 2017 11:43:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: check kthread_should_stop() after the setting of
 task state
Message-ID: <20170918184342.GL6540@magnolia>
References: <1504771497-44154-1-git-send-email-houtao1@huawei.com>
 <20170908174251.GH905@bfoster.bfoster>
 <bbc2d571-6305-3713-66be-a11b0b06f6c2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbc2d571-6305-3713-66be-a11b0b06f6c2@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, david@fromorbit.com

On Tue, Sep 12, 2017 at 04:38:03PM +0800, Hou Tao wrote:
> Hi,
> 
> On 2017/9/9 1:42, Brian Foster wrote:
> > On Thu, Sep 07, 2017 at 04:04:57PM +0800, Hou Tao wrote:
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
> >> such that it isn't blocked indefinitely and detects the stop bit
> >> at the next iteration.
> >>
> >> Signed-off-by: Hou Tao <houtao1@huawei.com>
> >> ---
> > 
> > I assume you've verified this against your local reproducer? Otherwise
> > just a nit on the comment...
> Yes, the patch fixes the test case with the delay hacks. After applying the
> patch, I also have tried to move the artificial delay in xfsaild down to the
> next of kthread_should_stop() and there is no hang of umount.

Can this be turned into an xfstest, please?

--D

> 
> >>  fs/xfs/xfs_trans_ail.c | 17 ++++++++++++++---
> >>  1 file changed, 14 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> >> index 9056c0f..cd6e185 100644
> >> --- a/fs/xfs/xfs_trans_ail.c
> >> +++ b/fs/xfs/xfs_trans_ail.c
> >> @@ -499,11 +499,22 @@ xfsaild(
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
> >> +		 * to guarantee that we either see the stop bit and exit or the
> >> +		 * task state is reset to runnable such that it's not blocked
> >> +		 * indefinitely and detects the stop bit at the next iteration.
> >> +		 */
> > 
> > I'd change the "it's not blocked indefinitely" wording to something like
> > "it's not scheduled out indefinitely." Also, a mention that the task
> > state sets above include a memory barrier to serialize against
> > kthread_stop() couldn't hurt. Otherwise this looks fine to me:
> > 
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> Thanks for your comments. I will send v2 soon.
> 
> Regards,
> 
> Tao
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
