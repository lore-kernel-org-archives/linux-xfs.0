Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35218 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbeKJA7T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 19:59:19 -0500
Date: Fri, 9 Nov 2018 07:18:19 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/16] iomap: support block size > page size for direct IO
Message-ID: <20181109151819.GF9153@infradead.org>
References: <20181107063127.3902-1-david@fromorbit.com>
 <20181107063127.3902-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107063127.3902-7-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

>  static blk_qc_t
>  iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
>  		unsigned len)
>  {
>  	struct page *page = ZERO_PAGE(0);
>  	struct bio *bio;
> +	int npages = howmany(len, PAGE_SIZE);
> +
> +	WARN_ON_ONCE(npages > 16);

Where does this magic 16 come from?

> +	WARN_ON(len != 0);

WARN_ON_ONCE please to avoid making the log unreadable if it ever
triggers.

> +/*
> + * This is lifted almost straight from xfs_flush_unmap_range(). Need a generic
> + * version of the block size rounding for these purposes.
> + */

Can you just add a generic version of this in a separate patch and
also switch XFS over to it?

> +static int
> +iomap_flush_unmap_range(struct file *f, loff_t offset, loff_t len)

Can we please spell out file in the parameter name?
