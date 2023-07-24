Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993E0C04A6A
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 16:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjGXQUe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjGXQUd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 12:20:33 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C69710C8
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 09:20:31 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-760dff4b701so56745939f.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 09:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690215631; x=1690820431;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PjqhUUSJHEDS+/liGVpE4l4j4MgMfqBdW2j7FnapxL0=;
        b=QUMK8YzCfxQTkw3KbewQ7j4r1n3eRcnZrrrsVR0tbXl7qJxOxUeMimP7TrCu3jTgOH
         frPeyv/l9K6LTLprT3tFnk8IHyzAwiKmJq+5WFB8U3rR6hCWbUvyhRYka/a1a2UcrXjo
         yVOBekZyNEGFhxXdWyqbUzf5aJ3Rex5BkiM+Xo4bBydYRpReshLBOSgj7bigIiJ3GCh3
         h4dZu5VoafViCeqQnLftUGriordypjGMw5JF0xOFrJRmYixyluVyWbubBBhYXWtUEfRE
         Itsz/3kNtSNAbqeVLiJz/tfM6IO1W4g/gzhOs3u5viW50+0Czxp6BCMXMWJ02DIBkXr6
         0nPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690215631; x=1690820431;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PjqhUUSJHEDS+/liGVpE4l4j4MgMfqBdW2j7FnapxL0=;
        b=EEfvMYwp4+TR2Gj55UGx/uS6hw1Vq2n072giw4DyqMziOU2YSmmy+2bSliiEc7k4YG
         wjt0Y2WjMX2LNgYRKtBxSaXWWrgDyZTk6CJhDyIPxnFFcu/WhVPM0yvxGRVq/vwmQe6r
         Z0k7q/wxk66sX4ltNZYvaxQwwmgmoiRjBZNMAcckUqdc1m341kHmJncJ6jkjtBAUGTT7
         me/X/rGP6MGf8M5Kx6hoEU5/WSc8oZw3tZ4n0AVn+vrSslsmJPsLZJplYmtENRo+T40n
         XuxvRlf5XNWwBzbGly+iUrvmlPmjI9le9KlfSMhXLjHh7EVdjRpO4DqfrvEVRvByS7Rn
         BTMQ==
X-Gm-Message-State: ABy/qLbUGno2tZM5eGy07v/eGWa9y4we+G+8zsjtOP8R3EmUJk7M97id
        T4C6j8hRBxgVZxz0WVB3ISDnTg==
X-Google-Smtp-Source: APBJJlFwEFd+jld+I8p2U2KLjTk5n/p2RbYCOAoJaXQ0kpcyiwdON86mFhZ8lQF3jJAdnQloIwvU/A==
X-Received: by 2002:a05:6602:3e87:b0:780:cb36:6f24 with SMTP id el7-20020a0566023e8700b00780cb366f24mr8314800iob.2.1690215630989;
        Mon, 24 Jul 2023 09:20:30 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t23-20020a05663801f700b00420e6c58971sm3022763jaq.178.2023.07.24.09.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 09:20:30 -0700 (PDT)
Message-ID: <162d84d5-1f04-3448-dd6b-9ef3d5c46cc5@kernel.dk>
Date:   Mon, 24 Jul 2023 10:20:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] io_uring: Use io_schedule* in cqring wait
Content-Language: en-US
To:     Andres Freund <andres@anarazel.de>
Cc:     Phil Elwell <phil@raspberrypi.com>, asml.silence@gmail.com,
        david@fromorbit.com, hch@lst.de, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        stable <stable@vger.kernel.org>
References: <CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com>
 <3d97ae14-dd8d-7f82-395a-ccc17c6156be@kernel.dk>
 <20230724161654.cjh7pd63uas5grmz@awork3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230724161654.cjh7pd63uas5grmz@awork3.anarazel.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/24/23 10:16?AM, Andres Freund wrote:
> Hi,
> 
> On 2023-07-24 09:48:58 -0600, Jens Axboe wrote:
>> On 7/24/23 9:35?AM, Phil Elwell wrote:
>>> Hi Andres,
>>>
>>> With this commit applied to the 6.1 and later kernels (others not
>>> tested) the iowait time ("wa" field in top) in an ARM64 build running
>>> on a 4 core CPU (a Raspberry Pi 4 B) increases to 25%, as if one core
>>> is permanently blocked on I/O. The change can be observed after
>>> installing mariadb-server (no configuration or use is required). After
>>> reverting just this commit, "wa" drops to zero again.
>>
>> There are a few other threads on this...
>>
>>> I can believe that this change hasn't negatively affected performance,
>>> but the result is misleading. I also think it's pushing the boundaries
>>> of what a back-port to stable should do.
> 
> FWIW, I think this partially just mpstat reporting something quite bogus. It
> makes no sense to say that a cpu is 100% busy waiting for IO, when the one
> process is doing IO is just waiting.

Indeed... It really just means it's spending 100% of its time _waiting_
on IO, not that it's doing anything. This is largely to save myself from
future emails on this subject, saving my own time.

>> +static bool current_pending_io(void)
>> +{
>> +	struct io_uring_task *tctx = current->io_uring;
>> +
>> +	if (!tctx)
>> +		return false;
>> +	return percpu_counter_read_positive(&tctx->inflight);
>> +}
>> +
>>  /* when returns >0, the caller should retry */
>>  static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>  					  struct io_wait_queue *iowq)
>>  {
>> -	int token, ret;
>> +	int io_wait, ret;
>>  
>>  	if (unlikely(READ_ONCE(ctx->check_cq)))
>>  		return 1;
>> @@ -2511,17 +2520,19 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>  		return 0;
>>  
>>  	/*
>> -	 * Use io_schedule_prepare/finish, so cpufreq can take into account
>> -	 * that the task is waiting for IO - turns out to be important for low
>> -	 * QD IO.
>> +	 * Mark us as being in io_wait if we have pending requests, so cpufreq
>> +	 * can take into account that the task is waiting for IO - turns out
>> +	 * to be important for low QD IO.
>>  	 */
>> -	token = io_schedule_prepare();
>> +	io_wait = current->in_iowait;
> 
> I don't know the kernel "rules" around this, but ->in_iowait is only
> modified in kernel/sched, so it seemed a tad "unfriendly" to scribble
> on it here...

It's either that or add new helpers for this, at least for the initial
one. Calling blk_flush_plug() (and with async == true, no less) is not
something we need or want to do.

So we could add an io_schedule_prepare_noflush() for this, but also
seems silly to add a single use helper for that imho.

> Building a kernel to test with the patch applied, will reboot into it
> once the call I am on has finished. Unfortunately the performance
> difference didn't reproduce nicely in VM...

Thanks!

-- 
Jens Axboe

