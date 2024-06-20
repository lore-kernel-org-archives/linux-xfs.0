Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C481B5839
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 18:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718909647; cv=none; b=SLErsOe5udai4nBlDB81HZGsyirGMsKokpUiFMd06uGnZNURA9TwUPxm0NN+oBC10Flm+YjBP1XCvjdWJiA2mCwUxXRj+k8uZc41FfEur9ok2yxytUQ8hK0hTMY4VXfa/avO9Jxo8vT+12R4lKcnKF4BQm7ZA9II/I+CWXNbKwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718909647; c=relaxed/simple;
	bh=OelMIHbfvbfp2JLElKt7pxSGZE8PFgjptstO1zW7228=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oyl/KrN+KxKvJHzTkFVmqkZNFYA5U14EvXlkRiAToC3H+LFldFDKy53h8fNes2/luDhJlikOFpl/73E6XebL2EJytmrEGU88IqDDwXQPLhJZJ6f1atWPYqUKRIJsXa0My3oDFmnuNPzy51/oTMk3/DJvPGaME2tT97Pfx7bLZA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J5yseO4T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J5yseO4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B330AC32786;
	Thu, 20 Jun 2024 18:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718909646;
	bh=OelMIHbfvbfp2JLElKt7pxSGZE8PFgjptstO1zW7228=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J5yseO4TDJWe5MPRAd9FcF4NvtZlto8aZ1mhqDFG5O/i/aziOFngSwbS3pt4q8Xs4
	 RDgQN59wBA9KvXU/0Z9rTPUBHL4wGV8fRJWHMN96HTZWj2zmRMiJaTvto6k0TPcfis
	 JkMJC/IwnY+5t1qeWG9zkZJ39H3AJ39NW0hsp6UV2LDu1HCTATtuIF7ipsphY+o3yc
	 7EyUWJw/z0XZ82h92ca4Vuy2/oD1PhlpOXZkekXhYQ0ZQPZeBgOfTM5v1hEHoLyWzp
	 tC5qFIGZzkPhANXjVUwwE+pspUnkf6fzS5me9itVUBrLNettIO8k4IGJfLEprgzVA/
	 QH6l3ZqgnF3sg==
Date: Thu, 20 Jun 2024 11:54:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: refactor __xfs_filemap_fault
Message-ID: <20240620185406.GB103034@frogsfrogsfrogs>
References: <20240619115426.332708-1-hch@lst.de>
 <20240619115426.332708-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619115426.332708-5-hch@lst.de>

On Wed, Jun 19, 2024 at 01:53:54PM +0200, Christoph Hellwig wrote:
> Split the write fault and DAX fault handling into separate helpers
> so that the main fault handler is easier to follow.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 71 ++++++++++++++++++++++++++++++-----------------
>  1 file changed, 45 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 8aab2f66fe016f..51e50afd935895 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1252,7 +1252,7 @@ xfs_file_llseek(
>  }
>  
>  static inline vm_fault_t
> -xfs_dax_fault(
> +xfs_dax_fault_locked(
>  	struct vm_fault		*vmf,
>  	unsigned int		order,
>  	bool			write_fault)
> @@ -1273,6 +1273,45 @@ xfs_dax_fault(
>  	return ret;
>  }
>  
> +static vm_fault_t
> +xfs_dax_fault(

Oh, hey, you /did/ split the dax handling into two helpers.

Would you mind renaming this xfs_dax_read_fault since this doesn't
handle write faults?

With that changed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +	struct vm_fault		*vmf,
> +	unsigned int		order)
> +{
> +	struct xfs_inode	*ip = XFS_I(file_inode(vmf->vma->vm_file));
> +	unsigned int		lock_mode;
> +	vm_fault_t		ret;
> +
> +	lock_mode = xfs_ilock_for_write_fault(ip);
> +	ret = xfs_dax_fault_locked(vmf, order, false);
> +	xfs_iunlock(ip, lock_mode);
> +
> +	return ret;
> +}
> +
> +static vm_fault_t
> +xfs_write_fault(
> +	struct vm_fault		*vmf,
> +	unsigned int		order)
> +{
> +	struct inode		*inode = file_inode(vmf->vma->vm_file);
> +	unsigned int		lock_mode;
> +	vm_fault_t		ret;
> +
> +	sb_start_pagefault(inode->i_sb);
> +	file_update_time(vmf->vma->vm_file);
> +
> +	lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));
> +	if (IS_DAX(inode))
> +		ret = xfs_dax_fault_locked(vmf, order, true);
> +	else
> +		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
> +	xfs_iunlock(XFS_I(inode), lock_mode);
> +
> +	sb_end_pagefault(inode->i_sb);
> +	return ret;
> +}
> +
>  /*
>   * Locking for serialisation of IO during page faults. This results in a lock
>   * ordering of:
> @@ -1290,34 +1329,14 @@ __xfs_filemap_fault(
>  	bool			write_fault)
>  {
>  	struct inode		*inode = file_inode(vmf->vma->vm_file);
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	vm_fault_t		ret;
> -	unsigned int		lock_mode = 0;
>  
> -	trace_xfs_filemap_fault(ip, order, write_fault);
> -
> -	if (write_fault) {
> -		sb_start_pagefault(inode->i_sb);
> -		file_update_time(vmf->vma->vm_file);
> -	}
> -
> -	if (IS_DAX(inode) || write_fault)
> -		lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));
> -
> -	if (IS_DAX(inode)) {
> -		ret = xfs_dax_fault(vmf, order, write_fault);
> -	} else if (write_fault) {
> -		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
> -	} else {
> -		ret = filemap_fault(vmf);
> -	}
> -
> -	if (lock_mode)
> -		xfs_iunlock(XFS_I(inode), lock_mode);
> +	trace_xfs_filemap_fault(XFS_I(inode), order, write_fault);
>  
>  	if (write_fault)
> -		sb_end_pagefault(inode->i_sb);
> -	return ret;
> +		return xfs_write_fault(vmf, order);
> +	if (IS_DAX(inode))
> +		return xfs_dax_fault(vmf, order);
> +	return filemap_fault(vmf);
>  }
>  
>  static inline bool
> -- 
> 2.43.0
> 
> 
