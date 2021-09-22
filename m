Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A952C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 02:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C73C60F23
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 02:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhIVCSH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Sep 2021 22:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhIVCSH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Sep 2021 22:18:07 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A44C061575
        for <linux-xfs@vger.kernel.org>; Tue, 21 Sep 2021 19:16:38 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id w6so752512pll.3
        for <linux-xfs@vger.kernel.org>; Tue, 21 Sep 2021 19:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OosjfkLZh41x2OZZ5/Fq0+NUoloZ5quy7DhXoOzNYPo=;
        b=sc0tCxyYdZFVlGPIIr0dwpCw4M1wGDO19NAxNhEcE9rrShoOnwk3EaHGa+aje94ke8
         l0y0Rw+1YzMdkaA7wYUSc3Jh/PCUzrdAni7NzXATSJy8GQG01iqBASofOsgmNUm+3mb1
         Bs6s6HiOMBSDjkac4hID0AsKAWOCNExqnHBvsYxkh33xNFy0kJEm21h1lejHfVQKMIQX
         RESOjYS3rKj+nJP9MyN9vQj6r2vG96AKKusAHjEFho6mo0uGMIwpK1A6Wl/hGE14Bkvd
         E+S7ZngUtI32asDf3QYZOgY6sBh7VoMVBSQJnWdVYPvzClvgz071WetnhBmcjqfkgq8+
         cz1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OosjfkLZh41x2OZZ5/Fq0+NUoloZ5quy7DhXoOzNYPo=;
        b=hIeiNlWFx0PGtb5U/FMHZLH4eOTkJXYNoQXtAZzRxdyxLjgZ/tY/oGfBwEQ8H7/pKe
         TL8eKJwCiKokMs5hOtkg9h6IByLhV26KTnnKXAtzLSS5Df2PhwKJCrcVuZ+DDV7aluir
         YfOESilpNb91DtJ7BuoB2r/zRrch7+8VlK20vVejdbajKRYCvTriH1GR+5fgEZAPINLf
         RE4mqOYOj1cTH0qixAYFLfYwZjIgsyQpQw1qtfSUOVLr1SqoW5OthqBgBduMbh7l2zQc
         0H5Z0fJGfWGEGATGsGY5IKyRYQYXVoq79qitW1q0/NnILpwNQgI+pHCZNLu6fH+RYIpu
         ncfA==
X-Gm-Message-State: AOAM5318DDlDBiNjyosc5tvD8HBQQPsS3VkMhAwnotSSVnFUm6Q1zxXP
        z+obN3GbCWzLOlAqyCGLbREgRJDWUEeHJRYFQ7Cw5A==
X-Google-Smtp-Source: ABdhPJyclj4v0WQt0eQovMB+LlfPq/vxMuTMkF+PGvJeKggTto8OLI38FoDxRLjHCfd/IDJyVuwNh+N03sjTTLWyTj8=
X-Received: by 2002:a17:90a:f18f:: with SMTP id bv15mr8398509pjb.93.1632276997599;
 Tue, 21 Sep 2021 19:16:37 -0700 (PDT)
MIME-Version: 1.0
References: <163192864476.417973.143014658064006895.stgit@magnolia>
 <163192866125.417973.7293598039998376121.stgit@magnolia> <20210921004431.GO1756565@dread.disaster.area>
 <YUmYbxW70Ub2ytOc@infradead.org>
In-Reply-To: <YUmYbxW70Ub2ytOc@infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 21 Sep 2021 19:16:26 -0700
Message-ID: <CAPcyv4jF1UNW5rdXX3q2hfDcvzGLSnk=1a0C0i7_UjdivuG+pQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] vfs: add a zero-initialization mode to fallocate
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jane Chu <jane.chu@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 21, 2021 at 1:32 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Sep 21, 2021 at 10:44:31AM +1000, Dave Chinner wrote:
> > I think this wants to be a behavioural modifier for existing
> > operations rather than an operation unto itself. i.e. similar to how
> > KEEP_SIZE modifies ALLOC behaviour but doesn't fundamentally alter
> > the guarantees ALLOC provides userspace.
> >
> > In this case, the change of behaviour over ZERO_RANGE is that we
> > want physical zeros to be written instead of the filesystem
> > optimising away the physical zeros by manipulating the layout
> > of the file.
>
> Yes.
>
> > Then we have and API that looks like:
> >
> >       ALLOC           - allocate space efficiently
> >       ALLOC | INIT    - allocate space by writing zeros to it
> >       ZERO            - zero data and preallocate space efficiently
> >       ZERO | INIT     - zero range by writing zeros to it
> >
> > Which seems to cater for all the cases I know of where physically
> > writing zeros instead of allocating unwritten extents is the
> > preferred behaviour of fallocate()....
>
> Agreed.  I'm not sure INIT is really the right name, but I can't come
> up with a better idea offhand.

FUA? As in, this is a forced-unit-access zeroing all the way to media
bypassing any mechanisms to emulate zero-filled payloads on future
reads.
