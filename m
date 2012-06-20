Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5KFZKbI096615 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 10:35:20 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rm6NQVhaBYeBLyIU for
	<xfs@oss.sgi.com>; Wed, 20 Jun 2012 08:35:19 -0700 (PDT)
Message-ID: <4FE1EDDC.1070904@redhat.com>
Date: Wed, 20 Jun 2012 11:35:56 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs: re-enable xfsaild idle mode and fix associated
	races
References: <1339087793-45731-1-git-send-email-bfoster@redhat.com>
	<20120620080523.GA26167@infradead.org>
In-Reply-To: <20120620080523.GA26167@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 06/20/2012 04:05 AM, Christoph Hellwig wrote:
> On Thu, Jun 07, 2012 at 12:49:53PM -0400, Brian Foster wrote:
>> xfsaild idle mode logic currently leads to a couple hangs:
>>
>> 1.) If xfsaild is rescheduled in during an incremental scan
>>     (i.e., tout != 0) and the target has been updated since
>>     the previous run, we can hit the new target and go into
>>     idle mode with a still populated ail.
>> 2.) A wake up is only issued when the target is pushed forward.
>>     The wake up can race with xfsaild if it is currently in the
>>     process of entering idle mode, causing future wake up
>>     events to be lost.
>>
>> Both hangs are reproducible by running xfstests 273 in a loop.
>> Modify xfsaild to enter idle mode only when the ail is empty
>> and the push target has not been moved forward since the last
>> push.
> 
> What tree is this against?  The current XFS tree never fully idles,
> so something is missing here, probably just in the patch description.
> 

Yes, this was tested in an upstream tree with a minor modification to
re-enable idle mode (as previously implemented) and test/reproduce the
hangs. I'll send an updated patch that calls that out in the description.

>>  	spin_lock(&ailp->xa_lock);
>> +
>> +	/* barrier matches the xa_target update in xfs_ail_push() */
>> +	smp_rmb();
>> +	target = ailp->xa_target;
>> +	ailp->xa_target_prev = target;
>> +
>>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->xa_last_pushed_lsn);
>>  	if (!lip) {
>>  		/*
>> +
>> +		spin_lock(&ailp->xa_lock);
>> +
>> +		/*
>> +		 * Idle if the AIL is empty and we are not racing with a target
>> +		 * update. The barrier matches the xa_target update in
>> +		 * xfs_ail_push().
>> +		 */
>> +		smp_rmb();
> 
> Given that both sides are under xa_lock I can't see any need for
> barriers here.
> 

Ok.

>> +		if (!xfs_ail_min(ailp) && (ailp->xa_target == ailp->xa_target_prev)) {
>> +			spin_unlock(&ailp->xa_lock);
>> +			schedule();
>> +			tout = 0;
>> +			continue;
>> +		}
> 
> This seems to add the actual idling, but in a rather confusing way.
> 
> Can you add the xfs_ail_min and target checks to the end of xfsaild_push
> so that they are in one place with the other decisions for the timeout.
> 

A couple points here:

- This code is primarily based on logic from Dave (whom I should also
probably credit in the description), whom I think generally preferred to
see the sleeping logic pulled out from xfsaild_push(). To provide some
context, the relevant thread is here:

http://oss.sgi.com/archives/xfs/2012-05/msg00288.html

- One lockup this actually fixes is a race between xa_target updates and
the decision to idle the xfsaild thread. To be specific, it was possible
to update xa_target and issue a wake_up_process() that is "lost" due to
the idle thread already running. If the idle thread happens to be
somewhere after the decision to sleep (set tout=0) but before the thread
is set !TASK_RUNNING, it might schedule out indefinitely.

I think if we move the sleep check back into xfsaild_push(), we
reintroduce the race, narrow as it may be. Now that I think of it, I
could also elaborate on this particular race in the comment you call out
below.

So if I'm mistaken with this point, I'd at least like to see you and
Dave agree on an approach here before I post v3, so I'll await your
response...

> Please also add a comment explaining the conditions when we want to
> idle.
> 

This is the intent of the comment in the previous chunk you commented on
wrt to the barrier ("Idle if the AIL is empty..."). I can remove the
barrier bit if that goes away...

> Also two small style nipicks:
> 
>  - please make sure lines are shorter than 80 characters
>  - no need for the braces around the target comparism above.
> 

Ok. Thanks for the review.

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
