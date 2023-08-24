Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CF6C27C40
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 02:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239232AbjHXCHF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 22:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239285AbjHXCGx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2023 22:06:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3F9E59
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 19:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692842763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9AhJYemSabRZGTHMyDMbNTsnBBvHU+KuxQkFRN+gD98=;
        b=fgfwmmPE52XMWH7nIT0AqNsIdnCUQCvSZPK6uEQDnwuTKV2hn3+H4SZrrmP0wArzwmBdF4
        r8u2FciXRHlKLaelm/O99DhA2rd1l87Io/bP4hPlSr/j/3AvGSfoeWD5gyWbrP0A0rKQGe
        erpyK0+1R6ntVU6Q5q4ZKQ0YRKHFytw=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-PovB-BgAPNOxXGHXmYiu_w-1; Wed, 23 Aug 2023 22:06:01 -0400
X-MC-Unique: PovB-BgAPNOxXGHXmYiu_w-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3a337ddff03so7074127b6e.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 19:06:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692842761; x=1693447561;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9AhJYemSabRZGTHMyDMbNTsnBBvHU+KuxQkFRN+gD98=;
        b=TOvgL3SGXKgcNoc1nNASEa3tHs/Glwj65y8dfpuWfUDzLoZM3MOeMJLQhJg7S87RWE
         P9cdEcEVsuXpNQORy3Xu5Tk20wThwM2i8UXR0v3zO/5vdVwP5RfzcefK1LmHGm2xPIkY
         czTp0Cy4x9sjS4/n8FmJENBcCRBYzoYUWdcp7cPH/65O2SeYX3KxcuEDBRTjr3nJMT18
         l+krtzGaGUZe4rwkiFi2wjdr68YFzWSbqmFiEZ0J42NX70SwVtHUtaLAMs5xDsr2EJ7r
         Zqs4K27vXK8ajp38C9Ald+XmSbnQeJMlofyrDY7nYfZPmKVd6461JSqCw4cLHhq3+Il6
         J2cg==
X-Gm-Message-State: AOJu0YznziNfTtZVwvgNs1+mjAHwFyRw1qhlCvPeHqp0/mPLmKo/N00E
        ysjIpZASexoD/d0yKBg+EcIma/pcJVlCEIE7lDdzDtQpQ8Sg3pFXQeT8+/xr8N3R81XO+Vosty9
        0Higw3sM9fIqOvq0WzzkJlixUFZnu
X-Received: by 2002:a05:6808:1a1e:b0:3a7:3100:f8b9 with SMTP id bk30-20020a0568081a1e00b003a73100f8b9mr20654439oib.31.1692842760992;
        Wed, 23 Aug 2023 19:06:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqVi8we0VMuQLaNayBKOmsOc4mI5MzkW34Jagiw+Xywla2Lw4myoxAdGpemYWkA4g602mZGg==
X-Received: by 2002:a05:6808:1a1e:b0:3a7:3100:f8b9 with SMTP id bk30-20020a0568081a1e00b003a73100f8b9mr20654429oib.31.1692842760760;
        Wed, 23 Aug 2023 19:06:00 -0700 (PDT)
Received: from ?IPV6:2001:8003:4b08:fb00:e45d:9492:62e8:873c? ([2001:8003:4b08:fb00:e45d:9492:62e8:873c])
        by smtp.gmail.com with ESMTPSA id e5-20020aa78c45000000b00666912d8a52sm6826313pfd.197.2023.08.23.19.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Aug 2023 19:06:00 -0700 (PDT)
Message-ID: <d30c4aa2-713d-7799-209e-fb708e891ffd@redhat.com>
Date:   Thu, 24 Aug 2023 12:05:56 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to a86308c98
Content-Language: en-US
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     Carlos Maiolino <carlos@maiolino.me>, linux-xfs@vger.kernel.org
References: <20230802094128.ptcuzaycy3vzzovk@andromeda>
 <3d263b27-fa53-81c0-a711-aefffa2ef354@redhat.com>
In-Reply-To: <3d263b27-fa53-81c0-a711-aefffa2ef354@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 23/8/23 13:05, Donald Douwsma wrote:
> 
> 
> On 2/8/23 19:41, Carlos Maiolino wrote:
>> Hello.
>>
>> The xfsprogs for-next branch, located at:
>>
>> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next
>>
>> Has just been updated.
>>
>> Patches often get missed, so if your outstanding patches are properly 
>> reviewed on
>> the list and not included in this update, please let me know.
>>
> 
> Its a minor one, but the unit test for xfs_repair progress reporting[1] 
> depends on
> 
> xfs_repair: always print an estimate when reporting progress
> https://lore.kernel.org/linux-xfs/20230531064143.1737591-1-ddouwsma@redhat.com/
> 
> [1] [PATCH v4] xfstests: add test for xfs_repair progress reporting
> https://lore.kernel.org/linux-xfs/20230610063855.gg6cd7bh5pzyobhe@zlang-mailbox/
> 
> 
>> The new head of the for-next branch is commit:
>>
>> a86308c98d33e921eb133f47faedf1d9e62f2e77
>>
>> 2 new commits:
>>
>> Bill O'Donnell (1):
>>        [780e93c51] mkfs.xfs.8: correction on mkfs.xfs manpage since 
>> reflink and dax are compatible
> 
> Mmm, this reminds me, sparse inodes have been the default for a while 
> now, I thought someone was going to submit a patch to update the 
> manpage, but I cant see it anywhere.
> 

Nevermind, it was in 6.3
  [965f91091] mkfs: fix man's default value for sparse option

> - Don
> 
>>
>> Wu Guanghao (1):
>>        [a86308c98] xfs_repair: fix the problem of repair failure 
>> caused by dirty flag being abnormally set on buffer
>>
>> Code Diffstat:
>>
>>   man/man8/mkfs.xfs.8.in | 7 -------
>>   repair/scan.c          | 2 +-
>>   2 files changed, 1 insertion(+), 8 deletions(-)

