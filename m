Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE301CCA47E
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 19:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349355AbiFPTOr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 15:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235683AbiFPTOq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 15:14:46 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329E849CBA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 12:14:45 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id kq6so4502172ejb.11
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 12:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pbV08iBwGfkxmXYoA1VIJvlV2UmK3YzJ41yofRdZyLU=;
        b=dcdkMcHTJVnxoroJQQyOSQ2hvO4JsUyL9A8pgzbQH+EYSDrJYCrkrswzLz3irfA2j7
         efMBNu5K1vFadai8pD+FNsVf+1jorrZW261NR6AFq2WVl/6gy2247A+GRqmGxI/sKIAy
         Edk+iURnurHyyEsKgmgu6hsjFw1Nfh+9lfQlA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pbV08iBwGfkxmXYoA1VIJvlV2UmK3YzJ41yofRdZyLU=;
        b=p6tl6tZt63QM7X4kldh2s8lPQWxSwYpyUEop+NBf04gUS2Nlr/4J6pBLk6vOsBwf2J
         XO+gLTZzEFpauO6+wAcA0SRZc4sp/qN7mAw8V0MqGexPlgc8D6HJwSVOiEgEeSSmOXMU
         Ihps83Mor3rrhaCUUM50uxyP0vsICYPU4TQgpoc782Q0uAiN39d6r7M4l3TUTHR7FJig
         QLHW8LRK1ZGKEhkiXP+ZDRnSRMIivmzmG+3COUDatYUvog8IFgEzpE6a5KPifuO1nW1P
         LQLChuOrw1VpRl/sp4AwveIO3whmGHAgxqoEq8CZTlMRdsveuXqbhxFJMRAxbt5JCaUx
         JS4A==
X-Gm-Message-State: AJIora+QP6zALMou6U8/nkWmTuc5IKvG2NZzrf86ceMpclgSHIxZkHu8
        vPxiclAPD8d2xSnCIQUSwgvyJzzz5YyjyTou
X-Google-Smtp-Source: AGRyM1u7Jqk82Vb9Fq7ERmDE0pifHVzs/UfT16nd3MCkf1W3GKPOyXJgbS1iKgCtWeYkUjYSfa/i+A==
X-Received: by 2002:a17:907:7b86:b0:70c:a99a:f525 with SMTP id ne6-20020a1709077b8600b0070ca99af525mr5910352ejc.606.1655406882742;
        Thu, 16 Jun 2022 12:14:42 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id cy2-20020a0564021c8200b0042ab2127051sm2303855edb.64.2022.06.16.12.14.41
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 12:14:41 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id a15so3067814wrh.2
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 12:14:41 -0700 (PDT)
X-Received: by 2002:a5d:48c1:0:b0:21a:3574:e70c with SMTP id
 p1-20020a5d48c1000000b0021a3574e70cmr3982140wrs.97.1655406881201; Thu, 16 Jun
 2022 12:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220616143617.449094-1-Jason@zx2c4.com> <YqtAShjjo1zC6EgO@casper.infradead.org>
 <YqtDXPWdFQ/fqgDo@zx2c4.com> <YqtKjAZRPBVjlE8S@casper.infradead.org>
 <CAHk-=wj2OHy-5e+srG1fy+ZU00TmZ1NFp6kFLbVLMXHe7A1d-g@mail.gmail.com>
 <Yqtd6hTS52mbb9+q@casper.infradead.org> <CAHk-=wj_K2MnhC6N_LyY6ezmQyWzqBnfobXC354HJuKdqMePzA@mail.gmail.com>
In-Reply-To: <CAHk-=wj_K2MnhC6N_LyY6ezmQyWzqBnfobXC354HJuKdqMePzA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 16 Jun 2022 12:14:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=whS3xhJ=quD5bzDb6JsAhKd0vem4K-U=DhUGf-tDJUMHg@mail.gmail.com>
Message-ID: <CAHk-=whS3xhJ=quD5bzDb6JsAhKd0vem4K-U=DhUGf-tDJUMHg@mail.gmail.com>
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

On Thu, Jun 16, 2022 at 9:56 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Out bitmaps and bit fields are also all about "long" - again, entirely
> unrelated to pointers.

That, btw, has probably been a mistake. It's entirely historical. We
would have been better off had our bitmap types been defined in terms
of 32-bit chunks, because now we have the odd situation that 32-bit
and 64-bit architectures get very different sizes for some flag
fields.

It does have a technical reason: it's often better to traverse bitmaps
in maximally sized chunks (ie scanning for bits set or clear), and in
that sense defining bitmaps to always act as arrays of "long" has been
a good thing.

But it then causes pointless problems when people can't really rely on
more than 32 bits for atomic bit operations, and on 64-bit
architectures we unnecessarily use "long" and waste the upper bits.

In some places we then take advantage of that ugly difference (ie "we
have more page flags on 64-bit architectures"), but on the whole it
has probably been more of a pain than the technical gain. The bitmap
scanning is probably not worth it, and could have been done
differently.

And continuing that for some 128-bit architecture is likely just
making the same mistake even worse.

So I think we have a *lot* of things we should look at, if people
really get serious about 128-bit computing.

But I personally think it's several decades away, if ever. Looking at
historical workload growth is probably _very_ misleading - Moore's law
is dying or dead. We're not that many shrinks away from some very
fundamental physical limits.

I do expect people will want to do academic test architectures,
though. It's not clear it's going to be a "double all the widths" kind
of thing, though, and I don't think there is a lot of sense in
designing for a future architecture that is very hazy.

It's not entirely unlikely that we'll end up with a situation where we
do have access to 128-bit operations (because ALU and register width
is relatively "cheap", and it helps some loads - extended precision
arithmetic, crypto, integer vectors), but the address space will be
64-bit (because big pointers are bad for memory and cache use).

In that situation, we'd probably just see "long long" being 128-bit
("I32LP64LL128").

That's obviously what people thought back in the ILP32/LL64 data
model. They were wrong back then, and I may well be wrong now. But
Moore's law limits are fairly undisputable, and a 64-bit address space
is a *lot* bigger than a 32-bit address space was.

So I personally will take a "let's wait for reality to catch up a bit
more" approach, because it's not clear what the actual future will
hold.

                 Linus
