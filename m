Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52686 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388133AbfHGWkB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 18:40:01 -0400
Date: Thu, 8 Aug 2019 08:38:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] vfs: fix page locking deadlocks when deduping files
Message-ID: <20190807223850.GQ7777@dread.disaster.area>
References: <20190807145114.GP7138@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807145114.GP7138@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: viro@zeniv.linux.org.uk, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Aug 07, 2019 at 07:51:14AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> +/*
> + * Lock two pages, ensuring that we lock in offset order if the pages are from
> + * the same file.
> + */
> +static void vfs_lock_two_pages(struct page *page1, struct page *page2)
> +{
> +	if (page1 == page2) {
> +		lock_page(page1);
> +		return;
> +	}
> +
> +	if (page1->mapping == page2->mapping && page1->index > page2->index)
> +		swap(page1, page2);

I would do this even if the pages are on different mappings. That
way we don't expose a landmine if some other code locks two pages
from the same mappings in a different order...

> +	lock_page(page1);
> +	lock_page(page2);
> +}
> +
>  /*
>   * Compare extents of two files to see if they are the same.
>   * Caller must have locked both inodes to prevent write races.
> @@ -1867,10 +1881,12 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>  		dest_page = vfs_dedupe_get_page(dest, destoff);
>  		if (IS_ERR(dest_page)) {
>  			error = PTR_ERR(dest_page);
> -			unlock_page(src_page);
>  			put_page(src_page);
>  			goto out_error;
>  		}
> +
> +		vfs_lock_two_pages(src_page, dest_page);
> +
>  		src_addr = kmap_atomic(src_page);
>  		dest_addr = kmap_atomic(dest_page);
>  
> @@ -1882,7 +1898,8 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>  
>  		kunmap_atomic(dest_addr);
>  		kunmap_atomic(src_addr);
> -		unlock_page(dest_page);
> +		if (dest_page != src_page)
> +			unlock_page(dest_page);
>  		unlock_page(src_page);

Would it make sense for symmetry to wrap these in
vfs_unlock_two_pages()?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
