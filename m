Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39566 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbeLFRWM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Dec 2018 12:22:12 -0500
Subject: Re: [PATCH v2] xfs: use a dedicated SLAB cache for sector sized
 buffer data
References: <20181205225147.12626-1-hch@lst.de>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <52258a08-e79f-f52a-5062-6da805c268df@suse.com>
Date: Thu, 6 Dec 2018 19:22:09 +0200
MIME-Version: 1.0
In-Reply-To: <20181205225147.12626-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Cc: tom.leiming@gmail.com, vkuznets@redhat.com



On 6.12.18 г. 0:51 ч., Christoph Hellwig wrote:
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

nit: s/small/smaller/

<snip>
