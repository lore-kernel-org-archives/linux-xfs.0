Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2141DC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 13:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0984206DC
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 13:10:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="nxPTtZVV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgHKNKe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 09:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbgHKNKe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Aug 2020 09:10:34 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E717EC06174A
        for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2020 06:10:33 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f9so1850465pju.4
        for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2020 06:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZhILE2jVo2MVba2pbnkmf35kAhfGme0WKthuBzze9P0=;
        b=nxPTtZVVzGW/v9KU7DtLV0BMFzIvXBxQTR21jyDh8G58vv9+XfloLnltoqLmlOBxS4
         GdKJxZFylBxbOQ7ba4nNu6kj0R4V4wKI4VyuBf8IW0NLg8Zf9T0wtLR5j8GZoMj/36xC
         QGX0Z270ENT8p8XOeCXAwZIMceRtKQv0gDELY7xSums59uIrj3j5mfeZhQkXnB3hHdVl
         dpWmz1oQPyadwnHFpNwf9NsXVJ3jO7qtO5ioD7/j9/CABvYSG7cymc1XzhWmZdwCJRm5
         yw61zRIWVcIVVEC8hUo2cdSxrezaBs8/Y8fi2V1uiLMQwQ8/MPL8iVkpy9BW5IHieLDZ
         IR0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZhILE2jVo2MVba2pbnkmf35kAhfGme0WKthuBzze9P0=;
        b=Jc9TO+zJrCSBhCp7fmMclD2SlhwSneGeH8OIBqPiHHL0J8HkbawDhvQmPSOZ9HjpWW
         VVmQNKas29uHwMc0naC3u92lHHZCp8rCFyhlSQlWBrAyf9M+0K9o2A1/opuPjYuZjcqw
         +JLpbrsOmI9VMqlp/HiaKmv38qE7NuImjjbqT/sxepBYi/G3qpzR6K5yepH0SSrHpk0T
         ZLL4c2yl7dBz/GG8/HhP8SzDENx9/lmHXCs5u7uWH5eTTuiKK0V57hqZFhmKK58xE5ii
         6UGYpDTj2CViQWQtiBMT6tNwaCv1uFVThF2mqi3A/4LTgisd6VqAgEgUnAqnqCTQSbQH
         bfqg==
X-Gm-Message-State: AOAM5335depI34aF2Fc9Q4JykZzoLdsh9qB+8TlKtLe06kJo1jZVE6iD
        YXYDU2kwpezQP4vc33xogb3Q6XD4sKA=
X-Google-Smtp-Source: ABdhPJwczSCVsenpfb11OnFWSEz+ivsiPMZYqArH/kRLj9frV7ss46qIcKQGfVFd8/Ql88WyNprZRg==
X-Received: by 2002:a17:90a:c394:: with SMTP id h20mr1098353pjt.22.1597151432454;
        Tue, 11 Aug 2020 06:10:32 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q13sm2982945pjj.36.2020.08.11.06.10.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 06:10:31 -0700 (PDT)
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
To:     Dave Chinner <david@fromorbit.com>
Cc:     bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org
References: <bug-208827-201763@https.bugzilla.kernel.org/>
 <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
 <20200810000932.GH2114@dread.disaster.area>
 <20200810035605.GI2114@dread.disaster.area>
 <20200810070807.GJ2114@dread.disaster.area>
 <20200810090859.GK2114@dread.disaster.area>
 <20200811020052.GM2114@dread.disaster.area>
 <d7c9ea39-136d-bc1b-7282-097a784e336b@kernel.dk>
 <20200811070505.GO2114@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <547cde58-26f3-05f1-048c-fa2a94d6e176@kernel.dk>
Date:   Tue, 11 Aug 2020 07:10:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200811070505.GO2114@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/11/20 1:05 AM, Dave Chinner wrote:
> On Mon, Aug 10, 2020 at 08:19:57PM -0600, Jens Axboe wrote:
>> On 8/10/20 8:00 PM, Dave Chinner wrote:
>>> On Mon, Aug 10, 2020 at 07:08:59PM +1000, Dave Chinner wrote:
>>>> On Mon, Aug 10, 2020 at 05:08:07PM +1000, Dave Chinner wrote:
>>>>> [cc Jens]
>>>>>
>>>>> [Jens, data corruption w/ io_uring and simple fio reproducer. see
>>>>> the bz link below.]
>>>
>>> Looks like a io_uring/fio bugs at this point, Jens. All your go fast
>>> bits turns the buffered read into a short read, and neither fio nor
>>> io_uring async buffered read path handle short reads. Details below.
>>
>> It's a fio issue. The io_uring engine uses a different path for short
>> IO completions, and that's being ignored by the backend... Hence the
>> IO just gets completed and not retried for this case, and that'll then
>> trigger verification as if it did complete. I'm fixing it up.
> 
> I just updated fio to:
> 
> cb7d7abb (HEAD -> master, origin/master, origin/HEAD) io_u: set io_u->verify_offset in fill_io_u()
> 
> The workload still reports corruption almost instantly. Only this
> time, the trace is not reporting a short read.
> 
> File is patterned with:
> 
> verify_pattern=0x33333333%o-16
> 
> Offset of "bad" data is 0x1240000.
> 
> Expected:
> 
> 00000000:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000010:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000020:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000030:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000040:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000050:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000060:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000070:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000080:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> .....
> 0000ffd0:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff  3333............
> 0000ffe0:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff  3333............
> 0000fff0:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff  3333............
> 
> 
> Received:
> 
> 00000000:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000010:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000020:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000030:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000040:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000050:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000060:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000070:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> 00000080:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> .....
> 0000ffd0:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff  3333............
> 0000ffe0:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff  3333............
> 0000fff0:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff  3333............
> 
> 
> Looks like the data in the expected buffer is wrong - the data
> pattern in the received buffer is correct according the defined
> pattern.
> 
> Error is 100% reproducable from the same test case. Same bad byte in
> the expected buffer dump every single time.

What job file are you running? It's not impossible that I broken
something else in fio, the io_u->verify_offset is a bit risky... I'll
get it fleshed out shortly.

-- 
Jens Axboe

