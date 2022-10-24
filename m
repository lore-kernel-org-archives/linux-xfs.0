Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1DAC67871
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 22:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbiJXWUG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 18:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiJXWT2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 18:19:28 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035B330FC02
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 13:36:51 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id f8so6842275qkg.3
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 13:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iSOcydxSXUj96NbU/Er00mnbcEfNU+h40IX+5ItHvVI=;
        b=NdKygZeWtxEfUI9ndMdtc/4AWy07NJQctRLiPLF2eQWEQbYBk4YSxN2tF74liqneT2
         DizOz3/Yz4Eij2YMSyEWq79hgUDw9jAOSR2cbNueYcyedkMrPG+4sHU1EBFXmAmL7PKe
         NNXZcMMs/prAxArt0WyhEnqh+iQq4THrGL3oI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iSOcydxSXUj96NbU/Er00mnbcEfNU+h40IX+5ItHvVI=;
        b=dsuxZTztdsqRTKa1Z0uVv/p5rD3h/acEhOlHOewUo0BTPGo7pzJ7SyE1uB2Pstbu9y
         7e0q9AvdJ1aLq4vRYvT+iT9hOpHRixhoD5SibgPqWv1c8qjy34enZ/MjHtAXR+MdKVkA
         PmXt/6IhATzK2SZRaFiUpIPOugibsT4oby3lWrAdlIB/k5B9ilFFBHoToSPlBR4wI+tj
         fGtIduHce7PaYY5ExEEej2fIGcb+aN4EcsOKqur5h3tHu5aDWs7DcviCeHvBTIUFPXhz
         4pvEGX9xtTsQUrHZyhtxYmjSj+OOWUQAb26iRarlw2VxOlmHPnYMuhZt1Fa8gp7RfWwc
         rS/Q==
X-Gm-Message-State: ACrzQf2+TYp9F91CZNYZjf2so8l5T5B/7a7XfALEMKxnBo6h0bEmjQJm
        zQgPGSRNlBZ+AfzWFGaYiUBLwP0Jse6ffQ==
X-Google-Smtp-Source: AMsMyM5cps2McUgdgmJ8S9Zao7POvo5U0iPq28dc9PV4IY+GLAu96FpnsbM+hW74HqbjEojtvOX1Cg==
X-Received: by 2002:a37:ad03:0:b0:6ef:14a1:146b with SMTP id f3-20020a37ad03000000b006ef14a1146bmr16312659qkm.733.1666643329005;
        Mon, 24 Oct 2022 13:28:49 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id x6-20020a05620a448600b006b9c9b7db8bsm645281qkp.82.2022.10.24.13.28.47
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 13:28:48 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id i127so12265678ybc.11
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 13:28:47 -0700 (PDT)
X-Received: by 2002:a25:5389:0:b0:6bc:f12c:5d36 with SMTP id
 h131-20020a255389000000b006bcf12c5d36mr29953243ybb.184.1666643327656; Mon, 24
 Oct 2022 13:28:47 -0700 (PDT)
MIME-Version: 1.0
References: <YjDj3lvlNJK/IPiU@bfoster> <YjJPu/3tYnuKK888@casper.infradead.org>
 <YjM88OwoccZOKp86@bfoster> <YjSTq4roN/LJ7Xsy@bfoster> <YjSbHp6B9a1G3tuQ@casper.infradead.org>
 <CAHk-=wh6V6TZjjnqBvktbaho_wqfjZYQ9zcKJTV8EP2Kygn0uQ@mail.gmail.com>
 <6350a5f07bae2_6be12944c@dwillia2-xfh.jf.intel.com.notmuch>
 <CAHk-=wizsHtGa=7dESxXd6VNU2mdHqhvCv88FB3xcWb3o3iJMw@mail.gmail.com> <6356f1f74678c_141929415@dwillia2-mobl3.amr.corp.intel.com.notmuch>
In-Reply-To: <6356f1f74678c_141929415@dwillia2-mobl3.amr.corp.intel.com.notmuch>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 24 Oct 2022 13:28:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj7mRYuictrQjT+sacgj9_GrmRetE1KLTiz-nOk-H4DPQ@mail.gmail.com>
Message-ID: <CAHk-=wj7mRYuictrQjT+sacgj9_GrmRetE1KLTiz-nOk-H4DPQ@mail.gmail.com>
Subject: Re: writeback completion soft lockup BUG in folio_wake_bit()
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        jesus.a.arechiga.lopez@intel.com, tim.c.chen@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 1:13 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Arechiga reports that his test case that failed "fast" before now ran
> for 28 hours without a soft lockup report with the proposed patches
> applied. So, I would consider those:
>
> Tested-by: Jesus Arechiga Lopez <jesus.a.arechiga.lopez@intel.com>

Ok, great.

I really like that patch myself (and obviously liked it back when it
was originally proposed), but I think it was always held back by the
fact that we didn't really have any hard data for it.

It does sound like we now very much have hard data for "the page
waitlist complexity is now a bigger problem than the historical
problem it tried to solve".

So I'll happily apply it. The only question is whether it's a "let's
do this for 6.2", or if it's something that we'd want to back-port
anyway, and might as well apply sooner rather than later as a fix.

I think that in turn then depends on just how artificial the test case
was. If the test case was triggered by somebody seeing problems in
real life loads, that would make the urgency a lot higher. But if it
was purely a synthetic test case with no accompanying "this is what
made us look at this" problem, it might be a 6.2 thing.

Arechiga?

Also, considering that Willy authored the patch (even if it's really
just a "remove this whole code logic"), maybe he has opinions? Willy?

                 Linus
