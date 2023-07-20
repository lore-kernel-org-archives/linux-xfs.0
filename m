Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C238CEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 18:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbjGTSiL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 14:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjGTSiK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 14:38:10 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545AAE47
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 11:38:07 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-783698a37beso51440139f.0
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 11:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1689878286; x=1690483086;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sBKOtLiusaOWw33bk8O0sdnxuISL7hPnBJhD7qghAzw=;
        b=j89Dq1Gsobw5bIrGazAHoXSihT9TT0hy4Wk30omvu+ZUTGqvRX4QjugifeOzBPUW18
         wd79C2/mFE+b57nDxTSh8hKe/3/wgapr1PPPk8DXFiaIsW80yd4nEPxlEWxmyE9g5ray
         c1A7LZxnAbnl1+t53VzX1B6k1SUsbuMhNmVI0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689878286; x=1690483086;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sBKOtLiusaOWw33bk8O0sdnxuISL7hPnBJhD7qghAzw=;
        b=CTEGLbCPSnrIotrp9TSVUQn1gkPlRRY9ryiEYlTHx7ldTM5u/HiJkn+y2b5FedXyGI
         u2WVaeP6VhVZFxDPeEp0W/7fmLSacAxQkuEAagceZHSAs4IfGhZhoo+zv0q/Ymc0llz2
         OkrADz7W5VRYofuMpxJdnKFGA+tb5EtFvBJ8A397+hxCqBdYruVvgpqKqL9WJwWieShg
         kjCoepnLK2pAUMO4+GKfEnXqfDN7vvRArqSmhDuTjQh0zFx8HUSASC/E/ra1reSqy/pD
         NZTbw4JhnZOSdnGS1l84udZPQCQPGoKRGlZuu8HJTiq//90/K3wRjlD9cDswagUzhdPY
         Obow==
X-Gm-Message-State: ABy/qLYJOUvfOvwLbB7fFkTKBel9opKBj8cgNjLI+g9CmLBzuHlDtVyf
        8VyUGNG1O5Qg3YO9+WacI2YS4w==
X-Google-Smtp-Source: APBJJlFGlfHWhxfP6H9MBkq8ZiHq3bw5FqM4TMkUJ+VWeILOHczyvCfIr+OoVROuTmlyITBQpAWy5Q==
X-Received: by 2002:a05:6e02:1649:b0:346:50ce:d602 with SMTP id v9-20020a056e02164900b0034650ced602mr13674600ilu.1.1689878286680;
        Thu, 20 Jul 2023 11:38:06 -0700 (PDT)
Received: from ?IPV6:2606:4700:110:8e0c:167c:4790:3021:4c17? ([2a09:bac5:947a:4e6::7d:4c])
        by smtp.gmail.com with ESMTPSA id e11-20020a02a50b000000b0042b48d372aasm481209jam.100.2023.07.20.11.38.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 11:38:06 -0700 (PDT)
Message-ID: <b52378ac-e3b8-1bd6-1297-af9ae414e5e3@cloudflare.com>
Date:   Thu, 20 Jul 2023 13:38:05 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: Backporting of series xfs/iomap: fix data corruption due to stale
 cached iomap
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     Ignat Korchagin <ignat@cloudflare.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Daniel Dao <dqminh@cloudflare.com>,
        Dave Chinner <david@fromorbit.com>,
        kernel-team <kernel-team@cloudflare.com>,
        linux-fsdevel@vger.kernel.org,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Leah Rumancik <lrumancik@google.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <CA+wXwBRdcjHW2zxDABdFU3c26mc1u+g6iWG7HrXJRL7Po3Qp0w@mail.gmail.com>
 <ZJ2yeJR5TB4AyQIn@casper.infradead.org>
 <20230629181408.GM11467@frogsfrogsfrogs>
 <CALrw=nFwbp06M7LB_Z0eFVPe29uFFUxAhKQ841GSDMtjP-JdXA@mail.gmail.com>
 <CAOQ4uxiD6a9GmKwagRpUWBPRWCczB52Tsu5m6_igDzTQSLcs0w@mail.gmail.com>
 <CALrw=nHH2u=+utzy8NfP6+fM6kOgtW0hdUHwK9-BWdYq+t-UoA@mail.gmail.com>
 <CAOQ4uxju10zrQhVDA5WS+vTSbuW17vOD6EGBBJUmZg8c95vsrA@mail.gmail.com>
 <20230630151657.GJ11441@frogsfrogsfrogs>
 <CALrw=nFv82aODZ0URzknqnZavyjCxV1vKOP9oYijfSdyaYEQ3g@mail.gmail.com>
 <CAOQ4uxgvawD4=4g8BaRiNvyvKN1oreuov_ie6sK6arq3bf8fxw@mail.gmail.com>
 <ZLl9K7jODHNYybTY@bombadil.infradead.org>
Content-Language: en-US
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <ZLl9K7jODHNYybTY@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Amir and Luis

On 7/20/23 1:30 PM, Luis Chamberlain wrote:
> On Thu, Jul 20, 2023 at 09:45:14AM +0300, Amir Goldstein wrote:
>> On Wed, Jul 19, 2023 at 11:37 PM Ignat Korchagin <ignat@cloudflare.com> wrote:
>>>
>>> Circling back on this. So far it seems that the patchset in question
>>> does fix the issues of rocksdb corruption as we haven't seen them for
>>> some time on our test group. We're happy to dedicate some efforts now
>>> to get them officially backported to 6.1 according to the process. We
>>> did try basic things with kdevops and would like to learn more. Fred
>>> (cc-ed here) is happy to drive the effort and be the primary contact
>>> on this. Could you, please, guide us/him on the process?
>>>
>>
>> Hi Fred,
>>
>> I'd love to help you get started with kdevops and xfs testing.
>> However, I am going on vacation tomorrow for three weeks,
>> so I'll just drop a few pointers and let the others help you out.
>>
>> Luis (@mcgrof) is your best point of contact for kdevops.
> 
> I'm happy to help.
> 
>> Chandan should be able to help you with xfs backporting questions.
>>
>> Better yet, use the discord channel:
>>    https://bit.ly/linux-kdevops-chat
>>
>> Someone is almost always available to answer questions there.
> 
> Indeed and also on irc.oftc.net on #kdevops too if you prefer IRC.
> But discord seems to be more happening for kdevops these days.
> 
>> TESTING:
>> --------------
>> The most challenging part of running fstests with kdevops is
>> establishing the baseline (which tests pass in current 6.1.y per xfs config),
>> but the baseline for that has already been established and committed
>> in kdevops repo.
>>
>> There is a little quirk, that the baseline is associated only with exact
>> kernel version, hence commits like:
>> * c4e3de1 bootlinux: add expunge link for v6.1.39
> 
> Indeed so our latest baseline is in
> 
> workflows/fstests/expunges/6.1.39/xfs/unassigned/
> 
>> Make sure that you test your patches against one of those tags
>> or add new symlinks to other tags.
>> Start by running a sanity test without your patches, because different
>> running environments and kdevops configs may disagree on the baseline.
> 
> You want to first run at least one loop to confirm your setup is fine
> and that you don't find any other failures other than the ones above.
> 
>> You can use kdevops to either run local VMs with libvirt or launch
>> cloud VMs with terraform - you need to configure this and more
>> during the 'make menuconfig' step.
>> Attaching my kdevops config (for libvirt guests) as a reference.
> 
> Please read:
> 
> https://github.com/linux-kdevops/kdevops
> https://github.com/linux-kdevops/kdevops/blob/master/docs/requirements.md
> https://github.com/linux-kdevops/kdevops/blob/master/docs/kdevops-first-run.md
> https://github.com/linux-kdevops/kdevops/blob/master/docs/kdevops-mirror.md
> 
> And the video demonstrations. Then I'm happy to schedule some time to
> cover anything the docs didn't cover, in particular to help you test new
> patches you wish to backport for a stable kernel and the testing
> criteria for that.
> 
>    Luis

This is all fantastic! I just joined the discord and will likely begin 
work on this tomorrow. I've already setup kdevops and ran through some 
selftests earlier this week. I still need to watch the video however. 
I'll reach out in Discord after I give a crack at what's presented so far.

Fred
