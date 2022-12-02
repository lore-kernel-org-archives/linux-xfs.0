Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6E1C4321E
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Dec 2022 01:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiLBBzK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Dec 2022 20:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiLBBzJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2022 20:55:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BAAD3DEB
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 17:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669946053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=COzjxy6Cx/yoL60phqF9Y1iVWuFzG9VgVu3jRR0Ap+U=;
        b=gWed493kMMgxuuf1FUOH+kRxyXt6sGGHpC42jy7eF3atgfYQ+/lHdhS7l5hpif6WfPPibi
        6+Ueo+q4PgAmZyCfGGIwEYxvdcQ7iYscMBE7iP/lphH3DoD4K9f9Re9mOIu2Ss6+Ecp69L
        8J3NkTMZQQIXNuSrzh4q7mOyD4cax5Y=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-326-W8DqB2kcMsCUAFxj4bE5Gg-1; Thu, 01 Dec 2022 20:54:12 -0500
X-MC-Unique: W8DqB2kcMsCUAFxj4bE5Gg-1
Received: by mail-yb1-f199.google.com with SMTP id t5-20020a5b07c5000000b006dfa2102debso3666616ybq.4
        for <linux-xfs@vger.kernel.org>; Thu, 01 Dec 2022 17:54:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=COzjxy6Cx/yoL60phqF9Y1iVWuFzG9VgVu3jRR0Ap+U=;
        b=3nXuHOJb5DPtBw50UdWOpEfCaTByVo/Nf1AZ5aH/cHeEqoPlkWt8E6dCQ6gvGUuNWY
         crTFxF7JGAJSkY41KD/ynu1WacF4ADF0HHi3wW7aoG9bAzpDBoWx1A+lg+Po2sJzTRte
         qU+2mWT2CAe3iRqWaBIjL2bOzi7aPv6MFAELuWxMFIeHpkI40AJ0LhztnwxRD3DXrSG2
         LLtnkC6t0m4kb90prlez22qAuhVedIDnmeWTkr6Gpl9JriFmwMFLiQAMKTgzMUvUgy5d
         jNGwe+SvivyNpJzpAgRPZkO7v1OfXUu/h95jUMpgE+dd2Oe+KMQ3QtqLT8dzyAlXNPEM
         4oYg==
X-Gm-Message-State: ANoB5pmKKVk0Bc1YWsRavk+K0bEOtknl34pXsVITWrzJCc2XUERegcI0
        wRWr5QlMF8SvWIv0zd2jrUisjoiPouh48sroRAiFVIGHgAf+wwMd8jyc4XfGaG5KvDeE117YvWN
        Xyv50X03QTersvfC/cek/kHKwQPLgsYnPQuVT
X-Received: by 2002:a81:d92:0:b0:3bd:77de:3652 with SMTP id 140-20020a810d92000000b003bd77de3652mr29752902ywn.147.1669946052364;
        Thu, 01 Dec 2022 17:54:12 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4zl5/yw2S0gY5SqLJMEn3kK+Mc23RWKMLXVRNIap4XekIskw7GEsiU1dqL8mTyQsVHGqUk1+lUCQo3JuJVWvY=
X-Received: by 2002:a81:d92:0:b0:3bd:77de:3652 with SMTP id
 140-20020a810d92000000b003bd77de3652mr29752883ywn.147.1669946052084; Thu, 01
 Dec 2022 17:54:12 -0800 (PST)
MIME-Version: 1.0
References: <20221201160619.1247788-1-agruenba@redhat.com> <20221201180957.1268079-1-agruenba@redhat.com>
 <20221201212956.GO3600936@dread.disaster.area>
In-Reply-To: <20221201212956.GO3600936@dread.disaster.area>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Fri, 2 Dec 2022 02:54:00 +0100
Message-ID: <CAHc6FU6u9A0S-EwyB6vq89XPj1rucL8U0oqq__OzB1d0evM-yA@mail.gmail.com>
Subject: Re: [RFC v2 0/3] Turn iomap_page_ops into iomap_folio_ops
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 1, 2022 at 10:30 PM Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Dec 01, 2022 at 07:09:54PM +0100, Andreas Gruenbacher wrote:
> > Hi again,
> >
> > [Same thing, but with the patches split correctly this time.]
> >
> > we're seeing a race between journaled data writes and the shrinker on
> > gfs2.  What's happening is that gfs2_iomap_page_done() is called after
> > the page has been unlocked, so try_to_free_buffers() can come in and
> > free the buffers while gfs2_iomap_page_done() is trying to add them to
> > the transaction.  Not good.
> >
> > This is a proposal to change iomap_page_ops so that page_prepare()
> > prepares the write and grabs the locked page, and page_done() unlocks
> > and puts that page again.  While at it, this also converts the hooks
> > from pages to folios.
> >
> > To move the pagecache_isize_extended() call in iomap_write_end() out of
> > the way, a new folio_may_straddle_isize() helper is introduced that
> > takes a locked folio.  That is then used when the inode size is updated,
> > before the folio is unlocked.
> >
> > I've also converted the other applicable folio_may_straddle_isize()
> > users, namely generic_write_end(), ext4_write_end(), and
> > ext4_journalled_write_end().
> >
> > Any thoughts?
>
> I doubt that moving page cache operations from the iomap core to
> filesystem specific callouts will be acceptible. I recently proposed
> patches that added page cache walking to an XFS iomap callout to fix
> a data corruption, but they were NAKd on the basis that iomap is
> supposed to completely abstract away the folio and page cache
> manipulations from the filesystem.

Right. The resulting code is really quite disgusting, for a
fundamentalist dream of abstraction.

> This patchset seems to be doing the same thing - moving page cache
> and folio management directly in filesystem specific callouts. Hence
> I'm going to assume that the same architectural demarcation is
> going to apply here, too...
>
> FYI, there is already significant change committed to the iomap
> write path in the current XFS tree as a result of the changes I
> mention - there is stale IOMAP detection which adds a new page ops
> method and adds new error paths with a locked folio in
> iomap_write_begin().

That would have belonged on the iomap-for-next branch rather than in
the middle of a bunch of xfs commits.

> And this other data corruption (and performance) fix for handling
> zeroing over unwritten extents properly:
>
> https://lore.kernel.org/linux-xfs/20221201005214.3836105-1-david@fromorbit.com/
>
> changes the way folios are looked up and instantiated in the page
> cache in iomap_write_begin(). It also adds new error conditions that
> need to be returned to callers so to implement conditional "folio
> must be present and dirty" page cache zeroing from
> iomap_zero_iter(). Those semantics would also have to be supported
> by gfs2, and that greatly complicates modifying and testing iomap
> core changes.
>
> To avoid all this, can we simple move the ->page_done() callout in
> the error path and iomap_write_end() to before we unlock the folio?
> You've already done that for pagecache_isize_extended(), and I can't
> see anything obvious in the gfs2 ->page_done callout that
> would cause issues if it is called with a locked dirty folio...

Yes, I guess we can do that once pagecache_isize_extended() is
replaced by folio_may_straddle_isize().

Can people please scrutinize the math in folio_may_straddle_isize() in
particular?

Thanks,
Andreas

> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

