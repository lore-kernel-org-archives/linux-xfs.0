Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161101AbcLPQiO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Dec 2016 11:38:14 -0500
Date: Fri, 16 Dec 2016 11:38:11 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/9] xfs: use memalloc_nofs_{save,restore} instead of
 memalloc_noio*
Message-ID: <20161216163811.GG8447@bfoster.bfoster>
References: <20161215140715.12732-1-mhocko@kernel.org>
 <20161215140715.12732-6-mhocko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161215140715.12732-6-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>

On Thu, Dec 15, 2016 at 03:07:11PM +0100, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> kmem_zalloc_large and _xfs_buf_map_pages use memalloc_noio_{save,restore}
> API to prevent from reclaim recursion into the fs because vmalloc can
> invoke unconditional GFP_KERNEL allocations and these functions might be
> called from the NOFS contexts. The memalloc_noio_save will enforce
> GFP_NOIO context which is even weaker than GFP_NOFS and that seems to be
> unnecessary. Let's use memalloc_nofs_{save,restore} instead as it should
> provide exactly what we need here - implicit GFP_NOFS context.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> ---
>  fs/xfs/kmem.c    | 10 +++++-----
>  fs/xfs/xfs_buf.c |  8 ++++----
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f31ae592dcae..5c6f9bd4d8be 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -441,17 +441,17 @@ _xfs_buf_map_pages(
>  		bp->b_addr = NULL;
>  	} else {
>  		int retried = 0;
> -		unsigned noio_flag;
> +		unsigned nofs_flag;
>  
>  		/*
>  		 * vm_map_ram() will allocate auxillary structures (e.g.
>  		 * pagetables) with GFP_KERNEL, yet we are likely to be under
>  		 * GFP_NOFS context here. Hence we need to tell memory reclaim
> -		 * that we are in such a context via PF_MEMALLOC_NOIO to prevent
> +		 * that we are in such a context via PF_MEMALLOC_NOFS to prevent
>  		 * memory reclaim re-entering the filesystem here and
>  		 * potentially deadlocking.
>  		 */
> -		noio_flag = memalloc_noio_save();
> +		nofs_flag = memalloc_nofs_save();
>  		do {
>  			bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
>  						-1, PAGE_KERNEL);
> @@ -459,7 +459,7 @@ _xfs_buf_map_pages(
>  				break;
>  			vm_unmap_aliases();
>  		} while (retried++ <= 1);
> -		memalloc_noio_restore(noio_flag);
> +		memalloc_noio_restore(nofs_flag);

memalloc_nofs_restore() ?

Brian

>  
>  		if (!bp->b_addr)
>  			return -ENOMEM;
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
