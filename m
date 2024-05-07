Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA63785954;
	Tue,  7 May 2024 23:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715124821; cv=none; b=pjVcWSFTuKCuQPIHd0V3a6Oj1MOYXIxngAwG/m32HbmvwCKJ7Kt5xR4OaBbSXnN8gDnvGUckpcsQdEQFBH20MthCQB8lGhzLPpV7Q8WcsfM2OdEb6s8zlo4ZKpNl+JIzb6r6LzLrMRuICMvsq4attK0RBWnuPlH6x9W/x/z5Spg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715124821; c=relaxed/simple;
	bh=PclPuy1ZqHey3h95txPW76r0ZRBiORIW7rQ8fV8cKq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pba67XTh1QgGg/kG0txqawNpLLkjigQj5WnIM+QTjOcDtRd8cGCJh9CeVDaPz0spNkFPDoBJlnm+xlZaRbfG575RKN+BWTpMfi6JVSBRdTFFDLIlLfyOZ3nXzRqEj8mv/4jMd3NcF0ZfoC5ho2n630qeozWF5++QBKdLMm6w9NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iy9+eVeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iy9+eVeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69685C2BBFC;
	Tue,  7 May 2024 23:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715124820;
	bh=PclPuy1ZqHey3h95txPW76r0ZRBiORIW7rQ8fV8cKq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Iy9+eVeAx1Bycgiv30bsEt7gyMfNeBX/yunTmm9lmprmh2zVaIyVuH/FM3+bDhrqy
	 ve8JjpyYLJEay1yibV4sOUdwd+5qB5uALBoYLtx7Dw3Z/Z+Qz2PMg0hKWkhq5RndJA
	 coh6PFzJYoM3vRb8GQoVPIVE9ldjfS1HKilhlWUid78WoHVchRlB1iVfMc9Cc7ZgEn
	 Zt8dVcUJ0V1C7+AJ9Six6wGuFM1Y/sd04mD2LmW4oicDAo+JVlEO/GpLrEkXZUdDos
	 VTA5UsWp1+tCSOjcmUX47WDDZ8be86cn+CMvPo1Jb/XuKq1ug6xD0B4zUEj5uhv9Gx
	 koEO9nccC73dA==
Date: Tue, 7 May 2024 16:33:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: check for negatives in xfs_exchange_range_checks()
Message-ID: <20240507233339.GY360919@frogsfrogsfrogs>
References: <0e7def98-1479-4f3a-a69a-5f4d09e12fa8@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e7def98-1479-4f3a-a69a-5f4d09e12fa8@moroto.mountain>

On Sat, May 04, 2024 at 02:27:36PM +0300, Dan Carpenter wrote:
> The fxr->file1_offset and fxr->file2_offset variables come from the user
> in xfs_ioc_exchange_range().  They are size loff_t which is an s64.
> Check the they aren't negative.
> 
> Fixes: 9a64d9b3109d ("xfs: introduce new file range exchange ioctl")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> From static analysis.  Untested.  Sorry!

Not a fan of this        ^^^^^^^^

> 
>  fs/xfs/xfs_exchrange.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
> index c8a655c92c92..3465e152d928 100644
> --- a/fs/xfs/xfs_exchrange.c
> +++ b/fs/xfs/xfs_exchrange.c
> @@ -337,6 +337,9 @@ xfs_exchange_range_checks(
>  	if (IS_SWAPFILE(inode1) || IS_SWAPFILE(inode2))
>  		return -ETXTBSY;
>  
> +	if (fxr->file1_offset < 0 || fxr->file2_offset < 0)
> +		return -EINVAL;

but this looks right to me.

If you actually test your changes, then
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +
>  	size1 = i_size_read(inode1);
>  	size2 = i_size_read(inode2);
>  
> -- 
> 2.43.0
> 
> 
