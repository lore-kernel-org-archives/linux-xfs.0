Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40646 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750891AbeEQI7I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 May 2018 04:59:08 -0400
Date: Thu, 17 May 2018 10:59:06 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 2/2] iomap: don't allow holes in swapfiles
Message-ID: <20180517085906.t4mb5oowufdyz2lk@quack2.suse.cz>
References: <cover.1526493125.git.osandov@fb.com>
 <cdb5dc22c56b30f693741361f6d6168f97f26bc1.1526493125.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdb5dc22c56b30f693741361f6d6168f97f26bc1.1526493125.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, Aleksei Besogonov <cyberax@amazon.com>, kernel-team@fb.com

On Wed 16-05-18 10:54:11, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> generic_swapfile_activate() doesn't allow holes, so we should be
> consistent here. This is also a bit safer: if the user creates a
> swapfile with, say, truncate -s $SIZE followed by mkswap, they should
> really get an error and not much less swap space than they expected.
> swapon(8) will error out before calling swapon(2) if the file has holes,
> anyways.
> 
> Fixes: 9d93388b0afe ("iomap: add a swapfile activation function")
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Good catch. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/iomap.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 89517442e296..f2456d0d8ddd 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -1220,10 +1220,6 @@ static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
>  		return -EINVAL;
>  	}
>  
> -	/* Skip holes. */
> -	if (iomap->type == IOMAP_HOLE)
> -		goto out;
> -
>  	/* Only real or unwritten extents. */
>  	if (iomap->type != IOMAP_MAPPED && iomap->type != IOMAP_UNWRITTEN) {
>  		pr_err("swapon: file has unallocated extents\n");
> @@ -1259,7 +1255,6 @@ static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
>  			return error;
>  		memcpy(&isi->iomap, iomap, sizeof(isi->iomap));
>  	}
> -out:
>  	return count;
>  }
>  
> -- 
> 2.17.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
