Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35118 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbeKJA4W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 19:56:22 -0500
Date: Fri, 9 Nov 2018 07:15:22 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/16] iomap: sub-block dio needs to zeroout beyond EOF
Message-ID: <20181109151522.GE9153@infradead.org>
References: <20181107063127.3902-1-david@fromorbit.com>
 <20181107063127.3902-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107063127.3902-6-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Nov 07, 2018 at 05:31:16PM +1100, Dave Chinner wrote:
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
> ---
>  fs/iomap.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 64ce240217a1..16d16596b00f 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -1676,7 +1676,14 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
>  		dio->submit.cookie = submit_bio(bio);
>  	} while (nr_pages);
>  
> -	if (need_zeroout) {
> +	/*
> +	 * We need to zeroout the tail of a sub-block write if th extent type

s/th/the/

Otherwise this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
