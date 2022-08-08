Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE29DC00140
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Aug 2022 17:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243301AbiHHRh3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Aug 2022 13:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236004AbiHHRh1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Aug 2022 13:37:27 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490EC13E8B
        for <linux-xfs@vger.kernel.org>; Mon,  8 Aug 2022 10:37:27 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id z3so7031791qtv.5
        for <linux-xfs@vger.kernel.org>; Mon, 08 Aug 2022 10:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=nJWYXnuVn04pyUVFY8F7wsNOJfSWUigbE1m0b0OdOyY=;
        b=TCMdXOTs8IZAJbqDe6locfenWIt80GvYTLMIUo+cGGrdRsTGQ2AoXtFeXzk9xPft0a
         5DrbOfQ3WHd39z5B2+fPQVWksLe+MIJ44YixAHm3cbL57WzpJDqgVQk8AHGOx0xuIdjl
         GzJBfYosxmzpPNWkpLivqxL+Pdt+3kwit/izdouPIHuj8+8/cVpLSt6BoDC6ZwZhfQaA
         pNdBIcqp6gmA4k6yyNm9OLXyGgJ4ps/pZvE9ryx1kuYCprbvPc67BurPxsC4N6CgFLBw
         Fu+3ambPA35mRd31/LK8oH/5EXqBrFofq3G+SuX1zBbzF4CFiy0s08ktediN8kyaSqCA
         /gqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=nJWYXnuVn04pyUVFY8F7wsNOJfSWUigbE1m0b0OdOyY=;
        b=HFjjxwf4YCalOC0PTQMmrytQKKSHO+r2CvmpPBQm4jHoFYazMI0R+NjdMMp4jCDn7o
         UZVXbzfZYy+b7mYEeEgAOBa8s4AkUaOL5D8sPO9aOfXwc6QW9Ayvankn/y+pixiC0XTl
         p0Z8hdpZ4gQcuSS6bH58Cd1QCOwpW83AAW/zKaihtDuBzIrqgpRRyho/Lr/wj5ru2YXT
         h7MN2rrzytv/Za3dKNVGdySJN8NPOs1rMwuWDiMss9NbifSzdzzkYAtJYhz081853hMW
         KPxwSCU0jZqwL0GRo1RbzSj2dlqTMrG6MWNBBE4UEkrnmLpd4QT4B63ZTqpyzqgs9bCk
         iZbg==
X-Gm-Message-State: ACgBeo2pkRRN5ephG3xQXCO5jvjinlICTU2nWsHiWZP5IYMSRsDVxhLl
        VKnFxtxXkS5JkQPjqKkPnxY=
X-Google-Smtp-Source: AA6agR5fxAUPkyszhui0l8Dc0y2QJ+Hv870XTtInNHISP0GXMKZjrDHua4jMQuwqUq3BJwwQHlFGLg==
X-Received: by 2002:ac8:5754:0:b0:342:eaee:2c9f with SMTP id 20-20020ac85754000000b00342eaee2c9fmr9374373qtx.670.1659980246370;
        Mon, 08 Aug 2022 10:37:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id az38-20020a05620a172600b006b8619a67f4sm9348872qkb.34.2022.08.08.10.37.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 10:37:24 -0700 (PDT)
Message-ID: <ca42e6be-3565-1f38-48ed-81bd1ad9c289@gmail.com>
Date:   Mon, 8 Aug 2022 10:37:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH] libxfs: stop overriding MAP_SYNC in publicly exported
 header files
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        xfs <linux-xfs@vger.kernel.org>,
        Fabrice Fontaine <fontaine.fabrice@gmail.com>
References: <WVSe_1J22WBxe1bXs0u1-LcME14brH0fGDu5RCt5eBvqFJCSvxxAEPHIObGT4iqkEoCCZv4vpOzGZSrLjg8gcQ==@protonmail.internalid>
 <YtiPgDT3imEyU2aF@magnolia> <20220721121128.yyxnvkn4opjdgcln@orion>
 <e6ee2759-8b55-61a9-ff6c-6410d185d35e@gmail.com> <YuQBarhgxff8Hih6@magnolia>
 <86691238-3de4-418d-5e94-981de043173e@sandeen.net>
 <14b36a0e-b567-e854-8791-0aed7af0567a@gmail.com> <YvFJpctzK/9/LsV6@magnolia>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YvFJpctzK/9/LsV6@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/8/22 10:36, Darrick J. Wong wrote:
> On Mon, Aug 08, 2022 at 10:13:06AM -0700, Florian Fainelli wrote:
>> On 8/4/22 19:11, Eric Sandeen wrote:
>>>
>>>
>>> On 7/29/22 10:48 AM, Darrick J. Wong wrote:
>>>>> Darrick, do you need to re-post, or can the maintainers pick up the patch directly?
>>>> I already did:
>>>> https://lore.kernel.org/linux-xfs/YtmB005kkkErb5uw@magnolia/
>>>>
>>>> (It's August, so I think the xfsprogs maintainer might be on vacation?
>>>> Either way, I'll make sure he's aware of it before the next release.)
>>>>
>>>> --D
>>>>
>>>
>>> Yep I was, picking it up now. Thanks for the pointer Darrick.
>>>
>>> -Eric
>>
>> Eric, any chance this could be pushed to xfsprogs-dev.git so we can take the
>> patch and submit it to buildroot, OpenWrt and other projects that depend
>> upon that build fix?
> 
> It's queued in for-next, so the git commit ids should be stable if you
> want to get that started now.
> 
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/commit/?h=for-next&id=28965957f4ea5c79fc0b91b997168c656a4426c5

Woah, sorry for not noticing, thanks!
-- 
Florian
