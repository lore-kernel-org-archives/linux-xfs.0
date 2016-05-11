Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B5CD37CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 03:15:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 87C7D8F8054
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 01:15:39 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id OrKdm7f6MVAUPiK4 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 01:15:36 -0700 (PDT)
Date: Wed, 11 May 2016 10:15:32 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v6 4/5] dax: for truncate/hole-punch, do zeroing through
	the driver if possible
Message-ID: <20160511081532.GB14744@quack2.suse.cz>
References: <1462906156-22303-1-git-send-email-vishal.l.verma@intel.com>
	<1462906156-22303-5-git-send-email-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462906156-22303-5-git-send-email-vishal.l.verma@intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <boaz@plexistor.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On Tue 10-05-16 12:49:15, Vishal Verma wrote:
> In the truncate or hole-punch path in dax, we clear out sub-page ranges.
> If these sub-page ranges are sector aligned and sized, we can do the
> zeroing through the driver instead so that error-clearing is handled
> automatically.
> 
> For sub-sector ranges, we still have to rely on clear_pmem and have the
> possibility of tripping over errors.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

...

> +static bool dax_range_is_aligned(struct block_device *bdev,
> +				 struct blk_dax_ctl *dax, unsigned int offset,
> +				 unsigned int length)
> +{
> +	unsigned short sector_size = bdev_logical_block_size(bdev);
> +
> +	if (!IS_ALIGNED(((u64)dax->addr + offset), sector_size))

One more question: 'dax' is initialized in dax_zero_page_range() and
dax->addr is going to be always NULL here. So either you forgot to call
dax_map_atomic() to get the addr or the use of dax->addr is just bogus
(which is what I currently believe since I see no way how the address could
be unaligned with the sector_size)...

								Honza
> +		return false;
> +	if (!IS_ALIGNED(length, sector_size))
> +		return false;
> +
> +	return true;
> +}
> +
>  /**
>   * dax_zero_page_range - zero a range within a page of a DAX file
>   * @inode: The file being truncated
> @@ -1240,11 +1254,16 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
>  			.size = PAGE_SIZE,
>  		};
>  
> -		if (dax_map_atomic(bdev, &dax) < 0)
> -			return PTR_ERR(dax.addr);
> -		clear_pmem(dax.addr + offset, length);
> -		wmb_pmem();
> -		dax_unmap_atomic(bdev, &dax);
> +		if (dax_range_is_aligned(bdev, &dax, offset, length))
> +			return blkdev_issue_zeroout(bdev, dax.sector,
> +					length >> 9, GFP_NOFS, true);
> +		else {
> +			if (dax_map_atomic(bdev, &dax) < 0)
> +				return PTR_ERR(dax.addr);
> +			clear_pmem(dax.addr + offset, length);
> +			wmb_pmem();
> +			dax_unmap_atomic(bdev, &dax);
> +		}
>  	}
>  
>  	return 0;
> -- 
> 2.5.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
