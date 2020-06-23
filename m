Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF37BC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 10:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C395920768
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 10:51:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eT078qvr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732286AbgFWKvN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 06:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732254AbgFWKvN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 06:51:13 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA3BC061573;
        Tue, 23 Jun 2020 03:51:12 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id o5so22984798iow.8;
        Tue, 23 Jun 2020 03:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=52XyaX/hdvk4oZteuSuA9mZF0wwXuX2Bd31T6PscU2M=;
        b=eT078qvra+q7dx0AZwVaD2sAifUFvdztLvEDLrcEW3Nj4fsq57nKzUUktJiZmKF3O7
         bMsuhCdGw17RQNjw108CPcfpCZq0ykcoitTZ959imFYjnu1D/hwCf00PUIzwlQvMorNB
         c+4EqrSoenOQQMj0jf2b7hDWIgLq95jgSdH6TILNHfkKJmNgNSXXpfU16eJUncMav6hN
         qK0B+dEBsO1tE13DtkI+17F793pBFL8QZ33uaLtC3JtqAfc18DlEglRHPnKVoCRhuzYt
         ljdhObNj5H1MsVjVWdLUhu62Az3lFHBiXedhIBFUPBeJMnAWI66nuvsUR5pm0tSDuKh2
         sEmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=52XyaX/hdvk4oZteuSuA9mZF0wwXuX2Bd31T6PscU2M=;
        b=g6fRr5F+bv4xtLpIl3mhAPTtpPVKk+u4HixeK8wGFN2UiiPXU0hBqXMF7zdhbYwynM
         i/2k8dgNgXC/KfsJIwCQ+Ecg8OegesjT+AgMyx4iBS/rvDnqgggM4xbL+UxCPipoAHBE
         eadGELEEQhcw6buDaScfngc0oWsRHwEKNtpUonOVWCjcIPEF21+O9dDicK+RXhRWrpa/
         7Qj9e/Uukjp5kfDVAqFKN7tfkExz7P6UsGxT/ffRk9j/epmT5bmYsMZcX7WVX5ql0cQU
         /cbltEh2jKYz8Z3QHy2D1aBYTyDDiEwP6NhecKlqNyTjujJgPDoUJYcLJzusK/1AqTlJ
         KAOg==
X-Gm-Message-State: AOAM530qhqt3K6T0h7bc0dkciH0fUj4fZPpK1cfzRFraQDn7f+jL2zni
        4nc7RcAoq9cFEL0i8eY7e3dA+9+JPQnUWzpyubw=
X-Google-Smtp-Source: ABdhPJwGDAR+QPl6Q+5yOaiU1z+BOJcYwH8H1PsGsOochrEH1I/tffww96j0s7n5KtpClpctiy/oA76HTvUZv1DmuVw=
X-Received: by 2002:a6b:ba8b:: with SMTP id k133mr21068483iof.204.1592909471926;
 Tue, 23 Jun 2020 03:51:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200618122408.1054092-1-agruenba@redhat.com> <20200619131347.GA22412@infradead.org>
 <CAHc6FU7uKUV-R+qJ9ifLAJkS6aPoG_6qWe7y7wJOb7EbWRL4dQ@mail.gmail.com> <20200623103605.GA20464@infradead.org>
In-Reply-To: <20200623103605.GA20464@infradead.org>
From:   =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date:   Tue, 23 Jun 2020 12:51:00 +0200
Message-ID: <CAHpGcM+bCGJMB_k842pr57Ms1VMC6fva++XXaN+aF7rZ2roAvQ@mail.gmail.com>
Subject: Re: [PATCH v2] iomap: Make sure iomap_end is called after iomap_begin
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Bob Peterson <rpeterso@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Am Di., 23. Juni 2020 um 12:38 Uhr schrieb Christoph Hellwig
<hch@infradead.org>:
> On Mon, Jun 22, 2020 at 11:07:59AM +0200, Andreas Gruenbacher wrote:
> > On Fri, Jun 19, 2020 at 3:25 PM Christoph Hellwig <hch@infradead.org> wrote:
> > > On Thu, Jun 18, 2020 at 02:24:08PM +0200, Andreas Gruenbacher wrote:
> > > > Make sure iomap_end is always called when iomap_begin succeeds.
> > > >
> > > > Without this fix, iomap_end won't be called when a filesystem's
> > > > iomap_begin operation returns an invalid mapping, bypassing any
> > > > unlocking done in iomap_end.  With this fix, the unlocking would
> > > > at least still happen.
> > > >
> > > > This iomap_apply bug was found by Bob Peterson during code review.
> > > > It's unlikely that such iomap_begin bugs will survive to affect
> > > > users, so backporting this fix seems unnecessary.
> > > >
> > > > Fixes: ae259a9c8593 ("fs: introduce iomap infrastructure")
> > > > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > > > ---
> > > >  fs/iomap/apply.c | 10 ++++++----
> > > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/fs/iomap/apply.c b/fs/iomap/apply.c
> > > > index 76925b40b5fd..32daf8cb411c 100644
> > > > --- a/fs/iomap/apply.c
> > > > +++ b/fs/iomap/apply.c
> > > > @@ -46,10 +46,11 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
> > > >       ret = ops->iomap_begin(inode, pos, length, flags, &iomap, &srcmap);
> > > >       if (ret)
> > > >               return ret;
> > > > -     if (WARN_ON(iomap.offset > pos))
> > > > -             return -EIO;
> > > > -     if (WARN_ON(iomap.length == 0))
> > > > -             return -EIO;
> > > > +     if (WARN_ON(iomap.offset > pos) ||
> > > > +         WARN_ON(iomap.length == 0)) {
> > > > +             written = -EIO;
> > > > +             goto out;
> > > > +     }
> > >
> > > As said before please don't merge these for no good reason.
> >
> > I really didn't expect this tiny patch to require much discussion at
> > all, but just to be clear ... do you actually object to this very
> > patch that explicitly doesn't merge the two checks and keeps them on
> > two separate lines so that the warning messages will report different
> > line numbers, or are you fine with that?
>
> Yes, it merges the WARN_ONs, and thus reduces their usefulness.  How
> about a patch that just fixes your reported issue insted of messing up
> other things for no good reason?

So you're saying you prefer this:

+       if (WARN_ON(iomap.offset > pos)) {
+               written = -EIO;
+               goto out;
+       }
+       if (WARN_ON(iomap.length == 0)) {
+               written = -EIO;
+               goto out;
+       }

to this:

+       if (WARN_ON(iomap.offset > pos) ||
+           WARN_ON(iomap.length == 0)) {
+               written = -EIO;
+               goto out;
+       }

Well fine, you don't need to accuse me of messing up things for that.

Andreas
