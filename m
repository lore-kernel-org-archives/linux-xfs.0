Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7EEC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Dec 2022 20:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiLOUOx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Dec 2022 15:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiLOUOw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2022 15:14:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297CD303C7
        for <linux-xfs@vger.kernel.org>; Thu, 15 Dec 2022 12:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671135244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4SAnb8xM8pzY328qotBad3LRnalliWFM+XFPh7Dppkw=;
        b=iDb/pL5ePJG4trr7MqQMDUZbs4EmD+kwBxd+pCCy5/YM/WTB51EwlV8A95JpGB8faV5S/8
        XkGnq8nfxZGjKmPJuscOiOxh/8cOO5nSIXQLdd8nzQlKGgFPk4dOokO62IrB/7MTpzNF3W
        f9TpENA2e9dpV/QyTGehsE2XFSkn5Z0=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-154-I1hFo6e4POeHHO8sQMW8Qw-1; Thu, 15 Dec 2022 15:14:02 -0500
X-MC-Unique: I1hFo6e4POeHHO8sQMW8Qw-1
Received: by mail-yb1-f197.google.com with SMTP id a5-20020a25af05000000b006e450a5e507so5164077ybh.22
        for <linux-xfs@vger.kernel.org>; Thu, 15 Dec 2022 12:14:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4SAnb8xM8pzY328qotBad3LRnalliWFM+XFPh7Dppkw=;
        b=e0VWnzEttT9Ph4zQ4gJqziWVyU5j0fOwIgLhQHm/Czmpaz8zacyrH5hEG5EgKliRmt
         Tr8omPAADWZH97sOflPpNR9lHmnG2uQxx12UBkRjWtwsks3hnELgrNQBoAmBI0ywXrn4
         qyBsEtJjarmiaTTZyZaT0BNBD6AOI3A2vhL27sgbr65s6NaEp/QCDxzWCrKeCEKqQVf9
         DWjxJsOFBwUTWoBCTaoo7zEszEonsP8FWr03gNwIV4IEidWYnt8B/M0UsXiv5IiU1Px5
         k3TLIwMck8x38Xb+gqoFLbGFn+WNPwzmu10vgNxO4715R78hcEHffr8ZF36dknkJhWLd
         FI8w==
X-Gm-Message-State: ANoB5pkrIsON6MaaW1i0NyvaXAYVuCSfOvCb6d2k+LIKpsJfELUsH+1a
        Lg0BdnvSqPJHeCeL/RV3cHkSjTK/ox87Xm8BkbkNFv9cULwu69sNRLz/+0gaif4ivgJ3bBKg/cY
        gQJnRFR/lDrld1ESlHE/ObGdhc8bZZSsuUTo2
X-Received: by 2002:a25:5d5:0:b0:6f9:5e19:4729 with SMTP id 204-20020a2505d5000000b006f95e194729mr43103239ybf.311.1671135242060;
        Thu, 15 Dec 2022 12:14:02 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6J2MzYzMecMxwHefxxY6C66d+L8mAnjoVE3bvCq16qlNYB82xOiMyGxoxXsR3gvnJDlvCwzqfKxxd1HTPgniE=
X-Received: by 2002:a25:5d5:0:b0:6f9:5e19:4729 with SMTP id
 204-20020a2505d5000000b006f95e194729mr43103232ybf.311.1671135241744; Thu, 15
 Dec 2022 12:14:01 -0800 (PST)
MIME-Version: 1.0
References: <Y5l9zhhyOE+RNVgO@infradead.org> <20221214102409.1857526-1-agruenba@redhat.com>
In-Reply-To: <20221214102409.1857526-1-agruenba@redhat.com>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Thu, 15 Dec 2022 21:13:50 +0100
Message-ID: <CAHc6FU7pgH+nLS_0WFx8aFBenKtNy0z6DBiyAUSdjix0t57t5g@mail.gmail.com>
Subject: Re: [PATCH v2] iomap: Move page_done callback under the folio lock
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 14, 2022 at 11:24 AM Andreas Gruenbacher
<agruenba@redhat.com> wrote:
>
> Move the ->page_done() call in iomap_write_end() under the folio lock.
> This closes a race between journaled data writes and the shrinker in
> gfs2.  What's happening is that gfs2_iomap_page_done() is called after
> the page has been unlocked, so try_to_free_buffers() can come in and
> free the buffers while gfs2_iomap_page_done() is trying to add them to
> the current transaction.  The folio lock prevents that from happening.
>
> The only current user of ->page_done() is gfs2, so other filesystems are
> not affected.  Still, to catch out any new users, switch from page to
> folio in ->page_done().
>
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/gfs2/bmap.c         |  7 ++++---
>  fs/iomap/buffered-io.c |  4 ++--
>  include/linux/iomap.h  | 10 +++++-----
>  3 files changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
> index e7537fd305dd..c4ee47f8e499 100644
> --- a/fs/gfs2/bmap.c
> +++ b/fs/gfs2/bmap.c
> @@ -968,14 +968,15 @@ static int gfs2_iomap_page_prepare(struct inode *inode, loff_t pos,
>  }
>
>  static void gfs2_iomap_page_done(struct inode *inode, loff_t pos,
> -                                unsigned copied, struct page *page)
> +                                unsigned copied, struct folio *folio)
>  {
>         struct gfs2_trans *tr = current->journal_info;
>         struct gfs2_inode *ip = GFS2_I(inode);
>         struct gfs2_sbd *sdp = GFS2_SB(inode);
>
> -       if (page && !gfs2_is_stuffed(ip))
> -               gfs2_page_add_databufs(ip, page, offset_in_page(pos), copied);
> +       if (folio && !gfs2_is_stuffed(ip))
> +               gfs2_page_add_databufs(ip, &folio->page, offset_in_page(pos),
> +                                      copied);
>
>         if (tr->tr_num_buf_new)
>                 __mark_inode_dirty(inode, I_DIRTY_DATASYNC);

This is still screwed up. We really need to unlock the page before
calling into __mark_inode_dirty() and ending the transaction. The
current page_done() hook would force us to then re-lock the page just
so that the caller can unlock it again. This just doesn't make sense,
particularly since the page_prepare and page_done hooks only exist to
allow gfs2 to do data journaling via iomap. I'll follow up with a more
useful approach ...

> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 91ee0b308e13..d988c1bedf70 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -714,12 +714,12 @@ static size_t iomap_write_end(struct iomap_iter *iter, loff_t pos, size_t len,
>                 i_size_write(iter->inode, pos + ret);
>                 iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
>         }
> +       if (page_ops && page_ops->page_done)
> +               page_ops->page_done(iter->inode, pos, ret, folio);
>         folio_unlock(folio);
>
>         if (old_size < pos)
>                 pagecache_isize_extended(iter->inode, old_size, pos);
> -       if (page_ops && page_ops->page_done)
> -               page_ops->page_done(iter->inode, pos, ret, &folio->page);
>         folio_put(folio);
>
>         if (ret < len)
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 238a03087e17..bd6d80453726 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -116,18 +116,18 @@ static inline bool iomap_inline_data_valid(const struct iomap *iomap)
>
>  /*
>   * When a filesystem sets page_ops in an iomap mapping it returns, page_prepare
> - * and page_done will be called for each page written to.  This only applies to
> - * buffered writes as unbuffered writes will not typically have pages
> + * and page_done will be called for each folio written to.  This only applies
> + * to buffered writes as unbuffered writes will not typically have folios
>   * associated with them.
>   *
>   * When page_prepare succeeds, page_done will always be called to do any
> - * cleanup work necessary.  In that page_done call, @page will be NULL if the
> - * associated page could not be obtained.
> + * cleanup work necessary.  In that page_done call, @folio will be NULL if the
> + * associated folio could not be obtained.
>   */
>  struct iomap_page_ops {
>         int (*page_prepare)(struct inode *inode, loff_t pos, unsigned len);
>         void (*page_done)(struct inode *inode, loff_t pos, unsigned copied,
> -                       struct page *page);
> +                       struct folio *folio);
>  };
>
>  /*
> --
> 2.38.1
>

