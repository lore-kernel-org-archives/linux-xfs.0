Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B269DC47404
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 03:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8548921479
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 03:20:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="wFuqmJYq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbfJHDUj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 23:20:39 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42310 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729885AbfJHDUj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Oct 2019 23:20:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id z12so9438103pgp.9
        for <linux-xfs@vger.kernel.org>; Mon, 07 Oct 2019 20:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hOpTDwgTjucyOYseuwafLS5BCj+XUPc6M7qUnXfBnxQ=;
        b=wFuqmJYqLrRlrQHQ5K8l3Lk+dvl7JIhYgniYtJiHAXxg7N+TW71fgTajBO62mzEBLC
         Yk67K1NNivk4mBd4JjT9gdORmTFXgxyHueQW4MA4RJh4u3IHd1LzTNpzr5xOAS/l062J
         vS6xfo8FckBOdZ5EPU/6Ccv+ren2q/qfxw5bDeT4qLQE+EtyLrB7tp/8zW1elBj59UB2
         JUZR5Jv/UrNhsfqmkQ78Af50M4OOiXTNey5ePD5scA7DRXzLRYh4zMvrnQATNW4SJ9Ql
         s2Vst2rRIP1VYpovs7hyyF4LM28cvxdGd8r38xRa9S0jesZrNQJMfbr2eGul/JV60erm
         Rb5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hOpTDwgTjucyOYseuwafLS5BCj+XUPc6M7qUnXfBnxQ=;
        b=Vm50VgCJ/PNKIHBB8fOd2PMzL8SLU7iqBP7j35I39ju2f2aJ1+5gJlzJljWAGWbp5l
         rxo8jXraMIqtZFe7IQl1f75z6YpD+Gc8igBVPmf2ud+CtHLDkjCYA8gJCgqxxjtT4UF4
         mgWu32L4ZDy9v2A26txtKL462lNEHXbmsoqMIt3Nhe8T5fOzujDcOivkI8vBCijMUG+3
         RO9jELXlTdk+j44iW5R3ZVfq/HedGffQULX8D/OXtZ9bUWy2b6SxP6Xadf4dsiAIykvM
         Mg8Dou7HoG4olC/c0qr4V0vQJsX/DwJG96qD4mTvdyFeBlkpdaikP2d/42ggxVDbyf+d
         Fk6Q==
X-Gm-Message-State: APjAAAVuhqh3NDfgHgHH+Yf+R8unv8ohrzQwq2t3SIJ87FPJQtoNUJ5k
        +F9KLKhZbUp1By2QPwhVZ0tB/Q==
X-Google-Smtp-Source: APXvYqynScptury9jvAlSh/yIarWdlWWKHj5JE6ZAXlsr61jrwzksigutFCrPle/es17/CbWxJB6GQ==
X-Received: by 2002:a63:5552:: with SMTP id f18mr23984019pgm.437.1570504838136;
        Mon, 07 Oct 2019 20:20:38 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id d22sm18909893pfq.168.2019.10.07.20.20.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 20:20:36 -0700 (PDT)
Subject: Re: [5.4-rc1, regression] wb_workfn wakeup oops (was Re: frequent
 5.4-rc1 crash?)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Chris Mason <clm@fb.com>, Gao Xiang <hsiangkao@aol.com>,
        Dave Chinner <david@fromorbit.com>,
        xfs <linux-xfs@vger.kernel.org>, "tj@kernel.org" <tj@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20191003015247.GI13108@magnolia>
 <20191003064022.GX16973@dread.disaster.area>
 <20191003084149.GA16347@hsiangkao-HP-ZHAN-66-Pro-G1>
 <41B90CA7-E093-48FA-BDFD-73BE7EB81FB6@fb.com>
 <32f7c7d8-59d8-7657-4dcc-3741355bf63a@kernel.dk>
 <20191003183746.GK13108@magnolia> <20191006223041.GQ13108@magnolia>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bf8db64b-0b9b-172e-9aca-a06151dad252@kernel.dk>
Date:   Mon, 7 Oct 2019 21:20:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006223041.GQ13108@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/6/19 4:30 PM, Darrick J. Wong wrote:
> On Thu, Oct 03, 2019 at 11:37:46AM -0700, Darrick J. Wong wrote:
>> On Thu, Oct 03, 2019 at 08:05:42AM -0600, Jens Axboe wrote:
>>> On 10/3/19 8:01 AM, Chris Mason wrote:
>>>>
>>>>
>>>> On 3 Oct 2019, at 4:41, Gao Xiang wrote:
>>>>
>>>>> Hi,
>>>>>
>>>>> On Thu, Oct 03, 2019 at 04:40:22PM +1000, Dave Chinner wrote:
>>>>>> [cc linux-fsdevel, linux-block, tejun ]
>>>>>>
>>>>>> On Wed, Oct 02, 2019 at 06:52:47PM -0700, Darrick J. Wong wrote:
>>>>>>> Hi everyone,
>>>>>>>
>>>>>>> Does anyone /else/ see this crash in generic/299 on a V4 filesystem
>>>>>>> (tho
>>>>>>> afaict V5 configs crash too) and a 5.4-rc1 kernel?  It seems to pop
>>>>>>> up
>>>>>>> on generic/299 though only 80% of the time.
>>>>>>>
>>>>>
>>>>> Just a quick glance, I guess there could is a race between (complete
>>>>> guess):
>>>>>
>>>>>
>>>>>    160 static void finish_writeback_work(struct bdi_writeback *wb,
>>>>>    161                                   struct wb_writeback_work *work)
>>>>>    162 {
>>>>>    163         struct wb_completion *done = work->done;
>>>>>    164
>>>>>    165         if (work->auto_free)
>>>>>    166                 kfree(work);
>>>>>    167         if (done && atomic_dec_and_test(&done->cnt))
>>>>>
>>>>>    ^^^ here
>>>>>
>>>>>    168                 wake_up_all(done->waitq);
>>>>>    169 }
>>>>>
>>>>> since new wake_up_all(done->waitq); is completely on-stack,
>>>>>    	if (done && atomic_dec_and_test(&done->cnt))
>>>>> -		wake_up_all(&wb->bdi->wb_waitq);
>>>>> +		wake_up_all(done->waitq);
>>>>>    }
>>>>>
>>>>> which could cause use after free if on-stack wb_completion is gone...
>>>>> (however previous wb->bdi is solid since it is not on-stack)
>>>>>
>>>>> see generic on-stack completion which takes a wait_queue spin_lock
>>>>> between
>>>>> test and wake_up...
>>>>>
>>>>> If I am wrong, ignore me, hmm...
>>>>
>>>> It's a good guess ;)  Jens should have this queued up already:
>>>>
>>>> https://lkml.org/lkml/2019/9/23/972
>>>
>>> Yes indeed, it'll go out today or tomorrow for -rc2.
>>
>> The patch fixes the problems I've been seeing, so:
>> Tested-by: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Thank you for taking care of this. :)
> 
> Hmm, I don't see this patch in -rc2; did it not go out in time, or were
> there further complications?

Andrew had it queued up, apparently my memory was bad. It's in now.

-- 
Jens Axboe

