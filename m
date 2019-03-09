Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58750 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfCIRch (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Mar 2019 12:32:37 -0500
Date: Sat, 9 Mar 2019 09:32:30 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Use kmem_zalloc for bp->b_pages.
Message-ID: <20190309173230.GA4359@magnolia>
References: <20190309153636.14154-1-fxinrong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190309153636.14154-1-fxinrong@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sean Fu <fxinrong@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Mar 09, 2019 at 11:36:36PM +0800, Sean Fu wrote:
> Change the allocation of bp->b_pages to use kmem_zalloc instead of
> kmem_alloc.
> Remove unnecessary memset for bp->b_pages.
> 
> This reduces text size by 42 bytes.
> Before:
>    text	   data	    bss	    dec	    hex	filename
>   23335	    588	      8	  23931	   5d7b	./fs/xfs/xfs_buf.o
> After:
>    text	   data	    bss	    dec	    hex	filename
>   23293	    588	      8	  23889	   5d51	./fs/xfs/xfs_buf.o
> 
> Signed-off-by: Sean Fu <fxinrong@gmail.com>
> ---
>  fs/xfs/xfs_buf.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 4f5f2ff3f70f..be4f740b97c1 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -289,12 +289,11 @@ _xfs_buf_get_pages(
>  		if (page_count <= XB_PAGES) {
>  			bp->b_pages = bp->b_page_array;
>  		} else {
> -			bp->b_pages = kmem_alloc(sizeof(struct page *) *
> +			bp->b_pages = kmem_zalloc(sizeof(struct page *) *
>  						 page_count, KM_NOFS);
>  			if (bp->b_pages == NULL)
>  				return -ENOMEM;
>  		}
> -		memset(bp->b_pages, 0, sizeof(struct page *) * page_count);

Does this leave b_pages uninitialized in the page_count <= XB_PAGES
case?

--D

>  	}
>  	return 0;
>  }
> -- 
> 2.16.4
> 
