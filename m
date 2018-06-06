Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:51232 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752097AbeFFLhY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jun 2018 07:37:24 -0400
Received: by mail-it0-f66.google.com with SMTP id n7-v6so7590991itn.1
        for <linux-xfs@vger.kernel.org>; Wed, 06 Jun 2018 04:37:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180606104033.4947-7-hch@lst.de>
References: <20180606104033.4947-1-hch@lst.de> <20180606104033.4947-7-hch@lst.de>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 6 Jun 2018 13:37:22 +0200
Message-ID: <CAHc6FU5jJ=ipbkrjoLnqC6AGcecTZC3rD-gKSQ=-EbEzyhxbLA@mail.gmail.com>
Subject: Re: [PATCH 6/6] iomap: add a page_done callback
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, cluster-devel <cluster-devel@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>

On 6 June 2018 at 12:40, Christoph Hellwig <hch@lst.de> wrote:
> This will be used by gfs2 to attach data to transactions for the journaled
> data mode.  But the concept is generic enough that we might be able to
> use it for other purposes like encryption/integrity post-processing in the
> future.
>
> Based on a patch from Andreas Gruenbacher.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap.c            | 3 +++
>  include/linux/iomap.h | 8 ++++++++
>  2 files changed, 11 insertions(+)
>
> diff --git a/fs/iomap.c b/fs/iomap.c
> index f2a491b98b7c..a7ecdd5ddd17 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -201,6 +201,9 @@ iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
>                                 copied, page, NULL);
>         }
>
> +       if (iomap->page_done)
> +               iomap->page_done(inode, pos, copied, page, iomap);
> +
>         if (ret < len)
>                 iomap_write_failed(inode, pos, len);
>         return ret;
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 69ef622f650e..474e2255ac6e 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -58,6 +58,14 @@ struct iomap {
>                 struct dax_device   *dax_dev;
>                 void                *inline_data;
>         };
> +
> +       /*
> +        * Called when finished processing a page in the mapping returned in
> +        * thus iomap.  At least for now this is only supported in the buffered

"thus" -> "this"

> +        * write path.
> +        */
> +       void (*page_done)(struct inode *inode, loff_t pos, unsigned copied,
> +                       struct page *page, struct iomap *iomap);
>  };
>
>  /*
> --
> 2.14.2
>

Andreas
