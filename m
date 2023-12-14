Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515C254279
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 20:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SrVu3vLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7388EC433C7;
	Thu, 14 Dec 2023 20:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702586761;
	bh=aGFaVjVduuL/LJ0MD7D1gywPD42bbHg/19opFsBNdjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SrVu3vLJQ/5Wnhhfa0YOXVScPB807738xfqj0631Vcwzrll/nUZvEwHPBF0MUx+ug
	 WSz9zYBUhPhW9jKyPmjnfBdqH1Atf8kaUVzxFhh8jUS/r2SovKDEtHJSCGigtaQbsp
	 OleWyZhbv1TyAiyIVE53siX3+xEjjtTeZkfVav2AK0HPFteFCA3aULeW6MoTn7CE72
	 YbiozuCKSu1r9enWKYqXqyNlIxSsGzZrJcLFYaB/DWWlQqDzs2XH41j2nL2qU1S1An
	 TE1k4QYuORFIUjbMS4Do+Vxnzhz/PYWcMWaLPvAljEtFPrw121z1uo+wo1JCEMr32q
	 PamahPvSGB0IA==
Date: Thu, 14 Dec 2023 12:46:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/19] xfs: remove the xfs_alloc_arg argument to
 xfs_bmap_btalloc_accounting
Message-ID: <20231214204601.GR361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-4-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:22AM +0100, Christoph Hellwig wrote:
> xfs_bmap_btalloc_accounting only uses the len field from args, but that
> has just been propagated to ap->length field by the caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yep, nice streamlining...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index ca6614f4eac50a..afdfb3455d9ebe 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3265,8 +3265,7 @@ xfs_bmap_btalloc_select_lengths(
>  /* Update all inode and quota accounting for the allocation we just did. */
>  static void
>  xfs_bmap_btalloc_accounting(
> -	struct xfs_bmalloca	*ap,
> -	struct xfs_alloc_arg	*args)
> +	struct xfs_bmalloca	*ap)
>  {
>  	if (ap->flags & XFS_BMAPI_COWFORK) {
>  		/*
> @@ -3279,7 +3278,7 @@ xfs_bmap_btalloc_accounting(
>  		 * yet.
>  		 */
>  		if (ap->wasdel) {
> -			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)args->len);
> +			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
>  			return;
>  		}
>  
> @@ -3291,22 +3290,22 @@ xfs_bmap_btalloc_accounting(
>  		 * This essentially transfers the transaction quota reservation
>  		 * to that of a delalloc extent.
>  		 */
> -		ap->ip->i_delayed_blks += args->len;
> +		ap->ip->i_delayed_blks += ap->length;
>  		xfs_trans_mod_dquot_byino(ap->tp, ap->ip, XFS_TRANS_DQ_RES_BLKS,
> -				-(long)args->len);
> +				-(long)ap->length);
>  		return;
>  	}
>  
>  	/* data/attr fork only */
> -	ap->ip->i_nblocks += args->len;
> +	ap->ip->i_nblocks += ap->length;
>  	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
>  	if (ap->wasdel) {
> -		ap->ip->i_delayed_blks -= args->len;
> -		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)args->len);
> +		ap->ip->i_delayed_blks -= ap->length;
> +		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
>  	}
>  	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
>  		ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT : XFS_TRANS_DQ_BCOUNT,
> -		args->len);
> +		ap->length);
>  }
>  
>  static int
> @@ -3380,7 +3379,7 @@ xfs_bmap_process_allocated_extent(
>  		ap->offset = orig_offset;
>  	else if (ap->offset + ap->length < orig_offset + orig_length)
>  		ap->offset = orig_offset + orig_length - ap->length;
> -	xfs_bmap_btalloc_accounting(ap, args);
> +	xfs_bmap_btalloc_accounting(ap);
>  }
>  
>  #ifdef DEBUG
> -- 
> 2.39.2
> 
> 
