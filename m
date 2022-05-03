Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A80FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 22:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiECWTt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 18:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243533AbiECWTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 18:19:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42D053EBB9
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 15:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651616174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P+m2HgviktRF7+FLg8goUykshnn/6YyM7aMOuMI2GmY=;
        b=Cj7bjTaZyiebJtc69DY//SsVi57zkuz+9cAAp0SzG9Z1soNP+jWJMffR7p1GVCRRtebQRC
        xil31VUupnMZt0ZKZcHOtdS24rXUGFKD+I/5FlvgxmjhH0824uG8eLnUnc002c+gSD+Pye
        Hya6ozhgaKgCak6/RUktzggCNnbdPlY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-Vc263R0iM5igPTOkmSxE6w-1; Tue, 03 May 2022 18:16:13 -0400
X-MC-Unique: Vc263R0iM5igPTOkmSxE6w-1
Received: by mail-wm1-f72.google.com with SMTP id m26-20020a7bcb9a000000b0039455e871b6so452931wmi.8
        for <linux-xfs@vger.kernel.org>; Tue, 03 May 2022 15:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P+m2HgviktRF7+FLg8goUykshnn/6YyM7aMOuMI2GmY=;
        b=0TrLNb0Gl4CCfa9phKw+wh/l4zAfULrlX21iRCRSv3J/4d7gMtguLy7h0wPr61/OyN
         dlfLlCQpsb8My205MMOXjTXYSSnzwU6TLM9TsNG3S5c10O8qsgZDbwjed+Z9qfBisc2j
         siwFH0Sv9LkCjY/7LT0fouiJXAlntH4uryE45I4XQ76UUDdbNiDPFusLxR0AXH289Zj5
         S3hcQWb2XJBCBvCgOa1Avmahkl21ReUzAAnOrhhLpKU+kddR22QNokUXCeLhhsohFjfn
         Ngb9D44lFcWU8ErYiAvnvdyvDoAzovjB814HjS3G7sYoMe21Re9oOz29MtVOfescIEd2
         ncrA==
X-Gm-Message-State: AOAM532UvN+RgeUWFF4fy9PFevvfrh+tubvmJf5r4n/PRQBWGkttS47P
        QqIYJqHf/6sShqYBXO0yFphcRjhJMKPARViaARWSd5FXoUvsMagB2vySD3gCQXSKjQ/2CSzwV4p
        r+Yi9SF8tad0LcBJLuqX6I1/pQr7w5faCPgb8
X-Received: by 2002:a5d:5547:0:b0:20c:7a44:d8e7 with SMTP id g7-20020a5d5547000000b0020c7a44d8e7mr2669714wrw.349.1651616156775;
        Tue, 03 May 2022 15:15:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyL53Ke/vMFevWvEj+93LosE7xTi3VcEpQe/7CC8eovlyg0cDTCp1nV8tksVq6NS6fQ3BiB3qNeWVMEA7a4a10=
X-Received: by 2002:a5d:5547:0:b0:20c:7a44:d8e7 with SMTP id
 g7-20020a5d5547000000b0020c7a44d8e7mr2669709wrw.349.1651616156627; Tue, 03
 May 2022 15:15:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220503213727.3273873-1-agruenba@redhat.com> <YnGkO9zpuzahiI0F@casper.infradead.org>
In-Reply-To: <YnGkO9zpuzahiI0F@casper.infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 4 May 2022 00:15:45 +0200
Message-ID: <CAHc6FU5_JTi+RJxYwa+CLc9tx_3_CS8_r8DjkEiYRhyjUvbFww@mail.gmail.com>
Subject: Re: [PATCH] iomap: iomap_write_end cleanup
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 3, 2022 at 11:53 PM Matthew Wilcox <willy@infradead.org> wrote:
> On Tue, May 03, 2022 at 11:37:27PM +0200, Andreas Gruenbacher wrote:
> > In iomap_write_end(), only call iomap_write_failed() on the byte range
> > that has failed.  This should improve code readability, but doesn't fix
> > an actual bug because iomap_write_failed() is called after updating the
> > file size here and it only affects the memory beyond the end of the
> > file.
>
> I can't find a way to set 'ret' to anything other than 0 or len.  I know
> the code is written to make it look like we can return a short write,
> but I can't see a way to do it.

Good point, but that doesn't make the code any less confusing in my eyes.

Thanks,
Andreas

> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > ---
> >  fs/iomap/buffered-io.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 358ee1fb6f0d..8fb9b2797fc5 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -734,7 +734,7 @@ static size_t iomap_write_end(struct iomap_iter *iter, loff_t pos, size_t len,
> >       folio_put(folio);
> >
> >       if (ret < len)
> > -             iomap_write_failed(iter->inode, pos, len);
> > +             iomap_write_failed(iter->inode, pos + ret, len - ret);
> >       return ret;
> >  }
> >
> > --
> > 2.35.1
> >
>

