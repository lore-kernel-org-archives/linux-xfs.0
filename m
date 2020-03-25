Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E09FC54FD5
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 15:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F252B20740
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 15:54:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="PotvV1Ev"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgCYPy4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 11:54:56 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41275 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727538AbgCYPy4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 11:54:56 -0400
Received: by mail-io1-f68.google.com with SMTP id y24so2713154ioa.8
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 08:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WUvTsX9+jdPoLTOSHShSbaoohqGvLnmJWJx3goFYuLM=;
        b=PotvV1Ev6OzVSaF6m2X5tC6JwxVWHxAGf6FLW8AjKTGJyK/QJ8dyn6xJiqfkSFaAqz
         OCdtBX9daql7+1gX8+5dT3S5uMqemNZ36FP4ZPoQpwuOHn42a4uh+PVPR7d5d59NuA3a
         t2/cRclIFAps/zNhsd7jyIV2vHIEY2rkQ4dM0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WUvTsX9+jdPoLTOSHShSbaoohqGvLnmJWJx3goFYuLM=;
        b=ta6TSQH6PMmyLZuFmwsskSQNValcdf+9pkmiHgvMqqtkJrcNsWACVFqMzu2Gh5GrYr
         x2zmG4JtC/5LH2RfbBCrA2zcJCD2RREaCml2lsyWR1wn+xNUsGClR/J1oiOJH4fX0h/u
         d/DQIZ0vn6ijKJDEwwP6QaKhsVLSWipwKptGaWVTpbpuV35hbGP3heIrecryPyXGeouu
         WoELTVDoru+TymOhAK4K231VitKtqbsnS3oRBXJafsS1PhR7lG33qNZFMjuvrfOgbGNI
         RPZKizZCslxjy5v7/jP/4GyhpPedW0846j4McfwDceJ9tiD6UD/zuhJBtJdkqUEXTGk5
         MCzQ==
X-Gm-Message-State: ANhLgQ2O8hinfP0BVENONWObcr3RJKIcsS/3D8z9UMUT8XgnqdcLDyQt
        xP3oK7/DHq7gx77zVODJ6oAErRRQZwpToigzk01EUg==
X-Google-Smtp-Source: ADFU+vtWPrSX9gO9pLLxpavehCkl/CaKr8w3OI8WID1sZHiGcDBmq2nlMdLwxJGUo5kQXivDvVBrGhSFup9s33zQy+o=
X-Received: by 2002:a5d:9142:: with SMTP id y2mr3418704ioq.185.1585151694868;
 Wed, 25 Mar 2020 08:54:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200323202259.13363-1-willy@infradead.org> <20200323202259.13363-25-willy@infradead.org>
 <CAJfpegu7EFcWrg3bP+-2BX_kb52RrzBCo_U3QKYzUkZfe4EjDA@mail.gmail.com>
 <20200325120254.GA22483@bombadil.infradead.org> <CAJfpegshssCJiA8PBcq2XvBj3mR8dufHb0zWRFvvKKv82VQYsw@mail.gmail.com>
 <20200325153228.GB22483@bombadil.infradead.org>
In-Reply-To: <20200325153228.GB22483@bombadil.infradead.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 25 Mar 2020 16:54:43 +0100
Message-ID: <CAJfpegtrhGamoSqD-3Svfj3-iTdAbfD8TP44H_o+HE+g+CAnCA@mail.gmail.com>
Subject: Re: [PATCH v10 24/25] fuse: Convert from readpages to readahead
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        William Kucharski <william.kucharski@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 4:32 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Wed, Mar 25, 2020 at 03:43:02PM +0100, Miklos Szeredi wrote:
> > >
> > > -       while ((page = readahead_page(rac))) {
> > > -               if (fuse_readpages_fill(&data, page) != 0)
> > > +               nr_pages = min(readahead_count(rac), fc->max_pages);
> >
> > Missing fc->max_read clamp.
>
> Yeah, I realised that.  I ended up doing ...
>
> +       unsigned int i, max_pages, nr_pages = 0;
> ...
> +       max_pages = min(fc->max_pages, fc->max_read / PAGE_SIZE);
>
> > > +               ia = fuse_io_alloc(NULL, nr_pages);
> > > +               if (!ia)
> > >                         return;
> > > +               ap = &ia->ap;
> > > +               __readahead_batch(rac, ap->pages, nr_pages);
> >
> > nr_pages = __readahead_batch(...)?
>
> That's the other bug ... this was designed for btrfs which has a fixed-size
> buffer.  But you want to dynamically allocate fuse_io_args(), so we need to
> figure out the number of pages beforehand, which is a little awkward.  I've
> settled on this for the moment:
>
>         for (;;) {
>                struct fuse_io_args *ia;
>                 struct fuse_args_pages *ap;
>
>                 nr_pages = readahead_count(rac) - nr_pages;
>                 if (nr_pages > max_pages)
>                         nr_pages = max_pages;
>                 if (nr_pages == 0)
>                         break;
>                 ia = fuse_io_alloc(NULL, nr_pages);
>                 if (!ia)
>                         return;
>                 ap = &ia->ap;
>                 __readahead_batch(rac, ap->pages, nr_pages);
>                 for (i = 0; i < nr_pages; i++) {
>                         fuse_wait_on_page_writeback(inode,
>                                                     readahead_index(rac) + i);
>                         ap->descs[i].length = PAGE_SIZE;
>                 }
>                 ap->num_pages = nr_pages;
>                 fuse_send_readpages(ia, rac->file);
>         }
>
> but I'm not entirely happy with that either.  Pondering better options.

I think that's fine.   Note how the original code possibly
over-allocates the the page array, because it doesn't know the batch
size beforehand.  So this is already better.

>
> > This will give consecutive pages, right?
>
> readpages() was already being called with consecutive pages.  Several
> filesystems had code to cope with the pages being non-consecutive, but
> that wasn't how the core code worked; if there was a discontiguity it
> would send off the pages that were consecutive and start a new batch.
>
> __readahead_batch() can't return fewer than nr_pages, so you don't need
> to check for that.

That's far from obvious.

I'd put a WARN_ON at least to make document the fact.

Thanks,
Miklos
