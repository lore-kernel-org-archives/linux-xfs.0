Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C86C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Dec 2020 16:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C03A207B0
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Dec 2020 16:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgL3Qy5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Dec 2020 11:54:57 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:34983 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726214AbgL3Qy5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Dec 2020 11:54:57 -0500
Received: from [192.168.0.8] (ip5f5aef2f.dynamic.kabel-deutschland.de [95.90.239.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 285FC20646219;
        Wed, 30 Dec 2020 17:54:14 +0100 (CET)
Subject: Re: [PATCH] xfs: Wake CIL push waiters more reliably
To:     Hillf Danton <hdanton@sina.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>, it+linux-xfs@molgen.mpg.de
References: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
 <20201230024642.2171-1-hdanton@sina.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <f2933207-a48e-11a6-7dad-0081cae84e06@molgen.mpg.de>
Date:   Wed, 30 Dec 2020 17:54:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201230024642.2171-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 30.12.20 03:46, Hillf Danton wrote:
> On Wed, 30 Dec 2020 00:56:27 +0100
>> Threads, which committed items to the CIL, wait in the xc_push_wait
>> waitqueue when used_space in the push context goes over a limit. These
>> threads need to be woken when the CIL is pushed.
>>
>> The CIL push worker tries to avoid the overhead of calling wake_all()
>> when there are no waiters waiting. It does so by checking the same
>> condition which caused the waits to happen. This, however, is
>> unreliable, because ctx->space_used can actually decrease when items are
>> recommitted. If the value goes below the limit while some threads are
>> already waiting but before the push worker gets to it, these threads are
>> not woken.
> 
> Looks like you are fixing a typo in c7f87f3984cf ("xfs: fix
> use-after-free on CIL context on shutdown") in mainline, and
> it may mean
> 
> 	/*
> 	 * Wake up any background push waiters now this context is being pushed
> 	 * if we are no longer over the space limit
> 	 */
> 
> given waiters throttled for comsuming more space than limit in
> xlog_cil_push_background().

I'm not sure, I understand you correctly. Do you suggest to update the comment to "...if we are no longer over the space limit"  and change the code to `if (ctx->space_used < XLOG_CIL_BLOCKING_SPACE_LIMIT(log))` ?

I don't think, that would be correct.

The current push context is most probably still over the limit if it ever was. It is exceptional, that the few bytes, which might be returned to ctx->space_used, bring us back below the limit. The new context, on the other hand, will have space_used=0.

We need to resume any thread which is waiting for the push.

Best
   Donald

>> Always wake all CIL push waiters. Test with waitqueue_active() as an
>> optimization. This is possible, because we hold the xc_push_lock
>> spinlock, which prevents additions to the waitqueue.
>>
>> Signed-off-by: Donald Buczek <buczek@molgen.mpg.de>
>> ---
>>   fs/xfs/xfs_log_cil.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
>> index b0ef071b3cb5..d620de8e217c 100644
>> --- a/fs/xfs/xfs_log_cil.c
>> +++ b/fs/xfs/xfs_log_cil.c
>> @@ -670,7 +670,7 @@ xlog_cil_push_work(
>>   	/*
>>   	 * Wake up any background push waiters now this context is being pushed.
>>   	 */
>> -	if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
>> +	if (waitqueue_active(&cil->xc_push_wait))
>>   		wake_up_all(&cil->xc_push_wait);
>>   
>>   	/*
>> -- 
>> 2.26.2
