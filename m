Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44751A937
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 00:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773187978; cv=none; b=BPafTQRNAV967p3hCRyiNQSwzYCP6AaCZZ5h/IG7blOe0OAxT5bkrKvgAF3Wg4kKPSzLfLdRNIAMX34Yn3HboX6a0+ArLkWoimlznbQQ7IEqlGprcFiYhdisHBCkqZH+FtXSmxQvLg2cPgxd0TaAyiPyEhOYNOBFAdKpMZE8iDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773187978; c=relaxed/simple;
	bh=ezZ99ANDtvimmqy+xCsz5vgyaQ8mTPfdCH2z3ROBBnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lF58COaC34DxNGsOQtwbv+fZHw3+FkCyp90EH17Q2T117dxwmoRggJnTtpSbSSoN3BZsTZK/DNrjo2a11YjIVrwagtfFH9qZX9pA2+mlc28kjc+fYVJb7xKrdPeHVgm6xLGeL1joFWGZY2mFm/Rzu7opYSH+gRTiO4XY6aEIU0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/Wyyt7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/Wyyt7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6248C19423;
	Wed, 11 Mar 2026 00:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773187977;
	bh=ezZ99ANDtvimmqy+xCsz5vgyaQ8mTPfdCH2z3ROBBnQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T/Wyyt7wgjG1yUk0blFBLo5OXkaWY4Iz/Ggj3y1hG9/hrxVZ5cey6oXdS2D2hEjSc
	 756rP2pr5rWgjIDMNGXN6MKwUyGyXpSKU2OotqQ+iSSe9YoB5Rjg8SZ4/YJLDLbRVd
	 8bRGS3JD07DHBaqr9QmGP5BJ+NXNn0ks8NWq5F783VqZ576dfokyhf176+KizmHyul
	 oQrLSuLeUI9jcIlu9wFrspAIfVfslNt9qgS/HwQWb3xzWqfKeBcl3Y/m4VZLRGjwzW
	 CJBEPCpj+bA+A5HU5esi6C+cLaKoGj1bNpiHvZweCdRR2Ri6+F+chSRKGFI/XmXRmC
	 O3HfWhka/myyQ==
Date: Wed, 11 Mar 2026 11:12:52 +1100
From: Dave Chinner <dgc@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@infradead.org,
	djwong@kernel.org, p.raghav@samsung.com
Subject: Re: [PATCH v11 2/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <abCzhDSVmFx4PtWI@dread>
References: <20260309181235.428151-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309181235.428151-2-lukas@herbolt.com>

On Mon, Mar 09, 2026 at 07:12:36PM +0100, Lukas Herbolt wrote:
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device
> enable the unmap write zeroes operation.
> 
> Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> 
> ---
>  v11 changes:
> 	- split into 2 patches separating the bmapi_flags addition
> 	- 2 step allocation, to avoid zeroing beyond EOF
> 
>  fs/xfs/xfs_file.c | 41 +++++++++++++++++++++++++++++------------
>  1 file changed, 29 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index fd049a1fc9c6..f8c1611e3267 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1293,29 +1293,45 @@ xfs_falloc_zero_range(
>  	unsigned int		blksize = i_blocksize(inode);
>  	loff_t			new_size = 0;
>  	int			error;
> +	bool                    need_convert = false;
>  
>  	trace_xfs_zero_file_space(ip);
>  
> +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> +		if (xfs_is_always_cow_inode(ip) ||
> +		    !bdev_write_zeroes_unmap_sectors(
> +			    xfs_inode_buftarg(ip)->bt_bdev))
> +			return -EOPNOTSUPP;
> +		need_convert = true;
> +	}
> +
>  	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
>  	if (error)
>  		return error;
>  
>  	if (xfs_falloc_force_zero(ip, ac)) {
>  		error = xfs_zero_range(ip, offset, len, ac, NULL);
> -	} else {
> -		error = xfs_free_file_space(ip, offset, len, ac);
> -		if (error)
> -			return error;
> -
> -		len = round_up(offset + len, blksize) -
> -			round_down(offset, blksize);
> -		offset = round_down(offset, blksize);
> -		error = xfs_alloc_file_space(ip, offset, len,
> -				XFS_BMAPI_PREALLOC);
> +		goto set_filesize;
>  	}
> +	error = xfs_free_file_space(ip, offset, len, ac);
>  	if (error)
>  		return error;
> -	return xfs_falloc_setsize(file, new_size);
> +
> +	len = round_up(offset + len, blksize) - round_down(offset, blksize);
> +	offset = round_down(offset, blksize);
> +	error = xfs_alloc_file_space(ip, offset, len, XFS_BMAPI_PREALLOC);

xfs_alloc_file_space() already rounds the offset down and the range
end upwards to block size boundaries (XFS_B_TO_FSBT() rounds down,
XFS_B_TO_FSB rounds up). There is no need to do it here.

> +
> +set_filesize:
> +	if (error)
> +		return error;
> +
> +	error = xfs_falloc_setsize(file, new_size);
> +	if (error)
> +		return error;
> +	if (need_convert)
> +		error = xfs_alloc_file_space(ip, offset, len,
> +				XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
> +	return error;

Honestly, this "prealloc, set file size, then convert and zero" thing
seems a bit ... clunky. 

I mean, this is trying to work around an issue with
xfs_falloc_setsize() operating on written extents beyond EOF to set
EOF. But why are we even using a generic truncate operation to set
the EOF when we have already done most of the complex truncate work
(exclusion, page cache invalidation, extent removal, etc) already?

My logic:

xfs_bmapi_write(off, len, XFS_BMAPI_ZERO) will allocate all the
holes and delalloc extents over the given range as written extents
that are initialised to contain zeroes.

xfs_bmapi_write(off, len, XFS_BMAPI_CONVERT) will convert all the
unwritten extents over a given range to written extents, but will
not touch the data in those extents.

xfs_bmapi_write(off, len, XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO) will
allocate holes and delalloc extents and convert unwritten extents
all to written extents, and it will write zeros to all of those
extents.

This latter case is exactly what we want, and if gives us zeroes on
disk to the end of the extent beyond the new EOF. i.e. we've
completed all the data IO, and so now all we need
to do is update the file size transactionally, just like we do in
IO completion.

Indeed, xfs_iomap_write_unwritten() integrates this size update
into post-IO unwritten extent conversion. i.e we already have code
that does exactly what we need, except for tweaking the
xfs_bmapi_write() flags for the zeroing behaviour we need.

So, a helper function in fs/xfs/xfs_bmap_util.c such as this:

/*
 * This function is used to allocate written extents over holes
 * and/or convert unwritten extents to written extents based on the
 * @flags passed to it.
 *
 * If @flags is zero, if will allocate written extents for holes and
 * delalloc extents across the range.
 *
 * If XFS_BMAPI_CONVERT is specified in @flags, then it will also do
 * conversion of unwritten extents in the range to written extents.
 *
 * If XFS_BMAPI_ZERO is specified in @flags, then both newly
 * allocated extents and converted unwritten extents will be
 * initialised to contain zeroes.
 *
 * If @update_isize is true, then if the range we are operating on
 * extends beyond the current EOF, extend i_size to offset+len
 * incrementally as extents in the range are allocated/converted.
 */
int
xfs_bmap_alloc_or_convert_range(
	struct xfs_inode	*ip,
	xfs_off_t		offset,
	xfs_off_t		len,
	uint32_t		flags,
	bool			update_isize)
{
	< guts of xfs_iomap_write_unwritten >
}

Then xfs_iomap_write_unwritten() can be factored to a one-liner
(or replaced altogether), and this new fallocate op pretty much
becomes:

	error = xfs_bmap_alloc_or_convert_range(ip, offset, len,
			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO,
			new_size ? true : false);

The name of the function sucks but I can't think of anything better,
so if you've got a better idea then change it. :)

-Dave.
-- 
Dave Chinner
dgc@kernel.org
