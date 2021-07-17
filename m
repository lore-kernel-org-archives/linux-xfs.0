Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72892C636CA
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Jul 2021 17:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 562266101D
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Jul 2021 17:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhGQRhh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Jul 2021 13:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbhGQRhg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Jul 2021 13:37:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B4EC061762;
        Sat, 17 Jul 2021 10:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=Q+wswcJYx0J9VCEjAaimzcbWFDFM+jrzkSVI1Om9YP8=; b=Tc2Xcyp4qDe5ONVs9DMy/VIAJD
        ssAl0+fC8J6etu6unlJcMMd3JNN6l7QhWNJ1XfNUIXTs68Xc3FVIW3Pal7XxAABWz/Jc1Y4cGhCbi
        tbsqc8l0dHe/mIMoI3N2sAbjqdPpw9ZXfepAmiDnygEDM2v+PF6F8DY1aceKxkAwZ51jZDYv9w1Ur
        ybo04EokT05dT+CyyTq3t8Zfa3qJ87IVAxj6NWxXu2r0Aone9aEk/4tVxnQWUUu855U0acx8kiiif
        0SlPuvv/HfRPjDOQVuoI0LuDvm46vwYdpV5Os9tT02YpSQXSIabDLnsbWnuDHF5nKAjcFOIg5h1Sr
        1UND7SwA==;
Received: from [2601:1c0:6280:3f0::aefb]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4oCw-006tgb-Na; Sat, 17 Jul 2021 17:34:34 +0000
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
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <13030ef0-556d-ee79-196c-8a5f7443f2ed@infradead.org>
Date:   Sat, 17 Jul 2021 10:34:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3eb0e8e4-adae-883d-1be9-a086f01197ff@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/16/21 3:37 PM, Vlastimil Babka wrote:
> On 7/16/21 10:12 PM, Linus Torvalds wrote:
>> On Fri, Jul 16, 2021 at 12:39 AM Christoph Hellwig <hch@infradead.org> wrote:
>>>
>>> This somewhat unexpectedly causes a crash when running the xfs/433 test
>>> in xfstests for me.  Reverting the commit fixes the problem:
>>
>> I don't see why that would be the case, but I'm inclined to revert
>> that commit for another reason: the code doesn't seem to match the
>> description of the commit.
>>
>> It used to be that CONFIG_SLUB_DEBUG was a config option that was
>> harmless and that defaulted to 'y' because there was little downside.
>> In fact, it's not just "default y", it doesn't even *ask* the user
>> unless CONFIG_EXPERT is on. Because it was fairly harmless. And then
>> SLOB_DEBUG_ON was that "do you actually want this code _enabled_".
>>
>> But now it basically force-enables that STACKDEPOT support too, and
>> then instead of having an _optional_ CONFIG_STACKTRACE, you basically
>> have that as being forced on you whether you want active debugging or
>> not.
>>
>> Maybe that
>>
>>         select STACKDEPOT if STACKTRACE_SUPPORT
>>
>> should have been
>>
>>         select STACKDEPOT if STACKTRACE
> 
> I recall we tried that and run into KConfig recursive dependency hell as
> "config STACKDEPOT" does "select STACKTRACE", and after some attempts
> ended up with the above.
> 
>> because i\t used to be that CONFIG_STACKTRACE was somewhat unusual,
>> and only enabled for special debug cases (admittedly "CONFIG_TRACING"
>> likely meant that it was fairly widely enabled).
>>
>> In contrast, STACKTRACE_SUPPORT is basically "this architecture supports it".
>>
>> So now it seems STACKDEPOT is enabled basically unconditionally.
> 
> It seemed rather harmless as it was just a bit of extra code. But it's
> true Geert reports [1] unexpected memory usage which I would have only
> expected if actual stacks started to be collected. So I guess we'll have
> to look into that.
> 
> [1]
> https://lore.kernel.org/lkml/CAMuHMdW=eoVzM1Re5FVoEN87nKfiLmM2+Ah7eNu2KXEhCvbZyA@mail.gmail.com/
> 
>> So I really don't see why it would cause that xfs issue, but I think
>> there are multiple reasons to just go "Hmm" on that commit.
>>
>> Comments?
>>
>>                 Linus
>>
> 

There is also the matter of lib/stackdepot.c build errors on ARCH=arc:

https://lore.kernel.org/lkml/202107150600.LkGNb4Vb-lkp@intel.com/


-- 
~Randy

