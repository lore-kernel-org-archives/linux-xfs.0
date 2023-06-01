Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C44C7EE23
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jun 2023 00:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjFBAAB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 20:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbjFBAAA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 20:00:00 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D53F136
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 16:59:59 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-39810ce3e13so1229134b6e.2
        for <linux-xfs@vger.kernel.org>; Thu, 01 Jun 2023 16:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685663998; x=1688255998;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rGdFBJnRBzB9KI0yFtTkzqJxzKGRYEMJxGWBQmnwssA=;
        b=l2aciU1S/EpIwmRBZeg0Lsa2euQ6u+X6GPzT8kW2wJCn0bgMvdPAwbkArdAvsFbszM
         6tQiIL/ORR6wyJab4xSOep7epDAYuhe/ofKuMWnG7tB1yyR+TlgPC9Hc901sFLxBzmZB
         u8xyCoDtpROtih6Dvpkwam20ExCaW9SKY4KmbfR04HGbuaT1W/HUq3yWIJo/f4T9QfSA
         LQLrHrRPH1As/wjdrF+g2s0wprlKgE2R3LMUgvMKnmNVUBKlmJ/bfjfYwRZphRfLyNvc
         Vwvu3jF6TV3sUV6Q3DskEDDImjlq08s9h/sRt3ekcFjHRcQcx3XmdTDFMoDh/ltqtZVm
         NbUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685663998; x=1688255998;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rGdFBJnRBzB9KI0yFtTkzqJxzKGRYEMJxGWBQmnwssA=;
        b=LeahDhm8wIvVqVp0mk4Ez+t0VcgpOokZZwOZUsRwSYZ64k9qPzTzxE0hykJugZrVF/
         5hudjOT5ptw6dzwZ3InX6Jk+w7a4Sy4tKfHHBjOCdklfnI7zoo2f/v+wT5F4VbHZzg4O
         hHsG6S5/Z9EjnSTz4lBEHXFIktcyoxhbL+2J/IO+lDPrT4RpcXgkQLdBmXaeFVjfdnGc
         EhDP7lpHU/qgyDBv2s5fx7iy08F+Apnm8bxEvbzdZq2CwZX+EqXj83HyvaV1YukUNY0E
         KQsJiJ6ShLellDRibCh3eNyPNBD31F0nxHPdx7787BTQp7n/QgUX1wg5OAhI4EmDcHfs
         +/2g==
X-Gm-Message-State: AC+VfDzJ04WGqDLEY/ljsnxILn3iXpP+i0kkn2aljXJA1w6w9W7zTyHR
        KkNNH5UDAcwdlWFu22zWwyeBuwoxY6C9oA==
X-Google-Smtp-Source: ACHHUZ4JlxwAIqhu5NdJfbv1vKojXjsdZqdN0wG7bdYOsNeTvWhINVsCWSRE2sCGSw/APDyhVlvTOA==
X-Received: by 2002:a54:4514:0:b0:398:139f:fed7 with SMTP id l20-20020a544514000000b00398139ffed7mr851725oil.8.1685663998222;
        Thu, 01 Jun 2023 16:59:58 -0700 (PDT)
Received: from ?IPV6:2606:4700:110:8939:3cc4:589f:70ed:f5b0? ([2a09:bac0:1000:a2::4:263])
        by smtp.gmail.com with ESMTPSA id k18-20020aa792d2000000b0064fe9862ec2sm5618442pfa.116.2023.06.01.16.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 16:59:57 -0700 (PDT)
Message-ID: <38595e0a-e9eb-0659-df6c-f11a72db8abd@gmail.com>
Date:   Thu, 1 Jun 2023 16:59:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Question on the xfs inode slab memory
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <CAMj1M42L6hH9weqroQNaWu_SG+Yg8NrAuzgNO1b8jiWPJ2M-5A@mail.gmail.com>
 <ZHfhYsqln68N1HyO@dread.disaster.area>
 <7572072d-8132-d918-285c-3391cb041cff@gmail.com>
 <ZHkRHW9Fd19du0Zv@dread.disaster.area>
From:   Jianan Wang <wangjianan.zju@gmail.com>
In-Reply-To: <ZHkRHW9Fd19du0Zv@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On 6/1/23 14:43, Dave Chinner wrote:
> On Wed, May 31, 2023 at 11:21:41PM -0700, Jianan Wang wrote:
>> Seems the auto-wraping issue is on my gmail.... using thunderbird should be better...
> Thanks!
>
>> Resend the slabinfo and meminfo output here:
>>
>> Linux # cat /proc/slabinfo
>> slabinfo - version: 2.1
>> # name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
> .....
>> xfs_dqtrx              0      0    528   31    4 : tunables    0    0    0 : slabdata      0      0      0
>> xfs_dquot              0      0    496   33    4 : tunables    0    0    0 : slabdata      0      0      0
>> xfs_buf           2545661 3291582    384   42    4 : tunables    0    0    0 : slabdata  78371  78371      0
>> xfs_rui_item           0      0    696   47    8 : tunables    0    0    0 : slabdata      0      0      0
>> xfs_rud_item           0      0    176   46    2 : tunables    0    0    0 : slabdata      0      0      0
>> xfs_inode         23063278 77479540   1024   32    8 : tunables    0    0    0 : slabdata 2425069 2425069      0
>> xfs_efd_item        4662   4847    440   37    4 : tunables    0    0    0 : slabdata    131    131      0
>> xfs_buf_item        8610   8760    272   30    2 : tunables    0    0    0 : slabdata    292    292      0
>> xfs_trans           1925   1925    232   35    2 : tunables    0    0    0 : slabdata     55     55      0
>> xfs_da_state        1632   1632    480   34    4 : tunables    0    0    0 : slabdata     48     48      0
>> xfs_btree_cur       1728   1728    224   36    2 : tunables    0    0    0 : slabdata     48     48      0
> There's no xfs_ili slab cache - this kernel must be using merged
> slabs, so I'm going to have to infer how many inodes are dirty from
> other slabs. The inode log item is ~190 bytes in size, so....
>
>> skbuff_ext_cache  16454495 32746392    192   42    2 : tunables    0    0    0 : slabdata 779676 779676      0
> Yup, there were - 192 byte slab, 16 million active objects. Not all
> of those inodes will be dirty right now, but ~65% of the inodes
> cached in memory have been dirty at some point. 
>
> So, yes, it is highly likely that your memory reclaim/OOM problems
> are caused by blocking on dirty inodes in memory reclaim, which you
> can only fix by upgrading to a newer kernel.

Thanks for the suggestion! Do you have any kernel version recommendation in this case? We plan to use ubuntu 20.04 with 5.15 kernel for this, and probably rebuild the xfs and install by ourselves to bypass the default ones to test xfs 5.9. Is this a good plan from your perspective?

> -Dave.
