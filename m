Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF06C2D0E4
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 19:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBCBE206E5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 19:07:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dmXydy1i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390893AbgKXTHT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 14:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390956AbgKXTHS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 14:07:18 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F54C0613D6
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 11:07:15 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id cq7so22047340edb.4
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 11:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UJx0vHStpjdpABeEWpHqZ5R1kGbrDvDIbtQyZ0Zhqxc=;
        b=dmXydy1iMYMcd0XA86NtUQBuK77rLN5v+kCemhoSI8sSKW0ZRUU4BOa40Nc/j8TZ1H
         sUEPaPfvxYlaUXBxTnerkp0eTXuq+POTIYnXmeE1NOsrDnQWhHfi6trKluzdjlU1lbtI
         5f/uYvPlgWdyj4CpKpPEHo4H4FSJGyyvBfUWQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UJx0vHStpjdpABeEWpHqZ5R1kGbrDvDIbtQyZ0Zhqxc=;
        b=S4VHHXvd2GS916f4G7DLjz56l7gVwUwifbwa37RqnSVsSOOFt/o/eelxv+lIyC1qIA
         eCmMa+EpZ1KUVD4NqiaWVmbax7eTLmqrt6k8qIdmAgI7I/gExoAQJrXBxhAeOiMzMUiI
         bBmETulsPel4Iu/2b8U6QE9M9Hnoa94+LtwSlmn66QlbvwBz4Rz7i0czJXA3x1B3upX3
         6StKAdxjitl/fKnSY/Lw349VrRUclMlmXZws53ZVtu7eVyF+m5kBAVd7YYcsPR7JbU5h
         enng+d29jrRfCmoNBQYqDToehOGO+5GeomGQw2xIhWl/60FcGLUpAKn/g/Qi8Fxt2KtJ
         ACBw==
X-Gm-Message-State: AOAM5314j5IFrbM2cKGAoA+rJREH8hrFtjfqysWG6f+PLAiOEssFHDVX
        OqPPmvMnKCxWS8y7/eT2sGJ4FcQenOdv7w==
X-Google-Smtp-Source: ABdhPJz6XpqprDlRCzX3lp4fqsQIacPVycxTrji9yJxzE8lseEBTqG9GiDQ4lfn9moHL+GnXzZa+pQ==
X-Received: by 2002:a05:6402:149a:: with SMTP id e26mr5564301edv.232.1606244833703;
        Tue, 24 Nov 2020 11:07:13 -0800 (PST)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id d10sm7310246ejw.44.2020.11.24.11.07.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 11:07:13 -0800 (PST)
Received: by mail-ej1-f53.google.com with SMTP id k27so30018729ejs.10
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 11:07:13 -0800 (PST)
X-Received: by 2002:a05:651c:339:: with SMTP id b25mr2577530ljp.285.1606244458511;
 Tue, 24 Nov 2020 11:00:58 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d3a33205add2f7b2@google.com> <20200828100755.GG7072@quack2.suse.cz>
 <20200831100340.GA26519@quack2.suse.cz> <CAHk-=wivRS_1uy326sLqKuwerbL0APyKYKwa+vWVGsQg8sxhLw@mail.gmail.com>
 <alpine.LSU.2.11.2011231928140.4305@eggly.anvils> <20201124121912.GZ4327@casper.infradead.org>
 <alpine.LSU.2.11.2011240810470.1029@eggly.anvils> <20201124183351.GD4327@casper.infradead.org>
In-Reply-To: <20201124183351.GD4327@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 24 Nov 2020 11:00:42 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjtGAUP5fydxR8iWbzB65p2XvM0BrHE=PkPLQcJ=kq_8A@mail.gmail.com>
Message-ID: <CAHk-=wjtGAUP5fydxR8iWbzB65p2XvM0BrHE=PkPLQcJ=kq_8A@mail.gmail.com>
Subject: Re: kernel BUG at fs/ext4/inode.c:LINE!
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
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
        William Kucharski <william.kucharski@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 24, 2020 at 10:33 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> We could fix this by turning that 'if' into a 'while' in
> write_cache_pages().

That might be the simplest patch indeed.

At the same time, I do worry about other cases like this: while
spurious wakeup events are normal and happen in other places, this is
a bit different.

This is literally a wakeup that leaks from a previous use of a page,
and makes us think that something could have happened to the new use.

The unlock_page() case presumably never hits that, because even if we
have some unlock without a page ref (which I don't think can happen,
but whatever..), the exclusive nature of "lock_page()" means that no
locker can care - once you get the lock, you own the page./

The writeback code is special in that the writeback bit isn't some
kind of exclusive bit, but this code kind of expected it to be that.

So I'd _like_ to have something like

        WARN_ON_ONCE(!page_count(page));

in the wake_up_page_bit() function, to catch things that wake up a
page that has already been released and might be reused..

And that would require the "get_page()" to be done when we set the
writeback bit and queue the page up for IO (so that then
end_page_writeback() would clear the bit, do the wakeup, and then drop
the ref).

Hugh's second patch isn't pretty - I think the "get_page()" is
conceptually in the wrong place - but it "works" in that it keeps that
"implicit page reference" being kept by the PG_writeback bit, and then
it takes an explicit page reference before it clears the bit.

So while I don't love the whole "PG_writeback is an implicit reference
to the page" model, Hugh's patch at least makes that model much more
straightforward: we really either have that PG_writeback, _or_ we have
a real ref to the page, and we never have that odd "we could actually
lose the page" situation.

So I think I prefer Hugh's two-liner over your one-liner suggestion.

But your one-liner is technically not just smaller, it obviously also
avoids the whole mucking with the atomic page ref.

I don't _think_ that the extra get/put overhead could possibly really
matter: doing the writeback is going to be a lot more expensive
anyway. And an atomic access to a 'struct page' sounds expensive, but
that cacheline is already likely dirty in the L1 cache because we've
touch page->flags and done other things to it).

So I'd personally be inclined to go with Hugh's patch. Comments?

                 Linus
