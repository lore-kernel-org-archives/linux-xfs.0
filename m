Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D041152170
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 16:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724256444; cv=none; b=j9YYZqBYwWQfs4jEPXEesvu0O7rS9G6kaZ9Zit0vmWGbvynG+978fnhGmGjC8tgsTLUJBu9ibLfEhqWv0l/IjqVwAHCVloid1HWGMMw+mRQP/PNhiwveDXYcJJV/BXS5NPMfQ6fFoEXx/X+wKhhGr+mmorgUkXC5cvVI1UpU3mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724256444; c=relaxed/simple;
	bh=fxQqJMm0KU5Y3kBZKrhjQ13ElqmFCoU6uq+1pY0mrrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q29pAlgqOUFgKmavYbrM8Dqu++OoSfx43gwZzLVIzL5Lw2UjZZTQXVN8IhMUC6p7PRI074dISxU+HnqmZ4A+E5RtIx7BB7ORfryf+jHIXlDUJzSCb4mSSpBWpndJICOYERUZN2ovsxgUrJ6aoH7uly3ppE/9wAHKc2kwOOS5qQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YE9xQSor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YE9xQSor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2678C4AF13;
	Wed, 21 Aug 2024 16:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724256444;
	bh=fxQqJMm0KU5Y3kBZKrhjQ13ElqmFCoU6uq+1pY0mrrw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YE9xQSor6jVcowLY8YkjJXm+qiW8cqwCJGpfXG30MooeUx1uGGi8y29N2F+MWGju5
	 acnghYZyCTopiqZwxXyXrs6M8EqAp/Hg/Vri2DYVSfY2lrVoKTEbBdyPz6Hdxfvfeh
	 m+HBS3QTHgytbmHyZQyU+kj17vrK6974mqIWGXXR1Q32CZ1sFS8ugrso3whpCtD2KO
	 6mtcF1w+XcRzFLShOXl+YOlICy7TyBpqnLCpPmrGGeaTV+fmQOeX56Ou48t/zmrUa9
	 80wVKHBgQCApRcNKOAHj6BkY31mDH8uIxcaWGgZ2ukWKI96I7h5eqaZyCvNFR/+5j3
	 jmnt5hxi7Cvtg==
Date: Wed, 21 Aug 2024 09:07:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: support lowmode allocations in
 xfs_bmap_exact_minlen_extent_alloc
Message-ID: <20240821160723.GA865349@frogsfrogsfrogs>
References: <20240820170517.528181-1-hch@lst.de>
 <20240820170517.528181-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820170517.528181-7-hch@lst.de>

On Tue, Aug 20, 2024 at 07:04:57PM +0200, Christoph Hellwig wrote:
> Currently the debug-only xfs_bmap_exact_minlen_extent_alloc allocation
> variant fails to drop into the lowmode last restor allocator, and

                                         last resort?

> thus can sometimes fail allocations for which the caller has a
> transaction block reservation.
> 
> Fix this by using xfs_bmap_btalloc_low_space to do the actual allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index b5eeaea164ee46..784dd5dda2a1a2 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3493,7 +3493,13 @@ xfs_bmap_exact_minlen_extent_alloc(
>  	 */
>  	ap->blkno = XFS_AGB_TO_FSB(ap->ip->i_mount, 0, 0);
>  
> -	return xfs_alloc_vextent_first_ag(args, ap->blkno);
> +	/*
> +	 * Use the low space allocator as it first does a "normal" AG iteration
> +	 * and then drops the reservation to minlen, which might be required to
> +	 * find an allocation for the transaction reservation when the file
> +	 * system is very full.

Isn't it already doing a minlen allocation?  Oh, that probably refers to
shrinking args->total, doesn't it.

If the answer to that is 'yes' then
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +	 */
> +	return xfs_bmap_btalloc_low_space(ap, args);
>  }
>  #else
>  
> -- 
> 2.43.0
> 
> 
