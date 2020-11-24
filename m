Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A87C64E75
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 04:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6C192086A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 04:27:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qo/w8pRw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgKXE1K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Nov 2020 23:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbgKXE1J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Nov 2020 23:27:09 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F30C061A4D
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2020 20:27:09 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id i17so20523061ljd.3
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2020 20:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=24cszGpR4ywO4s4bnLwJTzF6tXtNEZ3Sx4FvfUI5fRM=;
        b=Qo/w8pRweB3KyHg3F/WpjXkumwlz+D/AvIsfhGajTbc5rxWuFX6axMRr2JB4kSL4pA
         hIBC4OqrP3RwB25oHrD6ZaKBqVFGtNoYL6Y4nSMoCfYeCeQOINqE3jTOyTbnWeWoHLiI
         UkFQ9R+vhIKbEe6WKzj2zXtFUjc557jUOVygU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=24cszGpR4ywO4s4bnLwJTzF6tXtNEZ3Sx4FvfUI5fRM=;
        b=TiqLhytTFwSaMp1p9AYCnsgNoOkSnaoKH8je680lK4tgMNGzk3Bx9H/SPEzcH7owHe
         v1/qUqi/h5pv0qGVABj8a4fvcuxxRZMijjXZd+jn/wOhrbwHtiTpnnRPO1o++xy1zxhx
         6u4CNdizdSBUfe7M2fAwT7P5hRahz4KFVT8aMANDusYf7XrW/0Bo2HA91mb9uRjHg8M0
         NMJQptu95aMKlb10XhzRG8aRqBnOc9j5wDplrdSda7+U7on+oUQ7jnEN1wx6cfTVyPJM
         H6WnaedagY5/UFvhNKfxYRzKoNBRnlprDIMNNaQMF/eZvavQ7W6qnYx4JzmkdiJLb4da
         uo3w==
X-Gm-Message-State: AOAM530ylgyX4r28YuPqEUnZW8nWLSwOSBDvvwvGxlOyTNe+rdZItctU
        rXx0RjwQboCCBaIfrBRLXQY09vfNulwg+w==
X-Google-Smtp-Source: ABdhPJwNzGBgA6pBKMv4q9sYnVTanEAi0MQCc+PRghGWSatRnJrohwbK7Tsbk9i+LWPEfIe/CmodNQ==
X-Received: by 2002:a2e:8143:: with SMTP id t3mr971885ljg.269.1606192027506;
        Mon, 23 Nov 2020 20:27:07 -0800 (PST)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id i5sm1597636lfl.53.2020.11.23.20.27.06
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 20:27:07 -0800 (PST)
Received: by mail-lf1-f45.google.com with SMTP id d20so11070068lfe.11
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2020 20:27:06 -0800 (PST)
X-Received: by 2002:a19:3f55:: with SMTP id m82mr1019862lfa.344.1606192024162;
 Mon, 23 Nov 2020 20:27:04 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d3a33205add2f7b2@google.com> <20200828100755.GG7072@quack2.suse.cz>
 <20200831100340.GA26519@quack2.suse.cz> <CAHk-=wivRS_1uy326sLqKuwerbL0APyKYKwa+vWVGsQg8sxhLw@mail.gmail.com>
 <alpine.LSU.2.11.2011231928140.4305@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.2011231928140.4305@eggly.anvils>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 23 Nov 2020 20:26:48 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjcSFM+aqLnh7ucx3_tHpc1+9sJ+FfhSgVFH316uX2FZQ@mail.gmail.com>
Message-ID: <CAHk-=wjcSFM+aqLnh7ucx3_tHpc1+9sJ+FfhSgVFH316uX2FZQ@mail.gmail.com>
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
> The problem is that PageWriteback is not accompanied by a page reference
> (as the NOTE at the end of test_clear_page_writeback() acknowledges): as
> soon as TestClearPageWriteback has been done, that page could be removed
> from page cache, freed, and reused for something else by the time that
> wake_up_page() is reached.

Ugh.

Would it be possible to instead just make PageWriteback take the ref?

I don't hate your patch per se, but looking at that long explanation,
and looking at the gyrations end_page_writeback() does, I go "why
don't we do that?"

IOW, why couldn't we just make the __test_set_page_writeback()
increment the page count if the writeback flag wasn't already set, and
then make the end_page_writeback() do a put_page() after it all?

            Linus
