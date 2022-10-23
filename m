Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AB8C3A59D
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Oct 2022 22:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJWWie (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Oct 2022 18:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJWWid (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Oct 2022 18:38:33 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7DB5720A
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 15:38:32 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id a5so5225305qkl.6
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 15:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/UZTxhTvsbmMSOgEXTH+zor/VLnuGIVlDQauO0NokYw=;
        b=LaiaDOv7LosGQH8OAA/CL1Kep0uh24JOI4avmJJz/WFxiE13j8DCwkLK2zTx8EHmUd
         4aAjNWmftEw55A1hvqz6OedrOo3y8KfnuZS7DdJ/GJ4GlPYe5vpei5/jEcSLRjIXtfe8
         dZvMtCbGCS9QFrIeS/y2poVrLgiIgghmqw+OU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/UZTxhTvsbmMSOgEXTH+zor/VLnuGIVlDQauO0NokYw=;
        b=XZLnvEt4IfYKobmMPDp0c90rdu7cgNv6BdabAjac7L8ucv07fjzkioVKy6f8DFy9Zj
         U59IYN5HmnCOfVPF/cQLAgMUM9CPSRjgTIaZ4VwJcvNH5MUqElyv44M2gM5iiVYOLB0t
         jGJj3Vsd9aFIDmLBdPubjwjeXgF0PFUPUdJ3V5EJIDrIHAZJreZLKtg9ziW+EZxi4+JG
         SAXitevxzrRMSoU+t1qIFLPCuRcfm066iDS/c36GoRFNM/iB/kIqchED0vm8Z4AnXRqQ
         zm/NntBzWgiBD6qT6O0RTKTGKZjVepcQ8zhGPIMYAg+rG0HMuuavaCn5tRDhBU6LGc2O
         1PRA==
X-Gm-Message-State: ACrzQf1IZ3RpFJ4gppn38dkAYIS3qvQKSIaIv8aAntYC27Lf4Yrkhk+v
        eXFhP7RVHXDqFegqsoPBj60Zojfj5Lz9Og==
X-Google-Smtp-Source: AMsMyM61IT26Q2grZwRUtMXhV9W2KMjSq4Tq0goDwZlhHe6eEJ99S7P28DcCoPqiT7yDgwQ+P13uZg==
X-Received: by 2002:a05:620a:1709:b0:6ed:4817:1d02 with SMTP id az9-20020a05620a170900b006ed48171d02mr21318314qkb.73.1666564711366;
        Sun, 23 Oct 2022 15:38:31 -0700 (PDT)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com. [209.85.128.180])
        by smtp.gmail.com with ESMTPSA id t28-20020a37ea1c000000b006f3e6933bacsm2539593qkj.113.2022.10.23.15.38.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Oct 2022 15:38:30 -0700 (PDT)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-36a4b86a0abso55661857b3.7
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 15:38:30 -0700 (PDT)
X-Received: by 2002:a81:d34c:0:b0:349:1e37:ce4e with SMTP id
 d12-20020a81d34c000000b003491e37ce4emr26546851ywl.112.1666564710035; Sun, 23
 Oct 2022 15:38:30 -0700 (PDT)
MIME-Version: 1.0
References: <YjDj3lvlNJK/IPiU@bfoster> <YjJPu/3tYnuKK888@casper.infradead.org>
 <YjM88OwoccZOKp86@bfoster> <YjSTq4roN/LJ7Xsy@bfoster> <YjSbHp6B9a1G3tuQ@casper.infradead.org>
 <CAHk-=wh6V6TZjjnqBvktbaho_wqfjZYQ9zcKJTV8EP2Kygn0uQ@mail.gmail.com> <6350a5f07bae2_6be12944c@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <6350a5f07bae2_6be12944c@dwillia2-xfh.jf.intel.com.notmuch>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 23 Oct 2022 15:38:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wizsHtGa=7dESxXd6VNU2mdHqhvCv88FB3xcWb3o3iJMw@mail.gmail.com>
Message-ID: <CAHk-=wizsHtGa=7dESxXd6VNU2mdHqhvCv88FB3xcWb3o3iJMw@mail.gmail.com>
Subject: Re: writeback completion soft lockup BUG in folio_wake_bit()
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 19, 2022 at 6:35 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> A report from a tester with this call trace:
>
>  watchdog: BUG: soft lockup - CPU#127 stuck for 134s! [ksoftirqd/127:782]
>  RIP: 0010:_raw_spin_unlock_irqrestore+0x19/0x40 [..]

Whee.

> ...lead me to this thread. This was after I had them force all softirqs
> to run in ksoftirqd context, and run with rq_affinity == 2 to force
> I/O completion work to throttle new submissions.
>
> Willy, are these headed upstream:
>
> https://lore.kernel.org/all/YjSbHp6B9a1G3tuQ@casper.infradead.org
>
> ...or I am missing an alternate solution posted elsewhere?

Can your reporter test that patch? I think it should still apply
pretty much as-is.. And if we actually had somebody who had a
test-case that was literally fixed by getting rid of the old bookmark
code, that would make applying that patch a no-brainer.

The problem is that the original load that caused us to do that thing
in the first place isn't repeatable because it was special production
code - so removing that bookmark code because we _think_ it now hurts
more than it helps is kind of a big hurdle.

But if we had some hard confirmation from somebody that "yes, the
bookmark code is now hurting", that would make it a lot more palatable
to just remove the code that we just _think_ that probably isn't
needed any more..

                  Linus
