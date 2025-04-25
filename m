Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBA32798F8;
	Fri, 25 Apr 2025 15:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745594142; cv=none; b=CSNRnDTPmrJZ1VX7XdmJcAWOLRpLVa9QNTCZKa8syaO8lXFi2SEkkLfkftZhwVjlWcnBDMrcx/v7gDU3fzAv98/0roA9IGM2djBQmiNkSQamzVXWqG3wh09MDjkAqCfMdeolNES+PlO2UKWd9zF7hTycV9u927h0jSrW/cSWj7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745594142; c=relaxed/simple;
	bh=C8FYTYQnzVootuMsrCRmSfUtojWm8zdXdoSIa4cnad0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jxfOD/i0JUEZiba10lWdN4qjUDcPT2Vn9jNEFBzM8DCDAGOFPBXfUKhoFCMbTKXTcKzgoVR64bXM8GS+zF3ESG/UMMzClPLqzOy6JNeP9SwURMgcxAa92zlDXzPxFcb33v+gX5nAhWPrjn9pTMya5+0Jgs3HkOjPGZHJmZ8oiKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TA/WAoHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TA/WAoHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505FFC4CEE4;
	Fri, 25 Apr 2025 15:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745594140;
	bh=C8FYTYQnzVootuMsrCRmSfUtojWm8zdXdoSIa4cnad0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TA/WAoHG8B/vfXAZVI2vircaK33q5sO+5Yij8KhVqH2Xx6aJMwuhSM+lNErabPqF+
	 BYoth885LHHkpn7bJrFarLnuGWa9OPtUJWyBWTnRlL1pRfeWFcf000TZU7Z368BDpA
	 FT8WjbnayGrv//EM/5mlCLkKe0FQHuLNuOhrmei1fZlHKNI0sxZa1Z16oCXdO1jHr7
	 KoxVKKWcBHW2UfiySgkTVqHB7vxhSFkQkuaTInOpMoOuAMeK0R99DGiziPVkra801S
	 RNWcWus2DFYbKJu/DTlKVDBh8+mGrgovrCMQb4WdmIRgauYbZuMYloYQgxk5LCiz8P
	 wH1M68q02ucvA==
Date: Fri, 25 Apr 2025 08:15:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chi Zhiling <chizhiling@163.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [RFC PATCH 2/2] xfs: Enable concurrency when writing within
 single block
Message-ID: <20250425151539.GO25675@frogsfrogsfrogs>
References: <20250425103841.3164087-1-chizhiling@163.com>
 <20250425103841.3164087-3-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425103841.3164087-3-chizhiling@163.com>

On Fri, Apr 25, 2025 at 06:38:41PM +0800, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> For unextending writes, we will only update the pagecache and extent.
> In this case, if our write occurs within a single block, that is,
> within a single folio, we don't need an exclusive lock to ensure the
> atomicity of the write, because we already have the folio lock.
> 
> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
> ---
>  fs/xfs/xfs_file.c | 34 +++++++++++++++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index a6f214f57238..8eaa98464328 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -914,6 +914,27 @@ xfs_file_dax_write(
>  	return ret;
>  }
>  
> +#define offset_in_block(inode, p) ((unsigned long)(p) & (i_blocksize(inode) - 1))

Is it correct to cast an loff_t (s64) to unsigned long (u32 on i386)
here?

> +
> +static inline bool xfs_allow_concurrent(

static inline bool
xfs_allow_concurrent(

(separate lines style nit)

> +	struct kiocb		*iocb,
> +	struct iov_iter		*from)
> +{
> +	struct inode		*inode = iocb->ki_filp->f_mapping->host;
> +
> +	/* Extending write? */
> +	if (iocb->ki_flags & IOCB_APPEND ||
> +	    iocb->ki_pos >= i_size_read(inode))
> +		return false;
> +
> +	/* Exceeds a block range? */
> +	if (iov_iter_count(from) > i_blocksize(inode) ||
> +	    offset_in_block(inode, iocb->ki_pos) + iov_iter_count(from) > i_blocksize(inode))
> +		return false;
> +
> +	return true;
> +}

...and since this helper only has one caller, maybe it should be named
xfs_buffered_write_iolock_mode and return the lock mode directly?

> +
>  STATIC ssize_t
>  xfs_file_buffered_write(
>  	struct kiocb		*iocb,
> @@ -925,8 +946,12 @@ xfs_file_buffered_write(
>  	bool			cleared_space = false;
>  	unsigned int		iolock;
>  
> +	if (xfs_allow_concurrent(iocb, from))
> +		iolock = XFS_IOLOCK_SHARED;
> +	else
> +		iolock = XFS_IOLOCK_EXCL;
> +
>  write_retry:
> -	iolock = XFS_IOLOCK_EXCL;
>  	ret = xfs_ilock_iocb_for_write(iocb, &iolock, false);
>  	if (ret)
>  		return ret;
> @@ -935,6 +960,13 @@ xfs_file_buffered_write(
>  	if (ret)
>  		goto out;
>  
> +	if (iolock == XFS_IOLOCK_SHARED &&
> +	    iocb->ki_pos + iov_iter_count(from) > i_size_read(inode)) {
> +		xfs_iunlock(ip, iolock);
> +		iolock = XFS_IOLOCK_EXCL;
> +		goto write_retry;
> +	}
> +
>  	trace_xfs_file_buffered_write(iocb, from);
>  	ret = iomap_file_buffered_write(iocb, from,
>  			&xfs_buffered_write_iomap_ops, NULL);
> -- 
> 2.43.0
> 
> 
