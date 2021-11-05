Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769B8C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 16:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 464D661252
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 16:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbhKEQO1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Nov 2021 12:14:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233968AbhKEQO1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Nov 2021 12:14:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636128706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iDJfY0ihWtVwG9LjlBxTp1DA6C0ooOsqaQIHR6f+2d0=;
        b=jDaQEkkO4WkEW8cTA3i2BkB+tbOGywcFmDvYqQOb39HvRwu77y2DArjLTBziFIQkqhJOvO
        /jcqzmPY9P7DJFkGV3QF68SKToP4Io7BJ+JZVg+KIu3kjzodE1v1qJ7jdyk8f9xlEO2poo
        I3UdEBVEcO5s+IY941X4GJ6MN4fNN0g=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-51BWy0krM7eOHmK70eomeQ-1; Fri, 05 Nov 2021 12:11:45 -0400
X-MC-Unique: 51BWy0krM7eOHmK70eomeQ-1
Received: by mail-il1-f199.google.com with SMTP id r13-20020a92440d000000b002498d6b85c1so6358668ila.5
        for <linux-xfs@vger.kernel.org>; Fri, 05 Nov 2021 09:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=iDJfY0ihWtVwG9LjlBxTp1DA6C0ooOsqaQIHR6f+2d0=;
        b=ycJzUZqZuf1j1z22JNK130C8xo2c5gUJmkRDm3KK/QmZe45dFybowMWhRNyzflM+GG
         392hFv4B+XMepiTsW+z+khvzg1JNN9yTRKh33VakV3c4nIkG9DfoL+LdxmFlvh/NqGCe
         cwrMSNaVQ/5m61dljeHcNd0cZhFYMo5Tik06gutXmfWK8ErGR1KrZMVGyx8Xcu5qyaNe
         7pgZk6wDG/h7C46xE0eANTIF98a+i41tRcn7Dy7afMmJXtTMbllNkaOobRbHhYwW5yaZ
         PfVCNlonCeHTAcv/O1Xc6J6KSp75ixFN+vnJ3BuyG9Koxgv9gVZ/7hJwZ1Z7FE00JA2e
         L4ZA==
X-Gm-Message-State: AOAM533FGhlLMXgvho/nGOBfTIoPQx2YiDiuydxp8YYUqik24D6DyQHl
        rjYil+57NXe5zkdx/s7njMOd4Z1WCnoS5JnJf1LkRJmxvimX+Wru9fq92ZZF+Sfmlt649MAqvN1
        QKmnbLK8ut105JiFxxOII
X-Received: by 2002:a05:6e02:1d02:: with SMTP id i2mr10593847ila.182.1636128703017;
        Fri, 05 Nov 2021 09:11:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2qw6H/GlD6n/5bPdFU8R2vLOtQxnBg6/83do0XOr3ncfjRJTwftkgjb6NTKBwfrFcTvUwUg==
X-Received: by 2002:a05:6e02:1d02:: with SMTP id i2mr10593831ila.182.1636128702838;
        Fri, 05 Nov 2021 09:11:42 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id z11sm4579692ilb.11.2021.11.05.09.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 09:11:42 -0700 (PDT)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <48920430-e48b-0531-2627-0efee9845a1c@redhat.com>
Date:   Fri, 5 Nov 2021 11:11:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: XFS / xfs_repair - problem reading very large sparse files on
 very large filesystem
Content-Language: en-US
To:     Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        Eric Sandeen <esandeen@redhat.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
References: <20211104090915.GW32555@pcnci.linuxbox.cz>
 <39784566-4696-2391-a6f5-6891c2c7802b@sandeen.net>
 <20211105141343.GH32555@pcnci.linuxbox.cz>
 <20211105141719.GI32555@pcnci.linuxbox.cz>
 <6af37cfb-1136-6d07-45a0-c0494b64b0d7@redhat.com>
 <20211105155914.GJ32555@pcnci.linuxbox.cz>
In-Reply-To: <20211105155914.GJ32555@pcnci.linuxbox.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/5/21 10:59 AM, Nikola Ciprich wrote:
>>>
>>> here's the output if it is of some use:
>>>
>>> https://storage.linuxbox.cz/index.php/s/AyZGW5Xdfxg47f6
>>
>> Just to be clear - I think Dave and I interpreted your original email slightly
>> differently.
>>
>> Are these large files on the 1.5PB filesystem filesystem images themselves,
>> or some other type of file?
>>
>> And - the repair you were running was against the 1.5PB filesystem?
>>
>> (see also Dave's reply in this thread)
>>
> Hello Eric,
> 
> I was running fsck on the 1.5PB fs (I interrupted it, as it doesn't seem
> to be the main problem now). Large files are archives of videofiles from camera
> streaming software, I don't know much about them, I was told at the beginning
> that all writes will be sequential, which apparently are not, so for new
> files, we'll be preallocating them.

ok, thanks for the clarification.

Though I've never heard of streaming video writes that weren't sequential ...
have you actually observed that via strace or whatnot?

What might be happening is that if you are streaming multiple files into a single
directory at the same time, it competes for the allocator, and they will interleave.

XFS has an allocator mode called "filestreams" which was designed just for this
(video ingest).

If you set the "S" attribute on the target directory, IIRC it should enable this
mode.  You can do that with the xfs_io "chattr" command.

Might be worth a test, or wait for dchinner to chime in on whether this is a
reasonable suggestion...

-Eric

> btw blocked read from file I sent backtrace seems to have started finally (after
> maybe an hour) and runs 8-20MB/s

