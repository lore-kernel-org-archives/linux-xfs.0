Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40605 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750826AbeEQI6W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 May 2018 04:58:22 -0400
Date: Thu, 17 May 2018 10:58:20 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 1/2] iomap: provide more useful errors for invalid
 swap files
Message-ID: <20180517085820.rcjpg4jfr4av4upp@quack2.suse.cz>
References: <cover.1526493125.git.osandov@fb.com>
 <5299c1f79f445e89b4b1c3c6c21da6b0b8510cfb.1526493125.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5299c1f79f445e89b4b1c3c6c21da6b0b8510cfb.1526493125.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, Aleksei Besogonov <cyberax@amazon.com>, kernel-team@fb.com

On Wed 16-05-18 10:54:10, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Currently, for an invalid swap file, we print the same error message
> regardless of the reason. This isn't very useful for an admin, who will
> likely want to know why exactly they can't use their swap file. So,
> let's add specific error messages for each reason, and also move the
> bdev check after the flags checks, since the latter are more
> fundamental.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Yup, looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/iomap.c | 40 ++++++++++++++++++++++++----------------
>  1 file changed, 24 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index d193390a1c20..89517442e296 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -1214,26 +1214,37 @@ static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
>  	struct iomap_swapfile_info *isi = data;
>  	int error;
>  
> +	/* No inline data. */
> +	if (iomap->flags & IOMAP_F_DATA_INLINE) {
> +		pr_err("swapon: file is inline\n");
> +		return -EINVAL;
> +	}
> +
>  	/* Skip holes. */
>  	if (iomap->type == IOMAP_HOLE)
>  		goto out;
>  
> -	/* Only one bdev per swap file. */
> -	if (iomap->bdev != isi->sis->bdev)
> -		goto err;
> -
>  	/* Only real or unwritten extents. */
> -	if (iomap->type != IOMAP_MAPPED && iomap->type != IOMAP_UNWRITTEN)
> -		goto err;
> +	if (iomap->type != IOMAP_MAPPED && iomap->type != IOMAP_UNWRITTEN) {
> +		pr_err("swapon: file has unallocated extents\n");
> +		return -EINVAL;
> +	}
>  
> -	/* No uncommitted metadata or shared blocks or inline data. */
> -	if (iomap->flags & (IOMAP_F_DIRTY | IOMAP_F_SHARED |
> -			    IOMAP_F_DATA_INLINE))
> -		goto err;
> +	/* No uncommitted metadata or shared blocks. */
> +	if (iomap->flags & IOMAP_F_DIRTY) {
> +		pr_err("swapon: file is not committed\n");
> +		return -EINVAL;
> +	}
> +	if (iomap->flags & IOMAP_F_SHARED) {
> +		pr_err("swapon: file has shared extents\n");
> +		return -EINVAL;
> +	}
>  
> -	/* No null physical addresses. */
> -	if (iomap->addr == IOMAP_NULL_ADDR)
> -		goto err;
> +	/* Only one bdev per swap file. */
> +	if (iomap->bdev != isi->sis->bdev) {
> +		pr_err("swapon: file is on multiple devices\n");
> +		return -EINVAL;
> +	}
>  
>  	if (isi->iomap.length == 0) {
>  		/* No accumulated extent, so just store it. */
> @@ -1250,9 +1261,6 @@ static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
>  	}
>  out:
>  	return count;
> -err:
> -	pr_err("swapon: file cannot be used for swap\n");
> -	return -EINVAL;
>  }
>  
>  /*
> -- 
> 2.17.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
