Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F08647F55
	for <xfs@oss.sgi.com>; Wed,  1 Jan 2014 08:38:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D74138F8035
	for <xfs@oss.sgi.com>; Wed,  1 Jan 2014 06:38:48 -0800 (PST)
Message-ID: <52C4286C.5040007@oracle.com>
Date: Wed, 01 Jan 2014 22:38:36 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfs: wake up cil->xc_commit_wait while removing ctx
	from cil->xc_committing
References: <52B98292.5040002@oracle.com> <52C18F56.70709@sgi.com>
In-Reply-To: <52C18F56.70709@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/30 2013 23:20 PM, Mark Tinguely wrote:
> On 12/24/13 06:48, Jeff Liu wrote:
>> From: Jie Liu<jeff.liu@oracle.com>
>>
>> I can easily to hit a hang up while running fsstress and shutting down
>> XFS on SSD via the tests below:
<snip>
>>
>>     Task1                    Task2
>>
>>                      list_add(&ctx->committing,&cil->xc_committing);
>>
>> xlog_wait(&cil->xc_commit_wait..)
>> schedule()...
>>
>>                      Aborting!! list_del(&ctx->committing);
>>                      wake_up_all(&cil->xc_commit_wait);<-- MISSING!
>>
>> As a result, we should handle this situation in xlog_cil_committed().
>>
>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>> ---
>>   fs/xfs/xfs_log_cil.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
>> index 5eb51fc..8c7e9c7 100644
>> --- a/fs/xfs/xfs_log_cil.c
>> +++ b/fs/xfs/xfs_log_cil.c
>> @@ -406,6 +406,8 @@ xlog_cil_committed(
>>
>>       spin_lock(&ctx->cil->xc_push_lock);
>>       list_del(&ctx->committing);
>> +    if (abort)
>> +        wake_up_all(&ctx->cil->xc_commit_wait);
>>       spin_unlock(&ctx->cil->xc_push_lock);
>>
>>       xlog_cil_free_logvec(ctx->lv_chain);
> 
> Hi Jeff, I hope you had a good break,
Thanks :)
> 
> So you are saying the wakeup in the CIL push error path missing?
Yes.

> I agree with that. But I don't like adding a new wake up to
> xlog_cil_committed(), which is after the log buffer is written.
IMO this callback would be called if any problem is happened before
the log buffer is written as well, e.g, 
xlog_cil_push()->xfs_log_notify() <-- failed
			| 
        		|->xlog_cil_committed()

Besides, the CTX will be removed from the committing list here but
there might still have waiters sleeping on it.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
