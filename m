Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C16FC43334
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 16:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378080AbiFPQAN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 12:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378029AbiFPQAM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 12:00:12 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075E7434AB
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 09:00:12 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w27so2809526edl.7
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 09:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BJ2jAaiEzLNQ93crLBAe3sDvH4iCO/x2lZ+zRlgdV/4=;
        b=cxj6vejdZIrdWg7i57fno7dIoPvsbKilzHyEXWvFkAoBv9r+QoFdy7bpOwZp2Ylk3B
         pfE/wp7Kfj88bh8j/WDUFirzzoX10qWcVrp+aqFo0r03zBUiPzkWhr4H7OcxpoTJRrbK
         rSMSCgfc1ly2bqQk3lU50OAV7bXFWH86uHjt0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BJ2jAaiEzLNQ93crLBAe3sDvH4iCO/x2lZ+zRlgdV/4=;
        b=G/ITsx8dOlGP68lYtdhG7AtGUBh/QCWYJvGN00rf+m0vPq7O21NOt5ftk/7/rpoCEg
         B2RzKI9dpwf61PNNjVrAZMBXLldVnKagq3qGT6Lw0wsKV69j8KYfN+x7Ma1j+0gSpCfq
         dO44OEoGK4QPpXHkxjXOYhEWelgT5CY4t6f+EOketLFak+QpoUZepGBUBjgJcp2m/oqb
         7TH1xerl2+HmrrlONFyZ0x+DMuSNbnvq9RF1fxiyT0WLZX/ENBrg6wH1OeIyPdRT8+MQ
         kkz2dqvP169LF7D4Tb9ngk0pXffE2M2OTm8b48dUcTZcR7b6iHC/7X8TrdE9E70rBt8Q
         Ajaw==
X-Gm-Message-State: AJIora+AP/bnvugvb1B/10nHh3ODT76kIzqsa1W0yTAQWGmfj6qchzeM
        qIaPikykMng8taSrIVFDHnrYA1BBNBZTwSsYkHE=
X-Google-Smtp-Source: AGRyM1si66+VvKjC5Y+TsLqMjz1g/d7iPTN6b44xQgU6Q7H90zF7LPh2lFREBRVrFvsSgvslaTf+tA==
X-Received: by 2002:a05:6402:294c:b0:435:2155:fbe8 with SMTP id ed12-20020a056402294c00b004352155fbe8mr7333348edb.256.1655395210233;
        Thu, 16 Jun 2022 09:00:10 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id qc23-20020a170906d8b700b006feb047502bsm935710ejb.151.2022.06.16.09.00.08
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 09:00:08 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id u8so2433749wrm.13
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 09:00:08 -0700 (PDT)
X-Received: by 2002:a5d:47aa:0:b0:218:5ac8:f3a8 with SMTP id
 10-20020a5d47aa000000b002185ac8f3a8mr5432558wrb.442.1655395207618; Thu, 16
 Jun 2022 09:00:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220616143617.449094-1-Jason@zx2c4.com> <YqtAShjjo1zC6EgO@casper.infradead.org>
 <YqtDXPWdFQ/fqgDo@zx2c4.com> <YqtKjAZRPBVjlE8S@casper.infradead.org>
In-Reply-To: <YqtKjAZRPBVjlE8S@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 16 Jun 2022 08:59:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj2OHy-5e+srG1fy+ZU00TmZ1NFp6kFLbVLMXHe7A1d-g@mail.gmail.com>
Message-ID: <CAHk-=wj2OHy-5e+srG1fy+ZU00TmZ1NFp6kFLbVLMXHe7A1d-g@mail.gmail.com>
Subject: Re: [PATCH] usercopy: use unsigned long instead of uintptr_t
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-hardening@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 16, 2022 at 8:21 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> I don't know why people call uintptr_t a "userspace type".  It's a type
> invented by C99 that is an integer type large enough to hold a pointer.
> Which is exactly what we want here.

On the other hand, "unsigned long" has existed since the first version
of C, and is an integer type large enough to hold a pointer.

Which is exactly what we want here, and what we use everywhere else too.

The whole "uintptr_t handles the historical odd cases with pointers
that are smaller than a 'long'" is entirely irrelevant, since those
odd cases are just not a factor.

And the "pointers are _larger_ than a 'long'" case is similarly
irrelevant, since we very much want to use arithmetic on these things,
and they are 'long' later. They aren't used as pointers, they are used
as integer indexes into the virtual address space that we do odd
operations on.

Honestly, even if you believe in the 128-bit pointer thing, changing
one cast in one random place to be different from everything else is
*not* productive. We're never going to do some "let's slowly migrate
from one to the other".

And honestly, we're never going to do that using "uintptr_t" anyway,
since it would be based on a kernel config variable and be a very
specific type, and would need to be type-safe for any sane conversion.

IOW, in a hypothetical word where the address size is larger than the
word-size, it would have to be something like out "pte_t", which is
basically wrapped in a struct so that C implicit type conversion
doesn't bite you in the arse.

So no. There is ABSOLUTELY ZERO reason to ever use 'uintptr_t' in the
kernel. It's wrong. It's wrong *even* for actual user space interfaces
where user space might use 'uintptr_t', because those need to be
specific kernel types so that we control them (think for compat
reasons etc).

We use the user-space types in a few places, and they have caused
problems, but at least they are really traditional and the compiler
actually enforces them for some really standard functions. I'm looking
at 'size_t' in particular, which caused problems exactly because it's
a type that is strictly speaking not under our control.

'size_t' is actually a great example of why 'uintptr_t' is a horrid
thing. It's effectively a integer type that is large enough to hold a
pointer difference. On unsegmented architectures, that ends up being a
type large enough to hold a pointer.

Sound familiar?

And does it sound familiar how on some architectures it's "unsigned
int", and on others it is "unsigned long"? It's very annoying, and
it's been annoying over the years. The latest annoyance was literally
less than a week ago in 1c27f1fc1549 ("iov_iter: fix build issue due
to possible type mis-match").

Again, "unsigned long" is superior.

And the only reason to migrate away from it is because you want
something *type-safe*, which uintptr_t very much is not. As
exemplified by size_t, it's the opposite of type-safe. It's actively
likely to be type-confused.

              Linus
