Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6D7C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 18:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240281AbiCRS7y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 14:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237336AbiCRS7x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 14:59:53 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B524CBF975
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 11:58:34 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id bu29so15601067lfb.0
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 11:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZDmW+p2ypjT1HjKWJx8fh+7ifv3HKZNMXtvuE6nm2qs=;
        b=XHm5zI8ZBbpkWBIg6jHxN78K61Pegw6nnLu5ZR3iY8VEia03dmDXc3bRlF28jroE23
         doUqgjtYjvMH/budaSJuXxwTsP9wm1X3caE0hvtLwEj1Yzt9y1nJKLAZWQpSC1IyN0hj
         mypuoFL+N7hevvkbbmj5/rf2VzcZF7ajqMqyI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZDmW+p2ypjT1HjKWJx8fh+7ifv3HKZNMXtvuE6nm2qs=;
        b=XKaVkHZonaTTefY/Gq+yJSud1kvBorh3L+fHQ72vmXXbrYjgnH6OnzvpjKcwb+nZaZ
         +w280tZ8YMjgtiNDQRrD0md9vzh1KTQ9N/GSav4kSIklHSSwockFSSlkvc66jtolPpEc
         1LjsAlGj+6/LfPouhzqIRK3NAemWOpjfGTeiqLU5j5oZMM7XRJdCw9N8wKTIE/NgVDQd
         XjnDgnDMq2k08F/aKUNi41MNIfnY/42HzKsuRntFTXiNo+/ZgaUMTz1v9Td0+HLV4Jv9
         iw4yKcpg8gDzL0cBX5E7fELtSmzvI3OooNFVcfrzFeoaqptTWZajDGM4JuXtZOpIkHrn
         8lbQ==
X-Gm-Message-State: AOAM532me2DzisKT7N2g357IqkjeVufYV0L2Q4KnGlvfJ9Fxq++F2+Zl
        ycmbBHpxSZ9OQ6lPI/TW35cmOQfrvaQqQh54kDI=
X-Google-Smtp-Source: ABdhPJy0jxOzZIPp82x73vUooRg9s1lDIc4qQjXxyCKE4EGc9jjfKyi1TpNcmKy8cfptR24uUywfBg==
X-Received: by 2002:ac2:5fc1:0:b0:448:2915:3306 with SMTP id q1-20020ac25fc1000000b0044829153306mr6528950lfg.109.1647629912767;
        Fri, 18 Mar 2022 11:58:32 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id h7-20020ac25d67000000b0044836d7c475sm964073lft.147.2022.03.18.11.58.31
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 11:58:31 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id y17so12392693ljd.12
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 11:58:31 -0700 (PDT)
X-Received: by 2002:a2e:a78f:0:b0:249:21ce:6d53 with SMTP id
 c15-20020a2ea78f000000b0024921ce6d53mr6973185ljf.164.1647629910974; Fri, 18
 Mar 2022 11:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <YjDj3lvlNJK/IPiU@bfoster> <YjJPu/3tYnuKK888@casper.infradead.org>
 <YjM88OwoccZOKp86@bfoster> <YjSTq4roN/LJ7Xsy@bfoster> <YjSbHp6B9a1G3tuQ@casper.infradead.org>
In-Reply-To: <YjSbHp6B9a1G3tuQ@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 18 Mar 2022 11:58:14 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh6V6TZjjnqBvktbaho_wqfjZYQ9zcKJTV8EP2Kygn0uQ@mail.gmail.com>
Message-ID: <CAHk-=wh6V6TZjjnqBvktbaho_wqfjZYQ9zcKJTV8EP2Kygn0uQ@mail.gmail.com>
Subject: Re: writeback completion soft lockup BUG in folio_wake_bit()
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 18, 2022 at 7:45 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> Excellent!  I'm going to propose these two patches for -rc1 (I don't
> think we want to be playing with this after -rc8)

Ack. I think your commit message may be a bit too optimistic (who
knows if other loads can trigger the over-long page locking wait-queue
latencies), but since I don't see any other ways to really check this
than just trying it, let's do it.

                 Linus
