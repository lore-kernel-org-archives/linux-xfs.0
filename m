Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841EF194C75
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 11:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756121547; cv=none; b=LnShXVSQnVcBlgcaU36OgKj8Uoale5w+MJBCDKg8xFpsJ1PGMYENx4aHFwRgVDC0z9p84c1O5ONDttsZnvRjeqVexbyu952XgffeHS/S+NnwKmUBb6UM+BTNIiXvZniyS442ZOMX6m/XQY0IlcohRMlZTnfDaW1DloUgd2gaKUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756121547; c=relaxed/simple;
	bh=N1ln4LIJNK38UPIBUpPE+8dYyNABZxNd6HXYFoDsPGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UK6WND31+xL057xlmCKQ4y/+YJ15EdHca4w0MpDwgcXrzVQMxU1rhdO7Kr40b7E5s7Ul1QLiEbTB8RVtTO814A940vSx8uuKPAv2B6eKPUgohDDmVtgpPRdsj1OcsFkBFJcYpg7crjbQlKtKDZR+j/T0uBCY9+RKoQErO1C3BDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPz9AoIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPz9AoIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323C2C4CEED;
	Mon, 25 Aug 2025 11:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756121547;
	bh=N1ln4LIJNK38UPIBUpPE+8dYyNABZxNd6HXYFoDsPGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aPz9AoIRzbUpTdHsoPkud0ht/YHthY6vnilaQV7bYJ4ZMhbEAyw9WhYj1CXgEG1n+
	 0900ipkqLPIOnSK10FTrBXzkleDBEcPQuvQ7OtVN3WzCrGKWffOofgr5ChB9GPl5vR
	 O+6aTGLVbDgPvNpoQBJo5VhzzVw2MzNu5EYzU4iq3sW6YbNPesxLJGJNmFHQD8jJL7
	 xDPAYOM0VQ6rAlp22dx90cXNSHqscOzi7OYPq1G/R1WQ9ezQFQ4ftfRxTiWlbfysv4
	 BxzK9UC3ZniLsLYgf19prgnp92zUMIzbKEvopE8Yyy9CFx2deMEhJKNboem4J8bl8v
	 kGDIIt5Oz9MBg==
Date: Mon, 25 Aug 2025 13:32:23 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: implement XFS_IOC_DIOINFO in terms of vfs_getattr
Message-ID: <fhpfunzcfllg2k7qslumh3n3vsac3h3aaq7k4l6vxcxhdqmeqv@3rb266uid7bx>
References: <cG84V92R_rvXt_xDUKDRAZU_E6E69atqXw04uiv_deBLGkFtMFj_XYvumw4sZh6EOFZpn33yItQ55aPJs5hNNw==@protonmail.internalid>
 <20250825111510.457731-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825111510.457731-1-hch@lst.de>

On Mon, Aug 25, 2025 at 01:15:00PM +0200, Christoph Hellwig wrote:
> Use the direct I/O alignment reporting from ->getattr instead of
> reimplementing it.  This exposes the relaxation of the memory
> alignment in the XFS_IOC_DIOINFO info and ensure the information will
> stay in sync.  Note that randholes.c in xfstests has a bug where it
> incorrectly fails when the required memory alignment is smaller than the
> pointer size.  Round up the reported value as there is a fair chance that
> this code got copied into various applications.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> Changes since v1:
>  - update the comment
> 
>  fs/xfs/xfs_ioctl.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index e1051a530a50..ff0a8dc74948 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1209,21 +1209,21 @@ xfs_file_ioctl(
>  				current->comm);
>  		return -ENOTTY;
>  	case XFS_IOC_DIOINFO: {
> -		struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
> +		struct kstat		st;
>  		struct dioattr		da;
> 
> -		da.d_mem = target->bt_logical_sectorsize;
> +		error = vfs_getattr(&filp->f_path, &st, STATX_DIOALIGN, 0);
> +		if (error)
> +			return error;
> 
>  		/*
> -		 * See xfs_report_dioalign() for an explanation about why this
> -		 * reports a value larger than the sector size for COW inodes.
> +		 * Some userspace directly feeds the return value to

		Some userspace /tools/ directly... ?

		I could fix this at commit time if this is the only
		change

> +		 * posix_memalign, which fails for values that are smaller than
> +		 * the pointer size.  Round up the value to not break userspace.
>  		 */
> -		if (xfs_is_cow_inode(ip))
> -			da.d_miniosz = xfs_inode_alloc_unitsize(ip);
> -		else
> -			da.d_miniosz = target->bt_logical_sectorsize;
> +		da.d_mem = roundup(st.dio_mem_align, sizeof(void *));
> +		da.d_miniosz = st.dio_offset_align;
>  		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
> -
>  		if (copy_to_user(arg, &da, sizeof(da)))
>  			return -EFAULT;
>  		return 0;

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> --
> 2.47.2
> 
