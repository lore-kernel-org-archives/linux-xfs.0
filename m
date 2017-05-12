Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24066 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757260AbdELAuF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2017 20:50:05 -0400
Subject: Re: [PATCH 1/1] xfs: remove lsn relevant fields from xfs_trans
 structure and its users
References: <1494484809-10217-1-git-send-email-shan.hai@oracle.com>
 <20170511121130.GA8659@infradead.org>
From: Shan Hai <shan.hai@oracle.com>
Message-ID: <cb4543fe-edcc-30a5-a0a1-41ba82476bf0@oracle.com>
Date: Fri, 12 May 2017 08:49:14 +0800
MIME-Version: 1.0
In-Reply-To: <20170511121130.GA8659@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org



On 2017年05月11日 20:11, Christoph Hellwig wrote:
> On Thu, May 11, 2017 at 02:40:09PM +0800, Shan Hai wrote:
>> The t_lsn is not used anymore and the t_commit_lsn is used as a tmp
>> storage for the checkpoint sequence number only in the current code.
>>
>> And the start/commit lsn are tracked as a transaction group tag in
>> the xfs_cil_ctx instead of a single transaction, so remove them from
>> the xfs_trans structure and their users to match with the design.
>>
>> Signed-off-by: Shan Hai <shan.hai@oracle.com>
>> ---
>>   fs/xfs/xfs_log_cil.c |  5 ++---
>>   fs/xfs/xfs_trace.h   | 19 -------------------
>>   fs/xfs/xfs_trans.h   |  4 ----
>>   3 files changed, 2 insertions(+), 26 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
>> index 82f1cbc..373f5e8 100644
>> --- a/fs/xfs/xfs_log_cil.c
>> +++ b/fs/xfs/xfs_log_cil.c
>> @@ -990,9 +990,8 @@
>>   	if (tp->t_ticket->t_curr_res < 0)
>>   		xlog_print_tic_res(mp, tp->t_ticket);
>>   
>> -	tp->t_commit_lsn = cil->xc_ctx->sequence;
>>   	if (commit_lsn)
>> -		*commit_lsn = tp->t_commit_lsn;
>> +		*commit_lsn = cil->xc_ctx->sequence;
>>   
>>   	xfs_log_done(mp, tp->t_ticket, NULL, regrant);
>>   	xfs_trans_unreserve_and_mod_sb(tp);
>> @@ -1008,7 +1007,7 @@
>>   	 * the log items. This affects (at least) processing of stale buffers,
>>   	 * inodes and EFIs.
>>   	 */
>> -	xfs_trans_free_items(tp, tp->t_commit_lsn, false);
>> +	xfs_trans_free_items(tp, cil->xc_ctx->sequence, false);
> Can we add a local variable to store cil->xc_ctx->sequence to make
> this a little more clear?

Ok, will be fixed in v2 patch.

Thanks
Shan Hai

> Otherwise this looks fine to me.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

