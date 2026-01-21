Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B4133C51A
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 06:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768978613; cv=none; b=XpBjPneEywVwZUiEFMXhUnOPXBq8iIBgLewUBc5oJB3v1aSICs9oaugobOsvTMu82a3+dmoLfi9z4GKgGOx1VIQjNyJE6+tRfqyOlDqI0u43bvk0nZd9ZK6rVq9srhK4FJog6KbBGfJ5QJ6QJODhQZqC+ZNdQobPQgSf5/IzklU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768978613; c=relaxed/simple;
	bh=Z5katYakHwyP7uL8Arp4NgBYvQLFjnuG/aNrInfCbBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sP8HKFJ32ars2UbCSlqVkvW+ZjYs+uop7+2179Jht89vd9A3+4JNNfl5I1ZIC31/FnyUnEQOZc0Xr1CKnmg7FTiPcpu/ZyHkFyHkkhb2SZ3nFcrOGHW2sBXTruoh3NVTjU1nRezixp8xIptcywE270fswMMxfmd4PqBEkhON3lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 54E99227AAA; Wed, 21 Jan 2026 07:56:45 +0100 (CET)
Date: Wed, 21 Jan 2026 07:56:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org,
	lukas@herbolt.com
Subject: Re: [PATCH v7] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <20260121065645.GA11349@lst.de>
References: <20260120132056.534646-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120132056.534646-2-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 20, 2026 at 02:20:50PM +0100, cem@kernel.org wrote:
> From: Lukas Herbolt <lukas@herbolt.com>
> 
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> the unmap write zeroes operation.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> [cem: rewrite xfs_falloc_zero_range() bits]

Nit: once you modify something substantially and add your marker
you also need to sign off on it.

> ---
> 
> Christoph, Darrick, could you please review/ack this patch again? I
> needed to rewrite the xfs_falloc_zero_range() bits, because it
> conflicted with 66d78a11479c and 8dc15b7a6e59. This version aims mostly
> to remove one of the if-else nested levels to keep it a bit cleaner.

Maybe mention the "merge conflict" in the above note?

> index d36a9aafa8ab..b23f1373116e 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1302,16 +1302,29 @@ xfs_falloc_zero_range(
>  
>  	if (xfs_falloc_force_zero(ip, ac)) {
>  		error = xfs_zero_range(ip, offset, len, ac, NULL);
> +		goto out;
> +	}
>  
> +	error = xfs_free_file_space(ip, offset, len, ac);
> +	if (error)
> +		return error;
> +
> +	len = round_up(offset + len, blksize) - round_down(offset, blksize);
> +	offset = round_down(offset, blksize);
> +
> +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> +		if (xfs_is_always_cow_inode(ip) ||
> +		    !bdev_write_zeroes_unmap_sectors(
> +				xfs_inode_buftarg(ip)->bt_bdev))
> +			return -EOPNOTSUPP;
> +		error = xfs_alloc_file_space(ip, offset, len,
> +					     XFS_BMAPI_ZERO);

Darrick made a good point that we should check the not supported cases
earlier, even if that is an issue in the original version.  Also I don't
think we should hit the force zero case for FALLOC_FL_WRITE_ZEROES.
I.e., this should probably become something like:

	if (mode & FALLOC_FL_WRITE_ZEROES) {
		if (xfs_is_always_cow_inode(ip) ||
		    !bdev_write_zeroes_unmap_sectors(
				xfs_inode_buftarg(ip)->bt_bdev))
			return -EOPNOTSUPP;
		bmapi_flags = XFS_BMAPI_ZERO;
	} else {
	  	if (xfs_falloc_force_zero(ip, ac)) {
	  		error = xfs_zero_range(ip, offset, len, ac, NULL);
			goto set_filesize;
		}
		bmapi_flags = XFS_BMAPI_PREALLOC;
	}

	< free file space, round, etc.. >

	error = xfs_alloc_file_space(ip, offset, len, bmapi_flags);
