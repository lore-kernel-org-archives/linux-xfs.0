Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38104 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751455AbdH3PEA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 11:04:00 -0400
Date: Wed, 30 Aug 2017 17:03:57 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] iomap: Add IOMAP_F_DATA_INLINE flag
Message-ID: <20170830150357.GD5920@quack2.suse.cz>
References: <20170829142942.21594-1-agruenba@redhat.com>
 <20170829142942.21594-3-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829142942.21594-3-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>

On Tue 29-08-17 16:29:40, Andreas Gruenbacher wrote:
> Add a new IOMAP_F_DATA_INLINE flag to indicate that a mapping is in a
> disk area that contains data as well as metadata.  In iomap_fiemap, map
> this flag to FIEMAP_EXTENT_DATA_INLINE.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/iomap.c            | 2 ++
>  include/linux/iomap.h | 5 +++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 7bc1797c2292..f0a263482a0e 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -510,6 +510,8 @@ static int iomap_to_fiemap(struct fiemap_extent_info *fi,
>  		flags |= FIEMAP_EXTENT_MERGED;
>  	if (iomap->flags & IOMAP_F_SHARED)
>  		flags |= FIEMAP_EXTENT_SHARED;
> +	if (iomap->flags & IOMAP_F_DATA_INLINE)
> +		flags |= FIEMAP_EXTENT_DATA_INLINE;
>  
>  	return fiemap_fill_next_extent(fi, iomap->offset,
>  			iomap->addr != IOMAP_NULL_ADDR ? iomap->addr : 0,
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 7b8a615fa021..2b0790dbd6ea 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -26,8 +26,9 @@ struct vm_fault;
>  /*
>   * Flags that only need to be reported for IOMAP_REPORT requests:
>   */
> -#define IOMAP_F_MERGED	0x10	/* contains multiple blocks/extents */
> -#define IOMAP_F_SHARED	0x20	/* block shared with another file */
> +#define IOMAP_F_MERGED		0x10	/* contains multiple blocks/extents */
> +#define IOMAP_F_SHARED		0x20	/* block shared with another file */
> +#define IOMAP_F_DATA_INLINE	0x40	/* data inline in the inode */
>  
>  /*
>   * Magic value for addr:
> -- 
> 2.13.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
