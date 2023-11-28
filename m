Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303181C3B
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 01:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z23NVD0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986FDC433C8;
	Tue, 28 Nov 2023 01:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701136409;
	bh=E6AWbb0RCBAC2KHxPmsYKkS2ntAK6XLzNbQwWkBamLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z23NVD0/jPuGzHwhauoGQsSDvgMPSCir7MzcOf6+gox0qYEJ5yrtZ0r9/gIOjGpdN
	 7oMnK+lbgGLXM0BJQ37Rkj/t3MUs/2ySml81mK6hsoeTh2u4mtAg50X6tzbkJN5d2b
	 nHvU9v7fD5xDxYK4grNO9SwrqFVOdpGx5yEzBIhaXszQruov96ORULm4P5Mj5/aoat
	 m0MNwy8YpX32xSulXN/hKn9ZE8/gyGK1BNvRta5W8sIo1BU43yO7x8UOGIenFhe+Ne
	 gsc1GmuNzHproeZNmBFyGmkfylgWI5wH4FxU4Eld4LC1qnKZd9bHzBOVESum4FUo9G
	 oPaGH9cV/NYJQ==
Date: Mon, 27 Nov 2023 17:53:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: clean up the XFS_IOC_{GS}ET_RESBLKS handler
Message-ID: <20231128015329.GQ2766956@frogsfrogsfrogs>
References: <20231126130124.1251467-1-hch@lst.de>
 <20231126130124.1251467-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231126130124.1251467-2-hch@lst.de>

On Sun, Nov 26, 2023 at 02:01:21PM +0100, Christoph Hellwig wrote:
> The XFS_IOC_GET_RESBLKS and XFS_IOC_SET_RESBLKS already share a fair
> amount of code, and will share even more soon.  Move the logic for both
> of them out of the main xfs_file_ioctl function into a
> xfs_ioctl_getset_resblocks helper to share the code and prepare for
> additional changes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_ioctl.c | 87 +++++++++++++++++++++++-----------------------
>  1 file changed, 43 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index a82470e027f727..8faaf2ef67a7b8 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1862,6 +1862,46 @@ xfs_fs_eofblocks_from_user(
>  	return 0;
>  }
>  
> +static int
> +xfs_ioctl_getset_resblocks(
> +	struct file		*filp,
> +	unsigned int		cmd,
> +	void __user		*arg)
> +{
> +	struct xfs_mount	*mp = XFS_I(file_inode(filp))->i_mount;
> +	struct xfs_fsop_resblks	fsop = { };
> +	int			error;
> +	uint64_t		in;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (cmd == XFS_IOC_SET_RESBLKS) {
> +		if (xfs_is_readonly(mp))
> +			return -EROFS;
> +
> +		if (copy_from_user(&fsop, arg, sizeof(fsop)))
> +			return -EFAULT;
> +
> +		error = mnt_want_write_file(filp);
> +		if (error)
> +			return error;
> +		in = fsop.resblks;
> +		error = xfs_reserve_blocks(mp, &in, &fsop);

<shudder> what an interface...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +		mnt_drop_write_file(filp);
> +		if (error)
> +			return error;
> +	} else {
> +		error = xfs_reserve_blocks(mp, NULL, &fsop);
> +		if (error)
> +			return error;
> +	}
> +
> +	if (copy_to_user(arg, &fsop, sizeof(fsop)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
>  /*
>   * These long-unused ioctls were removed from the official ioctl API in 5.17,
>   * but retain these definitions so that we can log warnings about them.
> @@ -2008,50 +2048,9 @@ xfs_file_ioctl(
>  		return 0;
>  	}
>  
> -	case XFS_IOC_SET_RESBLKS: {
> -		xfs_fsop_resblks_t inout;
> -		uint64_t	   in;
> -
> -		if (!capable(CAP_SYS_ADMIN))
> -			return -EPERM;
> -
> -		if (xfs_is_readonly(mp))
> -			return -EROFS;
> -
> -		if (copy_from_user(&inout, arg, sizeof(inout)))
> -			return -EFAULT;
> -
> -		error = mnt_want_write_file(filp);
> -		if (error)
> -			return error;
> -
> -		/* input parameter is passed in resblks field of structure */
> -		in = inout.resblks;
> -		error = xfs_reserve_blocks(mp, &in, &inout);
> -		mnt_drop_write_file(filp);
> -		if (error)
> -			return error;
> -
> -		if (copy_to_user(arg, &inout, sizeof(inout)))
> -			return -EFAULT;
> -		return 0;
> -	}
> -
> -	case XFS_IOC_GET_RESBLKS: {
> -		xfs_fsop_resblks_t out;
> -
> -		if (!capable(CAP_SYS_ADMIN))
> -			return -EPERM;
> -
> -		error = xfs_reserve_blocks(mp, NULL, &out);
> -		if (error)
> -			return error;
> -
> -		if (copy_to_user(arg, &out, sizeof(out)))
> -			return -EFAULT;
> -
> -		return 0;
> -	}
> +	case XFS_IOC_SET_RESBLKS:
> +	case XFS_IOC_GET_RESBLKS:
> +		return xfs_ioctl_getset_resblocks(filp, cmd, arg);
>  
>  	case XFS_IOC_FSGROWFSDATA: {
>  		struct xfs_growfs_data in;
> -- 
> 2.39.2
> 
> 
