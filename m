Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34125 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752199AbeC2P3W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 11:29:22 -0400
Date: Thu, 29 Mar 2018 17:29:19 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v7 03/14] block, dax: remove dead code in
 blkdev_writepages()
Message-ID: <20180329152919.6y2jwenxa24ouw2q@quack2.suse.cz>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167304720.5268.4517441516790980453.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152167304720.5268.4517441516790980453.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Jeff Moyer <jmoyer@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 21-03-18 15:57:27, Dan Williams wrote:
> Block device inodes never have S_DAX set, so kill the check for DAX and
> diversion to dax_writeback_mapping_range().
> 
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dave Chinner <david@fromorbit.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/block_dev.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index fe09ef9c21f3..846ee2d31781 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1946,11 +1946,6 @@ static int blkdev_releasepage(struct page *page, gfp_t wait)
>  static int blkdev_writepages(struct address_space *mapping,
>  			     struct writeback_control *wbc)
>  {
> -	if (dax_mapping(mapping)) {
> -		struct block_device *bdev = I_BDEV(mapping->host);
> -
> -		return dax_writeback_mapping_range(mapping, bdev, wbc);
> -	}
>  	return generic_writepages(mapping, wbc);
>  }
>  
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
