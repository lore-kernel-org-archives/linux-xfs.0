Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E18802
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730217473; cv=none; b=Bf/DEVfyJmwHrdRDni/n/iEdcNJJUgV0xSmzlu1DTw/ByIxIDiXo+NkS0iPDylS1bZRDMm6znOozOybEXLmVz7VOFke67BJuymEc1k3clEBZ8bzQUcx7pegqqErxTIRvrME8T29l2C1udVtjzUxdi/BMUBkNtSjv/yXYU+vEtmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730217473; c=relaxed/simple;
	bh=75vnSLGLA2kpyHOKQxoOags/S1dhTyVFkModsnwLflQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Om5fo4nuaJ6aeopZ3v0OtXn3Rw+4CwZHx82TD2cQV9Zn7q60TlN52C0amkdD8Jl+n7F7PFZ+Ke3SGDTCBWJ/amOpY66LPl5WopkwmZhyE0FjoOYFPkGOkFCU3rVhD0hzmREA6rLOjk7r3+4fYe2P3m/h8YELhP4BXuMJl+uDxA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uQ5PL8SY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uQ5PL8SY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE51C4CECD;
	Tue, 29 Oct 2024 15:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730217472;
	bh=75vnSLGLA2kpyHOKQxoOags/S1dhTyVFkModsnwLflQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uQ5PL8SYejn53je1dvbRxLZcIuKQO1jJ2SHdEBc6sG//Q9cDuMuojZoE/CpghpFN5
	 UfXJ0z1zEn+4ZqAtcsVwAoIyU1J7ZeWPpw70LCebC/8QNXjiQOQrl6tjitCFaUeXcZ
	 VZ0xHSa0Qp4bqd4WHIYCxPSYphT0IgS7MWs7E6Rgj+1/pOiQhN5onKSXLRdLCwlY6K
	 mRDyp9IiT8Y3qae2tA/haUEb4Kw31LbiCgNkZ/sWwr0ZBSdb/JLWVo+LbTa2qS9Nnx
	 CBrRHMsNVq9LH1YI9VOaGolWvaM3ZKxd03TGdcXGY+TfLFxi7+nkLUVMu9hzeM1WOU
	 kLHvZTpMgA23g==
Date: Tue, 29 Oct 2024 08:57:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: split write fault handling out of
 __xfs_filemap_fault
Message-ID: <20241029155752.GW2386201@frogsfrogsfrogs>
References: <20241029151214.255015-1-hch@lst.de>
 <20241029151214.255015-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029151214.255015-3-hch@lst.de>

On Tue, Oct 29, 2024 at 04:11:58PM +0100, Christoph Hellwig wrote:
> Only two of the callers of __xfs_filemap_fault every handle read faults.
> Split the write_fault handling out of __xfs_filemap_fault so that all
> callers call that directly either conditionally or unconditionally and
> only leave the read fault handling in __xfs_filemap_fault.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This seems pretty straightforward so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c | 41 +++++++++++++++++++----------------------
>  1 file changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 20f7f92b8867..0b8e36f8703c 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1434,6 +1434,16 @@ xfs_dax_read_fault(
>  	return ret;
>  }
>  
> +/*
> + * Locking for serialisation of IO during page faults. This results in a lock
> + * ordering of:
> + *
> + * mmap_lock (MM)
> + *   sb_start_pagefault(vfs, freeze)
> + *     invalidate_lock (vfs/XFS_MMAPLOCK - truncate serialisation)
> + *       page_lock (MM)
> + *         i_lock (XFS - extent map serialisation)
> + */
>  static vm_fault_t
>  xfs_write_fault(
>  	struct vm_fault		*vmf,
> @@ -1471,26 +1481,13 @@ xfs_write_fault(
>  	return ret;
>  }
>  
> -/*
> - * Locking for serialisation of IO during page faults. This results in a lock
> - * ordering of:
> - *
> - * mmap_lock (MM)
> - *   sb_start_pagefault(vfs, freeze)
> - *     invalidate_lock (vfs/XFS_MMAPLOCK - truncate serialisation)
> - *       page_lock (MM)
> - *         i_lock (XFS - extent map serialisation)
> - */
>  static vm_fault_t
>  __xfs_filemap_fault(
>  	struct vm_fault		*vmf,
> -	unsigned int		order,
> -	bool			write_fault)
> +	unsigned int		order)
>  {
>  	struct inode		*inode = file_inode(vmf->vma->vm_file);
>  
> -	if (write_fault)
> -		return xfs_write_fault(vmf, order);
>  	if (IS_DAX(inode))
>  		return xfs_dax_read_fault(vmf, order);
>  
> @@ -1511,9 +1508,9 @@ xfs_filemap_fault(
>  	struct vm_fault		*vmf)
>  {
>  	/* DAX can shortcut the normal fault path on write faults! */
> -	return __xfs_filemap_fault(vmf, 0,
> -			IS_DAX(file_inode(vmf->vma->vm_file)) &&
> -			xfs_is_write_fault(vmf));
> +	if (IS_DAX(file_inode(vmf->vma->vm_file)) && xfs_is_write_fault(vmf))
> +		return xfs_write_fault(vmf, 0);
> +	return __xfs_filemap_fault(vmf, 0);
>  }
>  
>  static vm_fault_t
> @@ -1525,15 +1522,16 @@ xfs_filemap_huge_fault(
>  		return VM_FAULT_FALLBACK;
>  
>  	/* DAX can shortcut the normal fault path on write faults! */
> -	return __xfs_filemap_fault(vmf, order,
> -			xfs_is_write_fault(vmf));
> +	if (xfs_is_write_fault(vmf))
> +		return xfs_write_fault(vmf, order);
> +	return __xfs_filemap_fault(vmf, order);
>  }
>  
>  static vm_fault_t
>  xfs_filemap_page_mkwrite(
>  	struct vm_fault		*vmf)
>  {
> -	return __xfs_filemap_fault(vmf, 0, true);
> +	return xfs_write_fault(vmf, 0);
>  }
>  
>  /*
> @@ -1545,8 +1543,7 @@ static vm_fault_t
>  xfs_filemap_pfn_mkwrite(
>  	struct vm_fault		*vmf)
>  {
> -
> -	return __xfs_filemap_fault(vmf, 0, true);
> +	return xfs_write_fault(vmf, 0);
>  }
>  
>  static const struct vm_operations_struct xfs_file_vm_ops = {
> -- 
> 2.45.2
> 
> 
