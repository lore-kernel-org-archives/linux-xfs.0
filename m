Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D30E111A8
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 20:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755550046; cv=none; b=mFDO7iHuohczUe8sNIDR4MWI2QWoPoTLB5HLNm6+pWbxKxrC6cgp3f0Jzbi0ijoeq4fbfC8by8aLhxsytOm5tu4XqQRnKRCH5xgxedkXfOD3jZt0Qck8E6rHzMGkNZUmtj6gK8YitsLupOdwxIS9O8UyHLsJuBYZEJ6oQdEipCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755550046; c=relaxed/simple;
	bh=8f1cdgBzLXJF9VVQrZMkFSePzmOHVhsct4bhN0jrYes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZdeQb9dzkkeiNFobS3QT7yg9043hrj/aNmu8852r42UQTvfiS51Tyv60SvV/lQ/db+UwHq1iYUFdU3O58TQAwKK37vjoDk7JXKJ+hi5ovI+zLmn3QJA0ngT1zZFOC59ZWRB3L8EEjC4lMuEZ4LlBMGGDUrkn05SzW+zK7Vkq21k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FOkP947e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FOkP947e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDBBC4CEEB;
	Mon, 18 Aug 2025 20:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755550046;
	bh=8f1cdgBzLXJF9VVQrZMkFSePzmOHVhsct4bhN0jrYes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FOkP947e83qzhvnrVOHWz9jfHvn39I+PwoIDHp4z2j+jqtG8cUdQDGQrFHR13ULl4
	 8QX5G3Em11KsnSpduZOJ7RZAZ0z3cB8Q4Nzm45YxXE1DeiWMCcZXLsGaGKR6eUPMs2
	 mzNcayoLtwRYyJqsI79k3baWD+raq9dUynb2foikjCzRYfpI0Wl2zr0RVT3GfLTxHP
	 QeSB4J7dApuBFk0jY+SryAOoIp7E0gWsgzSby0MtKUcE2sb2pcL+gy2eleAb+WBESy
	 gn/fee2nvKV6ad3Nsc/LggrrnGiuCDqOLo0Egl019/MvfzG/OCF53sc+Ff0m78cNpr
	 YnFfyEiW/sxDQ==
Date: Mon, 18 Aug 2025 13:47:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: implement XFS_IOC_DIOINFO in terms of vfs_getattr
Message-ID: <20250818204725.GX7965@frogsfrogsfrogs>
References: <20250818051348.1486572-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818051348.1486572-1-hch@lst.de>

On Mon, Aug 18, 2025 at 07:13:43AM +0200, Christoph Hellwig wrote:
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
>  fs/xfs/xfs_ioctl.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index e1051a530a50..21ae68896caa 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1209,21 +1209,24 @@ xfs_file_ioctl(
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
> +		 * The randholes tool in xfstests expects the alignment to not
> +		 * be smaller than the size of a pointer for whatever reason.

Userspace is grossssss

But I do see the value in not having two implementations of the directio
geometry gathering since we already had bugs wrt that vs. statx.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +		 *
> +		 * Align the report value to that so that the dword (4 byte)
> +		 * alignment supported by many storage devices doesn't trip it
> +		 * up.
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
> -- 
> 2.47.2
> 
> 
