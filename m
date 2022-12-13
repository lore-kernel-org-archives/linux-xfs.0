Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A28AC10F1B
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 20:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236986AbiLMUSN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 15:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236985AbiLMURv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 15:17:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0443C252B0
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 12:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670962551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XsEdZNGVmnTvoH2VquKqwJ5kQo3gqU2sUkgS6EmDZfQ=;
        b=BxMNPcXO6r9s9l+B6uXdRxnPN+tni06s7FrlJti+1WS+Fw3Xr4Tf565DU9SRg0rHFrXb8I
        unYgLGcXWzQVT8P1zSN/++7SjWni3RFx0T7yqMdxewjyve0qJKErGWn1aL0zfjawGXMe0V
        MDn7cEKPgM+CHxaRtQ/asZiTOI5OpQc=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-jU52HIeHMKCs4TKTzSF-DQ-1; Tue, 13 Dec 2022 15:15:49 -0500
X-MC-Unique: jU52HIeHMKCs4TKTzSF-DQ-1
Received: by mail-yb1-f199.google.com with SMTP id y133-20020a25328b000000b006f997751950so17889164yby.7
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 12:15:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XsEdZNGVmnTvoH2VquKqwJ5kQo3gqU2sUkgS6EmDZfQ=;
        b=HqSc29mTFdT2tFYBlj5zLIJwK3diR5U5ZtgVq4zx4H5e6g8ToYzR/axuiK82lNpTE+
         3vnKxn0GD/gR47QGgKj1t2VcByPj7JvZCTEXEnTmGLZUS6WxMDP+A2KWd/Ap8EtpmWAy
         ZWmYk0qRtUiPvdkexXn1GJzmBKeBvO5u4GEfQcla3vbtCZbxKG8dZTAFg7FIQiZ6eEp4
         iz60STV3G+Zt81nTzBniX3M0JLwSI+hNpH5V7TCuaeCKRmnEVqEIkHfZGBxrdp0uD02s
         7KuPrIcy4s9yiZqQWWnYPkYhQp5vLuzttbFCmbidyHgik/+UpUhDdm3UbKBB/8X1Kjcw
         Rr7w==
X-Gm-Message-State: ANoB5pmkBgfAAO8iaQKyv7TYEeB9oli5GB9pfwKzdvC5IQ+xXNTi+QAY
        J3aRXdQ0TuFltgT2GnutkamwRbyYMWFrmL28rQefzzxuscLrfyLMcRv6cnEykkRGeReiiUK9lns
        sAnwJgWVPzkIpG/i6hdvgDSfHcti8gXRiLqrn
X-Received: by 2002:a05:6902:1370:b0:6ff:eb24:45aa with SMTP id bt16-20020a056902137000b006ffeb2445aamr21101675ybb.321.1670962549304;
        Tue, 13 Dec 2022 12:15:49 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7CM1nfbCNHI0ZHI5MDflEDMT6ZkLZC5c2EhDzPUZV7YYp/sc72g7k5DBblPmLsDSxwy5HcT9sotLQ8mGWxeJk=
X-Received: by 2002:a05:6902:1370:b0:6ff:eb24:45aa with SMTP id
 bt16-20020a056902137000b006ffeb2445aamr21101671ybb.321.1670962549051; Tue, 13
 Dec 2022 12:15:49 -0800 (PST)
MIME-Version: 1.0
References: <20221213194833.1636649-1-agruenba@redhat.com> <Y5janUs2/29XZRbc@magnolia>
In-Reply-To: <Y5janUs2/29XZRbc@magnolia>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Tue, 13 Dec 2022 21:15:38 +0100
Message-ID: <CAHc6FU7CZZb48FZSELYg-29ehTUcAzLZoKNGdLSg1XK7Wx9Cfg@mail.gmail.com>
Subject: Re: [PATCH] iomap: Move page_done callback under the folio lock
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 9:03 PM Darrick J. Wong <djwong@kernel.org> wrote:
> On Tue, Dec 13, 2022 at 08:48:33PM +0100, Andreas Gruenbacher wrote:
> > Hi Darrick,
> >
> > I'd like to get the following iomap change into this merge window.  This
> > only affects gfs2, so I can push it as part of the gfs2 updates if you
> > don't mind, provided that I'll get your Reviewed-by confirmation.
> > Otherwise, if you'd prefer to pass this through the xfs tree, could you
> > please take it?
>
> I don't mind you pushing changes to ->page_done through the gfs2 tree,
> but don't you need to move the other callsite at the bottom of
> iomap_write_begin?

No, in the failure case in iomap_write_begin(), the folio isn't
relevant because it's not being written to.

Thanks for paying attention,
Andreas

> --D
>
> > Thanks,
> > Andreas
> >
> > --
> >
> > Move the ->page_done() call in iomap_write_end() under the folio lock.
> > This closes a race between journaled data writes and the shrinker in
> > gfs2.  What's happening is that gfs2_iomap_page_done() is called after
> > the page has been unlocked, so try_to_free_buffers() can come in and
> > free the buffers while gfs2_iomap_page_done() is trying to add them to
> > the current transaction.  The folio lock prevents that from happening.
> >
> > The only user of ->page_done() is gfs2, so other filesystems are not
> > affected.
> >
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > ---
> >  fs/iomap/buffered-io.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 91ee0b308e13..476c9ed1b333 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -714,12 +714,12 @@ static size_t iomap_write_end(struct iomap_iter *iter, loff_t pos, size_t len,
> >               i_size_write(iter->inode, pos + ret);
> >               iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
> >       }
> > +     if (page_ops && page_ops->page_done)
> > +             page_ops->page_done(iter->inode, pos, ret, &folio->page);
> >       folio_unlock(folio);
> >
> >       if (old_size < pos)
> >               pagecache_isize_extended(iter->inode, old_size, pos);
> > -     if (page_ops && page_ops->page_done)
> > -             page_ops->page_done(iter->inode, pos, ret, &folio->page);
> >       folio_put(folio);
> >
> >       if (ret < len)
> > --
> > 2.38.1
> >
>

