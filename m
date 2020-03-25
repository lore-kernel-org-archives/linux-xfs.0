Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB49C1975A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 09:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CE7320772
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 09:43:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="DMyiJnaz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgCYJnI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 05:43:08 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:42942 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgCYJnI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 05:43:08 -0400
Received: by mail-il1-f195.google.com with SMTP id f16so1210681ilj.9
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 02:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WJC80u+Ifj4HCTJaBhCcmeQxlknM9aDMikhj5e78Hk4=;
        b=DMyiJnazMqjl2qfzafo7tIFEtefoZjrSvPvqu5sHfAPRBEZ/A1uRJU7icYztbxoEQB
         g5CF3/s4HPa6oNzbsswDGOeOH6b8cPtSAM9SODfnMoawOYaqGUMD64MMEV4CyYGxaNCK
         u3cNVaqIoy9X6Y4p8jTdkYJcnnoetQuPBsAYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WJC80u+Ifj4HCTJaBhCcmeQxlknM9aDMikhj5e78Hk4=;
        b=OTKEnQTPcR9XjKIL/y4c0S88I/Ows+YrGvqDhA0yY5YdQfuW1aZ7OmSX0mzMKi3cDN
         vBVXlvw7Iar1JLEGiUWEv9lNi9qM7toL2zRZgkGYpHmcggaXLpjPakH6CxGGLhUJMefs
         MNqLtgI7P8rSPjmETqMiVh3ftUqbLpH4fpLEo5ui5kPR8nS0NxbBqceLrM+3GRtWkr20
         8roHVkBb5webeUuQW31LEvugrzq4My2pBIW7NAYGm5c0XC8Wfr/FH496EN147Z9VPhSf
         FGHhXcfKJcROGEkeOW5YF2nRC3HwilOH8MHAyJYohYf8LR49JmK7kN/PBm2vC1OwPSq8
         zXpA==
X-Gm-Message-State: ANhLgQ1/OSyRr1R4lr/m0a3qwBvtCTbZYWj6piZUqRNIsp32I5zc2P6P
        FgJCsup8uv+hHRef5xwE06JMpFHTqX1bnuuSQWRKww==
X-Google-Smtp-Source: ADFU+vsgfIWqTVfFvZZGiDAww03tclKMezpcFsmTHkThxRNJbwZiwKmblFARFxQj+PxAwoovscn7WyTAXThKOCyBwVE=
X-Received: by 2002:a92:9fd0:: with SMTP id z77mr2593848ilk.257.1585129387289;
 Wed, 25 Mar 2020 02:43:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200323202259.13363-1-willy@infradead.org> <20200323202259.13363-25-willy@infradead.org>
In-Reply-To: <20200323202259.13363-25-willy@infradead.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 25 Mar 2020 10:42:56 +0100
Message-ID: <CAJfpegu7EFcWrg3bP+-2BX_kb52RrzBCo_U3QKYzUkZfe4EjDA@mail.gmail.com>
Subject: Re: [PATCH v10 24/25] fuse: Convert from readpages to readahead
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        William Kucharski <william.kucharski@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 23, 2020 at 9:23 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> Use the new readahead operation in fuse.  Switching away from the
> read_cache_pages() helper gets rid of an implicit call to put_page(),
> so we can get rid of the get_page() call in fuse_readpages_fill().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>
> ---
>  fs/fuse/file.c | 46 +++++++++++++++++++---------------------------
>  1 file changed, 19 insertions(+), 27 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 9d67b830fb7a..5749505bcff6 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -923,9 +923,8 @@ struct fuse_fill_data {
>         unsigned int max_pages;
>  };
>
> -static int fuse_readpages_fill(void *_data, struct page *page)
> +static int fuse_readpages_fill(struct fuse_fill_data *data, struct page *page)
>  {
> -       struct fuse_fill_data *data = _data;
>         struct fuse_io_args *ia = data->ia;
>         struct fuse_args_pages *ap = &ia->ap;
>         struct inode *inode = data->inode;
> @@ -941,10 +940,8 @@ static int fuse_readpages_fill(void *_data, struct page *page)
>                                         fc->max_pages);
>                 fuse_send_readpages(ia, data->file);
>                 data->ia = ia = fuse_io_alloc(NULL, data->max_pages);
> -               if (!ia) {
> -                       unlock_page(page);
> +               if (!ia)
>                         return -ENOMEM;
> -               }
>                 ap = &ia->ap;
>         }
>
> @@ -954,7 +951,6 @@ static int fuse_readpages_fill(void *_data, struct page *page)
>                 return -EIO;
>         }
>
> -       get_page(page);
>         ap->pages[ap->num_pages] = page;
>         ap->descs[ap->num_pages].length = PAGE_SIZE;
>         ap->num_pages++;
> @@ -962,37 +958,33 @@ static int fuse_readpages_fill(void *_data, struct page *page)
>         return 0;
>  }
>
> -static int fuse_readpages(struct file *file, struct address_space *mapping,
> -                         struct list_head *pages, unsigned nr_pages)
> +static void fuse_readahead(struct readahead_control *rac)
>  {
> -       struct inode *inode = mapping->host;
> +       struct inode *inode = rac->mapping->host;
>         struct fuse_conn *fc = get_fuse_conn(inode);
>         struct fuse_fill_data data;
> -       int err;
> +       struct page *page;
>
> -       err = -EIO;
>         if (is_bad_inode(inode))
> -               goto out;
> +               return;
>
> -       data.file = file;
> +       data.file = rac->file;
>         data.inode = inode;
> -       data.nr_pages = nr_pages;
> -       data.max_pages = min_t(unsigned int, nr_pages, fc->max_pages);
> -;
> +       data.nr_pages = readahead_count(rac);
> +       data.max_pages = min_t(unsigned int, data.nr_pages, fc->max_pages);
>         data.ia = fuse_io_alloc(NULL, data.max_pages);
> -       err = -ENOMEM;
>         if (!data.ia)
> -               goto out;
> +               return;
>
> -       err = read_cache_pages(mapping, pages, fuse_readpages_fill, &data);
> -       if (!err) {
> -               if (data.ia->ap.num_pages)
> -                       fuse_send_readpages(data.ia, file);
> -               else
> -                       fuse_io_free(data.ia);
> +       while ((page = readahead_page(rac))) {
> +               if (fuse_readpages_fill(&data, page) != 0)

Shouldn't this unlock + put page on error?

Otherwise looks good.

Thanks,
Miklos
