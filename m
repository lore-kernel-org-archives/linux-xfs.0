Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B03BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 00:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359642AbiFWAue (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 20:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237587AbiFWAud (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 20:50:33 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDDD2AC5E
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 17:50:31 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k12-20020a17090a404c00b001eaabc1fe5dso993190pjg.1
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 17:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hCnyRyRjzk8DADp1qb3IgyvoAVy2J0edojYwRmYBh68=;
        b=AvJSSjxvborSxb6EJTrdIKT/iaP46rFLZqshkq+Tc9/BZG6ZjvR1RWlkoz9eKmwb+a
         MKQim0qrvEl7aHfugLLvia+gxjAHCZmSYRs9smWzPv5ZhQGjS+lqzulnylSG55Gh0Lf1
         K2nuzQiE3eH3a11ONSogawryHGzm8DmBUdek7ax7paxg43PtICAXMi+MzzokXFlldO2+
         xNWQa+xSyTFqKH0Z4s9ipHajsTGAWjRDlqRZyotRKa5C5Sb4tjNlLo18gQgXKUBZ6WWj
         26F1hJci3FfoQpYImE1+WpLcKKSrXrhrJMj3nR6wbBheM10OCPt9R3Gyib41yywwdT2v
         F0yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hCnyRyRjzk8DADp1qb3IgyvoAVy2J0edojYwRmYBh68=;
        b=LjyHu/wH5BlcYfiAVKVDtfzB/TtGsvzewMFoyUzIPk5asieRMb5sxCJPBb6pvmUKaH
         eUWzBmUlcUnFc0EL6hH9Mn5dHd/C97lLM2ZmjQBLdPDPFpMceE63coPbJe8i8I1WGoQe
         UI+h1IOKS6+kIkMWoAGvus7SHLJwY1F4ygQAWXLSLNB4u9MqWmXWyiBPYwJWgaQDcfMD
         jJ1+cgJyWcj00Fv6vjrxxvwyZy65CncJqfPrwfymQdmmUyR02cezveKpaIaXddKu0kNY
         NCT+JcpJRuhaiEze5KVIdINBCp/xSmouGvjhTwidlAA7lc8HKZAZfUWPNaFHMwFS4/xL
         7TsA==
X-Gm-Message-State: AJIora9+mWsIKWkjkSHB9A4wjtadI09cavpBUBY+Bqsh80m+aFs3tnNL
        yhZBaE5Aun7mZ+8JB34ssT3bKA==
X-Google-Smtp-Source: AGRyM1t6rtuE5DrAjHU7n06TIhxfsDwPMJVPgI3IoHgAeTiJ5hhKICpJWIetBdYDZJhK52Tj7RM7yg==
X-Received: by 2002:a17:902:d4c8:b0:16a:480b:b79c with SMTP id o8-20020a170902d4c800b0016a480bb79cmr6004566plg.15.1655945431198;
        Wed, 22 Jun 2022 17:50:31 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t66-20020a637845000000b004088f213f68sm14001919pgc.56.2022.06.22.17.50.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 17:50:30 -0700 (PDT)
Message-ID: <30b0adb6-a5f2-b295-50d2-e182f9dc9ef0@kernel.dk>
Date:   Wed, 22 Jun 2022 18:50:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v9 00/14] io-uring/xfs: support async buffered writes
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-mm@kvack.org, kernel-team@fb.com, linux-xfs@vger.kernel.org,
        io-uring@vger.kernel.org, shr@fb.com,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com,
        hch@infradead.org, jack@suse.cz, willy@infradead.org
References: <20220616212221.2024518-1-shr@fb.com>
 <165593682792.161026.12974983413174964699.b4-ty@kernel.dk>
 <YrO0AP4y3OGUjnXE@magnolia>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YrO0AP4y3OGUjnXE@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/22/22 6:29 PM, Darrick J. Wong wrote:
> On Wed, Jun 22, 2022 at 04:27:07PM -0600, Jens Axboe wrote:
>> On Thu, 16 Jun 2022 14:22:07 -0700, Stefan Roesch wrote:
>>> This patch series adds support for async buffered writes when using both
>>> xfs and io-uring. Currently io-uring only supports buffered writes in the
>>> slow path, by processing them in the io workers. With this patch series it is
>>> now possible to support buffered writes in the fast path. To be able to use
>>> the fast path the required pages must be in the page cache, the required locks
>>> in xfs can be granted immediately and no additional blocks need to be read
>>> form disk.
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [01/14] mm: Move starting of background writeback into the main balancing loop
>>         commit: 29c36351d61fd08a2ed50a8028a7f752401dc88a
>> [02/14] mm: Move updates of dirty_exceeded into one place
>>         commit: a3fa4409eec3c094ad632ac1029094e061daf152
>> [03/14] mm: Add balance_dirty_pages_ratelimited_flags() function
>>         commit: 407619d2cef3b4d74565999a255a17cf5d559fa4
>> [04/14] iomap: Add flags parameter to iomap_page_create()
>>         commit: 49b5cd0830c1e9aa0f9a3717ac11a74ef23b9d4e
>> [05/14] iomap: Add async buffered write support
>>         commit: ccb885b4392143cea1bdbd8a0f35f0e6d909b114
>> [06/14] iomap: Return -EAGAIN from iomap_write_iter()
>>         commit: f0f9828d64393ea2ce87bd97f033051c8d7a337f
> 
> I'm not sure /what/ happened here, but I never received the full V9
> series, and neither did lore:
> 
> https://lore.kernel.org/linux-fsdevel/165593682792.161026.12974983413174964699.b4-ty@kernel.dk/T/#t

Huh yes, didn't even notice that it's missing a few.

> As it is, I already have my hands full trying to figure out why
> generic/522 reports file corruption after 20 minutes of running on
> vanilla 5.19-rc3, so I don't think I'm going to get to this for a while
> either.
> 
> The v8 series looked all right to me, but ********* I hate how our
> development process relies on such unreliable **** tooling.  I don't

Me too, and the fact that email is getting worse and worse is not making
things any better...

> think it's a /great/ idea to be pushing new code into -next when both
> the xfs and pagecache maintainers are too busy to read the whole thing
> through... but did hch actually RVB the whole thing prior to v9?

Yes, hch did review the whole thing prior to v9. v9 has been pretty
quiet, but even v8 didn't have a whole lot. Which is to be expected for
a v9, this thing has been going for months.

We're only at -rc3 right now, so I think it's fine getting it some -next
exposure. It's not like it's getting pushed tomorrow, and if actual
concerns arise, let's just deal with them if that's the case. I'll check
in with folks before anything gets pushed certainly, I just don't think
it's fair to keep stalling when there are no real objections. Nothing
gets pushed unless the vested parties agree, obviously.

-- 
Jens Axboe

