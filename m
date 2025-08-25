Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8F82FD7D5
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 15:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756135778; cv=none; b=oVlfRSeOM/ExthupDMBr1MuWAv9BCgVxjM2Z5TyRZCAMoslZIjKbFBv6iabRM2o9tC/PfYdd6UhRnkI/UNRhRijPaqJJLtWoyx67TOVX7X6K8KDPNW7mU9HV4+iqHo0ynfyOcPBKDrS57oMJjNElA8LlQ1SQljmmQYSi9AyiOe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756135778; c=relaxed/simple;
	bh=qs/qm3prXMEShFI0lzbwyxI6rZ/LJnP1xe/AQNmiHQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nuVKLesWLgoeZJOKW8vft4OSz8wU8vYwv2klJlVeJ3frW8tStJiRxo97F0LpB9MS4LenxR0Zi3bgLeDHASjaFnJ254gaSNQZXMiMZm8Lmo38GRRKQWA28ZQb/NGhL1FSgTlmUP//pCuF/RuLLzfi1Z5H4wrxSgiwxrBf4NqgKMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PoNBwbDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PoNBwbDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1702C4CEED;
	Mon, 25 Aug 2025 15:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756135777;
	bh=qs/qm3prXMEShFI0lzbwyxI6rZ/LJnP1xe/AQNmiHQk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PoNBwbDYSCHc7Woac0CD9s0h0qvWZEt/jHGe2cxzkzkZbVn05TG3G+ta39s/j5u7c
	 SbFpppAk3czfCbt12RnRaC3CGOBOU3TCLw6XLTE/gUb8gavTlu8ZLDBbAJsDt774zW
	 lqC8oLF12OqM85JtSWGFyZ8ZF80crhRyZ/JdMwxD88sk7rZ7DKcgAob3duTASr/ySu
	 NiMyreZnz8YDxFt67THcqX867gvkKPCCHv1uj33pwDMtYQgttz4zHuZXHQRRP9TbO/
	 bpAh3Kw7pI9Cgm6wD3foN2PEu8k1TNcvKRbq7xbjyebljALlPucfMUQwrqUoOuELbs
	 7hOVZwuzyaoFA==
Date: Mon, 25 Aug 2025 08:29:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: implement XFS_IOC_DIOINFO in terms of vfs_getattr
Message-ID: <20250825152936.GB812310@frogsfrogsfrogs>
References: <20250825111510.457731-1-hch@lst.de>
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
> +		 * posix_memalign, which fails for values that are smaller than
> +		 * the pointer size.  Round up the value to not break userspace.

Looks ok, don't care much if you say "userspace" or "userspace
programs".
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

>  		 */
> -		if (xfs_is_cow_inode(ip))
> -			da.d_miniosz = xfs_inode_alloc_unitsize(ip);
> -		else
> -			da.d_miniosz = target->bt_logical_sectorsize;
> +		da.d_mem = roundup(st.dio_mem_align, sizeof(void *));

...though one thing I /do/ wonder is whether this roundup() should be in
the vfs statx code?  Do people need to be able to initiate directio with
buffers that are not aligned even to pointer size?

--D

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
