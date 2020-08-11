Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB09C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 01:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 919FC20716
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 01:07:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="HPy/Q52k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgHKBHM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Aug 2020 21:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbgHKBHL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Aug 2020 21:07:11 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF80C06174A
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2020 18:07:11 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t6so994753pjr.0
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2020 18:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wcepStmCPaQyHKG02HsJpqi/Mpfioo21JYLEfTzpgWU=;
        b=HPy/Q52k7cex+vGoX9ZF+Y5PGkUDobfFVtR7QrmVyrnT6U2FRg/su/ygPtQZ1VzKrX
         NhpJJNA6p6ycgrZnir/h+kfL5MIGymPWn8qP/bBIZOTmnVP4DRA9fhiWc6cX9kJwAobN
         vbylhpzbcfcQeBji44di032VlK2CBsnMB5XmvI2LklF9Eahy9pJ5iYEru8yxjd6hwuyD
         5b28R7emuUbmd3g05m/koht+6vRY6860OeZYy+XZTRjGYp5l5zQ+Oh8PYP68nGpSl2it
         Xs2FjjLD4G+IZanm5qlYj79UlKN2DUGooxfpfuhorhmNHp4GgO2Dt682VWC2aubWfkM8
         BLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wcepStmCPaQyHKG02HsJpqi/Mpfioo21JYLEfTzpgWU=;
        b=jMc5BYDXWM9ZZUPn9EoH5koHxdLU6Ig/j1dS+loKmWxmhya2R1D3og16Whm3fJQEJc
         pyd1mrsprUFOlTu/gQSm7fL7pHrhwPqCGleSSRa12CCBXdwMwkYac6P5wxMBhYUwaYH8
         F/KWu8f85KpYDnQCoZGoxj9ji2qn8xc4A8zDy2LKqZUdng+rmoFJplIMPfW3kSArqJ+B
         hK/OpJQH/9xfz6ysbmg1YQ8dFJFfQyY0EsvptGiIFfTrX0DF9mXT5A4RhX0j/Cim+fxT
         hDGRZxm9Wshfz1rJM46mKTOfCaeRqhaczP7mtYEvFsjQViXoY+arZzQ8a10dzozZ8Www
         FfYQ==
X-Gm-Message-State: AOAM530+7SlRJ4o7+G7HayS92PMonaBK+uVEEQoH/nFaeIwQKv5EYWc1
        kvSAklyxPqIyHBSVJaonElNgZwh6zww=
X-Google-Smtp-Source: ABdhPJx7dnZFf8bIGo/WyufmYzL9goinurugMDAsiRpNMqd/CcQTlkNURq2zP1nIAsXAayFw4uuS/A==
X-Received: by 2002:a17:902:a982:: with SMTP id bh2mr1288922plb.182.1597108029993;
        Mon, 10 Aug 2020 18:07:09 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s18sm5228432pgj.3.2020.08.10.18.07.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 18:07:09 -0700 (PDT)
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
To:     Dave Chinner <david@fromorbit.com>,
        bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
References: <bug-208827-201763@https.bugzilla.kernel.org/>
 <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
 <20200810000932.GH2114@dread.disaster.area>
 <20200810035605.GI2114@dread.disaster.area>
 <20200810070807.GJ2114@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d35b95df-2d0e-e402-251c-4da4bc254f66@kernel.dk>
Date:   Mon, 10 Aug 2020 19:07:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200810070807.GJ2114@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/10/20 1:08 AM, Dave Chinner wrote:
> [cc Jens]
> 
> [Jens, data corruption w/ io_uring and simple fio reproducer. see
> the bz link below.]
> 
> On Mon, Aug 10, 2020 at 01:56:05PM +1000, Dave Chinner wrote:
>> On Mon, Aug 10, 2020 at 10:09:32AM +1000, Dave Chinner wrote:
>>> On Fri, Aug 07, 2020 at 03:12:03AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
>>>> --- Comment #1 from Dave Chinner (david@fromorbit.com) ---
>>>> On Thu, Aug 06, 2020 at 04:57:58AM +0000, bugzilla-daemon@bugzilla.kernel.org
>>>> wrote:
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=208827
>>>>>
>>>>>             Bug ID: 208827
>>>>>            Summary: [fio io_uring] io_uring write data crc32c verify
>>>>>                     failed
>>>>>            Product: File System
>>>>>            Version: 2.5
>>>>>     Kernel Version: xfs-linux xfs-5.9-merge-7 + v5.8-rc4
>>>
>>> FWIW, I can reproduce this with a vanilla 5.8 release kernel,
>>> so this isn't related to contents of the XFS dev tree at all...
>>>
>>> In fact, this bug isn't a recent regression. AFAICT, it was
>>> introduced between in 5.4 and 5.5 - 5.4 did not reproduce, 5.5 did
>>> reproduce. More info once I've finished bisecting it....
>>
>> f67676d160c6ee2ed82917fadfed6d29cab8237c is the first bad commit
>> commit f67676d160c6ee2ed82917fadfed6d29cab8237c
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Mon Dec 2 11:03:47 2019 -0700
>>
>>     io_uring: ensure async punted read/write requests copy iovec

I don't think this commit is related to the issue at all, but I think
we're probably on the same page with that. It's probably just changing
things slightly enough to avoid the race.

> Ok, I went back to vanilla 5.8 to continue debugging and adding
> tracepoints, and it's proving strangely difficult to reproduce now.
> 
> However, I did just hit this:
> 
> [ 4980.136032] ------------[ cut here ]------------
> [ 4980.137665] do not call blocking ops when !TASK_RUNNING; state=1 set at [<00000000ef911b51>] prepare_to_wait_exclusive+0x3d/0xd0
> [ 4980.141403] WARNING: CPU: 13 PID: 6800 at kernel/sched/core.c:6888 __might_sleep+0x74/0x80
> [ 4980.143940] CPU: 13 PID: 6800 Comm: fio Not tainted 5.8.0-dgc+ #2549
> [ 4980.146147] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
> [ 4980.148774] RIP: 0010:__might_sleep+0x74/0x80
> [ 4980.150455] Code: ff 41 5c 41 5d 41 5e 5d c3 48 8b 90 30 22 00 00 48 c7 c7 a8 b9 50 82 c6 05 38 e4 9a 01 01 48 8b 70 10 48 89 d1 e8 fa 5c fc ff <0f> 0b eb c5 0f 1f 84 00 00 00 002
> [ 4980.156255] RSP: 0018:ffffc90005383c58 EFLAGS: 00010282
> [ 4980.158299] RAX: 0000000000000000 RBX: 0000561a18122000 RCX: 0000000000000000
> [ 4980.160817] RDX: ffff88883eca7de0 RSI: ffff88883ec97a80 RDI: ffff88883ec97a80
> [ 4980.163162] RBP: ffffc90005383c70 R08: ffff88883ec97a80 R09: ffff8888070f3000
> [ 4980.165635] R10: ffff8888070f3434 R11: ffff8888070f3434 R12: ffffffff8251f46e
> [ 4980.168115] R13: 00000000000001ba R14: 0000000000000000 R15: ffff888235647740
> [ 4980.170714] FS:  00007f80de7af700(0000) GS:ffff88883ec80000(0000) knlGS:0000000000000000
> [ 4980.173442] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 4980.175371] CR2: 00007f80d4005008 CR3: 00000005eb01c004 CR4: 0000000000060ee0
> [ 4980.177607] Call Trace:
> [ 4980.178583]  change_protection+0x827/0x9e0
> [ 4980.180063]  ? kvm_clock_read+0x18/0x30
> [ 4980.181654]  ? kvm_sched_clock_read+0x9/0x20
> [ 4980.183426]  ? sysvec_apic_timer_interrupt+0x46/0x90
> [ 4980.185160]  change_prot_numa+0x19/0x30
> [ 4980.186607]  task_numa_work+0x1c7/0x2e0
> [ 4980.188003]  task_work_run+0x64/0xb0
> [ 4980.189488]  io_cqring_wait+0x118/0x290

I'll get this one:

commit 4c6e277c4cc4a6b3b2b9c66a7b014787ae757cc1
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Jul 1 11:29:10 2020 -0600

    io_uring: abstract out task work running

queued up for stable. Should not be related to this at all, current -git
shouldn't run into this.

-- 
Jens Axboe

