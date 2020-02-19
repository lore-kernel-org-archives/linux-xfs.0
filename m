Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B46BC34050
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 09:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4275E208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 09:22:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="skzdvmlk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgBSJWA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 04:22:00 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33844 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgBSJWA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 04:22:00 -0500
Received: by mail-ot1-f67.google.com with SMTP id j16so22490524otl.1
        for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2020 01:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jnk001kHHnMJZPh5284on/H7ZVuekrqsnplVhw3qKG4=;
        b=skzdvmlkEwjc+AAGfz8cHX6+KV0Ear7q/T2X/aLZyVNB8hYHhuw7952mIi9a+oHsp2
         a1qaqaJ4LCcNqSSVeOrMDRc8eCDQ3PQxS8dNBJdz6Jn23OH1JxI0uxCYBe6DfX+c3Wsv
         BMvlxvoP7fNcpGpjkNUEGOMVNRsOdBPAlrgy+eyisWwxiYxQbtZhI/qyU3ILtNbxWj30
         XJ7Y5/V1GTnfsI37Rl1wHgxVw8Ow3geprTuNTc9F7LzKNG4Bq3L0gtcPzyJIV6b75eUg
         jFoCUoEaq29fBnOKzUjWJKft6VdearndY50Bh6pcEV5S8fsxKTzBy/FpQ9saBVoUf2eO
         DNNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jnk001kHHnMJZPh5284on/H7ZVuekrqsnplVhw3qKG4=;
        b=f3XMxaZJcnBqICFmmSD4+BuLuy7woCjsm4c8UeSM+FJP+u0JiABl1kgwDsbhuXw3WP
         e/R7b0FLOU8mUOgXVkhBZ4Yvb60VAFRtuRLiIn2v99rmfWJhStSpjPtMdfCswhYVUgST
         Veb0vpW/i7oFy4j++wIMgLJDwmpLcDhCVvYywSmSGIZ4vQxKAot/pfPW1jZ8nGZWUj2G
         JhN/BrX8rNHMmT/vb+edzm5RGF7CSXppsGmvGGdKA9rVQfTBLyL1o6u5I/3HGlyxdOUW
         l1RtHemRPVSKMhWEB/qkdQzYV4uUb5neoEqXnZ42bX/Wf8f05iIWWfzQGCTBLQEEf9Ln
         /EAw==
X-Gm-Message-State: APjAAAU95YuEYUDBnBmXhXzbwsqMeBQf4MYpu++YTB8ak2ZNTeKX9BP/
        tNYsY2IkOWFzAleYCs77YiN/nZbIEUXv6EomIE2tDw==
X-Google-Smtp-Source: APXvYqyJ4nt9+Cb3VvmCUmEkmEWPRJPd34khUiRmOXNDD0rpIaPsxx6hd3bW+kSqhqA60hbPtZDo3MahZ+o5NuJLHog=
X-Received: by 2002:a9d:7410:: with SMTP id n16mr19494651otk.23.1582104117580;
 Wed, 19 Feb 2020 01:21:57 -0800 (PST)
MIME-Version: 1.0
References: <20200219045228.GO23230@ZenIV.linux.org.uk> <EDCBB5B9-DEE4-4D4B-B2F4-F63179977D6C@lca.pw>
 <20200219052329.GP23230@ZenIV.linux.org.uk>
In-Reply-To: <20200219052329.GP23230@ZenIV.linux.org.uk>
From:   Marco Elver <elver@google.com>
Date:   Wed, 19 Feb 2020 10:21:46 +0100
Message-ID: <CANpmjNM=+y-OwKjtsjsEkwPjpHXpt7ywaE48JyiND6dKt=Vf1Q@mail.gmail.com>
Subject: Re: [PATCH] fs: fix a data race in i_size_write/i_size_read
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Qian Cai <cai@lca.pw>, Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 19 Feb 2020 at 06:23, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Wed, Feb 19, 2020 at 12:08:40AM -0500, Qian Cai wrote:
> >
> >
> > > On Feb 18, 2020, at 11:52 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > If aligned 64bit stores on 64bit host (note the BITS_PER_LONG ifdefs) end up
> > > being split, the kernel is FUBAR anyway.  Details, please - how could that
> > > end up happening?
> >
> > My understanding is the compiler might decide to split the load into saying two 4-byte loads. Then, we might have,
> >
> > Load1
> > Store
> > Load2
> >
> > where the load value could be a garbage. Also, Marco (the KCSAN maintainer) who knew more of compiler than me mentioned that there is no guarantee that the store will not be split either. Thus, the WRITE_ONCE().
> >

In theory, yes. But by now we're aware of the current convention of
assuming plain aligned writes up to word-size are atomic (which KCSAN
respects with default Kconfig).

>         I would suggest
> * if some compiler does that, ask the persons responsible for that
> "optimization" which flags should be used to disable it.
> * if they fail to provide such, educate them regarding the
> usefulness of their idea
> * if that does not help, don't use the bloody piece of garbage.
>
>         Again, is that pure theory (because I can't come up with
> any reason why splitting a 32bit load would be any less legitimate
> than doing the same to a 64bit one on a 64bit architecture),
> or is there anything that really would pull that off?

Right. In reality, for mainstream architectures, it appears quite unlikely.

There may be other valid reasons, such as documenting the fact the
write can happen concurrently with loads.

Let's assume the WRITE_ONCE can be dropped.

The load is a different story. While load tearing may not be an issue,
it's more likely that other optimizations can break the code. For
example load fusing can break code that expects repeated loads in a
loop. E.g. I found these uses of i_size_read in loops:

git grep -E '(for|while) \(.*i_size_read'
fs/ocfs2/dir.c: while (ctx->pos < i_size_read(inode)) {
fs/ocfs2/dir.c:                 for (i = 0; i < i_size_read(inode) &&
i < offset; ) {
fs/ocfs2/dir.c: while (ctx->pos < i_size_read(inode)) {
fs/ocfs2/dir.c:         while (ctx->pos < i_size_read(inode)
fs/squashfs/dir.c:      while (length < i_size_read(inode)) {
fs/squashfs/namei.c:    while (length < i_size_read(dir)) {

Can i_size writes happen concurrently, and if so will these break if
the compiler decides to just do i_size_read's load once, and keep the
result in a register?

Thanks,
-- Marco
