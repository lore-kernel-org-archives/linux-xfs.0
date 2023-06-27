Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9452FEB64D9
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jun 2023 18:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjF0Ske (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jun 2023 14:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjF0Skc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2023 14:40:32 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461EEE71
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 11:40:28 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e9e14a558f8ab-3458211a731so19938175ab.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 11:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687891227; x=1690483227;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n8+SpkcOHO0RavgrK9DG6Xu61QPv4FuCO2sMEhUYGEs=;
        b=UBZjYxsaIbY14re975yxEimEEOCGTJKlgvgEtfL1PGnXdIOqsvYV1WSeNdgrg8igLp
         hV0KWzoCInTAleasZQ8j6cEshMcZrD2KeGVSz9mTRkaXcMCnxlxnDTwJWKQhDS6iqzbR
         hnmxXKMV68WagfVbMoX1paRAoDPT+HntmL65524G7Xx9YRpdBrS2NR6krrzyNZdxuJxm
         RPsSF+Yg4d2IKdWlpag5lOkenrSYLh7NFexJvZJLYevXgMSgXiF2w0mw+agiLINXlDcC
         GY3FXaj4dFlUWTWySizgqrO+Z6V/Eu7kQQKlybHOR2ic4e3ATbpzW+Kg6f5YABBXmXOp
         /UEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687891227; x=1690483227;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n8+SpkcOHO0RavgrK9DG6Xu61QPv4FuCO2sMEhUYGEs=;
        b=cVHuF2lhExTacU43+m1KtjImpf6gDU/VZAJU0ynOjPnrH9B7N6tFt8dWh5aA9ifrus
         GxkgQ5EeiHVP1a25CoRW9hshyNr+cK4D2UelnSuMTkg/tB2mtmOnMtVPzKj8Ct9LzInQ
         MsxtZlMm3VJnpo6aLX0ImKmGarEDM7C5xfw4vHBUFFmRh8WYckxqJW2m3MictpohwLWa
         ThkNUkD/cnznvmjeckhXp/BT8HeZ57qUa26+7sH50u1rly71TDcRTBwTQAZId/ym2bY8
         NzLHqRAZpe20RJ9MxhBG5A/qb6eB50Qu6cuxy+HG2j2oq2GF2xqJ+JPQl8hMIo4Gy8C7
         JKaA==
X-Gm-Message-State: AC+VfDxW9fxx655gbkyhPAhxGkz0fheIfisxDk8sDfK9G8SCSeVj0ukP
        ygK0mai89PU1QZZcmXrOERW3+H7K8tciiw==
X-Google-Smtp-Source: ACHHUZ6buLuh+SRGVJA8eKdir4Ti3q+fPClnT6BjGxq5a5rTSMsOlqn7RZWzTrfJEDZ1fA6J1YvKiw==
X-Received: by 2002:a92:c68c:0:b0:345:a806:fa16 with SMTP id o12-20020a92c68c000000b00345a806fa16mr8054029ilg.10.1687891227483;
        Tue, 27 Jun 2023 11:40:27 -0700 (PDT)
Received: from ?IPV6:2606:4700:110:8939:3cc4:589f:70ed:f5b0? ([2a09:bac0:1000:a2::4:2ed])
        by smtp.gmail.com with ESMTPSA id p38-20020a634f66000000b005535ddd8dcfsm6079046pgl.89.2023.06.27.11.40.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 11:40:26 -0700 (PDT)
Message-ID: <dcbdc718-fec4-286f-468b-eed61749dd63@gmail.com>
Date:   Tue, 27 Jun 2023 11:40:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Question on the xfs inode slab memory
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <CAMj1M42L6hH9weqroQNaWu_SG+Yg8NrAuzgNO1b8jiWPJ2M-5A@mail.gmail.com>
 <ZHfhYsqln68N1HyO@dread.disaster.area>
 <7572072d-8132-d918-285c-3391cb041cff@gmail.com>
 <ZHkRHW9Fd19du0Zv@dread.disaster.area>
 <b9c528fd-9556-12c5-4628-4163c070e45d@gmail.com>
 <ZH/pk1UYR7BrT78b@dread.disaster.area>
Content-Language: en-US
From:   Jianan Wang <wangjianan.zju@gmail.com>
In-Reply-To: <ZH/pk1UYR7BrT78b@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Sorry for the late response. No, we actually did not get OOM kill issue in a small-scale testing phase when we try to stress the filesystem i/o. We plan to roll out to larger cluster for scale-testing. Could you please help advice if we need to reformat the xfs volume to take effect or we could simply upgrade the kernel module and expect it to work?

Best Regards.

Jianan.

On 6/6/23 19:21, Dave Chinner wrote:
> On Tue, Jun 06, 2023 at 04:00:56PM -0700, Jianan Wang wrote:
>> Hi Dave,
>>
>> Just to follow up on this. We have performed the testing using the
>> Ubuntu 20.04 with 5.15 kernel as well as our custom built xfs 5.9,
>> but we still see significant slab memory build-up during the
>> process.
> That's to be expected. Nothing has changed with respect to inode
> cache size management. All the changes were to how the XFS inode
> cache gets reclaimed.  Are you getting OOM killer reports when under
> memory pressure on 5.15 like you originally reported for the 5.4
> kernel you were running?
>
> Cheers,
>
> Dave.
