Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 34B537CA4
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 09:22:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 025C0304048
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 07:22:25 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id znNgCwidZAuECdmC (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 May 2016 07:22:22 -0700 (PDT)
Date: Tue, 10 May 2016 16:21:19 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 4/5] dax: for truncate/hole-punch, do zeroing through
	the driver if possible
Message-ID: <20160510142119.GN11897@quack2.suse.cz>
References: <1462571591-3361-1-git-send-email-vishal.l.verma@intel.com>
	<1462571591-3361-5-git-send-email-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462571591-3361-5-git-send-email-vishal.l.verma@intel.com>
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

On Fri 06-05-16 15:53:10, Vishal Verma wrote:
> +static bool dax_range_is_aligned(struct block_device *bdev,
> +				 struct blk_dax_ctl *dax, unsigned int offset,
> +				 unsigned int length)
> +{
> +	unsigned short sector_size = bdev_logical_block_size(bdev);
> +
> +	if (((u64)dax->addr + offset) % sector_size)
> +		return false;
> +	if (length % sector_size)
> +		return false;

sector_size should better be a power of two so you can save some cycles by
using & instead of %.

> @@ -1240,11 +1254,17 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
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
> +					length / bdev_logical_block_size(bdev),
> +					GFP_NOFS, true);

This is actually wrong. blkdev_issue_zeroout() expects length to be simply
in units of 512-bytes. So you need length >> 9 here.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
