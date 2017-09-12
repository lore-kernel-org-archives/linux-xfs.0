Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:6453 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751247AbdILIif (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2017 04:38:35 -0400
Subject: Re: [PATCH] xfs: check kthread_should_stop() after the setting of
 task state
References: <1504771497-44154-1-git-send-email-houtao1@huawei.com>
 <20170908174251.GH905@bfoster.bfoster>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <bbc2d571-6305-3713-66be-a11b0b06f6c2@huawei.com>
Date: Tue, 12 Sep 2017 16:38:03 +0800
MIME-Version: 1.0
In-Reply-To: <20170908174251.GH905@bfoster.bfoster>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

Hi,

On 2017/9/9 1:42, Brian Foster wrote:
> On Thu, Sep 07, 2017 at 04:04:57PM +0800, Hou Tao wrote:
>> A umount hang is possible when a race occurs between the umount
>> process and the xfsaild kthread. The following sequences outline
>> the race:
>>
>>     xfsaild: kthread_should_stop()
>> 	     => return false, so xfsaild continue
>>
>>     umount: set_bit(KTHREAD_SHOULD_STOP, &kthread->flags)
>> 	    => by kthread_stop()
>>     umount: wake_up_process()
>> 	    => because xfsaild is still running, so 0 is returned
>>
>>     xfsaild: __set_current_state(TASK_INTERRUPTIBLE)
>>     xfsaild: schedule()
>> 	    => now, xfsaild will wait indefinitely
>>
>>     umount: wait_for_completion()
>> 	    => and umount will hang
>>
>> To fix that, we need to check kthread_should_stop() after we set
>> the task state, so the xfsaild will either see the stop bit and
>> exit or the task state is reset to runnable by wake_up_process()
>> such that it isn't blocked indefinitely and detects the stop bit
>> at the next iteration.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> ---
> 
> I assume you've verified this against your local reproducer? Otherwise
> just a nit on the comment...
Yes, the patch fixes the test case with the delay hacks. After applying the
patch, I also have tried to move the artificial delay in xfsaild down to the
next of kthread_should_stop() and there is no hang of umount.

>>  fs/xfs/xfs_trans_ail.c | 17 ++++++++++++++---
>>  1 file changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
>> index 9056c0f..cd6e185 100644
>> --- a/fs/xfs/xfs_trans_ail.c
>> +++ b/fs/xfs/xfs_trans_ail.c
>> @@ -499,11 +499,22 @@ xfsaild(
>>  	current->flags |= PF_MEMALLOC;
>>  	set_freezable();
>>  
>> -	while (!kthread_should_stop()) {
>> +	while (1) {
>>  		if (tout && tout <= 20)
>> -			__set_current_state(TASK_KILLABLE);
>> +			set_current_state(TASK_KILLABLE);
>>  		else
>> -			__set_current_state(TASK_INTERRUPTIBLE);
>> +			set_current_state(TASK_INTERRUPTIBLE);
>> +
>> +		/*
>> +		 * Check kthread_should_stop() after we set the task state
>> +		 * to guarantee that we either see the stop bit and exit or the
>> +		 * task state is reset to runnable such that it's not blocked
>> +		 * indefinitely and detects the stop bit at the next iteration.
>> +		 */
> 
> I'd change the "it's not blocked indefinitely" wording to something like
> "it's not scheduled out indefinitely." Also, a mention that the task
> state sets above include a memory barrier to serialize against
> kthread_stop() couldn't hurt. Otherwise this looks fine to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Thanks for your comments. I will send v2 soon.

Regards,

Tao

