Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4M0WUqu057889 for <xfs@oss.sgi.com>; Mon, 21 May 2012 19:32:30 -0500
Message-ID: <4FBADE70.8020903@redhat.com>
Date: Mon, 21 May 2012 20:31:44 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH v2 2/3] xfs: fix xfsaild hang due to premature idle
References: <1337626169-21730-1-git-send-email-bfoster@redhat.com>
	<1337626169-21730-3-git-send-email-bfoster@redhat.com>
	<4FBAB16A.7000808@sgi.com>
In-Reply-To: <4FBAB16A.7000808@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 05/21/2012 05:19 PM, Mark Tinguely wrote:
> On 05/21/12 13:49, Brian Foster wrote:
>> Running xfstests 273 in a loop reproduces an XFS lockup due to
>> xfsaild entering idle mode indefinitely. The following
>> high-level sequence of events lead to the hang:
>>
>> - xfsaild is running, hits the stuck item threshold and reschedules,
>>    setting xa_last_pushed_lsn appropriately.
>> - xa_threshold is updated.
>> - xfsaild restarts from the previous xa_last_pushed_lsn, hits the
>>    new target and enters idle mode, even though the previously
>>    stuck items still populate the ail.
>>
>> Modify the tout logic to only enter idle mode when the ail is empty.
>> IOW, if we hit the target but did not perform the current scan from
>> the start of the ail, reschedule at least one more time.
>>
>> Signed-off-by: Brian Foster<bfoster@redhat.com>
>> ---
>>   fs/xfs/xfs_trans_ail.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
>> index ae620eb..8bc8aa2 100644
>> --- a/fs/xfs/xfs_trans_ail.c
>> +++ b/fs/xfs/xfs_trans_ail.c
>> @@ -503,7 +503,7 @@ xfsaild_push(
>>
>>       /* assume we have more work to do in a short while */
>>   out_done:
>> -    if (!count) {
>> +    if (!count&&  !ailp->xa_last_pushed_lsn) {
>>           /* We're past our target or empty, so idle */
>>           ailp->xa_last_pushed_lsn = 0;
>>           ailp->xa_log_flush = 0;
> 

Hi Mark,

> There is another patch in the OSS XFS (43ff2122 in git://oss.sgi.com/xfs/xfs) that is not yet in Linus' tree that is in this area and that is why it is not applying cleanly.
> 

Ah, sorry about that. This is my first time posting patches for XFS so I'm relatively new to the process. :) Should I rebase against the oss.sgi.com tree? For future reference, are new patches expected to be based against that tree?

> So the xfs_log_force() will un-stick the stuck items from the previous pass which set the ailp->xa_last_pushed_lsn = 0; I am asking to be re-assured the count will be non-zero and you won't go idle with still stuck items.
> 

I'm not sure I parse this comment... but my interpretation of xfsaild_push() is that it's possible to "miss" a section of the ail (as reflected by count) when xa_last_pushed_lsn is non-zero. If xa_last_pushed_lsn is 0, how could count be zero unless the ail is empty?

Brian

> 
> The problem that we are chasing in the AIL seems different than lost wakeup (next patch), but it would be interesting to have the patch in the kernel for testing.
> 
> --Mark Tinguely

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
