Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D53BC3A59E
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 02:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21A3422CF7
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 02:50:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PsXwEloZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfHVCuQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 22:50:16 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36199 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbfHVCuQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Aug 2019 22:50:16 -0400
Received: by mail-wm1-f67.google.com with SMTP id g67so4134452wme.1;
        Wed, 21 Aug 2019 19:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HVokBFt07/DgufHpWotptreZYXyNwxuPF5AIlwru9dA=;
        b=PsXwEloZGZx+BXlcCZ5EtNdrue+bNuEBfro6xjpy3h3o/tKFUF7/PLoGmoqZ8pznKg
         DrEF1/CtsRpVg5khE6Cj3pxRBO3+u8HvDOSN8s+1spQPevvCFcwbpMcp2sjazy4Imofr
         dMARb/9tfUX+LmHfKcEmI5FNqkm+ZcKa9O3ogzS4oiFZfMS3yT17bsYkTC5eAtZ3QOys
         XX2RPYjDMMcgFZtmAGW3H3NDnd+7b/R0i63GNZqJgjgNeVyzwTHHbZpEVdft6gk0McwH
         1Ylbj/Th2679ZiY032YZm1S+ITaaLrGbx8HUeENzZf/Jl3/Ke0xVMD+bfcc4Ur0i4ixC
         FFOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HVokBFt07/DgufHpWotptreZYXyNwxuPF5AIlwru9dA=;
        b=I2adumwnzfRGpq7Gyan7vmjAp7iRm3CSq0gwSXhlKSQnAe9XXP1lGGsjmOS8kDD5Ux
         5oqocoRKnDHOyjMb9xHBWqxcmeZRDv8CTu0qOiozqJsW/v8mGmGFyh3vkdbTUCdj6XeH
         eKS3ip/ISPBVaAUDrKpTCNHHsB6ZBpjN/UC9l2aAU6QmJCpKmtVzXtO+xmd00GM0pIKW
         DH7P5NOvhd6J8iM/FYIzPQgOiEpDOF8nevfpwv7Bp1ADCRvJFcWc8TFPj1/JHhKcfPm2
         IApAo02ELjJTx35wT0GO6Z5xZRkrsDhzhNBauG1oF2VMOZrWqBzKI3CI0q8LjK5h+J2p
         EEYg==
X-Gm-Message-State: APjAAAXIurlOEeaeN2Fy61PwEp0ZLKmvu91UBGu9+tBWguB+KPf9QR3l
        D6x1TPgSY6jkQjRswMa+raL/bU5MBDFjeVVuyXPBX0xc6Qx5Dg==
X-Google-Smtp-Source: APXvYqz8VqvKvEydwbqVxluMjivQJ0VzLf0WMXLfH/qFVPTg6LNbbpKm9yM4T0KPgEb6oiGhNau9Elt7K7OBE3jW0zw=
X-Received: by 2002:a1c:a615:: with SMTP id p21mr3138182wme.121.1566442214348;
 Wed, 21 Aug 2019 19:50:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190821083820.11725-1-david@fromorbit.com> <20190821083820.11725-4-david@fromorbit.com>
 <20190821232945.GC24904@infradead.org>
In-Reply-To: <20190821232945.GC24904@infradead.org>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Thu, 22 Aug 2019 10:50:02 +0800
Message-ID: <CACVXFVN93h7QrFvZNVQQwYZg_n0wGXwn=XZztMJrNbdjzzSpKQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 8:06 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Aug 21, 2019 at 06:38:20PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > Add memory buffer alignment validation checks to bios built in XFS
> > to catch bugs that will result in silent data corruption in block
> > drivers that cannot handle unaligned memory buffers but don't
> > validate the incoming buffer alignment is correct.
> >
> > Known drivers with these issues are xenblk, brd and pmem.
> >
> > Despite there being nothing XFS specific to xfs_bio_add_page(), this
> > function was created to do the required validation because the block
> > layer developers that keep telling us that is not possible to
> > validate buffer alignment in bio_add_page(), and even if it was
> > possible it would be too much overhead to do at runtime.
>
> I really don't think we should life this to XFS, but instead fix it
> in the block layer.  And that is not only because I have a pending
> series lifting bits you are touching to the block layer..
>
> > +int
> > +xfs_bio_add_page(
> > +     struct bio      *bio,
> > +     struct page     *page,
> > +     unsigned int    len,
> > +     unsigned int    offset)
> > +{
> > +     struct request_queue    *q = bio->bi_disk->queue;
> > +     bool            same_page = false;
> > +
> > +     if (WARN_ON_ONCE(!blk_rq_aligned(q, len, offset)))
> > +             return -EIO;
> > +
> > +     if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
> > +             if (bio_full(bio, len))
> > +                     return 0;
> > +             __bio_add_page(bio, page, len, offset);
> > +     }
> > +     return len;
>
> I know Jens disagree, but with the amount of bugs we've been hitting
> thangs to slub (and I'm pretty sure we have a more hiding outside of
> XFS) I think we need to add the blk_rq_aligned check to bio_add_page.

It isn't correct to blk_rq_aligned() here because 'len' has to be logical block
size aligned, instead of DMA aligned only.

Also not sure all users may setup bio->bi_disk well before adding page to bio,
since it is allowed to do that now.

If slub buffer crosses two pages, block layer may not handle it at all
even though
un-aligned 'offset' issue is solved.

Thanks,
Ming Lei
