Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39562 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbfHEMyB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 08:54:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so31135925wrt.6
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 05:54:00 -0700 (PDT)
Date: Mon, 5 Aug 2019 14:53:56 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 5/5] iomap: move struct iomap_page out of iomap.h
Message-ID: <20190805125356.bv42m4kiszy2ozqg@orion.maiolino.org>
References: <156444951713.2682520.8109813555788585092.stgit@magnolia>
 <156444955325.2682520.4411161096506742768.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156444955325.2682520.4411161096506742768.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Damien.LeMoal@wdc.com, Christoph Hellwig <hch@lst.de>, agruenba@redhat.com

On Mon, Jul 29, 2019 at 06:19:13PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Now that all the writepage code is in the iomap code there is no
> need to keep this structure public.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


>  fs/iomap/buffered-io.c |   17 +++++++++++++++++
>  include/linux/iomap.h  |   17 -----------------
>  2 files changed, 17 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 1a7570c441c8..ba0511131868 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -23,6 +23,23 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/iomap.h>
>  
> +/*
> + * Structure allocated for each page when block size < PAGE_SIZE to track
> + * sub-page uptodate status and I/O completions.
> + */
> +struct iomap_page {
> +	atomic_t		read_count;
> +	atomic_t		write_count;
> +	DECLARE_BITMAP(uptodate, PAGE_SIZE / 512);
> +};
> +
> +static inline struct iomap_page *to_iomap_page(struct page *page)
> +{
> +	if (page_has_private(page))
> +		return (struct iomap_page *)page_private(page);
> +	return NULL;
> +}
> +
>  static struct bio_set iomap_ioend_bioset;
>  
>  static struct iomap_page *
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 834d3923e2f2..38464b8f34b9 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -134,23 +134,6 @@ loff_t iomap_apply(struct inode *inode, loff_t pos, loff_t length,
>  		unsigned flags, const struct iomap_ops *ops, void *data,
>  		iomap_actor_t actor);
>  
> -/*
> - * Structure allocate for each page when block size < PAGE_SIZE to track
> - * sub-page uptodate status and I/O completions.
> - */
> -struct iomap_page {
> -	atomic_t		read_count;
> -	atomic_t		write_count;
> -	DECLARE_BITMAP(uptodate, PAGE_SIZE / 512);
> -};
> -
> -static inline struct iomap_page *to_iomap_page(struct page *page)
> -{
> -	if (page_has_private(page))
> -		return (struct iomap_page *)page_private(page);
> -	return NULL;
> -}
> -
>  ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
>  		const struct iomap_ops *ops);
>  int iomap_readpage(struct page *page, const struct iomap_ops *ops);
> 

-- 
Carlos
