Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11848C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 03:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D66ED6103A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 03:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhG2DzN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 23:55:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39425 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233414AbhG2DzN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 23:55:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627530910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uC1FHB6Ltwg9aVPHNYZs7xQhWoFRsts5ruZx40NQ+EI=;
        b=ar04ruK8NJdtw+cHgyMLruRMdwBt75eSzHSTu5f0/yd4r+bjaKDYbSynr6f7FzuKX7Ld21
        dJ+1RbCSQeGymab9eg7Mn+fOFYE4iD26aoyz6y11Nx1GVF9VP5+gyHYPPtdtTK+WxYE/m/
        jW/2qH5TQzYoGNTEYvNT8AOQUM3tDEA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-3B-CiJiCN-ugiopqoP4aIg-1; Wed, 28 Jul 2021 23:55:08 -0400
X-MC-Unique: 3B-CiJiCN-ugiopqoP4aIg-1
Received: by mail-wm1-f72.google.com with SMTP id o32-20020a05600c5120b0290225ef65c35dso1838164wms.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 20:55:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uC1FHB6Ltwg9aVPHNYZs7xQhWoFRsts5ruZx40NQ+EI=;
        b=h0OF14sTwjwiXc2kv8HVhbYjHacMbvQmhhvhoNS7SxhPe1xyhf5OCrHlph5soQ9OeU
         KNlh7368E9dPzSqPLGWZBFZKy3eu7aKdpjbz3ohkMP5Hiy1X8zbKPB+v/0u3X+8xGR44
         p0zBdPqSzgMkZherQKchPMus4c7pQ/ZoGurGo/aU2+S9WiGLeaxK8KLj/VrBpQyWeEEL
         RiRCLoRi8GlAFKnvSOfjim7lT1Wh7w8jrjZvRCar0jAZ1rqPVMr//EmrY+VsMAghkMOe
         Cxt2ISBZNJYeK1+AIaW4zvWoUCPenK3e3sw40T9DCv/iQR19UNcE14m+IIBGmQoSFuHZ
         pmJw==
X-Gm-Message-State: AOAM533FoV+IiCPpVpeI6mCSDvXfmNB3RTVK7knh2dmbNfyQwOoeY2uJ
        Kr+v3/grf5Zp4e6iNYq4NaNB/OcL3Yd6UK/mAMD1YEhx1TuBvGRrUnm4RwAhfPOXbXLdis5OR4A
        PesXrnx6CGwdYor+fwnUTwTnystSbdyslPfQo
X-Received: by 2002:a5d:5286:: with SMTP id c6mr2341665wrv.357.1627530907729;
        Wed, 28 Jul 2021 20:55:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyByMIX137ZLqJJiCVTQnxk6c1FnVSkm2nYKBkgw1Xej+SqUPl31fRTeEFWaBx/7Iuv8c60B/3IRkYVbRouDJo=
X-Received: by 2002:a5d:5286:: with SMTP id c6mr2341654wrv.357.1627530907583;
 Wed, 28 Jul 2021 20:55:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210729032344.3975412-1-willy@infradead.org>
In-Reply-To: <20210729032344.3975412-1-willy@infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Thu, 29 Jul 2021 05:54:56 +0200
Message-ID: <CAHc6FU5E9AdiH7SnfADteOVdttNFGO1EN0PoiYYVyaftCJ1Mqw@mail.gmail.com>
Subject: Re: [PATCH v2] iomap: Support inline data with block size < page size
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-erofs@lists.ozlabs.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs@vger.kernel.org, Gao Xiang <hsiangkao@linux.alibaba.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 29, 2021 at 5:25 AM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
> Remove the restriction that inline data must start on a page boundary
> in a file.  This allows, for example, the first 2KiB to be stored out
> of line and the trailing 30 bytes to be stored inline.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
> v2:
>  - Rebase on top of iomap: Support file tail packing v9
>
>  fs/iomap/buffered-io.c | 34 ++++++++++++++++------------------
>  1 file changed, 16 insertions(+), 18 deletions(-)
>
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 66b733537c46..50f18985ed13 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -209,28 +209,26 @@ static int iomap_read_inline_data(struct inode *inode, struct page *page,
>                 struct iomap *iomap)
>  {
>         size_t size = i_size_read(inode) - iomap->offset;
> +       size_t poff = offset_in_page(iomap->offset);
>         void *addr;
>
>         if (PageUptodate(page))
> -               return 0;
> +               return PAGE_SIZE - poff;
>
> -       /* inline data must start page aligned in the file */
> -       if (WARN_ON_ONCE(offset_in_page(iomap->offset)))
> -               return -EIO;

Maybe add a WARN_ON_ONCE(size > PAGE_SIZE - poff) here?

>         if (WARN_ON_ONCE(size > PAGE_SIZE -
>                          offset_in_page(iomap->inline_data)))
>                 return -EIO;
>         if (WARN_ON_ONCE(size > iomap->length))
>                 return -EIO;
> -       if (WARN_ON_ONCE(page_has_private(page)))
> -               return -EIO;
> +       if (poff > 0)
> +               iomap_page_create(inode, page);
>
> -       addr = kmap_atomic(page);
> +       addr = kmap_atomic(page) + poff;

Maybe kmap_local_page?

>         memcpy(addr, iomap->inline_data, size);
> -       memset(addr + size, 0, PAGE_SIZE - size);
> +       memset(addr + size, 0, PAGE_SIZE - poff - size);
>         kunmap_atomic(addr);
> -       SetPageUptodate(page);
> -       return 0;
> +       iomap_set_range_uptodate(page, poff, PAGE_SIZE - poff);
> +       return PAGE_SIZE - poff;
>  }
>
>  static inline bool iomap_block_needs_zeroing(struct inode *inode,
> @@ -252,13 +250,8 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>         unsigned poff, plen;
>         sector_t sector;
>
> -       if (iomap->type == IOMAP_INLINE) {
> -               int ret = iomap_read_inline_data(inode, page, iomap);
> -
> -               if (ret)
> -                       return ret;
> -               return PAGE_SIZE;
> -       }
> +       if (iomap->type == IOMAP_INLINE)
> +               return iomap_read_inline_data(inode, page, iomap);
>
>         /* zero post-eof blocks as the page may be mapped */
>         iop = iomap_page_create(inode, page);
> @@ -593,10 +586,15 @@ __iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, int flags,
>  static int iomap_write_begin_inline(struct inode *inode,
>                 struct page *page, struct iomap *srcmap)
>  {
> +       int ret;
> +
>         /* needs more work for the tailpacking case, disable for now */
>         if (WARN_ON_ONCE(srcmap->offset != 0))
>                 return -EIO;
> -       return iomap_read_inline_data(inode, page, srcmap);
> +       ret = iomap_read_inline_data(inode, page, srcmap);
> +       if (ret < 0)
> +               return ret;
> +       return 0;
>  }
>
>  static int
> --
> 2.30.2
>

Thanks,
Andreas

