Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1742A3234
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 16:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730217649; cv=none; b=jLBEB8a9s8dif8Mdcr1d5pqL5Ihxwlu9XWaVP+K7mogavklwQPwbVd2NgiEWBgiINY7L3rh4+COYKn/JRrmFCFSfHiLfuqykssyP5bRxbHaPwIy3apDk/RJD9SgPREct9iALPWJWkz9gkknFBc4Kdb9bF3F6diai4gdo8RQXLRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730217649; c=relaxed/simple;
	bh=ff3Wh9o7zgaGnjKjG2JfqW4PBIo2k9YE3lhnuoNM76Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=boDxAvH3RBqyHv461bSDaPhu0vCniKTiUCqyVZD3wYOhl+zRm7JO5A7gW+D7TGdHwF0BblUBJQZjO39K+Y74Y0CKQCkIu1KlG/cdgo1lOelikJBtvZPJTbVEDd+BJ0sD3/5VgombSBSkzbt3VHZNyyp2EVXMuwhcXi+VnoeNLjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XS6aRjvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XS6aRjvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDFDC4CECD;
	Tue, 29 Oct 2024 16:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730217648;
	bh=ff3Wh9o7zgaGnjKjG2JfqW4PBIo2k9YE3lhnuoNM76Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XS6aRjvBxJj87O31M+pFox+3IzLOSrvOolD4R4uygYQxnm4Q/78jfcslpLS4N406Z
	 NOFs4TGkyKZPEFXz9DepOxQvIh5Lw/8/4cBJ6RS9eQrjNoPaFpv19FcbAMZdy5nZan
	 eNvD9WYooh0JGjR27tGwjIBMZ6GmmeDHBBqnVCqnHRv5l3DXU9dR+JuSakUSf7sDkv
	 Aty+wGIlol46RW8kzcxko4cSJBvnt4USZolSBteNYHAKJffcORivAdc1grBR8Swy41
	 CicHYN8xeVCQz7jYTqxp/dy5HBf1D4QgVNz8M5zO6LZJeEKwgjPUAoaH657u3aqF02
	 Ip3Os0XfqaHoA==
Date: Tue, 29 Oct 2024 09:00:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: remove __xfs_filemap_fault
Message-ID: <20241029160048.GX2386201@frogsfrogsfrogs>
References: <20241029151214.255015-1-hch@lst.de>
 <20241029151214.255015-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029151214.255015-4-hch@lst.de>

On Tue, Oct 29, 2024 at 04:11:59PM +0100, Christoph Hellwig wrote:
> xfs_filemap_huge_fault only ever serves DAX faults, so hard code the
> call to xfs_dax_read_fault and open code __xfs_filemap_fault in the
> only remaining caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c | 29 +++++++++++------------------
>  1 file changed, 11 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 0b8e36f8703c..7464d874e766 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1481,20 +1481,6 @@ xfs_write_fault(
>  	return ret;
>  }
>  
> -static vm_fault_t
> -__xfs_filemap_fault(
> -	struct vm_fault		*vmf,
> -	unsigned int		order)
> -{
> -	struct inode		*inode = file_inode(vmf->vma->vm_file);
> -
> -	if (IS_DAX(inode))
> -		return xfs_dax_read_fault(vmf, order);
> -
> -	trace_xfs_read_fault(XFS_I(inode), order);
> -	return filemap_fault(vmf);
> -}
> -
>  static inline bool
>  xfs_is_write_fault(
>  	struct vm_fault		*vmf)
> @@ -1507,10 +1493,17 @@ static vm_fault_t
>  xfs_filemap_fault(
>  	struct vm_fault		*vmf)
>  {
> +	struct inode		*inode = file_inode(vmf->vma->vm_file);
> +
>  	/* DAX can shortcut the normal fault path on write faults! */
> -	if (IS_DAX(file_inode(vmf->vma->vm_file)) && xfs_is_write_fault(vmf))
> -		return xfs_write_fault(vmf, 0);
> -	return __xfs_filemap_fault(vmf, 0);
> +	if (IS_DAX(inode)) {
> +		if (xfs_is_write_fault(vmf))
> +			return xfs_write_fault(vmf, 0);
> +		return xfs_dax_read_fault(vmf, 0);
> +	}
> +
> +	trace_xfs_read_fault(XFS_I(inode), 0);
> +	return filemap_fault(vmf);
>  }
>  
>  static vm_fault_t
> @@ -1524,7 +1517,7 @@ xfs_filemap_huge_fault(
>  	/* DAX can shortcut the normal fault path on write faults! */
>  	if (xfs_is_write_fault(vmf))
>  		return xfs_write_fault(vmf, order);
> -	return __xfs_filemap_fault(vmf, order);
> +	return xfs_dax_read_fault(vmf, order);
>  }
>  
>  static vm_fault_t
> -- 
> 2.45.2
> 
> 
