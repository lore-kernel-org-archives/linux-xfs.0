Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4OD7oad258212 for <xfs@oss.sgi.com>; Thu, 24 May 2012 08:07:50 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id p5vgi2fAHs4fcsDf for
	<xfs@oss.sgi.com>; Thu, 24 May 2012 06:07:49 -0700 (PDT)
Message-ID: <4FBE32A5.6070306@redhat.com>
Date: Thu, 24 May 2012 09:07:49 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH v3 2/2] xfs: fix xfsaild hang due to lost wake ups
References: <1337704714-50235-1-git-send-email-bfoster@redhat.com>
	<1337704714-50235-3-git-send-email-bfoster@redhat.com>
	<20120523005830.GL25351@dastard> <4FBD2306.8090000@redhat.com>
	<20120524000626.GP25351@dastard>
In-Reply-To: <20120524000626.GP25351@dastard>
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

On 05/23/2012 08:06 PM, Dave Chinner wrote:
> On Wed, May 23, 2012 at 01:48:54PM -0400, Brian Foster wrote:
>> On 05/22/2012 08:58 PM, Dave Chinner wrote: snip
>>>
>>> Finally, rather than calling wake_up_process() in the
>>> xfs_ail_push*() functions, call wake_up(&ailp->xa_idle); There
>>> can only be one thread sleeping on that (the xfsaild) so there
>>> is no need to use the wake_up_all() variant...
>>>
>>> FWIW, you might be able to do this without the idle wait queue
>>> and just use wake_up_process() - 
>>>
>>
>> Hi Dave,
>>
>> I have a working version of your suggested algorithm. It looks
>> mostly the same with the exception of a spin_unlock fix. I also
>> have the below version that uses a wait_queue and that I plan to
>> test overnight tonight:
> 
> See my previous mail about using an idle queue.
> 

Ok, I was a bit curious why you suggested that, but I figured it was for
aesthetic or consistency reasons. ;) No problem.

>> 	while (!kthread_should_stop()) {
>> 		if (tout && tout <= 20)
>> 			state = TASK_KILLABLE;
>> 		else
>> 			state = TASK_INTERRUPTIBLE;
>>
>> 		prepare_to_wait(&ailp->xa_idle, &wait, state);
>>
>> 		spin_lock(&ailp->xa_lock);
>> 		/* barrier matches the xa_target update in xfs_ail_push() */
>> 		smp_rmb();
>> 		if (!xfs_ail_min(ailp) && (ailp->xa_target == ailp->xa_target_prev)) {
>> 			/* the ail is empty and no change to the push target - idle */
>> 			spin_unlock(&ailp->xa_lock);
>> 			schedule();
>> 		} else if (tout) {
>> 			spin_unlock(&ailp->xa_lock);
>> 			/* more work to do soon */
>> 			schedule_timeout(msecs_to_jiffies(tout));
>> 		} else {
>> 			spin_unlock(&ailp->xa_lock);
>> 		}
> 
> Three separate unlocks? that's a recipe for future disasters. how
> about:
> 

FWIW, I started off with two just to fix the double unlock on return
from idle mode, then rearranged that for some reason when I added the
idle queue.

> 		if (!xfs_ail_min(ailp) && (ailp->xa_target == ailp->xa_target_prev)) {
> 			/* the ail is empty and no change to the push target - idle */
> 			spin_unlock(&ailp->xa_lock);
> 			schedule();
> 			tout = 0;
> 			continue;
> 		}
> 		spin_unlock(&ailp->xa_lock);
> 
> 		if (tout) {
> 			/* more work to do soon */
> 			schedule_timeout(msecs_to_jiffies(tout));
> 		}
> 
> So that we recheck the idle condition on wakeup from idle before
> doing anything. (i.e. handle spurious idle wakeups effectively). By
> setting the tout to zero, we then fall through immediately to
> pushing the AIL if it was a real wakeup that moved the target....
> 

That sounds good to me. Thanks again.

Brian

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
