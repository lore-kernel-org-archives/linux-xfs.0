Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 31 Jul 2007 22:42:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l715ftbm003296
	for <xfs@oss.sgi.com>; Tue, 31 Jul 2007 22:41:59 -0700
Date: Wed, 1 Aug 2007 15:41:42 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] stop using uio in the readlink code
Message-ID: <20070801054142.GT31489@sgi.com>
References: <20070729211354.GB12824@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729211354.GB12824@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, Jul 29, 2007 at 11:13:54PM +0200, Christoph Hellwig wrote:
> Simplify the readlink code to get rid of the last user of uio.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-07-14 16:07:19.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2007-07-29 14:28:29.000000000 +0200
> @@ -349,19 +349,44 @@ xfs_open_by_handle(
>  	return new_fd;
>  }
>  
> +/*
> + * This is a copy from fs/namei.c:vfs_readlink(), except for removing it's
> + * unused first argument.
> + */
> +STATIC int
> +do_readlink(
> +	char __user		*buffer,
> +	int			buflen,
> +	const char		*link)
> +{
> +        int len;
> +
> +	len = PTR_ERR(link);
> +	if (IS_ERR(link))
> +		goto out;
> +
> +	len = strlen(link);
> +	if (len > (unsigned) buflen)
> +		len = buflen;
> +	if (copy_to_user(buffer, link, len))
> +		len = -EFAULT;
> + out:
> +	return len;
> +}

Do we really need to copy this code? I guess it doesn't really
matter that much but it would be nice not to have to copy an
exported vfs function just because we don't have a dentry...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
