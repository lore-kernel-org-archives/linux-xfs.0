Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAEC0C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 16:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C47FE604E9
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 16:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241289AbhIPQ1H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 12:27:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26687 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235318AbhIPQZK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 12:25:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631809429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z5Y9NOu5otUa5L7UN3zKLDiFgCIaYof6Ct86IIfujPA=;
        b=WaCQ1oErslNh1RY2+doxYO3VrOnT46Vq+8g3pF3LWZ7uMakM3L2WVmwGRCD4kwiZZ4w9U3
        kDAo+8oy035nl8TSXRssJdJkZZKUtKd88i0K2tCQHsXqU2CH3Yvnc47p3zwV+4NChIld4H
        icqkL8LOmdyrhLuvi4wmAYGOhHLVoyM=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-5UkpuKx4M3-qfAT61IrzMg-1; Thu, 16 Sep 2021 12:23:48 -0400
X-MC-Unique: 5UkpuKx4M3-qfAT61IrzMg-1
Received: by mail-io1-f69.google.com with SMTP id g14-20020a6be60e000000b005b62a0c2a41so12922358ioh.2
        for <linux-xfs@vger.kernel.org>; Thu, 16 Sep 2021 09:23:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z5Y9NOu5otUa5L7UN3zKLDiFgCIaYof6Ct86IIfujPA=;
        b=B8vvm3V5YC3U3goUAmWkIPq/eQCn7trQ9nJYinnNwoLzkGHZHFu/aJI+PjxN8ZKwbQ
         pjxmS5w9vMBqMJ4/rG82ANU5AAeTwpDT/xdOa541nEM8FXdU8b3yP9jC/Gj4ddaBDjf2
         y6wuNU+k5V+KHZLHgb8laGfx5jrgfb+cP7oSXN75AiMBkr/hagrWX4zhF9e44LFDMnKU
         GNCRaJOSnUEVzgRjRDCB9S3U6wEnwSUeY2W0KgJ3B9i/vue0Wq05YCxVfsEohhUDeVXi
         +pspF9e8xcLi4JsxvkXDecjXAaQrRyEz82kyi78Y0eA/b85H3AXHyweTtP1ooxIvnxaR
         24Zw==
X-Gm-Message-State: AOAM5326GKk65P1uJclE49zK4aZPZmsEcIgSDuveWTsGskqtHfJoQs0E
        glBuUn9rXUjcvLo+pg0hcVFhpWQB9e/EDBsB3iYVQ37CHizObPHGzWD+USfSvGSW4q7QiXL+gaR
        3bRcXVUm+NorhfIdg+nKR94GcsMQE4dvZsLPh9zW9ouHt9eQCnDxKmgT41X4PNAZoHea35gL7
X-Received: by 2002:a5d:8894:: with SMTP id d20mr4963819ioo.4.1631809427436;
        Thu, 16 Sep 2021 09:23:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIy90EKoXrjLBVRNXB9VwsyVzFypSlUstYBnAylRj3LD3uuQjDkyRaNsLNHBBWNuGx0xVuCQ==
X-Received: by 2002:a5d:8894:: with SMTP id d20mr4963800ioo.4.1631809427100;
        Thu, 16 Sep 2021 09:23:47 -0700 (PDT)
Received: from liberator.local (h114.53.19.98.static.ip.windstream.net. [98.19.53.114])
        by smtp.gmail.com with ESMTPSA id o18sm1933325ilh.52.2021.09.16.09.23.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 09:23:46 -0700 (PDT)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 03/61] libfrog: create header file for mocked-up kernel
 data structures
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174721123.350433.6338166230233894732.stgit@magnolia>
 <20210916004646.GO2361455@dread.disaster.area>
Message-ID: <e2da1b2f-cc3a-aa32-a4da-eeda3af70f92@redhat.com>
Date:   Thu, 16 Sep 2021 11:23:45 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210916004646.GO2361455@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/15/21 7:46 PM, Dave Chinner wrote:
> On Wed, Sep 15, 2021 at 04:06:51PM -0700, Darrick J. Wong wrote:
>> From: Darrick J. Wong <djwong@kernel.org>
>>
>> Create a mockups.h for mocked-up versions of kernel data structures to
>> ease porting of libxfs code.
>>
>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   include/libxfs.h     |    1 +
>>   libfrog/Makefile     |    1 +
>>   libfrog/mockups.h    |   19 +++++++++++++++++++
>>   libxfs/libxfs_priv.h |    4 +---
>>   4 files changed, 22 insertions(+), 3 deletions(-)
> 
> I don't really like moving this stuff to libfrog. The whole point of
> libxfs/libxfs_priv.h is to define the kernel wrapper stuff that
> libxfs needs to compile and should never be seen by anything outside
> libxfs/...

I had the same reaction to seeing these in libfrog/ TBH.

IIRC adding this all to libxfs_priv.h caused me problems, though I don't
remember exactly why.  I had more luck creating a new header file in
include/mockups.h, and then I had to include /that/ in both libxfs.h
and libxfs_priv.h. I don't remember how I ended up like that... but
without the libxfs.h include, I ended up with:

In file included from ../include/libxfs.h:73:0,
                  from topology.c:7:
../libxfs/xfs_ag.h:75:2: error: unknown type name 'spinlock_t'
   spinlock_t pag_state_lock;
   ^

I do think that more functionally-named, separate header files might
be good, rather than just "dump more stuff in libxfs_priv.h" because
it's getting to be quite the junk drawer. ;)

But I see Dave may have a grander plan than that ;)


-Eric

> Indeed, we -cannot- use spinlocks in userspace code, so I really
> don't see why we'd want to make them more widely visible to the
> userspace xfsprogs code...
> 
> Cheers,
> 
> Dave.
> 

