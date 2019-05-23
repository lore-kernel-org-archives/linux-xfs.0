Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46223 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387693AbfEWXRc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 19:17:32 -0400
Date: Fri, 24 May 2019 09:17:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/20] xfs: factor out splitting of an iclog from
 xlog_sync
Message-ID: <20190523231726.GU29573@dread.disaster.area>
References: <20190523173742.15551-1-hch@lst.de>
 <20190523173742.15551-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523173742.15551-9-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 07:37:30PM +0200, Christoph Hellwig wrote:
> Split out a self-contained chunk of code from xlog_sync that calculates
> the split offset for an iclog that wraps the log end and bumps the
> cycles for the second half.
> 
> Use the chance to bring some sanity to the variables used to track the
> split in xlog_sync by not changing the count variable, and instead use
> split as the offset for the split and use those to calculate the
> sizes and offsets for the two write buffers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 63 +++++++++++++++++++++++++-----------------------
>  1 file changed, 33 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 9a81d2d32ad9..885470f08554 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1804,6 +1804,32 @@ xlog_write_iclog(
>  	xfs_buf_submit(bp);
>  }
>  
> +/*
> + * Bump the cycle numbers at the start of each block in the part of the iclog
> + * that ends up in the buffer that gets written to the start of the log.
> + *
> + * Watch out for the header magic number case, though.

Can we update this comment to be easier to parse?

/*
 * We need to bump cycle number for the part of the iclog that is
 * written to the start of the log. Watch out for the header magic
 * number case, though.
 */

> + */
> +static unsigned int
> +xlog_split_iclog(
> +	struct xlog		*log,
> +	void			*data,
> +	uint64_t		bno,
> +	unsigned int		count)
> +{
> +	unsigned int		split_offset = BBTOB(log->l_logBBsize - bno), i;

You can lose a tab from all these indents. Also, can you declare
i as a separate statement - I'd prefer we don't mix multiple
declarations with initialisations on the one line - it just makes
the code harder to read. (i.e. I had to specifically look to find
where i was declared...)

> +	for (i = split_offset; i < count; i += BBSIZE) {
> +		uint32_t cycle = get_unaligned_be32(data + i);
> +
> +		if (++cycle == XLOG_HEADER_MAGIC_NUM)
> +			cycle++;
> +		put_unaligned_be32(cycle, data + i);

Is the location we read from/write to ever unaligned? The cycle
should always be 512 byte aligned to the start of the iclog data
buffer, which should always be at least 4 byte aligned in memory...

Otherwise the patch is fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
