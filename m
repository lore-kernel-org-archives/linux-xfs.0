Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2237C63798
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 04:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D9A92085B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 04:53:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SwaVIz6Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgKXExl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Nov 2020 23:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgKXExk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Nov 2020 23:53:40 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A70BC0613CF
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2020 20:53:40 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id y7so5629415lji.8
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2020 20:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=39gr2tFdgeuXdCwWbn22GRnP3K3VvibhIlGf9k17rGw=;
        b=SwaVIz6ZuT6iXE5tagOrwT7N6KNmmSkcEsDFfOdmzj5yjFEuDkdXhaHbzf22ipogzf
         zWRWhpolqbEMbnZmb7w8SY8YssaOfvRbra2P6MvkDrdQIcceCNS8eCPycSxvqCyBE/Wt
         Aogcb79k9z8ri+jJ6nmyXvkP8hv8F792ZSl3g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=39gr2tFdgeuXdCwWbn22GRnP3K3VvibhIlGf9k17rGw=;
        b=RXZdXcIm1HVh4BwZr7GtzHH/YV3cAIAV8O3fWCWbbJ+gs5Ca9TRtHkHVDlWjZjs4+f
         bEKiSMsxyVeCamfVfavcjGF7B3CbHLIDRt7NtmbHLfOCsuM4njXHCp0uWZiU7fiks2th
         m/q8ioFkMCwpLIZI7dgNvzUjR8L8UDwedwveP8XW+N/zkmHUO3wKWzTup3R850vBIwFw
         VI7akLH6rr2gUwotXCOa5BekawY3pzeUYgFbVYHVCZaDbkybIuQjC/TqPDY/3dXeL17u
         VPz4yqhO+GzVFoBwuiaPH61/LAtHIFdo2YYpou00n4YFMN9MbZCCIybTE6wqLMOT0NFT
         0dTA==
X-Gm-Message-State: AOAM533k8WEXS3XmOr9cC0EnnKaFRHYDmKsWYAMNy8GfCTehzkBeskuw
        4RSeHuaaTsQiND5xkF4JGj7W59diGVn01w==
X-Google-Smtp-Source: ABdhPJxyg4s1toj0Nd9SlSuYgr7OiEIV+o3o/nFSXi57EnnzEps/FOC38MnIEv9+kQ1y4T5n+mXqcA==
X-Received: by 2002:a2e:8e97:: with SMTP id z23mr1082619ljk.230.1606193618777;
        Mon, 23 Nov 2020 20:53:38 -0800 (PST)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id 16sm1593403lfk.186.2020.11.23.20.53.37
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 20:53:38 -0800 (PST)
Received: by mail-lj1-f178.google.com with SMTP id i17so20567976ljd.3
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2020 20:53:37 -0800 (PST)
X-Received: by 2002:a19:ae06:: with SMTP id f6mr1057406lfc.133.1606193616810;
 Mon, 23 Nov 2020 20:53:36 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d3a33205add2f7b2@google.com> <20200828100755.GG7072@quack2.suse.cz>
 <20200831100340.GA26519@quack2.suse.cz> <CAHk-=wivRS_1uy326sLqKuwerbL0APyKYKwa+vWVGsQg8sxhLw@mail.gmail.com>
 <alpine.LSU.2.11.2011231928140.4305@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.2011231928140.4305@eggly.anvils>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 23 Nov 2020 20:53:20 -0800
X-Gmail-Original-Message-ID: <CAHk-=whYO5v09E8oHoYQDn7qqV0hBu713AjF+zxJ9DCr1+WOtQ@mail.gmail.com>
Message-ID: <CAHk-=whYO5v09E8oHoYQDn7qqV0hBu713AjF+zxJ9DCr1+WOtQ@mail.gmail.com>
Subject: Re: kernel BUG at fs/ext4/inode.c:LINE!
To:     Hugh Dickins <hughd@google.com>
Cc:     Jan Kara <jack@suse.cz>,
        syzbot <syzbot+3622cea378100f45d59f@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Linux-MM <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Nicholas Piggin <npiggin@gmail.com>,
        Alex Shi <alex.shi@linux.alibaba.com>, Qian Cai <cai@lca.pw>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        William Kucharski <william.kucharski@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 23, 2020 at 8:07 PM Hugh Dickins <hughd@google.com> wrote:
>
> Then on crashing a second time, realized there's a stronger reason against
> that approach.  If my testing just occasionally crashes on that check,
> when the page is reused for part of a compound page, wouldn't it be much
> more common for the page to get reused as an order-0 page before reaching
> wake_up_page()?  And on rare occasions, might that reused page already be
> marked PageWriteback by its new user, and already be waited upon?  What
> would that look like?
>
> It would look like BUG_ON(PageWriteback) after wait_on_page_writeback()
> in write_cache_pages() (though I have never seen that crash myself).

So looking more at the patch, I started looking at this part:

> +       writeback = TestClearPageWriteback(page);
> +       /* No need for smp_mb__after_atomic() after TestClear */
> +       waiters = PageWaiters(page);
> +       if (waiters) {
> +               /*
> +                * Writeback doesn't hold a page reference on its own, relying
> +                * on truncation to wait for the clearing of PG_writeback.
> +                * We could safely wake_up_page_bit(page, PG_writeback) here,
> +                * while holding i_pages lock: but that would be a poor choice
> +                * if the page is on a long hash chain; so instead choose to
> +                * get_page+put_page - though atomics will add some overhead.
> +                */
> +               get_page(page);
> +       }

and thinking more about this, my first reaction was "but that has the
same race, just a smaller window".

And then reading the comment more, I realize you relied on the i_pages
lock, and that this odd ordering was to avoid the possible latency.

But what about the non-mapping case? I'm not sure how that happens,
but this does seem very fragile.

I'm wondering why you didn't want to just do the get_page()
unconditionally and early. Is avoiding the refcount really such a big
optimization?

            Linus
