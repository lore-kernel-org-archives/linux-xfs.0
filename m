Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:34841 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753353AbeE3NsY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 09:48:24 -0400
MIME-Version: 1.0
In-Reply-To: <20180530100208.31490-4-hch@lst.de>
References: <20180530100208.31490-1-hch@lst.de> <20180530100208.31490-4-hch@lst.de>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Wed, 30 May 2018 15:48:23 +0200
Message-ID: <CAHpGcM+NeMcEpBZZiesq6NUQZmwjvyUaLEnBXTwEVPCpNmkzXA@mail.gmail.com>
Subject: Re: [PATCH 3/3] fs: use ->is_partially_uptodate in page_cache_seek_hole_data
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org

2018-05-30 12:02 GMT+02:00 Christoph Hellwig <hch@lst.de>:
> This way the implementation doesn't depend on buffer_head internals.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap.c | 85 +++++++++++++++++++++++++-----------------------------
>  1 file changed, 39 insertions(+), 46 deletions(-)
>
> diff --git a/fs/iomap.c b/fs/iomap.c
> index e75153f52748..5b92243808d3 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -794,36 +794,51 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
>  }
>  EXPORT_SYMBOL_GPL(iomap_fiemap);
>
> -/*
> - * Seek for SEEK_DATA / SEEK_HOLE within @page, starting at @lastoff.
> - *
> - * Returns the offset within the file on success, and -ENOENT otherwise.
> - */
> -static loff_t
> -page_seek_hole_data(struct page *page, loff_t lastoff, int whence)
> +static bool
> +page_seek_hole_data(struct inode *inode, struct page *page, loff_t *lastoff,
> +               int whence)
>  {
> -       loff_t offset = page_offset(page);
> -       struct buffer_head *bh, *head;
> +       const struct address_space_operations *ops = inode->i_mapping->a_ops;
> +       unsigned int bsize = i_blocksize(inode), off;
>         bool seek_data = whence == SEEK_DATA;
> +       loff_t poff = page_offset(page);
>
> -       if (lastoff < offset)
> -               lastoff = offset;
> -
> -       bh = head = page_buffers(page);
> -       do {
> -               offset += bh->b_size;
> -               if (lastoff >= offset)
> -                       continue;
> +       if (WARN_ON_ONCE(*lastoff >= poff + PAGE_SIZE))
> +               return false;
>
> +       if (*lastoff < poff) {
>                 /*
> -                * Any buffer with valid data in it should have BH_Uptodate set.
> +                * Last offset smaller than the start of the page means we found
> +                * a hole:
>                  */
> -               if (buffer_uptodate(bh) == seek_data)
> -                       return lastoff;
> +               if (whence == SEEK_HOLE)
> +                       return true;
> +               *lastoff = poff;
> +       }
> +
> +       /*
> +        * Just check the page unless we can and should check block ranges:
> +        */
> +       if (bsize == PAGE_SIZE || !ops->is_partially_uptodate)
> +               return PageUptodate(page) == seek_data;
>
> -               lastoff = offset;
> -       } while ((bh = bh->b_this_page) != head);
> -       return -ENOENT;
> +       lock_page(page);
> +       if (unlikely(page->mapping != inode->i_mapping))
> +               goto out_unlock_not_found;

Not a regression, but I guess it would make more sense to treat the
above as a hole.

> +
> +       for (off = 0; off < PAGE_SIZE; off += bsize) {
> +               if ((*lastoff & ~PAGE_MASK) >= off + bsize)
> +                       continue;
> +               if (ops->is_partially_uptodate(page, off, bsize) == seek_data) {
> +                       unlock_page(page);
> +                       return true;
> +               }
> +               *lastoff = poff + off + bsize;
> +       }
> +
> +out_unlock_not_found:
> +       unlock_page(page);
> +       return false;
>  }
>
>  /*
> @@ -860,30 +875,8 @@ page_cache_seek_hole_data(struct inode *inode, loff_t offset, loff_t length,
>                 for (i = 0; i < nr_pages; i++) {
>                         struct page *page = pvec.pages[i];
>
> -                       /*
> -                        * At this point, the page may be truncated or
> -                        * invalidated (changing page->mapping to NULL), or
> -                        * even swizzled back from swapper_space to tmpfs file
> -                        * mapping.  However, page->index will not change
> -                        * because we have a reference on the page.
> -                         *
> -                        * If current page offset is beyond where we've ended,
> -                        * we've found a hole.
> -                         */
> -                       if (whence == SEEK_HOLE &&
> -                           lastoff < page_offset(page))
> +                       if (page_seek_hole_data(inode, page, &lastoff, whence))
>                                 goto check_range;
> -
> -                       lock_page(page);
> -                       if (likely(page->mapping == inode->i_mapping) &&
> -                           page_has_buffers(page)) {
> -                               lastoff = page_seek_hole_data(page, lastoff, whence);
> -                               if (lastoff >= 0) {
> -                                       unlock_page(page);
> -                                       goto check_range;
> -                               }
> -                       }
> -                       unlock_page(page);
>                         lastoff = page_offset(page) + PAGE_SIZE;
>                 }
>                 pagevec_release(&pvec);
> --
> 2.17.0

Other than the above, these three patches look okay, and they have
passed xfstests on gfs2.

Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>

Thanks,
Andreas
