Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45494 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbeEPPuK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 11:50:10 -0400
Date: Wed, 16 May 2018 08:50:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] iomap: don't allow holes in swapfiles
Message-ID: <20180516155000.GC23858@magnolia>
References: <e722c29f7291b9c31533fd8b2e84d7f469c3ac88.1526452889.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e722c29f7291b9c31533fd8b2e84d7f469c3ac88.1526452889.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>

On Tue, May 15, 2018 at 11:45:38PM -0700, Omar Sandoval wrote:
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
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Hey, Darrick, I noticed this while writing up a generic xfstest to test
> that the Btrfs swap support patches don't allow a swapfile with holes.
> It'd be nice if we were all consistent :) This is based on
> xfs-linux/for-next. Feel free to fold it in to your patch or apply it
> separately as you see fit. Thanks!

I sent a testcase of my own ("generic: test swapfile creation,
activation, and deactivation") a while back; would you mind sending out
yours so we can combine them into a single testcase?

>  fs/iomap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index d193390a1c20..ba559adaa327 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -1214,9 +1214,9 @@ static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
>  	struct iomap_swapfile_info *isi = data;
>  	int error;
>  
> -	/* Skip holes. */
> +	/* No holes. */
>  	if (iomap->type == IOMAP_HOLE)
> -		goto out;
> +		goto err;

Ok.  I agree that it looks weird to mount a swap file with holes, so I
guess the least-surprise principle applies here and we should emulate
the old behavior completely.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  
>  	/* Only one bdev per swap file. */
>  	if (iomap->bdev != isi->sis->bdev)
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
