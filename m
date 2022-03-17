Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE712C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 16:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbiCQQLK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 12:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiCQQLJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 12:11:09 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE85E9C92
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 09:09:52 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id r13so11758491ejd.5
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 09:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9S1dj2ozMzQZPZTJBZ9QOWNEopJf5uJI85XYX/uBfag=;
        b=182KBuCWak8O+g8Rl6RNSgeEqNHI9LYnjdqg+VdV08kK4IlAyJV/U7NHQyAuwGDQiz
         EEtE4rSTsHlcAxLqFmkjFozt/TBsjZe9VJbxdkxBmBQyxpst/YgP6h/5m01AlrK80oqN
         HnAX51X1P9KWI8NT6YvI1lDXksp2id77VYTAZ7oAmyZLzG8c8BLn/eWQhKfQVfaWnSis
         S/9G5Oitc0PplQwYbXUYk9XjEbt70/K2mh6PzXpFxyHpRzyWXzFZFGqrJCuX416WfjwP
         a86SEfYJO3h1NOKdXltk1zymLH+Z2k0iYpMZ+QVcmP8kP2msWpkl+QQGDuO/mtC4L0iv
         mbmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9S1dj2ozMzQZPZTJBZ9QOWNEopJf5uJI85XYX/uBfag=;
        b=P+7eBsd9Ju1Ew8SDmo2/w2dRBLJ57rDcXg28XfjxhNjeDubdBahdT7ySFFwVE7Nx7H
         yagO6ly9mYY5AjuEKgR1SL1pgISxzaHewwW4K5ng4DSuTB8RN4cZjLqRZGlrF0AyoX0j
         DHhxo3sh9/qtDDDuWRkoKJKJ3Qy/zEE2bWJ7peYkDo63KkvVbOA/97UelVrQJsF7/6Gm
         78x2suS7YXVEL+8u8ivC9jXHRlJba1TVZgaP4CKc2YJjQ+XYD9njVzMbkLEC3Z0P1+l2
         gkmrASCDcrYKGExWvd2QKybZlzdEe47LeQrbnpjNA04hVOA6JTd6MIwx+L5waT7GKjI5
         qqKQ==
X-Gm-Message-State: AOAM531+wwZl3UVz0+OwuBe2F0+HQPlko03HGTqXGuVs8vmqpNc7pg5O
        8+oHuiWGLyIfRY1ny0vF8cdICw==
X-Google-Smtp-Source: ABdhPJzNaMWzre8p1B2ALVIBRlMiHcj9iKefth7xRNPC6dN4FEpILFFbGqNS+Jr1vu+vqLONASYdtg==
X-Received: by 2002:a17:906:6144:b0:6cf:bb2e:a2e1 with SMTP id p4-20020a170906614400b006cfbb2ea2e1mr5139031ejl.299.1647533391104;
        Thu, 17 Mar 2022 09:09:51 -0700 (PDT)
Received: from ?IPV6:2003:d9:970a:1500:3685:1631:4fc4:d41f? (p200300d9970a1500368516314fc4d41f.dip0.t-ipconnect.de. [2003:d9:970a:1500:3685:1631:4fc4:d41f])
        by smtp.googlemail.com with ESMTPSA id x12-20020a50d9cc000000b0040f70fe78f3sm2963091edj.36.2022.03.17.09.09.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 09:09:50 -0700 (PDT)
Message-ID: <fb6facca-9028-8249-470c-af75318e9fb7@colorfullife.com>
Date:   Thu, 17 Mar 2022 17:09:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: Metadata CRC error detected at
 xfs_dir3_block_read_verify+0x9e/0xc0 [xfs], xfs_dir3_block block 0x86f58
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        "Spraul Manfred (XC/QMM21-CT)" <Manfred.Spraul@de.bosch.com>
References: <613af505-7646-366c-428a-b64659e1f7cf@colorfullife.com>
 <20220313224624.GJ3927073@dread.disaster.area>
 <8024317e-07be-aa3d-9aa3-2f835aaa1278@colorfullife.com>
 <3242ad20-0039-2579-b125-b7a9447a7230@colorfullife.com>
 <20220317024705.GY3927073@dread.disaster.area>
 <20220317030828.GZ3927073@dread.disaster.area>
 <21c13283-2a9f-4978-25e4-228e44ab74e6@colorfullife.com>
 <20220317082411.GA3927073@dread.disaster.area>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <20220317082411.GA3927073@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On 3/17/22 09:24, Dave Chinner wrote:
> On Thu, Mar 17, 2022 at 07:49:02AM +0100, Manfred Spraul wrote:
>> Hi Dave,
>>
>> [+Ted as the topic also applies to ext4]
>>
>> On 3/17/22 04:08, Dave Chinner wrote:
>>> On Thu, Mar 17, 2022 at 01:47:05PM +1100, Dave Chinner wrote:
>>>> On Wed, Mar 16, 2022 at 09:55:04AM +0100, Manfred Spraul wrote:
>>>>> Hi Dave,
>>>>>
>>>>> On 3/14/22 16:18, Manfred Spraul wrote:
>>>>>
>>>>> But:
>>>>>
>>>>> I've checked the eMMC specification, and the spec allows that teared write
>>>>> happen:
>>>> Yes, most storage only guarantees that sector writes are atomic and
>>>> so multi-sector writes have no guarantees of being written
>>>> atomically.  IOWs, all storage technologies that currently exist are
>>>> allowed to tear multi-sector writes.
>>>>
>>>> However, FUA writes are guaranteed to be whole on persistent storage
>>>> regardless of size when the hardware signals completion. And any
>>>> write that the hardware has signalled as complete before a cache
>>>> flush is received is also guaranteed to be whole on persistent
>>>> storage when the cache flush is signalled as complete by the
>>>> hardware. These mechanisms provide protection against torn writes.
>> My plan was to create a replay application that randomly creates disc images
>> allowed by the writeback_cache_control documentation.
>>
>> https://www.kernel.org/doc/html/latest/block/writeback_cache_control.html
>>
>> And then check that the filesystem behaves as expected/defined.
> We already have that tool that exercises stepwise flush/fua aware
> write recovery for filesystem testing: dm-logwrites was written and
> integrated into fstests years ago (2016?) by Josef Bacik for testing
> btrfs recovery, but it was a generic solution that all filesystems
> can use to test failure recovery....
>
> See, for example, common/dmlogwrites and tests/generic/482 - g/482
> uses fsstress to randomly modify the filesystem while dm-logwrites
> records all the writes made by the filesystem. It then replays them
> one flush/fua at a time, mounting the filesystem to ensure that it
> can recover the filesystem, then runs filesystem checkers to ensure
> that the filesystem does not have any corrupt metadata. Then it
> replays to the next flush/fua and repeats.
>
> tools/dm-logwrite-replay provides a script and documents the
> methodology to run step by step through replay of g/482 failures to
> be able to reliably reproduce and diagnose the cause of the failure.
>
> There's no need to re-invent the wheel if we've already got a
> perfectly good one...

Thanks a lot for the hint!

I was thinking were a replay tool might exist and came up with nbd. 
Feedback was that it doesn't exist so I wrote something.

I didn't think about dm.

I'll look at dm-log-writes.

>>>>> Is my understanding correct that XFS support neither eMMC nor NVM devices?
>>>>> (unless there is a battery backup that exceeds the guarantees from the spec)
>>>> Incorrect.
>>>>
>>>> They are supported just fine because flush/FUA semantics provide
>>>> guarantees against torn writes in normal operation. IOWs, torn
>>>> writes are something that almost *never* happen in real life, even
>>>> when power fails suddenly. Despite this, XFS can detect it has
>>>> occurred (because broken storage is all too common!), and if it
>>>> can't recovery automatically, it will shut down and ask the user to
>>>> correct the problem.
>> So for xfs the behavior should be:
>>
>> - without torn writes: Mount always successful, no errors when accessing the
>> content.
> Yes.
>
> Of course, there are software bugs, so mounts, recovery and
> subsequent repair testing can still fail.
>
>> - with torn writes: There may be error that will be detected only at
>> runtime. The errors may at the end cause a file system shutdown.
> Yes, and they may even prevent the filesystem from being mounted
> because recovery trips over them (e.g. processing pending unlinked
> inodes or replaying incomplete intents).
>
>> (commented dmesg is attached)
>>
>> The application I have in mind are embedded systems.
>> I.e. there is no user that can correct something, the recovery strategy must
>> be included in the design.
> Good luck with that - storage hardware fails in ways that no
> existing filesystem can recover automatically from 100% of the time.
> And very few even attempt to do so because it is largely an
> impossible requirement to fulfil. Torn writes are just the tip of
> the iceberg....
Yes :-(

--

     Manfred

