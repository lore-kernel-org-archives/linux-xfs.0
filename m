Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357031C68E
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 17:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708708919; cv=none; b=D2/4QJwHr3cp0e1mjZqZLkqhGXfq0mnh+XS0BnnkrwGEx/AfodwPAhyvYcsPB4zPLU7bt9BxgXZ516sCe7Ox57rVIKBxz8DjkGAEfpKZ6ReG1QEo+C+RV2AegksICttibxYeGr0yH3WyF37mFvj8/IKn0A418IDkciUxCae15IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708708919; c=relaxed/simple;
	bh=enTW9JCWwcAZO4m4nVoxpi8gcFbbvMXZ2NthHeCIQqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQS+vr0iAuOS8UlAMhMz8E7cqTV3WOWtr1/b5UE3CT2hcqM3THvncXY9cZmVmK0Ny83IqYT11pOulbZk/SpYWpcbN9wevWeUW6P7xpO2XNceFkf0mpxUq3S7AR5absWn6UVvF7A0Hqpp+r6nT5mbvMF9fqRZMfigH7NQpqqL5uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rXv8Gdqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rXv8Gdqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E9BC433C7;
	Fri, 23 Feb 2024 17:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708708918;
	bh=enTW9JCWwcAZO4m4nVoxpi8gcFbbvMXZ2NthHeCIQqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rXv8GdqhotjWQBYPNMQuWM8poQfqa6gnvYFXdcVnStWmI6U9LyiyN70jLlVgZPjGg
	 xHCAsIy73otNo/nxB+eU+KXagGV38tZDFbW6kd86lXp4EBQjtucy4aYKlpCreJLHBk
	 hAygUC8xXe0+rdgaM4ul47+/BT96wwAaC9rubmisESIxRk6JKPJj7Dqb5eBD7E3o39
	 5k7hBTXTzZTmb1cdAjEmaDx55apP3SnFB/4YI3hse3vkXmamA5gL0Msbulqvt87KLK
	 GW1XM8AAyGKe6G22lp1j9WYWHmL0TzlfO7I29Shk2BiwPPf7NkY6T9jcSIJ6Yr3eTA
	 i7e90lZp5pxow==
Date: Fri, 23 Feb 2024 09:21:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs: look at m_frextents in
 xfs_iomap_prealloc_size for RT allocations
Message-ID: <20240223172158.GU616564@frogsfrogsfrogs>
References: <20240223071506.3968029-1-hch@lst.de>
 <20240223071506.3968029-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223071506.3968029-9-hch@lst.de>

On Fri, Feb 23, 2024 at 08:15:04AM +0100, Christoph Hellwig wrote:
> Add a check for files on the RT subvolume and use m_frextents instead
> of m_fdblocks to adjust the preallocation size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iomap.c | 42 ++++++++++++++++++++++++++++++------------
>  1 file changed, 30 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 18c8f168b1532d..e6abe56d1f1f23 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -27,6 +27,7 @@
>  #include "xfs_dquot_item.h"
>  #include "xfs_dquot.h"
>  #include "xfs_reflink.h"
> +#include "xfs_rtbitmap.h"
>  
>  #define XFS_ALLOC_ALIGN(mp, off) \
>  	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
> @@ -398,6 +399,29 @@ xfs_quota_calc_throttle(
>  	}
>  }
>  
> +static int64_t
> +xfs_iomap_freesp(
> +	struct percpu_counter	*counter,
> +	uint64_t		low_space[XFS_LOWSP_MAX],
> +	int			*shift)
> +{
> +	int64_t			freesp;
> +
> +	freesp = percpu_counter_read_positive(counter);
> +	if (freesp < low_space[XFS_LOWSP_5_PCNT]) {
> +		*shift = 2;
> +		if (freesp < low_space[XFS_LOWSP_4_PCNT])
> +			(*shift)++;
> +		if (freesp < low_space[XFS_LOWSP_3_PCNT])
> +			(*shift)++;
> +		if (freesp < low_space[XFS_LOWSP_2_PCNT])
> +			(*shift)++;
> +		if (freesp < low_space[XFS_LOWSP_1_PCNT])
> +			(*shift)++;
> +	}
> +	return freesp;
> +}
> +
>  /*
>   * If we don't have a user specified preallocation size, dynamically increase
>   * the preallocation size as the size of the file grows.  Cap the maximum size
> @@ -480,18 +504,12 @@ xfs_iomap_prealloc_size(
>  	alloc_blocks = XFS_FILEOFF_MIN(roundup_pow_of_two(XFS_MAX_BMBT_EXTLEN),
>  				       alloc_blocks);
>  
> -	freesp = percpu_counter_read_positive(&mp->m_fdblocks);
> -	if (freesp < mp->m_low_space[XFS_LOWSP_5_PCNT]) {
> -		shift = 2;
> -		if (freesp < mp->m_low_space[XFS_LOWSP_4_PCNT])
> -			shift++;
> -		if (freesp < mp->m_low_space[XFS_LOWSP_3_PCNT])
> -			shift++;
> -		if (freesp < mp->m_low_space[XFS_LOWSP_2_PCNT])
> -			shift++;
> -		if (freesp < mp->m_low_space[XFS_LOWSP_1_PCNT])
> -			shift++;
> -	}
> +	if (unlikely(XFS_IS_REALTIME_INODE(ip)))
> +		freesp = xfs_rtx_to_rtb(mp, xfs_iomap_freesp(&mp->m_frextents,
> +				mp->m_low_rtexts, &shift));
> +	else
> +		freesp = xfs_iomap_freesp(&mp->m_fdblocks, mp->m_low_space,
> +				&shift);
>  
>  	/*
>  	 * Check each quota to cap the prealloc size, provide a shift value to
> -- 
> 2.39.2
> 
> 
