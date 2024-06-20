Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24F8381B9
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 18:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718909834; cv=none; b=rxx/My2KnAdglKndMgnw4aCVaoWS+69am3PZKS5SsCk5Y/pgDhjuefOihdny9CDUlS130l/jKX+dAEgnH4z6LB3E+QQ2BdT/BdfOp1ZmSnhY8fTEnOY4a3uxA9BmiEP3IbD79+Da5SJio8Swlsa/HQB5Pn7K21c7QsLLy+QRdCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718909834; c=relaxed/simple;
	bh=BXdguldct67sxoXkEtvhsogT9FlvbcYDqiqcePMaf1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r1Sp45u5WLbiGpbNLW6va33dWcf+hXKJ6rUWlPLUUG0SNK9As/yaHnY2pobnkedyFoQ7bQgYBOSJ1m7vtWqrroqxUTRZJRMDNNaDxKgMEd9NRGbtxdoeKBrDEB+N6j0l3CG2i9/TTYSjUzVmZNngZe176sx8dLt8wqDNjPX43XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sp6T8KkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sp6T8KkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A51C2BD10;
	Thu, 20 Jun 2024 18:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718909833;
	bh=BXdguldct67sxoXkEtvhsogT9FlvbcYDqiqcePMaf1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sp6T8KkQYcez/Ke2cBKmlSffHbdcO64Msu/sxu+HEWmuPxHOD9dKDXK0mHSx8XKPW
	 avAXia63dW/uEUbC1H4YygZNOdnrTMvLNUVpuxdfa4zJZbmYcfwIi+8FdE2QvhvZWp
	 wn5ZOPJR9a6n+HrfQCi/Vwtpjsm/r5nGOei1kflc08D3BULe5oNa5VbNCoL2aMRo0e
	 4jxA7zXZREv+T4yKjQheMcT64bloSRTEA+yOFh0iccwsnSaESO+4Igd1ekjjovfw/6
	 7IEPr3ONDGILIaCpnubqIdFsfWnrONRh/mLdwcIH4G3Jqpa58PYqvKxGqlFEW+Qjgu
	 9K2+6l/k97qBw==
Date: Thu, 20 Jun 2024 11:57:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: fold xfs_ilock_for_write_fault into
 xfs_write_fault
Message-ID: <20240620185712.GD103034@frogsfrogsfrogs>
References: <20240619115426.332708-1-hch@lst.de>
 <20240619115426.332708-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619115426.332708-7-hch@lst.de>

On Wed, Jun 19, 2024 at 01:53:56PM +0200, Christoph Hellwig wrote:
> Now that the page fault handler has been refactored, the only caller
> of xfs_ilock_for_write_fault is simple enough and calls it
> unconditionally.  Fold the logic and expand the comments explaining it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c | 33 +++++++++++++++------------------
>  1 file changed, 15 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 62a69ed796f2fd..05ea96661c475f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -227,21 +227,6 @@ xfs_ilock_iocb_for_write(
>  	return 0;
>  }
>  
> -static unsigned int
> -xfs_ilock_for_write_fault(
> -	struct xfs_inode	*ip)
> -{
> -	/* get a shared lock if no remapping in progress */
> -	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> -	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
> -		return XFS_MMAPLOCK_SHARED;
> -
> -	/* wait for remapping to complete */
> -	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
> -	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> -	return XFS_MMAPLOCK_EXCL;
> -}
> -
>  STATIC ssize_t
>  xfs_file_dio_read(
>  	struct kiocb		*iocb,
> @@ -1294,18 +1279,30 @@ xfs_write_fault(
>  	unsigned int		order)
>  {
>  	struct inode		*inode = file_inode(vmf->vma->vm_file);
> -	unsigned int		lock_mode;
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	unsigned int		lock_mode = XFS_MMAPLOCK_SHARED;
>  	vm_fault_t		ret;
>  
>  	sb_start_pagefault(inode->i_sb);
>  	file_update_time(vmf->vma->vm_file);
>  
> -	lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));
> +	/*
> +	 * Normally we only need the shared mmaplock, but if a reflink remap is
> +	 * in progress we take the exclusive lock to wait for the remap to
> +	 * finish before taking a write fault.
> +	 */
> +	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> +	if (xfs_iflags_test(ip, XFS_IREMAPPING)) {
> +		xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
> +		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> +		lock_mode = XFS_MMAPLOCK_EXCL;
> +	}
> +
>  	if (IS_DAX(inode))
>  		ret = xfs_dax_fault_locked(vmf, order, true);
>  	else
>  		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
> -	xfs_iunlock(XFS_I(inode), lock_mode);
> +	xfs_iunlock(ip, lock_mode);
>  
>  	sb_end_pagefault(inode->i_sb);
>  	return ret;
> -- 
> 2.43.0
> 
> 
