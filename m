Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B75EE7FC6
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 16:35:39 -0600 (CST)
Message-ID: <5306833D.7080600@sgi.com>
Date: Thu, 20 Feb 2014 16:35:41 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs: always do log forces via the workqueue
References: <1392783402-4726-1-git-send-email-david@fromorbit.com>
	<1392783402-4726-2-git-send-email-david@fromorbit.com>
	<5304F6F6.3070007@redhat.com> <20140220002358.GH4916@dastard>
	<5306168B.8080209@sgi.com> <20140220220747.GQ4916@dastard>
In-Reply-To: <20140220220747.GQ4916@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On 02/20/14 16:07, Dave Chinner wrote:
> On Thu, Feb 20, 2014 at 08:51:55AM -0600, Mark Tinguely wrote:
>> On 02/19/14 18:23, Dave Chinner wrote:
>>> On Wed, Feb 19, 2014 at 01:24:54PM -0500, Brian Foster wrote:
>>>> On 02/18/2014 11:16 PM, Dave Chinner wrote:
>>>>> From: Dave Chinner<dchinner@redhat.com>
>>>>>
>>>>> Log forces can occur deep in the call chain when we have relatively
>>>>> little stack free. Log forces can also happen at close to the call
>>>>> chain leaves (e.g. xfs_buf_lock()) and hence we can trigger IO from
>>>>> places where we really don't want to add more stack overhead.
>>>>>
>>>>> This stack overhead occurs because log forces do foreground CIL
>>>>> pushes (xlog_cil_push_foreground()) rather than waking the
>>>>> background push wq and waiting for the for the push to complete.
>>>>> This foreground push was done to avoid confusing the CFQ Io
>>>>> scheduler when fsync()s were issued, as it has trouble dealing with
>>>>> dependent IOs being issued from different process contexts.
>>>>>
>>>>> Avoiding blowing the stack is much more critical than performance
>>>>> optimisations for CFQ, especially as we've been recommending against
>>>>> the use of CFQ for XFS since 3.2 kernels were release because of
>>>>> it's problems with multi-threaded IO workloads.
>>>>>
>>>>> Hence convert xlog_cil_push_foreground() to move the push work
>>>>> to the CIL workqueue. We already do the waiting for the push to
>>>>> complete in xlog_cil_force_lsn(), so there's nothing else we need to
>>>>> modify to make this work.
>>>>>
>>>>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> .....
>>>>> @@ -803,7 +808,6 @@ xlog_cil_force_lsn(
>>>>>   	 * before allowing the force of push_seq to go ahead. Hence block
>>>>>   	 * on commits for those as well.
>>>>>   	 */
>>>>> -restart:
>>>>>   	spin_lock(&cil->xc_push_lock);
>>>>>   	list_for_each_entry(ctx,&cil->xc_committing, committing) {
>>>>>   		if (ctx->sequence>   sequence)
>>>>> @@ -821,6 +825,28 @@ restart:
>>>>>   		/* found it! */
>>>>>   		commit_lsn = ctx->commit_lsn;
>>>>>   	}
>>>>> +
>>>>> +	/*
>>>>> +	 * The call to xlog_cil_push_now() executes the push in the background.
>>>>> +	 * Hence by the time we have got here it our sequence may not have been
>>>>> +	 * pushed yet. This is true if the current sequence still matches the
>>>>> +	 * push sequence after the above wait loop and the CIL still contains
>>>>> +	 * dirty objects.
>>>>> +	 *
>>>>> +	 * When the push occurs, it will empty the CIL and
>>>>> +	 * atomically increment the currect sequence past the push sequence and
>>>>> +	 * move it into the committing list. Of course, if the CIL is clean at
>>>>> +	 * the time of the push, it won't have pushed the CIL at all, so in that
>>>>> +	 * case we should try the push for this sequence again from the start
>>>>> +	 * just in case.
>>>>> +	 */
>>>>> +
>>>>> +	if (sequence == cil->xc_current_sequence&&
>                                               ^^^^^
> FYI, your mailer is still mangling whitespace when quoting code....
>
>>>>> +	    !list_empty(&cil->xc_cil)) {
>>>>> +		spin_unlock(&cil->xc_push_lock);
>>>>> +		goto restart;
>>>>> +	}
>>>>> +
>>>>
>>>> IIUC, the objective here is to make sure we don't leave this code path
>>>> before the push even starts and the ctx makes it onto the committing
>>>> list, due to xlog_cil_push_now() moving things to a workqueue.
>>>
>>> Right.
>>>
>>>> Given that, what's the purpose of re-executing the background push as
>>>> opposed to restarting the wait sequence (as done previously)? It looks
>>>> like push_now() won't queue the work again due to cil->xc_push_seq, but
>>>> it will flush the queue and I suppose make it more likely the push
>>>> starts. Is that the intent?
>>>
>>> Effectively. But the other thing that it is protecting against is
>>> that foreground push is done without holding the cil->xc_ctx_lock,
>>> and so we can get the situation where we try a foreground push
>>> of the current sequence, see that the CIL is empty and return
>>> without pushing, wait for previous sequences to commit, then find
>>> that the CIL has items on the CIL in the sequence we are supposed to
>>> be committing.
>>>
>>> In this case, we don't know if this occurred because the workqueue
>>> has not started working on our push, or whether we raced on an empty
>>> CIL, and hence we need to make sure that everything in the sequence
>>> we are support to commit is pushed to the log.
>>>
>>> Hence if the current sequence is dirty after we've ensure that all
>>> prior sequences are fully checkpointed, need to go back and
>>> push the CIL again to ensure that when we return to the caller the
>>> CIL is checkpointed up to the point in time of the log force
>>> occurring.
>>
>> The desired push sequence was taken from an item on the CIL (either
>> when added or from a pinned item). How could the CIL now be empty
>> other than someone else pushed to at least the desire sequence?
>
> The push sequence is only taken from an object on the CIL through
> xfs_log_force_lsn(). For xfs_log_force(), the sequence is taken
> directly from the current CIL context:
>
> static inline void
> xlog_cil_force(struct xlog *log)
> {
>          xlog_cil_force_lsn(log, log->l_cilp->xc_current_sequence);
> }
>
> And that's how you get an empty CIL when entering
> xlog_cil_force_lsn(), and hence how you can get the race condition
> that the code is protecting against.
>
>> A flush_work() should be enough in the case where the ctx of the
>> desire sequence is not on the xc_committing list. The flush_work
>> will wait for the worker to start and place the ctx of the desired
>> sequence into the xc_committing list. This preventing a tight loop
>> waiting for the cil push worker to start.
>
> Yes, that's exactly what the code does.
>
>> Starting the cil push worker for every wakeup of smaller sequence in
>> the list_for_each_entry loop seems wasteful.
>
> As Brian pointed out, it won't restart on every wakeup - the
> cil->xc_push_seq checks prevent that from happening, so a specific
> sequence will only ever be queued for a push once.
>
>> We know the later error paths in xfs_cil_push() will not do a wake,
>> now is a good time to fix that.
>
> I'm not sure what you are talking about here. If there's a problem,
> please send patches.
>
> Cheers,
>
> Dave.

http://oss.sgi.com/archives/xfs/2013-12/msg00870.html

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
