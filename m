Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7572C282C6
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 18:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C180722DFB
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 18:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389453AbhASRtr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 12:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387536AbhASPFA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 10:05:00 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4ACC061794
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jan 2021 07:02:45 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id dj23so19315261edb.13
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jan 2021 07:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fDuqpJkn5GspgDWRB1BYrRy2qAbRAjHizmo2HBhR7pQ=;
        b=oojxFdEJj3cNOmrUEg91evcb+azGkjEvGTDw85IcPGrxnnNfAX36al7kBtqyy351u1
         EXceWK1H+jpe5lreYf/tfOloss7eGj5XdybYlfYGHMzkJTlOVmUARmqm1yhMaOFgvf6T
         HZ/YAUIO8Gu1rlKV3AJKLwS55cGAQx/YUfuY7GNaXZlwxC5TklBPGOxdea2N2bb66rEb
         H2I4aWWaXwPaOO8J3voh8b6G+8iB/9PIdl2+BJpxtiSxv1AY9Dq+3LJJFW2HukVSXIk1
         FD0DvTQfe+YI0ZA3TzpEpO8JgHIbdDVVkAoisn1DB6cHghLaZ2QzfqJR1U/5uhszp1oY
         QJzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fDuqpJkn5GspgDWRB1BYrRy2qAbRAjHizmo2HBhR7pQ=;
        b=O6J/updzipljJUpQSEQY3yf1yYrgoD8mPLN621Ypc1ZnxKxAbEGpLriVXboQZJ8sq3
         djlPXPoWpFWMzYO7EmBCaNlY3M7Z8hWzgTgM7ATMNnVToHEhjiUeXhmRIJokonWdSw5a
         BIBBdgXUfYbLDzv+EMgi2im1AOW7iFOXu9s2qgYwqqFCizbfsPmmAJAW/Os/RpcotMYj
         1ysztxOZkNw1LxuBztmAZbdyb3HOKRtChPz/ShahApbuYENP3hwhntXo3X7lPLaAGpEv
         en7hgjddH/76UD5ptN3FTBPtcrjNuBtiLpyw2njFsRdjl4MtvW930gSA5fpPl+belAAM
         Ny/A==
X-Gm-Message-State: AOAM530qnJ9luAu0frlYRL9tZX8UOiqW+V5j607NCO9X662l/M9458vJ
        y37X3PJzk5SvUoh1ODPIxc8vrsV21SsvIw==
X-Google-Smtp-Source: ABdhPJxqqsM5Cy++n/sVzIq35WJdFsUjMBlEFVb3fAwz7r+M18onZL+9OUMMEJylnM2h7rilXl4GHA==
X-Received: by 2002:a05:6402:510f:: with SMTP id m15mr3755840edd.267.1611068563062;
        Tue, 19 Jan 2021 07:02:43 -0800 (PST)
Received: from [10.100.31.37] ([109.90.143.203])
        by smtp.gmail.com with ESMTPSA id w17sm10891241ejk.124.2021.01.19.07.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 07:02:41 -0800 (PST)
Subject: Re: [PATCH v2 0/6] debian: xfsprogs package clean-up
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210116092328.2667-1-bastiangermann@fishpost.de>
 <49ecc92b-6f67-5938-af41-209a0e303e8e@sandeen.net>
From:   Bastian Germann <bastiangermann@fishpost.de>
Message-ID: <522af0f2-8485-148f-1ec2-96576925f88e@fishpost.de>
Date:   Tue, 19 Jan 2021 16:02:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <49ecc92b-6f67-5938-af41-209a0e303e8e@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-frami
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Am 18.01.21 um 22:33 schrieb Eric Sandeen:
> On 1/16/21 3:23 AM, Bastian Germann wrote:
>> Apply some minor changes to the xfsprogs debian packages, including
>> missing copyright notices that are required by Debian Policy.
>>
>> v2:
>>    resend with Reviewed-by annotations applied, Nathan actually sent:
>>    "Signed-off-by: Nathan Scott <nathans@debian.org>"
> 
> I've pushed these, plus Nathan's patch to add you to Uploaders

Thanks! It would be great to have a 5.10.0 version available in Debian 
bullseye. Currently, it has 5.6.0. The freeze is in three weeks, so to 
give the package time to migrate it should be uploaded in January.

> 
> Thanks,
> -Eric
> 
>> Bastian Germann (6):
>>    debian: cryptographically verify upstream tarball
>>    debian: remove dependency on essential util-linux
>>    debian: remove "Priority: extra"
>>    debian: use Package-Type over its predecessor
>>    debian: add missing copyright info
>>    debian: new changelog entry
>>
>>   debian/changelog                |  11 ++++
>>   debian/control                  |   5 +-
>>   debian/copyright                | 111 ++++++++++++++++++++++++++++----
>>   debian/upstream/signing-key.asc |  63 ++++++++++++++++++
>>   debian/watch                    |   2 +-
>>   5 files changed, 175 insertions(+), 17 deletions(-)
>>   create mode 100644 debian/upstream/signing-key.asc
>>
