Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406C2C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 07:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FBB661007
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 07:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhD1HjC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236524AbhD1Hi7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 03:38:59 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD8FC06138D
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 00:38:14 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id t4so9857765ejo.0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 00:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AR7AZx/HprhMaXntKpX52HDvu0W5Gy7xNQSVkuB/z5U=;
        b=P76X46Fh530DkQZbz7+8vDw89K1PJ3fhVkrYy3zt/17O7p7VwyCS2OknSWC7pDVkRi
         ugNNmpVmi220g8sTiWh5rGxJLjez6tgjsrlsXH/Qf69c9989+Ytae5aWs+YWbf6I1rgp
         ub8hnylXAiKCXGjL7rYeTVbUqdMbO/58Yyh6Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AR7AZx/HprhMaXntKpX52HDvu0W5Gy7xNQSVkuB/z5U=;
        b=VY8AKTRwiXF09vv6cWjJ+RejHcMrneLgltPagHTJ78hDRY7t9Ho090iMsGuDWXJ5oe
         0pYBTnLIaJKpcllyJKirrio24GwfWm8v2bR+gSOHq5UrSx4UDK/EInGaIiXDZwelEWie
         /i5c4kCyQPjKjj3ltkGeZjWnrxKuPRjta/0iIk9af/d4JjRkeCKNVMYWNyflazdDdNtm
         ZN6G8NtUGKL5KHdwfqQyt+9cGMllc/eSnVhheqnxfJJ6ADiGZ5N8JSxMWizKhM2cm2wK
         ChkRYpUy5kF1OdFcfB8+vHp3VMjDsNcGXzaWuDziULWNhnyyeUY+q2EJPhgvYCdnQ6eV
         eMKQ==
X-Gm-Message-State: AOAM530xyBvGtZOMOO9ThAp+qFBCjCRvBMGVNQgYmR4d/aDGk4rtm63U
        iAhNRuZRaM0dhTa0zSK9TlMySQ==
X-Google-Smtp-Source: ABdhPJztiab7WaB93LjAFGfGYcmhmIRppuTAwnbjIDRZlIEEUE8m1/iQzPhWpIkhHSPp6zcR9a5iAA==
X-Received: by 2002:a17:906:48c6:: with SMTP id d6mr27065165ejt.376.1619595492580;
        Wed, 28 Apr 2021 00:38:12 -0700 (PDT)
Received: from [192.168.1.149] ([80.208.71.248])
        by smtp.gmail.com with ESMTPSA id j16sm4205265edt.39.2021.04.28.00.38.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 00:38:12 -0700 (PDT)
Subject: Re: [GIT PULL] iomap: new code for 5.13-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, Jia He <justin.he@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
References: <20210427025805.GD3122264@magnolia>
 <CAHk-=wj6XUGJCgsr+hx3rz=4KvBP-kspn3dqG5v-cKMzzMktUw@mail.gmail.com>
 <20210427195727.GA9661@lst.de>
 <CAHk-=wjrpinf=8gAjxyPoXT0jbK6-U3Urawiykh-zpxeo47Vhg@mail.gmail.com>
 <20210428061706.GC5084@lst.de>
 <CAHk-=whWnFu4wztnOtySjFVYXmBR4Mb2wxrp6OayZqnpKeQw0g@mail.gmail.com>
 <20210428064110.GA5883@lst.de>
 <CAHk-=wjeUhrznxM95ni4z+ynMqhgKGsJUDU8g0vrDLc+fDtYWg@mail.gmail.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <1de23de2-12a9-2b13-3b86-9fe4102fdc0c@rasmusvillemoes.dk>
Date:   Wed, 28 Apr 2021 09:38:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjeUhrznxM95ni4z+ynMqhgKGsJUDU8g0vrDLc+fDtYWg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28/04/2021 09.14, Linus Torvalds wrote:
So let me just quote that first reply of mine, because you seem to not
> have seen it:
> 
>> We have '%pD' for printing a filename. It may not be perfect (by
>> default it only prints one component, you can do "%pD4" to show up to
>> four components), but it should "JustWork(tm)".
>>
>> And if it doesn't, we should fix it.
> 
> I really think %pD4 should be more than good enough. And I think maybe
> we should make plain "%pD" mean "as much of the path that is
> reasonable" rather than "as few components as possible" (ie 1).
> 
> So I don't think "%pD" (or "%pD4") is necessarily perfect, but I think
> it's even worse when people then go and do odd ad-hoc things because
> of some inconvenience in our %pD implementation.
> 
> For example, changing the default to be "show more by default" should
> be as simple as something like the attached.  I do think that would be
> the more natural behavior for %pD - don't limit it unnecessarily by
> default, but for somebody who literally just wants to see a maximum of
> 2 components, using '%pD2' makes sense.
> 
> (Similarly, changing the limit of 4  components to something slightly
> bigger would be trivial)
> 
> Hmm?
> 
> Grepping for existing users with
> 
>     git grep '%pD[^1-4]'
>
> most of them would probably like a full pathname, and the odd s390
> hmcdrv_dev.c use should just be fixed (it has a hardcoded "/dev/%pD",
> which seems very wrong).

So the patch makes sense to me. If somebody says '%pD5', it would get
capped at 4 instead of being forced down to 1. But note that while that
grep only produces ~36 hits, it also affects %pd, of which there are
~200 without a 2-4 following (including some vsprintf test cases that
would break). So I think one would first have to explicitly support '1',
switch over some users by adding that 1 in their format string
(test_vsprintf in particular), then flip the default for 'no digit
following %p[dD]'.

Rasmus
