Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22515C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 08:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346087AbiCPI4W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 04:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345549AbiCPI4V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 04:56:21 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E036C2C13C
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 01:55:06 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id d10so2632391eje.10
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 01:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=X5ydxHYWOblptVZ8H1Fz1lofwwdpSFjGxBAnmiGiHLk=;
        b=FnRLt5jVmDX7Dd8wvlpoWFAY4tP9Z8De96sJkjakkBktgdGHaQYRKRADo9NCwm9y+o
         6HEYWVpEncHGW2mH11LMSdWK5QKyM1rU4N2wYM1/ITPoKBTYABTw2of8tNXE/Sb76t9m
         hdsCxs6feS5JNDJNEAxU9DKrlipXHgxQ6gnBj23vGUZ5OtWmev+HLv5trzN6ZJNkpq+i
         qFNtvxDMe2l4/AS3jKs8pKvmm/N7pBOQSfe1e+0KpDlKsFZz0ejj3PJGGPucxPQ11Iu7
         iIPDLW11DA2jX2qUCc7NeHUTda+InI4J4BpBthblOmpXlXyTe8XFSv3hv93/3kqhKS1H
         yTKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=X5ydxHYWOblptVZ8H1Fz1lofwwdpSFjGxBAnmiGiHLk=;
        b=hzNxK865qqup4GQKqwsMg+Ekdlr5H1+b1+lbHG4pHoC3RcB//FpcJLSHT0yZ/4UDlk
         xu+eBrI6XtF3z2bnTMGoZ5ZSGKNf8Rl4ekQYalsuXZ0FyfKEGgZ41e7i8A9uq8lcjwXv
         1s6lTTNBGiXmF9AksEYWdRMvUepl565xFhe1SuwqEFk1g3b1ioFRmH/Lr28RkbOPkJ8x
         xuHYZ8JlNxBOtEpgsFhh4mh3mWihDLDZ4s3K2PySXBZCWuGgAjNuJ2Cjm0iKfPRNwZ6g
         DDjO5RnWxU4PWjgd0Lp5jbZBPE+Sc9lQvda/Zb08ERkssSVfR5RxjejKmJ27mSVIWcM6
         t9nw==
X-Gm-Message-State: AOAM5335iRN2LXJfyuaUwd5tBfviqE+UQjXBNVE/nNzla/60MM/k6HKG
        bSBwAhxRzShpSWF9ebl7ZMNg9O5qHGS9LA==
X-Google-Smtp-Source: ABdhPJzzPSm72xIG67kVYsKfeoTBPYIJuqLRJON8e09/V+vZnGhbvBXgJyiCchr+OwSGKxKB8ZPU7w==
X-Received: by 2002:a17:907:6eac:b0:6db:9dc7:9c0e with SMTP id sh44-20020a1709076eac00b006db9dc79c0emr21008302ejc.18.1647420905410;
        Wed, 16 Mar 2022 01:55:05 -0700 (PDT)
Received: from ?IPV6:2003:d9:9706:b800:c31b:4649:aab0:e4be? (p200300d99706b800c31b4649aab0e4be.dip0.t-ipconnect.de. [2003:d9:9706:b800:c31b:4649:aab0:e4be])
        by smtp.googlemail.com with ESMTPSA id js24-20020a170906ca9800b006c8aeca8fe8sm607915ejb.58.2022.03.16.01.55.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 01:55:05 -0700 (PDT)
Message-ID: <3242ad20-0039-2579-b125-b7a9447a7230@colorfullife.com>
Date:   Wed, 16 Mar 2022 09:55:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: Metadata CRC error detected at
 xfs_dir3_block_read_verify+0x9e/0xc0 [xfs], xfs_dir3_block block 0x86f58
Content-Language: en-US
From:   Manfred Spraul <manfred@colorfullife.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org,
        "Spraul Manfred (XC/QMM21-CT)" <Manfred.Spraul@de.bosch.com>
References: <613af505-7646-366c-428a-b64659e1f7cf@colorfullife.com>
 <20220313224624.GJ3927073@dread.disaster.area>
 <8024317e-07be-aa3d-9aa3-2f835aaa1278@colorfullife.com>
In-Reply-To: <8024317e-07be-aa3d-9aa3-2f835aaa1278@colorfullife.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On 3/14/22 16:18, Manfred Spraul wrote:
> Hi Dave,
>
> On 3/13/22 23:46, Dave Chinner wrote:
>> OK, this test is explicitly tearing writes at the storage level.
>> When there is an update to multiple sectors of the metadata block,
>> the metadata will be inconsistent on disk while those individual
>> sector writes are replayed.
>
> Thanks for the clarification.
>
> I'll modify the test application to never tear write operations and 
> retry.
>
> If there are findings, then I'll distribute them.
>
I've modified the test app, and with 4000 simulated power failures I 
have not seen any corruptions.


Thus:

- With teared write operations: 2 corruptions from ~800 simulated power 
failures

- Without teared write operations: no corruptions from ~4000 simulated 
power failures.

But:

I've checked the eMMC specification, and the spec allows that teared 
write happen:

JESD84-B51A, chapter 6.6.8.1:

> All of the sectors being modified by the write operation that was interrupted may be in one of the following states: all sectors contain new data, all sectors contain old data or some sectors contain new data and some sectors contain old data.
"some sectors contain new data and some sectors contain old data".

NVM also appears to allow tearing for writes larger than a certain size 
(and the size is 2 kB in the example in the spec, and one observed 
corruption happened when tearing a 20 kB write that crosses a 32kB boundary)

NVMe-NVM-Command-Set-Specification-1.0a-2021.07.26-Ratified, Chapter 
2.1.4.2AWUPF/NAWUPF

> If a write command is submitted with size greater than the 
> AWUPF/NAWUPF value or crosses an atomic
> boundary, then there is no guarantee of the data returned on 
> subsequent reads of the associated logical
> blocks.


Is my understanding correct that XFS support neither eMMC nor NVM devices?
(unless there is a battery backup that exceeds the guarantees from the spec)


--

     Manfred

