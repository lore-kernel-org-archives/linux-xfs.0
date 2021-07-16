Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72DFEC636CB
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jul 2021 22:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56BF9613F2
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jul 2021 22:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbhGPWlZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Jul 2021 18:41:25 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:42878 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbhGPWlY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jul 2021 18:41:24 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B829B1FD56;
        Fri, 16 Jul 2021 22:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1626475107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QiZkom7aCM3xLpdHt0hB30lVzuPCzlDOb6gF6XnOuUE=;
        b=ESPCZ4bc4NB/hyHbq5a6CpkbCnBbMvqtE419cVBLHEVqRgk1RqWMCUHMOawgMRS1pyP+A1
        PDRaeoVPhKtZlFIzqRqqsNWYwGXo6Q76k4sSM7lXqEs2hbUCgwO6iqCAENZQHGlKL6Q6jF
        rnCu+QqdhVXuzRDEG11XbPNipIbgY8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1626475107;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QiZkom7aCM3xLpdHt0hB30lVzuPCzlDOb6gF6XnOuUE=;
        b=rpaizg0krsnwjQCfQyfUki3ftA0gfVFGOz5+r4OQ+++fI51frhPgFzp5KQWa60UHKuIrnt
        q3Me/Vgrr38IsdBA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 614B713B02;
        Fri, 16 Jul 2021 22:38:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id OY/PFWMK8mAPPQAAGKfGzw
        (envelope-from <vbabka@suse.cz>); Fri, 16 Jul 2021 22:38:27 +0000
Subject: Re: [patch 07/54] mm/slub: use stackdepot to save stack trace in
 objects
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, glittao@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Rientjes <rientjes@google.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
 <20210708010747.zIP9yxsci%akpm@linux-foundation.org>
 <YPE3l82acwgI2OiV@infradead.org>
 <CAHk-=whnjz19Ln3=s4rDZn4+XER2pmA+pEVrjpwMYGba2rHAQA@mail.gmail.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <3eb0e8e4-adae-883d-1be9-a086f01197ff@suse.cz>
Date:   Sat, 17 Jul 2021 00:37:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=whnjz19Ln3=s4rDZn4+XER2pmA+pEVrjpwMYGba2rHAQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/16/21 10:12 PM, Linus Torvalds wrote:
> On Fri, Jul 16, 2021 at 12:39 AM Christoph Hellwig <hch@infradead.org> wrote:
>>
>> This somewhat unexpectedly causes a crash when running the xfs/433 test
>> in xfstests for me.  Reverting the commit fixes the problem:
> 
> I don't see why that would be the case, but I'm inclined to revert
> that commit for another reason: the code doesn't seem to match the
> description of the commit.
> 
> It used to be that CONFIG_SLUB_DEBUG was a config option that was
> harmless and that defaulted to 'y' because there was little downside.
> In fact, it's not just "default y", it doesn't even *ask* the user
> unless CONFIG_EXPERT is on. Because it was fairly harmless. And then
> SLOB_DEBUG_ON was that "do you actually want this code _enabled_".
> 
> But now it basically force-enables that STACKDEPOT support too, and
> then instead of having an _optional_ CONFIG_STACKTRACE, you basically
> have that as being forced on you whether you want active debugging or
> not.
> 
> Maybe that
> 
>         select STACKDEPOT if STACKTRACE_SUPPORT
> 
> should have been
> 
>         select STACKDEPOT if STACKTRACE

I recall we tried that and run into KConfig recursive dependency hell as
"config STACKDEPOT" does "select STACKTRACE", and after some attempts
ended up with the above.

> because i\t used to be that CONFIG_STACKTRACE was somewhat unusual,
> and only enabled for special debug cases (admittedly "CONFIG_TRACING"
> likely meant that it was fairly widely enabled).
> 
> In contrast, STACKTRACE_SUPPORT is basically "this architecture supports it".
> 
> So now it seems STACKDEPOT is enabled basically unconditionally.

It seemed rather harmless as it was just a bit of extra code. But it's
true Geert reports [1] unexpected memory usage which I would have only
expected if actual stacks started to be collected. So I guess we'll have
to look into that.

[1]
https://lore.kernel.org/lkml/CAMuHMdW=eoVzM1Re5FVoEN87nKfiLmM2+Ah7eNu2KXEhCvbZyA@mail.gmail.com/

> So I really don't see why it would cause that xfs issue, but I think
> there are multiple reasons to just go "Hmm" on that commit.
> 
> Comments?
> 
>                 Linus
> 

