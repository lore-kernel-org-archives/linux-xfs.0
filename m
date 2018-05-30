Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:10449 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753695AbeE3XAl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 19:00:41 -0400
Date: Thu, 31 May 2018 09:00:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] fs: use ->is_partially_uptodate in
 page_cache_seek_hole_data
Message-ID: <20180530230038.GY10363@dastard>
References: <20180530100208.31490-1-hch@lst.de>
 <20180530100208.31490-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530100208.31490-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, May 30, 2018 at 12:02:08PM +0200, Christoph Hellwig wrote:
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
> +		int whence)

Can we keep the comment explaining the return value?

>  {
> -	loff_t offset = page_offset(page);
> -	struct buffer_head *bh, *head;
> +	const struct address_space_operations *ops = inode->i_mapping->a_ops;
> +	unsigned int bsize = i_blocksize(inode), off;

Split this into two lines.

Otherwise looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
