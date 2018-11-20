Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52494 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbeKUJc7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 04:32:59 -0500
Date: Tue, 20 Nov 2018 15:01:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] iomap: sub-block dio needs to zeroout beyond EOF
Message-ID: <20181120230116.GM6792@magnolia>
References: <20181119211742.8824-1-david@fromorbit.com>
 <20181119211742.8824-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119211742.8824-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Nov 20, 2018 at 08:17:39AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we are soing sub-block dio that extends EOF, we need to zero
> the unused tail of the block to initialise the data in it it. If we
> do not zero the tail of the block, then an immediate mmap read of
> the EOF block will expose stale data beyond EOF to userspace. Found
> with fsx running sub-block DIO sizes vs MAPREAD/MAPWRITE operations.
> 
> Fix this by detecting if the end of the DIO write is beyond EOF
> and zeroing the tail if necessary.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok, will s/soing/doing/ on the changelog before committing.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/iomap.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 72f3864a2e6b..77c214194edf 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -1677,7 +1677,14 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
>  		dio->submit.cookie = submit_bio(bio);
>  	} while (nr_pages);
>  
> -	if (need_zeroout) {
> +	/*
> +	 * We need to zeroout the tail of a sub-block write if the extent type
> +	 * requires zeroing or the write extends beyond EOF. If we don't zero
> +	 * the block tail in the latter case, we can expose stale data via mmap
> +	 * reads of the EOF block.
> +	 */
> +	if (need_zeroout ||
> +	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
>  		/* zero out from the end of the write to the end of the block */
>  		pad = pos & (fs_block_size - 1);
>  		if (pad)
> -- 
> 2.19.1
> 
