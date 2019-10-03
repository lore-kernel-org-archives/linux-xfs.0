Return-Path: <SRS0=y7rh=X4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C25CC4CED1
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 14:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10E27207FF
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 14:05:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="U/T3eYaL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730138AbfJCOFr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Oct 2019 10:05:47 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41591 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730114AbfJCOFr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Oct 2019 10:05:47 -0400
Received: by mail-io1-f68.google.com with SMTP id n26so5737657ioj.8
        for <linux-xfs@vger.kernel.org>; Thu, 03 Oct 2019 07:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zd10yaCQtpl6TZ0TOAMtyatF9DypoM7H+hcM5WzFUVE=;
        b=U/T3eYaLtuoQ2ZqXaNtEC8/zsRl7vXbkvH0ur/mnuZdci8JHS25m8tVZhHzkHXcOoc
         WXUD7QLzxXLhhCHtQSsdWh88cGv6kpU+S7wFZp4bTseszz7PqWHfjNvElwKG0n86H2ue
         psO740nts7BGRk8Q0vM1D/p1IPXdardfp1FT/z0cuL8d+mIuaWkzkJmjYjFGlH47Tf0d
         Ph+8CkYQExEPukS9Qzgo/l3dXhUljVSa0XWe6A1cAOjC3UVbBtnJwKZYqUMqb2DsSOrS
         oKpZjKvBLPq6NmzXf6ktUHkVKcDGNxe4rwdVCKI1RtsND9eofEpN9ovUZ+Tc1RIG3L8q
         uFfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zd10yaCQtpl6TZ0TOAMtyatF9DypoM7H+hcM5WzFUVE=;
        b=kxpK7jdZ5084RrjDly/l3COyhq2EEVdy2nNDnS/HcC9LC+lLu9VK7Zvpnb58uBEz2Z
         JG4oz55PgrTxmJzomsUStFgGKJDHJaa/C9YoPcQziBcl5YPQxOKHA/qsYqzk0tc9A9YJ
         WoZDgI0GtPrlcELtUjXXhDV3FdLI3qPmIsKo/G8gZmcnBrSVEifd2Xrb7+dRmz8GtR2i
         eBEmR2TUQc33UuhuezX1oUO0ihoSpZinDYJXpHKB52ix7Y7gicx9z2ob1AdW5Ri9sd2K
         OknzfNKYP/FdWiItOHjT6Xug2TXLRfRtdHQtzivOyXY5lSoXTUb7WfWa5or9zxb1e/qw
         NJcg==
X-Gm-Message-State: APjAAAWbm/4ZkxsjRcePOQxrQ7YuPZLT6wZ2lFzvN6F7qdWotI2yV0Mq
        UkiHDt7Vi/egmbrUlYd+lmSKUw==
X-Google-Smtp-Source: APXvYqxMC85P8p6nfEer1yrkDe1pPs1QGTYJo4ByBv6STdcpSYNzenOiPdhO4Vs5nrMYzAegJKsClw==
X-Received: by 2002:a92:ce4f:: with SMTP id a15mr10046137ilr.50.1570111545121;
        Thu, 03 Oct 2019 07:05:45 -0700 (PDT)
Received: from [192.168.1.50] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z16sm889283iol.64.2019.10.03.07.05.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 07:05:44 -0700 (PDT)
Subject: Re: [5.4-rc1, regression] wb_workfn wakeup oops (was Re: frequent
 5.4-rc1 crash?)
To:     Chris Mason <clm@fb.com>, Gao Xiang <hsiangkao@aol.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>, "tj@kernel.org" <tj@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20191003015247.GI13108@magnolia>
 <20191003064022.GX16973@dread.disaster.area>
 <20191003084149.GA16347@hsiangkao-HP-ZHAN-66-Pro-G1>
 <41B90CA7-E093-48FA-BDFD-73BE7EB81FB6@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <32f7c7d8-59d8-7657-4dcc-3741355bf63a@kernel.dk>
Date:   Thu, 3 Oct 2019 08:05:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <41B90CA7-E093-48FA-BDFD-73BE7EB81FB6@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/3/19 8:01 AM, Chris Mason wrote:
> 
> 
> On 3 Oct 2019, at 4:41, Gao Xiang wrote:
> 
>> Hi,
>>
>> On Thu, Oct 03, 2019 at 04:40:22PM +1000, Dave Chinner wrote:
>>> [cc linux-fsdevel, linux-block, tejun ]
>>>
>>> On Wed, Oct 02, 2019 at 06:52:47PM -0700, Darrick J. Wong wrote:
>>>> Hi everyone,
>>>>
>>>> Does anyone /else/ see this crash in generic/299 on a V4 filesystem
>>>> (tho
>>>> afaict V5 configs crash too) and a 5.4-rc1 kernel?  It seems to pop
>>>> up
>>>> on generic/299 though only 80% of the time.
>>>>
>>
>> Just a quick glance, I guess there could is a race between (complete
>> guess):
>>
>>
>>   160 static void finish_writeback_work(struct bdi_writeback *wb,
>>   161                                   struct wb_writeback_work *work)
>>   162 {
>>   163         struct wb_completion *done = work->done;
>>   164
>>   165         if (work->auto_free)
>>   166                 kfree(work);
>>   167         if (done && atomic_dec_and_test(&done->cnt))
>>
>>   ^^^ here
>>
>>   168                 wake_up_all(done->waitq);
>>   169 }
>>
>> since new wake_up_all(done->waitq); is completely on-stack,
>>   	if (done && atomic_dec_and_test(&done->cnt))
>> -		wake_up_all(&wb->bdi->wb_waitq);
>> +		wake_up_all(done->waitq);
>>   }
>>
>> which could cause use after free if on-stack wb_completion is gone...
>> (however previous wb->bdi is solid since it is not on-stack)
>>
>> see generic on-stack completion which takes a wait_queue spin_lock
>> between
>> test and wake_up...
>>
>> If I am wrong, ignore me, hmm...
> 
> It's a good guess ;)  Jens should have this queued up already:
> 
> https://lkml.org/lkml/2019/9/23/972

Yes indeed, it'll go out today or tomorrow for -rc2.

-- 
Jens Axboe

