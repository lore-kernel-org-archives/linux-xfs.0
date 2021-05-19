Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A5EC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 14:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2635861002
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 14:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347139AbhESOOv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 10:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347124AbhESOOu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 10:14:50 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D51BC06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 07:13:29 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id y184-20020a1ce1c10000b02901769b409001so3431193wmg.3
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 07:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=F1uHj1sY3bif8fDQ1vUSxLLQOsCnGsqmIKuxItWP5SE=;
        b=SDA0dOzGVO+57kjNrjJvQNP1xKWe1BPMgFM9LOB60TBGNsZruo26eZNVXQqHe09Wyh
         t3YEDBwQS7nNB1xn9iJx8liHXnOFRK2JiAxiWSDZmd0y2ICBe0XzbJMM27m7C4SUQ3mu
         vTwkFi8o8/S48uFCjBnplHtzTETQR9EHC8t3XNRux0bH+1PsALWdCxh/yfztwXYCDoKj
         4vfbQDwTnryp2WQTliveGOceQ94Hg4RgVC2Z5C9umWFF3RgOi+xYwuw2KRaukYTlDn8q
         5EcLldNa9cFNt2eOyYdEbGWwfhZhm6l/gvIk70K66a+C3/1G3PH9v28xbGCgNBSLKwPX
         ISNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=F1uHj1sY3bif8fDQ1vUSxLLQOsCnGsqmIKuxItWP5SE=;
        b=qlJOnAGsirqVnSoqNgoH/u79YL5mPv4/UaoTGblw8LJtxq3birjKiPcsNue62u/oY7
         Uw/XidklIPfM6Aw17wzZw3r1749zzgo/1xL137Ww7HrHRwIT4qM3uy0896UHsUF6dbmG
         PZtROLu5YVb0WJa6eHQ5PCLJNYKXet1U1NcsHfymorD6aWLxdq7TTPtmCTavxmfLJ860
         dzXIMV9MfNlHpvdAG+LjhI9Q8VpqfBHT5EhY38lhlfucifzxZcKbwLGjg3JVcCgSIf6O
         E1IphHpt8pB9n0dWfx3j/HA+2H/MfrxABdHHPq0mEFlSy2U9cvpu0WfGKcK909dOD7ob
         FiWA==
X-Gm-Message-State: AOAM530BLc1mU2UqoKPheonirJvUhSozeNooyA+nL7xOR9kbO5EpN8Bs
        az3c8MewTWy31uMGmmDGBlpGpw==
X-Google-Smtp-Source: ABdhPJxk+UI+VUW6asY9NMngA528APjLs2XsUer7iCT6Z9lvFyaeGL+Kw3GXszS2nh/Snl9Wx61CBA==
X-Received: by 2002:a05:600c:19cc:: with SMTP id u12mr7608624wmq.178.1621433607809;
        Wed, 19 May 2021 07:13:27 -0700 (PDT)
Received: from avi.scylladb.com (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id h9sm20842196wmb.35.2021.05.19.07.13.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 07:13:27 -0700 (PDT)
Subject: Re: How capacious and well-indexed are ext4, xfs and btrfs
 directories?
To:     Dave Chinner <david@fromorbit.com>
Cc:     David Howells <dhowells@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <djwong@kernel.org>, Chris Mason <clm@fb.com>,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org
References: <206078.1621264018@warthog.procyon.org.uk>
 <20210517232237.GE2893@dread.disaster.area>
 <ad2e8757-41ce-41e3-a22e-0cf9e356e656@scylladb.com>
 <20210519125743.GP2893@dread.disaster.area>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
Message-ID: <c5d83b86-321e-349b-303c-b6027bcd9ae1@scylladb.com>
Date:   Wed, 19 May 2021 17:13:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210519125743.GP2893@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 19/05/2021 15.57, Dave Chinner wrote:
> On Wed, May 19, 2021 at 11:00:03AM +0300, Avi Kivity wrote:
>> On 18/05/2021 02.22, Dave Chinner wrote:
>>>> What I'd like to do is remove the fanout directories, so that for each logical
>>>> "volume"[*] I have a single directory with all the files in it.  But that
>>>> means sticking massive amounts of entries into a single directory and hoping
>>>> it (a) isn't too slow and (b) doesn't hit the capacity limit.
>>> Note that if you use a single directory, you are effectively single
>>> threading modifications to your file index. You still need to use
>>> fanout directories if you want concurrency during modification for
>>> the cachefiles index, but that's a different design criteria
>>> compared to directory capacity and modification/lookup scalability.
>> Something that hit us with single-large-directory and XFS is that
>> XFS will allocate all files in a directory using the same
>> allocation group.  If your entire filesystem is just for that one
>> directory, then that allocation group will be contended.
> There is more than one concurrency problem that can arise from using
> single large directories. Allocation policy is just another aspect
> of the concurrency picture.
>
> Indeed, you can avoid this specific problem simply by using the
> inode32 allocator - this policy round-robins files across allocation
> groups instead of trying to keep files physically local to their
> parent directory. Hence if you just want one big directory with lots
> of files that index lots of data, using the inode32 allocator will
> allow the files in the filesytsem to allocate/free space at maximum
> concurrency at all times...


Perhaps a directory attribute can be useful in case the filesystem is 
created independently of the application (say by the OS installer).


>
>> We saw spurious ENOSPC when that happened, though that
>> may have related to bad O_DIRECT management by us.
> You should not see spurious ENOSPC at all.
>
> The only time I've recall this sort of thing occurring is when large
> extent size hints are abused by applying them to every single file
> and allocation regardless of whether they are needed, whilst
> simultaneously mixing long term and short term data in the same
> physical locality.


Yes, you remember well.


>   Over time the repeated removal and reallocation
> of short term data amongst long term data fragments the crap out of
> free space until there are no large contiguous free spaces left to
> allocate contiguous extents from.
>
>> We ended up creating files in a temporary directory and moving them to the
>> main directory, since for us the directory layout was mandated by
>> compatibility concerns.
> inode32 would have done effectively the same thing but without
> needing to change the application....


It would not have helped the installed base.


>> We are now happy with XFS large-directory management, but are nowhere close
>> to a million files.
> I think you are conflating directory scalability with problems
> arising from file allocation policies not being ideal for your data
> set organisation, layout and longevity characteristics.


Probably, but these problems can happen to others using large 
directories. The XFS list can be very helpful in resolving them, but 
better to be warned ahead.


