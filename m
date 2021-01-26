Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F42FC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F97720663
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731633AbhAZXDu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394233AbhAZSMt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 13:12:49 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D5AC0613D6
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jan 2021 10:12:09 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id my11so1647054pjb.1
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jan 2021 10:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=H6klVWmwpbGvIBE8XxiMeYeDlbdj0w7FBJf05BgWvl4=;
        b=uFmSU1V8WA5+3XsjZ1CtIR7PuRTQhgJ9z6MnAteUaZMkk4iPXC6GsdqbieR6Luq1A3
         r+KUn57EtAA35viiRWkb2gnJgLsigsJ63UUR7m3FhcfBj9mxzKWVgG29L8wEmsgo4z0n
         IpTMy5fqcnaduJOMsHZ/7ZjESJ+7c1/DceO3dVRnTfStZ9e9rqdAhUdrbyvZZTGXIwl2
         PiwqmzEmLhOKpaLPYcNT+mw7q5DbgoY1m6U2lCnhuNrMCpUJaq/js5RLzDxHez2N0emD
         jg5SyU7tfo62gCJVJuLUIcNVI6O2P+o5P4LOFT+CtpCmIm6AfrZBbThEm9ZJO4t94FZu
         Deig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=H6klVWmwpbGvIBE8XxiMeYeDlbdj0w7FBJf05BgWvl4=;
        b=F5g/V1py5h18c6Lk3CC2KOuQd41CGXYtZBEDzNPpor496pK7meFyeZIINTGwGPYUB5
         4asSR+hxKWYO6adfrSRHY5CLOz0QPTePtj4YhfXBT2edEcAOR6RyKVUycG6A2TUq0qGc
         L7k2+VKjkjv4bh+urNZRnT1ZGYTRlGcvweCIOEI5g3A88JqkvQPjZv16KwJYBnKJla4f
         SAxL38empPaKGXrtXuXkdQiSt7EHjIxiAEDHW1qhZ9RpsS2S7HYLgJGmu5CeXEfNu7eP
         ENKI8c/VKygPGEKepM1/Ybmq3ftccMy3HMSAWmEMRFe1vp5M5InRuemjiqx5BKuYrNbq
         9BaQ==
X-Gm-Message-State: AOAM530CrDkaMtkOWPF1cerWuE9sOVQOa5D7rdmZEvp7OvzQ0nPKuWDN
        gd4SbYi9qR6icNAVf3WBUOM=
X-Google-Smtp-Source: ABdhPJwngnNUR+V+HmVbnWzsv4F/FQK9r/hRKXUnpTSVDr6KucWLHHgyNPh8okEB4r0tQ8KkKPWkIQ==
X-Received: by 2002:a17:90b:1905:: with SMTP id mp5mr1015264pjb.205.1611684728836;
        Tue, 26 Jan 2021 10:12:08 -0800 (PST)
Received: from garuda ([122.167.33.191])
        by smtp.gmail.com with ESMTPSA id m4sm19605757pfa.53.2021.01.26.10.12.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Jan 2021 10:12:08 -0800 (PST)
References: <20210125095809.219833-1-chandanrlinux@gmail.com> <20210126175855.GW7698@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH 1/2] xfsprogs: xfs_fsr: Interpret arguments of qsort's compare function correctly
In-reply-to: <20210126175855.GW7698@magnolia>
Date:   Tue, 26 Jan 2021 23:42:04 +0530
Message-ID: <87mtwvtvnv.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 Jan 2021 at 23:28, Darrick J. Wong wrote:
> On Mon, Jan 25, 2021 at 03:28:08PM +0530, Chandan Babu R wrote:
>> The first argument passed to qsort() in fsrfs() is an array of "struct
>> xfs_bulkstat". Hence the two arguments to the cmp() function must be
>> interpreted as being of type "struct xfs_bulkstat *" as against "struct
>> xfs_bstat *" that is being used to currently typecast them.
>> 
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>  fsr/xfs_fsr.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>> 
>> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
>> index 77a10a1d..635e4c70 100644
>> --- a/fsr/xfs_fsr.c
>> +++ b/fsr/xfs_fsr.c
>> @@ -702,9 +702,8 @@ out0:
>>  int
>>  cmp(const void *s1, const void *s2)
>>  {
>> -	return( ((struct xfs_bstat *)s2)->bs_extents -
>> -	        ((struct xfs_bstat *)s1)->bs_extents);
>> -
>> +	return( ((struct xfs_bulkstat *)s2)->bs_extents -
>> +	        ((struct xfs_bulkstat *)s1)->bs_extents);
>
> It might be a good idea to check bs_version here to avoid future
> maintainer screwups <coughs this maintainer>
>

Sure, I will write a new patch to add that.

> Thanks for catching this,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>

-- 
chandan
