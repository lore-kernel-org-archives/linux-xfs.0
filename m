Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 222EDC2D0E4
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 23:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D21792100A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 23:31:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eMtd8miS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388776AbgKXXb7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 18:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388294AbgKXXb7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 18:31:59 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA671C0613D6
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 15:31:58 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id j10so315464lja.5
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 15:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vZpDzZfRGW5JQ+z/SLaL70l0Y+Id271dyPmoJFXV3Yg=;
        b=eMtd8miSV5Q4HzVm9lx1snZ252JU2LUG08CXEG9MZekZ6i7RMmkka/lMY+IPVuJ23L
         PqhYtLLZg6ffJmiv3yaDYTznuv3dIQ4YBw1pOJz9r2vKjiack1bfddd/lir5cfbryUH+
         /Jt2/UYsF/gTRVYdgZmuNAbHMgKvTDtyzGHaA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vZpDzZfRGW5JQ+z/SLaL70l0Y+Id271dyPmoJFXV3Yg=;
        b=ZxzQJdnhL0xoVWAoE/znQOSAMQ3zohXKbh2mjkWUUP/wVaLoO/u71naAldaR3LoPFk
         vSed6Y5KAFGy2ejYcgMHLD/X1w2Lkr4VJnHETkZkhGa3902Z6TEzcEzqZ+p4KGPIVr8t
         ZKlac0vbv06DA7V9sVvUeuvLEIpCfaK53YLvnAnoY1MrOXRmVp77s88ewENL9vWF3Q4T
         Yd8EB6RZkE9t4GEAxt7kFGrg3g8TVVXxJRQPOW4H/pcR7+h3jlQMTuFyYa3lvUu6S/b6
         mIcX6FTGOzneEB+Ii6DW/l5SrfJnEzcNrD7ApOQu55ru5lZHBW7oOUrbDtfjh3apYvTo
         fW+A==
X-Gm-Message-State: AOAM5327hhL6smzKAKXoaG7TqCkH4d1wrqpm/xHt8xTUVzfRwiUCFkcx
        fsqacR+mXKoklbpD6KaTGeRP0GAqslpceg==
X-Google-Smtp-Source: ABdhPJwLDGnDY2y5MaF/umIxRPf6V8CuF9fddLZhsv6gHJxFg9HoXpCAG5hn0FkEWiiCbRqjBYBZaA==
X-Received: by 2002:a2e:a584:: with SMTP id m4mr243658ljp.173.1606260717036;
        Tue, 24 Nov 2020 15:31:57 -0800 (PST)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id v16sm56120ljj.0.2020.11.24.15.31.56
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 15:31:56 -0800 (PST)
Received: by mail-lj1-f181.google.com with SMTP id o24so308358ljj.6
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 15:31:56 -0800 (PST)
X-Received: by 2002:a19:ed0f:: with SMTP id y15mr172684lfy.352.1606260312243;
 Tue, 24 Nov 2020 15:25:12 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d3a33205add2f7b2@google.com> <20200828100755.GG7072@quack2.suse.cz>
 <20200831100340.GA26519@quack2.suse.cz> <CAHk-=wivRS_1uy326sLqKuwerbL0APyKYKwa+vWVGsQg8sxhLw@mail.gmail.com>
 <alpine.LSU.2.11.2011231928140.4305@eggly.anvils> <20201124121912.GZ4327@casper.infradead.org>
 <alpine.LSU.2.11.2011240810470.1029@eggly.anvils> <20201124183351.GD4327@casper.infradead.org>
 <CAHk-=wjtGAUP5fydxR8iWbzB65p2XvM0BrHE=PkPLQcJ=kq_8A@mail.gmail.com>
 <20201124201552.GE4327@casper.infradead.org> <CAHk-=wj9n5y7pu=SVVGwd5-FbjMGS6uoFU4RpzVLbuOfwBifUA@mail.gmail.com>
 <alpine.LSU.2.11.2011241322540.1777@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.2011241322540.1777@eggly.anvils>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 24 Nov 2020 15:24:56 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjiVtroOvNkuptH0GofVUvOMw4wmmaXdnGPPT8y8+MbyQ@mail.gmail.com>
Message-ID: <CAHk-=wjiVtroOvNkuptH0GofVUvOMw4wmmaXdnGPPT8y8+MbyQ@mail.gmail.com>
Subject: Re: kernel BUG at fs/ext4/inode.c:LINE!
To:     Hugh Dickins <hughd@google.com>
Cc:     Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
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

On Tue, Nov 24, 2020 at 1:47 PM Hugh Dickins <hughd@google.com> wrote:
>
> I think the unreferenced struct page asks for trouble.

I do agree.

I've applied your second patch (the smaller one that just takes a ref
around the critical section). If somebody comes up with some great
alternative, we can always revisit this.

            Linus
