Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50BD5C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 21:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240797AbiEXVNJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 17:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbiEXVNI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 17:13:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72A7753E34
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 14:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653426786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DJjs4N/WDLSZMajK/IEiJU5M1LfX92grmiSyImpG9YI=;
        b=gre5BSMEBJ2p1GyA9MjCl4oOU/y3+Ax1iB4bXaGSGCLAvQZSXb8nFQHhslYMV28HF4a/Ty
        O5m4DAv6taT78xS/8R5Ey0DjhgDkuEu2UwKPslcSeYWyIh5kgGJKGm+M7DOJ2QMnu16jlF
        XKDpo1DCRAuPlYJIObpBEAjY9GhRqAE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-bv79HRYbP5aFenvS2YhDvg-1; Tue, 24 May 2022 17:13:04 -0400
X-MC-Unique: bv79HRYbP5aFenvS2YhDvg-1
Received: by mail-wm1-f69.google.com with SMTP id l16-20020a05600c1d1000b003974df9b91cso1855580wms.8
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 14:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DJjs4N/WDLSZMajK/IEiJU5M1LfX92grmiSyImpG9YI=;
        b=T2aWQxMtINWCLaa3JCaYjTRfQ4Car/HntQpzblBpLDU7cYqmx9XRuDaCWEwp/GjflA
         UVdLJkCS3VrzPA4OhCyG6yOiu48Z5yYG0wovwHSnN+ZzFGJpVveUoohM/K17sxeiG9NY
         nbEFY6uD6nXs9YnGUZ0Amcx/6E+GakvPP/unAkTqFdz1jvsmZ2RoAxAEvi4DveJ1VNNW
         MN6qE3pK4zSUuNcofYJ/LHkLdtosgd7Kk8oJ9zDDjsPbbxGLGg0xorIza/TBtm0f7otp
         0lHPGmp54gyT7Am2sXQxg8KlfIOOrH5aypQh4f87+cdRY9l58eaUkXk6CxEFZXePtmRy
         wgcw==
X-Gm-Message-State: AOAM532oh7snxpT7yZeJ7fayzphFYyXTUGEVs9OCT1L6VQrDLeY0m716
        h6Gg/VviBDZcQNCvUwTyfpdHeI3RPgXhqGs/Zh6yqj09CWKNT8KvcERvCbNdJk/rQaTud6111Z7
        c/Oua6H8iG1M+S5gg3bxM
X-Received: by 2002:a05:6000:160d:b0:20f:fb59:849e with SMTP id u13-20020a056000160d00b0020ffb59849emr1294230wrb.47.1653426783214;
        Tue, 24 May 2022 14:13:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPqzqr0vfQWAigwZf9mwRaeaOBt+ZkKvhPRYiVUrLw+djjuAIkmRdwGuhsfIdfCHYElA246g==
X-Received: by 2002:a05:6000:160d:b0:20f:fb59:849e with SMTP id u13-20020a056000160d00b0020ffb59849emr1294223wrb.47.1653426783001;
        Tue, 24 May 2022 14:13:03 -0700 (PDT)
Received: from [192.168.100.69] (gw19-pha-stl-mmo-1.avonet.cz. [131.117.213.203])
        by smtp.gmail.com with ESMTPSA id c124-20020a1c3582000000b003973ea7e725sm25917wma.0.2022.05.24.14.13.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 14:13:02 -0700 (PDT)
Message-ID: <aca7a3d7-8808-fa79-8124-06950c6065eb@redhat.com>
Date:   Tue, 24 May 2022 23:13:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] mkfs: Fix memory leak
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20220524204040.954138-1-preichl@redhat.com>
 <Yo1I5N1IMXdHKUcw@magnolia> <Yo1JPr6yvQGzUNBB@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
In-Reply-To: <Yo1JPr6yvQGzUNBB@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 5/24/22 23:08, Darrick J. Wong wrote:
> On Tue, May 24, 2022 at 02:06:44PM -0700, Darrick J. Wong wrote:
>> On Tue, May 24, 2022 at 10:40:40PM +0200, Pavel Reichl wrote:
>>> 'value' is allocated by strup() in getstr(). It
>> Nit: strdup, not strup.
>>
>>> needs to be freed as we do not keep any permanent
>>> reference to it.
>>>
>>> Signed-off-by: Pavel Reichl <preichl@redhat.com>
>> With that fixed,
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>>
>> --D
>>
>>> ---
>>>   mkfs/xfs_mkfs.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>>> index 01d2e8ca..a37d6848 100644
>>> --- a/mkfs/xfs_mkfs.c
>>> +++ b/mkfs/xfs_mkfs.c
>>> @@ -1714,6 +1714,7 @@ naming_opts_parser(
>>>   		} else {
>>>   			cli->sb_feat.dir_version = getnum(value, opts, subopt);
>>>   		}
>>> +		free((char *)value);
> ...well, that, and the ^^^^ cast here isn't necessary.
>
> --D

Hi,

thanks for the comment, but w/o the cast I get this warning

xfs_mkfs.c:1717:22: warning: passing argument 1 of ‘free’ discards 
‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
  1717 |                 free(value);
       |                      ^~~~~
In file included from ../include/platform_defs.h:16,
                  from ../include/libxfs.h:11,
                  from xfs_mkfs.c:7:
/usr/include/stdlib.h:555:25: note: expected ‘void *’ but argument is of 
type ‘const char *’
   555 | extern void free (void *__ptr) __THROW;

>
>>>   		break;
>>>   	case N_FTYPE:
>>>   		cli->sb_feat.dirftype = getnum(value, opts, subopt);
>>> -- 
>>> 2.36.1
>>>

