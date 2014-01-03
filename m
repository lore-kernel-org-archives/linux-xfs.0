Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C31E87F3F
	for <xfs@oss.sgi.com>; Fri,  3 Jan 2014 09:30:42 -0600 (CST)
Message-ID: <52C6D79E.6050103@sgi.com>
Date: Fri, 03 Jan 2014 09:30:38 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfs: wake up cil->xc_commit_wait while removing ctx
	from cil->xc_committing
References: <52B98292.5040002@oracle.com>	<52C18F56.70709@sgi.com>	<52C4286C.5040007@oracle.com>	<20140102004503.GN20579@dastard>
	<52C69035.7010606@oracle.com> <52C6B86C.6060407@oracle.com>
In-Reply-To: <52C6B86C.6060407@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 1/3/2014 7:17 AM, Jeff Liu wrote:
> On 01/03 2014 18:25 PM, Jeff Liu wrote:
>> On 01/02 2014 08:45, Dave Chinner wrote:
>>> On Wed, Jan 01, 2014 at 10:38:36PM +0800, Jeff Liu wrote:
>>>> On 12/30 2013 23:20 PM, Mark Tinguely wrote:
>>>>> On 12/24/13 06:48, Jeff Liu wrote:
>>>>>> From: Jie Liu<jeff.liu@oracle.com>
>>>>>>
>>>>>> I can easily to hit a hang up while running fsstress and shutting down
>>>>>> XFS on SSD via the tests below:
>>>> <snip>
>>>>>>      Task1                    Task2
>>>>>>
>>>>>>                       list_add(&ctx->committing,&cil->xc_committing);
>>>>>>
>>>>>> xlog_wait(&cil->xc_commit_wait..)
>>>>>> schedule()...
>>>>>>
>>>>>>                       Aborting!! list_del(&ctx->committing);
>>>>>>                       wake_up_all(&cil->xc_commit_wait);<-- MISSING!
>>>>>>
>>>>>> As a result, we should handle this situation in xlog_cil_committed().
>>>>>>
>>>>>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>>>>>> ---
>>>>>>    fs/xfs/xfs_log_cil.c | 2 ++
>>>>>>    1 file changed, 2 insertions(+)
>>>>>>
>>>>>> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
>>>>>> index 5eb51fc..8c7e9c7 100644
>>>>>> --- a/fs/xfs/xfs_log_cil.c
>>>>>> +++ b/fs/xfs/xfs_log_cil.c
>>>>>> @@ -406,6 +406,8 @@ xlog_cil_committed(
>>>>>>
>>>>>>        spin_lock(&ctx->cil->xc_push_lock);
>>>>>>        list_del(&ctx->committing);
>>>>>> +    if (abort)
>>>>>> +        wake_up_all(&ctx->cil->xc_commit_wait);
>>>>>>        spin_unlock(&ctx->cil->xc_push_lock);
>>>>>>
>>>>>>        xlog_cil_free_logvec(ctx->lv_chain);
>>>>> Hi Jeff, I hope you had a good break,
>>>> Thanks :)
>>>>> So you are saying the wakeup in the CIL push error path missing?
>>>> Yes.
>>>>
>>>>> I agree with that. But I don't like adding a new wake up to
>>>>> xlog_cil_committed(), which is after the log buffer is written.
>>> Hi Mark, any particular reason why you don't like this? It would be
>>> great if you could explain why you don't like something up front so
>>> we don't have to guess at your reasons or wait for another round

My concern is consistency, with the patch there will be two paths that 
could do the wake up.

Originally, the wakeup happened before the iclog write.  With the patch, 
if the cil push
sequence successfully wrote it's ticket, woke up the waiters, wrote back 
the iclog, and
then had an error writing the iclog, it would wakeup the xc_commit_wait 
a second time.
Not too drastic of a problem, because the zeroed commit_lsn will prevent 
an premature
write of the next cil push. I just prefer to handle the error in the cil 
push routine and avoid
a second form of wake up.

--Mark.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
