Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76905C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 02:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbiKQCNE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Nov 2022 21:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiKQCND (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2022 21:13:03 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEA022BD2
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 18:12:59 -0800 (PST)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NCNjH4dTrz15Mc1;
        Thu, 17 Nov 2022 10:12:35 +0800 (CST)
Received: from [10.174.177.238] (10.174.177.238) by
 kwepemi500019.china.huawei.com (7.221.188.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 10:12:57 +0800
Message-ID: <68d584fa-5486-3254-35c2-9ad628b688e5@huawei.com>
Date:   Thu, 17 Nov 2022 10:12:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH v3 1/2] xfs: wait xlog ioend workqueue drained before
 tearing down AIL
To:     Dave Chinner <david@fromorbit.com>
CC:     <dchinner@redhat.com>, <djwong@kernel.org>, <fangwei1@huawei.com>,
        <houtao1@huawei.com>, <jack.qiu@huawei.com>,
        <leo.lilong@huawei.com>, <linux-xfs@vger.kernel.org>,
        <yi.zhang@huawei.com>, <zengheng4@huawei.com>,
        <zhengbin13@huawei.com>
References: <20221107142716.1476166-2-guoxuenan@huawei.com>
 <20221108140605.1558692-1-guoxuenan@huawei.com>
 <20221116060229.GC3600936@dread.disaster.area>
From:   Guo Xuenan <guoxuenan@huawei.com>
In-Reply-To: <20221116060229.GC3600936@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.238]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500019.china.huawei.com (7.221.188.117)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/11/16 14:02, Dave Chinner wrote:
> On Tue, Nov 08, 2022 at 10:06:05PM +0800, Guo Xuenan wrote:
>> Fix uaf in xfs_trans_ail_delete during xlog force shutdown.
>> In commit cd6f79d1fb32 ("xfs: run callbacks before waking waiters in
>> xlog_state_shutdown_callbacks") changed the order of running callbacks
>> and wait for iclog completion to avoid unmount path untimely destroy AIL.
>> But which seems not enough to ensue this, adding mdelay in
>> `xfs_buf_item_unpin` can prove that.
>>
>> The reproduction is as follows. To ensure destroy AIL safely,
>> we should wait all xlog ioend workers done and sync the AIL.
> Like Darrick, I didn't see this either because it's in an old
> thread....
Get it and gladly accept :)
>>   fs/xfs/xfs_log.c | 33 +++++++++++++++++++++++++++------
>>   1 file changed, 27 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index f02a0dd522b3..467bac00951c 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -82,6 +82,9 @@ STATIC int
>>   xlog_iclogs_empty(
>>   	struct xlog		*log);
>>   
>> +static void
>> +xlog_wait_iodone(struct xlog *log);
>> +
> Why do we need a forward prototype definition?
I guess you mean the function name is same as before,
if so, this is coincidence. :)
>>   static int
>>   xfs_log_cover(struct xfs_mount *);
>>   
>> @@ -886,6 +889,23 @@ xlog_force_iclog(
>>   	return xlog_state_release_iclog(iclog->ic_log, iclog, NULL);
>>   }
>>   
>> +/*
>> + * Cycle all the iclogbuf locks to make sure all log IO completion
>> + * is done before we tear down AIL/CIL.
>> + */
>> +static void
>> +xlog_wait_iodone(struct xlog *log)
>> +{
>> +	int		i;
>> +	xlog_in_core_t	*iclog = log->l_iclog;
>> +
>> +	for (i = 0; i < log->l_iclog_bufs; i++) {
>> +		down(&iclog->ic_sema);
>> +		up(&iclog->ic_sema);
>> +		iclog = iclog->ic_next;
>> +	}
>> +}
> This doesn't guarantee no iclog IO is in progress, just that it
> waited for each iclog to finish any IO it had in progress. If we are
> in a normal runtime condition, xfs_log_force(mp, XFS_LOG_SYNC)
> performs this "wait for journal IO to complete" integrity operation.
>
> Which, in normal runtime unmount operation, we get from
> xfs_log_cover().....
>
>> +
>>   /*
>>    * Wait for the iclog and all prior iclogs to be written disk as required by the
>>    * log force state machine. Waiting on ic_force_wait ensures iclog completions
>> @@ -1276,6 +1296,12 @@ xfs_log_cover(
>>   		xfs_ail_push_all_sync(mp->m_ail);
>>   	} while (xfs_log_need_covered(mp));
>>   
>> +	/*
>> +	 * Cycle all the iclogbuf locks to make sure all log IO completion
>> +	 * is done before we tear down AIL.
>> +	 */
>> +	xlog_wait_iodone(mp->m_log);
> .... and so this call is redundant for normal runtime log quiesce
> operations.  That's because the synchronous transaction run in this
> loop:

yes, it is redundant,through discussion here[1] with Darrick

[1] 
https://lore.kernel.org/all/8575089d-bf9b-0383-939b-922f1440abf7@huawei.com/

>         do {
>>>>>>>           error = xfs_sync_sb(mp, true);
>                  if (error)
>                          break;
>                  xfs_ail_push_all_sync(mp->m_ail);
>          } while (xfs_log_need_covered(mp));
>
> causes a xfs_log_force(mp, XFS_LOG_SYNC) to be issued to force the
> transaction to disk and it *waits for the journal IO to complete.
> Further, it is iclog IO completion that moves the log covered state
> forwards, so this loop absolutely relies on the journal IO being
> fully completed and both the CIL and AIL being empty before it will
> exit.
>
> Hence adding xlog_wait_iodone() here would only have an effect if
> the log had been shut down. however, we never get here if the log
> has been shut down because the xfs_log_writable(mp) check at the
> start of xfs_log_cover() will fail. Hence we return without trying
> to cover the log or wait for iclog completion.
>
> IOWs, I don't see how this code does anything to avoid the problem
> that has been described - if the iclog callback runs the shutdown,
> by the time it gets to running shutdown callbacks it's already
> marked both the log and the mount as shut down, so unmount will
> definitely not run this code and so will not wait for the iclog
> running shutdown callbacks during IO completion....
Thank you very much for your detailed explanation here.
> ----
>
> Really, the only place this iclog walk matters is in the unmount
> path prior to tearing down internal structures, and it only matters
> when ths filesystem has been shut down. That means it needs
> to be a part of xfs_log_unmount(), not part of the normal runtime
> freeze/remount readonly/unmount log quiescing.
>
> If we are shut down, then we have to guarantee that we've
> finished processing the iclogs before we tear down the things that
> use log items - the CIL, the AIL, the iclogs themselves, etc. It
> *must* also run in the shutdown case, so it can't be put in a
> function that is conditional on a normal running filesystem.
> Something like this:
>
>   void
>   xfs_log_unmount(
>           struct xfs_mount        *mp)
>   {
>          xfs_log_clean(mp);
>
> +	/*
> +	 * If shutdown has come from iclog IO context, the log
> +	 * cleaning will have been skipped and so we need to wait
> +	 * for ithe iclog to complete shutdown processing before we
> +	 * tear anything down.
> +	 */
> +	xfs_iclog_iodone_wait(mp->m_log);
>          xfs_buftarg_drain(mp->m_ddev_targp);
>
> And the iclog walk can be removed from xlog_dealloc_log() as we've
> already done the checks it needs before tearing down the iclogs....
OK, I will send v4 in a new thread according to your kindly and detailed 
suggestion.

Best regards
Xuenan
> Cheers,
>
> Dave.

-- 
Guo Xuenan [OS Kernel Lab]
-----------------------------
Email: guoxuenan@huawei.com

