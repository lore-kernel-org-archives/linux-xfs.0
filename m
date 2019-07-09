Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:38266 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfGIXdE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 19:33:04 -0400
MIME-Version: 1.0
References: <20190703075502.79782-1-yuchao0@huawei.com>
In-Reply-To: <20190703075502.79782-1-yuchao0@huawei.com>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Wed, 10 Jul 2019 01:32:51 +0200
Message-ID: <CAHpGcM+s77hKMXo=66nWNF7YKa3qhLY9bZrdb4-Lkspyg2CCDw@mail.gmail.com>
Subject: Re: [RFC PATCH] iomap: generalize IOMAP_INLINE to cover tail-packing case
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chao Yu <yuchao0@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Gao Xiang <gaoxiang25@huawei.com>, chao@kernel.org

Hi Chao,

Am Mi., 3. Juli 2019 um 09:55 Uhr schrieb Chao Yu <yuchao0@huawei.com>:
> Some filesystems like erofs/reiserfs have the ability to pack tail
> data into metadata, e.g.:
> IOMAP_MAPPED [0, 8192]
> IOMAP_INLINE [8192, 8200]
>
> However current IOMAP_INLINE type has assumption that:
> - inline data should be locating at page #0.
> - inline size should equal to .i_size
> Those restriction fail to convert to use iomap IOMAP_INLINE in erofs,
> so this patch tries to relieve above limits to make IOMAP_INLINE more
> generic to cover tail-packing case.

this patch suffers from the following problems:

* Fiemap distinguishes between FIEMAP_EXTENT_DATA_INLINE and
FIEMAP_EXTENT_DATA_TAIL. Someone will sooner or later inevitably use
iomap_fiemap on a filesystem with tail packing, so if we don't make
the same distinction in iomap, iomap_fiemap will silently produce the
wrong result. This means that IOMAP_TAIL should become a separate
mapping type.

* IOMAP_INLINE mappings always start at offset 0 and span an entire
page, so they are always page aligned. IOMAP_TAIL mappings only need
to be block aligned. If the block size is smaller than the page size,
a tail page can consist of more than one mapping. So
iomap_read_inline_data needs to be changed to only copy a single block
out of iomap->inline_data, and we need to adjust iomap_write_begin and
iomap_readpage_actor accordingly.

* Functions iomap_read_inline_data, iomap_write_end_inline, and
iomap_dio_inline_actor currently all assume that we are operating on
page 0, and that iomap->inline_data points at the data at offset 0.
That's no longer the case for IOMAP_TAIL mappings. We need to look
only at the offset within the page / block there.

* There are some asserts like the following int he code:

  BUG_ON(size > PAGE_SIZE - offset_in_page(iomap->inline_data));

Those should probably be tightened to check for block boundaries
instead of page boundaries, i.e. something like:

  BUG_ON(size > i_blocksize(inode) -
offset_in_block(iomap->inline_data, inode));

> Signed-off-by: Chao Yu <yuchao0@huawei.com>
> ---
>  fs/iomap.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 12654c2e78f8..d1c16b692d31 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -264,13 +264,12 @@ static void
>  iomap_read_inline_data(struct inode *inode, struct page *page,
>                 struct iomap *iomap)
>  {
> -       size_t size = i_size_read(inode);
> +       size_t size = iomap->length;

Function iomap_read_inline_data fills the entire page here, not only
the iomap->length part, so this is wrong. But see my comment above
about changing iomap_read_inline_data to read a single block above as
well.

>         void *addr;
>
>         if (PageUptodate(page))
>                 return;
>
> -       BUG_ON(page->index);
>         BUG_ON(size > PAGE_SIZE - offset_in_page(iomap->inline_data));
>
>         addr = kmap_atomic(page);
> @@ -293,7 +292,6 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>         sector_t sector;
>
>         if (iomap->type == IOMAP_INLINE) {
> -               WARN_ON_ONCE(pos);
>                 iomap_read_inline_data(inode, page, iomap);
>                 return PAGE_SIZE;
>         }

Those last two changes look right to me.

Thanks,
Andreas
