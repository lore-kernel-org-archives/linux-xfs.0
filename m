Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F104CC38142
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Jan 2023 21:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjAaVeG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Jan 2023 16:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjAaVeE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2023 16:34:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049F21EFEA
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2023 13:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675200797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Rg6fbl7dgG4jCUNGUH6At0nHeKDb4FxUgvQsWlsCTI=;
        b=QQl7yuMQp37ER/PTdc/RTVhOCNxquQIjf3jJYn9E2p1Lamxzr3gq9RHZnQXnvcrjoA3BR3
        C6OrkP77Vn5l9UGy1w+TFmY3Lp7QMgI/qtWZNaqFnPkWz9dBO4onjSepQU5csHzdliUXQe
        lvApkTy+zbHqmg9vXZG6GbwHE6J0IvU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-413-H47Zr526NGG9lLUQWUx0LA-1; Tue, 31 Jan 2023 16:33:16 -0500
X-MC-Unique: H47Zr526NGG9lLUQWUx0LA-1
Received: by mail-pj1-f69.google.com with SMTP id r17-20020a17090aa09100b0021903e75f14so6640750pjp.9
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2023 13:33:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Rg6fbl7dgG4jCUNGUH6At0nHeKDb4FxUgvQsWlsCTI=;
        b=TXqWd8yBhgI1S9CZ/vA48fqZBehSx+Y0l5haMGN0ZUaLD4lic5xLQZvl/5U+EARj19
         UcCkqiamwK2yAzyrE7QHOx+KgAcyK6JKbbHxy/mGVTK8TvmUo5vMstbihN31emqUdhii
         pVnchHlJ6YpE9Cb2N/RpoBtEAtz8P33fEakkig/b83nfg+Ap2U6EhTpw1V19C/tsqr3h
         YrhIkiFhxYXRRJkx2fhvila+usSQTi4YbmPGmXZq8ZiTRq4e57HBFNeobS8tMZ0899UV
         WySI7CuH1kHGDDNUgT8QQFDmP1UKGzdxY4Qwa66ARKn/7e2pFq0UndBZc37oNiykIQis
         T9VA==
X-Gm-Message-State: AO0yUKXg9RbC/m4tH08dy231fj3GoUDheX+O+yq45FgyKCp1Ws4JeNkL
        EwlnK+OfWPrAwNWZqMirSF4ropUYKwUJeUsD6/jfOyz0VRqtrbSHgBfu8rJW1ArULNYo1jXwYx4
        zEaJvUTNFtMqx/dCs0Kl256iOaVfBFGTNcrhm
X-Received: by 2002:a17:90a:9316:b0:226:e191:4417 with SMTP id p22-20020a17090a931600b00226e1914417mr144884pjo.16.1675200794889;
        Tue, 31 Jan 2023 13:33:14 -0800 (PST)
X-Google-Smtp-Source: AK7set+3ftaiw544NuVW2ZH8VprBCE7BMkB5bi8ZRGRO28/BUbobq+S5msnCbAA7Nc5bdoIiQID9vxZV3vXM/MQm+Bg=
X-Received: by 2002:a17:90a:9316:b0:226:e191:4417 with SMTP id
 p22-20020a17090a931600b00226e1914417mr144879pjo.16.1675200794625; Tue, 31 Jan
 2023 13:33:14 -0800 (PST)
MIME-Version: 1.0
References: <20230108194034.1444764-1-agruenba@redhat.com> <20230108194034.1444764-6-agruenba@redhat.com>
 <Y9lt/95kN6kwp+A1@casper.infradead.org>
In-Reply-To: <Y9lt/95kN6kwp+A1@casper.infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Tue, 31 Jan 2023 22:33:02 +0100
Message-ID: <CAHc6FU6DoR7c5Cmwvdpzs9Vc1M-wVn4sip4vscN89LwMYiwFpQ@mail.gmail.com>
Subject: Re: [RFC v6 05/10] iomap/gfs2: Get page in page_prepare handler
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 31, 2023 at 8:37 PM Matthew Wilcox <willy@infradead.org> wrote:
> On Sun, Jan 08, 2023 at 08:40:29PM +0100, Andreas Gruenbacher wrote:
> > +static struct folio *
> > +gfs2_iomap_page_prepare(struct iomap_iter *iter, loff_t pos, unsigned len)
> >  {
> > +     struct inode *inode = iter->inode;
> >       unsigned int blockmask = i_blocksize(inode) - 1;
> >       struct gfs2_sbd *sdp = GFS2_SB(inode);
> >       unsigned int blocks;
> > +     struct folio *folio;
> > +     int status;
> >
> >       blocks = ((pos & blockmask) + len + blockmask) >> inode->i_blkbits;
> > -     return gfs2_trans_begin(sdp, RES_DINODE + blocks, 0);
> > +     status = gfs2_trans_begin(sdp, RES_DINODE + blocks, 0);
> > +     if (status)
> > +             return ERR_PTR(status);
> > +
> > +     folio = iomap_get_folio(iter, pos);
> > +     if (IS_ERR(folio))
> > +             gfs2_trans_end(sdp);
> > +     return folio;
> >  }
>
> Hi Andreas,

Hello,

> I didn't think to mention this at the time, but I was reading through
> buffered-io.c and this jumped out at me.  For filesystems which support
> folios, we pass the entire length of the write (or at least the length
> of the remaining iomap length).  That's intended to allow us to decide
> how large a folio to allocate at some point in the future.
>
> For GFS2, we do this:
>
>         if (!mapping_large_folio_support(iter->inode->i_mapping))
>                 len = min_t(size_t, len, PAGE_SIZE - offset_in_page(pos));
>
> I'd like to drop that and pass the full length of the write to
> ->get_folio().  It looks like you'll have to clamp it yourself at this
> point.

sounds reasonable to me.

I see that gfs2_page_add_databufs() hasn't been folio-ized yet, but it
looks like it might just work anway. So gfs2_iomap_get_folio() ...
gfs2_iomap_put_folio() should, in principle, work for requests bigger
than PAGE_SIZE.

Is there a reasonable way of trying it out?

We still want to keep the transaction size somewhat reasonable, but
the maximum size gfs2_iomap_begin() will return for a write is 509
blocks on a 4k-block filesystem, or slightly less than 2 MiB, which
should be fine.

>  I am kind of curious why you do one transaction per page --
> I would have thought you'd rather do one transaction for the entire write.

Only for journaled data writes. We could probably do bigger
transactions even in that case, but we'd rather get rid of data
journaling than encourage it, so we're also not spending a lot of time
on optimizing this case.

Thanks,
Andreas

