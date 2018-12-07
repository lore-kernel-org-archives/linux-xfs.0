Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60678 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbeLGPV0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Dec 2018 10:21:26 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v2] xfs: use a dedicated SLAB cache for sector sized buffer data
In-Reply-To: <20181205225147.12626-1-hch@lst.de>
References: <20181205225147.12626-1-hch@lst.de>
Date: Fri, 07 Dec 2018 16:21:23 +0100
Message-ID: <87bm5xe51o.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: tom.leiming@gmail.com, linux-xfs@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> XFS currently uses kmalloc for buffers smaller than the page size to
> avoid wasting too much memory.  But this can cause a problem with slub
> debugging turned on as the allocations might not be naturally aligned.
> On block devices that require sector size alignment this can lead to
> data corruption.
>
> Give that our smaller than page size buffers are always sector sized
> on a live file system, we can just create a kmem_cache with an
> explicitly specified alignment requirement for this case to fix this
> case without much effort.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thank you for taking care of this issue, the patch was verified with
xen-blkfront driver when KASAN is enabled. So:

Tested-by: Xiao Liang <xiliang@redhat.com>

> ---
>
> Changes since v1:
>  - document the decision to use a single cache per file system in
>    a comment
>  - update the commit log a bit
>
>  fs/xfs/xfs_buf.c   | 23 +++++++++--------------
>  fs/xfs/xfs_mount.h |  2 ++
>  fs/xfs/xfs_super.c | 28 ++++++++++++++++++++++++++++
>  3 files changed, 39 insertions(+), 14 deletions(-)
>
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index b21ea2ba768d..904d45f93ce7 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -339,8 +339,10 @@ xfs_buf_free(
>  
>  			__free_page(page);
>  		}
> -	} else if (bp->b_flags & _XBF_KMEM)
> -		kmem_free(bp->b_addr);
> +	} else if (bp->b_flags & _XBF_KMEM) {
> +		kmem_cache_free(bp->b_target->bt_mount->m_sector_cache,
> +				bp->b_addr);
> +	}
>  	_xfs_buf_free_pages(bp);
>  	xfs_buf_free_maps(bp);
>  	kmem_zone_free(xfs_buf_zone, bp);
> @@ -354,6 +356,7 @@ xfs_buf_allocate_memory(
>  	xfs_buf_t		*bp,
>  	uint			flags)
>  {
> +	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	size_t			size;
>  	size_t			nbytes, offset;
>  	gfp_t			gfp_mask = xb_to_gfp(flags);
> @@ -362,25 +365,17 @@ xfs_buf_allocate_memory(
>  	int			error;
>  
>  	/*
> -	 * for buffers that are contained within a single page, just allocate
> -	 * the memory from the heap - there's no need for the complexity of
> -	 * page arrays to keep allocation down to order 0.
> +	 * Use a special slab cache for sector sized buffers when sectors are
> +	 * small than a page to avoid wasting lots of memory.
>  	 */
>  	size = BBTOB(bp->b_length);
> -	if (size < PAGE_SIZE) {
> -		bp->b_addr = kmem_alloc(size, KM_NOFS);
> +	if (size < PAGE_SIZE && size == mp->m_sb.sb_sectsize) {
> +		bp->b_addr = kmem_cache_alloc(mp->m_sector_cache, GFP_NOFS);
>  		if (!bp->b_addr) {
>  			/* low memory - use alloc_page loop instead */
>  			goto use_alloc_page;
>  		}
>  
> -		if (((unsigned long)(bp->b_addr + size - 1) & PAGE_MASK) !=
> -		    ((unsigned long)bp->b_addr & PAGE_MASK)) {
> -			/* b_addr spans two pages - use alloc_page instead */
> -			kmem_free(bp->b_addr);
> -			bp->b_addr = NULL;
> -			goto use_alloc_page;
> -		}
>  		bp->b_offset = offset_in_page(bp->b_addr);
>  		bp->b_pages = bp->b_page_array;
>  		bp->b_pages[0] = virt_to_page(bp->b_addr);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 7964513c3128..83d76271c2d4 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -93,6 +93,8 @@ typedef struct xfs_mount {
>  	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
>  	struct xfs_inode	*m_rootip;	/* pointer to root directory */
>  	struct xfs_quotainfo	*m_quotainfo;	/* disk quota information */
> +	struct kmem_cache	*m_sector_cache;/* sector sized buf data */
> +	char			*m_sector_cache_name;
>  	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
>  	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */
>  	xfs_buftarg_t		*m_rtdev_targp;	/* ptr to rt device */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f4d34749505e..1d07d9c02c20 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -706,6 +706,10 @@ xfs_close_devices(
>  		fs_put_dax(dax_rtdev);
>  	}
>  	xfs_free_buftarg(mp->m_ddev_targp);
> +	if (mp->m_sector_cache) {
> +		kmem_cache_destroy(mp->m_sector_cache);
> +		kfree(mp->m_sector_cache_name);
> +	}
>  	fs_put_dax(dax_ddev);
>  }
>  
> @@ -804,6 +808,30 @@ xfs_setup_devices(
>  {
>  	int			error;
>  
> +	/*
> +	 * Create a SLAB cache for block sized buffer data.  This is to avoid
> +	 * wasting a lot of memory given that XFS uses sector sized I/O for
> +	 * metadata even if the file system otherwise uses a larger block size.
> +	 * Note that we only create a single cache per filesystem even if the
> +	 * log can optionally use a different, larger sector size.  The reason
> +	 * for that is that the log code on a live file system uses its own
> +	 * memory allocation, and log recovery only uses one buffer at a time,
> +	 * so no memory is wasted there.
> +	 */
> +	if (mp->m_sb.sb_sectsize < PAGE_SIZE) {
> +		mp->m_sector_cache_name = kasprintf(GFP_KERNEL, "%s-sector",
> +				mp->m_fsname);
> +		if (!mp->m_sector_cache_name)
> +			return -ENOMEM;
> +		mp->m_sector_cache = kmem_cache_create(mp->m_sector_cache_name,
> +				mp->m_sb.sb_sectsize, mp->m_sb.sb_sectsize,
> +				0, NULL);
> +		if (!mp->m_sector_cache) {
> +			kfree(mp->m_sector_cache_name);
> +			return -ENOMEM;
> +		}
> +	}
> +
>  	error = xfs_setsize_buftarg(mp->m_ddev_targp, mp->m_sb.sb_sectsize);
>  	if (error)
>  		return error;

-- 
Vitaly
