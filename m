Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BC5C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Oct 2021 14:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8C9261002
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Oct 2021 14:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhJRO6y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Oct 2021 10:58:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232967AbhJRO6x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Oct 2021 10:58:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634569002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1JPKJW9jmQFNl0DEesDHaYLU1Ump6fI10AQwea/MLp8=;
        b=ENoGwxJ+lTTgDaEIs7laPg6ta181vdQEC8HmUqLkU1DF9TmqbXQ8hTnLR5mxUgF989kgLo
        BZcfqqv08cT87TJA+UUiJ5spLXqfVav6601V60paI2LdHshXtaZasg+0rf1vT05E7kLJvg
        1vFp3MFP4MtVCqvfFH/q97U+Ipdbe1o=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-a7h4HEBwNEetITMclWTO6Q-1; Mon, 18 Oct 2021 10:56:41 -0400
X-MC-Unique: a7h4HEBwNEetITMclWTO6Q-1
Received: by mail-io1-f70.google.com with SMTP id s18-20020a5d9a12000000b005ddc91c47f4so10916980iol.14
        for <linux-xfs@vger.kernel.org>; Mon, 18 Oct 2021 07:56:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=1JPKJW9jmQFNl0DEesDHaYLU1Ump6fI10AQwea/MLp8=;
        b=hwFMSxI4+55y22hRRQKLC4E4bQ7RJAZGW5yg/fvBz/N6X/lA683VPC4mWctXmv1vqz
         8DWrtacYiTlp6CE3o9+bsGw0kLoPO6Mg3VcuZZCFINEQoAA742tBdJN/iZSgLkxrO41S
         5P9NKp5zjICh2DPW1WqwOcxUFlZLwOKQYBxl95O6+xOJpilBDAVNUZDXwVbzfS8NQrPI
         mpDScwW0217o3YNEq8jwnb0Jtt44IkQ9uw/KZGH1pXLxEP9ASapLev9PMr46P9comY8P
         gqJ6brLGbXImkAZbbjhdIduct0z8sqNdgq4MgWsUSy5Sto921lW94xz4oiQDI8bOrCfJ
         3M+A==
X-Gm-Message-State: AOAM5327LfSEJnssi2UDpoZs7T7Wde6hu36Mo3oIKv4jcwCUDme1HryR
        sPI52BQF8z6saEPV1Xxq4ujd3KEw83T7V/0xmECkBkNuCEHe45r10sI1cG6JGyxBu9RfnzFp8U6
        tKjrNaLvAiNzX4CPyImyA
X-Received: by 2002:a05:6638:ac6:: with SMTP id m6mr210914jab.28.1634569000269;
        Mon, 18 Oct 2021 07:56:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz27cutu0MISFDBgB30Irb26Sq/ur8bLqjjY/WDqeaIzVIZjtjfulgI06LMsT39U655JTqjFQ==
X-Received: by 2002:a05:6638:ac6:: with SMTP id m6mr210890jab.28.1634568999960;
        Mon, 18 Oct 2021 07:56:39 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id n17sm7265813ile.76.2021.10.18.07.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 07:56:39 -0700 (PDT)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <c686231d-f478-2737-793f-ae618e50b2ce@redhat.com>
Date:   Mon, 18 Oct 2021 09:56:38 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [ANNOUNCE] xfsprogs for-next rebased to b4c6731a
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>
References: <40ae0dd3-aeea-344c-ac6b-e76b42892e86@sandeen.net>
 <d162a7f8-4101-6021-684b-275f894454be@sandeen.net>
 <20211016041017.GS24307@magnolia>
 <20211016062943.GX2361455@dread.disaster.area>
In-Reply-To: <20211016062943.GX2361455@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/16/21 1:29 AM, Dave Chinner wrote:
> On Fri, Oct 15, 2021 at 09:10:17PM -0700, Darrick J. Wong wrote:
>> On Fri, Oct 15, 2021 at 03:32:41PM -0500, Eric Sandeen wrote:
>>> On 10/15/21 2:42 PM, Eric Sandeen wrote:
>>>> Hi folks,
>>>>
>>>> The for-next branch of the xfsprogs repository at:
>>>>
>>>>       git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
>>>>
>>>> has just been updated.
>>>>
>>>> Patches often get missed, so please check if your outstanding
>>>> patches were in this update. If they have not been in this update,
>>>> please resubmit them to linux-xfs@vger.kernel.org so they can be
>>>> picked up in the next update.
>>>>
>>>> This is really just the libxfs-5.14 sync (finally!).  Big thanks
>>>> to chandan, djwong, dchinner who all helped significantly with what
>>>> was a much more challenging libxfs sync this time.
>>>>
>>>> Odds are this will be the bulk of the final 5.14 release. I will just
>>>> add Darrick's deprecation warning, and anything else I get reminded
>>>> of in the next week.  :)
>>>
>>> I missed Derrick's "libxfs: fix crash on second attempt to initialize library"
>>> because my old userspace rcu library did not exhibit the problem. :/
>>>
>>> Rather than leave a few dozen commits with regressed behavior as a bisect bomb,
>>> I have force-pushed and anybody who pulled in the last hour will need to rebase.
>>> Sorry about that!
>>
>> Er... /me notices the following discrepancy between the kernel and
>> xfsprogs in libxfs/xfs_shared.h:
>>
>> --- a/libxfs/xfs_shared.h
>> +++ b/libxfs/xfs_shared.h
>> @@ -174,24 +174,4 @@ struct xfs_ino_geometry {
>>   
>>   };
>>   
>> -/* Faked up kernel bits */
>> -struct rb_root {
>> -};
>> -
>> -#define RB_ROOT                (struct rb_root) { }
>> -
>> -typedef struct wait_queue_head {
>> -} wait_queue_head_t;
>> -
>> -#define init_waitqueue_head(wqh)       do { } while(0)
>> -
>> -struct rhashtable {
>> -};
>> -
>> -struct delayed_work {
>> -};
>> -
>> -#define INIT_DELAYED_WORK(work, func)  do { } while(0)
>> -#define cancel_delayed_work_sync(work) do { } while(0)
>> -
>>   #endif /* __XFS_SHARED_H__ */
> 
> Shouldn't those be libxfs/libxfs_priv.h along with all the other
> faked up kernel bits?

IIRC that doesn't work but I don't remember why - has to do w/ the ag code move,
and use in userspace IIRC. And TBH I forgot that "xfs_shared" was uhhhh actually
shared with the kernel and failed to check.

I'll figure something out.  Tired of pushing this stuff from file to file,
subdir to subdir ... was trying to avoid libfrog.

But thanks for noticing, Darrick - and sorry for missing it.

-Eric

