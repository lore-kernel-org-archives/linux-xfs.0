Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53740 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZUKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:10:21 -0400
Date: Wed, 26 Jun 2019 13:09:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 3/3] iomap: fix page_done callback for short writes
Message-ID: <20190626200946.GK5171@magnolia>
References: <20190626132335.14809-1-agruenba@redhat.com>
 <20190626132335.14809-3-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626132335.14809-3-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 03:23:35PM +0200, Andreas Gruenbacher wrote:
> When we truncate a short write to have it retried, pass the truncated
> length to the page_done callback instead of the full length.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

LGTM,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/iomap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 97569064faaa..9a9d016b2782 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -803,7 +803,7 @@ iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
>  	if (old_size < pos)
>  		pagecache_isize_extended(inode, old_size, pos);
>  	if (page_ops && page_ops->page_done)
> -		page_ops->page_done(inode, pos, copied, page, iomap);
> +		page_ops->page_done(inode, pos, ret, page, iomap);
>  	put_page(page);
>  
>  	if (ret < len)
> -- 
> 2.20.1
> 
