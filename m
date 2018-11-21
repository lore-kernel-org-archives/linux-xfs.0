Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53934 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727874AbeKVDJb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 22:09:31 -0500
Date: Wed, 21 Nov 2018 08:34:22 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/5 V2] iomap: readpages doesn't zero page tail beyond
 EOF properly
Message-ID: <20181121163422.GB27540@infradead.org>
References: <20181119211742.8824-1-david@fromorbit.com>
 <20181121065018.GS19305@dastard>
 <20181121082736.GT19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121082736.GT19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Nov 21, 2018 at 07:27:36PM +1100, Dave Chinner wrote:
> index d51e7a2ae641..b95110867eee 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -142,13 +142,14 @@ static void
>  iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
>  		loff_t *pos, loff_t length, unsigned *offp, unsigned *lenp)
>  {
> +	loff_t orig_pos = *pos;
> +	loff_t isize = i_size_read(inode);
>  	unsigned block_bits = inode->i_blkbits;
>  	unsigned block_size = (1 << block_bits);
>  	unsigned poff = offset_in_page(*pos);
>  	unsigned plen = min_t(loff_t, PAGE_SIZE - poff, length);
>  	unsigned first = poff >> block_bits;
>  	unsigned last = (poff + plen - 1) >> block_bits;
> -	unsigned end = offset_in_page(i_size_read(inode)) >> block_bits;
>  
>  	/*
>  	 * If the block size is smaller than the page size we need to check the
> @@ -183,8 +184,11 @@ iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
>  	 * handle both halves separately so that we properly zero data in the
>  	 * page cache for blocks that are entirely outside of i_size.
>  	 */
> -	if (first <= end && last > end)
> -		plen -= (last - end) * block_size;
> +	if (orig_pos <= isize && orig_pos + length > isize) {
> +		unsigned end = offset_in_page(isize - 1) >> block_bits;
> +		if (first <= end && last > end)
> +			plen -= (last - end) * block_size;

Please add an empty line afte the variable declaration.

Otherwise this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
