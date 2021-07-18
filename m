Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF54C636CB
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Jul 2021 14:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B5D60FF4
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Jul 2021 14:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhGROUS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Jul 2021 10:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhGROUS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Jul 2021 10:20:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A009C061762;
        Sun, 18 Jul 2021 07:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=vcKpMjMRq1iVbDLEXU10AgADN9GUG+Ga+0mteMq2FHk=; b=ENo75coWz5w2TRP+dznlAekjZF
        CUu+nBjfCqcnGWFsj2bZnbVSUmZZAxPnlD16Frmb0payRVs0cYKWZou1RxTkyIuXtpZDgOProswVa
        uzdE+MDsPWfT3qLIqtGwvjoleVxSkT9Jd8QLkMuK8b50GFvn5oEzsv06sfqNNowtbMULsiqcQf6fd
        gOOetljwoP+sw8GEVK2RaoI3unpSMWXghzY0AV+IT06DTwYO/nYacb0CCXaLlWk4w4CctcOWJcZ7X
        XgqaB1RZ9oYIswVrSUTdeagIRXuEgTzUur8kt1dseO9sDWfy+PvxCcLXhWP3vLO2ioLNOMDVLGMRn
        IShws7rg==;
Received: from [2601:1c0:6280:3f0::aefb]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m57bV-007n5E-MT; Sun, 18 Jul 2021 14:17:13 +0000
Subject: Re: [patch 07/54] mm/slub: use stackdepot to save stack trace in
 objects
To:     Vlastimil Babka <vbabka@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, glittao@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
 <20210708010747.zIP9yxsci%akpm@linux-foundation.org>
 <YPE3l82acwgI2OiV@infradead.org>
 <CAHk-=whnjz19Ln3=s4rDZn4+XER2pmA+pEVrjpwMYGba2rHAQA@mail.gmail.com>
 <3eb0e8e4-adae-883d-1be9-a086f01197ff@suse.cz>
 <13030ef0-556d-ee79-196c-8a5f7443f2ed@infradead.org>
 <01949b7f-a463-e81e-f183-19fe717a2ba7@suse.cz>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <1c975296-25ca-630f-de7e-38715f5a5eba@infradead.org>
Date:   Sun, 18 Jul 2021 07:17:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <01949b7f-a463-e81e-f183-19fe717a2ba7@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/18/21 12:29 AM, Vlastimil Babka wrote:
> On 7/17/21 7:34 PM, Randy Dunlap wrote:
>>>> because i\t used to be that CONFIG_STACKTRACE was somewhat unusual,
>>>> and only enabled for special debug cases (admittedly "CONFIG_TRACING"
>>>> likely meant that it was fairly widely enabled).
>>>>
>>>> In contrast, STACKTRACE_SUPPORT is basically "this architecture supports it".
>>>>
>>>> So now it seems STACKDEPOT is enabled basically unconditionally.
>>>
>>> It seemed rather harmless as it was just a bit of extra code. But it's
>>> true Geert reports [1] unexpected memory usage which I would have only
>>> expected if actual stacks started to be collected. So I guess we'll have
>>> to look into that.
>>>
>>> [1]
>>> https://lore.kernel.org/lkml/CAMuHMdW=eoVzM1Re5FVoEN87nKfiLmM2+Ah7eNu2KXEhCvbZyA@mail.gmail.com/
>>>
>>>> So I really don't see why it would cause that xfs issue, but I think
>>>> there are multiple reasons to just go "Hmm" on that commit.
>>>>
>>>> Comments?
>>>>
>>>>                 Linus
>>>>
>>>
>>
>> There is also the matter of lib/stackdepot.c build errors on ARCH=arc:
>>
>> https://lore.kernel.org/lkml/202107150600.LkGNb4Vb-lkp@intel.com/
> 
> That's being fixed AFAIK?
> 
> https://lore.kernel.org/lkml/20210710145033.2804047-1-linux@roeck-us.net/

Ah, thanks.

> I'll try to come up with some KConfig flag set that will make it depend
> on STRACKTRACE again without recursion issues.
> 

