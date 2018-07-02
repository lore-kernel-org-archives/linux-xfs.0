Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753132AbeGBSQC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Jul 2018 14:16:02 -0400
Date: Mon, 2 Jul 2018 14:16:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 23/24] iomap: add support for sub-pagesize buffered I/O
 without buffer heads
Message-ID: <20180702181600.GA9759@bfoster>
References: <20180615130209.1970-24-hch@lst.de>
 <20180619165211.GD2806@bfoster>
 <20180620075655.GA2668@lst.de>
 <20180620143252.GE3241@bfoster>
 <20180620160803.GA4838@magnolia>
 <20180620181259.GD4493@bfoster>
 <20180620190230.GB4838@magnolia>
 <20180621084646.GA5764@lst.de>
 <20180623130624.GA16691@bfoster>
 <20180702125036.GA3366@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180702125036.GA3366@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Jul 02, 2018 at 02:50:36PM +0200, Christoph Hellwig wrote:
> The problem is that we need to split extents at the eof block
> so that the existing zeroing actually takes effect.  The patch below
> fixes the test case for me:
> 

Looks sane at a glance. I'll take a closer look at v7 and run some more
testing..

Brian

> diff --git a/fs/iomap.c b/fs/iomap.c
> index e8f1bcdc95cf..9c88b8736de0 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -143,13 +143,20 @@ static void
>  iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
>  		loff_t *pos, loff_t length, unsigned *offp, unsigned *lenp)
>  {
> +	unsigned block_bits = inode->i_blkbits;
> +	unsigned block_size = (1 << block_bits);
>  	unsigned poff = *pos & (PAGE_SIZE - 1);
>  	unsigned plen = min_t(loff_t, PAGE_SIZE - poff, length);
> +	unsigned first = poff >> block_bits;
> +	unsigned last = (poff + plen - 1) >> block_bits;
> +	unsigned end = (i_size_read(inode) & (PAGE_SIZE - 1)) >> block_bits;
>  
> +	/*
> +	 * If the block size is smaller than the page size we need to check the
> +	 * per-block uptodate status and adjust the offset and length if needed
> +	 * to avoid reading in already uptodate ranges.
> +	 */
>  	if (iop) {
> -		unsigned block_size = i_blocksize(inode);
> -		unsigned first = poff >> inode->i_blkbits;
> -		unsigned last = (poff + plen - 1) >> inode->i_blkbits;
>  		unsigned int i;
>  
>  		/* move forward for each leading block marked uptodate */
> @@ -159,17 +166,27 @@ iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
>  			*pos += block_size;
>  			poff += block_size;
>  			plen -= block_size;
> +			first++;
>  		}
>  
>  		/* truncate len if we find any trailing uptodate block(s) */
>  		for ( ; i <= last; i++) {
>  			if (test_bit(i, iop->uptodate)) {
>  				plen -= (last - i + 1) * block_size;
> +				last = i - 1;
>  				break;
>  			}
>  		}
>  	}
>  
> +	/*
> +	 * If the extent spans the block that contains the i_size we need to
> +	 * handle both halves separately so that we properly zero data in the
> +	 * page cache for blocks that are entirely outside of i_size.
> +	 */
> +	if (first <= end && last > end)
> +		plen -= (last - end) * block_size;
> +
>  	*offp = poff;
>  	*lenp = plen;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
