Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9162CC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 12:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FA0620776
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 12:21:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J/DN6BZS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgFRMVl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 08:21:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51693 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726909AbgFRMVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 08:21:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592482898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zVIx3Lw3mCtvicq1Con/Tph1Hck+YrpwlfvxN0WeRQA=;
        b=J/DN6BZSvzdN9abhvs2S0wzX+2nwhdiHBw3NOOzeq/q+d7NwTJ/0K7CJPzhMzxDKMwQw4d
        FUBbJKTl63NmnclxJ8rWHuJGyO/x5bk5lS/NLc1UzemSYEO5oX/RuYIcYBKe+dd5DGzuC8
        Vqo2Hiize4hhcDRnLtMEz2AEw8FsxCc=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-3v-_HgQRO_mZSUSI4i8THw-1; Thu, 18 Jun 2020 08:21:36 -0400
X-MC-Unique: 3v-_HgQRO_mZSUSI4i8THw-1
Received: by mail-oo1-f69.google.com with SMTP id p15so2587575oov.17
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jun 2020 05:21:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zVIx3Lw3mCtvicq1Con/Tph1Hck+YrpwlfvxN0WeRQA=;
        b=nbFHv0e5htPc4z0Y8L3BdStPK0cM6kSGuFHxwDGurP+PEdnxW5wBbLn9g/Dwv557t0
         SkR3sGmV3JUOzBddt1tkWIX+3wIOIy1K76ozpEz89T6bzeIUl+Kr2/NYr0HRFUU8LpR0
         AR/i5hdFaK+tuN70MtWMlBwryTMe7JBRo95xAJJ9jf3zedJJB1V1hCE/J0V4DGXnRCjc
         +ICTVwerm9bSVOdv6HuVO6MmYGL02fnlOgzYRZs2DcrFoKmF/CiFyVnVaONvdfwHlfgR
         v5/7TeYeT8G+vYhUv+X3fZjFQ4EHJ9AqgcMNtD4uBiYRCtv1N326Fae1fIgfkM2Ai8qi
         rfuQ==
X-Gm-Message-State: AOAM533aT9b8G9HORyjZ6DpQ1q3yh9W2InxoKPrDgcQu1/TdWUSOKmII
        7bAXsdDkCjR0T/Y+N+3qvPNCL+DXHiBOfGfmXohOvAswM/TTBE4OyNfa3j9SQp4tRMDmVS3rEaO
        hXLu30Bip/4A0a1dAAHmc5Rv+rMsNPQ0hqE4G
X-Received: by 2002:a4a:e049:: with SMTP id v9mr3772924oos.22.1592482895726;
        Thu, 18 Jun 2020 05:21:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8Vz5RoMaRMnhgrKw5BwObY2thiM8ANkKOLKrEUi3X7FXXUq1RapjKFAWIzm+QaaDyB5zq65OkmBNh89rmsAU=
X-Received: by 2002:a4a:e049:: with SMTP id v9mr3772904oos.22.1592482895397;
 Thu, 18 Jun 2020 05:21:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200615160244.741244-1-agruenba@redhat.com> <20200618013901.GR11245@magnolia>
In-Reply-To: <20200618013901.GR11245@magnolia>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Thu, 18 Jun 2020 14:21:23 +0200
Message-ID: <CAHc6FU714HhtJdbfZXL26fxQ1_AV7rpsOVbhx8sLrdqwOUJBzg@mail.gmail.com>
Subject: Re: [PATCH] iomap: Make sure iomap_end is called after iomap_begin
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Bob Peterson <rpeterso@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 18, 2020 at 3:39 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Mon, Jun 15, 2020 at 06:02:44PM +0200, Andreas Gruenbacher wrote:
> > Make sure iomap_end is always called when iomap_begin succeeds: the
> > filesystem may take locks in iomap_begin and release them in iomap_end,
> > for example.
> >
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > ---
> >  fs/iomap/apply.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/iomap/apply.c b/fs/iomap/apply.c
> > index 76925b40b5fd..c00a14d825db 100644
> > --- a/fs/iomap/apply.c
> > +++ b/fs/iomap/apply.c
> > @@ -46,10 +46,10 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
> >       ret = ops->iomap_begin(inode, pos, length, flags, &iomap, &srcmap);
> >       if (ret)
> >               return ret;
> > -     if (WARN_ON(iomap.offset > pos))
> > -             return -EIO;
> > -     if (WARN_ON(iomap.length == 0))
> > -             return -EIO;
> > +     if (WARN_ON(iomap.offset > pos) || WARN_ON(iomap.length == 0)) {
>
> <urk> Forgot to actually review the original patch. :P
>
> Why combine these WARN_ON?  Before, you could distinguish between your
> iomap_begin method returning zero length vs. bad offset.

Right, the WARN_ONs shouldn't both report the same line number. I'll
send an update.

Thanks,
Andreas

