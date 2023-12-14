Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C012DF66
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 20:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5xElTm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA4DC433C7;
	Thu, 14 Dec 2023 20:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702587064;
	bh=+AYC274RFgXoF6TOgFsIInz8zzidM/A0PpdYlSA1AGQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i5xElTm/ti2YeBGjI60EJAaqPYRfEjCxfL+kEcrc5uvZZuYbsmK5YB5xCn6tPwkJb
	 QIthUj8fzm7+auqUtg/O6PILkXOn++YS7DHBDbbx+yPmr8pusV12SG+oIRBIGntvAm
	 UX/F0ZUFSZjBAhxzb57liFKsC5JdAUd01KUMKbDzI/68NW7cEAX2HanmDIor5yfuaZ
	 +/bS22Ji4cJBrc988g3TD7479k9QFHr9ucuCNYugY6404HYeS6JVMu1QN4bWdIHnxr
	 FBTjhxM/IMd1Vgr0YYZ/IsNIljFUSwzT2HUB7el1uJmyBdmn6DstBcPeglCln4p/+S
	 sxp9yFFjscQ4Q==
Date: Thu, 14 Dec 2023 12:51:03 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/19] xfs: reflow the tail end of xfs_bmap_rtalloc
Message-ID: <20231214205103.GV361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-8-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:26AM +0100, Christoph Hellwig wrote:
> Reorder the tail end of xfs_bmap_rtalloc so that the successfully
> allocation is in the main path, and the error handling is on a branch.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok to me
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 60 ++++++++++++++++++++++----------------------
>  1 file changed, 30 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index dac148d53af3ec..158a631379378e 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1479,39 +1479,39 @@ xfs_bmap_rtalloc(
>  	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
>  	error = xfs_rtallocate_extent(ap->tp, rtx, raminlen, ralen, &ralen,
>  			ap->wasdel, prod, &rtx);
> -	if (!error) {
> -		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
> -		ap->length = xfs_rtxlen_to_extlen(mp, ralen);
> -		xfs_bmap_alloc_account(ap);
> -		return 0;
> -	}
> -
> -	if (error != -ENOSPC)
> -		return error;
> +	if (error == -ENOSPC) {
> +		if (align > mp->m_sb.sb_rextsize) {
> +			/*
> +			 * We previously enlarged the request length to try to
> +			 * satisfy an extent size hint.  The allocator didn't
> +			 * return anything, so reset the parameters to the
> +			 * original values and try again without alignment
> +			 * criteria.
> +			 */
> +			ap->offset = orig_offset;
> +			ap->length = orig_length;
> +			minlen = align = mp->m_sb.sb_rextsize;
> +			goto retry;
> +		}
>  
> -	if (align > mp->m_sb.sb_rextsize) {
> -		/*
> -		 * We previously enlarged the request length to try to satisfy
> -		 * an extent size hint.  The allocator didn't return anything,
> -		 * so reset the parameters to the original values and try again
> -		 * without alignment criteria.
> -		 */
> -		ap->offset = orig_offset;
> -		ap->length = orig_length;
> -		minlen = align = mp->m_sb.sb_rextsize;
> -		goto retry;
> -	}
> +		if (!ignore_locality && ap->blkno != 0) {
> +			/*
> +			 * If we can't allocate near a specific rt extent, try
> +			 * again without locality criteria.
> +			 */
> +			ignore_locality = true;
> +			goto retry;
> +		}
>  
> -	if (!ignore_locality && ap->blkno != 0) {
> -		/*
> -		 * If we can't allocate near a specific rt extent, try again
> -		 * without locality criteria.
> -		 */
> -		ignore_locality = true;
> -		goto retry;
> +		ap->blkno = NULLFSBLOCK;
> +		ap->length = 0;
> +		return 0;
>  	}
> +	if (error)
> +		return error;
>  
> -	ap->blkno = NULLFSBLOCK;
> -	ap->length = 0;
> +	ap->blkno = xfs_rtx_to_rtb(mp, rtx);
> +	ap->length = xfs_rtxlen_to_extlen(mp, ralen);
> +	xfs_bmap_alloc_account(ap);
>  	return 0;
>  }
> -- 
> 2.39.2
> 
> 
