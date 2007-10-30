Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Oct 2007 04:01:15 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9UB150w018226
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2007 04:01:09 -0700
Date: Tue, 30 Oct 2007 10:09:06 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Implement fallocate
Message-ID: <20071030100906.GD23489@infradead.org>
References: <20071029233841.GT995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029233841.GT995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

On Tue, Oct 30, 2007 at 10:38:41AM +1100, David Chinner wrote:
> +/*
> + * generic space allocation vector.
> + */

This comment is rather non-sensical.  But I think you can just kill
it as inode operations don't really need comments.

> +STATIC long
> +xfs_vn_fallocate(
> +	struct inode	*inode,
> +	int		mode,
> +	loff_t		offset,
> +	loff_t		len)
> +{
> +	long		error;
> +	loff_t		new_size = 0;
> +	xfs_flock64_t	bf;
> +
> +	/* preallocation on directories not yet supported */
> +	error = -ENODEV;
> +	if (S_ISDIR(inode->i_mode))
> +		goto out_error;
> +
> +	bf.l_whence = 0;
> +	bf.l_start = offset;
> +	bf.l_len = len;
> +
> +	xfs_ilock(XFS_I(inode), XFS_IOLOCK_EXCL);
> +	error = xfs_change_file_space(XFS_I(inode), XFS_IOC_RESVSP, &bf,
> +						0, NULL, ATTR_NOLOCK);

please add a 

	struct xfs_inode *ip = XFS_I(inode);

to the beginning of the function and use it subsequently.  That'll make the
fun ction a little more readable.

Otherwise this looks fine to me.
