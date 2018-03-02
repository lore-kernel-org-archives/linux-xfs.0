Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38254 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932266AbeCBWUc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Mar 2018 17:20:32 -0500
Date: Fri, 2 Mar 2018 23:20:31 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO writes
Message-ID: <20180302222031.GA30818@lst.de>
References: <20180301014144.28892-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180301014144.28892-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-fsdevel@vger.kernel.org

> @@ -760,8 +761,19 @@ static ssize_t iomap_dio_complete(struct iomap_dio *dio)
>  	}
>  
>  	inode_dio_end(file_inode(iocb->ki_filp));
> -	kfree(dio);
>  
> +	/*
> +	 * If a FUA write was done, then that is all we required for datasync
> +	 * semantics -. we don't need to call generic_write_sync() to complete
> +	 * the write.
> +	 */
> +	if (ret > 0 &&
> +	    (dio->flags & (IOMAP_DIO_WRITE|IOMAP_DIO_WRITE_FUA)) ==
> +							IOMAP_DIO_WRITE) {
> +		ret = generic_write_sync(iocb, ret);
> +	}
> +
> +	kfree(dio);

Can please split the move of the generic_write_sync call into
generic_write_sync a separate prep patch?  It's enough of a logic change
on its own that it warrants a separate commit with a separate explanation.

Also I'd be tempted to invert the IOMAP_DIO_WRITE_FUA flag and replace
it with an IOMAP_DIO_WRITE_SYNC flag to indicate we need the
generic_write_sync call, as that should make the logic much more clear.

> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 260ff5e5c264..81aa3b73471e 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -732,6 +732,11 @@ xfs_file_write_iter(
>  		ret = xfs_file_dio_aio_write(iocb, from);
>  		if (ret == -EREMCHG)
>  			goto buffered;
> +		/*
> +		 * Direct IO handles sync type writes internally on I/O
> +		 * completion.
> +		 */
> +		return ret;
>  	} else {
>  buffered:
>  		ret = xfs_file_buffered_aio_write(iocb, from);

The else is not needed and you can now have a much more sensible
code flow here:

		ret = xfs_file_dio_aio_write(iocb, from);
		if (ret != -EREMCHG))
			return ret;
	}

	ret = xfs_file_buffered_aio_write(iocb, from);

