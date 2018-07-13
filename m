Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387696AbeGMDL1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jul 2018 23:11:27 -0400
Date: Thu, 12 Jul 2018 21:58:53 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 5/6] iomap: add a page_done callback
Message-ID: <20180713025853.xugxx6zte3kvvqjy@merlin>
References: <20180619164137.13720-1-hch@lst.de>
 <20180619164137.13720-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619164137.13720-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org

On 18:41 19/06, Christoph Hellwig wrote:
> This will be used by gfs2 to attach data to transactions for the journaled
> data mode.  But the concept is generic enough that we might be able to
> use it for other purposes like encryption/integrity post-processing in the
> future.
> 
> Based on a patch from Andreas Gruenbacher.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap.c            | 3 +++
>  include/linux/iomap.h | 9 +++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 4aecd7c5dbd8..a1f71e64ea49 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -201,6 +201,9 @@ iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
>  				copied, page, NULL);
>  	}
>  
> +	if (iomap->page_done)
> +		iomap->page_done(inode, pos, copied, page, iomap);
> +
>  	if (ret < len)
>  		iomap_write_failed(inode, pos, len);
>  	return ret;
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 10d6cff7f69a..45f43865b0f0 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -9,6 +9,7 @@ struct fiemap_extent_info;
>  struct inode;
>  struct iov_iter;
>  struct kiocb;
> +struct page;
>  struct vm_area_struct;
>  struct vm_fault;
>  
> @@ -56,6 +57,14 @@ struct iomap {
>  	struct block_device	*bdev;	/* block device for I/O */
>  	struct dax_device	*dax_dev; /* dax_dev for dax operations */
>  	void			*inline_data;
> +
> +	/*
> +	 * Called when finished processing a page in the mapping returned in
> +	 * this iomap.  At least for now this is only supported in the buffered
> +	 * write path.
> +	 */
> +	void (*page_done)(struct inode *inode, loff_t pos, unsigned copied,
> +			struct page *page, struct iomap *iomap);
>  };
>  

Would it be better if we keep this function as a part of iomap_ops? I
know gfs2 sets this conditionally, but we can always check the condition
in the function assigned to page_done(). It would keep all the functions
in one place.

-- 
Goldwyn

