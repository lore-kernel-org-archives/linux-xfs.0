Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC22F1B29B8
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 18:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718909788; cv=none; b=I2LV9UFZwPqQCgxvTWwRxkbYZZ6y18ntnAz6OOLl7DpWoOr8Nm9zpqtGhsoF653ry+3zHAve+CL/PpdpoVCKPX+M8iJlFmyRwn4X8R7jxKEfEJ8oT2R+RZEz/66TWxHwhg3/lmyg7EH0g3z17KaAzRwJyKdKvjRp7Qls/KDUFvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718909788; c=relaxed/simple;
	bh=HYEtitCJ+jqRKagdM88/5WyrKPlSaeg5rTXEHoMKti0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LEqsjitWyVNfBZFdIu+E2L9DrX6ENU9/iBtr4JlL2WcMx89sMXgz4l3qxvRI+cS0Ntf126S8jlFEGDaBOSiB8/Qct3k1KzpOtrKPk61jxBIBsHqmyAkX9CLxlTqec155gXK3NxLpVudRq1WrOfeA3FnjZ8dbCx1exoNZ2kX/qlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D88CvPA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D88CvPA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D822C4AF0E;
	Thu, 20 Jun 2024 18:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718909788;
	bh=HYEtitCJ+jqRKagdM88/5WyrKPlSaeg5rTXEHoMKti0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D88CvPA3+Nc4AucKzIOsUTt9jJ2SkdEMv+NkSd+KHNCG20ZIBuY3Tqp/gOjRfCoQZ
	 /iHv1+UnT1oXuNHL3B4CW4erRui7bFB5XB95evWCkVifjUHvtTXATi853XbwxnA9+Y
	 jwNznzT8FhKMh3SWX8IsAPDTg7AWrVUK55HZXO62k43xxw0LHRKTx8HSl4wl2CedV8
	 Gvgk+xUuBTL9JfPrOe/2aDOb9Qxho9xqKA+jFe5/uV6AsLM8OegwnV0RVRcbrqykg/
	 IQ3cX+7dYEYzxbrGD2TWUGLhY65+Ap27rwHDeAO6DMcI/C08WIldZJfZCW9WX+B2Z6
	 DRvSILKR2TKsQ==
Date: Thu, 20 Jun 2024 11:56:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: always take XFS_MMAPLOCK shared in xfs_dax_fault
Message-ID: <20240620185627.GC103034@frogsfrogsfrogs>
References: <20240619115426.332708-1-hch@lst.de>
 <20240619115426.332708-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619115426.332708-6-hch@lst.de>

On Wed, Jun 19, 2024 at 01:53:55PM +0200, Christoph Hellwig wrote:
> After the previous refactoring, xfs_dax_fault is now never used for write
> faults, so don't bother with the xfs_ilock_for_write_fault logic to
> protect against writes when remapping is in progress.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense to me, all we need to do here is make sure that nobody can
invalidate the mappings -- there's no need to take MMAPLOCK_EXCL if a
reflink is cloning from this file's data.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 51e50afd935895..62a69ed796f2fd 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1279,12 +1279,11 @@ xfs_dax_fault(
>  	unsigned int		order)
>  {
>  	struct xfs_inode	*ip = XFS_I(file_inode(vmf->vma->vm_file));
> -	unsigned int		lock_mode;
>  	vm_fault_t		ret;
>  
> -	lock_mode = xfs_ilock_for_write_fault(ip);
> +	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
>  	ret = xfs_dax_fault_locked(vmf, order, false);
> -	xfs_iunlock(ip, lock_mode);
> +	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
>  
>  	return ret;
>  }
> -- 
> 2.43.0
> 
> 
