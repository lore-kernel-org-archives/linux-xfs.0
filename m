Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37627C56202
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 20:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7CFE2068D
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 20:35:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YiUauuLl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbgKXUey (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 15:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731196AbgKXUex (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 15:34:53 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D11C0613D6
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 12:34:51 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id m16so201054edr.3
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 12:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AEOjqbrPL7ThHmqZn4HHPdQNZCU9KRjN0OANoYqF+LI=;
        b=YiUauuLl4oDGTRL45zuGDHR2J5VSlaFB7O6pBpiLin0jYi4oMDEyJ6WnB0ezsU1+lJ
         /Xr+VMmFy6Yl0v0tfocLf0a2OpJoR4jkrZf+QWqP87nKzXSlOFC8xx9JTBLeqme23GEA
         yBj2rHCTti3flo3PfXBjCwjdx6z70F417NynU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AEOjqbrPL7ThHmqZn4HHPdQNZCU9KRjN0OANoYqF+LI=;
        b=cxUTHRS+E5PbIrVXtclw0do8LUskpuOnxLfvZHeJOOT2Sr1J0kW/W84fdNNyDYhnDG
         zQCBExQE+kS27zm31Q0+Q2eSwSAdtUY4x4pXVGq80cobg9CVmoRKvzSTZEWBRd62bzs6
         h/4wjXg2xYRs1w2FRfjO7u/Uej55Ojp1nSY9gtiKQRhcdeR6gDRWe+QL8UyDTChV7x0l
         VkM1vuKlvadkJp/7s2Myflj8ztI2D75VMZbiB7Mg2B81C29UJPt7on3IGL+mBOBYxTJ3
         sd52bFM8H7SN65BWlJxI57E0YBmG5KUpJWRdxlVTuXMSMCifmYd4hwDozZVP7V8KrTKR
         cCog==
X-Gm-Message-State: AOAM530TIij0/7Uc3CmkU8tNth+bNgJlBZWMO1/qw/bT3JkdbJrL9AnI
        7aPVIEnBGkMm+GRgAASiUOu5LQuCnp9piA==
X-Google-Smtp-Source: ABdhPJy0zeq5RFnRrrMOAq5OWeInXK2gBSJKjOZ+PC+kTuzTRbn/GX6evAJzIYjvJsNOzvC8sHRGOg==
X-Received: by 2002:a50:fb07:: with SMTP id d7mr265396edq.169.1606250090631;
        Tue, 24 Nov 2020 12:34:50 -0800 (PST)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id q14sm7507210eds.80.2020.11.24.12.34.50
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 12:34:50 -0800 (PST)
Received: by mail-wr1-f44.google.com with SMTP id g14so8483913wrm.13
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 12:34:50 -0800 (PST)
X-Received: by 2002:a2e:8701:: with SMTP id m1mr27321lji.314.1606250089295;
 Tue, 24 Nov 2020 12:34:49 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d3a33205add2f7b2@google.com> <20200828100755.GG7072@quack2.suse.cz>
 <20200831100340.GA26519@quack2.suse.cz> <CAHk-=wivRS_1uy326sLqKuwerbL0APyKYKwa+vWVGsQg8sxhLw@mail.gmail.com>
 <alpine.LSU.2.11.2011231928140.4305@eggly.anvils> <20201124121912.GZ4327@casper.infradead.org>
 <alpine.LSU.2.11.2011240810470.1029@eggly.anvils> <20201124183351.GD4327@casper.infradead.org>
 <CAHk-=wjtGAUP5fydxR8iWbzB65p2XvM0BrHE=PkPLQcJ=kq_8A@mail.gmail.com> <20201124201552.GE4327@casper.infradead.org>
In-Reply-To: <20201124201552.GE4327@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 24 Nov 2020 12:34:33 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj9n5y7pu=SVVGwd5-FbjMGS6uoFU4RpzVLbuOfwBifUA@mail.gmail.com>
Message-ID: <CAHk-=wj9n5y7pu=SVVGwd5-FbjMGS6uoFU4RpzVLbuOfwBifUA@mail.gmail.com>
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

On Tue, Nov 24, 2020 at 12:16 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> So my s/if/while/ suggestion is wrong and we need to do something to
> prevent spurious wakeups.  Unless we bury the spurious wakeup logic
> inside wait_on_page_writeback() ...

We can certainly make the "if()" in that loop be a "while()'.

That's basically what the old code did - simply by virtue of the
wakeup not happening if the writeback bit was set in
wake_page_function():

        if (test_bit(key->bit_nr, &key->page->flags))
                return -1;

of course, the race was still there - because the writeback bit might
be clear at that point, but another CPU would reallocate and dirty it,
and then autoremove_wake_function() would happen anyway.

But back in the bad old days, the wait_on_page_bit_common() code would
then double-check in a loop, so it would catch that case, re-insert
itself on the wait queue, and try again. Except for the DROP case,
which isn't used by writeback.

Anyway, making that "if()" be a "while()" in wait_on_page_writeback()
would basically re-introduce that old behavior. I don't really care,
because it was the lock bit that really mattered, the writeback bit is
not really all that interesting (except from a "let's fix this bug"
angle)

I'm not 100% sure I like the fragility of this writeback thing.

Anyway, I'm certainly happy with either model, whether it be an added
while() in wait_on_page_writeback(), or it be the page reference count
in end_page_writeback().

Strong opinions?

            Linus
