Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF2BC38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 22:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJXWLS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 18:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbiJXWKo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 18:10:44 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2954302BC0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 13:25:31 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id o2so6790445qkk.10
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 13:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JBAZHyd5XgygP1+md+qYdTHi+gwkM0InAuquo+/p7pw=;
        b=WBTb2zVyYxNOefcbYu3yHqG/UB1C+xJGDwXHwakVh38aS5ZuDINwt8jsxNEAQqvkEi
         XrcSmdHK+SpPVQiz7c1X4aBcmHBv21rx1vohljqxcxvdc1TQj/sdvazdSXaHo0IYXHLv
         2TH61pa0fSCvroXIW67FQ2PDONkPgzt3hTCwY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JBAZHyd5XgygP1+md+qYdTHi+gwkM0InAuquo+/p7pw=;
        b=5R2WKI0E7v2TSR0NP/J8STK1eFQn+F+0X/8+oIqdZD/5j00tl7tZ4mO/GZZi+2ooWA
         htL1Ty8EzBSqYXOBHjU6RPh6mop7CjYUCMgiSEunA8WH2ATJHXDIMrWUuyharDUTzWbe
         OtEbIeqcRYl/Px9AIPcuEjIdGhucsXsMeQEOx/kcEfqL5kAuINg/z/s7mX0v8Vj9qnE/
         NHmN7HmCDQEVvTE51NMJBBWdulMwPsF8az/u30epPYB5ou1UBMek8HqF2X6ppyDSsNI4
         YYsQuG5r3dvOfaF1ILpBIQXMgkTqjMzoo1JKIkVmUn4WTZVdrBQhbo8WR1tE4yzlRewy
         3MVw==
X-Gm-Message-State: ACrzQf3FQChlfK9Teg6OoSnTxHDYgldoVshhdoa4B1SzqeTZTdGXrDfw
        Z4cPUjpnLE4cgbnR9c9DKcWv3xapDRzZFg==
X-Google-Smtp-Source: AMsMyM5XYzqrO6dBa0zmCQNCgTPWHGABvjfStTPRZZAbi8uAxq70VTYn7EHAvG63PH+eSQGHReQqxA==
X-Received: by 2002:a05:622a:506:b0:39d:12bc:e371 with SMTP id l6-20020a05622a050600b0039d12bce371mr18859163qtx.52.1666640617708;
        Mon, 24 Oct 2022 12:43:37 -0700 (PDT)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com. [209.85.128.181])
        by smtp.gmail.com with ESMTPSA id p16-20020a05620a057000b006e16dcf99c8sm513541qkp.71.2022.10.24.12.43.36
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 12:43:36 -0700 (PDT)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-36847dfc5ccso95475917b3.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 12:43:36 -0700 (PDT)
X-Received: by 2002:a81:2544:0:b0:360:c270:15a1 with SMTP id
 l65-20020a812544000000b00360c27015a1mr29252227ywl.67.1666640616299; Mon, 24
 Oct 2022 12:43:36 -0700 (PDT)
MIME-Version: 1.0
References: <YjDj3lvlNJK/IPiU@bfoster> <YjJPu/3tYnuKK888@casper.infradead.org>
 <YjM88OwoccZOKp86@bfoster> <YjSTq4roN/LJ7Xsy@bfoster> <YjSbHp6B9a1G3tuQ@casper.infradead.org>
 <CAHk-=wh6V6TZjjnqBvktbaho_wqfjZYQ9zcKJTV8EP2Kygn0uQ@mail.gmail.com>
 <6350a5f07bae2_6be12944c@dwillia2-xfh.jf.intel.com.notmuch>
 <CAHk-=wizsHtGa=7dESxXd6VNU2mdHqhvCv88FB3xcWb3o3iJMw@mail.gmail.com> <feb89e52675ed630e52dc8aacfa66feb6f19fd3a.camel@linux.intel.com>
In-Reply-To: <feb89e52675ed630e52dc8aacfa66feb6f19fd3a.camel@linux.intel.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 24 Oct 2022 12:43:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj7y5AJKGWExD3TmNj=kOhaJN2Or1p5VXC=P0-YPv97NQ@mail.gmail.com>
Message-ID: <CAHk-=wj7y5AJKGWExD3TmNj=kOhaJN2Or1p5VXC=P0-YPv97NQ@mail.gmail.com>
Subject: Re: writeback completion soft lockup BUG in folio_wake_bit()
To:     Tim Chen <tim.c.chen@linux.intel.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 12:39 PM Tim Chen <tim.c.chen@linux.intel.com> wrote:
>
> I do think that the original locked page on migration problem was fixed
> by commit 9a1ea439b16b. Unfortunately the customer did not respond to
> us when we asked them to test their workload when that patch went
> into the mainline.

Oh well.

> I don't have objection to Matthew's fix to remove the bookmark code,
> now that it is causing problems with this scenario that I didn't
> anticipate in my original code.

I'd really like to avoid *another* "we can't actually verify that this
helps" change in this area, so I'm hoping that the reporter that Dan
was talking to could test that patch.

Otherwise we're kind of going back-and-forth based on "this might fix
things", which just feels really fragile and reminds me of the bad old
days when we had the "one step forward, two steps back" dance with
some of the suspend/resume issues.

I realize that this code needs some extreme loads (and likely pretty
special hardware too) to actually become problematic, so testing is
_always_ going to be a bit of a problem, but still...

               Linus
