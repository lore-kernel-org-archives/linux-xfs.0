Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA70C636CA
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Jul 2021 07:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E26406109E
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Jul 2021 07:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhGRHdO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Jul 2021 03:33:14 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50548 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhGRHdN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Jul 2021 03:33:13 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7F48E22540;
        Sun, 18 Jul 2021 07:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1626593414; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bf1RqKai+duaWr87/gn5MZI/Qg8aTMEvGytJ+hLZIQc=;
        b=Ahisbh78jA8N/e6G0TDCKyatd9RYA8KLnHS8rjdsZ65QqfucheY6UflejyPfN0CJp32Ufw
        D9/klVR6Hv0zsJkcNVR2X+If7FL59eQATAdngJqfTn3cOobvif82u5lEGRvAXsn4Ong67T
        tO4WdgCm25RtB+t6dqEAZSdGI7TgM9c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1626593414;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bf1RqKai+duaWr87/gn5MZI/Qg8aTMEvGytJ+hLZIQc=;
        b=gVrs1iBHJEq6bOYuv8NAi0lm8f+3zIW4cmrly/fSUbUZN1LmHml9XjlwJsV1owLvwXaC6P
        jlRNNHZ5PIsQIiDQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 287FF1332A;
        Sun, 18 Jul 2021 07:30:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id GxL+B4bY82AVCwAAGKfGzw
        (envelope-from <vbabka@suse.cz>); Sun, 18 Jul 2021 07:30:14 +0000
Subject: Re: [patch 07/54] mm/slub: use stackdepot to save stack trace in
 objects
To:     Randy Dunlap <rdunlap@infradead.org>,
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
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <01949b7f-a463-e81e-f183-19fe717a2ba7@suse.cz>
Date:   Sun, 18 Jul 2021 09:29:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <13030ef0-556d-ee79-196c-8a5f7443f2ed@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/17/21 7:34 PM, Randy Dunlap wrote:
>>> because i\t used to be that CONFIG_STACKTRACE was somewhat unusual,
>>> and only enabled for special debug cases (admittedly "CONFIG_TRACING"
>>> likely meant that it was fairly widely enabled).
>>>
>>> In contrast, STACKTRACE_SUPPORT is basically "this architecture supports it".
>>>
>>> So now it seems STACKDEPOT is enabled basically unconditionally.
>>
>> It seemed rather harmless as it was just a bit of extra code. But it's
>> true Geert reports [1] unexpected memory usage which I would have only
>> expected if actual stacks started to be collected. So I guess we'll have
>> to look into that.
>>
>> [1]
>> https://lore.kernel.org/lkml/CAMuHMdW=eoVzM1Re5FVoEN87nKfiLmM2+Ah7eNu2KXEhCvbZyA@mail.gmail.com/
>>
>>> So I really don't see why it would cause that xfs issue, but I think
>>> there are multiple reasons to just go "Hmm" on that commit.
>>>
>>> Comments?
>>>
>>>                 Linus
>>>
>>
> 
> There is also the matter of lib/stackdepot.c build errors on ARCH=arc:
> 
> https://lore.kernel.org/lkml/202107150600.LkGNb4Vb-lkp@intel.com/

That's being fixed AFAIK?

https://lore.kernel.org/lkml/20210710145033.2804047-1-linux@roeck-us.net/

I'll try to come up with some KConfig flag set that will make it depend
on STRACKTRACE again without recursion issues.
