Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:65458 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751083AbdL0ARH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Dec 2017 19:17:07 -0500
Date: Tue, 26 Dec 2017 17:17:05 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v4 07/18] dax: store pfns in the radix
Message-ID: <20171227001705.GA4802@linux.intel.com>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407699792.38751.2859846645388380112.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151407699792.38751.2859846645388380112.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de

On Sat, Dec 23, 2017 at 04:56:38PM -0800, Dan Williams wrote:
> In preparation for examining the busy state of dax pages in the truncate
> path, switch from sectors to pfns in the radix.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dax/super.c |   15 ++++++++--
>  fs/dax.c            |   75 ++++++++++++++++++---------------------------------
>  2 files changed, 39 insertions(+), 51 deletions(-)
<>
> @@ -688,7 +685,7 @@ static int dax_writeback_one(struct block_device *bdev,
>  	 * compare sectors as we must not bail out due to difference in lockbit
>  	 * or entry type.
>  	 */

Can you please also fix the comment above this test so it talks about pfns
instead of sectors?

> -	if (dax_radix_sector(entry2) != dax_radix_sector(entry))
> +	if (dax_radix_pfn(entry2) != dax_radix_pfn(entry))
>  		goto put_unlocked;
>  	if (WARN_ON_ONCE(dax_is_empty_entry(entry) ||
>  				dax_is_zero_entry(entry))) {
> @@ -718,29 +715,11 @@ static int dax_writeback_one(struct block_device *bdev,
>  	 * 'entry'.  This allows us to flush for PMD_SIZE and not have to
>  	 * worry about partial PMD writebacks.
>  	 */

Ditto for this comment ^^^

> -	sector = dax_radix_sector(entry);
> +	pfn = dax_radix_pfn(entry);
>  	size = PAGE_SIZE << dax_radix_order(entry);
>  
> -	id = dax_read_lock();
> -	ret = bdev_dax_pgoff(bdev, sector, size, &pgoff);
> -	if (ret)
> -		goto dax_unlock;
> -
> -	/*
> -	 * dax_direct_access() may sleep, so cannot hold tree_lock over
> -	 * its invocation.
> -	 */
> -	ret = dax_direct_access(dax_dev, pgoff, size / PAGE_SIZE, &kaddr, &pfn);
> -	if (ret < 0)
> -		goto dax_unlock;
> -
> -	if (WARN_ON_ONCE(ret < size / PAGE_SIZE)) {
> -		ret = -EIO;
> -		goto dax_unlock;
> -	}
> -
> -	dax_mapping_entry_mkclean(mapping, index, pfn_t_to_pfn(pfn));
> -	dax_flush(dax_dev, kaddr, size);
> +	dax_mapping_entry_mkclean(mapping, index, pfn);
> +	dax_flush(dax_dev, page_address(pfn_to_page(pfn)), size);
>  	/*
>  	 * After we have flushed the cache, we can clear the dirty tag. There
>  	 * cannot be new dirty data in the pfn after the flush has completed as
