Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E3CC07E95
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 21:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AB9F613FB
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 21:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhGBVmm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 17:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhGBVmk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 17:42:40 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BB6C061762
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jul 2021 14:40:07 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id u20so15121998ljo.12
        for <linux-xfs@vger.kernel.org>; Fri, 02 Jul 2021 14:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RZqwALtsQH508tfhUhLkddcNRdEqyv+/EhplpEdJ7pE=;
        b=W9R8pciJeHPopheaM4dxRYQGRdFdnYvt5IhQAOtvo0wWZduPQ99gAJNxhkarmUN9Hj
         WBqvxUAZ4TG638+jnCmrTHQQ7u9tdOYur+Rqk4LCJW+cox858p4xQOB9IY1rCKsWBLYh
         ky2fTm14sB1+RbkbNhx6IdQIjkFO+r2Z6YPkU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RZqwALtsQH508tfhUhLkddcNRdEqyv+/EhplpEdJ7pE=;
        b=PMtF2qbhNAruMVsgrlvlDWRGLmkQTUPx0bBwkqG0RFMWQYkH3Y5OmPnZQ05JXBQ7ox
         odZoeZRSx2v3TIzrW2Mi8QTPb0Wjaa/sEOiDZ9oAG33KNag8K9qW9YwnamySSZ+nRIEu
         3xxVYILsNeX4RSDoMruGa5Pq3gVizhEmx1b6A+eUzX1rdN1h+1QcLa92Zh5zrjviiqPA
         LU8CawSjvlp/xw79+M9iqTDmpwTufl0J7wcVfzy/nRz33iRHKbUkJ+//N11bWncZiTET
         yHiAJ3jgoBfICz3b6+4GBBUNYe9q3Q5LcSQQNgETFjixIEaG+map9T1r17hIru2E0f2p
         ob8g==
X-Gm-Message-State: AOAM531ngAiOmLdRFY3L8n9z220T0SBmyvQfBNjGfHbKl4vCsbLbN8Ww
        zBWC/Wbs5SIxelB73RXdHUEEVdOT/Z53F8XInec=
X-Google-Smtp-Source: ABdhPJwj6lcl4Li4OtPZvsG6pDzoPekAmrGwjhc+dW7MJjSluc3qKRiGXBEGuwe87W3StCK4zkGBPQ==
X-Received: by 2002:a2e:2ac3:: with SMTP id q186mr1133190ljq.500.1625262005280;
        Fri, 02 Jul 2021 14:40:05 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id v21sm378139lfr.192.2021.07.02.14.40.04
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 14:40:04 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id u20so15121928ljo.12
        for <linux-xfs@vger.kernel.org>; Fri, 02 Jul 2021 14:40:04 -0700 (PDT)
X-Received: by 2002:a2e:9c58:: with SMTP id t24mr1096050ljj.411.1625262004353;
 Fri, 02 Jul 2021 14:40:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210702201643.GA13765@locust>
In-Reply-To: <20210702201643.GA13765@locust>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 2 Jul 2021 14:39:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjaCmLbgtSXjVA19HZO6RS8rNePjUf6HuMa3PoDS9VuSQ@mail.gmail.com>
Message-ID: <CAHk-=wjaCmLbgtSXjVA19HZO6RS8rNePjUf6HuMa3PoDS9VuSQ@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: new code for 5.14
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 2, 2021 at 1:16 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> Please let me know if anything else strange happens during the merge
> process.  The merge commits I made seem stable enough, but as it's the
> first time I've ever accepted a pull request, we'd all be open to
> feedback for improvements for next time.

It looks fine to me.

I *would* suggest editing the merge commit messages a bit when doing
pull requests from other people.

It's by no means a big deal, but it looks a bit odd to see things like

    Hi all,

   ...

    Questions, comment and feedback appreciated!

    Thanks all!
    Allison

in the merge message. All that text made a ton of sense in Allison's
pull request, but as you actually then merge it, it doesn't make a lot
of sense in the commit log, if you see what I mean..

But it's not a problem for this pull request, and I've merged it in my
tree (pending my usual build tests etc, and I don't expect any
issues).

            Linus
