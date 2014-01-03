Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EDAF47F3F
	for <xfs@oss.sgi.com>; Fri,  3 Jan 2014 07:17:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB3F98F8033
	for <xfs@oss.sgi.com>; Fri,  3 Jan 2014 05:17:56 -0800 (PST)
Message-ID: <52C6B86C.6060407@oracle.com>
Date: Fri, 03 Jan 2014 21:17:32 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfs: wake up cil->xc_commit_wait while removing ctx
	from cil->xc_committing
References: <52B98292.5040002@oracle.com>	<52C18F56.70709@sgi.com>	<52C4286C.5040007@oracle.com>	<20140102004503.GN20579@dastard>
	<52C69035.7010606@oracle.com>
In-Reply-To: <52C69035.7010606@oracle.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Tinguely <tinguely@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 01/03 2014 18:25 PM, Jeff Liu wrote:
> On 01/02 2014 08:45, Dave Chinner wrote:
>> On Wed, Jan 01, 2014 at 10:38:36PM +0800, Jeff Liu wrote:
>>> On 12/30 2013 23:20 PM, Mark Tinguely wrote:
>>>> On 12/24/13 06:48, Jeff Liu wrote:
>>>>> From: Jie Liu<jeff.liu@oracle.com>
>>>>>
>>>>> I can easily to hit a hang up while running fsstress and shutting down
>>>>> XFS on SSD via the tests below:
>>> <snip>
>>>>>
>>>>>     Task1                    Task2
>>>>>
>>>>>                      list_add(&ctx->committing,&cil->xc_committing);
>>>>>
>>>>> xlog_wait(&cil->xc_commit_wait..)
>>>>> schedule()...
>>>>>
>>>>>                      Aborting!! list_del(&ctx->committing);
>>>>>                      wake_up_all(&cil->xc_commit_wait);<-- MISSING!
>>>>>
>>>>> As a result, we should handle this situation in xlog_cil_committed().
>>>>>
>>>>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>>>>> ---
>>>>>   fs/xfs/xfs_log_cil.c | 2 ++
>>>>>   1 file changed, 2 insertions(+)
>>>>>
>>>>> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
>>>>> index 5eb51fc..8c7e9c7 100644
>>>>> --- a/fs/xfs/xfs_log_cil.c
>>>>> +++ b/fs/xfs/xfs_log_cil.c
>>>>> @@ -406,6 +406,8 @@ xlog_cil_committed(
>>>>>
>>>>>       spin_lock(&ctx->cil->xc_push_lock);
>>>>>       list_del(&ctx->committing);
>>>>> +    if (abort)
>>>>> +        wake_up_all(&ctx->cil->xc_commit_wait);
>>>>>       spin_unlock(&ctx->cil->xc_push_lock);
>>>>>
>>>>>       xlog_cil_free_logvec(ctx->lv_chain);
>>>>
>>>> Hi Jeff, I hope you had a good break,
>>> Thanks :)
>>>>
>>>> So you are saying the wakeup in the CIL push error path missing?
>>> Yes.
>>>
>>>> I agree with that. But I don't like adding a new wake up to
>>>> xlog_cil_committed(), which is after the log buffer is written.
>>
>> Hi Mark, any particular reason why you don't like this? It would be
>> great if you could explain why you don't like something up front so
>> we don't have to guess at your reasons or wait for another round
>> trip in the conversation to find them out....
>>
>>> IMO this callback would be called if any problem is happened before
>>> the log buffer is written as well, e.g, 
>>> xlog_cil_push()->xfs_log_notify() <-- failed
>>> 			| 
>>>         		|->xlog_cil_committed()
>>
>> Right, it's the generic CIL commit handler and it can be called
>> directly or from log IO completion.
>>
>> The question is this: it is safe to wake up waiters from log IO
>> completion if that is where an abort is first triggered from (i.e.
>> on log IO error). From what I can see, it is safe to do the wakeup
>> on abort because the iclog iwe attach the IO completion callback to
>> in xlog_cil_push() cannot be put under IO until we release the
>> reference gained in xfs_log_done().
>>
>> But this raises an interesting question - the wakeup in
>> xlog_cil_push() is done before the log IO for the checkpoint is
>> complete, so the wakeup is occurring on checkpoint processing
>> completion, not iclog IO completion. i.e. the actual log force
>> sleeping still needs to wait for log IO completion to occur after
>> then CIL has been pushed. This occurs in the _xfs_log_force{_lsn}()
>> wrappers, where iclog state changes are waited for.
>>
>> Why is this important? The iclog write/flush wakeups are all done
>> from IO completion context, except for the force shutdown case,
>> which calls xlog_state_do_callback(log, XFS_LI_ABORTED, NULL); to
>> trigger wakeups and aborts via the log IO completion callbacks on
>> all the outstanding iclogs.
>>
>> IOWs, we've already got a design pattern that says:
>>
>> 	- run log force wakeups from IO completions
>> 	- on shutdown, run IO completions directly to abort pending
>> 	  log operations
>>
>> So, really, issuing wakeups from iclog IO completion on log aborts
>> or errors is exactly what we currently do to ensure that shutdowns
>> don't leave processes waiting on log force completion behind. So
>> from that perspective, adding the wakeup on abort to
>> xlog_cil_committed() seems like the right approach to take.
>>
>> Actually, there's more issues here: xlog_cil_push() leaks a
>> reference to the iclog when it triggers the error path via
>> xfs_log_notify() failure. At this point we always need to release
>> the iclog. Hence if xfs_log_notify() were to always add the IO
>> completion to the iclog and xlog_cil_committed() issued wakeups on
>> abort errors, then we could completely ignore the log state in
>> xfs_log_notify() and have xfs_log_release_iclog() capture the IO
>> error and the subsequent shutdown would handle the aborts and
>> wakeups....
> 
> There is indeed an iclog ref leak after digging into the code.
>>
>> Hmmm, then xfs_log_notify could go away, and the callback list could
>> be made a lockless list and the ic_callback_lock could go away,
>> too....
> 
> Hence we can fold xfs_log_notify() into xlog_cil_push() directly, but am
> not sure I get the reason why we could make the callback list lockless:
> When attaching the IO completion callback to icl og, we assert the iclog
> state to be XLOG_STATE_ACTIVE or XLOG_STATE_WANT_SYNC, but in the other
> place where we also try to get the ic_callback_lock, i.e, 
> xlog_state_do_callback(),  we only perform callbacks for iclogs that in
> XLOG_STATE_DONE_SYNC or in XLOG_STATE_DO_CALLBACK, so they're already
> prevented from the potential race situations, am I understood correctly?
> 
> Also, it seems like the iclog->ic_callback_tail can go away as well,
> since it only serves as a left value.
> 

Oh, no! I took ic_callback_tail wrong... It's used to attach func to the
tail of callback list.

But IMHO, since it seems like the current code only attach one callback to
iclog (xlog_cil_committed()), the only "iclog->ic_callback" could handle it
if no more callbacks would be added in the future...

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
